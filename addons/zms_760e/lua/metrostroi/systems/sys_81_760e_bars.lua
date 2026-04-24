--------------------------------------------------------------------------------
-- БАРС для 81-765
-- Автор - ZONT_ a.k.a. enabled person
--------------------------------------------------------------------------------
Metrostroi.DefineSystem("81_760E_BARS")
TRAIN_SYSTEM.DontAccelerateSimulation = true
function TRAIN_SYSTEM:Initialize()
    self.Train:LoadSystem("ALSCoil")
    self.Active = 0
    self.ALSMode = 0
    self.SpeedLimit = 0
    self.NextLimit = 0
    self.Ring = 0
    self.Brake = 0
    self.AllowStart = 0
    self.Drive = 0
    self.Drive1 = 0
    self.Drive2 = 0
    self.LN = false
    self.StillBrake = 0
    self.SbTimer = 0
    self.ZsErrorMargin = math.random() * 0.15 + 0.35
    self.PN1 = 0
    self.PN2 = 0
    self.PN3 = 0
    self.BTB = 0
    self.UOS = 0
    self.RVTB = 0
    self.AO = 0
    self.NextNoFq = false
    self.Ready = false
    self.dV = 0
end

function TRAIN_SYSTEM:Outputs()
    return {"Active", "ALSMode", "Ring", "Brake", "Drive", "Drive1", "Drive2", "AllowStart", "PN1", "PN2", "PN3", "StillBrake", "SpeedLimit", "BTB", "UOS", "NextNoFq", "BadFq", "AO"}
end

function TRAIN_SYSTEM:Inputs()
    return {}
end

function TRAIN_SYSTEM:TriggerInput(name, value)
end

function TRAIN_SYSTEM:Think(dT)
    local Wag = self.Train
    local ALS = Wag.ALSCoil
    local ALSVal = Wag.ALS.Value * (Wag.ALSVal == 2 and 1 or 0) * Wag.PpzUpi.Value
    local UOS = (Wag.PmvAtsBlock.Value == 3) and (Wag.RV["KRO5-6"] == 0 or Wag.RV["KRR15-16"] > 0)
    local EnableALS = Wag.Electric.Battery80V > 62 and (1 - Wag.RV["KRO5-6"]) + Wag.RV["KRR15-16"] > 0
    local DAU = Wag.PmvFreq.Value == 0
    local TwoToSix = Wag.PmvFreq.Value > 0
    if EnableALS ~= (ALS.Enabled == 1) then ALS:TriggerInput("Enable", EnableALS and 1 or 0) end

    -- Kolhoz tipa 81-765 (skoree vsego huinya)
    self.BarsPower = Wag.Electric.Battery80V > 62 and (Wag.RV["KRO5-6"] == 0 or Wag.RV["KRR15-16"] > 0)
    self.ATS1Bypass = not self.BarsPower or UOS or Wag.PmvAtsBlock.Value == 2
    self.ATS2Bypass = not self.BarsPower or UOS or Wag.PmvAtsBlock.Value == 1
    self.ATS1 = self.BarsPower and (self.ATS1Bypass or Wag.PpzAts1.Value > 0.5)
    self.ATS2 = self.BarsPower and (self.ATS2Bypass or Wag.PpzAts2.Value > 0.5)

    local PowerALS = self.ATS1 or self.ATS2
    local Power = self.ATS1 and self.ATS2

    self.NoFreq = ALS.NoFreq > 0
    self.F1 = ALS.F1 > 0 and not self.NoFreq
    self.F2 = ALS.F2 > 0 and not self.NoFreq
    self.F3 = ALS.F3 > 0 and not self.NoFreq
    self.F4 = ALS.F4 > 0 and not self.NoFreq
    self.F5 = ALS.F5 > 0 and not self.NoFreq
    self.F6 = ALS.F6 > 0 and not self.NoFreq
    self.RealF5 = self.F5 and not self.F4 and not self.F3 and not self.F2 and not self.F1
    self.NoFreq = self.NoFreq or (not self.F1 and not self.F2 and not self.F3 and not self.F4 and not self.F5)
    self.UOS = UOS and 1 or 0

    self.Speed = math.Round(ALS.Speed * 10) / 10
    if ALSVal ~= self.PrevALS then
        if ALSVal == 0 and self.Speed < self.SpeedLimit + 0.2 then
            self.Ready = true
            self.ReadyTimer = nil
        end
        self.PrevALS = ALSVal
    end

    self.KB = Wag.PB.Value > 0.5 or Wag.Attention.Value > 0.5
    self.KVT = Wag.AttentionBrake.Value > 0.5 --or self.KB

    local Active = Power and Wag.BUKP.State == 5
    local Emer = Wag.RV["KRR15-16"] * Wag.PpzEmerControls.Value > 0.5
    local KMState = Wag.KV765.Position
    local BUPKMState = Wag.BUKP.ControllerState
    if Emer then
        KMState = (Wag.EmerX1.Value > 0 or Wag.EmerX2.Value > 0) and 20 or 0
        BUPKMState = KMState
    end

    local AO = false

    if EnableALS and Wag.BUKP.Active > 0 and PowerALS then
        local Vlimit = 0
        if self.F4 then Vlimit = 40 end
        if self.F3 then Vlimit = 60 end
        if self.F2 then Vlimit = 70 end
        if self.F1 then Vlimit = 80 end
        self.SpeedLimit = Vlimit + 0.5
        self.NextLimit = Vlimit

        local count = 0
        if self.F1 then self.NextLimit = 80 count = count + 1 end
        if self.F2 then self.NextLimit = 70 count = count + 1 end
        if self.F3 then self.NextLimit = 60 count = count + 1 end
        if self.F4 then self.NextLimit = 40 count = count + 1 end
        if self.F5 then self.NextLimit = 0 count = count + 1 end
        if self.F6 then count = count + 1 end

        local HasAoFeature = self.NoFreq or self.F5
        AO = self.AO == 1 and HasAoFeature

        if HasAoFeature then
            local AoFeature = self.F5 and 1 or 2
            local changed = self.LastAoFeature ~= AoFeature
            self.LastAoFeature = AoFeature
            if self.F5 and not self.WasAlsZero then
                self.WasAlsZero = true
                changed = false
            end
            if self.NoFreq and not self.WasAlsNoFq then
                self.WasAlsNoFq = true
                changed = false
            end
            if self.WasAlsZero and self.WasAlsNoFq and changed then
                AO = true
            end
            if not changed and not self.NoAoFeatureChangeTimer then
                self.NoAoFeatureChangeTimer = CurTime() + 3
            elseif changed and self.NoAoFeatureChangeTimer then
                self.NoAoFeatureChangeTimer = nil
            end
        else
            AO = false
            self.WasAlsZero = false
            self.WasAlsNoFq = false
            self.LastAoFeature = nil
            self.NoAoFeatureChangeTimer = nil
        end

        if AO and self.NoAoFeatureChangeTimer and CurTime() >= self.NoAoFeatureChangeTimer then
            AO = false
            self.WasAlsZero = false
            self.WasAlsNoFq = false
            self.LastAoFeature = nil
            self.NoAoFeatureChangeTimer = nil
        end

        self.NextNoFq = DAU or ((not self.F1 and not self.F2 and not self.F3 and not self.F4 and not self.F5) or TwoToSix and self.LN and count == 1) and not AO or AO and not self.F5
        if TwoToSix and self.F6 and self.SpeedLimit > 21 then self.NextNoFq = false end
        if not TwoToSix and (math.max(20, self.NextLimit) ~= math.max(20, Vlimit) or self.F6) then
            self.SpeedLimit = 0
            self.NextLimit = self.SpeedLimit
            self.NoFreq = true
        end

        if TwoToSix and self.F4 and self.F6 then self.LN = true end
        self.BadFq = (ALS.OneFreq == 1 or ALS.TwoFreq == 1 and not self.LN or self.NoFreq) and TwoToSix and not AO
        if self.BadFq and (self.F4 or self.F3 or self.F2 or self.F1) then self.SpeedLimit = self.LN and 40 or (self.KB and 20 or 0) end
        if self.SpeedLimit < 20 and self.KB and not AO then self.SpeedLimit = 20 end
        if self.NextLimit > self.SpeedLimit then self.NextLimit = self.SpeedLimit end
        if DAU then self.NextLimit = Wag.AlsArs and 0 or nil end
    else
        self.SpeedLimit = 0
        self.NextLimit = 0
    end

    self.AO = AO and 1 or 0

    local forgiveful = Wag:GetNW2Bool("ForgivefulBars", true)

    local Backward = Emer and Wag.RV["KRR13-14"] > 0 or Wag.RV["KRO15-16"] > 0
    local Speed = self.Speed * Wag.SpeedSign * (Backward and -1 or 1)
    local SelfZs = Emer or Wag.BUKP.State ~= 5
    local ZeroSpeed = not SelfZs and Wag.BUKP.ZeroSpeed > 0 or SelfZs and Speed < 1.4

    local RVTB = true
    local BTB = self.RVTB > 0
    local Brake = self.Brake > 0
    local Ring = self.Ring > 0
    local Drive = self.Drive > 0
    local AllowStart = self.AllowStart > 0
    local DisableDrive = self.DisableDrive
    local SpeedLimit = self.SpeedLimit

    self.PN1 = 0
    self.PN2 = 0
    self.PN3 = 0

    self.Drive1 = 0
    self.Drive2 = 0

    local DvMeasured = false

    if self.BarsPower and (Wag.BUKP.State == 5 or UOS) and ALSVal == 0 then
        RVTB = Active or UOS

        if not TwoToSix or not Active or UOS then self.LN = false end

        local KmCur = KMState > 0 or Active and BUPKMState > 0
        if Active and not UOS then
            SpeedLimit = self.KB and not AO and 20 or SpeedLimit

            if Speed > SpeedLimit then
                if not Brake then
                    Ring = SpeedLimit > self.SpeedLimit - 0.5
                    self.PN1Timer = CurTime() + 1.6
                end
                Brake = true
            elseif Brake and not Ring and not KmCur then
                Brake = false
                self.PN1Timer = nil
            end

            if Ring and Drive and not self.KvtTimer then
                self.KvtTimer = CurTime() + 3.5
            end
            if Ring and self.KVT --[[or ZeroSpeed]] then
                Ring = false
            end
            RVTB = RVTB and self:RvtbTimer("KvtTimer", not (Brake and KmCur or not forgiveful and AO))

            if Speed > SpeedLimit - 1.3 and KmCur then
                if not Drive then
                    if not self.TryDriveTimer then
                        self.TryDriveTimer = CurTime() + 3.2
                    end
                elseif not DisableDrive and Speed <= SpeedLimit and not Brake then
                    DisableDrive = true
                    self.ControllerInDrive = true
                end
            end
            RVTB = RVTB and self:RvtbTimer("TryDriveTimer", not KmCur or Speed <= SpeedLimit - 1.3)

            if self.TryDriveTimer or Brake and Speed < 7 then
                self.PN3 = 1
            end

            if Brake and DisableDrive then
                DisableDrive = false
                self.ControllerInDrive = false
            end

            if DisableDrive and not KmCur and (SpeedLimit < 19 or Speed < SpeedLimit - 3.1) then
                DisableDrive = false
                self.ControllerInDrive = false
            elseif self.ControllerInDrive and not KmCur then
                self.ControllerInDrive = false
            end
            if KmCur and DisableDrive and not self.ControllerInDrive then
                if not forgiveful then
                    self.DisableDriveAttempt = CurTime()
                else
                    Brake = true
                end
                Ring = true
            end
            RVTB = RVTB and self:RvtbTimer("DisableDriveAttempt")

            if AO and Drive then
                Brake = true
            end
            if AO then
                if Wag.AttentionBrake.Value > 0.5 then self.RingingAO = false end
                Ring = Ring or self.RingingAO
                if not ZeroSpeed then self.PN3 = 1 end
            else
                self.RingingAO = true
            end

            local AntiRoll = not Drive and math.abs(Speed) > 0.6 or Speed < -0.5
            if AntiRoll then
                if not self.AntirollTimer then
                    self.AntirollTimer = CurTime() + 0.4
                elseif CurTime() > self.AntirollTimer then
                    if self.RVTB == 1 then
                        Ring = true
                        Brake = true
                    end
                end
            end
            RVTB = RVTB and self:RvtbTimer("AntirollTimer", not AntiRoll)

            if not self.NoFreq and KmCur and Speed < 0.8 and not self.NoSpeedTimer then
                self.NoSpeedTimer = CurTime() + (Emer and 6.2 or 4.8)
            end
            RVTB = RVTB and self:RvtbTimer("NoSpeedTimer", self.NoFreq or not KmCur or Speed >= 0.8)

            if self.PrevSpeed and self.PrevDvMeasure then
                self.dV = (Speed - self.PrevSpeed) / (CurTime() - self.PrevDvMeasure)
            end
            self.PrevSpeed = Speed
            self.PrevDvMeasure = CurTime()
            DvMeasured = true

            local BrakeEff = Brake and self.dV > -3.0
            if BrakeEff and not self.BrakeEff then
                self.BrakeEff = CurTime() + 3
                print("Start dV", self.dV)
            end
            RVTB = RVTB and self:RvtbTimer("BrakeEff", not BrakeEff)

            self.BUKPErr = Wag.BUKP.BupDisableDrive > 0
            local EmerGood = Emer and not Wag.BUKP.Errors.RvErr
            local ZsError = not EmerGood and self.BUKPErr and Wag.BUKP.ZeroSpeed < 1 and Speed < 7
            if ZsError then
                ZsError = false
                if not self.ZsErrorTimer then
                    self.ZsErrorTimer = CurTime() + self.ZsErrorMargin + math.Rand(0, 0.2)
                elseif CurTime() >= self.ZsErrorTimer then
                    ZsError = true
                end
            else
                self.ZsErrorTimer = nil
            end

            self.PN3 = (self.PN3 > 0 or ZsError or KmCur and Speed < 7 and not EmerGood and self.BUKPErr) and 1 or 0
        elseif UOS then
            SpeedLimit = self.KB and (TwoToSix and 45 or 80) + 0.5 or 0
            self.SpeedLimit = SpeedLimit
            self.NextLimit = nil
        end

        AllowStart = UOS or (self.KB or not self.NoFreq and not self.RealF5 and not (TwoToSix and not self.LN)) and not AO and not Brake
        local travel = Drive and not self.SbTimer
        if travel then self.TravelTimer = CurTime() + math.Rand(0.27, 0.34) end
        if not travel and Drive and self.TravelTimer and CurTime() < self.TravelTimer then
            travel = true
        end
        Drive = travel or AllowStart and (KmCur or UOS and Speed >= 7)

        if UOS then
            if not Emer and Wag.PpzUpi.Value * Wag.KAH.Value < 1 or Speed > SpeedLimit then
                Drive = false
            end
            if Emer and Speed > SpeedLimit then
                self.UosLimitTimer = CurTime() - 1
                RVTB = false
            end
            BTB = BTB and self.KB and (Speed < 7 or Drive)
            self.PN3 = self.PN3 < 1 and BTB and 0 or 1
        end
        RVTB = RVTB and self:RvtbTimer("UosLimitTimer", true, ZeroSpeed)

        if Emer then
            local EmerCondition = not UOS and Drive and not (Brake and SpeedLimit > 21) or UOS and self.KB
            if not EmerCondition and not self.EmerTimer then
                self.EmerTimer = CurTime()
            end
            RVTB = RVTB and self:RvtbTimer("EmerTimer", EmerCondition, not UOS and ZeroSpeed and AllowStart and KmCur or UOS and self.KB)
        end

        self.RVTB = RVTB and 1 or 0
        self.BTB = BTB and 1 or 0
        self.Brake = Brake and 1 or 0
        self.Ring = Ring and 1 or 0
        self.Drive = Drive and 1 or 0
        self.AllowStart = AllowStart and 1 or 0
        self.DisableDrive = DisableDrive
        self.SpeedLimit = SpeedLimit > self.SpeedLimit and SpeedLimit or self.SpeedLimit

        if Brake then
            self.BrakeTimer = CurTime() + 1
        elseif self.BrakeTimer and CurTime() >= self.BrakeTimer then
            self.BrakeTimer = nil
        end

        self.Drive1 = self.ATS1 and Drive and (not Emer and not UOS or RVTB and BTB) and not self.BrakeTimer and 1 or 0
        self.Drive2 = self.ATS2 and Drive and (not Emer and not UOS or RVTB and BTB) and not self.BrakeTimer and 1 or 0

    elseif ALSVal == 1 then
        -- TODO Some BUKP logic for speed regulation
        self.PN1 = 0
        self.PN2 = 0
        self.PN3 = 0
        self.Ring = 0
        self.Brake = 0
        self.Drive = 1
        self.Drive1 = 1
        self.Drive2 = 1
        self.BTB = 1
        self.RVTB = 1
        self.DisableDrive = false

    else
        self.BTB = 0
        self.Brake = 0
        self.Drive = 0
        self.Ring = 0
        self.PN1 = 0
        self.PN2 = 0
        self.PN3 = 0
        self.Drive1 = 0
        self.Drive2 = 0
        self.RingingAO = true
        self.LN = Wag.BUKP.State > 0 and self.LN
        self.Ready = true
        self.StillBrake = 0
        self.SbTimer = 0
    end

    if not DvMeasured then
        self.PrevSpeed = nil
        self.PrevDvMeasure = nil
    end

    if self.BarsPower and not UOS and ALSVal < 1 then
        if KMState <= 0 and ZeroSpeed then
            if not self.SbTimer then
                self.SbTimer = CurTime()
            elseif self:WhenStops(0) then
                self.StillBrake = 1
            end
        end
        if self.Drive == 1 and (KMState > 0 or BUPKMState > 0) then
            self.StillBrake = 0
            self.SbTimer = nil
        end

        if self.PN1Timer then
            if CurTime() < self.PN1Timer then
                self.PN1 = 1
            elseif not Brake then
                self.PN1Timer = nil
            end
        end
    elseif self.BarsPower then
        self.StillBrake = 0
        self.SbTimer = nil
    end

    if not Emer and Wag.Electric.V2 ~= self.ElectricBTB then
        self.RVTB = 1
        self.BTB = 1
        self.ElectricBTB = Wag.Electric.V2
    end

    self.RVTB = not Emer and Wag.Electric.V2 == 0 and 1 or self.RVTB
    self.Active = (Active or self.BarsPower and UOS) and 1 or 0
    self.ALSMode = ALSVal

    if self.StillBrake > 0 then
        self.PN2 = 1
    end

    if self.PN3 > 0 then
        self.PN3Timer = CurTime() + 0.6
    elseif self.PN3Timer and CurTime() < self.PN3Timer then
        self.PN3 = 1
    elseif self.PN3Timer then
        self.PN3Timer = nil
    end
end

function TRAIN_SYSTEM:WhenStops(delay)
    return self.SbTimer and CurTime() - self.SbTimer > (delay or 0.65) or false
end

function TRAIN_SYSTEM:RvtbTimer(name, restore, bypass)
    if self[name] then
        if CurTime() >= self[name] then
            local val = restore and (bypass or self:WhenStops() and self.Ring == 0)
            if val then self[name] = nil end
            if name == "BrakeEff" and not val and self.RVTB == 1 then
                print("Terminal dV", self.dV)
            end
            if self.RVTB == 1 and not val then print(name) end
            return val
        elseif restore then
            self[name] = nil
        end
    end
    return true
end
