AddCSLuaFile()
ENT.Type = "anim"
ENT.PrintName = "81-766E PvVZ"
ENT.Author = ""
ENT.Contact = ""
ENT.Purpose = ""
ENT.Instructions = ""
ENT.Category = "Metrostroi (trains)"
ENT.SkinsType = "81-765e"
ENT.Model = "models/metrostroi_train/81-765_v1/766/hull_p.mdl"
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

local function GetDoorPosition(i, k)
    return Vector(381 - 36.0 + 1 * k - 0.85 * (k == 1 and 1 or 0) - 230 * i, -66 * (1 - 2 * k), -1)
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

ENT.SubwayTrain = {
    Type = "81-760E",
    Name = "81-761E",
    WagType = 2,
    Manufacturer = "PvVZ",
    EKKType = 765,
}

ENT.NumberRanges = {{66501, 66993}}

if CLIENT then
    Metrostroi.GenerateClientProps()
end
