ENT.Type = "anim"
ENT.Base = "gmod_subway_base"
ENT.PrintName = "81-763E PvVZ"
ENT.Author = ""
ENT.Contact = ""
ENT.Purpose = ""
ENT.Instructions = ""
ENT.Category = "Metrostroi (trains)"
ENT.SkinsType = "81-760e"
ENT.Model = "models/metrostroi_train/81-760/81_761a_body.mdl"
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
    for k = 0, 1 do
        if k == 1 then
            table.insert(ENT.LeftDoorPositions, GetDoorPosition(i, k))
        else
            table.insert(ENT.RightDoorPositions, GetDoorPosition(i, k))
        end
    end
end

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
    self.SoundNames["test_async1"] = {
        "subway_trains/722/engines/inverter_1000.wav",
        loop = true
    }

    self.SoundNames["test_async1_2"] = {
        "subway_trains/722/engines/inverter_1000.wav",
        loop = true
    }

    self.SoundNames["test_async1_3"] = {
        "subway_trains/722/engines/inverter_1000.wav",
        loop = true
    }

    self.SoundNames["test_async2"] = {
        "subway_trains/722/engines/inverter_2000.wav",
        loop = true
    }

    self.SoundNames["test_async3"] = {
        "subway_trains/722/engines/inverter_2800.wav",
        loop = true
    }

    self.SoundNames["test_async3_2"] = {
        "subway_trains/722/engines/inverter_2800.wav",
        loop = true
    }

    self.SoundPositions["test_async1"] = {400, 1e9, Vector(0, 0, 0), 0.5}
    self.SoundPositions["test_async1_2"] = {400, 1e9, Vector(0, 0, 0), 0.1}
    self.SoundPositions["test_async1_3"] = {400, 1e9, Vector(0, 0, 0), 0.1}
    self.SoundPositions["test_async2"] = {400, 1e9, Vector(0, 0, 0), 0.1}
    self.SoundPositions["test_async3"] = {400, 1e9, Vector(0, 0, 0), 0.1}
    self.SoundPositions["test_async3_2"] = self.SoundPositions["test_async3"]
    self.SoundNames["async_p2"] = {
        "subway_trains/722/engines/inverter_1000.wav",
        loop = true
    }

    self.SoundPositions["async_p2"] = {400, 1e9, Vector(0, 0, 0), 1}
    self.SoundNames["async_p3"] = {
        "subway_trains/722/engines/inverter_1000.wav",
        loop = true
    }

    self.SoundPositions["async_p3"] = {400, 1e9, Vector(0, 0, 0), 1}
    self.SoundNames["engine_loud"] = {
        "subway_trains/722/engines/engine_loud.wav",
        loop = true
    }

    self.SoundPositions["engine_loud"] = {400, 1e9, Vector(0, 0, 0), 0.2}
    self.SoundNames["chopper"] = {
        "subway_trains/722/chopper.wav",
        loop = true
    }

    self.SoundPositions["chopper"] = {400, 1e9, Vector(0, 0, 0), 0.03}
    for i = 1, 8 do
        self.SoundNames["vent" .. i] = {
            loop = true,
            "subway_trains/720/vent_mix.wav"
        }

        self.SoundPositions["vent" .. i] = {100, 1e9, Vector(-413 + (i - 1) * 117, 0, 30), 0.5}
    end

    self.SoundNames["release"] = {
        loop = true,
        "subway_trains/760/new/pneumo_release2.wav"
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

    self.SoundNames["rolling_10"] = {loop=true,"subway_trains/760/rolling/rolling_10.wav"}
    self.SoundNames["rolling_45"] = {loop=true,"subway_trains/760/rolling/rolling_45.wav"}
    self.SoundNames["rolling_60"] = {loop=true,"subway_trains/760/rolling/rolling_60.wav"}
    self.SoundNames["rolling_70"] = {loop=true,"subway_trains/760/rolling/rolling_70.wav"}
    self.SoundPositions["rolling_10"] = {485,1e9,Vector(0,0,0),0.20}
    self.SoundPositions["rolling_45"] = {485,1e9,Vector(0,0,0),0.50}
    self.SoundPositions["rolling_60"] = {485,1e9,Vector(0,0,0),0.55}
    self.SoundPositions["rolling_70"] = {485,1e9,Vector(0,0,0),0.60}
    self.SoundNames["rolling_low"] = {loop=true,"subway_trains/760/rolling/rolling_outside_low.wav"}
    self.SoundNames["rolling_medium1"] = {loop=true,"subway_trains/760/rolling/rolling_outside_medium1.wav"}
    self.SoundNames["rolling_medium2"] = {loop=true,"subway_trains/760/rolling/rolling_outside_medium2.wav"}
    self.SoundNames["rolling_high2"] = {loop=true,"subway_trains/760/rolling/rolling_outside_high2.wav"}
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
    self.SoundNames["door_alarm"] = {"subway_trains/760/new/door_alarm_fast.mp3"}
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
        self.SoundNames[id1.."a"] = {"subway_trains/760/rolling/wheels/tunnel/st"..i.."a.wav"}
        self.SoundNames[id1.."b"] = {"subway_trains/760/rolling/wheels/tunnel/st"..i.."b.wav"}
        self.SoundNames[id2.."a"] = {"subway_trains/760/rolling/wheels/tunnel/st"..i.."a.wav"}
        self.SoundNames[id2.."b"] = {"subway_trains/760/rolling/wheels/tunnel/st"..i.."b.wav"}
        self.SoundPositions[id1 .. "a"] = {700 * 0.75, 1e9, Vector(317 - 5, 0, -84), 1 * 0.5}
        self.SoundPositions[id1 .. "b"] = self.SoundPositions[id1 .. "a"]
        self.SoundPositions[id2 .. "a"] = {700 * 0.75, 1e9, Vector(-317 + 0, 0, -84), 1 * 0.5}
        self.SoundPositions[id2 .. "b"] = self.SoundPositions[id2 .. "a"]
    end

    for i = 1, 14 do
        local id1 = Format("b1street_%d", i)
        local id2 = Format("b2street_%d", i)
        self.SoundNames[id1.."a"] = {"subway_trains/760/rolling/wheels/street/street_"..i.."a.mp3"}
        self.SoundNames[id1.."b"] = {"subway_trains/760/rolling/wheels/street/street_"..i.."b.mp3"}
        self.SoundNames[id2.."a"] = {"subway_trains/760/rolling/wheels/street/street_"..i.."a.mp3"}
        self.SoundNames[id2.."b"] = {"subway_trains/760/rolling/wheels/street/street_"..i.."b.mp3"}
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
        Vector(323 - (i - 1) * 230, --[[+37.5]]
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

ENT.NumberRanges = {{30001, 30993}}