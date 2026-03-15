--------------------------------------------------------------------------------
-- 81-760Э «Чурá» Base entity by ZONT_ a.k.a. enabled person
--------------------------------------------------------------------------------
-- Logic of 81-720A Experimental engines sounds by fixinit75
-- located at ExperimentalAsync method, permission granted for this addon
--------------------------------------------------------------------------------
include("shared.lua")
ENT.ClientProps = {}
ENT.ButtonMap = {}
ENT.ClientSounds = {}
ENT.AutoAnims = {}
ENT.ClientPropsInitialized = false

ENT.ButtonMap["PVZ"] = {
    pos = Vector(450.75, 53.75, 17.8),
    ang = Angle(0, -90, 90),
    width = 305,
    height = 425,
    scale = 0.05,
    hideseat = 0.2,
    buttons = {}
}
table.Add(ENT.ButtonMap["PVZ"].buttons, ENT.PvzToggles)

ENT.ButtonMap["Power"] = {
    pos = Vector(448.7, 43.2, -6.3),
    ang = Angle(0, -90, 90),
    width = 50,
    height = 50,
    scale = 0.0625,
    hideseat = 0.2,
    buttons = {
        {
            ID = "PowerOnSet",
            x = 17,
            y = 25,
            radius = 20,
            tooltip = "Бортсеть вкл",
            model = {
                model = "models/metrostroi_train/81-760/81_760_button_red.mdl",
                z = -0.5,
                var = "PowerOn",
                speed = 12,
                vmin = 0,
                vmax = 0.5,
                sndvol = 0.3,
                snd = function(val) return val and "button_square_on" or "button_square_off" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
    }
}

ENT.ButtonMap["FrontPneumatic"] = {
    pos = Vector(426.0, -65.0, -57.7),
    ang = Angle(0, 0, 90),
    width = 230,
    height = 100,
    scale = 0.1,
    hideseat = 0.2,
    hide = true,
    buttons = {
        {
            ID = "FrontBrakeLineIsolationToggle",
            x = 92,
            y = 64,
            radius = 32,
            tooltip = "Концевой кран тормозной магистрали",
            model = {
                var = "FrontBrakeLineIsolation",
                sndid = "FrontBrake",
                states = {"Train.Buttons.Opened", "Train.Buttons.Closed"}
            }
        },
        {
            ID = "FrontTrainLineIsolationToggle",
            x = 192,
            y = 64,
            radius = 32,
            tooltip = "Концевой кран напорной магистрали",
            model = {
                var = "FrontTrainLineIsolation",
                sndid = "FrontTrain",
                states = {"Train.Buttons.Opened", "Train.Buttons.Closed"}
            }
        },
    }
}

ENT.ClientProps["FrontBrake"] = {
    model = "models/metrostroi_train/81-760/81_760_crane_k23.mdl",
    pos = Vector(434.9, -63.2, -64.1),
    ang = Angle(0, 90, 0),
    hide = 2,
}

ENT.ClientProps["FrontTrain"] = {
    model = "models/metrostroi_train/81-760/81_760_crane_k23.mdl",
    pos = Vector(444.9, -60.35, -66.1),
    ang = Angle(0, 90, 0),
    hide = 2,
}

ENT.ClientSounds["FrontBrakeLineIsolation"] = {{"FrontBrake", function() return "disconnectvalve" end, 1, 1, 50, 1e3, Angle(-90, 0, 0)}}
ENT.ClientSounds["FrontTrainLineIsolation"] = {{"FrontTrain", function() return "disconnectvalve" end, 1, 1, 50, 1e3, Angle(-90, 0, 0)}}
ENT.ButtonMap["RearPneumatic"] = {
    pos = Vector(-458.0, -65.0, -57.7),
    ang = Angle(0, 0, 90),
    width = 230,
    height = 100,
    scale = 0.1,
    hideseat = 0.2,
    hide = true,
    buttons = {
        {
            ID = "RearBrakeLineIsolationToggle",
            x = 92,
            y = 64,
            radius = 32,
            tooltip = "Концевой кран тормозной магистрали",
            model = {
                var = "RearBrakeLineIsolation",
                sndid = "RearBrake",
                states = {"Train.Buttons.Opened", "Train.Buttons.Closed"}
            }
        },
        {
            ID = "RearTrainLineIsolationToggle",
            x = 192,
            y = 64,
            radius = 32,
            tooltip = "Концевой кран напорной магистрали",
            model = {
                var = "RearTrainLineIsolation",
                sndid = "RearTrain",
                states = {"Train.Buttons.Opened", "Train.Buttons.Closed"}
            }
        },
    }
}

ENT.ClientProps["RearBrake"] = {
    model = "models/metrostroi_train/81-760/81_760_crane_k23.mdl",
    pos = Vector(-449.1, -63.2, -64.1),
    ang = Angle(0, 90, 0),
    hide = 2,
}

ENT.ClientProps["RearTrain"] = {
    model = "models/metrostroi_train/81-760/81_760_crane_k23.mdl",
    pos = Vector(-439.2, -60.35, -66.1),
    ang = Angle(0, 90, 0),
    hide = 2,
}

ENT.ClientSounds["RearBrakeLineIsolation"] = {{"RearBrake", function() return "disconnectvalve" end, 1, 1, 50, 1e3, Angle(-90, 0, 0)}}
ENT.ClientSounds["RearTrainLineIsolation"] = {{"RearTrain", function() return "disconnectvalve" end, 1, 1, 50, 1e3, Angle(-90, 0, 0)}}

ENT.ButtonMap["ClosetCapL"] = {
    pos = Vector(445.5, 63, 26),
    ang = Angle(0, -90, 90),
    width = 600,
    height = 1200,
    scale = 0.0625,
    hide = 0.8,
    buttons = {
        {
            ID = "CouchCapL",
            x = 0,
            y = 0,
            w = 600,
            h = 1200,
            tooltip = "Шкаф"
        }
    }
}

ENT.ButtonMap["ClosetCapLop"] = {
    pos = Vector(264.6, 45.6, 20),
    ang = Angle(0, 0, 81),
    width = 600,
    height = 1200,
    scale = 0.0625,
    hide = 0.8,
    buttons = {
        {
            ID = "CouchCapL",
            x = 0,
            y = 0,
            w = 600,
            h = 1200,
            tooltip = "Шкаф"
        }
    }
}

ENT.ButtonMap["ClosetCapR"] = {
    pos = Vector(445.5, -63, -49),
    ang = Angle(0, 90, -90),
    width = 720,
    height = 950,
    scale = 0.05,
    hide = 0.8,
    buttons = {
        {
            ID = "CouchCapR",
            x = 0,
            y = 0,
            w = 720,
            h = 950,
            tooltip = "Шкаф"
        }
    }
}

ENT.ButtonMap["ClosetCapRop"] = {
    pos = Vector(264.6, -36, -54),
    ang = Angle(0, 0, -81),
    width = 720,
    height = 950,
    scale = 0.05,
    hide = 0.8,
    buttons = {
        {
            ID = "CouchCapR",
            x = 0,
            y = 0,
            w = 720,
            h = 950,
            tooltip = "Шкаф"
        }
    }
}

ENT.ButtonMap["BoxR"] = {
    pos = Vector(450.5, -62, -49),
    ang = Angle(0, 90, -90),
    width = 720,
    height = 950,
    scale = 0.05,
    hide = 0.8,
    buttons = {
        {
            ID = "EmergencyBrakeValveToggle",
            x = 500,
            y = 250,
            w = 60,
            h = 100,
            tooltip = "EmergencyBrakeValve",
            model = {
                var = "EmergencyBrakeValve",
            }
        },
    }
}

ENT.ClientProps["Stopkran"] = {
    model = "models/metrostroi_train/81-760/81_760_crane_handle_red.mdl",
    pos = Vector(451.8, -35.4, -32.9),
    ang = Angle(180, 180, -90),
    hide = 2,
}
ENT.ClientSounds["EmergencyBrakeValve"] = {{"Stopkran", function() return "disconnectvalve" end, 1, 1, 50, 1e3, Angle(-90, 0, 0)}}

for i = 0, 4 do
    local name = "TrainNumberL" .. i
    ENT.ClientProps[name] = {
        model = "models/metrostroi_train/81-760/numbers/number_0.mdl",
        pos = Vector(0, 0, 0),
        ang = Angle(0, 90, 0),
        hide = 1.5,
        callback = function(ent) ent.WagonNumber = false end,
    }
    ENT.ClientProps[name] = {
        model = "models/metrostroi_train/81-760/numbers/number_0.mdl",
        pos = Vector(0, 0, 0),
        ang = Angle(0, -90, 0),
        hide = 1.5,
        callback = function(ent) ent.WagonNumber = false end,
    }
end

for i = 1, 4 do
    ENT.ButtonMap["BNTL" .. i] = {
        pos = Vector(319 - 229.975 * (i - 1), 46.24, 53.21),
        ang = Angle(0, 0, 119.9),
        width = 3840,
        height = 512,
        scale = 0.0134,
        system = "LBnt",
        hide = 1,
    }
    ENT.ButtonMap["BNTR" .. i] = {
        pos = Vector(-319 - 229.975 * (i - 4), -46.24, 53.21),
        ang = Angle(180, 0, -60.1),
        width = 3840,
        height = 512,
        scale = 0.0134,
        system = "RBnt",
        hide = 1,
    }
    ENT.ClientProps["BntLcdL" .. i] = {
        model = "models/metrostroi_train/81-765/bnt_lcd.mdl",
        pos = Vector(319 - 229.975 * (i - 1), 46.4, 52.5) + Vector(25.72, 2, -2),
        ang = Angle(119.9, -90, 0),
        hide = 1,
    }
    ENT.ClientProps["BntLcdR" .. i] = {
        model = "models/metrostroi_train/81-765/bnt_lcd.mdl",
        pos = Vector(-319 - 229.975 * (i - 4), -46.4, 52.5) - Vector(25.72, 2, 2),
        ang = Angle(119.9, 90, 0),
        hide = 1,
    }
end

ENT.ClientProps["Salon"] = {
    model = "models/metrostroi_train/81-760/81_761a_int.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hide = 2,
}

ENT.ClientProps["BoxIntR"] = {
    model = "models/metrostroi_train/81-760/81_761a_box_int_r.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hide = 2,
}

ENT.ClientProps["BoxDoorL"] = {
    model = "models/metrostroi_train/81-760/81_761a_box_door_l.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hide = 2,
}

ENT.ClientProps["BoxDoorR"] = {
    model = "models/metrostroi_train/81-760/81_761a_box_door_r.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hide = 2,
}

ENT.ClientProps["SalonLightsHalf"] = {
    model = "models/metrostroi_train/81-760/81_760_lamp_int_half.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hide = 2,
}

ENT.ClientProps["SalonLightsFull"] = {
    model = "models/metrostroi_train/81-760/81_761_lamp_int_full.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hide = 2,
}

ENT.ClientProps["VmLv"] = {
    model = "models/metrostroi_train/81-760/81_760_arrow_electric.mdl",
    pos = Vector(448.42, 45, -8.82),
    ang = Angle(0, -90, 0),
    hide = 0.2,
}

ENT.ClientProps["VmHv"] = {
    model = "models/metrostroi_train/81-760/81_760_arrow_electric.mdl",
    pos = Vector(457.55, -42.825, -27.43),
    ang = Angle(0, -90, 0),
    hide = 0.2,
}

ENT.ClientProps["MnBc"] = {
    model = "models/metrostroi_train/81-760/81_761_arrow_nm.mdl",
    pos = Vector(455.09, -53.9, -21.3),
    ang = Angle(45.1, 90, 0),
    hideseat = 0.2,
}

ENT.ClientProps["MnTl"] = {
    model = "models/metrostroi_train/81-760/81_761_arrow_nm.mdl",
    pos = Vector(455.07, -47.6, -21.3),
    ang = Angle(45.1, 90, 0),
    hideseat = 0.2,
}

ENT.ClientProps["MnBl"] = {
    model = "models/metrostroi_train/81-760/81_761_arrow_tm.mdl",
    pos = Vector(455.09, -47.6, -21.3),
    ang = Angle(45.1, 90, 0),
    hideseat = 0.2,
}

ENT.ClientProps["FenceR"] = {
    model = "models/metrostroi_train/81-760/81_760_fence_corrugated.mdl",
    pos = Vector(-464.07, 0, 0),
    ang = Angle(0, 0, 0),
    nohide = true,
}

ENT.ClientProps["FenceF"] = {
    model = "models/metrostroi_train/81-760/81_760_fence_corrugated.mdl",
    pos = Vector(464.37, 0, 0),
    ang = Angle(0, 0, 0),
    nohide = true,
}

ENT.ClientProps["FencePlR"] = {
    model = "models/metrostroi_train/81-760/81_760_fence_corrugated_platform.mdl",
    pos = Vector(-480.15, 0, 0),
    ang = Angle(0, 90, 0),
    hide = 1,
}

ENT.ClientProps["FencePlF"] = {
    model = "models/metrostroi_train/81-760/81_760_fence_corrugated_platform.mdl",
    pos = Vector(480.15, 0, 0),
    ang = Angle(0, -90, 0),
    hide = 1,
}

local bs_pos = {
    [1] = Vector(-27.93, 40.5, -18.36),
    [2] = Vector(-27.93, -39.5, -18.36),
    [3] = Vector(27.93, 39.5, -18.36),
    [4] = Vector(27.93, -40.5, -18.36),
}

for i = 1, 8 do
    local name = "BS" .. i
    ENT.ClientProps[name] = {
        model = "models/metrostroi_train/81-760/81_760_brake_shoe.mdl",
        pos = Vector(0, 0, -78),
        ang = Angle(0, 180 - 180 * (i % 2), 0),
        hide = 0.5,
        callback = function(ent, cl_ent)
            local bogey = i <= 4 and ent:GetNW2Entity("FrontBogey") or i > 4 and ent:GetNW2Entity("RearBogey")
            if not IsValid(bogey) then ent:ShowHide(name, false) return end
            cl_ent:SetParent(bogey)
            cl_ent:SetPos(bogey:LocalToWorld(bs_pos[i > 4 and i - 4 or i]))
            local ang = bogey:GetAngles()
            cl_ent:SetAngles((i <= 2 or i > 4 and i <= 6) and Angle(-ang.x, 180 + ang.y, -ang.z) or ang)
        end,
    }
end

for i = 1, 4 do
    local name = "TR" .. i
    ENT.ClientProps[name] = {
        model = "models/metrostroi_train/81-760/81_760_pantograph.mdl",
        pos = Vector(0, 0, 0),
        ang = Angle(0, 180 * (i % 2), 0),
        hide = 2,
        callback = function(ent, cl_ent)
            local bogey = i > 2 and ent:GetNW2Entity("RearBogey") or ent:GetNW2Entity("FrontBogey")
            if not IsValid(bogey) then ent:ShowHide(name, false) return end
            cl_ent:SetParent(bogey)
            cl_ent:SetPos(bogey:GetPos())
            local ang = bogey:GetAngles()
            cl_ent:SetAngles(i % 2 == 1 and Angle(-ang.x, 180 + ang.y, -ang.z) or ang)
        end,
    }
end

ENT.ButtonMap["K23"] = {
    pos = Vector(123, -60, -58),
    ang = Angle(0, 0, 90),
    width = 170,
    height = 150,
    scale = 0.1,
    buttons = {
        {
            ID = "K23Toggle",
            x = 0,
            y = 0,
            w = 170,
            h = 150,
            tooltip = "К23",
            model = {
                var = "K23",
                sndid = "K23",
            }
        },
    }
}

ENT.ClientProps["K23Valve"] = {
    model = "models/metrostroi_train/81-760/81_760_crane_k23.mdl",
    pos = Vector(131.42, -64.14, -64.6),
    ang = Angle(0, 0, 0),
    hide = 2,
}

ENT.ClientSounds["K23ValveIsolation"] = {{"K23Valve", function() return "disconnectvalve" end, 1, 1, 50, 1e3, Angle(-90, 0, 0)}}
ENT.ButtonMap["K31Cap"] = {
    pos = Vector(76.9, 57, -13.4),
    ang = Angle(0, 0, 90),
    width = 50,
    height = 50,
    scale = 0.1 / 2,
    hideseat = 0.2,
    buttons = {
        {
            ID = "K31Cap",
            x = 0,
            y = 0,
            w = 50,
            h = 50,
            tooltip = "Открыть крышку К31",
            model = {
                var = "K31Cap",
            }
        },
    }
}

ENT.ButtonMap["K31"] = {
    pos = Vector(74.6, 60, -13),
    ang = Angle(0, 0, 90),
    width = 150,
    height = 250,
    scale = 0.1 / 2,
    hideseat = 0.2,
    buttons = {
        {
            ID = "K31Toggle",
            x = 0,
            y = 0,
            w = 150,
            h = 250,
            tooltip = "К31",
            model = {
                var = "K31",
            }
        },
    }
}

ENT.ClientProps["K31"] = {
    model = "models/metrostroi_train/81-760/81_760_crane_k31.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hide = 0.5,
}

ENT.ClientProps["K31cap"] = {
    model = "models/metrostroi_train/81-760/81_760_cap_k31.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hide = 0.5,
}

for i = 0, 3 do
    for k = 0, 1 do
        ENT.ClientProps["door" .. i .. "x" .. k] = {
            model = "models/metrostroi_train/81-760e/81_760e_door.mdl",
            pos = Vector(229.92 * i * (k == 0 and 1 or -1), 0, 0),
            ang = Angle(0, 180 + k * 180, 0),
            hide = 2,
        }
    end
end

for k, tbl in ipairs({ENT.LeftDoorPositions or {}, ENT.RightDoorPositions or {}}) do
    for i, pos in ipairs(tbl) do
        local idx = (k - 1) * 4 + i
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
            pos = Vector(229.92 * (i - 1) * (k == 1 and 1 or -1), k == 1 and 0.08 or -0.08, 0),
            ang = Angle(0, 180 + (k - 1) * 180, 0),
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

ENT.Lights = {}

ENT.PakPositions = {
    [0] = 270,
    [1] = 235,
    [2] = 210,
    [3] = 180,
    [4] = 140,
    [5] = 115,
    [6] = 90,
}

--------------------------------------------------------------------------------
function ENT:Initialize()
    -- FIXME possible lag creation on spawn
    -- find another solution etogo pizdeca
    -- self:RecursiveRemoveBaseclass(self.ButtonMap)
    -- self:RecursiveRemoveBaseclass(self.ClientSounds)
    -- self:RecursiveRemoveBaseclass(self.ClientProps)
    -- self.ClientProps.BaseClass = {}

    local BaseClass = scripted_ents.GetStored("gmod_subway_base").t
    BaseClass.Initialize(self)
    self.LBnt = self:CreateRT("765LBnt", 3840, 512)
    self.RBnt = self:CreateRT("765RBnt", 3840, 512)
    self.ReleasedPdT = 0
    self.PreviousCompressorState = false
    self.FrontLeak = 0
    self.RearLeak = 0
    self.CompressorVol = 0
    self.ParkingBrake = 0
    self.VentRand = {}
    self.VentState = {}
    self.VentVol = {}
    -- self.GlowingLights = self.GlowingLights or {}
    -- self.LightBrightness = self.LightBrightness or {}
    for i = 1, 8 do
        self.VentRand[i] = math.Rand(0.5, 2)
        self.VentState[i] = 0
        self.VentVol[i] = 0
    end

    if not self.IsIntermediate then
        self.VentVolume = 0
        self.VentVolume2 = 0
        self.CraneRamp = 0
        self.CraneRRamp = 0
        self.EmergencyValveRamp = 0
        self.EmergencyValveEPKRamp = 0
        self.EmergencyBrakeValveRamp = 0
    end

    self.FrontBogey = self:GetNW2Entity("FrontBogey")
    self.RearBogey = self:GetNW2Entity("RearBogey")
    self.FrontCouple = self:GetNW2Entity("FrontCouple")
    self.RearCouple = self:GetNW2Entity("RearCouple")
end

function ENT:RecursiveRemoveBaseclass(tbl)
    if tbl.BaseClass then tbl.BaseClass = nil end
    for _, v in pairs(tbl) do
        if istable(v) then
            self:RecursiveRemoveBaseclass(v)
        end
    end
end

function ENT:UpdateTextures()
    local BaseClass = scripted_ents.GetStored("gmod_subway_base").t
    if isfunction(BaseClass.UpdateTextures) then BaseClass.UpdateTextures(self) end
    self.Number = self:GetWagonNumber()
    for i = 0, 4 do
        local num = tostring(self.Number)[i + 1]
        if not num or num == "" then num = "3" end
        local number = self.ClientEnts["TrainNumberL" .. i]
        if IsValid(number) then
            number:SetPos(self:LocalToWorld(Vector(269 - i * 5.8, 68, -21)))
            number:SetAngles(self:LocalToWorldAngles(Angle(0, 90, 0)))
            number:SetModel(Format("models/metrostroi_train/81-760/numbers/number_%s.mdl", num))
        end
        number = self.ClientEnts["TrainNumberR" .. i]
        if IsValid(number) then
            number:SetPos(self:LocalToWorld(Vector(-443.7 + i * 5.8, -68, -21)))
            number:SetAngles(self:LocalToWorldAngles(Angle(0, -90, 0)))
            number:SetModel(Format("models/metrostroi_train/81-760/numbers/number_%s.mdl", num))
        end
    end
    if not IsValid(self.RearBogey) then self.RearBogey = self:GetNW2Entity("RearBogey") end
    if not IsValid(self.FrontBogey) then self.FrontBogey = self:GetNW2Entity("FrontBogey") end

    if not self.IsIntermediate then
        self:ShowHide("BtbuSdLabel", self:GetNW2Bool("BtbuSd", false))

        local foundOther = false
        for _, btn in ipairs(self.ButtonMap["BackPPZ"].buttons) do
            if btn.ID == "SF22F4Toggle" then
                btn.tooltip = self:GetNW2Bool("BtbuSd", false) and "22F4: КМ" or "Не используется"
                if foundOther then break end
                foundOther = true
            elseif btn.ID == "SF22F2Toggle" then
                btn.tooltip = self:GetNW2Bool("BtbuSd", false) and "22F2: БТБУ, СД" or "22F2: КМ, БТБУ, СД"
                if foundOther then break end
                foundOther = true
            end
        end
    end
end

function ENT:IsNumberBroken()
    for i = 0, 4 do
        local ent = self.ClientEnts["TrainNumber" .. i]
        if IsValid(ent) and (ent:GetPos() == self:GetPos()) then
            return true
        end
        ent = self.ClientEnts["TrainNumberL" .. i]
        if IsValid(ent) and (ent:GetPos() == self:GetPos()) then
            return true
        end
        ent = self.ClientEnts["TrainNumberR" .. i]
        if IsValid(ent) and (ent:GetPos() == self:GetPos()) then
            return true
        end
    end
    return false
end

function ENT:ReInitBogeySounds(bogey)
    if not IsValid(bogey) then return end
    bogey.EngineSNDConfig = Metrostroi.Version > 1537278077 and bogey.EngineSNDConfig or {}

    local tbl = bogey.EngineSNDConfig
    if Metrostroi.Version > 1537278077 then
        bogey.EngineSNDConfig[4] = {}
        tbl = bogey.EngineSNDConfig[4]
        bogey.MotorSoundType = nil
    else
        bogey.MotorSoundType = bogey:GetNWInt("MotorSoundType", 1)
    end

    local suffix = Metrostroi.Version > 1537278077 and "765" or "720"

    table.insert(tbl, { "ted1_" .. suffix, --40
        08, 00, 16, 0.14 })
    table.insert(tbl, { "ted2_" .. suffix, --35
        16, 08 - 4, 24, 0.13 })
    table.insert(tbl, { "ted3_" .. suffix, --32
        24, 16 - 4, 32, 0.12 })
    table.insert(tbl, { "ted4_" .. suffix, --28
        32, 24 - 4, 40, 0.10 })
    table.insert(tbl, { "ted5_" .. suffix, --22
        40, 32 - 4, 48, 0.09 })
    table.insert(tbl, { "ted6_" .. suffix, --18
        48, 40 - 4, 56, 0.06 })
    table.insert(tbl, { "ted7_" .. suffix, --15
        56, 48 - 4, 64, 0.05 })
    table.insert(tbl, { "ted8_" .. suffix, --10
        64, 56 - 4, 72, 0.04 })
    table.insert(tbl, { "ted9_" .. suffix, --07
        72, 64 - 4, 80, 0.03 })
    table.insert(tbl, { "ted10_" .. suffix, --05
        80, 72 - 4, 88, 0.02 })

    bogey.SoundNames = bogey.SoundNames or {}
    bogey.SoundNames["ted1_" .. suffix] = "subway_trains/765/rumble/engines/engine_8.wav"
    bogey.SoundNames["ted2_" .. suffix] = "subway_trains/765/rumble/engines/engine_16.wav"
    bogey.SoundNames["ted3_" .. suffix] = "subway_trains/765/rumble/engines/engine_24.wav"
    bogey.SoundNames["ted4_" .. suffix] = "subway_trains/765/rumble/engines/engine_32.wav"
    bogey.SoundNames["ted5_" .. suffix] = "subway_trains/765/rumble/engines/engine_40.wav"
    bogey.SoundNames["ted6_" .. suffix] = "subway_trains/765/rumble/engines/engine_48.wav"
    bogey.SoundNames["ted7_" .. suffix] = "subway_trains/765/rumble/engines/engine_56.wav"
    bogey.SoundNames["ted8_" .. suffix] = "subway_trains/765/rumble/engines/engine_64.wav"
    bogey.SoundNames["ted9_" .. suffix] = "subway_trains/765/rumble/engines/engine_72.wav"
    bogey.SoundNames["ted10_" .. suffix] = "subway_trains/765/rumble/engines/engine_80.wav"

    bogey.SoundNames["flangea"] = "subway_trains/765/rumble/bogey/skrip1.wav"
    bogey.SoundNames["flangeb"] = "subway_trains/765/rumble/bogey/skrip2.wav"
    bogey.SoundNames["flange1"] = "subway_trains/765/rumble/bogey/flange_9.wav"
    bogey.SoundNames["flange2"] = "subway_trains/765/rumble/bogey/flange_10.wav"
    bogey.SoundNames["brakea_loop1"] = "subway_trains/765/rumble/bogey/braking_async1.wav"
    bogey.SoundNames["brakea_loop2"] = "subway_trains/765/rumble/bogey/braking_async2.wav"
    bogey.SoundNames["brake_loop1"] = "subway_trains/bogey/brake_rattle3.wav"
    bogey.SoundNames["brake_loop2"] = "subway_trains/bogey/brake_rattle4.wav"
    bogey.SoundNames["brake_loop3"] = "subway_trains/bogey/brake_rattle5.wav"
    bogey.SoundNames["brake_loop4"] = "subway_trains/bogey/brake_rattle6.wav"
    bogey.SoundNames["brake_loopb"] = "subway_trains/common/junk/junk_background_braking1.wav"
    bogey.SoundNames["brake2_loop1"] = "subway_trains/bogey/brake_rattle2.wav"
    bogey.SoundNames["brake2_loop2"] = "subway_trains/bogey/brake_rattle_h.wav"
    bogey.SoundNames["brake_squeal1"] = "subway_trains/bogey/brake_squeal1.wav"
    bogey.SoundNames["brake_squeal2"] = "subway_trains/bogey/brake_squeal2.wav"

    if bogey.Sounds then
        for k, v in pairs(bogey.Sounds) do
            v:Stop()
        end
    end

    bogey.Sounds = {}
    bogey.Playing = {}
    for k, v in pairs(bogey.SoundNames) do
        util.PrecacheSound(v)
        local e = bogey
        if (k == "brakea_loop1" or k == "brakea_loop2") and IsValid(bogey:GetNW2Entity("TrainWheels")) then e = bogey:GetNW2Entity("TrainWheels") end
        bogey.Sounds[k] = CreateSound(e, Sound(v))
    end

    bogey.Async = nil
end

function ENT:CheckBogeySounds(bogey)
    return IsValid(bogey) and bogey.SoundNames and (
        not bogey.SoundNames or
        Metrostroi.Version > 1537278077 and not bogey.SoundNames["ted1_765"] or
        Metrostroi.Version <= 1537278077 and bogey.SoundNames["ted1_720"] ~= "subway_trains/765/rumble/engines/engine_8.wav"
    )
end

function ENT:SetupFence(platform, fence, wag, front)
    local otherFront = wag:GetNW2Entity("FrontTrain") == self
    local k = not otherFront and -1 or 1
    if IsValid(platform) then
        local ang1 = platform:WorldToLocalAngles(wag:LocalToWorldAngles(Angle(0, 90 * k, 0)))
        local vec = platform:WorldToLocal(wag:LocalToWorld(Vector(480.1 * k, k * ang1.p * 1.585, 0.6)))
        platform:ManipulateBoneAngles(0, Angle(-ang1.r / 2, ang1.y / 2, ang1.p / 3) + Angle(0, 90, 0))
        platform:ManipulateBonePosition(0, Vector(vec.x / 2, vec.y / 2, vec.z / 2))
    end
    if IsValid(fence) then
        if not fence.HasCallback then
            fence:AddCallback("BuildBonePositions", function(ent)
                if ent:IsMarkedForDeletion() then return end
                if not ent.fpos1 or not ent.fpos2 or not ent.fang1 or not ent.fang2 then return end
                local m = Matrix()
                for idx = 1, 2 do
                    local bidx = ent:LookupBone("Bone0" .. (idx + 2))
                    if bidx and ent:GetBoneName(bidx) ~= "__INVALIDBONE__" then
                        m:SetTranslation(ent["fpos" .. idx])
                        m:SetAngles(ent["fang" .. idx])
                        ent:SetBoneMatrix(bidx, m)
                    end
                end
            end)
            fence.HasCallback = true
        end
        fence.fpos1 = wag:LocalToWorld(Vector(otherFront and 464.37 or -464.07, 0, 0))
        fence.fpos2 = self:LocalToWorld(Vector(front and 464.37 or -464.07, 0, 0))
        fence.fang1 = wag:LocalToWorldAngles(Angle(0, otherFront and 180 or 0, -90))
        fence.fang2 = self:LocalToWorldAngles(Angle(0, front and 180 or 0, 90))
    end
end

function ENT:FenceConnectable(wag, prefix)
    local compatible = IsValid(wag) and (wag:GetClass():find("76") and wag:GetClass()[19] == "e" or string.match(wag:GetClass(), "76[567]"))
    return (
        compatible and (
            wag:GetNW2Entity("RearTrain") == self and not IsValid(wag.ClientEnts[prefix .. "R"]) or
            wag:GetNW2Entity("FrontTrain") == self and not IsValid(wag.ClientEnts[prefix .. "F"])
        )
    )
end

local CranePos = {0, 0.28, 0.38, 0.48, 0.85, 1}
local ControllerPos = {0, 0.22, 0.41, 0.6, 0.8, 1}
function ENT:Think()
    local BaseClass = scripted_ents.GetStored("gmod_subway_base").t
    BaseClass.Think(self)
    if not self.RenderClientEnts or self.CreatingCSEnts then
        self.Number = 0
        return
    end

    if not IsValid(self.RearBogey) then self.RearBogey = self:GetNW2Entity("RearBogey") end
    if not IsValid(self.FrontBogey) then self.FrontBogey = self:GetNW2Entity("FrontBogey") end

    if self:CheckBogeySounds(self.FrontBogey) then self:ReInitBogeySounds(self.FrontBogey) end
    if self:CheckBogeySounds(self.RearBogey) then self:ReInitBogeySounds(self.RearBogey) end
    if self.Number ~= self:GetWagonNumber() then self:UpdateTextures() end
    if self.Texture ~= self:GetNW2String("Texture") then self:UpdateTextures() end
    if self.PassTexture ~= self:GetNW2String("passtexture") then self:UpdateTextures() end
    if self.CabinTexture ~= self:GetNW2String("cabtexture") then self:UpdateTextures() end
    if self:IsNumberBroken() then self:UpdateTextures() end

    local ValidfB, ValidrB = IsValid(self.FrontBogey), IsValid(self.RearBogey)
    for i = 1, 4 do
        self:ShowHide("TR" .. i, i <= 2 and ValidfB or i >= 3 and ValidrB)
        self:ShowHide("BS" .. i, ValidfB)
        self:ShowHide("BS" .. (i + 4), ValidrB)
        self:Animate("TR" .. i, self:GetPackedBool("TR" .. i) and 1 or 0, 0, 1, 8, 0.5)
        self:Animate("BS" .. i, self:GetPackedBool("BC" .. i) and 1 or 0, 1, 0.722, 32, 2)
        self:Animate("BS" .. (i + 4), self:GetPackedBool("BC" .. (i + 4)) and 1 or 0, 1, 0.722, 32, 2)
    end

    local RearTrain, FrontTrain = self:GetNW2Entity("RearTrain"), self:GetNW2Entity("FrontTrain")
    self:ShowHide("FenceR", self:FenceConnectable(RearTrain, "Fence"))
    self:ShowHide("FencePlR", self:FenceConnectable(RearTrain, "FencePl"))
    if self.IsIntermediate then
        self:ShowHide("FenceF", self:FenceConnectable(FrontTrain, "Fence"))
        self:ShowHide("FencePlF", self:FenceConnectable(FrontTrain, "FencePl"))
    end

    local fenceRear, fenceFront = self.ClientEnts["FenceR"], self.ClientEnts["FenceF"]
    local platformRear, platformFront = self.ClientEnts["FencePlR"], self.ClientEnts["FencePlF"]
    if IsValid(RearTrain) then
        self:SetupFence(platformRear, fenceRear, RearTrain)
    end
    if self.IsIntermediate and IsValid(FrontTrain) then
        self:SetupFence(platformFront, fenceFront, FrontTrain, true)
    end

    local speed = self:GetPackedRatio("Speed", 0)
    if IsValid(self.ClientEnts["KtiFan"]) and self:GetPackedBool("WorkFan", false) then self.ClientEnts["KtiFan"]:SetPoseParameter("position", 1.0 - (speed > 10 and CurTime() % 0.5 * 2 or CurTime() % 1)) end
    if IsValid(self.ClientEnts["RFan"]) and self:GetPackedBool("WorkFan", false) then self.ClientEnts["RFan"]:SetPoseParameter("position", 1.0 - (speed > 10 and CurTime() % 0.5 * 2 or CurTime() % 1)) end
    self:Animate("FrontBrake", self:GetNW2Bool("FbI") and 0 or 1, 0, 1, 3, false)
    self:Animate("FrontTrain", self:GetNW2Bool("FtI") and 0 or 1, 0, 1, 3, false)
    self:Animate("RearBrake", self:GetNW2Bool("RbI") and 0 or 1, 0, 1, 3, false)
    self:Animate("RearTrain", self:GetNW2Bool("RtI") and 0 or 1, 0, 1, 3, false)
    self:Animate("K23Valve", self:GetNW2Bool("K23") and 0 or 1, 0, 1, 3, false)
    self:Animate("Stopkran", self:GetPackedBool("EmergencyBrakeValve") and 1 or 0.5, 0, 1, 3, false)

    if not self.IsTrailer then
        if self.LastGvState ~= self:GetPackedBool("GV") then
            self.GvWrenchHide = CurTime() + 1.5
            self.LastGvState = self:GetPackedBool("GV")
        end
        self:Animate("GvWrench", self:GetPackedBool("GV") and 0 or 1, 0, 0.51, 128, 1, false)
        self:ShowHideSmooth("GvWrench", CurTime() < self.GvWrenchHide and 1 or 0.1)
    end

    if not self.IsTrailer then self:Animate("VmBs", self:GetPackedRatio("IVO"), 0, 1, 16, 1) end
    if self.IsTrailer then
        self:Animate("VmLv", self:GetPackedRatio("LV"), 0, 0.95, 16, 1)
        self:Animate("VmHv", self:GetPackedRatio("HV"), 0, 1, 16, 6)
        self:Animate("MnBl", self:GetPackedRatio("BL"), 0, 0.78, 256, 2)
        self:Animate("MnTl", self:GetPackedRatio("TL"), 0, 0.78, 256, 2)
        self:Animate("MnBc", self:GetPackedRatio("BC"), 0, 0.78, 256, 2)
    end
    local BoxDoorL = self:Animate("BoxDoorL", self:GetPackedBool("CouchCapL") and 1 or 0, 0, 1, 2, 2)
    local BoxDoorR = self:Animate("BoxDoorR", self:GetPackedBool("CouchCapR") and 1 or 0, 0, 1, 2, 2)
    if self.IsIntermediate then
        self:HidePanel("ClosetCapL", BoxDoorL > 0)
        self:HidePanel("ClosetCapR", BoxDoorR > 0)
        self:HidePanel("ClosetCapLop", BoxDoorL < 1)
        self:HidePanel("ClosetCapRop", BoxDoorR < 1)
        self:HidePanel("BoxR", BoxDoorR == 0)
        self:HidePanel("Power", BoxDoorL == 0)
    end
    self:HidePanel("PVZ", self.IsIntermediate and BoxDoorL == 0)
    self:ShowHide("BoxIntL", self.IsIntermediate and BoxDoorL > 0)
    self:ShowHide("BoxAdd", self.IsIntermediate and BoxDoorL > 0)
    self:ShowHide("BoxIntR", self.IsIntermediate and BoxDoorR > 0)
    self:ShowHide("VmHv", not self.IsIntermediate or BoxDoorR > 0)
    self:ShowHide("MnBc", not self.IsIntermediate or BoxDoorR > 0)
    self:ShowHide("MnTl", not self.IsIntermediate or BoxDoorR > 0)
    self:ShowHide("MnBl", not self.IsIntermediate or BoxDoorR > 0)
    self:ShowHide("VmLv", not self.IsIntermediate or BoxDoorL > 0)
    if not self.IsTrailer then self:ShowHide("VmBs", self.IsIntermediate and BoxDoorL > 0) end
    self:ShowHide("Stopkran", BoxDoorR > 0)

    self:ShowHideSmooth("SalonLightsHalf", self:Animate("LampsEmer", self:GetPackedBool("SalonLighting1") and 1 or 0, 0, 1, 5, false))
    self:ShowHideSmooth("SalonLightsFull", self:Animate("LampsFull", self:GetPackedBool("SalonLighting2") and 1 or 0, 0, 1, 5, false))

    local K31cap = self:Animate("K31cap", self:GetPackedBool("DoorK31") and 1 or 0, 0, 1, 4, 0.5)
    self:ShowHide("K31", K31cap > 0)
    self:HidePanel("K31", K31cap < 1)
    self:Animate("K31", self:GetPackedBool("K31") and 0 or 1, 0, 1, 16, 0.5)

    -- LEGACY, to be removed
    if not self.DoorStates then self.DoorStates = {} end
    if not self.DoorLoopStates then self.DoorLoopStates = {} end
    for i = 0, 3 do
        for k = 0, 1 do
            local st = k == 1 and "DoorL" or "DoorR"
            local id, sid = st .. (i + 1), "door" .. i .. "x" .. k
            local doorstate = self:GetPackedBool("Command" .. id)
            local state = self:GetPackedRatio(id)

            local randvalKey = "Door" .. (k == 1 and "L" or "R") .. "BR" .. (i + 1)
            if not self[randvalKey] then self[randvalKey] = math.random(0, 1) end
            local randval = self[randvalKey]
            if (state ~= 1 and state ~= 0) ~= self.DoorStates[id] then
                if doorstate and state < 1 or not doorstate and state > 0 then
                    if doorstate then
                        self:PlayOnce(sid .. "op" .. randval, "", 1, 1)
                    end
                else
                    if state > 0 then
                        self:PlayOnce(sid .. "o" .. randval, "", 1, 1)
                    else
                        self:PlayOnce(sid .. "c" .. randval, "", 1, 1)
                    end
                    self[randvalKey] = math.random(0, 1)
                end

                self.DoorStates[id] = state ~= 1 and state ~= 0
            end

            if state ~= 1 and state ~= 0 then
                self.DoorLoopStates[id] = math.Clamp((self.DoorLoopStates[id] or 0) + 2 * self.DeltaTime, 0, 1)
            else
                self.DoorLoopStates[id] = math.Clamp((self.DoorLoopStates[id] or 0) - 6 * self.DeltaTime, 0, 1)
            end

            self:SetSoundState(sid .. "r" .. randval, self.DoorLoopStates[id], 1) --0.9+self.DoorLoopStates[id]*0.1)
            self:SetSoundState(sid .. "r" .. math.abs(1 - randval), 0, 0)
            local n_l = "door" .. i .. "x" .. k
            self:Animate(n_l, 1 - state, 0, 1, 15, 1) --0.8 + (-0.2+0.4*math.random()),0)

            local idx = k * 4 + i + 1
            local btnKey = "DoorArrdessButton" .. idx
            self:Animate(btnKey, 1 - state, 0, 1, 15, 1)
        end
    end

    for idx = 1, 8 do
        self:HidePanel("DoorManual" .. idx, not self:GetNW2Bool("DoorManualOpenLever" .. idx, false))
        self:HidePanel("DoorManualOutside" .. idx, not self:GetNW2Bool("DoorManualOpenLever" .. idx, false))
        local open = self:GetPackedRatio((idx < 5 and "DoorL" or "DoorR") .. (idx < 5 and idx or 9 - idx), 0) > 0
        self:HidePanel("DoorManualBlock" .. idx, open)
        self:HidePanel("DoorAddressOpen" .. idx, open or not self:GetNW2Bool("AddressDoors", false))
        self:HidePanel("DoorAddressOpenOutside" .. idx, open or not self:GetNW2Bool("AddressDoors", false))
        local btnKey = "DoorArrdessButton" .. idx
        self:ShowHide(btnKey, self:GetNW2Bool("AddressDoors", false))
        local btn = self.ClientEnts[btnKey]
        if IsValid(btn) then
            local idx2 = (idx < 5 and 9 - idx or idx - 4)
            local led = self:GetNW2Bool("DoorButtonLed" .. idx2, false)
            if led then
                local state = self:GetNW2String("DoorAnnounceState" .. idx2)
                led = state ~= "Closed" or CurTime() % 1.2 < 0.6
            end
            btn:SetSubMaterial(1, led and "models/metrostroi_train/81-765/led_green" or "models/metrostroi_train/81-765/led_off")
        end
    end

    local dT = self.DeltaTime

    self.FrontLeak = math.Clamp(self.FrontLeak + 10 * (-self:GetPackedRatio("FrontLeak") - self.FrontLeak) * dT, 0, 1)
    self.RearLeak = math.Clamp(self.RearLeak + 10 * (-self:GetPackedRatio("RearLeak") - self.RearLeak) * dT, 0, 1)
    self:SetSoundState("front_isolation", self.FrontLeak, 0.9 + 0.2 * self.FrontLeak)
    self:SetSoundState("rear_isolation", self.RearLeak, 0.9 + 0.2 * self.RearLeak)
    local parking_brake = math.max(0, -self:GetPackedRatio("ParkingBrakePressure_dPdT", 0))
    self.ParkingBrake = self.ParkingBrake + (parking_brake - self.ParkingBrake) * dT * 10
    self:SetSoundState("parking_brake", self.ParkingBrake, 1.4)
    self.ReleasedPdT = math.Clamp(self.ReleasedPdT + 10 * (-self:GetPackedRatio("BrakeCylinderPressure_dPdT", 0) - self.ReleasedPdT) * dT * 1.5, 0, 1)
    self:SetSoundState("release", math.Clamp(self.ReleasedPdT, 0, 1) ^ 2, 1)

    if not self.IsTrailer then
        local cmp_state = self:GetPackedBool("CompressorWork")
        if self.CompressorVol < 1 and cmp_state then
            self.CompressorVol = math.min(1, self.CompressorVol + (self.CompressorVol < 0.2 and 0.1 or 0.2) * dT)
        elseif self.CompressorVol > 0 and not stcmp_stateate then
            self.CompressorVol = math.max(0, self.CompressorVol - dT)
        end

        self:SetSoundState("compressor", self.CompressorVol / 6, 0.8 + 0.2 * self.CompressorVol)
        self.PreviousCompressorState = cmp_state
    end

    local rollingi = math.min(1, self.TunnelCoeff + math.Clamp((self.StreetCoeff - 0.82) / 0.5, 0, 1))
    local rollings = math.max(self.TunnelCoeff * 0.6, self.StreetCoeff)
    local rolling_total = rollingi + rollings * 0.2
    local rol10 = math.Clamp(speed / 25, 0, 1) * (1 - math.Clamp((speed - 25) / 8, 0, 1))
    local rol45 = math.Clamp((speed - 23) / 8, 0, 1) * (1 - math.Clamp((speed - 50) / 8, 0, 1))
    local rol60 = math.Clamp((speed - 50) / 8, 0, 1) * (1 - math.Clamp((speed - 65) / 5, 0, 1))
    local rol70 = math.Clamp((speed - 65) / 5, 0, 1)
    self:SetSoundState("rolling_10", rollingi * rol10, 1)
    self:SetSoundState("rolling_45", rollingi * rol45, 1)
    self:SetSoundState("rolling_60", rollingi * rol60, 1)
    self:SetSoundState("rolling_70", rollingi * rol70, 1)

    local rol10h = math.Clamp(speed / 15, 0, 1) * (1 - math.Clamp((speed - 18) / 35, 0, 1))
    local rol10ph = Lerp((speed - 15) / 14, 0.6, 0.78)
    local rol40h = math.Clamp((speed - 18) / 35, 0, 1) * (1 - math.Clamp((speed - 55) / 40, 0, 1))
    local rol40ph = Lerp((speed - 15) / 66, 0.6, 1.3)
    local rol70h = math.Clamp((speed - 55) / 20, 0, 1)
    local rol70ph = Lerp((speed - 55) / 27, 0.78, 1.15)
    self:SetSoundState("rolling_low", rol10h * rollings, rol10ph)
    self:SetSoundState("rolling_medium2", rol40h * rollings, rol40ph)
    self:SetSoundState("rolling_high2", rol70h * rollings, rol70ph)

    if not self.IsTrailer then
        local asyncType = self:GetNW2Int("VVVFSound", 1)
        if asyncType == 1 then
            local asyncState = self:GetPackedRatio("asynccurrent")
            local strength = self:GetPackedRatio("asyncstate") * (1 - math.Clamp((speed - 23) / 23, 0, 1)) * 0.5
            self:SetSoundState("async1", rolling_total * math.Clamp(asyncState / 0.26 + 0.2, 0, 1) * strength, 1)
        else
            self:ExperimentalAsync(asyncType, rolling_total, speed)
        end
    end

    local work = self:GetPackedBool("AnnPlay")
    for k, v in ipairs(self.AnnouncerPositions) do
        if self.Sounds["announcer" .. k] and IsValid(self.Sounds["announcer" .. k]) then self.Sounds["announcer" .. k]:SetVolume(work and (v[3] or 1) or 0) end
    end

    if not self.IsIntermediate then
        self:ShowHide("ASHook", ValidfB)
        self:Animate("ASHook", self:GetPackedBool("ASHook") and 1 or 0, 0, 1, 8, 0.5)

        local col = render.GetLightColor(self:GetPos() + 530 * self:GetForward())
        local val = math.floor((col.x * 255 + col.y * 255 + col.z * 255) * 5) / 5
        if self.LightVal ~= val and CurTime() - (self.LightValTimer or 0) > 0 or not self.LightVal then
            self.LightValTimer = CurTime() + 0.5
            self.LightVal = val
        end

        local headl = math.max(0, self:GetPackedRatio("Headlights") + (self.LightVal >= 6 and self:GetPackedRatio("Headlights") == 1 and -0.5 or 0))
        self:SetLightPower(1, headl > 0, headl)

        local redShouldOn = self:GetPackedBool("BacklightsEnabled")
        local hl1 = (self:GetPackedBool("HeadLightsEnabled1") or self:GetPackedBool("HeadLightsEnabled2") and self.LightVal >= 6)
        local hl2 = self:GetPackedBool("HeadLightsEnabled2") and self.LightVal < 6
        local rlm = redShouldOn and not (hl1 or hl2)
        local hl0 = not rlm and not hl2 and not hl1 and not self:GetPackedBool("BacklightsEnabled")

        local rl = self:Animate("backlights0", redShouldOn and 1 or 0, 0, 1, 4, false)
        self:SetLightPower(2, rl > 0, rl)

        for idx = 1, 4 do
            local redOn = not self:GetNW2Bool("RlBroken" .. idx, false) and redShouldOn
            local whiteOn = not redShouldOn and not self:GetNW2Bool("WlBroken" .. idx, false) and (self:GetPackedBool("HeadLightsEnabled1") or self:GetPackedBool("HeadLightsEnabled2"))
            self:ShowHideSmooth("RedLights" .. idx, self:Animate("rl" .. idx, redOn and 1 or 0, 0, 1, 12, false))
            self:ShowHideSmooth("WhiteLights" .. idx, self:Animate("wl" .. idx, whiteOn and 1 or 0, 0, 1, 12, false))
            self:ShowHideSmooth("OffLights" .. idx, self:Animate("ol" .. idx, not redOn and not whiteOn and 1 or 0, 0, 1, 12, false))
        end

        local headlEnt = self.GlowingLights[1]
        if IsValid(headlEnt) then
            headlEnt:SetEnableShadows(true)
            if headl < 1 and headlEnt:GetFarZ() > 4096 then headlEnt:SetFarZ(4096) end
            if headl == 1 and headlEnt:GetFarZ() < 8192 then headlEnt:SetFarZ(8192) end
        end

        hl1 = self:Animate("headlights1", hl1 and 1 or 0, 0, 1, 12, false)
        hl2 = self:Animate("headlights2", hl2 and 1 or 0, 0, 1, 12, false)
        self:ShowHideSmooth("HeadLights0", self:Animate("headlights0", hl0 and 1 or 0, 0, 1, 12, false))
        self:ShowHideSmooth("HeadLights1", hl1)
        self:ShowHideSmooth("HeadLights2", hl2)
        self:ShowHideSmooth("HeadLightsRed", self:Animate("headlightsRed", rlm and 1 or 0, 0, 1, 12, false))
        local hlPower = math.min(1, hl1 + hl2)
        self:SetLightPower(3, rl < 0.1 and hlPower > 0.1, hlPower)

        local PanelLighting = self:GetPackedBool("PanelLighting")
        self:SetLightPower(11, PanelLighting)
        self:SetLightPower(12, PanelLighting)

        self:Animate("MnBl", self:GetPackedRatio("BL"), 0, 0.853, 256, 2)
        self:Animate("MnTl", self:GetPackedRatio("TL"), 0, 0.853, 256, 2)
        self:Animate("MnBc", self:GetPackedRatio("BC"), 0, 0.827, 256, 2)
        self:Animate("Controller", ControllerPos[self:GetPackedRatio("Controller") + 4] or 0, 0.316, 0.66, 2, false)
        self:Animate("EmergencyBrakeValve", self:GetPackedBool("EmergencyBrakeValve") and 1 or 0, 0, 1, 6, false)

        self:Animate("K9", self:GetPackedBool("K9") and 0 or 1, 0, 1, 16, 0.5)
        self:Animate("K29", self:GetPackedBool("K29") and 1 or 0, 0, 1, 16, 0.5)
        self:Animate("K35", self:GetPackedBool("UAVA") and 1 or 0, 0, 1, 32, 0.5)

        self:Animate("KRO", self:GetPackedRatio("KRO", 0), 0, 1, 6, false)
        self:Animate("KRR", self:GetPackedRatio("KRR", 0), 0, 1, 3, false)

        self:Animate("KM013", CranePos[7 - self:GetPackedRatio("Cran")] or 0, 0, 1, 2, false)
        self:Animate("PB", self:GetPackedBool("PB") and 1 or 0, 0, 1, 8, false)

        local cabl_full = self:GetPackedBool("CabinEnabledFull")
        local cabl_half = not cabl_full and self:GetPackedBool("CabinEnabledEmer")
        local cabl_off = not cabl_full and not cabl_half
        cabl_full = self:Animate("CabFull", cabl_full and 1 or 0, 0, 1, 5, false)
        cabl_half = self:Animate("CabEmer", cabl_half and 1 or 0, 0, 1, 5, false)
        cabl_off = self:Animate("CabOff", cabl_off and 1 or 0, 0, 1, 5, false)
        self:ShowHideSmooth("cab_full", cabl_full)
        self:ShowHideSmooth("cab_half", cabl_half)
        self:ShowHideSmooth("cab_off", cabl_off)

        local DoorCabL = self:Animate("DoorCabL", self:GetPackedBool("CabinDoorLeft") and 1 or 0, 0, 1, 2, 0.5)
        local DoorCabR = self:Animate("DoorCabR", self:GetPackedBool("CabinDoorRight") and (self:GetPackedBool("CabinDoorRightLimit") and 0.6 or 1) or 0, 0, 1, 2, 0.5)
        self:PlayDoorSound(self:Animate("DoorCabM", self:GetPackedBool("PassengerDoor") and 1 or 0, 0, 1, 2, 0.5) > 0.2, "door_cab_m")
        self:PlayDoorSound(DoorCabL > 0.2, "door_cab_l")
        self:PlayDoorSound(DoorCabR > 0.2, "door_cab_r")
        self:HidePanel("PpzCover", DoorCabL == 0)
        self:Animate("CabChairAdd", self:GetPackedBool("CabChairAdd") and 1 or 0, 0, 1, 4, 0.5)
        local Closet1Val = self:Animate("Closet1Val", self:GetPackedBool("Closet1Val") and 1 or 0, 0, 1, 2, 0.5)
        self:PlayDoorSound(Closet1Val > 0, "door_add_1")
        self:HidePanel("Closet1", Closet1Val > 0)
        self:HidePanel("Closet1Op", Closet1Val < 1)

        self:ShowHide("K35", Closet1Val > 0)
        self:HidePanel("K35", Closet1Val == 0)

        self:AnimateCustom("DoorCabL", "position_window", self:GetPackedBool("CabinWindowLeft") and 1 or 0, 0, 1, 8, 0.5)
        self:AnimateCustom("DoorCabR", "position_window", self:GetPackedBool("CabinWindowRight") and 1 or 0, 0, 1, 8, 0.5)

        local state = self:GetPackedBool("WorkCabVent", false)
        local ventTimer = self:GetPackedRatio("VentTimer", 0)
        self.VentTimer = ventTimer > 0 and ventTimer
        if self.VentVolume < 1 and state then
            self.VentVolume = math.min(1, self.VentVolume + dT)
        elseif self.VentVolume > 0 and not state then
            self.VentVolume = math.max(0, self.VentVolume - dT)
        end

        state = self.VentTimer and CurTime() - self.VentTimer > 4 and CurTime() - self.VentTimer < 11
        if self.VentVolume2 < 1 and state then
            self.VentVolume2 = math.min(1, self.VentVolume2 + dT)
        elseif self.VentVolume2 > 0 and not state then
            self.VentVolume2 = math.max(0, self.VentVolume2 - 0.75 * dT)
        end

        if self.VentTimer then
            if CurTime() - self.VentTimer <= 4 then
                self:SetSoundState("vent_loop", 0.07 * self.VentVolume, 0.9 + self.VentVolume / 10)
                self:SetSoundState("vent_loop_max", 0.0, 1)
            elseif CurTime() - self.VentTimer > 11 then
                self:SetSoundState("vent_loop", 0.0, 1)
                self:SetSoundState("vent_loop_max", 0.33 * self.VentVolume2 / 2, 0.9 + self.VentVolume2 / 10)
            elseif CurTime() - self.VentTimer > 4 then
                self:SetSoundState("vent_loop", 0.25 * self.VentVolume / 2, 1)
                self:SetSoundState("vent_loop_max", 0.33 * self.VentVolume2 / 2, 0.9 + self.VentVolume2 / 10)
            end
        else
            self:SetSoundState("vent_loop", 0.0, 0.9 + self.VentVolume / 10)
            self:SetSoundState("vent_loop_max", 0.0, 1)
        end

        self:HideButton("KAHToggle", self:GetPackedBool("ALSk"))
        self:SetSoundState("ring_ppz", self:GetPackedBool("BUKPRing", false) and 1.6 or 0, 1)
        self:SetSoundState("ring_call", self:GetPackedBool("CallRing", false) and 1.0 or 0, 1)
        self:Animate("VmLv", self:GetPackedRatio("LV"), 0, 1, 16, 1)
        self:Animate("VmHv", self:GetPackedRatio("HV"), 0, 1, 16, 6)

        local ramp = self:GetPackedRatio("Crane_dPdT", 0)
        if ramp > 0 then
            self.CraneRamp = self.CraneRamp + ((0.4 * ramp) - self.CraneRamp) * dT
        else
            self.CraneRamp = self.CraneRamp + ((1.2 * ramp) - self.CraneRamp) * dT
        end
        self.CraneRRamp = math.Clamp(self.CraneRRamp + 1.0 * ((1 * ramp) - self.CraneRRamp) * dT, 0, 1)

        self:SetSoundState("crane013_release", self.CraneRRamp ^ 1.5, 1.0)
        self:SetSoundState("crane013_brake", math.Clamp(-self.CraneRamp * 1.5, 0, 1) ^ 1.3, 1.0)
        self:SetSoundState("crane013_brake2", math.Clamp(-self.CraneRamp * 1.5 - 0.95, 0, 1.5) ^ 2, 1.0)

        local emergencyValveEPK = self:GetPackedRatio("EmergencyValveEPK_dPdT", 0)
        self.EmergencyValveEPKRamp = math.Clamp(self.EmergencyValveEPKRamp + 1.0 * ((0.5 * emergencyValveEPK) - self.EmergencyValveEPKRamp) * dT, 0, 1)
        if self.EmergencyValveEPKRamp < 0.01 then self.EmergencyValveEPKRamp = 0 end
        self:SetSoundState("epk_brake", self.EmergencyValveEPKRamp, 1.0)

        local emergencyBrakeValve = self:GetPackedRatio("EmergencyBrakeValve_dPdT", 0)
        self.EmergencyBrakeValveRamp = math.Clamp(self.EmergencyBrakeValveRamp + (emergencyBrakeValve - self.EmergencyBrakeValveRamp) * dT * 8, 0, 1)
        self:SetSoundState("valve_brake", self.EmergencyBrakeValveRamp, 0.8 + math.min(0.2, self.EmergencyBrakeValveRamp * 0.8))
        self:SetSoundState("valve_brake_open", self.EmergencyBrakeValveRamp > 0.0001 and CurTime() - self:GetPackedRatio("EmerValve", 1e9) < 0 and 1 or 0, 1)

        local emergencyValve = self:GetPackedRatio("EmergencyValve_dPdT", 0) ^ 0.4 * 1.2
        self.EmergencyValveRamp = math.Clamp(self.EmergencyValveRamp + (emergencyValve - self.EmergencyValveRamp) * dT * 16, 0, 1)

        local emervalve_open = self:GetPackedRatio("EmerValveAutost", 0) - CurTime()
        self:SetSoundState("emer_brake_open", self.EmergencyValveRamp > 0.0001 and emervalve_open > 0 and Lerp(math.min(1.0, emervalve_open / 1.5), self.EmergencyValveRamp, 1) or 0, 1.0)
        self:SetSoundState("emer_brake", emervalve_open <= 0 and self.EmergencyValveRamp or 0, 1.0)
        self:SetSoundState("ring", self:GetPackedBool("RingEnabled") and 1 or 0, 1)

        if self.ClientEnts then
            for k, cfg in pairs(self.PakToggles or {}) do
                local ce = self.ClientEnts[k .. "Toggle"]
                if IsValid(ce) then
                    local kAnim = "PakAnim" .. k
                    self[kAnim] = self[kAnim] or 0

                    local target = self.PakPositions[cfg.positions[math.Clamp((self:GetNW2Int(k) or 0) + 1, 1, #cfg.positions)]]

                    if math.abs(target - self[kAnim]) > 0.5 then
                        local sgn = target - self[kAnim] > 0 and 1 or -1
                        self[kAnim] = self[kAnim] + 540 * dT * sgn
                        if math.abs(target - self[kAnim]) < 10 then
                            self[kAnim] = target
                        end
                    end

                    ce:SetPoseParameter("position", 1.0 - ((self[kAnim] % 360) / 360))
                end
            end
        end
    end
end

function ENT:ExperimentalAsync(asyncType, rolling_total, speed)
    if asyncType == 5 then  -- Hitachi GTO
        local gtoamps = self:GetPackedRatio("asynccurrent")
        local gtovol = math.Clamp(gtoamps, 0, 1)
        local state = self:GetPackedRatio("asyncstate")
        self:SetSoundState("gto1", gtovol * math.Clamp((5.4 - speed) / 5.4, 0, 1), 1)
        for idx, val in ipairs(VVVF_GTOTBL) do
            if idx >= 20 then idx = idx + 1 end
            local name = "gto" .. idx
            local condition, expression, speedVal = unpack(val)
            if condition(speed, state) then
                self:SetSoundState(name, expression(gtovol, speed), speedVal > 0 and (speed / speedVal) or 1)
            else
                self:SetSoundState(name, 0, speedVal > 0 and (speed / speedVal) or 1)
            end
        end

    elseif asyncType == 2 then  -- Alstom ONIX
        local state = self:GetPackedRatio("asynccurrent")
        local strength = self:GetPackedRatio("asyncstate") * math.Clamp((self:GetNW2Bool("FirstONIX", 0) == true and (speed - 24) or (speed - 9)) / 1, 0, 1) * (1 - math.Clamp((speed - 23) / 23, 0, 1)) * 0.5
        local strengthls = self:GetPackedRatio("asyncstate") * (1 - math.Clamp((self:GetNW2Bool("FirstONIX", 0) == true and (speed - 23.9) or (speed - 8.9)) / 1, 0, 1)) * 0.5
        self:SetSoundState("KATP", rolling_total * math.Clamp(state / 0.26 + 0.2, 0, 1) * strength, 1)
        self:SetSoundState("KATP_lowspeed", rolling_total * math.Clamp(state / 0.26 + 0.2, 0, 1) * strengthls, 1)
        self:SetSoundState("chopper_onix", rolling_total * self:GetPackedRatio("chopper"), 1)

    elseif asyncType == 3 then  -- КАТП-1
        local state = self:GetPackedRatio("asynccurrent")
        local strength = self:GetPackedRatio("asyncstate") * (1 - math.Clamp((speed - 23) / 23, 0, 1)) * 0.5
        self:SetSoundState("ONIX", rolling_total * math.Clamp(state / 0.26 + 0.2, 0, 1) * strength, 1)
        self:SetSoundState("chopper_katp", rolling_total * self:GetPackedRatio("chopper"), 1)
        if self:GetNW2Bool("HSEngines", 0) == true then
            self:SetSoundState("hs35533_p2", rolling_total * (math.Clamp((speed - 8) / 5, 0, 1) * 0.1 + math.Clamp((speed - 25) / 10, 0, 1) * 0.9) * (1 - math.Clamp((speed - 30) / 4, 0, 1)) * self:GetPackedRatio("asyncstate"), speed / 36)
            self:SetSoundState("hs35533_p2_1", rolling_total * (math.Clamp((speed - 3) / 5, 0, 1) * 0.1 + math.Clamp((speed - 5) / 10, 0, 1) * 0.9) * (1 - math.Clamp((speed - 7) / 4, 0, 1)) * self:GetPackedRatio("asyncstate"), speed / 12)
            self:SetSoundState("hs35533_p3", rolling_total * (math.Clamp((speed - 13) / 5, 0, 1) * 0.1 + math.Clamp((speed - 23) / 10, 0, 1) * 0.9) * (1 - math.Clamp((speed - 35) / 4, 0, 1)) * self:GetPackedRatio("asyncstate"), speed / 42)
            self:SetSoundState("hs35533_p3_1", rolling_total * (math.Clamp((speed - 32) / 10, 0, 1) * 0.9) * (1 - math.Clamp((speed - 40) / 4, 0, 1)) * self:GetPackedRatio("asyncstate"), speed / 49)
        end

    elseif asyncType == 4 then  -- КАТП-3
        local state = self:GetPackedRatio("asynccurrent")
        local strength = self:GetPackedRatio("asyncstate") * math.Clamp((speed - 9) / 1, 0, 1) * (1 - math.Clamp((speed - 23) / 23, 0, 1)) * 0.5
        local strengthls = self:GetPackedRatio("asyncstate") * (1 - math.Clamp((speed - 8.9) / 1, 0, 1)) * 0.5
        self:SetSoundState("KATP", rolling_total * math.Clamp(state / 0.26 + 0.2, 0, 1) * strength, 1)
        self:SetSoundState("KATP_lowspeed", rolling_total * math.Clamp(state / 0.26 + 0.2, 0, 1) * strengthls, 1)
        self:SetSoundState("chopper_katp", rolling_total * self:GetPackedRatio("chopper"), 1)

    elseif asyncType == 6 then  -- Hitachi IGBT
        local state = self:GetPackedRatio("asynccurrent")
        local strength = self:GetPackedRatio("asyncstate") * (1 - math.Clamp((speed - 15) / 15, 0, 1))
        self:SetSoundState("Hitachi", rolling_total * math.Clamp(state / 0.26, 0, 1) * strength, 1)
        self:SetSoundState("Hitachi2_2", rolling_total * (math.Clamp((speed - 18) / 5, 0, 1) * 0.1 + math.Clamp((speed - 23) / 10, 0, 1) * 1.5) * (1 - math.Clamp((speed - 23) / 10, 0, 1)) * self:GetPackedRatio("asyncstate"), speed / 23)
        self:SetSoundState("Hitachi2", rolling_total * (math.Clamp((speed - 32) / 5, 0, 1) * 0.1 + math.Clamp((speed - 27) / 10, 0, 1) * 2.2) * (1 - math.Clamp((speed - 25) / 12, 0, 1)) * self:GetPackedRatio("asyncstate"), (speed / 33) * 0.8)
        self:SetSoundState("Hitachi2_1", rolling_total * (math.Clamp((speed - 31) / 5, 0, 1) * 0.1 + math.Clamp((speed - 25) / 10, 0, 1) * 2) * (1 - math.Clamp((speed - 23) / 12, 0, 1)) * self:GetPackedRatio("asyncstate"), (speed / 30) * 0.95)
        self:SetSoundState("battery_off_loop", 1, 1)
        self:SetSoundState("hs35533_p2", rolling_total * (math.Clamp((speed - 8) / 5, 0, 1) * 0.1 + math.Clamp((speed - 25) / 10, 0, 1) * 0.9) * (1 - math.Clamp((speed - 30) / 4, 0, 1)) * self:GetPackedRatio("asyncstate"), speed / 36)
        self:SetSoundState("hs35533_p2_1", rolling_total * (math.Clamp((speed - 3) / 5, 0, 1) * 0.1 + math.Clamp((speed - 5) / 10, 0, 1) * 0.9) * (1 - math.Clamp((speed - 7) / 4, 0, 1)) * self:GetPackedRatio("asyncstate"), speed / 12)
        self:SetSoundState("hs35533_p3", rolling_total * (math.Clamp((speed - 13) / 5, 0, 1) * 0.1 + math.Clamp((speed - 23) / 10, 0, 1) * 0.9) * (1 - math.Clamp((speed - 36) / 4, 0, 1)) * self:GetPackedRatio("asyncstate"), speed / 42)
        self:SetSoundState("hs35533_p3_1", rolling_total * (math.Clamp((speed - 32) / 10, 0, 1) * 0.9) * (1 - math.Clamp((speed - 40) / 4, 0, 1)) * self:GetPackedRatio("asyncstate"), speed / 49)
        self:SetSoundState("engine_loud", rolling_total * math.Clamp((speed - 20) / 15, 0, 1) * (1 - math.Clamp((speed - 40) / 40, 0, 0.6)) * self:GetPackedRatio("asyncstate"), speed / 20)
        self:SetSoundState("chopper_hitachi", rolling_total * self:GetPackedRatio("chopper"), 1)

    elseif asyncType == 7 then  -- Hitachi VFI-HD1420F
        local state = self:GetPackedRatio("asynccurrent")
        local strength = self:GetPackedRatio("asyncstate") * (1 - math.Clamp((speed - 15) / 15, 0, 1))
        self:SetSoundState("vfi_start", rolling_total * math.Clamp(state / 0.3 + 0.2, 0, 0.7) * strength, 0.6 + math.Clamp(state, 0, 1) * 0.4)
        self:SetSoundState("vfi1_n", rolling_total * math.Clamp(state / 0.3 + 0.2, 0, 1) * strength, 0.6 + math.Clamp(state, 0, 1) * 0.4)
        self:SetSoundState("vfi1_2_n", rolling_total * math.Clamp((state - 0.75) / 0.05, 0, 1) * strength, 0.6 + math.Clamp((state - 0.8) / 0.2, 0, 1) * 0.14)
        self:SetSoundState("vfi1_3_n", rolling_total * math.Clamp((state - 0.7) / 0.1, 0, 1) * strength, 0.87)
        self:SetSoundState("vfi2_n", rolling_total * math.Clamp(math.max(0, state / 0.3 + 0.2), 0, 1) * strength, 0.55 + math.Clamp(state, 0, 1) * 0.45)
        self:SetSoundState("vfi3_n", rolling_total * math.Clamp(math.max(0, (state - 0.7) / 0.1), 0, 1) * strength, 1)
        self:SetSoundState("vfi3_2_n", rolling_total * math.Clamp((state - 0.415) / 0.1, 0, 1) * (1 - math.Clamp((state - 1.1) / 0.3, 0, 0.5)) * strength, 0.48 + math.Clamp(state, 0, 1) * 0.72)
        self:SetSoundState("hs35533_p2_n", rolling_total * (math.Clamp((speed - 8) / 5, 0, 1) * 0.1 + math.Clamp((speed - 25) / 10, 0, 1) * 0.9) * (1 - math.Clamp((speed - 30) / 4, 0, 1)) * self:GetPackedRatio("asyncstate"), speed / 36)
        self:SetSoundState("hs35533_p2_1_n", rolling_total * (math.Clamp((speed - 3) / 5, 0, 1) * 0.1 + math.Clamp((speed - 5) / 10, 0, 1) * 0.9) * (1 - math.Clamp((speed - 7) / 4, 0, 1)) * self:GetPackedRatio("asyncstate"), speed / 12)
        self:SetSoundState("hs35533_p3_n", rolling_total * (math.Clamp((speed - 13) / 5, 0, 1) * 0.1 + math.Clamp((speed - 23) / 10, 0, 1) * 0.9) * (1 - math.Clamp((speed - 36) / 4, 0, 1)) * self:GetPackedRatio("asyncstate"), speed / 42)
        self:SetSoundState("hs35533_p3_1_n", rolling_total * (math.Clamp((speed - 32) / 10, 0, 1) * 0.9) * (1 - math.Clamp((speed - 40) / 4, 0, 1)) * self:GetPackedRatio("asyncstate"), speed / 49)
        self:SetSoundState("engine_loud", rolling_total * math.Clamp((speed - 20) / 15, 0, 1) * (1 - math.Clamp((speed - 40) / 40, 0, 0.6)) * self:GetPackedRatio("asyncstate"), speed / 20)
        self:SetSoundState("chopper_hitachi", rolling_total * self:GetPackedRatio("chopper"), 1)

    elseif asyncType == 8 then  -- Experimental for 765
        local state = self:GetPackedRatio("asynccurrent") --^1.5--RealTime()%2.5/2	
        local strength = self:GetPackedRatio("asyncstate") * math.Clamp((speed - 13) / 1, 0, 1) * (1 - math.Clamp((math.min(52, speed) - 28) / 30, 0, 1)) * 0.4
        local strengthls = self:GetPackedRatio("asyncstate") * (1 - math.Clamp((speed - 12.9) / 1, 0, 1)) * 1
        self:SetSoundState("async1", rolling_total * math.Clamp(state / 0.26 + 0.2, 0, 1) * strength, 1) --+math.Clamp(state,0,1)*0.1)
        self:SetSoundState("KATP_lowspeed", rolling_total * math.Clamp(state / 0.26 + 0.2, 0, 1) * strengthls, 0.85) --+math.Clamp(state,0,1)*0.1)
        self:SetSoundState("chopper_katp", rolling_total * self:GetPackedRatio("chopper"), 1)
    end
end

function ENT:AnimateCustom(clientProp, param, value, min, max, speed, damping, stickyness)
    local id = Format("%s.%s", clientProp, param)
    local anims = self.Anims
    if not anims[id] then
        anims[id] = {}
        anims[id].val = value
        anims[id].value = min + (max - min) * value
        anims[id].V = 0.0
        anims[id].block = false
        anims[id].stuck = false
        anims[id].P = value
    end

    if self.Hidden[clientProp] or self.Hidden.anim[clientProp] then return 0 end
    if anims[id].Ignore then
        if RealTime() - anims[id].Ignore < 0 then
            return anims[id].value
        else
            anims[id].Ignore = nil
        end
    end

    local val = anims[id].val
    if value ~= val then anims[id].block = false end
    if anims[id].block then
        if anims[id].reload and IsValid(self.ClientEnts[clientProp]) then
            self.ClientEnts[clientProp]:SetPoseParameter(param, anims[id].value)
            anims[id].reload = false
        end
        return anims[id].value
    end

    if stickyness and damping then
        if (math.abs(anims[id].P - value) < stickyness) and anims[id].stuck then
            value = anims[id].P
            anims[id].stuck = false
        else
            anims[id].P = value
        end
    end

    local dT = FrameTime()
    if damping == false then
        local dX = speed * dT
        if value > val then val = val + dX end
        if value < val then val = val - dX end
        if math.abs(value - val) < dX then
            val = value
            anims[id].V = 0
        else
            anims[id].V = dX
        end
    else
        -- Prepare speed limiting
        local delta = math.abs(value - val)
        local max_speed = 1.5 * delta / dT
        local max_accel = 0.5 / dT
        -- Simulate
        local dX2dT = (speed or 128) * (value - val) - anims[id].V * (damping or 8.0)
        if dX2dT > max_accel then dX2dT = max_accel end
        if dX2dT < -max_accel then dX2dT = -max_accel end
        anims[id].V = anims[id].V + dX2dT * dT
        if anims[id].V > max_speed then anims[id].V = max_speed end
        if anims[id].V < -max_speed then anims[id].V = -max_speed end
        val = math.max(0, math.min(1, val + anims[id].V * dT))
        -- Check if value got stuck
        if (math.abs(dX2dT) < 0.001) and stickyness and (dT > 0) then anims[id].stuck = true end
    end

    local retval = min + (max - min) * val
    if IsValid(self.ClientEnts[clientProp]) then self.ClientEnts[clientProp]:SetPoseParameter(param, retval) end
    if math.abs(anims[id].V) == 0 and math.abs(val - value) == 0 and not anims[id].stuck then anims[id].block = true end
    anims[id].val = val
    anims[id].oldival = value
    anims[id].oldspeed = speed
    anims[id].value = retval
    return retval
end

function ENT:PlayDoorSound(bool, door)
    if self[door] ~= bool then
        self[door] = bool
        self:PlayOnce(Format("%s_%s", door, bool and "open" or "close"), "", 1, 1)
    end
end

function ENT:Draw()
    local BaseClass = scripted_ents.GetStored("gmod_subway_base").t
    BaseClass.Draw(self)
end

function ENT:DrawPost(special)
    self.RTMaterial:SetTexture("$basetexture", self.LBnt)
    for i = 1, 4 do
        self:DrawOnPanel("BNTL" .. i, function(...)
            surface.SetMaterial(self.RTMaterial)
            surface.SetDrawColor(255, 255, 255)
            surface.DrawTexturedRectRotated(1920, 256, 3840, 512, 0)
        end)
    end
    self.RTMaterial:SetTexture("$basetexture", self.RBnt)
    for i = 1, 4 do
        self:DrawOnPanel("BNTR" .. i, function(...)
            surface.SetMaterial(self.RTMaterial)
            surface.SetDrawColor(255, 255, 255)
            surface.DrawTexturedRectRotated(1920, 256, 3840, 512, 0)
        end)
    end
end

local dist = {}
for id, panel in pairs(ENT.ButtonMap) do
    if not panel.buttons then continue end
    for k, v in pairs(panel.buttons) do
        if v.model then
            local cdist = dist[id] or 150
            if v.model.model then
                v.model.hideseat = cdist
            elseif v.model.lamp then
                v.model.lamp.hideseat = cdist
            end
        end
    end
end

-- Workaround for preventing recursive "BaseClass" field creation
ENT:ExportFields(
    "ClientProps",
    "ButtonMap",
    "ClientSounds",
    "AutoAnims",
    "ClientPropsInitialized",
    "Lights",
    "PakPositions"
)
