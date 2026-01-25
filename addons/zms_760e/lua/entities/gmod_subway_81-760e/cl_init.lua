include("shared.lua")
--------------------------------------------------------------------------------
ENT.ClientProps = {}
ENT.ButtonMap = {}
ENT.AutoAnims = {}
ENT.ClientSounds = {}
--------------------------------------------------------------------------------
ENT.ClientPropsInitialized = false

DEFINE_BASECLASS("gmod_subway_base")

local function _fncCoord(gridLength, panelLength, gap, totalMargin, marginStart)
    local buttonLength = (panelLength - gap * (gridLength - 1) - (totalMargin or 0)) / gridLength
    return function(idx, margin)
        return (buttonLength + gap) * idx + (margin or 0) + (marginStart or 0)
    end, function(idx, margin)
        return (buttonLength + gap) * idx + (margin or 0) + (marginStart or 0) + buttonLength / 2
    end, buttonLength, buttonLength / 2
end
local function _fncCoordFixed(gridLength, panelLength, buttonLength, totalMargin, marginStart)
    local gap = (panelLength - buttonLength * gridLength - (totalMargin or 0)) / (gridLength - 1)
    return function(idx, margin)
        return (buttonLength + gap) * idx + (margin or 0) + (marginStart or 0)
    end, function(idx, margin)
        return (buttonLength + gap) * idx + (margin or 0) + (marginStart or 0) + buttonLength / 2
    end, buttonLength, buttonLength / 2
end
local _getX, _getY, _bw, _bh


_, _getX, _, _bw = _fncCoord(12, 425.8, 8)
_, _getY = _fncCoord(2, 64, 20)
ENT.ButtonMap["PUU"] = {
    pos = Vector(490.9, 31.4, -8.95),
    ang = Angle(0, -90, 70.431),
    width = 425.8,
    height = 64,
    scale = 0.05,
    hideseat = 0.2,
    buttons = {
        {
            ID = "!DoorsClosed",
            x = _getX(0),
            y = _getY(0),
            radius = _bw,
            tooltip = "Двери закрыты",
            model = {
                model = "models/metrostroi_train/81-760/81_760_rect_button_green.mdl",
                z = 0,
                ang = Angle(0, -62, 90),
                lamp = {
                    model = "models/metrostroi_train/81-760/81_760_lamp_rect_green.mdl",
                    var = "DoorsClosed",
                    anim = true,
                    ang = Angle(62, 0, 0),
                    z = 0.5
                },
            }
        },
        {
            ID = "!HVoltage",
            x = _getX(1),
            y = _getY(0),
            radius = _bw,
            tooltip = "Сеть контактная",
            model = {
                model = "models/metrostroi_train/81-760/81_760_rect_button_green.mdl",
                z = 0,
                ang = Angle(0, -62, 90),
                lamp = {
                    model = "models/metrostroi_train/81-760/81_760_lamp_rect_green.mdl",
                    var = "HVoltage",
                    anim = true,
                    ang = Angle(62, 0, 0),
                    z = 0.5
                },
            }
        },
        {
            ID = "!UnusedBlack1",
            x = _getX(2),
            y = _getY(0),
            radius = _bw,
            tooltip = "",
            model = {
                model = "models/metrostroi_train/81-760/81_760_rect_button_black.mdl",
                z = -0.5,
                ang = Angle(0, -62, 90),
            }
        },
        {
            ID = "!UnusedBlack2",
            x = _getX(3),
            y = _getY(0),
            radius = _bw,
            tooltip = "",
            model = {
                model = "models/metrostroi_train/81-760/81_760_rect_button_black.mdl",
                z = -0.5,
                ang = Angle(0, -62, 90),
            }
        },
        {
            ID = "!UnusedBlack3",
            x = _getX(4),
            y = _getY(0),
            radius = _bw,
            tooltip = "",
            model = {
                model = "models/metrostroi_train/81-760/81_760_rect_button_black.mdl",
                z = -0.5,
                ang = Angle(0, -62, 90),
            }
        },
        {
            ID = "!UnusedBlack4",
            x = _getX(5),
            y = _getY(0),
            radius = _bw,
            tooltip = "",
            model = {
                model = "models/metrostroi_train/81-760/81_760_rect_button_black.mdl",
                z = -0.5,
                ang = Angle(0, -62, 90),
            }
        },
        {
            ID = "ALSkToggle",
            x = _getX(6) - _bw * 4 - 6,
            y = _getY(0) - 10,
            w = 40,
            h = 20,
            tooltip = "Крышка кнопки АЛС\nALS button cover",
            model = {
                model = "models/metrostroi_train/81-760/81_760_plomb_als.mdl",
                ang = Angle(0, -62, 90),
                x = 1,
                y = -0.45,
                z = 1,
                var = "ALSk", --disable="KAHToggle",
                speed = 8,
                min = 1,
                max = 0,
                disable = "ALSToggle",
                plomb = {
                    model = "models/metrostroi_train/81/plomb.mdl",
                    ang = 90,
                    x = 52,
                    y = -18,
                    z = -6,
                    var = "ALSPl",
                    ID = "ALSPl",
                },
                sndvol = 1,
                snd = function(val) return val and "kr_close" or "kr_open" end,
                sndmin = 90,
                sndmax = 1e3,
                sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "ALSToggle",
            x = _getX(6),
            y = _getY(0),
            radius = _bw,
            tooltip = "АЛС",
            model = {
                model = "models/metrostroi_train/81-760/81_760_rect_button_green.mdl",
                z = 0.5,
                ang = Angle(0, -62, 90),
                lamp = {
                    model = "models/metrostroi_train/81-760/81_760_lamp_rect_green.mdl",
                    var = "ALSLamp",
                    anim = true,
                    ang = Angle(62, 0, 0),
                    z = 0.5
                },
                var = "ALS",
                speed = 12,
                vmin = 0,
                vmax = 1,
                sndvol = 0.3,
                snd = function(val) return val and "button_square_on" or "button_square_off" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "KAHToggle",
            x = _getX(7),
            y = _getY(0),
            radius = _bw,
            tooltip = "КАХ",
            model = {
                model = "models/metrostroi_train/81-760/81_760_rect_button_green.mdl",
                z = 0.5,
                ang = Angle(0, -62, 90),
                lamp = {
                    model = "models/metrostroi_train/81-760/81_760_lamp_rect_green.mdl",
                    var = "KAHLamp",
                    anim = true,
                    ang = Angle(62, 0, 0),
                    z = 0.5
                },
                var = "KAH",
                speed = 12,
                vmin = 0,
                vmax = 1,
                sndvol = 0.3,
                snd = function(val) return val and "button_square_on" or "button_square_off" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "AutoDriveToggle",
            x = _getX(8),
            y = _getY(0),
            radius = _bw,
            tooltip = "Автоведение (не заведено)",
            model = {
                model = "models/metrostroi_train/81-760/81_760_rect_button_green.mdl",
                z = 0.5,
                ang = Angle(0, -62, 90),
                var = "AutoDrive",
                speed = 12,
                vmin = 0,
                vmax = 1,
                sndvol = 0.3,
                snd = function(val) return val and "button_square_press" or "button_square_release" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "PrToggle",
            x = _getX(9),
            y = _getY(0),
            radius = _bw,
            tooltip = "Прогрев колодок",
            model = {
                model = "models/metrostroi_train/81-760/81_760_rect_button_green.mdl",
                z = 0.5,
                ang = Angle(0, -62, 90),
                lamp = {
                    model = "models/metrostroi_train/81-760/81_760_lamp_rect_green.mdl",
                    var = "PrLamp",
                    anim = true,
                    ang = Angle(62, 0, 0),
                    z = 0.5
                },
                var = "Pr",
                speed = 12,
                vmin = 0,
                vmax = 1,
                sndvol = 0.3,
                snd = function(val) return val and "button_square_press" or "button_square_release" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "AccelRateSet",
            x = _getX(10),
            y = _getY(0),
            radius = _bw,
            tooltip = "Подъём",
            model = {
                model = "models/metrostroi_train/81-760/81_760_rect_button_yellow.mdl",
                z = -0.5,
                ang = Angle(0, -62, 90),
                var = "AccelRate",
                speed = 12,
                vmin = 0,
                vmax = 1,
                sndvol = 0.3,
                snd = function(val) return val and "button_square_press" or "button_square_release" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "RingSet",
            x = _getX(11),
            y = _getY(0),
            radius = _bw,
            tooltip = "Передача управления(звонок)",
            model = {
                model = "models/metrostroi_train/81-760/81_760_rect_button_black.mdl",
                z = -0.5,
                ang = Angle(0, -62, 90),
                var = "Ring",
                speed = 12,
                vmin = 0,
                vmax = 1,
                sndvol = 0.3,
                snd = function(val) return val and "button_square_press" or "button_square_release" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "!UnusedAux1",
            x = _getX(0),
            y = _getY(1),
            radius = _bw,
            tooltip = "",
            model = {
                model = "models/metrostroi_train/81-760/81_760_rect_button_black.mdl",
                z = -0.5,
                ang = Angle(0, -62, 90),
            }
        },
        {
            ID = "SCToggle",
            x = _getX(1),
            y = _getY(1),
            radius = _bw,
            tooltip = "Связь с СЦ",
            model = {
                model = "models/metrostroi_train/81-760/81_760_rect_button_orange.mdl",
                z = -0.5,
                ang = Angle(0, -62, 90),
                --lamp = {model = "models/metrostroi_train/81-760/81_760_lamp_rect_orange.mdl",var="SCLamp",anim=true,ang=Angle(0,-62,90),z=1},
                var = "SC",
                speed = 12,
                vmin = 0,
                vmax = 1,
                sndvol = 0.3,
                snd = function(val) return val and "button_square_press" or "button_square_release" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "!UnusedAux2",
            x = _getX(2),
            y = _getY(1),
            radius = _bw,
            tooltip = "",
            model = {
                model = "models/metrostroi_train/81-760/81_760_rect_button_red.mdl",
                z = -0.5,
                ang = Angle(0, -62, 90),
            }
        },
        {
            ID = "!UnusedAux3",
            x = _getX(3),
            y = _getY(1),
            radius = _bw,
            tooltip = "",
            model = {
                model = "models/metrostroi_train/81-760/81_760_rect_button_yellow.mdl",
                z = -0.5,
                ang = Angle(0, -62, 90),
            }
        },
        {
            ID = "!UnusedAux4",
            x = _getX(4),
            y = _getY(1),
            radius = _bw,
            tooltip = "",
            model = {
                model = "models/metrostroi_train/81-760/81_760_rect_button_black.mdl",
                z = -0.5,
                ang = Angle(0, -62, 90),
            }
        },
        {
            ID = "DisableBVSet",
            x = _getX(5),
            y = _getY(1),
            radius = _bw,
            tooltip = "Отключение БВ",
            model = {
                model = "models/metrostroi_train/81-760/81_760_rect_button_red.mdl",
                z = -0.5,
                ang = Angle(0, -62, 90),
                var = "DisableBV",
                speed = 12,
                vmin = 0,
                vmax = 1,
                sndvol = 0.3,
                snd = function(val) return val and "button_square_press" or "button_square_release" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "OtklRToggle",
            x = _getX(6),
            y = _getY(1),
            radius = _bw,
            tooltip = "Откл рекуперации",
            model = {
                model = "models/metrostroi_train/81-760/81_760_rect_button_green.mdl",
                z = 0.5,
                ang = Angle(0, -62, 90),
                lamp = {
                    model = "models/metrostroi_train/81-760/81_760_lamp_rect_green.mdl",
                    var = "OtklRLamp",
                    anim = true,
                    ang = Angle(62, 0, 0),
                    z = 0.5
                },
                var = "OtklR",
                speed = 12,
                vmin = 0,
                vmax = 1,
                sndvol = 0.3,
                snd = function(val) return val and "button_square_press" or "button_square_release" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "DoorBlockToggle",
            x = _getX(7),
            y = _getY(1),
            radius = _bw,
            tooltip = "Блокировка дверей",
            model = {
                model = "models/metrostroi_train/81-760/81_760_rect_button_red.mdl",
                z = -0.5,
                ang = Angle(0, -62, 90),
                lamp = {
                    model = "models/metrostroi_train/81-760/81_760_lamp_rect_red.mdl",
                    var = "DoorBlockLamp",
                    anim = true,
                    ang = Angle(62, 0, 0),
                    z = 0.5
                },
                var = "DoorBlock",
                speed = 12,
                vmin = 0,
                vmax = 1,
                sndvol = 0.3,
                snd = function(val) return val and "button_square_on" or "button_square_off" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "EnableBVSet",
            x = _getX(8),
            y = _getY(1),
            radius = _bw,
            tooltip = "Включение защиты",
            model = {
                model = "models/metrostroi_train/81-760/81_760_rect_button_green.mdl",
                ang = Angle(0, -62, 90),
                var = "EnableBV",
                speed = 12,
                vmin = 0,
                vmax = 1,
                sndvol = 0.3,
                snd = function(val) return val and "button_square_press" or "button_square_release" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "GlassHeatingToggle",
            x = _getX(9),
            y = _getY(1),
            radius = _bw,
            tooltip = "Обогрев стекла",
            model = {
                model = "models/metrostroi_train/81-760/81_760_rect_button_green.mdl",
                z = 0.5,
                ang = Angle(0, -62, 90),
                var = "GlassHeating",
                speed = 12,
                vmin = 0,
                vmax = 1,
                lamp = {
                    model = "models/metrostroi_train/81-760/81_760_lamp_rect_green.mdl",
                    var = "GlassHeatingLamp",
                    anim = true,
                    ang = Angle(62, 0, 0),
                    z = 0.5
                },
                sndvol = 0.3,
                snd = function(val) return val and "button_square_press" or "button_square_release" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "WasherSet",
            x = _getX(10),
            y = _getY(1),
            radius = _bw,
            tooltip = "Омыватель",
            model = {
                model = "models/metrostroi_train/81-760/81_760_rect_button_blue.mdl",
                z = -0.5,
                ang = Angle(0, -62, 90),
                lamp = {
                    model = "models/metrostroi_train/81-760/81_760_lamp_rect_blue.mdl",
                    var = "WasherLamp",
                    anim = true,
                    ang = Angle(62, 0, 0),
                    z = 0.5
                },
                var = "Washer",
                speed = 12,
                vmin = 0,
                vmax = 1,
                ang = 180,
                sndvol = 0.5,
                snd = function(val) return val and "button_square_press" or "button_square_release" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "WiperToggle",
            x = _getX(11),
            y = _getY(1),
            radius = _bw,
            tooltip = "Стекло-очиститель",
            model = {
                model = "models/metrostroi_train/81-760/81_760_rect_button_blue.mdl",
                z = -0.5,
                ang = Angle(0, -62, 90),
                lamp = {
                    model = "models/metrostroi_train/81-760/81_760_lamp_rect_blue.mdl",
                    var = "WiperLamp",
                    anim = true,
                    ang = Angle(62, 0, 0),
                    z = 0.5
                },
                var = "Wiper",
                speed = 12,
                vmin = 0,
                vmax = 1,
                ang = 180,
                sndvol = 0.5,
                snd = function(val) return val and "button_square_press" or "button_square_release" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
        --[[
        {
            ID = "R_ToBackSet",
            x = 607,
            y = 23,
            radius = 15,
            tooltip = "Установка в начало",
            model = {
                model = "models/metrostroi_train/81-760/81_760_rect_button_yellow.mdl",
                z = -0.5,
                ang = Angle(0, -62, 90),
                var = "R_ToBack",
                speed = 12,
                vmin = 0,
                vmax = 1,
                sndvol = 0.3,
                snd = function(val) return val and "button_square_press" or "button_square_release" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "R_ChangeRouteToggle",
            x = 631,
            y = 23,
            radius = 15,
            tooltip = "Выбор маршрута",
            model = {
                model = "models/metrostroi_train/81-760/81_760_rect_button_yellow.mdl",
                z = -0.5,
                ang = Angle(0, -62, 90),
                lamp = {
                    model = "models/metrostroi_train/81-760/81_760_lamp_rect_yellow.mdl",
                    var = "R_ChangeRouteLamp",
                    anim = true,
                    ang = Angle(62, 0, 0),
                    z = 0.5
                },
                var = "R_ChangeRoute",
                speed = 12,
                vmin = 0,
                vmax = 1,
                sndvol = 0.3,
                snd = function(val) return val and "button_square_press" or "button_square_release" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },]]
        -- {
        --     ID = "R_LineToggle",
        --     x = 655.4,
        --     y = 23,
        --     radius = 15,
        --     tooltip = "Линия",
        --     model = {
        --         model = "models/metrostroi_train/81-760/81_760_rect_button_yellow.mdl",
        --         z = -0.5,
        --         ang = Angle(0, -62, 90),
        --         lamp = {
        --             model = "models/metrostroi_train/81-760/81_760_lamp_rect_yellow.mdl",
        --             var = "R_LineLamp",
        --             anim = true,
        --             ang = Angle(62, 0, 0),
        --             z = 0.5
        --         },
        --         var = "R_Line",
        --         speed = 12,
        --         vmin = 0,
        --         vmax = 1,
        --         sndvol = 0.3,
        --         snd = function(val) return val and "button_square_on" or "button_square_off" end,
        --         sndmin = 80,
        --         sndmax = 1e3 / 3,
        --         sndang = Angle(-90, 0, 0),
        --     }
        -- },
    }
}

--[[
        {ID = "EnableBVEmerSet",x=42, y=110, radius=15, tooltip = "Возврат БВ резервный",model = {
            model = "models/metrostroi_train/81-720/button_circle2.mdl",z=3,
            var="EnableBVEmer",speed=12, vmin=0, vmax=0.9,
            sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }},]]
--[[
ENT.ButtonMap["PUL"] = {
    pos = Vector(473,36,-26.6+1.6), --446 -- 14 -- -0,5
    ang = Angle(0,-90,21.5),
    width = 100,
    height = 280,
    scale = 0.0625,

    buttons = {



    }
}]]
_, _getX, _, _bw = _fncCoord(6, 261.2, 10)
_, _getY = _fncCoordFixed(3, 167.2, _bw * 2)
ENT.ButtonMap["PUR"] = {
    pos = Vector(486.6, 15.48, -13.2),
    ang = Angle(0, -90, 0),
    width = 261.2,
    height = 167.2,
    scale = 0.05,
    hideseat = 0.2,
    buttons = {
        {
            ID = "DoorSelectLToggle",
            x = _getX(0),
            y = _getY(0),
            radius = _bw,
            tooltip = "Выбор левых дверей",
            model = {
                model = "models/metrostroi_train/81-760/81_760_button_white.mdl",
                z = 0,
                lamp = {
                    model = "models/metrostroi_train/81-760/81_760_lamp_white.mdl",
                    var = "DoorLeftLamp",
                    z = 0.5,
                    anim = true
                },
                var = "DoorSelectL",
                speed = 12,
                vmin = 0,
                vmax = 1,
                sndvol = 0.3,
                snd = function(val) return val and "button_square_on" or "button_square_off" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "DoorSelectRToggle",
            x = _getX(1),
            y = _getY(0),
            radius = _bw,
            tooltip = "Выбор правых дверей",
            model = {
                model = "models/metrostroi_train/81-760/81_760_button_white.mdl",
                z = 0,
                lamp = {
                    model = "models/metrostroi_train/81-760/81_760_lamp_white.mdl",
                    var = "DoorRightLamp",
                    z = 0.5,
                    anim = true
                },
                var = "DoorSelectR",
                speed = 12,
                vmin = 0,
                vmax = 1,
                sndvol = 0.3,
                snd = function(val) return val and "button_square_on" or "button_square_off" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
        -- {
        --     ID = "!NEZ1",
        --     x = _getX(2),
        --     y = _getY(0),
        --     radius = _bw,
        --     tooltip = "",
        --     model = {
        --         model = "models/metrostroi_train/81-760/81_760_button_green.mdl",
        --         z = 0.2,
        --         var = "",
        --         speed = 12,
        --         vmin = 0,
        --         vmax = 1,
        --         sndvol = 0.3,
        --         snd = function(val) return val and "button_square_on" or "button_square_off" end,
        --         sndmin = 80,
        --         sndmax = 1e3 / 3,
        --         sndang = Angle(-90, 0, 0),
        --     }
        -- },
        {
            ID = "!NEZ2",
            x = _getX(3),
            y = _getY(0),
            radius = _bw,
            tooltip = "",
            model = {
                model = "models/metrostroi_train/81-760/81_760_button_white.mdl",
                z = 0,
                var = "",
                speed = 12,
                vmin = 0,
                vmax = 1,
                sndvol = 0.3,
                snd = function(val) return val and "button_square_on" or "button_square_off" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "R_MicroSet",
            x = _getX(4),
            y = _getY(0),
            radius = _bw,
            tooltip = "Микрофон",
            model = {
                model = "models/metrostroi_train/81-760/81_760_button_yellow.mdl",
                z = 0,
                var = "R_Micro",
                speed = 12,
                vmin = 0,
                vmax = 1,
                sndvol = 0.3,
                snd = function(val) return val and "button_square_on" or "button_square_off" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "HeadlightsSwitchToggle",
            x = _getX(5),
            y = _getY(0),
            radius = 0,
            tooltip = "Фары",
            model = {
                getfunc = function(ent) return ent:GetPackedRatio("HeadlightsSwitch") end,
                var = "HeadlightsSwitch",
                model = "models/metrostroi_train/81-760/81_760_button_front_lamps.mdl",
                z = 0,
                ang = 90,
                speed = 12,
                vmin = 0,
                vmax = 1,
                sndvol = 0.3,
                snd = function(val) return val and "switch_on" or "switch_off" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "HeadlightsSwitch+",
            x = _getX(5),
            y = _getY(0),
            w = _bw,
            h = _bw,
            tooltip = "Фары +"
        },
        {
            ID = "HeadlightsSwitch-",
            x = _getX(5) - _bw,
            y = _getY(0),
            w = _bw,
            h = _bw,
            tooltip = "Фары -"
        },

        {
            ID = "DoorCloseToggle",
            x = _getX(0),
            y = _getY(1),
            radius = _bw,
            tooltip = "Закрытие дверей",
            model = {
                model = "models/metrostroi_train/81-760/81_760_button_green.mdl",
                z = -0.5,
                lamp = {
                    model = "models/metrostroi_train/81-760/81_760_lamp_green.mdl",
                    var = "DoorCloseLamp",
                    z = 0.5,
                    anim = true,
                    color = Color(80, 255, 100)
                },
                var = "DoorClose",
                speed = 12,
                vmin = 0,
                vmax = 1,
                sndvol = 0.3,
                snd = function(val) return val and "button_square_on" or "button_square_off" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "R_Program1Set",
            x = _getX(1),
            y = _getY(1),
            radius = _bw,
            tooltip = "Пуск записи",
            model = {
                model = "models/metrostroi_train/81-760/81_760_button_yellow.mdl", --blue
                z = -0.5,
                var = "R_Program1",
                speed = 12,
                vmin = 0,
                vmax = 1,
                sndvol = 0.3,
                snd = function(val) return val and "button_square_press" or "button_square_release" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "HornBSet",
            x = _getX(2),
            y = _getY(1),
            radius = _bw,
            tooltip = "Сигнал",
            model = {
                model = "models/metrostroi_train/81-760/81_760_button_black.mdl",
                z = -0.5,
                var = "HornB",
                speed = 12,
                vmin = 0,
                vmax = 1,
                sndvol = 0.5,
                snd = function(val) return val and "button_press" or "button_release" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "AttentionMessageSet",
            x = _getX(3),
            y = _getY(1),
            radius = _bw,
            tooltip = "Восприятие сообщения",
            model = {
                model = "models/metrostroi_train/81-760/81_760_button_red.mdl",
                z = 0,
                var = "AttentionMessage",
                speed = 12,
                vmin = 0,
                vmax = 1,
                sndvol = 0.3,
                snd = function(val) return val and "button_square_press" or "button_square_release" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "AttentionBrakeSet",
            x = _getX(4),
            y = _getY(1),
            radius = _bw,
            tooltip = "Восприятие торможения",
            model = {
                model = "models/metrostroi_train/81-760/81_760_button_red.mdl",
                z = 0,
                var = "AttentionBrake",
                speed = 12,
                vmin = 0,
                vmax = 1,
                sndvol = 0.3,
                snd = function(val) return val and "button_square_press" or "button_square_release" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "AttentionSet",
            x = _getX(5),
            y = _getY(1),
            radius = _bw,
            tooltip = "Бдительность",
            model = {
                model = "models/metrostroi_train/81-760/81_760_button_red.mdl",
                z = 0,
                var = "Attention",
                speed = 12,
                vmin = 0,
                vmax = 1,
                sndvol = 0.3,
                snd = function(val) return val and "button_square_press" or "button_square_release" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },

        {
            ID = "DoorLeftSet",
            x = _getX(0),
            y = _getY(2),
            radius = _bw,
            tooltip = "Левые двери",
            model = {
                model = "models/metrostroi_train/81-760/81_760_button_white.mdl",
                z = -0.5,
                lamp = {
                    model = "models/metrostroi_train/81-760/81_760_lamp_white.mdl",
                    var = "DoorLeftLamp",
                    z = 0.2,
                    anim = true
                },
                var = "DoorLeft",
                speed = 12,
                vmin = 0,
                vmax = 1,
                sndvol = 0.5,
                snd = function(val) return val and "button_press" or "button_release" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "DoorRightSet",
            x = _getX(5),
            y = _getY(2),
            radius = _bw,
            tooltip = "Прав двери",
            model = {
                model = "models/metrostroi_train/81-760/81_760_button_white.mdl",
                z = -0.5,
                lamp = {
                    model = "models/metrostroi_train/81-760/81_760_lamp_white.mdl",
                    var = "DoorRightLamp",
                    z = 0.2,
                    anim = true
                },
                var = "DoorRight",
                speed = 12,
                vmin = 0,
                vmax = 1,
                sndvol = 0.5,
                snd = function(val) return val and "button_press" or "button_release" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
    }
}

_, _getX, _, _bw = _fncCoord(3, 136, 18)
_, _getY = _fncCoordFixed(3, 167, _bw * 2)
ENT.ButtonMap["PUR2"] = {
    pos = Vector(486.6, -0.5, -13.2),
    ang = Angle(0, -90, 0),
    width = 136,
    height = 167,
    scale = 0.05,
    hideseat = 0.2,
    buttons = {
        {
            ID = "SDToggle",
            x = _getX(0),
            y = _getY(0),
            radius = _bw,
            tooltip = "Аварийная блокировка СД",
            model = {
                model = "models/metrostroi_train/81-760/81_760_switch_under_glass.mdl",
                z = 0,
                ang = -90,
                --lamp = {model = "models/metrostroi_train/81-720/buttons/l3.mdl",var="ALSLamp",color=Color(255,80,100), anim=true},
                var = "SD",
                speed = 12,
                vmin = 0,
                vmax = 1,
                sndvol = 0.5,
                snd = function(val) return val and "switch_on" or "switch_off" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "SDkToggle",
            x = _getX(0) - _bw - 7,
            y = _getY(0) + 2,
            w = 40,
            h = 20,
            tooltip = "Крышка АБСД",
            model = {
                model = "models/metrostroi_train/81-760/81_760_cap_with_glass.mdl",
                ang = 90,
                z = 3,
                x = 2,
                y = -13,
                var = "SDk",
                speed = 8,
                min = 1,
                max = 0,
                disable = "SDToggle",
                plomb = {
                    model = "",
                    ang = 180 - 70,
                    x = -5,
                    y = -45,
                    z = 3,
                    var = "SDPl",
                    ID = "SDPl",
                },
                sndvol = 1,
                snd = function(val) return val and "kr_close" or "kr_open" end,
                sndmin = 90,
                sndmax = 1e3,
                sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "BTBToggle",
            x = _getX(2),
            y = _getY(0),
            radius = _bw,
            tooltip = "Аварийный блокиратор ЭСД",
            model = {
                model = "models/metrostroi_train/81-760/81_760_switch_under_glass.mdl",
                z = 0,
                ang = -90,
                --lamp = {model = "models/metrostroi_train/81-720/buttons/l3.mdl",var="ALSLamp",color=Color(255,80,100), anim=true},
                var = "BTB",
                speed = 12,
                vmin = 0,
                vmax = 1,
                sndvol = 0.5,
                snd = function(val) return val and "switch_on" or "switch_off" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "BTBkToggle",
            x = _getX(2) - _bw - 7,
            y = _getY(0) + 2,
            w = 40,
            h = 20,
            tooltip = "Крышка АБЭСД",
            model = {
                model = "models/metrostroi_train/81-760/81_760_cap_with_glass.mdl",
                ang = 90,
                z = 3,
                x = 2,
                y = -13,
                var = "BTBk",
                speed = 8,
                min = 1,
                max = 0,
                disable = "BTBToggle",
                plomb = {
                    model = "",
                    ang = 180 - 70,
                    x = -5,
                    y = -45,
                    z = 3,
                    var = "BTBPl",
                    ID = "BTBPl",
                },
                sndvol = 1,
                snd = function(val) return val and "kr_close" or "kr_open" end,
                sndmin = 90,
                sndmax = 1e3,
                sndang = Angle(-90, 0, 0),
            }
        },
        --sndvol = 0.3, snd = function(val) return val and "button_square_press" or "button_square_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        {
            ID = "EmergencyCompressor2Set",
            x = _getX(1),
            y = _getY(0),
            radius = _bw,
            tooltip = "Компрессор резервный",
            model = {
                model = "models/metrostroi_train/81-760/81_760_button_black.mdl",
                z = 0,
                var = "EmergencyCompressor2",
                speed = 12,
                vmin = 0,
                vmax = 1,
                sndvol = 0.3,
                snd = function(val) return val and "button_square_press" or "button_square_release" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "EmerBrakeAddSet",
            x = _getX(0),
            y = _getY(1),
            radius = _bw,
            tooltip = "Тормоз (КТР+)",
            model = {
                model = "models/metrostroi_train/81-760/81_760_button_black.mdl",
                z = 0,
                var = "EmerBrakeAdd",
                speed = 12,
                vmin = 0,
                vmax = 1,
                sndvol = 0.3,
                snd = function(val) return val and "button_square_press" or "button_square_release" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "EmerBrakeReleaseSet",
            x = _getX(1),
            y = _getY(1),
            radius = _bw,
            tooltip = "Отпуск (КТР-)",
            model = {
                model = "models/metrostroi_train/81-760/81_760_button_white.mdl",
                z = 0,
                var = "EmerBrakeRelease",
                speed = 12,
                vmin = 0,
                vmax = 1,
                sndvol = 0.3,
                snd = function(val) return val and "button_square_press" or "button_square_release" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "EmerBrakeToggle",
            x = _getX(2),
            y = _getY(1),
            radius = _bw,
            tooltip = "КТР: Тормоз резервный",
            model = {
                model = "models/metrostroi_train/81-760/81_760_button_with_hole.mdl",
                z = 0,
                lamp = {
                    model = "models/metrostroi_train/81-760/81_760_lamp_green.mdl",
                    var = "EmerBrakeWork",
                    z = -0.5,
                    anim = true,
                },
                var = "EmerBrake",
                speed = 12,
                vmin = 0,
                vmax = 1,
                sndvol = 0.3,
                snd = function(val) return val and "button_square_on" or "button_square_off" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "R_Program11Set",
            x = _getX(0),
            y = _getY(2),
            radius = _bw,
            tooltip = "Пуск записи",
            model = {
                model = "models/metrostroi_train/81-760/81_760_button_yellow.mdl",
                z = 0,
                var = "R_Program11",
                speed = 12,
                sndvol = 0.3,
                snd = function(val) return val and "button_press" or "button_release" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "EmergencyBrakeToggle",
            x = _getX(1),
            y = _getY(2),
            radius = _bw,
            tooltip = "Тормоз экстренный\n(Петля безопасности)",
            model = {
                model = "models/metrostroi_train/81-760/81_760_switch_emergency.mdl",
                z = 8,
                ang = 0,
                var = "EmergencyBrake",
                speed = 12,
                sndvol = 0.5,
                snd = function(val) return val and "switch_on" or "switch_off" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "HornCSet",
            x = _getX(2),
            y = _getY(2),
            radius = _bw,
            tooltip = "Сигнал",
            model = {
                model = "models/metrostroi_train/81-760/81_760_button_black.mdl",
                z = 0,
                var = "HornC",
                speed = 12,
                vmin = 0,
                vmax = 1,
                sndvol = 0.3,
                snd = function(val) return val and "button_square_press" or "button_square_release" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        }
    },
}

ENT.ButtonMap["RVTop"] = {
    pos = Vector(487.6, 37, -13.2),
    ang = Angle(0, -90, 0), --    ang = Angle(-12,13.5,0),
    width = 80,
    height = 60,
    scale = 0.0625,
    hideseat = 0.2,
    buttons = {
        {
            ID = "KRR+",
            x = 0, y = 0, w = 40, h = 30,
            tooltip = "КРР Вперед",
        }, {
            ID = "KRR-",
            x = 0, y = 30, w = 40, h = 30,
            tooltip = "КРР Назад",
        },
        {
            ID = "KRO+",
            x = 40, y = 0, w = 40, h = 30,
            tooltip = "КРО Вперед",
        }, {
            ID = "KRO-",
            x = 40, y = 30, w = 40, h = 30,
            tooltip = "КРО Назад",
        },
    }
}

_, _getX, _, _bw = _fncCoord(3, 153, 20)
_, _getY = _fncCoordFixed(2, 96, _bw * 2)
ENT.ButtonMap["RV"] = {
    pos = Vector(482.9, 39.9, -13.2),
    ang = Angle(0, -90, 0), --    ang = Angle(-12,13.5,0),
    width = 153,
    height = 96,
    scale = 0.05,
    hideseat = 0.2,
    buttons = {
        {
            ID = "!EmergencyControls",
            x = _getX(2),
            y = _getY(1),
            radius = _bw,
            tooltip = "Управление резервное\nОтладочная сигнализационная лампа\nНе используется как кнопка",
            model = {
                model = "models/metrostroi_train/81-760/81_760_button_red.mdl",
                z = 0,
                lamp = {
                    model = "models/metrostroi_train/81-760/81_760_lamp_red.mdl",
                    var = "EmergencyControlsLamp",
                    z = 0.2,
                    anim = true
                },
                var = "EmergencyControls",
                speed = 12,
                vmin = 0,
                vmax = 0,
                ang = 180,
            }
        },
        {
            ID = "EmergencyCompressorSet",
            x = _getX(0),
            y = _getY(0),
            radius = _bw,
            tooltip = "Компрессор резервный",
            model = {
                model = "models/metrostroi_train/81-760/81_760_button_black.mdl",
                z = 0,
                var = "EmergencyCompressor",
                speed = 12,
                vmin = 0,
                vmax = 1,
                sndvol = 0.5,
                snd = function(val) return val and "button_press" or "button_release" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "EmerX1Set",
            x = _getX(1),
            y = _getY(0),
            radius = _bw,
            tooltip = "Ход 1 резервный",
            model = {
                model = "models/metrostroi_train/81-760/81_760_button_with_hole.mdl",
                z = 0,
                var = "EmerX1",
                speed = 12,
                vmin = 0,
                vmax = 1,
                lamp = {
                    model = "models/metrostroi_train/81-760/81_760_lamp_green.mdl",
                    var = "EmerXod",
                    z = -0.8,
                    anim = true,
                },
                sndvol = 0.5,
                snd = function(val) return val and "button_press" or "button_release" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "EmerX2Set",
            x = _getX(2),
            y = _getY(0),
            radius = _bw,
            tooltip = "Ход 2 резервный",
            model = {
                model = "models/metrostroi_train/81-760/81_760_button_with_hole.mdl",
                z = 0,
                var = "EmerX2",
                speed = 12,
                vmin = 0,
                vmax = 1,
                lamp = {
                    model = "models/metrostroi_train/81-760/81_760_lamp_green.mdl",
                    var = "EmerXod",
                    z = -0.82,
                    anim = true,
                },
                sndvol = 0.5,
                snd = function(val) return val and "button_press" or "button_release" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
    }
}

local pnang = Angle(11.695, -39.12, -12.642)
pnang:RotateAroundAxis(pnang:Forward(), 90)
pnang:RotateAroundAxis(pnang:Right(), 90)
ENT.ButtonMap["PneumoHelper1"] = {
    pos = Vector(493.9, -11.34, 1),
    ang = pnang,
    width = 100,
    height = 240,
    scale = 0.0625,
    hideseat = 0.2,
    buttons = {
        {
            ID = "!BrakeCylinder",
            x = 35,
            y = 60,
            radius = 60,
            tooltip = "Тормозной цилиндр",
            tooltipFunc = function(ent) return Format(Metrostroi.GetPhrase("Train.Buttons.BCPressure"), ent:GetPackedRatio("BC") * 6) end
        },
        {
            ID = "!BrakeTrainLine",
            x = 35,
            y = 60 * 3,
            radius = 60,
            tooltip = "Красная - тормозная, чёрная - напорная магистраль",
            tooltipFunc = function(ent) return Format(Metrostroi.GetPhrase("Train.Buttons.BLTLPressure"), ent:GetPackedRatio("TL") * 16, ent:GetPackedRatio("BL") * 16) end
        },
    }
}

ENT.ButtonMap["VoltHelper1"] = {
    pos = Vector(492, 59, 35),
    ang = Angle(-11.549, -60.09, 98.2),
    width = 150,
    height = 200,
    scale = 0.055,
    hideseat = 0.2,
    buttons = {
        {
            ID = "!Battery",
            x = 0, y = 0,
            w = 150, h = 100,
            tooltip = "Вольтметр бортовой сети\n(батарея)",
            tooltipFunc = function(ent) return Format(Metrostroi.GetPhrase("Train.Buttons.BatteryVoltage"), ent:GetPackedRatio("LV") * 150) end
        },
        {
            ID = "!HV",
            x = 0, y = 100,
            w = 150, h = 100,
            tooltip = "Киловольтметр высокого напряжения\n(контактный рельс)",
            tooltipFunc = function(ent) return Format(Metrostroi.GetPhrase("Train.Buttons.HighVoltage"), ent:GetPackedRatio("HV") * 1000) end
        },
    }
}

ENT.ButtonMap["ASNPScreen"] = {
    pos = Vector(416.8, 36.82, 37.85),
    ang = Angle(0, 90, 90),
    width = 512 * 1.35,
    height = 128 * 1.35,
    scale = 0.0067,
    hideseat = 0.2,
}

ENT.ButtonMap["ASNP"] = {
    pos = Vector(416.82, 35, 38.6),
    ang = Angle(0, 90, 90),
    width = 180, height = 100,
    scale = 0.045,
    hideseat = 0.2,
    buttons = {
        {
            ID = "R_ASNPMenuSet",
            x = 56,
            y = 78,
            radius = 15,
            tooltip = "АСНП: Меню",
            model = {
                model = "models/metrostroi_train/81-760/81_760_button_asnp.mdl",
                ang = Angle(-90, 0, 0),
                z = 2,
                var = "R_ASNPMenu",
                speed = 12,
                vmin = 0,
                vmax = 0.9,
                sndvol = 0.3,
                snd = function(val) return val and "button_press" or "button_release" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "R_ASNPUpSet",
            x = 165,
            y = 18,
            radius = 8,
            tooltip = "АСНП: Вверх",
            model = {
                model = "models/metrostroi_train/81-760/81_760_button_asnp.mdl",
                ang = Angle(-90, 0, 0),
                z = 3,
                var = "R_ASNPUp",
                speed = 12,
                vmin = 0,
                vmax = 0.9,
                sndvol = 0.3,
                snd = function(val) return val and "button_press" or "button_release" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "R_ASNPDownSet",
            x = 165,
            y = 40,
            radius = 8,
            tooltip = "АСНП: Вниз",
            model = {
                model = "models/metrostroi_train/81-760/81_760_button_asnp.mdl",
                ang = Angle(-90, 0, 0),
                z = 3,
                var = "R_ASNPDown",
                speed = 12,
                vmin = 0,
                vmax = 0.9,
                sndvol = 0.3,
                snd = function(val) return val and "button_press" or "button_release" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "R_ASNPOnToggle",
            x = 17,
            y = 22,
            radius = 8,
            tooltip = "АСНП: Включение",
            model = {
                model = "models/metrostroi_train/81-760/81_760_switch_asnp.mdl",
                ang = Angle(-90, 0, 0),
                z = 6,
                plomb = {
                    model = "models/metrostroi_train/81/plomb_b.mdl",
                    ang = -90,
                    x = 0,
                    y = 25,
                    z = -15,
                    var = "R_ASNPOnPl",
                    ID = "R_ASNPOnPl",
                },
                var = "R_ASNPOn",
                speed = 12,
                sndvol = 0.5,
                snd = function(val) return val and "switch_on" or "switch_off" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
    }
}

--color=Color(187,255,91) green
--color=Color(255,56,30)  red
--color=Color(255,168,000) yellow
ENT.ButtonMap["RVSScreen"] = {
    pos = Vector(479.1, 51.44, -13.29),
    ang = Angle(0, -60, 0),
    width = 256,
    height = 140,
    scale = 0.014,
    hideseat = 0.2,
    system = "RVS",
}

ENT.ButtonMap["RVSButtons"] = {
    pos = Vector(478.6, 55.56, -13.1),
    ang = Angle(0, -60, 0),
    width = 400,
    height = 150,
    scale = 0.03,
    hideseat = 0.2,
    buttons = {
        {
            ID = "RVS_KVSet",
            x = 26,
            y = 32,
            w = 30,
            h = 20,
            tooltip = "КВ",
            model = {
                z = 1,
                ang = Angle(-90, 0, 0),
                lamp = {
                    speed = 16,
                    model = "models/metrostroi_train/common/lamps/svetodiod1.mdl",
                    var = "RVSKV",
                    ang = 90,
                    color = Color(187, 255, 91),
                    x = 31,
                    y = 8,
                    z = -5
                },
                var = "RVS_KV", --vmin=0, vmax=0.9
                speed = 12,
            }
        },
        {
            ID = "!RVS_KVLamp",
            x = 26,
            y = 32,
            model = {
                z = 1,
                ang = Angle(-90, 0, 0),
                lamp = {
                    speed = 16,
                    model = "models/metrostroi_train/common/lamps/svetodiod1.mdl",
                    var = "RVSKVPRD",
                    ang = 90,
                    color = Color(255, 56, 30),
                    x = 46,
                    y = 6,
                    z = -5
                },
            }
        },
        {
            ID = "RVS_UKVSet",
            x = 24,
            y = 115,
            w = 30,
            h = 20,
            tooltip = "УКВ",
            model = {
                z = 1,
                ang = Angle(-90, 0, 0),
                lamp = {
                    speed = 16,
                    model = "models/metrostroi_train/common/lamps/svetodiod1.mdl",
                    var = "RVSUKV",
                    ang = 90,
                    color = Color(187, 255, 91),
                    x = 31,
                    y = 8,
                    z = -5
                },
                var = "RVS_UKV", --vmin=0, vmax=0.9
                speed = 12,
            }
        },
        {
            ID = "!RVS_UKVLamp",
            x = 24,
            y = 115,
            model = {
                z = 1,
                ang = Angle(-90, 0, 0),
                lamp = {
                    speed = 16,
                    model = "models/metrostroi_train/common/lamps/svetodiod1.mdl",
                    var = "RVSUKVPRD",
                    ang = 90,
                    color = Color(255, 56, 30),
                    x = 46,
                    y = 6,
                    z = -5
                },
            }
        },
        {
            ID = "RVS_SSet",
            x = 277,
            y = 42,
            radius = 15,
            tooltip = "С",
            model = {
                z = 1,
                ang = Angle(-90, 0, 0),
                lamp = {
                    speed = 16,
                    model = "models/metrostroi_train/common/lamps/svetodiod1.mdl",
                    var = "RVSPRD",
                    ang = 90,
                    color = Color(187, 255, 91),
                    x = 17,
                    y = 0,
                    z = -5
                },
                var = "RVS_S", --vmin=0, vmax=0.9
                speed = 12,
            }
        },
        {
            ID = "RVS_FSet",
            x = 104,
            y = 42,
            radius = 15,
            tooltip = "F",
            model = {
                z = 1,
                ang = Angle(-90, 0, 0),
                --lamp = {speed=16,model = "models/metrostroi_train/common/lamps/svetodiod1.mdl", var="IGLA:ButtonL1", ang=90,color=Color(187,255,91),x=0,y=-5.5,z=0},
                var = "RVS_F", --vmin=0, vmax=0.9
                speed = 12,
            }
        },
        {
            ID = "RVS_1Set",
            x = 278,
            y = 79,
            radius = 12,
            tooltip = "1",
            model = {
                z = 1,
                ang = Angle(-90, 0, 0),
                lamp = {
                    speed = 16,
                    model = "models/metrostroi_train/common/lamps/svetodiod1.mdl",
                    var = "RVS1",
                    ang = 90,
                    color = Color(187, 255, 91),
                    x = 0,
                    y = -12,
                    z = -5
                },
                var = "RVS_1", --vmin=0, vmax=0.9
                speed = 12,
            }
        },
        {
            ID = "RVS_2Set",
            x = 303,
            y = 79,
            radius = 12,
            tooltip = "2",
            model = {
                z = 1,
                ang = Angle(-90, 0, 0),
                lamp = {
                    speed = 16,
                    model = "models/metrostroi_train/common/lamps/svetodiod1.mdl",
                    var = "RVS2",
                    ang = 90,
                    color = Color(187, 255, 91),
                    x = 0,
                    y = -12,
                    z = -5
                },
                var = "RVS_2", --vmin=0, vmax=0.9
                speed = 12,
            }
        },
        {
            ID = "RVS_3Set",
            x = 328,
            y = 79,
            radius = 12,
            tooltip = "3",
            model = {
                z = 1,
                ang = Angle(-90, 0, 0),
                --lamp = {speed=16,model = "models/metrostroi_train/common/lamps/svetodiod1.mdl", var="IGLA:ButtonL1", ang=90,color=Color(187,255,91),x=0,y=-5.5,z=0},
                var = "RVS_3", --vmin=0, vmax=0.9
                speed = 12,
            }
        },
        {
            ID = "RVS_4Set",
            x = 278,
            y = 99,
            radius = 12,
            tooltip = "4",
            model = {
                z = 1,
                ang = Angle(-90, 0, 0),
                --lamp = {speed=16,model = "models/metrostroi_train/common/lamps/svetodiod1.mdl", var="IGLA:ButtonL1", ang=90,color=Color(187,255,91),x=0,y=-5.5,z=0},
                var = "RVS_4", --vmin=0, vmax=0.9
                speed = 12,
            }
        },
        {
            ID = "RVS_5Set",
            x = 303,
            y = 99,
            radius = 12,
            tooltip = "5",
            model = {
                z = 1,
                ang = Angle(-90, 0, 0),
                --lamp = {speed=16,model = "models/metrostroi_train/common/lamps/svetodiod1.mdl", var="IGLA:ButtonL1", ang=90,color=Color(187,255,91),x=0,y=-5.5,z=0},
                var = "RVS_5", --vmin=0, vmax=0.9
                speed = 12,
            }
        },
        {
            ID = "RVS_6Set",
            x = 328,
            y = 99,
            radius = 12,
            tooltip = "6",
            model = {
                z = 1,
                ang = Angle(-90, 0, 0),
                --lamp = {speed=16,model = "models/metrostroi_train/common/lamps/svetodiod1.mdl", var="IGLA:ButtonL1", ang=90,color=Color(187,255,91),x=0,y=-5.5,z=0},
                var = "RVS_6", --vmin=0, vmax=0.9
                speed = 12,
            }
        },
        {
            ID = "RVS_7Set",
            x = 278,
            y = 115,
            radius = 12,
            tooltip = "7",
            model = {
                z = 1,
                ang = Angle(-90, 0, 0),
                --lamp = {speed=16,model = "models/metrostroi_train/common/lamps/svetodiod1.mdl", var="IGLA:ButtonL1", ang=90,color=Color(187,255,91),x=0,y=-5.5,z=0},
                var = "RVS_7", --vmin=0, vmax=0.9
                speed = 12,
            }
        },
        {
            ID = "RVS_8Set",
            x = 303,
            y = 115,
            radius = 12,
            tooltip = "8",
            model = {
                z = 1,
                ang = Angle(-90, 0, 0),
                --lamp = {speed=16,model = "models/metrostroi_train/common/lamps/svetodiod1.mdl", var="IGLA:ButtonL1", ang=90,color=Color(187,255,91),x=0,y=-5.5,z=0},
                var = "RVS_8", --vmin=0, vmax=0.9
                speed = 12,
            }
        },
        {
            ID = "RVS_9Set",
            x = 328,
            y = 115,
            radius = 12,
            tooltip = "9",
            model = {
                z = 1,
                ang = Angle(-90, 0, 0),
                --lamp = {speed=16,model = "models/metrostroi_train/common/lamps/svetodiod1.mdl", var="IGLA:ButtonL1", ang=90,color=Color(187,255,91),x=0,y=-5.5,z=0},
                var = "RVS_9", --vmin=0, vmax=0.9
                speed = 12,
            }
        },
        {
            ID = "RVS_0Set",
            x = 303,
            y = 130,
            radius = 12,
            tooltip = "0",
            model = {
                z = 1,
                ang = Angle(-90, 0, 0),
                --lamp = {speed=16,model = "models/metrostroi_train/common/lamps/svetodiod1.mdl", var="IGLA:ButtonL1", ang=90,color=Color(187,255,91),x=0,y=-5.5,z=0},
                var = "RVS_0", --vmin=0, vmax=0.9
                speed = 12,
            }
        },
    }
}

ENT.ButtonMap["IGLA"] = {
    pos = Vector(416.9, 46.27, 28.94),
    ang = Angle(0, 90, 90),
    width = 512,
    height = 93,
    scale = 0.018,
    hideseat = 0.2,
    system = "IGLA",
}

ENT.ButtonMap["IGLAButtons"] = {
    pos = Vector(417.08, 46.68, 30.64),
    ang = Angle(0, 90, 90),
    width = 133,
    height = 75,
    scale = 0.065,
    hideseat = 0.2,
    buttons = {
        {
            ID = "IGLA1Set",
            tooltip = "ИГЛА: Первая кнопка\nIGLA: First button",
            x = 0, y = 60, w = 20, h = 15,
            model = {
                var = "IGLA1",
                model = "models/metrostroi_train/81-760/81_760_rect_button_green.mdl",
                lamp = {
                    model = "models/metrostroi_train/81-760/81_760_lamp_rect_green.mdl",
                    var = "IGLA:ButtonL1",
                    speed = 16,
                    ang = Angle(62, 0, 0),
                    color = Color(187, 255, 91),
                    x = 0, y = 0, z = 0.5, scale = 1.05,
                },
                z = -0.6, scale = 1.05,
                ang = Angle(0, -62, 90),
                speed = 12, vmin = 0, vmax = 1, sndvol = 0.3,
                snd = function(val) return val and "button_square_press" or "button_square_release" end,
                sndmin = 80, sndmax = 1e3 / 3, sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "IGLA2Set",
            tooltip = "ИГЛА: Вторая кнопка\nIGLA: Second button",
            x = 36, y = 60, w = 20, h = 15,
            model = {
                var = "IGLA2",
                model = "models/metrostroi_train/81-760/81_760_rect_button_green.mdl",
                lamp = {
                    model = "models/metrostroi_train/81-760/81_760_lamp_rect_green.mdl",
                    var = "IGLA:ButtonL2",
                    speed = 16,
                    ang = Angle(62, 0, 0),
                    color = Color(187, 255, 91),
                    x = 0, y = 0, z = 0.5, scale = 1.05,
                },
                z = -0.6, scale = 1.05,
                ang = Angle(0, -62, 90),
                speed = 12, vmin = 0, vmax = 1, sndvol = 0.3,
                snd = function(val) return val and "button_square_press" or "button_square_release" end,
                sndmin = 80, sndmax = 1e3 / 3, sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "IGLA23",
            x = 64, y = 67, radius = 10,
            tooltip = "ИГЛА: Вторая и третья кнопка"
        },
        {
            ID = "IGLA3Set",
            tooltip = "ИГЛА: Третья кнопка\nIGLA: Third button",
            x = 72, y = 60, w = 20, h = 15,
            model = {
                model = "models/metrostroi_train/81-760/81_760_rect_button_green.mdl",
                var = "IGLA3",
                lamp = {
                    model = "models/metrostroi_train/81-760/81_760_lamp_rect_green.mdl",
                    var = "IGLA:ButtonL3",
                    speed = 16,
                    ang = Angle(62, 0, 0),
                    color = Color(187, 255, 91),
                    x = 0, y = 0, z = 0.5, scale = 1.05,
                },
                z = -0.6, scale = 1.05,
                ang = Angle(0, -62, 90),
                speed = 12, vmin = 0, vmax = 1, sndvol = 0.3,
                snd = function(val) return val and "button_square_press" or "button_square_release" end,
                sndmin = 80, sndmax = 1e3 / 3, sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "IGLA4Set",
            tooltip = "ИГЛА: Четвёртая кнопка\nIGLA: Fourth button",
            x = 108, y = 60, w = 20, h = 15,
            model = {
                model = "models/metrostroi_train/81-760/81_760_rect_button_green.mdl",
                var = "IGLA4",
                lamp = {
                    model = "models/metrostroi_train/81-760/81_760_lamp_rect_green.mdl",
                    var = "IGLA:ButtonL4",
                    speed = 16,
                    ang = Angle(62, 0, 0),
                    color = Color(187, 255, 91),
                    x = 0, y = 0, z = 0.5, scale = 1.05,
                },
                z = -0.6, scale = 1.05,
                ang = Angle(0, -62, 90),
                speed = 12, vmin = 0, vmax = 1, sndvol = 0.3,
                snd = function(val) return val and "button_square_press" or "button_square_release" end,
                sndmin = 80, sndmax = 1e3 / 3, sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "!IGLAFire",
            tooltip = "ИГЛА: Пожар!",
            x = 0, y = 0, w = 20, h = 15,
            model = {
                model = "models/metrostroi_train/81-760/81_760_rect_button_red.mdl",
                lamp = {
                    model = "models/metrostroi_train/81-760/81_760_lamp_rect_red.mdl",
                    var = "IGLA:Fire",
                    speed = 16,
                    ang = Angle(62, 0, 0),
                    x = 0, y = 0, z = 0.5, scale = 1.05,
                },
                x = 0.5, z = -1.4, scale = 1.05,
                ang = Angle(0, -62, 90),
                speed = 12, vmin = 0, vmax = 1, sndvol = 0.3,
                snd = function(val) return val and "button_square_press" or "button_square_release" end,
                sndmin = 80, sndmax = 1e3 / 3, sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "!IGLAErr",
            tooltip = "ИГЛА: Сообщение",
            x = 108, y = 0, w = 20, h = 15,
            model = {
                model = "models/metrostroi_train/81-760/81_760_rect_button_green.mdl",
                lamp = {
                    model = "models/metrostroi_train/81-760/81_760_lamp_rect_green.mdl",
                    var = "IGLA:Error",
                    speed = 16,
                    ang = Angle(62, 0, 0),
                    x = 0, y = 0, z = 0.5, scale = 1.05,
                },
                z = -0.8, scale = 1.05,
                ang = Angle(0, -62, 90),
                speed = 12, vmin = 0, vmax = 1, sndvol = 0.3,
                snd = function(val) return val and "button_square_press" or "button_square_release" end,
                sndmin = 80, sndmax = 1e3 / 3, sndang = Angle(-90, 0, 0),
            }
        }
    }
}

ENT.ButtonMap["BackPPZ"] = {
    pos = Vector(416.99, 32.92, 31.96),
    ang = Angle(0, 90, 90),
    width = 482.6,
    height = 581,
    scale = 0.05,
    hideseat = 0.2,
    buttons = {
        {
            ID = "PowerOnSet", tooltip = "Включение бортсети",
            x = 34, y = 47, radius = 20,
            model = {
                var = "PowerOn",
                model = "models/metrostroi_train/81-760/81_760_button_green.mdl",
                lamp = {
                    model = "models/metrostroi_train/81-760/81_760_lamp_green.mdl",
                    var = "PowerOnLamp", z = 0.5, anim = true,
                },
                z = 0, ang = Angle(0, 0, 0), scale = 1.05,
                sndvol = 0.4, speed = 12, vmin = 0, vmax = 1,
                snd = function(val) return val and "button_square_on" or "button_square_off" end,
                sndmin = 90, sndmax = 1e3,
            }
        }, {
            ID = "PowerOffSet", tooltip = "Выключение бортсети",
            x = 87, y = 47, radius = 20,
            model = {
                var = "PowerOff",
                model = "models/metrostroi_train/81-760/81_760_button_red.mdl",
                lamp = {
                    model = "models/metrostroi_train/81-760/81_760_lamp_red.mdl",
                    var = "PowerOffLamp", z = 0.5, anim = true,
                },
                z = 0, ang = Angle(0, 0, 0), scale = 1.05,
                sndvol = 0.4, speed = 12, vmin = 0, vmax = 1,
                snd = function(val) return val and "button_square_on" or "button_square_off" end,
                sndmin = 90, sndmax = 1e3,
            }
        }, {
            ID = "BatteryChargeToggle", tooltip = "Заряд аккумуляторной батареи",
            x = 139, y = 47, radius = 20,
            model = {
                var = "BatteryCharge",
                model = "models/metrostroi_train/81-760/81_760_button_white.mdl",
                lamp = {
                    model = "models/metrostroi_train/81-760/81_760_lamp_white.mdl",
                    var = "BatteryChargeLamp", z = 0.5, anim = true,
                },
                z = 0, ang = Angle(0, 0, 0), scale = 1.05,
                sndvol = 0.4, speed = 12, vmin = 0, vmax = 1,
                snd = function(val) return val and "button_square_on" or "button_square_off" end,
                sndmin = 90, sndmax = 1e3,
            }
        }
    }
}

table.Add(ENT.ButtonMap["BackPPZ"].buttons, ENT.PpzToggles)

ENT.ButtonMap["PpzCover"] = {
    pos = Vector(418, 32, 32),
    ang = Angle(0, 90, 90),
    width = 510,
    height = 584,
    scale = 0.05,
    hideseat = 0.2,
    buttons = {}
}

ENT.ButtonMap["PVZ"] = {
    pos = Vector(402, 10.8, 12.6), --446 -- 14 -- -0,5
    ang = Angle(0, 90, 90),
    width = 250,
    height = 283,
    scale = 0.0625,
    hideseat = 0.2,
    buttons = {
        {
            ID = "SF31Toggle",
            x = 0 * 16 + 8,
            y = 0,
            w = 16,
            h = 50,
            tooltip = "SF31"
        },
        {
            ID = "SF32Toggle",
            x = 1 * 16 + 8,
            y = 0,
            w = 32,
            h = 50,
            tooltip = "SF32"
        },
        {
            ID = "SF33Toggle",
            x = 3 * 16 + 8,
            y = 0,
            w = 32,
            h = 50,
            tooltip = "SF33"
        },
        {
            ID = "SF34Toggle",
            x = 5 * 16 + 8,
            y = 0,
            w = 16,
            h = 50,
            tooltip = "SF34"
        },
        {
            ID = "SF36Toggle",
            x = 6 * 16 + 8,
            y = 0,
            w = 16,
            h = 50,
            tooltip = "SF36"
        },
        {
            ID = "SF37Toggle",
            x = 7 * 16 + 8,
            y = 0,
            w = 16,
            h = 50,
            tooltip = "SF37"
        },
        {
            ID = "SF38Toggle",
            x = 8 * 16 + 8,
            y = 0,
            w = 16,
            h = 50,
            tooltip = "SF38"
        },
        {
            ID = "SF39Toggle",
            x = 9 * 16 + 8,
            y = 0,
            w = 16,
            h = 50,
            tooltip = "SF39"
        },
        {
            ID = "SF40Toggle",
            x = 10 * 16 + 8,
            y = 0,
            w = 16,
            h = 50,
            tooltip = "SF40"
        },
        {
            ID = "SF41Toggle",
            x = 11 * 16 + 8,
            y = 0,
            w = 16,
            h = 50,
            tooltip = "SF41"
        },
        {
            ID = "SF42Toggle",
            x = 12 * 16 + 8,
            y = 0,
            w = 16,
            h = 50,
            tooltip = "SF42"
        },
        {
            ID = "SF57Toggle",
            x = 13 * 16 + 8,
            y = 0,
            w = 16,
            h = 50,
            tooltip = "SF57"
        },
        {
            ID = "SF43Toggle",
            x = 0 * 24 + 8,
            y = 113,
            w = 16,
            h = 50,
            tooltip = "SF43"
        },
        {
            ID = "SF44Toggle",
            x = 1 * 16 + 8,
            y = 113,
            w = 16,
            h = 50,
            tooltip = "SF44"
        },
        {
            ID = "SF45Toggle",
            x = 2 * 16 + 8,
            y = 113,
            w = 16,
            h = 50,
            tooltip = "SF45"
        },
        {
            ID = "SF46Toggle",
            x = 3 * 16 + 8,
            y = 113,
            w = 16,
            h = 50,
            tooltip = "SF46"
        },
        {
            ID = "SF47Toggle",
            x = 4 * 16 + 8,
            y = 113,
            w = 16,
            h = 50,
            tooltip = "SF47"
        },
        {
            ID = "SF48Toggle",
            x = 5 * 16 + 8,
            y = 113,
            w = 16,
            h = 50,
            tooltip = "SF48"
        },
        {
            ID = "SF49Toggle",
            x = 6 * 16 + 8,
            y = 113,
            w = 16,
            h = 50,
            tooltip = "SF49"
        },
        {
            ID = "SF50Toggle",
            x = 7 * 16 + 8,
            y = 113,
            w = 16,
            h = 50,
            tooltip = "SF50"
        },
        {
            ID = "SF51Toggle",
            x = 8 * 16 + 8,
            y = 113,
            w = 16,
            h = 50,
            tooltip = "SF51"
        },
        {
            ID = "SF52Toggle",
            x = 9 * 16 + 8,
            y = 113,
            w = 16,
            h = 50,
            tooltip = "SF52"
        },
        {
            ID = "SF53Toggle",
            x = 10 * 16 + 8,
            y = 113,
            w = 16,
            h = 50,
            tooltip = "SF53"
        },
        {
            ID = "SF54Toggle",
            x = 11 * 16 + 8,
            y = 113,
            w = 16,
            h = 50,
            tooltip = "SF54"
        },
        {
            ID = "SF55Toggle",
            x = 12 * 16 + 8,
            y = 113,
            w = 16,
            h = 50,
            tooltip = "SF55"
        },
        {
            ID = "SF56Toggle",
            x = 13 * 16 + 8,
            y = 113,
            w = 16,
            h = 50,
            tooltip = "SF56"
        },
        {
            ID = "SF80F9Toggle",
            x = 0 * 16 + 8,
            y = 113 * 1.5,
            w = 16,
            h = 50,
            tooltip = "80F9: Скорость 0 (БУД)"
        },
    }
}

for k, buttbl in ipairs(ENT.ButtonMap["PVZ"].buttons) do
    if k == 2 or k == 3 then
        buttbl.model = {
            model = "models/metrostroi_train/81-760/81_760_double_switch_pmv.mdl",
            z = -16,
            ang = Angle(-180, 90, 90),
            var = buttbl.ID:Replace("Toggle", ""),
            speed = 9,
            sndvol = 0.4,
            snd = function(val) return val and "sf_on" or "sf_off" end,
            sndmin = 90,
            sndmax = 1e3,
        }
    else
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
end

ENT.ButtonMap["Lighting"] = {
    pos = Vector(475.6, 53.19, -21.08),
    ang = Angle(0, -90, 51.39),
    width = 268,
    height = 77,
    scale = 0.0625,
    hideseat = 0.2,
    buttons = {
        {ID = "CabinLightToggle", x = 90, y = 40, radius = nil, model = {
            model = "models/metrostroi_train/81-722/button_rot.mdl", ang = 45,
            getfunc = function(ent) return ent:GetPackedRatio("CabinLight") end,
            var = "CabinLight", speed = 4.1, min = 0, max = 0.27,
            sndvol = 0.4, snd = function(val,val2) return val2 == 1 and "multiswitch_panel_mid" or val and "multiswitch_panel_min" or "multiswitch_panel_max" end,
            sndmin = 90, sndmax = 1e3,
        }},
        {ID = "CabinLight-", x = 80 - 8, y = 25, w = 20, h = 30, tooltip = "Освещение кабины (влево)", model = {
            var = "CabinLight", states = {"Common.765.CabLight.Off", "Common.765.CabLight.Normal", "Common.765.CabLight.Full"},
            varTooltip = function(ent) return ent:GetPackedRatio("CabinLight") / 0.99 end
        }},
        {ID = "CabinLight+", x = 80 + 8, y = 25, w = 20, h = 30, tooltip = "Освещение кабины (вправо)", model = {
            var = "CabinLight", states = {"Common.765.CabLight.Off", "Common.765.CabLight.Normal", "Common.765.CabLight.Full"},
            varTooltip = function(ent) return ent:GetPackedRatio("CabinLight") / 0.99 end
        }},
        -- {ID = "PanelLightToggle", x = 140, y = 30, radius = 15, tooltip = "Освещение пульта", model = {
        --     model = "models/metrostroi_train/81-722/button_rot.mdl", ang = 45,
        --     var = "PanelLight", speed = 8.2, min = 0, max = 0.27,
        --     sndvol = 0.4, snd = function(val,val2) return val and "multiswitch_panel_max" or "multiswitch_panel_min" end,
        --     sndmin = 90, sndmax = 1e3,
        -- }},
    }
}

ENT.ButtonMap["MfduButtons"] = {
    pos = Vector(494.05, 5.2, 0.2),
    ang = Angle(0, -90, 70.431),
    width = 150,
    height = 117,
    scale = 0.1,
    hideseat = 0.2,
    buttons = {
        -- {
        --     ID = "MfduTvSet",
        --     x = 10,
        --     y = 10,
        --     w = 15,
        --     h = 15,
        --     tooltip = "Скиф: Упр ТВ",
        --     model = {
        --         var = "MfduTv",
        --         speed = 16,
        --     }
        -- },
        -- {
        --     ID = "MfduTv1Set",
        --     x = 10,
        --     y = 28,
        --     w = 15,
        --     h = 15,
        --     tooltip = "Скиф: ТВ1",
        --     model = {
        --         var = "MfduTv1",
        --         speed = 16,
        --     }
        -- },
        -- {
        --     ID = "MfduTv2Set",
        --     x = 10,
        --     y = 46,
        --     w = 15,
        --     h = 15,
        --     tooltip = "Скиф: ТВ2",
        --     model = {
        --         var = "MfduTv2",
        --         speed = 16,
        --     }
        -- },
        -- {
        {
            ID = "Mfdu1Set",
            x = 17 + 11.6 * 0,
            y = 117 - 11.6,
            w = 11.6,
            h = 11.6,
            tooltip = "Скиф: 1",
            model = {
                var = "Mfdu1",
                speed = 16,
                snd = function(val) return val and "mfdu_down" or "mfdu_up" end,
                sndmin = 90, sndmax = 1e3, sndvol = 0.5, sndang = Angle(-90,0,0),
                vmin = 0, vmax = 1
            }
        },
        {
            ID = "Mfdu2Set",
            x = 17 + 11.7 * 1,
            y = 117 - 11.7,
            w = 11.7,
            h = 11.7,
            tooltip = "Скиф: 2",
            model = {
                var = "Mfdu2",
                speed = 16,
                snd = function(val) return val and "mfdu_down" or "mfdu_up" end,
                sndmin = 90, sndmax = 1e3, sndvol = 0.5, sndang = Angle(-90,0,0)
            }
        },
        {
            ID = "Mfdu3Set",
            x = 17 + 11.7 * 2,
            y = 117 - 11.7,
            w = 11.7,
            h = 11.7,
            tooltip = "Скиф: 3",
            model = {
                var = "Mfdu3",
                speed = 16,
                snd = function(val) return val and "mfdu_down" or "mfdu_up" end,
                sndmin = 90, sndmax = 1e3, sndvol = 0.5, sndang = Angle(-90,0,0)
            }
        },
        {
            ID = "Mfdu4Set",
            x = 17 + 11.7 * 3,
            y = 117 - 11.7,
            w = 11.7,
            h = 11.7,
            tooltip = "Скиф: 4",
            model = {
                var = "Mfdu4",
                speed = 16,
                snd = function(val) return val and "mfdu_down" or "mfdu_up" end,
                sndmin = 90, sndmax = 1e3, sndvol = 0.5, sndang = Angle(-90,0,0)
            }
        },
        {
            ID = "Mfdu5Set",
            x = 17 + 11.7 * 4,
            y = 117 - 11.7,
            w = 11.7,
            h = 11.7,
            tooltip = "Скиф: 5",
            model = {
                var = "Mfdu5",
                speed = 16,
                snd = function(val) return val and "mfdu_down" or "mfdu_up" end,
                sndmin = 90, sndmax = 1e3, sndvol = 0.5, sndang = Angle(-90,0,0)
            }
        },
        {
            ID = "Mfdu6Set",
            x = 17 + 11.7 * 5,
            y = 117 - 11.7,
            w = 11.7,
            h = 11.7,
            tooltip = "Скиф: 6",
            model = {
                var = "Mfdu6",
                speed = 16,
                snd = function(val) return val and "mfdu_down" or "mfdu_up" end,
                sndmin = 90, sndmax = 1e3, sndvol = 0.5, sndang = Angle(-90,0,0)
            }
        },
        {
            ID = "Mfdu7Set",
            x = 17 + 11.7 * 6,
            y = 117 - 11.7,
            w = 11.7,
            h = 11.7,
            tooltip = "Скиф: 7",
            model = {
                var = "Mfdu7",
                speed = 16,
                snd = function(val) return val and "mfdu_down" or "mfdu_up" end,
                sndmin = 90, sndmax = 1e3, sndvol = 0.5, sndang = Angle(-90,0,0)
            }
        },
        {
            ID = "Mfdu8Set",
            x = 17 + 11.7 * 7,
            y = 117 - 11.7,
            w = 11.7,
            h = 11.7,
            tooltip = "Скиф: 8",
            model = {
                var = "Mfdu8",
                speed = 16,
                snd = function(val) return val and "mfdu_down" or "mfdu_up" end,
                sndmin = 90, sndmax = 1e3, sndvol = 0.5, sndang = Angle(-90,0,0)
            }
        },
        {
            ID = "Mfdu9Set",
            x = 17 + 11.7 * 8,
            y = 117 - 11.7,
            w = 11.7,
            h = 11.7,
            tooltip = "Скиф: 9",
            model = {
                var = "Mfdu9",
                speed = 16,
                snd = function(val) return val and "mfdu_down" or "mfdu_up" end,
                sndmin = 90, sndmax = 1e3, sndvol = 0.5, sndang = Angle(-90,0,0)
            }
        },
        {
            ID = "Mfdu0Set",
            x = 17 + 11.7 * 9,
            y = 117 - 11.7,
            w = 11.7,
            h = 11.7,
            tooltip = "Скиф: 0",
            model = {
                var = "Mfdu0",
                speed = 16,
                snd = function(val) return val and "mfdu_down" or "mfdu_up" end,
                sndmin = 90, sndmax = 1e3, sndvol = 0.5, sndang = Angle(-90,0,0)
            }
        },
        {
            ID = "MfduF5Set",
            x = 150-10,
            y = 15 + 11.6 * 4,
            w = 11.6,
            h = 11.6,
            tooltip = "Скиф: Сброс",
            model = {
                var = "MfduF5",
                speed = 16,
                snd = function(val) return val and "mfdu_down" or "mfdu_up" end,
                sndmin = 90, sndmax = 1e3, sndvol = 0.5, sndang = Angle(-90,0,0)
            }
        },
        {
            ID = "MfduF6Set",
            x = 150-10,
            y = 15 + 11.6 * 2,
            w = 11.6,
            h = 11.6,
            tooltip = "Скиф: Вверх",
            model = {
                var = "MfduF6",
                speed = 16,
                snd = function(val) return val and "mfdu_down" or "mfdu_up" end,
                sndmin = 90, sndmax = 1e3, sndvol = 0.5, sndang = Angle(-90,0,0)
            }
        },
        {
            ID = "MfduF7Set",
            x = 150-10,
            y = 15 + 11.6 * 3,
            w = 11.6,
            h = 11.6,
            tooltip = "Скиф: Вниз",
            model = {
                var = "MfduF7",
                speed = 16,
                snd = function(val) return val and "mfdu_down" or "mfdu_up" end,
                sndmin = 90, sndmax = 1e3, sndvol = 0.5, sndang = Angle(-90,0,0)
            }
        },
        {
            ID = "MfduF8Set",
            x = 150-10,
            y = 15 + 11.6 * 6,
            w = 11.6,
            h = 11.6,
            tooltip = "Скиф: Ввод",
            model = {
                var = "MfduF8",
                speed = 16,
                snd = function(val) return val and "mfdu_down" or "mfdu_up" end,
                sndmin = 90, sndmax = 1e3, sndvol = 0.5, sndang = Angle(-90,0,0)
            }
        },
        {
            ID = "MfduF9Set",
            x = 150-10,
            y = 15 + 11.6 * 5,
            w = 11.6,
            h = 11.6,
            tooltip = "Скиф: Выбор",
            model = {
                var = "MfduF9",
                speed = 16,
                snd = function(val) return val and "mfdu_down" or "mfdu_up" end,
                sndmin = 90, sndmax = 1e3, sndvol = 0.5, sndang = Angle(-90,0,0)
            }
        },
        {
            ID = "MfduHelpSet",
            x = 150-10,
            y = 15 + 11.6 * 1,
            w = 11.6,
            h = 11.6,
            tooltip = "Скиф: ?",
            model = {
                var = "MfduHelp",
                speed = 16,
                snd = function(val) return val and "mfdu_down" or "mfdu_up" end,
                sndmin = 90, sndmax = 1e3, sndvol = 0.5, sndang = Angle(-90,0,0)
            }
        },
        {
            ID = "MfduKontrSet",
            x = 150-10,
            y = 15 + 11.6 * 0,
            w = 11.6,
            h = 11.6,
            tooltip = "Скиф: КОНТР",
            model = {
                var = "MfduKontr",
                speed = 16,
                snd = function(val) return val and "mfdu_down" or "mfdu_up" end,
                sndmin = 90, sndmax = 1e3, sndvol = 0.5, sndang = Angle(-90,0,0)
            }
        },
        {
            ID = "!MfduLamp",
            x = 6.9,
            y = 114.3,
            radius = 2,
            model = {
                lamp = {
                    model = "models/metrostroi_train/81-760/81_760_led_small_mfdu.mdl",
                    ang = Angle(-90, 10, 0),
                    var = "MfduLamp",
                    z = -4,
                    color = Color(255, 255, 255) --Color(175,250,20)
                },
            }
        },
    }
}

_, _getX, _, _bw = _fncCoord(12, 425.8, 10)
_, _getY = _fncCoord(1, 20.2, 0)
ENT.ButtonMap["BUIKButtons"] = {
    pos = Vector(491.75, 31.37, -6.42),
    ang = Angle(0, -90, 70.431),
    width = 425.8,
    height = 20.2,
    scale = 0.05,
    hideseat = 0.2,
    buttons = {
        {
            ID = "Buik_EMsg1Set",
            x = _getX(0),
            y = _getY(0),
            radius = _bw,
            tooltip = "Экстренное Сообщение 1",
            model = {
                model = "models/metrostroi_train/81-760/81_760_rect_button_orange.mdl",
                z = -0.5,
                ang = Angle(0, -62, 90),
                --lamp = {model = "models/metrostroi_train/81-760/81_760_lamp_rect_orange.mdl",var="SCLamp",anim=true,ang=Angle(0,-62,90),z=1},
                var = "Buik_EMsg1",
                speed = 12,
                vmin = 0,
                vmax = 1,
                sndvol = 0.3,
                snd = function(val) return val and "button_square_press" or "button_square_release" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "Buik_EMsg2Set",
            x = _getX(1),
            y = _getY(0),
            radius = _bw,
            tooltip = "Экстренное Сообщение 2",
            model = {
                model = "models/metrostroi_train/81-760/81_760_rect_button_orange.mdl",
                z = -0.5,
                ang = Angle(0, -62, 90),
                --lamp = {model = "models/metrostroi_train/81-760/81_760_lamp_rect_orange.mdl",var="SCLamp",anim=true,ang=Angle(0,-62,90),z=1},
                var = "Buik_EMsg2",
                speed = 12,
                vmin = 0,
                vmax = 1,
                sndvol = 0.3,
                snd = function(val) return val and "button_square_press" or "button_square_release" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "Buik_Unused1Set",
            x = _getX(2),
            y = _getY(0),
            radius = _bw,
            tooltip = "Резвервная линия (не используется)",
            model = {
                model = "models/metrostroi_train/81-760/81_760_rect_button_orange.mdl",
                z = -0.5,
                ang = Angle(0, -62, 90),
                var = "Buik_Unused1",
                speed = 12,
                vmin = 0,
                vmax = 1,
                sndvol = 0.3,
                snd = function(val) return val and "button_square_press" or "button_square_release" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "Buik_ModeSet",
            x = _getX(3),
            y = _getY(0),
            radius = _bw,
            tooltip = "Режим (страница)",
            model = {
                model = "models/metrostroi_train/81-760/81_760_rect_button_black.mdl",
                z = -0.5,
                ang = Angle(0, -62, 90),
                var = "Buik_Mode",
                speed = 12,
                vmin = 0,
                vmax = 1,
                sndvol = 0.3,
                snd = function(val) return val and "button_square_press" or "button_square_release" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "Buik_PathToggle",
            x = _getX(4),
            y = _getY(0),
            radius = _bw,
            tooltip = "Выбор маршрута",
            model = {
                model = "models/metrostroi_train/81-760/81_760_rect_button_yellow.mdl",
                z = -0.5,
                ang = Angle(0, -62, 90),
                lamp = {
                    model = "models/metrostroi_train/81-760/81_760_lamp_rect_yellow.mdl",
                    var = "Buik_PathLamp",
                    anim = true,
                    ang = Angle(62, 0, 0),
                    z = 0.5
                },
                var = "Buik_Path",
                speed = 12,
                vmin = 0,
                vmax = 1,
                sndvol = 0.3,
                snd = function(val) return val and "button_square_press" or "button_square_release" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "Buik_ReturnSet",
            x = _getX(5),
            y = _getY(0),
            radius = _bw,
            tooltip = "Установка в начало",
            model = {
                model = "models/metrostroi_train/81-760/81_760_rect_button_yellow.mdl",
                z = -0.5,
                ang = Angle(0, -62, 90),
                var = "Buik_Return",
                speed = 12,
                vmin = 0,
                vmax = 1,
                sndvol = 0.3,
                snd = function(val) return val and "button_square_press" or "button_square_release" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "Buik_DownSet",
            x = _getX(6),
            y = _getY(0),
            radius = _bw,
            tooltip = "Выбор станции ↓",
            model = {
                model = "models/metrostroi_train/81-760/81_760_rect_button_black.mdl",
                z = -0.5,
                ang = Angle(0, -62, 90),
                var = "Buik_Down",
                speed = 12,
                vmin = 0,
                vmax = 1,
                sndvol = 0.3,
                snd = function(val) return val and "button_square_press" or "button_square_release" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "Buik_UpSet",
            x = _getX(7),
            y = _getY(0),
            radius = _bw,
            tooltip = "Выбор станции ↑",
            model = {
                model = "models/metrostroi_train/81-760/81_760_rect_button_black.mdl",
                z = -0.5,
                ang = Angle(0, -62, 90),
                var = "Buik_Up",
                speed = 12,
                vmin = 0,
                vmax = 1,
                sndvol = 0.3,
                snd = function(val) return val and "button_square_press" or "button_square_release" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "Buik_MicLineToggle",
            x = _getX(8),
            y = _getY(0),
            radius = _bw,
            tooltip = "Линия",
            model = {
                model = "models/metrostroi_train/81-760/81_760_rect_button_yellow.mdl",
                z = -0.5,
                ang = Angle(0, -62, 90),
                lamp = {
                    model = "models/metrostroi_train/81-760/81_760_lamp_rect_yellow.mdl",
                    var = "Buik_MicLineLamp",
                    anim = true,
                    ang = Angle(62, 0, 0),
                    z = 0.5
                },
                var = "Buik_MicLine",
                speed = 12,
                vmin = 0,
                vmax = 1,
                sndvol = 0.3,
                snd = function(val) return val and "button_square_press" or "button_square_release" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "Buik_MicBtnSet",
            x = _getX(9),
            y = _getY(0),
            radius = _bw,
            tooltip = "Микрофон",
            model = {
                model = "models/metrostroi_train/81-760/81_760_rect_button_black.mdl",
                z = -0.5,
                ang = Angle(0, -62, 90),
                var = "Buik_MicBtn",
                speed = 12,
                vmin = 0,
                vmax = 1,
                sndvol = 0.3,
                snd = function(val) return val and "button_square_press" or "button_square_release" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "Buik_AsotpSet",
            x = _getX(10),
            y = _getY(0),
            radius = _bw,
            tooltip = "АСОТП: Автоматическая система обнаружения и тушения пожара",
            model = {
                model = "models/metrostroi_train/81-760/81_760_rect_button_black.mdl",
                z = -0.5,
                ang = Angle(0, -62, 90),
                var = "Buik_Asotp",
                speed = 12,
                vmin = 0,
                vmax = 1,
                sndvol = 0.3,
                snd = function(val) return val and "button_square_press" or "button_square_release" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "Buik_IkSet",
            x = _getX(11),
            y = _getY(0),
            radius = _bw,
            tooltip = "ИК: Информационный комплекс",
            model = {
                model = "models/metrostroi_train/81-760/81_760_rect_button_black.mdl",
                z = -0.5,
                ang = Angle(0, -62, 90),
                var = "Buik_Ik",
                speed = 12,
                vmin = 0,
                vmax = 1,
                sndvol = 0.3,
                snd = function(val) return val and "button_square_press" or "button_square_release" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        }
    }
}

-- ENT.ButtonMap["SpeedometerButtons"] = {
--     pos = Vector(515 + 20.8, 28, -21.2) + Vector(-41.5, 0, 17.5),
--     ang = Angle(0, -89.5, 62),
--     width = 20,
--     height = 160,
--     scale = 0.035,
--     hideseat = 0.2,
--     buttons = {
--         {
--             ID = "SpeedometerF3Set",
--             x = 0,
--             y = 120,
--             w = 20,
--             h = 20,
--             tooltip = "Спидометр: F3",
--             model = {
--                 var = "SpeedometerF3",
--                 speed = 16,
--             }
--         },
--     }
-- }

ENT.ButtonMap["CAMSButtons"] = {
    pos = Vector(482.58, 50.71, -11.23),
    ang = Angle(0, -59.84, 72.91),
    width = 297.5,
    height = 20,
    scale = 0.0388,
    hideseat = 0.2,
    buttons = {
        {
            ID = "CAMS1Set",
            x = 0, y = 0, w = 20, h = 20,
            tooltip = "▼",
            model = {
                model = "models/metrostroi_train/81-760/81_760_button_cam_green.mdl",
                z = 6, scale = 1.05,
                var = "CAMS1",
                speed = 16,
            }
        },
        {
            ID = "CAMS2Set",
            x = 28.3 * 1, y = 0, w = 20, h = 20,
            tooltip = "▲",
            model = {
                model = "models/metrostroi_train/81-760/81_760_button_cam_green.mdl",
                z = 6, scale = 1.05,
                var = "CAMS2",
                speed = 16,
            }
        },
        {
            ID = "CAMS3Set",
            x = 28.3 * 2, y = 0, w = 20, h = 20,
            tooltip = "3",
            model = {
                model = "models/metrostroi_train/81-760/81_760_button_cam_green.mdl",
                z = 6, scale = 1.05,
                var = "CAMS3",
                speed = 16,
            }
        },
        {
            ID = "CAMS4Set",
            x = 28.3 * 3, y = 0, w = 20, h = 20,
            tooltip = "4",
            model = {
                model = "models/metrostroi_train/81-760/81_760_button_cam_green.mdl",
                z = 6, scale = 1.05,
                var = "CAMS4",
                speed = 16,
            }
        },
        {
            ID = "CAMS5Set",
            x = 135.3, y = 0, w = 20, h = 20,
            tooltip = "5",
            model = {
                model = "models/metrostroi_train/81-760/81_760_button_cam_yellow.mdl",
                z = 6, scale = 1.05,
                var = "CAMS5",
                speed = 16,
            }
        },
        {
            ID = "CAMS6Set",
            x = 135.3 + 28.3 * 1, y = 0, w = 20, h = 20,
            tooltip = "6",
            model = {
                model = "models/metrostroi_train/81-760/81_760_button_cam_yellow.mdl",
                z = 6, scale = 1.05,
                var = "CAMS6",
                speed = 16,
            }
        },
        {
            ID = "CAMS7Set",
            x = 135.3 + 28.3 * 2, y = 0, w = 20, h = 20,
            tooltip = "7",
            model = {
                model = "models/metrostroi_train/81-760/81_760_button_cam_yellow.mdl",
                z = 6, scale = 1.05,
                var = "CAMS7",
                speed = 16,
            }
        },
        {
            ID = "CAMS8Set",
            x = 135.3 + 28.3 * 3, y = 0, w = 20, h = 20,
            tooltip = "8",
            model = {
                model = "models/metrostroi_train/81-760/81_760_button_cam_yellow.mdl",
                z = 6,
                var = "CAMS8",
                speed = 16,
            }
        },
        {
            ID = "CAMS9Set",
            x = 135.3 + 28.3 * 4, y = 0, w = 20, h = 20,
            tooltip = "9",
            model = {
                model = "models/metrostroi_train/81-760/81_760_button_cam_yellow.mdl",
                z = 6, scale = 1.05,
                var = "CAMS9",
                speed = 16,
            }
        },
        {
            ID = "CAMS10Set",
            x = 135.3 + 28.3 * 5, y = 0, w = 20, h = 20,
            tooltip = "10",
            model = {
                model = "models/metrostroi_train/81-760/81_760_button_cam_yellow.mdl",
                z = 6, scale = 1.05,
                var = "CAMS10",
                speed = 16,
            }
        },
    }
}

ENT.ButtonMap["StopKran"] = {
    pos = Vector(484, -54, -6),
    ang = Angle(0, 225, 90),
    width = 160,
    height = 600,
    scale = 0.0625,
    hideseat = 0.2,
    buttons = {
        {
            ID = "EmergencyBrakeValveToggle",
            x = 0,
            y = 0,
            w = 160,
            h = 600,
            tooltip = "Стопкран"
        },
    }
}

ENT.ClientProps["EmergencyBrakeValve"] = {
    model = "models/metrostroi_train/81-765/keb.mdl",
    pos = Vector(0, 0, 0), --Vector(455,-55.2,26),
    ang = Angle(0, 0, 0),
    hideseat = 0.5,
}

ENT.ButtonMap["BTO1"] = {
    pos = Vector(486, -50, -46),
    ang = Angle(0, 225, 90),
    width = 140,
    height = 150,
    scale = 0.0625,
    hideseat = 0.2,
    buttons = {
        {
            ID = "K9Toggle",
            x = 0, y = 0,
            w = 140, h = 150,
            tooltip = "К9 (РВТБ)",
            model = {
                plomb = {
                    model = "",
                    ang = 180 - 70,
                    x = -5,
                    y = -45,
                    z = 3,
                    var = "K9Pl",
                    ID = "K9Pl",
                },
                var = "K9",
                speed = 4,
                min = 0.28,
                max = 0,
            }
        },
    }
}
ENT.ButtonMap["BTO2"] = {
    pos = Vector(478, -50, -50),
    ang = Angle(0, 225, 90),
    width = 140,
    height = 100,
    scale = 0.0625,
    hideseat = 0.2,
    buttons = {
        {
            ID = "K29Toggle",
            x = 0, y = 0,
            w = 140, h = 100,
            tooltip = "К29 (КРМШ)",
            model = {
                var = "K29",
                speed = 4,
                max = 0.28,
            }
        },
    }
}

--[[
        {ID = "UAVAToggle", x=24+280,  y=26, radius=25, tooltip="УАВА", model = {
            model = "models/metrostroi_train/81-720/720_cran.mdl", ang=-90,
            plomb = {var="UAVAPl", ID="UAVAPl", },
            var="UAVA",speed=4, max=0.28
        }},]]
ENT.ClientProps["RVTB"] = {
    model = "models/metrostroi_train/81-765/k9.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hideseat = 0.5,
}

-- ENT.ClientProps["PPZ"] = {
--     model = "models/metrostroi_train/81-765/81_765_ppz.mdl",
--     pos = Vector(0, 0, 0),
--     ang = Angle(0, 0, 0),
--     hide = 2,
-- }

ENT.ClientProps["K29"] = {
    model = "models/metrostroi_train/81-765/k29.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hideseat = 0.5,
}

ENT.ButtonMap["K35"] = {
    pos = Vector(410, -66, 11.5), --446 -- 14 -- -0,5
    ang = Angle(0, 180, 90),
    width = 110,
    height = 1000,
    scale = 0.0625,
    hideseat = 0.2,
    buttons = {
        {
            ID = "UAVAToggle",
            x = 0,
            y = 0,
            w = 110,
            h = 1000,
            tooltip = "К35 (УАВА)",
            model = {
                --model = "models/metrostroi_train/81-720/720_cran.mdl", ang=-90,
                plomb = {
                    var = "UAVAPl",
                    ID = "UAVAPl",
                },
                var = "UAVA",
                speed = 4,
                max = 0.28
            }
        },
    }
}

ENT.ClientProps["K35"] = {
    model = "models/metrostroi_train/81-765/k35.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hideseat = 0.5,
}

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

ENT.ButtonMap["FrontPneumatic"] = {
pos = Vector(428, -52, -60),
    ang = Angle(0, 0, 90),
    width = 230,
    height = 100,
    scale = 0.1,
    hideseat = 0.2,
    hide = true,
    buttons = {
        {
            ID = "FrontTrainLineIsolationToggle",
            x = 80,
            y = 35,
            radius = 32,
            tooltip = "Концевой кран напорной магистрали",
            model = {
                var = "FrontTrainLineIsolation",
                sndid = "FrontTrain",
                states = {"Train.Buttons.Opened", "Train.Buttons.Closed"}
            }
        },
        {
            ID = "FrontBrakeLineIsolationToggle",
            x = 180,
            y = 60,
            radius = 32,
            tooltip = "Концевой кран тормозной магистрали",
            model = {
                var = "FrontBrakeLineIsolation",
                sndid = "FrontBrake",
                states = {"Train.Buttons.Opened", "Train.Buttons.Closed"}
            }
        },
    }
}

ENT.ClientProps["FrontBrake"] = {
    --
    model = "models/metrostroi_train/81-760/81_760_crane_k23.mdl",
    pos = Vector(446.3, -50.62, -66.14),
    ang = Angle(0, 90, 0),
    hide = 2,
}

ENT.ClientProps["FrontTrain"] = {
    --
    model = "models/metrostroi_train/81-760/81_760_crane_k23.mdl",
    pos = Vector(436.3, -53.57, -64.13),
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
                states = {"Train.Buttons.Opened", "Train.Buttons.Closed"}
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
                states = {"Train.Buttons.Opened", "Train.Buttons.Closed"}
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
ENT.ButtonMap["K23M"] = {
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
ENT.ButtonMap["PassengerDoor"] = {
    pos = Vector(400, -28.5, 40), --28
    ang = Angle(0, 90, 90),
    width = 730,
    height = 2000,
    scale = 0.1 / 2,
    buttons = {
        {
            ID = "PassengerDoor",
            x = 0,
            y = 0,
            w = 730,
            h = 2000,
            tooltip = "Дверь в кабину машиниста из салона\nPass door",
            model = {
                var = "PassengerDoor",
                sndid = "door_cab_m",
                sndvol = 1,
                snd = function(val) return val and "door_cab_open" or "door_cab_close" end,
                sndmin = 90,
                sndmax = 1e3,
                sndang = Angle(-90, 0, 0),
            }
        },
    }
}

ENT.ButtonMap["PassengerDoor2"] = {
    pos = Vector(398, 8, 40), --28
    ang = Angle(0, -90, 90),
    width = 730,
    height = 2000,
    scale = 0.1 / 2,
    buttons = {
        {
            ID = "PassengerDoor",
            x = 0,
            y = 0,
            w = 730,
            h = 2000,
            tooltip = "Дверь в кабину машиниста из салона\nPass door"
        },
    }
}

ENT.ButtonMap["Chair"] = {
    pos = Vector(417, -58, -6), --28
    ang = Angle(0, 90, 90),
    width = 830,
    height = 1000,
    scale = 0.1 / 3.8,
    buttons = {
        {
            ID = "Chair",
            x = 0,
            y = 0,
            w = 830,
            h = 1000,
            tooltip = "Сидуха"
        },
    }
}

-- ENT.ButtonMap["Door_pvz"] = {
--     pos = Vector(411.6, 21, 42), --28
--     ang = Angle(0, 90, 90),
--     width = 235,
--     height = 1840,
--     scale = 0.1 / 2,
--     buttons = {
--         {
--             ID = "Door_pvz",
--             x = 0,
--             y = 0,
--             w = 235,
--             h = 1840,
--             tooltip = "Шкаф",
--             model = {
--                 var = "Door_pvz",
--             }
--         },
--     }
-- }

-- ENT.ButtonMap["Door_pvzo"] = {
--     pos = Vector(413.6, -13, 42), --28
--     ang = Angle(0, 180, 90),
--     width = 235,
--     height = 1840,
--     scale = 0.1 / 2,
--     buttons = {
--         {
--             ID = "Door_pvz",
--             x = 0,
--             y = 0,
--             w = 235,
--             h = 1840,
--             tooltip = "Шкаф",
--             model = {
--                 var = "Door_pvz",
--             }
--         },
--     }
-- }

ENT.ButtonMap["Door_add_1"] = {
    pos = Vector(417, -57.5, 48), --28
    ang = Angle(0, 90, 90),
    width = 100,
    height = 230,
    scale = 0.23,
    buttons = {
        {
            ID = "Door_add_1",
            x = 0,
            y = 0,
            w = 100,
            h = 230,
            tooltip = "Шкаф",
            model = {
                var = "Door_add_1",
            }
        },
    }
}

ENT.ButtonMap["Door_add_1o"] = {
    pos = Vector(439.1, -50, 47.1), --28
    ang = Angle(0, 198.28, 90),
    width = 100,
    height = 230,
    scale = 0.23,
    buttons = {
        {
            ID = "Door_add_1",
            x = 0,
            y = 0,
            w = 100,
            h = 230,
            tooltip = "Шкаф",
            model = {
                var = "Door_add_1",
            }
        },
    }
}

-- ENT.ButtonMap["Door_add_2"] = {
--     pos = Vector(406.5, -30.2, 45.5), --28
--     ang = Angle(0, 180, 90),
--     width = 350,
--     height = 1910,
--     scale = 0.1 / 2,
--     buttons = {
--         {
--             ID = "Door_add_2",
--             x = 0,
--             y = 0,
--             w = 350,
--             h = 1910,
--             tooltip = "Шкаф",
--             model = {
--                 var = "Door_add_2",
--             }
--         },
--     }
-- }

-- ENT.ButtonMap["Door_add_2o"] = {
--     pos = Vector(390.5, -30.2, 45.5), --28
--     ang = Angle(0, 90, 90),
--     width = 350,
--     height = 1910,
--     scale = 0.1 / 2,
--     buttons = {
--         {
--             ID = "Door_add_2",
--             x = 0,
--             y = 0,
--             w = 350,
--             h = 1910,
--             tooltip = "Шкаф",
--             model = {
--                 var = "Door_add_2",
--             }
--         },
--     }
-- }

ENT.ButtonMap["CabinDoorL"] = {
    pos = Vector(425, 64.5, 49.2),
    ang = Angle(0, 0, 91),
    width = 710,
    height = 2030,
    scale = 0.1 / 2,
    buttons = {
        {
            ID = "CabinWindowLeft",
            x = 0,
            y = 0,
            w = 710,
            h = 600,
            tooltip = "Форточка",
            model = {
                var = "CabinWindowLeft",
                sndid = "doorw_cab_l",
            }
        }, {
            ID = "CabinDoorLeft",
            x = 0,
            y = 600,
            w = 710,
            h = 1430,
            tooltip = "Дверь в кабину машиниста\nCabin door",
            model = {
                var = "CabinDoorLeft",
                sndid = "door_cab_l",
            }
        },
    }
}

ENT.ButtonMap["CabinDoorL1"] = {
    pos = Vector(425, 67.5, -52.3),
    ang = Angle(0, 0, -89),
    width = 710,
    height = 2030,
    scale = 0.1 / 2,
    buttons = {
        {
            ID = "CabinDoorLeft",
            x = 0,
            y = 0,
            w = 710,
            h = 2030,
            tooltip = "Дверь в кабину машиниста\nCabin door",
            model = {
                var = "CabinDoorLeft",
                sndid = "door_cab_l",
            }
        },
    }
}

ENT.ButtonMap["CabinDoorR"] = {
    pos = Vector(460, -64.5, 49.2),
    ang = Angle(0, 180, 91),
    width = 710,
    height = 2030,
    scale = 0.1 / 2,
    buttons = {
        {
            ID = "CabinWindowRight",
            x = 0,
            y = 0,
            w = 710,
            h = 600,
            tooltip = "Форточка",
            model = {
                var = "CabinWindowRight",
                sndid = "doorw_cab_r",
            }
        }, {
            ID = "CabinDoorRight",
            x = 0,
            y = 600,
            w = 710,
            h = 1430,
            tooltip = "Дверь в кабину машиниста\nCabin door",
            model = {
                var = "CabinDoorRight",
                sndid = "door_cab_r",
            }
        },
    }
}

ENT.ButtonMap["CabinDoorR1"] = {
    pos = Vector(460, -67.5, -52.3),
    ang = Angle(0, 180, -89),
    width = 710,
    height = 2030,
    scale = 0.1 / 2,
    buttons = {
        {
            ID = "CabinDoorRight",
            x = 0,
            y = 0,
            w = 710,
            h = 2030,
            tooltip = "Дверь в кабину машиниста\nCabin door",
            model = {
                var = "CabinDoorRight",
                sndid = "door_cab_r",
            }
        },
    }
}

for i = 0, 4 do
    -- ENT.ClientProps["TrainNumber" .. i] = {
    --     model = "models/metrostroi_train/81-760/numbers/number_0.mdl",
    --     pos = Vector(0, 0, 0),
    --     ang = Angle(-6, 0, 0),
    --     hide = 1.5,
    --     callback = function(ent) ent.WagonNumber = false end,
    -- }

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

--[[
table.insert(ENT.ClientProps,{
    model = "models/cricket_metrostroi/81-760/760_interior_lod0.mdl",
    pos = Vector(0,0,0),
    ang = Angle(0,0,0)
})
table.insert(ENT.ClientProps,{
    model = "models/cricket_metrostroi/81-760/760_interior_seats_lod0.mdl",
    pos = Vector(0,0,0),
    ang = Angle(0,0,0)
})]]
ENT.ClientProps["Salon"] = {
    model = "models/metrostroi_train/81-760/81_760a_int.mdl",
    pos = Vector(0, 0, 0), --Vector(55.5,0,-54.25),
    ang = Angle(0, 0, 0),
    hide = 2,
}

ENT.ClientProps["Cabin"] = {
    model = "models/metrostroi_train/81-765/cabin.mdl",
    pos = Vector(0, 0, 0), --Vector(55.5,0,-54.25),
    ang = Angle(0, 0, 0),
    hide = 2,
}

-- ENT.ClientProps["micro"] = {
--     model = "models/metrostroi_train/81-760/81_760_microphone.mdl",
--     pos = Vector(0, 0, 0),
--     ang = Angle(0, 0, 0),
--     hide = 2,
-- }

-- ENT.ClientProps["mfdu_stl"] = {
--     model = "models/metrostroi_train/81-760/81_760e_mfdu.mdl",
--     pos = Vector(0, 0, 0), --Vector(55.5,0,-54.25),
--     ang = Angle(0, 0, 0),
--     hide = 2,
-- }

-- ENT.ClientProps["label_stl"] = {
--     model = "models/metrostroi_train/81-760/81_760_label_stl.mdl",
--     pos = Vector(0, 0, 0),
--     ang = Angle(0, 0, 0),
--     hide = 2,
-- }


for idx = 1, 4 do
    ENT.ClientProps["RedLights" .. idx] = {
        model = "models/metrostroi_train/81-765/headlights_" .. idx .. "_red.mdl",
        pos = Vector(0, 0, 0),
        ang = Angle(0, 0, 0),
        nohide = true,
    }
    ENT.ClientProps["WhiteLights" .. idx] = {
        model = "models/metrostroi_train/81-765/headlights_" .. idx .. "_on.mdl",
        pos = Vector(0, 0, 0),
        ang = Angle(0, 0, 0),
        nohide = true,
    }
    ENT.ClientProps["OffLights" .. idx] = {
        model = "models/metrostroi_train/81-765/headlights_" .. idx .. "_off.mdl",
        pos = Vector(0, 0, 0),
        ang = Angle(0, 0, 0),
        nohide = true,
    }
end

ENT.ClientProps["HeadLights0"] = {
    model = "models/metrostroi_train/81-765/headlights_main_off.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    nohide = true,
}

ENT.ClientProps["HeadLights1"] = {
    model = "models/metrostroi_train/81-765/headlights_main_half.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    nohide = true,
}

ENT.ClientProps["HeadLights2"] = {
    model = "models/metrostroi_train/81-765/headlights_main_on.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    nohide = true,
}

ENT.ClientProps["HeadLightsRed"] = {
    model = "models/metrostroi_train/81-765/headlights_main_red.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    nohide = true,
}

table.insert(ENT.ClientProps, {
    model = "models/metrostroi_train/81-760/81_760_underwagon.mdl",
    pos = Vector(0, 0, 0), --Vector(-60,0,-79),
    ang = Angle(0, 0, 0),
    hide = 2,
})

ENT.ClientProps["nm_tm_rear"] = {
    model = "models/metrostroi_train/81-760/81_760a_crane_nm_tm.mdl",
    pos = Vector(0, 0, 0), --Vector(53,-12,-56.5),
    ang = Angle(0, 0, 0),
    hide = 2,
}

ENT.ClientProps["nm_tm"] = {
    model = "models/metrostroi_train/81-765/crane_nm_tm.mdl",
    pos = Vector(0, 0, 0), --Vector(53,-12,-56.5),
    ang = Angle(0, 0, 0),
    hide = 2,
}

ENT.ClientProps["fan_kti"] = {
    model = "models/metrostroi_train/81-760/81_760_fan_kti.mdl",
    pos = Vector(0, 0, 0), --Vector(53,-12,-56.5),
    ang = Angle(0, 0, 0),
    hide = 1.5,
}

ENT.ClientProps["fan_r"] = {
    model = "models/metrostroi_train/81-760/81_760_fan_r.mdl",
    pos = Vector(0, 0, 0), --Vector(-193.5,-39,-75.2),
    ang = Angle(0, 0, 0),
    hide = 1.5,
}

ENT.ButtonMap["GV"] = {
    pos = Vector(-166.9, 42, -52 - 15),
    ang = Angle(0, 90, 90),
    width = 170,
    height = 150,
    scale = 0.1,
    buttons = {
        {
            ID = "GVToggle",
            x = 0,
            y = 0,
            w = 170,
            h = 150,
            tooltip = "Разъединитель БРУ (ГВ)",
            model = {
                var = "GV",
                sndid = "gv_wrench",
                sndvol = 0.8,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
                snd = function(val) return val and "gv_f" or "gv_b" end,
            }
        },
    }
}

ENT.ClientProps["gv_wrench"] = {
    model = "models/metrostroi_train/reversor/reversor_classic.mdl",
    pos = Vector(-167.5, 49.47, -74.07),
    ang = Angle(-90, 180, 0),
    hide = 0.5,
}

--[[
local yventpos = {
    -414.5+0*117,
    -414.5+1*117+6.2,
    -414.5+2*117+5,
    -414.5+3*117+2,
    -414.5+4*117+0.5,
    -414.5+5*117-2.3,
    -414.5+6*117-2.3,
}
for i=1,7 do
    ENT.ClientProps["vent"..i] = {
        model = "models/metrostroi_train/81-720/vent.mdl",
        pos = Vector(yventpos[i],0,57.2),
        ang = Angle(0,0,0)
    }
end]]
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

ENT.ClientProps["door_cab_m"] = {
    model = "models/metrostroi_train/81-765/sdoor.mdl",
    pos = Vector(0, 0, 0), --Vector(380,5,-12.3),
    ang = Angle(0, 0, 0),
    hide = 2,
}

ENT.ClientProps["door_cab_l"] = {
    model = "models/metrostroi_train/81-765/ldoor.mdl",
    pos = Vector(0, 0, 0), --Vector(412.8,63.2,34.5),
    ang = Angle(0, 0, 0),
    hide = 2,
    modelcallback = function(ent)
        if ent.Anims and ent.Anims["door_cab_l.position_window"] then
            ent.Anims["door_cab_l.position_window"].reload = true
        end
    end
}

ENT.ClientProps["door_cab_r"] = {
    model = "models/metrostroi_train/81-765/rdoor.mdl",
    pos = Vector(0, 0, 0), --Vector(412.8,-63.2,34.5),
    ang = Angle(0, 0, 0),
    hide = 2,
    modelcallback = function(ent)
        if ent.Anims and ent.Anims["door_cab_r.position_window"] then
            ent.Anims["door_cab_r.position_window"].reload = true
        end
    end
}

--[[
	callback = function(ent,cl_ent)
		for k,v in pairs(cl_ent:GetMaterials() or {}) do
			if v == "models/metrostroi_train/81-760/hull" then
				cl_ent:SetSubMaterial(k-1,"models/metrostroi_train/81-760/hull_baklajan")
			end
		end	
	end,]]
ENT.ClientProps["door_add_1"] = {
    model = "models/metrostroi_train/81-765/cldoor.mdl",
    pos = Vector(0, 0, 0), --Vector(410.5,-57.4,23.3),
    ang = Angle(0, 0, 0),
    hide = 2,
}

-- ENT.ClientProps["door_add_2"] = {
--     model = "models/metrostroi_train/81-760/81_760_door_add_2.mdl",
--     pos = Vector(0, 0, 0), --Vector(387.2,-28.1,-2.2),
--     ang = Angle(0, 0, 0),
--     hide = 2,
-- }

-- ENT.ClientProps["door_pvz"] = {
--     model = "models/metrostroi_train/81-760/81_760_door_pvz.mdl",
--     pos = Vector(0, 0, 0), --Vector(385.93,7.5,-4),
--     ang = Angle(0, 0, 0),
--     hide = 2,
-- }

ENT.ClientProps["cab_chair_add"] = {
    model = "models/metrostroi_train/81-765/auxseat.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hideseat = 0.5,
}

-- ENT.ClientProps["wiper"] = {
--     model = "models/metrostroi_train/81-760/81_760_wiper.mdl",
--     pos = Vector(0, 0, 0),
--     ang = Angle(0, 0, 0),
--     hide = 2,
-- }

ENT.ClientProps["KRO"] = {
    model = "models/metrostroi_train/81-760/81_760_switch_kro.mdl",
    pos = Vector(485.6, 33.1, -12.38),
    ang = Angle(0, 0, 0),
    hideseat = 0.5,
}

ENT.ClientProps["KRR"] = {
    model = "models/metrostroi_train/81-760/81_760_switch_krr.mdl",
    pos = Vector(485.6, 36, -12.38),
    ang = Angle(0, 0, 0),
    hideseat = 0.5,
}

ENT.ClientProps["controller"] = {
    model = "models/metrostroi_train/81-722/81-722_controller.mdl",
    pos = Vector(482.4, 23.89, -14.2),
    ang = Angle(0, 90, 0),
    hide = 2,
}

ENT.ClientProps["km013"] = {
    model = "models/metrostroi_train/81-760/81_760_km_013.mdl",
    pos = Vector(475.09, -11.89, -16.46),
    ang = Angle(2.6, 11, 0),
    hideseat = 0.5,
}

if not ENT.ClientSounds["br_013"] then ENT.ClientSounds["br_013"] = {} end
table.insert(ENT.ClientSounds["br_013"], {"km013", function(ent, _, var) return "br_013" end, 1, 1, 50, 1e3, Angle(-90, 0, 0)})

ENT.ClientProps["PB"] = {
    model = "models/metrostroi_train/81-765/pb.mdl",
    pos = Vector(487, 31.88, -49.42),
    ang = Angle(0, 0, 0),
}

if not ENT.ClientSounds["PB"] then ENT.ClientSounds["PB"] = {} end
table.insert(ENT.ClientSounds["PB"], {"PB", function(ent, var) return var > 0 and "pb_on" or "pb_off" end, 1, 1, 50, 1e3, Angle(-90, 0, 0)})

ENT.ClientProps["fence"] = {
    model = "models/metrostroi_train/81-760/81_760_fence_corrugated_platform.mdl", --"models/metrostroi/mezhvag.mdl",
    pos = Vector(-480.15, 0, 0), -- -474.7 1.27 -467
    ang = Angle(0, 90, 0),
    hide = 2,
}

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
        pos = Vector(0, 0, 0),
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

ENT.ClientProps["SK1"] = {
    model = "models/metrostroi_train/81-760/81_760_brake_valve.mdl",
    pos = Vector(0, 0, -78),
    ang = Angle(0, 180, 0),
    hide = 1.1,
    callback = function(ent, cl_ent)
        local frontbogey = ent:GetNW2Entity("FrontBogey")
        if not IsValid(frontbogey) then
            ent:ShowHide("SK1", false)
            return
        end

        cl_ent:SetParent(frontbogey)
        cl_ent:SetPos(frontbogey:GetPos())
        local ang = frontbogey:GetAngles()
        cl_ent:SetAngles(Angle(-ang.x, 180 + ang.y, -ang.z))
    end,
}

local arrowsang = Angle(15.22, -46, 1.9432) -- 105.22 1.9432 -312.64
local fwd = arrowsang:Forward()
arrowsang:RotateAroundAxis(fwd, -56)
local bcarrow = Angle(arrowsang)
bcarrow:RotateAroundAxis(fwd, 8)
ENT.ClientProps["brake_cylinder"] = {
    model = "models/metrostroi_train/81-760/81_760_arrow_nm.mdl",
    pos = Vector(491.29, -13.54, -2.23) - fwd * 0.04,
    ang = bcarrow,
    hideseat = 0.2,
}

ENT.ClientProps["train_line"] = {
    model = "models/metrostroi_train/81-760/81_760_arrow_nm.mdl",
    pos = Vector(488.81, -13.54, -9.20) - fwd * 0.04,
    ang = arrowsang,
    hideseat = 0.2,
}

ENT.ClientProps["brake_line"] = {
    model = "models/metrostroi_train/81-760/81_760_arrow_tm.mdl",
    pos = Vector(488.81, -13.54, -9.20) - fwd * 0.08,
    ang = arrowsang,
    hideseat = 0.2,
}

ENT.ClientProps["lamp1"] = {
    model = "models/metrostroi_train/81-760/81_760_lamp_int_half.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hide = 2,
}

ENT.ClientProps["lamp2"] = {
    model = "models/metrostroi_train/81-760/81_760_lamp_int_full.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hide = 2,
}

ENT.ClientProps["cab_full"] = {
    model = "models/metrostroi_train/81-765/cablights_on.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hideseat = 1.1,
}

ENT.ClientProps["cab_half"] = {
    model = "models/metrostroi_train/81-765/cablights_half.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hideseat = 1.1,
}

ENT.ClientProps["cab_off"] = {
    model = "models/metrostroi_train/81-765/cablights.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hideseat = 1.1,
}

--color = Color(206,162,153),
-- ENT.ClientProps["box_int_1"] = {
--     model = "models/metrostroi_train/81-760/81_760_box_int_1.mdl",
--     pos = Vector(0, 0, 0),
--     ang = Angle(0, 0, 0),
--     hideseat = 1.1,
-- }

-- ENT.ClientProps["box_int_2"] = {
--     model = "models/metrostroi_train/81-760/81_760_box_int_2.mdl",
--     pos = Vector(0, 0, 0),
--     ang = Angle(0, 0, 0),
--     hideseat = 1.1,
-- }

ENT.ClientProps["zoomer_lamps"] = {
    model = "models/metrostroi_train/81-760/81_760_zoomer_lamps.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hide = 1.1,
}

local vmang = Angle(-11.549, -60, 8.2)
local rotvmang = Angle(-11.549, -119.91, 8.2)
vmang:RotateAroundAxis(rotvmang:Right(), -10)
vmang:RotateAroundAxis(rotvmang:Forward(), -6)
local vmoffset = rotvmang:Up() * -0.65 + rotvmang:Forward() * -0.35 + Vector(0, -0.08, 0)

ENT.ClientProps["volt_lv"] = {
    model = "models/metrostroi_train/81-760/81_760_arrow_electric.mdl",
    pos = Vector(496.93, 55.47, 32.3) + vmoffset,
    ang = vmang,
    hide = 0.2,
}

ENT.ClientProps["volt_hv"] = {
    model = "models/metrostroi_train/81-760/81_760_arrow_electric.mdl",
    pos = Vector(498.16, 55.34, 27.53) + vmoffset,
    ang = vmang,
    hide = 0.2,
}

ENT.ClientProps["ampermetr"] = {
    model = "models/metrostroi_train/81-760/81_760_arrow_electric.mdl",
    pos = Vector(389.2, 17.99, 19.6),
    ang = Angle(0, 90, 0),
    hide = 0.2,
}

ENT.Lights = {
    -- Headlight glow 
    [1] = {
        "headlight",
        Vector(520, 0, -12),
        Angle(0, 0, 90),
        Color(120, 153, 255),
        hfov = 80,
        vfov = 80,
        farz = 5144,
        brightness = 8
    },
    [2] = {
        "headlight",
        Vector(525, 0, -46),
        Angle(0, 0, 0),
        Color(255, 0, 0),
        fov = 170,
        brightness = 0.1,
        farz = 250,
        texture = "models/metrostroi_train/equipment/headlight2",
        shadows = 0,
        backlight = true
    },
    [3] = {
        "headlight",
        Vector(525, 0, -46),
        Angle(0, 0, 0),
        Color(197, 233, 233),
        fov = 170,
        brightness = 0.2,
        farz = 350,
        texture = "models/metrostroi_train/equipment/headlight2",
        shadows = 0,
        backlight = true
    },
    [11] = {
        "headlight", --brake_cylinder
        Vector(491.4, -13.7, 0),
        Angle(90, 240, 0),
        Color(235, 165, 60),
        farz = 6,
        nearz = 0.2,
        shadows = 0,
        brightness = 0.4,
        fov = 155
    },
    [12] = {
        "headlight", --nm tm
        Vector(488.96, -13.84, -7.04),
        Angle(90, 240, 0),
        Color(235, 165, 60),
        farz = 6,
        nearz = 0.2,
        shadows = 0,
        brightness = 0.4,
        fov = 155
    },
    [15] = {
        "headlight",
        Vector(407, -49, 52.8),
        Angle(90, 0, 0),
        Color(255, 255, 255),
        brightness = 0.2,
        fov = 20,
        farz = 350
    },
    --[13] = { "headlight",       Vector(476.9,7,-3.56), Angle(130,0,0), Color(180,180,255), farz = 25.6, nearz = 1, shadows = 0, brightness = 0.4, fov = 178},
    -- [3] = {
    --     "headlight",
    --     Vector(380, 40, 43.9),
    --     Angle(50, 40, -0),
    --     Color(206, 135, 80),
    --     hfov = 100,
    --     vfov = 100,
    --     farz = 200,
    --     brightness = 6,
    --     shadows = 1
    -- },
}

ENT.ButtonMap["MFDU"] = {
    pos = Vector(493.93, 3.77, -0.77),
    ang = Angle(0, -90, 70.431),
    width = 1024,
    height = 768,
    scale = 0.01185,
    hideseat = 0.2,
    system = "MFDU",
    hide = 0.5,
}

--239.3 расстояние между
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

ENT.ButtonMap["BUIK"] = {
    pos = Vector(494.37, 37.06, 0.4),
    ang = Angle(0, -90, 70.431),
    width = 2486,
    height = 496,
    scale = 0.01107,
    system = "BUIK",
    hide = 0.5,
}

ENT.ButtonMap["CAMS"] = {
    pos = Vector(484.8, 54.56, 0.15),
    ang = Angle(0, -59.84, 72.91),
    width = 1280,
    height = 1024,
    scale = 0.0106,
    system = "CAMS",
    hide = 0.5,
}

ENT.ButtonMap["BMIK"] = {
    pos = Vector(494.8, -9.4, 58.8),
    ang = Angle(0, 90, 90),
    width = 1800,
    height = 300,
    scale = 0.03,
    hide = 2,
}

ENT.ButtonMap["BNMIK"] = {
    pos = Vector(519.6, 14.6, -30.61),
    ang = Angle(0, 90, 84.57),
    width = 600,
    height = 300,
    scale = 0.03,
    hide = 2,
}

ENT.ButtonMap["BLIK"] = {
    pos = Vector(518.4, -9.1, -21.45),
    ang = Angle(0, 90, 83.41),
    width = 380,
    height = 380,
    scale = 0.048,
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

for _, cfg in pairs(ENT.PakToggles or {}) do
    if cfg.buttons and cfg.btnmap and ENT.ButtonMap[cfg.btnmap] and ENT.ButtonMap[cfg.btnmap].buttons then
        table.Add(ENT.ButtonMap[cfg.btnmap].buttons, cfg.buttons)
    end
end

for _, bm in ipairs({"PUU", "PUR", "PUR2", "RV"}) do
    local bl = ENT.ButtonMap[bm].buttons
    for idx = 1, #bl do
        if bl[idx].model then
            bl[idx].model.scale = 1.1
        end
    end
end

ENT.PakPositions = {
    [0] = 270,
    [1] = 235,
    [2] = 210,
    [3] = 180,
    [4] = 140,
    [5] = 115,
    [6] = 90,
}

function ENT:Initialize()
    self.BaseClass.Initialize(self)
    self.MFDU = self:CreateRT("765MFDU", 1024, 768)
    self.BUIK = self:CreateRT("765BUIK", 2486, 496)
    self.LBnt = self:CreateRT("765LBnt", 3840, 512)
    self.RBnt = self:CreateRT("765RBnt", 3840, 512)
    self.CAMS = self:CreateRT("760CAMS", 1024, 768)
    self.ASNP = self:CreateRT("760ASNP", 512, 128)
    self.IGLA = self:CreateRT("760IGLA", 512, 128)
    self.RVSScr = self:CreateRT("760RVS", 256, 256)
    self.BMIK = self:CreateRT("765BMIK", 1380, 230)
    self.BNMIK = self:CreateRT("765BNMIK", 380, 190)
    self.BLIK = self:CreateRT("765BLIK", 380, 380)
    self.ReleasedPdT = 0
    self.PreviousRingState = false
    self.PreviousCompressorState = false
    self.TISUVol = 0
    self.EmergencyValveRamp = 0
    self.EmergencyValveEPKRamp = 0
    self.EmergencyBrakeValveRamp = 0
    self.CraneRamp = 0
    self.CraneRRamp = 0
    self.FrontLeak = 0
    self.RearLeak = 0
    self.CompressorVol = 0
    self.ParkingBrake = 0
    self.BrakeCylinder = 0.5
    self.BPSNBuzzVolume = 0
    self.VentVolume = 0
    self.VentVolume2 = 0
    self.VentRand = {}
    self.VentState = {}
    self.VentVol = {}
    for i = 1, 7 do
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
    self.LastStation = self:GetNW2Int("LastStation")
    self.RouteNumber = self:GetNW2Int("RouteNumber")
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

    self.keyval = -1

    for i = 0, 4 do
        local num = tostring(self.Number)[i + 1]
        if not num or num == "" then num = "3" end
        -- if IsValid(self.ClientEnts["TrainNumber" .. i]) then
        --     local number = self.ClientEnts["TrainNumber" .. i]
        --     number:SetPos(self:LocalToWorld(Vector(509.8, -48 + i * 5.8, -16)))
        --     number:SetAngles(self:LocalToWorldAngles(Angle(-6, 0, 0)))
        --     --number:SetPos(self:LocalToWorld(Vector(509.7,-48+i*5.8,-21)))
        --     number:SetModel("models/metrostroi_train/81-760/numbers/number_" .. num .. ".mdl")
        -- end

        if IsValid(self.ClientEnts["TrainNumberL" .. i]) then
            local number = self.ClientEnts["TrainNumberL" .. i]
            number:SetPos(self:LocalToWorld(Vector(269 - i * 5.8, 68, -21)))
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

    if not IsValid(self.RearBogey) then self.RearBogey = self:GetNW2Entity("RearBogey") end
    if not IsValid(self.FrontBogey) then self.FrontBogey = self:GetNW2Entity("FrontBogey") end
end

local Cpos = {0, 0.28, 0.38, 0.48, 0.85, 1}
local controllerpos = {0, 0.22, 0.41, 0.6, 0.8, 1}
function ENT:IsNumberError()
    local err = false
    for i = 0, 4 do
        if IsValid(self.ClientEnts["TrainNumber" .. i]) and (self.ClientEnts["TrainNumber" .. i]:GetPos() == self:GetPos()) then
            err = true
            break
        end

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

    if (val and 1 or 0) ~= self.ShouldRenderClientEnt then
        self.ShouldRenderClientEnt = val and 1 or 0
        if not val then
            local glow1, glow2 = self:GetNW2Entity("GlowingLights1"), self:GetNW2Entity("GlowingLights2")
            if IsValid(glow1) and IsValid(glow2) and self.keyval ~= 0 then
                glow1:SetKeyValue("rendercolor", "0 0 0")
                glow2:SetKeyValue("rendercolor", "0 0 0")
                self.keyval = 0
            end
        end
    end
    return val
end

function ENT:ReInitBogeySounds(bogey)
    if not IsValid(bogey) then return end
    -- Bogey-related sounds
    bogey.SoundNames = {}
    bogey.EngineSNDConfig = {}
    bogey.MotorSoundType = bogey:GetNWInt("MotorSoundType", 2)
    for k, v in pairs(bogey.EngineSNDConfig) do
        bogey:SetSoundState(v[1], 0, 0)
    end

    table.insert(bogey.EngineSNDConfig, {
        "ted1_720", --40
        08,
        00,
        16,
        0.14
    })

    table.insert(bogey.EngineSNDConfig, {
        "ted2_720", --35
        16,
        08 - 4,
        24,
        0.13
    })

    table.insert(bogey.EngineSNDConfig, {
        "ted3_720", --32
        24,
        16 - 4,
        32,
        0.12
    })

    table.insert(bogey.EngineSNDConfig, {
        "ted4_720", --28
        32,
        24 - 4,
        40,
        0.10
    })

    table.insert(bogey.EngineSNDConfig, {
        "ted5_720", --22
        40,
        32 - 4,
        48,
        0.09
    })

    table.insert(bogey.EngineSNDConfig, {
        "ted6_720", --18
        48,
        40 - 4,
        56,
        0.06
    })

    table.insert(bogey.EngineSNDConfig, {
        "ted7_720", --15
        56,
        48 - 4,
        64,
        0.05
    })

    table.insert(bogey.EngineSNDConfig, {
        "ted8_720", --10
        64,
        56 - 4,
        72,
        0.04
    })

    table.insert(bogey.EngineSNDConfig, {
        "ted9_720", --07
        72,
        64 - 4,
        80,
        0.03
    })

    table.insert(bogey.EngineSNDConfig, {
        "ted10_720", --05
        80,
        72 - 4,
        88,
        0.02
    })

    --table.insert(bogey.EngineSNDConfig,{"ted11_720",88,80-4   ,0.01})--02
    bogey.SoundNames = {}
    bogey.SoundNames["ted1_703"] = "subway_trains/bogey/engines/703/speed_8.wav"
    bogey.SoundNames["ted2_703"] = "subway_trains/bogey/engines/703/speed_16.wav"
    bogey.SoundNames["ted3_703"] = "subway_trains/bogey/engines/703/speed_24.wav"
    bogey.SoundNames["ted4_703"] = "subway_trains/bogey/engines/703/speed_32.wav"
    bogey.SoundNames["ted5_703"] = "subway_trains/bogey/engines/703/speed_40.wav"
    bogey.SoundNames["ted6_703"] = "subway_trains/bogey/engines/703/speed_48.wav"
    bogey.SoundNames["ted7_703"] = "subway_trains/bogey/engines/703/speed_56.wav"
    bogey.SoundNames["ted8_703"] = "subway_trains/bogey/engines/703/speed_64.wav"
    bogey.SoundNames["ted9_703"] = "subway_trains/bogey/engines/703/speed_72.wav"
    bogey.SoundNames["ted10_703"] = "subway_trains/bogey/engines/703/speed_80.wav"
    bogey.SoundNames["ted11_703"] = "subway_trains/bogey/engines/703/speed_88.wav"
    --bogey.SoundNames["tedm_703"]  = "subway_trains/bogey/engines/703/engines_medium.wav"
    bogey.SoundNames["ted1_717"] = "subway_trains/bogey/engines/717/engines_8.wav"
    bogey.SoundNames["ted2_717"] = "subway_trains/bogey/engines/717/engines_16.wav"
    bogey.SoundNames["ted3_717"] = "subway_trains/bogey/engines/717/engines_24.wav"
    bogey.SoundNames["ted4_717"] = "subway_trains/bogey/engines/717/engines_32.wav"
    bogey.SoundNames["ted5_717"] = "subway_trains/bogey/engines/717/engines_40.wav"
    bogey.SoundNames["ted6_717"] = "subway_trains/bogey/engines/717/engines_48.wav"
    bogey.SoundNames["ted7_717"] = "subway_trains/bogey/engines/717/engines_56.wav"
    bogey.SoundNames["ted8_717"] = "subway_trains/bogey/engines/717/engines_64.wav"
    bogey.SoundNames["ted9_717"] = "subway_trains/bogey/engines/717/engines_72.wav"
    bogey.SoundNames["ted10_717"] = "subway_trains/bogey/engines/717/engines_80.wav"
    --bogey.SoundNames["ted11_720"] = "subway_trains/760/engines/engine_80.wav"
    bogey.SoundNames["ted1_720"] = "subway_trains/760/engines/engine_8.wav"
    bogey.SoundNames["ted2_720"] = "subway_trains/760/engines/engine_16.wav"
    bogey.SoundNames["ted3_720"] = "subway_trains/760/engines/engine_24.wav"
    bogey.SoundNames["ted4_720"] = "subway_trains/760/engines/engine_32.wav"
    bogey.SoundNames["ted5_720"] = "subway_trains/760/engines/engine_40.wav"
    bogey.SoundNames["ted6_720"] = "subway_trains/760/engines/engine_48.wav"
    bogey.SoundNames["ted7_720"] = "subway_trains/760/engines/engine_56.wav"
    bogey.SoundNames["ted8_720"] = "subway_trains/760/engines/engine_64.wav"
    bogey.SoundNames["ted9_720"] = "subway_trains/760/engines/engine_72.wav"
    bogey.SoundNames["ted10_720"] = "subway_trains/760/engines/engine_80.wav"
    --*0.975
    --*1.025
    bogey.SoundNames["flangea"] = "subway_trains/bogey/skrip1.wav"
    bogey.SoundNames["flangeb"] = "subway_trains/bogey/skrip2.wav"
    bogey.SoundNames["flange1"] = "subway_trains/bogey/flange_9.wav"
    bogey.SoundNames["flange2"] = "subway_trains/bogey/flange_10.wav"
    bogey.SoundNames["brakea_loop1"] = "subway_trains/bogey/braking_async1.wav"
    bogey.SoundNames["brakea_loop2"] = "subway_trains/bogey/braking_async2.wav"
    bogey.SoundNames["brake_loop1"] = "subway_trains/bogey/brake_rattle3.wav"
    bogey.SoundNames["brake_loop2"] = "subway_trains/bogey/brake_rattle4.wav"
    bogey.SoundNames["brake_loop3"] = "subway_trains/bogey/brake_rattle5.wav"
    bogey.SoundNames["brake_loop4"] = "subway_trains/bogey/brake_rattle6.wav"
    bogey.SoundNames["brake_loopb"] = "subway_trains/common/junk/junk_background_braking1.wav"
    bogey.SoundNames["brake2_loop1"] = "subway_trains/bogey/brake_rattle2.wav"
    bogey.SoundNames["brake2_loop2"] = "subway_trains/bogey/brake_rattle_h.wav"
    bogey.SoundNames["brake_squeal1"] = "subway_trains/bogey/brake_squeal1.wav"
    bogey.SoundNames["brake_squeal2"] = "subway_trains/bogey/brake_squeal2.wav"
    -- Remove old sounds
    if bogey.Sounds then
        for k, v in pairs(bogey.Sounds) do
            v:Stop()
        end
    end

    -- Create sounds
    bogey.Sounds = {}
    bogey.Playing = {}
    for k, v in pairs(bogey.SoundNames) do
        --if not file.Exists(v, "MOD") then
        --          bogey.SoundNames[k] = nil
        --end
        util.PrecacheSound(v)
        local e = bogey
        if (k == "brake3a") and IsValid(bogey:GetNW2Entity("TrainWheels")) then e = bogey:GetNW2Entity("TrainWheels") end
        bogey.Sounds[k] = CreateSound(e, Sound(v))
    end

    bogey.Async = nil
    --bogey.MotorSoundType = nil
end

function ENT:PlayDoorSound(bool, door)
    if self[door] ~= bool then
        self[door] = bool
        self:PlayOnce(door .. "_" .. (self[door] and "open" or "close"), "", 1, 1)
    end
end

function ENT:Think()
    self.BaseClass.Think(self)
    if not self.RenderClientEnts or self.CreatingCSEnts then
        self.Number = 0
        self.RouteNumber = 0
        self.LastStation = 0
        return
    end

    local refresh = false --true
    if IsValid(self.FrontBogey) and self.FrontBogey.SoundNames and (self.FrontBogey.SoundNames["ted1_720"] ~= "subway_trains/760/engines/engine_8.wav" or self.FrontBogey.EngineSNDConfig and self.FrontBogey.EngineSNDConfig[1] and self.FrontBogey.EngineSNDConfig[1][5] ~= 0.14) or refresh then self:ReInitBogeySounds(self.FrontBogey) end
    if IsValid(self.RearBogey) and self.RearBogey.SoundNames and (self.RearBogey.SoundNames["ted1_720"] ~= "subway_trains/760/engines/engine_8.wav" or self.RearBogey.EngineSNDConfig and self.RearBogey.EngineSNDConfig[1] and self.RearBogey.EngineSNDConfig[1][5] ~= 0.14) or refresh then self:ReInitBogeySounds(self.RearBogey) end
    if self.LastStation ~= self:GetNW2Int("LastStation") then self:UpdateTextures() end
    if self.RouteNumber ~= self:GetNW2Int("RouteNumber") then self:UpdateTextures() end
    if self.Number ~= self:GetWagonNumber() then self:UpdateTextures() end
    if self.Texture ~= self:GetNW2String("texture") then self:UpdateTextures() end
    if self.PassTexture ~= self:GetNW2String("passtexture") then self:UpdateTextures() end
    if self.CabinTexture ~= self:GetNW2String("cabtexture") then self:UpdateTextures() end
    if self.Scheme ~= self:GetNW2Int("Scheme", 1) then self:UpdateTextures() end
    if self.InvertSchemes ~= self:GetNW2Bool("PassSchemesInvert", false) then self:UpdateTextures() end
    if self:IsNumberError() then self:UpdateTextures() end
    local glow1, glow2 = self:GetNW2Entity("GlowingLights1"), self:GetNW2Entity("GlowingLights2")
    if IsValid(glow1) and IsValid(glow2) then
        if (IsValid(self.ClientEnts["HeadLights2"]) or IsValid(self.ClientEnts["HeadLights1"])) and self.keyval ~= 1 then
            glow1:SetKeyValue("rendercolor", "100 120 128")
            glow2:SetKeyValue("rendercolor", "100 120 128")
            self.keyval = 1
        elseif not (IsValid(self.ClientEnts["HeadLights2"]) or IsValid(self.ClientEnts["HeadLights1"])) and self.keyval ~= 0 then
            glow1:SetKeyValue("rendercolor", "0 0 0")
            glow2:SetKeyValue("rendercolor", "0 0 0")
            self.keyval = 0
        end
    end

    local ValidfB, ValidrB = IsValid(self.FrontBogey), IsValid(self.RearBogey)
    self:ShowHide("SK1", ValidfB)
    for i = 1, 4 do
        self:ShowHide("TR" .. i, i <= 2 and ValidfB or i >= 3 and ValidrB)
        self:ShowHide("brake_shoe" .. i, ValidfB)
        self:ShowHide("brake_shoe" .. (i + 4), ValidrB)
        self:Animate("TR" .. i, self:GetPackedBool("TR" .. i) and 1 or 0, 0, 1, 8, 0.5)
        self:Animate("brake_shoe" .. i, self:GetPackedBool("BC" .. i) and 1 or 0, 1, 0.722, 32, 2)
        self:Animate("brake_shoe" .. (i + 4), self:GetPackedBool("BC" .. (i + 4)) and 1 or 0, 1, 0.722, 32, 2)
    end

    local RearTrain, fence = self:GetNW2Entity("RearTrain"), self.ClientEnts["fence"]
    self:ShowHide("fence", IsValid(RearTrain) and ((RearTrain:GetClass():find("760a") or RearTrain:GetClass():find("760e")) and not IsValid(RearTrain.ClientEnts["fence"]) and RearTrain:GetNW2Entity("FrontTrain") ~= self or RearTrain:GetClass():find("761a") or RearTrain:GetClass():find("763a") or RearTrain:GetClass():find("761e") or RearTrain:GetClass():find("763e")) and true)
    if IsValid(fence) and IsValid(RearTrain) then
        local a = 1
        if RearTrain:GetNW2Entity("RearTrain") == self then a = -1 end
        local ang1 = fence:WorldToLocalAngles(RearTrain:LocalToWorldAngles(Angle(0, 0 * a, 0)))
        local vec = fence:WorldToLocal(RearTrain:LocalToWorld(Vector(480.15 * a, 0, 0)))
        local a = 1
        if RearTrain:GetNW2Entity("RearTrain") == self then a = -1 end
        local ang1 = fence:WorldToLocalAngles(RearTrain:LocalToWorldAngles(Angle(0, 90 * a, 0)))
        local vec = fence:WorldToLocal(RearTrain:LocalToWorld(Vector(480.1 * a, a * ang1.p * 1.585, 0.6)))
        fence:ManipulateBoneAngles(0, Angle(-ang1.r / 2, ang1.y / 2, ang1.p / 3) + Angle(0, 90, 0))
        fence:ManipulateBonePosition(0, Vector(vec.x / 2, vec.y / 2, vec.z / 2))
    end

    self:Animate("SK1", self:GetPackedBool("SK1") and 1 or 0, 0, 1, 8, 0.5)
    local col = render.GetLightColor(self:GetPos() + 530 * self:GetForward())
    local val = math.floor((col.x * 255 + col.y * 255 + col.z * 255) * 5) / 5
    if self.val ~= val and CurTime() - (self.valTimer or 0) > 0 or not self.val then
        self.valTimer = CurTime() + 0.5
        self.val = val
    end

    local headl = math.max(0, self:GetPackedRatio("Headlights") + (self.val >= 6 and self:GetPackedRatio("Headlights") == 1 and -0.5 or 0))
    self:SetLightPower(1, headl > 0, headl)

    local redShouldOn = self:GetPackedBool("BacklightsEnabled")
    local hl1 = (self:GetPackedBool("HeadLightsEnabled1") or self:GetPackedBool("HeadLightsEnabled2") and self.val >= 6)
    local hl2 = self:GetPackedBool("HeadLightsEnabled2") and self.val < 6
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

    local dT = self.DeltaTime

    if IsValid(self.GlowingLights[1]) then
        self.GlowingLights[1]:SetEnableShadows(true)
        if headl < 1 and self.GlowingLights[1]:GetFarZ() > 2850 then self.GlowingLights[1]:SetFarZ(2850) end
        if headl == 1 and self.GlowingLights[1]:GetFarZ() < 8192 then self.GlowingLights[1]:SetFarZ(8192) end
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
    --ANIMS
    self:Animate("brake_line", self:GetPackedRatio("BL"), 0, 0.853, 256, 2)
    self:Animate("train_line", self:GetPackedRatio("TL"), 0, 0.853, 256, 2)
    self:Animate("brake_cylinder", self:GetPackedRatio("BC"), 0, 0.827, 256, 2)
    self:Animate("controller", controllerpos[self:GetPackedRatio("Controller") + 4] or 0, 0.316, 0.66, 2, false)
    self:Animate("EmergencyBrakeValve", self:GetPackedBool("EmergencyBrakeValve") and 1 or 0, 0, 1, 6, false)
    local speed = self:GetPackedRatio("Speed", 0)
    if IsValid(self.ClientEnts["fan_kti"]) and self:GetPackedBool("WorkFan", false) then self.ClientEnts["fan_kti"]:SetPoseParameter("position", 1.0 - (speed > 10 and CurTime() % 0.5 * 2 or CurTime() % 1)) end
    if IsValid(self.ClientEnts["fan_r"]) and self:GetPackedBool("WorkFan", false) then self.ClientEnts["fan_r"]:SetPoseParameter("position", 1.0 - (speed > 10 and CurTime() % 0.5 * 2 or CurTime() % 1)) end
    self:Animate("FrontBrake", self:GetNW2Bool("FbI") and 0 or 1, 0, 1, 3, false)
    self:Animate("FrontTrain", self:GetNW2Bool("FtI") and 0 or 1, 0, 1, 3, false)
    self:Animate("RearBrake", self:GetNW2Bool("RbI") and 0 or 1, 0, 1, 3, false)
    self:Animate("RearTrain", self:GetNW2Bool("RtI") and 0 or 1, 0, 1, 3, false)
    self:Animate("K23Valve", self:GetNW2Bool("K23") and 0 or 1, 0, 1, 3, false)
    if self.LastValue ~= self:GetPackedBool("GV") then
        self.ResetTime = CurTime() + 1.5
        self.LastValue = self:GetPackedBool("GV")
    end

    self:Animate("gv_wrench", self:GetPackedBool("GV") and 0 or 1, 0, 0.5, 128, 1, false)
    self:ShowHideSmooth("gv_wrench", CurTime() < self.ResetTime and 1 or 0.1)
    --self:Animate("controller", (self:GetPackedRatio("Controller")+3)/6, 0.75, 0.15,  2,false)
    --self:SetPackedRatio("BL", self.Pneumatic.BrakeLinePressure/16.0)
    --self:SetPackedRatio("TL", self.Pneumatic.TrainLinePressure/16.0)
    --self:SetPackedRatio("BC", math.min(3.2,self.Pneumatic.BrakeCylinderPressure)/6.0)
    self:Animate("RVTB", self:GetPackedBool("K9") and 0 or 1, 0, 1, 16, 0.5)
    self:Animate("K29", self:GetPackedBool("K29") and 1 or 0, 0, 1, 16, 0.5)
    self:Animate("K31", self:GetPackedBool("K31") and 0 or 1, 0, 1, 16, 0.5)
    self:Animate("K35", self:GetPackedBool("UAVA") and 1 or 0, 0, 1, 32, 0.5)
    self:Animate("KRO", self:GetPackedRatio("KRO", 0), 0, 1, 6, false)
    self:Animate("KRR", self:GetPackedRatio("KRR", 0), 0, 1, 3, false)
    --self:ShowHide("KRO",self:GetNW2Int("Wrench",0) == 1)
    --self:ShowHide("KRR",self:GetNW2Int("Wrench",0) == 2)
    self:Animate("km013", Cpos[7 - self:GetPackedRatio("Cran")] or 0, 0, 1, 2, false)
    self:Animate("PB", self:GetPackedBool("PB") and 1 or 0, 0, 1, 8, false)
    self:ShowHideSmooth("lamp1", self:Animate("LampsEmer", self:GetPackedBool("SalonLighting1") and 1 or 0, 0, 1, 5, false))
    self:ShowHideSmooth("lamp2", self:Animate("LampsFull", self:GetPackedBool("SalonLighting2") and 1 or 0, 0, 1, 5, false))
    local cabl_full = self:GetPackedBool("CabinEnabledFull")
    local cabl_half = not cabl_full and self:GetPackedBool("CabinEnabledEmer")
    local cabl_off = not cabl_full and not cabl_half
    cabl_full = self:Animate("CabFull", cabl_full and 1 or 0, 0, 1, 5, false)
    cabl_half = self:Animate("CabEmer", cabl_half and 1 or 0, 0, 1, 5, false)
    cabl_off = self:Animate("CabOff", cabl_off and 1 or 0, 0, 1, 5, false)
    self:ShowHideSmooth("cab_full", cabl_full)
    self:ShowHideSmooth("cab_half", cabl_half)
    self:ShowHideSmooth("cab_off", cabl_off)
    self:ShowHideSmooth("zoomer_lamps", self:Animate("zoomerl", self:GetNW2Bool("DoorAlarmState") and 1 or 0, 0, 1, 16, false))
    -- self:ShowHide("micro", not self:GetNW2Bool("Micro", false))

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
        self:HidePanel("DoorAddressOpen" .. idx, open or not self:GetNW2Bool("AddressDoors", false))
        self:HidePanel("DoorAddressOpenOutside" .. idx, open or not self:GetNW2Bool("AddressDoors", false))
        local btnKey = "DoorArrdessButton" .. idx
        self:ShowHide(btnKey, self:GetNW2Bool("AddressDoors", false))
        local btn = self.ClientEnts[btnKey]
        if IsValid(btn) then
            btn:SetSubMaterial(1, self:GetNW2Bool("DoorButtonLed" .. (idx < 5 and 9 - idx or idx - 4), false) and "models/metrostroi_train/81-765/led_green" or "models/metrostroi_train/81-765/led_off")
        end
    end

    local door_cab_m = self:Animate("door_cab_m", self:GetPackedBool("PassengerDoor") and 1 or 0, 0, 1, 2, 0.5)
    self:PlayDoorSound(door_cab_m > 0.2, "door_cab_m")
    local door_cab_l = self:Animate("door_cab_l", self:GetPackedBool("CabinDoorLeft") and 1 or 0, 0, 1, 2, 0.5)
    self:PlayDoorSound(door_cab_l > 0.2, "door_cab_l")
    self:HidePanel("PpzCover", door_cab_l == 0)
    local door_cab_r = self:Animate("door_cab_r", self:GetPackedBool("CabinDoorRight") and (self:GetPackedBool("CabinDoorRightLimit") and 0.6 or 1) or 0, 0, 1, 2, 0.5)
    self:PlayDoorSound(door_cab_r > 0.2, "door_cab_r")
    local cab_chair_add = self:Animate("cab_chair_add", self:GetPackedBool("cab_chair_add") and 1 or 0, 0, 1, 4, 0.5)
    local door_pvz = self:Animate("door_pvz", (self:GetPackedBool("door_pvz") or self.CurrentCamera == 7) and 1 or 0, 0, 1, 2, 0.5)
    self:PlayDoorSound(door_pvz > 0, "door_pvz")
    local door_add_1 = self:Animate("door_add_1", self:GetPackedBool("door_add_1") and 1 or 0, 0, 1, 2, 0.5)
    self:PlayDoorSound(door_add_1 > 0, "door_add_1")
    local door_add_2 = self:Animate("door_add_2", self:GetPackedBool("door_add_2") and 1 or 0, 0, 1, 2, 0.5)
    self:PlayDoorSound(door_add_2 > 0, "door_add_2")
    self:HidePanel("Door_add_1", door_add_1 > 0)
    self:HidePanel("Door_add_1o", door_add_1 < 1)
    -- self:HidePanel("Door_add_2", door_add_2 > 0)
    -- self:HidePanel("Door_add_2o", door_add_2 < 1)
    self:ShowHide("K35", door_add_1 + door_add_2 > 0)
    self:HidePanel("K35", door_add_1 + door_add_2 == 0)
    self:ShowHide("box_int_1", door_pvz > 0)
    self:ShowHide("box_int_2", door_add_1 + door_add_2 > 0)
    -- self:HidePanel("Door_pvz", door_pvz > 0)
    -- self:HidePanel("Door_pvzo", door_pvz < 1)
    self:ShowHide("ampermetr", door_pvz > 0)
    -- self:SetLightPower(15, self:GetPackedBool("AppLights") and door_pvz > 0)
    local K31_cap = self:Animate("K31_cap", self:GetPackedBool("door_k31") and 1 or 0, 0, 1, 4, 0.5)
    self:ShowHide("K31", K31_cap > 0)
    self:HidePanel("K31", K31_cap < 1)

    self:AnimateCustom("door_cab_l", "position_window", self:GetPackedBool("CabinWindowLeft") and 1 or 0, 0, 1, 8, 0.5)
    self:AnimateCustom("door_cab_r", "position_window", self:GetPackedBool("CabinWindowRight") and 1 or 0, 0, 1, 8, 0.5)

    --[[
    if (self:GetPackedBool("WorkBeep") and self:GetPackedBool("wiper")) and self.Anims["wiper"] and self:GetPackedBool("WiperPower") then
        local anim = self.Anims["wiper"].value
        if anim == 0 then
            self.WiperDir = true
        elseif anim == 1 then
            self.WiperDir = false
        end
        self:Animate("wiper", self.WiperDir and 1 or 0, 0, 1, 0.32, false)
    elseif self:GetPackedBool("WiperPower") then
        self:Animate("wiper", 0, 0, 1, 0.32, false)
    end]]

    local state = self:GetPackedBool("WorkCabVent", false)
    self.VentTimer = self:GetPackedRatio("VentTimer", 0) > 0 and self:GetPackedRatio("VentTimer")
    if self.VentVolume < 1 and state then
        self.VentVolume = math.min(1, self.VentVolume + dT) --5*dT
    elseif self.VentVolume > 0 and not state then
        self.VentVolume = math.max(0, self.VentVolume - dT) --3*dT
    end

    local state = self.VentTimer and CurTime() - self.VentTimer > 4 and CurTime() - self.VentTimer < 11
    if self.VentVolume2 < 1 and state then
        self.VentVolume2 = math.min(1, self.VentVolume2 + dT) --5*dT	
    elseif self.VentVolume2 > 0 and not state then
        self.VentVolume2 = math.max(0, self.VentVolume2 - 0.75 * dT) --3*dT		
    end

    if self.VentTimer then
        if CurTime() - self.VentTimer <= 4 then
            self:SetSoundState("vent_loop", 0.07 * self.VentVolume, 0.9 + self.VentVolume / 10)
            self:SetSoundState("vent_loop_max", 0.0, 1)
        elseif CurTime() - self.VentTimer > 11 then
            --self:SetSoundState("vent_loop",0.07,1)
            --self:SetSoundState("vent_loop_max",0.33*self.VentVolume2/2,0.9+self.VentVolume2/10)
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
    self:HidePanel("PVZ", door_pvz == 0)
    self:Animate("volt_lv", self:GetPackedRatio("LV"), 0, 1, 16, 1) --0.035,0.965,16,1)
    self:Animate("volt_hv", self:GetPackedRatio("HV"), 0, 1, 16, 6) --0.035,0.965,16,1)
    self:Animate("ampermetr", self:GetPackedRatio("IVO"), 0, 1, 16, 1) --0.035,0.965,16,1)
    --print(dPdT)
    local parking_brake = math.max(0, -self:GetPackedRatio("ParkingBrakePressure_dPdT", 0))
    self.ParkingBrake = self.ParkingBrake + (parking_brake - self.ParkingBrake) * dT * 10
    self:SetSoundState("parking_brake", self.ParkingBrake, 1.4)
    local dPdT = self:GetPackedRatio("BrakeCylinderPressure_dPdT")
    self.ReleasedPdT = math.Clamp(self.ReleasedPdT + 10 * (-self:GetPackedRatio("BrakeCylinderPressure_dPdT", 0) - self.ReleasedPdT) * dT * 1.5, 0, 1)
    local release1 = math.Clamp(self.ReleasedPdT, 0, 1) ^ 2
    self:SetSoundState("release", release1, 1)
    self.FrontLeak = math.Clamp(self.FrontLeak + 10 * (-self:GetPackedRatio("FrontLeak") - self.FrontLeak) * dT, 0, 1)
    self.RearLeak = math.Clamp(self.RearLeak + 10 * (-self:GetPackedRatio("RearLeak") - self.RearLeak) * dT, 0, 1)
    self:SetSoundState("front_isolation", self.FrontLeak, 0.9 + 0.2 * self.FrontLeak)
    self:SetSoundState("rear_isolation", self.RearLeak, 0.9 + 0.2 * self.RearLeak)
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
    local state = self:GetPackedBool("RingEnabled")
    self:SetSoundState("ring", state and 1 or 0, 1)
    local state = self:GetPackedBool("CompressorWork")
    if self.CompressorVol < 1 and state then
        self.CompressorVol = math.min(1, self.CompressorVol + (self.CompressorVol < 0.2 and 0.1 or 0.2) * dT) --5*dT
    elseif self.CompressorVol > 0 and not state then
        self.CompressorVol = math.max(0, self.CompressorVol - dT) --3*dT
    end

    --if state then
    self:SetSoundState("compressor", self.CompressorVol / 6, 0.8 + 0.2 * self.CompressorVol)
    --else
    --self:SetSoundState("compressor",0,0)
    --end
    self.PreviousCompressorState = state
    local state = self:GetPackedBool("WorkBeep")
    self:SetSoundState("work_beep", state and 1 or 0, 1)
    --[[
	self:SetModelScale(0.1)
	for k,v in pairs(self.ClientEnts) do
		v:SetModelScale(0.1)
	end]]
    --print(self:GetAmbientLight())
    local speed = self:GetPackedRatio("Speed", 0)
    --[[
    local ventSpeedAdd = math.Clamp(speed/30,0,1)

    local v1state = self:GetPackedBool("Vent1Work")
    local v2state = self:GetPackedBool("Vent2Work")
    for i=1,7 do
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
            --self.ClientEnts["vent"..i]:SetPoseParameter("position",self.VentState[i])
        end
    end]]
    --Vector(409,25.6,-26.3)
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
    local state = self:GetPackedRatio("asynccurrent") --^1.5--RealTime()%2.5/2	
    local strength = self:GetPackedRatio("asyncstate") * (1 - math.Clamp((speed - 23) / 23, 0, 1)) * 0.5
    --print(state/0.3+0.2)
    local asyncType = self:GetNW2Int("VVVFSound", 1)
    if asyncType == 1 then
        self:SetSoundState("async1", tunstreet * math.Clamp(state / 0.26 + 0.2, 0, 1) * strength, 1) --+math.Clamp(state,0,1)*0.1)
    else
        self:ExperimentalAsync(asyncType, tunstreet, speed)
    end

    --[[
    local state = 1-self:GetPackedRatio("RNState")
    self.TISUVol = math.Clamp(self.TISUVol+(state-self.TISUVol)*dT*8,0,1)
    self:SetSoundState("tisu", self.TISUVol, 1)
    self:SetSoundState("tisu2", self.TISUVol, 1)
    self:SetSoundState("tisu3", 0 or self.TISUVol, 1)
    ]]
    --self:SetSoundState("bbe", self:GetPackedBool("BBEWork") and 1 or 0, 1)
    local work = self:GetPackedBool("AnnPlay")
    local head = self:GetPackedBool("AnnPlayHead")
    for k, v in ipairs(self.AnnouncerPositions) do
        if self.Sounds["announcer" .. k] and IsValid(self.Sounds["announcer" .. k]) then self.Sounds["announcer" .. k]:SetVolume((work and (k > 1 or k == 1 and head)) and (v[3] or 1) or 0) end
    end

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

function ENT:ExperimentalAsync(asyncType, tunstreet, speed)
    if asyncType == 5 then  -- Hitachi GTO
        local vvvfamps = self:GetPackedRatio("asynccurrent")
        local vvvfvol = math.Clamp(vvvfamps, 0, 1)
        local vvvfmode = self:GetPackedRatio("asyncstate")
        self:SetSoundState("vvvf1", vvvfvol * math.Clamp((5.4 - speed) / 5.4, 0, 1), 1)
        if vvvfmode > 0 then
            self:SetSoundState("vvvf1", vvvfvol * math.Clamp((5.4 - speed) / 5.4, 0, 1), 1)
        else
            self:SetSoundState("vvvf1", 0, 1)
        end

        if speed < 5.5 and vvvfmode > 0 then
            self:SetSoundState("vvvf2", vvvfvol * math.Clamp(speed, 0, 1), 1)
        else
            self:SetSoundState("vvvf2", 0, 1)
        end

        if speed > 5.5 and speed < 7.6 and vvvfmode ~= 0 then
            self:SetSoundState("vvvf3", vvvfvol, speed / 6.5)
        else
            self:SetSoundState("vvvf3", 0, speed / 6.5)
        end

        if speed > 7.6 and speed < 12.2 and vvvfmode > 0 then
            self:SetSoundState("vvvf4", vvvfvol, speed / 12)
        else
            self:SetSoundState("vvvf4", 0, speed / 12)
        end

        if speed > 12.2 and speed < 20.4 and vvvfmode > 0 then
            self:SetSoundState("vvvf5", vvvfvol, speed / 17.775)
        else
            self:SetSoundState("vvvf5", 0, speed / 17.775)
        end

        if speed > 20.4 and speed < 27.4 and vvvfmode > 0 then
            self:SetSoundState("vvvf6", vvvfvol, speed / 28.883)
        else
            self:SetSoundState("vvvf6", 0, speed / 28.883)
        end

        if speed > 27.4 and speed < 34.3 and vvvfmode > 0 then
            self:SetSoundState("vvvf7", vvvfvol * Lerp((speed - 27.4) / (34.3 - 27.4), 1, 0), speed / 30)
        else
            self:SetSoundState("vvvf7", 0, speed / 30)
        end

        if speed > 33.9 and speed < 41.0 and vvvfmode > 0 then
            self:SetSoundState("vvvf8", vvvfvol * Lerp((speed - 33.9) / (34.3 - 33.9), 0, 1) * Lerp((speed - 34.3) / (41 - 34.3), 1, 0), speed / 33.9)
        else
            self:SetSoundState("vvvf8", 0, speed / 33.9)
        end

        if speed > 38.0 and speed < 70.0 and vvvfmode ~= 0 then
            self:SetSoundState("vvvf9", vvvfvol * Lerp((speed - 38.0) / (42.0 - 38.0), 0, 1) * Lerp((speed - 55.0) / (70.0 - 55.0), 1, 0), speed / 55)
        else
            self:SetSoundState("vvvf9", 0, speed / 55)
        end

        if speed > 12 and speed < 18 and vvvfmode > 0 then
            self:SetSoundState("vvvf10", vvvfvol * Lerp((speed - 15) / (18 - 15), 1, 0), speed / 15)
        else
            self:SetSoundState("vvvf10", 0, speed / 15)
        end

        if speed > 20 and speed < 27 and vvvfmode > 0 then
            self:SetSoundState("vvvf11", vvvfvol * Lerp((speed - 20.5) / (27 - 20.5), 1, 0), speed / 22.638)
        else
            self:SetSoundState("vvvf11", 0, speed / 22.638)
        end

        if speed > 27 and speed < 34.3 and vvvfmode > 0 then
            self:SetSoundState("vvvf12", vvvfvol * Lerp((speed - 27) / (33.9 - 27), 0, 1), speed / 35)
        else
            self:SetSoundState("vvvf12", 0, speed / 35)
        end

        if speed > 33.9 and speed < 42 and vvvfmode > 0 then
            self:SetSoundState("vvvf13", vvvfvol * Lerp((speed - 33.9) / (38 - 33.9), 0, 1), speed / 40.2)
        else
            self:SetSoundState("vvvf13", 0, speed / 40.2)
        end

        if speed > 7.5 and speed < 10 and vvvfmode > 0 then
            self:SetSoundState("vvvf14", vvvfvol * Lerp((speed - 7.5) / (10 - 7.5), 1, 0), speed / 7)
        else
            self:SetSoundState("vvvf14", 0, speed / 7)
        end

        if speed > 5.4 and speed < 7.5 and vvvfmode > 0 then
            self:SetSoundState("vvvf15", vvvfvol * Lerp((speed - 5.4) / (7.5 - 5.4), 1, 0), speed / 6)
        else
            self:SetSoundState("vvvf15", 0, speed / 6)
        end

        if speed > 41.5 and speed < 55 and vvvfmode ~= 0 then
            self:SetSoundState("vvvf16", vvvfvol * Lerp((speed - 42) / (55 - 42), 1, 0), speed / 50)
        else
            self:SetSoundState("vvvf16", 0, speed / 50)
        end

        if speed > 55 and vvvfmode ~= 0 then
            self:SetSoundState("vvvf17", vvvfvol * Lerp((speed - 55) / (65 - 55), 0, 1), speed / 64)
        else
            self:SetSoundState("vvvf17", 0, speed / 64)
        end

        if speed > 55 and speed < 90 and vvvfmode ~= 0 then
            self:SetSoundState("vvvf18", vvvfvol * Lerp((speed - 55) / (70 - 55), 0, 1) * Lerp((speed - 70) / (90 - 70), 1, 0), speed / 69)
        else
            self:SetSoundState("vvvf18", 0, speed / 69)
        end

        if speed > 75 and speed < 120 and vvvfmode ~= 0 then
            self:SetSoundState("vvvf19", vvvfvol * Lerp((speed - 75) / (85 - 75), 0, 1) * Lerp((speed - 105) / (120 - 105), 1, 0), speed / 85)
        else
            self:SetSoundState("vvvf19", 0, speed / 85)
        end

        if speed > 44.5 and speed < 48.5 and vvvfmode < 0 then
            self:SetSoundState("vvvf21", vvvfvol, speed / 48)
        else
            self:SetSoundState("vvvf21", 0, speed / 48)
        end

        if speed > 35 and speed < 44.5 and vvvfmode < 0 then
            self:SetSoundState("vvvf22", vvvfvol * Lerp((speed - 34.8) / (35.3 - 34.8), 0, 1), speed / 42)
        else
            self:SetSoundState("vvvf22", 0, speed / 42)
        end

        if speed > 22.4 and speed < 35 and vvvfmode < 0 then
            self:SetSoundState("vvvf23", vvvfvol, speed / 31.5)
        else
            self:SetSoundState("vvvf23", 0, speed / 31.5)
        end

        if speed > 22.4 and speed < 35 and vvvfmode < 0 then
            self:SetSoundState("vvvf24", vvvfvol * Lerp((speed - 26) / (35 - 26), 1, 0), speed / 25.2)
        else
            self:SetSoundState("vvvf24", 0, speed / 25.2)
        end

        if speed > 12.4 and speed < 22.4 and vvvfmode < 0 then
            self:SetSoundState("vvvf25", vvvfvol, speed / 19.5)
        else
            self:SetSoundState("vvvf25", 0, speed / 19.5)
        end

        if speed > 12.4 and speed < 22.4 and vvvfmode < 0 then
            self:SetSoundState("vvvf26", vvvfvol, speed / 15.21)
        else
            self:SetSoundState("vvvf26", 0, speed / 15.21)
        end

        if speed > 8 and speed < 12.4 and vvvfmode < 0 then
            self:SetSoundState("vvvf27", vvvfvol * Lerp((speed - 8) / (10 - 8), 0, 1), speed / 11.5)
        else
            self:SetSoundState("vvvf27", 0, speed / 11.5)
        end

        if speed > 0 and speed < 12.4 and vvvfmode < 0 then
            self:SetSoundState("vvvf28", vvvfvol * Lerp((speed - 8) / (12.4 - 8), 1, 0), speed / 8)
        else
            self:SetSoundState("vvvf28", 0, speed / 8)
        end

    elseif asyncType == 2 then  -- Alstom ONIX
        local state = self:GetPackedRatio("asynccurrent") --^1.5--RealTime()%2.5/2	
        --if self:GetNW2Bool("FirstONIX",0) == true then
        local strength = self:GetPackedRatio("asyncstate") * math.Clamp((self:GetNW2Bool("FirstONIX", 0) == true and (speed - 24) or (speed - 9)) / 1, 0, 1) * (1 - math.Clamp((speed - 23) / 23, 0, 1)) * 0.5
        local strengthls = self:GetPackedRatio("asyncstate") * (1 - math.Clamp((self:GetNW2Bool("FirstONIX", 0) == true and (speed - 23.9) or (speed - 8.9)) / 1, 0, 1)) * 0.5
        --else
        -- local strength = self:GetPackedRatio("asyncstate")*(math.Clamp((speed-9)/1,0,1))*(1-math.Clamp((speed-23)/23,0,1))*0.5
        --local strengthls = self:GetPackedRatio("asyncstate")*(1-math.Clamp((speed-8.9)/1,0,1))*0.5
        --end
        self:SetSoundState("KATP", tunstreet * math.Clamp(state / 0.26 + 0.2, 0, 1) * strength, 1) --+math.Clamp(state,0,1)*0.1)
        self:SetSoundState("KATP_lowspeed", tunstreet * math.Clamp(state / 0.26 + 0.2, 0, 1) * strengthls, 1) --+math.Clamp(state,0,1)*0.1)
        self:SetSoundState("chopper_onix", tunstreet * self:GetPackedRatio("chopper"), 1)

    elseif asyncType == 3 then  -- КАТП-1
        --local state = (RealTime()%4/3)^1.5
        --local strength = 1--self:GetPackedRatio("asyncstate")*(1-math.Clamp((speed-15)/15,0,1))
        local state = self:GetPackedRatio("asynccurrent") --^1.5--RealTime()%2.5/2	
        local strength = self:GetPackedRatio("asyncstate") * (1 - math.Clamp((speed - 23) / 23, 0, 1)) * 0.5
        self:SetSoundState("ONIX", tunstreet * math.Clamp(state / 0.26 + 0.2, 0, 1) * strength, 1) --+math.Clamp(state,0,1)*0.1)
        self:SetSoundState("chopper_katp", tunstreet * self:GetPackedRatio("chopper"), 1)
        if self:GetNW2Bool("HSEngines", 0) == true then
            self:SetSoundState("async_p2", tunstreet * (math.Clamp((speed - 8) / 5, 0, 1) * 0.1 + math.Clamp((speed - 25) / 10, 0, 1) * 0.9) * (1 - math.Clamp((speed - 30) / 4, 0, 1)) * self:GetPackedRatio("asyncstate"), speed / 36)
            self:SetSoundState("async_p2_1", tunstreet * (math.Clamp((speed - 3) / 5, 0, 1) * 0.1 + math.Clamp((speed - 5) / 10, 0, 1) * 0.9) * (1 - math.Clamp((speed - 7) / 4, 0, 1)) * self:GetPackedRatio("asyncstate"), speed / 12)
            self:SetSoundState("async_p3", tunstreet * (math.Clamp((speed - 13) / 5, 0, 1) * 0.1 + math.Clamp((speed - 23) / 10, 0, 1) * 0.9) * (1 - math.Clamp((speed - 35) / 4, 0, 1)) * self:GetPackedRatio("asyncstate"), speed / 42)
            self:SetSoundState("async_p3_1", tunstreet * (math.Clamp((speed - 32) / 10, 0, 1) * 0.9) * (1 - math.Clamp((speed - 40) / 4, 0, 1)) * self:GetPackedRatio("asyncstate"), speed / 49)
        end

    elseif asyncType == 4 then  -- КАТП-3
        local state = self:GetPackedRatio("asynccurrent") --^1.5--RealTime()%2.5/2	
        local strength = self:GetPackedRatio("asyncstate") * math.Clamp((speed - 9) / 1, 0, 1) * (1 - math.Clamp((speed - 23) / 23, 0, 1)) * 0.5
        local strengthls = self:GetPackedRatio("asyncstate") * (1 - math.Clamp((speed - 8.9) / 1, 0, 1)) * 0.5
        self:SetSoundState("KATP", tunstreet * math.Clamp(state / 0.26 + 0.2, 0, 1) * strength, 1) --+math.Clamp(state,0,1)*0.1)
        self:SetSoundState("KATP_lowspeed", tunstreet * math.Clamp(state / 0.26 + 0.2, 0, 1) * strengthls, 1) --+math.Clamp(state,0,1)*0.1)
        self:SetSoundState("chopper_katp", tunstreet * self:GetPackedRatio("chopper"), 1)

    elseif asyncType == 6 then  -- Hitachi IGBT
        local state = self:GetPackedRatio("asynccurrent") --^1.5--RealTime()%2.5/2
        local strength = self:GetPackedRatio("asyncstate") * (1 - math.Clamp((speed - 15) / 15, 0, 1))
        --self:SetSoundState("Hitachi", tunstreet*math.Clamp((state)/0.3+0.2,0,1)*strength, 0.6+math.Clamp(state,0,1)*0.4)
        --self:SetSoundState("Hitachi",tunstreet*math.Clamp((state-0.75)/0.05,0,1)*strength, 0.6+math.Clamp((state-0.8)/0.2,0,1)*0.14)
        self:SetSoundState("Hitachi", tunstreet * math.Clamp(state / 0.26, 0, 1) * strength, 1)
        --self:SetSoundState("Hitachi2", tunstreet*(math.Clamp((speed-20)/5,0,1)*0.1+math.Clamp((speed-25)/10,0,1)*1.5)*(1-math.Clamp((speed-30)/12,0,1))*self:GetPackedRatio("asyncstate"), speed/36)
        --self:SetSoundState("Hitachi2_2", tunstreet*(math.Clamp((speed-20)/5,0,1)*0.1+math.Clamp((speed-25)/10,0,1)*1.5)*(1-math.Clamp((speed-25)/12,0,1))*self:GetPackedRatio("asyncstate"), speed/36)
        self:SetSoundState("Hitachi2_2", tunstreet * (math.Clamp((speed - 18) / 5, 0, 1) * 0.1 + math.Clamp((speed - 23) / 10, 0, 1) * 1.5) * (1 - math.Clamp((speed - 23) / 10, 0, 1)) * self:GetPackedRatio("asyncstate"), speed / 23)
        --self:SetSoundState("Hitachi2", tunstreet*(math.Clamp((speed-27)/5,0,1)*0.1+math.Clamp((speed-22)/10,0,1)*2.2)*(1-math.Clamp((speed-20)/12,0,1))*self:GetPackedRatio("asyncstate"), (speed/30)*2.8)
        self:SetSoundState("Hitachi2", tunstreet * (math.Clamp((speed - 32) / 5, 0, 1) * 0.1 + math.Clamp((speed - 27) / 10, 0, 1) * 2.2) * (1 - math.Clamp((speed - 25) / 12, 0, 1)) * self:GetPackedRatio("asyncstate"), (speed / 33) * 0.8)
        self:SetSoundState("Hitachi2_1", tunstreet * (math.Clamp((speed - 31) / 5, 0, 1) * 0.1 + math.Clamp((speed - 25) / 10, 0, 1) * 2) * (1 - math.Clamp((speed - 23) / 12, 0, 1)) * self:GetPackedRatio("asyncstate"), (speed / 30) * 0.95)
        --self:SetSoundState("Hitachi2_1", tunstreet*(math.Clamp((speed-20)/5,0,1)*0.1+math.Clamp((speed-27)/10,0,1)*2.5)*(1-math.Clamp((speed-30)/12,0,1))*self:GetPackedRatio("asyncstate"), speed/36)
        --self:SetSoundState("Hitachi2", tunstreet*math.Clamp(math.max(0,(state)/0.3+0.2),0,1)*strength, 0.55+math.Clamp(state,0,1)*0.45)
        --self:SetSoundState("Hitachi2", tunstreet*math.Clamp(math.max(0,(state-0.7)/0.1),0,1)*strength, 1)
        --self:SetSoundState("Hitachi2", tunstreet*math.Clamp((state-0.415)/0.1,0,1)*(1-math.Clamp((state-1.1)/0.3,0,0.5))*strength, 0.48+math.Clamp(state,0,1)*1)
        self:SetSoundState("battery_off_loop", --[[ self:GetPackedBool("BattPressed") and 1 or 0 ]] 1, 1)
        --self:SetSoundState("async_p2", tunstreet*(math.Clamp((speed-5)/5,0,1)*0.1+math.Clamp((speed-14)/10,0,1)*0.9)*(1-math.Clamp((speed-27)/4,0,1))*self:GetPackedRatio("asyncstate"), speed/36)
        --self:SetSoundState("async_p2", tunstreet*(math.Clamp((speed-8)/5,0,1)*0.1+math.Clamp((speed-17)/10,0,1)*0.9)*(1-math.Clamp((speed-30)/4,0,1))*self:GetPackedRatio("asyncstate"), speed/36)
        self:SetSoundState("async_p2", tunstreet * (math.Clamp((speed - 8) / 5, 0, 1) * 0.1 + math.Clamp((speed - 25) / 10, 0, 1) * 0.9) * (1 - math.Clamp((speed - 30) / 4, 0, 1)) * self:GetPackedRatio("asyncstate"), speed / 36)
        self:SetSoundState("async_p2_1", tunstreet * (math.Clamp((speed - 3) / 5, 0, 1) * 0.1 + math.Clamp((speed - 5) / 10, 0, 1) * 0.9) * (1 - math.Clamp((speed - 7) / 4, 0, 1)) * self:GetPackedRatio("asyncstate"), speed / 12)
        self:SetSoundState("async_p3", tunstreet * (math.Clamp((speed - 13) / 5, 0, 1) * 0.1 + math.Clamp((speed - 23) / 10, 0, 1) * 0.9) * (1 - math.Clamp((speed - 36) / 4, 0, 1)) * self:GetPackedRatio("asyncstate"), speed / 42)
        self:SetSoundState("async_p3_1", tunstreet * (math.Clamp((speed - 32) / 10, 0, 1) * 0.9) * (1 - math.Clamp((speed - 40) / 4, 0, 1)) * self:GetPackedRatio("asyncstate"), speed / 49)
        self:SetSoundState("engine_loud", tunstreet * math.Clamp((speed - 20) / 15, 0, 1) * (1 - math.Clamp((speed - 40) / 40, 0, 0.6)) * self:GetPackedRatio("asyncstate"), speed / 20)
        self:SetSoundState("chopper_hitachi", tunstreet * self:GetPackedRatio("chopper"), 1)

    elseif asyncType == 7 then  -- Hitachi VFI-HD1420F
        local state = self:GetPackedRatio("asynccurrent") --^1.5--RealTime()%2.5/2
        local strength = self:GetPackedRatio("asyncstate") * (1 - math.Clamp((speed - 15) / 15, 0, 1))
        self:SetSoundState("test_async_start", tunstreet * math.Clamp(state / 0.3 + 0.2, 0, 0.7) * strength, 0.6 + math.Clamp(state, 0, 1) * 0.4)
        self:SetSoundState("test_async1_n", tunstreet * math.Clamp(state / 0.3 + 0.2, 0, 1) * strength, 0.6 + math.Clamp(state, 0, 1) * 0.4)
        self:SetSoundState("test_async1_2_n", tunstreet * math.Clamp((state - 0.75) / 0.05, 0, 1) * strength, 0.6 + math.Clamp((state - 0.8) / 0.2, 0, 1) * 0.14)
        self:SetSoundState("test_async1_3_n", tunstreet * math.Clamp((state - 0.7) / 0.1, 0, 1) * strength, 0.87)
        self:SetSoundState("test_async2_n", tunstreet * math.Clamp(math.max(0, state / 0.3 + 0.2), 0, 1) * strength, 0.55 + math.Clamp(state, 0, 1) * 0.45)
        self:SetSoundState("test_async3_n", tunstreet * math.Clamp(math.max(0, (state - 0.7) / 0.1), 0, 1) * strength, 1)
        self:SetSoundState("test_async3_2_n", tunstreet * math.Clamp((state - 0.415) / 0.1, 0, 1) * (1 - math.Clamp((state - 1.1) / 0.3, 0, 0.5)) * strength, 0.48 + math.Clamp(state, 0, 1) * 0.72)
        --self:SetSoundState("async_p2_n", tunstreet*(math.Clamp((speed-5)/5,0,1)*0.1+math.Clamp((speed-14)/10,0,1)*0.9)*(1-math.Clamp((speed-27)/4,0,1))*self:GetPackedRatio("asyncstate"), speed/36)
        --self:SetSoundState("async_p3_n", tunstreet*(math.Clamp((speed-7)/5,0,1)*0.1+math.Clamp((speed-17)/10,0,1)*0.9)*(1-math.Clamp((speed-30)/4,0,1))*self:GetPackedRatio("asyncstate"), speed/42)
        self:SetSoundState("async_p2_n", tunstreet * (math.Clamp((speed - 8) / 5, 0, 1) * 0.1 + math.Clamp((speed - 25) / 10, 0, 1) * 0.9) * (1 - math.Clamp((speed - 30) / 4, 0, 1)) * self:GetPackedRatio("asyncstate"), speed / 36)
        self:SetSoundState("async_p2_1_n", tunstreet * (math.Clamp((speed - 3) / 5, 0, 1) * 0.1 + math.Clamp((speed - 5) / 10, 0, 1) * 0.9) * (1 - math.Clamp((speed - 7) / 4, 0, 1)) * self:GetPackedRatio("asyncstate"), speed / 12)
        self:SetSoundState("async_p3_n", tunstreet * (math.Clamp((speed - 13) / 5, 0, 1) * 0.1 + math.Clamp((speed - 23) / 10, 0, 1) * 0.9) * (1 - math.Clamp((speed - 36) / 4, 0, 1)) * self:GetPackedRatio("asyncstate"), speed / 42)
        self:SetSoundState("async_p3_1_n", tunstreet * (math.Clamp((speed - 32) / 10, 0, 1) * 0.9) * (1 - math.Clamp((speed - 40) / 4, 0, 1)) * self:GetPackedRatio("asyncstate"), speed / 49)
        self:SetSoundState("engine_loud", tunstreet * math.Clamp((speed - 20) / 15, 0, 1) * (1 - math.Clamp((speed - 40) / 40, 0, 0.6)) * self:GetPackedRatio("asyncstate"), speed / 20)
        --self:SetSoundState("engine_loud", tunstreet*math.Clamp((speed-10)/15,0,1)*(1-math.Clamp((speed-30)/40,0,0.6))*self:GetPackedRatio("asyncstate"), speed/20)
        self:SetSoundState("chopper_hitachi", tunstreet * self:GetPackedRatio("chopper"), 1)

    elseif asyncType == 8 then  -- Experimental for 765
        local state = self:GetPackedRatio("asynccurrent") --^1.5--RealTime()%2.5/2	
        local strength = self:GetPackedRatio("asyncstate") * math.Clamp((speed - 13) / 1, 0, 1) * (1 - math.Clamp((speed - 28) / 28, 0, 1)) * 0.5
        local strengthls = self:GetPackedRatio("asyncstate") * (1 - math.Clamp((speed - 12.9) / 1, 0, 1)) * 0.7
        self:SetSoundState("async1", tunstreet * math.Clamp(state / 0.26 + 0.2, 0, 1) * strength, 1) --+math.Clamp(state,0,1)*0.1)
        self:SetSoundState("KATP_lowspeed", tunstreet * math.Clamp(state / 0.26 + 0.2, 0, 1) * strengthls, 1) --+math.Clamp(state,0,1)*0.1)
        self:SetSoundState("chopper_katp", tunstreet * self:GetPackedRatio("chopper"), 1)
    end
end

function ENT:Draw()
    self.BaseClass.Draw(self)
end

function ENT:DrawPost(special)
    self.RTMaterial:SetTexture("$basetexture", self.MFDU)
    self:DrawOnPanel("MFDU", function(...)
        surface.SetMaterial(self.RTMaterial)
        surface.SetDrawColor(255, 255, 255)
        surface.DrawTexturedRectRotated(1024 / 2, math.floor(768 / 2), 1024, 768, 0)
    end)

    self.RTMaterial:SetTexture("$basetexture", self.ASNP)
    self:DrawOnPanel("ASNPScreen", function(...)
        surface.SetMaterial(self.RTMaterial)
        surface.SetDrawColor(255, 255, 255)
        surface.DrawTexturedRectRotated(256 * 1.35, 64 * 1.35, 512 * 1.35, 128 * 1.35, 0)
    end)

    self.RTMaterial:SetTexture("$basetexture", self.IGLA)
    self:DrawOnPanel("IGLA", function(...)
        surface.SetMaterial(self.RTMaterial)
        surface.SetDrawColor(255, 255, 255)
        surface.DrawTexturedRectRotated(256, 74, 512, 150, 0)
    end)

    self.RTMaterial:SetTexture("$basetexture", self.RVSScr)
    self:DrawOnPanel("RVSScreen", function(...)
        surface.SetMaterial(self.RTMaterial)
        surface.SetDrawColor(255, 255, 255)
        surface.DrawTexturedRectRotated(128, 128, 256, 256, 0)
    end)

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

    self.RTMaterial:SetTexture("$basetexture", self.CAMS)
    self:DrawOnPanel("CAMS", function(...)
        --local brightness = self:GetNW2Int("CAMSBrightness",100)/100
        --surface.SetAlphaMultiplier(brightness)
        surface.SetMaterial(self.RTMaterial)
        surface.SetDrawColor(255, 255, 255)
        surface.DrawTexturedRectRotated(1280 / 2, 512, 1280, 1024, 0)
        --surface.SetAlphaMultiplier(1.0)
    end)

    self.RTMaterial:SetTexture("$basetexture", self.BUIK)
    self:DrawOnPanel("BUIK", function(...)
        surface.SetMaterial(self.RTMaterial)
        surface.SetDrawColor(255, 255, 255)
        surface.DrawTexturedRectRotated(2486 / 2, 496 / 2, 2486, 496, 0)
    end)

    self.RTMaterial:SetTexture("$basetexture", self.BMIK)
    self:DrawOnPanel("BMIK", function(...)
        surface.SetMaterial(self.RTMaterial)
        surface.SetDrawColor(255, 255, 255)
        surface.DrawTexturedRectRotated(900, 150, 1800, 300, 0)
    end)

    self.RTMaterial:SetTexture("$basetexture", self.BNMIK)
    self:DrawOnPanel("BNMIK", function(...)
        surface.SetMaterial(self.RTMaterial)
        surface.SetDrawColor(255, 255, 255)
        surface.DrawTexturedRectRotated(300, 150, 600, 300, 0)
    end)

    self.RTMaterial:SetTexture("$basetexture", self.BLIK)
    self:DrawOnPanel("BLIK", function(...)
        surface.SetMaterial(self.RTMaterial)
        surface.SetDrawColor(255, 255, 255)
        surface.DrawTexturedRectRotated(190, 190, 380, 380, 0)
    end)
end

function ENT:OnButtonPressed(button)
    if button == "ShowHelp" then RunConsoleCommand("metrostroi_train_manual") end
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
        return anims[id].value --min + (max-min)*anims[id].val
    end

    --if self["_anim_old_"..id] == value then return self["_anim_old_"..id] end
    -- Generate sticky value
    if stickyness and damping then
        if (math.abs(anims[id].P - value) < stickyness) and anims[id].stuck then
            value = anims[id].P
            anims[id].stuck = false
        else
            anims[id].P = value
        end
    end

    local dT = FrameTime() --self.DeltaTime
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

local dist = {
    BackVent = 550,
    BackPPZ = 550,
    BackDown = 550,
}

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