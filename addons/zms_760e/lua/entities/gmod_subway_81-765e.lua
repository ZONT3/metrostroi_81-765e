AddCSLuaFile()
ENT.Type = "anim"
ENT.PrintName = "81-760E PvVZ"
ENT.Author = ""
ENT.Contact = ""
ENT.Purpose = ""
ENT.Instructions = ""
ENT.Category = "Metrostroi (trains)"
ENT.SkinsType = "81-760e"
ENT.Model = "models/metrostroi_train/81-760e/81_760e_body.mdl"
ENT.NoTrain = false
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.DontAccelerateSimulation = false

ZMS.ImportBaseEnt("Impl765", "gmod_subway_81-765")
if CLIENT then
    if not ENT.ButtonMap then ErrorNoHaltWithStack("Failed to load 765 impl\n") else print("### 765 impl found") end
else
    if not ENT.SyncTable then ErrorNoHaltWithStack("Failed to load 765 impl\n") else print("### 765 impl found") end
end

--------------------------------------------------------------------------------
-- local BaseClass = baseclass.Get("gmod_subway_81-765")
ENT.Base = "gmod_subway_base"  -- TODO Implement 765_impl instead when (if) moving to metrostroi 2025+

function ENT:ResetSettings()
end

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

ENT.Spawner = ENT.SpawnerCustom

if CLIENT then
    Metrostroi.GenerateClientProps()
end
