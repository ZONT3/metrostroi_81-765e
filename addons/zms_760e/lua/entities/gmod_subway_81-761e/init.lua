--------------------------------------------------------------------------------
-- 81-761Э «Чурá» by ZONT_ a.k.a. enabled person
-- Based on code by Cricket, Hell et al.
--------------------------------------------------------------------------------
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
ENT.BogeyDistance = 650
ENT.SyncTable = {"RearBrakeLineIsolation", "RearTrainLineIsolation", "FrontBrakeLineIsolation", "FrontTrainLineIsolation", "GV", "K31", "Battery", "PowerOn", "K23", "EmergencyBrakeValve",}

if not ENT.PvzToggles then print("ACHTUNG! PIZDEC!") end
for _, cfg in ipairs(ENT.PvzToggles or {}) do
    table.insert(ENT.SyncTable, cfg.relayName)
end

--------------------------------------------------------------------------------
function ENT:Initialize()
    -- Set model and initialize
    self:SetModel("models/metrostroi_train/81-760e/81_761e_body.mdl")
    self.BaseClass.Initialize(self)
    self:SetPos(self:GetPos() + Vector(0, 0, 140))
    -- Create bogeys
    self.FrontBogey = self:CreateBogey(Vector(338 - 20.8, 0, -70), Angle(0, 180, 0), true, "760") --z=-90
    self.RearBogey = self:CreateBogey(Vector(-338 + 20.8, 0, -70), Angle(0, 0, 0), false, "760")
    self.FrontBogey:SetNWBool("Async", true)
    self.RearBogey:SetNWBool("Async", true)
    self.FrontBogey:SetNWInt("MotorSoundType", 2)
    self.RearBogey:SetNWInt("MotorSoundType", 2)
    self.FrontBogey:SetNWFloat("SqualPitch", 0.75)
    self.RearBogey:SetNWFloat("SqualPitch", 0.75)
    self.FrontCouple = self:CreateCouple(Vector(437 - 20.8, 0, -68), Angle(0, 0, 0), true, "763")
    self.RearCouple = self:CreateCouple(Vector(-437 + 20.8, 0, -68), Angle(0, 180, 0), false, "763")
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

    self:SetNW2String("Texture", "MosBrend")
    self:SetNW2String("texture", "MosBrend")
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
            trigger:SetCollisionBounds(Vector(-doorTrigSize, -doorTrigSize, -doorTrigSize), Vector(doorTrigSize, doorTrigSize, doorTrigSize))
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
end

function ENT:Think()
    local retVal = self.BaseClass.Think(self)
    local Panel = self.Panel
    local power = self.Electric.BSPowered > 0
    self:SetPackedBool("WorkBeep", power)
    self:SetPackedBool("WorkFan", Panel.WorkFan > 0)
    local state = math.abs(self.AsyncInverter.InverterFrequency / (11 + self.AsyncInverter.State * 5))
    self:SetPackedRatio("asynccurrent", math.Clamp(state * (state + self.AsyncInverter.State / 1), 0, 1) * math.Clamp(self.Speed / 6, 0, 1))
    self:SetPackedRatio("asyncstate", math.Clamp(self.AsyncInverter.State / 0.2 * math.abs(self.AsyncInverter.Current) / 100, 0, 1))
    self:SetPackedRatio("chopper", math.Clamp(self.Electric.Chopper > 0 and self.Electric.Iexit / 100 or 0, 0, 1))
    self:SetPackedBool("CompressorWork", self.Pneumatic.Compressor and CurTime() - self.Pneumatic.Compressor > 0)
    for idx = 1, 8 do
        self:SetNW2Bool("DoorButtonLed" .. idx, self.Electric.BSPowered > 0 and self.BUD.OpenButton[idx] and true)
    end

    self:SetPackedBool("CouchCapR", self.CouchCapR)
    self:SetPackedBool("CouchCapL", self.CouchCapL)
    self:SetPackedBool("DoorK31", self.DoorK31)
    self:SetPackedRatio("LV", Panel.LV / 150)
    self:SetPackedRatio("HV", self.Electric.Main750V / 1000)
    self:SetPackedRatio("IVO", 0.5 + self.BUV.IVO / 150)
    local bogeyF, bogeyR = self.FrontBogey, self.RearBogey
    local fbValid, rbValid = IsValid(bogeyF), IsValid(bogeyR)
    for i = 1, 4 do
        self:SetPackedBool("TR" .. i, self.BUV.Pant or i <= 2 and fbValid and bogeyF.DisableContactsManual or i > 2 and rbValid and bogeyR.DisableContactsManual)
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
    self.AsyncInverter:TriggerInput("Speed", self.Speed)
    if fbValid and rbValid and not self.IgnoreEngine then
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

function ENT:FenceConnectable(other, headAcceptable)
    local compatible = other:GetClass():find("76") and other:GetClass()[19] == "e" or string.match(other:GetClass(), "76[567]")
    if headAcceptable then return compatible end
    local lit = other:GetClass()[18]
    return compatible and lit ~= "5" and lit ~= "0"
end

function ENT:CreateFence(other, front)
    local otherWag = other:GetNW2Entity("TrainEntity")
    local otherFront = other ~= otherWag.RearCouple
    local otherSide = otherFront and "FenceF" or "FenceR"
    local side = front and "FenceF" or "FenceR"
    if not (IsValid(otherWag) and IsValid(otherWag.RearCouple) and IsValid(otherWag.FrontCouple)) then return end
    if not IsValid(self[side]) and self:FenceConnectable(otherWag, not otherFront) then
        local k1 = front and -1 or 1
        local k2 = otherFront and -1 or 1
        local pos1, pos2 = self:GetPos(), otherWag:GetPos()
        local fwd1, fwd2 = -self:GetForward() * k1, -otherWag:GetForward() * k2
        local min, pos
        for i = 467, 495, 0.001 do
            local cpos = pos1 + fwd1 * i
            local dist = cpos:DistToSqr(pos2 + fwd2 * i)
            if not min or dist < min then
                min = dist
                pos = cpos
            elseif min then
                break
            end
        end

        if not pos then return end
        pos = self:WorldToLocal(pos)
        pos.y = 0 pos.z = 0
        pos = self:LocalToWorld(pos)

        local ent = ents.Create("prop_ragdoll")
        if not IsValid(ent) then return end
        ent:SetModel("models/metrostroi_train/81-760/81_760_fence_corrugated.mdl")
        ent:SetPos(pos)
        ent:SetAngles(self:GetAngles())
        ent:Spawn()
        ent:SetOwner(self)
        ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
        if CPPI and IsValid(self:CPPIGetOwner()) then ent:CPPISetOwner(self:CPPIGetOwner()) end
        ent:GetPhysicsObject():SetMass(1)
        table.insert(self.TrainEntities, ent)
        table.insert(otherWag.TrainEntities, ent)

        local bone1, bone2 = 0, 1
        local bonen1, bonen2 = ent:GetPhysicsObjectNum(bone1), ent:GetPhysicsObjectNum(bone2)
        bonen1:SetPos(otherWag:LocalToWorld(Vector(otherFront and 464.37 or -464.07, 0, 0)))
        bonen2:SetPos(self:LocalToWorld(Vector(front and 464.37 or -464.07, 0, 0)))
        bonen1:SetAngles(otherWag:LocalToWorldAngles(Angle(0, otherFront and 180 or 0, 90)))
        bonen2:SetAngles(self:LocalToWorldAngles(Angle(0, front and 180 or 0, -90)))
        constraint.Weld(ent, self, bone2, 0, 0, true)
        constraint.Weld(ent, otherWag, bone1, 0, 0, true)
        otherWag[otherSide] = ent
        self[side] = ent
    end
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

    self:CreateFence(train, isfront)

    self.BaseClass.OnCouple(self, train, isfront)
end

function ENT:OnDecouple(isfront)
    if isfront then
        self.FrontCoupledBogey = nil
    else
        self.RearCoupledBogey = nil
    end

    self:OnConnectDisconnect()
    if self.OnDecoupled then self:OnDecoupled() end

    local fence = isfront and self.FenceF or self.FenceR
    if IsValid(fence) then fence:Remove() end
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
