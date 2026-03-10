--------------------------------------------------------------------------------
-- 81-763Э «Чурá» by ZONT_ a.k.a. enabled person
--------------------------------------------------------------------------------
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local BaseClass = baseclass.Get("gmod_81-765_base")
ENT.Base = "gmod_subway_base"  -- TODO Implement 765_base instead when (if) moving to metrostroi 2025+

function ENT:Initialize(...)
    return BaseClass.Initialize(self, ...)
end

function ENT:Think(...)
    return BaseClass.Think(self, ...)
end

-- Nothing :D
-- see gmod_81-765_base
