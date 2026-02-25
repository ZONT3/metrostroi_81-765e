--------------------------------------------------------------------------------
-- 81-763Э «Чурá» by ZONT_ a.k.a. enabled person
-- Based on code by Cricket, Hell et al.
--------------------------------------------------------------------------------
include("shared.lua")
ENT.ClientProps = {}
ENT.ButtonMap = {}
ENT.AutoAnims = {}
ENT.ClientSounds = {}
ENT.ClientPropsInitialized = false
ENT.ButtonMap["PVZ"] = {
    pos = Vector(450.75, 53.77, 16.95),
    ang = Angle(0, -90, 90),
    width = 305,
    height = 473,
    scale = 0.05,
    hideseat = 0.2,
    buttons = {}
}
table.Add(ENT.ButtonMap["PVZ"].buttons, ENT.PvzToggles)

ENT.ButtonMap["Power"] = {
    pos = Vector(448.7, 50.4, -12.1),
    ang = Angle(0, -90, 90),
    width = 50,
    height = 50,
    scale = 0.0625,
    hideseat = 0.2,
    buttons = {
        {
            ID = "PowerOnSet",
            x = 25,
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

ENT.ButtonMap["Battery"] = {
    pos = Vector(452.46, 22, 50),
    ang = Angle(0, -90, 180),
    width = 80,
    height = 80,
    scale = 0.0625,
    hideseat = 0.2,
    buttons = {
        {
            ID = "BatteryStub",
            x = 0,
            y = 0,
            w = 80,
            h = 80,
            tooltip = "Батарея (неисп.)",
            model = {
                var = "Battery",
                speed = 9,
                vmin = 1,
                vmax = 0,
                model = "models/metrostroi_train/81-760/81_761_trihedral.mdl",
                z = 1,
                ang = Angle(0, -90, 0),
                sndvol = 0.8,
                snd = function(val) return val and "pak_on" or "pak_off" end,
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
    --
    model = "models/metrostroi_train/81-760/81_760_crane_k23.mdl",
    pos = Vector(434.9, -63.2, -64.1),
    ang = Angle(0, 90, 0),
    hide = 2,
}

ENT.ClientProps["FrontTrain"] = {
    --
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
    ENT.ClientProps["TrainNumberL" .. i] = {
        model = "models/metrostroi_train/81-760/numbers/number_0.mdl",
        pos = Vector(0, 0, 0),
        ang = Angle(0, 90, 0),
        hide = 1.5,
        callback = function(ent) ent.WagonNumber = false end,
    }

    ENT.ClientProps["TrainNumberR" .. i] = {
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

table.insert(ENT.ClientProps, {
    model = "models/metrostroi_train/81-760/81_763a_underwagon.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hide = 2,
})

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

ENT.ClientProps["BoxAdd"] = {
    model = "models/metrostroi_train/81-760/81_763a_box_add.mdl",
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
    pos = Vector(448.42, 48.84, -11.3),
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

ENT.ClientProps["FenceR"] = {
    model = "models/metrostroi_train/81-760/81_760_fence_corrugated_platform.mdl",
    pos = Vector(-480.15, 0, 0),
    ang = Angle(0, 90, 0),
    hide = 2,
}

ENT.ClientProps["FenceF"] = {
    model = "models/metrostroi_train/81-760/81_760_fence_corrugated_platform.mdl",
    pos = Vector(480.15, 0, 0),
    ang = Angle(0, -90, 0),
    hide = 2,
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

function ENT:Initialize()
    self.BaseClass.Initialize(self)
    self.LBnt = self:CreateRT("765LBnt", 3840, 512)
    self.RBnt = self:CreateRT("765RBnt", 3840, 512)
    self.ReleasedPdT = 0
    self.PreviousCompressorState = false
    self.FrontLeak = 0
    self.RearLeak = 0
    self.CompressorVol = 0
    self.ParkingBrake = 0
    self.BrakeCylinder = 0.5
    self.VentRand = {}
    self.VentState = {}
    self.VentVol = {}
    for i = 1, 8 do
        self.VentRand[i] = math.Rand(0.5, 2)
        self.VentState[i] = 0
        self.VentVol[i] = 0
    end

    self.FrontBogey = self:GetNW2Entity("FrontBogey")
    self.RearBogey = self:GetNW2Entity("RearBogey")
    self.FrontCouple = self:GetNW2Entity("FrontCouple")
    self.RearCouple = self:GetNW2Entity("RearCouple")
end

function ENT:UpdateTextures()
    if isfunction(self.BaseClass.UpdateTextures) then self.BaseClass.UpdateTextures(self) end
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
    bogey.EngineSNDConfig = bogey.EngineSNDConfig or {}
    -- if Metrostroi.Version > 1537278077 then bogey.EngineSNDConfig[bogey.MotorSoundType or 2] = {} end
    bogey.SoundNames = bogey.SoundNames or {}
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
        if (k == "brake3a") and IsValid(bogey:GetNW2Entity("TrainWheels")) then e = bogey:GetNW2Entity("TrainWheels") end
        bogey.Sounds[k] = CreateSound(e, Sound(v))
    end

    bogey.Async = nil
end

function ENT:SetupFence(fence, wag)
    local a = wag:GetNW2Entity("RearTrain") == self and -1 or 1
    local ang1 = fence:WorldToLocalAngles(wag:LocalToWorldAngles(Angle(0, 90 * a, 0)))
    local vec = fence:WorldToLocal(wag:LocalToWorld(Vector(480.1 * a, a * ang1.p * 1.585, 0.6)))
    fence:ManipulateBoneAngles(0, Angle(-ang1.r / 2, ang1.y / 2, ang1.p / 3) + Angle(0, 90, 0))
    fence:ManipulateBonePosition(0, Vector(vec.x / 2, vec.y / 2, vec.z / 2))
end

function ENT:Think()
    self.BaseClass.Think(self)
    if not self.RenderClientEnts or self.CreatingCSEnts then
        self.Number = 0
        return
    end

    if not IsValid(self.RearBogey) then self.RearBogey = self:GetNW2Entity("RearBogey") end
    if not IsValid(self.FrontBogey) then self.FrontBogey = self:GetNW2Entity("FrontBogey") end
    if IsValid(self.FrontBogey) and (self.FrontBogey.SoundNames and self.FrontBogey.SoundNames["flangea"] ~= "subway_trains/765/rumble/bogey/skrip1.wav" or not self.FrontBogey.SoundNames) or refresh then self:ReInitBogeySounds(self.FrontBogey) end
    if IsValid(self.RearBogey) and (self.RearBogey.SoundNames and self.RearBogey.SoundNames["flangea"] ~= "subway_trains/765/rumble/bogey/skrip1.wav" or not self.RearBogey.SoundNames) or refresh then self:ReInitBogeySounds(self.RearBogey) end

    if self.Number ~= self:GetWagonNumber() then self:UpdateTextures() end
    if self.Texture ~= self:GetNW2String("Texture") then self:UpdateTextures() end
    if self.PassTexture ~= self:GetNW2String("passtexture") then self:UpdateTextures() end
    if self.CabinTexture ~= self:GetNW2String("cabtexture") then self:UpdateTextures() end
    if self:IsNumberBroken() then self:UpdateTextures() end
    local RearTrain, FrontTrain = self:GetNW2Entity("RearTrain"), self:GetNW2Entity("FrontTrain")
    self:ShowHide("FenceR", IsValid(RearTrain) and (RearTrain:GetClass():find("760") and false or (RearTrain:GetClass():find("761a") or RearTrain:GetClass():find("763a") or RearTrain:GetClass():find("761e") or RearTrain:GetClass():find("763e")) and (RearTrain:GetNW2Entity("RearTrain") == self and not IsValid(RearTrain.ClientEnts["FenceR"]) or RearTrain:GetNW2Entity("FrontTrain") == self and not IsValid(RearTrain.ClientEnts["FenceF"])) and true))
    self:ShowHide("FenceF", IsValid(FrontTrain) and (FrontTrain:GetClass():find("760") and false or (FrontTrain:GetClass():find("761a") or FrontTrain:GetClass():find("763a") or FrontTrain:GetClass():find("761e") or FrontTrain:GetClass():find("763e")) and (FrontTrain:GetNW2Entity("RearTrain") == self and not IsValid(FrontTrain.ClientEnts["FenceR"]) or FrontTrain:GetNW2Entity("FrontTrain") == self and not IsValid(FrontTrain.ClientEnts["FenceF"])) and true))
    local fenceRear, fenceFront = self.ClientEnts["FenceR"], self.ClientEnts["FenceF"]

    if IsValid(fenceRear) and IsValid(RearTrain) then
        self:SetupFence(fenceRear, RearTrain)
    end
    if IsValid(fenceFront) and IsValid(FrontTrain) then
        self:SetupFence(fenceFront, FrontTrain)
    end

    local ValidfB, ValidrB = IsValid(self.FrontBogey), IsValid(self.RearBogey)
    for i = 1, 4 do
        self:ShowHide("TR" .. i, i <= 2 and ValidfB or i >= 3 and ValidrB)
        self:ShowHide("BS" .. i, ValidfB)
        self:ShowHide("BS" .. (i + 4), ValidrB)
        self:Animate("TR" .. i, self:GetPackedBool("TR" .. i) and 1 or 0, 0, 1, 8, 0.5)
        self:Animate("BS" .. i, self:GetPackedBool("BC" .. i) and 1 or 0, 1, 0.722, 32, 2)
        self:Animate("BS" .. (i + 4), self:GetPackedBool("BC" .. (i + 4)) and 1 or 0, 1, 0.722, 32, 2)
    end

    local speed = self:GetPackedRatio("Speed", 0)
    self:Animate("VmLv", self:GetPackedRatio("LV"), 0, 1, 16, 1)
    self:Animate("VmHv", self:GetPackedRatio("HV"), 0, 1, 16, 6)

    self:Animate("MnBl", self:GetPackedRatio("BL"), 0, 0.78, 256, 2)
    self:Animate("MnTl", self:GetPackedRatio("TL"), 0, 0.78, 256, 2)
    self:Animate("MnBc", self:GetPackedRatio("BC"), 0, 0.78, 256, 2)

    local BoxDoorL = self:Animate("BoxDoorL", self:GetPackedBool("CouchCapL") and 1 or 0, 0, 1, 2, 2)
    local BoxDoorR = self:Animate("BoxDoorR", self:GetPackedBool("CouchCapR") and 1 or 0, 0, 1, 2, 2)
    self:HidePanel("ClosetCapL", BoxDoorL > 0)
    self:HidePanel("ClosetCapR", BoxDoorR > 0)
    self:HidePanel("ClosetCapLop", BoxDoorL < 1)
    self:HidePanel("ClosetCapRop", BoxDoorR < 1)
    self:HidePanel("PVZ", BoxDoorL == 0)
    self:HidePanel("BoxR", BoxDoorR == 0)
    self:ShowHide("BoxIntL", BoxDoorL > 0)
    self:ShowHide("BoxAdd", BoxDoorL > 0)
    self:ShowHide("BoxIntR", BoxDoorR > 0)
    self:ShowHide("VmHv", BoxDoorR > 0)
    self:ShowHide("MnBc", BoxDoorR > 0)
    self:ShowHide("MnTl", BoxDoorR > 0)
    self:ShowHide("MnBl", BoxDoorR > 0)
    self:ShowHide("VmLv", BoxDoorL > 0)
    self:ShowHide("Stopkran", BoxDoorR > 0)
    self:HidePanel("Power", BoxDoorL == 0)
    self:Animate("FrontBrake", self:GetNW2Bool("FbI") and 0 or 1, 0, 1, 3, false)
    self:Animate("FrontTrain", self:GetNW2Bool("FtI") and 0 or 1, 0, 1, 3, false)
    self:Animate("RearBrake", self:GetNW2Bool("RbI") and 0 or 1, 0, 1, 3, false)
    self:Animate("RearTrain", self:GetNW2Bool("RtI") and 0 or 1, 0, 1, 3, false)
    self:Animate("K23Valve", self:GetNW2Bool("K23") and 0 or 1, 0, 1, 3, false)
    self:Animate("Stopkran", self:GetPackedBool("EmergencyBrakeValve") and 1 or 0.5, 0, 1, 3, false)

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

            self:SetSoundState(sid .. "r" .. randval, self.DoorLoopStates[id], 1)
            self:SetSoundState(sid .. "r" .. math.abs(1 - randval), 0, 0)
            local n_l = "door" .. i .. "x" .. k
            self:Animate(n_l, 1 - state, 0, 1, 15, 1)

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
                led = state ~= "Closed" or CurTime() % 1.4 < 0.7
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
    local release1 = math.Clamp(self.ReleasedPdT, 0, 1) ^ 2
    self:SetSoundState("release", release1, 1)
    local rollingi = math.min(1, self.TunnelCoeff + math.Clamp((self.StreetCoeff - 0.82) / 0.5, 0, 1))
    local rollings = math.max(self.TunnelCoeff * 0.6, self.StreetCoeff)
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

    local work = self:GetPackedBool("AnnPlay")
    for k, v in ipairs(self.AnnouncerPositions) do
        if self.Sounds["announcer" .. k] and IsValid(self.Sounds["announcer" .. k]) then self.Sounds["announcer" .. k]:SetVolume(work and (v[3] or 1) or 0) end
    end
end

function ENT:Draw()
    self.BaseClass.Draw(self)
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

Metrostroi.GenerateClientProps()
