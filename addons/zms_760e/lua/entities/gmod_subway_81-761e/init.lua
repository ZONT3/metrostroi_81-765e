AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.BogeyDistance = 650 -- Needed for gm trainspawner
ENT.SyncTable = {
    "SF31","SF32","SF33","SF34","SF36","SF37","SF38","SF39","SF40","SF41","SF42","SF57","SF80F9",
    "SF43","SF44","SF45","SF46","SF47","SF48","SF49","SF50","SF51","SF52","SF53","SF54","SF55","SF56","SF58","SF59",
    
        "RearBrakeLineIsolation","RearTrainLineIsolation",
        "FrontBrakeLineIsolation","FrontTrainLineIsolation",
    "GV","K31","Battery","PowerOn","K23","EmergencyBrakeValve",
}
--------------------------------------------------------------------------------
function ENT:Initialize()
    -- Set model and initialize
    self:SetModel("models/metrostroi_train/81-760/81_761a_body.mdl")
    self.BaseClass.Initialize(self)
    self:SetPos(self:GetPos() + Vector(0,0,140))

    -- Create seat entities
    --self.DriverSeat = self:CreateSeat("instructor",Vector(450,11,-35))

    -- Hide seats
    --self.DriverSeat:SetRenderMode(RENDERMODE_TRANSALPHA)
    --self.DriverSeat:SetColor(Color(0,0,0,0))

    -- Create bogeys
    self.FrontBogey = self:CreateBogey(Vector(338-20.8,0,-70),Angle(0,180,0),true,"760")--z=-90
    self.RearBogey = self:CreateBogey(Vector(-338+20.8,0,-70),Angle(0,0,0),false,"760")
    
    self.FrontBogey:SetNWBool("Async",true)
    self.RearBogey:SetNWBool("Async",true)
    self.FrontBogey:SetNWInt("MotorSoundType",2)
    self.RearBogey:SetNWInt("MotorSoundType",2)     	
    self.FrontBogey:SetNWFloat("SqualPitch",0.75)
    self.RearBogey:SetNWFloat("SqualPitch",0.75)
    --self.FrontBogey:SetNWBool("DisableEngines",true)
    --self.RearBogey:SetNWBool("DisableEngines",true)
    --self.FrontBogey.DisableSound = 1
    --self.RearBogey.DisableSound = 1	
    
    --if Metrostroi.BogeyOldMap then
    --else
        self.FrontCouple = self:CreateCouple(Vector( 437-20.8,0,-68),Angle(0,0,0),true,"763")
        self.RearCouple  = self:CreateCouple(Vector(-437+20.8,0,-68),Angle(0,180,0),false,"763")
    --end
    
    self:SetNW2Entity("FrontBogey",self.FrontBogey)
    self:SetNW2Entity("RearBogey",self.RearBogey)
    self:SetNW2Entity("FrontCouple",self.FrontCouple)
    self:SetNW2Entity("RearCouple",self.RearCouple)	
    
    -- Initialize key mapping
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
    -- Cross connections in train wires
    self.TrainWireCrossConnections = {
        [4] = 3, -- Orientation F<->B
        [13] = 12, -- Reverser F<->B
        [38] = 37, -- Doors L<->R
    }

    self.Lights = {
        -- Interior
        --[11] = { "dynamiclight",	Vector( 200, 0, 10), Angle(0,0,0), Color(255,175,50), brightness = 3, distance = 400 , fov=180,farz = 128
        --[[
        [15] = { "dynamiclight",	Vector(-330, 0, 10), Angle(0,0,0), Color(238,238,197), brightness = 0.5, distance = 500, fov=180,farz = 128 },
        [16] = { "dynamiclight",	Vector(-0, 0, 10), Angle(0,0,0), Color(238,238,197), brightness = 0.5, distance = 500, fov=180,farz = 128 },
        [17] = { "dynamiclight",	Vector( 330, 0, 10), Angle(0,0,0), Color(238,238,197), brightness = 0.5, distance = 500, fov=180,farz = 128 },]]
        -- Interior
        [11] = { "dynamiclight",    Vector( 285, 0, 10), Angle(0,0,0), Color(230,230,255), brightness = 2, distance = 650,fov=180,farz = 128},
        [12] = { "dynamiclight",    Vector(  -5, 0, 10), Angle(0,0,0), Color(230,230,255), brightness = 2, distance = 650,fov=180,farz = 128},
        [13] = { "dynamiclight",    Vector(-295, 0, 10), Angle(0,0,0), Color(230,230,255), brightness = 2, distance = 650,fov=180,farz = 128},	
        
        --[13] = { "dynamiclight",	Vector(-200, 0, 10), Angle(0,0,0), Color(255,175,50), brightness = 3, distance = 400 , fov=180,farz = 128 },
        --[11] = { "dynamiclight",	Vector( 100, 0, 10), Angle(0,0,0), Color(255,175,50), brightness = 3, distance = 400 , fov=180,farz = 128 },
        --[12] = { "dynamiclight",	Vector( 100, 0, 10), Angle(0,0,0), Color(255,175,50), brightness = 3, distance = 400, fov=180,farz = 128 },
    }
    self.STL = self.STL or true
    self.BKL = self.BKL or false
    self:SetNW2Bool("STL",self.STL)
    self:SetNW2Bool("BKL",self.BKL)	
    
    self.CouchCapL = false
    self.CouchCapR = false
    self.door_k31 = false

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

    --for k in pairs(self:GetMaterials()) do self:SetSubMaterial(k-1,"") end
    --self:SetSubMaterial(0,"models/metrostroi_train/81-760/hull_baklajan")	

    self:SetNW2String("Texture","760A")
    self:SetNW2String("texture","760A")	
    
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

function ENT:CreateFence(pos,ang,a)
    local ent = ents.Create("prop_ragdoll")--ents.Create("prop_physics")
    if not IsValid(ent) then return end
    local pos = pos or Vector(0,0,0)
    local ang = ang or Angle(0,0,0)
    ent:SetPos(self:LocalToWorld(pos))
    ent:SetModel("models/metrostroi_train/81-760/81_760_fence_corrugated.mdl")--ent:SetModel("models/sligwolf/blue-x12/bluex12_train_socket.mdl")
    ent:SetAngles(self:GetAngles())
    ent:Spawn()
    --ent:SetParent(self)
    ent:SetOwner(self:GetOwner())
    ent:SetCollisionGroup( COLLISION_GROUP_WORLD )
    
    -- Assign ownership
    if CPPI and IsValid(self:CPPIGetOwner()) then ent:CPPISetOwner(self:CPPIGetOwner()) end	
    
    --constraint.Weld(ent,self,0,0,0,1,false)	
    ent:GetPhysicsObject():SetMass(1)
    
    -- Add to cleanup list
    table.insert(self.TrainEntities,ent)
    return ent
end

function ENT:TrainSpawnerUpdate()
    --for k in pairs(self:GetMaterials()) do self:SetSubMaterial(k-1,"") end
    --self:SetSubMaterial(0,"models/metrostroi_train/81-760/hull_baklajan")
    self:SetNW2Bool("STL",self.STL)
    self:SetNW2Bool("BKL",self.BKL)	

    -- for i=1,4 do
    --     self:SetNW2Int("DoorRBR"..i,1)--math.random(0,1))				
    --     self:SetNW2Int("DoorLBR"..i,1)--math.random(0,1))				
    -- end	

    --self.CISConfig = 0
    local Announcer = {}
    for k,v in pairs(Metrostroi.AnnouncementsASNP or {}) do if not v.riu then Announcer[k] = v.name or k end end
    if #Metrostroi.CISConfig == 1 then
        self.CISConfig = 1
    else
        self.CISConfig = self:GetNW2Int("CISConfig",1)
    end
    --[[
    for k,v in pairs(Metrostroi.CISConfig) do
        for k2,v2 in pairs(Announcer) do
            if v2 == v.name then
                self.CISConfig = k
            end
        end
    end]]
    --self:SetNW2Int("CISConfig",self.CISConfig)
end
--------------------------------------------------------------------------------
function ENT:Think()
    local retVal = self.BaseClass.Think(self)
    local Panel = self.Panel
    local power = self.Electric.BSPowered > 0
    self:SetPackedBool("WorkBeep",power)
    self:SetPackedBool("WorkFan",Panel.WorkFan>0)--power and self.Battery.Value*self.GV.Value*(550 <= self.Electric.Main750V and self.Electric.Main750V <= 975 and 1 or 0) > 0)		
    local state = math.abs(self.AsyncInverter.InverterFrequency/(11+self.AsyncInverter.State*5))--(10+8*math.Clamp((self.AsyncInverter.State-0.4)/0.4,0,1)))
    self:SetPackedRatio("asynccurrent", math.Clamp(state*(state+self.AsyncInverter.State/1),0,1)*math.Clamp(self.Speed/6,0,1))
    self:SetPackedRatio("asyncstate", math.Clamp(self.AsyncInverter.State/0.2*math.abs(self.AsyncInverter.Current)/100,0,1))
    self:SetPackedRatio("chopper", math.Clamp(self.Electric.Chopper>0 and self.Electric.Iexit/100 or 0,0,1))
    
    self:SetPackedBool("CompressorWork",self.Pneumatic.Compressor and CurTime()-self.Pneumatic.Compressor > 0)
    --self:SetPackedBool("Vent1Work",self.Electric.Vent1>0)
    --self:SetPackedBool("Vent2Work",self.Electric.Vent2>0)
    --self:SetPackedBool("PSNWork",power and self.BUV.PSN > 0)
    for idx = 1, 8 do
        self:SetNW2Bool("DoorButtonLed" .. idx, self.Electric.BSPowered > 0 and self.BUD.OpenButton[idx])
    end
    self:SetNW2Int("PassSchemesLED",self.CIS.PassSchemeCurr)
    self:SetNW2Int("PassSchemesLEDN",self.CIS.PassSchemeArr)
    self:SetPackedBool("PassSchemesLEDO",self.CIS.PassSchemePath)
    self:SetPackedBool("PassSchemes",Panel.PassSchemes>0) --power and (self.BUV.Power*(self.SF37.Value+self.SF38.Value) > 0) and self.CIS.BMCISInit)
    self:SetPackedBool("PassSchemesL",Panel.PassSchemesL>0)--power and self.BUV.Power*self.SF37.Value > 0)
    self:SetPackedBool("PassSchemesR",Panel.PassSchemesR>0)--power and self.BUV.Power*self.SF38.Value > 0)
    self:SetPackedBool("CouchCapR",self.CouchCapR)
    self:SetPackedBool("CouchCapL",self.CouchCapL)	
    self:SetPackedBool("door_k31",self.door_k31)
    
    self:SetPackedRatio("LV",Panel.LV/150)--self.Battery.Value*self.Electric.KM2*self.SF44.Value*self.Electric.Battery80V/150)	
    self:SetPackedRatio("HV",self.Electric.Main750V/1000)	
    self:SetPackedRatio("IVO",0.5+self.BUV.IVO/150)	
    
    local fB,rB = self.FrontBogey,self.RearBogey
    local validfB,validrB = IsValid(fB),IsValid(rB)
    for i=1,4 do
        self:SetPackedBool("TR"..i,self.BUV.Pant or i<=2 and validfB and fB.DisableContactsManual or i>2 and validrB and rB.DisableContactsManual)
    end
    --local passlight = power1 and (self.BUV.MainLights and 1 or (self.SF44.Value > 0.5 and (self.SF31.Value+self.SF32.Value > 0.5)) and 0.25) or 0
    local passlight = Panel.SalonLighting1*0.25+Panel.SalonLighting2*0.75
    local passl = passlight > 0
    self:SetLightPower(11,passl, passlight)
    self:SetLightPower(12,passl, passlight)
    self:SetLightPower(13,passl, passlight)
    self:SetPackedBool("SalonLighting1",Panel.SalonLighting1>0)--power and self.BUV.MainLights and self.SF44.Value*self.Battery.Value > 0)
    self:SetPackedBool("SalonLighting2",Panel.SalonLighting2>0)--power and self.BUV.MainLights and self.SF43.Value*self.Battery.Value > 0)
    --self:SetPackedRatio("SalonLighting",passlight)
    self:SetPackedBool("AnnPlay",power)--self:GetNW2Bool("AnnouncerPlaying",false))	
    
    self:SetNW2Bool("DoorAlarm",self.CIS.DoorAlarm)
    
    self:SetPackedRatio("BL", self.Pneumatic.BrakeLinePressure/16.0)
    self:SetPackedRatio("TL", self.Pneumatic.TrainLinePressure/16.0)
    self:SetPackedRatio("BC", math.min(3.8,self.Pneumatic.BrakeCylinderPressure)/6.0)
    
    for i=1,8 do
        if i==1 or i==4 or i==5 or i==8 then--  со стояночным
            self:SetPackedBool("BC"..i, math.max(self.Pneumatic.BrakeCylinderPressure,(i < 5 and (validfB and fB.DisableParking and 0 or 1) or i > 4 and (validrB and rB.DisableParking and 0 or 1))*(3.8-self.Pneumatic.ParkingBrakePressure)/2)<=0.1)
            self:SetPackedRatio("DPBTPressure"..i, math.max(self.Pneumatic.BrakeCylinderPressure,(i < 5 and (validfB and fB.DisableParking and 0 or 1) or i > 4 and (validrB and rB.DisableParking and 0 or 1))*(3.8-self.Pneumatic.ParkingBrakePressure)/2))
        else
            self:SetPackedBool("BC"..i,self.Pneumatic.BrakeCylinderPressure<=0.1)
            self:SetPackedRatio("DPBTPressure"..i,self.Pneumatic.BrakeCylinderPressure)
        end
    end
    
    if self.FrontTrain ~= self.PrevFrontTrain then
        self:SetNW2Entity("FrontTrain",self.FrontTrain)
        self.PrevFrontTrain = self.FrontTrain
    end
    if self.RearTrain ~= self.PrevRearTrain then
        self:SetNW2Entity("RearTrain",self.RearTrain)
        self.PrevRearTrain = self.RearTrain	
    end
    
    --local mul = self.SF45.Value > 0.5 and self.BUV.MainLights and 1 or self.SF46.Value > 0.5 and 0.5 or 0
    --self:SetLightPower(11,self.BUV.Power and mul > 0, mul)
    --self:SetLightPower(12,self.BUV.Power and mul > 0, mul)
    self:SetPackedRatio("Speed", self.Speed)
    self.AsyncInverter:TriggerInput("Speed",self.Speed)
    --self.AsyncInverter:TriggerInput("Speed1",self.Speed)	
    if validfB and validrB and not self.IgnoreEngine then
        local A = self.AsyncInverter.Torque
        local add = 1
        if math.abs(self:GetAngles().pitch) > 4 then
            add = math.min((math.abs(self:GetAngles().pitch)-4)/2,1)
        end
        fB.MotorForce = (40000+5000*(A < 0 and 1 or 0))*add --35300
        fB.Reversed = (self.BUV.Reverser < 0.5)--<
        rB.MotorForce  = (40000+5000*(A < 0 and 1 or 0))*add --35300
        rB.Reversed = (self.BUV.Reverser > 0.5)-->

        -- These corrections are required to beat source engine friction at very low values of motor power
        local P = math.max(0,0.04449 + 1.06879*math.abs(A) - 0.465729*A^2)
        if math.abs(A) > 0.4 then P = math.abs(A) end
        if math.abs(A) < 0.05 then P = 0 end
        if self.Speed < 10 then P = P*(1.0 + 0.6*(10.0-self.Speed)/10.0) end
        rB.MotorPower  = P*0.5*((A > 0) and 1 or -1)
        fB.MotorPower = P*0.5*((A > 0) and 1 or -1)

        -- Apply brakes
        fB.PneumaticBrakeForce = 50000.0--3000 --40000
        fB.BrakeCylinderPressure = self.Pneumatic.BrakeCylinderPressure--math.max(self.Pneumatic.BrakeCylinderPressure,(3.85-self.Pneumatic.ParkingBrakePressure))
        fB.ParkingBrakePressure = math.max(0,3.8-self.Pneumatic.ParkingBrakePressure)/2
        fB.BrakeCylinderPressure_dPdT = -self.Pneumatic.BrakeCylinderPressure_dPdT
        fB.DisableContacts = self.BUV.Pant
        rB.PneumaticBrakeForce = 50000.0--3000 --40000
        rB.BrakeCylinderPressure = self.Pneumatic.BrakeCylinderPressure--math.max(self.Pneumatic.BrakeCylinderPressure,(3.85-self.Pneumatic.ParkingBrakePressure))
        rB.ParkingBrakePressure = math.max(0,3.8-self.Pneumatic.ParkingBrakePressure)/2
        rB.BrakeCylinderPressure_dPdT = -self.Pneumatic.BrakeCylinderPressure_dPdT
        rB.DisableContacts = self.BUV.Pant
    end
    return retVal
end


function ENT:OnCouple(train,isfront)
    if isfront and self.FrontAutoCouple then
        self.FrontBrakeLineIsolation:TriggerInput("Open",1.0)
        self.FrontTrainLineIsolation:TriggerInput("Open",1.0)
        self.FrontAutoCouple = false
    elseif not isfront and self.RearAutoCouple then
        self.RearBrakeLineIsolation:TriggerInput("Open",1.0)
        self.RearTrainLineIsolation:TriggerInput("Open",1.0)
        self.RearAutoCouple = false
    end
    
    local ent = train:GetNW2Entity("TrainEntity")
    local a,a2 = isfront and -1 or 1,train ~= ent.RearCouple and -1 or 1
    local fence = isfront and "Fence1" or "Fence"
    local s = (train ~= ent.RearCouple and "Fence1" or "Fence")
    
    if not IsValid(self[fence]) and not IsValid(ent[s]) and ent:GetClass():find("76") and (ent:GetClass()[19] == "a" or ent:GetClass()[19] == "e") and not ent:GetClass():find("760") then
        local pos1,pos2 = self:GetPos(),ent:GetPos()
        local b1,b2 = -self:GetForward()*a,-ent:GetForward()*a2
        local min = 1
        local pos
        for i=475,490,0.001 do
            if (pos1+b1*i):Distance(pos2+b2*i) < min then
                min = (pos1+b1*i):Distance(pos2+b2*i)
                pos = pos1+b1*i
            end
        end
        pos = pos and self:WorldToLocal(pos) --or -a*480.15	
        self[fence] = self:CreateFence(Vector(pos,0,0),Angle(0,0,0),-a)
        ent[s] = self[fence]
        table.insert(ent.TrainEntities,ent[s])	
        local bone1,bone2 = 0,1
        local bonen1,bonen2 = self[fence]:GetPhysicsObjectNum(bone1),self[fence]:GetPhysicsObjectNum(bone2)		
        --[[
        if (self:GetPos():Distance(bonen1:GetPos()) < self:GetPos():Distance(bonen2:GetPos())) then
            bone1,bone2 = 0,1
            bonen1,bonen2 = self[fence]:GetPhysicsObjectNum(bone1),self[fence]:GetPhysicsObjectNum(bone2)					
        end	]]	
        bonen1:SetPos(ent:LocalToWorld(Vector(a2 == -1 and 464.37 or -464.07,0,0)))
        bonen2:SetPos(self:LocalToWorld(Vector(a == -1 and 464.37 or -464.07,0,0)))
        bonen1:SetAngles(ent:LocalToWorldAngles( a*Angle(0,90*(1-a2),90*a)))
        bonen2:SetAngles(self:LocalToWorldAngles(a*Angle(0,90*(1-a),-90*a))) 
        constraint.Weld( self[fence],self, bone2, 0, 0, 1, false )	
        constraint.Weld( self[fence],ent , bone1, 0, 0, 1, false )
    end	
    
    self.BaseClass.OnCouple(self,train,isfront)
end

function ENT:OnDecouple(isfront)
    if isfront then
        self.FrontCoupledBogey = nil
    else
        self.RearCoupledBogey = nil
    end
    self:OnConnectDisconnect()
    if self.OnDecoupled then self:OnDecoupled() end
    
    local fence = isfront and "Fence1" or "Fence"	
    if IsValid(self[fence]) then
        self[fence]:Remove()
    end	
end

function ENT:OnButtonPress(button,ply)
    if string.find(button,"PneumaticBrakeSet") then
        self.Pneumatic:TriggerInput("BrakeSet",tonumber(button:sub(-1,-1)))
        return
    end
    if button == "CouchCapL" then
        self.CouchCapL = not self.CouchCapL
    end	
    if button == "CouchCapR" then
        self.CouchCapR = not self.CouchCapR
    end		
    if button == "K31Cap" then self.door_k31 = not self.door_k31 end

    if string.StartsWith(button, "SalonDoor") then
        local idx = tonumber(string.sub(button, 10))
        if idx and IsValid(ply) and self.BUD then
            self.BUD:OpenDoorMenu(ply, idx)
        end
    end
end
