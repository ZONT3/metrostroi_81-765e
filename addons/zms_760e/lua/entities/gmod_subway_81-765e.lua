AddCSLuaFile()
ENT.Type = "anim"
ENT.PrintName = "81-760E PvVZ"
ENT.Author = ""
ENT.Contact = ""
ENT.Purpose = ""
ENT.Instructions = ""
ENT.Category = "Metrostroi (trains)"
ENT.SkinsType = "81-760e"
ENT.Model = "models/metrostroi_train/81-760e/81_760e_body.mdl"
ENT.NoTrain = false
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.DontAccelerateSimulation = false

ZMS.ImportBaseEnt("Impl765", "gmod_subway_81-765")
if CLIENT then
    if not ENT.ButtonMap then ErrorNoHaltWithStack("Failed to load 765 impl\n") else print("### 765 impl found") end
else
    if not ENT.SyncTable then ErrorNoHaltWithStack("Failed to load 765 impl\n") else print("### 765 impl found") end
end

--------------------------------------------------------------------------------
-- local BaseClass = baseclass.Get("gmod_subway_81-765")
ENT.Base = "gmod_subway_base"  -- TODO Implement 765_impl instead when (if) moving to metrostroi 2025+

local function GetDoorPosition(i, k)
    return Vector(381 - 36.0 + 1 * k - 0.85 * (k == 1 and 1 or 0) - 230 * i, -66 * (1 - 2 * k), -1)
end

ENT.LeftDoorPositions = {}
ENT.RightDoorPositions = {}
for i = 0, 3 do
    table.insert(ENT.LeftDoorPositions, GetDoorPosition(i, 1))
    table.insert(ENT.RightDoorPositions, GetDoorPosition(i, 0))
end
-- Workshop version backport
ENT.LeftDoorPositionsBAK = ENT.LeftDoorPositions
ENT.RightDoorPositionsBAK = ENT.RightDoorPositions

function ENT:ResetSettings()
end

ENT.SubwayTrain = {
    Type = "81-760E",
    Name = "81-760E",
    WagType = 1,
    Manufacturer = "PvVZ",
    ALS = {
        HaveAutostop = true,
        TwoToSix = true,
        RSAs325Hz = true,
        Aproove0As325Hz = false,
        CheckLKT = false,
    },
    EKKType = 765,
    NoFrontEKK = true,
}

ENT.NumberRanges = {{37500, 37699}}

ENT.Spawner = ENT.SpawnerCustom
ENT.Spawner.model = {"models/metrostroi_train/81-760e/81_760e_body.mdl", "models/metrostroi_train/81-760/81_760a_int.mdl", "models/metrostroi_train/81-765/cabin.mdl", "models/metrostroi_train/81-765/headlights_main_off.mdl",}
ENT.Spawner.spawnfunc = ENT.SpawnerSpawnFnc("gmod_subway_81-765e", "gmod_subway_81-766e", "gmod_subway_81-767e")

if CLIENT then
    for k, tbl in ipairs({ENT.LeftDoorPositions or {}, ENT.RightDoorPositions or {}}) do
        for i, pos in ipairs(tbl) do
            local idx = (k - 1) * 4 + i
            ENT.ClientProps["Door" .. idx] = {
                model = "models/metrostroi_train/81-760e/81_760e_door.mdl",
                pos = k == 1 and pos - tbl[1] or tbl[1] - pos * Vector(-1, 1, 1),
                ang = Angle(0, k == 1 and 0 or -180, 0),
                hide = 2,
            }
            ENT.ButtonMap["DoorAddressOpen" .. idx] = {
                pos = pos + Vector(k == 1 and -250 - 10 or 250 + 10, 0, 170) * 0.05,
                ang = Angle(0, k == 1 and 0 or -180, 90),
                width = 50, height = 50, scale = 0.05,
                buttons = {
                    {
                        ID = "DoorAddressButton" .. idx .. "Set",
                        x = 0, y = 0, w = 50, h = 50,
                        tooltip = "Кнопка ИОД",
                    }
                }
            }
            ENT.ButtonMap["DoorAddressOpenOutside" .. idx] = {
                pos = pos + Vector(k == 1 and -200 - 10 or 200 + 10, k == 1 and 24 or -24, 170) * 0.05,
                ang = Angle(0, k == 1 and 180 or 0, 90),
                width = 50, height = 50, scale = 0.05,
                buttons = {
                    {
                        ID = "DoorAddressButton" .. idx .. "Set",
                        x = 0, y = 0, w = 50, h = 50,
                        tooltip = "Кнопка ИОД",
                    }
                }
            }
            ENT.ClientProps["DoorArrdessButton" .. idx] = {
                model = "models/metrostroi_train/81-765/door_button.mdl",
                pos = k == 1 and pos - tbl[1] or tbl[1] - pos * Vector(-1, 1, 1),
                ang = Angle(0, k == 1 and 0 or -180, 0),
                hide = 2,
            }
            ENT.ButtonMap["DoorManualBlock" .. idx] = {
                pos = pos + Vector(k == 1 and 488 or -488, k == 1 and -18 or 18, -715) * 0.05,
                ang = Angle(0, k == 1 and 0 or -180, 90),
                width = 50,
                height = 50,
                scale = 0.05,
                buttons = {
                    {
                        ID = "DoorManualBlock" .. idx .. "Toggle",
                        x = 0,
                        y = 0,
                        w = 50,
                        h = 50,
                        tooltip = "Ручная блокировка",
                        model = {
                            var = "DoorManualBlock" .. idx,
                            model = "models/metrostroi_train/81-717/battery_enabler.mdl",
                            speed = 9, vmin = 1, vmax = 0, sndvol = 0.8, scale = 0.1,
                            snd = function(val) return val and "pak_on" or "pak_off" end,
                            sndmin = 80, sndmax = 1e3 / 3, sndang = Angle(-90, 0, 0),
                        }
                    }
                }
            }
            ENT.ButtonMap["DoorManual" .. idx] = {
                pos = pos - Vector(1200 * (k == 1 and 1 or -1), 0, -2030) * 0.05 / 2,
                ang = Angle(0, k == 1 and 0 or -180, 90),
                width = 1200,
                height = 2030,
                scale = 0.05,
                buttons = {
                    {
                        ID = "DoorManualOpenPush" .. idx .. "Set",
                        x = 300,
                        y = 0,
                        w = 600,
                        h = 2030,
                        tooltip = "Толкать двери",
                    },{
                        ID = "DoorManualOpenPull" .. idx .. "Set",
                        x = 0,
                        y = 0,
                        w = 300,
                        h = 2030,
                        tooltip = "Тянуть двери",
                    },{
                        ID = "DoorManualOpenPull" .. idx .. "Set",
                        x = 900,
                        y = 0,
                        w = 300,
                        h = 2030,
                        tooltip = "Тянуть двери",
                    },
                }
            }
            ENT.ButtonMap["DoorManualOutside" .. idx] = {
                pos = pos + Vector(1600 * (k == 1 and 1 or -1), k == 1 and 20 or -20, 2030) * 0.05 / 2,
                ang = Angle(0, k == 1 and 180 or 0, 90),
                width = 1600,
                height = 2030,
                scale = 0.05,
                buttons = {
                    {
                        ID = "DoorManualOpenPush" .. idx .. "Set",
                        x = 300,
                        y = 0,
                        w = 1000,
                        h = 2030,
                        tooltip = "Раздвигать двери",
                    },{
                        ID = "DoorManualOpenPull" .. idx .. "Set",
                        x = 0,
                        y = 0,
                        w = 300,
                        h = 2030,
                        tooltip = "Закрывать двери",
                    },{
                        ID = "DoorManualOpenPull" .. idx .. "Set",
                        x = 1300,
                        y = 0,
                        w = 300,
                        h = 2030,
                        tooltip = "Закрывать двери",
                    },
                }
            }
        end
    end
    ENT.ClientProps["MezhwagR"] = {
        model = "models/metrostroi_train/81-760/81_760_fence_corrugated.mdl",
        pos = Vector(-464.07, 0, 0),
        ang = Angle(0, 0, 0),
        nohide = true,
    }
    Metrostroi.GenerateClientProps()
end
