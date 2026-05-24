--------------------------------------------------------------------------------
-- ������������� ����
-- ты ебанутый? ты в какой кодировке это сохранил?
--------------------------------------------------------------------------------
Metrostroi.DefineSystem("81_760E_Electric")
TRAIN_SYSTEM.DontAccelerateSimulation = false
local function Clamp(val, min, max)
    return math.max(min, math.min(max, val))
end

local function Rand(a, b)
    return a + (b - a) * math.random()
end

local function sign(x)
    return x > 0 and 1 or x < 0 and -1 or 0
end

function TRAIN_SYSTEM:Initialize()
    -- HV
    self.Main750V = 0.0
    self.Aux750V = 0.0
    self.Power750V = 0.0

    -- LV outputs (V)
    -- Battery voltage. Always on when battery is not dead
    self.TrueBattery80V = 0.0
    -- Inter-wagon shared power supply voltage. On when any wagon has BS enabled
    self.Shared80V = 0.0
    -- PSN output voltage. On only when PSN is working and has HV
    self.Psn80V = 0.0
    -- Inter-wagon shared power supply voltage. On when any wagon has BS enabled with PSN working with good voltage output
    self.SharedPsn80V = 0.0
    -- Voltage for emergency lights, UPI, etc. On when either our BS is on or we have SharedPsn80V from any wagon
    self.Emer80V = 0.0
    -- Main LV power supply voltage. On when the BS is on.
    self.Supply80V = 0.0

    -- Backwards-compat
    self.Battery80V = 0.0

    -- LV good outputs (1/0)
    -- Voltage on battery good
    self.AKB = 0
    -- PSN works and outputs good voltage
    self.PSN = 0
    -- We have emergency power supply, either from us or any other wagon
    self.EmerSupply = 0
    -- 30KM1 and 30KM2 power supply good
    self.KM = 0

    -- Reserve PSN active
    self.ReservePsn = 0

    -- Total energy used by train
    self.ElectricEnergyUsed = 0 -- joules
    self.ElectricEnergyDissipated = 0 -- joules
    self.EnergyChange = 0
    --Wag wire outside power
    -- Need many iterations for engine simulation to converge
    self.SubIterations = 16

    self.Train:LoadSystem("Battery", "81_765_Battery")
    self.Train:LoadSystem("BV", "Relay", { bass = true })
    self.Train:LoadSystem("GV", "Relay", "GV_10ZH", { bass = true })

    for idx = 1, 4 do
        -- UKKZ per-pant
        self.Train:LoadSystem("UKKZ" .. idx, "Relay", "Switch", { normally_closed = true })
        -- short circuit in pant
        self.Train:LoadSystem("PantShort" .. idx, "Relay", "Switch")
    end
    -- short circuit in inverter / engine
    self.Train:LoadSystem("AsyncShort", "Relay", "Switch")
    -- master UKKZ
    self.Train:LoadSystem("UKKZ", "Relay", "Switch")

    -- __RANDOMSEED_MARGIN = (__RANDOMSEED_MARGIN or 0) + 1
    -- math.randomseed(os.time() + __RANDOMSEED_MARGIN)

    -- Relay coils 30KM1 and 30KM2. Basically a 'BS on' flag.
    self.Train:LoadSystem("W30KM", "Relay", { close_time = Rand(0.05, 0.1), open_time = 0.1, bass = true })
    -- Relay coil 30K11. BS Enabling with self-lock circuit
    self.Train:LoadSystem("W30K11", "Relay", { close_time = Rand(0.05, 0.4), open_time = 0.1 })
    -- Relay coil 30K12. BS Disabling time relay.
    self.Train:LoadSystem("W30K12", "Relay")

    -- Wagon power buttons
    self.Train:LoadSystem("PowerOn", "Relay", "Switch", {bass = true})
    self.Train:LoadSystem("PowerOff", "Relay", "Switch", {bass = true})

    self.BTB = 0
    self.Brake = 0
    self.Drive = 0
    self.BTO = 0
    self.Recurperation = 0
    self.Iexit = 0
    self.Itotal = 0
    self.Chopper = 0
    self.ChopperTimeout = 0
    self.MK = 0
    self.V2 = 0
    self.V1 = 0
    self.SD = 0
    self.Slope = 0
    self.command = 0
    self.commandTimer = 0
    self.EmerXod = 0
    self.UPIPower = 0
    self.PowerReserve = 0
    self.ZeroSpeed = 0
    self.DoorsControl = 0
end

function TRAIN_SYSTEM:Inputs()
    return {"EnergyChange", "Power", "Slope"}
end

function TRAIN_SYSTEM:Outputs()
    return {
        "TrueBattery80V", "Shared80V", "Psn80V", "SharedPsn80V", "Emer80V", "Supply80V",
        "AKB", "PSN", "EmerSupply", "KM", "Battery80V", "ReservePsn",
        "Brake", "Drive", "V2", "V1", "Main750V", "Power750V", "Aux750V", "BTB", "MK",
        "SD", "EmerXod", "UPIPower", "PowerReserve", "Recurperation", "Iexit", "Itotal", "Chopper", "ElectricEnergyUsed",
        "ElectricEnergyDissipated", "EnergyChange", "BTO", "ZeroSpeed", "DoorsControl",
    }
end


local function _lerp(t, from, to)
    return from + (to - from) * t
end

local function GetCurrent(command)
    if math.abs(command) < 1 then
        return 0, 0
    elseif command > 0 then
        return _lerp((command - 1) / 3, 150, 320), _lerp((command - 1) / 3, 0.67, 0.79)
    else
        return _lerp((-command - 1) / 2, 150, 320), _lerp((-command - 1) / 2, 0.55, 0.85)
    end
end

function TRAIN_SYSTEM:TriggerInput(name, value)
    if name == "Power" and value then
        self.ForcePoweron = CurTime() + 5
    end

    if name == "Slope" then self.Slope = value end
end

local S = {}

local function C(x)
    return x and 1 or 0
end

local function N(x)
    return 1 - x
end

local function Nw(x)
    return N(x.Value)
end

function TRAIN_SYSTEM:LV(x)
    if not self.LvDeath then self.LvDeath = Rand(49.5, 50.4) end
    return C(x > self.LvDeath)
end

local min, max, abs = math.min, math.max, math.abs
--------------------------------------------------------------------------------
function TRAIN_SYSTEM:Think(dT, iter)
    local Wag = self.Train
    local Async = Wag.AsyncInverter
    local Panel = Wag.Panel
    local BUV = Wag.BUV
    local RV = Wag.RV


    ----------------------------------------------------------------------------
    -- HV dynamic
    ----------------------------------------------------------------------------
    local dU = Wag.TR.Main750V - self.Main750V
    if Wag.TR.Main750V < 550 and self.Main750V >= 550 then
        if not self.Main750VTimer then self.Main750VTimer = CurTime() + Rand(0.4, 0.8) end
        dU = 0
        if CurTime() - self.Main750VTimer > 0 then
            self.Main750V = math.max(530, Wag.TR.Main750V)
            self.Main750VTimer = nil
        end
    end

    self.Main750V = self.Main750V + dU * dT / ((dU < 0 and self.Main750V < 530 and 0.016 or 0.0014) * 1100)
    self.Aux750V = self.Main750V
    self.Power750V = self.Main750V * Wag.GV.Value

    S.HV = C(550 <= self.Main750V and self.Main750V <= 975)


    ----------------------------------------------------------------------------
    -- Solve LV circuit
    ----------------------------------------------------------------------------
    if not self.PsnRand then
        self.PsnRand = Rand(81.0, 82.9)
    end

    S.dU = Wag.Battery.Voltage - self.TrueBattery80V
    S.Uakb = self.TrueBattery80V + max(1, abs(S.dU)) * sign(S.dU) * dT * 4
    if (Wag.Battery.Voltage - S.Uakb) * S.dU < 0 then S.Uakb = Wag.Battery.Voltage end

    self.TrueBattery80V = S.Uakb

    self.PsnRand = self.PsnRand + (Rand(Rand(78, 80.5), Rand(83.4, 85.0)) - self.PsnRand) * dT
    S.Ucharge = BUV.PSN * self.PsnRand
    self.Psn80V = Wag.W30KM.Value * S.Ucharge

    Wag:WriteTrainWire(55, self.Psn80V)
    self.SharedPsn80V = Wag:ReadTrainWire(55) / max(1, Wag:ReadTrainWire(53))

    self.Supply80V = Wag.W30KM.Value * self.TrueBattery80V
    self.Emer80V = max(self.Supply80V, self.SharedPsn80V)

    self.Battery80V = self.Emer80V + 2.0  -- Legacy backport

    Wag:WriteTrainWire(56, self.Supply80V)
    self.Shared80V = Wag:ReadTrainWire(56) / max(1, Wag:ReadTrainWire(54))

    self.AKB = self:LV(self.TrueBattery80V)
    self.KM = self:LV(self.Supply80V)
    self.PSN = self:LV(self.Psn80V)
    self.EmerSupply = self:LV(self.Emer80V)

    Wag:WriteTrainWire(53, self.PSN)
    Wag:WriteTrainWire(54, Wag.W30KM.Value)

    if self.ForcePoweron then
        S.ForcePoweron = 1
        if CurTime() >= self.ForcePoweron then self.ForcePoweron = nil end
    else
        S.ForcePoweron = 0
    end

    S.HasControlVoltage = C(self.TrueBattery80V > 50.8)
    S.BsControlPower = Wag.SF30F2.Value * S.HasControlVoltage
    S.BsControl = S.BsControlPower * Nw(Wag.W30K12) * Nw(Wag.PowerOff) * Wag.W30K11.Value
    Wag.W30K11:TriggerInput("Set", min(1, S.BsControl + Wag:ReadTrainWire(72) + S.BsControlPower * Wag.PowerOn.Value + S.ForcePoweron))

    if Wag:ReadTrainWire(73) > 0 and not self.W30K12Timer then
        self.W30K12Timer = CurTime() + Rand(2, 2.4)
    elseif Wag:ReadTrainWire(73) < 1 and self.W30K12Timer then
        self.W30K12Timer = nil
    end
    Wag.W30K12:TriggerInput("Set", self.W30K12Timer and CurTime() >= self.W30K12Timer and 1 or 0)

    Wag.W30KM:TriggerInput("Set", S.BsControl)
    Wag:WriteTrainWire(74, Wag.W30K11.Value)
    Wag:WriteTrainWire(75, 1 - Wag.W30K11.Value)

    self.ReservePsn = Wag:ReadTrainWire(42) * S.HasControlVoltage

    Wag.Battery:TriggerInput("Charge", S.Ucharge)
    S.Load = Wag.BUV.Load + 220 * max(0.1, Wag.W30KM.Value)

    self.BTO = self.EmerSupply * Wag.SF22F1.Value


    ----------------------------------------------------------------------------
    -- Solve internal electric
    ----------------------------------------------------------------------------
    if RV then
        local BUP = Wag.BUKP
        S.Load = S.Load + BUP.Load

        S.SharedLv = self:LV(self.Shared80V)
        S.BsControl = min(1, self.AKB + S.SharedLv) * Wag.SF30F1.Value
        Wag:WriteTrainWire(72, S.BsControl * Wag.MasterTrainPowerOn.Value)
        Wag:WriteTrainWire(73, S.BsControl * Wag.MasterTrainPowerOff.Value * Wag.W30K8.Value)
        S.BatteryChargeBtn = min(1, C(self.TrueBattery80V > 22) + S.SharedLv) * Wag.SF30F1.Value * Wag.BatteryCharge.Value
        Wag:WriteTrainWire(42, S.BatteryChargeBtn)

        S.ActiveCabin = self.EmerSupply * min(1, RV["KRO13-14"] * Wag.SF23F2.Value --[[* Wag.SF23F13.Value]] + RV["KRR11-12"] * Wag.SF23F1.Value)
        S.OrientFwd = S.ActiveCabin * Wag.SF23F13.Value * (1 - RV["KRO7-8"])

        S.PpzKm = BUP.BtbuSd > 0 and Wag.SF22F4.Value or Wag.SF22F2.Value
        S.PpzBtbu = Wag.SF22F2.Value

        self.UPIPower = S.SharedLv * Wag.SF23F8.Value
        self.PowerReserve = self.EmerSupply * min(1, (1 - Wag.SF23F8.Value) * abs(RV.KRRPosition) + Wag.SF23F8.Value)
        Wag:WriteTrainWire(20, self.EmerSupply)
        Wag:WriteTrainWire(36, Wag.SF23F1.Value * Wag.EmergencyControls.Value)
        S.Drive = Wag.BARS.Drive * min(Wag.BARS.UOS + (1 - Wag.BARS.Brake) * (BUP.DoorClosed + Wag.DoorBlock.Value), 1)
        S.Orientation = C(Wag.SF23F13.Value * BUP.Active + RV["KRR7-8"] > 0)
        Wag:WriteTrainWire(19, self.PowerReserve * (1 - Wag.SD3.Value) * RV["KRR7-8"] * S.Drive * Wag.EmerX1.Value)
        Wag:WriteTrainWire(45, self.PowerReserve * (1 - Wag.SD3.Value) * RV["KRR7-8"] * S.Drive * Wag.EmerX2.Value)
        self.EmerXod = self.PowerReserve * RV["KRR7-8"] * S.Drive * min(1, Wag.EmerX1.Value + Wag.EmerX2.Value)
        S.RV = self.EmerSupply * (BUP.InitTimer and BUP.InitTimer > 0 and 1 or RV["KRO9-10"] + RV["KRR7-8"] * Wag.SF23F1.Value)
        Wag:WriteTrainWire(3, S.RV * S.Orientation)
        Wag:WriteTrainWire(4, 0)
        Wag:WriteTrainWire(5, self.EmerSupply * RV["KRR7-8"] * S.Orientation)
        Wag:WriteTrainWire(6, self.EmerSupply * RV["KRO1-2"] * S.Orientation)
        S.KM1 = self.EmerSupply * RV["KRO11-12"]
        S.KM2 = self.EmerSupply * RV["KRO15-16"]
        Wag:WriteTrainWire(12, self.EmerSupply * (RV["KRR3-4"] * Wag.SF23F1.Value + S.KM1))
        Wag:WriteTrainWire(13, self.EmerSupply * (RV["KRR9-10"] + S.KM2))
        Wag:WriteTrainWire(14, self.EmerSupply * RV["KRR3-4"] * S.Orientation * Wag.SF23F1.Value)
        Wag:WriteTrainWire(15, self.EmerSupply * RV["KRR9-10"] * S.Orientation * Wag.SF23F1.Value)
        S.BTB = self.EmerSupply * S.ActiveCabin * S.PpzBtbu
        S.SDval = --[[RV["KRR7-8"] > 0 and Wag.SD3.Value or]] Wag.SD2.Value
        if self.EmerSupply * Wag.SD.Value > 0 then
            if S.RV ~= self.rv then
                self.rv = S.RV
                if self.rv ~= 0 then self.SDActive = true end
            end

            self.SD = C(S.RV > 0 and (self.SDActive or S.SDval == 0))
        else
            self.SD = 0
            self.SDActive = false
        end

        S.BTBp = S.BTB * min(1, 1 - S.SDval + self.SD)
        self.V2 = self.EmerSupply * min(1, RV["KRO1-2"] * S.PpzKm * Wag.SF23F2.Value + RV["KRR1-2"] * S.PpzKm)
        self.V1 = self.UPIPower * Wag.SF70F3.Value * min(1, Wag.HornB.Value + Wag.HornC.Value)
        Wag:WriteTrainWire(27, S.BTB)
        Wag:WriteTrainWire(11, S.BTB * Wag.PmvParkingBrake.Value * Wag.SF22F3.Value * BUP.Active)
        Wag:WriteTrainWire(31, S.BTB * (1 - Wag.PmvParkingBrake.Value) * Wag.SF22F3.Value * BUP.Active)
        Wag:WriteTrainWire(28, S.BTB * Wag.EmerBrake.Value)
        Wag:WriteTrainWire(29, S.BTB * Wag.EmerBrake.Value * Wag.EmerBrakeAdd.Value)
        Wag:WriteTrainWire(30, S.BTB * Wag.EmerBrake.Value * Wag.EmerBrakeRelease.Value)
        Wag:WriteTrainWire(24, S.BTBp * (1 - Wag:ReadTrainWire(41)))
        Wag:WriteTrainWire(25, S.BTBp == 0 and Wag:ReadTrainWire(26) > 0 and Wag:ReadTrainWire(24) * self.BTB or 0)
        Wag:WriteTrainWire(26, S.BTBp * Wag.BARS.BTB * (1 - BUP.ESD * (1 - Wag.ABESD.Value)) * (1 - BUP.EmergencyBrake))
        Wag:WriteTrainWire(41, Wag.EmergencyBrake.Value)

        if Wag:ReadTrainWire(26) > 0 and Wag:ReadTrainWire(24) == 0 then
            self.BTB = 0
        elseif Wag:ReadTrainWire(26) == 0 then
            self.BTB = 1
        end

        S.ManualZeroSpeed = C(Wag.PmvAtsBlock.Value == 3) * Wag.PmvParkingBrake.Value
        self.ZeroSpeed = S.RV * min(1, BUP.BudZeroSpeed * BUP.Active * Wag.SF80F5.Value + S.ManualZeroSpeed)
        self.DoorsControl = self.ZeroSpeed * min(1, S.RV * Wag.SF80F5.Value * C(BUP.State == 5) * Wag.SF23F2.Value + Wag.EmergencyDoors.Value)

        Wag:WriteTrainWire(10, self.KM * min(1, Wag.EmergencyCompressor.Value + Wag.EmergencyCompressor2.Value))
        S.EmergencyDoorsAllowOpen = self.DoorsControl * Wag.EmergencyDoors.Value
        S.DoorClose = min(1, self.UPIPower * Wag.SF23F2.Value + self.DoorsControl) * Wag.SF80F5.Value * Wag.SF80F1.Value * S.RV * BUP.Active * Wag.DoorClose.Value
        Wag:WriteTrainWire(40, Wag.EmergencyDoors.Value)
        Wag:WriteTrainWire(39, S.DoorClose)
        Wag:WriteTrainWire(38, S.EmergencyDoorsAllowOpen * self.ZeroSpeed * Wag.DoorLeft.Value * Wag.DoorSelectL.Value * (1 - Wag.DoorSelectR.Value))
        Wag:WriteTrainWire(37, S.EmergencyDoorsAllowOpen * self.ZeroSpeed * Wag.DoorRight.Value * Wag.DoorSelectR.Value * (1 - Wag.DoorSelectL.Value))

        Wag:WriteTrainWire(82, min(1, BUP.BupActive + S.RV * S.ManualZeroSpeed))
        Wag:WriteTrainWire(83, min(1, BUP.BupActive * self.ZeroSpeed + S.RV * S.ManualZeroSpeed))

        S.EmerBattPower = Wag.PmvEmerPower.Value * self.AKB
        Wag.ASNP_VV.Power = self.EmerSupply * Wag.SF42F1.Value * Wag.R_ASNPOn.Value

        Panel.CabLight = min(1, self.EmerSupply + S.EmerBattPower) * Wag.SF52F1.Value * min(1 + self.KM, Wag.CabinLight.Value)
        Panel.PanelLights = min(1, self.EmerSupply + S.EmerBattPower) * Wag.SF52F1.Value
        Panel.HeadlightsFull = min(1, self.UPIPower * S.OrientFwd * Wag.SF51F1.Value * RV["KRO11-12"] * max(0, Wag.HeadlightsSwitch.Value - 1) + RV["KRR3-4"] * self.KM)
        Panel.HeadlightsHalf = min(1, self.UPIPower * S.OrientFwd * Wag.SF51F1.Value * RV["KRO11-12"] * Wag.HeadlightsSwitch.Value + RV["KRR3-4"] * self.KM)
        Panel.RedLights = min(1, Wag.SF51F2.Value * self.AKB + (1 - S.OrientFwd) * Wag.SF51F1.Value * self.KM + Wag.EmergencyControls.Value * self.KM)
        Panel.CabVent = self.KM * Wag.SF62F3.Value
        Panel.DoorLeftL = self.DoorsControl * Wag.DoorSelectL.Value * (1 - Wag.DoorSelectR.Value)
        Panel.DoorRightL = self.DoorsControl * Wag.DoorSelectR.Value * (1 - Wag.DoorSelectL.Value)
        Panel.DoorCloseL = S.DoorClose
        Panel.DoorBlockL = self.UPIPower * Wag.DoorBlock.Value
        Panel.EmerBrakeL = self.PowerReserve * C(Wag.Pneumatic.EmerBrakeWork == 1 or Wag.Pneumatic.EmerBrakeWork == true) * S.BTB
        Panel.EmerXodL = self.PowerReserve * abs(RV.KRRPosition) * (1 - Wag.SD3.Value) * Wag.BARS.Drive * (1 - BUP.BupDisableDrive)
        Panel.KAHl = self.UPIPower * Wag.KAH.Value
        Panel.ALSl = self.UPIPower * Wag.ALS.Value
        Panel.PRl = self.UPIPower * Wag.Pr.Value * Wag.SF70F3.Value
        Panel.OtklRl = self.UPIPower * Wag.OtklR.Value * Wag.SF70F3.Value
        Panel.Washerl = self.PowerReserve * Wag.Washer.Value * Wag.SF70F3.Value
        Panel.Wiperl = self.PowerReserve * Wag.Wiper.Value * Wag.SF70F3.Value
        Panel.WiperPower = self.PowerReserve * Wag.SF70F3.Value
        Panel.EmergencyControlsl = self.UPIPower * Wag.EmergencyControls.Value
        Panel.EmergencyDoorsl = self.UPIPower * Wag.EmergencyDoors.Value
        Panel.GlassHeatingl = self.PowerReserve * Wag.SF70F2.Value * Wag.GlassHeating.Value
        Panel.PowerOnl = S.BsControl * Wag:ReadTrainWire(74)
        Panel.PowerOffl = S.BsControl * Wag:ReadTrainWire(75) * Wag:ReadTrainWire(74)
        Panel.BatteryChargel = S.BatteryChargeBtn
        Panel.LV = self.Shared80V * self.EmerSupply * Wag.SF42F2.Value

        S.Load = S.Load + (
            (Panel.CabLight < 1 and 0 or Panel.CabLight < 2 and 14 or 32)
            + Panel.HeadlightsFull * 100
            + Panel.HeadlightsHalf * 75
            + math.min(1, Panel.HeadlightsHalf + Panel.RedLights + Panel.HeadlightsFull) * 34
            + Panel.CabVent * 1600
            + Panel.Wiperl * 15
            + Panel.Washerl * 7.5
        )
    else
        Panel.LV = self.KM * self.TrueBattery80V
    end

    Wag.SF54:TriggerInput("Set", Wag.SF45F5.Value * Wag.SF45F6.Value)

    Panel.WorkFan = self.KM * Wag.GV.Value * S.HV
    Panel.SalonLighting1 = self.EmerSupply * Wag.SF52F3.Value
    Panel.SalonLighting2 = self.KM * Wag.SF52F2.Value * BUV.MainLights

    local ukkz = 1
    local kzx, pkz, val, short, timerId
    local hvInput = Wag.TR.Main750V >= 550
    for idx = 1, 4 do
        kzx = Wag["UKKZ" .. idx]
        pkz = Wag["PantShort" .. idx]
        if kzx and pkz then
            val = kzx.Value
            short = kzx.Value == 1 and (pkz.Value + Wag.AsyncShort.Value) > 0
            timerId = "UkkzTimer" .. idx
            if val < 1 and not (short or hvInput) then
                if not self[timerId] then
                    self[timerId] = CurTime() + 10
                elseif self[timerId] < CurTime() then
                    kzx:TriggerInput("Close", 1)
                    self[timerId] = nil
                end
            elseif hvInput and short then
                kzx:TriggerInput("Open", 1)
                val = 0
            elseif self[timerId] then
                self[timerId] = nil
            end
            ukkz = ukkz * val
        end
    end
    Wag.UKKZ:TriggerInput("Set", ukkz)
    if ukkz < 1 and Wag.BV.Value > 0 then
        if not self.BvSoundTimer then
            Wag:PlayOnce("bv_off", "", 1, 1)
            self.BvSoundTimer = CurTime() + 1
        end
        Wag.BV:TriggerInput("Open", 1)
    end
    if self.BvSoundTimer and self.BvSoundTimer < CurTime() then
        self.BvSoundTimer = nil
    end

    S.Load = S.Load + (
        Panel.SalonLighting1 * 180
        + Panel.SalonLighting2 * 560
        + Panel.WorkFan * 310
    )
    Wag.Battery:TriggerInput("Load", S.Load)
    Wag.Battery:TriggerInput("SetInfinite", 1 - Wag.W30KM.Value)

    if not Async then return end

    self.MK = self.PSN * S.HV * self.KM * Wag.SF30F3.Value * (BUV.MK > 0 and 1 or Wag:ReadTrainWire(10))
    local command = BUV.Strength or 0
    local speed = Async.Speed
    if self.command ~= command and CurTime() - self.commandTimer > (0.3 + (command ~= 0 and speed > 2 and sign(command) ~= sign(self.command) and 0.6 or 0)) then
        self.commandTimer = CurTime()
        self.command = command
    end

    Async:TriggerInput("Power", self.KM * (Wag.SF23F4 and Wag.SF23F4.Value or 1) * Wag.GV.Value * Wag.BV.Value)
    if self.command > 0 then
        Async:TriggerInput("Drive", self.command)
        Async:TriggerInput("Brake", 0)
    elseif self.command < 0 then
        Async:TriggerInput("Drive", 0)
        Async:TriggerInput("Brake", abs(self.command))
    else
        Async:TriggerInput("Drive", 0)
        Async:TriggerInput("Brake", 0)
    end

    local targetI, k = GetCurrent(self.command)
    if self.command > 0 then
        Async:TriggerInput("TargetCurrent", targetI * (1 + (self.Slope == 1 and 0.1 or Wag.Pneumatic.WeightLoadRatio * 0.1)) * ((1 - k) + k * Clamp((speed - 3) / 16, 0, 1))) --*(0.22+0.78*Clamp((speed-3)/14,0,1)))--*(speed > 50 and 1-(speed-50)/150 or 1) )--*(speed < 20 and 0.23+Clamp(speed/22,0,1)*0.77 or 1))--330
    elseif self.command < 0 then
        Async:TriggerInput("TargetCurrent", targetI * (1 + (self.Slope == 1 and 0.1 or Wag.Pneumatic.WeightLoadRatio * 0.1)) * ((1 - k) + k * Clamp((speed - 3) / 22, 0, 1))) --*Clamp((speed-2)/18,0,1))--*(Clamp(speed/30,0,1)+(speed < 10 and 0.035 or 0) ))--330
    else
        Async:TriggerInput("TargetCurrent", 0)
    end

    self.EnergyChange = Async.Mode > 0 and (Async.Current ^ 2) * 2.2 or 0
    self.Itotal = Async.Current

    if Async.Mode < 0 and Async.State > 0 then
        self.Recurperation = C(self.Main750V > 749 and self.Main750V < 921) * BUV.Recurperation
        self.Iexit = self.Iexit + (-Async.Current * 2 * self.Recurperation - self.Iexit) * dT * 2

        S.ChopperWork = (self.Main750V >= 921 or self.Main750V < 550) and 1 or 0
        S.ChopperWork = S.ChopperWork + (1 - self.Recurperation)
        if S.ChopperWork > 0 and CurTime() >= self.ChopperTimeout then self.ChopperTimeout = CurTime() + Rand(1, 5) end
        self.Chopper = (S.ChopperWork > 0 or CurTime() < self.ChopperTimeout) and 1 or 0
    else
        self.Recurperation = 0
        self.Iexit = 0
        self.Chopper = 0
    end

    self.ElectricEnergyUsed = self.ElectricEnergyUsed + max(0, self.EnergyChange) * dT
    self.ElectricEnergyDissipated = self.ElectricEnergyDissipated + max(0, self.Iexit ^ 2) * 2.2 * dT

end
