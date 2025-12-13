--------------------------------------------------------------------------------
-- Пневматическая система 81-763Э
--------------------------------------------------------------------------------
Metrostroi.DefineSystem("81_763E_Pneumatic")
TRAIN_SYSTEM.DontAccelerateSimulation = true
function TRAIN_SYSTEM:Initialize(is722)
    -- (013)
    -- 1 Accelerated charge
    -- 2 Normal charge (brake release)
    -- 3 Closed
    -- 4 Service application
    -- 5 Emergency application
    -- Pressure in parking brake
    self.ParkingBrakePressure = 0
    self.AirDistributorPressure = 0
    -- Pressure in reservoir
    self.ReservoirPressure = 0.0 -- atm
    -- Pressure in trains feed line
    self.TrainLinePressure = 8.0 -- atm
    -- Pressure in trains brake line
    self.BrakeLinePressure = 0.0 -- atm
    -- Pressure in brake cylinder
    self.BrakeCylinderPressure = 0.0 -- atm
    -- Pressure in the door line
    self.DoorLinePressure = 0.0 -- atm
    -- Блокировка дверей
    self.Train:LoadSystem("BD", "Relay", "")
    -- Регулятор давления (АК)
    self.Train:LoadSystem("AK", "Relay", "AK-11B")
    self.Train:LoadSystem("UAVA", "Relay", "Switch")
    self.Train:LoadSystem("EmergencyBrakeValve", "Relay", "Switch")
    self.Train:LoadSystem("stopkran", "Relay", "Switch")
    self.Train:LoadSystem("K31", "Relay", "Switch", {
        normally_closed = true --ВР
    })

    self.Train:LoadSystem("K23", "Relay", "Switch", {
        normally_closed = true --подача нм к стояночным и отпуск стояночной камеры	
    })

    self.V4 = 0 --Включение РУ
    self.K1 = false
    self.K2 = false
    self.EmerBrake = 0
    -- Isolation valves
    self.Train:LoadSystem("FrontBrakeLineIsolation", "Relay", "Switch", {
        normally_closed = true,
        bass = true
    })

    self.Train:LoadSystem("RearBrakeLineIsolation", "Relay", "Switch", {
        normally_closed = true,
        bass = true
    })

    self.Train:LoadSystem("FrontTrainLineIsolation", "Relay", "Switch", {
        normally_closed = true,
        bass = true
    })

    self.Train:LoadSystem("RearTrainLineIsolation", "Relay", "Switch", {
        normally_closed = true,
        bass = true
    })

    -- Brake cylinder atmospheric valve open
    self.BrakeCylinderValve = 0
    -- Overpressure protection valve open
    self.TrainLineOverpressureValve = false
    -- Compressor simulation
    self.Compressor = false --Simulate overheat with TRK FIXME
    -- Disconnect valve status
    self.EPKPrevious = 0
    -- Doors state
    --[[self.Train:LoadSystem("LeftDoor1","Relay",{ open_time = 0.5, close_time = 0.5 })
    self.Train:LoadSystem("LeftDoor2","Relay",{ open_time = 0.5, close_time = 0.5 })
    self.Train:LoadSystem("LeftDoor3","Relay",{ open_time = 0.5, close_time = 0.5 })
    self.Train:LoadSystem("LeftDoor4","Relay",{ open_time = 0.5, close_time = 0.5 })
    self.Train:LoadSystem("RightDoor1","Relay",{ open_time = 0.5, close_time = 0.5 })
    self.Train:LoadSystem("RightDoor2","Relay",{ open_time = 0.5, close_time = 0.5 })
    self.Train:LoadSystem("RightDoor3","Relay",{ open_time = 0.5, close_time = 0.5 })
    self.Train:LoadSystem("RightDoor4","Relay",{ open_time = 0.5, close_time = 0.5 })]]
    --
    
    -- READ-ONLY now
    self.DoorLeft = false
    self.DoorRight = false
    self.CloseDoors = false
    if not TURBOSTROI then
        self.LeftDoorState = {0, 0, 0, 0}
        self.RightDoorState = {0, 0, 0, 0}
        self.LeftDoorDir = {0, 0, 0, 0}
        self.RightDoorDir = {0, 0, 0, 0}
        self.LeftDoorSpeed = {0, 0, 0, 0}
        self.RightDoorSpeed = {0, 0, 0, 0}
        self.DoorSpeedMain = 0.6
        for i = 1, #self.LeftDoorSpeed do
            self.LeftDoorSpeed[i] = 1.4
            self.RightDoorSpeed[i] = 1.4
        end
    end

    self.PlayOpen = 1e9
    self.PlayClosed = 1e9
    self.TrainLineOpen = false
    self.ParkingBrake = false
    self.EmergencyValve = false
    self.WeightLoadRatio = 0
    self.EmerBrakeWork = false
    self.BrakeCylinderRegulationError = (math.random() > 0.5 and 1 or -1) * math.random() * 0.09
end

function TRAIN_SYSTEM:Inputs()
    return {"BrakeUp", "BrakeDown", "BrakeSet", "Autostop"}
end

function TRAIN_SYSTEM:Outputs()
    return {"BrakeLinePressure", "BrakeCylinderPressure", "ReservoirPressure", "TrainLinePressure", "DoorLinePressure", "WeightLoadRatio"}
end

function TRAIN_SYSTEM:TriggerInput(name, value)
end

-- Calculate derivatives
function TRAIN_SYSTEM:equalizeCouplePressure(dT, pressure, train, valve_status, rate, close_rate)
    if not valve_status then return 0 end
    local other
    if IsValid(train) then other = train.Pneumatic end
    -- Get second pressure
    local P2 = 0
    if other then P2 = other[pressure] end
    if (not other) and valve_status then
        self.TrainLineOpen = pressure == "TrainLinePressure"
        rate = close_rate or rate
        --self.TrainLinePressure_dPdT = 0.0
    end

    -- Calculate rate
    local dPdT = rate * (P2 - self[pressure])
    -- Calculate delta
    local dP = dPdT * dT
    if other and other.ReadOnly then dP = dP / 250 end
    -- Equalized pressure
    local P0 = (P2 + self[pressure]) / 2
    -- Update pressures
    if dP > 0 then
        self[pressure] = math.min(P0, self[pressure] + dP)
        if other and not other.ReadOnly then other[pressure] = math.max(P0, other[pressure] - dP) end
    else
        self[pressure] = math.max(P0, self[pressure] + dP)
        if other and not other.ReadOnly then other[pressure] = math.min(P0, other[pressure] - dP) end
    end

    -- Update delta if losing air
    if self.TrainLineOpen and (pressure == "TrainLinePressure") then self[pressure .. "_dPdT"] = (self[pressure .. "_dPdT"] or 0) + dPdT end
    return dP
end

-------------------------------------------------------------------------------
function TRAIN_SYSTEM:UpdatePressures(Train, dT)
    local frontBrakeOpen = Train.FrontBrakeLineIsolation.Value == 0
    local rearBrakeOpen = Train.RearBrakeLineIsolation.Value == 0
    local frontTrainOpen = Train.FrontTrainLineIsolation.Value == 0
    local rearTrainOpen = Train.RearTrainLineIsolation.Value == 0
    local Ft = IsValid(Train.FrontTrain) and Train.FrontTrain
    local Rt = IsValid(Train.RearTrain) and Train.RearTrain
    local Fc, Rc = Train.FrontCouple or Train.FrontBogey, Train.RearCouple or Train.RearBogey
    local Fb, Rb
    if IsValid(Fc) and Fc.DepotPneumo then Fb = Fc.DepotPneumo end
    if IsValid(Rc) and Rc.DepotPneumo then Rb = Rc.DepotPneumo end
    local frontBrakeLeak = false
    local rearBrakeLeak = false
    local frontTrainLeak = false
    local rearTrainLeak = false
    -- Check if both valve on this train and connected train are open
    if Ft and Ft.FrontBrakeLineIsolation then
        if Ft.FrontTrain == Train then -- Nose to nose
            frontBrakeLeak = frontBrakeOpen and Ft.FrontBrakeLineIsolation.Value == 1 and 0.08
            frontTrainLeak = frontTrainOpen and Ft.FrontTrainLineIsolation.Value == 1 and 0.08
        else -- Rear to nose
            frontBrakeLeak = frontBrakeOpen and Ft.RearBrakeLineIsolation.Value == 1 and 0.08
            frontTrainLeak = frontTrainOpen and Ft.RearTrainLineIsolation.Value == 1 and 0.08
        end
    else
        frontBrakeLeak = frontBrakeOpen and 0.7
        frontTrainLeak = frontTrainOpen and not Fb and 0.3
    end

    if Rt and Rt.FrontBrakeLineIsolation then
        if Rt.FrontTrain == Train then -- Nose to nose
            rearBrakeLeak = rearBrakeOpen and Rt.FrontBrakeLineIsolation.Value == 1 and 0.08
            rearTrainLeak = rearTrainOpen and Rt.FrontTrainLineIsolation.Value == 1 and 0.08
        else -- Rear to nose
            rearBrakeLeak = rearBrakeOpen and Rt.RearBrakeLineIsolation.Value == 1 and 0.08
            rearTrainLeak = rearTrainOpen and Rt.RearTrainLineIsolation.Value == 1 and 0.08
        end
    else
        rearBrakeLeak = rearBrakeOpen and 0.7
        rearTrainLeak = rearTrainOpen and not Rb and 0.3
    end

    -- Equalize pressure
    local Fl = math.min(0, self:equalizeCouplePressure(dT, "BrakeLinePressure", frontBrakeLeak == false and Ft, frontBrakeOpen, 100, frontBrakeLeak or 0.08) * 3) * (frontBrakeLeak and 1 or 0)
    local Rl = math.min(0, self:equalizeCouplePressure(dT, "BrakeLinePressure", rearBrakeLeak == false and Rt, rearBrakeOpen, 100, rearBrakeLeak or 0.08) * 3) * (rearBrakeLeak and 1 or 0)
    Fl = Fl + math.min(0, self:equalizeCouplePressure(dT, "TrainLinePressure", frontTrainLeak == false and Ft or Fb, frontTrainOpen, 100, frontTrainLeak or 0.08) * 10) * (frontTrainLeak and 1 or 0)
    Rl = Rl + math.min(0, self:equalizeCouplePressure(dT, "TrainLinePressure", rearTrainLeak == false and Rt or Rb, rearTrainOpen, 100, rearTrainLeak or 0.08) * 10) * (rearTrainLeak and 1 or 0)
    self.TrainLineOpen = frontTrainLeak or rearTrainLeak
    self.BraieLineOpen = frontBrakeLeak or rearBrakeLeak
    Train:SetPackedRatio("FrontLeak", Fl)
    Train:SetPackedRatio("RearLeak", Rl)
end

function TRAIN_SYSTEM:equalizePressure(dT, pressure, target, rate, fill_rate, no_limit, smooth)
    if fill_rate and (target > self[pressure]) then rate = fill_rate end
    -- Calculate derivative
    local dPdT = rate
    if target < self[pressure] then dPdT = -dPdT end
    local dPdTramp = math.min(1.0, math.abs(target - self[pressure]) * (smooth or 0.5))
    dPdT = dPdT * dPdTramp
    -- Update pressure
    self[pressure] = self[pressure] + dT * dPdT
    self[pressure] = math.max(0.0, math.min(16.0, self[pressure]))
    self[pressure .. "_dPdT"] = (self[pressure .. "_dPdT"] or 0) + dPdT
    if no_limit ~= true then
        if self[pressure] == 0.0 then self[pressure .. "_dPdT"] = 0 end
        if self[pressure] == 16.0 then self[pressure .. "_dPdT"] = 0 end
    end
    return dPdT
end

-------------------------------------------------------------------------------
function TRAIN_SYSTEM:Think(dT)
    local Train = self.Train
    self.WeightLoadRatio = math.max(0, math.min(1, Train:GetNW2Float("PassengerCount") / 200))
    -- Apply specific rate to equalize pressure
    local V4 = false --Train.K29.Value == 1 or self.V4 and Train.Electric.V2 == 1 --Train.Electric.V4 > 0
    ----------------------------------------------------------------------------
    -- Accumulate derivatives
    self.TrainLinePressure_dPdT = 0.0
    self.BrakeLinePressure_dPdT = 0.0
    self.ReservoirPressure_dPdT = 0.0
    self.BrakeCylinderPressure_dPdT = 0.0
    self.AirDistributorPressure_dPdT = 0.0
    self.ParkingBrakePressure_dPdT = 0.0
    -- Reduce pressure for brake line
    self.TrainToBrakeReducedPressure = math.min(5.1, self.TrainLinePressure) -- * 0.725)
    -- Feed pressure to door line
    self.DoorLinePressure = self.TrainToBrakeReducedPressure * 0.90
    local trainLineConsumption_dPdT = 0.0
    local wagc = Train:GetWagonCount()
    local pr_speed = 1.25 * wagc
    self.Leak = false
    local leak = 0
    if self.Train.EmergencyBrakeValve.Value > 0.5 then
        leak = self:equalizePressure(dT, "BrakeLinePressure", 0.0, 2.2 * wagc, false, false, 1)
        self.Leak = true
    end

    self.Train:SetPackedRatio("EmergencyBrakeValve_dPdT", -leak)
    local leak = 0
    if self.Train.stopkran.Value > 0.5 then
        leak = self:equalizePressure(dT, "BrakeLinePressure", 0.0, 2.2 * wagc, false, false, 1)
        self.Leak = true
    end

    self.Train:SetPackedRatio("stopkran_dPdT", -leak)
    self.Train:SetPackedRatio("Crane_dPdT", self.BrakeLinePressure_dPdT)
    trainLineConsumption_dPdT = trainLineConsumption_dPdT + math.max(0, self.BrakeLinePressure_dPdT)
    local targetPressure = 0 --math.max(0,math.min(5.2,1.5*(math.min(5.1,self.TrainToBrakeReducedPressure) - self.BrakeLinePressure)))
    --if self.BrakeLinePressure <= 3.3 then
    local PMPressure = 0
    local EPMPressure = 0
    local from = self.TrainToBrakeReducedPressure --+self.BrakeCylinderRegulationError  
    local Power = Train.Electric.BUFT > 0 --работа буфт
    local emerBraking = Train:ReadTrainWire(29) > 0
    local emerRelease = Train:ReadTrainWire(30) > 0
    if not self.EmergencyBrakeActive then self.EmerBrakeWork = Train:ReadTrainWire(28) > 0 end
    if emerBraking and self.EmerBraking ~= emerBraking and self.EmerBrake < 3 then self.EmerBrake = self.EmerBrake + 1 end
    if emerRelease and self.EmerRelease ~= emerRelease and self.EmerBrake > 0 then self.EmerBrake = self.EmerBrake - 1 end
    self.EmerBraking = emerBraking
    self.EmerRelease = emerRelease
    if Power then
        if self.EmerBrakeWork then --Train:ReadTrainWire(28) > 0 then--and not self.EmergencyBrakeActive then
            if not self.EmergencyBrakeActive then
                if self.EmerBrake > 1 and self.EmerBrake <= 2 then
                    EPMPressure = 1.2 + self.BrakeCylinderRegulationError + self.WeightLoadRatio * 0.5 --2 уставка
                elseif self.EmerBrake > 0 then
                    EPMPressure = 0.7 + self.BrakeCylinderRegulationError + self.WeightLoadRatio * 0.4 --1 уставка
                end
            elseif self.EmerBrake > 0 then
                self.EmerBrake = 0
            end
        else
            if self.EmerBrake > 0 then self.EmerBrake = 0 end
            if Train.BUV.PN2 then
                EPMPressure = 1.2 + self.BrakeCylinderRegulationError + self.WeightLoadRatio * 0.5 --2 уставка
            elseif Train.BUV.PN1 then
                EPMPressure = 0.7 + self.BrakeCylinderRegulationError + self.WeightLoadRatio * 0.4 --1 уставка
            end
        end
    end

    --self:equalizePressure(dT,"AirDistributorPressure", math.Clamp(((from-self.BrakeLinePressure)/(from-3.2)),0,1)*(2.3+self.BrakeCylinderRegulationError+self.WeightLoadRatio*1.3), 2.50, 2.50, nil, 1.3)
    self:equalizePressure(dT, "AirDistributorPressure", math.Clamp((from - self.BrakeLinePressure) / (from - 3.2), 0, 1) * (1.75 + self.BrakeCylinderRegulationError + self.WeightLoadRatio * 1.3), 2.50, 2.50, nil, 1.3)
    self.EmergencyBrakeActive = Train:ReadTrainWire(25) * Train:ReadTrainWire(26) == 0 --*Train.Electric.Battery80V*Train:ReadTrainWire(35) < 62--[[or self.EmerBrake == 3 or Train.BUV.BTB]]
    self.BTBReady = self.AirDistributorPressure > (1.75 + self.BrakeCylinderRegulationError + self.WeightLoadRatio * 1.3) - 0.05
    if self.EmergencyBrakeActive or self.EmerBrake == 3 or Train.BUV.PN3 then
        PMPressure = self.AirDistributorPressure
        if self.BrakeCylinderPressure < self.AirDistributorPressure and self.AirDistributorPressure - self.BrakeCylinderPressure > 0.1 then self:equalizePressure(dT, "AirDistributorPressure", 0, (self.AirDistributorPressure - self.BrakeCylinderPressure) * 1, (self.AirDistributorPressure - self.BrakeCylinderPressure) * 1, nil, 2) end
    end

    if EPMPressure > PMPressure then --Работа П1
        targetPressure = EPMPressure
    else
        targetPressure = PMPressure
    end

    self.DisableScheme = not Train.BUV:Get("Slope") and self.BrakeCylinderPressure > 0.6 or self.BrakeCylinderPressure > 1.8 + self.BrakeCylinderRegulationError + self.WeightLoadRatio * 0.4
    --end
    ----------------------------------------------------------------------------
    -- Fill brake cylinders
    if Train.K31.Value == 1 then
        if math.abs(self.BrakeCylinderPressure - targetPressure) > 0.150 then self.BrakeCylinderValve = 1 end
        if math.abs(self.BrakeCylinderPressure - targetPressure) < 0.001 then self.BrakeCylinderValve = 0 end
        local pneumaticValveConsumption_dPdT = 0
        trainLineConsumption_dPdT = trainLineConsumption_dPdT + math.max(0, pneumaticValveConsumption_dPdT)
        if self.BrakeCylinderValve == 1 then self:equalizePressure(dT, "BrakeCylinderPressure", math.min(3.8, targetPressure), 6, 2.5, nil, self.BrakeCylinderPressure > targetPressure and 0.3 + math.Clamp((self.BrakeCylinderPressure - 0.0) / 3.3, 0, 0.6) or 0.9) end
    else
        self:equalizePressure(dT, "BrakeCylinderPressure", 0.0, 2.00)
    end

    local PBPressure = math.Clamp(self.TrainLinePressure / 2, 0, 1) * self.TrainLinePressure --3.01
    --[[
    if Train:ReadTrainWire(11) == 1 or Train.K23.Value == 0 then
        self:equalizePressure(dT,"ParkingBrakePressure", math.min(0,PBPressure), 0.33, 0.33, nil, 1.3)--0.15
    elseif Train:ReadTrainWire(31) == 1 then       --if Train:ReadTrainWire(27) > 0 then
        self:equalizePressure(dT,"ParkingBrakePressure", (PBPressure), 0.33, 0.33, nil, 1.3)
    end
    ]]
    if not self.ParkingBrake and (Train:ReadTrainWire(11) == 1 or Train.K23.Value == 0) then
        self.ParkingBrake = true
        --self:equalizePressure(dT,"ParkingBrakePressure", math.min(0,PBPressure), 0.33, 0.33, nil, 1.3)--0.15
    elseif self.ParkingBrake and (Train:ReadTrainWire(31) == 1) then
        --if Train:ReadTrainWire(27) > 0 then
        self.ParkingBrake = false
        --self:equalizePressure(dT,"ParkingBrakePressure", (PBPressure), 0.33, 0.33, nil, 1.3)
    end

    self:equalizePressure(dT, "ParkingBrakePressure", self.ParkingBrake and math.min(0, PBPressure) or PBPressure, 0.33, 0.33, nil, 1.3)
    Train:SetPackedRatio("ParkingBrakePressure_dPdT", self.ParkingBrakePressure_dPdT + 0.02)
    trainLineConsumption_dPdT = trainLineConsumption_dPdT + math.max(0, self.BrakeCylinderPressure_dPdT + self.ParkingBrakePressure_dPdT)
    self.Train:SetPackedRatio("BrakeCylinderPressure_dPdT", self.BrakeCylinderPressure_dPdT)
    -- Simulate cross-feed between different wagons
    self:UpdatePressures(Train, dT)
    ----------------------------------------------------------------------------
    -- Simulate compressor operation and train line depletion
    self.TrainLinePressure = self.TrainLinePressure - 0.05 * trainLineConsumption_dPdT * dT -- 0.190 --0.170
    --self:equalizePressure(dT,"TrainLinePressure", 8.0, 0.7) --TEMP
    --print(self.BrakeLinePressure)
    self:equalizePressure(dT, "TrainLinePressure", 0, 0.001)
    -- Overpressure
    if self.TrainLinePressure > 9 then self.TrainLineOverpressureValve = true end
    if self.TrainLineOverpressureValve then
        --self:equalizePressure(dT,"TrainLinePressure", 0.0, 0.2)
        self:equalizePressure(dT, "TrainLinePressure", 0.0, 0.05)
        self.TrainLineOpen = true
        if self.TrainLinePressure < 7.2 then self.TrainLineOverpressureValve = false end
    end

    --self.SD2 = 1-Train:ReadTrainWire(34)
    ----------------------------------------------------------------------------
    -- FIXME
    Train:SetNW2Bool("FbI", Train.FrontBrakeLineIsolation.Value ~= 0)
    Train:SetNW2Bool("RbI", Train.RearBrakeLineIsolation.Value ~= 0)
    Train:SetNW2Bool("FtI", Train.FrontTrainLineIsolation.Value ~= 0)
    Train:SetNW2Bool("RtI", Train.RearTrainLineIsolation.Value ~= 0)
    Train:SetNW2Bool("AD", Train.K31.Value == 0)
    --if CurTime()%10 > 9.9 then
    --ulx.fancyLog("ТМ-#.2f атм.НМ-#.2f атм.ТЦ-#.2f атм", self.BrakeLinePressure, self.TrainLinePressure, self.BrakeCylinderPressure)
    --end

    -- BackwardsCompat
    local BUD = self.Train.BUD
    self.DoorLeft = BUD.DoorLeft
    self.DoorRight = BUD.DoorRight
    self.CloseDoors = BUD.CloseDoors
    self.LeftDoorState = BUD.LeftDoorState
    self.RightDoorState = BUD.RightDoorState
    self.LeftDoorDir = BUD.LeftDoorDir
    self.RightDoorDir = BUD.RightDoorDir
    self.LeftDoorSpeed = BUD.LeftDoorSpeed
    self.RightDoorSpeed = BUD.RightDoorSpeed
    self.DoorSpeedMain = BUD.DoorSpeedMain
    for i = 1, #self.LeftDoorSpeed do
        self.LeftDoorSpeed[i] = BUD.LeftDoorSpeed[i]
        self.RightDoorSpeed[i] = BUD.RightDoorSpeed[i]
    end
end