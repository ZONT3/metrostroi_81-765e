--------------------------------------------------------------------------------
-- ПрОст, КОС
-- Автор - ZONT_ a.k.a. enabled person
--------------------------------------------------------------------------------
Metrostroi.DefineSystem("81_765_ProstKos")

TRAIN_SYSTEM.DontAccelerateSimulation = true

local BrakeSettings = {
    [0] = 0,
    20, 50, 80
}
local RollingMatrix = {
    { -- < 6 wag
        20, 10,
        8, 1.7,
        1.6, 0.2,
    }, { -- >= 6 wag
        20, 14,
        10, 1.9,
        1.7, 0.2,
    },
}
local decelCalibrationTau = 2

function TRAIN_SYSTEM:Initialize()
    self.Active = 0
    self.ProstActive = 0
    self.KosActive = 0
    self.Command = 0
    self.CommandKos = 0
    self.Distance = nil
    self.LastTag = nil
    self.LastTagTime = 0
    self.Readings = 0
    self.Receiving = false
    self.ShouldReceive = false
    self.LastThink = nil
    self.BlockDoorsL = false
    self.BlockDoorsR = false
    self.OPV = 0

    self.BrakeDecel = {
        { 1.2, 2.8, 3.0 },  -- Low speed
        { 1.5, 3.1, 3.6 },  -- Medium speed
        { 1.6, 3.4, 4.5 },  -- High speed
    }
end

function TRAIN_SYSTEM:Inputs()
    return {}
end

function TRAIN_SYSTEM:Outputs()
    return {"Command", "CommandKos", "Active", "ProstActive", "KosActive"}
end

function TRAIN_SYSTEM:TriggerSensor(plate)
    local Wag = self.Train
    if self.ShouldReceive and IsValid(plate) and plate.ProstDistance then
        local prev = self.LastTag
        self.LastTag = {
            typ = plate.Mode,
            dist = plate.ProstDistance,
            id = plate.ProstId,
            station = plate.ProstStation,
            path = Wag:ReadCell(49167),
            doors = plate.RightDoors
        }
        self.LastThink = CurTime()
        self.LastTagTime = CurTime()
        self.LastThinkSpeed = Wag.SpeedSign * Wag.Speed
        self.Distance = plate.ProstDistance
        self.Readings = self.Readings + 1

        self.WrongDirection = prev and self.Active > 0 and prev.typ < self.LastTag.typ
    end
end

local function getBrakeDistance(speed)
    -- wagc=5 twagc=1 speed=10 result=8
    -- wagc=5 twagc=1 speed=20 result=18
    -- wagc=5 twagc=1 speed=30 result=32
    -- wagc=5 twagc=1 speed=40 result=52
    -- wagc=5 twagc=1 speed=50 result=83
    -- wagc=5 twagc=1 speed=60 result=115
    -- wagc=5 twagc=1 speed=70 result=157
    if speed < 2.7 then return 0.5 end
    if speed < 6 then return 2 end
    if speed < 10 then return 4 end
    return 0.0498 * math.pow(speed, 1.894)
end

local prostKeyframes = {
    {250, 59}, {150, 55}, {110, 50}, {90, 45}, {70, 40}, {60, 35}, {50, 30}, {40, 25}, {10, 12},
}
local function getTargetSpeed(dist)
    local prevDist, prevSpeed
    for _, kf in ipairs(prostKeyframes) do
        local tdist, tspeed = unpack(kf)
        if dist > tdist then
            if not prevDist then
                return tspeed * dist / tdist
            else
                return Lerp((prevDist - tdist - (prevDist - dist)) / (prevDist - tdist), tspeed, prevSpeed)
            end
        end
        prevDist = tdist
        prevSpeed = tspeed
    end
    return dist > 10 and dist or 0
end

function TRAIN_SYSTEM:Think()
    local Wag = self.Train
    local BUKP = Wag.BUKP
    local speed = Wag.SpeedSign * Wag.Speed
    if not self.LastThink then self.LastThink = CurTime() self.LastThinkSpeed = speed return end
    local dT = CurTime() - self.LastThink

    local dist = dT * 0.5 * (self.LastThinkSpeed + speed) / 3.6
    if self.Distance then self.Distance = self.Distance - dist end
    local decel = self.LastThinkSpeed and self.LastThinkSpeed > speed and (self.LastThinkSpeed - speed) / dT or nil
    self.LastThink = CurTime()
    self.LastThinkSpeed = speed

    if not Wag.Odometer then
        Wag.Odometer = 0
    end
    Wag.Odometer = Wag.Odometer + math.abs(dist)

    -- For brake distance calibration
    -- if speed > 5 and BUKP.Kos and math.floor(speed * 10) % 100 == 0 then
    --     if self.KosActive < 1 then
    --         self.KosActive = 1
    --         self.CommandKos = 1
    --         self.Distance = 0
    --         self.spd = speed
    --     end
    -- elseif self.KosActive > 0 and speed < 0.1 then
    --     print(self.spd, math.abs(self.Distance))
    --     self.KosActive = 0
    --     self.CommandKos = 0
    --     self.Distance = nil
    --     self.spd = nil
    -- end

    local power = Wag.Electric.UPIPower > 0
    local prostWork = power and BUKP.State == 5 and BUKP.Prost
    local kosWork = power and BUKP.State == 5 and BUKP.Kos
    local work = kosWork or prostWork
    local rv = (1 - Wag.RV["KRO5-6"]) * Wag.PpzPrimaryControls.Value > 0 and BUKP.MainMsg == 0
    local kvBrake = Wag.KV765.Position < 0

    if not power then
        self.Command = 0
        self.CommandKos = 0
        self.Distance = nil
        self.LastTag = nil
        self.LastTagTime = 0
        self.Readings = 0
        self.BlockDoorsL = false
        self.BlockDoorsR = false
    end

    self.Receiving = rv and (prostWork or kosWork) and self.Distance and CurTime() - self.LastTagTime < 0.4
    self.ProstActive = prostWork and self.ProstActive > 0 and 1 or 0
    self.KosActive = kosWork and self.KosActive > 0 and 1 or 0
    self.ShouldReceive = work

    if kosWork and self.KosActive < 1 then
        self.KosActive = self.Receiving and 1 or 0
    elseif not kosWork or self.KosActive > 0 and speed < 0.5 and (self.Distance < 3.2 or self.CommandKos > 0) and (kvBrake or self.CommandKos < 1) then
        self.KosActive = 0
    end

    if prostWork and self.ProstActive < 1 then
        self.ProstActive = self.Receiving and self.LastTag and self.LastTag.typ ~= 1 and not kvBrake and 1 or 0
    elseif not prostWork or not self.Distance or self.ProstActive > 0 and kvBrake then
        self.ProstActive = 0
    end

    if BUKP.BudZeroSpeed < 1 then
        self.OPV = 0
        self.BlockDoorsL = true
        self.BlockDoorsR = true
    elseif not self.LastTag or not work then
        self.BlockDoorsL = false
        self.BlockDoorsR = false
    elseif self.OPV < 1 and self.Distance and math.abs(self.Distance) < 3.2 then
        -- print(Wag:GetWagonNumber(), "opv found", self.Distance)
        self.OPV = 1
        self.BlockDoorsL = not not self.LastTag.doors
        self.BlockDoorsR = not     self.LastTag.doors
    end

    self.Active = math.min(1, self.ProstActive + self.KosActive)
    if self.Active < 1 and self.Distance and self.Distance < -5 then
        -- print(Wag:GetWagonNumber(), "reset", self.Distance)
        self.Distance = nil
    end

    if self.KosActive > 0 and self.CommandKos < 1 and rv then
        if self.WrongDirection then
            self.CommandKos = 1
        else
            local bd = getBrakeDistance(speed, BUKP.MotorWagc, BUKP.TrailerWagc) * (kvBrake and 0.9 or 1)
            local ad = (
                self.ProstActive > 0       and self.Distance + 6.5 or
                speed < 15                 and self.Distance + 3.2 or
                BUKP.ControllerState < -10 and self.Distance + 2.2 or
                self.Distance
            )
            self.CommandKos = bd >= ad and 1 or 0
            -- print(bd, ad)
        end
    end
    if (self.KosActive < 1 or not rv) and self.CommandKos > 0 then
        self.CommandKos = 0
        self.WrongDirection = false
    end

    if decel and work and rv and speed > 15 and BUKP.ControllerState <= -20 then
        if not self.BrakeCalibrationTimer or self.BrakeCalibState ~= BUKP.ControllerState then
            self.BrakeCalibrationTimer = CurTime() + 1.2
            self.BrakeCalibState = BUKP.ControllerState
        elseif CurTime() >= self.BrakeCalibrationTimer then
            local state = math.abs(BUKP.ControllerState)
            local idx, delta
            for curIdx = 1, 3 do
                local curDelta = BrakeSettings[curIdx] - state
                if not delta or math.abs(curDelta) < math.abs(delta) then
                    delta = curDelta
                    idx = curIdx
                end
            end
            local curDecel = decel * BrakeSettings[idx] / state
            local decelMap = self.BrakeDecel[speed < 35 and 1 or speed < 60 and 2 or 3]
            decelMap[idx] = decelMap[idx] + (1 - math.exp(-dT / decelCalibrationTau)) * (curDecel - decelMap[idx])
            -- print(idx, decel, curDecel, decelMap[idx])
        end
    elseif self.BrakeCalibrationTimer then
        self.BrakeCalibrationTimer = nil
        self.BrakeCalibState = nil
    end

    if self.ProstActive > 0 then
        local tspeed = getTargetSpeed(self.Distance)
        local delta = (speed - tspeed) * 0.7
        -- print(tspeed, delta)

        if speed < 15 then
            local wagc = BUKP.MotorWagc + BUKP.TrailerWagc
            local roll = RollingMatrix[wagc < 6 and 1 or 2]
            if speed > 10 then
                self.Command = self.Distance > roll[1] and 0 or self.Distance > roll[2] and -BrakeSettings[1] or self.Distance > 5 and -BrakeSettings[2] or -BrakeSettings[3]
            elseif speed > 4 then
                self.Command = self.Distance > roll[3] and 0 or self.Distance > roll[4] and -BrakeSettings[2] or -BrakeSettings[3]
            else
                self.Command = self.Distance > roll[5] and 0 or self.Distance > roll[6] and -BrakeSettings[2] or -BrakeSettings[3]
            end
        elseif delta > (self.Distance > 150 and 0 or -2.2) then
            local decelMap = self.BrakeDecel[speed < 35 and 1 or speed < 60 and 2 or 3]
            if delta >= decelMap[2] then
                self.Command = -BrakeSettings[3]
            else
                for idx, d in ipairs(decelMap) do
                    if delta < d then
                        self.Command = -BrakeSettings[idx]
                        break
                    end
                end
            end
        else
            self.Command = 0
        end

    else
        self.Command = 0
    end
end
