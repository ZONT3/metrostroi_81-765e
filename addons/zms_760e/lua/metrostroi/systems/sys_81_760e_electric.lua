--------------------------------------------------------------------------------
-- ������������� ����
-- ты ебанутый? ты в какой кодировке это сохранил?
-- Оригинальный код - Cricket & Hell (для 760), Metrostroi team (для 720, 722 и др.)
-- Переработка - ZONT_ a.k.a. enabled person
-- Реализованы УККЗ и логика БС 81-765
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
    -- General power output
    self.Main750V = 0.0
    self.Aux750V = 0.0
    self.Power750V = 0.0
    self.Aux80V = 0.0
    self.Lights80V = 0.0
    self.Battery80V = 0.0
    -- Total energy used by train
    self.ElectricEnergyUsed = 0 -- joules
    self.ElectricEnergyDissipated = 0 -- joules
    self.EnergyChange = 0
    --Train wire outside power
    -- Need many iterations for engine simulation to converge
    self.SubIterations = 16
    -- ������� �����������
    self.Train:LoadSystem("BV", "Relay")
    self.Train:LoadSystem("GV", "Relay", "GV_10ZH", {
        bass = true
    })

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

    self.BTB = 0
    self.Brake = 0
    self.Drive = 0
    self.BTO = 0
    self.Recurperation = 0
    self.Iexit = 0
    self.Chopper = 0
    self.ChopperTimeout = 0
    self.MK = 0
    self.V2 = 0
    self.V1 = 0
    self.SD = 0
    self.KM2 = 0
    self.Slope = 0
    self.command = 0
    self.commandTimer = 0
    self.EmerXod = 0
    self.UPIPower = 0
    self.Power = nil
    self.BSPowered = 0
    self.PowerReserve = 0
    self.ZeroSpeed = 0
    self.DoorsControl = 0
end

function TRAIN_SYSTEM:Inputs()
    return {"EnergyChange", "PowerTimer", "Slope"}
end

function TRAIN_SYSTEM:Outputs()
    return {
        "Brake", "Drive", "V2", "V1", "Main750V", "Power750V", "Aux750V", "Aux80V", "Lights80V", "Battery80V", "BTB", "ABESDr", "MK", "Power",
        "SD", "KM2", "EmerXod", "BSPowered", "UPIPower", "PowerReserve", "Recurperation", "Iexit", "Itotal", "Chopper", "ElectricEnergyUsed",
        "ElectricEnergyDissipated", "EnergyChange", "BTO", "ZeroSpeed", "DoorsControl"
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

local min, max, abs = math.min, math.max, math.abs
--------------------------------------------------------------------------------
function TRAIN_SYSTEM:Think(dT, iter)
    local Train = self.Train
    local Async = Train.AsyncInverter
    local Panel = Train.Panel
    local BUV = Train.BUV
    local RV = Train.RV
    self.Battery80V = self.Power and self.Power > 1 and BUV.AKBVoltage or 0
    local PBatt = C(BUV.AKBVoltage >= 62)
    local P = C(self.Battery80V > 62)
    self.BSPowered = P
    local PowerPSN = C(self.Battery80V > 79)
    local HV = C(550 <= self.Main750V and self.Main750V <= 975)
    local BO = C(self.Battery80V > 67)
    ----------------------------------------------------------------------------
    -- Information only
    ----------------------------------------------------------------------------
    local PSN = BUV.PSN * BO > 0
    self.Aux80V = PSN and 80 or 69
    self.Lights80V = PSN and 80 or 0
    self.BTO = P * Train.Battery.Value * Train.SF22F1.Value * self.KM2
    ----------------------------------------------------------------------------
    -- Voltages from the third rail
    ----------------------------------------------------------------------------
    local dU = Train.TR.Main750V - self.Main750V
    if Train.TR.Main750V < 550 and self.Main750V >= 550 then
        if not self.Main750VTimer then self.Main750VTimer = CurTime() + Rand(0.4, 0.8) end
        dU = 0
        if CurTime() - self.Main750VTimer > 0 then
            self.Main750V = math.max(530, Train.TR.Main750V)
            self.Main750VTimer = nil
        end
    end

    self.Main750V = self.Main750V + dU * dT / ((dU < 0 and self.Main750V < 530 and 0.016 or 0.0014) * 1100)
    self.Aux750V = self.Main750V
    self.Power750V = self.Main750V * Train.GV.Value

    if self.ForcePoweron and CurTime() > self.ForcePoweron then
        self.ForcePoweron = nil
    end

    if not self.ForcePoweron then
        if RV then
            local bsOff = PBatt * Train.SF30F1.Value * Train.PowerOff.Value > 0.5
            if bsOff and not self.PowerOffCommandTimer then self.PowerOffCommandTimer = CurTime() + Rand(0.8, 1.6) end
            if not bsOff and self.PowerOffCommandTimer then self.PowerOffCommandTimer = nil self.BsOffPlayed = false end
            bsOff = bsOff and CurTime() > self.PowerOffCommandTimer
            if bsOff and not self.BsOffPlayed then Train:PlayOnce("battery_pneumo","bass",1) self.BsOffPlayed = true end
            Train:WriteTrainWire(72, PBatt * Train.SF30F1.Value * Train.PowerOn.Value)
            Train:WriteTrainWire(73, bsOff and 1 or 0)
        end

        local bsOff = not PBatt or Train:ReadTrainWire(73) > 0 or Train.SF30F2.Value < 1
        local bsOn = PBatt * Train.SF30F2.Value * (Train.PowerOn.Value + Train:ReadTrainWire(72)) > 0

        if BUV.AKBVoltage < 62 and self.Power then
            self.Power = nil
        elseif (self.Power or 0) > 0 and bsOff and not self.PowerOffTimer then
            self.PowerOffTimer = CurTime() + Rand(1.8, 2.1)
        elseif (self.Power or 0) < 1 and bsOn and not self.PowerTimer then
            self.PowerTimer = CurTime() + Rand(0.1, 0.3)
        end

        if self.PowerTimer and self.PowerOffTimer then self.PowerTimer = nil end

        if self.PowerTimer and CurTime() - self.PowerTimer > 0 then
            if not bsOn then
                self.Power = 0
                self.PowerTimer = nil
            else
                self.Power = (self.Power or 0) + 1
                if self.Power < 2 then
                    self.PowerTimer = CurTime() + Rand(2, 3)
                else
                    self.PowerTimer = nil
                end
                if self.Power then
                    if self.Power == 1 then
                        Train:PlayOnce("battery_pneumo","bass",1)
                    else
                        Train:PlayOnce("battery_on_1","bass",1)
                    end
                end
            end
        end

        if self.PowerOffTimer and CurTime() - self.PowerOffTimer > 0 then
            if self.Power > 1 and not bsOff then
                self.PowerOffTimer = nil
            else
                self.Power = (self.Power or 0) - 1
                if self.Power < 0 then
                    self.Power = nil
                    self.PowerOffTimer = nil
                elseif self.Power > 0 then
                    self.PowerOffTimer = CurTime() + Rand(1.2, 1.6)
                else
                    self.PowerOffTimer = nil
                end
                if self.Power then
                    if self.Power == 1 then
                        Train:PlayOnce("battery_off_1","bass",1)
                    else
                        Train:PlayOnce("battery_off_2","bass",1)
                    end
                end
            end
        end

        self.Power = (P == 0) and nil or self.Power
        Train:WriteTrainWire(75, P * math.max(0, (self.Power or 0) - 1))
        Train:WriteTrainWire(74, PBatt * (1 - math.max(0, (self.Power or 0) - 1)))

    else
        self.Power = 2
    end


    self.KM2 = self.Power and self.Power > 1 and 1 or 0
    ----------------------------------------------------------------------------
    -- Some internal electric
    ----------------------------------------------------------------------------
    if RV then
        local UPIPower = P * Train.SF23F8.Value
        self.UPIPower = UPIPower
        local PowerReserve = P * min(1, (1 - Train.SF23F8.Value) * abs(RV.KRRPosition) + Train.SF23F8.Value)
        self.PowerReserve = PowerReserve
        Train:WriteTrainWire(20, P)
        Train:WriteTrainWire(35, P * (RV["KRO1-2"] * Train.SF22F2.Value + RV["KRR1-2"] * Train.SF22F2.Value))
        Train:WriteTrainWire(36, Train.SF23F1.Value * Train.EmergencyControls.Value)
        local Drive = min(Train.BARS.UOS + Train.BARS.Drive * (Train.BUKP.DoorClosed + Train.DoorBlock.Value), 1)
        local Orientation = C(Train.SF23F13.Value * Train.BUKP.Active + RV["KRR7-8"] > 0)
        Train:WriteTrainWire(19, PowerReserve * (1 - Train.SD3.Value) * RV["KRR7-8"] * Drive * Train.EmerX1.Value)
        Train:WriteTrainWire(45, PowerReserve * (1 - Train.SD3.Value) * RV["KRR7-8"] * Drive * Train.EmerX2.Value)
        self.EmerXod = PowerReserve * RV["KRR7-8"] * Drive * min(1, Train.EmerX1.Value + Train.EmerX2.Value)
        S["RV"] = P * (Train.BUKP.InitTimer and Train.BUKP.InitTimer > 0 and 1 or RV["KRO9-10"] * Train.SF23F3.Value + RV["KRR7-8"] * Train.SF23F1.Value)
        Train:WriteTrainWire(3, S["RV"] * Orientation)
        Train:WriteTrainWire(4, 0)
        Train:WriteTrainWire(5, P * RV["KRR7-8"] * Orientation)
        Train:WriteTrainWire(6, P * RV["KRO1-2"] * Orientation)
        local KM1 = P * RV["KRO11-12"] * Train.SF23F3.Value
        local KM2 = P * RV["KRO15-16"]
        Train:WriteTrainWire(12, P * (RV["KRR3-4"] * Train.SF23F1.Value + KM1))
        Train:WriteTrainWire(13, P * (RV["KRR9-10"] + KM2))
        Train:WriteTrainWire(14, P * RV["KRR3-4"] * Orientation * Train.SF23F1.Value)
        Train:WriteTrainWire(15, P * RV["KRR9-10"] * Orientation * Train.SF23F1.Value)
        local BTB = P * (RV["KRO13-14"] * Train.SF23F3.Value * Train.SF22F2.Value + RV["KRR11-12"] * Train.SF23F1.Value * Train.SF22F2.Value)
        local SDval = --[[RV["KRR7-8"] > 0 and Train.SD3.Value or]] Train.SD2.Value
        if P * Train.SD.Value > 0 then
            if S["RV"] ~= self.rv then
                self.rv = S["RV"]
                if self.rv ~= 0 then self.SDActive = true end
            end

            self.SD = C(S["RV"] > 0 and (self.SDActive or SDval == 0))
        else
            self.SD = 0
            self.SDActive = false
        end

        local BTBp = BTB * min(1, 1 - SDval + self.SD)
        self.V2 = BTB
        self.V1 = UPIPower * Train.SF70F3.Value * min(1, Train.HornB.Value + Train.HornC.Value)
        Train:WriteTrainWire(27, BTB)
        Train:WriteTrainWire(11, BTB * Train.PmvParkingBrake.Value * Train.SF22F3.Value * Train.BUKP.Active)
        Train:WriteTrainWire(31, BTB * (1 - Train.PmvParkingBrake.Value) * Train.SF22F3.Value * Train.BUKP.Active)
        Train:WriteTrainWire(28, BTB * Train.EmerBrake.Value)
        Train:WriteTrainWire(29, BTB * Train.EmerBrake.Value * Train.EmerBrakeAdd.Value)
        Train:WriteTrainWire(30, BTB * Train.EmerBrake.Value * Train.EmerBrakeRelease.Value)
        Train:WriteTrainWire(24, BTBp * (1 - Train:ReadTrainWire(41)))
        Train:WriteTrainWire(25, BTBp == 0 and Train:ReadTrainWire(26) > 0 and Train:ReadTrainWire(24) * self.BTB or 0)
        Train:WriteTrainWire(26, BTBp * Train.BARS.BTB * (1 - Train.BUKP.ESD * (1 - Train.ABESD.Value)) * (1 - Train.BUKP.EmergencyBrake))
        Train:WriteTrainWire(41, Train.EmergencyBrake.Value)

        if Train:ReadTrainWire(26) > 0 and Train:ReadTrainWire(24) == 0 then
            self.BTB = 0
        elseif Train:ReadTrainWire(26) == 0 then
            self.BTB = 1
        end

        self.ZeroSpeed = S["RV"] * min(1, Train.BUKP.BudZeroSpeed * Train.BUKP.Active + C(Train.PmvAtsBlock.Value == 3) * Train.PmvParkingBrake.Value)
        self.DoorsControl = Train.SF80F5.Value * min(1, Train.BUKP.BudZeroSpeed * Train.BUKP.Active + Train.EmergencyDoors.Value)

        Train:WriteTrainWire(10, P * Train.Battery.Value * min(1, Train.EmergencyCompressor.Value + Train.EmergencyCompressor2.Value))
        local EmergencyDoors = self.DoorsControl * Train.EmergencyDoors.Value
        Train:WriteTrainWire(40, EmergencyDoors)
        Train:WriteTrainWire(39, EmergencyDoors * Train.EmerCloseDoors.Value)
        Train:WriteTrainWire(38, EmergencyDoors * self.ZeroSpeed * Train.DoorLeft.Value)
        Train:WriteTrainWire(37, EmergencyDoors * self.ZeroSpeed * Train.DoorRight.Value)

        Train:WriteTrainWire(42, P * Train.BatteryCharge.Value)

        local EmerBattPower = Train.PmvEmerPower.Value * PBatt
        local ASNP_VV = Train.ASNP_VV
        ASNP_VV.Power = P * Train.SF42F1.Value * Train.R_ASNPOn.Value
        Panel.CabLight = min(1, P + EmerBattPower) * Train.SF52F1.Value * min(2 - (1 - P) * EmerBattPower, Train.CabinLight.Value)
        Panel.PanelLights = min(1, P + EmerBattPower) * Train.SF52F1.Value
        Panel.HeadlightsFull = UPIPower * Train.SF51F1.Value * RV["KRO11-12"] * max(0, Train.HeadlightsSwitch.Value - 1) + Train.EmergencyControls.Value * P
        Panel.HeadlightsHalf = UPIPower * Train.SF51F1.Value * RV["KRO11-12"] * Train.HeadlightsSwitch.Value + Train.EmergencyControls.Value * P
        Panel.RedLights = min(1, Train.SF51F2.Value * PBatt + RV["KRO7-8"] * Train.SF51F1.Value * P + Train.EmergencyControls.Value * P)
        Panel.CabVent = P * Train.SF62F3.Value
        Panel.DoorLeftL = self.DoorsControl * Train.DoorSelectL.Value * (1 - Train.DoorSelectR.Value)
        Panel.DoorRightL = self.DoorsControl * Train.DoorSelectR.Value * (1 - Train.DoorSelectL.Value)
        Panel.DoorCloseL = min(1, UPIPower + self.DoorsControl) * Train.SF80F5.Value * S["RV"] * Train.BUKP.Active * Train.DoorClose.Value
        Panel.DoorBlockL = UPIPower * Train.DoorBlock.Value
        Panel.EmerBrakeL = PowerReserve * C(Train.Pneumatic.EmerBrakeWork == 1 or Train.Pneumatic.EmerBrakeWork == true) * BTB
        Panel.EmerXodL = PowerReserve * abs(RV.KRRPosition) * (1 - Train.SD3.Value) * Train.BARS.Drive  -- FIXME Restore old BARS.Drive as separate field
        Panel.KAHl = UPIPower * Train.KAH.Value
        Panel.ALSl = UPIPower * Train.ALS.Value
        Panel.AutoDriveLamp = UPIPower -- остальное уже в ините посчитаем
        Panel.PRl = UPIPower * Train.Pr.Value * Train.SF70F3.Value
        Panel.OtklRl = UPIPower * Train.OtklR.Value * Train.SF70F3.Value
        Panel.Washerl = PowerReserve * Train.Washer.Value * Train.SF70F3.Value
        Panel.Wiperl = PowerReserve * Train.Wiper.Value * Train.SF70F3.Value
        Panel.WiperPower = PowerReserve * Train.SF70F3.Value
        Panel.EmergencyControlsl = UPIPower * Train.EmergencyControls.Value
        Panel.EmergencyDoorsl = UPIPower * Train.EmergencyDoors.Value
        Panel.GlassHeatingl = PowerReserve * Train.SF70F2.Value * Train.GlassHeating.Value
        Panel.PowerOnl = PBatt * Train.SF30F1.Value * min(1, Train:ReadTrainWire(75) + Train.PowerOn.Value)
        Panel.PowerOffl = PBatt * Train.SF30F1.Value * min(1, Train:ReadTrainWire(74) + Train.PowerOff.Value)
        Panel.BatteryChargel = Train:ReadTrainWire(42)
        Panel.LV = Train.Battery.Value * self.Battery80V --/150
    else
        Panel.LV = Train.Battery.Value * self.KM2 * Train.SF52F3.Value * self.Battery80V --/150
    end

    Train.SF54:TriggerInput("Set", Train.SF45F5.Value * Train.SF45F6.Value)

    Panel.WorkFan = P * Train.Battery.Value * Train.GV.Value * HV
    Panel.SalonLighting1 = P * self.KM2 * Train.Battery.Value * Train.SF52F3.Value
    Panel.SalonLighting2 = P * self.KM2 * Train.Battery.Value * Train.SF52F2.Value * BUV.MainLights

    local ukkz = 1
    local kzx, pkz, val, short, timerId
    local hvInput = Train.TR.Main750V >= 550
    for idx = 1, 4 do
        kzx = Train["UKKZ" .. idx]
        pkz = Train["PantShort" .. idx]
        if kzx and pkz then
            val = kzx.Value
            short = kzx.Value == 1 and (pkz.Value + Train.AsyncShort.Value) > 0
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
    Train.UKKZ:TriggerInput("Set", ukkz)
    if ukkz < 1 and Train.BV.Value > 0 then
        if not self.BvSoundTimer then
            Train:PlayOnce("bv_off", "", 1, 1)
            self.BvSoundTimer = CurTime() + 1
        end
        Train.BV:TriggerInput("Open", 1)
    end
    if self.BvSoundTimer and self.BvSoundTimer < CurTime() then
        self.BvSoundTimer = nil
    end

    if not Async then return end

    self.MK = Train.Battery.Value * PowerPSN * BUV.PSN * HV * self.KM2 * Train.SF30F3.Value * (BUV.MK > 0 and 1 or Train:ReadTrainWire(10))
    local command = BUV.Strength or 0
    local speed = Async.Speed
    if self.command ~= command and CurTime() - self.commandTimer > (0.3 + (command ~= 0 and speed > 2 and sign(command) ~= sign(self.command) and 0.6 or 0)) then
        self.commandTimer = CurTime()
        self.command = command
    end

    Async:TriggerInput("Power", BO * self.KM2 * (Train.SF23F4 and Train.Battery.Value * Train.SF23F4.Value or 1) * Train.GV.Value * Train.BV.Value)
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
        Async:TriggerInput("TargetCurrent", targetI * (1 + (self.Slope == 1 and 0.1 or Train.Pneumatic.WeightLoadRatio * 0.1)) * ((1 - k) + k * Clamp((speed - 3) / 16, 0, 1))) --*(0.22+0.78*Clamp((speed-3)/14,0,1)))--*(speed > 50 and 1-(speed-50)/150 or 1) )--*(speed < 20 and 0.23+Clamp(speed/22,0,1)*0.77 or 1))--330
    elseif self.command < 0 then
        Async:TriggerInput("TargetCurrent", targetI * (1 + (self.Slope == 1 and 0.1 or Train.Pneumatic.WeightLoadRatio * 0.1)) * ((1 - k) + k * Clamp((speed - 3) / 22, 0, 1))) --*Clamp((speed-2)/18,0,1))--*(Clamp(speed/30,0,1)+(speed < 10 and 0.035 or 0) ))--330
    else
        Async:TriggerInput("TargetCurrent", 0)
    end

    self.EnergyChange = Async.Mode > 0 and (Async.Current ^ 2) * 2.2 or 0
    self.Itotal = Async.Current

    if Async.Mode < 0 and Async.State > 0 then
        self.Recurperation = C(self.Main750V > 749 and self.Main750V < 921) * BUV.Recurperation
        self.Iexit = self.Iexit + (-Async.Current * 2 * self.Recurperation - self.Iexit) * dT * 2

        S["ChopperWork"] = (self.Main750V >= 921 or self.Main750V < 550) and 1 or 0
        S["ChopperWork"] = S["ChopperWork"] + (1 - self.Recurperation)
        if S["ChopperWork"] > 0 and CurTime() >= self.ChopperTimeout then self.ChopperTimeout = CurTime() + Rand(1, 5) end
        self.Chopper = (S["ChopperWork"] > 0 or CurTime() < self.ChopperTimeout) and 1 or 0
    else
        self.Recurperation = 0
        self.Iexit = 0
        self.Chopper = 0
    end

    self.ElectricEnergyUsed = self.ElectricEnergyUsed + max(0, self.EnergyChange) * dT
    self.ElectricEnergyDissipated = self.ElectricEnergyDissipated + max(0, self.Iexit ^ 2) * 2.2 * dT
end
