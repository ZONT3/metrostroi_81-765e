--------------------------------------------------------------------------------
-- Блок Управления Информационным Комплексом (и Спидометр) 81-765
-- Имплементация варианта "Метроспецтехника"
-- Автор - ZONT_ a.k.a. enabled person
--------------------------------------------------------------------------------
Metrostroi.DefineSystem("81_765_BUIK")
TRAIN_SYSTEM.DontAccelerateSimulation = true

local dbg = false

function TRAIN_SYSTEM:Initialize()
    self:InitTrigger("Buik_EMsg1")  -- Экстр. Сообщение 1
    self:InitTrigger("Buik_EMsg2")  -- Экстр. Сообщение 2
    self:InitTrigger("Buik_EMsg3")  -- Экстр. Сообщение 2
    self:InitTrigger("Buik_Unused1")  -- Не используется (резвервная линия)
    self:InitTrigger("Buik_Mode")  -- Безымянная (выбор режима/страницы)
    self:InitTrigger("Buik_Path")  -- Выбор маршрута
    self:InitTrigger("Buik_Return")  -- Установка в начало
    self:InitTrigger("Buik_Down")  -- Выбор станции вниз
    self:InitTrigger("Buik_Up")  -- Выбор станции вверх
    self:InitTrigger("Buik_MicLine")  -- Линия
    self:InitTrigger("Buik_MicBtn")  -- Микрофон
    self:InitTrigger("Buik_Asotp")  -- АСОТП (не реализовано)
    self:InitTrigger("Buik_Ik")  -- ИК (штатный режим)
    self:AddTrigger("R_Program1")
    self:AddTrigger("R_Program11", "R_Program1")

    self.State = 0
    self.State2 = 0
    self.Triggers = {}
    self.StatusStates = {}

    self.MsgDelay = 0.9 + math.random() * 0.4

    -- Конфиг
    -- БУ-ИК активен только в активной кабине
    self.ActiveOnly = false
    -- БУ-ИК неактивен в хвостовой кабине (не имеет значения, если пред. true)
    self.RearInactive = true

    -- Backwards-compat
    if not self.Train.Announcer then self.Train.Announcer = {} end
    if not self.Train.Announcer.Schedule then self.Train.Announcer.Schedule = {} end

    if SERVER then
        self:CheckTriggers(true)
        self:InitInformer()
    end

    self.NextThink = CurTime()
end

function TRAIN_SYSTEM:InitTrigger(name)
    self.Train:LoadSystem(name, "Relay", "Switch", {bass = true})
    self.TriggerNames = self.TriggerNames or {}
    table.insert(self.TriggerNames, name)
end

function TRAIN_SYSTEM:AddTrigger(name, redirect)
    self.TriggerNames = self.TriggerNames or {}
    table.insert(self.TriggerNames, not redirect and name or {name, redirect})
end

function TRAIN_SYSTEM:CheckTriggers(dontRun)
    for k, v in pairs(self.TriggerNames) do
        local name = istable(v) and v[1] or v
        local trigName = istable(v) and v[2] or v
        local val = self.Train[name] and (self.Train[name].Value > 0.5) or false
        if val ~= self.Triggers[name] then
            if not dontRun then self:Trigger(trigName, val) end
            self.Triggers[name] = val
        end
    end
end

function TRAIN_SYSTEM:Outputs()
    return {}
end
if TURBOSTROI then return end

local highlights = {
    "LastStation", "List", "Page", "RouteNumber",

    -- Дешифратор,  АРС1,     АРС2,     АТС/УОС/ШТАТ,  ЛН (НД)   0,        ОЧ,       АО,       БОСД
    "State1",       "State2", "State3", "State4",      "State5", "State6", "State7", "State8", "State9",
    -- AUTO DRIVE  СВЯЗЬ С СЦ
    "Option1",     "Option2"
}
local highlights_2k = {}
for k, v in ipairs(highlights) do
    highlights_2k[v] = k
end

local GENERAL_TIMEOUT = 3.5
local PAGE_TIMEOUT = 5.0

-- Общие
local STATE_INACTIVE = 1
local STATE_NORMAL = 2

-- Состояния на БУИКе
local STATE_RED = 3
local STATE_GREEN = 4
local STATE_YELLOW = 5

-- Состояния БУИКа
local STATE_POWEROFF = 0
local STATE_BOOTING = 3
local STATE_INACTIVE_CABIN = 4

-- Информатор
local STATE_SETUP = 3

local PAGE_MAIN = 1
local PAGE_MSG = 2
local PAGE_LAST_ST = 3
local PAGE_ROUTES = 4


local cyrillic_map = {}
cyrillic_map["а"] = "А"
cyrillic_map["б"] = "Б"
cyrillic_map["в"] = "В"
cyrillic_map["г"] = "Г"
cyrillic_map["д"] = "Д"
cyrillic_map["е"] = "Е"
cyrillic_map["ё"] = "Ё"
cyrillic_map["ж"] = "Ж"
cyrillic_map["з"] = "З"
cyrillic_map["и"] = "И"
cyrillic_map["й"] = "Й"
cyrillic_map["к"] = "К"
cyrillic_map["л"] = "Л"
cyrillic_map["м"] = "М"
cyrillic_map["н"] = "Н"
cyrillic_map["о"] = "О"
cyrillic_map["п"] = "П"
cyrillic_map["р"] = "Р"
cyrillic_map["с"] = "С"
cyrillic_map["т"] = "Т"
cyrillic_map["у"] = "У"
cyrillic_map["ф"] = "Ф"
cyrillic_map["х"] = "Х"
cyrillic_map["ц"] = "Ц"
cyrillic_map["ч"] = "Ч"
cyrillic_map["ш"] = "Ш"
cyrillic_map["щ"] = "Щ"
cyrillic_map["ъ"] = "Ъ"
cyrillic_map["ы"] = "Ы"
cyrillic_map["ь"] = "Ь"
cyrillic_map["э"] = "Э"
cyrillic_map["ю"] = "Ю"
cyrillic_map["я"] = "Я"
local function toUpperCase(str)
    str = string.upper(str)
    for k, v in pairs(cyrillic_map) do
        str = string.Replace(str, k, v)
    end
    return str
end

local ars_states = {
    [0] = STATE_RED,
    [1] = STATE_GREEN,
    [2] = STATE_YELLOW,
}


if SERVER then
    util.AddNetworkString("BUIK765.AnnouncerCmd")

    local BOOT_SEQ = { 3, 5, 2, 1, 1, 3, 2, 1 }

    function TRAIN_SYSTEM:Think(dT)
        self:CheckTriggers()

        if CurTime() < self.NextThink then return end
        self.NextThink = CurTime() + 0.26

        self:AnnouncerWork()

        local activate = self.Activate
        if activate then self.Activate = false end

        local Wag = self.Train

        local battery = Wag.Electric.Battery80V > 62
        local power = battery and Wag.SF45F11.Value > 0.5
        if not power then
            self.State = STATE_POWEROFF
        elseif self.State == STATE_POWEROFF then
            self.State = STATE_BOOTING
        end

        Wag:SetNW2Bool("Buik_PathLamp", battery and Wag.Buik_Path.Value * Wag.SF70F3.Value * Wag.Electric.UPIPower > 0)
        Wag:SetNW2Bool("Buik_MicLineLamp", battery and Wag.Buik_MicLine.Value * Wag.SF70F3.Value * Wag.Electric.UPIPower > 0)

        if not power and self:IsCurrentlyPlaying() then
            self:StopMessage()
        end

        if self.State == STATE_BOOTING then
            if self.NextBootSeq and CurTime() < self.NextBootSeq then return end
            if self.State2 < 1 then self.State2 = 1 end
            if self.State2 > #BOOT_SEQ then
                self.State = STATE_INACTIVE
                self.State2 = 0
                self.NextBootSeq = nil
                Wag:SetNW2Int("BUIK:BootState", 0)
                return
            end
            local delay = BOOT_SEQ[self.State2]
            self.NextBootSeq = CurTime() + (delay >= 2 and math.Rand(delay - 2, delay + 2) or delay + math.random() - 0.5)
            Wag:SetNW2Int("BUIK:BootState", self.State2)
            Wag:SetNW2Int("BUIK:State", self.State)
            self.State2 = self.State2 + 1
            return
        end

        if self.State == STATE_NORMAL and (not Wag.BUKP or Wag.BUKP.State ~= 5) then self.State = STATE_INACTIVE end

        self.WagNum = Wag.BUKP and Wag.BUKP.WagNum or 0
        if self.State == STATE_NORMAL and (not isnumber(self.WagNum) or self.WagNum < 1) then self.State = STATE_INACTIVE end

        if self.State == STATE_NORMAL then
            self:TrainInfo(Wag)
            self:Speedometer(Wag)
            self:InformerWork(Wag)

        else
            self.Active = self.State == STATE_INACTIVE_CABIN and Wag:GetNW2Int("Skif:MainMsg", 1) == 0 or false
            if activate and Wag:GetNW2Int("Skif:MainMsg", 1) < 2 then self.Active = true Wag:CANWrite("BUIK", self.Train:GetWagonNumber(), "BUIK", nil, "Deactivate", true) end
            if self.State == STATE_INACTIVE and Wag.BUKP and Wag.BUKP.State == 5 and Wag.PpzUpi.Value > 0.5 and isnumber(self.WagNum) and self.WagNum >= 1 then
                self.State = STATE_INACTIVE_CABIN
            end
            if self.State == STATE_INACTIVE_CABIN and self.Active then self.State = STATE_NORMAL end

            self.WagNum = 0
            self.StatusStates = {}
            self.NextBootSeq = nil
            self.Page = PAGE_MAIN
            self.DoorAlarm = false
            if self.State == STATE_POWEROFF then
                self.InformerState = STATE_INACTIVE
                self.RouteNumber = -1
                self.InformerCfg = nil
                self.InformerCfgIdx = nil
                self.IkCfg = nil
                self.CisCfg = nil
                self.CisCfgIdx = nil
            end
        end

        Wag:SetNW2Int("BUIK:State", self.State)
        Wag:SetNW2String("BUIK:Clock", Wag.BUKP and Wag.BUKP.TimeEntered and os.date("%H:%M:%S", Wag.BUKP.Timer1) or os.date("!%H:%M:%S", Metrostroi.GetSyncTime()))
    end

    function TRAIN_SYSTEM:Highlight(name)
        local hlIdx = highlights_2k[name]
        if hlIdx then
            self.Train:SetNW2Float("BUIK:Highlight" .. hlIdx, CurTime())
        end
    end

    function TRAIN_SYSTEM:CheckDisplayState(stateIdx, strVal, stateVal)
        local name = "State" .. stateIdx
        local prevStr, prevState = unpack(self.StatusStates[name] or {})
        local hlIdx = highlights_2k[name]
        if hlIdx and (prevStr ~= strVal or prevState ~= stateVal) then
            self.Train:SetNW2Float("BUIK:Highlight" .. hlIdx, CurTime())
            self.Train:SetNW2String("BUIK:StateText" .. stateIdx, strVal)
            self.Train:SetNW2Int("BUIK:" .. name, stateVal)
            self.StatusStates[name] = {strVal, stateVal}
        end
    end

    function TRAIN_SYSTEM:Speedometer(Wag)
        Wag:SetNW2Float("BUIK:ActualSpeed", Wag.BARS.Speed)
        Wag:SetNW2Int("BUIK:MaxSpeed", Wag:GetNW2Int("Skif:SpeedLimit", 0))
        Wag:SetNW2Int("BUIK:NextSpeed", Wag:GetNW2Int("Skif:NextSpeedLimit", 0))
        Wag:SetNW2Bool("BUIK:SpeedometerBlink", Wag:GetNW2Bool("Skif:NoFreqReal", false) or Wag:GetNW2Bool("Skif:BarsBrake", false))
        Wag:SetNW2Bool("BUIK:NoMaxSpeed", Wag:GetNW2Bool("Skif:NoFreq", false))
        Wag:SetNW2Int("BUIK:Odometer", math.floor((Wag.Odometer or 0) / 1000))
    end

    function TRAIN_SYSTEM:TrainInfo(Wag)
        local bukpMessage = Wag:GetNW2Int("Skif:MainMsg", 1)
        self.Active = bukpMessage == 0 and Wag.BUKP.Active > 0
        if not self.Active and self.ActiveOnly then
            self.State = STATE_INACTIVE_CABIN
            return
        end

        local activeRear = bukpMessage == 2
        Wag:SetNW2Bool("BUIK:ActiveRearCabin", activeRear)
        if activeRear and self.RearInactive then
            self.State = STATE_INACTIVE_CABIN
            return
        end

        for idx = 1, self.WagNum do
            local wagon = Wag.BUKP.Trains[Wag.BUKP.Trains[idx]]
            if not wagon or not wagon.WagNumber or not Wag.BUKP:CheckBuv(wagon) then
                for di = 1, 8 do
                    Wag:SetNW2Bool(string.format("BUIK:Wag%dDoor%dClosed", idx, di), false)
                end
                Wag:SetNW2String("BUIK:WagNum" .. idx, "?????")
                Wag:SetNW2String("BUIK:WagErr" .. idx, true)

            else
                local orientation = wagon.Orientation
                for di = 1, 4 do
                    local r = wagon["Door" .. (orientation and di + 4 or di) .. "Closed"]
                    local l = wagon["Door" .. (orientation and di or di + 4) .. "Closed"]
                    Wag:SetNW2Bool(string.format("BUIK:Wag%dDoor%dClosed", idx, di), r)
                    Wag:SetNW2Bool(string.format("BUIK:Wag%dDoor%dClosed", idx, di + 4), l)
                end

                if idx == self.WagNum then
                    Wag:SetNW2Int("BUIK:RearCabinWagNum", idx)
                end

                local err = wagon.ParkingBrakeEnabled or not wagon.BTBReady

                Wag:SetNW2String("BUIK:WagNum" .. idx, tostring(wagon.WagNumber))
                Wag:SetNW2String("BUIK:WagErr" .. idx, err)
            end

        end

        local alsArs = Wag:GetNW2Bool("Skif:AlsArs")
        self:CheckDisplayState(1, alsArs and "2/6" or "ДАУ", STATE_NORMAL)
        self:CheckDisplayState(2, "АРС1", ars_states[Wag:GetNW2Int("Skif:ARS1", -1)] or STATE_INACTIVE)
        self:CheckDisplayState(3, "АРС2", ars_states[Wag:GetNW2Int("Skif:ARS2", -1)] or STATE_INACTIVE)
        self:CheckDisplayState(4, Wag.PmvAtsBlock.Value == 1 and "АТС1" or Wag.PmvAtsBlock.Value == 2 and "АТС2" or Wag.PmvAtsBlock.Value == 3 and "УОС" or "ШТАТ", STATE_NORMAL)
        self:CheckDisplayState(5, "НД", alsArs and not Wag.BARS.NoFreq and (Wag.BARS.LN and STATE_NORMAL or STATE_RED) or STATE_INACTIVE)
        self:CheckDisplayState(6, "0", not Wag.BARS.NoFreq and math.floor(Wag.BARS.SpeedLimit) < 21 and STATE_RED or STATE_NORMAL)
        self:CheckDisplayState(7, "ОЧ", Wag.BARS.NoFreq and STATE_RED or STATE_NORMAL)  -- FIXME: or inactive?
        self:CheckDisplayState(8, "АО", Wag.ALSCoil.AO and STATE_RED or STATE_NORMAL)
        self:CheckDisplayState(9, "БОСД", Wag.DoorBlock.Value > 0.5 and STATE_RED or STATE_INACTIVE)

        Wag:SetNW2Int("BUIK:WagNum", self.WagNum)
        Wag:SetNW2Bool("BUIK:ActiveCabin", self.Active)
    end


    function TRAIN_SYSTEM:InitInformer()
        self.Route = 0
        self.RouteNumber = -1
        self.InformerState = STATE_INACTIVE

        self.InformerServiceRoutes = {
            "Обкатка",
            "Перегонка",
            "В депо",
            "В пиве",
            "Посадки нет",
        }

        self.LastStationDraft = "Посадки нет"
        self.LastStation = "Посадки нет"
        self.DoorAlarm = false
    end

    function TRAIN_SYSTEM:SetupInformer(Wag)
        local reset = self.InformerCfgIdx ~= Wag:GetNW2Int("Announcer", 1) or self.CisCfgIdx ~= Wag:GetNW2Int("CISConfig", 0) or self.RouteNumber < 0
        local idx = Wag:GetNW2Int("Announcer", 1)
        local cfg = Metrostroi.ASNPSetup[idx]
        local cisIdx = Wag:GetNW2Int("CISConfig", 1)
        local cisCfg = (Metrostroi.CISConfig or {})[cisIdx]
        if not cfg[1] then
            self.InformerState = STATE_SETUP
            self.InformerCfg = nil
            self.InformerCfgIdx = -1
            return
        end
        self.AnnouncerCfg = Metrostroi.AnnouncementsASNP[idx]
        self.InformerCfg = not reset and self.InformerCfg or cfg
        self.InformerCfgIdx = not reset and self.InformerCfgIdx or idx
        self.CisCfg = not reset and self.CisCfg or cisCfg
        self.CisCfgIdx = not reset and self.CisCfgIdx or cisIdx
        self.RouteNumber = self.RouteNumber >= 0 and self.RouteNumber or 0
        self.InformerState = not reset and STATE_NORMAL or STATE_SETUP
        self.Page = not reset and PAGE_LAST_ST or PAGE_ROUTES
        self.Route = not reset and self.Route > 0 and self.Route or 1
        self.Path = Wag.Buik_Path.Value > 0
        self.PageSelTimer = nil
        self:InitRoutes()
        self:InitRoute()
        self:ReturnInformer(true)
        self:UpdatePage(true)
    end

    function TRAIN_SYSTEM:WriteToIk(str, data, arg, ...)
        if arg then
            str = string.format(str, arg, ...)
        end
        self.Train:CANWrite("BUIK", self.Train:GetWagonNumber(), "IK", nil, str, data)
    end

    function TRAIN_SYSTEM:InformerWork(Wag)
        if self.Train.BUKP.State == 5 then
            self:WriteToIk("Time", self.Train.BUKP.Time)
        end

        if self.InformerCfgIdx ~= -1 and (
            not self.InformerCfg or self.InformerState == STATE_INACTIVE or self.InformerCfgIdx ~= Wag:GetNW2Int("Announcer", 1)
        ) then
            self:SetupInformer(Wag)
            return
        end

        local path = Wag.Buik_Path.Value > 0
        if path ~= self.Path then
            self.Path = path
            self:ReturnInformer(true)
            self:UpdatePage(true)
        end

        if self.DoorAlarm and Wag.BUKP.DoorClosed > 0 then self.DoorAlarm = false end
        Wag.IK.DoorAlarm = self.DoorAlarm

        if self.InformerState == STATE_SETUP then
            self.RouteNumber = Wag.BUKP.RouteNumber or 99
            self.InformerState = STATE_NORMAL
            self.RouteChanged = true
            self:Highlight("List")

        elseif self.InformerState == STATE_NORMAL then
            if self.Page ~= PAGE_MAIN then
                if not self.PageSelTimer then self.PageSelTimer = CurTime() + PAGE_TIMEOUT end
                if CurTime() >= self.PageSelTimer then
                    self.PageSelTimer = nil
                    self.Page = PAGE_MAIN
                    self:Highlight("List")
                    self:UpdatePage()
                end
            elseif self.Page == PAGE_MAIN then
                if self.PageSelTimer then self.PageSelTimer = nil end
                if self.RouteChanged --[[and self.IsServiceRoute]] then
                    self.RouteChanged = false
                    self:ActivateRoute()
                end
            end
        end

        if self.UpdateIkTimer and CurTime() > self.UpdateIkTimer then
            self.UpdateIkTimer = nil
            self:UpdateIk()
        end

        Wag:SetNW2Int("BUIK:InformerState", self.InformerState)
        Wag:SetNW2String("BUIK:LastStation", toUpperCase(self.LastStationDraft))
        Wag:SetNW2String("BUIK:Page", self.Page)
        Wag:SetNW2String("BUIK:RouteNumber", self.RouteNumber >= 0 and string.format("%03d", math.floor(self.RouteNumber)) or "---")
    end

    function TRAIN_SYSTEM:UpdatePage(displayOnly, ikNow)
        if (self.Page == PAGE_MAIN or self.Page == PAGE_LAST_ST) and (
            not self.Stations or #self.Stations < 2 or not self.Station or self.Station < 1 or self.Station > #self.Stations
        ) then
            self:ClearListLines(1, 3)
            self:SetListLine(2, "Ошибка чтения конфигурации")
            return
        end

        if self.Page == PAGE_MAIN then
            self:SetListLine(1, self.Station > 1 and self.Stations[self.Station - 1].name or "")
            self:SetListLine(2, self.Stations[self.Station].name)
            self:SetListLine(3, #self.Stations > self.Station and self.Stations[self.Station + 1].name or "")
            if not ikNow then
                self.UpdateIkTimer = CurTime() + 5
            else
                self.UpdateIkTimer = nil
                self:UpdateIk()
            end
        elseif self.Page == PAGE_LAST_ST then
            if #self.LastStations > 0 or self.LastStations[0] then
                self:SetListLine(1, self.LastStationIdx > 0 and self.LastStations[self.LastStationIdx - 1].name or "Выберите станцию оборота:")
                self:SetListLine(2, self.LastStations[self.LastStationIdx].name)
                self:SetListLine(3, #self.LastStations > self.LastStationIdx and self.LastStations[self.LastStationIdx + 1].name or "")
            end
            if not displayOnly then
                self:UpdateLastStation()
            end
        elseif self.Page == PAGE_ROUTES then
            if not self.Routes or #self.Routes == 0 then
                self:ClearListLines(1, 3)
                self:SetListLine(2, "Память пуста")
                return
            elseif self.Route > #self.Routes then
                self:ClearListLines(1, 3)
                self:SetListLine(2, "Ошибка чтения конфигурации")
                return
            end
            self:SetListLine(1, self.Route > 1 and self.Routes[self.Route - 1] or "Выберите маршрут:")
            self:SetListLine(2, self.Routes[self.Route])
            self:SetListLine(3, #self.Routes > self.Route and self.Routes[self.Route + 1] or "")
            if not displayOnly then
                self:UpdateRoute()
            end
        else
            self:ClearListLines(1, 3)
            self:SetListLine(2, "Не заведено")
        end
    end

    function TRAIN_SYSTEM:ClearListLines(...)
        for _, idx in ipairs({...}) do
            self.Train:SetNW2String("BUIK:Line" .. idx, "")
        end
    end

    function TRAIN_SYSTEM:SetListLine(idx, str)
        if #str > 200 then
            str = string.sub(str, 1, 200)
        end
        self.Train:SetNW2String("BUIK:Line" .. idx, str)
    end

    function TRAIN_SYSTEM:Trigger(name, val)
        if self.InformerState == STATE_NORMAL then
            if val and name == "Buik_MicBtn" and self:IsCurrentlyPlaying() and self.Train.Buik_MicLine.Value > 0 then
                self:StopMessage()
                self.DoorAlarm = false
                return
            end

            if val and name == "Buik_Mode" then
                local x = self.Page + 1
                if x > 4 then x = 1 end
                self.Page = x
                self:Highlight("List")
                self:UpdatePage(true)
                self.PageSelTimer = nil
                return
            end
            if val and self.Page ~= PAGE_MAIN and name == "Buik_Return" then
                self.Page = PAGE_MAIN
                self:Highlight("List")
                self:UpdatePage(true)
                return
            end

            if val and not (self.RouteChanged and self.Page == PAGE_MAIN) and (name == "Buik_Down" or name == "Buik_Up") then
                local delta = name == "Buik_Down" and 1 or -1
                local listCfg = (
                    self.Page == PAGE_MAIN and "Station" or
                    self.Page == PAGE_LAST_ST and {"LastStationIdx", "LastStations", true} or
                    self.Page == PAGE_ROUTES and "Route" or
                    self.Page == PAGE_MSG and "Message"
                )

                local cursorName = istable(listCfg) and listCfg[1] or listCfg
                local listName = istable(listCfg) and listCfg[2] or cursorName .. "s"
                local allowZero = istable(listCfg) and listCfg[3]
                local listTbl = self[listName]
                if not listTbl then return end
                local listLen = #listTbl
                if listLen < 1 then return end

                local x = self[cursorName] + delta
                if listLen >= x and (x > 0 or allowZero and x >= 0) then
                    self[cursorName] = x
                end
                self:Highlight("List")
                self:UpdatePage()
                self.PageSelTimer = nil
                return
            end

            if self.Page == PAGE_MAIN then
                if val and self.RouteChanged and (name == "Buik_Return" or name == "R_Program1" or name == "Buik_Down" or name == "Buik_Up") then
                    self.RouteChanged = false
                    local exec = self.Station > 1 and name ~= "R_Program1"
                    self:ActivateRoute()
                    if exec then
                        self:Trigger(name, val)
                    end

                elseif val and name == "R_Program1" then
                    if self:IsCurrentlyPlaying() then
                        self:StopMessage()
                        self.DoorAlarm = false
                    end
                    self:Play()

                elseif val and name == "Buik_Return" then
                    self:ReturnInformer()
                    if not self.ServiceRoute then self.Station = 1 end
                    self:UpdatePage(true, true)

                end
            end
        end

        if self.State == STATE_INACTIVE_CABIN and name == "Buik_Return" and val then
            self.Activate = true
        end
    end

    function TRAIN_SYSTEM:InitRoutes()
        local routes = {}

        if self.InformerCfg then
            for _, route in ipairs(self.InformerCfg) do
                local first = route[1]
                first = first[2] or first[1] or "ОШИБКА"
                local last = route[#route]
                last = last[2] or last[1] or "ОШИБКА"
                table.insert(routes, string.format("%s - %s", first, last))
            end
        end

        for _, serviceRoute in ipairs(self.InformerServiceRoutes) do
            -- it is intended -- source: https://youtu.be/4LIZseVyUvw?si=thJTgjNnY74HbIXC&t=3188
            table.insert(routes, string.format("%s - %s", serviceRoute, serviceRoute))
        end

        self.Routes = routes
    end

    function TRAIN_SYSTEM:InitRoute()
        local isServiceRoute
        if #self.InformerCfg < self.Route then
            local service = self.InformerServiceRoutes[self.Route - #self.InformerCfg] or "Посадки нет"
            self.RouteCfg = {{[1] = 991, [2] = service}, {[1] = 992, [2] = service}}
            isServiceRoute = true
        else
            self.RouteCfg = self.InformerCfg[self.Route]
            if #self.RouteCfg < 2 then
                print("765 BUIK WARN: THERE IS LESS THAN 2 STATIONS IN SELECTED ANNOUNCER ROUTE (LINE) CONFIG!")
                print("falling back to service route...")
                local service = self.InformerServiceRoutes[#self.InformerServiceRoutes] or "Посадки нет"
                self.RouteCfg = {{[1] = 991, [2] = service}, {[1] = 992, [2] = service}}
                self.Route = #self.InformerCfg + #self.InformerServiceRoutes
                isServiceRoute = true
            else
                isServiceRoute = false
            end
        end
        self.IsServiceRoute = isServiceRoute
    end

    function TRAIN_SYSTEM:UpdateRoute()
        self:InitRoute()
        self:ReturnInformer(true)
    end

    function TRAIN_SYSTEM:ReturnInformer(resetLastSt)
        if resetLastSt then
            self.LastStationIdx = 0
        end

        local routeStationsCfg = self.Path and table.Reverse(self.RouteCfg) or self.RouteCfg
        local lastStations = {}
        for idx, station in ipairs(routeStationsCfg) do
            if idx > 1 and (self.IsServiceRoute or station.arrlast or station.not_last) then
                station = table.Copy(station)
                station.idx = idx
                station.tbl_id = self.Path and (#routeStationsCfg - idx + 1) or idx
                station.index = station[1] or -1
                station.name = station[2] or station[1] or "ОШИБКА"
                if idx < #routeStationsCfg then
                    table.insert(lastStations, station)
                else
                    lastStations[0] = station
                end
            end
        end
        self.LastStations = lastStations

        if #self.LastStations < self.LastStationIdx then self.LastStationIdx = 0 end
        local lastStation = self.LastStations[self.LastStationIdx]

        local routeStations = {}
        for idx, station in ipairs(routeStationsCfg) do
            if self.IsServiceRoute or lastStation.idx >= idx then
                station = table.Copy(station)
                station.idx = idx
                station.tbl_id = self.Path and (#routeStationsCfg - idx + 1) or idx
                station.index = station[1] or -1
                station.name = station[2] or station[1] or "ОШИБКА"
                station.is_terminus = self.LastStations[0].idx == station.idx
                table.insert(routeStations, station)
                if not self.IsServiceRoute and idx < lastStation.idx then
                    station = table.Copy(station)
                    station.name = station.name .. " отпр"
                    station.is_dep = true
                    table.insert(routeStations, station)
                end
            end
        end

        self.Station = 1
        self.Stations = routeStations
        self:Highlight("List")

        lastStation = lastStation or routeStations[1]
        if self.LastStationDraft ~= lastStation.name then
            self:Highlight("LastStation")
            self.RouteChanged = true
        end
        self.LastStationDraft = lastStation.name
        self.Train:CANWrite("BUIK", self.Train:GetWagonNumber(), "BUIK", nil, "RouteChanged", true)
    end

    function TRAIN_SYSTEM:UpdateLastStation()
        local lastStation = self.LastStations[self.LastStationIdx]
        if self.LastStationDraft ~= lastStation.name then
            local stationWas = self.Station
            self:ReturnInformer()
            if stationWas < #self.Stations then
                self.Station = stationWas
            end
        end
    end

    function TRAIN_SYSTEM:ActivateRoute()
        self.LastStation = self.LastStationDraft
        self.Arrived = true
        self:UpdatePlates()

        if self.IsServiceRoute then self:ResetIk() return end
        local lastStation = self.LastStations[self.LastStationIdx]
        self:InitIk(lastStation.idx)
        self:UpdatePage(true, true)

        if self.Train:GetNW2Bool("SarmatBeep", true) then
            self:QueueAnnounce("#SarmatInit")
        end
    end

    function TRAIN_SYSTEM:UpdatePlates()
        self.Train:CANWrite("BUIK", self.Train:GetWagonNumber(), "BUIK", nil, "RouteNumber", self.RouteNumber)
        self.Train:CANWrite("BUIK", self.Train:GetWagonNumber(), "BUIK", nil, "Route", self.Route)
        self.Train:CANWrite("BUIK", self.Train:GetWagonNumber(), "BUIK", nil, "InformerCfg", self.InformerCfgIdx)

        local lastStation = self.IsServiceRoute and self.LastStation or self.Stations[1][2] or self.Stations[1][1]
        self.Train:CANWrite("BUIK", self.Train:GetWagonNumber(), "BUIK", nil, "LastStation", lastStation)
        self.Train:SetNW2Int("IK:Route", self.Route)
        self.Train.FrontIK:TriggerInput("SetRoute", self.LastStation, self.RouteNumber, not self.IsServiceRoute and self.Stations[#self.Stations].index or nil)
        self.Train:SetNW2String("RouteNumber", self.RouteNumber)

        self.Train:CANWrite("BUIK", self.Train:GetWagonNumber(), "BUIK", nil, "UpdateBmt", not self.IsServiceRoute and self.Stations[1].index)
    end

    function TRAIN_SYSTEM:InitIk(lastSt)
        local BUP = self.Train.BUKP
        if BUP.State == 5 then
            self:WriteToIk("Time", BUP.Time)
            self:WriteToIk("Date", BUP.DateStr)

            self:WriteToIk("RouteId", string.format("%d.%d.%s", self.CisCfgIdx, self.Route, self.Path and "II" or "I"))
            self:WriteToIk("Route", self.Route)
            self:WriteToIk("CfgIdx", self.CisCfgIdx)
            self:WriteToIk("LastStation", lastSt)
            self:WriteToIk("Path", self.Path)
            self:WriteToIk("LineName", self.RouteCfg.Name)

            local stations = {}
            for _, st in ipairs(self.Stations) do if not st.is_dep then stations[st.idx] = st.index end end
            self:WriteToIk("Stations", table.concat(stations, ","))

            self:WriteToIk("Init", true)
        end
    end

    function TRAIN_SYSTEM:UpdateIk(canBeDepart)
        local station = self.Stations[self.Station]
        if not station then return end
        local lastSt = self.LastStations[self.LastStationIdx]
        self:WriteToIk("RouteId", string.format("%d.%d.%s", self.CisCfgIdx, self.Route, self.Path and "II" or "I"))
        self:WriteToIk("Station", station.idx)
        self:WriteToIk("Depart", station.is_dep and canBeDepart or false)
        self:WriteToIk("Terminus", station.is_terminus or lastSt and lastSt.idx == station.idx and station.arrlast and true or false)
        self:WriteToIk("Execute", true)
    end

    function TRAIN_SYSTEM:ResetIk()
        self:WriteToIk("Reset", true)
    end

    function TRAIN_SYSTEM:CANReceive(source, sourceid, target, targetid, textdata, numdata)
        if source == "BUIK" and sourceid == self.Train:GetWagonNumber() then return end
        if textdata == "Deactivate" then self.Active = false self.State = STATE_INACTIVE_CABIN end
        if textdata == "RouteChanged" then self.RouteChanged = numdata end
        if textdata == "RouteNumber" then self.RouteNumber = numdata end
        if textdata == "Route" then self.Route = numdata end
        if textdata == "InformerCfg" then self.InformerCfgIdx = numdata self.InformerCfg = nil end
        if textdata == "LastStation" then
            self.LastStation = numdata
            self.LastStationDraft = numdata
        end
        if textdata == "UpdateRn" or textdata == "UpdateBmt" then
            self.Train.FrontIK:TriggerInput("SetRouteNum", self.RouteNumber)
            self.Train:SetNW2String("RouteNumber", self.RouteNumber)
            if textdata == "UpdateRn" then
                self.Train.BUKP.RouteNumber = self.RouteNumber
                self:Highlight("RouteNumber")
            end
        end
        if textdata == "UpdateBmt" then
            self.InformerState = STATE_INACTIVE
            self.Train:SetNW2Int("IK:Route", self.Route)
            self.Train.FrontIK:TriggerInput("SetRoute", self.LastStation, self.RouteNumber, numdata)
        end
    end

    function TRAIN_SYSTEM:IsCurrentlyPlaying()
        return self.AnnSchedule and #self.AnnSchedule > 0 or self.AnnNextAt and CurTime() < self.AnnNextAt
    end

    function TRAIN_SYSTEM:Play()
        if self.IsServiceRoute then return end

        self:UpdateIk(true)
        self.Train:CANWrite("BUIK", self.Train:GetWagonNumber(), "BUIK", nil, "RouteChanged", true)

        local station = self.Stations[self.Station]
        self.Arrived = not station.is_dep
        if self.Station < #self.Stations then
            self.Station = self.Station + 1
            self:Highlight("List")
            self:UpdatePage(false)
            self.UpdateIkTimer = nil
        end

        local lastSt = self.LastStations[self.LastStationIdx]
        local recordings = (
            not station.is_dep and (station.arr or station.arrlast or {})[self.Path and 2 or 1] or
            station.is_dep and station.dep[self.Path and 2 or 1] or
            station.idx == 1 and lastSt and lastSt.not_last
        ) or nil
        if not recordings then return end
        if not istable(recordings) then recordings = {recordings} end

        if station.is_dep and self.Train.BUKP.DoorClosed < 1 then self.DoorAlarm = CurTime() end

        local clicks = self.Train:GetNW2Bool("AnnouncerClicks", false)
        if clicks then
            self:QueueAnnounce("click1")
        elseif station.idx ~= 1 then
            self:QueueAnnounce({self.MsgDelay})
        end

        if not station.is_dep and lastSt and lastSt.idx == station.idx and station.arrlast and not station.is_terminus then
            recordings = station.arrlast[self.Path and 2 or 1]
            if not istable(recordings) then recordings = {recordings} end
            for _, wag in pairs(self.Train.WagonList) do
                wag.AnnouncementToLeaveWagon = true
            end
        end

        if not station.is_dep and lastSt and lastSt.not_last and lastSt.idx ~= station.idx and (station.have_inrerchange or (lastSt.idx - station.idx) < 5) then
            table.insert(recordings, 0.5)
            table.Add(recordings, lastSt.not_last)
        end

        self:QueueAnnounce(recordings)
        if clicks then
            self:QueueAnnounce("click2")
        end
    end

    function TRAIN_SYSTEM:StopMessage()
        self.AnnSchedule = {"_STOP", "click2"}
        self.AnnNextAt = nil
    end

    function TRAIN_SYSTEM:QueueAnnounce(recordings)
        if not istable(recordings) then recordings = { recordings } end
        self.AnnSchedule = self.AnnSchedule or {}
        for _, v in ipairs(recordings) do
            if v == -2 then
                self:StopMessage()
            else
                table.insert(self.AnnSchedule, v)
            end
        end
    end

    function TRAIN_SYSTEM:AnnouncerWork()
        self.AnnSchedule = self.AnnSchedule or {}
        if not self.AnnouncerCfg or #self.AnnSchedule == 0 then return end
        if self.AnnNextAt and CurTime() < self.AnnNextAt then return end

        local rec = table.remove(self.AnnSchedule, 1)
        local dur = 0
        if isnumber(rec) then
            dur = rec
            rec = nil
        elseif rec[1] ~= "#" and rec[1] ~= "_" then
            local snd = self.AnnouncerCfg[rec]
            if not snd then
                print("[765 BUIK ANNOUNCER] NO RECORDING", rec)
                return
            end
            rec = snd[1]
            dur = snd[2]
        end
        if rec then
            self:SendAnnouncerCmd(rec)
        end
        self.AnnNextAt = CurTime() + dur
    end

    function TRAIN_SYSTEM:SendAnnouncerCmd(cmd)
        for _, wagon in pairs(self.Train.WagonList) do
            if IsValid(wagon) then
                net.Start("BUIK765.AnnouncerCmd", true)
                    net.WriteEntity(wagon)
                    net.WriteString(cmd)
                net.Broadcast()
            end
        end
    end

    function TRAIN_SYSTEM:RouteNumberScroll(down)
        if not self.RouteNumber or self.RouteNumber < 0 then
            self.RouteNumber = 0
            return
        end
        local delta = down and -1 or 1
        local val = self.RouteNumber + delta
        if val < 0 then val = 100
        elseif val > 777 then val = 0
        end
        self.RouteNumber = val
    end


else

    local announcerCommandSounds = {
        ["#SarmatInit"] = "subway_trains/722/sarmat_start.mp3"
    }
    net.Receive("BUIK765.AnnouncerCmd", function()
        local wagon = net.ReadEntity()
        local recording = net.ReadString()
        if not IsValid(wagon) then return end

        if announcerCommandSounds[recording] then
            recording = announcerCommandSounds[recording]
        end

        if wagon.AnnouncerPositions then
            for k, v in ipairs(wagon.AnnouncerPositions) do
                wagon:PlayOnceFromPos("announcer" .. k, recording, wagon.OnAnnouncer and wagon:OnAnnouncer(v[3], k) or v[3] or 1, 1, v[2] or 400, 1e9, v[1])
            end
        else
            wagon:PlayOnceFromPos("announcer", recording, wagon.OnAnnouncer and wagon:OnAnnouncer(1) or 1, 1, 600, 1e9, Vector(0, 0, 0))
        end
    end)

    local scr_w, scr_h = 2486, 496

    function TRAIN_SYSTEM:ClientThink(dT)
        if not self.Train.BUIK or not self.Train:ShouldDrawPanel("BUIK") then return end
        if self.NextDraw and CurTime() < self.NextDraw then return end
        self.NextDraw = CurTime() + 0.05

        render.PushRenderTarget(self.Train.BUIK, 0, 0, scr_w, scr_h)
        render.Clear(0, 0, 0, 0)
        cam.Start2D()
            self:DrawBuik()
        cam.End2D()
        render.PopRenderTarget()
    end

    surface.CreateFont("BUIK64", {
        font = "Arimo",
        extended = true,
        size = 64,
        weight = 500,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = false,
        additive = false,
        outline = false,
    })
    surface.CreateFont("BUIKSystemHeader", {
        extended = true,
        font = "Arimo",
        size = 200,
        weight = 500,
    })
    surface.CreateFont("BUIKSystemSmall", {
        extended = true,
        font = "Arimo",
        size = 34,
        weight = 700,
    })
    surface.CreateFont("BUIKSystem", {
        extended = true,
        font = "Arimo",
        size = 40,
        weight = 700,
    })
    surface.CreateFont("BUIKSpeedometerClock", {
        extended = true,
        font = "Arimo",
        size = 38,
        weight = 700,
    })
    surface.CreateFont("BUIKSpeedometer", {
        extended = true,
        font = "Mvm765SegmentedMono",
        size = 156,
    })
    surface.CreateFont("BUIKSpeedometerSmall", {
        extended = true,
        font = "Mvm765SegmentedMono",
        size = 32,
    })
    surface.CreateFont("BUIKSpeedometerSmall.shadow", {
        extended = true,
        font = "Mvm765SegmentedMono",
        size = 32,
    })
    surface.CreateFont("BUIKClock", {
        extended = true,
        font = "Arimo",
        size = 64,
        weight = 700,
    })
    surface.CreateFont("BUIKOdometer", {
        extended = true,
        font = "Arimo",
        size = 56,
        weight = 700,
    })
    surface.CreateFont("BUIKRoute", {
        extended = true,
        font = "Rationale",
        size = 140,
    })

    local colorWhite = Color(255, 255, 255)
    local colorDarkerWhite = Color(190, 190, 190)
    local colorDisabled = Color(27, 27, 27)
    local colorBackground = Color(13, 14, 17)
    local colorBackgroundSpeedometer = Color(13, 14, 17)
    local colorBackgroundSpeedometerTop = Color(21, 23, 27)
    local colorInactive = Color(22, 41, 99)
    local colorActive = Color(209, 215, 233)
    local colorSelected = Color(83, 164, 201)
    local colorActiveCabin = Color(16, 112, 255)
    local colorRed = Color(255, 75, 75)
    local colorYellow = Color(209, 245, 55)
    local colorGreen = Color(55, 245, 55)
    local colorSelectedLineActive = Color(10, 192, 216)
    local colorSelectedLineInactive = Color(7, 50, 180)
    local colorLineTextActive = Color(223, 223, 223)
    local colorLineTextInactive = Color(67, 151, 190)
    local logo = Material("zxc765/PIVO_logo_lt.png", "smooth ignorez")

    local sizeSpeedometrW = 740
    local sizeSpeedometrH = scr_h
    local sizeWagonsW = scr_w - sizeSpeedometrW
    local sizeWagonsH = 200
    local sizeLeftPanelW = 250
    local sizeFooterW = sizeWagonsW
    local sizeFooterH = 70
    local sizeRnW = sizeLeftPanelW
    local sizeRnH = scr_h - sizeWagonsH - sizeFooterH * 2
    local sizeStationsW = 800
    local sizeStationsH = scr_h - sizeWagonsH - sizeFooterH
    local sizeStatusW = scr_w - sizeSpeedometrW - sizeLeftPanelW - sizeStationsW
    local sizeStatusH = sizeStationsH

    local function getTextW(text)
        local s = 0
        local lastUnicode = false
        for idx = 1, #text do
            local b = string.byte(text[idx])
            if lastUnicode or b < 208 then
                s = s + 1
                lastUnicode = false
            else
                lastUnicode = true
            end
        end
        return s
    end

    local lastStationFonts = {}
    local function getLastStationFont(text, scale)
        surface.SetFont("BUIK64")
        local tw = getTextW(text) * 25
        local sz = math.floor(math.Clamp(46 * sizeLeftPanelW / tw, 24, 64) * (scale or 1))
        local font = "BUIKLastStation" .. sz
        if not lastStationFonts[font] then
            surface.CreateFont(font, {
                font = "Arimo",
                extended = false,
                size = sz,
                weight = 500,
                blursize = 0,
                scanlines = 0,
                antialias = true,
                underline = false,
                italic = false,
                strikeout = false,
                symbol = false,
                rotary = false,
                shadow = false,
                additive = false,
                outline = false,
            })
            lastStationFonts[font] = true
        end
        return font
    end

    local function drawOutlinedRect(x, y, w, h, borderColor, color, noVerticalBorders)
        surface.SetDrawColor(borderColor)
        surface.DrawRect(x, y, w, h)
        surface.SetDrawColor(color)
        surface.DrawRect(x + (not noVerticalBorders and 2 or 0), y + 2, w - (not noVerticalBorders and 4 or 0), h - 4)
    end

    local function drawBorders()
        surface.SetDrawColor(colorInactive)
        surface.DrawRect(sizeWagonsW, 0, 2, scr_h)
        surface.DrawRect(sizeLeftPanelW, sizeWagonsH, 2, scr_h - sizeWagonsH)
        surface.DrawRect(sizeLeftPanelW + sizeStationsW, sizeWagonsH, 2, scr_h - sizeWagonsH)
        surface.DrawRect(0, sizeWagonsH, sizeWagonsW, 2)
        surface.DrawRect(0, scr_h - sizeFooterH * 2, sizeLeftPanelW, 2)
        surface.DrawRect(0, scr_h - sizeFooterH, sizeWagonsW, 2)
    end

    local highlightsState = {}
    local function updateHighlights(Wag)
        for k, v in ipairs(highlights) do
            highlightsState[v] = (CurTime() - Wag:GetNW2Float("BUIK:Highlight" .. k, 0)) < GENERAL_TIMEOUT
        end
    end


    local wagonsMarginX, wagonsMarginY = 12, 12
    local sizeWagHead = 52
    local sizeWagGap = 8
    local sizeMaxTrainLen = sizeWagonsW - sizeWagHead * 2 - wagonsMarginX * 2
    local sizeWagW = (sizeMaxTrainLen - sizeWagGap * 2 * 7) / 8
    local sizeWagH = sizeWagonsH - wagonsMarginY * 2
    local sizeWagDoorW = (sizeWagW - sizeWagGap * 5) / 4
    local sizeWagDoorH = sizeWagGap * 2

    local function drawWagons(Wag)
        local wagNum = Wag:GetNW2Int("BUIK:WagNum", 0)
        local wagDoors = {}

        local wagX, wagY = wagonsMarginX, wagonsMarginY
        for idx = 1, wagNum do
            local err = Wag:GetNW2Bool("BUIK:WagErr" .. idx, false)
            local doorsClosed = true
            for di = 1, 8 do
                local closed = Wag:GetNW2Bool(string.format("BUIK:Wag%dDoor%dClosed", idx, di), false)
                wagDoors[di] = closed
                doorsClosed = doorsClosed and closed
            end

            local color = err and colorRed or not doorsClosed and colorActive or colorInactive

            local extendStart, extendEnd = 0, 0
            if idx == 1 then
                local cabinColor = Wag:GetNW2Bool("BUIK:ActiveCabin", false) and colorActiveCabin or colorBackground
                draw.RoundedBoxEx(sizeWagHead, wagX, wagY, sizeWagHead * 2, sizeWagH, color, true, false, true, false)
                draw.RoundedBoxEx(sizeWagHead, wagX + 2, wagY + 2, (sizeWagHead * 2) - 4, sizeWagH - 4, cabinColor, true, false, true, false)
                wagX = wagX + sizeWagHead
                extendStart = sizeWagGap
            elseif idx == Wag:GetNW2Int("BUIK:RearCabinWagNum", 0) then
                local cabinColor = Wag:GetNW2Bool("BUIK:ActiveRearCabin", false) and colorActiveCabin or colorBackground
                draw.RoundedBoxEx(sizeWagHead, wagX + sizeWagW - sizeWagHead, wagY, sizeWagHead * 2, sizeWagH, color, false, true, false, true)
                draw.RoundedBoxEx(sizeWagHead, wagX + sizeWagW - sizeWagHead + 2, wagY + 2, (sizeWagHead * 2) - 4, sizeWagH - 4, cabinColor, false, true, false, true)
                extendEnd = sizeWagGap
            end

            drawOutlinedRect(wagX - extendStart, wagY, sizeWagW + extendStart + extendEnd, sizeWagH, color, colorBackground)
            if idx < wagNum then
                drawOutlinedRect(wagX + sizeWagW - 3, wagY + (sizeWagH / 3), sizeWagGap + 2, sizeWagH / 3, color, colorBackground, true)
            end
            if idx > 1 then
                drawOutlinedRect(wagX - sizeWagGap - 1, wagY + (sizeWagH / 3), sizeWagGap + 3, sizeWagH / 3, color, colorBackground, true)
            end

            local dx, dy
            dx, dy = wagX + sizeWagGap, wagY - sizeWagDoorH / 2
            for di = 1, 4 do
                local dc = wagDoors[5 - di] and (not doorsClosed and colorActive or colorInactive) or colorRed
                drawOutlinedRect(dx, dy, sizeWagDoorW, sizeWagDoorH, color, dc)
                dx = dx + sizeWagGap + sizeWagDoorW
            end
            dx, dy = wagX + sizeWagGap, wagY - sizeWagDoorH / 2 + sizeWagH - 2
            for di = 1, 4 do
                local dc = wagDoors[di + 4] and (not doorsClosed and colorActive or colorInactive) or colorRed
                drawOutlinedRect(dx, dy, sizeWagDoorW, sizeWagDoorH, color, dc)
                dx = dx + sizeWagGap + sizeWagDoorW
            end

            draw.SimpleText(Wag:GetNW2String("BUIK:WagNum" .. idx, "?????"), "BUIK64", wagX + sizeWagW / 2,  wagY + sizeWagH / 2, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

            wagX = wagX + sizeWagGap * 2 + sizeWagW
        end
    end


    local sizeRnMarginX, sizeRnMarginY = 20, 8
    local sizeRnDigitBoxW = sizeRnW - sizeRnMarginX * 2
    local sizeRnDigitBoxH = sizeRnH - 46 - sizeRnMarginY * 2

    local function drawRouteNumber(Wag)
        local x, y = sizeRnMarginX, sizeWagonsH + sizeRnH - sizeRnDigitBoxH - sizeRnMarginY

        draw.RoundedBox(sizeRnMarginY, x, y, sizeRnDigitBoxW, sizeRnDigitBoxH, colorInactive)
        draw.RoundedBox(sizeRnMarginY, x + 2, y + 2, sizeRnDigitBoxW - 4, sizeRnDigitBoxH - 4, colorBackground)

        local color = highlightsState["RouteNumber"] and colorActive or colorInactive
        draw.SimpleText(Wag:GetNW2String("BUIK:RouteNumber", "---"), "BUIKRoute", x + sizeRnDigitBoxW / 2, y + sizeRnDigitBoxH / 2 - 10, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        local rnText = "№ Маршрута"
        draw.SimpleText(rnText, getLastStationFont(rnText, 0.8), x + sizeRnDigitBoxW / 2, y + sizeRnDigitBoxH / 2 - 70, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local lastStationCvar = CreateClientConVar("zms_765ls", "ОШИБКА", false, false)
    local function drawLastStation(Wag)
        local x, y = 0, scr_h - sizeFooterH * 2
        local lastStation = Wag:GetNW2String("BUIK:LastStation", lastStationCvar:GetString())
        local color = highlightsState["LastStation"] and colorActive or colorInactive
        draw.SimpleText(lastStation, getLastStationFont(lastStation), x + sizeLeftPanelW / 2, y + sizeFooterH / 2, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local function drawClock(Wag)
        local x, y = 0, scr_h - sizeFooterH
        local time = Wag:GetNW2String("BUIK:Clock", "--:--:--")
        draw.SimpleText(time, "BUIKClock", x + sizeLeftPanelW / 2, y + sizeFooterH / 2, colorInactive, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local sizePgGap = 16
    local sizePgMargin = 12
    local sizeRightMargin = 20
    local sizePgW = (sizeStationsW - sizePgGap * 5) / 4
    local sizePgH = sizeFooterH - sizePgMargin * 2
    local pageNames = {"Станция", "Доп. инфо.", "Ст. оборота", "Маршруты"}
    local functionNames = {"AUTO PLAY", "СВЯЗЬ С СЦ"}
    local function drawFooter(Wag)
        local selected = Wag:GetNW2Int("BUIK:Page", 0)
        local x, y = sizeLeftPanelW + sizePgGap, scr_h - sizeFooterH + sizePgMargin
        for idx = 1, 4 do
            draw.RoundedBox(10, x, y, sizePgW, sizePgH, selected == idx and colorSelected or colorInactive)
            draw.SimpleText(pageNames[idx], "BUIKSystemSmall", x + sizePgW / 2, y + sizePgH / 2, colorBackground, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            x = x + sizePgW + sizePgGap
        end

        x = x + sizePgGap + 2
        for idx = 1, 2 do
            draw.RoundedBox(16, x, y, sizePgW, sizePgH, colorInactive)
            draw.SimpleText(functionNames[idx], "BUIKSystemSmall", x + sizePgW / 2, y + sizePgH / 2, colorBackground, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            x = x + sizePgW + sizePgGap
        end

        surface.SetDrawColor(colorInactive)
        surface.DrawRect(x, y - sizePgMargin, 2, sizeFooterH)
        draw.SimpleText("км", "BUIKOdometer", scr_w - sizeSpeedometrW - sizeRightMargin, y + sizePgH / 2 + 1, colorActive, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        draw.SimpleText(string.format("%07d", Wag:GetNW2Int("BUIK:Odometer", 0)), "BUIKClock", scr_w - sizeSpeedometrW - sizeRightMargin - 60, y + sizePgH / 2, colorActive, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    end

    local sizeStatusGapX = 24
    local sizeStatusGapY = 24
    local sizeStatusStateW = (sizeStatusW - sizeStatusGapX * 5) / 4
    local sizeStatusStateShortW = (sizeStatusW - sizeStatusGapX * 6) / 5
    local sizeStatusStateH = (sizeStatusH - sizeStatusGapY * 3) / 2
    local statesDefaults = {"???", "АРС1", "АРС2", "???", "НД", "0", "ОЧ", "АО", "БОСД"}
    local statesColors = {
        [STATE_INACTIVE] = colorInactive,
        [STATE_NORMAL] = colorSelected,
        [STATE_RED] = ColorAlpha(colorRed, 60),
        [STATE_YELLOW] = ColorAlpha(colorYellow, 60),
        [STATE_GREEN] = ColorAlpha(colorGreen, 60),
    }
    local statesColorsHighlighted = {
        [STATE_INACTIVE] = colorInactive,
        [STATE_NORMAL] = colorActive,
        [STATE_RED] = colorRed,
        [STATE_YELLOW] = colorYellow,
        [STATE_GREEN] = colorGreen,
    }
    local function drawStatus(Wag)
        local x0, y = scr_w - sizeSpeedometrW - sizeStatusW + sizeStatusGapX, sizeWagonsH + sizeStatusGapY
        local x = x0
        for line = 1, 2 do
            for col = 1, 5 do
                if not (col == 5 and line ~= 2) and not (col == 1 and line == 2 and not Wag.BuikAlsArs) then
                    local w = Wag.BuikAlsArs and line == 2 and sizeStatusStateShortW or sizeStatusStateW

                    local idx = 4 * (line - 1) + col
                    local state = Wag:GetNW2Int("BUIK:State" .. idx, STATE_INACTIVE)
                    local highlight = highlightsState["State" .. idx]
                    if idx == 8 and state == STATE_RED then
                        -- AO
                        highlight = CurTime() % 1.0 < 0.5
                    elseif idx == 7 or idx == 5 or idx == 6 then
                        -- ОЧ, 0, НД (ЛН)
                        highlight = highlight or state == STATE_RED
                    end
                    local color = highlight and statesColorsHighlighted[state] or statesColors[state]
                    if not color then print(idx, highlight, state) end
                    local textColor = (state ~= STATE_RED) and colorBackground or highlight and colorWhite or colorDarkerWhite

                    draw.RoundedBox(10, x, y, w, sizeStatusStateH, color)
                    draw.SimpleText(
                        Wag:GetNW2String("BUIK:StateText" .. idx, statesDefaults[idx]), "BUIKSystem",
                        x + w / 2, y + sizeStatusStateH / 2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER
                    )
                    x = x + w + sizeStatusGapX
                end
            end
            x = x0
            y = y + sizeStatusStateH + sizeStatusGapY
        end
    end


    local sizeListMargin = 4
    local sizeListLineW = sizeStationsW - sizeListMargin * 2
    local sizeListLineH = (sizeStationsH - sizeListMargin * 2) / 3
    local function drawList(Wag)
        local x, y = sizeLeftPanelW + sizeListMargin, sizeWagonsH + sizeListMargin
        local active = highlightsState["List"]
        for idx = 1, 3 do
            if idx == 2 then
                draw.RoundedBox(10, x, y, sizeListLineW, sizeListLineH, active and colorSelectedLineActive or colorSelectedLineInactive)
            end
            local color = active and colorLineTextActive or idx == 2 and colorLineTextInactive or colorInactive
            draw.SimpleText(Wag:GetNW2String("BUIK:Line" .. idx, ""), "BUIK64", x + sizeListMargin, y + sizeListLineH / 2, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            y = y + sizeListLineH
        end
    end


    local sizeSpeedometerPadding = 110
    local sizeSpeedometerInnerRadius = (sizeSpeedometrW - sizeSpeedometerPadding * 2) / 2
    local sizeSpeedometerLineGap = 6
    local circleResolution = 200
    function drawCircle(x, y, r, color, percent, invert)
        local extend = not not percent
        local a1, a2 = math.pi * (not extend and 1.0 or 1.015), math.pi * (not extend and 0 or -0.015)
        percent = percent and math.Clamp(percent, 0, 1) or 1

        local vtx = {}
        table.insert(vtx, { x = x, y = y })
        for i = 0, circleResolution do
            local k = i / circleResolution
            if k <= percent and not invert or k >= percent and invert then
                local a = Lerp(k, a1, a2)
                table.insert(vtx, { x = x + math.cos(a) * r, y = y - math.sin(a) * r })
            end
        end

        if #vtx > 2 then
            surface.SetDrawColor(color)
            draw.NoTexture()
            surface.DrawPoly(vtx)
        end
    end
    function drawSpeedometer(Wag)
        local x0, y0 = scr_w - sizeSpeedometrW + sizeSpeedometerPadding + sizeSpeedometerInnerRadius, sizeSpeedometerPadding + sizeSpeedometerInnerRadius

        local r1 = sizeSpeedometerInnerRadius + sizeSpeedometerLineGap - 4
        local r2 = sizeSpeedometerInnerRadius + sizeSpeedometerPadding - sizeSpeedometerLineGap - 40
        local r3 = sizeSpeedometerInnerRadius + sizeSpeedometerPadding - sizeSpeedometerLineGap - 18
        local r12 = r1 + (r2 - r1) / 2 + 2

        local speed = Wag:GetNW2Float("BUIK:ActualSpeed", 0)
        local maxSpeed = Wag:GetNW2Int("BUIK:MaxSpeed", 0)
        local nextSpeed = Wag.BuikAlsArs and Wag:GetNW2Bool("BUIK:ActiveCabin", false) and Wag:GetNW2Int("BUIK:NextSpeed", 0) or nil

        local maxSpeedColor = not Wag:GetNW2Bool("BUIK:NoMaxSpeed", false) and colorRed or colorBackgroundSpeedometerTop
        drawCircle(x0, y0, r2, colorBackgroundSpeedometerTop, maxSpeed / 100)
        drawCircle(x0, y0, r2, maxSpeedColor, maxSpeed / 100, true)
        drawCircle(x0, y0, r2, colorGreen, speed / 100)
        drawCircle(x0, y0, r12, colorBackgroundSpeedometerTop, 1)
        if nextSpeed then
            drawCircle(x0, y0, r12, colorYellow, nextSpeed / 100, true)
        end

        for i = 0, 20 do
            local a = Lerp(i / 20, math.pi * 1.015, -math.pi * 0.015)
            local cosa, sina = math.cos(a), math.sin(a)
            local rt = i < 20 and (r3 - 6) or r3
            local x1, y1 = x0 + cosa * r1, y0 - sina * r1
            local x2, y2 = x0 + cosa * r2, y0 - sina * r2
            local xl, yl = (x1 + x2) / 2, (y1 + y2) / 2
            local x3, y3 = x0 + cosa * rt, y0 - sina * rt
            surface.SetDrawColor(255, 255, 255)
            draw.NoTexture()
            surface.DrawTexturedRectRotated(xl, yl, r2 - r1, 2, math.deg(a))
            draw.SimpleText(tostring(i * 5), "BUIKSpeedometerClock", x3, y3, maxSpeed > 0 and i * 5 == math.floor(maxSpeed) and colorRed or colorWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        drawCircle(x0, y0, sizeSpeedometerInnerRadius, colorBackgroundSpeedometer, 1)
        if Wag:GetNW2Bool("BUIK:SpeedometerBlink", false) and CurTime() % 1.2 < 0.6 then
            drawCircle(x0, y0, sizeSpeedometerInnerRadius, colorRed, 1)
        end

        draw.SimpleText("00", "BUIKSpeedometer", x0, y0 - 80, colorInactive, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(tostring(math.floor(speed) % 100), "BUIKSpeedometer", x0 + (speed < 10 and 70 or 0), y0 - 80, colorActive, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    function TRAIN_SYSTEM:DrawBuik(state)
        state = state or self.Train:GetNW2Int("BUIK:State", -1)
        if state ~= STATE_INACTIVE then
            self.LastState = state
        end

        if state == STATE_NORMAL then
            surface.SetDrawColor(colorBackground)
            surface.DrawRect(0, 0, scr_w, scr_h)
            self.Train.BuikAlsArs = self.Train:GetNW2String("BUIK:StateText1", "") == "2/6"
            drawBorders()
            updateHighlights(self.Train)
            drawWagons(self.Train)
            drawRouteNumber(self.Train)
            drawLastStation(self.Train)
            drawClock(self.Train)
            drawFooter(self.Train)
            drawStatus(self.Train)
            drawSpeedometer(self.Train)
            drawList(self.Train)

        elseif state == STATE_INACTIVE then
            if not self.LastState then
                surface.SetDrawColor(colorDisabled)
                surface.DrawRect(0, 0, scr_w, scr_h)
                draw.SimpleText("БЛОК НЕАКТИВЕН", "BUIKSystemHeader", scr_w / 2, scr_h / 2, colorWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            else
                self:DrawBuik(self.LastState)
            end

        elseif state == STATE_INACTIVE_CABIN then
            surface.SetDrawColor(colorDisabled)
            surface.DrawRect(0, 0, scr_w, scr_h)
            draw.SimpleText("НЕАКТИВНАЯ КАБИНА", "BUIKSystemHeader", scr_w / 2, scr_h / 2, colorWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        elseif state == STATE_BOOTING then
            local bootState = self.Train:GetNW2Int("BUIK:State", -1) == STATE_INACTIVE and 8 or self.Train:GetNW2Int("BUIK:BootState", 1)
            surface.SetDrawColor(colorDisabled)
            surface.DrawRect(0, 0, scr_w, scr_h)
            if bootState == 2 then
                draw.SimpleText("НПО \"ПИВО\"", "BUIKSystemHeader", scr_w / 2, scr_h / 2 - 65, colorWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                draw.SimpleText("совместно с ПвВЗ", "BUIKSystemHeader", scr_w / 2 + 170, scr_h / 2 + 65, colorWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                surface.SetDrawColor(255, 255, 255, 255)
                surface.SetMaterial(logo)
                surface.DrawTexturedRectRotated(scr_w / 2 - 700, scr_h / 2, 300, 300, (CurTime() % 10) * 360 / 10)
                draw.SimpleText("ver. " .. self.Train.IkVersion, "BUIKSystem", scr_w - 20, scr_h - 20, colorWhite, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
            elseif bootState == 4 or bootState == 8 then
                draw.SimpleText("БЛОК НЕАКТИВЕН", "BUIKSystemHeader", scr_w / 2, scr_h / 2, colorWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            elseif bootState == 6 then
                draw.SimpleText("ПОИСК ОБОРУДОВАНИЯ...", "BUIKSystemHeader", scr_w / 2, scr_h / 2, colorWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end

        -- Unpowered
        else
            surface.SetDrawColor(0, 0, 0)
            surface.DrawRect(0, 0, scr_w, scr_h)
        end
    end
end
