--------------------------------------------------------------------------------
-- Блок Управления Вагоном
--------------------------------------------------------------------------------
Metrostroi.DefineSystem("81_760E_BUV")
TRAIN_SYSTEM.DontAccelerateSimulation = true

local function randomGaussian(min, mid, max)
    local u1 = math.random()
    local u2 = math.random()
    local z0 = math.sqrt(-2 * math.log(u1)) * math.cos(2 * math.pi * u2)
    local mean = mid
    local sigma = (max - min) / 6
    local value = mean + z0 * sigma
    if value < min then value = min end
    if value > max then value = max end
    return value
end

function TRAIN_SYSTEM:Initialize()
    if TURBOSTROI then
    else
        self.TrainIndex = self.Train:GetWagonNumber()
    end

    self.Battery = false
    self.Power = 0
    self.States = {}
    self.Commands = {}
    self.Slope = false
    self.PSN = 0
    self.MK = 0
    self.Reverser = 0
    self.PN2 = 0
    self.Brake = 0
    self.Drive = 0
    self.DriveStrength = 0
    self.Disassembly = 0
    self.Vent1 = 0
    self.Vent2 = 0
    self.Cond1 = 0
    self.Cond2 = 0
    self.PowerTimer = CurTime()
    self.PowerTbl = {
        [1] = 0.0425, --X1 150A
        [2] = 0.1295, --X2 200A
        [3] = 0.2345, --X3 260A
        [4] = 0.3565, --X4 330A
        -------------------
        [0] = 0,
        -------------------
        [-1] = -0.0185, --T1 -150A
        [-2] = -0.2150, --T2 -260A
        [-3] = -0.3044, --T3 -310A
    }

    self.DriveTimer = CurTime()
    self.CurTime = CurTime()
    self.TimerMode = CurTime()
    self.I = math.random(3, 6)
    self.IVO = -00.1
    self.FirstHalf = false
    self.Strength = 0
    self.TargetStrength = 0
    self.AKBVoltage = 0
    self.PrevBV = 0
    self.PowerOff = 0
    self.SchemeSlope = false
    self.Recurperation = 1
    self.MainLights = 0
    self.BC2Dev = math.random() * 0.24 - 0.12
    self.BTOKTO1 = 0
    self.BTOKTO2 = 0
    self.BTOKTO3 = 0
    self.BTOKTO4 = 0
    self.Orient = "Bad"
    self.BTOKTO1Val = randomGaussian(1.7, 2.7, 3.0)
    self.BTOKTO2Val = randomGaussian(1.7, 2.7, 3.0)
    self.BTOKTO3Val = randomGaussian(1.7, 2.7, 3.0)
    self.BTOKTO4Val = randomGaussian(1.7, 2.7, 3.0)

    self.WagIdx = 1
    self.TrainLen = 1
end

function TRAIN_SYSTEM:Outputs()
    return {"Brake", "Drive", "DriveStrength", "Disassembly", "PSN", "MK", "Vent1", "Vent2", "Cond1", "Cond2", "Strength", "Recurperation", "Slope", "Slope1", "AKBVoltage", "SchemeSlope", "PowerOff", "MainLights", "Power"}
end

function TRAIN_SYSTEM:Inputs()
    return {}
end

function TRAIN_SYSTEM:CState(name, value)
    if self.CurrentBUP and (self.Reset or self.States[name] ~= value) then
        self.States[name] = value
        self.Train:CANWrite("BUV", self.Train:GetWagonNumber(), "BUKP", self.CurrentBUP, name, value)
    end
end

function TRAIN_SYSTEM:CANReceive(source, sourceid, target, targetid, textdata, numdata)
    if textdata == "BUPWork" and not numdata then
        self.Commands[sourceid] = {}
    elseif textdata == "Orientate" then
        self.OrientateBUP = sourceid
        self.LastOrientate = sourceid
        self.FirstHalf = numdata
        self.Reset = CurTime()
    elseif self.CurrentBUP then
        if not self.Commands[sourceid] then self.Commands[sourceid] = {} end
        if textdata == "DriveStrength" then
            numdata = math.Round(numdata / 10)
            numdata = numdata > 0 and math.max(1, math.min(4, numdata * 4 / 10)) or numdata < 0 and math.min(-1, math.max(-3, numdata * 3 / 10)) or 0
        end
        self.Commands[sourceid][textdata] = numdata
    end
end

function TRAIN_SYSTEM:Get(id)
    local Commands = self.Commands[self.CurrentBUP]
    if Commands then return Commands[id] end
end

function TRAIN_SYSTEM:TriggerInput(name, value)
end

local SFTbl = {
    SF23F12 = "SF", -- Счетчик
    SF23F4 = "SF52", -- Инвертор
    SF23F6 = "SF51", -- Управ. рез.
    SF30F4 = "SF45", -- ПСН
    SF52F3 = "SF44", -- Освещение авар.
    SF52F2 = "SF43", -- Освещение осн.
    SF90F2 = "SF36", -- АСОТП
    SF45F3 = "SF", -- Питание ESM
    SF80F6 = "SF40", -- Двери откр.
    SF80F7 = "SF41", -- Двери откр.
    SF21F1 = "SF53", -- ТКПР
    SF45F5 = "SF54", -- Видео
    SF52F4 = "SF", -- Подсветка дверей
    SF23F10 = "SF", -- Противоюз
    SF30F3 = "SF34", -- Осушитель
    SF23F5 = "SF50", -- Цепи упрв. осн.
    SF30F7 = "SF31", -- Питание ЦУ
    SF30F9 = "SF32", -- Питание ЦУ
    SF30F6 = "SF33", -- Питание ЦУ
    SF30F8 = "SF46", -- Питание ЦУ
    SF30F2 = "SF58", -- БС управл.
    SF45F2 = "SF", -- БУТ БВМ
    SF45F4 = "SF", -- БУТ БВМ
    SF45F7 = "SF37", -- БНТ-ИК
    SF45F8 = "SF38", -- БНТ-ИК
    SF22F1 = "SF55", -- БУФТ
}

local function PrevTrain(Train, front)
    if front and IsValid(Train.FrontTrain) then
        if not Train:ElectricConnected(Train, not front) then return end
    elseif not front and IsValid(Train.RearTrain) then
        if not Train:ElectricConnected(Train, not front) then return end
    end
    return front and Train.FrontTrain or not front and Train.RearTrain
end

local function Orient(Train, front)
    local Or = not front and IsValid(Train.RearTrain) and (Train.RearTrain.FrontTrain == Train) or front and IsValid(Train.FrontTrain) and (Train.FrontTrain.RearTrain == Train) or nil
    return Or
end

local function PrintTbl(tbl)
    for k, v in pairs(tbl) do
        print(k, IsEntity(v) and v.WagonNumber or v)
    end
end

local function CheckSF33(Train, val)
    local tbl, numtbl = {Train}, {}
    numtbl[Train.WagonNumber] = true
    local Ft, Rt = PrevTrain(Train, true), PrevTrain(Train)
    local SF33 = Train.SF33.Value

    local i = 0
    while IsValid(Ft) and not Train.SA1 do
        i = i + 1
        if not Ft.SA1 and Ft.SF33.Value == 0 then
            if Ft.RearTrain ~= tbl[i] then
                table.insert(tbl, Ft)
                numtbl[Ft.WagonNumber] = true
            end

            break
        else
            table.insert(tbl, Ft)
            numtbl[Ft.WagonNumber] = true
            if Ft.SA1 then break end
        end

        if IsValid(PrevTrain(Ft, true)) and not numtbl[PrevTrain(Ft, true).WagonNumber] then
            Ft = PrevTrain(Ft, true)
        elseif IsValid(PrevTrain(Ft)) and not numtbl[PrevTrain(Ft).WagonNumber] then
            Ft = PrevTrain(Ft)
        else
            break
        end
    end

    local k = i
    while IsValid(Rt) and SF33 > 0 do
        i = i + 1
        if not Rt.SA1 and Rt.SF33.Value == 0 then
            if Rt.RearTrain ~= tbl[i] and Rt.RearTrain ~= tbl[i - k] then
                table.insert(tbl, Rt)
                numtbl[Rt.WagonNumber] = true
            end

            break
        else
            table.insert(tbl, Rt)
            numtbl[Rt.WagonNumber] = true
            if Rt.SA1 then break end
        end

        if IsValid(PrevTrain(Rt, true)) and not numtbl[PrevTrain(Rt, true).WagonNumber] then
            Rt = PrevTrain(Rt, true)
        elseif IsValid(PrevTrain(Rt)) and not numtbl[PrevTrain(Rt).WagonNumber] then
            Rt = PrevTrain(Rt)
        else
            break
        end
    end

    tbl["i"] = i
    tbl["k"] = k

    local valu = false
    for _, v in pairs(tbl) do
        if IsEntity(v) and (v.SA1 or not v.SA1 and v.SF32.Value > 0) and v.Battery.Value > 0 and (not v.Electric.KM2 or v.Electric.KM2 == 1) then
            valu = true
            break
        end
    end

    local value = true
    if Train.SA1 then
        value = false
        local prev = PrevTrain(Train)
        if IsValid(prev) then
            value = not prev.SA1 and CheckSF33(prev, 1) or prev.SA1 and prev.Battery.Value == 1
            if not prev.SA1 and not Orient(Train) and prev.SF33.Value == 0 then value = false end
        end

        if not value then value = SF33 == 1 end
    end

    if val == true then
        return tbl
    elseif val and val == 1 then
        return valu and value
    elseif not val then
        return valu and value or Train.Battery.Value > 0
    end
end

local function CheckVoltage(Train)
    local tbl = CheckSF33(Train, true)
    local V = Train.Battery.Value > 0 and 69 + 11 * Train.BUV.PSN or 0
    local i, k, max = (tbl["i"] or 0) + 1, (tbl["k"] or 0) + 1, #tbl
    if (Train.SA1 or (Train.SF31.Value + Train.SF32.Value) > 0) and V < 80 then
        local Rt, Ft = nil, nil
        local j = 1
        while (j < k) and tbl[j + 1] do
            j = j + 1
            if tbl[j].SA1 or not tbl[j].SA1 and tbl[j].SF32.Value > 0 then
                Ft = tbl[j]
                break
            elseif tbl[j].SA1 then
                break
            end
        end

        j = k
        while (j < max) and tbl[j + 1] do
            j = j + 1
            if tbl[j].SA1 or not tbl[j].SA1 and tbl[j].SF32.Value > 0 then
                Rt = tbl[j]
                break
            elseif tbl[j].SA1 then
                break
            end
        end

        V = math.max(V, IsValid(Ft) and IsValid(Rt) and math.max((Ft.BUV.AKBVoltage - 4.4) * (not Ft.Electric.KM2 and 1 or Ft.Electric.KM2), (Rt.BUV.AKBVoltage - 4.4) * (not Rt.Electric.KM2 and 1 or Rt.Electric.KM2)) or IsValid(Ft) and (Ft.BUV.AKBVoltage - 4.4) * (not Ft.Electric.KM2 and 1 or Ft.Electric.KM2) or IsValid(Rt) and (Rt.BUV.AKBVoltage - 4.4) * (not Rt.Electric.KM2 and 1 or Rt.Electric.KM2) or 0)
    end
    return V > 62 and (CheckSF33(Train) and 1 or 0) * V or 0
end

function TRAIN_SYSTEM:Think(dT)
    if CurTime() - self.CurTime < 0.1 then return end
    self.DeltaTime = CurTime() - self.CurTime
    self.CurTime = CurTime()
    local Train = self.Train
    local wagcount = #Train.WagonList

    local IsHead = not not Train.RV
    local HasEngine = not not Train.AsyncInverter
    local P = HasEngine and Train.Electric.Power750V or Train.Electric.Main750V

    self.AKBVoltage = CheckVoltage(Train)
    self.Power = (Train.Electric.Battery80V > 62 and (Train.SF31.Value + Train.SF32.Value > 0 or not Train.SA1 and CheckSF33(Train, 1))) and 1 or 0
    self.State = self.Power > 0
    self.ADUVWork = (Train.Battery.Value * Train.SF48.Value > 0) or self.States.BCPressure == nil
    self.ADUTWork = (Train.Electric.BUFT > 0) or self.States.BCPressure == nil
    self.ADUDWork = Train.Battery.Value * Train.SF47.Value > 0.5
    local SchemeWork = HasEngine and (
        Train:ReadTrainWire(6) * Train.SF50.Value > 0.5 or
        (Train:ReadTrainWire(14) + Train:ReadTrainWire(15) == 1 and 1 or 0) * Train.SF51.Value > 0
    ) and 1 or (not HasEngine and 1 or 0)

    if self.State and Train.SF46.Value > 0.5 then
        if not self.States.BUVWork then self.Train:CANWrite("BUV", Train:GetWagonNumber(), "BUKP", nil, "Get", 1) end
        self:CState("Battery", Train.Battery.Value == 1)
        for i = 1, 4 do
            self:CState("Door" .. i .. "Closed", self.ADUDWork and Train.Pneumatic.LeftDoorState[i] == 0 or not self.ADUDWork and Train.Battery.Value > 0 and self.States["Door" .. i .. "Closed"])
            self:CState("Door" .. (i + 4) .. "Closed", self.ADUDWork and Train.Pneumatic.RightDoorState[i] == 0 or not self.ADUDWork and Train.Battery.Value > 0 and self.States["Door" .. (i + 4) .. "Closed"])
        end

        self:CState("LeftDoorsOpened", self.ADUDWork and Train.LeftDoorsOpened or not self.ADUDWork and Train.Battery.Value > 0 and self.States.LeftDoorsOpened)
        self:CState("RightDoorsOpened", self.ADUDWork and Train.RightDoorsOpened or not self.ADUDWork and Train.Battery.Value > 0 and self.States.RightDoorsOpened)
        self:CState("BUDWork", self.ADUDWork)
        if IsHead then
            self:CState("DoorTorec", Train.RearDoor or Train.FrontDoor)
            self:CState("DoorBack", Train.PassengerDoor or Train.CabinDoorLeft or Train.CabinDoorRight)
            self:CState("CabDoorLeft", not Train.CabinDoorLeft)
            self:CState("CabDoorRight", not Train.CabinDoorRight)
            self:CState("CabDoorPass", not Train.PassengerDoor)
            self:CState("CondK", Train.Electric.BSPowered * Train.SF62F3.Value > 0.5)
        end

        self:CState("EmPT", Train:ReadTrainWire(28) > 0)
        self:CState("NoAssembly", self.TargetStrength > 0) --K3_4 == 1
        local emer = Train:ReadTrainWire(45) + Train:ReadTrainWire(19)
        local bv = Train.BV.Value
        local strength, brake, drive = 0, 0, 0
        if emer > 0 then
            strength = Train:ReadTrainWire(45) > 0 and 4 or Train:ReadTrainWire(19) > 0 and 2 or 0
            drive = strength * bv
        else
            brake = self.Brake
            drive = self.Drive * bv
            strength = self.DriveStrength
        end

        self.Scheme = (Train.Speed < 0.4 and 0 or Train.Electric.Brake) + drive > 0
        self:CState("Strength", self.Strength)
        if HasEngine then
            self:CState("Scheme", ((Train.Speed < 6.5 and 0 or brake) + drive > 0 and (drive > 0 and (Train.Pneumatic.BrakeCylinderPressure < 0.7 or self.Slope1 or Train:ReadTrainWire(19) + Train:ReadTrainWire(45) > 0) or brake > 0 and Train.Pneumatic.BrakeCylinderPressure < 1.7 + Train.Pneumatic.WeightLoadRatio * 0.5 + Train.Pneumatic.BrakeCylinderRegulationError)) and SchemeWork > 0.5)
        else
            self:CState("Scheme", (Train.Speed < 6.5 and 0 or brake) + drive > 0 and (drive > 0 and Train.Pneumatic.BrakeCylinderPressure < 0.7 or brake > 0 and Train.Pneumatic.BrakeCylinderPressure < 1.7 + Train.Pneumatic.WeightLoadRatio * 0.5 + Train.Pneumatic.BrakeCylinderRegulationError))
        end

        self:CState("ParkingBrakeEnabled", self.ADUTWork and 3.8 - Train.Pneumatic.ParkingBrakePressure > 0 or not self.ADUTWork and self.States.ParkingBrakeEnabled)
        self:CState("BEPPBroken", false)

        for i = 1, 8 do
            self:CState("DPBT" .. i, self.ADUVWork and Train:GetPackedBool("BC" .. i) or not self.ADUVWork and self.States["DPBT" .. i])
        end

        for sfn, sf in pairs(SFTbl) do
            self:CState(sfn, not Train[sf] or Train[sf].Value == 1)  -- FIXME implement all SFs and remove this
        end

        self:CState("EmergencyBrakeGood", Train.Pneumatic.BrakeCylinderPressure > ((HasEngine and 2.3 or 1.75) + Train.Pneumatic.BrakeCylinderRegulationError + Train.Pneumatic.WeightLoadRatio * 1.3) - 0.05)
        self:CState("EmergencyBrake", self.States.EmergencyBrakeGood and Train.Pneumatic.EmergencyBrakeActive) -- and Train:ReadTrainWire(28) == 0	)
        self:CState("ReserveChannelBraking", HasEngine and self.Recurperation == 1 or not HasEngine and nil) --Train.Pneumatic.EmerBrakeWork)--Train:ReadTrainWire(28)>0)
        self:CState("PTBad", Train.K31.Value == 0) --false)
        self:CState("PTReady", Train.Pneumatic.AirDistributorPressure >= (2.4 + Train.Pneumatic.WeightLoadRatio * 0.9) - 0.1)
        self:CState("PTReplace", self.PTReplace) --and CurTime()-self.PTReplace > 1.5)
        self:CState("BTBReady", Train.Pneumatic.BTBReady)
        self:CState("BCPressure", (self.ADUVWork and self.ADUTWork) and math.Round(Train.Pneumatic.BrakeCylinderPressure, 1) or (not self.ADUVWork or not self.ADUTWork) and self.States.BCPressure)
        self:CState("PantDisabled", self.ADUVWork and self.Pant or not self.ADUVWork and self.States.PantDisabled)
        self:CState("PTEnabled", (self.States.BCPressure or 2.3) > 0.22) --(not self.States.DPBT1) == true or (self.States.BCPressure and self.States.BCPressure or 2.3)>0.22)
        self:CState("HPPressure", self.ADUTWork and math.Round(Train.Pneumatic.AirDistributorPressure, 1) or not self.ADUTWork and self.States.HPPressure)
        self:CState("ParkingBrakePressure", self.ADUTWork and math.Round(Train.Pneumatic.ParkingBrakePressure, 1) or not self.ADUTWork and self.States.ParkingBrakePressure)
        self:CState("TLPressure", self.ADUTWork and math.Round(Train.Pneumatic.TrainLinePressure, 1) or not self.ADUTWork and self.States.TLPressure)
        self:CState("BLPressure", self.ADUTWork and math.Round(Train.Pneumatic.BrakeLinePressure, 1) or not self.ADUTWork and self.States.BLPressure)
        self:CState("WeightLoad", math.Round(Train.Pneumatic.WeightLoadRatio, 2))
        self:CState("ElectricEnergyUsed", Train.Electric.ElectricEnergyUsed / 3.6e6)
        self:CState("PSNEnabled", self.PSN)
        self:CState("AddressDoorsL", Train.BUD.AddressReadyL)
        self:CState("AddressDoorsR", Train.BUD.AddressReadyR)

        if HasEngine then
            self:CState("EnginesBroken", not self:Get("PVU5") and Train.Battery.Value * Train.SF52.Value == 1)
            self:CState("PSNWork", not self:Get("PVU6") and Train.Battery.Value * Train.SF45.Value == 1)
            self:CState("PSNBroken", false)
            self:CState("BVEnabled", Train.BV.Value > 0)
            self:CState("MKCurrent", math.Round(Train.Electric.MK * math.Round(math.Rand(12, 15) * (Train.Pneumatic.Compressor and (CurTime() - Train.Pneumatic.Compressor > 0 and 1 or CurTime() - Train.Pneumatic.Compressor > -4 and (4 + (CurTime() - Train.Pneumatic.Compressor)) / 4) or 0))))
            self:CState("MKWork", not self:Get("PVU2") and Train.SF34.Value == 1)
            self:CState("DriveStrength", math.min(0, Train.AsyncInverter.Torque + Train.AsyncInverter.Torque * math.Rand(0, 0.05)))
            self:CState("BrakeStrength", math.max(0, Train.AsyncInverter.Torque + Train.AsyncInverter.Torque * math.Rand(0, 0.05)))
            self:CState("I", Train.AsyncInverter.Current)
        else
            self:CState("DriveStrength", 0)
            self:CState("BrakeStrength", 0)
            self:CState("I", 0)
        end

        self:CState("LV", Train.Electric.Battery80V)
        self:CState("HVBad", P < 550)
        self:CState("LVBad", Train.Electric.Battery80V < 62)
        self:CState("EnginesDone", self.EnginesDone) -- and math.abs(Train.Speed) < 7.5)
        self:CState("PassLightEnabled", self.MainLights == 1)
        self:CState("VagEqConsumption", self.IVO)
        self:CState("HVVoltage", math.floor(P))
        self:CState("LVVoltage", math.floor(Train.Electric.Battery80V))
        self:CState("Cond1", self.Cond1 > 0)
        self:CState("Cond2", self.Cond2 > 0)
        self:CState("HeatEnabled", false)
        self:CState("BUVWork", true)
        self:CState("WagNOrientated", self.Orientation == self.RevOrientation)
        self:CState("AsyncInverter", HasEngine)
        self:CState("HasCabin", IsHead)
        self:CState("Orientation", self.Orientation)
        self:CState("BadCombination", (Train:ReadTrainWire(3) * Train:ReadTrainWire(4)) > 0)
        self:CState("WagType", Train.SubwayTrain.WagType)
        self:CState("WagNumber", Train.WagonNumber)

        if IsHead then
            self:CState("Blocks", self.ADUVWork and self.BlockTorec or not self.ADUVWork and self.States.Blocks)
        end

        self:CState("BCPressure2", (self.ADUVWork and self.ADUTWork) and math.Round(math.max(0, Train.Pneumatic.BrakeCylinderPressure + self.BC2Dev), 1) or (not self.ADUVWork or not self.ADUTWork) and self.States.BCPressure)
        self:CState("ElectricEnergyDissipated", Train.Electric.ElectricEnergyDissipated / 3.6e6)
        self:CState("BrakeEquip", Train.K31.Value > 0)
        self:CState("BTOKTO1", self.BTOKTO1)
        self:CState("BTOKTO2", self.BTOKTO2)
        self:CState("BTOKTO3", self.BTOKTO3)
        self:CState("BTOKTO4", self.BTOKTO4)
    else
        self:CState("BUVWork", false)
        for k, v in pairs(self.Commands) do
            self.Commands[k] = false
        end
    end

    if self.Reset and self.Reset ~= CurTime() then self.Reset = nil end
    self.IVO = Train.Electric.Battery80V > 67 and self.PSN > 0 and self.I * 10 + math.Round(math.Rand(2, 6), 1) or -00.1
    if HasEngine then
        local bv_off = (self:Get("BVOff") or Train.Battery.Value * Train.SF52.Value == 0 or Train.Electric.Battery80V <= 67) and (Train:ReadTrainWire(19) + Train:ReadTrainWire(45) == 0) or self:Get("PVU7")
        local bv_on = Train.Battery.Value > 0 and (self:Get("BVOn") or Train:ReadTrainWire(2) > 0 or self:Get("BVInit") or Train:ReadTrainWire(19) + Train:ReadTrainWire(45) > 0) and not self:Get("PVU7")
        if Train.BV.Value ~= self.PrevBV and Train:ReadTrainWire(5) == 0 and Train:ReadTrainWire(6) == 1 then self.PrevBV = Train.BV.Value end
        if Train:ReadTrainWire(5) ~= self.PrevBV1 then
            if Train:ReadTrainWire(5) == 0 then
                if self.PrevBV == 0 then
                    Train.BV:TriggerInput("Open", 1)
                else
                    Train.BV:TriggerInput("Close", 1)
                end
            end

            self.PrevBV1 = Train:ReadTrainWire(5)
        end

        if bv_on and not self.BVTimer then self.BVTimer = CurTime() + math.Rand(2, 4) end
        if bv_off then
            if Train.BV.Value == 1 then Train:PlayOnce("bv_off", "", 1, 1) end
            Train.BV:TriggerInput("Open", 1)
            self.BVTimer = nil
        end

        if self.BVTimer and CurTime() - self.BVTimer > 0 then
            Train.BV:TriggerInput("Close", 1)
            self.BVTimer = nil
        end
    end

    if self.PSN > 0 or self.MainLights == 0 or self.MainLightsTimer and CurTime() - self.MainLightsTimer > 20 then self.MainLightsTimer = nil end
    self.MainLights = not self:Get("PVU3") and (self.PSN > 0 or self.MainLightsTimer) and self.PassLight and 1 or 0
    if self:Get("Slope") then
        self.Slope = CurTime()
    elseif Train:ReadTrainWire(5) > 0 and self.Slope then
        self.Slope = false
    end

    if self.Slope and self.TargetStrength > 0 then self.SchemeSlope = true end
    if self.SchemeSlope and self.TargetStrength <= 0 then self.SchemeSlope = false end
    if not self:Get("Slope") and self.Slope and (self:Get("SlopeSpeed") and self.TargetStrength > 0 and CurTime() - self.Slope > 2 or not self:Get("SlopeSpeed") and self.TargetStrength ~= 0) then --Train.Pneumatic.BrakeCylinderPressure < 1.5 then self.Slope = false end
        self.Slope = false
    end

    if self.Slope then self.Slope1 = true end
    if self.Slope1 and Train.Pneumatic.BrakeCylinderPressure < 0.1 then self.Slope1 = false end
    self.Reverser = Train:ReadTrainWire(12)
    local brake = self:Get("Brake") or 0
    local strength = not self:Get("PVU5") and (self.Slope1 and true or brake > 0 and Train.Pneumatic.BrakeCylinderPressure < 1.7 + Train.Pneumatic.WeightLoadRatio * 0.5 + Train.Pneumatic.BrakeCylinderRegulationError or brake == 0 and (self:Get("Slope") or Train.Pneumatic.BrakeCylinderPressure < 0.7)) and self:Get("DriveStrength") or 0
    if not self:Get("PVU5") and brake == 0 and Train.Pneumatic.BrakeCylinderPressure < 0.4 then self.DriveTimer = CurTime() end
    if brake == 0 and not self:Get("PVU5") then
        if Train:ReadTrainWire(45) == 1 then
            strength = 4
            self.SchemeSlope = true
        elseif Train:ReadTrainWire(19) == 1 then
            strength = 2
            self.SchemeSlope = true
        end
    end

    local drive = math.min(1, (1 - brake) * strength)
    if strength == 0 then
        brake = 0
        drive = 0
    end

    self.Brake = brake
    self.Drive = drive
    self.Strength = (self.Brake == 1 and -1 or 1) * strength * SchemeWork
    if HasEngine then Train.Electric:TriggerInput("Slope", self.SchemeSlope) end
    self.TargetStrength = (self:Get("Brake") == 1 and -1 or 1) * (self:Get("DriveStrength") or 0) + ((Train:ReadTrainWire(45) == 1 and 4 or Train:ReadTrainWire(19) == 1 and 2) or 0)
    local strongerBrake
    if HasEngine then
        strongerBrake = self.TargetStrength < 0 and self:Get("StrongerBrake") and self:Get("StrongerBrake") > 0
    else
        strongerBrake = self.TargetStrength < -2.5 or self.TargetStrength < 0 and self:Get("StrongerBrake") and self:Get("StrongerBrake") > 0
    end
    self.DriveStrength = strength
    if not self.Slope then
        if HasEngine then
            if (self:Get("Brake") or 0) == 0 then
                self.EnginesDone = false
            elseif Train.AsyncInverter.Brake == 1 and Train.Speed < 7 or self:Get("PVU5") then
                self.EnginesDone = true
            end
        else
            self.EnginesDone = true
        end

        if (self.EnginesDone or self.States.EnginesDone) and self.Strength < 0 and Train.Speed > 7 then
            self.EnginesDone = false
            self.States.EnginesDone = false
        end

        if HasEngine then
            if self.TargetStrength < 0 and not self.PTReplaceTimer and math.abs(Train.AsyncInverter.Torque) < 0.01 then
                self.PTReplaceTimer = CurTime()
            elseif (self.TargetStrength >= 0 or math.abs(Train.AsyncInverter.Torque) >= 0.1) and self.PTReplaceTimer then
                self.PTReplaceTimer = nil
            end
        else
            if strongerBrake and not self.PTReplaceTimer then
                self.PTReplaceTimer = CurTime()
            elseif not strongerBrake and self.PTReplaceTimer then
                self.PTReplaceTimer = nil
            end
        end

        if self.PTReplaceTimer and CurTime() - self.PTReplaceTimer > (HasEngine and 2.2 or 0.5) or (Train.Speed < 7 and self.TargetStrength < 0) then
            self.PTReplace = true
        elseif not self.PTReplaceTimer and self.PTReplace then
            self.PTReplace = false
        end
    end

    if not self.EnginesDone or not self.States.EnginesDone then --and (self:Get("BARSBrake") or self:Get("AO")) then
        self.EnginesDone = true
        self.States.EnginesDone = true
    end

    if self.States.BUVWork then
        if IsHead then
            self.BlockSignal = self:Get("DoorTorec")
        end
        if HasEngine then
            self.MKSignal = self:Get("Compressor")
        end
        self.PSNSignal = self:Get("PSN")
        self.PowerOff = (self:Get("PowerOff") or Train.SF35 and Train.SF35.Value == 0) and 1 or 0
        self.PassLight = self:Get("PassLight")
        self.ZeroSpeed = self:Get("ZeroSpeed")
    elseif Train.Electric.Power == 0 then
        self.PassLight = false
        self.PSNSignal = false
        self.PowerOff = 0
        self.ZeroSpeed = false
    end

    local PN = self.PTReplace
    if HasEngine then
        self.PN1 = (self:Get("PN1") and self:Get("PN1") > 0) or PN and (self:Get("DriveStrength") and self:Get("DriveStrength") > 0) or self:Get("PR") and self.TargetStrength <= 0
        self.PN2 = self.Slope and self:Get("SlopeSpeed") or (self:Get("PN2") and self:Get("PN2") > 0) or PN and strongerBrake
        self.MK = not self:Get("PVU2") and self.MKSignal and 1 or 0
    else
        self.PN1 = (self:Get("PN1") and self:Get("PN1") > 0) or PN and (self:Get("DriveStrength") and self:Get("DriveStrength") > 1) or self:Get("PR") and self.TargetStrength <= 0
        self.PN2 = self.Slope and self:Get("SlopeSpeed") or PN and strongerBrake
    end
    self.PN3 = self:Get("PN3") and self:Get("PN3") > 0 or false

    self.PSN = not self:Get("PVU6") and Train.Electric.Battery80V > 67 and self.PSNSignal and Train.Battery.Value * Train.SF45.Value > 0 and 1 or Train:ReadTrainWire(42)
    if Train.Electric.Main750V < 550 or Train.Electric.Main750V > 975 then self.PSN = 0 end
    if self.PSN == 0 and self.PassLight and self.MainLights == 1 and not self.MainLightsTimer then self.MainLightsTimer = CurTime() end
    self.Recurperation = not self:Get("ReccOff") and 1 or 0

    self.BTB = Train.Pneumatic.RVTBLeak == 1
    self.OpenLeft = not self:Get("PVU1") and (self:Get("OpenLeft") and self.Orientation or self:Get("OpenRight") and not self.Orientation)
    self.OpenRight = not self:Get("PVU1") and (self:Get("OpenRight") and self.Orientation or self:Get("OpenLeft") and not self.Orientation)
    self.AddressDoors = self:Get("AddressDoors")
    self.WagIdx = self:Get("WagIdx") or 1
    self.TrainLen = self:Get("TrainLen") or 1

    local command = not self:Get("PVU1") and self:Get("CloseDoors")
    if command and self.CloseDoorsCommand ~= command and Train.DoorsOpened then
        self.CloseDoorsCommandAt = CurTime()
    end
    if not command and self.CloseDoorsCommandAt then
        self.CloseDoorsCommandAt = nil
    end
    if not command then
        self.CloseDoors = command
    end
    self.CloseDoorsCommand = command
    if command and (not self.CloseDoorsCommandAt or CurTime() - self.CloseDoorsCommandAt > 1.8) then
        self.CloseDoors = true
        if not Train.DoorsOpened then
            self.CloseDoorsCommandAt = nil
        end
    end

    self.Cond1 = self:Get("Cond1") and Train.Battery.Value * Train.SF56.Value * Train.SF57.Value > 0 and 1 or 0
    if P < 550 or P > 975 then self.Cond1 = 0 end
    self.Cond2 = self.Cond1 == 1 and 1 or 0
    self.Orientation = Train:ReadTrainWire(3) > 0
    self.RevOrientation = Train:ReadTrainWire(4) > 0
    local BadOrientation = self.Orientation and self.Orientation == self.RevOrientation
    if self.State and self.Orientation ~= self.RevOrientation then
        if not self.BadOrientation and self.OrientateBUP and (not self.Commands[self.OrientateBUP] or self.Orientation and self.Commands.Forward ~= self.OrientateBUP or self.RevOrientation and self.Commands.Back ~= self.OrientateBUP) then
            --print(Train:GetWagonNumber(),"New BUP",self.Orientation and "Forward" or "Back",self.OrientateBUP)
            if self.Orientation then
                self.Commands.Forward = self.OrientateBUP
            else
                self.Commands.Back = self.OrientateBUP
            end

            self.OrientateBUP = nil
        end
    end

    local ReOrientation = self.State and (self.Orientation or self.RevOrientation) and (self.Orientation ~= self.PrevOrientation or self.RevOrientation ~= self.PrevRevOrientation or self.CurrentBUP ~= (self.Orientation and self.Commands.Forward or self.Commands.Back))
    if ReOrientation then
        self.CurrentBUP = self.Orientation and self.Commands.Forward or self.Commands.Back
        self.Reset = CurTime()
        if self.CurrentBUP then
            self.Commands[self.CurrentBUP] = {}
            Train:CANWrite("BUV", Train:GetWagonNumber(), "BUKP", self.CurrentBUP, "Get")
        end
    end

    self.BadOrientation = BadOrientation
    self.PrevOrientation = self.Train:ReadTrainWire(3) > 0
    self.PrevRevOrientation = self.Train:ReadTrainWire(4) > 0
    if self.ADUVWork then
        if IsHead then
            self.BlockTorec = not Train.RearDoor and not Train.FrontDoor and self.BlockSignal and Train.SF42.Value * Train.Battery.Value > 0
        end
        if (self:Get("PVU4") and Train.SF53.Value > 0 or self:Get("PantDisabled") and Train.SF53.Value > 0) and Train.Battery.Value > 0 then
            self.Pant = true
        else
            self.Pant = false
        end
    end

    -- FIXME move to pneumatic
    -- FIXME research what is this and make realistic
    self.BTOKTO1 = self.BTOKTO1 + (math.min(Train.Pneumatic.TrainLinePressure, Train.K31.Value > 0 and (self.BTOKTO1Val + (math.random() * 2 - 1) * 0.08) or 0) - self.BTOKTO1) * 2 * dT
    self.BTOKTO2 = self.BTOKTO2 + (math.min(Train.Pneumatic.TrainLinePressure, Train.K31.Value > 0 and (self.BTOKTO2Val + (math.random() * 2 - 1) * 0.08) or 0) - self.BTOKTO2) * 2 * dT
    self.BTOKTO3 = self.BTOKTO3 + (math.min(Train.Pneumatic.TrainLinePressure, Train.K31.Value > 0 and (self.BTOKTO3Val + (math.random() * 2 - 1) * 0.08) or 0) - self.BTOKTO3) * 2 * dT
    self.BTOKTO4 = self.BTOKTO4 + (math.min(Train.Pneumatic.TrainLinePressure, Train.K31.Value > 0 and (self.BTOKTO4Val + (math.random() * 2 - 1) * 0.08) or 0) - self.BTOKTO4) * 2 * dT
end
