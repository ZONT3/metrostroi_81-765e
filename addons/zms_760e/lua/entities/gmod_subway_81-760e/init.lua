--------------------------------------------------------------------------------
-- 81-760Э «Чурá» by ZONT_ a.k.a. enabled person
-- Based on code by Cricket, Hell et al.
--------------------------------------------------------------------------------
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.BogeyDistance = 650
ENT.SyncTable = {
    "EnableBVEmer", "Ticker", "KAH", "KAHk", "ALS", "ALSk", "ABESD", "ABESDk", "SD", "SDk", "FDepot", "PassScheme", "EnableBV",
    "DisableBV", "Ring", "R_Program2", "R_Announcer", "R_Line", "R_Micro", "R_Emer", "R_Program1", "R_Program11", "R_ChangeRoute",
    "R_ToBack", "DoorSelectL", "DoorSelectR", "DoorBlock", "EmerBrakeAdd", "EmerBrakeRelease", "EmerBrake", "DoorClose", "AttentionMessage",
    "Attention", "AttentionBrake", "EmergencyBrake", "Pr", "OtklR", "GlassHeating", "Washer", "SC",
    "Stand", "EmergencyCompressor", "EmergencyCompressor2", "EmergencyControls", "EmergencyControlsK", "Wiper", "DoorLeft", "AccelRate", "HornB", "HornC", "DoorRight",
    "AutoDrive", "Micro", "Vent1", "Vent2", "Vent", "PassLight", "CabLight", "HeadlightsSwitch", "ParkingBrake",
    "BBER", "BBE", "Compressor", "CabLightStrength", "AppLights1", "AppLights2", "Battery", "MfduF1", "MfduF2", "MfduF3",
    "MfduF4", "Mfdu1", "Mfdu4", "Mfdu7", "Mfdu2", "Mfdu5", "Mfdu8", "Mfdu0", "Mfdu3", "Mfdu6", "Mfdu9", "MfduF5",
    "MfduF6", "MfduF7", "MfduF8", "MfduF9", "K29", "UAVA", "K9", "K31", "EmerX1", "EmerX2", "EmerCloseDoors", "EmergencyDoors",
    "R_ASNPMenu", "R_ASNPUp", "R_ASNPDown", "R_ASNPOn", "VentHeatMode", "PowerOn", "PowerOff", "RearBrakeLineIsolation",
    "RearTrainLineIsolation", "FrontBrakeLineIsolation", "FrontTrainLineIsolation", "PB", "GV", "K23", "EmergencyBrakeValve",
    "CAMS1", "CAMS2", "CAMS3", "CAMS4", "CAMS5", "CAMS6", "CAMS7", "CAMS8", "CAMS9", "CAMS10",
    "IGLA1", "IGLA2", "IGLA3", "IGLA4",
    "MfduHelp", "MfduKontr", "MfduTv", "MfduTv1", "MfduTv2",
    "Buik_EMsg1", "Buik_EMsg2", "Buik_Unused1", "Buik_Mode", "Buik_Path", "Buik_Return", "Buik_Down", "Buik_Up", "Buik_MicLine", "Buik_MicBtn", "Buik_Asotp", "Buik_Ik",
    "BatteryCharge"
}

if not ENT.PpzToggles then print("ACHTUNG! PIZDEC!") end
for _, cfg in ipairs(ENT.PpzToggles or {}) do
    table.insert(ENT.SyncTable, cfg.relayName)
end

if not ENT.PvzToggles then print("ACHTUNG! PIZDEC!") end
for _, cfg in ipairs(ENT.PvzToggles or {}) do
    table.insert(ENT.SyncTable, cfg.relayName)
end

if not ENT.PakToggles then print("ACHTUNG! PIZDEC!") end
for k, cfg in pairs(ENT.PakToggles or {}) do
    if #cfg.positions == 2 then
        table.insert(ENT.SyncTable, k)
    end
end

for idx = 1, 8 do
    table.insert(ENT.SyncTable, "DoorManualBlock" .. idx)
end

--------------------------------------------------------------------------------
function ENT:Initialize()
    self.Plombs = {
        ABESD = {true, "ABESDk"},
        ABESDk = true,
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
    self:SetModel("models/metrostroi_train/81-760e/81_760e_body.mdl")
    self.BaseClass.Initialize(self)
    self:SetPos(self:GetPos() + Vector(0, 0, 140))
    -- Create seat entities
    self.DriverSeat = self:CreateSeat("driver", Vector(461, 14, -27)) --Vector(427,17.5,-35))--  -- +Vector(21,7,-10)) 447.8   455            Vector(455,18.1,-35)
    self.InstructorsSeat = self:CreateSeat("instructor", Vector(435.8, -12, -40), Angle(0, 90, 0), "models/vehicles/prisoner_pod_inner.mdl")
    self.InstructorsSeat2 = self:CreateSeat("instructor", Vector(435.8, 45, -40), Angle(0, 90, 0), "models/vehicles/prisoner_pod_inner.mdl")
    self.InstructorsSeat3 = self:CreateSeat("instructor", Vector(425, -43, -37))
    self.InstructorsSeat4 = self:CreateSeat("instructor", Vector(462, -35, -40), Angle(0, 90, 0), "models/vehicles/prisoner_pod_inner.mdl")
    -- Hide seats
    self.DriverSeat:SetRenderMode(RENDERMODE_TRANSALPHA)
    self.DriverSeat:SetColor(Color(0, 0, 0, 0))
    self.InstructorsSeat:SetRenderMode(RENDERMODE_TRANSALPHA)
    self.InstructorsSeat:SetColor(Color(0, 0, 0, 0))
    self.InstructorsSeat2:SetRenderMode(RENDERMODE_TRANSALPHA)
    self.InstructorsSeat2:SetColor(Color(0, 0, 0, 0))
    self.InstructorsSeat3:SetRenderMode(RENDERMODE_TRANSALPHA)
    self.InstructorsSeat3:SetColor(Color(0, 0, 0, 0))
    self.InstructorsSeat4:SetRenderMode(RENDERMODE_TRANSALPHA)
    self.InstructorsSeat4:SetColor(Color(0, 0, 0, 0))
    self.LightSensor = self:AddLightSensor(Vector(460, 0, -130), Angle(0, 90, 0))
    -- Create bogeys
    self.FrontBogey = self:CreateBogey(Vector(297 + 20.8, 0, -70), Angle(0, 180, 0), true, "760F")
    self.RearBogey = self:CreateBogey(Vector(-338 + 20.8, 0, -70), Angle(0, 0, 0), false, "760")
    self.FrontBogey:SetNWBool("Async", true)
    self.RearBogey:SetNWBool("Async", true)
    self.FrontBogey:SetNWInt("MotorSoundType", Metrostroi.Version > 1537278077 and 3 or 2)
    self.RearBogey:SetNWInt("MotorSoundType", Metrostroi.Version > 1537278077 and 3 or 2)
    self.FrontBogey:SetNWFloat("SqualPitch", 0.75)
    self.RearBogey:SetNWFloat("SqualPitch", 0.75)
    self.FrontCouple = self:CreateCouple(Vector(442.2 + 30, 0, -68), Angle(0, 0, 0), true, "722")
    self.RearCouple = self:CreateCouple(Vector(-439 + 20.8, 0, -68), Angle(0, 180, 0), false, "763")
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
        1) -- nocollide
    self.FrontCouple.CouplingPointOffset = Vector(65, 0, 0)
    self.FrontCouple.SnakePos = Vector(65.1, 1, -4.9)
    self:SetNW2Entity("FrontBogey", self.FrontBogey)
    self:SetNW2Entity("RearBogey", self.RearBogey)
    self:SetNW2Entity("FrontCouple", self.FrontCouple)
    self:SetNW2Entity("RearCouple", self.RearCouple)

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
        [KEY_9] = "KRO-",
        [KEY_0] = "KRO+",
        [KEY_A] = "DoorLeft",
        [KEY_D] = "DoorRight",
        [KEY_V] = "DoorClose",
        [KEY_G] = "EnableBVSet",
        [KEY_SPACE] = "PBSet",
        [KEY_EQUAL] = "R_Program1Set",
        [KEY_MINUS] = "Micro",
        [KEY_B] = "AttentionMessageSet",
        [KEY_N] = "AttentionBrakeSet",
        [KEY_M] = "AttentionSet",
        [KEY_H] = "PrToggle",
        [KEY_LSHIFT] = {
            [KEY_S] = "KV765Set7",
            [KEY_SPACE] = "AttentionBrakeSet",
            [KEY_V] = "EmergencyDoorsToggle",
            [KEY_9] = "KRR-",
            [KEY_0] = "KRR+",
            [KEY_G] = "DisableBVSet",
            [KEY_2] = "RingSet",
            [KEY_L] = "HornBSet",
            [KEY_A] = "AutoDriveToggle",
            [KEY_MINUS] = "Buik_DownSet",
            [KEY_EQUAL] = "Buik_UpSet",
        },
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

    self.LeftDoorPositions = self.LeftDoorPositionsBAK
    self.RightDoorPositions = self.RightDoorPositionsBAK

    -- Cross connections in train wires
    self.TrainWireCrossConnections = {
        [4] = 3, -- Orientation F<->B
        [13] = 12, -- Reverser F<->B
        [38] = 37, -- Doors L<->R
    }

    self.Lights = {
        [1] = {
            "light",
            Vector(515, -56, 0),
            Angle(0, 0, 90),
            Color(200, 240, 255),
            brightness = 0.5,
            scale = 2.5
        },
        [2] = {
            "light",
            Vector(515, 56, 0),
            Angle(0, 0, 90),
            Color(200, 240, 255),
            brightness = 0.5,
            scale = 2.5
        },
        [3] = {
            "light",
            Vector(508, -52, 34),
            Angle(0, 0, 90),
            Color(255, 50, 50),
            brightness = 0.2,
            scale = 4,
            texture = "sprites/light_glow02.vmt"
        },
        [4] = {
            "light",
            Vector(508, 52, 34),
            Angle(0, 0, 90),
            Color(255, 50, 50),
            brightness = 0.2,
            scale = 4,
            texture = "sprites/light_glow02.vmt"
        },
        [10] = {
            "dynamiclight",
            Vector(495, 13, 25),
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
        {
            Pos = Vector(428, -52, -60),
            Radius = 10,
            ID = "CraneNM"
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

    self.PassengerDoor = false
    self.CabinDoorLeft = false
    self.CabinDoorRight = false
    self.CabinWindowLeft = false
    self.CabinWindowRight = false
    self.Chair = false
    self.SpeedTimer = CurTime()
    self.stationDoorSideLeft = false
    self.WrenchMode = 0
    self.ALSVal = 0
    self.Closet1Val = false
    self.DoorK31 = false

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

-- if map not supported
-- TODO add "FL mode"
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

function ENT:TriggerLightSensor(coil, plate)
    self.ProstKos:TriggerSensor(plate)
end

function ENT:TrainSpawnerUpdate()
    if self.InitializeSounds then
        self:InitializeSounds()
    end

    self:SetNW2Int("BNT:ScreenFps", self:GetNW2Int("BntFps", 2) == 2 and 60 or math.random(9, 13))
    self:UpdateTextures()
end

function ENT:Think()
    local retVal = self.BaseClass.Think(self)
    local Panel = self.Panel
    local powerUpi = self.Electric.UPIPower > 0
    local powerBs = self.Electric.BSPowered > 0
    local powerReserve = self.Electric.PowerReserve > 0
    if self.Electric.Battery80V < 62 then self.Electric.Power = nil end
    local state = math.abs(self.AsyncInverter.InverterFrequency / (11 + self.AsyncInverter.State * 5))
    self:SetPackedRatio("asynccurrent", math.Clamp(state * (state + self.AsyncInverter.State / 1), 0, 1) * math.Clamp(self.Speed / 6, 0, 1))
    self:SetPackedRatio("asyncstate", math.Clamp(self.AsyncInverter.State / 0.2 * math.abs(self.AsyncInverter.Current) / 100, 0, 1))
    self:SetPackedRatio("chopper", math.Clamp(self.Electric.Chopper > 0 and self.Electric.Iexit / 100 or 0, 0, 1))
    self:SetPackedRatio("Speed", self.Speed)
    self:SetPackedRatio("Controller", self.KV765.VisualPosition)
    self:SetPackedRatio("KRO", (self.RV.KROPosition + 1) / 2)
    self:SetPackedRatio("KRR", (self.RV.KRRPosition + 1) / 2)
    self:SetPackedRatio("VentCondMode", self.VentCondMode.Value / 3)
    self:SetPackedRatio("VentStrengthMode", self.VentStrengthMode.Value / 3)
    self:SetPackedBool("PowerOnLamp", Panel.PowerOnl > 0)
    self:SetPackedBool("PowerOffLamp", Panel.PowerOffl > 0)
    self:SetPackedBool("BatteryChargeLamp", Panel.BatteryChargel > 0)

    local bogeyF, bogeyR = self.FrontBogey, self.RearBogey
    local fbValid, rbValid = IsValid(bogeyF), IsValid(bogeyR)
    for i = 1, 4 do
        self:SetPackedBool("TR" .. i, self.BUV.Pant or i <= 2 and fbValid and bogeyF.DisableContactsManual or i > 2 and rbValid and bogeyR.DisableContactsManual)
    end

    for k, cfg in pairs(self.PakToggles or {}) do
        local r = self[k]
        if r and r.Value then
            self:SetNW2Int(k, r.Value)
        end
    end

    self:SetPackedBool("ASHook", self.AsHookTimer and CurTime() < self.AsHookTimer)
    if self.Pneumatic.EmergencyValve and not self.AsHookTimer then
        self.AsHookTimer = CurTime() + 1
    elseif not self.Pneumatic.EmergencyValve and self.AsHookTimer and CurTime() >= self.AsHookTimer then
        self.AsHookTimer = nil
    end

    self:SetPackedBool("WorkBeep", powerBs)
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
    self:SetPackedBool("BUKPRing", powerUpi and self.BUKP.State == 5 and self.BUKP.ErrorRinging)
    self:SetPackedBool("CallRing", powerUpi and self.BUKP.State == 5 and self.BUKP.CallRing)
    self:SetPackedBool("RingEnabled", powerUpi and self.BUKP.Ring)
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
    self:SetLightPower(3, Panel.RedLights > 0, 0.8)
    self:SetLightPower(4, Panel.RedLights > 0, 0.8)

    local cablight = Panel.CabLight == 1 and 0.25 or Panel.CabLight == 2 and 0.8 or 0
    local cabl = cablight > 0
    self:SetLightPower(10, cabl, cablight)
    self:SetPackedBool("CabinEnabledEmer", cabl)
    self:SetPackedBool("CabinEnabledFull", cablight > 0.25)

    local passlight = Panel.SalonLighting1 * 0.25 + Panel.SalonLighting2 * 0.75
    local passl = passlight > 0
    self:SetLightPower(11, passl, passlight)
    self:SetLightPower(12, passl, passlight)
    self:SetLightPower(13, passl, passlight)
    self:SetPackedBool("SalonLighting1", Panel.SalonLighting1 > 0)
    self:SetPackedBool("SalonLighting2", Panel.SalonLighting2 > 0)

    for idx = 1, 8 do
        self:SetNW2Bool("DoorButtonLed" .. idx, self.Electric.BSPowered > 0 and self.BUD.OpenButton[idx] and true)
    end

    self:SetNW2Bool("MfduLamp", powerUpi and self.BUKP.State ~= 0)
    self:SetNW2Bool("DoorsClosed", powerReserve and self.BUKP.DoorClosed > 0)
    self:SetNW2Bool("HVoltage", powerReserve and not self.BUKP.HVBad)
    self:SetNW2Bool("DoorLeftLamp", Panel.DoorLeftL > 0)
    self:SetNW2Bool("DoorRightLamp", Panel.DoorRightL > 0)
    self:SetNW2Bool("EmerBrakeWork", Panel.EmerBrakeL > 0)
    self:SetNW2Bool("EmerXod", Panel.EmerXodL > 0)
    self:SetNW2Bool("KAHLamp", Panel.KAHl > 0)
    self:SetNW2Bool("ALSLamp", Panel.ALSl > 0)
    self:SetNW2Bool("PrLamp", Panel.PRl > 0)
    self:SetNW2Bool("AutoDriveLamp", Panel.AutoDriveLamp > 0 and self.sys_Autodrive.State > 0)
    self:SetNW2Bool("OtklRLamp", Panel.OtklRl > 0)
    self:SetNW2Bool("R_LineLamp", Panel.R_Linel > 0)
    self:SetNW2Bool("R_ChangeRouteLamp", Panel.R_ChangeRoutel > 0)
    self:SetNW2Bool("WasherLamp", Panel.Washerl > 0)
    self:SetNW2Bool("WiperLamp", Panel.Wiperl > 0)
    self:SetNW2Bool("WiperPower", Panel.WiperPower > 0)
    self:SetNW2Bool("AccelRateLamp", powerUpi and self.BUKP.Slope)
    self:SetNW2Bool("EmergencyControlsLamp", Panel.EmergencyControlsl > 0)
    self:SetNW2Bool("EmergencyDoorsLamp", Panel.EmergencyDoorsl > 0)
    self:SetNW2Bool("GlassHeatingLamp", Panel.GlassHeatingl > 0)
    self:SetNW2Bool("DoorCloseLamp", Panel.DoorCloseL > 0)
    self:SetNW2Bool("DoorBlockLamp", Panel.DoorBlockL > 0)
    self:SetPackedRatio("CabinLight", self.CabinLight.Value / 2)
    self:SetPackedRatio("LV", Panel.LV / 150)
    self:SetPackedRatio("HV", (self.SF42F2.Value * self.Electric.BSPowered > 0.5 and self.Electric.Main750V or 0) / 1000)
    self:SetPackedRatio("IVO", 0.5 + self.BUV.IVO / 150)
    self:SetPackedBool("PassengerDoor", self.PassengerDoor)
    self:SetPackedBool("CabinDoorLeft", self.CabinDoorLeft)
    self:SetPackedBool("CabinDoorRight", self.CabinDoorRight)
    self:SetPackedBool("CabinWindowLeft", self.CabinWindowLeft)
    self:SetPackedBool("CabinWindowRight", self.CabinWindowRight)
    self:SetPackedBool("CabinDoorRightLimit", self.Closet1Val or self.Chair or self.InstructorsSeat3 and IsValid(self.InstructorsSeat3) and IsValid(self.InstructorsSeat3:GetDriver()))
    self:SetPackedBool("Closet1Val", self.Closet1Val)
    self:SetPackedBool("DoorK31", self.DoorK31)
    self:SetPackedBool("CabChairAdd", self.Chair or self.InstructorsSeat3 and IsValid(self.InstructorsSeat3) and IsValid(self.InstructorsSeat3:GetDriver()))
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
        if i == 1 or i == 4 or i == 5 or i == 8 then
            self:SetPackedBool("BC" .. i, math.max(self.Pneumatic.BrakeCylinderPressure, (i < 5 and (fbValid and bogeyF.DisableParking and 0 or 1) or i > 4 and (rbValid and bogeyR.DisableParking and 0 or 1)) * (3.8 - self.Pneumatic.ParkingBrakePressure) / 2) <= 0.1)
            self:SetPackedRatio("DPBTPressure" .. i, math.max(self.Pneumatic.BrakeCylinderPressure, (i < 5 and (fbValid and bogeyF.DisableParking and 0 or 1) or i > 4 and (rbValid and bogeyR.DisableParking and 0 or 1)) * (3.8 - self.Pneumatic.ParkingBrakePressure) / 2))
        else
            self:SetPackedBool("BC" .. i, self.Pneumatic.BrakeCylinderPressure <= 0.1)
            self:SetPackedRatio("DPBTPressure" .. i, self.Pneumatic.BrakeCylinderPressure)
        end
    end

    self.AsyncInverter:TriggerInput("Speed", self.Speed)
    if fbValid and rbValid and not self.IgnoreEngine then
        local A = self.AsyncInverter.Torque
        local add = 1
        if math.abs(self:GetAngles().pitch) > 4 then add = math.min((math.abs(self:GetAngles().pitch) - 4) / 2, 1) end
        bogeyF.MotorForce = (40000 + 5000 * (A < 0 and 1 or 0)) * add
        bogeyF.Reversed = self.BUV.Reverser < 0.5 --<
        bogeyR.MotorForce = (40000 + 5000 * (A < 0 and 1 or 0)) * add
        bogeyR.Reversed = self.BUV.Reverser > 0.5 -->

        -- These corrections are required to beat source engine friction at very low values of motor powerUpi
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

function ENT:FenceConnectable(other, headAcceptable)
    local compatible = other:GetClass():find("76") and other:GetClass()[19] == "e" or string.match(other:GetClass(), "76[567]")
    if headAcceptable then return compatible end
    local lit = other:GetClass()[18]
    return compatible and lit ~= "5" and lit ~= "0"
end

function ENT:CreateFence(other)
    local otherWag = other:GetNW2Entity("TrainEntity")
    local front = other ~= otherWag.RearCouple
    local otherSide = front and "FenceF" or "FenceR"
    if not (IsValid(otherWag) and IsValid(otherWag.RearCouple) and IsValid(otherWag.FrontCouple)) then return end
    if not IsValid(self.FenceR) and self:FenceConnectable(otherWag, not front) then
        local k = front and -1 or 1
        local pos1, pos2 = self:GetPos(), otherWag:GetPos()
        local fwd1, fwd2 = -self:GetForward(), -otherWag:GetForward() * k
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
        bonen1:SetPos(otherWag:LocalToWorld(Vector(front and 464.37 or -464.07, 0, 0)))
        bonen2:SetPos(self:LocalToWorld(Vector(-464.07, 0, 0)))
        bonen1:SetAngles(otherWag:LocalToWorldAngles(Angle(0, front and 180 or 0, 90)))
        bonen2:SetAngles(self:LocalToWorldAngles(Angle(0, 0, -90)))
        constraint.Weld(ent, self, bone2, 0, 0, true)
        constraint.Weld(ent, otherWag, bone1, 0, 0, true)
        otherWag[otherSide] = ent
        self.FenceR = ent
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

    if not isfront then self:CreateFence(train) end

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

    if not isfront and IsValid(self.FenceR) then
        self.FenceR:Remove()
    end
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

    if button == "K31Cap" then self.DoorK31 = not self.DoorK31 end
    if button == "Chair" and not (self.InstructorsSeat3 and IsValid(self.InstructorsSeat3) and IsValid(self.InstructorsSeat3:GetDriver())) then self.Chair = not self.Chair end
    if button == "PassengerDoor" then
        self.PassengerDoor = not self.PassengerDoor
    end

    if button == "Closet1" then --[[self:PlayOnce("door_cab_m_"..(self.Closet1Val and "open" or "close"),"")]]
        self.Closet1Val = not self.Closet1Val
    end


    if button == "CabinDoorLeft" and (self.CabinDoorLeft or self.SF80F3.Value == 0 or self.Speed < 20) then --[[self:PlayOnce("door_cab_l_"..(self.CabinDoorLeft and "open" or "close"),"")]]
        self.CabinDoorLeft = not self.CabinDoorLeft
    end

    if button == "CabinDoorRight" and (self.CabinDoorRight or (self.SF80F3.Value == 0 or self.Speed < 20)) then
        self.CabinDoorRight = not self.CabinDoorRight
        if self.CabinDoorRight and self.InstructorsSeat3 and IsValid(self.InstructorsSeat3) then
            self.InstructorsSeat3:SetSolid(SOLID_NONE)
        elseif self.InstructorsSeat3 and IsValid(self.InstructorsSeat3) then
            self.InstructorsSeat3:SetSolid(SOLID_VPHYSICS)
        end
    end

    if button == "CabinWindowLeft" then
        self.CabinWindowLeft = not self.CabinWindowLeft
    end
    if button == "CabinWindowRight" then
        self.CabinWindowRight = not self.CabinWindowRight
    end

    if button == "CraneNM" then
        self.FrontTrainLineIsolation:TriggerInput("Set", self.FrontTrainLineIsolation.Value > 0.5 and 0 or 1)
    end

    if button == "DoorLeft" then
        if self.DoorSelectL.Value == 1 or self.EmergencyDoors.Value == 1 --[[or self.DoorClose.Value == 0]] then
            self.DoorLeft:TriggerInput("Set", 1)
        end
        if self.CAMS5 then
            self.CAMS5:TriggerInput("Set", 1)
        end
        self.DoorSelectL:TriggerInput("Set", 1)
        self.DoorSelectR:TriggerInput("Set", 0)
    end

    if button == "DoorRight" then
        if self.DoorSelectR.Value == 1 or self.EmergencyDoors.Value == 1 --[[or self.DoorClose.Value == 0]] then
            self.DoorRight:TriggerInput("Set", 1)
        end
        if self.CAMS6 then
            self.CAMS6:TriggerInput("Set", 1)
        end
        self.DoorSelectL:TriggerInput("Set", 0)
        self.DoorSelectR:TriggerInput("Set", 1)
    end

    if button == "DoorClose" then
        self.DoorClose:TriggerInput("Set", 1 - self.DoorClose.Value)
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
        if self.ALS.Value * self.PpzUpi.Value == 1 then
            if self.ALSVal == 2 then
                self.ALSVal = 0
            else
                self.ALSVal = self.ALSVal + 1
            end
        end
    end

    if button == "EmergencyBrakeValveToggle" and (self.K29.Value == 1 or self.Pneumatic.V4 and self:ReadTrainWire(27) == 1) and not self.Pneumatic.RVTBTimer and self.Pneumatic.BrakeLinePressure > 2 then
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
    if button == "Micro" then
        self.Buik_MicLine:TriggerInput("Set", 0)
        self.Buik_MicBtn:TriggerInput("Set", 0)
    end

    if button == "EmergencyBrakeValveToggle" and (self.K29.Value == 1 or self.Pneumatic.V4 and self:ReadTrainWire(27) == 1) and not self.Pneumatic.RVTBTimer then self:PlayOnce("valve_brake_close", "", 1, 1) end
end
