AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.BogeyDistance = 650 -- Needed for gm trainspawner
ENT.SyncTable = {
    "EnableBVEmer", "Ticker", "KAH", "KAHk", "ALS", "ALSk", "BTB", "BTBk", "SD", "SDk", "FDepot", "PassScheme", "EnableBV",
    "DisableBV", "Ring", "R_Program2", "R_Announcer", "R_Line", "R_Micro", "R_Emer", "R_Program1", "R_Program11", "R_ChangeRoute",
    "R_ToBack", "DoorSelectL", "DoorSelectR", "DoorBlock", "EmerBrakeAdd", "EmerBrakeRelease", "EmerBrake", "DoorClose", "AttentionMessage",
    "Attention", "AttentionBrake", "EmergencyBrake", "Pr", "OtklR", "GlassHeating", "Washer", "SC",
    "SF31", "SF32", "SF33", "SF34", "SF36", "SF37",
    "SF38", "SF39", "SF40", "SF41", "SF42", "SF57", "SF43", "SF44", "SF45", "SF46", "SF47", "SF48", "SF49", "SF50", "SF51", "SF52", "SF53",
    "SF54", "SF55", "SF56", "SF80F9",
    "Stand", "EmergencyCompressor", "EmergencyControls", "EmergencyControlsK", "Wiper", "DoorLeft", "AccelRate", "HornB", "DoorRight",
    "AutoDrive", "Micro", "Vent1", "Vent2", "Vent", "PassLight", "CabLight", "HeadlightsSwitch", "ParkingBrake",
    "BBER", "BBE", "Compressor", "CabLightStrength", "AppLights1", "AppLights2", "Battery", "MfduF1", "MfduF2", "MfduF3",
    "MfduF4", "Mfdu1", "Mfdu4", "Mfdu7", "Mfdu2", "Mfdu5", "Mfdu8", "Mfdu0", "Mfdu3", "Mfdu6", "Mfdu9", "MfduF5",
    "MfduF6", "MfduF7", "MfduF8", "MfduF9", "K29", "UAVA", "K9", "K31", "EmerX1", "EmerX2", "EmerCloseDoors", "EmergencyDoors",
    "R_ASNPMenu", "R_ASNPUp", "R_ASNPDown", "R_ASNPOn", "VentHeatMode", "PowerOn", "PowerOff", "RearBrakeLineIsolation",
    "RearTrainLineIsolation", "FrontBrakeLineIsolation", "FrontTrainLineIsolation", "PB", "GV", "K23", "EmergencyBrakeValve",
    "CAMS1", "CAMS2", "CAMS3", "CAMS4", "CAMS5", "CAMS6", "CAMS7", "CAMS8", "CAMS9", "CAMS10",
    "IGLA1", "IGLA2", "IGLA3", "IGLA4", "AB",
    "MfduF1", "MfduF2", "MfduF3", "MfduF4", "Mfdu1", "Mfdu4", "Mfdu7", "Mfdu2", "Mfdu5", "Mfdu8", "Mfdu0", "Mfdu3", "Mfdu6", "Mfdu9", "MfduF5", "MfduF6", "MfduF7",
    "MfduF8", "MfduF9", "MfduHelp", "MfduKontr", "MfduTv", "MfduTv1", "MfduTv2",
    "Buik_EMsg1", "Buik_EMsg2", "Buik_Unused1", "Buik_Mode", "Buik_Path", "Buik_Return", "Buik_Down", "Buik_Up", "Buik_MicLine", "Buik_MicBtn", "Buik_Asotp", "Buik_Ik",
    "BatteryCharge"
}

if not ENT.PpzToggles then print("ACHTUNG! PIZDEC!") end
for _, cfg in ipairs(ENT.PpzToggles or {}) do
    table.insert(ENT.SyncTable, cfg.relayName)
end

if not ENT.PakToggles then print("ACHTUNG! PIZDEC!") end
for k, cfg in pairs(ENT.PakToggles or {}) do
    if #cfg.positions == 2 then
        table.insert(ENT.SyncTable, k)
    end
end

--------------------------------------------------------------------------------
function ENT:Initialize()
    self.Plombs = {
        --KAH = {true,"KAHk"},
        --KAHk = true,
        BTB = {true, "BTBk"},
        BTBk = true,
        --EmergencyControls = {false,"EmergencyControlsK"},
        --EmergencyControlsK = true,
        SD = {true, "SDk"},
        SDk = true,
        ALS = {true, "ALSk"},
        ALSk = true,
        K9 = true,
        UAVA = true,
        R_ASNPOn = true,
        Init = true,
    }

    -- Set model and initialize
    self:SetModel("models/metrostroi_train/81-760/81_760a_body.mdl")
    self.BaseClass.Initialize(self)
    self:SetPos(self:GetPos() + Vector(0, 0, 140))
    -- Create seat entities
    self.DriverSeat = self:CreateSeat("driver", Vector(461, 18.1, -33)) --Vector(427,17.5,-35))--  -- +Vector(21,7,-10)) 447.8   455            Vector(455,18.1,-35)
    self.InstructorsSeat = self:CreateSeat("instructor", Vector(435.8, -12, -40), Angle(0, 90, 0), "models/vehicles/prisoner_pod_inner.mdl")
    self.InstructorsSeat2 = self:CreateSeat("instructor", Vector(435.8, 45, -40), Angle(0, 90, 0), "models/vehicles/prisoner_pod_inner.mdl")
    self.InstructorsSeat3 = self:CreateSeat("instructor", Vector(417, -43, -36))
    --self.InstructorsSeat4 = self:CreateSeat("instructor",Vector(465,-35,-40),Angle(0,90,0),"models/vehicles/prisoner_pod_inner.mdl")
    -- Hide seats
    self.DriverSeat:SetRenderMode(RENDERMODE_TRANSALPHA)
    self.DriverSeat:SetColor(Color(0, 0, 0, 0))
    self.InstructorsSeat:SetRenderMode(RENDERMODE_TRANSALPHA)
    self.InstructorsSeat:SetColor(Color(0, 0, 0, 0))
    self.InstructorsSeat2:SetRenderMode(RENDERMODE_TRANSALPHA)
    self.InstructorsSeat2:SetColor(Color(0, 0, 0, 0))
    self.InstructorsSeat3:SetRenderMode(RENDERMODE_TRANSALPHA)
    self.InstructorsSeat3:SetColor(Color(0, 0, 0, 0))
    --self.InstructorsSeat4:SetRenderMode(RENDERMODE_TRANSALPHA)
    --self.InstructorsSeat4:SetColor(Color(0,0,0,0))
    self.LightSensor = self:AddLightSensor(Vector(460, 0, -130), Angle(0, 90, 0)) --"models/metrostroi_train/81-717/dkp_reader.mdl")
    --self.LightSensor = self:AddLightSensor(Vector(0,65,-30),Angle(0,0,0),"models/metrostroi_train/81-717/dkp_reader.mdl")
    -- Create bogeys
    self.FrontBogey = self:CreateBogey(Vector(297 + 20.8, 0, -70), Angle(0, 180, 0), true, "760F") --z=-90
    self.RearBogey = self:CreateBogey(Vector(-338 + 20.8, 0, -70), Angle(0, 0, 0), false, "760")
    self.FrontBogey:SetNWBool("Async", true)
    self.RearBogey:SetNWBool("Async", true)
    self.FrontBogey:SetNWInt("MotorSoundType", 2)
    self.RearBogey:SetNWInt("MotorSoundType", 2)
    self.FrontBogey:SetNWFloat("SqualPitch", 0.75)
    self.RearBogey:SetNWFloat("SqualPitch", 0.75)
    --self.FrontBogey:SetNWBool("DisableEngines",true)
    --self.RearBogey:SetNWBool("DisableEngines",true)
    --if Metrostroi.BogeyOldMap then
    --self.FrontCouple = self:CreateCouple(Vector( 448-6,0,-68.5),Angle(0,0,0),true,"722")
    --self.RearCouple  = self:CreateCouple(Vector(-419.5-7.5+6,0,-68.5),Angle(0,180,0),false,"717")
    --else
    self.FrontCouple = self:CreateCouple(Vector(442.2 + 20.8, 0, -68), Angle(0, 0, 0), true, "722")
    self.RearCouple = self:CreateCouple(Vector(-439 + 20.8, 0, -68), Angle(0, 180, 0), false, "763")
    --end
    --self.FrontBogey.DisableSound = 1
    --self.RearBogey.DisableSound = 1
    self.FrontCouple:SetModel("models/metrostroi_train/81-760/81_760_couple_wtht_ekk.mdl")
    self.FrontCouple:PhysicsInit(SOLID_VPHYSICS)
    constraint.AdvBallsocket(self, self.FrontCouple, 0, --bone
        0, --bone
        Vector(431.2 + 20.8, 0, -68), Vector(0, 0, 0), 1, --forcelimit
        1, --torquelimit
        -2, --xmin
        -2, --ymin
        -15, --zmin
        2, --xmax
        2, --ymax
        15, --zmax
        0.1, --xfric
        0.1, --yfric
        1, --zfric
        0, --rotonly
        1)

    --nocollide
    self.FrontCouple.CouplingPointOffset = Vector(65, 0, 0)
    self.FrontCouple.SnakePos = Vector(65.1, 1, -4.9)
    self:SetNW2Entity("FrontBogey", self.FrontBogey)
    self:SetNW2Entity("RearBogey", self.RearBogey)
    self:SetNW2Entity("FrontCouple", self.FrontCouple)
    self:SetNW2Entity("RearCouple", self.RearCouple)
    --self.DoorCabLeft = self:CreateDoor(Vector(0,0,0),Angle(0,0,0),"models/metrostroi_train/81-760/81_760_door_cab_l.mdl")
    -- Initialize key mapping
    self.KeyMap = {
        [KEY_W] = "KV765Up",
        [KEY_S] = "KV765Down",
        [KEY_1] = "KV765Set1",
        [KEY_2] = "KV765Set2",
        [KEY_3] = "KV765Set3",
        [KEY_4] = "KV765Set4",
        [KEY_5] = "KV765Set5",
        [KEY_6] = "KV765Set6",
        [KEY_7] = "KV765Set7",
        -- [KEY_8] = "KV765Set8",
        [KEY_9] = "KRO-",
        [KEY_0] = "KRO+",
        [KEY_A] = "DoorLeft",
        [KEY_D] = "DoorRight",
        [KEY_V] = "DoorClose",
        [KEY_G] = "EnableBVSet",
        [KEY_SPACE] = "PBSet",
        [KEY_EQUAL] = "R_Program1Set",
        [KEY_MINUS] = "Micro",
        -- [KEY_RBRACKET] = "R_Program1Set",
        [KEY_B] = "AttentionMessageSet",
        [KEY_N] = "AttentionBrakeSet",
        [KEY_M] = "AttentionSet",
        [KEY_H] = "PrToggle",
        [KEY_LSHIFT] = {
            -- [KEY_W] = "PanelKVUp_Unlocked",
            [KEY_SPACE] = "AttentionBrakeSet",
            [KEY_V] = "EmergencyDoorsToggle",
            --[KEY_7] = "WrenchNone",
            --[KEY_8] = "WrenchKRR",
            [KEY_9] = "KRR-", --"WrenchKRO",
            [KEY_0] = "KRR+", --"WrenchKRO",
            [KEY_G] = "DisableBVSet",
            [KEY_2] = "RingSet",
            [KEY_L] = "HornBSet",
            [KEY_MINUS] = "Buik_DownSet",
            [KEY_EQUAL] = "Buik_UpSet",
            -- [KEY_UP] = "BMCISUpSet",
            -- [KEY_DOWN] = "BMCISDownSet",
        },
        --[KEY_LEFT] = "BMCISEscSet",
        --[KEY_RIGHT] = "BMCISEnterSet",		
        [KEY_LALT] = {
            [KEY_V] = "DoorBlockToggle",
            [KEY_PAD_1] = "Mfdu1Set",
            [KEY_PAD_2] = "Mfdu2Set",
            [KEY_PAD_3] = "Mfdu3Set",
            [KEY_PAD_4] = "Mfdu4Set",
            [KEY_PAD_5] = "Mfdu5Set",
            [KEY_PAD_6] = "Mfdu6Set",
            [KEY_PAD_7] = "Mfdu7Set",
            [KEY_PAD_8] = "Mfdu8Set",
            [KEY_PAD_9] = "Mfdu9Set",
            [KEY_PAD_0] = "Mfdu0Set",
            [KEY_PAD_DECIMAL] = "MfduF5Set",
            [KEY_PAD_ENTER] = "MfduF8Set",
            [KEY_UP] = "MfduF6Set",
            [KEY_LEFT] = "MfduF5Set",
            [KEY_DOWN] = "MfduF7Set",
            [KEY_RIGHT] = "MfduF9Set",
            [KEY_PAD_MINUS] = "MfduF2Set",
            [KEY_PAD_PLUS] = "MfduF3Set",
            [KEY_PAD_MULTIPLY] = "MfduF4Set",
            [KEY_PAD_DIVIDE] = "MfduF1Set",
            [KEY_SPACE] = "AttentionMessageSet",
            [KEY_MINUS] = "Buik_ModeSet",
            [KEY_EQUAL] = "Buik_ReturnSet",
        },
        [KEY_PAD_PLUS] = "EmerBrakeAddSet",
        [KEY_PAD_MINUS] = "EmerBrakeReleaseSet",
        [KEY_F] = "PneumaticBrakeUp",
        [KEY_R] = "PneumaticBrakeDown",
        [KEY_PAD_1] = "PneumaticBrakeSet1",
        [KEY_PAD_2] = "PneumaticBrakeSet2",
        [KEY_PAD_3] = "PneumaticBrakeSet3",
        [KEY_PAD_4] = "PneumaticBrakeSet4",
        [KEY_PAD_5] = "PneumaticBrakeSet5",
        [KEY_PAD_6] = "PneumaticBrakeSet6",
        [KEY_PAD_DIVIDE] = "EmerX1Set",
        [KEY_PAD_MULTIPLY] = "EmerX2Set",
        [KEY_PAD_9] = "EmerBrakeToggle",
        [KEY_BACKSPACE] = "EmergencyBrakeToggle",
        [KEY_L] = "HornEngage",
    }

    self.KeyMap[KEY_RALT] = self.KeyMap[KEY_LALT]
    self.KeyMap[KEY_RSHIFT] = self.KeyMap[KEY_LSHIFT]
    self.KeyMap[KEY_RCONTROL] = self.KeyMap[KEY_LCONTROL]
    -- Cross connections in train wires
    self.TrainWireCrossConnections = {
        [4] = 3, -- Orientation F<->B
        [13] = 12, -- Reverser F<->B
        [38] = 37, -- Doors L<->R
    }

    self.Lights = {
        --[1]  = { "light",           Vector(508.9  ,   -36, -39.5), Angle(0,0,0), Color(200,255,255), brightness = 1, scale = 0.3},--, texture = "sprites/light_glow02.vmt" },
        --[2]  = { "light",           Vector(508.9  ,   36.5, -39.5), Angle(0,0,0), Color(200,255,255), brightness = 1, scale = 0.3},--, texture = "sprites/light_glow02.vmt" },
        --[10] = { "dynamiclight",    Vector( 465, 0, 30), Angle(0,0,0), Color(245,238,223), brightness = 0.5, distance = 650 },
        -- Interior
        --[11] = { "dynamiclight",  Vector( 200, 0, 10), Angle(0,0,0), Color(255,175,50), brightness = 3, distance = 400 , fov=180,farz = 128
        -- Redlights
        --[3]  = { "light",           Vector(500,   -65, 15), Angle(0,0,0), Color(255,50,50), brightness = 0.2, scale = 4, texture = "sprites/light_glow02.vmt" },
        --[4]  = { "light",           Vector(509,   60, 15), Angle(0,0,0), Color(255,50,50), brightness = 0.2, scale = 4, texture = "sprites/light_glow02.vmt" },
        [1] = {
            "light", --, texture = "sprites/light_glow02.vmt" },
            Vector(509.3, -36, -39.5),
            Angle(0, 0, 0),
            Color(200, 240, 255),
            brightness = 0.5,
            scale = 2.5
        },
        [2] = {
            "light", --, texture = "sprites/light_glow02.vmt" },
            Vector(509.3, 36.5, -39.5),
            Angle(0, 0, 0),
            Color(200, 240, 255),
            brightness = 0.5,
            scale = 2.5
        },
        --[10] = { "dynamiclight",    Vector( 486, 14, 13), Angle(0,0,0), Color(255,255,255), brightness = 0.1, distance = 550 },
        [10] = {
            "dynamiclight",
            Vector(487, 16, 13),
            Angle(0, 0, 0),
            Color(255, 255, 255),
            brightness = 0.1,
            distance = 550
        },
        -- Interior
        [11] = {
            "dynamiclight",
            Vector(190, 0, 10),
            Angle(0, 0, 0),
            Color(230, 230, 255),
            brightness = 2,
            distance = 630,
            fov = 180,
            farz = 128
        },
        [12] = {
            "dynamiclight",
            Vector(-65, 0, 10),
            Angle(0, 0, 0),
            Color(230, 230, 255),
            brightness = 2,
            distance = 630,
            fov = 180,
            farz = 128
        },
        [13] = {
            "dynamiclight",
            Vector(-320, 0, 10),
            Angle(0, 0, 0),
            Color(230, 230, 255),
            brightness = 2,
            distance = 630,
            fov = 180,
            farz = 128
        },
    }

    --[[
        [15] = { "dynamiclight",    Vector(-350, 0, 10), Angle(0,0,0), Color(238,238,197), brightness = 0.5, distance = 500, fov=180,farz = 128 },
        [16] = { "dynamiclight",    Vector(-60, 0, 10), Angle(0,0,0), Color(238,238,197), brightness = 0.5, distance = 500, fov=180,farz = 128 },
        [17] = { "dynamiclight",    Vector( 230, 0, 10), Angle(0,0,0), Color(238,238,197), brightness = 0.5, distance = 500, fov=180,farz = 128 },]]
    --[13] = { "dynamiclight",  Vector(-200, 0, 10), Angle(0,0,0), Color(255,175,50), brightness = 3, distance = 400 , fov=180,farz = 128 },
    --[11] = { "dynamiclight",  Vector( 100, 0, 10), Angle(0,0,0), Color(255,175,50), brightness = 3, distance = 400 , fov=180,farz = 128 },
    --[12] = { "dynamiclight",  Vector( 100, 0, 10), Angle(0,0,0), Color(255,175,50), brightness = 3, distance = 400, fov=180,farz = 128 },
    self.InteractionZones = {
        {
            Pos = Vector(466, 64, -15),
            Radius = 48,
            ID = "CabinDoorLeft"
        },
        {
            Pos = Vector(466, -60, -15),
            Radius = 48,
            ID = "CabinDoorRight"
        },
    }

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

    self.STL = self.STL or false
    self.BKL = self.BKL or true
    self:SetNW2Bool("STL", self.STL)
    self:SetNW2Bool("BKL", self.BKL)
    self.PassengerDoor = false
    self.CabinDoorLeft = false
    self.CabinDoorRight = false
    self.Chair = false
    self.SpeedTimer = CurTime()
    self.WrenchMode = 0
    self.ALSVal = 0
    self.door_pvz = false
    self.door_add_1 = false
    self.door_add_2 = false
    self.door_k31 = false
    --for k in pairs(self:GetMaterials()) do self:SetSubMaterial(k-1,"") end
    --self:SetSubMaterial(0,"models/metrostroi_train/81-760/hull_baklajan")
    self:SetNW2String("Texture", "760A")
    self:SetNW2String("texture", "760A")
    --self:CreateLadder()
    --self:CreateLadder(true)
    self:CreateDoorTriggers()
    self:TrainSpawnerUpdate()
end

function ENT:InitializeSystemsServer()
    self.PpzAsnp = self.SF42F1
    self.PpzBsControl = self.SF30F1
    self.PpzActiveCabin = self.SF23F2
    self.PpzPrimaryControls = self.SF23F3
    self.PpzEmerControls = self.SF23F1
    self.PpzOrient = self.SF23F13
    self.PpzAts1 = self.SF23F8
    self.PpzAts2 = self.SF23F7
    self.PpzUpi = self.SF23F8
    self.PpzKm = self.SF22F2
    self.PpzBtboSd = self.SF22F2
    self.PpzParkingBrakeControl = self.SF22F3
    self.PpzRvtb = self.SF22F5
    self.PpzDoorsControl = self.SF80F5
    self.PpzDoorsSignal = self.SF80F1
    self.PpzCabinDoors = self.SF80F3
    self.PpzAoVent = self.SF62F1
    self.PpzCounter = self.SF42F2
    self.PpzPpp = self.SF30F5
    self.PpzRvs = self.SF70F1
    self.PpzCik = self.SF45F11
    self.PpzVideo = self.SF45F1
    self.PpzSmartdrive = self.SF43F3
    self.PpzAsotpCbki = self.SF90F1
    self.PpzHeadlights = self.SF51F1
    self.PpzBattLights = self.SF51F2
    self.PpzCabinLights = self.SF52F1
    self.PpzCabinAc = self.SF62F3
    self.PpzCabinEpra = self.SF62F4
    self.PpzSalonAc = self.SF61F8
    self.PpzAuxCabin = self.SF70F4
    self.PpzWiper = self.SF70F3
    self.PpzPurLamps = self.SF70F3
    self.PpzWindshieldHeat = self.SF70F2
end

function ENT:NonSupportTrigger()
    self.ALS:TriggerInput("Set", 1)
    self.ALSk:TriggerInput("Set", 0)
    self.ALSVal = 2
    self.Plombs.ALS = nil
    self.Plombs.ALSk = nil
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

local function CanConstrain(Ent, Bone)
    if not Ent then return false end
    if not Ent:IsWorld() and not Ent:IsValid() then return false end
    if not Ent:GetPhysicsObjectNum(Bone) or not Ent:GetPhysicsObjectNum(Bone):IsValid() then return false end
    return true
end

function ENT:CreateLadder(rev)
    local train = self
    local self = ents.Create("base_entity")
    --train:SetSolid(SOLID_NONE)	
    self:SetPos(train:LocalToWorld(Vector(rev and 431 or 432, rev and -75 or 120, -125)))
    self:SetModel("models/props_c17/metalladder001.mdl")
    self:SetSolid(SOLID_VPHYSICS)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self:SetCollisionGroup(COLLISION_GROUP_WORLD)
    constraint.Weld(train, self, 0, 0, 0, 1, false)
    constraint.NoCollide(Entity(0), self, 0, 0)
    constraint.NoCollide(train, self, 0, 0)
    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        --phys:EnableMotion(false);
    end

    local pos = self:GetPos()
    local dist = self:OBBMaxs().x + 17
    local dismountDist = self:OBBMaxs().x + 49
    local bottom = self:LocalToWorld(Vector(0, 0, self:OBBMins().z))
    local top = self:LocalToWorld(Vector(0, 0, 70))
    for k, v in pairs(self:GetChildren()) do
        SafeRemoveEntity(v)
    end

    self.ladder = ents.Create("func_useableladder")
    self.ladder:SetPos(pos + self:GetForward() * dist)
    self.ladder:SetKeyValue("point0", tostring(bottom + self:GetForward() * dist))
    self.ladder:SetKeyValue("point1", tostring(top + self:GetForward() * dist))
    self.ladder:SetKeyValue("targetname", "zladder_" .. self:EntIndex())
    self.ladder:SetParent(self)
    self.ladder:Spawn()
    self.bottomDismount = ents.Create("info_ladder_dismount")
    self.bottomDismount:SetPos(bottom + self:GetForward() * dismountDist)
    self.bottomDismount:SetKeyValue("laddername", "zladder_" .. self:EntIndex())
    self.bottomDismount:SetParent(self)
    self.bottomDismount:Spawn()
    constraint.Weld(train, self.bottomDismount, 0, 0, 0, 1, false)
    constraint.NoCollide(Entity(0), self.bottomDismount, 0, 0)
    constraint.NoCollide(train, self.bottomDismount, 0, 0)
    self.topDismount = ents.Create("info_ladder_dismount")
    self.topDismount:SetPos(top - self:GetForward() * dist)
    self.topDismount:SetKeyValue("laddername", "zladder_" .. self:EntIndex())
    self.topDismount:SetParent(self)
    self.topDismount:Spawn()
    constraint.Weld(train, self.topDismount, 0, 0, 0, 1, false)
    constraint.NoCollide(Entity(0), self.topDismount, 0, 0)
    constraint.NoCollide(train, self.topDismount, 0, 0)
    self.ladder:Activate()
    self:SetAngles(train:GetAngles() + (rev and Angle(0, -90, 0) or Angle(0, 90, 0)))
    --print(self)
    --self:SetCollisionGroup( COLLISION_GROUP_IN_VEHICLE )
    table.insert(train.TrainEntities, self)
    table.insert(train.TrainEntities, self.ladder)
    table.insert(train.TrainEntities, self.bottomDismount)
    table.insert(train.TrainEntities, self.topDismount)
    if rev then
        train.ladderbaseR = self
    else
        train.ladderbaseL = self
    end
end

function ENT:CreateDoor(pos, ang, mdl)
    local ent = ents.Create("prop_physics") --ents.Create("prop_door_rotating")
    if not IsValid(ent) then return end
    local pos = pos or Vector(0, 0, 0)
    local ang = ang or Angle(0, 0, 0)
    ent:SetModel(mdl) --(mdl)
    ent:SetPos(self:LocalToWorld(pos))
    ent:SetAngles(self:GetAngles() + ang)
    ent:Spawn()
    ent:SetOwner(self:GetOwner())
    --ent:SetCollisionGroup( COLLISION_GROUP_WORLD )
    -- Assign ownership
    if CPPI and IsValid(self:CPPIGetOwner()) then ent:CPPISetOwner(self:CPPIGetOwner()) end
    --ent:SetParent(self)
    --[[
	ent:SetUseType( SIMPLE_USE )
	ent:PhysicsInit( SOLID_VPHYSICS )
	ent:SetMoveType( MOVETYPE_VPHYSICS )
	ent:SetCollisionGroup( COLLISION_GROUP_NONE )	]]
    --[[
	local VERTICES = {}
	table.insert( VERTICES, { pos = ( self:GetPos() + Vector( 0,0,10 ) ) } );
	table.insert( VERTICES, { pos = ( self:GetPos() + Vector( 0,0,-10 ) ) } );
	 
	ent:PhysicsFromMesh( VERTICES )
	ent:GetPhysicsObject():EnableMotion( false )
	ent:EnableCustomCollisions( true )	]]
    --constraint.Weld( ent, self , 0, 0, 0, 1, false )				
    --constraint.NoCollide(ent,self,0,0)	
    --ent:SetKeyValue("hardware",0)
    ent:SetParent(self)
    table.insert(self.TrainEntities, ent)
    return ent
end

function ENT:CreateFence(pos, ang, a)
    local ent = ents.Create("prop_ragdoll") --ents.Create("prop_physics")
    if not IsValid(ent) then return end
    ent:SetModel("models/metrostroi_train/81-760/81_760_fence_corrugated.mdl") --ent:SetModel("models/sligwolf/blue-x12/bluex12_train_socket.mdl")	
    ent:SetPos(self:LocalToWorld(pos))
    ent:SetAngles(self:GetAngles())
    ent:Spawn()
    --ent:SetParent(self)
    ent:SetOwner(self:GetOwner())
    ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
    -- Assign ownership
    if CPPI and IsValid(self:CPPIGetOwner()) then ent:CPPISetOwner(self:CPPIGetOwner()) end
    --constraint.Weld(ent,self,0,0,0,1,false)	
    ent:GetPhysicsObject():SetMass(1)
    -- Add to cleanup list
    table.insert(self.TrainEntities, ent)
    return ent
end

--[[
hook.Add("MetrostroiCoupled","Fence",function(ent,ent2)
	if ent:GetClass():find("760a") or ent:GetClass():find("761a") or ent:GetClass():find("763a") then
		if not IsValid(ent.Fence) and not IsValid(ent2.Fence) then
			ent.Fence = ent:CreateFence(Vector(-477.25,0,1.5),Angle(0,0,0))
			ent2.Fence = ent.Fence
			local bone1,bone2 = 0,1
			local pos1,pos2 = ent.Fence:GetBonePosition(1),ent.Fence:GetBonePosition(2)
			if ent:GetPos():Distance(pos1) < ent:GetPos():Distance(pos2) then
				bone1,bone2 = 1,0
			end			
			constraint.Weld( ent.Fence, ent , bone1, 0, 0, 1, false )			
			constraint.Weld( ent.Fence, ent2, bone2, 0, 0, 1, false )
		end
	end
end)]]
--------------------------------------------------------------------------------
-- Turn light on or off
--------------------------------------------------------------------------------
function ENT:SetLightPower(index, power, brightness)
    local lightData = self.Lights[index]
    self.GlowingLights = self.GlowingLights or {}
    self.LightBrightness = self.LightBrightness or {}
    brightness = brightness or 1
    -- Check if light already glowing
    if (power and self.GlowingLights[index]) and (brightness == self.LightBrightness[index]) then return end
    -- If light already glowing and only brightness changed
    if (power and self.GlowingLights[index]) and (brightness ~= self.LightBrightness[index]) then
        local light = self.GlowingLights[index]
        if (lightData[1] == "glow") or (lightData[1] == "light") then
            local brightness = brightness * (lightData.brightness or 0.5)
            light:SetKeyValue("rendercolor", Format("%i %i %i", lightData[4].r * brightness, lightData[4].g * brightness, lightData[4].b * brightness))
        end

        if lightData[1] == "headlight" then
            -- Set Brightness
            local brightness = brightness * (lightData.brightness or 1.25)
            light:SetKeyValue("lightcolor", Format("%i %i %i 255", lightData[4].r * brightness, lightData[4].g * brightness, lightData[4].b * brightness))
        end

        if lightData[1] == "dynamiclight" then
            --light:SetKeyValue("brightness", brightness * (lightData.brightness or 2))
            light:SetKeyValue("_light", Format("%i %i %i", lightData[4].r * brightness, lightData[4].g * brightness, lightData[4].b * brightness))
        end

        self.LightBrightness[index] = brightness
        return
    end

    -- Turn off light
    SafeRemoveEntity(self.GlowingLights[index])
    self.GlowingLights[index] = nil
    self.LightBrightness[index] = brightness
    -- Create light
    if (lightData[1] == "headlight") and power then
        local light = ents.Create("env_projectedtexture")
        light.DormantFix1 = true
        light:SetTransmitWithParent(true)
        light:SetParent(self)
        light:SetPos(self:LocalToWorld(lightData[2]))
        light:SetAngles(self:LocalToWorldAngles(lightData[3]))
        -- Set parameters
        light:SetKeyValue("enableshadows", lightData.shadows or 1)
        light:SetKeyValue("farz", lightData.farz or 2048)
        light:SetKeyValue("nearz", lightData.nearz or 16)
        light:SetKeyValue("lightfov", lightData.fov or 120)
        -- Set Brightness
        local brightness = brightness * (lightData.brightness or 1.25)
        light:SetKeyValue("lightcolor", Format("%i %i %i 255", lightData[4].r * brightness, lightData[4].g * brightness, lightData[4].b * brightness))
        -- Turn light on
        light:Spawn() --"effects/flashlight/caustics"
        light:Input("SpotlightTexture", nil, nil, lightData.texture or "effects/flashlight001")
        self.GlowingLights[index] = light
    end

    if (lightData[1] == "glow") and power then
        local light = ents.Create("env_sprite")
        light.DormantFix1 = true
        light:SetTransmitWithParent(true)
        light:SetParent(self)
        light:SetLocalPos(lightData[2])
        light:SetLocalAngles(lightData[3])
        -- Set parameters
        local brightness = brightness * (lightData.brightness or 0.5)
        light:SetKeyValue("rendercolor", Format("%i %i %i", lightData[4].r * brightness, lightData[4].g * brightness, lightData[4].b * brightness))
        light:SetKeyValue("rendermode", lightData.type or 3) -- 9: WGlow, 3: Glow
        light:SetKeyValue("renderfx", 14)
        light:SetKeyValue("model", lightData.texture or "sprites/glow1.vmt")
        --      light:SetKeyValue("model", "sprites/light_glow02.vmt")
        --      light:SetKeyValue("model", "sprites/yellowflare.vmt")
        light:SetKeyValue("scale", lightData.scale or 1.0)
        light:SetKeyValue("spawnflags", 1)
        -- Turn light on
        light:Spawn()
        self.GlowingLights[index] = light
    end

    if (lightData[1] == "light") and power then
        local light = ents.Create("env_sprite")
        light.DormantFix1 = true
        light:SetTransmitWithParent(true)
        light:SetParent(self)
        light:SetLocalPos(lightData[2])
        light:SetLocalAngles(lightData[3])
        -- Set parameters
        local brightness = brightness * (lightData.brightness or 0.5)
        light:SetKeyValue("rendercolor", Format("%i %i %i", lightData[4].r * brightness, lightData[4].g * brightness, lightData[4].b * brightness))
        light:SetKeyValue("rendermode", lightData.type or 9) -- 9: WGlow, 3: Glow
        light:SetKeyValue("renderfx", 14)
        --      light:SetKeyValue("model", "sprites/glow1.vmt")
        light:SetKeyValue("model", lightData.texture or "sprites/light_glow02.vmt")
        --      light:SetKeyValue("model", "sprites/yellowflare.vmt")
        light:SetKeyValue("scale", lightData.scale or 1.0)
        --Size of Glow Proxy Geometry
        light:SetKeyValue("spawnflags", 1)
        -- Turn light on
        light:Spawn()
        self.GlowingLights[index] = light
        self:SetNW2Entity("GlowingLights" .. index, self.GlowingLights[index])
    end

    if (lightData[1] == "dynamiclight") and power then
        local light = ents.Create("light_dynamic")
        light:SetParent(self)
        -- Set position
        light:SetLocalPos(lightData[2])
        light:SetLocalAngles(lightData[3])
        -- Set parameters
        light:SetKeyValue("_light", Format("%i %i %i", lightData[4].r * brightness, lightData[4].g * brightness, lightData[4].b * brightness))
        light:SetKeyValue("style", 0)
        light:SetKeyValue("distance", lightData.distance or 300)
        light:SetKeyValue("brightness", lightData.brightness or 2)
        -- Turn light on
        light:Spawn()
        light:Fire("TurnOn", "", "0")
        self.GlowingLights[index] = light
    end
end

function ENT:TriggerLightSensor(coil, plate)
    self.ProstKos:TriggerSensor(plate)
end

function ENT:TrainSpawnerUpdate()
    self:SetNW2Bool("STL", self.STL)
    self:SetNW2Bool("BKL", self.BKL)

    local Announcer = {}
    for k, v in pairs(Metrostroi.AnnouncementsASNP or {}) do
        if not v.riu then Announcer[k] = v.name or k end
    end

    if self.InitializeSounds then
        self:InitializeSounds()
    end
end

--------------------------------------------------------------------------------
function ENT:Think()
    local retVal = self.BaseClass.Think(self)
    local Panel = self.Panel
    local power = self.Electric.UPIPower > 0
    local power1 = self.Electric.BSPowered > 0
    local powerReserve = self.Electric.PowerReserve > 0
    if self.Electric.Battery80V < 62 then self.Electric.Power = nil end
    local state = math.abs(self.AsyncInverter.InverterFrequency / (11 + self.AsyncInverter.State * 5)) --(10+8*math.Clamp((self.AsyncInverter.State-0.4)/0.4,0,1)))
    self:SetPackedRatio("asynccurrent", math.Clamp(state * (state + self.AsyncInverter.State / 1), 0, 1) * math.Clamp(self.Speed / 6, 0, 1))
    self:SetPackedRatio("asyncstate", math.Clamp(self.AsyncInverter.State / 0.2 * math.abs(self.AsyncInverter.Current) / 100, 0, 1))
    self:SetPackedRatio("chopper", math.Clamp(self.Electric.Chopper > 0 and self.Electric.Iexit / 100 or 0, 0, 1))
    self:SetPackedRatio("Speed", self.Speed)
    self:SetNW2Int("Wrench", self.WrenchMode)
    self:SetPackedRatio("Controller", self.KV765.VisualPosition)
    self:SetPackedRatio("KRO", (self.RV.KROPosition + 1) / 2)
    self:SetPackedRatio("KRR", (self.RV.KRRPosition + 1) / 2)
    self:SetPackedRatio("VentCondMode", self.VentCondMode.Value / 3)
    self:SetPackedRatio("VentStrengthMode", self.VentStrengthMode.Value / 3)
    self:SetPackedBool("PowerOnLamp", Panel.PowerOnl > 0)
    self:SetPackedBool("PowerOffLamp", Panel.PowerOffl > 0)
    self:SetPackedBool("BatteryChargeLamp", Panel.BatteryChargel > 0)
    local fB, rB = self.FrontBogey, self.RearBogey
    local validfB, validrB = IsValid(fB), IsValid(rB)
    for i = 1, 4 do
        self:SetPackedBool("TR" .. i, self.BUV.Pant or i <= 2 and validfB and fB.DisableContactsManual or i > 2 and validrB and rB.DisableContactsManual)
    end

    for k, cfg in pairs(self.PakToggles or {}) do
        local r = self[k]
        if r and r.Value then
            self:SetNW2Int(k, r.Value)
        end
    end

    self:SetPackedBool("SK1", self.EmergencyValveTimer and CurTime() - self.EmergencyValveTimer < 1)
    if self.Pneumatic.EmergencyValve and not self.EmergencyValveTimer then
        self.EmergencyValveTimer = CurTime()
    elseif not self.Pneumatic.EmergencyValve and self.EmergencyValveTimer and CurTime() - self.EmergencyValveTimer > 1 then
        self.EmergencyValveTimer = nil
    end

    --self:SetPackedBool("PSNWork",power and self.BUV.PSN > 0)
    self:SetPackedBool("WorkBeep", power1)
    self:SetPackedBool("WorkCabVent", Panel.CabVent > 0)
    if Panel.CabVent > 0 then
        if not self.VentTimer then self.VentTimer = CurTime() end
    elseif self.VentTimer then
        self.VentTimer = nil
    end

    if not self.IglaStarted and self.IGLA_CBKI.State == 2 then
        self.IglaStarted = CurTime() + 7
    end
    if self.IglaStarted and self.IGLA_CBKI.State < 2 then
        self.IglaStarted = nil
    end
    if isnumber(self.IglaStarted) and CurTime() > self.IglaStarted then
        self:PlayOnce("igla_started", "cabin", nil, 1)
        self.IglaStarted = true
    end

    self:SetPackedRatio("VentTimer", self.VentTimer or 0)
    self:SetPackedBool("BUKPRing", power and self.BUKP.State == 5 and self.BUKP.ErrorRinging)
    self:SetPackedBool("RingEnabled", power and self.BUKP.Ring)
    self:SetPackedBool("WorkFan", Panel.WorkFan > 0)
    self:SetPackedBool("PanelLighting", Panel.PanelLights > 0)
    local HeadlightsPower = Panel.HeadlightsFull > 0 and 1 or Panel.HeadlightsHalf > 0 and 0.5 or 0
    self:SetPackedRatio("HeadlightsSwitch", self.HeadlightsSwitch.Value / 2)
    self:SetPackedBool("HeadlightsEnabled2", HeadlightsPower > 0.5)
    self:SetPackedBool("HeadlightsEnabled1", HeadlightsPower > 0 and HeadlightsPower < 1)
    self:SetPackedRatio("Headlights", HeadlightsPower)
    self:SetLightPower(1, HeadlightsPower > 0, HeadlightsPower ^ 0.5)
    self:SetLightPower(2, HeadlightsPower > 0, HeadlightsPower ^ 0.5)
    self:SetPackedBool("BacklightsEnabled", Panel.RedLights > 0)
    local cablight = Panel.CabLight == 1 and 0.25 or Panel.CabLight == 2 and 0.8 or 0
    local cabl = cablight > 0
    self:SetLightPower(10, cabl, cablight)
    self:SetPackedBool("CabinEnabledEmer", cabl)
    self:SetPackedBool("CabinEnabledFull", cablight > 0.25)
    --local passlight = power1 and (self.BUV.MainLights and 1 or (self.SF44.Value > 0.5 and (self.SF31.Value+self.SF32.Value > 0.5)) and 0.25) or 0
    --local passlight = power1 and self.BUV.MainLights and ((self.SF44.Value*self.Battery.Value > 0 and 0.25 or 0)+(self.SF43.Value*self.Battery.Value > 0 and 0.75 or 0)) or 0
    local passlight = Panel.SalonLighting1 * 0.25 + Panel.SalonLighting2 * 0.75
    local passl = passlight > 0
    self:SetLightPower(11, passl, passlight)
    self:SetLightPower(12, passl, passlight)
    self:SetLightPower(13, passl, passlight)
    self:SetPackedBool("SalonLighting1", Panel.SalonLighting1 > 0) --power1 and self.BUV.MainLights and self.SF44.Value*self.Battery.Value > 0)
    self:SetPackedBool("SalonLighting2", Panel.SalonLighting2 > 0) --power1 and self.BUV.MainLights and self.SF43.Value*self.Battery.Value > 0)
    --self:SetPackedRatio("SalonLighting",passlight)
    --self:SetPackedRatio("TrainLine",7.3/16)
    --self:SetPackedRatio("BrakeLine",5.2/16)
    --self:SetPackedRatio("BrakeCylinder",self.AsyncInverter.PN1*1.1/6)
    self:SetNW2Bool("BISpeedLimitBlink", power and (self.BARS.BINoFreq > 0 or self.BARS.NoFreq) and self.BARS.Active == 1)
    --self:SetNW2Bool("NoFrequency",power and self.BARS.NoFreq)
    --print(self.BARS.NoFreq)
    for idx = 1, 8 do
        self:SetNW2Bool("DoorButtonLed" .. idx, self.Electric.BSPowered > 0 and self.BUD.OpenButton[idx] and true)
    end
    self:SetNW2Bool("BIForward", power and self.SpeedSign == 1 and self.BARS.Speed > 0.2)
    self:SetNW2Bool("BIBack", power and self.SpeedSign == -1 and self.BARS.Speed > 0.2)
    self:SetNW2Bool("MfduLamp", power and self.BUKP.State ~= 0)
    self:SetNW2Bool("DoorsClosed", powerReserve and self.BUKP.DoorClosed)
    self:SetNW2Bool("HVoltage", powerReserve and not self.BUKP.HVBad)
    self:SetNW2Bool("DoorLeftLamp", Panel.DoorLeftL > 0)
    self:SetNW2Bool("DoorRightLamp", Panel.DoorRightL > 0)
    self:SetNW2Bool("EmerBrakeWork", Panel.EmerBrakeL > 0)
    self:SetNW2Bool("EmerXod", Panel.EmerXodL > 0)
    self:SetNW2Bool("KAHLamp", Panel.KAHl > 0)
    self:SetNW2Bool("ALSLamp", Panel.ALSl > 0)
    self:SetNW2Bool("PrLamp", Panel.PRl > 0)
    self:SetNW2Bool("OtklRLamp", Panel.OtklRl > 0)
    self:SetNW2Bool("R_LineLamp", Panel.R_Linel > 0)
    self:SetNW2Bool("R_ChangeRouteLamp", Panel.R_ChangeRoutel > 0)
    self:SetNW2Bool("WasherLamp", Panel.Washerl > 0)
    self:SetNW2Bool("WiperLamp", Panel.Wiperl > 0)
    self:SetNW2Bool("WiperPower", Panel.WiperPower > 0)
    self:SetNW2Bool("AccelRateLamp", power and self.BUKP.Slope)
    self:SetNW2Bool("RS", power and self.BARS.F6)
    self:SetNW2Bool("DoorAlarm", self.IK.DoorAlarm)
    self:SetNW2Bool("EmergencyControlsLamp", Panel.EmergencyControlsl > 0)
    self:SetNW2Bool("EmergencyDoorsLamp", Panel.EmergencyDoorsl > 0)
    self:SetNW2Bool("GlassHeatingLamp", Panel.GlassHeatingl > 0)
    self:SetPackedBool("AnnPlay", power1)
    self:SetPackedBool("AnnPlayHead", power1)
    self:SetNW2Bool("DoorCloseLamp", Panel.DoorCloseL > 0)
    self:SetNW2Bool("DoorBlockLamp", Panel.DoorBlockL > 0)
    self:SetPackedRatio("CabinLight",self.CabinLight.Value / 2)
    self:SetPackedBool("AppLights", Panel.AppLights > 0)
    self:SetPackedRatio("LV", Panel.LV / 150)
    self:SetPackedRatio("HV", (self.SF42F2.Value * self.Electric.BSPowered > 0.5 and self.Electric.Main750V or 0) / 1000)
    self:SetPackedRatio("IVO", 0.5 + self.BUV.IVO / 150)
    self:SetPackedBool("PassengerDoor", self.PassengerDoor)
    self:SetPackedBool("CabinDoorLeft", self.CabinDoorLeft)
    self:SetPackedBool("CabinDoorRight", self.CabinDoorRight)
    self:SetPackedBool("door_pvz", self.door_pvz)
    self:SetPackedBool("door_add_1", self.door_add_1)
    self:SetPackedBool("door_add_2", self.door_add_2)
    self:SetPackedBool("door_k31", self.door_k31)
    self:SetPackedBool("cab_chair_add", self.Chair or self.InstructorsSeat3 and IsValid(self.InstructorsSeat3) and IsValid(self.InstructorsSeat3:GetDriver()))
    self:SetPackedBool("CompressorWork", self.Pneumatic.Compressor and CurTime() - self.Pneumatic.Compressor > 0)
    if self.FrontTrain ~= self.PrevFrontTrain then
        self:SetNW2Entity("FrontTrain", self.FrontTrain)
        self.PrevFrontTrain = self.FrontTrain
    end

    if self.RearTrain ~= self.PrevRearTrain then
        self:SetNW2Entity("RearTrain", self.RearTrain)
        self.PrevRearTrain = self.RearTrain
    end

    self:SetPackedRatio("Cran", self.Pneumatic.DriverValvePosition)
    self:SetPackedRatio("BL", self.Pneumatic.BrakeLinePressure / 16.0)
    self:SetPackedRatio("TL", self.Pneumatic.TrainLinePressure / 16.0)
    self:SetPackedRatio("BC", math.min(3.8, self.Pneumatic.BrakeCylinderPressure) / 6.0)
    for i = 1, 8 do
        if i == 1 or i == 4 or i == 5 or i == 8 then --  со стояночным
            self:SetPackedBool("BC" .. i, math.max(self.Pneumatic.BrakeCylinderPressure, (i < 5 and (validfB and fB.DisableParking and 0 or 1) or i > 4 and (validrB and rB.DisableParking and 0 or 1)) * (3.8 - self.Pneumatic.ParkingBrakePressure) / 2) <= 0.1)
            self:SetPackedRatio("DPBTPressure" .. i, math.max(self.Pneumatic.BrakeCylinderPressure, (i < 5 and (validfB and fB.DisableParking and 0 or 1) or i > 4 and (validrB and rB.DisableParking and 0 or 1)) * (3.8 - self.Pneumatic.ParkingBrakePressure) / 2))
        else
            self:SetPackedBool("BC" .. i, self.Pneumatic.BrakeCylinderPressure <= 0.1)
            self:SetPackedRatio("DPBTPressure" .. i, self.Pneumatic.BrakeCylinderPressure)
        end
    end

    self.AsyncInverter:TriggerInput("Speed", self.Speed)
    if validfB and validrB and not self.IgnoreEngine then
        local A = self.AsyncInverter.Torque
        local add = 1
        if math.abs(self:GetAngles().pitch) > 4 then add = math.min((math.abs(self:GetAngles().pitch) - 4) / 2, 1) end
        fB.MotorForce = (40000 + 5000 * (A < 0 and 1 or 0)) * add --35300
        fB.Reversed = self.BUV.Reverser < 0.5 --<
        rB.MotorForce = (40000 + 5000 * (A < 0 and 1 or 0)) * add --35300
        rB.Reversed = self.BUV.Reverser > 0.5 -->
        -- These corrections are required to beat source engine friction at very low values of motor power
        local P = math.max(0, 0.04449 + 1.06879 * math.abs(A) - 0.465729 * A ^ 2)
        if math.abs(A) > 0.4 then P = math.abs(A) end
        if math.abs(A) < 0.05 then P = 0 end
        if self.Speed < 10 then P = P * (1.0 + 0.6 * (10.0 - self.Speed) / 10.0) end
        rB.MotorPower = P * 0.5 * ((A > 0) and 1 or -1)
        fB.MotorPower = P * 0.5 * ((A > 0) and 1 or -1)
        -- Apply brakes
        fB.PneumaticBrakeForce = 50000.0
        fB.BrakeCylinderPressure = self.Pneumatic.BrakeCylinderPressure
        fB.ParkingBrakePressure = math.max(0, 3.8 - self.Pneumatic.ParkingBrakePressure) / 2
        fB.BrakeCylinderPressure_dPdT = -self.Pneumatic.BrakeCylinderPressure_dPdT
        fB.DisableContacts = self.BUV.Pant
        rB.PneumaticBrakeForce = 50000.0
        rB.BrakeCylinderPressure = self.Pneumatic.BrakeCylinderPressure
        rB.ParkingBrakePressure = math.max(0, 3.8 - self.Pneumatic.ParkingBrakePressure) / 2
        rB.BrakeCylinderPressure_dPdT = -self.Pneumatic.BrakeCylinderPressure_dPdT
        rB.DisableContacts = self.BUV.Pant
    end

    if (self.RV.KRRPosition ~= 0) ~= (self.EmergencyControls.Value > 0) then
        self.EmergencyControls:TriggerInput("Set", (self.RV.KRRPosition ~= 0) and 1 or 0)
    end
    if (self.RV.KRRPosition ~= 0) ~= (self.EmergencyDoors.Value > 0) then
        self.EmergencyDoors:TriggerInput("Set", (self.RV.KRRPosition ~= 0) and 1 or 0)
    end
    if (self.RV.KRRPosition ~= 0 and self.DoorClose.Value > 0) ~= (self.EmerCloseDoors.Value > 0) then
        self.EmerCloseDoors:TriggerInput("Set", (self.RV.KRRPosition ~= 0 and self.DoorClose.Value > 0) and 1 or 0)
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

    if not isfront then
        local ent = train:GetNW2Entity("TrainEntity")
        local s = train ~= ent.RearCouple and "Fence1" or "Fence"
        local a2 = train ~= ent.RearCouple and -1 or 1
        if not IsValid(self.Fence) and not IsValid(ent[s]) and ent:GetClass():find("76") and (ent:GetClass()[19] == "a" or ent:GetClass()[19] == "e") and (not ent:GetClass():find("760") or a2 == 1) then
            local pos1, pos2 = self:GetPos(), ent:GetPos()
            local b1, b2 = -self:GetForward(), -ent:GetForward() * a2
            local min = 3
            local pos
            for i = 475, 490, 0.001 do
                if (pos1 + b1 * i):Distance(pos2 + b2 * i) < min then
                    min = (pos1 + b1 * i):Distance(pos2 + b2 * i)
                    pos = pos1 + b1 * i
                end
            end

            pos = pos and self:WorldToLocal(pos) --or -a*480.15	
            self.Fence = self:CreateFence(Vector(pos, 0, 0), Angle(0, 0, 0), -1)
            ent[s] = self.Fence
            table.insert(ent.TrainEntities, ent[s])
            local bone1, bone2 = 0, 1
            local bonen1, bonen2 = self.Fence:GetPhysicsObjectNum(bone1), self.Fence:GetPhysicsObjectNum(bone2)
            --[[
			if (self:GetPos():Distance(bonen1:GetPos()) < self:GetPos():Distance(bonen2:GetPos())) then
				bone1,bone2 = 0,1
				bonen1,bonen2 = self.Fence:GetPhysicsObjectNum(bone1),self.Fence:GetPhysicsObjectNum(bone2)					
			end	]]
            bonen1:SetPos(ent:LocalToWorld(Vector(a2 == -1 and 464.37 or -464.07, 0, 0)))
            bonen2:SetPos(self:LocalToWorld(Vector(-464.07, 0, 0)))
            bonen1:SetAngles(ent:LocalToWorldAngles(Angle(0, 90 * (1 - a2), 90)))
            bonen2:SetAngles(self:LocalToWorldAngles(Angle(0, 0, -90)))
            constraint.Weld(self.Fence, self, bone2, 0, 0, 1, false)
            constraint.Weld(self.Fence, ent, bone1, 0, 0, 1, false)
        end
    end

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
    if not isfront and IsValid(self.Fence) then self.Fence:Remove() end
end

function ENT:OnButtonPress(button, ply)
    local pakUp = string.StartsWith(button, "PakUp")
    local pakDn = not pakUp and string.StartsWith(button, "PakDn")
    if pakUp or pakDn then
        local k = string.sub(button, 6)
        local cfg = self.PakToggles and self.PakToggles[k] or nil
        local r = cfg and self[k] or nil
        if r and r.Value then
            r:TriggerInput("Set", r.Value + (pakDn and 1 or -1), 0, #cfg.positions - 1)
            return
        end
    end

    if string.find(button, "PneumaticBrakeSet") then
        self.Pneumatic:TriggerInput("BrakeSet", tonumber(button:sub(-1, -1)))
        return
    end

    if button:find("SA") and button:find("k") then
        local butt1 = button:gsub("Toggle", "")
        local butt = button:gsub("kToggle", "")
        if self[butt1] and self[butt] and self[butt1].Value == 0 then self[butt]:TriggerInput("Set", 0) end
    end

    if button == "Attention" then
        if self.BARS.Ringing then
            self.AttentionBrake:TriggerInput("Set", 1)
        else
            self.PB:TriggerInput("Set", 1)
        end
    end

    if button == "IGLA23" then
        self.IGLA2:TriggerInput("Set", 1)
        self.IGLA3:TriggerInput("Set", 1)
    end

    if button == "K31Cap" then self.door_k31 = not self.door_k31 end
    if button == "Chair" and not (self.InstructorsSeat3 and IsValid(self.InstructorsSeat3) and IsValid(self.InstructorsSeat3:GetDriver()) or self.CabinDoorRight) then self.Chair = not self.Chair end
    if button == "PassengerDoor" and not self.door_pvz and not self.door_add_2 then --[[self:PlayOnce("door_cab_m_"..(self.PassengerDoor and "open" or "close"),"")]]
        self.PassengerDoor = not self.PassengerDoor
    end

    if button == "Door_pvz" and not self.CabinDoorLeft then --[[self:PlayOnce("door_cab_m_"..(self.door_pvz and "open" or "close"),"")]]
        self.door_pvz = not self.door_pvz
    end

    if button == "Door_add_1" and not self.CabinDoorRight then --[[self:PlayOnce("door_cab_m_"..(self.door_add_1 and "open" or "close"),"")]]
        self.door_add_1 = not self.door_add_1
    end

    if button == "Door_add_2" and not self.PassengerDoor and not self.door_pvz then --[[self:PlayOnce("door_cab_m_"..(self.door_add_2 and "open" or "close"),"")]]
        self.door_add_2 = not self.door_add_2
    end

    if button == "CabinDoorLeft" and (self.CabinDoorLeft or self.SF80F3.Value == 0 or self.Speed < 20) then --[[self:PlayOnce("door_cab_l_"..(self.CabinDoorLeft and "open" or "close"),"")]]
        self.CabinDoorLeft = not self.CabinDoorLeft
    end

    if button == "CabinDoorRight" and (self.CabinDoorRight or (self.SF80F3.Value == 0 or self.Speed < 20) and not (self.door_add_1 or self.Chair or self.InstructorsSeat3 and IsValid(self.InstructorsSeat3) and IsValid(self.InstructorsSeat3:GetDriver()))) then
        self.CabinDoorRight = not self.CabinDoorRight
        --self:PlayOnce("door_cab_r_"..(self.CabinDoorRight and "open" or "close"),"")
        if self.CabinDoorRight and self.InstructorsSeat3 and IsValid(self.InstructorsSeat3) then
            self.InstructorsSeat3:SetSolid(SOLID_NONE)
        elseif self.InstructorsSeat3 and IsValid(self.InstructorsSeat3) then
            self.InstructorsSeat3:SetSolid(SOLID_VPHYSICS)
        end
    end

    if button == "DoorLeft" then
        self.DoorSelectL:TriggerInput("Set", 1)
        self.DoorSelectR:TriggerInput("Set", 0)
        if self.EmergencyDoors.Value == 1 or self.DoorClose.Value == 0 then
            self.DoorLeft:TriggerInput("Set", 1)
        end
        if self.CAMS5 then
            self.CAMS5:TriggerInput("Set", 1)
        end
    end

    if button == "DoorRight" then
        self.DoorSelectL:TriggerInput("Set", 0)
        self.DoorSelectR:TriggerInput("Set", 1)
        if self.EmergencyDoors.Value == 1 or self.DoorClose.Value == 0 then
            self.DoorRight:TriggerInput("Set", 1)
        end
        if self.CAMS6 then
            self.CAMS6:TriggerInput("Set", 1)
        end
    end

    if button == "DoorClose" then
        -- if self.EmergencyDoors.Value == 1 then
        --     self.EmerCloseDoors:TriggerInput("Set", 1)
        -- else
        self.DoorClose:TriggerInput("Set", 1 - self.DoorClose.Value)
            -- self.EmerCloseDoors:TriggerInput("Set", 0)
        -- end
    end

    if button == "KRO+" then self.RV:TriggerInput("KROSet", self.RV.KROPosition + 1) end
    if button == "KRO-" then self.RV:TriggerInput("KROSet", self.RV.KROPosition - 1) end

    if button == "KRR+" then self.RV:TriggerInput("KRRSet", self.RV.KRRPosition + 1) end
    if button == "KRR-" then self.RV:TriggerInput("KRRSet", self.RV.KRRPosition - 1) end

    if button:find("KRO") or button:find("KRR") then self.WrenchMode = self.RV.KROPosition ~= 0 and 1 or (self.RV.KRRPosition ~= 0 and 2) or 0 end
    if button == "Micro" then
        self.Buik_MicLine:TriggerInput("Set", 1)
        self.Buik_MicBtn:TriggerInput("Set", 1)
    end

    if button == "ALSToggle" then
        if self.ALS.Value * self.PpzUpi.Value == 1 then --выключается
            if self.ALSVal == 2 then
                self.ALSVal = 0
            else
                self.ALSVal = self.ALSVal + 1
            end
        end
    end

    if button == "EmergencyBrakeValveToggle" and (self.K29.Value == 1 or self.Pneumatic.V4 and self:ReadTrainWire(27) == 1) and not self.Pneumatic.RVTBTimer and self.Pneumatic.BrakeLinePressure > 2 then
        --self:PlayOnce("valve_brake_open","",1.1,1)
        self:SetPackedRatio("EmerValve", CurTime() + 3.8)
    end

    if button:find("RVS_") then
        button = button:gsub("RVS_", ""):gsub("Set", "")
        local num = tonumber(button)
        if num then self.RVS.RVSVal = self.RVS.RVSVal + 1 end
    end

    if string.StartsWith(button, "SalonDoor") then
        local idx = tonumber(string.sub(button, 10))
        if idx and IsValid(ply) and self.BUD then
            self.BUD:OpenDoorMenu(ply, idx)
        end
    end

    --[[
    if button == "WrenchNone" then
        if self.WrenchMode ~= 0 then
            if self.WrenchMode == 2 and self.RV.KRRPosition == 0 then
                self:PlayOnce("krr_out","cabin",1,1)
                RunConsoleCommand("say",ply:GetName().." stop drive with KRU!")
                self.WrenchMode = 0
            elseif self.WrenchMode == 1 and self.RV.KROPosition == 0 then
                self:PlayOnce("kro_out","cabin",1,1)
                self.WrenchMode = 0
            end
        end
    end]]
end

function ENT:OnButtonRelease(button, ply)
    if button == "Attention" then
        self.AttentionBrake:TriggerInput("Set", 0)
        self.PB:TriggerInput("Set", 0)
    end

    if button:find("RVS_") then
        button = button:gsub("RVS_", ""):gsub("Set", "")
        local num = tonumber(button)
        if num then self.RVS.RVSVal = self.RVS.RVSVal - 1 end
    end

    if button == "DoorLeft" then
        self.DoorLeft:TriggerInput("Set", 0)
        if self.CAMS5 then
            self.CAMS5:TriggerInput("Set", 0)
        end
    end
    if button == "DoorRight" then
        self.DoorRight:TriggerInput("Set", 0)
        if self.CAMS6 then
            self.CAMS6:TriggerInput("Set", 0)
        end
    end
    -- if button == "DoorClose" then self.EmerCloseDoors:TriggerInput("Set", 0) end
    if button == "Micro" then
        self.Buik_MicLine:TriggerInput("Set", 0)
        self.Buik_MicBtn:TriggerInput("Set", 0)
    end

    if button == "EmergencyBrakeValveToggle" and (self.K29.Value == 1 or self.Pneumatic.V4 and self:ReadTrainWire(27) == 1) and not self.Pneumatic.RVTBTimer then self:PlayOnce("valve_brake_close", "", 1, 1) end
end
