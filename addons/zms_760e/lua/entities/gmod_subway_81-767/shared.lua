--------------------------------------------------------------------------------
-- 81-763Э «Чурá» by ZONT_ a.k.a. enabled person
--------------------------------------------------------------------------------
ENT.Type = "anim"
ENT.Base = "gmod_subway_base"  -- TODO Implement 765_base instead when (if) moving to metrostroi 2025+
ENT.PrintName = "81-767 MVM"
ENT.Author = ""
ENT.Contact = ""
ENT.Purpose = ""
ENT.Instructions = ""
ENT.Category = "Metrostroi (trains)"
ENT.SkinsType = "81-765"
ENT.Model = "models/metrostroi_train/81-765/766_hull.mdl"
ENT.NoTrain = false
ENT.Spawnable = true
ENT.AdminSpawnable = false

ZMS.ImportBaseEnt("Base765", "gmod_81-765_base")
ENT.IsIntermediate = true
ENT.IsTrailer = true

function ENT:GetStandingArea()
    return Vector(-450, -30, -53), Vector(380, 30, -53)
end

function ENT:InitializeSystems()
    self:LoadSystem("TR", "TR_3B")
    self:LoadSystem("Electric", "81_765_Electric")
    self:LoadSystem("BUV", "81_760E_BUV")
    self:LoadSystem("BUD", "81_765_BUD")
    self:LoadSystem("Pneumatic", "81_763E_Pneumatic")
    self:LoadSystem("Panel", "81_761E_Panel")
    self:LoadSystem("IK", "81_765_IK")
    self:LoadSystem("BNT", "81_765_BNT")
end

---------------------------------------------------
-- Defined train information
-- Types of wagon(for wagon limit system):
-- 0 = Head or intherim
-- 1 = Only head
-- 2 = Only intherim
---------------------------------------------------
ENT.SubwayTrain = {
    Type = "81-765",
    Name = "81-767",
    WagType = 2,
    Manufacturer = "MVM",
    EKKType = 765,
}

ENT.NumberRanges = {{67001, 67996}}


ENT.ExportTable = "Impl767"
ENT.SharedFields = {
    "Version",
    "IkVersion",
    "PvzToggles",
    "AnnouncerPositions",
    "LeftDoorPositions",
    "RightDoorPositions",
    "LeftDoorPositionsBAK",
    "RightDoorPositionsBAK",
    "ZmsKpCheck",
}
