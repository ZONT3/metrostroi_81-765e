--------------------------------------------------------------------------------
-- 81-761Э «Чурá» by ZONT_ a.k.a. enabled person
--------------------------------------------------------------------------------
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

-- local BaseClass = baseclass.Get("gmod_81-765_base")
-- ENT.Base = "gmod_subway_base"  -- TODO Implement 765_base instead when (if) moving to metrostroi 2025+

function ENT:Initialize(...)
    local BaseClass = scripted_ents.GetStored("gmod_81-765_base").t
    return BaseClass.Initialize(self, ...)
end

function ENT:Think(...)
    local BaseClass = scripted_ents.GetStored("gmod_81-765_base").t
    return BaseClass.Think(self, ...)
end

ENT:ExportFields(
    "SyncTable"
)

-- Nothing :D
-- see gmod_81-765_base
