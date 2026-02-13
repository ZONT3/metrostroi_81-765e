--------------------------------------------------------------------------------
-- Панель управления 
--------------------------------------------------------------------------------
Metrostroi.DefineSystem("81_760E_Panel")
TRAIN_SYSTEM.DontAccelerateSimulation = false

-- увы, не нашел способа передать это все сюда (в турбострой) из train entity
-- поэтому дублируем часть кода из shared.lua вагона
local PakToggles = {}

local function pmvToggle(name, positions, default)
    PakToggles[name] = {
        positions = positions,
        default = default or 0,
    }
end

pmvToggle("PmvAddressDoors", {0, 3}, 1)
pmvToggle("PmvRpdp", {0, 3})
pmvToggle("PmvPant", {0, 2, 4, 6}, 3)
pmvToggle("PmvParkingBrake", {0, 3})
pmvToggle("PmvAtsBlock", {0, 1, 2, 3})
pmvToggle("PmvFreq", {0, 3})
pmvToggle("PmvLights", {0, 3}, 1)
pmvToggle("PmvEmerPower", {0, 3})
pmvToggle("PmvCond", {0, 3}, 1)

local PpzToggles = {
    "SF42F1", "SF30F1", "SF23F2", "SF23F1", "SF23F3", "SF23F13", "SF23F7", "SF23F8", "SF22F5", "SF22F2", "SF22F3",
    "SF80F5", "SF80F1", "SF80F3", "SF62F1", "SF42F2", "SF30F5", "SF70F1", "SF45F11", "SF45F1", "SF43F3", "SF90F1",
    "PPZUU1", "SF51F1", "SF51F2", "SF52F1", "SF62F3", "SF62F4", "SF61F8", "SF70F5", "SF70F3", "SF70F2",
}

local PvzToggles = {
    "SF23F12", "SF70F4", "SF22F1",
    "SF23F11", "SF23F9", "SF90F2", "SF23F10", "SF45F5", "SF45F6", "SF45F7", "SF45F8", "SF52F3", "SF61F3",
    "SF45F2", "SF61F4", "SF23F4", "SF45F4", "SF30F4", "SF45F3", "SF30F3", "SF21F1", "SF52F5", "SF52F4",
    "SF80F2", "SF80F13", "SF80F14", "SF80F12", "SF80F8", "SF80F11", "SF80F10", "SF80F7", "SF80F6", "SF80F9",
    "SF30F2", "SF23F5", "SF23F6", "SF30F7", "SF30F9", "SF30F6", "SF30F8", "SF52F2", "SF61F1", "SF61F9",
}

function TRAIN_SYSTEM:Initialize()
    self.Train:LoadSystem("Stand", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("ABESD", "Relay", "Switch", { bass = true, normally_closed = true })
    self.Train:LoadSystem("ABESDk", "Relay", "Switch", { bass = true, normally_closed = true })
    self.Train:LoadSystem("SD", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("SDk", "Relay", "Switch", { bass = true, normally_closed = true })
    self.Train:LoadSystem("Ticker", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("KAH", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("KAHk", "Relay", "Switch", { bass = true, normally_closed = true })
    self.Train:LoadSystem("ALS", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("ALSk", "Relay", "Switch", { bass = true, normally_closed = true })
    self.Train:LoadSystem("FDepot", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("PassScheme", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("EmergencyCompressor", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("EmergencyCompressor2", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("EnableBV", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("EnableBVEmer", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("DisableBV", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("Ring", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("R_Program2", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("R_Announcer", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("R_Micro", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("R_Emer", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("R_Program1", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("R_Program11", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("Pr", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("OtklR", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("GlassHeating", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("Washer", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("SC", "Relay", "Switch", { bass = true })

    self.Train:LoadSystem("HeadlightsSwitch", "Relay", "Switch", {
        maxvalue = 2,
        defaultvalue = 0,
        bass = true
    })

    self.Train:LoadSystem("Micro", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("EmergencyControls", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("EmergencyControlsK", "Relay", "Switch", {
        defaultvalue = 1,
        bass = true
    })

    self.Train:LoadSystem("Wiper", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("AutoDrive", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("DoorSelectL", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("DoorSelectR", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("DoorBlock", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("DoorLeft", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("AccelRate", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("EmerBrakeAdd", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("EmerBrakeRelease", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("EmerBrake", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("EmergencyBrake", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("DoorRight", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("HornB", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("HornC", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("DoorClose", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("AttentionMessage", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("Attention", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("AttentionBrake", "Relay", "Switch", { bass = true })

    self.Train:LoadSystem("VentCondMode", "Relay", "Switch", {
        maxvalue = 3,
        defaultvalue = 2,
        bass = true
    })

    self.Train:LoadSystem("VentStrengthMode", "Relay", "Switch", {
        maxvalue = 3,
        defaultvalue = 2,
        bass = true
    })

    self.Train:LoadSystem("VentHeatMode", "Relay", "Switch", {
        maxvalue = 1,
        defaultvalue = 0,
        bass = true
    })

    self.Train:LoadSystem("EmerX1", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("EmerX2", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("EmerCloseDoors", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("EmergencyDoors", "Relay", "Switch", { bass = true })

    self.Train:LoadSystem("CabinLight","Relay","Switch",{ maxvalue = 2, defaultvalue = 0, bass = true})

    for k, cfg in pairs(PakToggles or {}) do
        self.Train:LoadSystem(k, "Relay", "Switch", {
            maxvalue = #cfg.positions - 1,
            defaultvalue = cfg.default or 0,
            bass = true
        })
    end

    for _, name in ipairs(PpzToggles or {}) do
        self.Train:LoadSystem(name, "Relay", "Switch", {
            bass = true,
        })
    end

    -- for legacy dependencies and external addons, TODO - include and rewrite these dependencies as new systems
    self.Train.SA1 = self.Train.PmvParkingBrake
    -- self.Train.SA14 = self.Train.PmvFreq
    self.Train.SF18 = self.Train.SF42F1  -- АНСП пит (от РПДП)
    self.Train.SF19 = self.Train.SF45F1  -- Видео пит
    self.Train.SF20 = self.Train.SF90F1  -- АСОТП ЦБКИ пит
    self.Train.SF21 = self.Train.SF70F1  -- РВС пит
    self.Train.SF36 = self.Train.SF30F9  -- АСОТП ПЦБК
    self.Train.PowerReserve = self.Train.PmvEmerPower
    self.Train:LoadSystem("SF54", "Relay", "Switch", { bass = true })  -- Видео

    for _, name in ipairs(PvzToggles or {}) do
        self.Train:LoadSystem(name, "Relay", "Switch", {
            bass = true, normally_closed = true,
        })
    end

    self.Train:LoadSystem("Battery", "Relay", "Switch", { bass = true, normally_closed = true })
    self.Train:LoadSystem("PowerOn", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("PowerOff", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("BatteryCharge", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("PB", "Relay", "Switch", { bass = true })

    -- MFDU
    self.Train:LoadSystem("MfduF1", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("MfduF2", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("MfduF3", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("MfduF4", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("Mfdu1", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("Mfdu4", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("Mfdu7", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("Mfdu2", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("Mfdu5", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("Mfdu8", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("Mfdu0", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("Mfdu3", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("Mfdu6", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("Mfdu9", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("MfduF5", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("MfduF6", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("MfduF7", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("MfduF8", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("MfduF9", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("MfduHelp", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("MfduKontr", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("MfduTv", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("MfduTv1", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("MfduTv2", "Relay", "Switch", { bass = true })

    -- BUD
    for idx = 1, 8 do
        self.Train:LoadSystem("DoorManualBlock" .. idx, "Relay", "Switch", { bass = true })
        self.Train:LoadSystem("DoorManualOpenLever" .. idx, "Relay", "Switch", { bass = true })
        self.Train:LoadSystem("DoorManualOpenLeverPl" .. idx, "Relay", "Switch", { bass = true })
        self.Train:LoadSystem("DoorManualOpenPush" .. idx, "Relay", "Switch", { bass = true })
        self.Train:LoadSystem("DoorManualOpenPull" .. idx, "Relay", "Switch", { bass = true })
        self.Train:LoadSystem("DoorAddressButton" .. idx, "Relay", "Switch", { bass = true })
    end

    self.Controller = 0

    self.AnnouncerPlaying = 0
    self.CabLight = 0
    self.PanelLights = 0
    self.HeadlightsHalf = 0
    self.HeadlightsFull = 0
    self.RedLights = 0
    self.CabVent = 0
    self.DoorLeftL = 0
    self.DoorRightL = 0
    self.DoorCloseL = 0
    self.DoorBlockL = 0
    self.EmerBrakeL = 0
    self.EmerXodL = 0
    self.KAHl = 0
    self.ALSl = 0
    self.AutoDriveLamp = 0
    self.PRl = 0
    self.OtklRl = 0
    self.R_Linel = 0
    self.R_ChangeRoutel = 0
    self.Washerl = 0
    self.Wiperl = 0
    self.WiperPower = 0
    self.EmergencyControlsl = 0
    self.EmergencyDoorsl = 0
    self.GlassHeatingl = 0
    self.PowerOnl = 0
    self.PowerOffl = 0
    self.BatteryChargel = 0
    self.SalonLighting1 = 0
    self.SalonLighting2 = 0
    self.WorkFan = 0
    self.LV = 0
end

function TRAIN_SYSTEM:Inputs()
    return { "SetController" }
end

function TRAIN_SYSTEM:Outputs()
    return {
        "Controller",
        "AnnouncerPlaying", "TargetController", "CabLight", "PanelLights", "HeadlightsHalf", "HeadlightsFull", "RedLights", "CabVent", "WorkFan", "LV",
        "DoorLeftL", "DoorRightL", "DoorCloseL", "DoorBlockL", "EmerBrakeL", "EmerXodL", "KAHl", "ALSl", "AutoDriveLamp", "PRl", "OtklRl", "R_Linel", "R_ChangeRoutel", "Washerl", "Wiperl",
        "EmergencyControlsl", "EmergencyDoorsl", "GlassHeatingl", "PowerOffl", "PowerOnl", "SalonLighting1", "SalonLighting2", "BatteryChargel", "WiperPower"
    }
end

function TRAIN_SYSTEM:TriggerInput(name, value)
    if name ~= "SetController" then return end
    self.Controller = value
end
