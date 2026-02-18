--------------------------------------------------------------------------------
-- Контроллер 81-765
-- В будущем возможен перенос в БУКП (САУ Скиф-М), если так реалестичнее
-- Автор - ZONT_ a.k.a. enabled person
--------------------------------------------------------------------------------
Metrostroi.DefineSystem("81_765_Controller")
TRAIN_SYSTEM.DontAccelerateSimulation = true


local SettingSpeed = 80  -- Per second
local SettingDelay = 0.2  -- Seconds
local ZeroTimer = 1.6  -- Seconds

function TRAIN_SYSTEM:Initialize()
    self.VisualPosition = 0
    self.Position = 0
    self.TargetPosition = 0

    self.Set1Pressed = false
    self.Set5Pressed = false

    self.Online = 0
    self.TractiveSetting = 0
    self.TargetTractiveSetting = 0
    self.IsOverriden = 0
    self.DelayBypass = 0

    self.Train.KvSettingSpeed = SettingSpeed
end

function TRAIN_SYSTEM:Inputs()
    return {
        "Up", "Down", "Set1", "Set2", "Set3", "Set4", "Set5", "Set6", "Set7", "ResetTractiveSetting", "SetTractiveSetting"
    }
end

function TRAIN_SYSTEM:Outputs()
    return { "Position", "TractiveSetting", "Online", "IsOverriden" }
end

function TRAIN_SYSTEM:TriggerInput(name, value)
    if name == "Up" then
        if value > 0 then
            self.TargetPosition = math.min(2, self.TargetPosition + 1)
        elseif math.abs(self.TargetPosition) == 2 then
            self.TargetPosition = 1 * (self.TargetPosition < 0 and -1 or 1)
        end

    elseif name == "Down" then
        if value > 0 then
            self.TargetPosition = math.max(-3, self.TargetPosition - 1)
        elseif self.TargetPosition == -2 then
            self.TargetPosition = -1
        end

    -- +M
    elseif name == "Set2" or name == "Set3" then
        self.TargetPosition = value > 0 and 2 or self.TargetPosition == 2 and 1 or self.TargetPosition

    -- M
    elseif name == "Set1" then
        if value > 0 then
            self.TargetPosition = self.TargetTractiveSetting > 20 and 0 or 1
            self.Set1Pressed = true
        else
            if self.TargetPosition == 0 then
                self.TargetPosition = 1
            end
            self.Set1Pressed = false
        end

    -- 0
    elseif name == "Set4" and value > 0 then
        self.TargetPosition = 0

    -- F
    elseif name == "Set5" then
        if value > 0 then
            self.TargetPosition = self.TargetTractiveSetting < -20 and 0 or -1
            self.Set5Pressed = true
        else
            if self.TargetPosition == 0 then
                self.TargetPosition = -1
            end
            self.Set5Pressed = false
        end

    -- +F
    elseif name == "Set6" then
        self.TargetPosition = value > 0 and -2 or self.TargetPosition == -2 and -1 or self.TargetPosition

    -- VF
    elseif name == "Set7" and value > 0 then
        self.TargetPosition = -3

    end

    if name == "ResetTractiveSetting" then
        self.TractiveSettingOverride = nil
        if value > 0 then
            self.MotionBlocked = true
            self.TractiveSetting = self.TargetTractiveSetting <= 0 and self.TargetTractiveSetting or 0
            self.TargetTractiveSetting = self.TargetTractiveSetting <= 0 and self.TargetTractiveSetting or 0
        end

    elseif name == "SetTractiveSetting" then
        self.TractiveSettingOverride = value
        self.MotionBlocked = value <= 0

    else
        self.ControllerTimer = CurTime() - 1

    end
end

function TRAIN_SYSTEM:Think(dT)
    if self.ControllerTimer and CurTime() - self.ControllerTimer > 0.06 and self.VisualPosition ~= self.TargetPosition then
        local previousPosition = self.VisualPosition
        self.ControllerTimer = CurTime()
        if self.TargetPosition > self.VisualPosition then
            self.VisualPosition = self.VisualPosition + 1
        else
            self.VisualPosition = self.VisualPosition - 1
        end

        self.Train:PlayOnce("KV_" .. previousPosition .. "_" .. self.VisualPosition, "cabin", 0.25, 0.95)
    end

    if self.VisualPosition == self.TargetPosition then self.ControllerTimer = nil end

    self.Train.Panel:TriggerInput("SetController", self.VisualPosition)

    -- Is Controller online (can change tractive power)
    -- FIXME: how realistic is it?
    self.Online = self.Train.BUKP and self.Train.BUKP.State == 5 and self.Train:GetNW2Int("Skif:MainMsg", 0) == 0 and 1 or 0
    -- self.Online = self.Online * self.Train.PpzKm.Value
    self.IsOverriden = self.TractiveSettingOverride ~= nil

    if self.Online > 0 then
        if self.VisualPosition == 0 and math.abs(self.TractiveSetting) >= 40 and not self.ZeroTimer then
            self.ZeroTimer = CurTime()
        elseif self.ZeroTimer and not (self.VisualPosition == 0 and math.abs(self.TractiveSetting) > 2) then
            self.ZeroTimer = nil
        elseif self.VisualPosition == 0 and self.ZeroTimer and math.abs(self.TractiveSetting) > 2 and CurTime() - self.ZeroTimer >= ZeroTimer then
            self.ZeroTimer = nil
            self.TractiveSetting = 0
            self.TargetTractiveSetting = 0
        end

        if self.MotionBlocked and self.VisualPosition <= 0 then
            self.MotionBlocked = false
        end

        if self.TargetTractiveSetting > 0 and self.MotionBlocked then
            self.TargetTractiveSetting = 0
        end

        if self.TractiveSettingOverride == nil then
            if self.VisualPosition == -3 then
                self.TargetTractiveSetting = -100
                self.TractiveSetting = -100

            elseif self.MotionBlocked and (self.TractiveSetting > 0 or self.TargetTractiveSetting == 0) then
                self.TargetTractiveSetting = 0
                self.TractiveSetting = 0

            elseif not self.MotionBlocked or self.VisualPosition <= 0 then
                if self.VisualPosition > 0 and self.TractiveSetting < 0 or self.VisualPosition < 0 and self.TractiveSetting > 0 then
                    self.TargetTractiveSetting = 0
                    self.TractiveSetting = 0
                end

                if self.TargetTractiveSetting == 0 and (self.VisualPosition > 0.5 or self.VisualPosition < -0.5) then
                    self.TargetTractiveSetting = self.VisualPosition > 0 and 20 or -20
                    self.DelayBypass = CurTime() + SettingDelay + 0.05
                end

                if math.abs(self.TargetTractiveSetting) > 10 then
                    local target = math.abs(self.TargetTractiveSetting)
                    local current = math.abs(self.TractiveSetting)
                    local direction = math.abs(self.VisualPosition)
                    direction = direction > 1.2 and 1 or direction < 0.8 and -1 or 0

                    local new = target + (math.abs(target - current) < 5 and 10 * direction or 0)
                    if direction ~= 0 then
                        if not self.DeltaDelay then
                            self.DeltaDelay = CurTime() + SettingDelay
                            self.DeltaDir = direction
                            self.Accel40 = self.TractiveSetting == 100 and direction == -1
                        end
                    else
                        if self.DeltaDelay then
                            direction = self.DeltaDir or direction
                            if self.Accel40 and CurTime() < self.DeltaDelay then
                                new = 40
                            else
                                new = target + math.max(10, math.floor((self.DeltaDelay - CurTime()) * SettingSpeed / 10) * 10) * direction
                            end
                            self.DeltaDelay = nil
                            self.DeltaDir = nil
                            self.Accel40 = nil
                        end
                    end

                    if new ~= target and (not self.DeltaDelay or self.DelayBypass > CurTime() or CurTime() >= self.DeltaDelay) then
                        target = new
                        if target > 100 then target = 100
                        elseif target < 20 then target = 0 end
                        self.TargetTractiveSetting = target * (self.TargetTractiveSetting > 0 and 1 or -1)
                    end
                end

                local delta = self.TargetTractiveSetting - self.TractiveSetting
                local sgn = delta > 0 and 1 or delta < 0 and -1 or 0
                if sgn ~= 0 then
                    local newDelta = dT * SettingSpeed * sgn
                    if math.abs(newDelta) > math.abs(delta) then
                        self.TractiveSetting = self.TargetTractiveSetting
                    else
                        self.TractiveSetting = self.TractiveSetting + newDelta
                    end
                end

            end

        elseif self.TractiveSettingOverride ~= nil then
            self.TractiveSetting = self.TractiveSettingOverride
        end

        self.Position = self.VisualPosition
    else
        self.TractiveSetting = 0
        self.TargetTractiveSetting = 0
        self.ZeroTimer = nil
    end

    if self.TargetPosition == 0 and self.Set1Pressed and self.TargetTractiveSetting <= 20 then
        self.TargetPosition = 1
        self.ControllerTimer = CurTime() - 1
    elseif self.TargetPosition == 0 and self.Set5Pressed and self.TargetTractiveSetting >= -20 then
        self.TargetPosition = -1
        self.ControllerTimer = CurTime() - 1
    end
end
