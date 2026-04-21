--------------------------------------------------------------------------------
-- 81-760Э «Чурá» by ZONT_ a.k.a. enabled person
--------------------------------------------------------------------------------
ENT.Type = "anim"
ENT.PrintName = "81-765 MVM"
ENT.Author = ""
ENT.Contact = ""
ENT.Purpose = ""
ENT.Instructions = ""
ENT.Category = "Metrostroi (trains)"
ENT.Base = "gmod_subway_base"
ENT.SkinsType = "81-760e"
ENT.Model = "models/metrostroi_train/81-760e/81_760e_body.mdl"
ENT.NoTrain = true
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.DontAccelerateSimulation = false

ZMS.ImportBaseEnt("Base765", "gmod_81-765_base")

--------------------------------------------------------------------------------
-- local BaseClass = baseclass.Get("gmod_81-765_base")
-- ENT.Base = "gmod_subway_base"  -- TODO Implement 765_base instead when (if) moving to metrostroi 2025+

function ENT:GetStandingArea()
    return Vector(-450, -30, -53), Vector(360, 30, -53)
end

function ENT:InitializeSounds()
    local BaseClass = scripted_ents.GetStored("gmod_81-765_base").t
    BaseClass.InitializeSounds(self)

    self.SoundNames["crane013_brake"] = {
        loop = true,
        "subway_trains/common/pneumatic/release_2.wav"
    }
    self.SoundPositions["crane013_brake"] = {80, 1e9, Vector(475, -10, -47.9), 0.86}

    self.SoundNames["crane013_brake2"] = {
        loop = true,
        "subway_trains/common/pneumatic/013_brake2.wav"
    }
    self.SoundPositions["crane013_brake2"] = {80, 1e9, Vector(475, -10, -47.9), 0.86}

    self.SoundNames["crane013_release"] = {
        loop = true,
        "subway_trains/765/rumble/pneumatic/013_release.wav"
    }
    self.SoundPositions["crane013_release"] = {80, 1e9, Vector(475, -10, -47.9), 0.4}

    self.SoundNames["pneumo_disconnect_close"] = {"subway_trains/765/rumble/013_close1.wav"}
    self.SoundNames["pneumo_disconnect_open"] = {"subway_trains/760/013_open1.wav",}
    self.SoundPositions["pneumo_disconnect_close"] = {100, 1e9, Vector(478, 45, -61), 0.5}
    self.SoundPositions["pneumo_disconnect_open"] = {100, 1e9, Vector(478, 45, -61), 0.5}
    self.SoundPositions["pneumo_disconnect_close"] = {100, 1e9, Vector(478, 45, -61), 0.5}
    self.SoundPositions["pneumo_disconnect_open"] = {100, 1e9, Vector(478, 45, -61), 0.5}

    self.SoundNames["horn"] = {
        loop = 0.6,
        "subway_trains/common/pneumatic/horn/horn3_start.wav",
        "subway_trains/common/pneumatic/horn/horn3_loop.wav",
        "subway_trains/common/pneumatic/horn/horn3_end.wav"
    }
    self.SoundPositions["horn"] = {1100, 1e9, Vector(500, -25, -64)}

    local kvType = self:GetNW2Int("KvType", 1)
    if kvType == 1 then kvType = math.random(2) else kvType = kvType - 1 end
    if kvType == 1 then
        self.SoundNames["KV_-3_-2"] = "subway_trains/722/kuau/x_xp.mp3"
        self.SoundNames["KV_-2_-1"] = "subway_trains/722/kuau/xp_x2.mp3"
        self.SoundNames["KV_-1_0"] = "subway_trains/722/kuau/x_xp.mp3"
        self.SoundNames["KV_0_1"] = "subway_trains/722/kuau/0_x.mp3"
        self.SoundNames["KV_1_2"] = "subway_trains/722/kuau/x_xp.mp3"
        self.SoundNames["KV_2_1"] = "subway_trains/722/kuau/xp_x2.mp3"
        self.SoundNames["KV_1_0"] = "subway_trains/722/kuau/x_xp.mp3"
        self.SoundNames["KV_0_-1"] = "subway_trains/722/kuau/0_x.mp3"
        self.SoundNames["KV_-1_-2"] = "subway_trains/722/kuau/x_xp.mp3"
        self.SoundNames["KV_-2_-3"] = "subway_trains/722/kuau/xp_x.mp3"
    else
        self.SoundNames["KV_-3_-2"] = "subway_trains/765/controller2/e-tp.mp3"
        self.SoundNames["KV_-2_-1"] = "subway_trains/765/controller2/tp-t.mp3"
        self.SoundNames["KV_-1_0"] = "subway_trains/765/controller2/t-0.mp3"
        self.SoundNames["KV_0_1"] = "subway_trains/765/controller2/0-x.mp3"
        self.SoundNames["KV_1_2"] = "subway_trains/765/controller2/x-xp.mp3"
        self.SoundNames["KV_2_1"] = "subway_trains/765/controller2/xp-x.mp3"
        self.SoundNames["KV_1_0"] = "subway_trains/765/controller2/x-0.mp3"
        self.SoundNames["KV_0_-1"] = "subway_trains/765/controller2/0-t.mp3"
        self.SoundNames["KV_-1_-2"] = "subway_trains/765/controller2/t-tp.mp3"
        self.SoundNames["KV_-2_-3"] = "subway_trains/765/controller2/tp-e.mp3"
    end

    self.SoundPositions["KV_-3_-2"] = {80, 1e9, Vector(461.8, 25.3, -27.7)}
    self.SoundPositions["KV_-2_-1"] = self.SoundPositions["KV_-3_-2"]
    self.SoundPositions["KV_-1_0"] = self.SoundPositions["KV_-3_-2"]
    self.SoundPositions["KV_0_1"] = self.SoundPositions["KV_-3_-2"]
    self.SoundPositions["KV_1_2"] = self.SoundPositions["KV_-3_-2"]
    self.SoundPositions["KV_2_1"] = self.SoundPositions["KV_-3_-2"]
    self.SoundPositions["KV_1_0"] = self.SoundPositions["KV_-3_-2"]
    self.SoundPositions["KV_0_-1"] = self.SoundPositions["KV_-3_-2"]
    self.SoundPositions["KV_-1_-2"] = self.SoundPositions["KV_-3_-2"]
    self.SoundPositions["KV_-2_-3"] = self.SoundPositions["KV_-3_-2"]

    self.SoundNames["kro_in"] = {"subway_trains/717/kru/kru_insert1.mp3", "subway_trains/717/kru/kru_insert2.mp3"}
    self.SoundNames["kro_out"] = {"subway_trains/717/kru/kru_eject1.mp3", "subway_trains/717/kru/kru_eject2.mp3", "subway_trains/717/kru/kru_eject3.mp3",}
    self.SoundNames["kro_-1_0"] = {"subway_trains/717/kru/kru0-1_1.mp3", "subway_trains/717/kru/kru0-1_2.mp3", "subway_trains/717/kru/kru0-1_3.mp3", "subway_trains/717/kru/kru0-1_4.mp3",}
    self.SoundNames["kro_0_1"] = {"subway_trains/717/kru/kru1-2_1.mp3", "subway_trains/717/kru/kru1-2_2.mp3", "subway_trains/717/kru/kru1-2_3.mp3", "subway_trains/717/kru/kru1-2_4.mp3",}
    self.SoundNames["kro_1_0"] = {"subway_trains/717/kru/kru2-1_1.mp3", "subway_trains/717/kru/kru2-1_2.mp3", "subway_trains/717/kru/kru2-1_3.mp3", "subway_trains/717/kru/kru2-1_4.mp3",}
    self.SoundNames["kro_0_-1"] = {"subway_trains/717/kru/kru1-0_1.mp3", "subway_trains/717/kru/kru1-0_2.mp3", "subway_trains/717/kru/kru1-0_3.mp3", "subway_trains/717/kru/kru1-0_4.mp3",}
    self.SoundPositions["kro_in"] = {80, 1e9, Vector(463.4, 53.3, -21.1)}
    self.SoundPositions["kro_out"] = self.SoundPositions["kro_in"]
    self.SoundPositions["kro_-1_0"] = self.SoundPositions["kro_in"]
    self.SoundPositions["kro_0_1"] = self.SoundPositions["kro_in"]
    self.SoundPositions["kro_1_0"] = self.SoundPositions["kro_in"]
    self.SoundPositions["kro_0_-1"] = self.SoundPositions["kro_in"]
    self.SoundNames["krr_in"] = self.SoundNames["kro_in"]
    self.SoundNames["krr_out"] = self.SoundNames["kro_out"]
    self.SoundNames["krr_-1_0"] = self.SoundNames["kro_-1_0"]
    self.SoundNames["krr_0_1"] = self.SoundNames["kro_0_1"]
    self.SoundNames["krr_1_0"] = self.SoundNames["kro_1_0"]
    self.SoundNames["krr_0_-1"] = self.SoundNames["kro_0_-1"]
    self.SoundPositions["krr_in"] = {80, 1e9, Vector(470.4, 53.9, -17.3)}
    self.SoundPositions["krr_out"] = self.SoundPositions["krr_in"]
    self.SoundPositions["krr_-1_0"] = self.SoundPositions["krr_in"]
    self.SoundPositions["krr_0_1"] = self.SoundPositions["krr_in"]
    self.SoundPositions["krr_1_0"] = self.SoundPositions["krr_in"]
    self.SoundPositions["krr_0_-1"] = self.SoundPositions["krr_in"]

    self.SoundNames["switch_batt_on"] = {"subway_trains/760/vb_on.wav"}
    self.SoundNames["switch_batt_off"] = {"subway_trains/720/switches/batt_off.mp3", "subway_trains/720/switches/batt_off2.mp3"}
    self.SoundNames["switch_batt"] = {"subway_trains/720/switches/batt_on.mp3", "subway_trains/720/switches/batt_on2.mp3", "subway_trains/720/switches/batt_off.mp3", "subway_trains/720/switches/batt_off2.mp3"}
    self.SoundNames["switch_pvz_on"] = {"subway_trains/720/switches/switchb_on.mp3", "subway_trains/720/switches/switchp_on.mp3"}
    self.SoundNames["switch_pvz_off"] = {"subway_trains/720/switches/switchb_off.mp3", "subway_trains/720/switches/switchp_off.mp3"}
    self.SoundNames["switch_on"] = {"subway_trains/720/switches/switchp_on.mp3", "subway_trains/720/switches/switchp_on2.mp3", "subway_trains/720/switches/switchp_on3.mp3"}
    self.SoundNames["switch_off"] = {"subway_trains/720/switches/switchp_off.mp3", "subway_trains/720/switches/switchp_off2.mp3", "subway_trains/720/switches/switchp_off3.mp3"}

    self.SoundNames["button_press"] = {"subway_trains/765/rumble/switches/butt_press.mp3","subway_trains/765/rumble/switches/butt_press2.mp3","subway_trains/765/rumble/switches/butt_press3.mp3"}
    self.SoundNames["button_release"] = {"subway_trains/765/rumble/switches/butt_release.mp3","subway_trains/765/rumble/switches/butt_release2.mp3","subway_trains/765/rumble/switches/butt_release3.mp3"}
    self.SoundNames["button_square_press"] = "subway_trains/720/switches/butts_press.mp3"
    self.SoundNames["button_square_release"] = "subway_trains/720/switches/butts_release.mp3"
    self.SoundNames["button_square_on"] = {"subway_trains/720/switches/butts_on.mp3", "subway_trains/720/switches/butts_on2.mp3"}
    self.SoundNames["button_square_off"] = {"subway_trains/720/switches/butts_off.mp3", "subway_trains/720/switches/butts_off2.mp3"}

    self.SoundNames["door_cab_open"] = {"subway_trains/720/door/door_torec_open.mp3", "subway_trains/720/door/door_torec_open2.mp3"}
    self.SoundNames["door_cab_close"] = {"subway_trains/720/door/door_torec_close.mp3", "subway_trains/720/door/door_torec_close2.mp3"}

    self.SoundNames["multiswitch_panel_max"] = "subway_trains/722/switches/multi_switch_panel_max.mp3"
    self.SoundNames["multiswitch_panel_mid"] = {"subway_trains/722/switches/multi_switch_panel_mid.mp3","subway_trains/722/switches/multi_switch_panel_mid2.mp3"}
    self.SoundNames["multiswitch_panel_min"] = "subway_trains/722/switches/multi_switch_panel_min.mp3"

    self.SoundNames["igla_on"] = "subway_trains/common/other/igla/igla_on1.mp3"
    self.SoundNames["igla_off"] = "subway_trains/common/other/igla/igla_off2.mp3"
    self.SoundNames["igla_start1"] = "subway_trains/common/other/igla/igla_start.mp3"
    self.SoundNames["igla_start2"] = "subway_trains/common/other/igla/igla_start2.mp3"
    self.SoundNames["igla_started"] = "subway_trains/760e/igla/igla_started.mp3"
    self.SoundNames["igla_alarm1"] = "subway_trains/common/other/igla/igla_alarm1.mp3"
    self.SoundNames["igla_alarm2"] = "subway_trains/common/other/igla/igla_alarm2.mp3"
    self.SoundNames["igla_alarm3"] = "subway_trains/common/other/igla/igla_alarm3.mp3"
    self.SoundPositions["igla_on"] = {50, 1e9, Vector(410.56, 48.32, 12.62), 0.3}
    self.SoundPositions["igla_off"] = {50, 1e9, Vector(410.56, 48.32, 12.62), 0.3}
    self.SoundPositions["igla_start1"] = {50, 1e9, Vector(410.56, 48.32, 12.62), 0.5}
    self.SoundPositions["igla_start2"] = {50, 1e9, Vector(410.56, 48.32, 12.62), 0.3}
    self.SoundPositions["igla_started"] = {50, 1e9, Vector(410.56, 48.32, 12.62), 1}
    self.SoundPositions["igla_alarm1"] = {50, 1e9, Vector(410.56, 48.32, 12.62), 0.5}
    self.SoundPositions["igla_alarm2"] = {50, 1e9, Vector(410.56, 48.32, 12.62), 0.5}
    self.SoundPositions["igla_alarm3"] = {50, 1e9, Vector(410.56, 48.32, 12.62), 0.5}

    self.SoundNames["rvtb_leak"] = {
        loop = true,
        "subway_trains/760/new/rvtb_loop.wav"
    }
    self.SoundPositions["rvtb_leak"] = {80, 1e9, Vector(478, -45, -61), 0.65}
    self.SoundNames["rvtb_leak_start"] = { "subway_trains/760/new/rvtb_start.wav" }
    self.SoundPositions["rvtb_leak_start"] = self.SoundPositions["rvtb_leak"]
    self.SoundNames["rvtb_leak_end"] = { "subway_trains/760/new/rvtb_end.wav" }
    self.SoundPositions["rvtb_leak_end"] = self.SoundPositions["rvtb_leak"]

    self.SoundNames["valve_brake"] = {
        loop = true,
        "subway_trains/760/new/stopcrane_loop.wav"
    }
    self.SoundPositions["valve_brake"] = {400, 1e9, Vector(418.25, -49.2, 1.3), 1}

    self.SoundNames["valve_brake_close"] = {"subway_trains/760/stopkran_close.wav"}
    self.SoundPositions["valve_brake_close"] = {400, 1e9, Vector(418.25, -49.2, 1.3), 1}
    self.SoundNames["valve_brake_open"] = {"subway_trains/760/stopkran_open.wav"}
    self.SoundPositions["valve_brake_open"] = {400, 1e9, Vector(418.25, -49.2, 1.3), 1}

    self.SoundNames["emer_brake"] = {
        loop = true,
        "subway_trains/765/pneumo/autostop_loop.wav"
    }
    self.SoundPositions["emer_brake"] = {600, 1e9, Vector(380, -45, -75), 0.95}
    self.SoundNames["emer_brake_open"] = { "subway_trains/765/pneumo/autostop_start.wav" }
    self.SoundPositions["emer_brake_open"] = {600, 1e9, Vector(380, -45, -75), 1}

    self.SoundNames["vent_loop"] = {
        loop = true,
        "subway_trains/760/new/vent_cockpit_default_2.wav"
    }
    self.SoundPositions["vent_loop"] = {400, 1e9, Vector(422, 55, 40), 1}
    self.SoundNames["vent_loop_max"] = {
        loop = true,
        "subway_trains/760/new/vent_cockpit_high.wav"
    }
    self.SoundPositions["vent_loop_max"] = {400, 1e9, Vector(422, 55, 40), 1}

    self.SoundNames["door_cab_l_open"] = self.SoundNames["door_cab_open"]
    self.SoundPositions["door_cab_l_open"] = {800, 1e9, Vector(412.8, 63.2, 34.5), 0.5}
    self.SoundNames["door_cab_l_close"] = self.SoundNames["door_cab_close"]
    self.SoundPositions["door_cab_l_close"] = {800, 1e9, Vector(412.8, 63.2, 34.5), 0.5}
    self.SoundNames["door_cab_r_open"] = self.SoundNames["door_cab_open"]
    self.SoundPositions["door_cab_r_open"] = {800, 1e9, Vector(412.8, -63.2, 34.5), 0.5}
    self.SoundNames["door_cab_r_close"] = self.SoundNames["door_cab_close"]
    self.SoundPositions["door_cab_r_close"] = {800, 1e9, Vector(412.8, -63.2, 34.5), 0.5}
    self.SoundNames["door_cab_m_open"] = self.SoundNames["door_cab_open"]
    self.SoundPositions["door_cab_m_open"] = {800, 1e9, Vector(380, 5, -12.3), 0.5}
    self.SoundNames["door_cab_m_close"] = self.SoundNames["door_cab_close"]
    self.SoundPositions["door_cab_m_close"] = {800, 1e9, Vector(380, 5, -12.3), 0.5}
    self.SoundNames["door_add_1_open"] = self.SoundNames["door_cab_open"]
    self.SoundPositions["door_add_1_open"] = {800, 1e9, Vector(411.2, -57.5, 45), 0.5}
    self.SoundNames["door_add_1_close"] = self.SoundNames["door_cab_close"]
    self.SoundPositions["door_add_1_close"] = {800, 1e9, Vector(411.2, -57.5, 45), 0.5}
    self.SoundNames["door_pvz_close"] = self.SoundNames["door_cab_close"]
    self.SoundPositions["door_pvz_close"] = {800, 1e9, Vector(411.6, 21, 42), 0.5}
    self.SoundNames["bkpu"] = {"subway_trains/760/vb_on.wav"}
    self.SoundPositions["bkpu"] = {800, 1e9, Vector(410.2, 59, 1), 0.5}

    local ring = self:GetNW2Bool("SingleRing", false) and self:GetNW2Int("RingType765", 1) or nil
    if ring then
        if ring == 1 then
            ring = math.random(2, 4)
        end
        if ring == 2 then
            ring = "subway_trains/765/rumble/ring_vityaz.wav"
        elseif ring == 3 then
            ring = "subway_trains/765/ring_msg.wav"
        elseif ring == 4 then
            ring = "subway_trains/760/new/ring_ars.wav"
        end
    end
    self.SoundNames["ring_call"] = { loop = true, ring or "subway_trains/765/rumble/ring_vityaz.wav" }
    self.SoundPositions["ring_call"] = {800, 1e9, Vector(490, 21.6, -9.2), 0.5}
    self.SoundNames["ring_ppz"] = { loop = true, ring or "subway_trains/765/rumble/ring_vityaz.wav" }
    self.SoundPositions["ring_ppz"] = {800, 1e9, Vector(417, 36, 31.3), 0.5}
    self.SoundNames["ring"] = { loop = true, ring or "subway_trains/760/new/ring_ars.wav" }
    self.SoundPositions["ring"] = {100, 1e9, Vector(417, 36, 31.3)}

    self.SoundNames["powerreserve"] = {"subway_trains/760/vb_on.wav"}
    self.SoundPositions["powerreserve"] = {800, 1e9, Vector(410.2, 55, 1), 0.5}

    self.SoundNames["rvs1"] = {"subway_trains/722/door_alarm.mp3"}
    self.SoundPositions["rvs1"] = {800, 1e9, Vector(454.817, 60.54, -10.64), 0.5}

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


    local hornType = self:GetNW2Int("HornType", 0)
    if hornType == 2 then hornType = math.random(3, 5) end
    if hornType == 3 then
        self.SoundNames["horn"] = { loop = 0.6, "subway_trains/common/pneumatic/horn/horn1_start.wav","subway_trains/common/pneumatic/horn/horn1_loop.wav", "subway_trains/common/pneumatic/horn/horn1_end.mp3" }
        self.SoundPositions["horn"] = {1100,1e9,Vector(450,0,-55),1}
    elseif hornType == 4 then
        self.SoundNames["horn"] = { loop = 0.6, "subway_trains/common/pneumatic/horn/horn2_start.wav","subway_trains/common/pneumatic/horn/horn2_loop.wav", "subway_trains/common/pneumatic/horn/horn2_end.mp3" }
        self.SoundPositions["horn"] = {1100,1e9,Vector(450,0,-55),1}
    elseif hornType == 5 then
        self.SoundNames["horn"] = { loop = 0.6, "subway_trains/765/tifon/tifon_start.mp3","subway_trains/765/tifon/tifon_loop.mp3", "subway_trains/765/tifon/tifon_end.mp3" }
        self.SoundPositions["horn"] = {1100,1e9,Vector(450,0,-55),1}
    end

    self.SoundNames["mfdu_down"] = {
        "subway_trains/765/btn_mfdu_dn1.mp3",
        "subway_trains/765/btn_mfdu_dn2.mp3",
    }
    self.SoundNames["mfdu_up"] = {
        "subway_trains/765/btn_mfdu_up1.mp3",
        "subway_trains/765/btn_mfdu_up2.mp3",
    }
end


ENT.PakToggles = {}

local function pmvToggle(name, tooltip, x, y, idx, positions, states, default)
    ENT.PakToggles[name] = {
        btnmap = "BackPPZ",
        positions = positions,
        default = default or 0,
        buttons = {
            {
                ID = name .. "Toggle", x = x + idx * 68.8, y = y + 30, radius = nil, model = {
                    var = name,
                    model = "models/metrostroi_train/81-760/81_760_switch_bcpu.mdl",
                    z = -1, ang = Angle(0,90,-90), color = Color(0,0,0),
                    speed = 4,
                    sndvol = 0.4, snd = function(_, val) return val == 0 and "multiswitch_panel_min" or val == (#positions - 1) and "multiswitch_panel_max" or "multiswitch_panel_mid" end,
                    sndmin = 90, sndmax = 1e3, sndang = Angle(-90,0,0)
                }
            },
            {ID = "PakUp" .. name, x = idx * 68.8 + x - 30, y = y,      w = 60, h = 30, tooltip = tooltip .. " ↑", model = {
                states = states, var = states and name or nil, varTooltip = states and function(ent) return ent:GetNW2Int(name, 0) / (#states - 1) end or nil
            }},
            {ID = "PakDn" .. name, x = idx * 68.8 + x - 30, y = y + 31, w = 60, h = 30, tooltip = tooltip .. " ↓", model = {
                states = states, var = states and name or nil, varTooltip = states and function(ent) return ent:GetNW2Int(name, 0) / (#states - 1) end or nil
            }},
        }
    }
end

pmvToggle("PmvAddressDoors", "Индивидуальное открытие дверей", 34, 84, 0, {0, 3}, {
    "Common.765.Buttons.IOn", "Common.765.Buttons.IOff"
}, 1)
pmvToggle("PmvRpdp", "Питание РПДП", 34, 84, 1, {0, 3}, {
    "Common.765.PMV.RPDP.BS", "Common.765.PMV.RPDP.AKB"
})
pmvToggle("PmvPant", "Отжатие токоприемников", 34, 160, 0, {0, 2, 4, 6}, {
    "Common.765.PMV.Pant.All", "Common.765.PMV.Pant.2nd", "Common.765.PMV.Pant.1st", "Common.765.PMV.Pant.Off"
}, 3)
pmvToggle("PmvParkingBrake", "Стояночный тормоз", 34, 160, 1, {0, 3}, {
    "Common.765.Buttons.Off", "Common.765.Buttons.On"
})
pmvToggle("PmvAtsBlock", "Блокиратор АТС", 34, 160, 2, {0, 1, 2, 3}, {
    "Common.765.PMV.ATS.Normal", "Common.765.PMV.ATS.ATS1", "Common.765.PMV.ATS.ATS2", "Common.765.PMV.ATS.UOS"
})
pmvToggle("PmvFreq", "Дешифратор", 34, 160, 3, {0, 3}, {
    "Common.765.PMV.Freq.DAU", "Common.765.PMV.Freq.AlsArs"
})
pmvToggle("PmvLights", "Освещение салона", 34, 160, 4, {0, 3}, {
    "Common.765.Buttons.IOn", "Common.765.Buttons.IOff"
}, 1)
pmvToggle("PmvEmerPower", "Аварийное питание", 34, 160, 5, {0, 3}, {
    "Common.765.Buttons.IOff", "Common.765.Buttons.IOn"
})
pmvToggle("PmvCond", "Выключатель кондиционера салона", 34, 160, 6, {0, 3}, {
    "Common.765.Buttons.On", "Common.765.Buttons.Off"
}, 1)
--[[
    TODO restore functionality:
    SA13 рез. фары - нужен ли, либо всегда вкл от рез. цепей
    SA15 авар.пит.приц.ваг. - проверить, используется ли после переработки БС
]]


local function ppzToggle(name, tooltip, x, y, idx)
    return {
        relayName = name,
        ID = name .. "Toggle", tooltip = tooltip,
        x = idx * 29.8 + x, y = y,
        w = 29.8, h = 50,
        model = {
            var = name,
            model = "models/metrostroi_train/81-765/switch_breaker.mdl",
            z = 0, ang = Angle(-90, -180, 0), scale = 1,
            speed = 9, sndvol = 0.4, vmin = 0, vmax = 1,
            snd = function(val) return val and "sf_on" or "sf_off" end,
            sndmin = 90, sndmax = 1e3,
        }
    }
end

ENT.PpzToggles = {
    ppzToggle("SF42F1", "42F1: РПДП", 3.0, 356, 0),
    ppzToggle("SF30F1", "30F1: Управление БС", 3.0, 356, 1),
    ppzToggle("SF23F2", "23F2: Активная кабина", 3.0, 356, 2),
    ppzToggle("SF23F1", "23F1: Управление резервное", 3.0, 356, 3),
    ppzToggle("SF23F3", "23F3: Управление основное", 3.0, 356, 4),
    ppzToggle("SF23F13", "23F13: Ориентация", 3.0, 356, 5),
    ppzToggle("SF23F7", "23F7: АТС-2", 3.0, 356, 6),
    ppzToggle("SF23F8", "23F8: АТС-1, УПИ, Монитор", 3.0, 356, 7),
    ppzToggle("SF22F5", "22F5: РВТБ", 3.0, 356, 8),
    ppzToggle("SF22F2", "22F2: КМ, БТБУ, СД", 3.0, 356, 9),
    ppzToggle("SF22F3", "22F3: Управление стояночным тормозом", 3.0, 356, 10),
    ppzToggle("SF80F5", "80F5: Двери управление", 3.0, 356, 11),
    ppzToggle("SF80F1", "80F1: Контроль дверей", 3.0, 356, 12),
    ppzToggle("SF80F3", "80F3: Двери кабины", 3.0, 356, 13),
    ppzToggle("SF62F1", "62F1: Вентиляция аппаратного отсека", 3.0, 356, 14),
    ppzToggle("SF42F2", "42F2: Счетчик", 3.0, 356, 15),
    ppzToggle("SF30F5", "30F5: ППП", 3.0, 536, 0),
    ppzToggle("SF70F1", "70F1: Радиосвязь", 3.0, 536, 1),
    ppzToggle("SF45F11", "45F11: ЦИК", 3.0, 536, 2),
    ppzToggle("SF45F1", "45F1: Видеонаблюдение", 3.0, 536, 3),
    ppzToggle("SF43F3", "43F3: Штурман (антисон)", 3.0, 536, 4),
    ppzToggle("SF90F1", "90F1: АСОТП ЦБКИ", 3.0, 536, 5),
    ppzToggle("SF22F4", "Не используется", 3.0, 536, 6),
    ppzToggle("SF51F1", "51F1: Фары, габаритные огни", 3.0, 536, 7),
    ppzToggle("SF51F2", "51F2: Габаритные огни от АКБ\n(ночной отстой)", 3.0, 536, 8),
    ppzToggle("SF52F1", "52F1: Освещение кабины", 3.0, 536, 9),
    ppzToggle("SF62F3", "62F3: Кондиционер кабины", 3.0, 536, 10),
    ppzToggle("SF62F4", "62F4: Обеззараживающее уст-во кабины", 3.0, 536, 11),
    ppzToggle("SF61F8", "61F8: Кондиционер салона", 3.0, 536, 12),
    ppzToggle("SF70F5", "70F4: Обогрев кресла, подножки\nШторка, подстаканник (81-765.4)", 3.0, 536, 13),
    ppzToggle("SF70F3", "70F3: Стеклоочиститель, омыватель, АГС, сигнал", 3.0, 536, 14),
    ppzToggle("SF70F2", "70F2: Обогрев стекла", 3.0, 536, 15),
}

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
            model = "models/metrostroi_train/81-765/switch_breaker.mdl",
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
    self:LoadSystem("KV765", "81_765_Controller")
    self:LoadSystem("RV", "81_720_RV")
    self:LoadSystem("BUKP", "81_760E_BUKP")
    self:LoadSystem("BUV", "81_760E_BUV")
    self:LoadSystem("BUD", "81_765_BUD")
    self:LoadSystem("BARS", "81_760E_BARS")
    self:LoadSystem("SD3", "Relay", "Switch")
    self:LoadSystem("Pneumatic", "81_760E_Pneumatic")
    self:LoadSystem("Horn", "81_720_Horn")
    self:LoadSystem("Panel", "81_760E_Panel")

    self:LoadSystem("ASNP", "81_760_ASNP")
    self:LoadSystem("ASNP_VV", "81_760_ASNP_VV")
    self:LoadSystem("IGLA_CBKI", "81_760_IGLA_CBKI1")
    self:LoadSystem("IGLA_PCBK", "81_760_IGLA_PCBK")
    self:LoadSystem("IK", "81_765_IK")
    self:LoadSystem("RVS", "81_760A_RVS_1")
    self:LoadSystem("BNT", "81_765_BNT")
    self:LoadSystem("BUIK", "81_765_BUIK")
    self:LoadSystem("CAMS", "81_760_CAMS")
    self:LoadSystem("ProstKos", "81_765_ProstKos")
    self:LoadSystem("FrontIK", "81_765_FrontIK")

    if self.InitializeSystemsServer then
        self:InitializeSystemsServer()
    end
end

if not ENT.AnnouncerPositions then print("ACHTUNG! PIZDEC! AnnouncerPositions") end
table.insert(ENT.AnnouncerPositions or {}, {Vector(490, 34.5, -10), 60, 0.2})

ENT.Cameras = {
    {Vector(430, 45, 30), Angle(0, 180, 0), "Train.765.CameraPMV"},
    {Vector(430, 45, 12), Angle(0, 180, 0), "Train.760.CameraPPZ"},
    {Vector(479, 43, -4), Angle(14.5, 30, 0), "Train.760.CameraCams"},
    {Vector(483, 23, -1), Angle(21, 0, 0), "Train.765.CameraBuik"},
    {Vector(486, -3, -3), Angle(21, 0, 0), "Train.765.CameraMfdu"},
    {Vector(427.5 + 40, -40, -25), Angle(55, -70, 0), "Train.760.CameraKRMH"},
    {Vector(415, 18, 9), Angle(0, 180, 0), "Train.760.CameraPVZ"},
    {Vector(380, 0, 45), Angle(0, 180, 0), "Train.765.CameraSalon"},
    {Vector(520, 0, 15), Angle(60, 0, 0), "Train.765.CameraCouple"},
}

---------------------------------------------------
-- Defined train information
-- Types of wagon(for wagon limit system):
-- 0 = Head or intherim
-- 1 = Only head
-- 2 = Only intherim
---------------------------------------------------
ENT.SubwayTrain = {
    Type = "81-765",
    Name = "81-765",
    WagType = 1,
    Manufacturer = "MVM",
    ALS = {
        HaveAutostop = true,
        TwoToSix = true,
        RSAs325Hz = true,
        Aproove0As325Hz = false,
        CheckLKT = false,
    },
    EKKType = 763,
    NoFrontEKK = true,
}

ENT.NumberRanges = {{65001, 65499}}


local skins = Metrostroi.Skins.GetTable("Texture", "Spawner.Texture", false, "train")
skins.Section = "Branding"

ENT.SpawnerSkins = function(prefix, ...)
    local extra = { }
    for _, k in ipairs({ ... }) do extra[k] = true end
    local tbl = Metrostroi.Skins.GetTable("Texture", "Spawner.Texture", false, "train")
    local typ = ENT and ENT.SkinsType
    tbl.Section = "Branding"
    tbl[4] = function()
        local result = {}
        for k, v in pairs(Metrostroi.Skins["train"]) do
            if v.typ == typ and (extra[k] or string.StartsWith(k, prefix)) and not hook.Run("MetrostroiSkinsCheck", typ, "train", v.name or k, k) then
                result[k] = v.name or k
            end
        end
        if table.IsEmpty(result) then result = {["760e.MosBrend"] = "Чура"} end
        return result
    end
    return tbl
end

ENT.SpawnerLogos = function(...)
    local arg = { ... }
    local whitelist = #arg > 0 and {} or nil
    for _, k in ipairs(arg) do whitelist[k] = true end
    return {
        "BLIK:Logo",
        "Логотип БЛ-ИК",
        "List",
        function()
            local tbl = { ["-"] = "Нет" }  -- FIXME translation
            if not Metrostroi.Skins or not Metrostroi.Skins["765logo"] then return tbl end
            for k, v in pairs(Metrostroi.Skins["765logo"]) do
                if not whitelist or whitelist[k] then
                    tbl[k] = v.name or k
                end
            end
            return tbl
        end,
        "-",
        function(ent, val)
            ent:SetNW2String("BLIK:Logo", val)
        end,
        function(self, sl)
            local val = self:GetOptionData(self:GetSelectedID())
            local cfg = Metrostroi.Skins and Metrostroi.Skins["765logo"] and Metrostroi.Skins["765logo"][val]
            local d = val == "-" or not cfg or not isfunction(cfg.anim)
            local a = sl["BLIK:Anim"]
            a:SetValue(not d)
            a:SetDisabled(d)
            a.Disable = d

            if not cfg or not cfg.defaults then return end
            for k,v in pairs(cfg.defaults) do
                local id = sl[k].ID
                if id and sl[id] then
                    sl[id](v, true)
                end
            end
        end,
        Section = "Branding",
    }
end

ENT.SpawnerSpawnFnc = function(mg, mp, pp)
    return function(i, tbls)
        local WagNum = tbls.WagNum
        if i > 1 and i < WagNum then
            return (
                WagNum < 6 and not tbls.NoTrailers and i == 3 or
                WagNum >= 6 and i % 3 == 0
            ) and pp or mp
        else
            return mg
        end
    end
end

ENT.SpawnerCustom = {
    model = {"models/metrostroi_train/81-760e/81_760e_body.mdl", "models/metrostroi_train/81-760/81_760a_int.mdl", "models/metrostroi_train/81-765/cabin.mdl", "models/metrostroi_train/81-765/headlights_main_off.mdl",},
    spawnfunc = ENT.SpawnerSpawnFnc("gmod_subway_81-765e", "gmod_subway_81-766e", "gmod_subway_81-767e"),
    postfunc = function(trains, WagNum)
        local wag1 = trains[1]:GetWagonNumber()
        for i = 1, #trains do
            local ent = trains[i]
            if ent._SpawnerStarted <= 2 then
                ent.BUV.OrientateBUP = wag1
                ent.BUV.LastOrientate = wag1
                ent.BUV.FirstHalf = i % 2 > 0
                ent.BUV.Reset = CurTime()
            end

            if not ent.BUKP then continue end
            local wagn = math.min(8, WagNum)
            ent.BUKP.WagNum = wagn
            ent.BUKP.Trains = {}
            for j = 1, wagn do
                local tent = trains[i == 1 and j or #trains - j + 1]
                local oldNum = ent.BUKP.Trains[j]
                local data = oldNum and ent.BUKP.Trains[oldNum]
                if oldNum then ent.BUKP.Trains[oldNum] = nil end
                ent.BUKP.Trains[j] = tent:GetWagonNumber()
                ent.BUKP.Trains[tent:GetWagonNumber()] = data or {}
            end
            for j = wagn + 1, 8 do
                local oldNum = ent.BUKP.Trains[j]
                if oldNum then ent.BUKP.Trains[oldNum] = nil end
                ent.BUKP.Trains[j] = nil
            end

            ent:SetNW2Int("CAMSWagNum", wagn)
            ent.CAMS.Inv = ent:GetWagonNumber() > trains[i == 1 and wagn or 1]:GetWagonNumber()
            ent:SetNW2Bool("CAMSInv", ent:GetWagonNumber() > trains[i == 1 and wagn or 1]:GetWagonNumber())
            ent:SetNW2Bool("CAMSLast", trains[wagn]:GetWagonNumber() > 37000)
            ent.ASNP.Path = i ~= 1
        end
    end,
    skins,
    -- Metrostroi.Skins.GetTable("PassTexture","Spawner.PassTexture",PassTexture,"pass"),
    -- Metrostroi.Skins.GetTable("CabTexture","Spawner.CabTexture",CabTexture,"cab"),
    {
        "Announcer",
        "Spawner.760.Announcer",
        "List",
        function()
            local Announcer = {}
            for k, v in pairs(Metrostroi.AnnouncementsASNP or {}) do
                if not v.riu then Announcer[k] = v.name or k end
            end
            return Announcer
        end,
        Section = "IkConfig",
    },
    {
        "CISConfig",
        "ИК / ЦИС Конфиг карты",
        "List",
        function()
            local CISConfig = {}
            local ikOnly = false
            for k, v in pairs(Metrostroi.CISConfig or {}) do
                local name = v.name or k
                if string.StartsWith(name, "[ИК]") then
                    if not ikOnly then CISConfig = {} end
                    ikOnly = true
                    CISConfig[k] = name
                elseif not ikOnly then
                    CISConfig[k] = name
                end
            end
            return CISConfig
        end,
        Section = "IkConfig",
    },
    ENT.SpawnerLogos(),
    { "BLIK:Anim", "Анимация БЛ-ИК", "Boolean", Section = "Branding" },
    { "SarmatBeep", "Звук теста аппаратуры от \"Сармат\"", "Boolean", Section = "Settings", Subsection = "AudioEvents", },
    { "AnnouncerClicks", "Звук клика в оповещениях", "Boolean", Section = "Settings", Subsection = "AudioEvents" },
    {
        "SingleRing",
        "Один тип звонка",
        "Boolean",
        false,
        nil,
        function(self, sl)
            if sl.RingType765 then
                sl.RingType765:SetDisabled(not self:GetChecked())
            end
        end,
        Section = "Settings", Subsection = "AudioEvents"
    },
    { "RingType765", "Тип звонка", "List", { "Случайный", "Тип 1", "Тип 2", "Тип 3" }, 1, Section = "Settings", Subsection = "AudioEvents" },
    { "HornType", "Тифон", "List", { "Стандартный", "Случайный", "Тип 1", "Тип 2", "81-765" }, 5, Section = "Settings", Subsection = "Sounds" },
    { "KvType", "Звук КВ", "List", { "Случайный", "Alfa Union", "81-765" }, 3, Section = "Settings", Subsection = "Sounds" },
    { "AddressDoors", "Индивид. открытие дверей (765.2)", "Boolean", false, Section = "Settings", Subsection = "FunctionalSettings" },
    { "ForgivefulBars", "БАРС прощает ошибки", "Boolean", true, Section = "Settings", Subsection = "FunctionalSettings" },
    { "BtbuSd", "Автомат ППЗ БТБУ", "Boolean", false, Section = "Settings", Subsection = "FunctionalSettings" },
    {
        "NoTrailers", "Без прицепных 763Э", "Boolean", false, nil,
        function(self, stbl)
            local wagnField = stbl.WagNum
            if self.TrainInjected == wagnField then return end
            self.TrainInjected = wagnField
            local t = self.Think or function() end
            self.Think = function(_self)
                local retval = { t(_self) }
                local wagn = wagnField:GetValue()
                if wagnField == self.TrainInjected and wagn ~= self.PrevWagn then
                    local enable = wagn < 6 and wagn > 3
                    self:SetEnabled(enable)
                    if not enable then
                        self:SetValue(wagn <= 3)
                    else
                        self:SetValue(false)
                    end
                    self.PrevWagn = wagn
                end
                return unpack(retval)
            end
        end,
        Section = "Settings", Subsection = "FunctionalSettings"
    },
    { "BMIK:Font", "Шрифт БМТ, БНМ", "List", { "Тип 1 (2017)", "Тип 2 (2019)" }, 1, Section = "Settings", Subsection = "VisualSettings" },
    { "CikColor", "Цвет БМТ, БНМ", "List", { "Метроспецтехника (желтый)", "Сармат (рыжий)", "Ранний (зеленый)" }, 1, Section = "Settings", Subsection = "VisualSettings" },
    { "BntFps", "FPS на БНТ", "List", { "Метроспецтехника (15 FPS)", "Сармат (60 FPS)" }, 1, Section = "Settings", Subsection = "VisualSettings" },
    { "BuikType", "БУ-ИК", "List", { "Метроспецтехника (Москва)", "Метроспецтехника (Чура)", "Сармат" }, 1, Section = "Settings", Subsection = "VisualSettings" },
    {
        "ArsMode",
        "Режим для АБ",
        "List",
        {"1/5", "ДАУ (АБ)", "ДАУ (АЛС-АРС)"},
        1,
        function(ent, val)
            ent.AlsArs = val == 3
            ent.ArsDau = val ~= 1
            ent:SetNW2String("AlsArs", ent.AlsArs)
            ent:SetNW2String("ArsDau", ent.ArsDau)
        end,
        Section = "Settings", Subsection = "VisualSettings"
    },
    { "KdLongerDelay", "Задержка контроля дверей", "Boolean", false, Section = "Wear" },
    {
        "BreakRedChance", "Шанс сломать габ. огни", "Slider", 0, 0, 35, 0,
        function(ent, val, rot, i)
            if ent.SA1 then
                local any = false
                for idx = 1, 4 do
                    local broke = math.random() < (val / 100)
                    any = any or broke
                    ent:SetNW2Bool("RlBroken" .. idx, broke)
                end
                if not any and val > 20 and i ~= 1 then
                    ent:SetNW2Bool("RlBroken" .. math.random(4), true)
                end
            end
        end,
        Section = "Wear"
    },
    {
        "VVVFSound",
        "Звук инвертора",
        "List",
        {
            "Стоковый с 81-760",
            "ALSTOM ONIX IGBT",
            "ТМХ КАТП-1",
            "ТМХ КАТП-3",
            "Hitachi GTO",
            "Hitachi IGBT",
            "Hitachi VFI-HD1420F",
            "КАТП-3 Экспериментальный (81-765Э)"
        },
        8,
        nil,
        function(self, spawnerList)
            if self:GetSelectedID() ~= 3 then
                spawnerList.HSEngines:SetValue(false)
                spawnerList.HSEngines:SetDisabled(true)
                spawnerList.HSEngines.Disable = true
            else
                spawnerList.HSEngines:SetDisabled(false)
                spawnerList.HSEngines.Disable = false
            end

            if self:GetSelectedID() ~= 2 then
                spawnerList.FirstONIX:SetValue(false)
                spawnerList.FirstONIX:SetDisabled(true)
                spawnerList.FirstONIX.Disable = true
            else
                spawnerList.FirstONIX:SetDisabled(false)
                spawnerList.FirstONIX.Disable = false
            end
        end,
        Section = "Settings", Subsection = "AsyncSounds"
    },
    { "HSEngines", "Spawner.720a.HSEngines", "Boolean", Section = "Settings", Subsection = "AsyncSounds" },
    { "FirstONIX", "Spawner.720a.FirstONIX", "Boolean", Section = "Settings", Subsection = "AsyncSounds" },
    {
        "SpawnMode",
        "Spawner.Common.SpawnMode",
        "List",
        {"Spawner.Common.SpawnMode.Full", "Spawner.Common.SpawnMode.Deadlock", "Spawner.Common.SpawnMode.NightDeadlock", "Spawner.Common.SpawnMode.Depot"},
        nil,
        function(ent, val, rot, i, wagnum, rclk)
            if rclk then return end
            if ent._SpawnerStarted ~= val then
                ent.Pneumatic:TriggerInput("Spawned", true)
                if val <= 2 then
                    ent.Electric:TriggerInput("Power", true)
                end
                local first = i == 1 or _LastSpawner ~= CurTime()
                if first then
                    if IsValid(ent.Owner) and ent.Owner.GetUTimeTotalTime then
                        _Odometer = math.floor(ent.Owner:GetUTimeTotalTime() * 1000 / 3600 * 1000)
                    else
                        _Odometer = math.random(0, 999999)
                    end
                    _randRoute = math.random(1, 89)
                    _DoorsDelay = math.Rand(0.42, 0.57)
                end
                if _Odometer then ent.Odometer = _Odometer end
                if _DoorsDelay then ent.BUD.DoorsDelayMax = _DoorsDelay end
                if ent.SA1 then
                    local leaveOff = {
                        SF22F4 = not ent:GetNW2Bool("BtbuSd", false),
                        SF70F2 = true,  -- PpzWindshieldHeat
                        SF43F3 = true,  -- PpzSmartdrive
                        SF51F2 = val ~= 3,  -- PpzBattLights
                        SF30F1 = val > 2,  -- PpzBsControl
                        SF62F3 = val > 1,  -- PpzCabinAc
                        SF62F4 = val > 1,  -- PpzCabinEpra
                        SF70F4 = val > 2,  -- PpzAuxCabin
                    }
                    for _, cfg in ipairs(ent.PpzToggles or {}) do
                        local r = ent[cfg.relayName]
                        if r and r.TriggerInput then
                            r:TriggerInput("Set", leaveOff[cfg.relayName] and 0 or 1)
                        end
                    end

                    if MetrostroiAdvanced and MetrostroiAdvanced.TwoToSixMap then
                        ent.PmvFreq:TriggerInput("Set", 1)
                    end

                    ent.HeadlightsSwitch:TriggerInput("Set", 2)
                    ent.DoorClose:TriggerInput("Set", first and val == 1 and 1 or 0)
                    ent.R_ASNPOn:TriggerInput("Set", 1)
                    ent.CabinLight:TriggerInput("Set", 1)

                    -- Without that, sometimes they remain turned off in turbostroi, but turning on on main thread
                    timer.Simple(1, function()
                        ent.PmvAddressDoors:TriggerInput("Set", ent:GetNW2Bool("AddressDoors", false) and 0 or 1)
                        ent.PmvParkingBrake:TriggerInput("Set", val == 3 and 1 or 0)
                        ent.PmvLights:TriggerInput("Set", val <= 1 and 0 or 1)
                        ent.PmvCond:TriggerInput("Set", val <= 1 and 0 or 1)
                    end)

                    local yd = os.date("!*t").yday
                    ent.BUKP.CondLeto = yd > 115 and yd < 300

                    _LastSpawner = CurTime()
                    ent.CabinDoorLeft = val == 4 and first
                    ent.CabinDoorRight = val == 4 and first
                    ent.PassengerDoor = val == 4
                    ent.RearDoor = val == 4
                else
                    ent.FrontDoor = val == 4
                    ent.RearDoor = val == 4
                end

                for idx = 1, 8 do ent.BUD.DoorCommand[idx] = val == 4 end

                ent.GV:TriggerInput("Set", val < 4 and 1 or 0)

                if val <= 2 then
                    if ent.SA1 then
                        timer.Simple(2, function()
                            if not IsValid(ent) then return end
                            ent.BUKP.State = 5
                            ent.BUIK.State = 4
                            for idx = 1, 8 do
                                ent:SetNW2String("BUIK:WagErr" .. idx, false)
                                for di = 1, 8 do
                                    ent:SetNW2Bool(string.format("BUIK:Wag%dDoor%dClosed", idx, di), true)
                                end
                            end
                            ent.BUKP:CState("ZeroSpeed", true)
                        end)
                    end

                    timer.Simple(7, function()
                        if not IsValid(ent) then return end
                        ent.BUV.PassLight = val == 1
                        if ent.AsyncInverter then ent.BUV.PSNSignal = true end
                        if ent.ASNP and isnumber(ent.ASNP.RouteNumber) then
                            if val <= 2 and ent.ASNP.RouteNumber <= 0 then
                                ent.ASNP.RouteNumber = _randRoute or 11
                            elseif ent.ASNP.RouteNumber * 10 % 10 ~= 0 then
                                ent.ASNP.RouteNumber = math.floor(ent.ASNP.RouteNumber * 10)
                            end
                            ent.BUIK.RouteNumber = val <= 2 and ent.ASNP.RouteNumber or 0
                            ent.BUKP.RouteNumber = val <= 2 and ent.ASNP.RouteNumber or 0
                        end
                    end)

                    timer.Simple(3, function()
                        if not IsValid(ent) then return end
                        ent.BV:TriggerInput("Set", 1)
                    end)

                    ent.Pneumatic.BrakeLinePressure = 2.25 + math.random() * 0.15
                end

                ent.Pneumatic.TrainLinePressure = val == 3 and 5 + math.random() or val == 2 and 6.6 + math.random() * 1.4 or 7.6 + math.random() * 0.5
                if not ent.SA1 then ent.Pneumatic.TLPressure = ent.Pneumatic.TrainLinePressure end
                ent.Pneumatic.ParkingBrakePressure = val == 3 and 0 or ent.Pneumatic.TrainLinePressure
                ent.Pneumatic.ParkingBrake = val == 3
                ent._SpawnerStarted = val
            end
        end
    }
}

for idx = 1, 4 do
    table.insert(ENT.SpawnerCustom.model, "models/metrostroi_train/81-765/headlights_" .. idx .. "_off.mdl")
end

ENT.Spawner = {
    model = ENT.SpawnerCustom.model,
    spawnfunc = ENT.SpawnerSpawnFnc("gmod_subway_81-765", "gmod_subway_81-766", "gmod_subway_81-767"),
    postfunc = ENT.SpawnerCustom.postfunc,
    ENT.SpawnerSkins("765", "760e.Moscow"),
    ENT.SpawnerCustom[2], ENT.SpawnerCustom[3],
    ENT.SpawnerLogos("MosMetro", "MosBrend", "MosBrend3D"),
    ENT.SpawnerCustom[5],  -- BLIK:Anim
    ENT.SpawnerCustom[9],  -- RingType765
    ENT.SpawnerCustom[15],  -- NoTrailers
    ENT.SpawnerCustom[20],  -- ArsMode
    ENT.SpawnerCustom[21],  -- KdLongerDelay
    ENT.SpawnerCustom[22],  -- BreakRedChance
    { "CikType", "ЦИК", "List", { "Метроспецтехника", "Сармат", "Метроспецтехника (ранний)" }, 1, Section = "Settings", Subsection = "FunctionalSettings" },
    ENT.SpawnerCustom[#ENT.SpawnerCustom]
}


ENT.ExportTable = "Impl765"
ENT.SharedFields = {
    "Version",
    "IkVersion",
    "Spawner",
    "SpawnerCustom",
    "SpawnerSkins",
    "SpawnerLogos",
    "Cameras",
    "PakToggles",
    "PpzToggles",
    "PvzToggles",
    "AnnouncerPositions",
    "LeftDoorPositions",
    "RightDoorPositions",
    "LeftDoorPositionsBAK",
    "RightDoorPositionsBAK",
}
