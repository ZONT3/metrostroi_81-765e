--------------------------------------------------------------------------------
-- 81-760Э «Чурá» by ZONT_ a.k.a. enabled person
--------------------------------------------------------------------------------
include("shared.lua")

-- local BaseClass = baseclass.Get("gmod_81-765_base")
-- ENT.Base = "gmod_subway_base"  -- TODO Implement 765_base instead when (if) moving to metrostroi 2025+

if not ENT.ButtonMap.RearPneumatic then ErrorNoHaltWithStack("BaseClass not initialized!\n") end

ENT.AutoAnims = {}
ENT.ClientPropsInitialized = false

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
    pos = Vector(497.53, 32.65, -8.97),
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
    pos = Vector(493.32, 16.34, -13.29),
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
    pos = Vector(493.32, 0.36, -13.29),
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
    pos = Vector(494.02, 38, -13.29),
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
    pos = Vector(489.62, 40.83, -13.29),
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
    pos = Vector(416.77, 38.0, 33.8),
    ang = Angle(0, 90, 90),
    width = 512 * 1.35,
    height = 128 * 1.35,
    scale = 0.0067,
    hideseat = 0.2,
}

ENT.ButtonMap["ASNP"] = {
    pos = Vector(416.82, 36.31, 34.52),
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

-- ENT.ButtonMap["RVSScreen"] = {
--     pos = Vector(479.1, 51.44, -13.29),
--     ang = Angle(0, -60, 0),
--     width = 256,
--     height = 140,
--     scale = 0.014,
--     hideseat = 0.2,
--     system = "RVS",
-- }

-- ENT.ButtonMap["RVSButtons"] = {
--     pos = Vector(478.6, 55.56, -13.1),
--     ang = Angle(0, -60, 0),
--     width = 400,
--     height = 150,
--     scale = 0.03,
--     hideseat = 0.2,
--     buttons = {
--         {
--             ID = "RVS_KVSet",
--             x = 26,
--             y = 32,
--             w = 30,
--             h = 20,
--             tooltip = "КВ",
--             model = {
--                 z = 1,
--                 ang = Angle(-90, 0, 0),
--                 lamp = {
--                     speed = 16,
--                     model = "models/metrostroi_train/common/lamps/svetodiod1.mdl",
--                     var = "RVSKV",
--                     ang = 90,
--                     color = Color(187, 255, 91),
--                     x = 31,
--                     y = 8,
--                     z = -5
--                 },
--                 var = "RVS_KV",
--                 speed = 12,
--             }
--         },
--         {
--             ID = "!RVS_KVLamp",
--             x = 26,
--             y = 32,
--             model = {
--                 z = 1,
--                 ang = Angle(-90, 0, 0),
--                 lamp = {
--                     speed = 16,
--                     model = "models/metrostroi_train/common/lamps/svetodiod1.mdl",
--                     var = "RVSKVPRD",
--                     ang = 90,
--                     color = Color(255, 56, 30),
--                     x = 46,
--                     y = 6,
--                     z = -5
--                 },
--             }
--         },
--         {
--             ID = "RVS_UKVSet",
--             x = 24,
--             y = 115,
--             w = 30,
--             h = 20,
--             tooltip = "УКВ",
--             model = {
--                 z = 1,
--                 ang = Angle(-90, 0, 0),
--                 lamp = {
--                     speed = 16,
--                     model = "models/metrostroi_train/common/lamps/svetodiod1.mdl",
--                     var = "RVSUKV",
--                     ang = 90,
--                     color = Color(187, 255, 91),
--                     x = 31,
--                     y = 8,
--                     z = -5
--                 },
--                 var = "RVS_UKV",
--                 speed = 12,
--             }
--         },
--         {
--             ID = "!RVS_UKVLamp",
--             x = 24,
--             y = 115,
--             model = {
--                 z = 1,
--                 ang = Angle(-90, 0, 0),
--                 lamp = {
--                     speed = 16,
--                     model = "models/metrostroi_train/common/lamps/svetodiod1.mdl",
--                     var = "RVSUKVPRD",
--                     ang = 90,
--                     color = Color(255, 56, 30),
--                     x = 46,
--                     y = 6,
--                     z = -5
--                 },
--             }
--         },
--         {
--             ID = "RVS_SSet",
--             x = 277,
--             y = 42,
--             radius = 15,
--             tooltip = "С",
--             model = {
--                 z = 1,
--                 ang = Angle(-90, 0, 0),
--                 lamp = {
--                     speed = 16,
--                     model = "models/metrostroi_train/common/lamps/svetodiod1.mdl",
--                     var = "RVSPRD",
--                     ang = 90,
--                     color = Color(187, 255, 91),
--                     x = 17,
--                     y = 0,
--                     z = -5
--                 },
--                 var = "RVS_S",
--                 speed = 12,
--             }
--         },
--         {
--             ID = "RVS_FSet",
--             x = 104,
--             y = 42,
--             radius = 15,
--             tooltip = "F",
--             model = {
--                 z = 1,
--                 ang = Angle(-90, 0, 0),
--                 var = "RVS_F",
--                 speed = 12,
--             }
--         },
--         {
--             ID = "RVS_1Set",
--             x = 278,
--             y = 79,
--             radius = 12,
--             tooltip = "1",
--             model = {
--                 z = 1,
--                 ang = Angle(-90, 0, 0),
--                 lamp = {
--                     speed = 16,
--                     model = "models/metrostroi_train/common/lamps/svetodiod1.mdl",
--                     var = "RVS1",
--                     ang = 90,
--                     color = Color(187, 255, 91),
--                     x = 0,
--                     y = -12,
--                     z = -5
--                 },
--                 var = "RVS_1",
--                 speed = 12,
--             }
--         },
--         {
--             ID = "RVS_2Set",
--             x = 303,
--             y = 79,
--             radius = 12,
--             tooltip = "2",
--             model = {
--                 z = 1,
--                 ang = Angle(-90, 0, 0),
--                 lamp = {
--                     speed = 16,
--                     model = "models/metrostroi_train/common/lamps/svetodiod1.mdl",
--                     var = "RVS2",
--                     ang = 90,
--                     color = Color(187, 255, 91),
--                     x = 0,
--                     y = -12,
--                     z = -5
--                 },
--                 var = "RVS_2",
--                 speed = 12,
--             }
--         },
--         {
--             ID = "RVS_3Set",
--             x = 328,
--             y = 79,
--             radius = 12,
--             tooltip = "3",
--             model = {
--                 z = 1,
--                 ang = Angle(-90, 0, 0),
--                 var = "RVS_3",
--                 speed = 12,
--             }
--         },
--         {
--             ID = "RVS_4Set",
--             x = 278,
--             y = 99,
--             radius = 12,
--             tooltip = "4",
--             model = {
--                 z = 1,
--                 ang = Angle(-90, 0, 0),
--                 var = "RVS_4",
--                 speed = 12,
--             }
--         },
--         {
--             ID = "RVS_5Set",
--             x = 303,
--             y = 99,
--             radius = 12,
--             tooltip = "5",
--             model = {
--                 z = 1,
--                 ang = Angle(-90, 0, 0),
--                 var = "RVS_5",
--                 speed = 12,
--             }
--         },
--         {
--             ID = "RVS_6Set",
--             x = 328,
--             y = 99,
--             radius = 12,
--             tooltip = "6",
--             model = {
--                 z = 1,
--                 ang = Angle(-90, 0, 0),
--                 var = "RVS_6",
--                 speed = 12,
--             }
--         },
--         {
--             ID = "RVS_7Set",
--             x = 278,
--             y = 115,
--             radius = 12,
--             tooltip = "7",
--             model = {
--                 z = 1,
--                 ang = Angle(-90, 0, 0),
--                 var = "RVS_7",
--                 speed = 12,
--             }
--         },
--         {
--             ID = "RVS_8Set",
--             x = 303,
--             y = 115,
--             radius = 12,
--             tooltip = "8",
--             model = {
--                 z = 1,
--                 ang = Angle(-90, 0, 0),
--                 var = "RVS_8",
--                 speed = 12,
--             }
--         },
--         {
--             ID = "RVS_9Set",
--             x = 328,
--             y = 115,
--             radius = 12,
--             tooltip = "9",
--             model = {
--                 z = 1,
--                 ang = Angle(-90, 0, 0),
--                 var = "RVS_9",
--                 speed = 12,
--             }
--         },
--         {
--             ID = "RVS_0Set",
--             x = 303,
--             y = 130,
--             radius = 12,
--             tooltip = "0",
--             model = {
--                 z = 1,
--                 ang = Angle(-90, 0, 0),
--                 var = "RVS_0",
--                 speed = 12,
--             }
--         },
--     }
-- }

ENT.ButtonMap["PPUP"] = {
    pos = Vector(416.9, 47.42, 24.80),
    ang = Angle(0, 90, 90),
    width = 512,
    height = 93,
    scale = 0.018,
    hideseat = 0.2,
    system = "PPUP",
}

ENT.ButtonMap["PPUPButtons"] = {
    pos = Vector(417.1, 47.83, 26.54),
    ang = Angle(0, 90, 90),
    width = 133,
    height = 75,
    scale = 0.065,
    hideseat = 0.2,
    buttons = {
        {
            ID = "PPUP1Set",
            tooltip = "ППУ-П: Первая кнопка\nНедоступно в альфа-версии",
            x = 0, y = 60, w = 20, h = 15,
            model = {
                var = "PPUP1",
                model = "models/metrostroi_train/81-760/81_760_rect_button_green.mdl",
                lamp = {
                    model = "models/metrostroi_train/81-760/81_760_lamp_rect_green.mdl",
                    var = "PPUP:ButtonL1",
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
            ID = "PPUP2Set",
            tooltip = "ППУ-П: Вторая кнопка\nНедоступно в альфа-версии",
            x = 36, y = 60, w = 20, h = 15,
            model = {
                var = "PPUP2",
                model = "models/metrostroi_train/81-760/81_760_rect_button_green.mdl",
                lamp = {
                    model = "models/metrostroi_train/81-760/81_760_lamp_rect_green.mdl",
                    var = "PPUP:ButtonL2",
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
            ID = "PPUP23",
            x = 64, y = 67, radius = 10,
            tooltip = "ППУ-П: Вторая и третья кнопка\nНедоступно в альфа-версии"
        },
        {
            ID = "PPUP3Set",
            tooltip = "ППУ-П: Третья кнопка\nНедоступно в альфа-версии",
            x = 72, y = 60, w = 20, h = 15,
            model = {
                model = "models/metrostroi_train/81-760/81_760_rect_button_green.mdl",
                var = "PPUP3",
                lamp = {
                    model = "models/metrostroi_train/81-760/81_760_lamp_rect_green.mdl",
                    var = "PPUP:ButtonL3",
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
            ID = "PPUP4Set",
            tooltip = "ППУ-П: Четвёртая кнопка\nНедоступно в альфа-версии",
            x = 108, y = 60, w = 20, h = 15,
            model = {
                model = "models/metrostroi_train/81-760/81_760_rect_button_green.mdl",
                var = "PPUP4",
                lamp = {
                    model = "models/metrostroi_train/81-760/81_760_lamp_rect_green.mdl",
                    var = "PPUP:ButtonL4", ang = Angle(62, 0, 0),
                    speed = 16, x = 0, y = 0, z = 0.5, scale = 1.05,
                },
                z = -0.6, scale = 1.05, ang = Angle(0, -62, 90),
                speed = 12, vmin = 0, vmax = 1, sndvol = 0.3,
                snd = function(val) return val and "button_square_press" or "button_square_release" end,
                sndmin = 80, sndmax = 1e3 / 3, sndang = Angle(-90, 0, 0),
            }
        },
        {
            ID = "!PPUPFire",
            tooltip = "ППУ-П: Пожар!",
            x = 0, y = 0, w = 20, h = 15,
            model = {
                model = "models/metrostroi_train/81-760/81_760_rect_button_yellow.mdl",
                lamp = {
                    model = "models/metrostroi_train/81-760/81_760_lamp_rect_yellow.mdl",
                    var = "PPUP:Fire", ang = Angle(62, 0, 0),
                    speed = 16, x = 0, y = 0, z = 1, scale = 1.05,
                },
                z = -2, scale = 1.05, ang = Angle(0, -62, 90),
            }
        },
        {
            ID = "!PPUPMsg",
            tooltip = "ППУ-П: Работа",
            x = 108, y = 0, w = 20, h = 15,
            model = {
                model = "models/metrostroi_train/81-760/81_760_rect_button_green.mdl",
                lamp = {
                    model = "models/metrostroi_train/81-760/81_760_lamp_rect_green.mdl",
                    var = "PPUP:Msg", ang = Angle(62, 0, 0),
                    speed = 16, x = 0, y = 0, z = 0.5, scale = 1.05,
                },
                z = -0.6, scale = 1.05, ang = Angle(0, -62, 90),
            }
        },
        {
            ID = "!PPUPWarn",
            tooltip = "ППУ-П: Сообщение",
            x = 108, y = 0, w = 20, h = 15,
            model = {
                model = "models/metrostroi_train/81-760/81_760_rect_button_green.mdl",
                lamp = {
                    model = "models/metrostroi_train/81-760/81_760_lamp_rect_red.mdl",
                    var = "PPUP:Warn", ang = Angle(62, 0, 0),
                    speed = 16, x = 0, y = 0, z = 0.5, scale = 1.05,
                },
                z = -0.6, scale = 1.05, ang = Angle(0, -62, 90),
            }
        }
    }
}

ENT.ButtonMap["BackPPZ"] = {
    pos = Vector(416.99, 34.07, 27.89),
    ang = Angle(0, 90, 90),
    width = 482.6,
    height = 581,
    scale = 0.05,
    hideseat = 0.2,
    buttons = {
        {
            ID = "MasterTrainPowerOnSet", tooltip = "Включение бортсети",
            x = 34, y = 47, radius = 20,
            model = {
                var = "MasterTrainPowerOn",
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
            ID = "MasterTrainPowerOffSet", tooltip = "Выключение бортсети",
            x = 87, y = 47, radius = 20,
            model = {
                var = "MasterTrainPowerOff",
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
    pos = Vector(500.55, 5.45, -0.41),
    ang = Angle(0, -90, 70.431),
    width = 150,
    height = 117,
    scale = 0.10,
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
            x = 4.4,
            y = 112.5,
            radius = 2,
            model = {
                lamp = {
                    model = "models/metrostroi_train/81-760/81_760_led_small_mfdu.mdl",
                    ang = Angle(-90, 10, 0),
                    var = "MfduLamp",
                    z = -3,
                    color = Color(255, 255, 255)
                },
            }
        },
    }
}

_, _getX, _, _bw = _fncCoord(12, 425.8, 10)
_, _getY = _fncCoord(1, 20.2, 0)
ENT.ButtonMap["BUIKButtons"] = {
    pos = Vector(498.42, 32.65, -6.47),
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
    pos = Vector(489.76, 50.82, -11.33),
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
                z = 5,
                var = "CAMS1",
                speed = 16,
            }
        },
        {
            ID = "CAMS2Set",
            x = 26.5 * 1, y = 0, w = 20, h = 20,
            tooltip = "▲",
            model = {
                model = "models/metrostroi_train/81-760/81_760_button_cam_green.mdl",
                z = 5,
                var = "CAMS2",
                speed = 16,
            }
        },
        {
            ID = "CAMS3Set",
            x = 26.5 * 2, y = 0, w = 20, h = 20,
            tooltip = "3",
            model = {
                model = "models/metrostroi_train/81-760/81_760_button_cam_green.mdl",
                z = 5,
                var = "CAMS3",
                speed = 16,
            }
        },
        {
            ID = "CAMS4Set",
            x = 26.5 * 3, y = 0, w = 20, h = 20,
            tooltip = "4",
            model = {
                model = "models/metrostroi_train/81-760/81_760_button_cam_green.mdl",
                z = 5,
                var = "CAMS4",
                speed = 16,
            }
        },
        {
            ID = "CAMS5Set",
            x = 126, y = 0, w = 20, h = 20,
            tooltip = "5",
            model = {
                model = "models/metrostroi_train/81-760/81_760_button_cam_yellow.mdl",
                z = 5,
                var = "CAMS5",
                speed = 16,
            }
        },
        {
            ID = "CAMS6Set",
            x = 126 + 26.5 * 1, y = 0, w = 20, h = 20,
            tooltip = "6",
            model = {
                model = "models/metrostroi_train/81-760/81_760_button_cam_yellow.mdl",
                z = 5,
                var = "CAMS6",
                speed = 16,
            }
        },
        {
            ID = "CAMS7Set",
            x = 126 + 26.5 * 2, y = 0, w = 20, h = 20,
            tooltip = "7",
            model = {
                model = "models/metrostroi_train/81-760/81_760_button_cam_yellow.mdl",
                z = 5,
                var = "CAMS7",
                speed = 16,
            }
        },
        {
            ID = "CAMS8Set",
            x = 126 + 26.5 * 3, y = 0, w = 20, h = 20,
            tooltip = "8",
            model = {
                model = "models/metrostroi_train/81-760/81_760_button_cam_yellow.mdl",
                z = 5,
                var = "CAMS8",
                speed = 16,
            }
        },
        {
            ID = "CAMS9Set",
            x = 126 + 26.5 * 4, y = 0, w = 20, h = 20,
            tooltip = "9",
            model = {
                model = "models/metrostroi_train/81-760/81_760_button_cam_yellow.mdl",
                z = 5,
                var = "CAMS9",
                speed = 16,
            }
        },
        {
            ID = "CAMS10Set",
            x = 126 + 26.5 * 5, y = 0, w = 20, h = 20,
            tooltip = "10",
            model = {
                model = "models/metrostroi_train/81-760/81_760_button_cam_yellow.mdl",
                z = 5,
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

ENT.ButtonMap["CoupleCenteringF"] = {
    pos = Vector(520, -50, -50), ang = Angle(0, 90, 90),
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

ENT.ButtonMap["PassengerDoor"] = {
    pos = Vector(389, -28.5, 40),
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
    pos = Vector(387, 8, 40),
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

ENT.ClientProps["Salon"] = {
    model = "models/metrostroi_train/81-765_v1/765/salon.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hide = 2,
}

ENT.ClientProps["Cabin"] = {
    model = "models/metrostroi_train/81-765_v1/765/cab.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hide = 2,
}

for idx = 1, 6 do
    ENT.ClientProps["Headlights" .. idx] = {
        model = string.format("models/metrostroi_train/81-765_v1/765/headlights_moscow/headlights_moscow_%s%d.mdl", idx % 2 == 0 and "r" or "l", math.ceil(idx / 2)),
        pos = Vector(0, 0, 0),
        ang = Angle(0, 0, 0),
        nohide = true,
    }
end

ENT.ClientProps["HeadlightsBody"] = {
    model = "models/metrostroi_train/81-765_v1/765/headlights_moscow/headlights_moscow.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    nohide = true,
}

ENT.ClientProps["SalonLights"] = {
    model = "models/metrostroi_train/81-765_v1/lights/salon_lights.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hide = 2,
}

table.insert(ENT.ClientProps, {
    model = "models/metrostroi_train/81-765_v1/765/underwag_h.mdl",
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

-- ENT.ClientProps["KtiFan"] = {
--     model = "models/metrostroi_train/81-760/81_760_fan_kti.mdl",
--     pos = Vector(0, 0, 0),
--     ang = Angle(0, 0, 0),
--     hide = 1.5,
-- }

-- ENT.ClientProps["RFan"] = {
--     model = "models/metrostroi_train/81-760/81_760_fan_r.mdl",
--     pos = Vector(0, 0, 0),
--     ang = Angle(0, 0, 0),
--     hide = 1.5,
-- }

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
                sndid = "GvWrench",
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

ENT.ClientProps["DoorCabM"] = {
    model = "models/metrostroi_train/81-765_v1/765/door_cc.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hide = 2,
}

ENT.ClientProps["DoorCabL"] = {
    model = "models/metrostroi_train/81-765_v1/765/door_cl.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hide = 2,
    modelcallback = function(ent)
        if ent.Anims and ent.Anims["DoorCabL.window"] then
            ent.Anims["DoorCabL.window"].reload = true
        end
    end
}

ENT.ClientProps["DoorCabR"] = {
    model = "models/metrostroi_train/81-765_v1/765/door_cr.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hide = 2,
    modelcallback = function(ent)
        if ent.Anims and ent.Anims["DoorCabR.window"] then
            ent.Anims["DoorCabR.window"].reload = true
        end
    end
}

local bays = {
    {
        names = {"BayK35_1", "BayCoverK35_1"},
        models = {nil, "models/metrostroi_train/81-765_v1/765/bay_k35_door1.mdl"},
        tooltip = "Отсек К35, БУД №5, снаряжения",
        pos = Vector(417, -57.5, 48), ang = Angle(0, 90, 90),
        pos_cl = Vector(439.1, -50, 47.1), ang_cl = Angle(0, 198.28, 90),
        w = 100, h = 230, scale = 0.23
    }, {
        names = {"BayK35_2", "BayCoverK35_2"},
        models = {nil, "models/metrostroi_train/81-765_v1/765/bay_k35_door2.mdl"},
        tooltip = "Отсек К35, БУД №5, снаряжения",
        pos = Vector(412.33, -31.89, 48.33), ang = Angle(0.000, -178.650, 90.000),
        pos_cl = Vector(394.60, -31.91, 48.66), ang_cl = Angle(0.000, 73.170, 90.000),
        w = 80, h = 375, scale = 0.23
    }, {
        names = {"BayMain2", "BayCoverMain2"},
        models = {nil, "models/metrostroi_train/81-765_v1/765/bay_main_cover2.mdl"},
        tooltip = "Аппаратный отсек (Шкаф)",
        pos = Vector(417.08, 15.68, 36.82), ang = Angle(0.000, 90.000, 90.000),
        pos_cl = Vector(417.41, 30.81, 36.88), ang_cl = Angle(0.000, -9.140, 90.000),
        w = 70, h = 370, scale = 0.23
    }, {
        names = {"BayMain3", "BayCoverMain3"},
        models = {nil, "models/metrostroi_train/81-765_v1/765/bay_main_cover3.mdl"},
        tooltip = "Аппаратный отсек (БУП)",
        pos = Vector(417.08, 32.78, -19.00), ang = Angle(0.000, 90.000, 90.000),
        pos_cl = Vector(420.98, 32.61, -54.30), ang_cl = Angle(0.000, 90.000, 0.000),
        w = 115, h = 125, scale = 0.23
    },
}
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
    if bay.models[1] then
        ENT.ClientProps[bay.names[1]] = {
            model = bay.models[1],
            pos = Vector(0, 0, 0),
            ang = Angle(0, 0, 0),
            hideseat = 2,
        }
    end
end
ENT.ButtonMap["BayCoverBud5"] = nil
ENT.ButtonMap["BayCoverBud5_close"] = nil
ENT.ClientProps["BayCoverBud5"] = nil

ENT.ButtonMap["DoorBay1_close"] = {
    pos = Vector(354.5, 50.5, 38.6), ang = Angle(0, 0, 90),
    width = 37, height = 86, scale = 1,
    buttons = {{ ID = "DoorBay1_close", tooltip = "Закрыть", x = 0, y = 0, w = 37, h = 86 }}
}

ENT.ButtonMap["BayHandle"] = {
    pos = Vector(394.5, 9.2, -3.4), ang = Angle(0, 0, 90),
    width = 250, height = 110, scale = 0.05,
    buttons = {{ ID = "BayHandle", tooltip = "Открыть аппаратный отсек", x = 0, y = 0, w = 250, h = 110, }}
}

ENT.ClientProps["BayMain"] = {
    model = "models/metrostroi_train/81-765_v1/bays/bay_main.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hideseat = 2,
}

ENT.ClientProps["DoorBay1"] = {
    model = "models/metrostroi_train/81-765_v1/765/bay_main_cover.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hide = 2
}

ENT.ClientProps["BayHandle"] = {
    model = "models/metrostroi_train/81-765_v1/765/bay_main_handle.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hideseat = 0.5
}

ENT.ClientProps["PMV"] = {
    model = "models/metrostroi_train/81-765_v1/765/pmv_early.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hide = 2,
}

ENT.ClientProps["BtbuSdLabel"] = {
    model = "models/metrostroi_train/81-765_v1/765/pmv_btbu_sd.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hideseat = 0.5,
}

ENT.ClientProps["CabChairAdd"] = {
    model = "models/metrostroi_train/81-765_v1/765/cab_seat_lower.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hideseat = 0.5,
}

ENT.ClientProps["NotificationPaper"] = {
    model = "models/metrostroi_train/81-765/notification_paper.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hideseat = 0.5,
    callback = function(wag, ent)
        if Cfg765 and Cfg765.NotificationMaterial then
            ent:SetMaterial(Cfg765.NotificationMaterial)
        else
            wag:ShowHide("NotificationPaper", false)
        end
    end
}

ENT.ButtonMap["NotificationPaperBtn"] = {
    pos = Vector(490.18, 40.043, -7.35),
    -- from blender: X -> Z, Y -> X, Z -> Y
    ang = Angle(0, -75.487, 62.8),
    width = 38,
    height = 75,
    scale = 0.1,
    buttons = {
        {
            ID = "NotificationPaperBtn",
            x = 0,
            y = 0,
            w = 38,
            h = 75,
            tooltip = "Показать/скрыть уведомление",
            model = {
                var = "NotificationPaper",
                states = {"Common.ClientProp.Hide", "Common.ClientProp.Show"}
            }
        },
    }
}

-- ENT.ClientProps["wiper"] = {
--     model = "models/metrostroi_train/81-760/81_760_wiper.mdl",
--     pos = Vector(0, 0, 0),
--     ang = Angle(0, 0, 0),
--     hide = 2,
-- }

ENT.ClientProps["KRO"] = {
    model = "models/metrostroi_train/81-765_v1/765/reversor.mdl",
    pos = Vector(492.40, 34.11, -13.29),
    ang = Angle(0, 0, 0),
    hideseat = 0.5,
}

ENT.ClientProps["KRR"] = {
    model = "models/metrostroi_train/81-765_v1/765/reversor_red.mdl",
    pos = Vector(492.40, 36.98, -13.29),
    ang = Angle(0, 0, 0),
    hideseat = 0.5,
}

ENT.ClientProps["Controller"] = {
    model = "models/metrostroi_train/81-722/81-722_controller.mdl",
    pos = Vector(488.6, 24.7, -14.2),
    ang = Angle(0, 90, 0),
    hide = 2,
}

ENT.ClientProps["KM013"] = {
    model = "models/metrostroi_train/81-765_v1/765/krmsh_cab.mdl",
    pos = Vector(484.06, -11.59, -16.47),
    ang = Angle(-16.245, -21.177, 88.204),
    hideseat = 0.5,
}

if not ENT.ClientSounds["br_013"] then ENT.ClientSounds["br_013"] = {} end
table.insert(ENT.ClientSounds["br_013"], {"KM013", function(ent, _, var) return "br_013" end, 1, 1, 50, 1e3, Angle(-90, 0, 0)})

ENT.ClientProps["PB"] = {
    model = "models/metrostroi_train/81-765_v1/765/pb.mdl",
    pos = Vector(495.93, 37.23, -46.48),
    ang = Angle(0, 0, 0),
}

if not ENT.ClientSounds["PB"] then ENT.ClientSounds["PB"] = {} end
table.insert(ENT.ClientSounds["PB"], {"PB", function(ent, var) return var > 0 and "pb_on" or "pb_off" end, 1, 1, 50, 1e3, Angle(-90, 0, 0)})

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


ENT.ClientProps["MezhwagF"] = nil
ENT.ClientProps["FencePlF"] = nil

ENT.ClientProps["MnBc"] = {
    model = "models/metrostroi_train/81-765_v1/765/arrow_bc.mdl",
    pos = Vector(498.061, -13.866, -2.27934),
    ang = Angle(39.697, -142.968, 70.110),
    hideseat = 0.2,
}

ENT.ClientProps["MnTl"] = {
    model = "models/metrostroi_train/81-765_v1/765/arrow_tl.mdl",
    pos = Vector(495.455, -13.8682, -9.62502),
    ang = Angle(30.679, -139.217, 72.280),
    hideseat = 0.2,
}

ENT.ClientProps["MnBl"] = {
    model = "models/metrostroi_train/81-765_v1/765/arrow_bl.mdl",
    pos = Vector(495.455, -13.8682, -9.62502),
    ang = Angle(30.679, -139.217, 72.280),
    hideseat = 0.2,
}

ENT.ClientProps["cab_full"] = {
    model = "models/metrostroi_train/81-765_v1/lights/cab_lights_2.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hideseat = 1.1,
}

ENT.ClientProps["cab_half"] = {
    model = "models/metrostroi_train/81-765_v1/lights/cab_lights_1.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hideseat = 1.1,
}

ENT.ClientProps["VmLv"] = {
    model = "models/metrostroi_train/81-765_v1/765/arrow_vm.mdl",
    pos = Vector(502.661, 55.056, 27.0296),
    ang = Angle(2.666, 115.454, -98.410),
    hide = 0.2,
}

ENT.ClientProps["VmHv"] = {
    model = "models/metrostroi_train/81-765_v1/765/arrow_vm.mdl",
    pos = Vector(503.355, 55.1535, 22.5089),
    ang = Angle(2.666, 115.454, -98.410),
    hide = 0.2,
}


local LIGHT_HEADLIGHT = 4
local LIGHT_AREA_WHITE = 5
local LIGHT_AREA_RED = 6
local LIGHT_GLOW_WHITE_L = 7
local LIGHT_GLOW_WHITE_R = 8
local LIGHT_GLOW_RED_L = 9
local LIGHT_GLOW_RED_R = 10
local LIGHT_CAB = 11

table.Merge(ENT.Lights, {
    [LIGHT_HEADLIGHT] = {
        "headlight", Vector(520,0,-5.8), Angle(0,0,0), Color(220, 220, 220),
        farz = 5144, brightness = 8, hfov = 88, vfov = 88, shadows = 1, headlight = true,
    },
    [LIGHT_AREA_WHITE] = {
        "headlight", Vector(518, 0, 0), Angle(-10, 0, 0), Color(220, 220, 220),
        fov = 175, brightness = 0.1, farz = 450, shadows = 0, backlight = true,
        texture = "models/metrostroi_train/equipment/headlight2",
    },
    [LIGHT_AREA_RED] = {
        "headlight", Vector(518, 0, 0), Angle(-10, 0, 0), Color(255, 0, 0),
        fov = 175, brightness = 0.05, farz = 250, shadows = 0, backlight = true,
        texture = "models/metrostroi_train/equipment/headlight2",
    },
    [LIGHT_GLOW_WHITE_L] = {
        "light", Vector(520, 57, -5.7), Angle(0, 0, 0), Color(220, 220, 220),
        brightness = 0.2, scale = 4,
        texture = "sprites/light_glow02.vmt"
    },
    [LIGHT_GLOW_WHITE_R] = {
        "light", Vector(520, -57, -5.7), Angle(0, 0, 0), Color(220, 220, 220),
        brightness = 0.2, scale = 4,
        texture = "sprites/light_glow02.vmt"
    },
    [LIGHT_GLOW_RED_L] = {
        "light", Vector(515.55, 55, 22), Angle(0, 0, 0), Color(255, 20, 20),
        brightness = 0.2, scale = 4,
        texture = "sprites/light_glow02.vmt"
    },
    [LIGHT_GLOW_RED_R] = {
        "light", Vector(515.55, -55, 22), Angle(0, 0, 0), Color(255, 20, 20),
        brightness = 0.2, scale = 4,
        texture = "sprites/light_glow02.vmt"
    },
    [LIGHT_CAB] = { "dynamiclight", Vector(470, 0, 22), Angle(0,0,0), Color(220, 220, 220), brightness = 0.5, distance = 500 },
})

ENT.ButtonMap["MFDU"] = {
    pos = Vector(500.71, 4.24, -0.7),
    ang = Angle(0, -90, 70.431),
    width = 1024,
    height = 768,
    scale = 0.0124,
    hideseat = 0.2,
    system = "MFDU",
    hide = 0.5,
}

ENT.ButtonMap["BUIK"] = {
    pos = Vector(500.93, 37.93, -0.22),
    ang = Angle(0, -90, 70.431),
    width = 2716,
    height = 496,
    scale = 0.01,
    system = "BUIK",
    hide = 0.5,
}

ENT.ButtonMap["CAMS"] = {
    pos = Vector(491.82, 54.61, -0.59),
    ang = Angle(0.000, -59.841, 72.914),
    width = 1280,
    height = 1024,
    scale = 0.0106,
    system = "CAMS",
    hide = 0.5,
}

ENT.ButtonMap["BMIK"] = {
    pos = Vector(502.51, -7.86, 51),
    ang = Angle(0, 90, 90),
    width = 1800,
    height = 300,
    scale = 0.0295,
    nohide = true,
}

ENT.ButtonMap["BNMIK"] = {
    pos = Vector(520.84, 13.1, -36.86),
    ang = Angle(0.000, 90.000, 89.296),
    width = 600,
    height = 300,
    scale = 0.027,
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


local buikHelper = {
    {
        ID = "!Speed",
        x = 2486 - 740, y = 0, w = 740, h = 496,
        tooltip = "Скорость",
        tooltipFunc = function(wag)
            local freq = not wag:GetNW2Bool("Skif:NoFreq", false) and wag.BUIK.MaxSpeed
            local nextFreq = not wag:GetNW2Bool("Skif:NextNoFreq", false) and wag.BUIK.NextSpeed
            return Format("Фактическая %d км/ч\nДопустимая %s%s",
                math.floor(wag:GetPackedRatio("Speed", 0)),
                freq and Format("%d км/ч", freq) or "ОЧ",
                wag.BUIK.NextSpeed and (nextFreq and Format("\nПредупредительная %d км/ч", nextFreq) or "\nОЧ") or "")
        end
    },

    {
        ID = "!Page",
        x = 266, y = 496 - 70, w = 800, h = 70,
        tooltip = "Страница",
        tooltipFunc = function(wag)
            local pg = wag.BUIK.Page or 0
            return pg == 1 and "Записи информатора" or pg == 2 and "Записи доп. информации" or pg == 3 and "Выбор конечной станции" or pg == 4 and "Выбор линии (конфига)" or "Н/Д"
        end
    }, {
        ID = "!AutoPlay",
        x = 1066, y = 496 - 70, w = 398 / 2, h = 70,
        tooltip = "Автовоспр. записи на прибытие\nВключается через Metrostroi Advanced",
        tooltipFunc = function(wag)
            return wag.BuikAutoPlay and "Включено" or "Выключено"
        end
    }, {
        ID = "!LineSC",
        x = 1066 + 398 / 2, y = 496 - 70, w = 398 / 2, h = 70,
        tooltip = "Не используется",
    }, {
        ID = "!Odometer",
        x = 1464, y = 496 - 70, w = 2486 - 740 - 1464, h = 70,
        tooltip = "Одометер (пробег)",
        tooltipFunc = function(wag) return Format("%d км", wag.BUIK.Odometer or 0) end
    },

    {
        ID = "!WagonHead",
        x = 0, y = 0, w = 64, h = 200,
        tooltip = "Активная кабина",
        tooltipFunc = function(wag) return wag.BUIK.ActiveCab and "Активна" or "Неактивна" end
    }, {
        ID = "!RouteNum",
        x = 0, y = 200, w = 266, h = 496 - 140 - 200,
        tooltip = "Номер маршрута\nДля смены - выключить АТС1, АТС2, затем\nвключить и следовать инструкциям на МФДУ",
        tooltipFunc = function(wag) return wag.BUIK.RouteNum or "Н/Д" end
    }, {
        ID = "!LastSt",
        x = 0, y = 496 - 140, w = 266, h = 70,
        tooltip = "Конечная станция",
        tooltipFunc = function(wag) return wag.BUIK.LastStation or "Н/Д" end
    }, {
        ID = "!Clock",
        x = 0, y = 496 - 70, w = 266, h = 70,
        tooltip = "Время",
        tooltipFunc = function(wag) return wag.BUIK.Time or "Н/Д" end
    },

    {
        ID = "!FreqMode",
        x = 1050, y = 200, w = 696 / 4, h = 113,
        tooltip = "Режим дешифратора АЛС",
        tooltipFunc = function(wag) return wag.BUIK.StateText and wag.BUIK.StateText[1] or nil end
    }, {
        ID = "!ATS1",
        x = 1050 + 1 * 696 / 4, y = 200, w = 696 / 4, h = 113,
        tooltip = "Состояние полукомплекта БАРС1",
        tooltipFunc = function(wag)
            local state = wag:GetNW2Int("BUIK:State2", 1)
            return state == 3 and "Запрет движения" or state == 4 and "Разрешение движения" or state == 5 and "Запрет тягового режима" or "Шунтирован"
        end
    }, {
        ID = "!ATS2",
        x = 1050 + 2 * 696 / 4, y = 200, w = 696 / 4, h = 113,
        tooltip = "Состояние полукомплекта БАРС2",
        tooltipFunc = function(wag)
            local state = wag:GetNW2Int("BUIK:State3", 1)
            return state == 3 and "Запрет движения" or state == 4 and "Разрешение движения" or state == 5 and "Запрет тягового режима" or "Шунтирован"
        end
    }, {
        ID = "!AtsBlockS",
        x = 1050 + 3 * 696 / 4, y = 200, w = 696 / 4, h = 113,
        tooltip = "Режим блокиратора АТС",
        tooltipFunc = function(wag)
            local text = wag.BUIK.StateText and wag.BUIK.StateText[4] or nil
            return text == "ШТАТ" and "Штатный режим" or text == "АТС1" and "АТС2 шунтирован" or text == "АТС2" and "АТС1 шунтирован" or text == "УОС" and "Режим УОС" or "Н/Д"
        end
    }
}

local buikHelperX4 = table.Copy(buikHelper)
table.Add(buikHelperX4, {
    {
        ID = "!ArsZero",
        x = 1050, y = 313, w = 696 / 4, h = 113,
        tooltip = "Частота АРС 0",
        tooltipFunc = function(wag) return wag:GetNW2Int("BUIK:State6", 1) == 3 and "Присутствует" or "Норма" end
    }, {
        ID = "!ArsNoFq",
        x = 1050 + 1 * 696 / 4, y = 313, w = 696 / 4, h = 113,
        tooltip = "Отсутствие частоты",
        tooltipFunc = function(wag) return wag:GetNW2Int("BUIK:State7", 1) == 3 and "Частота отсутствует" or "Норма" end
    }, {
        ID = "!ArsAo",
        x = 1050 + 2 * 696 / 4, y = 313, w = 696 / 4, h = 113,
        tooltip = "Сигнал Абсолютной Остановки",
        tooltipFunc = function(wag) return wag:GetNW2Int("BUIK:State8", 1) == 3 and "Присутствует" or "Норма" end
    }, {
        ID = "!BOSD",
        x = 1050 + 3 * 696 / 4, y = 313, w = 696 / 4, h = 113,
        tooltip = "Режим движения без контроля дверей",
        tooltipFunc = function(wag) return wag:GetNW2Int("BUIK:State9", 1) == 3 and "Включено" or "Норма" end
    }
})

table.Add(buikHelper, {
    {
        ID = "!LN",
        x = 1050, y = 313, w = 696 / 5, h = 113,
        tooltip = "Признак направления движения (ЛН)",
        tooltipFunc = function(wag) return wag:GetNW2Int("BUIK:State5", 1) == 3 and "Отсутствует" or "Норма" end
    }, {
        ID = "!ArsZero",
        x = 1050 + 1 * 696 / 5, y = 313, w = 696 / 5, h = 113,
        tooltip = "Частота АРС 0",
        tooltipFunc = function(wag) return wag:GetNW2Int("BUIK:State6", 1) == 3 and "Присутствует" or "Норма" end
    }, {
        ID = "!ArsNoFq",
        x = 1050 + 2 * 696 / 5, y = 313, w = 696 / 5, h = 113,
        tooltip = "Отсутствие частоты",
        tooltipFunc = function(wag) return wag:GetNW2Int("BUIK:State7", 1) == 3 and "Частота отсутствует" or "Норма" end
    }, {
        ID = "!ArsAo",
        x = 1050 + 3 * 696 / 5, y = 313, w = 696 / 5, h = 113,
        tooltip = "Сигнал Абсолютной Остановки",
        tooltipFunc = function(wag) return wag:GetNW2Int("BUIK:State8", 1) == 3 and "Присутствует" or "Норма" end
    }, {
        ID = "!BOSD",
        x = 1050 + 4 * 696 / 5, y = 313, w = 696 / 5, h = 113,
        tooltip = "Режим движения без контроля дверей",
        tooltipFunc = function(wag) return wag:GetNW2Int("BUIK:State9", 1) == 3 and "Включено" or "Норма" end
    }
})

ZMS.ScreenHelper("BUIK", nil, "Mst4", 0, 0, 2486, 496, buikHelperX4)
ZMS.ScreenHelper("BUIK", nil, "Mst5", 0, 0, 2486, 496, buikHelper)


local sarmat9 = {
    {
        ID = "!Speed",
        x = 2486 - 739, y = 0, w = 739, h = 416,
        tooltip = "Скорость",
        tooltipFunc = function(wag)
            local freq = not wag:GetNW2Bool("Skif:NoFreq", false) and wag.BUIK.MaxSpeed
            local nextFreq = not wag:GetNW2Bool("Skif:NextNoFreq", false) and wag.BUIK.NextSpeed
            return Format("Фактическая %d км/ч\n%s%s",
                math.floor(wag:GetPackedRatio("Speed", 0)),
                freq and Format("Допустимая %d км/ч", freq) or "ОЧ",
                wag.BUIK.NextSpeed and (nextFreq and Format("\nПредупредительная %d км/ч", nextFreq) or "\nОЧ") or "")
        end
    },

    {
        ID = "!Page",
        x = 0, y = 160, w = 220, h = 74,
        tooltip = "Страница",
        tooltipFunc = function(wag)
            local pg = wag.BUIK.Page or 0
            return pg == 1 and "Записи информатора" or pg == 2 and "Записи доп. информации" or pg == 3 and "Выбор конечной станции" or pg == 4 and "Выбор линии (конфига)" or "Н/Д"
        end
    }, {
        ID = "!AutoPlay",
        x = 0, y = 237, w = 220, h = 262 / 3,
        tooltip = "Автовоспр. записи на прибытие\nВключается через Metrostroi Advanced",
        tooltipFunc = function(wag)
            return wag.BuikAutoPlay and "Включено" or "Выключено"
        end
    }, {
        ID = "!LineSC",
        x = 0, y = 237 + 262 / 3, w = 220, h = 262 / 3,
        tooltip = "Не используется",
    }, {
        ID = "!PassCall",
        x = 0, y = 237 + 2 * 262 / 3, w = 220, h = 262 / 3,
        tooltip = "Вызов пассажира",
    },

    {
        ID = "!RouteNum",
        x = 947, y = 160, w = 170, h = 170,
        tooltip = "Номер маршрута\nДля смены - выключить АТС1, АТС2, затем\nвключить и следовать инструкциям на МФДУ",
        tooltipFunc = function(wag) return wag.BUIK.RouteNum or "Н/Д" end
    }, {
        ID = "!LastSt",
        x = 947 + 170, y = 160, w = 800 - 170, h = 170,
        tooltip = "Конечная станция",
        tooltipFunc = function(wag) return wag.BUIK.LastStation or "Н/Д" end
    }
}

local sarmat8 = table.Copy(sarmat9)
table.Add(sarmat8, {
    {
        x = 947, y = 496 - 80, w = 1539 / 8, h = 80,
        ID = "!FreqMode",
        tooltip = "Режим дешифратора АЛС",
        tooltipFunc = function(wag) return wag.BUIK.StateText and wag.BUIK.StateText[1] or nil end
    }, {
        x = 947 + 1 * 1539 / 8, y = 496 - 80, w = 1539 / 8, h = 80,
        ID = "!ATS1",
        tooltip = "Состояние полукомплекта БАРС1",
        tooltipFunc = function(wag)
            local state = wag:GetNW2Int("BUIK:State2", 1)
            return state == 3 and "Запрет движения" or state == 4 and "Разрешение движения" or state == 5 and "Запрет тягового режима" or "Шунтирован"
        end
    }, {
        x = 947 + 2 * 1539 / 8, y = 496 - 80, w = 1539 / 8, h = 80,
        ID = "!ATS2",
        tooltip = "Состояние полукомплекта БАРС2",
        tooltipFunc = function(wag)
            local state = wag:GetNW2Int("BUIK:State3", 1)
            return state == 3 and "Запрет движения" or state == 4 and "Разрешение движения" or state == 5 and "Запрет тягового режима" or "Шунтирован"
        end
    }, {
        x = 947 + 3 * 1539 / 8, y = 496 - 80, w = 1539 / 8, h = 80,
        ID = "!AtsBlockS",
        tooltip = "Режим блокиратора АТС",
        tooltipFunc = function(wag)
            local text = wag.BUIK.StateText and wag.BUIK.StateText[4] or nil
            return text == "ШТАТ" and "Штатный режим" or text == "АТС1" and "АТС2 шунтирован" or text == "АТС2" and "АТС1 шунтирован" or text == "УОС" and "Режим УОС" or "Н/Д"
        end
    }, {
        x = 947 + 4 * 1539 / 8, y = 496 - 80, w = 1539 / 8, h = 80,
        ID = "!ArsZero",
        tooltip = "Частота АРС 0",
        tooltipFunc = function(wag) return wag:GetNW2Int("BUIK:State6", 1) == 3 and "Присутствует" or "Норма" end
    }, {
        x = 947 + 5 * 1539 / 8, y = 496 - 80, w = 1539 / 8, h = 80,
        ID = "!ArsAo",
        tooltip = "Сигнал Абсолютной Остановки",
        tooltipFunc = function(wag) return wag:GetNW2Int("BUIK:State8", 1) == 3 and "Присутствует" or "Норма" end
    }, {
        x = 947 + 6 * 1539 / 8, y = 496 - 80, w = 1539 / 8, h = 80,
        ID = "!ArsNoFq",
        tooltip = "Отсутствие частоты",
        tooltipFunc = function(wag) return wag:GetNW2Int("BUIK:State7", 1) == 3 and "Частота отсутствует" or "Норма" end
    }, {
        x = 947 + 7 * 1539 / 8, y = 496 - 80, w = 1539 / 8, h = 80,
        ID = "!BOSD",
        tooltip = "Режим движения без контроля дверей",
        tooltipFunc = function(wag) return wag:GetNW2Int("BUIK:State9", 1) == 3 and "Включено" or "Норма" end
    }
})

table.Add(sarmat9, {
    {
        x = 947, y = 496 - 80, w = 1539 / 9, h = 80,
        ID = "!FreqMode",
        tooltip = "Режим дешифратора АЛС",
        tooltipFunc = function(wag) return wag.BUIK.StateText and wag.BUIK.StateText[1] or nil end
    }, {
        x = 947 + 1 * 1539 / 9, y = 496 - 80, w = 1539 / 9, h = 80,
        ID = "!ATS1",
        tooltip = "Состояние полукомплекта БАРС1",
        tooltipFunc = function(wag)
            local state = wag:GetNW2Int("BUIK:State2", 1)
            return state == 3 and "Запрет движения" or state == 4 and "Разрешение движения" or state == 5 and "Запрет тягового режима" or "Шунтирован"
        end
    }, {
        x = 947 + 2 * 1539 / 9, y = 496 - 80, w = 1539 / 9, h = 80,
        ID = "!ATS2",
        tooltip = "Состояние полукомплекта БАРС2",
        tooltipFunc = function(wag)
            local state = wag:GetNW2Int("BUIK:State3", 1)
            return state == 3 and "Запрет движения" or state == 4 and "Разрешение движения" or state == 5 and "Запрет тягового режима" or "Шунтирован"
        end
    }, {
        x = 947 + 3 * 1539 / 9, y = 496 - 80, w = 1539 / 9, h = 80,
        ID = "!AtsBlockS",
        tooltip = "Режим блокиратора АТС",
        tooltipFunc = function(wag)
            local text = wag.BUIK.StateText and wag.BUIK.StateText[4] or nil
            return text == "ШТАТ" and "Штатный режим" or text == "АТС1" and "АТС2 шунтирован" or text == "АТС2" and "АТС1 шунтирован" or text == "УОС" and "Режим УОС" or "Н/Д"
        end
    }, {
        x = 947 + 4 * 1539 / 9, y = 496 - 80, w = 1539 / 9, h = 80,
        ID = "!LN",
        tooltip = "Признак направления движения (ЛН)",
        tooltipFunc = function(wag) return wag:GetNW2Int("BUIK:State5", 1) == 3 and "Отсутствует" or "Норма" end
    }, {
        x = 947 + 5 * 1539 / 9, y = 496 - 80, w = 1539 / 9, h = 80,
        ID = "!ArsZero",
        tooltip = "Частота АРС 0",
        tooltipFunc = function(wag) return wag:GetNW2Int("BUIK:State6", 1) == 3 and "Присутствует" or "Норма" end
    }, {
        x = 947 + 6 * 1539 / 9, y = 496 - 80, w = 1539 / 9, h = 80,
        ID = "!ArsAo",
        tooltip = "Сигнал Абсолютной Остановки",
        tooltipFunc = function(wag) return wag:GetNW2Int("BUIK:State8", 1) == 3 and "Присутствует" or "Норма" end
    }, {
        x = 947 + 7 * 1539 / 9, y = 496 - 80, w = 1539 / 9, h = 80,
        ID = "!ArsNoFq",
        tooltip = "Отсутствие частоты",
        tooltipFunc = function(wag) return wag:GetNW2Int("BUIK:State7", 1) == 3 and "Частота отсутствует" or "Норма" end
    }, {
        x = 947 + 8 * 1539 / 9, y = 496 - 80, w = 1539 / 9, h = 80,
        ID = "!BOSD",
        tooltip = "Режим движения без контроля дверей",
        tooltipFunc = function(wag) return wag:GetNW2Int("BUIK:State9", 1) == 3 and "Включено" or "Норма" end
    }
})

ZMS.ScreenHelper("BUIK", nil, "Sarmat8", 0, 0, 2486, 496, sarmat8)
ZMS.ScreenHelper("BUIK", nil, "Sarmat9", 0, 0, 2486, 496, sarmat9)


local wagW = (2486 - 740 - 128) / 8
local sarmatWagW = (2486 - 739) / 8
for k, g in ipairs({"Mst4", "Mst5", "Sarmat8", "Sarmat9"}) do
    for idx = 1, 8 do
        ZMS.ScreenHelper(
            "BUIK", g, "Wagon" .. idx,
            (k < 3 and 64 or 6) + (idx - 1) * (k < 3 and wagW or sarmatWagW), 0,
            k < 3 and wagW or sarmatWagW, k < 3 and 200 or 160, {
            {
                ID = "!Wagon" .. idx,
                x = 0, y = 0,
                w = k < 3 and wagW or sarmatWagW, h = 200,
                tooltip = idx > 1 and ("Вагон №" .. idx) or "Головной вагон",
                tooltipFunc = function(wag) return wag.BUIK.Wagons and (
                    wag.BUIK.Wagons[idx] == 3 and "Есть проблемы, см. МФДУ" or
                    wag.BUIK.Wagons[idx] == 2 and "Сработка противозажатия" or
                    wag.BUIK.Wagons[idx] == 1 and "Двери не закрыты"
                ) or "Норма" end
            }
        }, true)
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

function ENT:Initialize()
    local BaseClass = scripted_ents.GetStored("gmod_81-765_base").t
    BaseClass.Initialize(self)
    self.MFDUrt = self:CreateRT("765MFDU", 1024, 768)
    self.BUIKscr = self:CreateRT("765BUIK", 2716, 496)
    self.CAMS = self:CreateRT("760CAMS", 1024, 768)
    self.ASNP = self:CreateRT("760ASNP", 512, 128)
    self.PPUP = self:CreateRT("765PPUP", 512, 128)
    -- self.RVSScr = self:CreateRT("760RVS", 256, 256)
    self.BMIK = self:CreateRT("765BMIK", 1380, 230)
    self.BNMIK = self:CreateRT("765BNMIK", 380, 190)
    self.BLIK = self:CreateRT("765BLIK", 380, 380)
end

function ENT:Think(...)
    local BaseClass = scripted_ents.GetStored("gmod_81-765_base").t
    local retval =  BaseClass.Think(self, ...)

    -- local PanelLighting = self:GetPackedBool("PanelLighting")
    -- self:SetLightPower(11, PanelLighting)
    -- self:SetLightPower(12, PanelLighting)

    local col = render.GetLightColor(self:GetPos() + 530 * self:GetForward())
    local val = math.floor((col.x * 255 + col.y * 255 + col.z * 255) * 5) / 5
    if self.LightVal ~= val and CurTime() - (self.LightValTimer or 0) > 0 or not self.LightVal then
        self.LightValTimer = CurTime() + 0.5
        self.LightVal = val
    end

    local headl = math.max(0, self:GetPackedRatio("Headlights") + (self.LightVal >= 6 and self:GetPackedRatio("Headlights") == 1 and -0.5 or 0))
    self:SetLightPower(LIGHT_HEADLIGHT, headl > 0, headl)

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

    local headlEnt = self.GlowingLights[LIGHT_HEADLIGHT]
    if IsValid(headlEnt) then
        headlEnt:SetEnableShadows(true)
        if headl < 1 and headlEnt:GetFarZ() > 5500 then headlEnt:SetFarZ(5500) end
        if headl == 1 and headlEnt:GetFarZ() < 9000 then headlEnt:SetFarZ(9000) end
    end

    self:SetLightPower(LIGHT_AREA_WHITE, not rl and hl12, hl12 and 1 or 0)
    self:SetLightPower(LIGHT_AREA_RED, rl, rl and 1 or 0)
    self:SetLightPower(LIGHT_GLOW_WHITE_L, hl12, hl12 and 1 or 0)
    self:SetLightPower(LIGHT_GLOW_WHITE_R, hl12, hl12 and 1 or 0)
    self:SetLightPower(LIGHT_GLOW_RED_L, rl, rl and 1 or 0)
    self:SetLightPower(LIGHT_GLOW_RED_R, rl, rl and 1 or 0)

    local cabl_full = self:GetPackedBool("CabinEnabledFull")
    local cabl_half = self:GetPackedBool("CabinEnabledEmer")
    cabl_full = self:Animate("CabFull", cabl_full and 1 or 0, 0, 1, 12, false)
    cabl_half = self:Animate("CabEmer", cabl_half and 1 or 0, 0, 1, 12, false)
    self:ShowHideSmooth("cab_full", cabl_full)
    self:ShowHideSmooth("cab_half", cabl_half)
    self:SetLightPower(LIGHT_CAB, true, cabl_full * 0.8 + cabl_half * 0.2)

    local k35_1 = self:HandleDoorState("K35C1", "door_k35_1", "BayCoverK35_1", "BayCoverK35_1", 0.1, 0.2)
    local k35_2 = self:HandleDoorState("K35C2", "door_k35_2", "BayCoverK35_2", "BayCoverK35_2", 0.1, 0.2)
    self:ShowHide("K35", k35_1 or k35_2)
    self:HidePanel("K35", not k35_1 and not k35_2)

    self:Animate("BayHandle", self:GetPackedBool("BayHandle") and 1 or 0, 0, 1, 1.5, false)
    local bm1 = self:HandleDoorState("BayMain1Val", "door_bay_1", "DoorBay1", "DoorBay1", 0, 0, false, true)
    local bm2 = self:HandleDoorState("BayMain2Val", "door_bay_2", "BayCoverMain2", "BayCoverMain2", 0.1, 0.2)
    local bm3 = self:HandleDoorState("BayMain3Val", "door_bay_3", "BayCoverMain3", "BayCoverMain3", 0.1, 0.2)
    self:ShowHide("BayMain", bm1 or bm2 or bm3)

    return retval
end

function ENT:DrawPost(special)
    local BaseClass = scripted_ents.GetStored("gmod_81-765_base").t
    BaseClass.DrawPost(self, special)

    self.RTMaterial:SetTexture("$basetexture", self.MFDUrt)
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

    self.RTMaterial:SetTexture("$basetexture", self.PPUP)
    self:DrawOnPanel("PPUP", function(...)
        surface.SetMaterial(self.RTMaterial)
        surface.SetDrawColor(255, 255, 255)
        surface.DrawTexturedRectRotated(256, 74, 512, 150, 0)
    end)

    -- self.RTMaterial:SetTexture("$basetexture", self.RVSScr)
    -- self:DrawOnPanel("RVSScreen", function(...)
    --     surface.SetMaterial(self.RTMaterial)
    --     surface.SetDrawColor(255, 255, 255)
    --     surface.DrawTexturedRectRotated(128, 128, 256, 256, 0)
    -- end)

    self.RTMaterial:SetTexture("$basetexture", self.CAMS)
    self:DrawOnPanel("CAMS", function(...)
        surface.SetMaterial(self.RTMaterial)
        surface.SetDrawColor(255, 255, 255)
        surface.DrawTexturedRectRotated(1280 / 2, 512, 1280, 1024, 0)
    end)

    self.RTMaterial:SetTexture("$basetexture", self.BUIKscr)
    self:DrawOnPanel("BUIK", function(...)
        surface.SetMaterial(self.RTMaterial)
        surface.SetDrawColor(255, 255, 255)
        surface.DrawTexturedRectRotated(2716 / 2, 496 / 2, 2716, 496, 0)
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

Metrostroi.GenerateClientProps()
