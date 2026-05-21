--------------------------------------------------------------------------------
-- АКБ
--------------------------------------------------------------------------------
Metrostroi.DefineSystem("81_765_Battery")
TRAIN_SYSTEM.DontAccelerateSimulation = false

function TRAIN_SYSTEM:Initialize()
    -- Configuration
    self.FactoryCapacity = 110 * 3600  ----- A*second
    self.Capacity = self.FactoryCapacity  -- A*second
    self.ChargeMaxCurrent = 30  ------------ A
    self.InternalResist = 0.04  ------------ Ω
    self.ChargeSumResist = 0.15  ----------- Ω
    self.FactoryChargedVoltage = 77.4  ----- V
    self.RuinedVoltage = 40  --------------- V

    -- Inputs
    self.Load = 0  ----------- W
    self.ChargeVoltage = 0  -- V

    -- Values
    -- Charge level in A*second
    self.Charge = self.Capacity
    -- Battery voltage (V)
    self.Voltage = 69
    -- Current (A) created by load
    self.LoadCurrent = 0
    -- Charge current (A)
    self.Current = 0
    -- Is Working (1/0, backport purposes)
    self.Value = 1

    self.Infinite = false
end

function TRAIN_SYSTEM:Inputs()
    return { "SetInfinite", "Load", "Charge", "Current", "SetCapacity", "SetLevel", "Set", "Open", "Close" }
end

function TRAIN_SYSTEM:Outputs()
    return { "FactoryCapacity", "Capacity", "Load", "ChargeVoltage", "Charge", "Voltage", "Current", "LoadCurrent", "Value" }
end

function TRAIN_SYSTEM:TriggerInput(name, value)
    if name == "SetInfinite" then self.Infinite = value > 0 end

    if not value then return end
    -- Backport
    if name == "Set" or name == "Open" or name == "Close" then return end

    -- Inputs
    if name == "Load" then
        self.Load = value
    elseif name == "Charge" then
        self.ChargeVoltage = value

    -- Should not be used
    elseif name == "Current" then
        self.Current = value

    -- Configuration
    elseif name == "SetCapacity" then
        local k = math.min(1, self.Charge / self.Capacity)
        self.Capacity = value
        self.Charge = value * k
    elseif name == "SetLevel" then
        self.Charge = value * self.Capacity
    end
end

local S = {}
function TRAIN_SYSTEM:Think(dT)
    S.ChrgK = self.Charge / self.FactoryCapacity
    S.Ubase = self.RuinedVoltage + (self.FactoryChargedVoltage - self.RuinedVoltage) * math.pow(S.ChrgK, .65)

    S.Iload = self.Load / S.Ubase
    S.Ubat = S.Ubase - S.Iload * self.InternalResist

    self.Voltage = math.max(S.Ubat + 0.3 * (S.Ubase - S.Ubat), self.ChargeVoltage)
    S.Iload = self.Load / math.max(1, self.Voltage)

    S.Icharge = math.max(0, math.min(self.ChargeMaxCurrent, (self.ChargeVoltage - S.Ubat) / self.ChargeSumResist))
    S.Icharge = S.Icharge * math.pow(1 - math.max(0, math.min(1, (self.Charge / self.Capacity - 0.95) / 0.05)), 2)
    S.Ioverload = math.max(0, S.Iload - (self.ChargeVoltage >= S.Ubat and (150 - S.Icharge) or 0))

    self.LoadCurrent = S.Iload
    self.Current = S.Icharge - S.Ioverload
    self.Value = self.Voltage > 55 and 1 or 0
    if not self.Infinite then
        self.Charge = math.min(self.Capacity, math.max(0, self.Charge + self.Current * dT))
    end
end
