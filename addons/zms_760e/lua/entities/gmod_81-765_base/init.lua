--------------------------------------------------------------------------------
-- 81-760Э «Чурá» Base entity by ZONT_ a.k.a. enabled person
--------------------------------------------------------------------------------
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.BogeyDistance = 650
ENT.SyncTable = {
    "RearBrakeLineIsolation", "RearTrainLineIsolation", "FrontBrakeLineIsolation", "FrontTrainLineIsolation", "GV", "K31", "Battery", "PowerOn", "K23",
    "EmergencyBrakeValve",
}

if not ENT.PvzToggles then print("ACHTUNG! PIZDEC!") end
for _, cfg in ipairs(ENT.PvzToggles or {}) do
    table.insert(ENT.SyncTable, cfg.relayName)
end

for idx = 1, 8 do
    table.insert(ENT.SyncTable, "DoorManualBlock" .. idx)
end

--------------------------------------------------------------------------------
DEFINE_BASECLASS("gmod_subway_base")

function ENT:Initialize()
    -- Set model and initialize
    self:SetModel(self.IsIntermediate and "models/metrostroi_train/81-760e/81_761e_body.mdl" or "models/metrostroi_train/81-760e/81_760e_body.mdl")
    BaseClass.Initialize(self)
    self:SetPos(self:GetPos() + Vector(0, 0, 140))

    -- Create bogeys
    self.FrontBogey = self:CreateBogey(Vector(self.IsTrailer and (338 - 20.8) or (297 + 20.8), 0, -70), Angle(0, 180, 0), true, self.IsTrailer and "763" or self.IsIntermediate and "760" or "760F")
    self.RearBogey = self:CreateBogey(Vector(-338 + 20.8, 0, -70), Angle(0, 0, 0), false, self.IsTrailer and "763" or "760")
    self.FrontBogey:SetNWBool("Async", true)
    self.RearBogey:SetNWBool("Async", true)
    self.FrontBogey:SetNWFloat("SqualPitch", 0.75)
    self.RearBogey:SetNWFloat("SqualPitch", 0.75)

    if not self.IsTrailer then
        self.FrontBogey:SetNWInt("MotorSoundType", Metrostroi.Version > 1537278077 and 3 or 2)
        self.RearBogey:SetNWInt("MotorSoundType", Metrostroi.Version > 1537278077 and 3 or 2)
    else
        self.FrontBogey:SetNWBool("DisableEngines", true)
        self.RearBogey:SetNWBool("DisableEngines", true)
        self.FrontBogey.DisableSound = 1
        self.RearBogey.DisableSound = 1
    end

    self.FrontCouple = self:CreateCouple(self.IsIntermediate and Vector(437 - 20.8, 0, -68) or Vector(442.2 + 30, 0, -68), Angle(0, 0, 0), true, self.IsIntermediate and "763" or "722")
    self.RearCouple = self:CreateCouple(self.IsIntermediate and Vector(-437 + 20.8, 0, -68) or Vector(-439 + 20.8, 0, -68), Angle(0, 180, 0), false, "763")
    self:SetNW2Entity("FrontBogey", self.FrontBogey)
    self:SetNW2Entity("RearBogey", self.RearBogey)
    self:SetNW2Entity("FrontCouple", self.FrontCouple)
    self:SetNW2Entity("RearCouple", self.RearCouple)

    self.KeyMap = {
        [KEY_F] = "PneumaticBrakeUp",
        [KEY_R] = "PneumaticBrakeDown",
        [KEY_PAD_1] = "PneumaticBrakeSet1",
        [KEY_PAD_2] = "PneumaticBrakeSet2",
        [KEY_PAD_3] = "PneumaticBrakeSet3",
        [KEY_PAD_4] = "PneumaticBrakeSet4",
        [KEY_PAD_5] = "PneumaticBrakeSet5",
        [KEY_PAD_6] = "PneumaticBrakeSet6",
        [KEY_PAD_7] = "PneumaticBrakeSet7",
    }

    self.LeftDoorPositions = self.LeftDoorPositionsBAK
    self.RightDoorPositions = self.RightDoorPositionsBAK

    -- Cross connections in train wires
    self.TrainWireCrossConnections = {
        [4] = 3, -- Orientation F<->B
        [13] = 12, -- Reverser F<->B
        [38] = 37, -- Doors L<->R
    }

    self.Lights = {
        [11] = {
            "dynamiclight",
            Vector(285, 0, 10),
            Angle(0, 0, 0),
            Color(230, 230, 255),
            brightness = 2,
            distance = 650,
            fov = 180,
            farz = 128
        },
        [12] = {
            "dynamiclight",
            Vector(-5, 0, 10),
            Angle(0, 0, 0),
            Color(230, 230, 255),
            brightness = 2,
            distance = 650,
            fov = 180,
            farz = 128
        },
        [13] = {
            "dynamiclight",
            Vector(-295, 0, 10),
            Angle(0, 0, 0),
            Color(230, 230, 255),
            brightness = 2,
            distance = 650,
            fov = 180,
            farz = 128
        },
    }

    self.CouchCapL = false
    self.CouchCapR = false
    self.DoorK31 = false
    self.InteractionZones = self.InteractionZones or {}
    for k, tbl in ipairs({self.LeftDoorPositions or {}, self.RightDoorPositions or {}}) do
        for i, pos in ipairs(tbl) do
            local idx = (k - 1) * 4 + i
            table.insert(self.InteractionZones, {
                Pos = pos,
                Radius = 48,
                ID = "SalonDoor" .. idx
            })
        end
    end

    if self.IsTrailer then
        self.NormalMass = 19000
    end

    self:CreateDoorTriggers()
    self:TrainSpawnerUpdate()
end

local doorTrigSize = 5
function ENT:CreateDoorTriggers()
    for k, tbl in ipairs({self.LeftDoorPositions or {}, self.RightDoorPositions or {}}) do
        for i, pos in ipairs(tbl) do
            local idx = (k - 1) * 4 + i
            local trigger = ents.Create("base_entity")
            trigger:SetPos(self:LocalToWorld(pos))
            trigger:SetAngles(self:GetAngles())
            trigger:SetParent(self)
            trigger:Spawn()
            trigger:SetModel("models/hunter/blocks/cube05x05x05.mdl")
            trigger:SetNoDraw(true)
            trigger:SetNotSolid(true)
            trigger:SetCollisionBounds(
                Vector(-doorTrigSize, -doorTrigSize, -doorTrigSize),
                Vector(doorTrigSize, doorTrigSize, doorTrigSize)
            )
            trigger:SetSolid(SOLID_BBOX)
            trigger:SetTrigger(true)
            trigger:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
            trigger:AddEFlags(EFL_SERVER_ONLY)

            trigger.count = 0
            trigger.entMap = {}
            trigger.StartTouch = function(this, ent)
                if IsValid(self) and IsValid(ent) and ent:IsPlayer() then
                    this.count = this.count + 1
                    this.entMap[ent] = true
                    self.BUD.ForeignObject[idx] = this.count > 0
                end
            end
            trigger.EndTouch = function(this, ent)
                if this.entMap[ent] then
                    this.count = this.count - 1
                    this.entMap[ent] = nil
                    self.BUD.ForeignObject[idx] = this.count > 0
                end
            end
            table.insert(self.TrainEntities, trigger)
        end
    end
end

function ENT:TrainSpawnerUpdate()
    if self.InitializeSounds then
        self:InitializeSounds()
    end
    if self.ResetSettings then
        self:ResetSettings()
    end

    self:SetNW2Int("BNT:ScreenFps", self:GetNW2Int("BntFps", 2) == 2 and 60 or 15)
    self:UpdateTextures()
end

function ENT:ResetSettings()
    local cikType = self:GetNW2Int("CikType", 1)
    self:SetNW2Int("CikColor", cikType)
    self:SetNW2Int("BntFps", cikType == 2 and 2 or 1)
    self:SetNW2Int("BuikType", cikType == 2 and 3 or 1)
    self:SetNW2Bool("SarmatBeep", cikType == 2)

    local val = self:GetNW2String("BLIK:Logo", "")
    local cfg = Metrostroi.Skins and Metrostroi.Skins["765logo"]
    local red = val .. "R"
    if cikType == 2 and cfg and cfg[red] then
        self:SetNW2String("BLIK:Logo", red)
    end

    self:SetNW2Int("VVVFSound", 8)
    self:SetNW2Int("HornType", 5)
    self:SetNW2Int("KvType", 3)
    self:SetNW2Bool("BtbuSd", true)
    self:SetNW2Bool("SingleRing", true)
end

function ENT:Think()
    local retVal = BaseClass.Think(self)
    local Panel = self.Panel
    local power = self.Electric.BSPowered > 0
    self:SetPackedBool("WorkBeep", power)
    self:SetPackedBool("WorkFan", (Panel.WorkFan or 0) > 0)

    for idx = 1, 8 do
        self:SetNW2Bool("DoorButtonLed" .. idx, self.Electric.BSPowered > 0 and self.BUD.OpenButton[idx] and true)
    end

    if not self.IsTrailer then
        local state = math.abs(self.AsyncInverter.InverterFrequency / (11 + self.AsyncInverter.State * 5))
        self:SetPackedRatio("asynccurrent", math.Clamp(state * (state + self.AsyncInverter.State / 1), 0, 1) * math.Clamp(self.Speed / 6, 0, 1))
        self:SetPackedRatio("asyncstate", math.Clamp(self.AsyncInverter.State / 0.2 * math.abs(self.AsyncInverter.Current) / 100, 0, 1))
        self:SetPackedRatio("chopper", math.Clamp(self.Electric.Chopper > 0 and self.Electric.Iexit / 100 or 0, 0, 1))
        self:SetPackedBool("CompressorWork", self.Pneumatic.Compressor and CurTime() - self.Pneumatic.Compressor > 0)

        self:SetPackedRatio("IVO", 0.5 + self.BUV.IVO / 150)
    end

    self:SetPackedBool("CouchCapR", self.CouchCapR)
    self:SetPackedBool("CouchCapL", self.CouchCapL)
    self:SetPackedBool("DoorK31", self.DoorK31)

    self:SetPackedRatio("LV", Panel.LV / 150)
    if self.IsIntermediate then
        self:SetPackedRatio("HV", self.Electric.Main750V / 1000)
    else
        self:SetPackedRatio("HV", (self.SF42F2.Value * self.Electric.BSPowered > 0.5 and self.Electric.Main750V or 0) / 1000)
    end

    local passlight = Panel.SalonLighting1 * 0.25 + Panel.SalonLighting2 * 0.75
    local passl = passlight > 0
    self:SetLightPower(11, passl, passlight)
    self:SetLightPower(12, passl, passlight)
    self:SetLightPower(13, passl, passlight)
    self:SetPackedBool("SalonLighting1", Panel.SalonLighting1 > 0)
    self:SetPackedBool("SalonLighting2", Panel.SalonLighting2 > 0)
    self:SetPackedBool("AnnPlay", power)
    self:SetPackedRatio("BL", self.Pneumatic.BrakeLinePressure / 16.0)
    self:SetPackedRatio("TL", self.Pneumatic.TrainLinePressure / 16.0)
    self:SetPackedRatio("BC", math.min(3.8, self.Pneumatic.BrakeCylinderPressure) / 6.0)

    local bogeyF, bogeyR = self.FrontBogey, self.RearBogey
    local fbValid, rbValid = IsValid(bogeyF), IsValid(bogeyR)
    for i = 1, 4 do
        self:SetPackedBool("TR" .. i, self.BUV.Pant or i <= 2 and fbValid and bogeyF.DisableContactsManual or i > 2 and rbValid and bogeyR.DisableContactsManual)
    end
    for i = 1, 8 do
        if i == 1 or i == 4 or i == 5 or i == 8 then
            self:SetPackedBool("BC" .. i, math.max(self.Pneumatic.BrakeCylinderPressure, (i < 5 and (fbValid and bogeyF.DisableParking and 0 or 1) or i > 4 and (rbValid and bogeyR.DisableParking and 0 or 1)) * (3.8 - self.Pneumatic.ParkingBrakePressure) / 2) <= 0.1)
            self:SetPackedRatio("DPBTPressure" .. i, math.max(self.Pneumatic.BrakeCylinderPressure, (i < 5 and (fbValid and bogeyF.DisableParking and 0 or 1) or i > 4 and (rbValid and bogeyR.DisableParking and 0 or 1)) * (3.8 - self.Pneumatic.ParkingBrakePressure) / 2))
        else
            self:SetPackedBool("BC" .. i, self.Pneumatic.BrakeCylinderPressure <= 0.1)
            self:SetPackedRatio("DPBTPressure" .. i, self.Pneumatic.BrakeCylinderPressure)
        end
    end

    if self.FrontTrain ~= self.PrevFrontTrain then
        self:SetNW2Entity("FrontTrain", self.FrontTrain)
        self.PrevFrontTrain = self.FrontTrain
    end

    if self.RearTrain ~= self.PrevRearTrain then
        self:SetNW2Entity("RearTrain", self.RearTrain)
        self.PrevRearTrain = self.RearTrain
    end

    self:SetPackedRatio("Speed", self.Speed)

    if not self.IsTrailer then
        self.AsyncInverter:TriggerInput("Speed", self.Speed)
    end

    if fbValid and rbValid and not self.IgnoreEngine then
        if not self.IsTrailer then
            local A = self.AsyncInverter.Torque
            local add = 1
            if math.abs(self:GetAngles().pitch) > 4 then add = math.min((math.abs(self:GetAngles().pitch) - 4) / 2, 1) end
            bogeyF.MotorForce = (40000 + 5000 * (A < 0 and 1 or 0)) * add
            bogeyF.Reversed = self.BUV.Reverser < 0.5 --<
            bogeyR.MotorForce = (40000 + 5000 * (A < 0 and 1 or 0)) * add
            bogeyR.Reversed = self.BUV.Reverser > 0.5 -->

            -- These corrections are required to beat source engine friction at very low values of motor power
            local P = math.max(0, 0.04449 + 1.06879 * math.abs(A) - 0.465729 * A ^ 2)
            if math.abs(A) > 0.4 then P = math.abs(A) end
            if math.abs(A) < 0.05 then P = 0 end
            if self.Speed < 10 then P = P * (1.0 + 0.6 * (10.0 - self.Speed) / 10.0) end
            bogeyR.MotorPower = P * 0.5 * ((A > 0) and 1 or -1)
            bogeyF.MotorPower = P * 0.5 * ((A > 0) and 1 or -1)
        end

        bogeyF.PneumaticBrakeForce = 50000.0
        bogeyF.BrakeCylinderPressure = self.Pneumatic.BrakeCylinderPressure
        bogeyF.ParkingBrakePressure = math.max(0, 3.8 - self.Pneumatic.ParkingBrakePressure) / 2
        bogeyF.BrakeCylinderPressure_dPdT = -self.Pneumatic.BrakeCylinderPressure_dPdT
        bogeyF.DisableContacts = self.BUV.Pant
        bogeyR.PneumaticBrakeForce = 50000.0
        bogeyR.BrakeCylinderPressure = self.Pneumatic.BrakeCylinderPressure
        bogeyR.ParkingBrakePressure = math.max(0, 3.8 - self.Pneumatic.ParkingBrakePressure) / 2
        bogeyR.BrakeCylinderPressure_dPdT = -self.Pneumatic.BrakeCylinderPressure_dPdT
        bogeyR.DisableContacts = self.BUV.Pant
    end
    return retVal
end

function ENT:OnCouple(train, isfront)
    if isfront and self.FrontAutoCouple then
        self.FrontBrakeLineIsolation:TriggerInput("Open", 1.0)
        self.FrontTrainLineIsolation:TriggerInput("Open", 1.0)
        self.FrontAutoCouple = false
    elseif not isfront and self.RearAutoCouple then
        self.RearBrakeLineIsolation:TriggerInput("Open", 1.0)
        self.RearTrainLineIsolation:TriggerInput("Open", 1.0)
        self.RearAutoCouple = false
    end

    BaseClass.OnCouple(self, train, isfront)
end

function ENT:OnDecouple(isfront)
    if isfront then
        self.FrontCoupledBogey = nil
    else
        self.RearCoupledBogey = nil
    end

    self:OnConnectDisconnect()
    if self.OnDecoupled then self:OnDecoupled() end
end

function ENT:OnButtonPress(button, ply)
    if string.find(button, "PneumaticBrakeSet") then
        self.Pneumatic:TriggerInput("BrakeSet", tonumber(button:sub(-1, -1)))
        return
    end

    if button == "CouchCapL" then self.CouchCapL = not self.CouchCapL end
    if button == "CouchCapR" then self.CouchCapR = not self.CouchCapR end
    if button == "K31Cap" then self.DoorK31 = not self.DoorK31 end
    if string.StartsWith(button, "SalonDoor") then
        local idx = tonumber(string.sub(button, 10))
        if idx and IsValid(ply) and self.BUD then self.BUD:OpenDoorMenu(ply, idx) end
    end
end

function ENT:OnButtonRelease(button, ply)
    if button == "PneumaticBrakeSet1" then
        self.Pneumatic:TriggerInput("BrakeSet", 2)
        return
    end
end

ENT:ExportFields(
    "SyncTable"
)
