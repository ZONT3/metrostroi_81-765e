--------------------------------------------------------------------------------
-- 81-761Э «Чурá» by ZONT_ a.k.a. enabled person
--------------------------------------------------------------------------------
ENT.Type = "anim"
ENT.Base = "gmod_subway_base"  -- TODO Implement 765_base instead when (if) moving to metrostroi 2025+
ENT.PrintName = "81-766 MVM"
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

Metrostroi.ImportBase765(ENT)
ENT.IsIntermediate = true

function ENT:GetStandingArea()
    return Vector(-450, -30, -53), Vector(380, 30, -53)
end

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

---------------------------------------------------
-- Defined train information
-- Types of wagon(for wagon limit system):
-- 0 = Head or intherim
-- 1 = Only head
-- 2 = Only intherim
---------------------------------------------------
ENT.SubwayTrain = {
    Type = "81-765",
    Name = "81-766",
    WagType = 2,
    Manufacturer = "MVM",
    EKKType = 763,
}

ENT.NumberRanges = {{66001, 66999}}

ENT.ExportTable = "Impl766"
ENT.SharedFields = {
    "Version",
    "IkVersion",
    "PvzToggles",
    "AnnouncerPositions",
    "LeftDoorPositions",
    "RightDoorPositions",
    "LeftDoorPositionsBAK",
    "RightDoorPositionsBAK",
}

function Metrostroi.ImportImpl766(ent_tbl)
    for k, v in pairs(Metrostroi.Impl766 or {}) do
        ent_tbl[k] = istable(v) and table.Copy(v) or v
    end
end
