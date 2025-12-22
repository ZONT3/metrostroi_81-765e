--------------------------------------------------------------------------------
-- Блок наддверного табло КБ «Метроспецтехника»
--------------------------------------------------------------------------------
Metrostroi.DefineSystem("81_765_BNT")
TRAIN_SYSTEM.DontAccelerateSimulation = true

function TRAIN_SYSTEM:Initialize()
end

function TRAIN_SYSTEM:Outputs()
end

function TRAIN_SYSTEM:Inputs()
    return {}
end

if TURBOSTROI then return end
function TRAIN_SYSTEM:TriggerInput(name, value)
end

if SERVER then
    function TRAIN_SYSTEM:CANReceive(source, sourceid, target, targetid, textdata, data)
    end

    function TRAIN_SYSTEM:Trigger(name, value)
    end

    function TRAIN_SYSTEM:Think(dT)
        local Wag = self.Train
        local Power = Wag.Electric.Battery80V > 62 and Wag.BUV.Power * (Wag.SF37.Value + Wag.SF38.Value) > 0
        local PowerLeft = Power and Wag.SF37.Value > 0
        local PowerRight = Power and Wag.SF38.Value > 0
    end
end
