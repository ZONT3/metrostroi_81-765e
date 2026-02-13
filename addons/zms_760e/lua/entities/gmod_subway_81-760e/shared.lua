--------------------------------------------------------------------------------
-- 81-760Э «Чурá» by ZONT_ a.k.a. enabled person
-- Based on code by Cricket, Hell et al.
-- Logic of 81-720A Experimental engines sounds by fixinit75
-- located between "BEGIN EXPERIMENTAL ENGINES" and "END EXPERIMENTAL ENGINES",
-- permission granted for this addon
--------------------------------------------------------------------------------
ENT.Type = "anim"
ENT.Base = "gmod_subway_base"
ENT.PrintName = "81-760E PvVZ"
ENT.Author = ""
ENT.Contact = ""
ENT.Purpose = ""
ENT.Instructions = ""
ENT.Category = "Metrostroi (trains)"
ENT.SkinsType = "81-760e"
ENT.Model = "models/metrostroi_train/81-760e/81_760e_body.mdl"
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.DontAccelerateSimulation = false

ENT.Version = "0.10.0-dev"
ENT.IkVersion = "1.10.0-dev"


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
    return Vector(-450, -30, -53), Vector(360, 30, -53)
end

local yventpos = {-414.5 + 0 * 117, -414.5 + 1 * 117 + 6.2, -414.5 + 2 * 117 + 5, -414.5 + 3 * 117 + 2, -414.5 + 4 * 117 + 0.5, -414.5 + 5 * 117 - 2.3, -414.5 + 6 * 117,}
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
    self.SoundPositions["KATP_lowspeed"] = {400, 1e9, Vector(0, 0, -448), 1.8}
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

    self.SoundPositions["async1"] = {400, 1e9, Vector(0, 0, 0), 0.5}

    for i = 1, 7 do
        self.SoundNames["vent" .. i] = {
            loop = true,
            "subway_trains/720/vent_mix.wav"
        }

        self.SoundPositions["vent" .. i] = {100, 1e9, Vector(yventpos[i], 0, 30), 0.5}
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

    self.SoundNames["battery_on_1"]   = "subway_trains/722/battery/battery_off_1.mp3"
    self.SoundPositions["battery_on_1"] = {100,1e9,Vector(182,50,-75),0.5}
    self.SoundNames["battery_off_1"]   = "subway_trains/722/battery/battery_off_1.mp3"
    self.SoundPositions["battery_off_1"] = {100,1e9,Vector(182,50,-75),1}
    self.SoundNames["battery_off_2"]   = "subway_trains/722/battery/battery_off_2.mp3"
    self.SoundPositions["battery_off_2"] = {100,1e9,Vector(182,50,-75),1}
    self.SoundNames["battery_pneumo"]   = "subway_trains/722/battery/battery_pneumo.mp3"
    self.SoundPositions["battery_pneumo"] = {200,1e9,Vector(182,50,-75),0.5}

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

    self.SoundNames["multiswitch_panel_max"] = "subway_trains/722/switches/multi_switch_panel_max.mp3"
    self.SoundNames["multiswitch_panel_mid"] = {"subway_trains/722/switches/multi_switch_panel_mid.mp3","subway_trains/722/switches/multi_switch_panel_mid2.mp3"}
    self.SoundNames["multiswitch_panel_min"] = "subway_trains/722/switches/multi_switch_panel_min.mp3"
    self.SoundNames["pak_on"] = "subway_trains/717/switches/rc_on.mp3"
    self.SoundNames["pak_off"] = "subway_trains/717/switches/rc_off.mp3"

    self.SoundNames["gv_f"] = {"subway_trains/717/kv70/reverser_0-b_1.mp3", "subway_trains/717/kv70/reverser_0-b_2.mp3"}
    self.SoundNames["gv_b"] = {"subway_trains/717/kv70/reverser_b-0_1.mp3", "subway_trains/717/kv70/reverser_b-0_2.mp3"}
    self.SoundPositions["gv_f"] = {80, 1e9, Vector(126.4, 50, -60 - 23.5), 0.8}
    self.SoundPositions["gv_b"] = {80, 1e9, Vector(126.4, 50, -60 - 23.5), 0.8}
    self.SoundNames["disconnectvalve"] = "subway_trains/common/switches/pneumo_disconnect_switch.mp3"

    self.SoundNames["batt_on"] = "subway_trains/720/batt_on.mp3"
    self.SoundPositions["batt_on"] = {400, 1e9, Vector(126.4, 50, -60 - 23.5), 0.3}
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

    self.SoundNames["epk_brake"] = {
        loop = true,
        "subway_trains/760/new/rvtb_loop.wav"
    }
    self.SoundPositions["epk_brake"] = {80, 1e9, Vector(458, 56.5, -61), 0.65}  -- FIXME pos
    self.SoundNames["epk_brake_close"] = {"subway_trains/760/new/rvtb_end.wav"}
    self.SoundPositions["epk_brake_close"] = {80, 1e9, Vector(458, 56.5, -61), 0.65}  -- FIXME pos
    self.SoundNames["epk_brake_open"] = {"subway_trains/760/new/rvtb_start.wav"}
    self.SoundPositions["epk_brake_open"] = {80, 1e9, Vector(458, 56.5, -61), 0.65}  -- FIXME pos

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

    self.SoundNames["door_alarm"] = {"subway_trains/765/rumble/door_alarm_fast.mp3"}
    self.SoundPositions["door_alarm"] = {485, 1e9, Vector(0, 0, 0), 0.25}
    self.SoundNames["sf_on"] = "subway_trains/722/switches/sf_on.mp3"
    self.SoundNames["sf_off"] = "subway_trains/722/switches/sf_off.mp3"
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

    self.SoundNames["ring_call"] = { loop = true, "subway_trains/765/rumble/ring_vityaz.wav" }
    self.SoundPositions["ring_call"] = {800, 1e9, Vector(490, 21.6, -9.2), 0.5}
    self.SoundNames["ring_ppz"] = { loop = true, "subway_trains/765/rumble/ring_vityaz.wav" }
    self.SoundPositions["ring_ppz"] = {800, 1e9, Vector(417, 36, 31.3), 0.5}
    self.SoundNames["ring"] = { loop = true, "subway_trains/760/new/ring_ars.wav" }
    self.SoundPositions["ring"] = {100, 1e9, Vector(417, 36, 31.3)}

    self.SoundNames["powerreserve"] = {"subway_trains/760/vb_on.wav"}
    self.SoundPositions["powerreserve"] = {800, 1e9, Vector(410.2, 55, 1), 0.5}
    self.SoundNames["bv_off"] = {"subway_trains/760/new/bv_off.wav"}
    self.SoundPositions["bv_off"] = {800, 1e9, Vector(0, 0, -45), 0.5}
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
        self.SoundPositions["announcer_noiseW" .. k] = {v[2] or 300, 1e9, v[1], v[3] * 0.2}

        self.SoundNames["announcer_sarmat_start" .. k] = {"subway_trains/722/sarmat_start.mp3"}
        self.SoundPositions["announcer_sarmat_start" .. k] = {v[2] or 300, 1e9, v[1], v[3] * 0.2}
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
            model = "models/metrostroi_train/81-765/switch_av.mdl",
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
    ppzToggle("PPZUU1", "Не используется", 3.0, 536, 6),
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
    pvzToggle("SF23F12", "Счётчик", 0, 0),
    pvzToggle("SF70F4", "USB", 0, 0),
    pvzToggle("SF22F1", "БУФТ", 0, 0),

    pvzToggle("SF23F11", "БУВ-S", 0, 50),
    pvzToggle("SF23F9", "Резерв", 0, 50),
    pvzToggle("SF90F2", "АСОТП", 0, 50),
    pvzToggle("SF23F10", "Противоюз", 0, 50),
    pvzToggle("SF45F5", "Видео 1", 0, 50),
    pvzToggle("SF45F6", "Видео 2", 0, 50),
    pvzToggle("SF45F7", "БНТ-ИК (Л)", 0, 50),
    pvzToggle("SF45F8", "БНТ-ИК (П)", 0, 50),
    pvzToggle("SF52F3", "Аварийное освещение", 0, 50),
    pvzToggle("SF61F3", "Включение кондиционера", 0, 50),

    pvzToggle("SF45F2", "Питание БВМ", 0, 100),
    pvzToggle("SF61F4", "Питание преобразователя", 0, 100),
    pvzToggle("SF23F4", "Инвертор", 0, 100),
    pvzToggle("SF45F4", "Питание БУТ", 0, 100),
    pvzToggle("SF30F4", "ПСН", 0, 100),
    pvzToggle("SF45F3", "Питание ESM", 0, 100),
    pvzToggle("SF30F3", "Осушитель", 0, 100),
    pvzToggle("SF21F1", "Токоприемники, осушитель, БККЗ, ДПБТ", 0, 100),
    pvzToggle("SF52F5", "Подсветка двери левой", 0, 100),
    pvzToggle("SF52F4", "Подсветка дверей", 0, 100),

    pvzToggle("SF80F2", "Контроль дверей салона", 0, 150),
    pvzToggle("SF80F13", "Двери питание 2, 7", 0, 150),
    pvzToggle("SF80F14", "Двери питание 1, 4, 5", 0, 150),
    pvzToggle("SF80F12", "Двери питание 3, 6, 8", 0, 150),
    pvzToggle("SF80F8", "Двери закрытие", 0, 150),
    pvzToggle("SF80F11", "Двери выбор правые", 0, 150),
    pvzToggle("SF80F10", "Двери выбор левые", 0, 150),
    pvzToggle("SF80F7", "Двери открытие левые", 0, 150),
    pvzToggle("SF80F6", "Двери открытие правые", 0, 150),
    pvzToggle("SF80F9", "Скорость 0", 0, 150),

    pvzToggle("SF30F2", "БС Управлене", 0, 200),
    pvzToggle("SF23F5", "Управление основное", 0, 200),
    pvzToggle("SF23F6", "Управление резервное", 0, 200),
    pvzToggle("SF30F7", "Питание ЦУ 1", 0, 200),
    pvzToggle("SF30F9", "Питание ЦУ 2", 0, 200),
    pvzToggle("SF30F6", "Питание ЦУ 3", 0, 200),
    pvzToggle("SF30F8", "Питание ЦУ 4", 0, 200),
    pvzToggle("SF52F2", "Освещение основное", 0, 200),
    pvzToggle("SF61F1", "Питание УПВВ 1", 0, 200),
    pvzToggle("SF61F9", "Питание УПВВ 2", 0, 200),
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
    self:LoadSystem("sys_Autodrive", "81_765_AutoDrive")
    self:LoadSystem("FrontIK", "81_765_FrontIK")

    if self.InitializeSystemsServer then
        self:InitializeSystemsServer()
    end
end

ENT.AnnouncerPositions = {}
table.insert(ENT.AnnouncerPositions, {Vector(470, 0, 44), 100, 0.1})
for i = 1, 4 do
    table.insert(ENT.AnnouncerPositions, {
        Vector(323 - (i - 1) * 230, --[[+37.5]]
            47, 44),
        i == 1 and 60 or 100,
        0.1
    })

    table.insert(ENT.AnnouncerPositions, {Vector(323 - (i - 1) * 230, -47, 44), i == 1 and 60 or 100, 0.1})
end
table.insert(ENT.AnnouncerPositions, {Vector(490, 34.5, -10), 60, 0.2})

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
    Type = "81-760E",
    Name = "81-760E",
    WagType = 1,
    Manufacturer = "PvVZ",
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

ENT.NumberRanges = {{37500, 37699}}


ENT.Spawner = {
    model = {"models/metrostroi_train/81-760e/81_760e_body.mdl", "models/metrostroi_train/81-760/81_760a_int.mdl", "models/metrostroi_train/81-765/cabin.mdl", "models/metrostroi_train/81-765/headlights_main_off.mdl",},
    spawnfunc = function(i, tbls, tblt)
        local WagNum = tbls.WagNum
        if i > 1 and i < WagNum then
            return (
                WagNum < 6 and not tbls.NoTrailers and i == 3 or
                WagNum >= 6 and i % 3 == 0
            ) and "gmod_subway_81-763e" or "gmod_subway_81-761e"
        else
            return "gmod_subway_81-760e"
        end
    end,
    postfunc = function(trains, WagNum)
        local wag1 = trains[1]:GetWagonNumber()
        for i = 1, #trains do
            local ent = trains[i]
            if ent._SpawnerStarted <= 2 then
                timer.Simple(6, function()
                    if not IsValid(ent) then return end
                    ent.BUV.OrientateBUP = wag1
                    ent.BUV.CurrentBUP = wag1
                end)
            end

            if not ent.BUKP then continue end
            ent.BUKP.State = 1
            local wagn = math.min(8, WagNum)
            ent.BUKP.WagNum = wagn
            ent.BUKP.Trains = {}
            local first, last = 1, #trains
            for i1 = 1, wagn do
                local tent = trains[i == 1 and i1 or #trains - i1 + 1]
                ent.BUKP.Trains[i1] = tent:GetWagonNumber()
                ent.BUKP.Trains[tent:GetWagonNumber()] = {}
                ent:SetNW2String("BMCISWagN" .. i1, tent:GetWagonNumber())
            end

            ent:SetNW2Int("CAMSWagNum", wagn)
            ent.CAMS.Inv = ent:GetWagonNumber() > trains[i == 1 and wagn or 1]:GetWagonNumber()
            ent:SetNW2Bool("CAMSInv", ent:GetWagonNumber() > trains[i == 1 and wagn or 1]:GetWagonNumber())
            ent:SetNW2Bool("CAMSLast", trains[wagn]:GetWagonNumber() > 37000)
            ent.ASNP.Path = i ~= 1
        end
    end,
    Metrostroi.Skins.GetTable("Texture", "Spawner.Texture", false, "train"),
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
        end
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
        end
    },
    {
        "BLIK:Logo",
        "Логотип БЛ-ИК",
        "List",
        function()
            local tbl = { ["-"] = "Нет" }  -- FIXME translation
            if not Metrostroi.Skins or not Metrostroi.Skins["765logo"] then return tbl end
            for k, v in pairs(Metrostroi.Skins["765logo"]) do
                tbl[k] = v.name or k
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
            if d then a:SetValue(false) end
            a:SetDisabled(d)
            a.Disable = d

            if not cfg or not cfg.defaults then return end
            for k,v in pairs(cfg.defaults) do
                local id = sl[k].ID
                if id and sl[id] then
                    sl[id](v, true)
                end
            end
        end
    },
    { "BLIK:Anim", "Анимация БЛ-ИК", "Boolean" },
    { "SarmatBeep", "Звук теста аппаратуры от \"Сармат\"", "Boolean" },
    { "AnnouncerClicks", "Звук клика в оповещениях", "Boolean" },
    { "HornType", "Тифон", "List", { "Стандартный", "Случайный", "Тип 1", "Тип 2", "81-765" }, 5 },
    { "BntFps", "FPS на БНТ", "List", { "Метроспецтехника (~12 FPS)", "Сармат (60 FPS)" }, 1 },
    { "KvType", "Звук КВ", "List", { "Случайный", "Alfa Union", "81-765" }, 3 },
    {
        "VVVFSound",
        "Spawner.720a.VVVFSound",
        "List",
        {
            "Стоковый с 81-760",
            "Spawner.720a.VVVFSound.1", -- ALSTOM ONIX IGBT
            "Spawner.720a.VVVFSound.2", -- ТМХ КАТП-1
            "Spawner.720a.VVVFSound.3", -- ТМХ КАТП-3
            "Spawner.720a.VVVFSound.4", -- Hitachi GTO
            "Spawner.720a.VVVFSound.5", -- Hitachi IGBT
            "Spawner.720a.VVVFSound.6", -- Hitachi VFI-HD1420F
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
        end
    },
    {"HSEngines", "Spawner.720a.HSEngines", "Boolean"},
    {"FirstONIX", "Spawner.720a.FirstONIX", "Boolean"},
    {"AddressDoors", "Индивид. открытие дверей (765.2)", "Boolean", false},
    {"ForgivefulBars", "БАРС прощает ошибки", "Boolean", true},
    {"KdLongerDelay", "Задержка контроля дверей", "Boolean", false},
    {"BreakRedChance", "Шанс сломать габ. огни", "Slider", 0, 0, 35, 0, function(ent, val, rot, i)
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
    end},
    {"NoTrailers", "Без прицепных 763Э", "Boolean", false, nil, function(self, stbl)
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
    end},
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
                        PPZUU1 = true,
                        SF70F2 = true,  -- PpzWindshieldHeat
                        SF43F3 = true,  -- PpzSmartdrive
                        SF51F2 = val ~= 3,  -- PpzBattLights
                        SF30F1 = val > 2,  -- PpzBsControl
                        SF62F3 = val > 2,  -- PpzCabinAc
                        SF62F4 = val > 2,  -- PpzCabinEpra
                        SF70F4 = val > 2,  -- PpzAuxCabin
                        SF51F1 = val > 2,  -- PpzHeadlights
                        SF52F1 = val > 2,  -- PpzCabinLights
                    }
                    for _, cfg in ipairs(ent.PpzToggles or {}) do
                        if not leaveOff[cfg.relayName] then
                            local r = ent[cfg.relayName]
                            if r and r.TriggerInput then
                                r:TriggerInput("Set", 1)
                            end
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
                        ent.PmvLights:TriggerInput("Set", val <= 2 and 0 or 1)
                        ent.PmvCond:TriggerInput("Set", val <= 2 and 0 or 1)
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

                ent.BUD.RightDoorState = val == 4 and {1, 1, 1, 1} or {0, 0, 0, 0}
                ent.BUD.DoorRight = val == 4
                ent.BUD.LeftDoorState = val == 4 and {1, 1, 1, 1} or {0, 0, 0, 0}
                ent.BUD.DoorLeft = val == 4
                for idx = 1, 8 do ent.BUD.DoorCommand[idx] = val == 4 end

                ent.GV:TriggerInput("Set", val < 4 and 1 or 0)

                if val <= 2 then
                    if ent.SA1 then
                        timer.Simple(first and 2 or 1, function()
                            if not IsValid(ent) then return end
                            ent:SetNW2Int("Skif:WagNum", ent.BUKP.WagNum)
                            for i = 1, ent.BUKP.WagNum do
                                ent:CANWrite("BUKP", ent:GetWagonNumber(), "BUV", ent.BUKP.Trains[i], "Orientate", i % 2 > 0)
                            end

                            ent.BUKP.Errors = {}
                            ent.BUKP.InitTimer = CurTime() + 0.0
                            ent.BUKP.BErrorsTimer = CurTime() + 3
                            ent.BUKP.State = 5
                            ent.BUKP.State2 = 0
                            ent.BUKP.Prost = true
                            ent.BUKP.Kos = true
                            ent.BUKP.Ovr = true
                            ent.CAMS.State = -1
                            ent.CAMS.StateTimer = CurTime() + 6
                            ent.VentTimer = -20
                        end)

                        if first then
                            timer.Simple(8, function()
                                if not IsValid(ent) then return end
                                ent.BUKP.InitTimer = CurTime() + 0.5
                                ent.BUKP.Reset = 1
                            end)
                        end
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
    },
}

for idx = 1, 4 do
    table.insert(ENT.Spawner.model, "models/metrostroi_train/81-765/headlights_" .. idx .. "_off.mdl")
end
