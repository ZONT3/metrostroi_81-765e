AddCSLuaFile()
ENT.Type = "anim"
ENT.PrintName = "81-761E PvVZ"
ENT.Author = ""
ENT.Contact = ""
ENT.Purpose = ""
ENT.Instructions = ""
ENT.Category = "Metrostroi (trains)"
ENT.SkinsType = "81-760e"
ENT.Model = "models/metrostroi_train/81-760e/81_761e_body.mdl"
ENT.NoTrain = false
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.DontAccelerateSimulation = false

ZMS.ImportBaseEnt("Impl766", "gmod_subway_81-766")
if CLIENT then
    if not ENT.ButtonMap then ErrorNoHaltWithStack("Failed to load 766 impl\n") else print("### 766 impl found") end
else
    if not ENT.SyncTable then ErrorNoHaltWithStack("Failed to load 766 impl\n") else print("### 766 impl found") end
end
ENT.IsIntermediate = true

--------------------------------------------------------------------------------
-- local BaseClass = baseclass.Get("gmod_subway_81-765")
ENT.Base = "gmod_subway_base"  -- TODO Implement 766_impl instead when (if) moving to metrostroi 2025+

function ENT:ResetSettings()
end

ENT.SubwayTrain = {
    Type = "81-760E",
    Name = "81-761E",
    WagType = 2,
    Manufacturer = "PvVZ",
    EKKType = 763,
}

ENT.NumberRanges = {{30501, 30993}}

if CLIENT then
    ENT.ClientProps["FenceR"] = {
        model = "models/metrostroi_train/81-760/81_760_fence_corrugated.mdl",
        pos = Vector(-464.07, 0, 0),
        ang = Angle(0, 0, 0),
        nohide = true,
    }
    ENT.ClientProps["FenceF"] = {
        model = "models/metrostroi_train/81-760/81_760_fence_corrugated.mdl",
        pos = Vector(464.37, 0, 0),
        ang = Angle(0, 0, 0),
        nohide = true,
    }
    Metrostroi.GenerateClientProps()
end
