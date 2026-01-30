--------------------------------------------------------------------------------
-- Пневматическая система 81-760Э
--------------------------------------------------------------------------------
Metrostroi.DefineSystem("81_760E_Pneumatic")
TRAIN_SYSTEM.DontAccelerateSimulation = true
function TRAIN_SYSTEM:Initialize(is722)
    -- (013)
    -- 1 Accelerated charge
    -- 2 Normal charge (brake release)
    -- 3 Closed
    -- 4 Service application
    -- 5 Emergency application
    self.DriverValvePosition = 6
    self.RealDriverValvePosition = self.DriverValvePosition
    -- Pressure in parking brake
    self.ParkingBrakePressure = 0
    self.AirDistributorPressure = 0
    -- Pressure in reservoir
    self.ReservoirPressure = 0.0 -- atm
    -- Pressure in trains feed line
    self.TrainLinePressure = 8.0 -- atm
    self.TLPressure = 8.0 -- atm
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
    self.Train:LoadSystem("DriverValveTLDisconnect", "Relay", "Switch", {
        normally_closed = true --кран нм
    })

    self.Train:LoadSystem("DriverValveBLDisconnect", "Relay", "Switch") --кран тм	
    self.Train:LoadSystem("K31", "Relay", "Switch", {
        normally_closed = true --ВР
    })

    self.Train:LoadSystem("K23", "Relay", "Switch", {
        normally_closed = true --подача нм к стояночным и отпуск стояночной камеры
    })

    self.Train:LoadSystem("K9", "Relay", "Switch", {
        normally_closed = true --РВТБ
    })

    self.Train:LoadSystem("K29", "Relay", "Switch") --КРМШ
    self.Train:LoadSystem("SD2", "Relay", "Switch")
    self.V4 = 0 --Включение РУ
    self.V6 = false --Срыв от АРС(РВТБ)
    self.K1 = false
    self.K2 = false
    --self.SD2 = 1
    --self.SD3 = false
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
    self.DriverValveDisconnectPrevious = 0
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

    --self.LeftDoorBr = {false,false,false,false}
    --self.RightDoorBr = {false,false,false,false}	
    self.PlayOpen = 1e9
    self.PlayClosed = 1e9
    self.TrainLineOpen = false
    self.ParkingBrake = false
    self.EmergencyValve = false
    self.EmergencyValveEPK = false
    self.OldValuePos = self.DriverValvePosition
    self.CompressorVal = 1
    self.MaxPosition = 6
    self.RVTBLeak = 0
    self.DisconnectType = false
    self.PrevLeak = 0
    self.WeightLoadRatio = 0
    self.EmerBrakeWork = false
    self.BrakeCylinderRegulationError = (math.random() > 0.5 and 1 or -1) * math.random() * 0.09
end

function TRAIN_SYSTEM:Inputs()
    return {"BrakeUp", "BrakeDown", "BrakeSet", "Autostop", "DisconnectType", "MaxPosition"}
end

function TRAIN_SYSTEM:Outputs()
    return {
        "BrakeLinePressure",
        "BrakeCylinderPressure",
        "DriverValvePosition",
        "EmerBrakeWork",
        "ReservoirPressure", --,"SD2" }
        "TrainLinePressure",
        "DoorLinePressure",
        "WeightLoadRatio"
    }
end

function TRAIN_SYSTEM:TriggerInput(name, value)
    if name == "BrakeSet" then
        self.DriverValvePosition = math.floor(value)
        if self.DriverValvePosition < 1 then self.DriverValvePosition = 1 end
        if self.DriverValvePosition > self.MaxPosition then self.DriverValvePosition = self.MaxPosition end
    elseif name == "MaxPosition" then
        self.MaxPosition = value > 0.5 and 7 or 6
    elseif name == "DisconnectType" then
        self.DisconnectType = value > 0.5
    elseif (name == "BrakeUp") and (value > 0.5) then
        if self.MaxPosition == 6 or self.Train.CouchCapR then self:TriggerInput("BrakeSet", self.DriverValvePosition + 1) end
    elseif (name == "BrakeDown") and (value > 0.5) then
        if self.MaxPosition == 6 or self.Train.CouchCapR then self:TriggerInput("BrakeSet", self.DriverValvePosition - 1) end
    elseif name == "Autostop" then
        self.EmergencyValve = self.Train.UAVA.Value == 0
        if self.EmergencyValve and value > 0 then RunConsoleCommand("say", "Autostop braking", self.Train:GetDriverName()) end
    elseif name == "Spawned" then
        -- Костыль для облегчения "напряжения" состава после спавна
        self.Spawned = CurTime()
    end
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
    local V4 = Train.BUKP and (Train.K29.Value == 1 or self.V4 and Train.Electric.V2 > 0)
    self.V6 = Train.BUKP and (Train.K29.Value == 1 and (Train.Electric.Battery80V > 62 and 1 or 0) * (Train.RV["KRO1-2"] + Train.RV["KRR1-2"] == 0 and 0 or 1) == 0)
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
    if Train.BUKP then
        self.V4 = Train.Electric.Battery80V > 62 and (Train.Electric.V2 * Train.BUKP.Active > 0)
    end

    local wagc = Train:GetWagonCount()
    local pr_speed = 1.25 * wagc --2
    if self.Leak or self.BraieLineOpen then pr_speed = pr_speed * 0.4 end
    local BLDisconnect = self.DisconnectType and Train.DriverValveBLDisconnect.Value > 0
    local TLDisconnect = self.DisconnectType and Train.DriverValveTLDisconnect.Value > 0
    if self.MaxPosition == 7 then
        if TLDisconnect then
            self.TLPressure = math.min(self.TrainLinePressure, self.TLPressure + 2 * dT)
            --print(math.Rand(0.3,0.5))
        else
            self.TLPressure = math.max(0, self.TLPressure - 0.5 * dT)
        end
    end

    -- 013: 1 Overcharge tm=nm
    if (self.DriverValvePosition == 1) and (V4 or BLDisconnect and (TLDisconnect or self.BrakeLinePressure > self.TrainLinePressure)) and self.RVTBLeak == 0 then
        self:equalizePressure(dT, "BrakeLinePressure", self.TrainLinePressure, pr_speed)
        trainLineConsumption_dPdT = trainLineConsumption_dPdT + math.max(0, self.BrakeLinePressure_dPdT)
    end

    -- 013: 2 Normal pressure 5.2 81-760
    if (self.DriverValvePosition == 2) and (V4 or BLDisconnect and (TLDisconnect or self.BrakeLinePressure > 1.01 * math.min(5.1, self.TrainToBrakeReducedPressure))) and self.RVTBLeak == 0 then
        self:equalizePressure(dT, "BrakeLinePressure", 1.01 * math.min(5.1, self.TrainToBrakeReducedPressure), pr_speed, nil, 8.0)
        trainLineConsumption_dPdT = trainLineConsumption_dPdT + math.max(0, self.BrakeLinePressure_dPdT)
    end

    -- 013: 3 4.3 Atm  4.4 81-760
    if (self.DriverValvePosition == 3) and (V4 or BLDisconnect and (TLDisconnect or self.BrakeLinePressure > 1.01 * math.min(4.3, self.TrainToBrakeReducedPressure))) and self.RVTBLeak == 0 then
        self:equalizePressure(dT, "BrakeLinePressure", 1.01 * math.min(4.3, self.TrainToBrakeReducedPressure), pr_speed, nil, 8.0)
        trainLineConsumption_dPdT = trainLineConsumption_dPdT + math.max(0, self.BrakeLinePressure_dPdT)
    end

    -- 013: 4 4.0 Atm  4.1 81-760
    if (self.DriverValvePosition == 4) and (V4 or BLDisconnect and (TLDisconnect or self.BrakeLinePressure > 1.01 * math.min(4.0, self.TrainToBrakeReducedPressure))) and self.RVTBLeak == 0 then
        self:equalizePressure(dT, "BrakeLinePressure", 1.01 * math.min(4.0, self.TrainToBrakeReducedPressure), pr_speed, nil, 8.0)
        trainLineConsumption_dPdT = trainLineConsumption_dPdT + math.max(0, self.BrakeLinePressure_dPdT)
    end

    -- 013: 5 3.7 Atm  3.8 81-760
    if (self.DriverValvePosition == 5) and (V4 or BLDisconnect and (TLDisconnect or self.BrakeLinePressure > 1.01 * math.min(3.7, self.TrainToBrakeReducedPressure))) and self.RVTBLeak == 0 then
        self:equalizePressure(dT, "BrakeLinePressure", 1.01 * math.min(3.7, self.TrainToBrakeReducedPressure), pr_speed, nil, 8.0)
        trainLineConsumption_dPdT = trainLineConsumption_dPdT + math.max(0, self.BrakeLinePressure_dPdT)
    end

    -- 013: 6 3.0 Atm  3.1 81-760
    if (self.DriverValvePosition == 6) and (V4 or BLDisconnect and (TLDisconnect or self.BrakeLinePressure > 1.01 * math.min(3.0, self.TrainToBrakeReducedPressure))) and self.RVTBLeak == 0 then
        self:equalizePressure(dT, "BrakeLinePressure", 1.01 * math.min(3.0, self.TrainToBrakeReducedPressure), pr_speed, nil, 8.0)
        trainLineConsumption_dPdT = trainLineConsumption_dPdT + math.max(0, self.BrakeLinePressure_dPdT)
    end

    -- 013: 7 0.0 Atm рвтб
    if self.RVTBLeak == 1 and V4 then
        self:equalizePressure(dT, "BrakeLinePressure", 0.25, pr_speed, nil, 8.0)
        trainLineConsumption_dPdT = trainLineConsumption_dPdT + math.max(0, self.BrakeLinePressure_dPdT)
    end

    if (self.DriverValvePosition == 7) and (V4 or BLDisconnect) then
        self:equalizePressure(dT, "BrakeLinePressure", 0.0, pr_speed, nil, 8.0)
        trainLineConsumption_dPdT = trainLineConsumption_dPdT + math.max(0, self.BrakeLinePressure_dPdT)
    end

    local pr_speed = 1.25 * wagc
    self.Leak = false
    if Train.BARS then
        local leak = 0
        if self.EmergencyValve then
            local leakst = 1.45 * Train:GetWagonCount() --*(Train:GetWagonCount())
            leak = self:equalizePressure(dT, "BrakeLinePressure", 0.0, leakst, false, false, 0.4)
            if Train.UAVA.Value > 0 or self.BrakeLinePressure < 0.6 then --[[leak > -0.7*(Train:GetWagonCount()) or]]
                self.EmergencyValve = false
            end

            if not self.EmergencyValveWasOpen then
                Train:SetPackedRatio("EmerValveAutost", CurTime() + 1.65)
                self.EmergencyValveWasOpen = true
            end

            self.Leak = true
        elseif self.EmergencyValveWasOpen then
            self.EmergencyValveWasOpen = false
        end

        self.Train:SetPackedRatio("EmergencyValve_dPdT", -leak)
        local leak = 0
        if (Train.BARS.RVTB == 0 or not Train.BARS.UOS and Train.BUKP.State < 5 and Train.ALS.Value == 0 and (Train.RV.KROPosition + Train.RV.KRRPosition ~= 0)) and not self.RVTBTimer then
            self.RVTBTimer = CurTime()
        elseif (Train.BARS.RVTB > 0 and not (not Train.BARS.UOS and Train.BUKP.State < 5 and Train.ALS.Value == 0 and (Train.RV.KROPosition + Train.RV.KRRPosition ~= 0))) and self.RVTBTimer then
            self.RVTBTimer = nil
        end

        if self.V4 ~= self.PrevV4 and (self.RVTBTimer and CurTime() - self.RVTBTimer) then
            self.RVTBTimer = CurTime()
            self.PrevV4 = self.V4
        end

        if Train.K9.Value == 1 and (V4 and self.RVTBTimer and CurTime() - self.RVTBTimer > 0 or self.V6 or V4 and Train.PpzRvtb.Value == 0) then
            self.RVTBLeak = 1
            leak = self:equalizePressure(dT, "BrakeLinePressure", 0.0, 3 * Train:GetWagonCount(), false, false, 0.55)
            if self.PrevLeak ~= 1 then
                Train:PlayOnce("epk_brake_open", "", -leak / 3, 1)
                self.PrevLeak = 1
            end

            self.Leak = true
            self.leak = leak
        else
            self.RVTBLeak = 0
            if self.PrevLeak ~= 0 then
                Train:PlayOnce("epk_brake_close", "", -self.leak / 3, 1)
                self.PrevLeak = 0
            end
        end

        --print((Train.BARS.RVTB == 0 and self.V4) and self.RVTBTimer)
        self.Train:SetPackedRatio("EmergencyValveEPK_dPdT", -leak)
    end

    local leak = 0
    if self.Train.EmergencyBrakeValve.Value > 0.5 then
        leak = self:equalizePressure(dT, "BrakeLinePressure", 0.0, 2.2 * wagc, false, false, 1)
        --if not self.EmerLeakTimer then self.EmerLeakTimer = CurTime()+3.76 end
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
    if Power ~= self.Power then
        self.Power = Power
        if self.Power then self.CompressorVal = 0 end
    end

    self:equalizePressure(dT, "AirDistributorPressure", math.Clamp((from - self.BrakeLinePressure) / (from - 3.2), 0, 1) * (2.3 + self.BrakeCylinderRegulationError + self.WeightLoadRatio * 1.3), 2.50, 2.50, nil, 1.3)
    self.EmergencyBrakeActive = Train:ReadTrainWire(25) * Train:ReadTrainWire(26) == 0 --*Train.Electric.Battery80V*Train:ReadTrainWire(35) < 62--[[or self.EmerBrake == 3 or Train.BUV.BTB]]
    self.BTBReady = self.AirDistributorPressure > (2.3 + self.BrakeCylinderRegulationError + self.WeightLoadRatio * 1.3) - 0.05
    if self.EmergencyBrakeActive or self.EmerBrake == 3 then
        PMPressure = self.AirDistributorPressure
        if self.BrakeCylinderPressure < self.AirDistributorPressure and self.AirDistributorPressure - self.BrakeCylinderPressure > 0.1 then self:equalizePressure(dT, "AirDistributorPressure", 0, (self.AirDistributorPressure - self.BrakeCylinderPressure) * 1, (self.AirDistributorPressure - self.BrakeCylinderPressure) * 1, nil, 2) end
    end

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
                    EPMPressure = 1.6 + self.BrakeCylinderRegulationError + self.WeightLoadRatio * 0.5 --2 уставка
                elseif self.EmerBrake > 0 then
                    EPMPressure = 1.0 + self.BrakeCylinderRegulationError + self.WeightLoadRatio * 0.4 --1 уставка
                end
            elseif self.EmerBrake > 0 then
                self.EmerBrake = 0
            end
        else
            if self.EmerBrake > 0 then self.EmerBrake = 0 end
            if Train.BUV.PN3 then
                EPMPressure = 2.4 + self.BrakeCylinderRegulationError + self.WeightLoadRatio * 0.5 --3 уставка
            elseif Train.BUV.PN2 then
                EPMPressure = 1.6 + self.BrakeCylinderRegulationError + self.WeightLoadRatio * 0.5 --2 уставка
            elseif Train.BUV.PN1 then
                EPMPressure = 1.0 + self.BrakeCylinderRegulationError + self.WeightLoadRatio * 0.4 --1 уставка
            end
        end
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
    if Train:ReadTrainWire(27) > 0 and (Train.K23.Value ~= self.PrevK23 or math.Round(self.ParkingBrakePressure,1) == math.Round(self.TrainLinePressure,1) or math.Round(self.ParkingBrakePressure,1) == 0) then
        self.RVPB = (Train.BUV:Get("RVPB") and Train.Electric.Battery80V > 62 or self.TrainLinePressure < 3.8 or Train.K23.Value == 0)
        if Train.K23.Value ~= self.PrevK23 then
            self.PrevK23 = Train.K23.Value
        end
    end	]]
    if not self.ParkingBrake and (Train:ReadTrainWire(11) == 1 or Train.K23.Value == 0) then
        self.ParkingBrake = true
        --self:equalizePressure(dT,"ParkingBrakePressure", math.min(0,PBPressure), 0.33, 0.33, nil, 1.3)--0.15
    elseif self.ParkingBrake and (Train:ReadTrainWire(31) == 1) then
        self.ParkingBrake = false
        --self:equalizePressure(dT,"ParkingBrakePressure", (PBPressure), 0.33, 0.33, nil, 1.3)
    end

    self:equalizePressure(dT, "ParkingBrakePressure", self.ParkingBrake and math.min(0, PBPressure) or PBPressure, 0.4, 0.4, nil, 1.3)
    Train:SetPackedRatio("ParkingBrakePressure_dPdT", self.ParkingBrakePressure_dPdT + 0.02)
    trainLineConsumption_dPdT = trainLineConsumption_dPdT + math.max(0, self.BrakeCylinderPressure_dPdT + self.ParkingBrakePressure_dPdT)
    self.Train:SetPackedRatio("BrakeCylinderPressure_dPdT", self.BrakeCylinderPressure_dPdT)
    -- Simulate cross-feed between different wagons
    self:UpdatePressures(Train, dT)
    ----------------------------------------------------------------------------
    -- Simulate compressor operation and train line depletion
    if Train.Electric.MK ~= self.PrevCompressor then
        self.PrevCompressor = Train.Electric.MK
        self.CompressorVal = 1
    end

    if self.Compressor ~= (Train.BUV.PSN and self.CompressorVal == 1 and Train.Electric.MK > 0) then
        local val = Train.BUV.PSN and self.CompressorVal == 1 and Train.Electric.MK > 0 --Train.KK.Value * ((not Train.Electric or Train.Electric.Power750V > 550) and 1 or 0)
        if val and not self.Compressor then
            self.Compressor = CurTime() + 5
        elseif not val and self.Compressor then
            self.Compressor = nil
        end

        if self.Compressor and CurTime() - self.Compressor > 0 and not self.CompressorOver1 then self.CompressorOver1 = self.CompressorOver end
        if not self.Compressor and self.CompressorOver1 and self.CompressorOver > 0.04 and (self.CompressorOver - (self.CompressorOver1 or 0) < 0 or self.CompressorOver - (self.CompressorOver1 or 0) > 0.04) then
            Train:PlayOnce("compressor_pn" .. math.random(1, 2), "cabin", 1, 1)
            self.CompressorOver1 = nil
        end
    end

    self.CompressorOver = self.CompressorOver or 0
    if self.Compressor and CurTime() - self.Compressor > 0 then
        self.CompressorOver = self.CompressorOver + math.random(0.0215, 0.0235) * dT
        --print(self.CompressorOver)
        if self.CompressorOver >= 1 then --and Train.SF34.Value > 0.5 then --Train.SF54.Value > 0.5 and self.CompressorOver >= 1 then
            self.CompressorOver = 0
            Train:PlayOnce("compressor_pn" .. math.random(1, 2), "cabin", 1, 1)
        end
    end

    local Ratio = 29 / 400
    self.TrainLinePressure = self.TrainLinePressure - 0.05 * trainLineConsumption_dPdT * dT -- 0.190 --0.170
    if self.Compressor and CurTime() - self.Compressor > 0 then self:equalizePressure(dT, "TrainLinePressure", 10.0, 0.039) end
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

    if Train.RV and Train.RV.KROPosition + Train.RV.KRRPosition ~= 0 then
        --print(self.SD2,Train:ReadTrainWire(34))
        if Train.Electric.SD == 0 then
            --if self.BrakeLinePressure <= 2.6 and self.SD2~=1 then self.SD2 = 1 end
            --if self.BrakeLinePressure >= 2.8 and self.SD2~=0 then self.SD2 = 0 end
            Train.SD2:TriggerInput("Close", self.BrakeLinePressure < 2.6)
            Train.SD2:TriggerInput("Open", self.BrakeLinePressure > 2.8)
        elseif Train.SD2.Value ~= 0 then
            Train.SD2:TriggerInput("Close", 1)
        end

        Train.SD3:TriggerInput("Close", self.BrakeLinePressure < 1.9)
        Train.SD3:TriggerInput("Open", self.BrakeLinePressure > 2.1)
    else
        --Train.SD2:TriggerInput("Set",1-Train:ReadTrainWire(34))
        if Train.SD3 and Train.SD3.Value ~= 1 then Train.SD3:TriggerInput("Close", 1) end
        --self.SD2 = 1-Train:ReadTrainWire(34)
    end

    if Power then
        Train.AK:TriggerInput("Open", self.TrainLinePressure > 8.0)
        Train.AK:TriggerInput("Close", self.TrainLinePressure < 6.5)
    end

    ----------------------------------------------------------------------------
    -- FIXME
    Train:SetNW2Bool("FbI", Train.FrontBrakeLineIsolation.Value ~= 0)
    Train:SetNW2Bool("RbI", Train.RearBrakeLineIsolation.Value ~= 0)
    Train:SetNW2Bool("FtI", Train.FrontTrainLineIsolation.Value ~= 0)
    Train:SetNW2Bool("RtI", Train.RearTrainLineIsolation.Value ~= 0)
    Train:SetNW2Bool("AD", Train.K31.Value == 0)
    self.Timer = self.Timer or CurTime()
    if (CurTime() - self.Timer > 0.10) and (self.DriverValvePosition > self.RealDriverValvePosition) then
        self.Timer = CurTime()
        self.Train:PlayOnce("br_013", "cabin")
        self.RealDriverValvePosition = self.RealDriverValvePosition + 1
    end

    if (CurTime() - self.Timer > 0.10) and (self.DriverValvePosition < self.RealDriverValvePosition) then
        self.Timer = CurTime()
        self.Train:PlayOnce("br_013", "cabin")
        self.RealDriverValvePosition = self.RealDriverValvePosition - 1
    end

    if self.V4Previous ~= V4 then
        self.V4Previous = V4
        if not V4 then
            self.V4OffTimer = CurTime()
            self.Train:PlayOnce("pneumo_disconnect_close", "cabin")
        else
            self.V4OffTimer = nil
            self.Train:PlayOnce("pneumo_disconnect_open", "cabin")
        end
    end

    if self.V4OffTimer then
        if CurTime() - self.V4OffTimer < 0.45 then
            local pr_speed = 1.25 * wagc --1.25*(Train:GetWagonCount()) --2
            self:equalizePressure(dT, "BrakeLinePressure", 0, pr_speed)
        else
            self.V4OffTimer = nil
        end
    end

    if self.Spawned and (CurTime() - self.Spawned) >= 4 then
        if (CurTime() - self.Spawned) >= 6 then
            self.Spawned = nil
        else
            self.BrakeCylinderPressure = 0
        end
    end

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