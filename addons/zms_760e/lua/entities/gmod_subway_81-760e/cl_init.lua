--------------------------------------------------------------------------------
-- 81-760Э «Чурá» by ZONT_ a.k.a. enabled person
-- Based on code by Cricket, Hell et al.
-- Logic of 81-720A Experimental engines sounds by fixinit75
-- located at ExperimentalAsync method, permission granted for this addon
--------------------------------------------------------------------------------
include("shared.lua")
ENT.ClientProps = {}
ENT.ButtonMap = {}
ENT.AutoAnims = {}
ENT.ClientSounds = {}
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
ENT.ButtonMap["PU5"] = {
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
                var = "ALSk",
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
            tooltip = "Автоведение",
            model = {
                model = "models/metrostroi_train/81-760/81_760_rect_button_green.mdl",
                z = 0.5,
                ang = Angle(0, -62, 90),
                lamp = {
                    model = "models/metrostroi_train/81-760/81_760_lamp_rect_green.mdl",
                    var = "AutoDriveLamp",
                    anim = true,
                    ang = Angle(62, 0, 0),
                    z = 0.5
                },
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
            tooltip = "Стеклоочиститель",
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
                sndvol = 0.5,
                snd = function(val) return val and "button_square_press" or "button_square_release" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0),
            }
        },
    }
}

_, _getX, _, _bw = _fncCoord(6, 261.2, 10)
_, _getY = _fncCoordFixed(3, 167.2, _bw * 2)
ENT.ButtonMap["PU2"] = {
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
                model = "models/metrostroi_train/81-760/81_760_button_yellow.mdl",
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
ENT.ButtonMap["PU3"] = {
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
                z = 4,
                ang = -90,
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
                z = 6,
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
            ID = "ABESDToggle",
            x = _getX(2),
            y = _getY(0),
            radius = _bw,
            tooltip = "Аварийный блокиратор ЭСД",
            model = {
                model = "models/metrostroi_train/81-760/81_760_switch_under_glass.mdl",
                z = 4,
                ang = -90,
                var = "ABESD",
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
            ID = "ABESDkToggle",
            x = _getX(2) - _bw - 7,
            y = _getY(0) + 2,
            w = 40,
            h = 20,
            tooltip = "Крышка АБЭСД",
            model = {
                model = "models/metrostroi_train/81-760/81_760_cap_with_glass.mdl",
                ang = 90,
                z = 6,
                x = 2,
                y = -13,
                var = "ABESDk",
                speed = 8,
                min = 1,
                max = 0,
                disable = "ABESDToggle",
                plomb = {
                    model = "",
                    ang = 180 - 70,
                    x = -5,
                    y = -45,
                    z = 3,
                    var = "ABESDPl",
                    ID = "ABESDPl",
                },
                sndvol = 1,
                snd = function(val) return val and "kr_close" or "kr_open" end,
                sndmin = 90,
                sndmax = 1e3,
                sndang = Angle(-90, 0, 0),
            }
        },
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
    ang = Angle(0, -90, 0),
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
    ang = Angle(0, -90, 0),
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
                var = "RVS_KV",
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
                var = "RVS_UKV",
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
                var = "RVS_S",
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
                var = "RVS_F",
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
                var = "RVS_1",
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
                var = "RVS_2",
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
                var = "RVS_3",
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
                var = "RVS_4",
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
                var = "RVS_5",
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
                var = "RVS_6",
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
                var = "RVS_7",
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
                var = "RVS_8",
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
                var = "RVS_9",
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
                var = "RVS_0",
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
    pos = Vector(402, 10.8, 12.6),
    ang = Angle(0, 90, 90),
    width = 305,
    height = 283,
    scale = 0.05,
    hideseat = 0.2,
    buttons = {}
}
table.Add(ENT.ButtonMap["PVZ"].buttons, ENT.PvzToggles)


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
        {
            ID = "Mfdu1Set",
            x = 17 + 11.6 * 0,
            y = 117 - 11.6,
            w = 11.6,
            h = 11.6,
            tooltip = "Скиф: 1",
            model = {
                var = "Mfdu1",
                model = "models/metrostroi_train/81-760/81_760_rect_button_green.mdl",
                scale = 0.1, z = -5, speed = 16, vmin = 0, vmax = 1,
                snd = function(val) return val and "mfdu_down" or "mfdu_up" end,
                sndmin = 90, sndmax = 1e3, sndvol = 0.9,
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
                model = "models/metrostroi_train/81-760/81_760_rect_button_green.mdl",
                scale = 0.1, z = -5, speed = 16, vmin = 0, vmax = 1,
                snd = function(val) return val and "mfdu_down" or "mfdu_up" end,
                sndmin = 90, sndmax = 1e3, sndvol = 0.9,
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
                model = "models/metrostroi_train/81-760/81_760_rect_button_green.mdl",
                scale = 0.1, z = -5, speed = 16, vmin = 0, vmax = 1,
                snd = function(val) return val and "mfdu_down" or "mfdu_up" end,
                sndmin = 90, sndmax = 1e3, sndvol = 0.9,
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
                model = "models/metrostroi_train/81-760/81_760_rect_button_green.mdl",
                scale = 0.1, z = -5, speed = 16, vmin = 0, vmax = 1,
                snd = function(val) return val and "mfdu_down" or "mfdu_up" end,
                sndmin = 90, sndmax = 1e3, sndvol = 0.9,
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
                model = "models/metrostroi_train/81-760/81_760_rect_button_green.mdl",
                scale = 0.1, z = -5, speed = 16, vmin = 0, vmax = 1,
                snd = function(val) return val and "mfdu_down" or "mfdu_up" end,
                sndmin = 90, sndmax = 1e3, sndvol = 0.9,
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
                model = "models/metrostroi_train/81-760/81_760_rect_button_green.mdl",
                scale = 0.1, z = -5, speed = 16, vmin = 0, vmax = 1,
                snd = function(val) return val and "mfdu_down" or "mfdu_up" end,
                sndmin = 90, sndmax = 1e3, sndvol = 0.9,
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
                model = "models/metrostroi_train/81-760/81_760_rect_button_green.mdl",
                scale = 0.1, z = -5, speed = 16, vmin = 0, vmax = 1,
                snd = function(val) return val and "mfdu_down" or "mfdu_up" end,
                sndmin = 90, sndmax = 1e3, sndvol = 0.9,
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
                model = "models/metrostroi_train/81-760/81_760_rect_button_green.mdl",
                scale = 0.1, z = -5, speed = 16, vmin = 0, vmax = 1,
                snd = function(val) return val and "mfdu_down" or "mfdu_up" end,
                sndmin = 90, sndmax = 1e3, sndvol = 0.9,
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
                model = "models/metrostroi_train/81-760/81_760_rect_button_green.mdl",
                scale = 0.1, z = -5, speed = 16, vmin = 0, vmax = 1,
                snd = function(val) return val and "mfdu_down" or "mfdu_up" end,
                sndmin = 90, sndmax = 1e3, sndvol = 0.9,
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
                model = "models/metrostroi_train/81-760/81_760_rect_button_green.mdl",
                scale = 0.1, z = -5, speed = 16, vmin = 0, vmax = 1,
                snd = function(val) return val and "mfdu_down" or "mfdu_up" end,
                sndmin = 90, sndmax = 1e3, sndvol = 0.9,
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
                model = "models/metrostroi_train/81-760/81_760_rect_button_green.mdl",
                scale = 0.1, z = -5, speed = 16, vmin = 0, vmax = 1,
                snd = function(val) return val and "mfdu_down" or "mfdu_up" end,
                sndmin = 90, sndmax = 1e3, sndvol = 0.9,
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
                model = "models/metrostroi_train/81-760/81_760_rect_button_green.mdl",
                scale = 0.1, z = -5, speed = 16, vmin = 0, vmax = 1,
                snd = function(val) return val and "mfdu_down" or "mfdu_up" end,
                sndmin = 90, sndmax = 1e3, sndvol = 0.9,
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
                model = "models/metrostroi_train/81-760/81_760_rect_button_green.mdl",
                scale = 0.1, z = -5, speed = 16, vmin = 0, vmax = 1,
                snd = function(val) return val and "mfdu_down" or "mfdu_up" end,
                sndmin = 90, sndmax = 1e3, sndvol = 0.9,
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
                model = "models/metrostroi_train/81-760/81_760_rect_button_green.mdl",
                scale = 0.1, z = -5, speed = 16, vmin = 0, vmax = 1,
                snd = function(val) return val and "mfdu_down" or "mfdu_up" end,
                sndmin = 90, sndmax = 1e3, sndvol = 0.9,
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
                model = "models/metrostroi_train/81-760/81_760_rect_button_green.mdl",
                scale = 0.1, z = -5, speed = 16, vmin = 0, vmax = 1,
                snd = function(val) return val and "mfdu_down" or "mfdu_up" end,
                sndmin = 90, sndmax = 1e3, sndvol = 0.9,
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
                model = "models/metrostroi_train/81-760/81_760_rect_button_green.mdl",
                scale = 0.1, z = -5, speed = 16, vmin = 0, vmax = 1,
                snd = function(val) return val and "mfdu_down" or "mfdu_up" end,
                sndmin = 90, sndmax = 1e3, sndvol = 0.9,
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
                model = "models/metrostroi_train/81-760/81_760_rect_button_green.mdl",
                scale = 0.1, z = -5, speed = 16, vmin = 0, vmax = 1,
                snd = function(val) return val and "mfdu_down" or "mfdu_up" end,
                sndmin = 90, sndmax = 1e3, sndvol = 0.9,
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
                    color = Color(255, 255, 255)
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
    pos = Vector(0, 0, 0),
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

ENT.ClientProps["K9"] = {
    model = "models/metrostroi_train/81-765/k9.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hideseat = 0.5,
}

ENT.ClientProps["K29"] = {
    model = "models/metrostroi_train/81-765/k29.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hideseat = 0.5,
}

ENT.ButtonMap["K35"] = {
    pos = Vector(410, -66, 11.5),
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
    model = "models/metrostroi_train/81-760/81_760_crane_k23.mdl",
    pos = Vector(445.8, -50.62, -66.4),
    ang = Angle(0, 90, 0),
    hide = 2,
}

ENT.ClientProps["FrontTrain"] = {
    model = "models/metrostroi_train/81-760/81_760_crane_k23.mdl",
    pos = Vector(435.95, -53.57, -64.3),
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

ENT.ClientProps["K23Valve"] = {
    model = "models/metrostroi_train/81-760/81_760_crane_k23.mdl",
    pos = Vector(131.42, -64.14, -64.6),
    ang = Angle(0, 0, 0),
    hide = 2,
}

ENT.ClientSounds["K23ValveIsolation"] = {{"K23Valve", function() return "disconnectvalve" end, 1, 1, 50, 1e3, Angle(-90, 0, 0)}}
ENT.ButtonMap["PassengerDoor"] = {
    pos = Vector(400, -28.5, 40),
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
                sndid = "DoorCabM",
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
    pos = Vector(398, 8, 40),
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
    pos = Vector(417, -58, -6),
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

ENT.ButtonMap["Closet1"] = {
    pos = Vector(417, -57.5, 48),
    ang = Angle(0, 90, 90),
    width = 100,
    height = 230,
    scale = 0.23,
    buttons = {
        {
            ID = "Closet1",
            x = 0,
            y = 0,
            w = 100,
            h = 230,
            tooltip = "Шкаф",
            model = {
                var = "Closet1",
            }
        },
    }
}

ENT.ButtonMap["Closet1Op"] = {
    pos = Vector(439.1, -50, 47.1),
    ang = Angle(0, 198.28, 90),
    width = 100,
    height = 230,
    scale = 0.23,
    buttons = {
        {
            ID = "Closet1",
            x = 0,
            y = 0,
            w = 100,
            h = 230,
            tooltip = "Шкаф",
            model = {
                var = "Closet1",
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
                sndid = "DoorCabL",
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
                sndid = "DoorCabL",
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
                sndid = "DoorCabR",
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
                sndid = "DoorCabR",
            }
        },
    }
}

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

ENT.ClientProps["Salon"] = {
    model = "models/metrostroi_train/81-760/81_760a_int.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hide = 2,
}

ENT.ClientProps["Cabin"] = {
    model = "models/metrostroi_train/81-765/cabin.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hide = 2,
}


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
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hide = 2,
})

ENT.ClientProps["NmTmRear"] = {
    model = "models/metrostroi_train/81-760/81_760a_crane_nm_tm.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hide = 2,
}

ENT.ClientProps["KtiFan"] = {
    model = "models/metrostroi_train/81-760/81_760_fan_kti.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hide = 1.5,
}

ENT.ClientProps["RFan"] = {
    model = "models/metrostroi_train/81-760/81_760_fan_r.mdl",
    pos = Vector(0, 0, 0),
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

ENT.ClientProps["GvWrench"] = {
    model = "models/metrostroi_train/reversor/reversor_classic.mdl",
    pos = Vector(-167.5, 49.47, -74.07),
    ang = Angle(-90, 180, 0),
    hide = 0.5,
}

for i = 0, 3 do
    for k = 0, 1 do
        ENT.ClientProps["door" .. i .. "x" .. k] = {
            model = "models/metrostroi_train/81-760e/81_760e_door.mdl",
            pos = Vector(229.92 * i * (k == 0 and 1 or -1), 0, 0),
            ang = Angle(0, 180 + k * 180, 0),
            hide = 2
        }
    end
end

ENT.ClientProps["DoorCabM"] = {
    model = "models/metrostroi_train/81-765/sdoor.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hide = 2,
}

ENT.ClientProps["DoorCabL"] = {
    model = "models/metrostroi_train/81-765/ldoor.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hide = 2,
    modelcallback = function(ent)
        if ent.Anims and ent.Anims["DoorCabL.position_window"] then
            ent.Anims["DoorCabL.position_window"].reload = true
        end
    end
}

ENT.ClientProps["DoorCabR"] = {
    model = "models/metrostroi_train/81-765/rdoor.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hide = 2,
    modelcallback = function(ent)
        if ent.Anims and ent.Anims["DoorCabR.position_window"] then
            ent.Anims["DoorCabR.position_window"].reload = true
        end
    end
}

ENT.ClientProps["Closet1Val"] = {
    model = "models/metrostroi_train/81-765/cldoor.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hide = 2,
}


ENT.ClientProps["CabChairAdd"] = {
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

ENT.ClientProps["Controller"] = {
    model = "models/metrostroi_train/81-722/81-722_controller.mdl",
    pos = Vector(482.4, 23.89, -14.2),
    ang = Angle(0, 90, 0),
    hide = 2,
}

ENT.ClientProps["KM013"] = {
    model = "models/metrostroi_train/81-760/81_760_km_013.mdl",
    pos = Vector(475.09, -11.89, -16.46),
    ang = Angle(2.6, 11, 0),
    hideseat = 0.5,
}

if not ENT.ClientSounds["br_013"] then ENT.ClientSounds["br_013"] = {} end
table.insert(ENT.ClientSounds["br_013"], {"KM013", function(ent, _, var) return "br_013" end, 1, 1, 50, 1e3, Angle(-90, 0, 0)})

ENT.ClientProps["PB"] = {
    model = "models/metrostroi_train/81-765/pb.mdl",
    pos = Vector(487, 31.88, -49.42),
    ang = Angle(0, 0, 0),
}

if not ENT.ClientSounds["PB"] then ENT.ClientSounds["PB"] = {} end
table.insert(ENT.ClientSounds["PB"], {"PB", function(ent, var) return var > 0 and "pb_on" or "pb_off" end, 1, 1, 50, 1e3, Angle(-90, 0, 0)})

ENT.ClientProps["FenceR"] = {
    model = "models/metrostroi_train/81-760/81_760_fence_corrugated_platform.mdl",
    pos = Vector(-480.15, 0, 0),
    ang = Angle(0, 90, 0),
    hide = 2,
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

ENT.ClientProps["ASHook"] = {
    model = "models/metrostroi_train/81-760/81_760_brake_valve.mdl",
    pos = Vector(0, 0, -78),
    ang = Angle(0, 180, 0),
    hide = 1.1,
    callback = function(ent, cl_ent)
        local frontbogey = ent:GetNW2Entity("FrontBogey")
        if not IsValid(frontbogey) then ent:ShowHide("ASHook", false) end
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
ENT.ClientProps["MnBc"] = {
    model = "models/metrostroi_train/81-760/81_760_arrow_nm.mdl",
    pos = Vector(491.29, -13.54, -2.23) - fwd * 0.04,
    ang = bcarrow,
    hideseat = 0.2,
}

ENT.ClientProps["MnTl"] = {
    model = "models/metrostroi_train/81-760/81_760_arrow_nm.mdl",
    pos = Vector(488.81, -13.54, -9.20) - fwd * 0.04,
    ang = arrowsang,
    hideseat = 0.2,
}

ENT.ClientProps["MnBl"] = {
    model = "models/metrostroi_train/81-760/81_760_arrow_tm.mdl",
    pos = Vector(488.81, -13.54, -9.20) - fwd * 0.08,
    ang = arrowsang,
    hideseat = 0.2,
}

ENT.ClientProps["SalonLightsHalf"] = {
    model = "models/metrostroi_train/81-760/81_760_lamp_int_half.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hide = 2,
}

ENT.ClientProps["SalonLightsFull"] = {
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

local vmang = Angle(-11.549, -60, 8.2)
local rotvmang = Angle(-11.549, -119.91, 8.2)
vmang:RotateAroundAxis(rotvmang:Right(), -10)
vmang:RotateAroundAxis(rotvmang:Forward(), -6)
local vmoffset = rotvmang:Up() * -0.65 + rotvmang:Forward() * -0.35 + Vector(0, -0.08, 0)

ENT.ClientProps["VmLv"] = {
    model = "models/metrostroi_train/81-760/81_760_arrow_electric.mdl",
    pos = Vector(496.93, 55.47, 32.3) + vmoffset,
    ang = vmang,
    hide = 0.2,
}

ENT.ClientProps["VmHv"] = {
    model = "models/metrostroi_train/81-760/81_760_arrow_electric.mdl",
    pos = Vector(498.16, 55.34, 27.53) + vmoffset,
    ang = vmang,
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
        "headlight", --MnBc
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
    nohide = true,
}

ENT.ButtonMap["BNMIK"] = {
    pos = Vector(519.6, 14.6, -30.61),
    ang = Angle(0, 90, 84.57),
    width = 600,
    height = 300,
    scale = 0.03,
    nohide = true,
}

ENT.ButtonMap["BLIK"] = {
    pos = Vector(518.4, -9.1, -21.45),
    ang = Angle(0, 90, 83.41),
    width = 380,
    height = 380,
    scale = 0.048,
    hide = 10,
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

for _, cfg in pairs(ENT.PakToggles or {}) do
    if cfg.buttons and cfg.btnmap and ENT.ButtonMap[cfg.btnmap] and ENT.ButtonMap[cfg.btnmap].buttons then
        table.Add(ENT.ButtonMap[cfg.btnmap].buttons, cfg.buttons)
    end
end

for _, bm in ipairs({"PU5", "PU2", "PU3", "RV"}) do
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
    self.PreviousCompressorState = false
    self.EmergencyValveRamp = 0
    self.EmergencyValveEPKRamp = 0
    self.EmergencyBrakeValveRamp = 0
    self.CraneRamp = 0
    self.CraneRRamp = 0
    self.FrontLeak = 0
    self.RearLeak = 0
    self.CompressorVol = 0
    self.ParkingBrake = 0
    self.VentVolume = 0
    self.VentVolume2 = 0

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
    if not IsValid(self.RearBogey) then self.RearBogey = self:GetNW2Entity("RearBogey") end
    if not IsValid(self.FrontBogey) then self.FrontBogey = self:GetNW2Entity("FrontBogey") end
end

local CranePos = {0, 0.28, 0.38, 0.48, 0.85, 1}
local ControllerPos = {0, 0.22, 0.41, 0.6, 0.8, 1}
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
        Metrostroi.Version > 1537278077 and not bogey.SoundNames["ted1_765"] or
        Metrostroi.Version <= 1537278077 and bogey.SoundNames["ted1_720"] ~= "subway_trains/765/rumble/engines/engine_8.wav"
    )
end

function ENT:PlayDoorSound(bool, door)
    if self[door] ~= bool then
        self[door] = bool
        self:PlayOnce(Format("%s_%s", door, bool and "open" or "close"), "", 1, 1)
    end
end

function ENT:Think()
    self.BaseClass.Think(self)
    if not self.RenderClientEnts or self.CreatingCSEnts then
        self.Number = 0
        return
    end

    if self:CheckBogeySounds(self.FrontBogey) then self:ReInitBogeySounds(self.FrontBogey) end
    if self:CheckBogeySounds(self.RearBogey) then self:ReInitBogeySounds(self.RearBogey) end
    if self.Number ~= self:GetWagonNumber() then self:UpdateTextures() end
    if self.Texture ~= self:GetNW2String("Texture") then self:UpdateTextures() end
    if self.PassTexture ~= self:GetNW2String("passtexture") then self:UpdateTextures() end
    if self.CabinTexture ~= self:GetNW2String("cabtexture") then self:UpdateTextures() end
    if self:IsNumberBroken() then self:UpdateTextures() end

    local ValidfB, ValidrB = IsValid(self.FrontBogey), IsValid(self.RearBogey)
    self:ShowHide("ASHook", ValidfB)
    for i = 1, 4 do
        self:ShowHide("TR" .. i, i <= 2 and ValidfB or i >= 3 and ValidrB)
        self:ShowHide("BS" .. i, ValidfB)
        self:ShowHide("BS" .. (i + 4), ValidrB)
        self:Animate("TR" .. i, self:GetPackedBool("TR" .. i) and 1 or 0, 0, 1, 8, 0.5)
        self:Animate("BS" .. i, self:GetPackedBool("BC" .. i) and 1 or 0, 1, 0.722, 32, 2)
        self:Animate("BS" .. (i + 4), self:GetPackedBool("BC" .. (i + 4)) and 1 or 0, 1, 0.722, 32, 2)
    end

    local RearTrain, fence = self:GetNW2Entity("RearTrain"), self.ClientEnts["FenceR"]
    self:ShowHide("FenceR", IsValid(RearTrain) and ((RearTrain:GetClass():find("760a") or RearTrain:GetClass():find("760e")) and not IsValid(RearTrain.ClientEnts["FenceR"]) and RearTrain:GetNW2Entity("FrontTrain") ~= self or RearTrain:GetClass():find("761a") or RearTrain:GetClass():find("763a") or RearTrain:GetClass():find("761e") or RearTrain:GetClass():find("763e")) and true)
    if IsValid(fence) and IsValid(RearTrain) then
        local a = RearTrain:GetNW2Entity("RearTrain") == self and -1 or 1
        local ang1 = fence:WorldToLocalAngles(RearTrain:LocalToWorldAngles(Angle(0, 90 * a, 0)))
        local vec = fence:WorldToLocal(RearTrain:LocalToWorld(Vector(480.1 * a, a * ang1.p * 1.585, 0.6)))
        fence:ManipulateBoneAngles(0, Angle(-ang1.r / 2, ang1.y / 2, ang1.p / 3) + Angle(0, 90, 0))
        fence:ManipulateBonePosition(0, Vector(vec.x / 2, vec.y / 2, vec.z / 2))
    end

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

    local dT = self.DeltaTime

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

    local speed = self:GetPackedRatio("Speed", 0)
    if IsValid(self.ClientEnts["KtiFan"]) and self:GetPackedBool("WorkFan", false) then self.ClientEnts["KtiFan"]:SetPoseParameter("position", 1.0 - (speed > 10 and CurTime() % 0.5 * 2 or CurTime() % 1)) end
    if IsValid(self.ClientEnts["RFan"]) and self:GetPackedBool("WorkFan", false) then self.ClientEnts["RFan"]:SetPoseParameter("position", 1.0 - (speed > 10 and CurTime() % 0.5 * 2 or CurTime() % 1)) end
    self:Animate("FrontBrake", self:GetNW2Bool("FbI") and 0 or 1, 0, 1, 3, false)
    self:Animate("FrontTrain", self:GetNW2Bool("FtI") and 0 or 1, 0, 1, 3, false)
    self:Animate("RearBrake", self:GetNW2Bool("RbI") and 0 or 1, 0, 1, 3, false)
    self:Animate("RearTrain", self:GetNW2Bool("RtI") and 0 or 1, 0, 1, 3, false)
    self:Animate("K23Valve", self:GetNW2Bool("K23") and 0 or 1, 0, 1, 3, false)
    if self.LastGvState ~= self:GetPackedBool("GV") then
        self.GvWrenchHide = CurTime() + 1.5
        self.LastGvState = self:GetPackedBool("GV")
    end

    self:Animate("GvWrench", self:GetPackedBool("GV") and 0 or 1, 0, 0.5, 128, 1, false)
    self:ShowHideSmooth("GvWrench", CurTime() < self.GvWrenchHide and 1 or 0.1)

    self:Animate("K9", self:GetPackedBool("K9") and 0 or 1, 0, 1, 16, 0.5)
    self:Animate("K29", self:GetPackedBool("K29") and 1 or 0, 0, 1, 16, 0.5)
    self:Animate("K31", self:GetPackedBool("K31") and 0 or 1, 0, 1, 16, 0.5)
    self:Animate("K35", self:GetPackedBool("UAVA") and 1 or 0, 0, 1, 32, 0.5)

    self:Animate("KRO", self:GetPackedRatio("KRO", 0), 0, 1, 6, false)
    self:Animate("KRR", self:GetPackedRatio("KRR", 0), 0, 1, 3, false)

    self:Animate("KM013", CranePos[7 - self:GetPackedRatio("Cran")] or 0, 0, 1, 2, false)
    self:Animate("PB", self:GetPackedBool("PB") and 1 or 0, 0, 1, 8, false)

    self:ShowHideSmooth("SalonLightsHalf", self:Animate("LampsEmer", self:GetPackedBool("SalonLighting1") and 1 or 0, 0, 1, 5, false))
    self:ShowHideSmooth("SalonLightsFull", self:Animate("LampsFull", self:GetPackedBool("SalonLighting2") and 1 or 0, 0, 1, 5, false))

    local cabl_full = self:GetPackedBool("CabinEnabledFull")
    local cabl_half = not cabl_full and self:GetPackedBool("CabinEnabledEmer")
    local cabl_off = not cabl_full and not cabl_half
    cabl_full = self:Animate("CabFull", cabl_full and 1 or 0, 0, 1, 5, false)
    cabl_half = self:Animate("CabEmer", cabl_half and 1 or 0, 0, 1, 5, false)
    cabl_off = self:Animate("CabOff", cabl_off and 1 or 0, 0, 1, 5, false)
    self:ShowHideSmooth("cab_full", cabl_full)
    self:ShowHideSmooth("cab_half", cabl_half)
    self:ShowHideSmooth("cab_off", cabl_off)

    -- LEGACY, to be removed
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
                led = state ~= "Closed" or CurTime() % 1.2 < 0.6
            end
            btn:SetSubMaterial(1, led and "models/metrostroi_train/81-765/led_green" or "models/metrostroi_train/81-765/led_off")
        end
    end

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

    local K31cap = self:Animate("K31cap", self:GetPackedBool("DoorK31") and 1 or 0, 0, 1, 4, 0.5)
    self:ShowHide("K31", K31cap > 0)
    self:HidePanel("K31", K31cap < 1)

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

    local parking_brake = math.max(0, -self:GetPackedRatio("ParkingBrakePressure_dPdT", 0))
    self.ParkingBrake = self.ParkingBrake + (parking_brake - self.ParkingBrake) * dT * 10
    self:SetSoundState("parking_brake", self.ParkingBrake, 1.4)

    self.ReleasedPdT = math.Clamp(self.ReleasedPdT + 10 * (-self:GetPackedRatio("BrakeCylinderPressure_dPdT", 0) - self.ReleasedPdT) * dT * 1.5, 0, 1)
    self:SetSoundState("release", math.Clamp(self.ReleasedPdT, 0, 1) ^ 2, 1)
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
    self:SetSoundState("ring", self:GetPackedBool("RingEnabled") and 1 or 0, 1)

    local cmp_state = self:GetPackedBool("CompressorWork")
    if self.CompressorVol < 1 and cmp_state then
        self.CompressorVol = math.min(1, self.CompressorVol + (self.CompressorVol < 0.2 and 0.1 or 0.2) * dT) --5*dT
    elseif self.CompressorVol > 0 and not cmp_state then
        self.CompressorVol = math.max(0, self.CompressorVol - dT) --3*dT
    end
    self:SetSoundState("compressor", self.CompressorVol / 6, 0.8 + 0.2 * self.CompressorVol)
    self.PreviousCompressorState = cmp_state

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

    local asyncState = self:GetPackedRatio("asynccurrent")
    local strength = self:GetPackedRatio("asyncstate") * (1 - math.Clamp((speed - 23) / 23, 0, 1)) * 0.5
    local asyncType = self:GetNW2Int("VVVFSound", 1)
    if asyncType == 1 then
        self:SetSoundState("async1", rolling_total * math.Clamp(asyncState / 0.26 + 0.2, 0, 1) * strength, 1)
    else
        self:ExperimentalAsync(asyncType, rolling_total, speed)
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
        local strength = self:GetPackedRatio("asyncstate") * math.Clamp((speed - 13) / 1, 0, 1) * (1 - math.Clamp((speed - 28) / 28, 0, 1)) * 0.5
        local strengthls = self:GetPackedRatio("asyncstate") * (1 - math.Clamp((speed - 12.9) / 1, 0, 1)) * 0.7
        self:SetSoundState("async1", rolling_total * math.Clamp(state / 0.26 + 0.2, 0, 1) * strength, 1) --+math.Clamp(state,0,1)*0.1)
        self:SetSoundState("KATP_lowspeed", rolling_total * math.Clamp(state / 0.26 + 0.2, 0, 1) * strengthls, 1) --+math.Clamp(state,0,1)*0.1)
        self:SetSoundState("chopper_katp", rolling_total * self:GetPackedRatio("chopper"), 1)
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
        surface.SetMaterial(self.RTMaterial)
        surface.SetDrawColor(255, 255, 255)
        surface.DrawTexturedRectRotated(1280 / 2, 512, 1280, 1024, 0)
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

local dist = {
    BackVent = 550,
    BackPPZ = 550,
    BackDown = 550,
}

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
