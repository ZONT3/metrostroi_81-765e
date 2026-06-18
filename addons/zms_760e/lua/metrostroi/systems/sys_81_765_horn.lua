Metrostroi.DefineSystem("81_765_Horn")
TRAIN_SYSTEM.DontAccelerateSimulation = true

function TRAIN_SYSTEM:Initialize()
    self.Active = false
end

function TRAIN_SYSTEM:ClientInitialize()
    self.LastActive = 0
    self.MechanicSound = "horn"
    self.ElectricSound = "horn3"
end

function TRAIN_SYSTEM:Outputs()
    return { "Active" }
end

function TRAIN_SYSTEM:Inputs()
    return { "Engage" }
end

function TRAIN_SYSTEM:TriggerInput(name, value)
    if name == "Engage" then
        self.Active = value > 0.5
    end
end

function TRAIN_SYSTEM:Think()
    self.Train:SetNW2Int("HornState", self.Active and 1 or self.Train.Electric.V1 > 0 and 2 or 0)
end

function TRAIN_SYSTEM:ClientThink(dT)
    local active = self.Train:GetNW2Int("HornState", 0)

    local snd = self.Train:GetNW2String("ElectricHornSnd", self.ElectricSound)
    if self.ElectricSound and snd ~= self.ElectricSound then
        self.Train:SetSoundState(self.ElectricSound, 0, 1, nil, 1.09)
    end
    self.ElectricSound = snd

    snd = self.Train:GetNW2String("HornSnd", self.MechanicSound)
    if self.MechanicSound and snd ~= self.MechanicSound then
        self.Train:SetSoundState(self.MechanicSound, 0, 1, nil, 1.09)
    end
    self.MechanicSound = snd

    local pitch  = 1 - math.exp(-10 * self.Train:GetPackedRatio("TL"))
    local volume = 1 - math.exp(-4 * self.Train:GetPackedRatio("TL"))
    if self.ElectricSound == self.MechanicSound then
        self.Train:SetSoundState(self.ElectricSound, active > 0 and volume or 0, math.max(active, self.LastActive) == 2 and pitch * 0.98 or pitch, nil, 1.09)
    else
        self.Train:SetSoundState(self.ElectricSound, active == 2 and volume or 0, pitch * 0.98, nil, 1.09)
        self.Train:SetSoundState(self.MechanicSound, active == 1 and volume or 0, pitch, nil, 1.09)
    end
    self.Active = active
    self.LastActive = active > 0 and active or self.LastActive
end
