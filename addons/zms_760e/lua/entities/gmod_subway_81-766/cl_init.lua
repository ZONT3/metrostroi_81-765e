--------------------------------------------------------------------------------
-- 81-761Э «Чурá» by ZONT_ a.k.a. enabled person
--------------------------------------------------------------------------------
include("shared.lua")

local BaseClass = baseclass.Get("gmod_81-765_base")
ENT.Base = "gmod_subway_base"  -- TODO Implement 765_base instead when (if) moving to metrostroi 2025+

if not ENT.ButtonMap.RearPneumatic then ErrorNoHaltWithStack("BaseClass not initialized!\n") end

ENT.AutoAnims = {}
ENT.ClientPropsInitialized = false

table.insert(ENT.ClientProps, {
    model = "models/metrostroi_train/81-760/81_761_underwagon.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hide = 2,
})

ENT.ClientProps["KtiFan"] = {
    model = "models/metrostroi_train/81-760/81_760_fan_kti.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hide = 1,
}

ENT.ClientProps["RFan"] = {
    model = "models/metrostroi_train/81-760/81_760_fan_r.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hide = 1,
}

ENT.ClientProps["BoxIntL"] = {
    model = "models/metrostroi_train/81-760/81_761a_box_int_l.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    hide = 2,
}

ENT.ClientProps["VmBs"] = {
    model = "models/metrostroi_train/81-760/81_760_arrow_electric.mdl",
    pos = Vector(448.42, 45.092, -12.94),
    ang = Angle(0, -90, 0),
    hide = 0.2,
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

function ENT:Initialize(...)
    return BaseClass.Initialize(self, ...)
end

function ENT:Think(...)
    return BaseClass.Think(self, ...)
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

ENT:ExportFields(
    "ClientProps",
    "ButtonMap",
    "ClientSounds",
    "AutoAnims",
    "ClientPropsInitialized",
    "Lights"
)

Metrostroi.GenerateClientProps()

-- see gmod_81-765_base
