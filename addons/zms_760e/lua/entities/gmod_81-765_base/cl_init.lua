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
ENT.ScreenHelpers = {}
ENT.ScreenHelpersHide = {}
ENT.ClientPropsInitialized = false

ENT.ButtonMap["PVZ"] = {
    pos = Vector(-473.39, 44.09, 8.03),
    ang = Angle(0.000, 0.000, 90.000),
    width = 305,
    height = 425,
    scale = 0.05,
    hideseat = 0.2,
    buttons = {}
}
table.Add(ENT.ButtonMap["PVZ"].buttons, ENT.PvzToggles)

ENT.ButtonMap["Power"] = {
    pos = Vector(-461.84, -38.08, -8.98),
    ang = Angle(0.000, 180.000, 90.000),
    width = 100,
    height = 50,
    scale = 0.0625,
    hideseat = 0.2,
    buttons = {
        {
            ID = "PowerOnSet",
            tooltip = "Бортсеть вкл",
            x = 37, y = 28, radius = 20,
            model = {
                var = "PowerOn",
                model = "models/metrostroi_train/81-760/81_760_button_green.mdl",
                z = -0.5, speed = 12, vmin = 0, vmax = 0.5, sndvol = 0.3,
                snd = function(val) return val and "button_square_on" or "button_square_off" end,
                sndmin = 80, sndmax = 1e3 / 3, sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "PowerOffSet",
            tooltip = "Бортсеть выкл",
            x = 79, y = 28, radius = 20,
            model = {
                var = "PowerOff",
                model = "models/metrostroi_train/81-760/81_760_button_red.mdl",
                z = -0.5, speed = 12, vmin = 0, vmax = 0.5, sndvol = 0.3,
                snd = function(val) return val and "button_square_on" or "button_square_off" end,
                sndmin = 80, sndmax = 1e3 / 3, sndang = Angle(-90, 0, 0),
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

ENT.ButtonMap["CoupleCenteringF"] = {
    pos = Vector(460, -50, -50), ang = Angle(0, 90, 90),
    width = 100, height = 30, scale = 1,
    buttons = {
        {
            ID = "CoupleCenteringFToggle",
            x = 0, y = 0, w = 100, h = 30,
            tooltip = "Ручная центровка",
            model = {
                var = "CoupleCenteringF",
            }
        }
    }
}
ENT.ButtonMap["CoupleCenteringR"] = {
    pos = Vector(-460, 50, -50), ang = Angle(0, -90, 90),
    width = 100, height = 30, scale = 1,
    buttons = {
        {
            ID = "CoupleCenteringRToggle",
            x = 0, y = 0, w = 100, h = 30,
            tooltip = "Ручная центровка",
            model = {
                var = "CoupleCenteringR",
            }
        }
    }
}

local bays = {
    {
        names = {"BayPuv", "BayCoverPuv"},
        models = {"models/metrostroi_train/81-765_v1/bays/bay_puv.mdl", "models/metrostroi_train/81-765_v1/common/bay_puv_cover.mdl"},
        tooltip = "Отсек ПУВ (ПВЗ)",
        pos = Vector(-477.35, 37.91, 42.57), ang = Angle(0.000, 8.331, 90.000),
        pos_cl = Vector(-448.96, 42.07, 42.57), ang_cl = Angle(0.000, -62.094, 90.000),
        w = 575, h = 1935, scale = 0.05, close2 = true
    }, {
        names = {"BayBs", "BayCoverBs"},
        models = {"models/metrostroi_train/81-765_v1/bays/bay_bs.mdl", "models/metrostroi_train/81-765_v1/common/bay_bs_cover.mdl"},
        tooltip = "Отсек БС",
        pos = Vector(-448.96, -41.86, 1.35), ang = Angle(0.000, 166.170, 90.000),
        pos_cl = Vector(-448.43, -43.01, 1.35), ang_cl = Angle(0.000, 77.516, 90.000),
        w = 575, h = 900, scale = 0.05, close2 = true
    }, {
        names = {nil, "BayCoverCond"},
        models = {nil, "models/metrostroi_train/81-765_v1/common/bay_cond_cover.mdl"},
        tooltip = "Отсек защиты кондиционеров",
        pos = Vector(43, -43.60, 55.72), ang = Angle(0.000, 180.000, 142.820),
        pos_cl = Vector(43, -21.03, 52.61), ang_cl = Angle(0.000, 180.000, -172.000),
        w = 1100, h = 450, scale = 0.05
    },
}

for idx = 1, 4 do
    table.insert(bays, {
        names = {nil, "BayCoverBud" .. idx},
        models = {nil, Format("models/metrostroi_train/81-765_v1/common/bay_bud_cover_%d.mdl", idx)},
        tooltip = "Отсек БУД №" .. idx,
        pos = Vector(255.53 - (idx - 1) * 235.5, 43.60, 55.72), ang = Angle(0.000, 0.000, 142.820),
        pos_cl = Vector(255.53 - (idx - 1) * 235.5, 21.03, 52.61), ang_cl = Angle(0.000, 0.000, -172.000),
        w = 1100, h = 450, scale = 0.05
    })
end

for idx = 5, 8 do
    table.insert(bays, {
        names = {nil, "BayCoverBud" .. idx},
        models = {nil, Format("models/metrostroi_train/81-765_v1/common/bay_bud_cover_%d.mdl", idx)},
        tooltip = "Отсек БУД №" .. idx,
        pos = Vector(444.5 - (idx - 5) * 235.5, -43.60, 55.72), ang = Angle(0.000, 180.000, 142.820),
        pos_cl = Vector(444.5 - (idx - 5) * 235.5, -21.03, 52.61), ang_cl = Angle(0.000, 180.000, -172.000),
        w = 1100, h = 450, scale = 0.05
    })
end

for _, bay in ipairs(bays) do
    ENT.ButtonMap[bay.names[2]] = {
        pos = bay.pos,
        ang = bay.ang,
        width = bay.w, height = bay.h, scale = bay.scale,
        buttons = {{ ID = bay.names[2], x = 0, y = 0, w = bay.w, h = bay.h, tooltip = bay.tooltip }}
    }
    ENT.ButtonMap[bay.names[2] .. "_close"] = {
        pos = bay.pos_cl,
        ang = bay.ang_cl,
        width = bay.w, height = bay.h, scale = bay.scale,
        buttons = {{ ID = bay.names[2], x = 0, y = 0, w = bay.w, h = bay.h, tooltip = "Закрыть" }}
    }
    if bay.close2 then
            local pos = bay.pos_cl + bay.ang_cl:Up() + bay.ang_cl:Forward() * bay.scale * bay.w
            local ang = Angle(bay.ang_cl)
            ang:RotateAroundAxis(ang:Right(), 180)
            ENT.ButtonMap[bay.names[2] .. "_close2"] = {
                pos = pos,
                ang = ang,
                width = bay.w, height = bay.h, scale = bay.scale,
                buttons = {{ ID = bay.names[2], x = 0, y = 0, w = bay.w, h = bay.h, tooltip = "Закрыть" }}
            }
    end
    ENT.ClientProps[bay.names[2]] = {
        model = bay.models[2],
        pos = Vector(0, 0, 0),
        ang = Angle(0, 0, 0),
        hide = 2,
    }
    if bay.models[1] and bay.names[1] then
        ENT.ClientProps[bay.names[1]] = {
            model = bay.models[1],
            pos = Vector(0, 0, 0),
            ang = Angle(0, 0, 0),
            hideseat = 2,
        }
    end
end

for i = 1, 4 do
    ENT.ButtonMap["BNTR" .. i] = {
        pos = Vector(375.83 - 235.64 * (i - 1), -43.90, 52.27),
        ang = Angle(0.000, 180.000, 111.583),
        width = 3830,
        height = 620,
        scale = 0.0134,
        system = "LBnt",
        hide = 1,
    }
    ENT.ButtonMap["BNTL" .. i] = {
        pos = Vector(-382.42 - 235.64 * (i - 4), 43.90, 52.27),
        ang = Angle(0.000, 0.000, 111.583),
        width = 3830,
        height = 620,
        scale = 0.0134,
        system = "RBnt",
        hide = 1,
    }
    ENT.ButtonMap["BNT_SARMAT_R" .. i] = {
        pos = Vector(376.4 - 235.676 * (i - 1), -44.091, 51.941),
        ang = Angle(0.000, 180.000, 111.583),
        width = 2040,
        height = 280,
        scale = 0.02576,
        system = "LBnt_Sarmat",
        hide = 1,
    }
    ENT.ButtonMap["BNT_SARMAT_L" .. i] = {
        pos = Vector(323.94 - 235.676 * (i - 1), 44.091, 51.941),
        ang = Angle(0.000, 0.000, 111.583),
        width = 2040,
        height = 280,
        scale = 0.02576,
        system = "RBnt_Sarmat",
        hide = 1,
    }
    ENT.ButtonMap["BNT_MST_R" .. i] = {
        pos = Vector(375.81 - 235.649 * (i - 1), -43.96, 52.23),
        ang = Angle(0.000, 180.000, 111.583),
        width = 2080,
        height = 128,
        scale = 0.02465,
        system = "LBnt_MST",
        hide = 1,
    }
    ENT.ButtonMap["BNT_MST_L" .. i] = {
        pos = Vector(324.51 - 235.649 * (i - 1), 43.96, 52.23),
        ang = Angle(0.000, 0.000, 111.583),
        width = 2080,
        height = 128,
        scale = 0.02465,
        system = "RBnt_MST",
        hide = 1,
    }
    ENT.ButtonMap["BNT_MST_STRIP_R" .. i] = {
        pos = Vector(381.54 - 235.635 * (i - 1), -45.30, 48.72),
        ang = Angle(0.000, 180.000, 111.583),
        width = 4096,
        height = 364,
        scale = 0.01532,
        system = "Bnt_MST_Strip",
        hide = 1,
    }
    ENT.ButtonMap["BNT_MST_STRIP_L" .. i] = {
        pos = Vector(318.80 - 235.635 * (i - 1), 45.30, 48.72),
        ang = Angle(0.000, 0.000, 111.583),
        width = 4096,
        height = 364,
        scale = 0.01532,
        system = "Bnt_MST_Strip",
        hide = 1,
    }
end

ENT.ClientProps["BayTop"] = {
    model = "models/metrostroi_train/81-765_v1/bays/bay_top.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hideseat = 0.6,
}

ENT.ClientProps["Salon"] = {
    model = "models/metrostroi_train/81-765_v1/766/salon_p.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hide = 2,
}

ENT.ClientProps["SalonLights"] = {
    model = "models/metrostroi_train/81-765_v1/lights/salon_lights_p.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hide = 2,
}

ENT.ClientProps["MezhwagR"] = {
    model = "models/metrostroi_train/81-765_v1/common/mezhwag.mdl",
    pos = Vector(-494.34, 0, 0),
    ang = Angle(0, 0, 0),
    nohide = true,
}

ENT.ClientProps["MezhwagF"] = {
    model = "models/metrostroi_train/81-765_v1/common/mezhwag.mdl",
    pos = Vector(487.88, 0, 0),
    ang = Angle(0, 180, 0),
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

for k, tbl in ipairs({ENT.LeftDoorPositions or {}, ENT.RightDoorPositions or {}}) do
    for i, pos in ipairs(tbl) do
        local idx = (k - 1) * 4 + i
        ENT.ClientProps["Door" .. idx] = {
            model = string.format("models/metrostroi_train/81-765_v1/common/door%d.mdl", idx),
            pos = Vector(0, 0, 0),
            ang = Angle(0, 0, 0),
            hide = 2,
        }
        ENT.ClientProps["Strip" .. idx] = {
            model = string.format("models/metrostroi_train/81-765_v1/lights/strips_salon_%d.mdl", idx),
            pos = Vector(0, 0, 0),
            ang = Angle(0, 0, 0),
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


local bnt_models = {
    "models/metrostroi_train/81-765_v1/common/bnt_lcd_mst.mdl",
    "models/metrostroi_train/81-765_v1/common/bnt_lcd_sarmat.mdl",
    "models/metrostroi_train/81-765_v1/common/bnt_mst.mdl",
    "models/metrostroi_train/81-765_v1/common/bnt_sarmat.mdl",
}
local function update_bnt(wag, ent)
    local typ = wag:GetNW2Int("BntType", 1)
    ent:SetModel(bnt_models[typ])

    if typ < 3 then return end
    local scheme = Metrostroi.BntSchemes765 and Metrostroi.BntSchemes765[wag:GetNW2Int("Scheme765", 1)]
    scheme = scheme and scheme.SchemeTex
    if scheme then ent:SetSubMaterial(1, scheme) end
end
ENT.ClientProps["Bnt"] = {
    model = "models/metrostroi_train/81-765_v1/common/bnt_lcd_mst.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hide = 2,
    callback = update_bnt
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
    self.LBnt = self:CreateRT("765LBnt", 3830, 620)
    self.RBnt = self:CreateRT("765RBnt", 3830, 620)
    self.LBnt_Sarmat = self:CreateRT("765LBntSarmat", 2040, 280)
    self.RBnt_Sarmat = self:CreateRT("765RBntSarmat", 2040, 280)
    self.LBnt_MST = self:CreateRT("765LBntMST", 2080, 128)
    self.RBnt_MST = self:CreateRT("765RBntMST", 2080, 128)
    self.Bnt_MST_Strip = self:CreateRT("765BntMSTs", 4096, 364)
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

    local bnt = self.ClientEnts["Bnt"]
    if IsValid(bnt) then update_bnt(self, bnt) end
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
        not self.FrontBogey.EngineSNDConfig or
        Metrostroi.Version > 1537278077 and not bogey.SoundNames["ted1_765"] or
        Metrostroi.Version <= 1537278077 and (
            not self.FrontBogey.EngineSNDConfig[1] or
            self.FrontBogey.EngineSNDConfig[1][5] ~= 0.14 or
            bogey.SoundNames["ted1_720"] ~= "subway_trains/765/rumble/engines/engine_8.wav"
        )
    )
end

local function set_bone_transform(ent, m, bone, pos, ang)
    local bidx = ent:LookupBone(bone)
    if bidx and ent:GetBoneName(bidx) ~= "__INVALIDBONE__" then
        m:SetTranslation(pos)
        m:SetAngles(ang)
        ent:SetBoneMatrix(bidx, m)
    end
end

local posFreqXY  = 3.0  -- higher = faster response
local posFreqUpZ = 2.5  -- slower when moving up
local posFreqDownZ = 5.0  -- faster when moving down
local posDamping = 0.4  -- < 1 = overshoot, = 1 = critically damped-ish
local posGravity = 120.0  -- extra downward bias on Z (units/s^2)
local maxPosOffsetSqr = 24 * 24  -- squared distance
local angFreq = 3.0
local angDamping = 0.2  -- < 1 = overshoot
local maxAngOffset = Angle(12, 12, 12)
local targetOffset = Vector(0, 0, -2)

local function spring_fnc(cur, target, vel, freq, damping, dt)
    local omega = freq * 2 * math.pi
    local x = cur - target
    local a = -omega * omega * x - (2 * damping * omega * vel)

    vel = vel + a * dt
    cur = cur + vel * dt

    return cur, vel
end

local function ang_diff(a, b)
    return (b - a + 180) % 360 - 180
end

local function clamp_axis(cur, target, maxDeg)
    if maxDeg <= 0 then return cur end
    local d = ang_diff(target, cur) -- shortest delta from target to current
    d = math.Clamp(d, -maxDeg, maxDeg)
    return target + d
end

local function spring_angle_axis(cur, target, vel, dt)
    local unwrappedTarget = cur + ang_diff(cur, target)
    return spring_fnc(cur, unwrappedTarget, vel, angFreq, angDamping, dt)
end


local function calculate_fence_mid(fence, dt)
    if dt <= 0 then return end

    local origin = fence:GetPos()
    local fwdAng = fence:GetAngles()

    local targetWorldPos = (fence.fpos1 + fence.fpos2) * 0.5
    local targetRelPos = targetWorldPos - origin + targetOffset
    local dir = fence.fpos1 - fence.fpos2
    if dir:LengthSqr() < 1e-8 then
        dir = Vector(1, 0, 0)
    end

    local targetAng = dir:Angle()
    targetAng:Normalize()

    if not fence.randomPitch then
        fence.randomPitch = math.Rand(-0.75, 0.75)
    end
    targetAng.p = (targetAng.p + fence.randomPitch) * 3
    targetAng.y = targetAng.y * 1.01

    -- Low fps throttling
    if not system.HasFocus() or dt > 0.1 then
        targetAng.p = clamp_axis(targetAng.p, fwdAng.p, maxAngOffset.p)
        targetAng.y = clamp_axis(targetAng.y, fwdAng.y, maxAngOffset.y)
        targetAng.r = clamp_axis(targetAng.r, fwdAng.r, maxAngOffset.r)
        origin:Add(targetRelPos)
        fence.fpos3 = origin
        fence.fang3 = targetAng
        return
    end

    fence._bone3Pos = fence._bone3Pos or targetRelPos
    fence._bone3PosVel = fence._bone3PosVel or Vector(0, 0, 0)
    fence._bone3Ang = fence._bone3Ang or targetAng
    fence._bone3AngVel = fence._bone3AngVel or Vector(0, 0, 0)

    local pos = fence._bone3Pos
    local posVel = fence._bone3PosVel
    local ang = fence._bone3Ang
    local angVel = fence._bone3AngVel

    pos.x, posVel.x = spring_fnc(pos.x, targetRelPos.x, posVel.x, posFreqXY, posDamping, dt)
    pos.y, posVel.y = spring_fnc(pos.y, targetRelPos.y, posVel.y, posFreqXY, posDamping, dt)

    local zFreq = (targetRelPos.z > pos.z) and posFreqUpZ or posFreqDownZ
    pos.z, posVel.z = spring_fnc(pos.z, targetRelPos.z, posVel.z, zFreq, posDamping, dt)
    posVel.z = posVel.z - posGravity * dt

    local posErr = pos - targetRelPos
    local posErrSqr = posErr:LengthSqr()
    if maxPosOffsetSqr > 0 and posErrSqr > maxPosOffsetSqr then
        pos = targetRelPos + posErr:GetNormalized() * math.sqrt(maxPosOffsetSqr)
        fence._bone3Pos = pos
    end

    ang.p, angVel.x = spring_angle_axis(ang.p, targetAng.p, angVel.x, dt)
    ang.y, angVel.y = spring_angle_axis(ang.y, targetAng.y, angVel.y, dt)
    ang.r, angVel.z = spring_angle_axis(ang.r, targetAng.r, angVel.z, dt)

    ang.p = clamp_axis(ang.p, fwdAng.p, maxAngOffset.p)
    ang.y = clamp_axis(ang.y, fwdAng.y, maxAngOffset.y)
    ang.r = clamp_axis(ang.r, fwdAng.r, maxAngOffset.r)

    fence._bone3Pos = pos
    fence._bone3Ang = ang

    fence.fpos3 = origin + pos
    fence.fang3 = ang
end

local new_fence_bones = { "Bone.L", "Bone.R", "Bone.C", "Bone.Safety.L", "Bone.Safety.R", "Bone.Couple" }
function ENT:SetupMezhwag(platform, mezhwag, wag, front, dt)
    local couple = self:GetNW2Entity(front and "FrontCouple" or "RearCouple")
    local coupleValid = IsValid(couple)

    if IsValid(wag) then
        local otherFront = wag:GetNW2Entity("FrontTrain") == self
        local k = not otherFront and -1 or 1

        if IsValid(platform) then
            local ang1 = platform:WorldToLocalAngles(wag:LocalToWorldAngles(Angle(0, 90 * k, 0)))
            local vec = platform:WorldToLocal(wag:LocalToWorld(Vector(480.1 * k, k * ang1.p * 1.585, 0.6)))
            platform:ManipulateBoneAngles(0, Angle(-ang1.r / 2, ang1.y / 2, ang1.p / 3) + Angle(0, 90, 0))
            platform:ManipulateBonePosition(0, Vector(vec.x / 2, vec.y / 2, vec.z / 2))
        end

        if IsValid(mezhwag) then
            if not mezhwag.HasCallback then
                mezhwag.fscale = Vector(1, 1, 1)
                mezhwag:AddCallback("BuildBonePositions", function(ent)
                    if ent:IsMarkedForDeletion() then return end
                    local mdl = ent:GetModel()
                    local m = Matrix()
                    if mdl == "models/metrostroi_train/81-765_v1/common/mezhwag.mdl" then
                        for idx = 1, 6 do
                            local pos = ent["fpos" .. idx]
                            local ang = ent["fang" .. idx]
                            if not pos or not ang then return end
                            if idx == 3 and ent.fpos1 and ent.fpos2 then
                                mezhwag.fscale.x = math.Clamp(ent.fpos1:Distance(ent.fpos2) / 40.9524, 0.2, 1.8)  -- TODO adjust
                            else
                                mezhwag.fscale.x = 1
                            end
                            m:SetScale(mezhwag.fscale)
                            set_bone_transform(ent, m, new_fence_bones[idx], pos, ang)
                        end
                    else -- TODO remove
                        if not ent.fpos1 or not ent.fpos2 or not ent.fang1 or not ent.fang2 then return end
                        for idx = 1, 2 do
                            set_bone_transform(ent, m, "Bone0" .. (idx + 2), ent["fpos" .. idx], ent["fang" .. idx])
                        end
                    end
                end)

                mezhwag.HasCallback = true
            end

            if mezhwag:GetModel() == "models/metrostroi_train/81-765_v1/common/mezhwag.mdl" then
                mezhwag.fpos1 = self:LocalToWorld(Vector(front and 472.681 or -479.354, 0, 0))
                mezhwag.fpos2 = wag:LocalToWorld(Vector(otherFront and 472.681 or -479.354, 0, 0))
                mezhwag.fang1 = self:LocalToWorldAngles(Angle(0, front and 0 or 180, 0))
                mezhwag.fang2 = wag:LocalToWorldAngles(Angle(0, otherFront and 0 or 180, 0))

                calculate_fence_mid(mezhwag, dt)

                mezhwag.fpos4 = self:LocalToWorld(Vector(front and 424.38 or -430.84, 0, -79.47))
                mezhwag.fpos5 = wag:LocalToWorld(Vector(otherFront and 424.38 or -430.84, 0, -79.47))
                mezhwag.fang4 = (mezhwag.fpos5 - mezhwag.fpos4):GetNormalized():Angle()
                mezhwag.fang5 = (mezhwag.fpos4 - mezhwag.fpos5):GetNormalized():Angle()
                mezhwag.fang4:Normalize()
                mezhwag.fang5:Normalize()

                local couple2 = wag:GetNW2Entity(otherFront and "FrontCouple" or "RearCouple")
                if coupleValid and IsValid(couple2) then
                    local cpos1 = couple:LocalToWorld(Vector(64.43, 0, 0))
                    local cpos2 = couple2:LocalToWorld(Vector(64.43, 0, 0))
                    mezhwag.fpos6 = cpos1 + (cpos2 - cpos1) / 2
                    mezhwag.fang6 = mezhwag.fang5
                end

            else
                mezhwag.fpos1 = wag:LocalToWorld(Vector(otherFront and 464.37 or -464.07, 0, 0))
                mezhwag.fpos2 = self:LocalToWorld(Vector(front and 464.37 or -464.07, 0, 0))
                mezhwag.fang1 = wag:LocalToWorldAngles(Angle(0, otherFront and 180 or 0, -90))
                mezhwag.fang2 = self:LocalToWorldAngles(Angle(0, front and 180 or 0, 90))
            end
        end
    end

    if coupleValid then
        if not couple.HasCallback then
            couple:AddCallback("BuildBonePositions", function(ent)
                if ent:IsMarkedForDeletion() then return end
                if not ent.AngStatic or not ent.AngRotatable then return end
                local m = Matrix()
                local pos = ent:GetPos()
                set_bone_transform(ent, m, "static", pos, ent.AngStatic)
                set_bone_transform(ent, m, "rotatable", pos, ent.AngRotatable)
            end)
            couple.HasCallback = true
        end

        local ang = couple:GetAngles()
        local selfAng = self:GetAngles()
        if not front then selfAng:RotateAroundAxis(selfAng:Up(), 180) selfAng:Normalize() end
        ang.p = selfAng.p
        ang.r = selfAng.r
        couple.AngRotatable = Angle(ang)
        ang.y = selfAng.y
        couple.AngStatic = ang
    end
end

function ENT:MezhwagConnectable(wag, prefix)
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
    self:ShowHide("MezhwagR", self:MezhwagConnectable(RearTrain, "Mezhwag"))
    self:ShowHide("FencePlR", self:MezhwagConnectable(RearTrain, "FencePl"))
    if self.IsIntermediate then
        self:ShowHide("MezhwagF", self:MezhwagConnectable(FrontTrain, "Mezhwag"))
        self:ShowHide("FencePlF", self:MezhwagConnectable(FrontTrain, "FencePl"))
    end

    local dT = self.DeltaTime

    self:SetupMezhwag(self.ClientEnts["FencePlR"], self.ClientEnts["MezhwagR"], RearTrain, false, dT)
    if self.IsIntermediate then
        self:SetupMezhwag(self.ClientEnts["FencePlF"], self.ClientEnts["MezhwagF"], FrontTrain, true, dT)
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

    local lights = self.ClientEnts["SalonLights"]
    if IsValid(lights) then
        local half, full = self:GetPackedBool("SalonLighting1"), self:GetPackedBool("SalonLighting2")
        if half and not full then
            lights:SetSubMaterial(0, "models/metrostroi_train/81-765_v1/lights/lights_half")
        elseif full then
            lights:SetSubMaterial(0,
                self:GetPackedBool("WarmLight") and
                "models/metrostroi_train/81-765_v1/lights/lights_warm" or
                "models/metrostroi_train/81-765_v1/lights/lights_cold"
            )
        else
            lights:SetSubMaterial(0, nil)
        end
    end

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

    local puv = self:HandleDoorState("BayPuvVal", "door_puv", "BayCoverPuv", "BayCoverPuv", 0.05, 0, true)
    local bs = self:HandleDoorState("BayBsVal", "door_bs", "BayCoverBs", "BayCoverBs", 0.05, 0, true)
    local cond = self:HandleDoorState("BayCondVal", "door_cond", "BayCoverCond", "BayCoverCond", 0.05, 0)
    local ceiling = puv or cond
    local bud_4 = false
    for idx = 1, 8 do
        if self.IsIntermediate or idx ~= 5 then
            local bud = self:HandleDoorState("BayCoverBudVal" .. idx, "bud_" .. idx, "BayCoverBud" .. idx, "BayCoverBud" .. idx, 0.05, 0)
            ceiling = ceiling or bud
            if idx == 4 then bud_4 = bud end
        end
    end
    self:ShowHide("BayTop", ceiling)
    self:ShowHide("BayPuv", puv or bud_4)
    self:ShowHide("BayBs", bs)
    self:HidePanel("PVZ", not puv)

    for i = 1, 4 do
        local bnt_type = self:GetNW2Int("BntType", 1)
        self:HidePanel("BNTL" .. i, bnt_type > 2)
        self:HidePanel("BNTR" .. i, bnt_type > 2)
        self:HidePanel("BNT_SARMAT_L" .. i, bnt_type ~= 4)
        self:HidePanel("BNT_SARMAT_R" .. i, bnt_type ~= 4)
        self:HidePanel("BNT_MST_L" .. i, bnt_type ~= 3)
        self:HidePanel("BNT_MST_R" .. i, bnt_type ~= 3)
        self:HidePanel("BNT_MST_STRIP_L" .. i, bnt_type ~= 3)
        self:HidePanel("BNT_MST_STRIP_R" .. i, bnt_type ~= 3)
    end

    if not self.IsIntermediate then
        self:ShowHide("ASHook", ValidfB)
        self:Animate("ASHook", self:GetPackedBool("ASHook") and 1 or 0, 0, 1, 8, 0.5)

        if Cfg765 and Cfg765.NotificationPaper then
            self:HidePanel("NotificationPaperBtn", false)
            self:ShowHide("NotificationPaper", self:GetPackedBool("NotificationPaper", false))
        else
            self:HidePanel("NotificationPaperBtn", true)
            self:ShowHide("NotificationPaper", false)
        end

        local col = render.GetLightColor(self:GetPos() + 530 * self:GetForward())
        local val = math.floor((col.x * 255 + col.y * 255 + col.z * 255) * 5) / 5
        if self.LightVal ~= val and CurTime() - (self.LightValTimer or 0) > 0 or not self.LightVal then
            self.LightValTimer = CurTime() + 0.5
            self.LightVal = val
        end

        local headl = math.max(0, self:GetPackedRatio("Headlights") + (self.LightVal >= 6 and self:GetPackedRatio("Headlights") == 1 and -0.5 or 0))
        self:SetLightPower(1, headl > 0, headl)

        local rl = self:GetPackedBool("BacklightsEnabled")
        local hl1 = (self:GetPackedBool("HeadLightsEnabled1") or self:GetPackedBool("HeadLightsEnabled2") and self.LightVal >= 6)
        local hl2 = self:GetPackedBool("HeadLightsEnabled2") and self.LightVal < 6
        local hl12 = hl1 or hl2

        for idx = 1, 6 do
            local lightEnt = self.ClientEnts["Headlights" .. idx]
            if IsValid(lightEnt) then
                local redOn = rl and (idx < 3 or idx > 4 or not hl12) and not self:GetNW2Bool("RlBroken" .. idx, false)
                local whiteOn = hl12 and (not rl or idx >= 3 and idx <= 4) and not self:GetNW2Bool("WlBroken" .. idx, false)
                lightEnt:SetSubMaterial(0,
                    redOn and "models/metrostroi_train/81-765_v1/765/headlights_moscow_red" or
                    whiteOn and "models/metrostroi_train/81-765_v1/765/headlights_moscow_white" or
                    "models/metrostroi_train/81-765_v1/765/headlights_moscow_off"
                )
            end
        end

        local headlEnt = self.GlowingLights[1]
        if IsValid(headlEnt) then
            headlEnt:SetEnableShadows(true)
            if headl < 1 and headlEnt:GetFarZ() > 4096 then headlEnt:SetFarZ(4096) end
            if headl == 1 and headlEnt:GetFarZ() < 8192 then headlEnt:SetFarZ(8192) end
        end

        self:SetLightPower(3, not rl and hl12, hl12 and 1 or 0)
        self:SetLightPower(2, rl, rl and 1 or 0)

        local PanelLighting = self:GetPackedBool("PanelLighting")
        self:SetLightPower(11, PanelLighting)
        self:SetLightPower(12, PanelLighting)

        self:Animate("MnBl", self:GetPackedRatio("BL"), 0, 1, 256, 2)
        self:Animate("MnTl", self:GetPackedRatio("TL"), 0, 1, 256, 2)
        self:Animate("MnBc", self:GetPackedRatio("BC"), 0, 1, 256, 2)
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
        local cabl_half = self:GetPackedBool("CabinEnabledEmer")
        cabl_full = self:Animate("CabFull", cabl_full and 1 or 0, 0, 1, 5, false)
        cabl_half = self:Animate("CabEmer", cabl_half and 1 or 0, 0, 1, 5, false)
        self:ShowHideSmooth("cab_full", cabl_full)
        self:ShowHideSmooth("cab_half", cabl_half)

        local DoorCabL = self:Animate("DoorCabL", self:GetPackedBool("CabinDoorLeft") and 1 or 0, 0, 1, 2, 0.5)
        local DoorCabR = self:Animate("DoorCabR", self:GetPackedBool("CabinDoorRight") and (self:GetPackedBool("CabinDoorRightLimit") and 0.6 or 1) or 0, 0, 1, 2, 0.5)
        self:PlayDoorSound(self:Animate("DoorCabM", self:GetPackedBool("PassengerDoor") and 1 or 0, 0, 1, 2, 0.5) > 0.2, "door_cab_m")
        self:PlayDoorSound(DoorCabL > 0.2, "door_cab_l")
        self:PlayDoorSound(DoorCabR > 0.2, "door_cab_r")
        self:AnimateCustom("DoorCabL", "window", self:GetPackedBool("CabinWindowLeft") and 1 or 0, 0, 1, 8, 0.5)
        self:AnimateCustom("DoorCabR", "window", self:GetPackedBool("CabinWindowRight") and 1 or 0, 0, 1, 8, 0.5)

        local k35_1 = self:HandleDoorState("K35C1", "door_k35_1", "BayCoverK35_1", "BayCoverK35_1", 0.1, 0.2)
        local k35_2 = self:HandleDoorState("K35C2", "door_k35_2", "BayCoverK35_2", "BayCoverK35_2", 0.1, 0.2)
        self:ShowHide("K35", k35_1 or k35_2)
        self:HidePanel("K35", not k35_1 and not k35_2)

        local bm2 = self:HandleDoorState("BayMain2Val", "door_bay_2", "BayCoverMain2", "BayCoverMain2", 0.1, 0.2)
        local bm3 = self:HandleDoorState("BayMain3Val", "door_bay_3", "BayCoverMain3", "BayCoverMain3", 0.1, 0.2)
        self:ShowHide("K35", bm2 or bm3)

        self:Animate("CabChairAdd", self:GetPackedBool("CabChairAdd") and 1 or 0, 0, 1, 4, 0.5)
        self:HidePanel("CoupleCenteringF", not self:GetNW2Bool("CoupleSprings", false) or self:GetNW2Bool("FrontCoupled", false))
        self:HidePanel("CoupleCenteringR", not self:GetNW2Bool("CoupleSprings", false) or self:GetNW2Bool("RearCoupled", false))

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
            self.CraneRamp = self.CraneRamp + ((0.4 * ramp) - self.CraneRamp) * dT * 2
        else
            self.CraneRamp = self.CraneRamp + ((1.2 * ramp) - self.CraneRamp) * dT
        end
        self.CraneRRamp = math.Clamp(self.CraneRRamp + 1.0 * ((1 * ramp) - self.CraneRRamp) * dT * 2, 0, 1)

        self:SetSoundState("crane013_release", self.CraneRRamp ^ 1.5, 1.0)
        self:SetSoundState("crane013_brake", math.Clamp(-self.CraneRamp * 1.5, 0, 1) ^ 1.3, 1.0)
        self:SetSoundState("crane013_brake2", math.Clamp(-self.CraneRamp * 1.5 - 0.95, 0, 1.5) ^ 2, 1.0)

        -- self.EmergencyValveEPKRamp = math.Clamp(self.EmergencyValveEPKRamp + 1.0 * ((0.4 * emergencyValveEPK) - self.EmergencyValveEPKRamp) * dT, 0, 1)
        local prevRvtbRamp = self.EmergencyValveEPKRamp
        self.EmergencyValveEPKRamp = self:GetPackedRatio("EmergencyValveEPK_dPdT", 0) * 0.24
        if self.EmergencyValveEPKRamp < 0.01 then self.EmergencyValveEPKRamp = 0
        elseif self.EmergencyValveEPKRamp < 0.08 then self.EmergencyValveEPKRamp = 0.08 end

        if self.EmergencyValveEPKRamp > 0 and not self.RvtbLeak then
            self.RvtbLeak = CurTime() + 0.3
            self.RvtbLeakEnd = nil
        elseif self.EmergencyValveEPKRamp == 0 and self.RvtbLeak then
            self.RvtbLeak = nil
            self.RvtbLeakEnd = CurTime() + 0.1
            self.RvtbLeakEndRamp = prevRvtbRamp
        end
        local rvtb_start = self.RvtbLeak and math.Clamp(1.25 - (CurTime() - self.RvtbLeak), 0, 1.25) / 1.25 or 0
        local rvtb_end = self.RvtbLeakEnd and math.Clamp(0.28 - (CurTime() - self.RvtbLeakEnd), 0, 0.28) / 0.28 or 0
        local rvtb_loop = 1 - math.max(rvtb_start, rvtb_end)
        self:SetSoundState("rvtb_leak", self.EmergencyValveEPKRamp * rvtb_loop, 1.0)
        self:SetSoundState("rvtb_leak_start", self.EmergencyValveEPKRamp * rvtb_start, 1.0)
        self:SetSoundState("rvtb_leak_end", math.max(0.08, self.RvtbLeakEndRamp or 0) * rvtb_end, 1.0)

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

function ENT:HandleDoorState(nwvar, snd, panel, prop, open_state, close_state, two_sides)
    local state = self:GetPackedBool(nwvar)
    local val = self:Animate(prop, state and 1 or 0, 0, 1, 2, 0.5)
    local b = self:PlayDoorSound2(snd, val, 0.1, 0.2, state)
    self:HidePanel(panel, b)
    self:HidePanel(panel .. "_close", not b)
    if two_sides then
        self:HidePanel(panel .. "_close2", not b)
    end
    return b
end

function ENT:PlayDoorSound2(door, state, open_state, close_state, target_state)
    if not target_state and target_state ~= false then
        target_state = self[door]
    end
    local b = target_state and state > open_state or not target_state and state >= close_state
    if self[door] ~= b then
        self[door] = b
        self:PlayOnce(Format("%s_%s", door, b and "open" or "close"), "", self:IsolateSound(1), 1)
    end
    return b
end

function ENT:IsolateSound(val)
    -- todo
    return val
end

function ENT:ShowScreenHelper(screen, group)
    self.ActiveHelperGroups = self.ActiveHelperGroups or {}
    self.ActiveHelperGroups[screen] = group
    for groupName, v in pairs(self.ScreenHelpers[screen] or {}) do
        for _, bmName in pairs(v or {}) do
            self:HidePanel(bmName, group ~= groupName or self.HiddenSH and self.HiddenSH[bmName])
        end
    end
    for groupName, v in pairs(self.ScreenHelpersHide[screen] or {}) do
        if groupName ~= group then
            for _, hidePanels in pairs(v or {}) do
                for _, bmName in pairs(hidePanels or {}) do
                    self:HidePanel(bmName, true)
                end
            end
        end
    end
end

function ENT:ShowHideSceenHelper(val, screen, helper)
    local group = self.ActiveHelperGroups and self.ActiveHelperGroups[screen]
    if not screen or not group or not helper then return end
    local panel = (
        self.ScreenHelpers[screen] and
        self.ScreenHelpers[screen][group] and
        self.ScreenHelpers[screen][group][helper]
    ) or nil
    if panel then
        self.HiddenSH = self.HiddenSH or {}
        self.HiddenSH[panel] = not val
    end
end

function ENT:ShowHideSceenHelperElement(val, screen, group, helper, name)
    if not screen or not group or not helper or not name then return end
    local panel = (
        self.ScreenHelpersHide[screen] and
        self.ScreenHelpersHide[screen][group] and
        self.ScreenHelpersHide[screen][group][helper] and
        self.ScreenHelpersHide[screen][group][helper][name]
    ) or nil
    if panel then
        self:HidePanel(panel, val)
    end
end

function ENT:Draw()
    local BaseClass = scripted_ents.GetStored("gmod_subway_base").t
    BaseClass.Draw(self)
end

function ENT:DrawPost(special)
    self.RTMaterial:SetInt("$flags", bit.bor(self.RTMaterial:GetInt("$flags"), 65536))  -- "$decal" flag
    self.RTMaterial:SetTexture("$basetexture", self.LBnt)
    for i = 1, 4 do
        self:DrawOnPanel("BNTL" .. i, function(...)
            surface.SetMaterial(self.RTMaterial)
            surface.SetDrawColor(255, 255, 255)
            surface.DrawTexturedRectRotated(1915, 310, 3830, 620, 0)
        end)
    end
    self.RTMaterial:SetTexture("$basetexture", self.RBnt)
    for i = 1, 4 do
        self:DrawOnPanel("BNTR" .. i, function(...)
            surface.SetMaterial(self.RTMaterial)
            surface.SetDrawColor(255, 255, 255)
            surface.DrawTexturedRectRotated(1915, 310, 3830, 620, 0)
        end)
    end
    self.RTMaterial:SetTexture("$basetexture", self.LBnt_Sarmat)
    for i = 1, 4 do
        self:DrawOnPanel("BNT_SARMAT_L" .. i, function(...)
            surface.SetMaterial(self.RTMaterial)
            surface.SetDrawColor(255, 255, 255)
            surface.DrawTexturedRectRotated(1020, 140, 2040, 280, 0)
        end)
    end
    self.RTMaterial:SetTexture("$basetexture", self.RBnt_Sarmat)
    for i = 1, 4 do
        self:DrawOnPanel("BNT_SARMAT_R" .. i, function(...)
            surface.SetMaterial(self.RTMaterial)
            surface.SetDrawColor(255, 255, 255)
            surface.DrawTexturedRectRotated(1020, 140, 2040, 280, 0)
        end)
    end
    self.RTMaterial:SetTexture("$basetexture", self.LBnt_MST)
    for i = 1, 4 do
        self:DrawOnPanel("BNT_MST_L" .. i, function(...)
            surface.SetMaterial(self.RTMaterial)
            surface.SetDrawColor(255, 255, 255)
            surface.DrawTexturedRectRotated(1040, 64, 2080, 128, 0)
        end)
    end
    self.RTMaterial:SetTexture("$basetexture", self.RBnt_MST)
    for i = 1, 4 do
        self:DrawOnPanel("BNT_MST_R" .. i, function(...)
            surface.SetMaterial(self.RTMaterial)
            surface.SetDrawColor(255, 255, 255)
            surface.DrawTexturedRectRotated(1040, 64, 2080, 128, 0)
        end)
    end
    self.RTMaterial:SetTexture("$basetexture", self.Bnt_MST_Strip)
    for i = 1, 4 do
        self:DrawOnPanel("BNT_MST_STRIP_L" .. i, function(...)
            surface.SetMaterial(self.RTMaterial)
            surface.SetDrawColor(255, 255, 255)
            surface.DrawTexturedRectRotated(2048, 182, 4096, 364, 0)
        end)
        self:DrawOnPanel("BNT_MST_STRIP_R" .. i, function(...)
            surface.SetMaterial(self.RTMaterial)
            surface.SetDrawColor(255, 255, 255)
            surface.DrawTexturedRectRotated(2048, 182, 4096, 364, 0)
        end)
    end
end

function ENT:OnPlay(soundid, location, range, pitch)
    if location ~= "bass" then return soundid, location, range, pitch end
    if soundid == "W30KM" then
        if range == 0 then
            timer.Create("765.BatteryOffPost." .. self:EntIndex(), math.Rand(1, 1.15), 1, function()
                if not IsValid(self) then return end
                self:PlayOnce("battery_off_2", location, 1, 1)
            end)
        end
        return range > 0 and "battery_on_1" or "battery_off_1", location, 1, 1
    elseif soundid == "BV" then
        return range > 0 and "battery_pneumo" or "bv_off", location, 1, 1
    end
    return soundid, location, range, pitch
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
    "ScreenHelpers",
    "ScreenHelpersHide",
    "ClientSounds",
    "AutoAnims",
    "ClientPropsInitialized",
    "Lights",
    "PakPositions"
)
