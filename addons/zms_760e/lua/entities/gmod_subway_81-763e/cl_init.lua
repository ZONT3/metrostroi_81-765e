include("shared.lua")
--------------------------------------------------------------------------------
ENT.ClientProps = {}
ENT.ButtonMap = {}
ENT.AutoAnims = {}
ENT.ClientSounds = {}
--------------------------------------------------------------------------------
ENT.ClientPropsInitialized = false
ENT.ButtonMap["PVZ"] = {
    pos = Vector(450.75, 53.77, 16.95), --446 -- 14 -- -0,5
    ang = Angle(0, -90, 90),
    width = 170,
    height = 473,
    scale = 0.0625,
    hideseat = 0.2,
    buttons = {
        {
            ID = "SF34Toggle",
            x = 0 * 16 + 8,
            y = 0,
            w = 16,
            h = 50,
            tooltip = "SF34"
        },
        {
            ID = "SF35Toggle",
            x = 1 * 16 + 8,
            y = 0,
            w = 16,
            h = 50,
            tooltip = "SF35"
        },
        {
            ID = "SF36Toggle",
            x = 2 * 16 + 8,
            y = 0,
            w = 16,
            h = 50,
            tooltip = "SF36"
        },
        {
            ID = "SF37Toggle",
            x = 3 * 16 + 8,
            y = 0,
            w = 16,
            h = 50,
            tooltip = "SF37"
        },
        {
            ID = "SF38Toggle",
            x = 4 * 16 + 8,
            y = 0,
            w = 16,
            h = 50,
            tooltip = "SF38"
        },
        {
            ID = "SF39Toggle",
            x = 5 * 16 + 8,
            y = 0,
            w = 16,
            h = 50,
            tooltip = "SF39"
        },
        {
            ID = "SF40Toggle",
            x = 6 * 16 + 8,
            y = 0,
            w = 16,
            h = 50,
            tooltip = "SF40"
        },
        {
            ID = "SF41Toggle",
            x = 7 * 16 + 8,
            y = 0,
            w = 16,
            h = 50,
            tooltip = "SF41"
        },
        {
            ID = "SF56Toggle",
            x = 8 * 16 + 8,
            y = 0,
            w = 16,
            h = 50,
            tooltip = "SF56"
        },
        {
            ID = "SF57Toggle",
            x = 9 * 16 + 8,
            y = 0,
            w = 16,
            h = 50,
            tooltip = "SF57"
        },
        {
            ID = "SF44Toggle",
            x = 0 * 16 + 8,
            y = 173,
            w = 16,
            h = 50,
            tooltip = "SF44"
        },
        {
            ID = "SF43Toggle",
            x = 1 * 16 + 8,
            y = 173,
            w = 16,
            h = 50,
            tooltip = "SF43"
        },
        {
            ID = "SF46Toggle",
            x = 2 * 16 + 8,
            y = 173,
            w = 16,
            h = 50,
            tooltip = "SF46"
        },
        {
            ID = "SF47Toggle",
            x = 3 * 16 + 8,
            y = 173,
            w = 16,
            h = 50,
            tooltip = "SF47"
        },
        {
            ID = "SF48Toggle",
            x = 4 * 16 + 8,
            y = 173,
            w = 16,
            h = 50,
            tooltip = "SF48"
        },
        {
            ID = "SF49Toggle",
            x = 5 * 16 + 8,
            y = 173,
            w = 16,
            h = 50,
            tooltip = "SF49"
        },
        {
            ID = "SF53Toggle",
            x = 6 * 16 + 8,
            y = 173,
            w = 16,
            h = 50,
            tooltip = "SF53"
        },
        {
            ID = "SF54Toggle",
            x = 7 * 16 + 8,
            y = 173,
            w = 16,
            h = 50,
            tooltip = "SF54"
        },
        {
            ID = "SF55Toggle",
            x = 8 * 16 + 8,
            y = 173,
            w = 16,
            h = 50,
            tooltip = "SF55"
        },
        {
            ID = "SF42Toggle",
            x = 9 * 16 + 8,
            y = 173,
            w = 16,
            h = 50,
            tooltip = "SF42"
        },
        {
            ID = "SF80F9Toggle",
            x = 0 * 16 + 8,
            y = 85,
            w = 16,
            h = 50,
            tooltip = "80F9: Скорость 0 (БУД)"
        },
    }
}

for k, buttbl in ipairs(ENT.ButtonMap["PVZ"].buttons) do
    buttbl.model = {
        model = "models/metrostroi_train/81-760/81_760_switch_pmv.mdl",
        z = -16,
        ang = Angle(-180, 90, 90),
        var = buttbl.ID:Replace("Toggle", ""),
        speed = 9,
        sndvol = 0.4,
        snd = function(val) return val and "sf_on" or "sf_off" end,
        sndmin = 90,
        sndmax = 1e3,
    }
end

ENT.ButtonMap["Power"] = {
    pos = Vector(448.7, 50.4, -12.1), --446 -- 14 -- -0,5
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
                --lamp = {model = "models/metrostroi_train/81-760/81_760_lamp_red.mdl",var="PowerOnLamp",z=0.2,anim=true},
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
    pos = Vector(452.46, 22, 50), --446 -- 14 -- -0,5
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
                var = "Battery", --sndid = "batt_on",
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
    --screenHide = true,
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
            }
        },
        --model = "models/metrostroi_train/81-760/81_760_crane_tm_out.mdl", ang=Angle(0,90,-35), z=-1,y=0,
        --speed=4,vmin=1,vmax=0,
        --sndvol = 1, snd = function(val) return "disconnectvalve" end,
        --sndmin = 50, sndmax = 1e3, sndang = Angle(-90,0,0),
        {
            ID = "FrontTrainLineIsolationToggle",
            x = 192,
            y = 64,
            radius = 32,
            tooltip = "Концевой кран напорной магистрали",
            model = {
                var = "FrontTrainLineIsolation",
                sndid = "FrontTrain",
            }
        },
    }
}

--model = "models/metrostroi_train/81-760/81_760_crane_nm_out.mdl", ang=Angle(180,90,35), z=-1,y=0,
--speed=4,vmin=1,vmax=0,
--sndvol = 1, snd = function(val) return "disconnectvalve" end,
--sndmin = 50, sndmax = 1e3, sndang = Angle(-90,0,0),
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
    --screenHide = true,
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
            }
        },
        --model = "models/metrostroi_train/81-760/81_760_crane_tm_out.mdl", ang=Angle(0,90,-35), z=-1,y=0,
        --speed=4,vmin=1,vmax=0,
        --sndvol = 1, snd = function(val) return "disconnectvalve" end,
        --sndmin = 50, sndmax = 1e3, sndang = Angle(-90,0,0),
        {
            ID = "RearTrainLineIsolationToggle",
            x = 192,
            y = 64,
            radius = 32,
            tooltip = "Концевой кран напорной магистрали",
            model = {
                var = "RearTrainLineIsolation",
                sndid = "RearTrain",
            }
        },
    }
}

--model = "models/metrostroi_train/81-760/81_760_crane_nm_out.mdl", ang=Angle(180,90,35), z=-1,y=0,
--speed=4,vmin=1,vmax=0,
--sndvol = 1, snd = function(val) return "disconnectvalve" end,
--sndmin = 50, sndmax = 1e3, sndang = Angle(-90,0,0),
ENT.ClientProps["RearBrake"] = {
    --
    model = "models/metrostroi_train/81-760/81_760_crane_k23.mdl",
    pos = Vector(-449.1, -63.2, -64.1),
    ang = Angle(0, 90, 0),
    hide = 2,
}

ENT.ClientProps["RearTrain"] = {
    --
    model = "models/metrostroi_train/81-760/81_760_crane_k23.mdl",
    pos = Vector(-439.2, -60.35, -66.1),
    ang = Angle(0, 90, 0),
    hide = 2,
}

ENT.ClientSounds["RearBrakeLineIsolation"] = {{"RearBrake", function() return "disconnectvalve" end, 1, 1, 50, 1e3, Angle(-90, 0, 0)}}
ENT.ClientSounds["RearTrainLineIsolation"] = {{"RearTrain", function() return "disconnectvalve" end, 1, 1, 50, 1e3, Angle(-90, 0, 0)}}
ENT.ButtonMap["couch_capL"] = {
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

ENT.ButtonMap["couch_capL_o"] = {
    pos = Vector(264.6, 45.6, 20), --362
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

ENT.ButtonMap["couch_capR"] = {
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

ENT.ButtonMap["couch_capR_o"] = {
    pos = Vector(264.6, -36, -54), --372
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

ENT.ButtonMap["boxR"] = {
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
                var = "EmergencyBrakeValve", --sndid="emergency",
            }
        },
    }
}

--model = "models/metrostroi_train/81-760/81_761_trihedral.mdl",z=1, ang=Angle(0,-90,0),
--sndvol = 1, snd = function(val) return "disconnect_valve" end,
--sndmin = 50, sndmax = 1e3, sndang = Angle(-90,0,0),		
ENT.ClientProps["stopkran"] = {
    model = "models/metrostroi_train/81-760/81_760_crane_handle_red.mdl",
    pos = Vector(451.8, -35.4, -32.9),
    ang = Angle(180, 180, -90),
    hide = 2,
}

ENT.ClientSounds["EmergencyBrakeValve"] = {{"stopkran", function() return "disconnectvalve" end, 1, 1, 50, 1e3, Angle(-90, 0, 0)}}
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

for i = 1, 2 do
    ENT.ButtonMap["Tickers" .. i] = {
        pos = Vector((i == 1 and 1 or -0.92) * 4.35, (i == 1 and 1 or -1) * -18.15, 54.2), --446 -- 14 -- -0,5
        ang = Angle(0, (i == 1 and 1 or -1) * 90, 95),
        width = 492,
        height = 64,
        scale = 0.074,
        hide = 2,
    }
end

for i = 1, 4 do
    ENT.ButtonMap["BNT" .. i] = {
        pos = Vector(321.63 - 229.975 * (i - 1), 47.1, 52.5),
        ang = Angle(0, 0, 119.9),
        width = 640,
        height = 480,
        scale = 0.0134, --0.018
        system = "BNT",
        hide = 1,
    }

    ENT.ButtonMap["BNT" .. i + 4] = {
        pos = Vector(-321.31 - 229.975 * (i - 4), -47.1, 52.5),
        ang = Angle(180, 0, -60.1),
        width = 640,
        height = 480,
        scale = 0.0134, --0.018
        system = "BNT",
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
    pos = Vector(0, 0, 0), --Vector(55.5,0,-54.25),
    ang = Angle(0, 0, 0),
    hide = 2,
}

--[[
ENT.ClientProps["trihedral"] = {
	model = "models/metrostroi_train/81-760/81_761_trihedral.mdl",
	pos = Vector(411.5,56.95,-20.2),
	ang = Angle(0,0,0)
}]]
--[[
ENT.ClientProps["box_int_l"] = {
	model = "models/metrostroi_train/81-760/81_763a_box_int_l.mdl",
	pos = Vector(0,0,0),
	ang = Angle(0,0,0),
	hide=2,
}]]
ENT.ClientProps["box_int_r"] = {
    model = "models/metrostroi_train/81-760/81_761a_box_int_r.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hide = 2,
}

ENT.ClientProps["box_add"] = {
    model = "models/metrostroi_train/81-760/81_763a_box_add.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hide = 2,
}

ENT.ClientProps["box_door_l"] = {
    model = "models/metrostroi_train/81-760/81_761a_box_door_l.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hide = 2,
}

ENT.ClientProps["box_door_r"] = {
    model = "models/metrostroi_train/81-760/81_761a_box_door_r.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hide = 2,
}

ENT.ClientProps["lamp1"] = {
    model = "models/metrostroi_train/81-760/81_760_lamp_int_half.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hide = 2,
}

ENT.ClientProps["lamp2"] = {
    model = "models/metrostroi_train/81-760/81_761_lamp_int_full.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hide = 2,
}

ENT.ClientProps["volt_lv"] = {
    model = "models/metrostroi_train/81-760/81_760_arrow_electric.mdl",
    pos = Vector(448.42, 48.84, -11.3),
    ang = Angle(0, -90, 0),
    hide = 0.2,
}

ENT.ClientProps["volt_hv"] = {
    model = "models/metrostroi_train/81-760/81_760_arrow_electric.mdl",
    pos = Vector(457.55, -42.825, -27.43),
    ang = Angle(0, -90, 0),
    hide = 0.2,
}

ENT.ClientProps["brake_cylinder"] = {
    model = "models/metrostroi_train/81-760/81_761_arrow_nm.mdl",
    pos = Vector(455.09, -53.9, -21.3),
    ang = Angle(45.1, 90, 0),
    hideseat = 0.2,
}

ENT.ClientProps["train_line"] = {
    model = "models/metrostroi_train/81-760/81_761_arrow_nm.mdl",
    pos = Vector(455.07, -47.6, -21.3),
    ang = Angle(45.1, 90, 0),
    hideseat = 0.2,
}

ENT.ClientProps["brake_line"] = {
    model = "models/metrostroi_train/81-760/81_761_arrow_tm.mdl",
    pos = Vector(455.09, -47.6, -21.3),
    ang = Angle(45.1, 90, 0),
    hideseat = 0.2,
}

--[[
table.insert(ENT.ClientProps,{
    model = "models/metrostroi_train/81-720/720_tablo.mdl",
    pos = Vector(0,0,0),
    ang = Angle(0,0,0),
})
ENT.ClientProps["lamps_emer"] = {
    model = "models/metrostroi_train/81-720/720_lamps_emer.mdl",
    pos = Vector(0,0,0),
    ang = Angle(0,0,0),
    color = Color(245,238,223)
}
ENT.ClientProps["lamps_full"] = {
    model = "models/metrostroi_train/81-720/720_lamps_full.mdl",
    pos = Vector(0,0,0),
    ang = Angle(0,0,0),
    color = Color(245,238,223)
}]]
ENT.ClientProps["PassSchemes"] = {
    model = "models/metrostroi_train/81-760/81_760_panel_l.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hide = 1.5,
}

ENT.ClientProps["PassSchemesR"] = {
    model = "models/metrostroi_train/81-760/81_760_panel_r.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hide = 1.5,
}

for i = 1, 5 do
    ENT.ClientProps["led_l_f" .. i] = {
        model = "models/metrostroi_train/81-760/81_760_bnt_led_l_rev.mdl", --"models/metrostroi_train/81-720/720_led_l_r.mdl",
        pos = Vector((i - 1) * 6.73), --Vector((i-1)*10.5+0.2,0,0),
        ang = Angle(0, 0, 0),
        skin = 6,
        hideseat = 1.5,
    }

    ENT.ClientProps["led_l_b" .. i] = {
        --b
        model = "models/metrostroi_train/81-760/81_760_bnt_led_l.mdl", --"models/metrostroi_train/81-720/720_led_l.mdl",
        pos = Vector(-(i - 1) * 6.73, 0, 0),
        ang = Angle(0, 0, 0),
        skin = 6,
        hideseat = 1.5,
    }

    ENT.ClientProps["led_r_f" .. i] = {
        model = "models/metrostroi_train/81-760/81_760_bnt_led_r_rev.mdl", --"models/metrostroi_train/81-720/720_led_l_r.mdl",
        pos = Vector((i - 1) * 6.73 - 26.93), --Vector((i-1)*10.5+0.2,0,0),
        ang = Angle(0, 0, 0),
        skin = 6,
        hideseat = 1.5,
    }

    ENT.ClientProps["led_r_b" .. i] = {
        model = "models/metrostroi_train/81-760/81_760_bnt_led_r.mdl", --"models/metrostroi_train/81-720/720_led_l_r.mdl",
        pos = Vector(-(i - 1) * 6.73 + 26.93), --Vector((i-1)*10.5+0.2,0,0),
        ang = Angle(0, 0, 0),
        skin = 6,
        hideseat = 1.5,
    }
end

--[[
ENT.ClientProps["mezhvag"] = {
    model = "models/metrostroi_train/81-760/81_760_fence.mdl",--"models/metrostroi/mezhvag.mdl",
    pos = Vector(-470.8,0,-15),-- -474.7 1.27 -467
    ang = Angle(0,90,0),
	hide = 2,
}
ENT.ClientProps["mezhvag1"] = {
    model = "models/metrostroi_train/81-760/81_760_fence.mdl",--"models/metrostroi/mezhvag.mdl",
    pos = Vector(470.8,0,-15),-- -474.7 1.27 -467
    ang = Angle(0,-90,0),
	hideseat = 1000,
	hide = 2,
}]]
local pos = {
    [1] = Vector(-27.93, 40.5, -18.36),
    [2] = Vector(-27.93, -39.5, -18.36),
    [3] = Vector(27.93, 39.5, -18.36),
    [4] = Vector(27.93, -40.5, -18.36),
}

for i = 1, 8 do
    ENT.ClientProps["brake_shoe" .. i] = {
        model = "models/metrostroi_train/81-760/81_760_brake_shoe.mdl",
        pos = Vector(0, 0, -78),
        ang = Angle(0, 180 - 180 * (i % 2), 0),
        hide = 0.5,
        callback = function(ent, cl_ent)
            local bogey = i <= 4 and ent:GetNW2Entity("FrontBogey") or i > 4 and ent:GetNW2Entity("RearBogey")
            if not IsValid(bogey) then
                ent:ShowHide("brake_shoe" .. i, false)
                return
            end

            cl_ent:SetParent(bogey)
            cl_ent:SetPos(bogey:LocalToWorld(pos[i > 4 and i - 4 or i]))
            local ang = bogey:GetAngles()
            cl_ent:SetAngles((i <= 2 or i > 4 and i <= 6) and Angle(-ang.x, 180 + ang.y, -ang.z) or ang)
        end,
    }
end

for i = 1, 4 do
    ENT.ClientProps["TR" .. i] = {
        model = "models/metrostroi_train/81-760/81_760_pantograph.mdl",
        pos = Vector(0, 0, -70),
        ang = Angle(0, 180 * (i % 2), 0),
        hide = 2,
        callback = function(ent, cl_ent)
            local rearbogey, frontbogey = ent:GetNW2Entity("RearBogey"), ent:GetNW2Entity("FrontBogey")
            if i <= 2 then
                if not IsValid(frontbogey) then
                    ent:ShowHide("TR" .. i, false)
                    return
                end

                cl_ent:SetParent(frontbogey)
                cl_ent:SetPos(frontbogey:GetPos())
                local ang = frontbogey:GetAngles()
                cl_ent:SetAngles(i % 2 == 1 and Angle(-ang.x, 180 + ang.y, -ang.z) or ang)
            else
                if not IsValid(rearbogey) then
                    ent:ShowHide("TR" .. i, false)
                    return
                end

                cl_ent:SetParent(rearbogey)
                cl_ent:SetPos(rearbogey:GetPos())
                local ang = rearbogey:GetAngles()
                cl_ent:SetAngles(i % 2 == 1 and Angle(-ang.x, 180 + ang.y, -ang.z) or ang)
            end
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

--sndvol = 0.8,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
--snd = function(val) return val and "gv_f" or "gv_b" end,
ENT.ClientProps["K23Valve"] = {
    --
    model = "models/metrostroi_train/81-760/81_760_crane_k23.mdl",
    pos = Vector(131.42, -64.14, -64.6),
    ang = Angle(0, 0, 0),
    hide = 2,
}

ENT.ClientSounds["K23ValveIsolation"] = {{"K23Valve", function() return "disconnectvalve" end, 1, 1, 50, 1e3, Angle(-90, 0, 0)}}
ENT.ButtonMap["K31Cap"] = {
    pos = Vector(76.9, 57, -13.4), --28
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
    pos = Vector(74.6, 60, -13), --28
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

ENT.ClientProps["K31_cap"] = {
    model = "models/metrostroi_train/81-760/81_760_cap_k31.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hide = 0.5,
}

ENT.ClientProps["fence"] = {
    model = "models/metrostroi_train/81-760/81_760_fence_corrugated_platform.mdl", --"models/metrostroi/mezhvag.mdl",
    pos = Vector(-480.15, 0, 0), -- -474.7 1.27 -467
    ang = Angle(0, 90, 0),
    hide = 2,
}

ENT.ClientProps["fence1"] = {
    model = "models/metrostroi_train/81-760/81_760_fence_corrugated_platform.mdl", --"models/metrostroi/mezhvag.mdl",
    pos = Vector(480.15, 0, 0), -- -474.7 1.27 -467
    ang = Angle(0, -90, 0),
    hide = 2,
}

--------------------------------------------------------------------------------
-- Add doors
--------------------------------------------------------------------------------
for i = 0, 3 do
    for k = 0, 1 do
        ENT.ClientProps["door" .. i .. "x" .. k] = {
            model = "models/metrostroi_train/81-760e/81_760e_door.mdl",
            pos = Vector(229.92 * i * (k == 0 and 1 or -1), 0, 0),
            ang = Angle(0, 180 + k * 180, 0),
            hide = 2,
            callback = function(ent, cl_ent)
                local tx = ent:GetNW2String("Texture", "")
                tx = Metrostroi.Skins["train"][tx]
                tx = tx and tx.textures and tx.textures.hull or nil
                for k, v in pairs(cl_ent:GetMaterials() or {}) do
                    if v == "models/metrostroi_train/81-760/hull" then
                        cl_ent:SetSubMaterial(k - 1, tx or "models/metrostroi_train/81-760/hull_baklajan")
                    end
                end
            end,
        }
    end
end

ENT.ClientProps["zoomer_lamps"] = {
    model = "models/metrostroi_train/81-760/81_760_zoomer_lamps.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hide = 2,
}

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
                        speed = 9,
                        vmin = 1,
                        vmax = 0,
                        sndvol = 0.8,
                        snd = function(val) return val and "pak_on" or "pak_off" end,
                        sndmin = 80,
                        sndmax = 1e3 / 3,
                        sndang = Angle(-90, 0, 0),
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

--[[
local yventpos = {
    -414.5+0*117,
    -414.5+1*117+6.2,
    -414.5+2*117+5,
    -414.5+3*117+2,
    -414.5+4*117+0.5,
    -414.5+5*117-2.3,
    -414.5+6*117-2.3,
    -414.5+7*117+4,
}
for i=1,8 do
    ENT.ClientProps["vent"..i] = {
        model = "models/metrostroi_train/81-720/vent.mdl",
        pos = Vector(yventpos[i],0,57.2),
        ang = Angle(0,0,0)
    }
end]]
ENT.Lights = {}
-- Headlight glow
--[2] = { "dynamiclight",   Vector( 300, 0, 40), Angle(0,0,0), Color(255,255,255), brightness = 4, distance = 550 },
function ENT:Initialize()
    self.BaseClass.Initialize(self)
    self.Tickers = self:CreateRT("760Ticker", 2 * 1024, 2 * 64)
    self.BNTScreen = self:CreateRT("760BNT", 1024, 1024)
    render.PushRenderTarget(self.Tickers, 0, 0, 1024, 64)
    render.Clear(0, 0, 0, 0)
    render.PopRenderTarget()
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
    self.Texture = self:GetNW2String("Texture", "760A")
    self.PassTexture = self:GetNW2String("passtexture")
    self.CabinTexture = self:GetNW2String("cabtexture")
    self.Number = self:GetWagonNumber()

    local tx = Metrostroi.Skins["train"][self.Texture]
    tx = tx and tx.textures and tx.textures.hull or nil
    if tx and tx ~= "models/metrostroi_train/81-760/hull_baklajan" then
        for k, v in pairs(self:GetMaterials() or {}) do
            if v == "models/metrostroi_train/81-760/hull_baklajan" or v == "models/metrostroi_train/81-760/hull" then
                self:SetSubMaterial(k - 1, tx)
            end
        end
    end

    self.Scheme = self:GetNW2Int("Scheme", 1)
    self.InvertSchemes = self:GetNW2Bool("SarmatInvert", false)
    local sarmat, sarmatr = self.ClientEnts.PassSchemes, self.ClientEnts.PassSchemesR
    if IsValid(sarmat) and IsValid(sarmatr) and Metrostroi.Skins["760_schemes"] and Metrostroi.Skins["760_schemes"][self.Scheme] then
        local scheme = Metrostroi.Skins["760_schemes"][self.Scheme]
        --[[
        if self:GetNW2Bool("PassSchemesInvert") then
            sarmat:SetSubMaterial(0,scheme[2])
            sarmatr:SetSubMaterial(0,scheme[1])
        else
            sarmat:SetSubMaterial(0,scheme[1])
            sarmatr:SetSubMaterial(0,scheme[2])
        end]]
        sarmat:SetSubMaterial(0, scheme[1])
        sarmatr:SetSubMaterial(0, scheme[1])
    end

    self.CISConfig = self:GetNW2Int("CISConfig", 1)
    local Announcer = {}
    for k, v in pairs(Metrostroi.AnnouncementsASNP or {}) do
        if not v.riu then Announcer[k] = v.name or k end
    end

    if #Metrostroi.CISConfig == 1 then self.CISConfig = 1 end
    --[[
	for k,v in pairs(Metrostroi.CISConfig) do
		for k2,v2 in pairs(Announcer) do
			if v2 == v.name then
				self.CISConfig = k
			end
		end
	end]]
    --[[
	Metrostroi.Skins["train"][self.Texture] = {}	
	Metrostroi.Skins["train"][self.Texture].textures = {
		["hull"] = "models/metrostroi_train/81-760/hull_baklajan"
	}
	
    for k in pairs(self:GetMaterials()) do self:SetSubMaterial(k-1,"") end
	self:SetSubMaterial(0,"models/metrostroi_train/81-760/hull_baklajan") 	
	--self:SetSubMaterial(0,"models/metrostroi_train/81-760/hull_baklajan")]]
    for i = 0, 4 do
        local num = tostring(self.Number)[i + 1]
        if not num or num == "" then num = "3" end
        if IsValid(self.ClientEnts["TrainNumberL" .. i]) then
            local number = self.ClientEnts["TrainNumberL" .. i]
            number:SetPos(self:LocalToWorld(Vector(443.7 - i * 5.8, 68, -21)))
            number:SetAngles(self:LocalToWorldAngles(Angle(0, 90, 0)))
            number:SetModel("models/metrostroi_train/81-760/numbers/number_" .. num .. ".mdl")
        end

        if IsValid(self.ClientEnts["TrainNumberR" .. i]) then
            local number = self.ClientEnts["TrainNumberR" .. i]
            number:SetPos(self:LocalToWorld(Vector(-443.7 + i * 5.8, -68, -21)))
            number:SetAngles(self:LocalToWorldAngles(Angle(0, -90, 0)))
            number:SetModel("models/metrostroi_train/81-760/numbers/number_" .. num .. ".mdl")
        end
    end
end

function ENT:IsNumberError()
    local err = false
    for i = 0, 4 do
        if IsValid(self.ClientEnts["TrainNumberL" .. i]) and (self.ClientEnts["TrainNumberL" .. i]:GetPos() == self:GetPos()) then
            err = true
            break
        end

        if IsValid(self.ClientEnts["TrainNumberR" .. i]) and (self.ClientEnts["TrainNumberR" .. i]:GetPos() == self:GetPos()) then
            err = true
            break
        end
    end
    return err
end

local function PlyInTrain(ply, Train)
    local val = ply.InMetrostroiTrain == Train
    return val
end

local C_MinimizedShow = GetConVar("metrostroi_minimizedshow")
local C_Optimization = GetConVar("760_optimization")
local C_Optimization2 = GetConVar("760_optimization2")
local C_ScreenshotMode = GetConVar("metrostroi_screenshotmode")
function ENT:ShouldRenderClientEnts()
    local ply = LocalPlayer()
    local val = not self:IsDormant() and math.abs(LocalPlayer():GetPos().z - self:GetPos().z) < 500 and (system.HasFocus() or C_MinimizedShow:GetBool()) and (not Metrostroi or not Metrostroi.ReloadClientside)
    if not C_ScreenshotMode:GetBool() then
        if C_Optimization:GetBool() then
            if not PlyInTrain(ply, self) then --and not self:CPPIGetOwner() == ply then
                val = false
            end
        elseif C_Optimization2:GetBool() then
            if (CPPI and IsValid(self:CPPIGetOwner()) and self:CPPIGetOwner() ~= ply) and not PlyInTrain(ply, self) then val = false end
        end
    end
    return val
end

function ENT:Think()
    self.BaseClass.Think(self)
    if not self.RenderClientEnts or self.CreatingCSEnts then
        self.Number = 0
        return
    end

    if self.Number ~= self:GetWagonNumber() then self:UpdateTextures() end
    if self.Texture ~= self:GetNW2String("texture") then self:UpdateTextures() end
    if self.PassTexture ~= self:GetNW2String("passtexture") then self:UpdateTextures() end
    if self.CabinTexture ~= self:GetNW2String("cabtexture") then self:UpdateTextures() end
    if self.Scheme ~= self:GetNW2Int("Scheme", 1) then self:UpdateTextures() end
    if self.InvertSchemes ~= self:GetNW2Bool("PassSchemesInvert", false) then self:UpdateTextures() end
    if self:IsNumberError() then self:UpdateTextures() end
    local RearTrain, FrontTrain = self:GetNW2Entity("RearTrain"), self:GetNW2Entity("FrontTrain")
    self:ShowHide("fence", IsValid(RearTrain) and (RearTrain:GetClass():find("760") and false or (RearTrain:GetClass():find("761a") or RearTrain:GetClass():find("763a") or RearTrain:GetClass():find("761e") or RearTrain:GetClass():find("763e")) and (RearTrain:GetNW2Entity("RearTrain") == self and not IsValid(RearTrain.ClientEnts["fence"]) or RearTrain:GetNW2Entity("FrontTrain") == self and not IsValid(RearTrain.ClientEnts["fence1"])) and true))
    self:ShowHide("fence1", IsValid(FrontTrain) and (FrontTrain:GetClass():find("760") and false or (FrontTrain:GetClass():find("761a") or FrontTrain:GetClass():find("763a") or FrontTrain:GetClass():find("761e") or FrontTrain:GetClass():find("763e")) and (FrontTrain:GetNW2Entity("RearTrain") == self and not IsValid(FrontTrain.ClientEnts["fence"]) or FrontTrain:GetNW2Entity("FrontTrain") == self and not IsValid(FrontTrain.ClientEnts["fence1"])) and true))
    local fence, fence1 = self.ClientEnts["fence"], self.ClientEnts["fence1"]
    if IsValid(fence) and IsValid(RearTrain) then
        local a = 1
        if RearTrain:GetNW2Entity("RearTrain") == self then a = -1 end
        --local ang1 = RearTrain:GetAngles()
        local ang1 = fence:WorldToLocalAngles(RearTrain:LocalToWorldAngles(Angle(0, 90 * a, 0)))
        local vec = fence:WorldToLocal(RearTrain:LocalToWorld(Vector(480.1 * a, a * ang1.p * 1.585, 0.6)))
        fence:ManipulateBoneAngles(0, Angle(-ang1.r / 2, ang1.y / 2, ang1.p / 3) + Angle(0, 90, 0))
        fence:ManipulateBonePosition(0, Vector(vec.x / 2, vec.y / 2, vec.z / 2))
    end

    if IsValid(fence1) and IsValid(FrontTrain) then
        local a = 1
        if FrontTrain:GetNW2Entity("RearTrain") == self then a = -1 end
        --local ang1 = RearTrain:GetAngles()
        local ang1 = fence1:WorldToLocalAngles(FrontTrain:LocalToWorldAngles(Angle(0, 90 * a, 0)))
        local vec = fence1:WorldToLocal(FrontTrain:LocalToWorld(Vector(480.1 * a, a * ang1.p * 1.585, 0.6)))
        fence1:ManipulateBoneAngles(0, Angle(-ang1.r / 2, ang1.y / 2, ang1.p / 3) + Angle(0, 90, 0))
        fence1:ManipulateBonePosition(0, Vector(vec.x / 2, vec.y / 2, vec.z / 2))
    end

    local ValidfB, ValidrB = IsValid(self.FrontBogey), IsValid(self.RearBogey)
    for i = 1, 4 do
        self:ShowHide("TR" .. i, i <= 2 and ValidfB or i >= 3 and ValidrB)
        self:ShowHide("brake_shoe" .. i, ValidfB)
        self:ShowHide("brake_shoe" .. (i + 4), ValidrB)
        self:Animate("TR" .. i, self:GetPackedBool("TR" .. i) and 1 or 0, 0, 1, 8, 0.5)
        self:Animate("brake_shoe" .. i, self:GetPackedBool("BC" .. i) and 1 or 0, 1, 0.722, 32, 2)
        self:Animate("brake_shoe" .. (i + 4), self:GetPackedBool("BC" .. (i + 4)) and 1 or 0, 1, 0.722, 32, 2)
    end

    local speed = self:GetPackedRatio("Speed", 0)
    self:Animate("volt_lv", self:GetPackedRatio("LV"), 0, 1, 16, 1) --0.035,0.965,16,1)
    self:Animate("volt_hv", self:GetPackedRatio("HV"), 0, 1, 16, 6) --0.035,0.965,16,1)	
    --self:Animate("ampermetr",self:GetPackedRatio("IVO"),0,1,16,1)--0.035,0.965,16,1)	
    self:Animate("brake_line", self:GetPackedRatio("BL"), 0, 0.78, 256, 2)
    self:Animate("train_line", self:GetPackedRatio("TL"), 0, 0.78, 256, 2)
    self:Animate("brake_cylinder", self:GetPackedRatio("BC"), 0, 0.78, 256, 2)
    --self:Animate("trihedral", (self:GetPackedBool("WorkBeep") and 1 or 0), 0,1,64,2)
    local box_door_l = self:Animate("box_door_l", self:GetPackedBool("CouchCapL") and 1 or 0, 0, 1, 2, 2)
    local box_door_r = self:Animate("box_door_r", self:GetPackedBool("CouchCapR") and 1 or 0, 0, 1, 2, 2)
    self:HidePanel("couch_capL", box_door_l > 0)
    self:HidePanel("couch_capR", box_door_r > 0)
    self:HidePanel("couch_capL_o", box_door_l < 1)
    self:HidePanel("couch_capR_o", box_door_r < 1)
    self:HidePanel("PVZ", box_door_l == 0)
    self:HidePanel("boxR", box_door_r == 0)
    self:ShowHide("box_int_l", box_door_l > 0)
    self:ShowHide("box_add", box_door_l > 0)
    self:ShowHide("box_int_r", box_door_r > 0)
    self:ShowHide("volt_hv", box_door_r > 0)
    self:ShowHide("brake_cylinder", box_door_r > 0)
    self:ShowHide("train_line", box_door_r > 0)
    self:ShowHide("brake_line", box_door_r > 0)
    self:ShowHide("volt_lv", box_door_l > 0)
    --self:ShowHide("ampermetr",box_door_l>0)
    self:ShowHide("stopkran", box_door_r > 0)
    self:HidePanel("Power", box_door_l == 0)
    self:Animate("FrontBrake", self:GetNW2Bool("FbI") and 0 or 1, 0, 1, 3, false)
    self:Animate("FrontTrain", self:GetNW2Bool("FtI") and 0 or 1, 0, 1, 3, false)
    self:Animate("RearBrake", self:GetNW2Bool("RbI") and 0 or 1, 0, 1, 3, false)
    self:Animate("RearTrain", self:GetNW2Bool("RtI") and 0 or 1, 0, 1, 3, false)
    self:Animate("K23Valve", self:GetNW2Bool("K23") and 0 or 1, 0, 1, 3, false)
    self:Animate("stopkran", self:GetPackedBool("EmergencyBrakeValve") and 1 or 0.5, 0, 1, 3, false)
    local dT = self.DeltaTime
    local dPdT = self:GetPackedRatio("BrakeCylinderPressure_dPdT")
    self.ReleasedPdT = math.Clamp(self.ReleasedPdT + 10 * (-self:GetPackedRatio("BrakeCylinderPressure_dPdT", 0) - self.ReleasedPdT) * dT * 1.5, 0, 1)
    local release1 = math.Clamp(self.ReleasedPdT, 0, 1) ^ 2
    self:SetSoundState("release", release1, 1)
    self:ShowHideSmooth("lamp1", self:Animate("LampsEmer", self:GetPackedBool("SalonLighting1") and 1 or 0, 0, 1, 5, false))
    self:ShowHideSmooth("lamp2", self:Animate("LampsFull", self:GetPackedBool("SalonLighting2") and 1 or 0, 0, 1, 5, false))
    self:ShowHideSmooth("zoomer_lamps", self:Animate("zoomerl", self:GetNW2Bool("DoorAlarmState") and 1 or 0, 0, 1, 16, false))
    local K31_cap = self:Animate("K31_cap", self:GetPackedBool("door_k31") and 1 or 0, 0, 1, 4, 0.5)
    self:ShowHide("K31", K31_cap > 0)
    self:HidePanel("K31", K31_cap < 1)
    self:Animate("K31", self:GetPackedBool("K31") and 0 or 1, 0, 1, 16, 0.5)
    local led_back = not self:GetPackedBool("PassSchemesLEDO", false)
    --if self:GetPackedBool("PassSchemesInvert",false)  then led_back = not led_back end
    --if self.InvertSchemes then led_back = not led_back end
    local extraled = self:GetPackedBool("BMCISExtra", false)
    local extradir = self:GetPackedBool("BMCISExtraDir", false)
    for i = 1, 5 do
        self:ShowHide("led_l_f" .. i, not led_back)
        self:ShowHide("led_l_b" .. i, led_back)
        self:ShowHide("led_r_f" .. i, not led_back)
        self:ShowHide("led_r_b" .. i, led_back)
    end

    local scurr = self:GetNW2Int("PassSchemesLED")
    local snext = self:GetNW2Int("PassSchemesLEDN")
    local led = scurr
    if snext ~= 0 and CurTime() % 2 > 1 then led = led + snext end
    local ledwork = scurr >= 0 and self:GetPackedBool("PassSchemes")
    if led_back then
        for i = 1, 5 do
            if IsValid(self.ClientEnts["led_l_b" .. i]) then
                local skin = 0
                if (ledwork and self:GetPackedBool("PassSchemesL", false)) and extraled then
                    local num = extradir and 1 + math.floor(CurTime() % 0.8 * 10) or math.floor(CurTime() % 0.9 * 10) --(math.floor(CurTime()%0.9*10))
                    local tbl
                    if not extradir then
                        tbl = {num, num + 8, num + 16, num + 24}
                    else
                        tbl = {31 - num, 23 - num, 15 - num, 7 - num}
                    end

                    local min, max = (i - 1) * 6 + 1, i * 6
                    for k, v in pairs(tbl) do
                        if v >= min and v <= max then skin = v == min and 1 or v - min + 6 end
                    end
                elseif ledwork and self:GetPackedBool("PassSchemesL", false) then
                    skin = math.Clamp(led - ((i - 1) * 6), 0, 6)
                end

                self.ClientEnts["led_l_b" .. i]:SetSkin(skin)
            end

            if IsValid(self.ClientEnts["led_r_b" .. i]) then
                local skin = 0
                if (ledwork and self:GetPackedBool("PassSchemesR", false)) and extraled then
                    local num = extradir and 1 + math.floor(CurTime() % 0.8 * 10) or math.floor(CurTime() % 0.9 * 10) --(math.floor(CurTime()%0.9*10))
                    local tbl
                    if not extradir then
                        tbl = {num, num + 8, num + 16, num + 24}
                    else
                        tbl = {31 - num, 23 - num, 15 - num, 7 - num}
                    end

                    local min, max = (i - 1) * 6 + 1, i * 6
                    for k, v in pairs(tbl) do
                        if v >= min and v <= max then skin = v == min and 1 or v - min + 6 end
                    end
                elseif ledwork and self:GetPackedBool("PassSchemesR", false) then
                    skin = math.Clamp(led - ((i - 1) * 6), 0, 6)
                end

                self.ClientEnts["led_r_b" .. i]:SetSkin(skin)
            end
        end
    else
        for i = 1, 5 do
            if IsValid(self.ClientEnts["led_l_f" .. i]) then
                local skin = 0
                if (ledwork and self:GetPackedBool("PassSchemesL", false)) and extraled then
                    local num = not extradir and 1 + math.floor(CurTime() % 0.8 * 10) or math.floor(CurTime() % 0.9 * 10) --(math.floor(CurTime()%0.9*10))
                    local tbl
                    if extradir then
                        tbl = {num, num + 8, num + 16, num + 24}
                    else
                        tbl = {31 - num, 23 - num, 15 - num, 7 - num}
                    end

                    local min, max = (i - 1) * 6 + 1, i * 6
                    for k, v in pairs(tbl) do
                        if v >= min and v <= max then skin = v == min and 1 or v - min + 6 end
                    end
                elseif ledwork and self:GetPackedBool("PassSchemesL", false) then
                    skin = math.Clamp(led - ((i - 1) * 6), 0, 6)
                end

                self.ClientEnts["led_l_f" .. i]:SetSkin(skin)
            end

            if IsValid(self.ClientEnts["led_r_f" .. i]) then
                local skin = 0
                if (ledwork and self:GetPackedBool("PassSchemesR", false)) and extraled then
                    local num = not extradir and 1 + math.floor(CurTime() % 0.8 * 10) or math.floor(CurTime() % 0.9 * 10) --(math.floor(CurTime()%0.9*10))
                    local tbl
                    if extradir then
                        tbl = {num, num + 8, num + 16, num + 24}
                    else
                        tbl = {31 - num, 23 - num, 15 - num, 7 - num}
                    end

                    local min, max = (i - 1) * 6 + 1, i * 6
                    for k, v in pairs(tbl) do
                        if v >= min and v <= max then skin = v == min and 1 or v - min + 6 end
                    end
                elseif ledwork and self:GetPackedBool("PassSchemesR", false) then
                    skin = math.Clamp(led - ((i - 1) * 6), 0, 6)
                end

                self.ClientEnts["led_r_f" .. i]:SetSkin(skin)
            end
        end
    end

    if not self.DoorStates then self.DoorStates = {} end
    if not self.DoorLoopStates then self.DoorLoopStates = {} end
    for i = 0, 3 do
        for k = 0, 1 do
            local st = k == 1 and "DoorL" or "DoorR"
            local doorstate = self:GetPackedBool(st)
            local id, sid = st .. (i + 1), "door" .. i .. "x" .. k
            local state = self:GetPackedRatio(id)

            local randvalKey = "Door" .. (k == 1 and "L" or "R") .. "BR" .. (i + 1)
            if not self[randvalKey] then self[randvalKey] = math.random(0, 1) end
            local randval = self[randvalKey]
            --print(state,self.DoorStates[state])
            if (state ~= 1 and state ~= 0) ~= self.DoorStates[id] then
                if doorstate and state < 1 or not doorstate and state > 0 then
                    if doorstate then --math.Rand(0.9,1.3))
                        self:PlayOnce(sid .. "op" .. randval, "", 1, 1)
                    end
                else
                    if state > 0 then
                        self:PlayOnce(sid .. "o" .. randval, "", 1, 1) --math.Rand(0.9,1.3))
                    else
                        self:PlayOnce(sid .. "c" .. randval, "", 1, 1) --math.Rand(0.9,1.3))
                    end
                    self[randvalKey] = math.random(0, 1)
                end

                if state > 0 and doorstate then end
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
        self:HidePanel("DoorAddressOpen" .. idx, open and self:GetNW2Bool("AddressDoors", true))
        self:HidePanel("DoorAddressOpenOutside" .. idx, open and self:GetNW2Bool("AddressDoors", true))
        local btnKey = "DoorArrdessButton" .. idx
        self:ShowHide(btnKey, self:GetNW2Bool("AddressDoors", true))
        local btn = self.ClientEnts[btnKey]
        if IsValid(btn) then
            btn:SetSubMaterial(1, self:GetNW2Bool("DoorButtonLed" .. (idx < 5 and 9 - idx or idx - 4), false) and "models/metrostroi_train/81-765/led_green" or "models/metrostroi_train/81-765/led_off")
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
    local dPdT = self:GetPackedRatio("BrakeCylinderPressure_dPdT")
    self.ReleasedPdT = math.Clamp(self.ReleasedPdT + 10 * (-self:GetPackedRatio("BrakeCylinderPressure_dPdT", 0) - self.ReleasedPdT) * dT * 1.5, 0, 1)
    local release1 = math.Clamp(self.ReleasedPdT, 0, 1) ^ 2
    self:SetSoundState("release", release1, 1)
    --[[
    local state = self:GetPackedBool("CompressorWork")
    if self.CompressorVol < 1 and state then
        self.CompressorVol = math.min(1,self.CompressorVol + 5*dT)
    elseif self.CompressorVol > 0 and not state then
        self.CompressorVol = math.max(0,self.CompressorVol - 3*dT)
    end]]
    --if state then
    --self:SetSoundState("compressor",self.CompressorVol,0.8+0.2*self.CompressorVol)
    --else
    --self:SetSoundState("compressor",0,0)
    --end
    --self.PreviousCompressorState = state
    local speed = self:GetPackedRatio("Speed", 0)
    --[[
    local ventSpeedAdd = math.Clamp(speed/30,0,1)

    local v1state = self:GetPackedBool("Vent1Work")
    local v2state = self:GetPackedBool("Vent2Work")
    for i=1,8 do
        local rand = self.VentRand[i]
        local vol = self.VentVol[i]
        local even = i%2 == 0
        local work = (even and v1state or not even and v2state)
        local target = math.min(1,(work and 1 or 0)+ventSpeedAdd*rand*0.4)*2
        if self.VentVol[i] < target then
            self.VentVol[i] = math.min(target,vol + dT/1.5*rand)
        elseif self.VentVol[i] > target then
            self.VentVol[i] = math.max(0,vol - dT/8*rand*(vol*0.3))
        end
        self.VentState[i] = (self.VentState[i] + 10*((self.VentVol[i]/2)^3)*dT)%1
        local vol1 = math.max(0,self.VentVol[i]-1)
        local vol2 = math.max(0,(self.VentVol[i-1] or self.VentVol[i+1])-1)
        self:SetSoundState("vent"..i,vol1*(0.7+vol2*0.3),0.5+0.5*vol1+math.Rand(-0.01,0.01))
        if IsValid(self.ClientEnts["vent"..i]) then
            self.ClientEnts["vent"..i]:SetPoseParameter("position",self.VentState[i])
        end
    end]]
    local rollingi = math.min(1, self.TunnelCoeff + math.Clamp((self.StreetCoeff - 0.82) / 0.5, 0, 1))
    local rollings = math.max(self.TunnelCoeff * 0.6, self.StreetCoeff)
    local tunstreet = rollingi + rollings * 0.2
    local speed = self:GetPackedRatio("Speed", 0)
    local rol10 = math.Clamp(speed / 25, 0, 1) * (1 - math.Clamp((speed - 25) / 8, 0, 1))
    local rol45 = math.Clamp((speed - 23) / 8, 0, 1) * (1 - math.Clamp((speed - 50) / 8, 0, 1))
    local rol45p = Lerp((speed - 25) / 25, 0.8, 1)
    local rol60 = math.Clamp((speed - 50) / 8, 0, 1) * (1 - math.Clamp((speed - 65) / 5, 0, 1))
    local rol60p = Lerp((speed - 50) / 15, 0.8, 1)
    local rol70 = math.Clamp((speed - 65) / 5, 0, 1)
    local rol70p = Lerp((speed - 65) / 25, 0.8, 1.2)
    self:SetSoundState("rolling_10", rollingi * rol10, 1)
    self:SetSoundState("rolling_45", rollingi * rol45, 1)
    self:SetSoundState("rolling_60", rollingi * rol60, 1)
    self:SetSoundState("rolling_70", rollingi * rol70, 1)
    local rol10 = math.Clamp(speed / 15, 0, 1) * (1 - math.Clamp((speed - 18) / 35, 0, 1))
    local rol10p = Lerp((speed - 15) / 14, 0.6, 0.78)
    local rol40 = math.Clamp((speed - 18) / 35, 0, 1) * (1 - math.Clamp((speed - 55) / 40, 0, 1))
    local rol40p = Lerp((speed - 15) / 66, 0.6, 1.3)
    local rol70 = math.Clamp((speed - 55) / 20, 0, 1) --*(1-math.Clamp((speed-72)/5,0,1))
    local rol70p = Lerp((speed - 55) / 27, 0.78, 1.15)
    --local rol80 = math.Clamp((speed-70)/5,0,1)
    --local rol80p = Lerp(0.8+(speed-72)/15*0.2,0.8,1.2)
    self:SetSoundState("rolling_low", rol10 * rollings, rol10p) --15
    self:SetSoundState("rolling_medium2", rol40 * rollings, rol40p) --57
    --self:SetSoundState("rolling_medium1",0 or rol40*rollings,rol40p) --57
    self:SetSoundState("rolling_high2", rol70 * rollings, rol70p) --70
    --local state = (RealTime()%4/3)^1.5
    --local strength = 1--self:GetPackedRatio("asyncstate")*(1-math.Clamp((speed-15)/15,0,1))
    --self:SetSoundState("chopper", tunstreet*self:GetPackedRatio("chopper"), 1)
    --[[
    local state = 1-self:GetPackedRatio("RNState")
    self.TISUVol = math.Clamp(self.TISUVol+(state-self.TISUVol)*dT*8,0,1)
    self:SetSoundState("tisu", self.TISUVol, 1)
    self:SetSoundState("tisu2", 0 or self.TISUVol, 1)
    self:SetSoundState("tisu3", 0 or self.TISUVol, 1)
	]]
    --self:SetSoundState("bbe", self:GetPackedBool("BBEWork") and 1 or 0, 1)
    local work = self:GetPackedBool("AnnPlay")
    for k, v in ipairs(self.AnnouncerPositions) do
        if self.Sounds["announcer" .. k] and IsValid(self.Sounds["announcer" .. k]) then self.Sounds["announcer" .. k]:SetVolume(work and (v[3] or 1) or 0) end
    end
end

function ENT:Draw()
    self.BaseClass.Draw(self)
end

function ENT:DrawPost(special)
    self.RTMaterial:SetTexture("$basetexture", self.Tickers)
    for i = 1, 2 do
        self:DrawOnPanel("Tickers" .. i, function(...)
            surface.SetMaterial(self.RTMaterial)
            surface.SetDrawColor(255, 255, 255)
            surface.DrawTexturedRectRotated(512 * 2, 32 * 2, 2 * 1024, 64 * 2, 0)
        end)
    end

    self.RTMaterial:SetTexture("$basetexture", self.BNTScreen)
    for i = 1, 8 do
        self:DrawOnPanel("BNT" .. i, function(...)
            if not self:GetPackedBool("PassSchemesL", false) and i <= 4 or i > 4 and not self:GetPackedBool("PassSchemesR", false) then return end
            if self:GetNW2Bool("BMCISExtra", false) then
                local dir = self:GetNW2Bool("BMCISExtraDir", false)
                if i > 4 and dir or not dir and i <= 4 then
                    if dir then
                        surface.SetTexture(surface.GetTextureID("bnt/bnt_evac_forward_l"))
                    else
                        surface.SetTexture(surface.GetTextureID("bnt/bnt_evac_back_l"))
                    end
                elseif i > 4 and not dir or dir and i <= 4 then
                    if dir then
                        surface.SetTexture(surface.GetTextureID("bnt/bnt_evac_forward_r"))
                    else
                        surface.SetTexture(surface.GetTextureID("bnt/bnt_evac_back_r"))
                    end
                end

                surface.SetDrawColor(255, 255, 255, 170)
                surface.DrawTexturedRectRotated(512, 512, 1024, 1024, 0)
            else
                surface.SetMaterial(self.RTMaterial)
                surface.SetDrawColor(255, 255, 255, 170)
                surface.DrawTexturedRectRotated(512, 512, 1024, 1024, 0)
            end
        end)
    end
end

function ENT:OnButtonPressed(button)
    if button == "ShowHelp" then RunConsoleCommand("metrostroi_train_manual") end
end

local dist = {}
for id, panel in pairs(ENT.ButtonMap) do
    if not panel.buttons then continue end
    for k, v in pairs(panel.buttons) do
        if v.model then
            local dist = dist[id] or 150
            if v.model.model then
                v.model.hideseat = dist
            elseif v.model.lamp then
                v.model.lamp.hideseat = dist
            end
        end
    end
end

Metrostroi.GenerateClientProps()