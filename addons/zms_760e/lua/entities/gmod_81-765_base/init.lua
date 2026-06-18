--------------------------------------------------------------------------------
-- 81-760Э «Чурá» Base entity by ZONT_ a.k.a. enabled person
--------------------------------------------------------------------------------
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.BogeyDistance = 660
ENT.SyncTable = {
    "RearBrakeLineIsolation", "RearTrainLineIsolation", "FrontBrakeLineIsolation", "FrontTrainLineIsolation", "GV", "K31", "K23",
    "EmergencyBrakeValve", "CoupleCenteringR", "CoupleCenteringF", "PowerOn", "PowerOff"
}

if not ENT.PvzToggles then print("ACHTUNG! PIZDEC!") end
for _, cfg in ipairs(ENT.PvzToggles or {}) do
    table.insert(ENT.SyncTable, cfg.relayName)
end

for idx = 1, 8 do
    table.insert(ENT.SyncTable, "DoorManualBlock" .. idx)
end

--------------------------------------------------------------------------------

function ENT:Initialize()
    -- Set model and initialize
    self:SetModel(self.Model)
    local BaseClass = scripted_ents.GetStored("gmod_subway_base").t
    BaseClass.Initialize(self)
    self:SetPos(self:GetPos() + Vector(0, 0, 140))

    -- Create bogeys
    self.FrontBogey = self:CreateBogey(Vector(self.IsTrailer and 317.2 or 327, 0, -70), Angle(0, 180, 0), true, self.IsTrailer and "763" or self.IsIntermediate and "760" or "760F")
    self.RearBogey = self:CreateBogey(Vector(-317.2, 0, -70), Angle(0, 0, 0), false, self.IsTrailer and "763" or "760")
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

    self.FrontCouple = self:CreateCouple(self.IsIntermediate and Vector(427.1, 0, -69) or Vector(475.4, 0, -68), Angle(0, 0, 0), true, self.IsIntermediate and "765DC" or "722")
    self.RearCouple = self:CreateCouple(Vector(-433.5, 0, -69), Angle(0, 180, 0), false, "765DC")
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
                if IsValid(self) and IsValid(ent) and (ent:IsPlayer() or ent:IsNPC() or ent:IsNextBot()) then
                    this.count = this.count + 1
                    this.entMap[ent] = true
                    self.BUD.ForeignObject[idx] = true
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


-- Центровка автоцепок. Я ебал его рот. Блять. Каждый раз, когда я меняю constraint-ы, все идет по пизде.
-- А центровка нужна, т.к. на 81-765 сцепки центрируются, чтоб их не мотало из стороны в сторону.
-- И без этой фичи вагон выглядит упорото.

-- Закомменченный код здесь и в следующих трех методах - это все мои попытки победить ебанутую физику.
-- То сцепка будет прыгать по приколу сама, то из-за нее игрок в кабине постоянно едет куда-то,
-- То сцепленный вагон дрожит и толкается. И во всех этих случаях - сама сцепка дрожит и хаотично дергается.
-- Ни один вариант из разных комбинаций закомменченого кода не помог.

-- В итоге нащупал, что лишний раз вкл/выкл NoCollide все может исправить, и то - приходится полагаться на таймеры =)
-- Ибо за один фрейм ничего не фиксится, и даже за несколько. Приходится ждать какое-то время, которое хуй знает от чего зависит...

-- function ENT:RemoveBallsockets(couple)
--     print(constraint.RemoveConstraints(couple, "AdvBallsocket"))
--     -- local tbl = constraint.FindConstraints(couple, "AdvBallsocket")
--     -- for _, v in ipairs(tbl) do
--     --     if v.Ent1 == self and v.Ent2 == couple then
--     --         v.Constraint:Remove()
--     --     end
--     -- end
-- end

-- Убрать центровку
-- Да, изначально это были пружины. Но физике с ними совсем пизда.
function ENT:RemoveSprings(isfront, coupling)
    local couple = isfront and self.FrontCouple or self.RearCouple
    if not IsValid(couple) or not couple.Centered then return end
    -- print("remove", couple)
    -- constraint.RemoveAll(couple)
    -- self:RemoveBallsockets(couple)
    couple.Centered:Remove()
    constraint.RemoveConstraints(couple, "NoCollide")
    if not coupling then
        couple:SetPos(self:LocalToWorld(couple.SpawnPos))
        couple:SetAngles(self:GetAngles() + couple.SpawnAng)
    end
    constraint.AdvBallsocket(self, couple, 0, 0, couple.SpawnPos, Vector(0, 0, 0), 1, 1, -2, -2, -15, 2, 2, 15, 0.1, 0.1, 1)  -- Вырубить NoCollide флаг здесь - ОБЯЗАТЕЛЬНО.
    constraint.NoCollide(isfront and self.FrontBogey or self.RearBogey, couple, 0, 0)
    constraint.NoCollide(self, couple, 0, 0)  -- Но потом обратно его присрать отдельным constraint-ом
    -- if IsValid(coupling) then
    --     constraint.Weld(self, coupling, 0, 0, 0)
    -- end
    couple.Centered = false
    -- local phy = couple:GetPhysicsObject()
    -- if not IsValid(phy) then return end
    -- phy:SetMass(couple.OriginalMass or 5000)
end

-- Поставить центровку
function ENT:SetSprings(isfront, force)
    if not self:GetNW2Bool("CoupleSprings", false) then self:RemoveSprings(isfront) return end
    if isfront and self.CoupleCenteringF.Value > 0 or not isfront and self.CoupleCenteringR.Value > 0 then return end
    if isfront and self.FrontCoupledBogey or not isfront and self.RearCoupledBogey then return end
    local couple = isfront and self.FrontCouple or self.RearCouple
    if not IsValid(couple) or not force and couple.Centered then return end
    -- print("set", couple)
    -- local phy = couple:GetPhysicsObject()
    -- if not IsValid(phy) then return end
    -- phy:EnableMotion(false)
    -- local bs = constraint.Find(self, couple, "AdvBallsocket", 0, 0)
    -- if IsValid(bs) then bs:Remove() print("rm bs") end
    -- self:RemoveBallsockets(couple)
    constraint.RemoveAll(couple)
    couple:SetPos(self:LocalToWorld(couple.SpawnPos))
    couple:SetAngles(self:GetAngles() + couple.SpawnAng)
    -- couple.Centered = constraint.AdvBallsocket(self, couple, 0, 0, couple.SpawnPos, Vector(0, 0, 0), 1, 1, -2, -2, -0.6, 2, 2, 0.6, 0.1, 0.1, 1)
    couple.Centered = constraint.Weld(self, couple, 0, 0)  -- Вырубить NoCollide флаг здесь тоже - ОБЯЗАТЕЛЬНО.
    constraint.NoCollide(isfront and self.FrontBogey or self.RearBogey, couple, 0, 0)
    constraint.NoCollide(self, couple, 0, 0)
    -- couple.OriginalMass = phy:GetMass()
    -- phy:SetMass(0)  -- Вот это было неплохим вариантом, все становилось заебись, кроме... Блять естественно, веса сцепки =) Из-за чего она себя по-веселому ведет при ЛЮБЫХ коллизиях.
    -- timer.Create("765.CouplePhysRestore." .. couple:EntIndex(), 0.2, 1, function()
    --     if not IsValid(phy) then return end
    --     phy:EnableMotion(true)
    --     print("restored")
    -- end)
end

function ENT:TrainSpawnerUpdate()
    if self.ResetSettings then
        self:ResetSettings()
    end

    if not self.IsIntermediate and self:GetNW2Bool("CoupleSprings", false) then

        -- Да, блять...
        -- Физика перестает быть джокером только после этого.
        -- У кого есть другое решение - я молю блять, расскажите.

        -- Вот для первого раза достаточно одного фрейма. Но не меньше. Т.е. если мы это сделаем на том же фрейме, на котором заспавнился вагон - хуй.
        timer.Simple(0, function()
            if not IsValid(self) then return end
            self:SetSprings(true, true)

            -- А вот второй раз.
            -- Почему именно три секунды? Я не ебу. Один фрейм - не помогает, два - тоже. А хуй знает сколько - ДА.
            timer.Simple(3, function()
                if not IsValid(self) then return end
                self:RemoveSprings(true)
                self:SetSprings(true, true)
            end)
        end)

        -- Трахаться с физикой еще и задней сцепки я не собираюсь.
        -- Центрируем только переднюю головного вагона.
        -- В любом случае, на 765 остальные сцепки - это БЗС.
        -- self:SetSprings(false)
    end

    for _, k in ipairs({"Horn", "ElectricHorn"}) do
        local hornType = self:GetNW2Int(k .. "Type", 0)
        if hornType == 2 then hornType = math.random(3, 5) end
        if hornType >= 3 and hornType < 6 then
            self:SetNW2String(k .. "Snd", "horn" .. (hornType - 2))
        else
            self:SetNW2String(k .. "Snd", "horn")
        end
    end

    local kvType = self:GetNW2Int("KvType", 1)
    if kvType == 1 then kvType = math.random(2) else kvType = kvType - 1 end
    self.KvSnd = kvType == 1 and "KV1_" or "KV2_"

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
    local BaseClass = scripted_ents.GetStored("gmod_subway_base").t
    local retVal = BaseClass.Think(self)
    local Panel = self.Panel
    local power = self.Electric.KM > 0
    self:SetPackedBool("WorkBeep", power)
    self:SetPackedBool("WorkFan", (Panel.WorkFan or 0) > 0)

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
        self:SetPackedRatio("HV", (self.SF42F2.Value * self.Electric.KM > 0.5 and self.Electric.Main750V or 0) / 1000)
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

    self:SetNW2Bool("FrontCoupled", self:GetNW2Bool("CoupleSprings", false) and self.FrontCoupledBogey ~= nil)
    self:SetNW2Bool("RearCoupled", true--[[self:GetNW2Bool("CoupleSprings", false) and self.RearCoupledBogey ~= nil]])
    if not self.IsIntermediate then
        if self.FrontCoupledBogey and self.CoupleCenteringF.Value > 0 then
            self.CoupleCenteringF:TriggerInput("Set", 0)
        end
        if self.CoupleCenteringF.Value > 0 and self.FrontCouple.Centered then
            self:RemoveSprings(true)
        end
        if not self.FrontCoupledBogey and self.CoupleCenteringF.Value == 0 and not self.FrontCouple.Centered and self:GetNW2Bool("CoupleSprings", false) then
            self:SetSprings(true)
        end
        -- if self.RearCoupledBogey and self.CoupleCenteringR.Value > 0 then
        --     self.CoupleCenteringR:TriggerInput("Set", 0)
        -- end
        -- if self.CoupleCenteringR.Value > 0 and self.RearCouple.Centered then
        --     self:RemoveSprings(false)
        -- end
        -- if not self.RearCoupledBogey and self.CoupleCenteringR.Value == 0 and not self.RearCouple.Centered and self:GetNW2Bool("CoupleSprings", false) then
        --     self:SetSprings(false)
        -- end
    end

    self:SetNW2Bool("LvCritical", self.Electric.Emer80V < 54.8)

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

        local bc = self.Pneumatic.BrakeCylinderPressure
        local wheelsF = bogeyF:GetNW2Entity("TrainWheels")
        local wheelsR = bogeyR:GetNW2Entity("TrainWheels")

        -- Increasing brake force at around 1.18 kgf/cm2 of BC
        local x = (1.5 - bc + self.Pneumatic.WeightLoadRatio * 0.8) / bc
        local auxF = (x < 0 or x > 1) and 0 or (
            1 / (1 + math.exp(-40 * (x - 0.173))) -
            1 / (1 + math.exp(-35 * (x - 0.24)))
        )
        bogeyF.PneumaticBrakeForce = 50000.0 + auxF * 13000
        bogeyF.BrakeCylinderPressure = bc
        bogeyF.ParkingBrakePressure = math.max(IsValid(wheelsF) and wheelsF:GetNW2Bool("Disabled", false) and 2.8 or 0, 3.8 - self.Pneumatic.ParkingBrakePressure) / 2
        bogeyF.BrakeCylinderPressure_dPdT = -self.Pneumatic.BrakeCylinderPressure_dPdT
        bogeyF.DisableContacts = self.BUV.Pant
        bogeyR.PneumaticBrakeForce = 50000.0 + auxF * 13000
        bogeyR.BrakeCylinderPressure = bc
        bogeyR.ParkingBrakePressure = math.max(IsValid(wheelsR) and wheelsR:GetNW2Bool("Disabled", false) and 2.8 or 0, 3.8 - self.Pneumatic.ParkingBrakePressure) / 2
        bogeyR.BrakeCylinderPressure_dPdT = -self.Pneumatic.BrakeCylinderPressure_dPdT
        bogeyR.DisableContacts = self.BUV.Pant
    end
    return retVal
end

function ENT:OnCouple(couple, isfront)
    if isfront and self.FrontAutoCouple then
        self.FrontBrakeLineIsolation:TriggerInput("Open", 1.0)
        self.FrontTrainLineIsolation:TriggerInput("Open", 1.0)
        self.FrontAutoCouple = false
    elseif not isfront and self.RearAutoCouple then
        self.RearBrakeLineIsolation:TriggerInput("Open", 1.0)
        self.RearTrainLineIsolation:TriggerInput("Open", 1.0)
        self.RearAutoCouple = false
    end

    local BaseClass = scripted_ents.GetStored("gmod_subway_base").t
    BaseClass.OnCouple(self, couple, isfront)

    self:RemoveSprings(isfront, couple)
end

function ENT:OnDecouple(isfront)
    if isfront then
        self.FrontCoupledBogey = nil
    else
        self.RearCoupledBogey = nil
    end

    self:SetSprings(isfront)

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


local chura_files = {
    "entities/gmod_81-765_base/shared.lua",
    "entities/gmod_subway_81-765/shared.lua",
    "entities/gmod_subway_81-766/shared.lua",
    "entities/gmod_subway_81-767/shared.lua",
    "entities/gmod_subway_81-765e.lua",
    "entities/gmod_subway_81-766e.lua",
    "entities/gmod_subway_81-767e.lua",
}
concommand.Add("zms_refresh_chura", function(ply)
    if IsValid(ply) then return end
    for _, fp in ipairs(chura_files) do
        game.ConsoleCommand("lua_refresh_file " .. fp .. "\n")
    end
end)
