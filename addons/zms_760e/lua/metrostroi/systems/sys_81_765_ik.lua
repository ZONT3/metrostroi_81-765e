--------------------------------------------------------------------------------
-- Шина ЦИК (информационного комплекса)
-- Автор - ZONT_ a.k.a. enabled person
--------------------------------------------------------------------------------
Metrostroi.DefineSystem("81_765_IK")
TRAIN_SYSTEM.DontAccelerateSimulation = true

function TRAIN_SYSTEM:Initialize()
    self.Executables = {"Init", "Reset", "Execute"}
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
        self[textdata] = data
    end

    function TRAIN_SYSTEM:Trigger(name, value)
    end

    function TRAIN_SYSTEM:Get(str, arg, ...)
        if arg then
            str = string.format(str, arg, ...)
        end
        return self[str]
    end

    function TRAIN_SYSTEM:Think(dT)
        local Wag = self.Train
        local Power = Wag.Electric.Battery80V > 62 and Wag.BUV.Power * (Wag.SF45F7.Value + Wag.SF45F8.Value) > 0
        Wag:SetNW2Bool("DoorAlarmState", Power and self.DoorAlarm or false)

        for _, name in ipairs(self.Executables) do
            if self[name] then
                self[name] = false
                if Power then
                    self["Run" .. name](self)
                end
            end
        end
    end

    function TRAIN_SYSTEM:RunInit()
        local BNT = self.Train.BNT
        BNT.Stations = self.Stations
        BNT.LastStation = self.LastStation
        BNT.Route = self.Route
        BNT.Loop = self.Loop
        BNT.CfgIdx = self.CfgIdx
        BNT.ActiveRoute = self.RouteId
        self.ActiveRoute = self.RouteId
        BNT:SetStation(1)
    end

    function TRAIN_SYSTEM:RunReset()
        self.Train.BNT.ActiveRoute = nil
        self.ActiveRoute = nil
        self.Train.BNT.Working = false
    end

    function TRAIN_SYSTEM:RunExecute()
        if self.RouteId ~= self.ActiveRoute then
            self:RunReset()
            return
        end

        local BNT = self.Train.BNT
        if self.Station == BNT.Station and self.Depart then
            BNT:AnimateNext()
        else
            BNT:SetStation(self.Station)
            if self.Depart then
                BNT:AnimateNext()
            end
        end

        BNT.Terminus = false
        self.Train.BUD:TriggerInput("Depart", self.Depart)

        if self.Depart then
            BNT:AnimateDepart()
        elseif not self.Terminus then
            BNT:AnimateArrive()
        else
            BNT:AnimateTerminus()
            BNT.Terminus = true
        end

        BNT.Working = true
    end
end