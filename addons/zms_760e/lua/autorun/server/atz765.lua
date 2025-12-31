timer.Simple(1, function()
    ZMS.ATZ.Register("aod", {
        desc = "Включить АОД на вагоне. Арг.: [<сразу выключить, 0/1> [<вернуть пломбу после очистки, 0/1>]]",
        restrict_types = {"76[013]e"},
        restrict_desc = "только 760Э/761Э/763Э",
        on_run = function(wagon, args, case)
            case.door_idx = math.random(8)
            case.lever = wagon["DoorManualOpenLever" .. case.door_idx]
            case.pl = wagon["DoorManualOpenLeverPl" .. case.door_idx]
            if case.lever and case.pl then
                case.pl:TriggerInput("Close", 1)
                case.lever:TriggerInput("Close", 1)
                if args[1] and tonumber(args[1]) >= 1 then
                    timer.Simple(1.2, function() case.lever:TriggerInput("Open", 1) end)
                end
            end
            case.restore_pl = args[2] and tonumber(args[2]) >= 1 or false
        end,
        cleanup = function(wagon, case) if IsValid(wagon) and case.lever then
            case.lever:TriggerInput("Open", 1)
            if case.pl and case.restore_pl then
                case.pl:TriggerInput("Open", 1)
            end
        end end
    })
end)
