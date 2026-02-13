--------------------------------------------------------------------------------
-- Блок Управления и Контроля Поезда (САУ Скиф-М)
-- Автор - ZONT_ a.k.a. enabled person
-- Может содержать код Cricket & Hell (81-760) и Metrostroi team (81-720, 722 и др.)
-- Реализованы категории сообщений, повагонные сообщения, фоновая инициализация в режиме депо,
-- репозиторй ошибок по их именам, лог ошибок, контроллер от 765, общение с БУ-ИК,
-- ПрОст/КОС 765, БАРС 765 и т.д...
--------------------------------------------------------------------------------
Metrostroi.DefineSystem("81_760E_BUKP")
TRAIN_SYSTEM.DontAccelerateSimulation = true

local BTN_DOWN = "MfduF7"
local BTN_UP = "MfduF6"
local BTN_ENTER = "MfduF8"
local BTN_MODE = "MfduF9"
local BTN_CLEAR = "MfduF5"

local MAINMSG_NONE = 0
local MAINMSG_RVOFF = 1
local MAINMSG_REAR = 2
local MAINMSG_2RV = 3
local MAINMSG_RVFAIL = 4

local ErrorsA = {
    {"RvErr", "Сбой РВ."},
    {"KmErr", "Сбой КМ."},
    {"ArsFail",  "Неисправность АРС.", "Неисправность АРС. Переведи\nблокиратор в положение АТС%d"},
    {"BuvDiscon", "Нет связи с БУВ-С.", "Нет связи с БУВ-С на %d вагоне."},
    {"NoOrient", "Вагон не ориентирован.", "Вагон %d не ориентирован."},
    {"BrakeLine", "Низкое давление ТМ."},
    {"DisableDrive", "Запрет ТР от АРС.",},
    {"AVP:MissedStation", "АВП: Допуск проезда станции",},
    {"AVP:NotWithinReika", "АВП: Не в зоне ОПВ.",},
    {"AVP:LostDoorsWhileDep", "АВП: Потеря контроля дверей при отпр.",},
    {"EmergencyBrake", "Экстренное торможение.", "Экстренное торможение\nна %d вагоне."},
    {"AVP:DisengageDoorClose", "АВП: Отожми Закрытие Дверей",},
    {"ParkingBrake", "Стояночный тормоз прижат.", "Стояночный тормоз прижат\nна %d вагоне."},
    {"PneumoBrake", "Пневмотормоз включен.", "Пневмотормоз включен\nна %d вагоне."},
    {"Doors", "Двери не закрыты.", "Двери не закрыты на %d вагоне."},
    {"Short", "КЗ нескольких вагонов.", "КЗ %d вагона."},
}
local ErrorsB = {
    {"BvDisabled", "БВ отключен.", "БВ отключен на %d вагоне."},
    {"RightBlock", "Правые двери заблокированы.",},
    {"LeftBlock", "Левые двери заблокированы.",},
    {"RedLightsAkb", "Выключи габаритные огни."},
    {"HV", "Напряжение КС.",},
    {"RearCabin", "Открыта кабина ХВ.",},
}
local ErrorsC = {
    {"SF", "Включи автомат.", "Включи автомат на %d вагоне."},
    {"PassLights", "Освещение не включено.", "Освещение не включено\nна %d вагоне.",},
}

local ErrorsCat = { ErrorsA, ErrorsB, ErrorsC }
local function errById(idx)
    for catIdx, tbl in ipairs(ErrorsCat) do
        if idx <= #tbl then
            return tbl[idx], catIdx
        end
        idx = idx - #tbl
    end
end

local ErrRingContinuous = {
    RightBlock = true,
    LeftBlock = true,
    DisableDrive = true,
}
local NoLogErr = {
    Doors = true
}

local Error2id = {}
for idx, err in ipairs(ErrorsA) do Error2id[ErrorsA[idx][1]] = idx end
for idx, err in ipairs(ErrorsB) do Error2id[ErrorsB[idx][1]] = idx + #ErrorsA end
for idx, err in ipairs(ErrorsC) do Error2id[ErrorsC[idx][1]] = idx + #ErrorsB + #ErrorsA end
local ErrorIdx2Name = {}
for name, idx in pairs(Error2id) do ErrorIdx2Name[idx] = name end


function TRAIN_SYSTEM:Initialize()
    self.TriggerNames = {"MfduF1", "MfduF2", "MfduF3", "MfduF4", "Mfdu1", "Mfdu2", "Mfdu3", "Mfdu4", "Mfdu5", "Mfdu6", "Mfdu7", "Mfdu8", "Mfdu9", "Mfdu0", "MfduKontr", "MfduHelp", "MfduF6", "MfduF7", "MfduF5", "MfduF9", "MfduF8", "MfduTv", "MfduTv1", "MfduTv2", "AttentionMessage"}
    self.Triggers = {}
    for k, v in pairs(self.TriggerNames) do
        if self.Train[v] then self.Triggers[v] = self.Train[v].Value > 0.5 end
    end

    self.State = 0
    self.State2 = 0
    self.Trains = {}
    self.Errors = {}
    self.WagErrors = {}
    self.Error = 0
    self.ErrorParams = {}
    self.Password = ""
    self.DepotSel = 1
    self.PvuWag = 0
    self.PvuCursor = 1
    self.MsgPage = 1
    self.MsgVer = 0
    self.Messages = {}
    self.MessagesMap = {}
    self.CondLeto = true
    self.Time = "0"
    self.RouteNumber = 0
    self.WagNum = 0
    self.DepotWags = false
    self.DepotMode = false
    self.BTB = false
    self.AO = false
    self.Compressor = false
    self.DoorControlDelay = math.random() * 0.9 + 0.2
    self.States = {}
    self.PVU = {}
    self.Active = 0
    self.MainMsg = 0
    self.EnginesStrength = 0
    self.ControllerState = 0
    self.EmergencyBrake = 0
    self.BTB = 0
    self.ESD = 0
    self.CurrentSpeed = 0
    self.ZeroSpeed = 0
    self.BudZeroSpeed = 0
    self.ZeroSpeedDelay = math.random() * 0.5
    self.Speed = 0
    self.MotorWagc = 1
    self.TrailerWagc = 0
    self.CurTime = CurTime()
    self.Prost = false
    self.Kos = false
    self.DoorClosed = 0
    self.CurTime1 = CurTime()
    self.NextThink = CurTime()

    self:InitShared()
end

function TRAIN_SYSTEM:ClientInitialize()
    self:InitShared()
end

function TRAIN_SYSTEM:InitShared()
    self.SFTbl = {
        {
            SF23F12 = "Счетчик",
            SF23F4 = "Инвертор",
            SF23F6 = "Управ. рез.",
            SF30F4 = "ПСН",
            SF52F3 = "Освещение авар.",
            SF52F2 = "Освещение осн.",
            SF90F2 = "АСОТП",
            SF45F3 = "Питание ESM",
            SF80F6 = "Двери откр.",
            SF80F7 = "Двери откр.",
            SF21F1 = "ТКПР",
            SF45F5 = "Видео",
            SF52F4 = "Подсветка дверей",
        }, {
            SF23F10 = "Противоюз",
            SF30F3 = "Осушитель",
            SF23F5 = "Цепи упрв. осн.",
            SF30F7 = "Питание ЦУ",
            SF30F9 = "Питание ЦУ",
            SF30F6 = "Питание ЦУ",
            SF30F8 = "Питание ЦУ",
            SF30F2 = "БС управл.",
            SF45F2 = "БУТ БВМ",
            SF45F4 = "БУТ БВМ",
            SF45F7 = "БНТ-ИК",
            SF45F8 = "БНТ-ИК",
            SF22F1 = "БУФТ",
        },
    }
end

function TRAIN_SYSTEM:Outputs()
    return {"State", "ControllerState", "EmergencyBrake", "BTB", "WagNum", "Prost", "Kos", "CurrentSpeed", "InitTimer", "ZeroSpeed", "BudZeroSpeed", "Active", "DoorClosed", "ESD"}
end

function TRAIN_SYSTEM:Inputs()
    return {}
end

if TURBOSTROI then return end

include("ui_81_760e_bukp.lua")

function TRAIN_SYSTEM:TriggerInput(name, value)
end

local function IsValidDate(value)
    local d, m, y = string.match(value, "(%d{1,2})%p(%d{1,2})%p(%d{4})")
    if d and m and y then
        d, m, y = tonumber(d), tonumber(m), tonumber(y)
        local dm2 = d * m * m
        if y < 2016 then
            return false
        elseif d > 31 or m > 12 or dm2 == 0 or dm2 == 116 or dm2 == 120 or dm2 == 124 or dm2 == 496 or dm2 == 1116 or dm2 == 2511 or dm2 == 3751 then
            -- invalid unless leap year
            if dm2 == 116 and (y % 400 == 0 or (y % 100 ~= 0 and y % 4 == 0)) then
                return true
            else
                return false
            end
        else
            return true
        end
    else
        return false
    end
end


if SERVER then
    function TRAIN_SYSTEM:CANReceive(source, sourceid, target, targetid, textdata, numdata)
        if not self.Trains[sourceid] then return end
        if textdata == "Get" then
            self.Reset = 1
        else
            self.Trains[sourceid][textdata] = numdata
        end
    end

    function TRAIN_SYSTEM:CState(name, value, target, bypass)
        if self.Reset or self.States[name] ~= value or bypass then
            self.States[name] = value
            for i = 1, self.WagNum do
                self.Train:CANWrite("BUKP", self.Train:GetWagonNumber(), target or "BUV", self.Trains[i], name, value)
            end
        end
    end

    function TRAIN_SYSTEM:CStateTarget(name, targetname, targetsys, targetid, value)
        if self.Reset or self.States[name] ~= value or bypass then
            self.States[name] = value
            self.Train:CANWrite("BUKP", self.Train:GetWagonNumber(), targetsys, targetid, targetname, value)
        end
    end

    TRAIN_SYSTEM.SkifPass = "7777"
    function TRAIN_SYSTEM:Trigger(name, value)
        local Train = self.Train
        local char = name:gsub("Mfdu", "")
        char = tonumber(char)
        if Train.Electric.UPIPower == 0 then return end
        local RV = (1 - Train.RV["KRO5-6"]) + Train.RV["KRR15-16"]
        if self.State == 1 and RV ~= 0 then
            if name == BTN_CLEAR and value then self.Password = self.Password:sub(1, -2) end
            if name == BTN_ENTER and value then
                if self.Password == self.SkifPass then
                    self.State = 3
                    self.State2 = 0
                    self.DepotSel = 1
                    self.DepotWags = false
                    self.DepotMode = true
                    self:ReInit()
                else
                    self.Password = ""
                end
            end

            if char and #self.Password < 4 and value then self.Password = self.Password .. char end
            Train:SetNW2String("Skif:Pass", self.Password)
        elseif self.DepotMode and RV ~= 0 then
            if not self.DepotWags then
                if self.Entering then
                    local len = self.DepotSel == 6 and 3 or 1
                    if name == BTN_MODE and value then
                        -- if self.DepotSel == 1 then
                        --     self.Date1 = os.date("!*t", 75601)
                        --     if not IsValidDate(self.Entering:sub(1, 2) .. "." .. self.Entering:sub(3, 4) .. "." .. self.Entering:sub(5, 8)) then
                        --         self.Date1.day = "01"
                        --         self.Date1.month = "01"
                        --         self.Date1.year = "2010"
                        --     else
                        --         self.Date1.day = self.Entering:sub(1, 2)
                        --         self.Date1.month = self.Entering:sub(3, 4)
                        --         self.Date1.year = self.Entering:sub(5, 8)
                        --     end

                        --     self.DateEntered = true
                        -- end

                        -- if self.DepotSel == 2 then
                        --     self.Timer1 = tonumber(self.Entering:sub(1, 2)) * 3600 + tonumber(self.Entering:sub(3, 4)) * 60 + tonumber(self.Entering:sub(5, 6)) + 75600
                        --     self.TimeEntered = true
                        -- end

                        local num = tonumber(self.Entering)
                        local changed = false
                        if self.DepotSel == 2 and num and num < 9 then changed = self.WagNum ~= num self.WagNum = num end
                        if self.DepotSel == 6 and num and #self.Entering > 0 and #self.Entering < 4 then self.RouteNumber = num end
                        self.Entering = false
                        if changed then
                            self:ReInit()
                        end
                    end

                    if name == BTN_MODE and value then self.Entering = false end
                    if char and value and char and #self.Entering < len and value then self.Entering = self.Entering .. char end
                    if name == BTN_CLEAR and value then self.Entering = self.Entering:sub(1, -2) end
                else
                    if name == BTN_UP and value and self.DepotSel > 1 then self.DepotSel = self.DepotSel - 1 end
                    if name == BTN_DOWN and value and self.DepotSel < 8 then self.DepotSel = self.DepotSel + 1 end
                    if name == BTN_ENTER and value then
                        self.DepotMode = false
                        self.Train:CANWrite("BUKP", self.Train:GetWagonNumber(), "BUIK", nil, "RouteNumber", self.RouteNumber)
                        self.Train:CANWrite("BUKP", self.Train:GetWagonNumber(), "BUIK", nil, "UpdateRn", true)
                    end

                    if name == BTN_MODE and value then
                        if self.DepotSel == 3 then self.DepotWags = true end
                        if self.DepotSel == 2 or self.DepotSel == 6 then self.Entering = "" end
                    end
                end
            else
                if name == BTN_ENTER and value then
                    if self.Entering and #self.Entering == 5 then
                        local wagnum = tonumber(self.Entering)
                        self.Trains[wagnum] = {}
                        if not wagnum or wagnum == 0 then
                            self.Trains[wagnum] = nil
                            wagnum = nil
                        end

                        self.Trains[self.DepotSel] = wagnum
                        self.Entering = false
                        self.WagsChanged = true
                    elseif not self.Entering then
                        self.DepotWags = false
                        self.DepotSel = 1
                        if self.WagsChanged then
                            self:ReInit()
                            self.WagsChanged = nil
                        end
                    end
                end

                if name == BTN_MODE and value then
                    if self.Entering then
                        self.Entering = false
                    else
                        self.Entering = ""
                    end
                end

                if self.Entering then
                    if name == BTN_CLEAR and value then self.Entering = self.Entering:sub(1, -2) end
                    if char and #self.Entering < 5 and value then self.Entering = self.Entering .. char end
                    Train:SetNW2String("Skif:Enter", self.Entering)
                else
                    if name == BTN_UP and value and self.DepotSel > 0 then self.DepotSel = self.DepotSel - 1 end
                    if name == BTN_DOWN and value and self.DepotSel < 8 then self.DepotSel = self.DepotSel + 1 end
                end
            end
        elseif self.State == 3 and name == BTN_ENTER and value and RV ~= 0 then
            self.DepotMode = true
        elseif self.State == 5 and value and RV ~= 0 then
            if char and self.PvuWag == 0 then
                self.State2 = tonumber(char .. "1")
                self.Select = false
                self.AutoChPage = nil

                if self.State2 == 81 then self.MsgPage = 1 self:PrepareMessages() end
                if self.State2 == 91 then self.State2 = 0 self.DepotMode = true end
            end

            local page = math.floor(self.State2 / 10)
            if page >= 1 and name == BTN_DOWN or name == BTN_UP then
                local down = name == BTN_DOWN
                if self.Select then
                    self.Select = self.Select + (down and 1 or -1)
                    local max = page == 8 and math.Clamp(#self.Messages - 26 * (self.MsgPage - 1), 1, 26) or 3 -- 3 а не 2 для страницы АВП
                    if self.Select < 1 then self.Select = max
                    elseif self.Select > max then self.Select = 1 end
                elseif page == 1 then
                    self.State2 = self.State2 + (down and 1 or -1)
                    if self.State2 < 11 then self.State2 = 17
                    elseif self.State2 > 17 then self.State2 = 11 end
                elseif page == 8 then
                    self.MsgPage = self.MsgPage + (down and -1 or 1)
                    local max = math.max(1, math.ceil(#self.Messages / 26))
                    if self.MsgPage < 1 then self.MsgPage = max
                    elseif self.MsgPage > max then self.MsgPage = 1 end
                    self:PrepareMessages()
                end
            elseif not self.Select and name == BTN_MODE and (page == 6 or page == 7 or page == 8) then
                if page == 6 then
                    self.Select = self.CondLeto and 1 or 2
                else
                    self.Select = 1
                end
            else
                if page == 7 and name == BTN_MODE then
                    if self.Select == 1 then
                        Train.sys_Autodrive.ADBoost = not Train.sys_Autodrive.ADBoost
                    elseif self.Select == 2 then
                        self.Kos = not self.Kos
                    elseif self.Select == 3 then
                        self.Prost = not self.Prost
                    end
                end
            end

            if page == 6 and self.Select and (name == BTN_DOWN or name == BTN_UP) then
                self.CondLeto = self.Select == 1
            end

            if page == 0 then
                if name == BTN_DOWN or name == BTN_UP then
                    self.PvuCursor = self.PvuCursor + (name == BTN_DOWN and 1 or -1)
                    if self.PvuCursor < 1 then self.PvuCursor = 7
                    elseif self.PvuCursor > 7 then self.PvuCursor = 1 end
                end
                if self.PvuWag > 0 and name == BTN_MODE then
                    local train = self.Trains[self.PvuWag]
                    if not self.PVU[train] then self.PVU[train] = {} end
                    self.PVU[train][self.PvuCursor] = not self.PVU[train][self.PvuCursor]
                elseif name == BTN_MODE then
                    self.PvuWag = 1
                end
                if char and self.PvuWag > 0 then
                    local sel = tonumber(char)
                    if sel and sel > 0 and sel <= self.WagNum then self.PvuWag = sel end
                end
            end

            if name == BTN_CLEAR then
                if self.Select then
                    self.Select = false
                elseif self.PvuWag > 0 then
                    self.PvuWag = 0
                else
                    self.State2 = 0
                    self.AutoChPage = nil
                end
            end
        end

        if self.State == 5 and name == "AttentionMessage" and value then
            for idx = #ErrorsA + 1, #ErrorsA + #ErrorsB + #ErrorsC do
                if self.Errors[idx] then
                    self.Errors[idx] = false
                    self.Errors[ErrorIdx2Name[idx]] = false
                    self.ErrorParams[idx] = nil
                    break
                end
            end
        end
    end

    function TRAIN_SYSTEM:ReInit()
        self.State = 3
        if self.WagNum > 0 then
            for i = 1, self.WagNum do
                self.Train:CANWrite("BUKP", self.Train:GetWagonNumber(), "BUV", self.Trains[i], "Orientate", i % 2 > 0)
            end
        end
    end

    function TRAIN_SYSTEM:BeginWagonsCheck()
        self.WagErrors = {}
        self.ErrorParams = {[0] = self.ErrorParams[0]}
    end

    function TRAIN_SYSTEM:EndWagonsCheck()
        for name, wags in pairs(self.WagErrors) do
            for idx = 1, self.WagNum do
                self:CheckError(name, wags[idx], idx)
            end
        end
    end

    function TRAIN_SYSTEM:CheckWagError(idx, name, cond)
        local id = Error2id[name] or 0
        if id < 1 then print("WARN! No BUKP error named " .. (name or "nil")) return end
        if not self.WagErrors[name] then self.WagErrors[name] = {} end
        if not cond then return end
        self.WagErrors[name].any = true
        self.WagErrors[name][idx] = true
    end

    function TRAIN_SYSTEM:CheckError(name, cond, param)
        local id = Error2id[name] or 0
        if id < 1 then print("WARN! No BUKP error named " .. (name or "nil")) return end
        if id > #ErrorsA and self.BErrorsTimer and CurTime() - self.BErrorsTimer < 0 then return end
        local ident = name .. (isnumber(param) and param or "")

        local log = not NoLogErr[name] and not (self.BErrorsTimer and self.BErrorsTimer >= CurTime() or self.InitTimer and self.InitTimer >= CurTime())

        if cond then
            if log and not self.MessagesMap[ident] then
                local idx = table.insert(self.Messages, {name, param or nil, {self.DateStrShort or "--.--.--", self.Time or "--:--:--"}})
                self.MessagesMap[ident] = idx
                if self.State2 == 81 then self.SendMessages = true end
            end

            if self.Errors[id] ~= false then
                self.Errors[id] = CurTime()
                self.Errors[name] = CurTime()
                self.ErrorParams[id] = isnumber(param) and (not self.ErrorParams[id] and param or self.ErrorParams[id] ~= param and true) or self.ErrorParams[id]
            end
        elseif (not self.WagErrors[name] or not self.WagErrors[name].any) and ((id <= #ErrorsA or ErrRingContinuous[name]) and self.Errors[id] and self.Errors[id] ~= CurTime() or self.Errors[id] == false) then
            self.Errors[id] = nil
            self.Errors[name] = nil
            self.ErrorParams[id] = nil
        end

        if log and self.MessagesMap[ident] and (not cond and isnumber(param) or not self.Errors[id] and self.Errors[id] ~= false) then
            self.Messages[self.MessagesMap[ident]][4] = {self.DateStrShort or "--.--.--", self.Time or "--:--:--"}
            self.MessagesMap[ident] = nil
            if self.State2 == 81 then self.SendMessages = true end
        end
    end

    function TRAIN_SYSTEM:CommitError()
        local errId = 0
        local category = nil
        local start = 1
        for catIdx, cat in ipairs(ErrorsCat) do
            for idx = start, #cat + start - 1 do
                if self.Errors[idx] then
                    errId = idx
                    break
                end
            end
            if errId > 0 then category = catIdx break end
            start = start + #cat
        end

        local param = errId > 0 and self.ErrorParams[errId] or false
        if errId == 0 then
            if self.ErrorRing then self.ErrorRing = nil end
            self.Train:SetNW2Int("Skif:ErrorCat", 0)
            self.Train:SetNW2String("Skif:ErrorStr", "")
        else
            local str = ErrorsCat[category][errId - start + 1]
            local changed = self.Error ~= errId or self.ErrorParams[0] ~= param
            local ring = self.Error ~= errId or self.ErrorParams[0] ~= param and param == true

            if ((ring or ErrRingContinuous[str[1]]) and (str[1] ~= "Doors" or self.Train.Speed >= 1.8) and str[1] ~= "RvErr") then
                self.ErrorRing = CurTime()
            end
            if str[1] == "DisableDrive" and self.Train.KV765.Position <= 0 then
                self.ErrorRing = nil
            end

            if changed then
                self.Train:SetNW2Int("Skif:ErrorCat", category)
                if isnumber(param) and str[3] then
                    self.Train:SetNW2String("Skif:ErrorStr", string.format(str[3], param))
                else
                    self.Train:SetNW2String("Skif:ErrorStr", str[2])
                end
            end
        end

        self.Error = errId
        self.ErrorParams[0] = param
        if self.SendMessages then
            if self.State2 == 81 then self:PrepareMessages() end
            self.SendMessages = false
        end
    end

    function TRAIN_SYSTEM:ClearErrors()
        for _, idx in pairs(Error2id) do
            self.Errors[idx] = nil
            self.Errors[ErrorIdx2Name[idx]] = nil
            self.ErrorParams[idx] = nil
        end
        self.Error = 0
        self.ErrorParams[0] = nil
    end

    function TRAIN_SYSTEM:PrepareMessages()
        local len = 0
        for idx = 1, 26 do
            local msgIdx = #self.Messages - (self.MsgPage - 1) * 26 - idx + 1
            if msgIdx < 1 then break end
            local name, param, appeared, solved = unpack(self.Messages[msgIdx])
            local err, cat = errById(Error2id[name])
            local text = err[3] and isnumber(param) and string.format(err[3], param) or err[2]
            text = string.Replace(text, "\n", " ")
            self.Train:SetNW2String("Skif:LogMsg" .. idx, text)
            self.Train:SetNW2String("Skif:LogCat" .. idx, cat == 1 and "А" or cat == 2 and "Б" or "В")
            self.Train:SetNW2String("Skif:LogApDate" .. idx, appeared and appeared[1] or "")
            self.Train:SetNW2String("Skif:LogApTime" .. idx, appeared and appeared[2] or "")
            self.Train:SetNW2String("Skif:LogSolved" .. idx, solved and solved[2] or "")
            len = len + 1
        end

        self.MsgVer = self.MsgVer + 1
        self.Train:SetNW2Int("Skif:LogLen", len)
        self.Train:SetNW2Int("Skif:LogVer", self.MsgVer)
    end

    function TRAIN_SYSTEM:CheckBuv(train)
        if not train then return false end
        if not train.BUVWork then return false end
        for i = 1, #self.Train.WagonList do
            local TrainI = self.Train.WagonList[i]
            if train.WagNumber == TrainI.WagonNumber then
                return true
            end
        end
        return false
    end

    function TRAIN_SYSTEM:Think(dT)
        local Train = self.Train

        if self.State > 0 then
            for k, v in pairs(self.TriggerNames) do
                if Train[v] and (Train[v].Value > 0.5) ~= self.Triggers[v] then
                    self:Trigger(v, Train[v].Value > 0.5)
                    self.Triggers[v] = Train[v].Value > 0.5
                end
            end
        end

        if CurTime() < self.NextThink then return end
        self.NextThink = CurTime() + 0.075

        if self.State > 0 and self.Reset and self.Reset ~= 1 then self.Reset = false end
        if self.WagList ~= #self.Train.WagonList and self.Train.BUV.OrientateBUP == self.Train:GetWagonNumber() then
            self.Reset = 1
            self.InitTimer = CurTime() + 0.5
            self.WagList = #self.Train.WagonList
        end

        local Power = Train.Electric.Battery80V > 62
        local SkifWork = (Train.PpzAts2.Value + Train.PpzAts1.Value > 0) and Power
        if not SkifWork then
            self.State = 0
            self.State2 = 0
            self.HVBad = CurTime()
            self.SkifTimer = nil
        end

        if SkifWork and self.State == 0 then
            self.State = -1
            self.SkifTimer = CurTime()
            self.Reset = nil
            self.Compressor = false
            self.Ring = false
            self.Error = 0
            self.ErrorRing = nil
        end

        if self.State == 5 then
            for i = 1, self.WagNum do
                if not self.Trains[self.Trains[i]] then self.State = 3 end
            end
        end

        if Power and not self.Timer then
            self.Timer = CurTime()
            Train:SetNW2Int("Skif:Timer", CurTime())
        elseif not Power then
            self.Timer = nil
        end

        if self.State == -1 and CurTime() - self.SkifTimer > 1 then
            self.State = 1
            self.State2 = 0
            self.SkifTimer = false
            self.Password = ""
            Train:SetNW2String("Skif:Pass", "")
            self.States = {}
            self.PVU = {}
            for k, v in ipairs(self.Trains) do
                if self.Trains[v] then self.Trains[v] = {} end
            end
            self.PTEnabled = nil
            self.HVBad = CurTime()
        end

        local RV = (1 - Train.RV["KRO5-6"]) + Train.RV["KRR15-16"]
        Train:SetNW2Int("Skif:RV", RV * Train.Electric.UPIPower)
        if self.State ~= 5 then self.MainMsg = RV * Train.Electric.UPIPower > 0 and MAINMSG_NONE or MAINMSG_RVOFF end
        self.Active = (RV * Train.PpzActiveCabin.Value ~= 0) and 1 or 0

        if self.State < 5 then
            self.Prost = false
            self.Kos = false
        end

        self.ESD = 0
        self.CanZeroSpeed = false
        self.BudZeroSpeed = 0

        local BARS = Train.BARS
        if Power then
            self.DeltaTime = CurTime() - self.CurTime
            self.CurTime = CurTime()
            if self.DateEntered or self.Date1 or self.Date then
                self.Date = self.Date1 and self.Date1.day .. self.Date1.month .. self.Date1.year or self.Date
                local dat = {
                    day = self.Date1 and self.Date1.day or self.Date:sub(1, 2),
                    month = self.Date1 and self.Date1.month or self.Date:sub(3, 4),
                    year = self.Date1 and self.Date1.year or self.Date:sub(5, -1)
                }

                self.dat = dat
                if self.Date and self.Time and self.Time:sub(1, 2) == "00" and self.Time:sub(4, 5) == "00" and self.Time:sub(7, 8) == "00" and CurTime() - self.CurTime1 >= 1 then
                    self.CurTime1 = CurTime()
                    if not self.Date1 then
                        self.Date1 = {
                            day = self.Date:sub(1, 2),
                            month = self.Date:sub(3, 4),
                            year = self.Date:sub(5, -1)
                        }
                    end

                    if IsValidDate(Format("%02d", tonumber(dat.day) + 1) .. "." .. dat.month .. "." .. dat.year) then
                        self.Date1.day = Format("%02d", tonumber(dat.day) + 1)
                    elseif IsValidDate("01." .. Format("%02d", tonumber(dat.month) + 1) .. "." .. dat.year) then
                        self.Date1.day = "01"
                        self.Date1.month = Format("%02d", tonumber(dat.month) + 1)
                    else
                        self.Date1.day = "01"
                        self.Date1.month = "01"
                        if dat.year == "9999" then
                            self.Date1.year = Format("%04d", 2016)
                        else
                            self.Date1.year = Format("%04d", tonumber(dat.year) + 1)
                        end
                    end
                end
            else
                self.Date = os.date("%d%m%Y", Metrostroi.GetSyncTime())
            end

            if self.TimeEntered then
                self.Time = os.date("%H:%M:%S", self.Timer1)
                self.Timer1 = self.Timer1 + self.DeltaTime
            else
                self.Time = os.date("!%H:%M:%S", Metrostroi.GetSyncTime())
            end

            if self.Date1 then
                self.DateStr = string.format("%s.%s.%s", self.Date1.day, self.Date1.month, self.Date1.year)
                self.DateStrShort = string.format("%s.%s.%s", self.Date1.day, self.Date1.month, self.Date1.year:sub(3, 4))
            elseif self.dat then
                self.DateStr = string.format("%s.%s.%s", self.dat.day, self.dat.month, self.dat.year)
                self.DateStrShort = string.format("%s.%s.%s", self.dat.day, self.dat.month, self.dat.year:sub(3, 4))
            else
                self.DateStr = os.date("%d.%m.%Y", Metrostroi.GetSyncTime())
                self.DateStrShort = os.date("%d.%m.%y", Metrostroi.GetSyncTime())
            end

            if self.State >= 2 then
                Train:SetNW2String("Skif:Time", self.Time)
                Train:SetNW2String("Skif:Date", self.DateStr)
                Train:SetNW2Int("Skif:WagNum", self.WagNum)
            end
            if self.DepotMode then
                Train:SetNW2Int("Skif:RouteNumber", self.RouteNumber)
                Train:SetNW2String("Skif:Enter", self.Entering or "-")
            end

            if self.State == 3 then
                local initialized = self.WagNum > 0
                local tbl = {}
                for i = 1, self.WagNum do
                    local train = self.Trains[self.Trains[i]]
                    if train then
                        local find = false
                        local wnum = train.WagNumber
                        if wnum then
                            for k, num in pairs(tbl) do
                                if wnum == num then
                                    find = true
                                    break
                                end
                            end

                            table.insert(tbl, train.WagNumber)
                        end

                        if not train.WagNOrientated and train.BUVWork and not train.BadCombination and not find then
                            Train:SetNW2Bool("Skif:WagI" .. i, true)
                        else
                            Train:SetNW2Bool("Skif:WagI" .. i, false)
                            initialized = false
                        end
                    else
                        initialized = false
                    end
                end

                if initialized then
                    self.State = 5
                    self.State2 = 0
                    self.Select = false
                    self.Errors = {}
                    self.Prost = true
                    self.Kos = true
                    self.BErrorsTimer = CurTime() + 3
                    self.InitTimer = CurTime() + 1
                end
            end

            local kvSetting = 0
            local overrideKv = true

            local EnginesStrength = 0
            if self.InitTimer and CurTime() - self.InitTimer > 0 then self.InitTimer = nil end
            local RvKro = (1 - Train.RV["KRO5-6"]) * Train.PpzPrimaryControls.Value
            local RvKrr = Train.RV["KRR15-16"] * Train.PpzEmerControls.Value
            local RvWork = self.InitTimer and true or RvKro + RvKrr > 0.5 and RvKro + RvKrr < 1.5
            local doorLeft, doorRight, selectLeft, selectRight, doorClose = false, false, false
            if self.State == 5 and (Train.PpzUpi.Value == 1) then
                local Back = false
                local sfBroken = false
                local shortAny = false
                local HVBad, PantDisabled = false, false
                local motor, trailer = 0, 0
                for i = 1, self.WagNum do
                    local train = self.Trains[self.Trains[i]]
                    if train.DriveStrength then EnginesStrength = EnginesStrength + train.DriveStrength end
                    if train.BrakeStrength then EnginesStrength = EnginesStrength + train.BrakeStrength end
                    if train.RV and self.Trains[i] ~= Train:GetWagonNumber() then Back = true end
                    if train.HVBad and train.AsyncInverter then HVBad = true end
                    if train.PantDisabled then PantDisabled = true end
                    if train.AsyncInverter then motor = motor + 1 else trailer = trailer + 1 end
                end
                self.MotorWagc, self.TrailerWagc = motor, trailer

                local doorsNotClosed = false

                self.PantDisabled = PantDisabled
                if HVBad and not self.HVBad then self.HVBad = CurTime() end
                if not HVBad and self.HVBad then self.HVBad = false end
                self.SchemeEngaged = false
                if RvWork and not Back then
                    for i = 1, self.WagNum do
                        Train:CANWrite("BUKP", Train:GetWagonNumber(), "BUV", self.Trains[i], "Orientate", i % 2 > 0)
                    end

                    if self.Reset == nil then self.Reset = true end
                    local pbcMin, pbcMax
                    local uLvmin, uLvmax
                    local uHvmin, uHvmax
                    local countBL, countEsd = 0, 0
                    for i = 1, self.WagNum do
                        local trainid = self.Trains[i]
                        local train = self.Trains[trainid]
                        if train and train.BCPressure and train.BLPressure then
                            if not pbcMin or train.BCPressure < pbcMin then pbcMin = train.BCPressure end
                            if not pbcMax or train.BCPressure > pbcMax then pbcMax = train.BCPressure end
                            if not uLvmin or train.LV < uLvmin then uLvmin = train.LV end
                            if not uLvmax or train.LV > uLvmax then uLvmax = train.LV end
                            if not uHvmin or train.HVVoltage < uHvmin then uHvmin = train.HVVoltage end
                            if not uHvmax or train.HVVoltage > uHvmax then uHvmax = train.HVVoltage end
                            if train.BLPressure and train.BLPressure < 2.1 then countBL = countBL + 1 end
                            if train.BLPressure and train.BLPressure < 2.6 then countEsd = countEsd + 1 end
                        end
                    end

                    if countBL > 1 and Train.BARS.RVTB == 1 and not Train.Pneumatic.RVTBTimer and not self.BLTimer then
                        self.BLTimer = CurTime() + 9
                    elseif countBL < 2 and self.BLTimer then
                        self.BLTimer = nil
                    end

                    local bvEnabled = 0
                    local bvDisabled = 0
                    local ptApplied = false
                    local cabDoors = false
                    local hvBad = 0
                    local hvGood = 0
                    local condAny = false
                    local voGood = true
                    local schemeAll = true
                    local schemeAny = false
                    local btbAll = true

                    local noOrient = self.Errors.NoOrient
                    self:BeginWagonsCheck()

                    for i = 1, self.WagNum do
                        local trainid = self.Trains[i]
                        local train = self.Trains[trainid]
                        local doorclose = true
                        for d = 1, 8 do
                            if not train["Door" .. d .. "Closed"] then
                                doorclose = false
                                break
                            end
                        end

                        local working = self:CheckBuv(train)
                        self:CheckWagError(i, "BuvDiscon", not working)
                        self:CheckWagError(i, "NoOrient", working and train.WagNOrientated)
                        self:CheckWagError(i, "EmergencyBrake", working and train.EmergencyBrake)
                        self:CheckWagError(i, "ParkingBrake", working and train.ParkingBrakeEnabled)
                        self:CheckWagError(i, "Doors", working and not doorclose)
                        self:CheckWagError(i, "RearCabin", working and train.DoorBack and trainid ~= Train:GetWagonNumber())
                        self:CheckWagError(i, "PassLights", working and not train.PassLightEnabled)
                        self:CheckWagError(i, "BvDisabled", working and train.AsyncInverter and not train.BVEnabled)

                        if working then
                            ptApplied = not ptApplied and train.PTEnabled and i or ptApplied and train.PTEnabled and true or ptApplied
                            doorsNotClosed = doorsNotClosed or not doorclose

                            if train.BVEnabled then bvEnabled = bvEnabled + 1 end
                            if not train.BVEnabled and train.AsyncInverter then bvDisabled = bvDisabled + 1 end
                            if not train.HVBad and train.AsyncInverter then hvGood = hvGood + 1 end
                            if train.HVBad and train.AsyncInverter then hvBad = hvBad + 1 end
                            if train.Cond1 or train.Cond2 then condAny = true end
                            if not working or not train.PSNEnabled or not train.PassLightEnabled then voGood = false end
                            if not train.Scheme and train.AsyncInverter then schemeAll = false end
                            if train.Scheme and train.AsyncInverter then schemeAny = true end
                            if train.PTEnabled then ptAll = false end
                            if not train.BTBReady then btbAll = false end
                        end

                        --Errors
                        Train:SetNW2Bool("Skif:Doors" .. i, doorclose)
                        Train:SetNW2Bool("Skif:BV" .. i, train.BVEnabled)
                        Train:SetNW2Bool("Skif:BUVState" .. i, working)
                        Train:SetNW2Bool("Skif:Battery" .. i, train.Battery)
                        Train:SetNW2Bool("Skif:BTBReady" .. i, train.BTBReady)
                        Train:SetNW2Bool("Skif:EPTGood" .. i, train.EmergencyBrakeGood)
                        Train:SetNW2Bool("Skif:EmerActive" .. i, not train.EmergencyBrake)
                        Train:SetNW2Bool("Skif:PTApply" .. i, not train.PTEnabled)
                        Train:SetNW2Bool("Skif:PSNEnabled" .. i, train.PSNEnabled)
                        Train:SetNW2Bool("Skif:PSNWork" .. i, train.PSNWork)
                        Train:SetNW2Bool("Skif:Cond1" .. i, train.Cond1)
                        Train:SetNW2Bool("Skif:Cond2" .. i, train.Cond2)
                        Train:SetNW2Bool("Skif:PSNBroken" .. i, not train.PSNBroken)
                        Train:SetNW2Bool("Skif:Scheme" .. i, train.Scheme)
                        Train:SetNW2Bool("Skif:TPEnabled" .. i, train.EnginesBroken)
                        Train:SetNW2Bool("Skif:LVGood" .. i, not train.LVBad)
                        Train:SetNW2Bool("Skif:BVEnabled" .. i, train.BVEnabled)
                        Train:SetNW2Bool("Skif:PBApply" .. i, not train.ParkingBrakeEnabled)
                        Train:SetNW2Bool("Skif:BadCombination" .. i, not train.BadCombination)
                        Train:SetNW2Bool("Skif:AsyncInverter" .. i, train.AsyncInverter)
                        Train:SetNW2Bool("Skif:HVGood" .. i, not train.HVBad)
                        local orientation = train.Orientation
                        local doorleftopened, doorrightopened = false, false
                        for d = 1, 4 do
                            local l = not train["Door" .. (orientation and d or d + 4) .. "Closed"]
                            local r = not train["Door" .. (orientation and d + 4 or d) .. "Closed"]
                            if l and not doorleftopened then doorleftopened = true end
                            if r and not doorrightopened then doorrightopened = true end
                        end

                        Train:SetNW2Bool("Skif:DoorLeft" .. i, doorleftopened)
                        Train:SetNW2Bool("Skif:DoorRight" .. i, doorrightopened)
                        self.SchemeEngaged = self.SchemeEngaged or not train.NoAssembly

                        local short = false
                        for idx = 1, 4 do
                            short = short or not train["UKKZ" .. idx]
                            Train:SetNW2Bool("Skif:UKKZ" .. idx .. i, train["UKKZ" .. idx])
                        end
                        shortAny = shortAny or working and short
                        self:CheckWagError(i, "Short", working and short)

                        local curBroken = false
                        for sfp, sfs in ipairs(self.SFTbl) do
                            for sf in pairs(sfs) do
                                if working and not train[sf] then
                                    sfBroken = sfp .. sf
                                    curBroken = true
                                end
                            end
                        end
                        self:CheckWagError(i, "SF", curBroken)

                        Train:SetNW2Bool("Skif:AddressDoorsL" .. i, orientation and train.AddressDoorsL or not orientation and train.AddressDoorsR)
                        Train:SetNW2Bool("Skif:AddressDoorsR" .. i, orientation and train.AddressDoorsR or not orientation and train.AddressDoorsL)

                        local cab = not not train.HasCabin
                        Train:SetNW2Bool("Skif:HasCabin" .. i, cab)
                        if cab then
                            Train:SetNW2Bool("Skif:DoorML" .. i, orientation and train.CabDoorLeft or not orientation and train.CabDoorRight)
                            Train:SetNW2Bool("Skif:DoorMR" .. i, orientation and train.CabDoorRight or not orientation and train.CabDoorLeft)
                            Train:SetNW2Bool("Skif:DoorT" .. i, train.CabDoorPass)
                            cabDoors = cabDoors or not train.CabDoorLeft or not train.CabDoorRight or not train.CabDoorPass
                        end

                        Train:SetNW2Bool("Skif:CondK" .. i, train.CondK)
                    end

                    self:EndWagonsCheck()

                    if doorsNotClosed and not self.DoorControlTimer then
                        self.DoorControlTimer = true
                    end
                    if not doorsNotClosed and self.DoorControlTimer and not isnumber(self.DoorControlTimer) then
                        self.DoorControlTimer = CurTime() + self.DoorControlDelay + math.Rand(-0.2, 0.2) + (Train:GetNW2Bool("KdLongerDelay", false) and 1.2 or 0)
                    end
                    if not doorsNotClosed and isnumber(self.DoorControlTimer) then
                        doorsNotClosed = CurTime() < self.DoorControlTimer
                        if not doorsNotClosed then
                            self.DoorControlTimer = nil
                        end
                    end
                    self.DoorClosed = Train.SF80F1.Value > 0.5 and not doorsNotClosed and 1 or 0

                    local errPT = self.PTEnabled and CurTime() - self.PTEnabled > 2 + (Train.BUV.Slope1 and 1.2 or 0)

                    Train:SetNW2Int("Skif:DoorsAll", self.DoorClosed < 1 and 0 or 1)
                    Train:SetNW2Int("Skif:HvAll", hvGood == 0 and 0 or hvBad == 0 and 1 or 2)
                    Train:SetNW2Int("Skif:BvAll", bvEnabled == 0 and 0 or bvDisabled == 0 and 1 or 2)
                    Train:SetNW2Bool("Skif:CondAny", condAny)
                    Train:SetNW2Bool("Skif:VoGood", voGood)
                    Train:SetNW2Int("Skif:KTR", Train.EmerBrake.Value == 1 and 1 or -1)
                    Train:SetNW2Int("Skif:ALS", Train.ALS.Value * Train.ALSVal == 2 and 1 or -1)
                    Train:SetNW2Int("Skif:BOSD", Train.DoorBlock.Value == 1 and 0 or -1)

                    Train:SetNW2Bool("Skif:ShowDoors", doorsNotClosed)
                    Train:SetNW2Bool("Skif:ShowBV", bvDisabled > 0)
                    Train:SetNW2Bool("Skif:ShowScheme", self.SchemeTimer and self.SchemeTimer < CurTime())
                    Train:SetNW2Bool("Skif:ShowPTApply", errPT)
                    Train:SetNW2Bool("Skif:ShowPBApply", self.Errors.ParkingBrake)
                    Train:SetNW2Bool("Skif:ShowBUVState", self.Errors.BuvDiscon)
                    Train:SetNW2Bool("Skif:ShowBTBReady", not btbAll)

                    local schemeShouldAssemble = schemeAny or RvKro and Train.KV765.Position > 0 and not self.PTEnabled and not self.Errors.EmergencyBrake
                    if not schemeAll and schemeShouldAssemble and not self.SchemeTimer then self.SchemeTimer = CurTime() + 1.8 end
                    if (not schemeShouldAssemble or schemeAll) and self.SchemeTimer then self.SchemeTimer = nil end

                    if self.ProstTimer and Train.MfduF8.Value < 0.5 then self.ProstTimer = nil end
                    Train:SetNW2Bool("Skif:ProstTimer", self.ProstTimer and CurTime() - self.ProstTimer > 0.5)
                    Train:SetNW2Bool("Skif:Prost", self.Prost)
                    Train:SetNW2Bool("Skif:Kos", self.Kos)

					local AD = Train.sys_Autodrive
					local AD_Active = AD.State > 0
                    Train:SetNW2Bool("Skif:AVP:State",AD.State)
                    Train:SetNW2Bool("Skif:AVP:Button",Train.AutoDrive.Value > 0.5)
					Train:SetNW2Bool("Skif:AVP:Boost", Train.sys_Autodrive.ADBoost)

					local NoOrient = self.Errors.NoOrient
					local DoorsControl = Train.Electric.DoorsControl > 0
					if AD_Active then
						if not NoOrient then
							selectLeft = AD.DoorsLeft
							selectRight = AD.DoorsRight
							doorLeft = AD.DoorsLeft
							doorRight = AD.DoorsRight
							doorClose = AD.DoorsClose
						end
					else
						if not NoOrient and Train.DoorSelectL.Value > 0 and Train.DoorSelectR.Value == 0 then selectLeft = true end
						if not NoOrient and Train.DoorSelectR.Value > 0 and Train.DoorSelectL.Value == 0 then selectRight = true end
						if selectLeft and DoorsControl and Train.DoorLeft.Value > 0 and (not Train.ProstKos.BlockDoorsL or Train.DoorBlock.Value == 1) then doorLeft = true end
						if selectRight and DoorsControl and Train.DoorRight.Value > 0 and (not Train.ProstKos.BlockDoorsR or Train.DoorBlock.Value == 1) then doorRight = true end
					end

                    self.CanZeroSpeed = self.CurrentSpeed < 2.8
                    self.BudZeroSpeed = self.CanZeroSpeed and 1 or 0
                    Train:SetNW2Bool("Skif:Cond", self.CondLeto)
                    Train:SetNW2Bool("Skif:DoorBlockL", self.CanZeroSpeed and (not Train.ProstKos.BlockDoorsL or Train.DoorBlock.Value == 1))
                    Train:SetNW2Bool("Skif:DoorBlockR", self.CanZeroSpeed and (not Train.ProstKos.BlockDoorsR or Train.DoorBlock.Value == 1))
                    if Train:ReadTrainWire(33) + (1 - Train.Electric.V2) > 0 and self.EmergencyBrake == 1 then self.EmergencyBrake = 0 end

                    if self.BLTimer and CurTime() - self.BLTimer > 0 and Train.RV.KRRPosition == 0 and Train.Electric.SD == 0 and Train.Electric.V2 > 0 and self.EmergencyBrake == 0 then
                        self.State2 = 51
                        self.EmergencyBrake = 1
                    end

                    self:CheckError("RedLightsAkb", Train.PpzBattLights.Value > 0.5)
                    self:CheckError("AVP:MissedStation",AD.ADnotAvl and not AD_Active and AD.FailReason==6)
                    self:CheckError("AVP:NotWithinReika",AD.ADnotAvl and not AD_Active and (AD.FailReason==4 or AD.FailReason==7))
                    self:CheckError("AVP:LostDoorsWhileDep",AD.ADnotAvl and not AD_Active and AD.FailReason==5)
                    self:CheckError("AVP:DisengageDoorClose",AD_Active and AD.DriveCycle==1 and Train.DoorClose.Value > 0.5)

                    self:CheckError("RightBlock", (not doorRight or Train.DoorClose.Value > 0) and Train.DoorRight.Value > 0)
                    self:CheckError("LeftBlock", (not doorLeft or Train.DoorClose.Value > 0) and Train.DoorLeft.Value > 0)

                    self:CheckError("BrakeLine", self.BLTimer and CurTime() - self.BLTimer > 0)
                    self:CheckError("RvErr", false)
                    self:CheckError("KmErr", false)
                    self:CheckError("DisableDrive", BARS.DisableDrive or self.Errors.DisableDrive and Train.KV765.Position > 0)
                    self.DisableDrive = BARS.DisableDrive or self.Errors.DisableDrive
                    if not self.Errors.NoOrient then self:CheckError("NoOrient", noOrient and Train.KV765.Position > 0) end
                    -- if not self.Errors.Doors then self:CheckError("Doors", self.DoorsNotClosed and Train.KV765.Position > 0) end

                    local err11ch = self.DoorsNotClosed ~= doorsNotClosed
                    if self.Errors.Doors and err11ch then
                        if not self.AutoChPage then self.AutoChPage = self.State2 end
                        self.State2 = 21
                        self.Select = false
                    end
                    if not self.Errors.Doors and err11ch and self.AutoChPage and not self.AwaitOpenDoors then
                        self.State2 = self.AutoChPage or self.State2
                        self.Select = false
                    end
                    if self.AwaitOpenDoors and (not self.AutoChPage or self.Errors.Doors) then
                        self.AwaitOpenDoors = false
                    end
                    self.DoorsNotClosed = doorsNotClosed

                    if CurTime() - self.BErrorsTimer > 0 then
                        if sfBroken ~= self.sfBroken then
                            self.sfBroken = sfBroken
                            if sfBroken and not shortAny then
                                self.State2 = 15 + tonumber(sfBroken[1])
                                self.Select = false
                            end
                        end
                        if shortAny ~= self.shortAny then
                            self.shortAny = shortAny
                            if shortAny then
                                self.State2 = 12
                                self.Select = false
                            end
                        end
                    end

                    if Train.RV["KRO5-6"] == 0 then
						local KV_TRC_SET = Train.KV765.TractiveSetting
                        local AllowDriveInput = BARS.Brake == 0 and BARS.BTB == 1 and BARS.Drive > 0 and not self.DisableDrive and not self.Errors.BuvDiscon and not self.Errors.ParkingBrake

                        if AllowDriveInput or KV_TRC_SET <= 0 then
                            kvSetting = KV_TRC_SET or self.ControllerState or kvSetting
                            if kvSetting ~= 0 then
                                if kvSetting < 0 and kvSetting > -20 then kvSetting = -20 end
                                if kvSetting > 0 and kvSetting <  20 then kvSetting =  20 end
                            end
                            overrideKv = false
                        end

						if KV_TRC_SET==0 and AD.Command~=0 then
							kvSetting = AD.Command*25
						end

                        if Train.ProstKos.ProstActive == 1 and Train.KV765.Position >= 0 then kvSetting = Train.ProstKos.Command end
                        if Train.ProstKos.CommandKos > 0 then kvSetting = -100 overrideKv = true end
                        if BARS.Brake > 0 then kvSetting = -80 overrideKv = true end
                        if self.Errors.EmergencyBrake and self.ZeroSpeed < 1 then kvSetting = -100 overrideKv = true end
                        if Train.KV765.Position > 0 and (BARS.PN3 > 0 or BARS.BTB < 1) then
                            kvSetting = BARS.BUKPErr and -100 or -80
                            overrideKv = true
                        end

                        local sb = not overrideKv and BARS.StillBrake == 1
                        if sb then kvSetting = -50 overrideKv = true end

                        -- if kvSetting < -10 and not sb and Train.KV765.Position > 0 then kvSetting = -100 overrideKv = true end
                        if not sb and (KV_TRC_SET > 0 or Train.KV765.TargetTractiveSetting > 0) and kvSetting <= 0 then
                            Train.KV765:TriggerInput("ResetTractiveSetting", 1)
                        end
                    end

                    Train:SetNW2Bool("Skif:ProstActive", Train.ProstKos.ProstActive > 0)
                    Train:SetNW2Bool("Skif:KosActive", Train.ProstKos.KosActive > 0)
                    Train:SetNW2Bool("Skif:KosCommand", Train.ProstKos.CommandKos > 0)
                    Train:SetNW2Int("Skif:ProstReadings", Train.ProstKos.Readings)
                    Train:SetNW2Int("Skif:ProstDist", 100 * (Train.ProstKos.Distance or 0))
                    if Train.ProstKos.LastTag then
                        Train:SetNW2Int("Skif:ProstData1", Train.ProstKos.LastTag.id % 0x100)
                        Train:SetNW2Int("Skif:ProstData2", Train.ProstKos.LastTag.typ)
                        Train:SetNW2Int("Skif:ProstData3", math.floor(Train.ProstKos.LastTag.dist / 0x100))
                        Train:SetNW2Int("Skif:ProstData4", math.floor(Train.ProstKos.LastTag.dist % 0x100))
                        Train:SetNW2Int("Skif:ProstData5", math.floor(Train.ProstKos.LastTag.station / 0x100))
                        Train:SetNW2Int("Skif:ProstData6", math.floor(Train.ProstKos.LastTag.station % 0x100))
                        Train:SetNW2Int("Skif:ProstData7", Train.ProstKos.LastTag.path)
                        Train:SetNW2Int("Skif:ProstData8", Train.ProstKos.LastTag.doors and 1 or 0)
                    end

                    local checkPt = ptApplied and (kvSetting > 0 or Train.KV765.Position > 0 and not self.Errors.EmergencyBrake)
                    if not self.PTEnabled and checkPt then self.PTEnabled = CurTime() end
                    if self.PTEnabled and not checkPt then self.PTEnabled = nil end

                    self:CheckError("PneumoBrake", errPT and ptApplied, ptApplied)
                    self:CheckError("HV", self.HVBad and CurTime() - self.HVBad > 10)

                    local buv = self.Trains[self.Trains[1]]
                    Train:SetNW2Int("Skif:BUVStrength", math.abs(Train.BUV.Strength))
                    if buv and buv.LV then
                        Train:SetNW2Int("Skif:PNM", buv.TLPressure * 10)
                        Train:SetNW2Int("Skif:PTM", buv.BLPressure * 10)
                        Train:SetNW2Int("Skif:Ubs", buv.LV)
                        if pbcMin then Train:SetNW2Int("Skif:PMin", pbcMin * 10) end
                        if pbcMax then Train:SetNW2Int("Skif:PMax", pbcMax * 10) end
                        if uLvmin then Train:SetNW2Int("Skif:LvMin", uLvmin) end
                        if uLvmax then Train:SetNW2Int("Skif:LvMax", uLvmax) end
                        if uHvmin then Train:SetNW2Int("Skif:HvMin", uHvmin) end
                        if uHvmax then Train:SetNW2Int("Skif:HvMax", uHvmax) end
                    end

                    self.ESD = not self.InitTimer and countEsd > 1 and 1 or 0

                    self.Speed = math.Round(Train.ALSCoil.Speed * 10) / 10
                    self.CurrentSpeed = self.Speed

                    self.BARS1 = (BARS.Drive1 > 0 or self.DisableDrive) and BARS.ATS1
                    self.BARS2 = (BARS.Drive2 > 0 or self.DisableDrive) and BARS.ATS2

                    self:CheckError("ArsFail", Train.PmvAtsBlock.Value < 3 and (BARS.Active * (1 - BARS.ALSMode)) < 1, BARS.ATS1 and not BARS.ATS2 and 1 or BARS.ATS2 and not BARS.ATS1 and 2 or nil)
                    self:CheckError("KmErr", Train.KV765.Online < 1)

                    Train:SetNW2Bool("Skif:NoFreq", BARS.NoFreq and not BARS.KB)
                    Train:SetNW2Bool("Skif:NoFreqReal", BARS.NoFreq)
                    Train:SetNW2Bool("Skif:NextNoFreq", BARS.NextNoFq and not BARS.NoFreq)
                    Train:SetNW2Bool("Skif:Sao", Train.ALSCoil.AO)
                    Train:SetNW2Bool("Skif:Uos", Train.PmvAtsBlock.Value == 3)
                    Train:SetNW2Bool("Skif:AlsArs", Train.PmvFreq.Value > 0)
                    Train:SetNW2Bool("Skif:BarsBrake", Train.BARS.Brake > 0)

                    Train:SetNW2Int("Skif:SpeedLimit", (Train.ALSCoil.AO or BARS.NoFreq and not BARS.KB) and 0 or Train.BARS.SpeedLimit)
                    Train:SetNW2Int("Skif:NextSpeedLimit", (BARS.NoFreq or BARS.NextNoFq) and 0 or Train.BARS.NextLimit)

                    Train:SetNW2Bool("KB", BARS.KB)
                    Train:SetNW2Bool("DisableDrive", self.DisableDrive)
                    Train:SetNW2Bool("Skif:BTB", Train.BUV.BTB)
                    Train:SetNW2Bool("Skif:KRR", RvKrr > 0)
                    Train:SetNW2Bool("Skif:EmerActive", self.Errors.EmergencyBrake)
                    Train:SetNW2Bool("Skif:ParkEnabled", self.Errors.ParkingBrake)
                    Train:SetNW2Bool("Skif:PtApplied", not not ptApplied)
                    Train:SetNW2Bool("Skif:PtAppliedRear", self.Trains[self.WagNum] and self.Trains[self.Trains[self.WagNum]] and self.Trains[self.Trains[self.WagNum]].PTEnabled or false)
                    self.AO = Train.ALSCoil.AO

                    for i = 1, self.WagNum do
                        local train = self.Trains[self.Trains[i]]
                        Train:SetNW2Bool("Skif:InvSf" .. i, train.SF23F4)
                    end

                    if self.State2 == 11 or self.State2 == 01 then
                        for i = 1, self.WagNum do
                            local train = self.Trains[self.Trains[i]]
                            Train:SetNW2Bool("Skif:BuksGood" .. i, true)
                            Train:SetNW2Bool("Skif:MKState" .. i, not train.MKWork and -1 or train.MKCurrent > 5 and 1 or 0)
                            Train:SetNW2Bool("Skif:LightsWork" .. i, train.PassLightEnabled)
                            Train:SetNW2Bool("Skif:PantDisabled" .. i, not train.PantDisabled)
                            Train:SetNW2Bool("Skif:RessoraGood" .. i, true)
                            Train:SetNW2Bool("Skif:PUGood" .. i, true)
                            Train:SetNW2Bool("Skif:BUDWork" .. i, train.BUDWork)
                            Train:SetNW2Bool("Skif:WagOr" .. i, train.Orientation)
                        end
                    elseif self.State2 == 13 then
                        for i = 1, self.WagNum do
                            local train = self.Trains[self.Trains[i]]
                            for k = 1, 8 do
                                Train:SetNW2Bool("Skif:DPBT" .. k .. i, train["DPBT" .. k])
                            end
                        end
                    elseif self.State2 == 14 then
                        for i = 1, self.WagNum do
                            local train = self.Trains[self.Trains[i]]
                            for k = 1, 4 do
                                Train:SetNW2Bool("Skif:Pant" .. k .. i, not train.PantDisabled)
                                Train:SetNW2Bool("Skif:Pant" .. k .. i, not train.PantDisabled)
                            end
                        end
                    elseif self.State2 > 15 and self.State2 < 18 then
                        for i = 1, self.WagNum do
                            local train = self.Trains[self.Trains[i]]
                            for sf in pairs(self.SFTbl[self.State2 - 15]) do
                                Train:SetNW2Bool("Skif:Sf" .. sf .. i, train[sf])
                            end
                        end
                    elseif self.State2 == 21 then
                        for i = 1, self.WagNum do
                            local train = self.Trains[self.Trains[i]]
                            local orientation = train.Orientation
                            Train:SetNW2Bool("Skif:WagOr" .. i, orientation)
                            for d = 1, 4 do
                                Train:SetNW2Bool("Skif:Door" .. d .. "L" .. i, train["Door" .. (orientation and d or d + 4) .. "Closed"])
                                Train:SetNW2Bool("Skif:Door" .. d .. "R" .. i, train["Door" .. (orientation and d + 4 or d) .. "Closed"])
                                Train:SetNW2Bool("Skif:DoorReverse" .. d .. "L" .. i, train["DoorReverse" .. (orientation and d or 9 - d)])
                                Train:SetNW2Bool("Skif:DoorReverse" .. d .. "R" .. i, train["DoorReverse" .. (orientation and 9 - d or d)])
                                Train:SetNW2Bool("Skif:DoorAod" .. d .. "L" .. i, train["DoorAod" .. (orientation and d or 9 - d)])
                                Train:SetNW2Bool("Skif:DoorAod" .. d .. "R" .. i, train["DoorAod" .. (orientation and 9 - d or d)])
                            end
                        end
                    elseif self.State2 == 31 or self.State2 == 32 then
                        for i = 1, self.WagNum do
                            local train = self.Trains[self.Trains[i]]
                            Train:SetNW2Int("Skif:BrakeStrength" .. i, math.abs(train.BrakeStrength or 0) * 100)
                            Train:SetNW2Int("Skif:DriveStrength" .. i, math.abs(train.DriveStrength or 0) * 100)
                            Train:SetNW2Int("Skif:Power" .. i, train.ElectricEnergyUsed)
                            Train:SetNW2Int("Skif:I" .. i, train.I)
                            Train:SetNW2Int("Skif:U" .. i, train.HVVoltage)
                        end
                    elseif self.State2 == 41 then
                        for i = 1, self.WagNum do
                            local train = self.Trains[self.Trains[i]]
                            Train:SetNW2Int("Skif:IMK" .. i, train.MKCurrent and train.MKCurrent * 10)
                            Train:SetNW2Int("Skif:IVO" .. i, train.VagEqConsumption * 10)
                            Train:SetNW2Int("Skif:UBS" .. i, train.LV and train.LV * 10 or 0)
                            Train:SetNW2Int("Skif:U" .. i, train.HVVoltage and train.HVVoltage * 10 or 0)
                            Train:SetNW2Int("Skif:I" .. i, train.I)
                            Train:SetNW2Int("Skif:Power" .. i, train.ElectricEnergyUsed)
                            Train:SetNW2Int("Skif:Dissipated" .. i, train.ElectricEnergyDissipated)
                        end
                    elseif self.State2 == 51 or self.State2 == 52 then
                        for i = 1, self.WagNum do
                            local train = self.Trains[self.Trains[i]]
                            Train:SetNW2Int("Skif:P" .. i, train.BCPressure * 10)
                            Train:SetNW2Int("Skif:P2" .. i, (train.BCPressure2 or train.BCPressure) * 10)
                            Train:SetNW2Int("Skif:Pnm" .. i, train.TLPressure * 10)
                            Train:SetNW2Int("Skif:Ptm" .. i, train.BLPressure * 10)
                            Train:SetNW2Int("Skif:Pstt" .. i, train.ParkingBrakePressure * 10)
                            Train:SetNW2Int("Skif:Pskk" .. i, train.HPPressure * 10)
                            Train:SetNW2Bool("Skif:BrakeEquip" .. i, train.BrakeEquip or false)
                            Train:SetNW2Int("Skif:Pauto1" .. i, train.BTOKTO1 * 10)
                            Train:SetNW2Int("Skif:Pauto2" .. i, train.BTOKTO2 * 10)
                            Train:SetNW2Int("Skif:Pauto3" .. i, train.BTOKTO3 * 10)
                            Train:SetNW2Int("Skif:Pauto4" .. i, train.BTOKTO4 * 10)

                            local green = true
                            for k = 1, 8 do
                                if not train["DPBT" .. k] then
                                    green = false
                                    break
                                end
                            end
                            Train:SetNW2Bool("Skif:DPBT" .. i, green)
                        end

                    end

                    local pvu = false
                    for k = 1, self.WagNum do
                        local train = self.Trains[k]
                        for i = 1, 9 do
                            local val = self.PVU[train] and self.PVU[train][i]
                            Train:SetNW2Bool("Skif:PVU" .. i .. k, val)
                            pvu = pvu or val
                        end
                    end
                    Train:SetNW2Bool("Skif:Pvu", pvu)

                    if not self.Slope and Train.AccelRate.Value > 0 and (Train.BARS.Speed <= 2 or kvSetting == 0) then
                        self.Slope = true
                        self.SlopeSpeed = Train.BARS.Speed <= 2
                    end

                    if self.Slope and (not self.SchemeEngaged or not self.SlopeSpeed and kvSetting ~= 0) then self.Slope = false end
                else
                    if not self.InitTimer then self.Reset = nil end
                    self.AO = false
                    self.TimeEntered = nil
                    self.DateEntered = nil
                    self.EmergencyBrake = 0
                    self.BTB = 0
                    self.BErrorsTimer = CurTime() + 3
                    if self.PTEnabled then self.PTEnabled = nil end
                    self.BLTimer = nil
                    self:ClearErrors()
                    -- if self.Error then self.Errors[self.Error] = false end
                end

                Train:SetNW2Bool("AOState", self.AO)

                self:CheckError("RvErr", not RvWork and not Back)
                if not self.InitTimer then
                    self:CommitError()
                end

                if RV == 0 and not Back then
                    self.MainMsg = MAINMSG_RVOFF
                else
                    self.MainMsg = Back and RvWork and MAINMSG_2RV or Back and MAINMSG_REAR or not RvWork and RV > 0 and MAINMSG_RVFAIL or not RvWork and MAINMSG_RVOFF or MAINMSG_NONE
                end

                if not (Train.DoorBlock.Value * Train.EmergencyDoors.Value == 1) and (Train.PpzUpi.Value * Train.DoorClose.Value) == 1 then doorClose = true end
                --if Train.DoorClose.Value == 1 then doorClose = true end
            else
                self.DoorClosed = 0
            end

            for i = 1, 9 do
                Train:SetNW2Int("Skif:WagNum" .. i, self.Trains[i] or 0)
            end

            local addrDoors = Train:GetNW2Bool("AddressDoors", false) and Train.Electric.UPIPower * (1 - Train.PmvAddressDoors.Value) > 0.5
            self:CState("OpenLeft", doorLeft)
            self:CState("OpenRight", doorRight)
            self:CState("SelectLeft", selectLeft)
            self:CState("SelectRight", selectRight)
            self:CState("CloseDoors", doorClose)
            self:CState("AddressDoors", addrDoors)
            self:CState("Slope", Train.RV.KRRPosition == 0 and self.Slope)
            self:CState("SlopeSpeed", self.SlopeSpeed)
            if self.WagNum > 0 then
                self.EnginesStrength = EnginesStrength / self.WagNum
            else
                self.EnginesStrength = 0
            end

            if (Train.DoorLeft.Value + Train.DoorRight.Value) > 0 then
                if not self.AutoChPage then self.AutoChPage = self.State2 end
                self.State2 = 21
                self.AwaitOpenDoors = true
                self.Select = false
            end

            self.ControllerState = kvSetting
            Train:SetNW2Int("Skif:Throttle", (overrideKv or Train.ProstKos.Command < 10) and kvSetting or Train.KV765.TargetTractiveSetting)
            Train:SetNW2Bool("Skif:OverrideKv", overrideKv)

            self:CState("RV", RvWork, "BUKP")
            self:CState("Ring", Train.Ring.Value > 0, "BUKP")
            self:CState("DriveStrength", math.abs(kvSetting))
            self:CState("Brake", kvSetting < 0 and 1 or 0)
            self:CState("StrongerBrake", kvSetting < 0 and kvSetting < -75 and Train.BARS.StillBrake == 0 and 1 or 0)
            self:CState("PN1", Train.BARS.PN1)
            self:CState("PN2", Train.BARS.PN2 + (self.Slope and Train.RV.KROPosition ~= 0 and self.SlopeSpeed and 1 or 0))
            self:CState("PN3", Train.BARS.PN3)
            for t = 1, self.WagNum do
                local train = self.Trains[t]
                if train then
                    for i = 1, 9 do
                        self:CStateTarget("PVU" .. train .. "_" .. i, "PVU" .. i, "BUV", train, self.PVU[train] and self.PVU[train][i])
                    end
                    self:CStateTarget(
                        "PantDisabled" .. train, "PantDisabled", "BUV", train,
                        (Train.PmvPant.Value == 0 or Train.PmvPant.Value == 2) and t > self.WagNum / 2 or (Train.PmvPant.Value == 0 or Train.PmvPant.Value == 1) and t <= self.WagNum / 2
                    )
                    self:CStateTarget("WagIdx" .. train, "WagIdx", "BUV", train, t)
                    self:CStateTarget("TrainLen" .. train, "TrainLen", "BUV", train, self.WagNum)
                end
            end

            local ring = false
            for i = 2, self.WagNum do
                local train = self.Trains[self.Trains[i]]
                if train and train.Ring then ring = true end
            end
            self.CallRing = ring

            self.Ring = Train.BARS.Ring > 0
            self.ErrorRinging = (Train.ProstKos.Receiving and Train.Speed > 2 or Train.ProstKos.CommandKos > 0) or self.ErrorRing and CurTime() - self.ErrorRing < 2
            if self.MainMsg < 2 then
                self.PSN = (Train.PpzUpi.Value > 0) and self.State == 5
                self.Compressor = (Train.PpzUpi.Value * Train.SF30F4.Value * Train.Battery.Value > 0) and self.State == 5 and Train.AK.Value > 0
                self.PassLight = (1 - Train.PmvLights.Value) * Train.SF52F2.Value > 0 and self.State == 5
            end

            self:CState("ZeroSpeed", self.CanZeroSpeed)
            self:CState("TP1", (Train.PmvPant.Value == 0 or Train.PmvPant.Value == 2) and Train.PpzUpi.Value > 0)
            self:CState("TP2", (Train.PmvPant.Value == 0 or Train.PmvPant.Value == 1) and Train.PpzUpi.Value > 0)
            self:CState("PR", Train.Pr.Value * Train.PpzUpi.Value > 0)
            self:CState("Cond1", Train.PpzUpi.Value * (1 - Train.PmvCond.Value) * Train.SF61F8.Value * Train.PpzPrimaryControls.Value * Train.PpzUpi.Value * Train.PpzPrimaryControls.Value * Train.PpzUpi.Value > 0)
            self:CState("ReccOff", Train.PpzUpi.Value * Train.OtklR.Value > 0)
            self:CState("ParkingBrake", Train.PmvParkingBrake.Value * Train.PpzUpi.Value * Train.SF22F3.Value * Train.Electric.V2 > 0)
            self:CState("PassLight", self.PassLight)
            self:CState("PSN", self.PSN)
            self:CState("Ticker", true)
            self:CState("PassScheme", true)
            self:CState("Compressor", self.Compressor)
            if self.State >= 4 and self.Active > 0 then
                self:CState("BVOn", Train.KV765.Position <= 0 and Train.EnableBV.Value * Train.PpzUpi.Value > 0)
                self:CState("BVOff", Train.DisableBV.Value * Train.PpzUpi.Value > 0)
            end

            Train:SetNW2Int("Skif:Ptm", math.Round(Train.Pneumatic.BrakeLinePressure, 1) * 10)
            Train:SetNW2Int("Skif:Pnm", math.Round(Train.Pneumatic.TrainLinePressure, 1) * 10)
            Train:SetNW2Int("Skif:Ubs", math.Round(Train.Electric.Battery80V, 1) * 10)
            Train:SetNW2Int("Skif:Uhv", math.Round(Train.Electric.Main750V, 1) * 10)
            Train:SetNW2Int("Skif:Speed", BARS.Speed)
        else
            self.Ring = false
        end

        Train:SetNW2Int("Skif:ARS1", not BARS.BarsPower and 2 or BARS.ATS1Bypass and -1 or not self.BARS1 and 0 or self.DisableDrive and 2 or 1)
        Train:SetNW2Int("Skif:ARS2", not BARS.BarsPower and 2 or BARS.ATS2Bypass and -1 or not self.BARS2 and 0 or self.DisableDrive and 2 or 1)
        Train:SetNW2Int("Skif:MainMsg", self.MainMsg)

        self.EmergencyBrake = self.State == 5 and self.EmergencyBrake or 0
        self:CState("BUPWork", self.State > 0)
        Train:SetNW2Int("Skif:DepotSel", self.DepotSel)
        if Train.Electric.UPIPower < 0.5 then
            Train:SetNW2Int("Skif:State", 0)
        end
        if Train.PpzAts2.Value + Train.PpzAts1.Value > 0 and Train:GetNW2Int("Skif:State") == 5 or Train:GetNW2Int("Skif:State") < 5 or not Power then
            Train:SetNW2Bool("Skif:DepotMode", self.DepotMode)
            Train:SetNW2Bool("Skif:DepotWags", self.DepotWags)
            Train:SetNW2Int("Skif:State", self.State * Train.Electric.UPIPower)
            Train:SetNW2Int("Skif:State2", self.State2)
            Train:SetNW2Int("Skif:PvuWag", self.PvuWag)
            Train:SetNW2Int("Skif:PvuSel", self.PvuCursor)
            Train:SetNW2Int("Skif:Select", self.Select or 0)

            local line = "---"
            local BUIK = Train.BUIK
            if BUIK then
                if BUIK.IsServiceRoute then
                    line = BUIK.LastStation
                elseif BUIK.RouteCfg and BUIK.RouteCfg.Name then
                    line = BUIK.RouteCfg.Name
                    line = string.Trim(string.Replace(string.Replace(line, "линия", ""), "Линия", ""))
                end
            end
            Train:SetNW2String("Skif:LineName", line)
        end

        local ZeroSpeed = self.State == 5 and self.CurrentSpeed < 0.6
        if ZeroSpeed then
            ZeroSpeed = false
            if not self.ZeroSpeedTimer then
                self.ZeroSpeedTimer = CurTime() + math.Rand(0.6 + self.ZeroSpeedDelay, 0.8 + self.ZeroSpeedDelay)
            elseif CurTime() >= self.ZeroSpeedTimer then
                ZeroSpeed = true
            end
        else
            self.ZeroSpeedTimer = nil
        end
        self.ZeroSpeed = ZeroSpeed and 1 or 0

        if self.State < 2 and self.DepotMode then self.DepotMode = false end
        if not self.DepotMode and self.DepotWags then self.DepotWags = false end
        if self.State > 0 and self.Reset and self.Reset == 1 then self.Reset = false end
        if self.PvuWag > 0 and not (self.State == 5 and self.State2 == 01) then self.PvuWag = 0 end
    end
else

    function TRAIN_SYSTEM:ClientThink()
        if not self.Train:ShouldDrawPanel("MFDU") then return end
        if not self.DrawTimer then
            render.PushRenderTarget(self.Train.MFDU, 0, 0, 1024, 768)
            render.Clear(0, 0, 0, 0)
            render.PopRenderTarget()
        end

        local drawThrottle = self.NormalWork and self.DrawMainThrottle
        local skipOther = self.DrawTimer and CurTime() - self.DrawTimer < 0.1
        if not drawThrottle and skipOther then return end
        if not skipOther then self.DrawTimer = CurTime() end

        local state = self.Train:GetNW2Int("Skif:State", 0)
        local poweroff = state == 0
        skipOther = skipOther or state == -2 or poweroff
        if not skipOther then
            self.State = self.Train:GetNW2Bool("Skif:DepotMode", false) and 2 or state
            self.State2 = self.State ~= 2 and self.Train:GetNW2Int("Skif:State2", 0) or self.Train:GetNW2Bool("Skif:DepotWags", false) and 1 or 0
            self.Select = self.Train:GetNW2Int("Skif:Select", 0)
            self.WagNum = self.Train:GetNW2Int("Skif:WagNum", 0)
            self.MainScreen = self.State == 5 and self.State2 == 0
        end
        render.PushRenderTarget(self.Train.MFDU, 0, 0, 1024, 768)
        if not skipOther or poweroff then
            render.Clear(0, 0, 0, 0)
        end
        cam.Start2D()
        if not skipOther then
            self:SkifMonitor(self.Train)
        end
        if state == 5 and drawThrottle and self.NormalWork then
            self:DrawMainThrottle()
        end
        cam.End2D()
        render.PopRenderTarget()
    end
end
