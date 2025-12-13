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

local dbgStates = {}
local dbgCurStates = {}
local tnCond = function(wag) return wag:GetWagonNumber() == 37218 end
local function dbg(cond, sid, id, val)
    if not cond then return end
    if not dbgCurStates[sid] then dbgCurStates[sid] = {} end
    local s = dbgCurStates[sid]
    s[1] = id
    s[2] = val
end

local function dbgCommit()
    local ct = math.floor(CurTime() * 1000)
    for sid, v in pairs(dbgCurStates) do
        local prev = dbgStates[sid] or {}
        local prevId, prevVal = unpack(prev)
        local id, val = unpack(v)
        if id ~= prevId or val ~= prevVal then
            print(ct, sid, id, val)
            dbgStates[sid] = dbgStates[sid] or {}
            dbgStates[sid][1] = id
            dbgStates[sid][2] = val
        end
    end
end

function TRAIN_SYSTEM:Think(dT)
    local Train = self.Train
    local ALS = Train.ALSCoil
    local ALSVal = Train.ALS.Value * (Train.ALSVal == 2 and 1 or 0) * Train.SF23F8.Value
    local UOS = (Train.PmvAtsBlock.Value == 3) and (Train.RV["KRO5-6"] == 0 or Train.RV["KRR15-16"] > 0) --and ALSVal == 0
    local EnableALS = Train.Electric.Battery80V > 62 and (1 - Train.RV["KRO5-6"]) + Train.RV["KRR15-16"] > 0
    local DAU = Train.PmvFreq.Value == 0
    local TwoToSix = Train.PmvFreq.Value > 0
    if EnableALS ~= (ALS.Enabled == 1) then ALS:TriggerInput("Enable", EnableALS and 1 or 0) end

    -- Kolhoz tipa 81-765 (skoree vsego huinya)
    local Power = Train.Electric.Battery80V > 62 and (Train.RV["KRO5-6"] == 0 or Train.RV["KRR15-16"] > 0)
    self.ATS1Disabled = not Power or UOS or Train.PmvAtsBlock.Value == 2
    self.ATS2Disabled = not Power or UOS or Train.PmvAtsBlock.Value == 1
    self.ATS1 = Power and (self.ATS1Disabled or Train.SF23F8.Value > 0.5)
    self.ATS2 = Power and (self.ATS2Disabled or Train.SF23F7.Value > 0.5)

    local PowerALS = self.ATS1 and self.ATS2
    Power = PowerALS and ALSVal == 0

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
        self.Speed1 = math.Round(ALS.Speed * 10) / 10 --math.floor(Train.ALSCoil.Speed)
        speed = self.Speed1
    elseif Train.BUKP.State == -1 then
        speed = 99
        self.Speed1 = 99 -- -1.01
    elseif self.Speed1 > 2 then
        speed = self.Speed1
        --elseif self.Speed1 == -1.01 then
        --speed = 0
    end

    --print(self.Speed1)
    self.Speed = speed --Train.BUKP.CurrentSpeed --math.Round(ALS.Speed*10)/10
    if ALSVal ~= self.PrevALS then
        if ALSVal == 0 then
            if self.Speed < self.SpeedLimit + 0.2 then
                self.Ready = true
                self.ReadyTimer = nil
            end
        end

        self.PrevALS = ALSVal
    end

    -- ARS system placeholder logic
    self.KB = Train.PB.Value > 0.5 or Train.Attention.Value > 0.5
    self.KVT = Train.AttentionBrake.Value > 0.5
    if self.KVT then self.KVTTimer = CurTime() + 1 end
    if self.KVTTimer and CurTime() - self.KVTTimer > 0 then self.KVTTimer = false end
    local Active = Power -- and Train.ALS.Value == 0-- and Train.BUKP.Active > 0 and Train.BUV.Reverser ~= 0
    if not self.Ready then Active = false end
    --if not self.Ready and Train.BUKP.State == 5 and Power then self.RVTB = 0 end
    if self.RVTB == 0 then self.BTB = 0 end
    local Emer = Train.RV["KRR15-16"] * Train.SF23F1.Value > 0.5
    local KMState = Train.KV765.Position
    local ThrottleState = Train.KV765.TractiveSetting
    local BUPKMState = Train.BUKP.ControllerState
    if Emer then
        KMState = (Train.EmerX1.Value > 0 or Train.EmerX2.Value > 0) and 20 or 0
        BUPKMState = (Train.EmerX1.Value > 0 or Train.EmerX2.Value > 0) and 20 or 0
    end

    if EnableALS and Train.BUKP.Active > 0 and PowerALS then
        local V = math.floor(self.Speed + 0.05)
        local Vlimit = 20
        local VLimit2
        if self.F4 then Vlimit = 40 end
        if self.F3 then Vlimit = 60 end
        if self.F2 then Vlimit = 70 end
        if self.F1 or self.AB then Vlimit = 80 end
        --if (    self.KB) and (Vlimit ~= 0) and (V > Vlimit) then self.Overspeed = true end
        --if (    self.KB) and (Vlimit == 0) and (V > 20) then self.Overspeed = true end
        --if (not self.KB) and (V > Vlimit) and (V > (self.RealNoFreq and 0 or 3)) then self.Overspeed = true end
        --if (    self.KB) and (Vlimit == 0) and self.Train.ARSType and self.Train.ARSType == 3 and not self.Train["PA-KSD"].VRD then self.Overspeed = true end
        --self.Ring = self.Overspeed and (speed > 5)
        -- Determine next limit and current limit
        self.SpeedLimit = VLimit2 or Vlimit + 0.5
        self.NextLimit = VLimit2 or Vlimit
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
            self.NextLimit = 20
            count = count + 1
        end

        if self.AB then
            self.NextLimit = 80
            count = count + 1
        end

        if self.F6 then count = count + 1 end
        self.NextNoFq = not self.AB and (DAU or ((not self.F1 and not self.F2 and not self.F3 and not self.F4 and not self.F5) or TwoToSix and self.LN and count == 1) and not ALS.AO or ALS.AO and not self.F5)
        if TwoToSix and self.F6 and self.SpeedLimit > 21 then self.NextNoFq = false end
        if not TwoToSix and (self.NextLimit ~= math.max(20, Vlimit) or self.F6) and not self.AB then
            self.SpeedLimit = 0
            self.NextLimit = self.SpeedLimit
            self.NoFreq = true
            self.BINoFreq = 1
        end

        if TwoToSix and self.F4 and self.F6 then self.LN = true end
        self.BadFq = (ALS.OneFreq == 1 or ALS.TwoFreq == 1 and not self.LN or self.NoFreq) and TwoToSix and not ALS.AO
        if self.BadFq and (self.F4 or self.F3 or self.F2 or self.F1) then self.SpeedLimit = self.LN and 40 or (self.KB and 20 or 0) end
        if self.SpeedLimit < 20 and self.KB then self.SpeedLimit = 20 end
        --[[
        if ALS.AO and TwoToSix then
            if self.F5 then--0		
            else--оч		
            end
        end]]
        if self.NextLimit > self.SpeedLimit then self.NextLimit = self.SpeedLimit end
        if DAU or Train.BKL and not TwoToSix then self.NextLimit = nil end
        --AO and dau speedlimit = 0
        --[[
        if (not self.F1 and not self.F2 and not self.F3 and not self.F4 and not self.F5 or self.BadFq) and not (not self.LN and self.SpeedLimit == 0)  then
            self.NextNoFreq = true
        elseif self.NextNoFreq then
            self.NextNoFreq = false
        end	]]
    else
        self.SpeedLimit = 0
        self.NextLimit = 0
    end

    if Active and Train.BUKP.Active > 0 and not UOS then
        if Emer then
            if self.Speed < 1.8 then
                self.BTB = Train.Electric.EmerXod
                --else
                --self.BTB = self.RVTB
            end
        elseif self.Speed <= 0.1 then
            --self.BTB = 1
        end

        local speed = self.Speed * Train.SpeedSign * (Train.BUV.Reverser > 0.5 and 1 or -1)
        local Drive = self.Drive > 0
        local Brake = self.Brake > 0
        local SpeedLimit = self.SpeedLimit
        if TwoToSix and (not self.LN or self.NextLimit == math.max(20, SpeedLimit) and self.F6 == 0) then SpeedLimit = math.min(40, SpeedLimit) end
        if self.KB and Train.RV.KRRPosition == 0 then SpeedLimit = 20 end
        if self.Speed > SpeedLimit or (self.NoFreq or self.RealF5) and not self.KB and self.Speed > 0.1 or self.Braking and not Brake or ALS.AO and KMState > 0 and self.KB then --or (self.F1 or self.F2 or self.F3 or self.F4) and self.KB and speed > 20
            if not Brake and (SpeedLimit > 20 or self.Speed > 0) then
                self.Braking = CurTime()
                self.PN1Timer = CurTime()
            end

            if not Brake and (SpeedLimit > 20 or self.Speed > 0 or ALS.AO) then self.Ringing = true end
            Brake = true
        elseif (self.Speed < SpeedLimit or self.Speed == 0) and not self.Braking and KMState <= 0 then
            Brake = false
        end

        if (self.Ringing or self.Braking) and self.KVT then
            self.Braking = false
            self.Ringing = false
        end

        --Emer brake if we braking and speed < 4.5
        --if Brake and self.Speed > 0.1 and self.Speed < 4.5 then self.BTB = 0 end
        if (BUPKMState > 0 and self.Drive > 0) and self.PN2 > 0 then
            if not self.Starting then self.Starting = CurTime() end
            self.PN2 = 0
        end

        if self.Speed < 1.8 and KMState <= 0 then
            self.RollingBraking = CurTime()
        elseif KMState > 0 then
            self.RollingBraking = nil
        end

        if self.RollingBraking and KMState > 0 or Train.BUIK.State <= 0 then self.RollingBraking = CurTime() end
        --if self.RollingBraking and CurTime()-self.RollingBraking > 1.5 then self.RollingBraking = nil end
        if self.Starting and CurTime() - self.Starting > 6 then
            if self.Speed < 1.5 then self.RollingBraking = CurTime() end
            self.Starting = nil
        end

        --if self.RollingBraking then self.BTB = 0 end
        --if self.PN2 > 0 and self.Speed > 0.1 then self.BTB = 0 end
        --Brake efficiency check
        if Brake and Train.Acceleration < -0.6 and self.Speed > 0 then self.BrakeEfficiency = CurTime() end
        if (not Brake or math.Round(self.Speed) == 0) and self.BrakeEfficiency then self.BrakeEfficiency = nil end
        if self.BrakeEfficiency and KMState <= 0 and self.Speed < 0.1 then self.BrakeEfficiency = nil end
        --Disable PN1 if not braking or passed 1.5s
        if self.PN1Timer and (CurTime() - self.PN1Timer > 1.5 or not Brake) then self.PN1Timer = nil end
        if self.Speed > SpeedLimit - 1.1 and (KMState > 0 or ThrottleState > 0) and not Emer then
            self.DisableDrive = true
            self.ControllerInDrive = KMState > 0
        end

        if self.Speed < SpeedLimit - 3 and KMState <= 0 or SpeedLimit < 10 and KMState <= 0 or Emer then
            self.DisableDrive = false
            self.ControllerInDrive = false
        end

        if self.ControllerInDrive and (not self.DisableDrive or KMState <= 0) then self.ControllerInDrive = false end
        if self.DisableDrive and not self.ControllerInDrive and KMState > 0 then
            if not self.Braking then self.Braking = CurTime() end
            if not self.PN1Timer then self.PN1Timer = CurTime() end
            self.Ringing = true
            Brake = true
        end

        --[[
        if self.NoFreq and Train.PB.Value == 1 then
            self.NTimer = nil
        end
        if self.NTimer and CurTime()-self.NTimer > 3 then
            self.RVTB = 0
            if not self.RVTBResetTimer then self.RVTBResetTimer = CurTime() end
        end]]
        --Противоскат
        if self.Speed < 0.5 and not self.PN1Timer and (KMState <= 0 or self.Drive == 0) and not self.NoFreq then
            self.PN1Timer = CurTime()
            self.Starting = nil
        end

        if ALS.AO then
            self.NoFreq = not DAU and (ALS.F5 == 0)
            if Train.BKL and self.KVT and self.RingingAO then self.RingingAO = false end
            self.Ringing = self.RingingAO
        elseif not self.RingingAO then
            self.RingingAO = true
            --self.Ringing = false
        end

        --[[
        Drive = not self.DisableDrive and (
                                    (self.NoFreq or self.RealF5) and self.KB
                                    or not self.NoFreq and not self.RealF5
                                ) and not Brake and not Brake2
        self.PN1 = self.PN1Timer and 1 or 0
        self.Ring = self.Ringing and 1 or 0
        self.Brake = Brake and 1 or 0
        self.Brake2 = Brake2 and 1 or 0
        self.Drive = Drive and 1 or 0]]
        Drive = not self.DisableDrive and ((self.NoFreq or self.RealF5) and self.KB or not self.NoFreq and not self.RealF5) and not Brake and not Brake2
        self.PN1 = (ALS.AO or self.PN1Timer) and 1 or 0
        self.Ring = self.Ringing and 1 or 0
        self.Brake = Brake and 1 or 0
        self.Brake2 = Brake2 and 1 or 0
        self.Drive = Drive and 1 or 0
        if Train.Pneumatic.RVTBLeak == 0 then self.RVTB = 1 end
        if Train.BUKP.State <= 4 then --[[self.Ringing or]] --[[Train.BUKP.State > 0 and]] --or Train.BMCIS.State < 0 then
            self.RVTB = 0
        end

        if self.BrakeEfficiency and CurTime() - self.BrakeEfficiency >= 3.6 then
            self.RVTB = 0
            --print("brakefff")
            --self.BrakeEfficiency = nil
        end

        if Train.BUKP.State * Train.SF23F8.Value == 5 then
            if self.BUKPState ~= 5 then
                self.RVTB = 1
                self.BUKPState = 5
            end

            if not Emer then
                if (self.NoFreq or self.SpeedLimit < 21) and not self.KB and KMState > 0 and self.KBApply then
                    --self.RVTB = 0
                    self.DisableDrive = true
                    self.ControllerInDrive = true
                end

                if self.NoFreq or self.SpeedLimit < 21 then
                    if KMState > 0 and self.KB and not self.KBApply then --[[and Train.PB.Value == 1]]
                        self.KBApply = true
                    end
                elseif not self.KBApply then
                    self.KBApply = true
                end

                if (self.NoFreq or self.SpeedLimit < 21) and KMState <= 0 and (self.KBApply or self.KBApplyTimer) then
                    self.KBApply = false
                    self.KBApplyTimer = nil
                end

                if (self.NoFreq or self.SpeedLimit < 21) and not self.KB and KMState > 0 and Train.BUKP.State == 5 and not self.KBApply then
                    --self.RVTB = 0
                    if not self.KBApplyTimer then self.KBApplyTimer = CurTime() + 5 end
                    self.PN1 = 1
                    if not self.SBTimer then self.SBTimer = CurTime() end
                    --print("not kbapply")
                end

                if self.KBApplyTimer and CurTime() - self.KBApplyTimer > 0 and (self.NoFreq or self.SpeedLimit < 21) then
                    self.RVTB = 0
                    --print("KBAPPLY")
                elseif self.KBApplyTimer and not (self.NoFreq or self.SpeedLimit < 21) then
                    self.KBApplyTimer = nil
                end
            end

            if Train.BUKP.err11 and (KMState > 0) and Train.DoorBlock.Value == 0 or Train.BUIK.State <= 0 and CurTime() - (Train.CIS.Prev or 0) > 5 then
                -- self.DisableDrive = true
            end

        elseif self.BUKPState ~= 0 then
            self.BUKPState = 0
        end

        if self.RollingBraking and CurTime() - self.RollingBraking > 0.7 and not Emer then --and CurTime()-self.RollingBraking > 1 then
            self.RVTB = 0
        end

        if Train.SF23F13.Value == 0 and Train.RV.KROPosition ~= 0 then self.PN2 = 1 end
        --print(self.RVTB)
        if Train.BUKP.State == 5 then
            if Emer then
                if self.Brake > 0 or self.RollingBraking and CurTime() - self.RollingBraking > 0 then --and CurTime()-self.RollingBraking > 1 then
                    --self.RVTB = 0
                end

                if self.Speed < 1.8 and KMState > 0 then
                    self.RVTB = 1
                    self.BTB = 1
                elseif self.Speed < 1.8 then
                    self.RVTB = 0
                    self.BTB = 0
                    self.PN1 = 1
                end

                if self.NoFreq or self.SpeedLimit < 21 then
                    if KMState <= 0 then self.KBApply = self.KB end
                elseif not self.KBApply then
                    self.KBApply = true
                end

                if self.SpeedLimit <= 21 and (not self.KBApply and KMState > 0 or not self.KB) then
                    self.Drive = 0
                    self.RVTB = 0
                    self.PN1 = 1
                else
                    self.Drive = 1
                end

                self.DisableDrive = false
                self.ControllerInDrive = false
                if self.PN1 + self.PN2 > 0 and self.Speed < 0.5 then
                    self.BTB = 0
                    self.RVTB = 0
                    --self.Drive = 0
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
                    --self.RVTB = 0
                    self.RVTBTimer = CurTime() + 5
                    --elseif self.Brake == 0 and self.RVTBTimer then
                    --self.RVTBTimer = nil
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

            self.PN3 = KMState > 0 and (
                Train.BUKP.Errors.Doors or
                Train.BUKP.Errors.NoOrient
            ) and 1 or 0

            if self.Speed < 1.8 and not self.DisableDrive and KMState > 0 and ALS.NoFreq < 1 then
                if not self.NoSpeedTimer then
                    self.NoSpeedTimer = CurTime() + 7
                elseif CurTime() >= self.NoSpeedTimer then
                    self.RVTB = 0
                end
            elseif self.NoSpeedTimer then
                self.NoSpeedTimer = nil
            end
        end

        if self.RVTBReset then
            self.RVTB = 1
            self.BTB = 1
            self.RVTBReset = false
        end
    else
        self.BTB = 1
        if self.RVTB == 0 and not self.RVTBReset then if not self.RVTBResetTimer then self.RVTBResetTimer = CurTime() end end
        if self.RVTBTimer then self.RVTBTimer = nil end
        if not UOS and self.RollingBraking then self.RollingBraking = nil end
        self.BrakeEfficiency = nil
        if not self.RVTBReset and self.RVTB == 1 or self.RVTBResetTimer and CurTime() - self.RVTBResetTimer > 3 then
            self.RVTBReset = true
            self.RVTBResetTimer = nil
        end

        self.RVTB = (self.KVT or ALSVal > 0.5) and 1 or 0
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
            if Train.RV["KRO9-10"] * Train.SF23F3.Value > 0.5 then
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

                self.Drive = (self.KB and Train.KAH.Value == 1 and (ALSVal == 1 or Speed < 35.5)) and 1 or 0
                self.RVTB = (Train.SF23F7.Value + Train.SF23F8.Value == 0 or self.RollingBraking and CurTime() - self.RollingBraking > 0 or self.UOSBraking) and 0 or 1
            elseif Train.RV["KRR15-16"] * Train.SF23F1.Value > 0.5 then
                if not self.KB then self.BTB = 0 end
                self.UOSActive = self.KB
                self.RVTB = self.KB and 1 or 0
                self.Drive = 1 --(self.KB and 1 or 0)
            else
                self.Drive = 0
                self.BTB = 0
            end

            --print(Train.RV["KRR7-8"]*Train.BARS.BTB*Train.EmerX1.Value*((Train.SF23F8.Value+(Train.BARS.UOS and 1 or 0) > 0) and 1 or 0),Train.Pneumatic.SD2 )
            self.PN1 = 0
            self.PN2 = 0
            --self.DisableDrive = false
            self.Brake = 0
            --[[
            local NeedPB = ((Train.RV["KRO9-10"] > 0.5 or self.SpeedLimit < 21) and Train.PB.Value or 1) > 0.5-- or 1--PB или KB ?
            --self.UOSNeedPB = NeedPB
            local RVTB = (Train.SF23F8.Value > 0 or Train.RV.KRRPosition ~= 0) and (Train.RV["KRO9-10"]+Train.RV["KRR15-16"] > 0.5) and NeedPB and 1 or 0 --(Train.SF23F8.Value > 0 or Train.RV.KRRPosition ~= 0) and (self.SpeedLimit < 21 and self.KB or self.SpeedLimit > 21) and 1 or 0
            self.RVTB = RVTB
            self.BTB = 1
            self.Brake = 0
            
            self.SpeedLimit = (Train.RV["KRO9-10"] > 0.5 or self.SpeedLimit < 21) and NeedPB and 35.5 or self.SpeedLimit 
            if Train.RV["KRO9-10"] > 0.5 then
                if self.Speed > 35.5 then self.UOSBrake = true self.UOSBraking = true end
                if self.Speed < 35 and self.UOSBrake and KMState <= 0 then self.UOSBrake = false end
                if self.UOSBraking and self.Speed == 0 then self.UOSBraking = false end
            elseif Train.RV["KRR15-16"] > 0.5 then
                if self.Speed > self.SpeedLimit then self.UOSBrake = true self.UOSBraking = true end
                if self.Speed < self.SpeedLimit-0.5 and self.UOSBrake and Train:ReadTrainWire(19)+Train:ReadTrainWire(45) == 0 then self.UOSBrake = false end
                if self.UOSBraking and self.Speed == 0 then self.UOSBraking = false end
            end

            self.Drive = (self.UOSBrake or RVTB == 0) and 0 or (Train.RV["KRO9-10"] > 0.5 and Train.SF23F8.Value*Train.KAH.Value or (Train.RV["KRR15-16"] > 0.5 and 1 or 0))
            self.PN2 = 0
            --self.Ring = 0
            self.PN1 = 0
            self.RVTB = self.UOSBraking and 0 or self.RVTB
            
            if ALS.AO then
                self.RingingAO = (ALS.F5 == 0)
                self.Ringing = not self.RingingAO
            elseif not self.RingingAO then
                self.RingingAO = true
                self.Ringing = false
            end			
            self.Ring = self.Ringing and 1 or 0]]
            --self.DisableDrive = self.Speed > 33.9 or self.DisableDrive and KMState > 0
            --self.PN2 = self.UOSBraking and 1 or 0
        elseif ALSVal > 0 then
            self.PN2 = 1
            --self.RVTB = 0			
        else
            self.BTB = 0
            self.Brake = 0
            self.Drive = 0
            self.Ring = 0
            self.PN1 = 0
            self.PN2 = 0
        end

        self.Starting = nil
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
        --print(self.ReadyTimer,Power and Train.BUKP.Active > 0 and not self.Ready)
        --print(Power and Train.BUKP.Active > 0 and Train.BUKP.State == 5 and not self.ReadyTimer)
        if self.ReadyTimer and CurTime() - self.ReadyTimer > 0 then
            self.RVTB = 0
            --print("READYTIMER")
        end

        --if Emer then
        if Power and Train.BUKP.State == 5 and KMState <= 0 and self.Speed < 1.8 then
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
        --end
    end

    if Power and Train.SF23F8.Value == 0 and Train.RV.KROPosition ~= 0 then
        self.RVTB = 0
        --print("NOPOWER")
    end

    if self.PN1 + self.PN2 == 0 and self.StillBrake > 0 then self.StillBrake = 0 end
    --[[
    if Power and Train.BUKP.State == 5 and KMState <=0 and self.Speed < 0.1 then
        self.PN2 = 1
        self.PN2T = true
    end
    if Power and Train.BUKP.State == 5 and KMState > 0 and self.PN2T then self.PN2T = false end
    if Power and Train.BUKP.State == 5 and KMState <=0 and self.PN2T then
        self.PN2 = 1
    end
    ]]
    if Train.Electric.V2 ~= self.ElectricBTB then
        self.RVTB = 1
        self.BTB = 1
        self.ElectricBTB = Train.Electric.V2
    end

    self.BTB = self.BTB * (1 - Train:ReadTrainWire(41))

    self.RVTB = Train.Electric.V2 == 0 and 1 or self.RVTB * Train.SF22F5.Value
    self.Active = Active and 1 or 0

    dbgCommit()
end