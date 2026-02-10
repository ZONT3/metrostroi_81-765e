--------------------------------------------------------------------------------
-- 81-761Э
--------------------------------------------------------------------------------
Metrostroi.DefineSystem("81_761E_Panel")
TRAIN_SYSTEM.DontAccelerateSimulation = false

local PvzToggles = {
    "SF23F12", "SF70F4", "SF22F1",
    "SF23F11", "SF23F9", "SF90F2", "SF23F10", "SF45F5", "SF45F6", "SF45F7", "SF45F8", "SF52F3", "SF61F3",
    "SF45F2", "SF61F4", "SF23F4", "SF45F4", "SF30F4", "SF45F3", "SF30F3", "SF21F1", "SF52F5", "SF52F4",
    "SF80F2", "SF80F13", "SF80F14", "SF80F12", "SF80F8", "SF80F11", "SF80F10", "SF80F7", "SF80F6", "SF80F9",
    "SF30F2", "SF23F5", "SF23F6", "SF30F7", "SF30F9", "SF30F6", "SF30F8", "SF52F2", "SF61F1", "SF61F9",
}

function TRAIN_SYSTEM:Initialize()
    self.Train:LoadSystem("Battery", "Relay", "Switch", {bass = true, normally_closed = true})

    self.Train:LoadSystem("PowerOn", "Relay", "Switch", {bass = true})

    for _, name in ipairs(PvzToggles or {}) do
        self.Train:LoadSystem(name, "Relay", "Switch", {
            bass = true, normally_closed = true,
        })
    end

    -- for legacy dependencies and external addons, TODO - include and rewrite these dependencies as new systems
    self.Train.SF36 = self.Train.SF30F9  -- АСОТП ПЦБК
    self.Train:LoadSystem("SF54", "Relay", "Switch", { bass = true })  -- Видео

    self.SalonLighting1 = 0
    self.SalonLighting2 = 0
    self.LV = 0
    if self.Train.AsyncInverter then self.WorkFan = 0 end

    -- BUD
    for idx = 1, 8 do
        self.Train:LoadSystem("DoorManualBlock" .. idx, "Relay", "Switch", { bass = true })
        self.Train:LoadSystem("DoorManualOpenLever" .. idx, "Relay", "Switch", { bass = true })
        self.Train:LoadSystem("DoorManualOpenLeverPl" .. idx, "Relay", "Switch", { bass = true })
        self.Train:LoadSystem("DoorManualOpenPush" .. idx, "Relay", "Switch", { bass = true })
        self.Train:LoadSystem("DoorManualOpenPull" .. idx, "Relay", "Switch", { bass = true })
        self.Train:LoadSystem("DoorAddressButton" .. idx, "Relay", "Switch", { bass = true })
    end
end

function TRAIN_SYSTEM:Inputs()
    return {}
end

function TRAIN_SYSTEM:Outputs()
    return {"SalonLighting1", "SalonLighting2", "WorkFan", "LV"}
end