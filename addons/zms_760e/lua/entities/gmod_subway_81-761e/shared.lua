--------------------------------------------------------------------------------
-- 81-761Э «Чурá» by ZONT_ a.k.a. enabled person
-- Based on code by Cricket, Hell et al.
-- Logic of 81-720A Experimental engines sounds by fixinit75
-- located between "BEGIN EXPERIMENTAL ENGINES" and "END EXPERIMENTAL ENGINES",
-- permission granted for this addon
--------------------------------------------------------------------------------
ENT.Type = "anim"
ENT.Base = "gmod_subway_base"
ENT.PrintName = "81-761E PvVZ"
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

function ENT:InitializeSounds()
    self.BaseClass.InitializeSounds(self)
    -- [[                            BEGIN EXPERIMENTAL ENGINES                            ]]
    self.SoundNames["gto1"] = { "subway_trains/720a/VVVF/motor1.mp3", loop = true }
    self.SoundPositions["gto1"] = {400, 1e9, Vector(0, 0, -448), 1}
    self.SoundNames["gto2"] = { "subway_trains/720a/VVVF/motor2.mp3", loop = true }
    self.SoundPositions["gto2"] = {400, 1e9, Vector(0, 0, -448), 1}
    self.SoundNames["gto3"] = { "subway_trains/720a/VVVF/motor3.mp3", loop = true }
    self.SoundPositions["gto3"] = {400, 1e9, Vector(0, 0, -448), 1}
    self.SoundNames["gto4"] = { "subway_trains/720a/VVVF/motor4.mp3", loop = true }
    self.SoundPositions["gto4"] = {400, 1e9, Vector(0, 0, -448), 1}
    self.SoundNames["gto5"] = { "subway_trains/720a/VVVF/motor5.mp3", loop = true }
    self.SoundPositions["gto5"] = {400, 1e9, Vector(0, 0, -448), 1}
    self.SoundNames["gto6"] = { "subway_trains/720a/VVVF/motor6.mp3", loop = true }
    self.SoundPositions["gto6"] = {400, 1e9, Vector(0, 0, -448), 1}
    self.SoundNames["gto7"] = { "subway_trains/720a/VVVF/motor7.mp3", loop = true }
    self.SoundPositions["gto7"] = {400, 1e9, Vector(0, 0, -448), 1}
    self.SoundNames["gto8"] = { "subway_trains/720a/VVVF/motor8.mp3", loop = true }
    self.SoundPositions["gto8"] = {400, 1e9, Vector(0, 0, -448), 1}
    self.SoundNames["gto9"] = { "subway_trains/720a/VVVF/motor9.mp3", loop = true }
    self.SoundPositions["gto9"] = {400, 1e9, Vector(0, 0, -448), 1}
    self.SoundNames["gto10"] = { "subway_trains/720a/VVVF/motor10.mp3", loop = true }
    self.SoundPositions["gto10"] = {400, 1e9, Vector(0, 0, -448), 1}
    self.SoundNames["gto11"] = { "subway_trains/720a/VVVF/motor11.mp3", loop = true }
    self.SoundPositions["gto11"] = {400, 1e9, Vector(0, 0, -448), 1}
    self.SoundNames["gto12"] = { "subway_trains/720a/VVVF/motor12.mp3", loop = true }
    self.SoundPositions["gto12"] = {400, 1e9, Vector(0, 0, -448), 1}
    self.SoundNames["gto13"] = { "subway_trains/720a/VVVF/motor13.mp3", loop = true }
    self.SoundPositions["gto13"] = {400, 1e9, Vector(0, 0, -448), 1}
    self.SoundNames["gto14"] = { "subway_trains/720a/VVVF/motor14.mp3", loop = true }
    self.SoundPositions["gto14"] = {400, 1e9, Vector(0, 0, -448), 1}
    self.SoundNames["gto15"] = { "subway_trains/720a/VVVF/motor15.mp3", loop = false }
    self.SoundPositions["gto15"] = {400, 1e9, Vector(0, 0, -448), 1}
    self.SoundNames["gto16"] = { "subway_trains/720a/VVVF/motor16.mp3", loop = true }
    self.SoundPositions["gto16"] = {400, 1e9, Vector(0, 0, -448), 1}
    self.SoundNames["gto17"] = { "subway_trains/720a/VVVF/motor17.mp3", loop = true }
    self.SoundPositions["gto17"] = {400, 1e9, Vector(0, 0, -448), 1}
    self.SoundNames["gto18"] = { "subway_trains/720a/VVVF/motor18.mp3", loop = true }
    self.SoundPositions["gto18"] = {400, 1e9, Vector(0, 0, -448), 1}
    self.SoundNames["gto19"] = { "subway_trains/720a/VVVF/motor19.mp3", loop = true }
    self.SoundPositions["gto19"] = {400, 1e9, Vector(0, 0, -448), 1}
    self.SoundNames["gto21"] = { "subway_trains/720a/VVVF/motor21.mp3", loop = true }
    self.SoundPositions["gto21"] = {400, 1e9, Vector(0, 0, -448), 1}
    self.SoundNames["gto22"] = { "subway_trains/720a/VVVF/motor22.mp3", loop = true }
    self.SoundPositions["gto22"] = {400, 1e9, Vector(0, 0, -448), 1}
    self.SoundNames["gto23"] = { "subway_trains/720a/VVVF/motor23.mp3", loop = true }
    self.SoundPositions["gto23"] = {400, 1e9, Vector(0, 0, -448), 1}
    self.SoundNames["gto24"] = { "subway_trains/720a/VVVF/motor24.mp3", loop = true }
    self.SoundPositions["gto24"] = {400, 1e9, Vector(0, 0, -448), 1}
    self.SoundNames["gto25"] = { "subway_trains/720a/VVVF/motor25.mp3", loop = true }
    self.SoundPositions["gto25"] = {400, 1e9, Vector(0, 0, -448), 1}
    self.SoundNames["gto26"] = { "subway_trains/720a/VVVF/motor26.mp3", loop = true }
    self.SoundPositions["gto26"] = {400, 1e9, Vector(0, 0, -448), 1}
    self.SoundNames["gto27"] = { "subway_trains/720a/VVVF/motor27.mp3", loop = true }
    self.SoundPositions["gto27"] = {400, 1e9, Vector(0, 0, -448), 1}
    self.SoundNames["gto28"] = { "subway_trains/720a/VVVF/motor28.mp3", loop = true }
    self.SoundPositions["gto28"] = {400, 1e9, Vector(0, 0, -448), 1}
    self.SoundNames["ONIX"] = { "subway_trains/760/engines/inverter.wav", loop = true }
    self.SoundPositions["ONIX"] = {400, 1e9, Vector(0, 0, -448), 0.5}
    self.SoundNames["KATP_lowspeed"] = { "subway_trains/720a/inverter_lowspeed.wav", loop = true }
    self.SoundPositions["KATP_lowspeed"] = {400, 1e9, Vector(0, 0, -448), 1}
    self.SoundNames["KATP"] = { "subway_trains/720a/inverter_katp3.wav", loop = true }
    self.SoundPositions["KATP"] = {400, 1e9, Vector(0, 0, -448), 2.5}
    self.SoundNames["Hitachi"] = { "subway_trains/720a/inverter.wav", loop = true }
    self.SoundPositions["Hitachi"] = {400, 1e9, Vector(0, 0, -448), 0.5}
    self.SoundNames["Hitachi2"] = { "subway_trains/722/engines/inverter_2000.wav", loop = true }
    self.SoundPositions["Hitachi2"] = {400, 1e9, Vector(0, 0, -448), 1.5}
    self.SoundNames["Hitachi2_2"] = { "subway_trains/720a/inverter.wav", loop = true }
    self.SoundPositions["Hitachi2_2"] = {400, 1e9, Vector(0, 0, -448), 0.4}
    self.SoundNames["Hitachi2_1"] = { "subway_trains/722/engines/inverter_2000.wav", loop = true }
    self.SoundPositions["Hitachi2_1"] = {400, 1e9, Vector(0, 0, -448), 1.5}
    self.SoundNames["hs35533_p2"] = { "subway_trains/722/engines/inverter_1000.wav", loop = true }
    self.SoundPositions["hs35533_p2"] = {400, 1e9, Vector(0, 0, 0), 1.2}
    self.SoundNames["hs35533_p2_1"] = { "subway_trains/722/engines/inverter_1000.wav", loop = true }
    self.SoundPositions["hs35533_p2_1"] = {400, 1e9, Vector(0, 0, 0), 1}
    self.SoundNames["hs35533_p3"] = { "subway_trains/722/engines/inverter_1000.wav", loop = true }
    self.SoundPositions["hs35533_p3"] = {400, 1e9, Vector(0, 0, 0), 1.4}
    self.SoundNames["hs35533_p3_1"] = { "subway_trains/722/engines/inverter_1000.wav", loop = true }
    self.SoundPositions["hs35533_p3_1"] = {400, 1e9, Vector(0, 0, 0), 1.4}
    self.SoundNames["vfi_start"] = { "subway_trains/722/engines/inverter_start2.wav", loop = true }
    self.SoundNames["vfi1_n"] = { "subway_trains/722/engines/inverter_1000.wav", loop = true }
    self.SoundNames["vfi1_2_n"] = { "subway_trains/722/engines/inverter_1000.wav", loop = true }
    self.SoundNames["vfi1_3_n"] = { "subway_trains/722/engines/inverter_1000.wav", loop = true }
    self.SoundNames["vfi2_n"] = { "subway_trains/722/engines/inverter_2000.wav", loop = true }
    self.SoundNames["vfi3_n"] = { "subway_trains/722/engines/inverter_2800.wav", loop = true }
    self.SoundNames["vfi3_2_n"] = { "subway_trains/722/engines/inverter_2800.wav", loop = true }
    self.SoundPositions["vfi_start"] = {400, 1e9, Vector(0, 0, 0), 0.5}
    self.SoundPositions["vfi1_n"] = {400, 1e9, Vector(0, 0, 0), 0.5}
    self.SoundPositions["vfi1_2_n"] = {400, 1e9, Vector(0, 0, 0), 0.1}
    self.SoundPositions["vfi1_3_n"] = {400, 1e9, Vector(0, 0, 0), 0.1}
    self.SoundPositions["vfi2_n"] = {400, 1e9, Vector(0, 0, 0), 0.1}
    self.SoundPositions["vfi3_n"] = {400, 1e9, Vector(0, 0, 0), 0.1}
    self.SoundPositions["vfi3_2_n"] = self.SoundPositions["vfi3_n"]
    self.SoundNames["hs35533_p2_n"] = { "subway_trains/722/engines/inverter_1000.wav", loop = true }
    self.SoundPositions["hs35533_p2_n"] = {400, 1e9, Vector(0, 0, 0), 1}
    self.SoundNames["hs35533_p2_1_n"] = { "subway_trains/722/engines/inverter_1000.wav", loop = true }
    self.SoundPositions["hs35533_p2_1_n"] = {400, 1e9, Vector(0, 0, 0), 1.9}
    self.SoundNames["hs35533_p3_n"] = { "subway_trains/722/engines/inverter_1000.wav", loop = true }
    self.SoundPositions["hs35533_p3_n"] = {400, 1e9, Vector(0, 0, 0), 1.5}
    self.SoundNames["hs35533_p3_1_n"] = { "subway_trains/722/engines/inverter_1000.wav", loop = true }
    self.SoundPositions["hs35533_p3_1_n"] = {400, 1e9, Vector(0, 0, 0), 1.5}
    self.SoundNames["engine_loud"] = { "subway_trains/722/engines/engine_loud.wav", loop = true }
    self.SoundPositions["engine_loud"] = {400, 1e9, Vector(0, 0, 0), 0.32}
    self.SoundNames["chopper_hitachi"] = { "subway_trains/722/chopper.wav", loop = true }
    self.SoundPositions["chopper_hitachi"] = {400, 1e9, Vector(0, 0, 0), 0.05}
    self.SoundNames["chopper_katp"] = { "subway_trains/720a/chopper.mp3", loop = true }
    self.SoundPositions["chopper_katp"] = {400, 1e9, Vector(0, 0, 0), 0.35}
    self.SoundNames["chopper_onix"] = { "subway_trains/720a/chopper_onix.wav", loop = true }
    self.SoundPositions["chopper_onix"] = {400, 1e9, Vector(0, 0, 0), 0.2}
    -- [[                              END EXPERIMENTAL ENGINES                            ]]

    self.SoundNames["async1"] = {
        "subway_trains/765/rumble/engines/inverter.wav",
        loop = true
    }
    self.SoundPositions["async1"] = {400, 1e9, Vector(0, 0, 0), 1}

    for i = 1, 8 do
        self.SoundNames["vent" .. i] = {
            loop = true,
            "subway_trains/720/vent_mix.wav"
        }

        self.SoundPositions["vent" .. i] = {100, 1e9, Vector(-413 + (i - 1) * 117, 0, 30), 0.5}
    end

    self.SoundNames["compressor"] = {
        loop = true,
        "subway_trains/765/rumble/compressor_loop.wav"
    }
    self.SoundPositions["compressor"] = {
        800, --FIXME: Pos
        1e9,
        Vector(-118, -40, -66)
    }

    self.SoundNames["compressor_pn1"] = "subway_trains/765/rumble/compressor_dhm.wav"
    self.SoundPositions["compressor_pn1"] = {
        800, --FIXME: Pos
        1e9,
        Vector(-118, -40, -66)
    }

    self.SoundNames["compressor_pn2"] = "subway_trains/765/rumble/compressor_dhm_2.wav"
    self.SoundPositions["compressor_pn2"] = {
        800, --FIXME: Pos	
        1e9,
        Vector(-118, -40, -66)
    }

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

    self.SoundNames["pak_on"] = "subway_trains/717/switches/rc_on.mp3"
    self.SoundNames["pak_off"] = "subway_trains/717/switches/rc_off.mp3"

    self.SoundPositions["rear_isolation"] = {300, 1e9, Vector(-469, 0, -63), 1}
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

    self.SoundNames["bv_off"] = {"subway_trains/760/new/bv_off.wav"}
    self.SoundPositions["bv_off"] = {800, 1e9, Vector(0, 0, -45), 0.5}
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
    self:LoadSystem("AsyncInverter", "81_760_AsyncInverter")
    self:LoadSystem("BUV", "81_760E_BUV")
    self:LoadSystem("BUD", "81_765_BUD")
    self:LoadSystem("Pneumatic", "81_760E_Pneumatic")
    self:LoadSystem("Panel", "81_761E_Panel")
    self:LoadSystem("IK", "81_765_IK")
    self:LoadSystem("BNT", "81_765_BNT")
    self:LoadSystem("IGLA_PCBK", "81_760_IGLA_PCBK")
end

ENT.AnnouncerPositions = {}
for i = 1, 4 do
    table.insert(ENT.AnnouncerPositions, {
        Vector(323 - (i - 1) * 230, 47, 44),
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
    Name = "81-761E",
    WagType = 2,
    Manufacturer = "PvVZ",
    EKKType = 763,
}

ENT.NumberRanges = {{30501, 30993}}
