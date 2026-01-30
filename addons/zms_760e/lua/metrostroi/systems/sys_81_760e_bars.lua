--------------------------------------------------------------------------------
-- БАРС для 81-722
--------------------------------------------------------------------------------
Metrostroi.DefineSystem("81_760E_BARS")
TRAIN_SYSTEM.DontAccelerateSimulation = true
function TRAIN_SYSTEM:Initialize()
    self.Train:LoadSystem("ALSCoil")
    -- Internal state
    self.Active = 0
    self.SpeedLimit = 0
    self.NextLimit = 0
    self.Ring = 0
    self.Overspeed = false
    self.Brake = false
    self.Brake2 = false
    self.Drive = 0
    self.Drive1 = 0
    self.Drive2 = 0
    self.Braking = false
    self.LN = false
    self.StillBrake = 0
    self.PN1 = 0
    self.PN2 = 0
    self.PN3 = 0
    self.BTB = 0
    self.BTBReady = 0
    self.RVTB = 0
    self.BINoFreq = 0
    self.RVTBResetTimer = CurTime()
    self.RVTBReset = true
    self.KBApply = true
    self.AB = false
    self.NextNoFreq = false
    self.Speed1 = 0
end

function TRAIN_SYSTEM:Outputs()
    return {"Active", "Ring", "Brake", "Brake2", "Drive", "PN1", "PN2", "StillBrake", "UOS", "SpeedLimit", "BTB", "BINoFreq", "UOS", "AB", "NextNoFq", "BadFq"}
end

function TRAIN_SYSTEM:Inputs()
    return {}
end

function TRAIN_SYSTEM:TriggerInput(name, value)
end

function TRAIN_SYSTEM:Think(dT)
    local Train = self.Train
    local ALS = Train.ALSCoil
    local ALSVal = Train.ALS.Value * (Train.ALSVal == 2 and 1 or 0) * Train.PpzUpi.Value
    local UOS = (Train.PmvAtsBlock.Value == 3) and (Train.RV["KRO5-6"] == 0 or Train.RV["KRR15-16"] > 0) --and ALSVal == 0
    local EnableALS = Train.Electric.Battery80V > 62 and (1 - Train.RV["KRO5-6"]) + Train.RV["KRR15-16"] > 0
    local DAU = Train.PmvFreq.Value == 0
    local TwoToSix = Train.PmvFreq.Value > 0
    if EnableALS ~= (ALS.Enabled == 1) then ALS:TriggerInput("Enable", EnableALS and 1 or 0) end

    -- Kolhoz tipa 81-765 (skoree vsego huinya)
    self.BarsPower = Train.Electric.Battery80V > 62 and (Train.RV["KRO5-6"] == 0 or Train.RV["KRR15-16"] > 0)
    self.ATS1Bypass = not self.BarsPower or UOS or Train.PmvAtsBlock.Value == 2
    self.ATS2Bypass = not self.BarsPower or UOS or Train.PmvAtsBlock.Value == 1
    self.ATS1 = self.BarsPower and (self.ATS1Bypass or Train.PpzAts1.Value > 0.5)
    self.ATS2 = self.BarsPower and (self.ATS2Bypass or Train.PpzAts2.Value > 0.5)

    local PowerALS = self.ATS1 or self.ATS2
    local Power = self.ATS1 and self.ATS2 and ALSVal == 0

    self.NoFreq = not self.AB and ALS.NoFreq > 0
    self.BINoFreq = not self.AB and 0 or ALS.NoFreq
    self.F1 = ALS.F1 > 0 and not self.NoFreq
    self.F2 = ALS.F2 > 0 and not self.NoFreq
    self.F3 = ALS.F3 > 0 and not self.NoFreq
    self.F4 = ALS.F4 > 0 and not self.NoFreq
    self.F5 = ALS.F5 > 0 and not self.NoFreq
    self.F6 = ALS.F6 > 0 and not self.NoFreq
    self.RealF5 = self.F5 and not self.F4 and not self.F3 and not self.F2 and not self.F1
    self.NoFreq = self.NoFreq or not self.AB and (not self.F1 and not self.F2 and not self.F3 and not self.F4 and not self.F5)
    self.UOS = false
    self.UOSActive = false

    local speed = 99
    if Train.BUIK.State > 0 then
        self.Speed1 = math.Round(ALS.Speed * 10) / 10
        speed = self.Speed1
    elseif Train.BUKP.State == -1 then
        speed = 99
        self.Speed1 = 99
    elseif self.Speed1 > 2 then
        speed = self.Speed1
    end

    self.Speed = speed
    if ALSVal ~= self.PrevALS then
        if ALSVal == 0 and self.Speed < self.SpeedLimit + 0.2 then
            self.Ready = true
            self.ReadyTimer = nil
        end

        self.PrevALS = ALSVal
    end

    -- ARS system placeholder logic
    self.KB = Train.PB.Value > 0.5 or Train.Attention.Value > 0.5
    self.KVT = Train.AttentionBrake.Value > 0.5 or self.KB
    if self.KVT then self.KVTTimer = CurTime() + 1 end
    if self.KVTTimer and CurTime() - self.KVTTimer > 0 then self.KVTTimer = false end

    self.Drive1 = 0
    self.Drive2 = 0

    local Active = Power
    if not self.Ready then Active = false end
    -- if self.RVTB == 0 then self.BTB = 0 end
    local Emer = Train.RV["KRR15-16"] * Train.PpzEmerControls.Value > 0.5
    local KMState = Train.KV765.Position
    local BUPKMState = Train.BUKP.ControllerState
    if Emer then
        KMState = (Train.EmerX1.Value > 0 or Train.EmerX2.Value > 0) and 20 or 0
        BUPKMState = KMState
    end

    if EnableALS and Train.BUKP.Active > 0 and PowerALS then
        local Vlimit = 0
        if self.F4 then Vlimit = 40 end
        if self.F3 then Vlimit = 60 end
        if self.F2 then Vlimit = 70 end
        if self.F1 or self.AB then Vlimit = 80 end

        self.SpeedLimit = Vlimit + 0.5
        self.NextLimit = Vlimit

        local count = 0
        if self.F1 then
            self.NextLimit = 80
            count = count + 1
        end

        if self.F2 then
            self.NextLimit = 70
            count = count + 1
        end

        if self.F3 then
            self.NextLimit = 60
            count = count + 1
        end

        if self.F4 then
            self.NextLimit = 40
            count = count + 1
        end

        if self.F5 then
            self.NextLimit = 0
            count = count + 1
        end

        if self.AB then
            self.NextLimit = 80
            count = count + 1
        end

        if self.F6 then count = count + 1 end
        self.NextNoFq = not self.AB and (DAU or ((not self.F1 and not self.F2 and not self.F3 and not self.F4 and not self.F5) or TwoToSix and self.LN and count == 1) and not ALS.AO or ALS.AO and not self.F5)
        if TwoToSix and self.F6 and self.SpeedLimit > 21 then self.NextNoFq = false end
        if not TwoToSix and (math.max(20, self.NextLimit) ~= math.max(20, Vlimit) or self.F6) and not self.AB then
            self.SpeedLimit = 0
            self.NextLimit = self.SpeedLimit
            self.NoFreq = true
            self.BINoFreq = 1
        end

        if TwoToSix and self.F4 and self.F6 then self.LN = true end
        self.BadFq = (ALS.OneFreq == 1 or ALS.TwoFreq == 1 and not self.LN or self.NoFreq) and TwoToSix and not ALS.AO
        if self.BadFq and (self.F4 or self.F3 or self.F2 or self.F1) then self.SpeedLimit = self.LN and 40 or (self.KB and 20 or 0) end
        if self.SpeedLimit < 20 and self.KB and not ALS.AO then self.SpeedLimit = 20 end
        if self.NextLimit > self.SpeedLimit then self.NextLimit = self.SpeedLimit end
        if DAU or Train.BKL and not TwoToSix then self.NextLimit = nil end
    else
        self.SpeedLimit = 0
        self.NextLimit = 0
    end

    if Active and Train.BUKP.Active > 0 and not UOS then
        if Emer and self.Speed < 1.8 then
            self.BTB = Train.Electric.EmerXod
        end

        local speed = self.Speed * Train.SpeedSign * (Train.BUV.Reverser > 0.5 and 1 or -1)
        local Drive = self.Drive > 0
        local Brake = self.Brake > 0
        local SpeedLimit = self.SpeedLimit
        if TwoToSix and (not self.LN or self.NextLimit == math.max(20, SpeedLimit) and self.F6 == 0) then SpeedLimit = math.min(40, SpeedLimit) end
        if self.KB then SpeedLimit = 20 end
        if self.Speed > SpeedLimit or (self.NoFreq or self.RealF5) and not self.KB and self.Speed > 0.1 or self.Braking and not Brake or ALS.AO and KMState > 0 and self.KB then --or (self.F1 or self.F2 or self.F3 or self.F4) and self.KB and speed > 20
            if not Brake and (SpeedLimit > 20 or self.Speed > 0) then
                self.Braking = CurTime()
                self.PN1Timer = CurTime()
            end

            if not Brake and (SpeedLimit > 20 or self.Speed > 0 or ALS.AO) then self.Ringing = true end
            Brake = true
        elseif (self.Speed < SpeedLimit or self.Speed == 0) and not self.Braking and KMState <= 0 and BUPKMState <= 0 then
            Brake = false
        end

        if (self.Ringing or self.Braking) and self.KVT then
            self.Braking = false
            self.Ringing = false
        end

        if Brake and Train.Acceleration < -0.6 and self.Speed > 0 then self.BrakeEfficiency = CurTime() end
        if (not Brake or math.Round(self.Speed) == 0) and self.BrakeEfficiency then self.BrakeEfficiency = nil end
        if self.BrakeEfficiency and KMState <= 0 and self.Speed < 0.1 then self.BrakeEfficiency = nil end
        if self.PN1Timer and (CurTime() - self.PN1Timer > 1.5 or not Brake) then self.PN1Timer = nil end

        if self.RVTBReset then
            self.RVTB = 1
            self.BTB = 1
            self.RVTBReset = false
        end
        -- if Train.Pneumatic.RVTBLeak == 0 then self.RVTB = 1 end
        if Train.BUKP.State <= 4 then
            self.RVTB = 0
        end
        self:RecoverableRvtbBegin()

        local KmCur = (KMState > 0 or BUPKMState > 0)
        if self.Speed > SpeedLimit - 1.1 and KmCur then
            if self.PN3 > 0 or not self.KmWas and self.Speed >= SpeedLimit - 0.6 then
                self:RecoverableRvtbSet(CurTime() + 3.2)
                self.PN3 = 1
            else
                self.DisableDrive = true
                self.ControllerInDrive = true
                self.PN3 = 0
            end
        else
            self.PN3 = 0
        end
        self.KmWas = KmCur

        if self.Speed < SpeedLimit - 3 and not KmCur or SpeedLimit < 10 and not KmCur then
            self.DisableDrive = false
            self.ControllerInDrive = false
        end

        if KmCur and speed < 1.8 and not self.NoFreq then
            if not self.NoSpeedTimer then
                self.NoSpeedTimer = CurTime() + (Emer and 5.8 or 3.8)
            elseif CurTime() >= self.NoSpeedTimer then
                self:RecoverableRvtbSet(CurTime())
            end
        else
            self.NoSpeedTimer = nil
        end
        self:RecoverableRvtbEnd()

        if self.ControllerInDrive and (not self.DisableDrive or KMState <= 0) then self.ControllerInDrive = false end
        if self.DisableDrive and not self.ControllerInDrive and KMState > 0 then
            if not self.Braking then self.Braking = CurTime() end
            if not self.PN1Timer then self.PN1Timer = CurTime() end
            if Train:GetNW2Bool("DisableDriveRvtb", true) then
                self.RVTB = 0
            end
            self.Ringing = true
            Brake = true
        end

        if self.Speed < 0.5 and not self.PN1Timer and (KMState <= 0 or self.Drive == 0) and not self.NoFreq then
            self.PN1Timer = CurTime()
        end

        if not Drive and math.abs(speed) > 0.5 then
            if not self.RollingTimer then
                self.RollingTimer = CurTime() + 1
            elseif CurTime() >= self.RollingTimer then
                self.RVTB = 0
            end
        else
            self.RollingTimer = nil
        end

        if ALS.AO then
            self.NoFreq = not DAU and (ALS.F5 == 0)
            if Train.BKL and self.KVT and self.RingingAO then self.RingingAO = false end
            self.Ringing = self.RingingAO
        elseif not self.RingingAO then
            self.RingingAO = true
        end

        local travel = self.Drive > 0 and speed > 0.3 or not self.DisableDrive and self.PN3 < 1 and KmCur
        if travel and self.Drive > 0 then self.TravelTimer = CurTime() + 0.3 end
        if not travel and self.Drive > 0 and self.PN3 < 1 and self.TravelTimer and CurTime() < self.TravelTimer then
            travel = true
        end
        Drive = (
            (self.PN1 + self.PN2 < 1 or travel) and (
                self.Drive > 0 and speed > 0.3 or
                not self.NoFreq and not self.RealF5 or
                (self.NoFreq or self.RealF5) and self.KB
            )
        )
        self.PN1 = (ALS.AO or self.PN1Timer) and 1 or 0
        self.Ring = self.Ringing and 1 or 0
        self.Brake = Brake and 1 or 0
        self.Brake2 = Brake2 and 1 or 0
        self.Drive = Drive and 1 or 0

        if self.BrakeEfficiency and CurTime() - self.BrakeEfficiency >= 3.6 then
            self.RVTB = 0
        end

        if Train.BUKP.State * Train.PpzUpi.Value == 5 then
            if self.BUKPState ~= 5 then
                self.RVTB = 1
                self.BUKPState = 5
            end

        elseif self.BUKPState ~= 0 then
            self.BUKPState = 0
        end

        if Train.PpzPrimaryControls.Value == 0 and Train.RV.KROPosition ~= 0 then self.PN2 = 1 end
        if Train.BUKP.State == 5 then
            if Emer then
                if self.Speed < 1.8 and Drive and (not self.NoSpeedTimer or CurTime() < self.NoSpeedTimer) then
                    self.RVTB = 1
                    self.BTB = 1
                elseif self.Speed < 1.8 then
                    self.RVTB = 0
                    self.BTB = 0
                    self.PN1 = 1
                end

                self.DisableDrive = false
                self.ControllerInDrive = false
                if self.PN1 + self.PN2 > 0 and self.Speed < 0.5 and not Drive then
                    self.BTB = 0
                    self.RVTB = 0
                end

                if self.Brake > 0 then
                    self.RVTB = 0
                    self.BTB = 0
                    self.PN1 = 1
                    self.Ring = 1
                end
            end

            if not Emer then
                if self.Brake > 0 and not self.RVTBTimer then
                    self.RVTBTimer = CurTime() + 5
                end
                if self.RVTBTimer and self.Brake == 0 then self.RVTBTimer = nil end
                if self.RVTBTimer and CurTime() - self.RVTBTimer > 0 then
                    self.RVTB = 0
                end
            end

            if ALS.NoFreq == 1 and EnableALS then
                if not self.ABPressed1 and Train.AB.Value > 0 then self.ABPressed1 = CurTime() end
                if not self.ABPressed2 and self.KVT then self.ABPressed2 = CurTime() end
                if self.ABPressed1 and self.ABPressed2 and math.abs(self.ABPressed1 - self.ABPressed2) < 1 then self.AB = true end
            end

            if ALS.NoFreq == 0 or Train.AB.Value == 0 then self.ABPressed1 = nil end
            if ALS.NoFreq == 0 or not self.KVT then self.ABPressed2 = nil end
            if self.AB and EnableALS and ALS.F1 + ALS.F2 + ALS.F3 + ALS.F4 + ALS.F5 + ALS.F6 > 0 then self.AB = false end

            self.BUKPErr = (
                not Train.BUKP.DoorClosed and Train.DoorBlock.Value < 1 or
                Train.BUKP.Errors.NoOrient or
                Train.BUKP.Errors.EmergencyBrake or
                -- Train.BUKP.Errors.BuvDiscon or
                Train.BUKP.Errors.RvErr
            )
            self.PN3 = (self.PN3 > 0 or (KMState > 0 or self.Speed > 1.8) and self.BUKPErr) and 1 or 0
        end

        self.Drive1 = self.ATS1 and self.Drive or 0
        self.Drive2 = self.ATS2 and self.Drive or 0
    else
        self.BTB = 1
        if self.RVTB == 0 and not self.RVTBReset and not self.RVTBResetTimer then self.RVTBResetTimer = CurTime() end
        if self.RVTBTimer then self.RVTBTimer = nil end
        if not UOS and self.RollingBraking then self.RollingBraking = nil end
        self.BrakeEfficiency = nil
        if not self.RVTBReset and self.RVTB == 1 or self.RVTBResetTimer and CurTime() - self.RVTBResetTimer > 3 then
            self.RVTBReset = true
            self.RVTBResetTimer = nil
        end
        self:RecoverableRvtbReset()

        self.RVTB = (ALSVal > 0.5) and 1 or 0
        if ALSVal > 0 and Train.BUKP.State == 5 and not UOS then
            --[[  Устройства БАРС, или при следовании с отключёнными устройствами БАРС, устройство ограничения скорости (УОС) передают информацию о допустимой скорости и фактической скорости движения поезда в БУП. В зависимости от информации БУП разрешает движение, отключает тяговый режим, выдаёт команду на торможение.]]
            self.PN1 = 0
            self.PN2 = 0
            self.Ring = 0
            self.Brake = 0
            self.Brake2 = 0
            self.Drive = 1
            self.BTB = 1
            self.DisableDrive = false
        elseif UOS then
            self.UOS = true
            self.BTB = 1
            local Speed = self.Speed --math.Round(Train.Speed*10)/10
            if Train.RV["KRO9-10"] * Train.PpzPrimaryControls.Value > 0.5 then
                self.BTB = self.KB and 1 or 0
                if self.KB then
                    self.UOSActive = true
                    self.SpeedLimit = 35.5
                    self.NoFreq = false
                    --[[
                    if TwoToSix then
                        self.SpeedLimit = 35.5
                        self.NoFreq = false
                        --self.NextLimit = 0
                    else
                        self.SpeedLimit = 35.5
                        self.NoFreq = false
                    end]]
                end

                if ALSVal == 0 then
                    if Speed > 35.5 and not self.UOSBraking then
                        --if Speed > self.SpeedLimit and not self.UOSBraking then
                        self.UOSBraking = true
                    elseif Speed == 0 and self.UOSBraking then
                        self.UOSBraking = false
                    end
                elseif self.UOSBraking then
                    self.UOSBraking = false
                end

                if Train.RV.KROPosition > 0 then
                    if Speed < 1.8 and KMState <= 0 then
                        self.RollingBraking = CurTime()
                    elseif KMState > 0 then
                        self.RollingBraking = nil
                    end

                    if self.RollingBraking and KMState > 0 then self.RollingBraking = CurTime() end
                elseif self.RollingBraking then
                    self.RollingBraking = nil
                end

                self.Drive = (self.KB and Train.KAH.Value == 1 and (ALSVal == 1 or Speed < 35.5)) and (KMState > 0 or Speed > 1.8) and 1 or 0
                self.RVTB = (Train.PpzAts2.Value + Train.PpzAts1.Value == 0 or self.RollingBraking and CurTime() - self.RollingBraking > 0 or self.UOSBraking) and 0 or 1
            elseif Train.RV["KRR15-16"] * Train.PpzPrimaryControls.Value > 0.5 then
                if not self.KB then self.BTB = 0 end
                self.UOSActive = self.KB
                self.RVTB = self.KB and 1 or 0
                self.Drive = 1 --(self.KB and 1 or 0)
            else
                self.Drive = 0
                self.BTB = 0
            end

            self.PN1 = 0
            self.PN2 = 0
            self.Brake = 0

            self.Drive1 = self.ATS1 and self.Drive or 0
            self.Drive2 = self.ATS2 and self.Drive or 0
        elseif ALSVal > 0 then
            self.PN2 = 1
        else
            self.BTB = 0
            self.Brake = 0
            self.Drive = 0
            self.Ring = 0
            self.PN1 = 0
            self.PN2 = 0
            self.Drive1 = self.ATS1 and KMState > 0 and 1 or 0
            self.Drive2 = self.ATS2 and KMState > 0 and 1 or 0
        end

        self.Braking = false
        self.Ringing = false
        self.RingingAO = true
        self.LN = Train.BUKP.State > 0 and self.LN
        self.BINoFreq = 1
    end

    if not self.UOS then
        if Train.BUKP.State < 5 or (not Power or Train.BUKP.State < 5) then
            self.BTB = (not UOS and (ALSVal == 1)) and 1 or self.BTB
            self.Ready = false
            self.SBTimer = nil
            self.ReadyTimer = nil
        end

        if Power and not self.Ready and Train.BUKP.Active > 0 and Train.BUKP.State == 5 and not self.ReadyTimer then self.ReadyTimer = CurTime() end
        if self.ReadyTimer and CurTime() - self.ReadyTimer > 0 then
            self.RVTB = 0
        end

        --if Emer then
        if Power and Train.BUKP.State == 5 and (KMState <= 0 and BUPKMState <= 0) and self.Speed < 1.8 then
            --self.BTB = 1
            self.PN1 = 1
            if not self.SBTimer then self.SBTimer = CurTime() end
            self.Ready = true
            if self.ReadyTimer and CurTime() - self.ReadyTimer == 0 then self.ReadyTimer = nil end
            self.PN1T = true
        end

        if Power ~= self.PrevPower and Train.BUKP.State == 5 and KMState <= 0 and self.Speed < 1.8 then
            self.SBTimer = CurTime() - 2
            self.PrevPower = Power
        end

        if Power and Train.BUKP.State == 5 and KMState > 0 and self.PN1T then
            self.PN1T = false
            self.SBTimer = nil
        end

        if Power and Train.BUKP.State == 5 and KMState <= 0 and self.PN1T then self.PN1 = 1 end
        if Power and self.SBTimer and CurTime() - self.SBTimer > 2.5 then
            self.PN1 = 1
            self.StillBrake = 1
        end
    end

    if Power and Train.PpzUpi.Value == 0 and Train.RV.KROPosition ~= 0 then
        self.RVTB = 0
    end

    if self.PN1 + self.PN2 == 0 and self.StillBrake > 0 then self.StillBrake = 0 end

    if Train.Electric.V2 ~= self.ElectricBTB then
        self.RVTB = 1
        self.BTB = 1
        self.ElectricBTB = Train.Electric.V2
    end

    -- SD TB Restore fix
    -- Said to be unrealistic, meaning the SD TB restore behaivor IS realistic, not a bug.
    -- self.BTB = self.BTB * (1 - Train:ReadTrainWire(41))

    self.RVTB = Train.Electric.V2 == 0 and 1 or self.RVTB
    self.Active = Active and 1 or 0
end

function TRAIN_SYSTEM:RecoverableRvtbReset()
    self.CurRvtbOverride = false
    self.RecRvtbTimer = nil
end

function TRAIN_SYSTEM:RecoverableRvtbBegin()
    self.CurRvtbOverride = self.CurRvtbOverride or self.RVTB < 1 and self.CurRvtbReset
    self.CurRvtbReset = not self.CurRvtbOverride
end

function TRAIN_SYSTEM:RecoverableRvtbSet(ts)
    self.RecRvtbTimer = self.RecRvtbTimer and math.min(self.RecRvtbTimer, ts) or ts
    self.CurRvtbReset = false
end

function TRAIN_SYSTEM:RecoverableRvtbEnd()
    if self.CurRvtbReset then
        if self.RVTB < 1 then
            self.RVTBReset = true
        end
        self.RecRvtbTimer = nil
    elseif self.RecRvtbTimer and CurTime() >= self.RecRvtbTimer then
        self.RVTB = 0
        self.RecRvtbTimer = nil
    end
end
