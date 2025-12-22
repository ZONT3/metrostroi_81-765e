--------------------------------------------------------------------------------
-- 81-761Э
--------------------------------------------------------------------------------
Metrostroi.DefineSystem("81_761E_Panel")
TRAIN_SYSTEM.DontAccelerateSimulation = false
function TRAIN_SYSTEM:Initialize()
    self.Train:LoadSystem("Battery", "Relay", "Switch", {bass = true, normally_closed = true})

    self.Train:LoadSystem("PowerOn", "Relay", "Switch", {bass = true})

    --Автоматы
    for i = 31, 59 do
        self.Train:LoadSystem("SF" .. i, "Relay", "Switch", {
            normally_closed = true,
            bass = true
        })
    end

    self.Train:LoadSystem("SF80F9", "Relay", "Switch", { normally_closed = true, bass = true })

    self.SalonLighting1 = 0
    self.SalonLighting2 = 0
    self.LV = 0
    if self.Train.AsyncInverter then self.WorkFan = 0 end
end

function TRAIN_SYSTEM:Inputs()
    return {}
end

function TRAIN_SYSTEM:Outputs()
    return {"SalonLighting1", "SalonLighting2", "WorkFan", "LV"}
end