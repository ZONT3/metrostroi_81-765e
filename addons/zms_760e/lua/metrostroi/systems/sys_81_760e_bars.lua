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
    self.ZsErrorMargin = math.random() * 0.35 + 0.5
    self.PN1 = 0
    self.PN2 = 0
    self.PN3 = 0
    self.BTB = 0
    self.UOS = 0
    self.RVTB = 0
    self.NextNoFq = false
    self.Ready = false
end

function TRAIN_SYSTEM:Outputs()
    return {"Active", "ALSMode", "Ring", "Brake", "Drive", "Drive1", "Drive2", "AllowStart", "PN1", "PN2", "PN3", "StillBrake", "SpeedLimit", "BTB", "UOS", "NextNoFq", "BadFq"}
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
    local UOS = (Wag.PmvAtsBlock.Value == 3) and (Wag.RV["KRO5-6"] == 0 or Wag.RV["KRR15-16"] > 0) --and ALSVal == 0
    local EnableALS = Wag.Electric.Battery80V > 62 and (1 - Wag.RV["KRO5-6"]) + Wag.RV["KRR15-16"] > 0
    local DAU = Wag.PmvFreq.Value == 0
    local TwoToSix = Wag.PmvFreq.Value > 0
    local AD = Wag.sys_Autodrive
    if EnableALS ~= (ALS.Enabled == 1) then ALS:TriggerInput("Enable", EnableALS and 1 or 0) end

    -- Kolhoz tipa 81-765 (skoree vsego huinya)
    self.BarsPower = Wag.Electric.Battery80V > 62 and (Wag.RV["KRO5-6"] == 0 or Wag.RV["KRR15-16"] > 0)
    self.ATS1Bypass = not self.BarsPower or UOS or Wag.PmvAtsBlock.Value == 2
    self.ATS2Bypass = not self.BarsPower or UOS or Wag.PmvAtsBlock.Value == 1
    self.ATS1 = self.BarsPower and (self.ATS1Bypass or Wag.PpzAts1.Value > 0.5)
    self.ATS2 = self.BarsPower and (self.ATS2Bypass or Wag.PpzAts2.Value > 0.5)

    local PowerALS = self.ATS1 or self.ATS2
    local Power = self.ATS1 and self.ATS2 and ALSVal == 0

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
    self.KVT = Wag.AttentionBrake.Value > 0.5 or self.KB or AD.State > 0
    if self.KVT then self.KVTTimer = CurTime() + 1 end
    if self.KVTTimer and CurTime() - self.KVTTimer > 0 then self.KVTTimer = nil end

    local Active = Power
    local Emer = Wag.RV["KRR15-16"] * Wag.PpzEmerControls.Value > 0.5
    local KMState = Wag.KV765.Position
    local BUPKMState = Wag.BUKP.ControllerState
	if AD.State > 0 and AD.Command ~= 0 and KMState == 0 and self.Brake < 1 then
		KMState = AD.Command
		BUPKMState = AD.Command
	end
    if Emer then
        KMState = (Wag.EmerX1.Value > 0 or Wag.EmerX2.Value > 0) and 20 or 0
        BUPKMState = KMState
    end

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
        self.NextNoFq = DAU or ((not self.F1 and not self.F2 and not self.F3 and not self.F4 and not self.F5) or TwoToSix and self.LN and count == 1) and not ALS.AO or ALS.AO and not self.F5
        if TwoToSix and self.F6 and self.SpeedLimit > 21 then self.NextNoFq = false end
        if not TwoToSix and (math.max(20, self.NextLimit) ~= math.max(20, Vlimit) or self.F6) then
            self.SpeedLimit = 0
            self.NextLimit = self.SpeedLimit
            self.NoFreq = true
        end

        if TwoToSix and self.F4 and self.F6 then self.LN = true end
        self.BadFq = (ALS.OneFreq == 1 or ALS.TwoFreq == 1 and not self.LN or self.NoFreq) and TwoToSix and not ALS.AO
        if self.BadFq and (self.F4 or self.F3 or self.F2 or self.F1) then self.SpeedLimit = self.LN and 40 or (self.KB and 20 or 0) end
        if self.SpeedLimit < 20 and self.KB and not ALS.AO then self.SpeedLimit = 20 end
        if self.NextLimit > self.SpeedLimit then self.NextLimit = self.SpeedLimit end
        if DAU then self.NextLimit = nil end
    else
        self.SpeedLimit = 0
        self.NextLimit = 0
    end

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

    if self.BarsPower and (Wag.BUKP.Active > 0 or UOS) and ALSVal == 0 then
        Active = Active and Wag.BUKP.Active > 0
        RVTB = Active or UOS

        local KmCur = KMState > 0 or Active and BUPKMState > 0
        if Active and not UOS then
            SpeedLimit = self.KB and not ALS.AO and 20 or SpeedLimit

            if Speed > SpeedLimit then
                if not Brake then Ring = true end
                Brake = true
                self.PN1Timer = CurTime() + 1
            elseif not Ring then
                Brake = false
            end

            if Ring and Drive and not self.KvtTimer then
                self.KvtTimer = CurTime() + 6
            end
            if Ring and self.KVT then
                Ring = false
            end
            RVTB = RVTB and self:RvtbTimer("KvtTimer", not Ring)

            if Speed > SpeedLimit - 1.3 and KmCur then
                if not Drive then
                    if not self.TryDriveTimer then
                        self.TryDriveTimer = CurTime() + 3.2
                    end
                elseif not DisableDrive then
                    DisableDrive = true
                    self.ControllerInDrive = forgiveful or Speed < SpeedLimit
                end
            end
            RVTB = RVTB and self:RvtbTimer("TryDriveTimer", not KmCur or Speed <= SpeedLimit - 1.3)

            if self.TryDriveTimer then
                self.PN3 = 1
            end

            if DisableDrive and not KmCur and (SpeedLimit < 21 or Speed < SpeedLimit - 3.1) then
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
            RVTB = RVTB and self:RvtbTimer("DisableDriveAttempt", not Ring)

            local aoArrived = false
            if ALS.AO and Drive then
                Drive = false
                aoArrived = true
            end
            if ALS.AO then
                if self.KVT then self.RingingAO = false end
                Ring = Ring or self.RingingAO
            else
                self.RingingAO = true
            end

            if not Drive and math.abs(Speed) > 0.6 then
                if not self.AntirollTimer then
                    self.AntirollTimer = CurTime() + 1.1
                    self.AntirollAO = aoArrived
                elseif CurTime() > self.AntirollTimer then
                    if self.AntirollAO then
                        self.AntirollAoTimer = CurTime()
                    elseif self.RVTB == 1 then
                        self.DeadRvtb = true
                    end
                end
            elseif self.AntirollTimer then
                self.AntirollTimer = nil
                self.AntirollAO = false
            end
            RVTB = RVTB and self:RvtbTimer("AntirollAoTimer", not Ring, 1.9)

            if not self.NoFreq and KmCur and Speed < 0.8 and not self.NoSpeedTimer then
                self.NoSpeedTimer = CurTime() + (Emer and 6.8 or 4.8)
            end
            RVTB = RVTB and self:RvtbTimer("NoSpeedTimer", self.NoFreq or not KmCur or Speed >= 0.8)

            self.BUKPErr = (
                Wag.BUKP.DoorClosed + Wag.DoorBlock.Value < 1 or
                Wag.BUKP.Errors.NoOrient or
                Wag.BUKP.Errors.EmergencyBrake or
                -- Wag.BUKP.Errors.BuvDiscon or
                Wag.BUKP.Errors.RvErr
            )

            local ZsError = self.BUKPErr and Wag.BUKP.ZeroSpeed < 1
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

            self.PN3 = (self.PN3 > 0 or ZsError or KmCur and self.BUKPErr) and 1 or 0
        elseif UOS then
            SpeedLimit = not Emer and self.KB and 35 or 0
            self.SpeedLimit = SpeedLimit
            self.NextLimit = nil
        end

        AllowStart = UOS or (self.KB or not self.NoFreq and not self.RealF5) and not ALS.AO and not Brake
        local travel = Drive and not self.SbTimer
        if travel then self.TravelTimer = CurTime() + math.Rand(0.27, 0.34) end
        if not travel and Drive and self.TravelTimer and CurTime() < self.TravelTimer then
            travel = true
        end
        Drive = travel or AllowStart and KmCur

        if UOS and not Emer and (Wag.PpzUpi.Value * Wag.KAH.Value < 1 or Speed > 35.5) then
            Drive = false
        end

        if UOS and not Emer and Speed > 35.5 then
            self.UosLimitTimer = CurTime() - 1
            RVTB = false
        end
        RVTB = RVTB and self:RvtbTimer("UosLimitTimer", true, nil, ZeroSpeed)

        if Emer then
            local EmerCondition = not UOS and Drive and not Brake or UOS and self.KB
            if not EmerCondition and not self.EmerTimer then
                self.EmerTimer = CurTime()
            end
            RVTB = RVTB and self:RvtbTimer("EmerTimer", EmerCondition, nil, not UOS and ZeroSpeed and AllowStart and KmCur or UOS and self.KB)
        end

        if UOS then
            BTB = BTB and self.KB
        end

        self.RVTB = RVTB and not self.DeadRvtb and 1 or 0
        self.BTB = BTB and 1 or 0
        self.Brake = Brake and 1 or 0
        self.Ring = Ring and 1 or 0
        self.Drive = Drive and 1 or 0
        self.AllowStart = AllowStart and 1 or 0
        self.DisableDrive = DisableDrive
        self.SpeedLimit = SpeedLimit > self.SpeedLimit and SpeedLimit or self.SpeedLimit

        self.Drive1 = self.ATS1 and Drive and 1 or 0
        self.Drive2 = self.ATS2 and Drive and 1 or 0

    elseif ALSVal == 1 then
        -- TODO Some BUKP logic for speed regulation
        self.PN1 = 0
        self.PN2 = 0
        self.PN3 = 0
        self.Ring = 0
        self.Brake = 0
        self.Drive = KMState > 0 or not ZeroSpeed and 1 or 0
        self.Drive1 = self.ATS1 and self.Drive == 1 and 1 or 0
        self.Drive2 = self.ATS2 and self.Drive == 1 and 1 or 0
        self.BTB = 1
        self.DisableDrive = false

    else
        self.BTB = 0
        self.Brake = 0
        self.Drive = 0
        self.Ring = 0
        self.PN1 = 0
        self.PN2 = 0
        self.Drive1 = 0
        self.Drive2 = 0
        self.RingingAO = true
        self.LN = Wag.BUKP.State > 0 and self.LN
        self.Ready = true
        self.StillBrake = 1
        self.SbTimer = 0
        self.DeadRvtb = false
    end

    if self.BarsPower and (Active or ALSVal == 1) and not UOS then
        if KMState <= 0 and ZeroSpeed then
            if not self.SbTimer then
                self.SbTimer = CurTime()
            elseif self:WhenStops(SelfZs and 0 or 1.2) then
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
            else
                self.PN1Timer = nil
            end
        end
		if AD.State > 0 and AD.BrakeBoost then
			self.PN1 = 1
		end
    elseif self.BarsPower and UOS then
        self.StillBrake = 0
        self.SbTimer = nil
    end

    if Wag.Electric.V2 ~= self.ElectricBTB then
        self.RVTB = 1
        self.BTB = 1
        self.ElectricBTB = Wag.Electric.V2
    end

    self.RVTB = Wag.Electric.V2 == 0 and 1 or self.RVTB
    self.Active = (Active or self.BarsPower and UOS) and 1 or 0
    self.ALSMode = ALSVal

    if self.StillBrake > 0 then
        self.PN2 = 1
    end

    if self.PN3 > 0 then
        self.PN3Timer = CurTime() + 0.7
    elseif self.PN3Timer and CurTime() < self.PN3Timer then
        self.PN3 = 1
    elseif self.PN3Timer then
        self.PN3Timer = nil
    end
end

function TRAIN_SYSTEM:WhenStops(delay)
    return self.SbTimer and CurTime() - self.SbTimer > (delay or 0.65) or false
end

function TRAIN_SYSTEM:RvtbTimer(name, restore, delay, bypass)
    if self[name] then
        if CurTime() >= self[name] then
            local val = restore and (self:WhenStops(delay) or bypass)
            if val then self[name] = nil end
            -- if not val then print(name) end
            return val
        elseif restore then
            self[name] = nil
        end
    end
    return true
end
