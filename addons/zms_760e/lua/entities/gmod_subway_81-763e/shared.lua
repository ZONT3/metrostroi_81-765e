--------------------------------------------------------------------------------
-- 81-763Э «Чурá» by ZONT_ a.k.a. enabled person
-- Based on code by Cricket, Hell et al.
--------------------------------------------------------------------------------
ENT.Type = "anim"
ENT.Base = "gmod_subway_base"
ENT.PrintName = "81-763E PvVZ"
ENT.Author = ""
ENT.Contact = ""
ENT.Purpose = ""
ENT.Instructions = ""
ENT.Category = "Metrostroi (trains)"
ENT.SkinsType = "81-760e"
ENT.Model = "models/metrostroi_train/81-760e/81_761e_body.mdl"
ENT.Spawnable = true
ENT.AdminSpawnable = false


local function GetDoorPosition(i, k, j)
    if j == 0 then
        return Vector(381 - 36.0 + 1 * k - 0.85 * (k == 1 and 1 or 0) - 230 * i, -66 * (1 - 2 * k), -1)
    else
        return Vector(381 - 36.0 + 1 * k - 0.85 * (k == 1 and 1 or 0) - 230 * i, -66 * (1 - 2 * k), -1)
    end
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

function ENT:PassengerCapacity()
    return 300
end

function ENT:GetStandingArea()
    return Vector(-450, -30, -53), Vector(380, 30, -53)
end

local function GetDoorPosition(i, k)
    return Vector(377.0 - 36.0 + 1 * k - 230 * i, -64 * (1 - 2 * k), -10)
end

function ENT:InitializeSounds()
    self.BaseClass.InitializeSounds(self)

    for i = 1, 8 do
        self.SoundNames["vent" .. i] = {
            loop = true,
            "subway_trains/720/vent_mix.wav"
        }

        self.SoundPositions["vent" .. i] = {100, 1e9, Vector(-413 + (i - 1) * 117, 0, 30), 0.5}
    end

    self.SoundNames["release"] = {
        loop = true,
        "subway_trains/765/rumble/pneumo_release2.wav"
    }

    self.SoundPositions["release"] = {
        320, --FIXME: Pos
        1e9,
        Vector(-183, 0, -70),
        0.4
    }

    self.SoundNames["parking_brake"] = {
        loop = true,
        "subway_trains/common/pneumatic/autostop_loop.wav"
    }

    self.SoundPositions["parking_brake"] = {400, 1e9, Vector(-183, 0, -70), 0.95}
    self.SoundNames["front_isolation"] = {
        loop = true,
        "subway_trains/common/pneumatic/isolation_leak.wav"
    }

    self.SoundPositions["front_isolation"] = {300, 1e9, Vector(500, 0, -63), 1}
    self.SoundNames["rear_isolation"] = {
        loop = true,
        "subway_trains/common/pneumatic/isolation_leak.wav"
    }
    self.SoundPositions["rear_isolation"] = {300, 1e9, Vector(-469, 0, -63), 1}

    self.SoundNames["pak_on"] = "subway_trains/717/switches/rc_on.mp3"
    self.SoundNames["pak_off"] = "subway_trains/717/switches/rc_off.mp3"

    self.SoundNames["gv_f"] = {"subway_trains/717/kv70/reverser_0-b_1.mp3", "subway_trains/717/kv70/reverser_0-b_2.mp3"}
    self.SoundNames["gv_b"] = {"subway_trains/717/kv70/reverser_b-0_1.mp3", "subway_trains/717/kv70/reverser_b-0_2.mp3"}
    self.SoundPositions["gv_f"] = {80, 1e9, Vector(126.4, 50, -60 - 23.5), 0.8}
    self.SoundPositions["gv_b"] = {80, 1e9, Vector(126.4, 50, -60 - 23.5), 0.8}
    self.SoundNames["door_cab_open"] = {"subway_trains/720/door/door_torec_open.mp3", "subway_trains/720/door/door_torec_open2.mp3"}
    self.SoundNames["door_cab_close"] = {"subway_trains/720/door/door_torec_close.mp3", "subway_trains/720/door/door_torec_close2.mp3"}
    self.SoundNames["door_cab_roll"] = {"subway_trains/720/door/cabdoor_roll1.mp3", "subway_trains/720/door/cabdoor_roll2.mp3", "subway_trains/720/door/cabdoor_roll3.mp3", "subway_trains/720/door/cabdoor_roll4.mp3"}

    self.SoundNames["battery_on_1"]   = "subway_trains/722/battery/battery_off_1.mp3"
    self.SoundPositions["battery_on_1"] = {100,1e9,Vector(182,50,-75),0.5}
    self.SoundNames["battery_off_1"]   = "subway_trains/722/battery/battery_off_1.mp3"
    self.SoundPositions["battery_off_1"] = {100,1e9,Vector(182,50,-75),0.5}
    self.SoundNames["battery_off_2"]   = "subway_trains/722/battery/battery_off_2.mp3"
    self.SoundPositions["battery_off_2"] = {100,1e9,Vector(182,50,-75),0.5}
    self.SoundNames["battery_pneumo"]   = "subway_trains/722/battery/battery_pneumo.mp3"
    self.SoundPositions["battery_pneumo"] = {200,1e9,Vector(182,50,-75),0.1}

    self.SoundNames["rolling_10"] = {loop=true,"subway_trains/765/rumble/rolling/rolling_10.wav"}
    self.SoundNames["rolling_45"] = {loop=true,"subway_trains/765/rumble/rolling/rolling_45.wav"}
    self.SoundNames["rolling_60"] = {loop=true,"subway_trains/765/rumble/rolling/rolling_60.wav"}
    self.SoundNames["rolling_70"] = {loop=true,"subway_trains/765/rumble/rolling/rolling_70.wav"}
    self.SoundPositions["rolling_10"] = {485,1e9,Vector(0,0,0),0.20}
    self.SoundPositions["rolling_45"] = {485,1e9,Vector(0,0,0),0.50}
    self.SoundPositions["rolling_60"] = {485,1e9,Vector(0,0,0),0.55}
    self.SoundPositions["rolling_70"] = {485,1e9,Vector(0,0,0),0.60}
    self.SoundNames["rolling_low"] = {loop=true,"subway_trains/765/rumble/rolling/rolling_outside_low.wav"}
    self.SoundNames["rolling_medium1"] = {loop=true,"subway_trains/765/rumble/rolling/rolling_outside_medium1.wav"}
    self.SoundNames["rolling_medium2"] = {loop=true,"subway_trains/765/rumble/rolling/rolling_outside_medium2.wav"}
    self.SoundNames["rolling_high2"] = {loop=true,"subway_trains/765/rumble/rolling/rolling_outside_high2.wav"}
    self.SoundPositions["rolling_low"] = {480,1e12,Vector(0,0,0),0.6*0.4}
    self.SoundPositions["rolling_medium1"] = {480,1e12,Vector(0,0,0),0.90*0.4}
    self.SoundPositions["rolling_medium2"] = {480,1e12,Vector(0,0,0),0.90*0.4}
    self.SoundPositions["rolling_high2"] = {480,1e12,Vector(0,0,0),1.00*0.4}

    for i = 0, 3 do
        for k = 0, 1 do
            self.SoundNames["door" .. i .. "x" .. k .. "r0"] = {loop = true, "subway_trains/765/doors/door_open_loop1.mp3"}
            self.SoundPositions["door" .. i .. "x" .. k .. "r0"] = {100, 1e9, GetDoorPosition(i, k), 0.8}
            self.SoundNames["door" .. i .. "x" .. k .. "r1"] = {loop = true, "subway_trains/765/doors/door_open_loop2.mp3"}
            self.SoundPositions["door" .. i .. "x" .. k .. "r1"] = {100, 1e9, GetDoorPosition(i, k), 0.8}

            self.SoundNames["door" .. i .. "x" .. k .. "o0"] = {"subway_trains/765/doors/door_open_end1.mp3"}
            self.SoundPositions["door" .. i .. "x" .. k .. "o0"] = {150, 1e9, GetDoorPosition(i, k), 1.0}
            self.SoundNames["door" .. i .. "x" .. k .. "o1"] = {"subway_trains/765/doors/door_open_end2.mp3"}
            self.SoundPositions["door" .. i .. "x" .. k .. "o1"] = {150, 1e9, GetDoorPosition(i, k), 1.0}

            self.SoundNames["door" .. i .. "x" .. k .. "op0"] = {"subway_trains/765/doors/door_open_start1.mp3"}
            self.SoundPositions["door" .. i .. "x" .. k .. "op0"] = {150, 1e9, GetDoorPosition(i, k), 1.0}
            self.SoundNames["door" .. i .. "x" .. k .. "op1"] = {"subway_trains/765/doors/door_open_start2.mp3"}
            self.SoundPositions["door" .. i .. "x" .. k .. "op1"] = {150, 1e9, GetDoorPosition(i, k), 1.0}

            self.SoundNames["door" .. i .. "x" .. k .. "c0"] = {"subway_trains/765/doors/door_close_end1.mp3"}
            self.SoundPositions["door" .. i .. "x" .. k .. "c0"] = {250, 1e9, GetDoorPosition(i, k), 1.0}
            self.SoundNames["door" .. i .. "x" .. k .. "c1"] = {"subway_trains/765/doors/door_close_end2.mp3"}
            self.SoundPositions["door" .. i .. "x" .. k .. "c1"] = {250, 1e9, GetDoorPosition(i, k), 1.0}
        end
    end

    local doorAlarmFile = self:GetNW2Bool("FastDoorSignal", true) and "subway_trains/765/doors/door_alarm_fast.mp3" or "subway_trains/765/doors/door_alarm.mp3"
    for k, tbl in ipairs({self.LeftDoorPositions or {}, self.RightDoorPositions or {}}) do
        for i, pos in ipairs(tbl) do
            local idx = (k - 1) * 4 + i
            local sid = "door_alarm_" .. idx
            self.SoundNames[sid] = { loop = true, doorAlarmFile }
            self.SoundPositions[sid] = { 100, 1e9, pos + Vector(0, 0, 30), 1 }
        end
    end

    self.SoundNames["sf_on"] = "subway_trains/722/switches/sf_on.mp3"
    self.SoundNames["sf_off"] = "subway_trains/722/switches/sf_off.mp3"
    self.SoundNames["door_alarm"] = {"subway_trains/765/rumble/door_alarm_fast.mp3"}
    self.SoundPositions["door_alarm"] = {800, 1e9, Vector(0, 0, 0), 0.5}
    self.SoundNames["batt_on"] = "subway_trains/720/batt_on.mp3"
    self.SoundPositions["batt_on"] = {400, 1e9, Vector(126.4, 50, -60 - 23.5), 0.3}
    self.SoundNames["disconnectvalve"] = "subway_trains/common/switches/pneumo_disconnect_switch.mp3"
    self.SoundNames["disconnect_valve"] = "subway_trains/common/switches/pneumo_disconnect_switch.mp3"
    self.SoundNames["button_press"] = {"subway_trains/720/switches/butt_press.mp3", "subway_trains/720/switches/butt_press2.mp3", "subway_trains/720/switches/butt_press3.mp3"}
    self.SoundNames["button_release"] = {"subway_trains/720/switches/butt_release.mp3", "subway_trains/720/switches/butt_release2.mp3", "subway_trains/720/switches/butt_release3.mp3"}
    self.SoundNames["button_square_press"] = "subway_trains/720/switches/butts_press.mp3"
    self.SoundNames["button_square_release"] = "subway_trains/720/switches/butts_release.mp3"
    self.SoundNames["button_square_on"] = {"subway_trains/720/switches/butts_on.mp3", "subway_trains/720/switches/butts_on2.mp3"}
    self.SoundNames["button_square_off"] = {"subway_trains/720/switches/butts_off.mp3", "subway_trains/720/switches/butts_off2.mp3"}
    self.SoundNames["pak_on"] = "subway_trains/717/switches/rc_on.mp3"
    self.SoundNames["pak_off"] = "subway_trains/717/switches/rc_off.mp3"
    for i = 1, 10 do
        local id1 = Format("b1tunnel_%d", i)
        local id2 = Format("b2tunnel_%d", i)
        self.SoundNames[id1.."a"] = {"subway_trains/765/rumble/rolling/wheels/tunnel/st"..i.."a.wav"}
        self.SoundNames[id1.."b"] = {"subway_trains/765/rumble/rolling/wheels/tunnel/st"..i.."b.wav"}
        self.SoundNames[id2.."a"] = {"subway_trains/765/rumble/rolling/wheels/tunnel/st"..i.."a.wav"}
        self.SoundNames[id2.."b"] = {"subway_trains/765/rumble/rolling/wheels/tunnel/st"..i.."b.wav"}
        self.SoundPositions[id1 .. "a"] = {700 * 0.75, 1e9, Vector(317 - 5, 0, -84), 1 * 0.5}
        self.SoundPositions[id1 .. "b"] = self.SoundPositions[id1 .. "a"]
        self.SoundPositions[id2 .. "a"] = {700 * 0.75, 1e9, Vector(-317 + 0, 0, -84), 1 * 0.5}
        self.SoundPositions[id2 .. "b"] = self.SoundPositions[id2 .. "a"]
    end

    for i = 1, 14 do
        local id1 = Format("b1street_%d", i)
        local id2 = Format("b2street_%d", i)
        self.SoundNames[id1.."a"] = {"subway_trains/765/rumble/rolling/wheels/street/street_"..i.."a.mp3"}
        self.SoundNames[id1.."b"] = {"subway_trains/765/rumble/rolling/wheels/street/street_"..i.."b.mp3"}
        self.SoundNames[id2.."a"] = {"subway_trains/765/rumble/rolling/wheels/street/street_"..i.."a.mp3"}
        self.SoundNames[id2.."b"] = {"subway_trains/765/rumble/rolling/wheels/street/street_"..i.."b.mp3"}
        self.SoundPositions[id1 .. "a"] = {700, 1e9, Vector(317 - 5, 0, -84), 1.5 * 0.5}
        self.SoundPositions[id1 .. "b"] = self.SoundPositions[id1 .. "a"]
        self.SoundPositions[id2 .. "a"] = {700, 1e9, Vector(-317 + 0, 0, -84), 1.5 * 0.5}
        self.SoundPositions[id2 .. "b"] = self.SoundPositions[id2 .. "a"]
    end

    for k, v in ipairs(self.AnnouncerPositions) do
        self.SoundNames["announcer_noise1_" .. k] = {
            loop = true,
            "subway_announcers/upo/noiseS1.wav"
        }

        self.SoundPositions["announcer_noise1_" .. k] = {v[2] or 300, 1e9, v[1], v[3] * 0.2}
        self.SoundNames["announcer_noise2_" .. k] = {
            loop = true,
            "subway_announcers/upo/noiseS2.wav"
        }

        self.SoundPositions["announcer_noise2_" .. k] = {v[2] or 300, 1e9, v[1], v[3] * 0.2}
        self.SoundNames["announcer_noise3_" .. k] = {
            loop = true,
            "subway_announcers/upo/noiseS3.wav"
        }

        self.SoundPositions["announcer_noise3_" .. k] = {v[2] or 300, 1e9, v[1], v[3] * 0.2}
        self.SoundNames["announcer_noiseW" .. k] = {
            loop = true,
            "subway_announcers/upo/noiseW.wav"
        }

        self.SoundPositions["announcer_noiseW" .. k] = {v[2] or 300, 1e9, v[1], v[3] * 0.2}

        self.SoundNames["announcer_sarmat_start" .. k] = {"subway_trains/722/sarmat_start.mp3"}
        self.SoundPositions["announcer_sarmat_start" .. k] = {v[2] or 300, 1e9, v[1], v[3] * 0.2}
    end
end

local curIdx = 0
local lasty = nil
local function pvzToggle(name, tooltip, x, y, idx)
    if lasty ~= y then curIdx = 0 lasty = y end
    local btn = {
        relayName = name,
        ID = name .. "Toggle", tooltip = tooltip,
        x = (idx or curIdx) * 29.8 + x, y = y,
        w = 29.8, h = 50,
        model = {
            var = name,
            model = "models/metrostroi_train/81-765/switch_av.mdl",
            z = 0, ang = Angle(-90, -180, 0), scale = 1,
            speed = 9, sndvol = 0.4, vmin = 0, vmax = 1,
            snd = function(val) return val and "sf_on" or "sf_off" end,
            sndmin = 90, sndmax = 1e3,
        }
    }
    curIdx = curIdx + 1
    return btn
end

ENT.PvzToggles = {
    pvzToggle("SF23F12", "23F12: Счётчик", 0, 0),
    pvzToggle("SF70F4", "70F4: USB", 0, 0),
    pvzToggle("SF22F1", "22F1: БУФТ", 0, 0),

    pvzToggle("SF23F11", "23F11: БУВ-S", 0, 50),
    pvzToggle("SF23F9", "23F9: Резерв", 0, 50),
    pvzToggle("SF90F2", "90F2: АСОТП", 0, 50),
    pvzToggle("SF23F10", "23F10: Противоюз", 0, 50),
    pvzToggle("SF45F5", "45F5: Видео 1", 0, 50),
    pvzToggle("SF45F6", "45F6: Видео 2", 0, 50),
    pvzToggle("SF45F7", "45F7: БНТ-ИК (Л)", 0, 50),
    pvzToggle("SF45F8", "45F8: БНТ-ИК (П)", 0, 50),
    pvzToggle("SF52F3", "52F3: Аварийное освещение", 0, 50),
    pvzToggle("SF61F3", "61F3: Включение кондиционера", 0, 50),

    pvzToggle("SF45F2", "45F2: Питание БВМ", 0, 100),
    pvzToggle("SF61F4", "61F4: Питание преобразователя", 0, 100),
    pvzToggle("SF23F4", "23F4: Инвертор", 0, 100),
    pvzToggle("SF45F4", "45F4: Питание БУТ", 0, 100),
    pvzToggle("SF30F4", "30F4: ПСН", 0, 100),
    pvzToggle("SF45F3", "45F3: Питание ESM", 0, 100),
    pvzToggle("SF30F3", "30F3: Осушитель", 0, 100),
    pvzToggle("SF21F1", "21F1: Токоприемники, осушитель, БККЗ, ДПБТ", 0, 100),
    pvzToggle("SF52F5", "52F5: Подсветка двери левой", 0, 100),
    pvzToggle("SF52F4", "52F4: Подсветка дверей", 0, 100),

    pvzToggle("SF80F2", "80F2: Контроль дверей салона", 0, 150),
    pvzToggle("SF80F13", "80F13: Двери питание 2, 7", 0, 150),
    pvzToggle("SF80F14", "80F14: Двери питание 1, 4, 5", 0, 150),
    pvzToggle("SF80F12", "80F12: Двери питание 3, 6, 8", 0, 150),
    pvzToggle("SF80F8", "80F8: Двери закрытие", 0, 150),
    pvzToggle("SF80F11", "80F11: Двери выбор правые", 0, 150),
    pvzToggle("SF80F10", "80F10: Двери выбор левые", 0, 150),
    pvzToggle("SF80F7", "80F7: Двери открытие левые", 0, 150),
    pvzToggle("SF80F6", "80F6: Двери открытие правые", 0, 150),
    pvzToggle("SF80F9", "80F9: Скорость 0", 0, 150),

    pvzToggle("SF30F2", "30F2: БС Управлене", 0, 200),
    pvzToggle("SF23F5", "23F5: Управление основное", 0, 200),
    pvzToggle("SF23F6", "23F6: Управление резервное", 0, 200),
    pvzToggle("SF30F7", "30F7: Питание ЦУ 1", 0, 200),
    pvzToggle("SF30F9", "30F9: Питание ЦУ 2", 0, 200),
    pvzToggle("SF30F6", "30F6: Питание ЦУ 3", 0, 200),
    pvzToggle("SF30F8", "30F8: Питание ЦУ 4", 0, 200),
    pvzToggle("SF52F2", "52F2: Освещение основное", 0, 200),
    pvzToggle("SF61F1", "61F1: Питание УПВВ 1", 0, 200),
    pvzToggle("SF61F9", "61F9: Питание УПВВ 2", 0, 200),
}

function ENT:InitializeSystems()
    self:LoadSystem("TR", "TR_3B")
    self:LoadSystem("Electric", "81_760E_Electric")
    self:LoadSystem("BUV", "81_760E_BUV")
    self:LoadSystem("BUD", "81_765_BUD")
    self:LoadSystem("Pneumatic", "81_763E_Pneumatic")
    self:LoadSystem("Panel", "81_761E_Panel")
    self:LoadSystem("IK", "81_765_IK")
    self:LoadSystem("BNT", "81_765_BNT")
end

ENT.AnnouncerPositions = {}
for i = 1, 4 do
    table.insert(ENT.AnnouncerPositions, {
        Vector(323 - (i - 1) * 230,
            47, 44),
        100,
        0.1
    })

    table.insert(ENT.AnnouncerPositions, {Vector(323 - (i - 1) * 230, -47, 44), 100, 0.1})
end

---------------------------------------------------
-- Defined train information
-- Types of wagon(for wagon limit system):
-- 0 = Head or intherim
-- 1 = Only head
-- 2 = Only intherim
---------------------------------------------------
ENT.SubwayTrain = {
    Type = "81-760E",
    Name = "81-763E",
    WagType = 2,
    Manufacturer = "PvVZ",
    EKKType = 763,
}

ENT.NumberRanges = {{30503, 30999}}