-- 81-765 VVVF async invertor equipment KATP-3 / KATP-4 (sort of)
Metrostroi.DefineSystem("81_765_VVVF")
TRAIN_SYSTEM.DontAccelerateSimulation = false

function TRAIN_SYSTEM:Initialize()
    -- Physics state
    self.Torque = 0.0               -- Relative units of torque, m/s²

    -- Inverter state
    self.Assembly = 0               -- Currently assembled scheme mode, 1/0/-1
    self.Disassembled = 0           -- Scheme disassembled by invertor, 1/0
    self.State = 0.0                -- Nominal output state, [1, 0]
    self.InverterFrequency = 0.0    -- Output per-phase frequency, Hz
    self.TargetCurrent = 0.0        -- Target Current, that inverter will hold, A
    self.Current = 0.0              -- Total electric current, A
    self.Drive = 0                  -- Drive mode signal, 1/0
    self.Brake = 0                  -- Brake model signal, 1/0
    self.DeltaSpeed = 0             -- Actual acceleration, m/s²
    self.Load = 0                   -- Load factor
    self.LowSpeedMode = 0           -- Low speed program factor, [0, 1]

    -- Inverter input signals
    self.Speed = 0                  -- Speed of train, km/h
    self.Power = 0                  -- HV Power supply assembled, 1/0
    self.Voltage = 0                -- HV, V
    self.Command = 0                -- Command collective signal (target mode and level), [4, -3]
    self.WeightLoadRatio = 0        -- [0, inf]
    self.Slope = 0                  -- Slope mode signal, 1/0

    -- Internals
    self.LastSpeed = 0
end

function TRAIN_SYSTEM:Inputs()
    return { "Speed", "Power", "Voltage", "Command", "WeightLoadRatio", "Load" }
end

function TRAIN_SYSTEM:Outputs()
    return {
        "Drive", "Brake", "Assembly", "Torque", "Current", "State", "InverterFrequency", "Disassembled", "LowSpeedMode", "Load",
        "TargetCurrent", "Speed", "Voltage", "Power", "Command", "WeightLoadRatio", "Slope", "DeltaSpeed"
    }
end

function TRAIN_SYSTEM:TriggerInput(name, value)
    if self[name] then self[name] = value end
end

local max, min, abs, exp, pi, random = math.max, math.min, math.abs, math.exp, math.pi, math.random

local function sgn(x)
    return x > 0 and 1 or x < 0 and -1 or 0
end

local function Rand(a, b)
    return a + (b - a) * random()
end

local function Lerp(t, from, to)
    return from + (to - from) * t
end

local function Clamp(val, minv, maxv)
    return max(minv, min(maxv, val))
end

local function interpolate(tbl, num)
    for i = 1, #tbl do
        local curr, next = tbl[i], tbl[i + 1]
        if not next then
            return curr[2]
        elseif curr[1] <= num and num <= next[1] then
            return curr[2] + (next[2] - curr[2]) * ((num - curr[1]) / (next[1] - curr[1]))
        end
    end
end

local function GetTargetCurrent(command)
    if math.abs(command) < 1 then
        return 0, 0
    elseif command > 0 then
        return Lerp((command - 1) / 3, 150, 320), Lerp((command - 1) / 3, 0.67, 0.79)
    else
        return Lerp((-command - 1) / 2, 150, 320), Lerp((-command - 1) / 2, 0.55, 0.85)
    end
end

TRAIN_SYSTEM.xTorque = {
    { 0	 , 1.65 },
    { 150, 1.65 },
    { 200, 1.7 },
    { 260, 1.26 },
    { 320, 1.11 },
    { 340, 1.05 },
}
TRAIN_SYSTEM.xF = {
    { 0,  0.10 },
    { 1,  1.507 },
    { 3,  4.16 },
    { 5,  6.96 },
    { 10, 14.16 },
    { 15, 21.31 },
    { 20, 28.30 },
    { 30, 41.71 },
    { 40, 55.01 },
    { 60, 81.67 },
    { 80, 108.33 },
    { 90, 121.61 },
}

-- Physical parameters for the engine
local P = 4 -- No of poles       Poles in the engine
local R1 = 0.03 -- Ohm           Active stator resistance
local R2 = 0.03 -- Ohm           Active rotor resistance
local X1 = 1.1 -- Ohm reactive   Reactive stator resistance
local X2 = 1.1 -- Ohm reactive   Reactive rotor resistance
local Xm = 30 -- Ohm reactive    Air gap reactive resistance
local Inverter_PWM0 = 1.5 -- PWM On
local Inverter_PWM1 = 3   -- PWM Off

function TRAIN_SYSTEM:Think(dT)
    local v_a = self.Speed
    local v = max(1, v_a)
    local HV = self.Voltage >= 550 and self.Voltage <= 975
    local assembly = self.Assembly
    local command = self.Command
    local slope = self.Slope

    if self.LastSpeed then
        local dV = (v_a / 3.6 - self.LastSpeed / 3.6) / dT
        self.DeltaSpeed = dV + (self.DeltaSpeed - dV) * exp(-2 * dT)
    end
    self.LastSpeed = v_a

    if command > 0 then
        self.Drive = command
        self.Brake = 0
    elseif command < 0 then
        self.Drive = 0
        self.Brake = abs(command)
    else
        self.Drive = 0
        self.Brake = 0
    end

    local ls, ls_k
    local loadFactor = self.Load * (abs(command) / (command > 0 and 4 or 3)) ^ 2
    loadFactor = Clamp(slope * 2 + loadFactor - 0.75 / 1.1, 0, 1) * 5.0 - Clamp(0.4 - loadFactor - slope * 2 / 0.4, 0, 1) * 4.0
    if assembly > 0 then
        ls = 1 - Clamp((v - 12.2 + loadFactor) / 0.85, 0, 1)
        ls_k = 1.1 - 0.2 * Clamp((v - 10.5 + loadFactor) / 8.7, 0, 1)
    else
        ls = 1 - Clamp((v - 15 + loadFactor) / 0.5, 0, 1)
        ls_k = 1.1 - 0.2 * Clamp((v - 13 + loadFactor) / 8.7, 0, 1)
    end
    if assembly > 0 and ls > self.LowSpeedMode or assembly < 0 and ls < self.LowSpeedMode then
        ls = self.LowSpeedMode
    end

    local TargetMode = 0
    if self.Brake * self.Power > 0.5 and (assembly < 0 or HV) then
        TargetMode = -1
    elseif self.Drive * self.Power > 0.5 then
        TargetMode = 1
    end

    self.Disassembled = self.Brake * ((v <= 7 or assembly >= 0 and not HV) and 1 or 0)
    if TargetMode ~= assembly and self.State < 0.01 then assembly = TargetMode end
    if self.Power == 0 or (not HV and assembly > 0) then assembly = 0 end

    local I_target, k = 0, 0
    if assembly == TargetMode and TargetMode ~= 0 and self.Disassembled == 0 then
        I_target, k = GetTargetCurrent(command)
        local k_r = 1 - Clamp(0.77 * Clamp((v - 41) / 20, 0, 1) * (1 - abs(command) / (command < 0 and 1.75 or 4.4)), 0, 1)
        local k_w = 1 + (slope == 1 and 0.1 or self.WeightLoadRatio * 0.1)
        if command > 0 then
            k = (1 - k) + k * Clamp((v - 3) / (16 * ls_k), 0, 1)
            I_target = I_target * k * k_w * k_r
        elseif command < 0 then
            k = (1 - k) + k * Clamp((v - 3) / (22 * ls_k), 0, 1)
            I_target = I_target * k * k_w * k_r
        end
        self.State = max(0, min(1, self.State + (abs(I_target) - abs(self.Current)) / 400 * Rand(0.9, 1.15) * Inverter_PWM0 * dT))
    else
        self.State = max(0, self.State - Inverter_PWM1 * Rand(0.9, 1.15) * dT)
    end

    local f = interpolate(self.xF, v)
    local V = 750 * self.State * assembly
    local n = 3200 * v / 80
    local ns = 120 * (f / P)
    local s = (ns - n) / ns
    local R = math.sqrt((R1 + R2 / s) ^ 2 + (X1 + X2) ^ 2)
    local I = V / Xm + V / R
    local xTorque = interpolate(self.xTorque, abs(I))
    local Torque = (2 * 3 * V ^ 2 * R2 / (2 * pi * f * s * R ^ 2)) * 0.000744 * assembly * xTorque

    -- Outputs
    self.Assembly = assembly
    self.LowSpeedMode = ls
    self.InverterFrequency = f
    self.Current = I
    self.TargetCurrent = I_target
    self.Torque = Torque

    -- Load koef
    if abs(Torque) < 0.0001 then self.Load = 0 return end
    local dV = self.DeltaSpeed
    self.Load = max(self.State, 0.65) * sgn(Torque) * (Torque - dV) / 0.3
end


-- debug
if TURBOSTROI then return end

if CLIENT then
    local color = Color(255, 255, 255)
    local color_bg = Color(0, 0, 0, 100)
    hook.Add("HUDPaint", "765.VVVF.Debug", function()
        local ply = LocalPlayer()
        local wag = IsValid(ply) and ply.InMetrostroiTrain
        if not IsValid(wag) then return end

        local text = Format(
            "S=% 05.2f I=% 07.2fA I_t=% 07.2fA f=% 06.2fHz T=% 06.2fm/s²\nV=% 06.2fkm/h U=% 07.2fV Cmd=% 05.2f Cmd_s=%01d k_m=% 05.2f\ndV=% 06.2fm/s² k_L=% 05.2f k_LS=%04.2f",
            wag:GetNW2Int("VVVF:State", -1) / 100,
            wag:GetNW2Int("VVVF:Current", -1) / 100,
            wag:GetNW2Int("VVVF:TargetCurrent", -1) / 100,
            wag:GetNW2Int("VVVF:InverterFrequency", -1) / 100,
            wag:GetNW2Int("VVVF:Torque", -1) / 100,
            wag:GetNW2Int("VVVF:Speed", -1) / 100,
            wag:GetNW2Int("VVVF:Voltage", -1) / 100,
            wag:GetNW2Int("VVVF:Command", -1) / 100,
            wag:GetNW2Int("VVVF:Slope", -1),
            wag:GetNW2Int("VVVF:WeightLoadRatio", -1) / 100,
            wag:GetNW2Int("VVVF:DeltaSpeed", -1) / 100,
            wag:GetNW2Int("VVVF:Load", -1) / 100,
            wag:GetNW2Int("VVVF:LowSpeedMode", -1) / 100
        )

        surface.SetFont("DebugFixed")
        local w, h = surface.GetTextSize(text)
        surface.SetDrawColor(color_bg)
        surface.DrawRect(16, 16, w + 32, h + 32)
        draw.DrawText(text, "DebugFixed", 32, 32, color, TEXT_ALIGN_LEFT)
    end)
end

if SERVER then
    hook.Add("Think", "765.VVVF.Debug", function()
        for _, ply in player.Iterator() do
            local wag = ply:GetTrain()
            local vvvf = IsValid(wag) and wag.AsyncInverter
            if vvvf then
                wag:SetNW2Int("VVVF:State", vvvf.State * 100)
                wag:SetNW2Int("VVVF:Current", vvvf.Current * 100)
                wag:SetNW2Int("VVVF:TargetCurrent", vvvf.TargetCurrent * 100)
                wag:SetNW2Int("VVVF:InverterFrequency", vvvf.InverterFrequency * 100)
                wag:SetNW2Int("VVVF:Torque", vvvf.Torque * 100)
                wag:SetNW2Int("VVVF:Speed", vvvf.Speed * 100)
                wag:SetNW2Int("VVVF:Voltage", vvvf.Voltage * 100)
                wag:SetNW2Int("VVVF:Command", vvvf.Command * 100)
                wag:SetNW2Int("VVVF:WeightLoadRatio", vvvf.WeightLoadRatio * 100)
                wag:SetNW2Int("VVVF:Slope", vvvf.Slope)
                wag:SetNW2Int("VVVF:DeltaSpeed", vvvf.DeltaSpeed * 100)
                wag:SetNW2Int("VVVF:Load", vvvf.Load * 100)
                wag:SetNW2Int("VVVF:LowSpeedMode", vvvf.LowSpeedMode * 100)
            end
        end
    end)
end
