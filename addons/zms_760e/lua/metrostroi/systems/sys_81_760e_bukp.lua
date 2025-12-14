--------------------------------------------------------------------------------
-- Блок Управления и Контроля Поезда (Витязь)
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
    {"EmergencyBrake", "Экстренное торможение.", "Стояночный тормоз прижат\nна %d вагоне."},
    {"ParkingBrake", "Стояночный тормоз прижат.", "Стояночный тормоз прижат\nна %d вагоне."},
    {"PneumoBrake", "Пневмотормоз включен.", "Пневмотормоз включен\nна %d вагоне."},
    {"Doors", "Двери не закрыты.", "Двери не закрыты на %d вагоне."},
}
local ErrorsB = {
    {"RightBlock", "Правые двери заблокированы.",},
    {"LeftBlock", "Левые двери заблокированы.",},
    {"HV", "Напряжение КС.",},
    {"RearCabin", "Открыта кабина ХВ.",},
}
local ErrorsC = {
    {"SF", "Включи автомат.", "Включи автомат на %d вагоне."},
    {"PassLights", "Освещение не включено.", "Освещение не включено\nна %d вагоне.",},
}

local ErrRingContinuous = {
    RightBlock = true,
    LeftBlock = true,
}

local Error2id = {}
for idx, err in ipairs(ErrorsA) do Error2id[ErrorsA[idx][1]] = idx end
for idx, err in ipairs(ErrorsB) do Error2id[ErrorsB[idx][1]] = idx + #ErrorsA end
for idx, err in ipairs(ErrorsC) do Error2id[ErrorsC[idx][1]] = idx + #ErrorsB + #ErrorsA end
local ErrorIdx2Name = {}
for name, idx in pairs(Error2id) do ErrorIdx2Name[idx] = name end

local kv_765_map = {
    [4] = 100,
    [3] = 80,
    [2] = 40,
    [1] = 20,
    [0] = 0,
    [-1] = -40,
    [-2] = -60,
    [-3] = -100,
}
local function translate_oka_kv_to_765(pos)
    return kv_765_map[pos] or 0
end

function TRAIN_SYSTEM:Initialize()
    self.PowerCommand = 0
    self.PowerTarget = 0
    self.CurrentCab = false

    self.Train:LoadSystem("MfduF1", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("MfduF2", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("MfduF3", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("MfduF4", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("Mfdu1", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("Mfdu4", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("Mfdu7", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("Mfdu2", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("Mfdu5", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("Mfdu8", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("Mfdu0", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("Mfdu3", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("Mfdu6", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("Mfdu9", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("MfduF5", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("MfduF6", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("MfduF7", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("MfduF8", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("MfduF9", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("MfduHelp", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("MfduKontr", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("MfduTv", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("MfduTv1", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("MfduTv2", "Relay", "Switch", { bass = true })

    self.TriggerNames = {"MfduF1", "MfduF2", "MfduF3", "MfduF4", "Mfdu1", "Mfdu2", "Mfdu3", "Mfdu4", "Mfdu5", "Mfdu6", "Mfdu7", "Mfdu8", "Mfdu9", "Mfdu0", "MfduKontr", "MfduHelp", "MfduF6", "MfduF7", "MfduF5", "MfduF9", "MfduF8", "MfduTv", "MfduTv1", "MfduTv2", "AttentionMessage"}
    self.Triggers = {}
    for k, v in pairs(self.TriggerNames) do
        if self.Train[v] then self.Triggers[v] = self.Train[v].Value > 0.5 end
    end

    self.State = 0
    self.State2 = 0
    self.LegacyScreen = false
    self.Trains = {}
    self.Errors = {}
    self.WagErrors = {}
    self.ErrorsLog = {}
    self.Error = 0
    self.ErrorParams = {}
    self.Password = ""
    self.Selected = 0
    self.MsgPage = 1
    self.Messages = {{}}
    self.CondLeto = true
    self.Time = "0"
    self.RouteNumber = "0"
    self.WagNum = 0
    self.DepotCode = "1"
    self.DepeatStation = "0"
    self.Path = "0"
    self.Dir = "0"
    self.DBand = "848"
    self.Deadlock = "0"
    self.BTB = false
    self.BRBK1 = true
    self.Loop = true
    self.AO = false
    self.Compressor = false
    self.BlockLeft = true
    self.BlockRight = true
    self.DoorControlDelay = math.random() * 0.9 + 0.2
    self.States = {}
    self.PVU = {}
    self.Active = 0
    self.MainMsg = 0
    self.EnginesStrength = 0
    self.ControllerState = 0
    self.EmergencyBrake = 0
    self.BTB = 0
    self.CurrentSpeed = 0
    self.ZeroSpeed = 0
    self.Speed = 0
    self.CurTime = CurTime()
    self.Prost = false
    self.Kos = false
    self.Ovr = false
    self.DoorClosed = false
    self.CurTime1 = CurTime()
    self.FirstPressed = {}

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
    return {"State", "ControllerState", "EmergencyBrake", "BTB", "WagNum", "Prost", "Kos", "CurrentSpeed", "InitTimer", "ZeroSpeed", "Active"}
end

function TRAIN_SYSTEM:Inputs()
    return {}
end

if TURBOSTROI then return end

include("ui_81_760e_bukp.lua")

function TRAIN_SYSTEM:TriggerInput(name, value)
end

local function IsValidDate(value)
    --  Check for a UK date pattern dd/mm/yyyy , dd-mm-yyyy, dd.mm.yyyy
    --      My applications needs a textual response
    --      change the return values if you need true / false
    if string.match(value, "^%d+%p%d+%p%d%d%d%d$") then
        local d, m, y = string.match(value, "(%d+)%p(%d+)%p(%d+)")
        d, m, y = tonumber(d), tonumber(m), tonumber(y)
        local dm2 = d * m * m
        if y < 2010 then --1970
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
                    --self.PassedState2 = false
                    self.State = 2
                    self.State2 = 0
                    self.Selected = 0
                else
                    self.Password = ""
                end
            end

            if char and #self.Password < 4 and value then self.Password = self.Password .. char end
            Train:SetNW2String("SkifPass", self.Password)
        elseif self.State == 2 and RV ~= 0 then
            if self.State2 == 0 then
                if self.Entering then
                    local num = (self.Selected == 1 and 8 or self.Selected == 2 and 6) or (self.Selected == 7 or self.Selected == 8 or self.Selected == 4) and 1 or (self.Selected == 5 or self.Selected == 9) and 3 or 2
                    if name == BTN_MODE and value and #self.Entering == num then
                        if self.Selected == 1 then
                            self.Date1 = os.date("!*t", 75601)
                            if not IsValidDate(self.Entering:sub(1, 2) .. "." .. self.Entering:sub(3, 4) .. "." .. self.Entering:sub(5, 8)) then
                                self.Date1.day = "01"
                                self.Date1.month = "01"
                                self.Date1.year = "2010"
                            else
                                self.Date1.day = self.Entering:sub(1, 2)
                                self.Date1.month = self.Entering:sub(3, 4)
                                self.Date1.year = self.Entering:sub(5, 8)
                            end

                            self.DateEntered = true
                        end

                        if self.Selected == 2 then
                            self.Timer1 = tonumber(self.Entering:sub(1, 2)) * 3600 + tonumber(self.Entering:sub(3, 4)) * 60 + tonumber(self.Entering:sub(5, 6)) + 75600
                            self.TimeEntered = true
                        end

                        if self.Selected == 3 then self.RouteNumber = self.Entering end
                        if self.Selected == 4 and tonumber(self.Entering) < 9 then self.WagNum = tonumber(self.Entering) end
                        if self.Selected == 5 then self.DepotCode = self.Entering end
                        if self.Selected == 6 then self.DepeatStation = self.Entering end
                        if self.Selected == 7 then self.Path = self.Entering end
                        if self.Selected == 8 then self.Dir = self.Entering end
                        if self.Selected == 9 then self.DBand = self.Entering end
                        self.Entering = false
                    end

                    if name == BTN_MODE and value then self.Entering = false end
                    if char and value and char and #self.Entering < num and value then self.Entering = self.Entering .. char end
                    if name == BTN_CLEAR and value then self.Entering = self.Entering:sub(1, -2) end
                else
                    -- if name == BTN_UP and value and self.Selected > 0 then self.Selected = self.Selected - 1 end
                    -- if name == BTN_DOWN and value and self.Selected < 9 then self.Selected = self.Selected + 1 end
                    if name == BTN_ENTER and value then
                        if self.WagNum > 0 then
                            for i = 1, self.WagNum do
                                Train:CANWrite("BUKP", Train:GetWagonNumber(), "BUV", self.Trains[i], "Orientate", i % 2 > 0)
                            end
                        end
                        self.State = 3
                    end

                    -- if name == BTN_MODE and value then
                    --     if self.Selected == 0 then self.State2 = 1 end
                    --     if self.Selected > 0 then self.Entering = "" end
                    -- end
                end
            elseif self.State2 == 1 then
                if name == BTN_ENTER and value then
                    if self.Entering and #self.Entering == 5 then
                        local wagnum = tonumber(self.Entering)
                        self.Trains[wagnum] = {}
                        if not wagnum or wagnum == 0 then
                            self.Trains[wagnum] = nil
                            wagnum = nil
                        end

                        self.Trains[self.Selected + 1] = wagnum
                        self.Entering = false
                    elseif not self.Entering then
                        self.State2 = 0
                        self.Selected = 0
                        --self.PassedState2 = true
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
                    Train:SetNW2String("SkifEnter", self.Entering)
                else
                    if name == BTN_UP and value and self.Selected > 0 then self.Selected = self.Selected - 1 end
                    if name == BTN_DOWN and value and self.Selected < 8 then self.Selected = self.Selected + 1 end
                end
            end
        elseif self.State == 3 and name == BTN_ENTER and value and RV ~= 0 then
            self.State = 2
        elseif self.State == 5 and value and RV ~= 0 then
            if char and self.State2 ~= 01 then
                self.State2 = tonumber(char .. "1")
                self.AutoChPage = nil
            end

            local page = math.floor(self.State2 / 10)
            if page >= 1 and name == BTN_DOWN or name == BTN_UP then
                local down = name == BTN_DOWN
                if self.Select then
                    self.Select = self.Select + (down and 1 or -1)
                    local max = page == 8 and #self.Messages[self.MsgPage] or 2
                    if self.Select < 1 then self.Select = max
                    elseif self.Select > max then self.Select = 1 end
                elseif page == 1 then
                    self.State2 = self.State2 + (down and 1 or -1)
                    if self.State2 < 11 then self.State2 = 17
                    elseif self.State2 > 17 then self.State2 = 11 end
                elseif page == 8 then
                    self.MsgPage = self.MsgPage + (down and 1 or -1)
                    if self.MsgPage < 1 then self.MsgPage = #self.Messages
                    elseif self.MsgPage > self.MsgPageCount then self.MsgPage = 1 end
                end
            elseif not self.Select and name == BTN_MODE and (page == 6 or page == 7 or page == 8 or page == 0) then
                self.Select = 1
            end

            if name == BTN_CLEAR then
                if self.Select then
                    self.Select = false
                else
                    self.State2 = 0
                    self.AutoChPage = nil
                end
            end
        end

        if self.State == 5 and self.State2 == 01 and value then
            local train = self.Trains[self.Selected]
            if not self.PVU[train] then self.PVU[train] = {} end
            if self.Trains[train] and not self.Trains[train].AsyncInverter then
                if char and (char == 2 or char == 4 or char == 5) then self.PVU[train][char] = not self.PVU[train][char] end
            else
                if char and char ~= 6 then self.PVU[train][char] = not self.PVU[train][char] end
            end

            if name == BTN_UP and self.Selected > 1 then self.Selected = self.Selected - 1 end
            if name == BTN_DOWN and self.Selected < self.WagNum then self.Selected = self.Selected + 1 end
            if name == BTN_ENTER then self.State2 = 0 self.LegacyScreen = false end
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

    function TRAIN_SYSTEM:BeginWagonsCheck()
        self.WagChecks = self.WagChecks or {}
        self.WagErrors = {}
    end

    function TRAIN_SYSTEM:EndWagonsCheck()
        for name in pairs(self.WagChecks) do
            local wag = self.WagErrors[name]
            self:CheckError(name, wag, wag)
        end
    end

    function TRAIN_SYSTEM:CheckWagError(idx, name, cond)
        local id = Error2id[name] or 0
        if id < 1 then print("WARN! No BUKP error named " .. (name or "nil")) return end
        self.WagChecks[name] = true
        if not cond then return end
        if not self.WagErrors[name] then self.WagErrors[name] = idx return end
        self.WagErrors[name] = true
    end

    function TRAIN_SYSTEM:CheckError(name, cond, param)
        local id = Error2id[name] or 0
        if id < 1 then print("WARN! No BUKP error named " .. (name or "nil")) return end
        if id > #ErrorsA and self.BErrorsTimer and CurTime() - self.BErrorsTimer < 0 then return end
        if cond then
            if self.Errors[id] ~= false then
                self.Errors[id] = CurTime()
                self.Errors[name] = CurTime()
                self.ErrorParams[id] = isnumber(param) and param or nil
            end
        elseif (id <= #ErrorsA or ErrRingContinuous[name]) and self.Errors[id] and self.Errors[id] ~= CurTime() or self.Errors[id] == false then
            self.Errors[id] = nil
            self.Errors[name] = nil
            self.ErrorParams[id] = nil
        end
    end

    local ErrorsCat = { ErrorsA, ErrorsB, ErrorsC }
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
            self.Train:SetNW2Int("SkifErrorCat", 0)
            self.Train:SetNW2String("SkifErrorStr", "")
        else
            local str = ErrorsCat[category][errId - start + 1]
            local changed = self.Error ~= errId or self.ErrorParams[0] ~= param

            if (changed or ErrRingContinuous[str[1]]) and (str[1] ~= "Doors" or self.Train.Speed >= 1.8) then
                self.ErrorRing = CurTime()
            end

            if changed then
                self.Train:SetNW2Int("SkifErrorCat", category)

                if isnumber(param) and str[3] then
                    self.Train:SetNW2String("SkifErrorStr", string.format(str[3], param))
                else
                    self.Train:SetNW2String("SkifErrorStr", str[2])
                end
            end
        end

        self.Error = errId
        self.ErrorParams[0] = param
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
        if self.State > 0 and self.Reset and self.Reset ~= 1 then self.Reset = false end
        if self.WagList ~= #self.Train.WagonList and self.Train.BUV.OrientateBUP == self.Train:GetWagonNumber() then
            self.Reset = 1
            self.InitTimer = CurTime() + 0.5
            self.WagList = #self.Train.WagonList
        end

        local Train = self.Train
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

        if Power and not self.Timer then
            self.Timer = CurTime()
            Train:SetNW2Int("SkifTimer", CurTime())
        elseif not Power then
            self.Timer = nil
        end

        if self.State == -1 and CurTime() - self.SkifTimer > 1 then
            self.State = 1
            self.State2 = 0
            self.SkifTimer = false
            self.Password = ""
            Train:SetNW2String("SkifPass", "")
            self.States = {}
            self.PVU = {}
            for k, v in ipairs(self.Trains) do
                if self.Trains[v] then self.Trains[v] = {} end
            end
            self.PTEnabled = nil
            self.HVBad = CurTime()
        end

        if self.State > 0 then
            for k, v in pairs(self.TriggerNames) do
                if Train[v] and (Train[v].Value > 0.5) ~= self.Triggers[v] then
                    self:Trigger(v, Train[v].Value > 0.5)
                    self.Triggers[v] = Train[v].Value > 0.5
                end
            end
        end

        local RV = (1 - Train.RV["KRO5-6"]) + Train.RV["KRR15-16"]
        Train:SetNW2Int("SkifRV", RV * Train.Electric.UPIPower)
        self.Active = (RV * Train.PpzActiveCabin.Value ~= 0) and 1 or 0

        if self.State < 5 and self.Prost then
            self.Prost = false
            self.Kos = false
            self.Ovr = false
        end

        local BARS = Train.BARS
        if Power then
            self.DeltaTime = CurTime() - self.CurTime
            self.CurTime = CurTime()
            Train:SetNW2Int("SkifSpeedLimit", BARS.NoFreq and 19 or math.floor(BARS.SpeedLimit))
            if self.DateEntered or self.Date1 or self.Date then
                self.Date = self.Date1 and self.Date1.day .. self.Date1.month .. self.Date1.year or self.Date
                local dat = {
                    day = self.Date1 and self.Date1.day or self.Date:sub(1, 2),
                    month = self.Date1 and self.Date1.month or self.Date:sub(3, 4),
                    year = self.Date1 and self.Date1.year or self.Date:sub(5, -1)
                }

                self.dat = dat
                if self.Date and self.Time and self.Time:sub(1, 2) == "00" and self.Time:sub(3, 4) == "00" and self.Time:sub(5, 6) == "00" and CurTime() - self.CurTime1 >= 1 then
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
                            self.Date1.year = Format("%04d", 2010)
                        else
                            self.Date1.year = Format("%04d", tonumber(dat.year) + 1)
                        end
                    end
                end
            else
                self.Date = os.date("%d%m%Y", Metrostroi.GetSyncTime())
            end

            if self.TimeEntered then
                self.Time = os.date("%H%M%S", self.Timer1)
                self.Timer1 = self.Timer1 + self.DeltaTime
            else
                self.Time = os.date("!%H%M%S", Metrostroi.GetSyncTime())
            end

            if self.State >= 2 then
                Train:SetNW2String("SkifTime", self.Time)
                Train:SetNW2String("SkifDate", self.Date1 and self.Date1.day .. self.Date1.month .. self.Date1.year or self.dat.day .. self.dat.month .. self.dat.year) --or self.Date1.day..self.Date1.month..self.Date1.year)
            end
            if self.State == 2 then
                Train:SetNW2String("SkifRouteNumber", self.RouteNumber)
                Train:SetNW2Int("SkifWagNum", self.WagNum)
                Train:SetNW2String("SkifDepotCode", self.DepotCode)
                Train:SetNW2String("SkifDepeatStation", self.DepeatStation)
                Train:SetNW2String("SkifPath", self.Path)
                Train:SetNW2String("SkifDir", self.Dir)
                Train:SetNW2String("SkifDBand", self.DBand)
                Train:SetNW2String("SkifDeadlock", self.Deadlock)
                Train:SetNW2String("SkifEnter", self.Entering or "-")
            end

            if self.State == 3 then
                local initialized = true
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
                            Train:SetNW2Bool("SkifWagI" .. i, true)
                        else
                            Train:SetNW2Bool("SkifWagI" .. i, false)
                            initialized = false
                        end
                    else
                        initialized = false
                    end
                end

                if initialized then
                    self.State = 5
                    self.State2 = 0
                    self.Errors = {}
                    self.Prost = true
                    self.Kos = true
                    self.Ovr = true
                    self.BErrorsTimer = CurTime() + 3
                    self.InitTimer = CurTime() + 1
                end
            end

            local kvSetting = 0
            local overrideKv = true

            local EnginesStrength = 0
            if self.InitTimer and CurTime() - self.InitTimer > 0 then self.InitTimer = nil end
            local RvKro = (1 - Train.RV["KRO5-6"]) * Train.PpzPrimaryControls.Value
            local RvKrr = Train.RV["KRR15-16"] * Train.PpzPrimaryControls.Value
            local RvWork = self.InitTimer and true or RvKro + RvKrr > 0.5 and RvKro + RvKrr < 1.5
            local doorLeft, doorRight, doorClose = false, false, false
            if self.State == 5 and (Train.PpzUpi.Value == 1) then
                local Back = false
                local sfBroken = false
                local HVBad, PantDisabled = false, false
                for i = 1, self.WagNum do
                    local train = self.Trains[self.Trains[i]]
                    if train.DriveStrength then EnginesStrength = EnginesStrength + train.DriveStrength end
                    if train.BrakeStrength then EnginesStrength = EnginesStrength + train.BrakeStrength end
                    if train.RV and self.Trains[i] ~= Train:GetWagonNumber() then Back = true end
                    if train.HVBad and train.AsyncInverter then HVBad = true end
                    if train.PantDisabled then PantDisabled = true end
                end

                local doorsNotClosed = Train.SF80F1.Value < 0.5

                self.PantDisabled = PantDisabled
                if HVBad and not self.HVBad then self.HVBad = CurTime() end
                if not HVBad and self.HVBad then self.HVBad = false end
                self.SchemeEngaged = false
                if RvWork and not Back then
                    for i = 1, self.WagNum do
                        Train:CANWrite("BUKP", Train:GetWagonNumber(), "BUV", self.Trains[i], "Orientate", i % 2 > 0)
                    end

                    if self.Reset == nil then self.Reset = true end
                    local min, max
                    local uLvmin, uLvmax
                    local uHvmin, uHvmax
                    local countBL = 0
                    self.DoorClosed = not doorsNotClosed
                    for i = 1, self.WagNum do
                        local trainid = self.Trains[i]
                        local train = self.Trains[trainid]
                        if train and train.BCPressure and train.BLPressure then
                            if not min or train.BCPressure < min then min = train.BCPressure end
                            if not max or train.BCPressure > max then max = train.BCPressure end
                            if not uLvmin or train.LV < uLvmin then uLvmin = train.LV end
                            if not uLvmax or train.LV > uLvmax then uLvmax = train.LV end
                            if not uHvmin or train.HVVoltage < uHvmin then uHvmin = train.HVVoltage end
                            if not uHvmax or train.HVVoltage > uHvmax then uHvmax = train.HVVoltage end
                            if train.BLPressure and train.BLPressure < 2.1 then countBL = countBL + 1 end
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

                    self:BeginWagonsCheck()

                    for i = 1, self.WagNum do
                        local trainid = self.Trains[i]
                        local train = self.Trains[trainid]
                        local doorclose = true
                        for i = 1, 8 do
                            if not train["Door" .. i .. "Closed"] then
                                doorclose = false
                                break
                            end
                        end

                        if not doorclose then self.DoorClosed = false end
                        local working = self:CheckBuv(train)
                        self:CheckWagError(i, "BuvDiscon", not working)
                        self:CheckWagError(i, "NoOrient", working and train.WagNOrientated)
                        self:CheckWagError(i, "EmergencyBrake", working and train.EmergencyBrake)
                        self:CheckWagError(i, "ParkingBrake", working and train.ParkingBrakeEnabled)
                        self:CheckWagError(i, "Doors", working and not doorclose)
                        self:CheckWagError(i, "RearCabin", working and train.DoorBack and trainid ~= Train:GetWagonNumber())
                        self:CheckWagError(i, "PassLights", working and not train.PassLightEnabled)

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
                        Train:SetNW2Bool("SkifDoors" .. i, doorclose)
                        Train:SetNW2Bool("SkifBV" .. i, train.BVEnabled)
                        Train:SetNW2Bool("SkifBUVState" .. i, working)
                        Train:SetNW2Bool("SkifBattery" .. i, train.Battery)
                        Train:SetNW2Bool("SkifBTBReady" .. i, train.BTBReady)
                        Train:SetNW2Bool("SkifEPTGood" .. i, train.EmergencyBrakeGood)
                        Train:SetNW2Bool("SkifEmerActive" .. i, not train.EmergencyBrake)
                        Train:SetNW2Bool("SkifPTApply" .. i, not train.PTEnabled)
                        Train:SetNW2Bool("SkifPSNEnabled" .. i, train.PSNEnabled)
                        Train:SetNW2Bool("SkifPSNWork" .. i, train.PSNWork)
                        Train:SetNW2Bool("SkifCond1" .. i, train.Cond1)
                        Train:SetNW2Bool("SkifCond2" .. i, train.Cond2)
                        Train:SetNW2Bool("SkifPSNBroken" .. i, not train.PSNBroken)
                        Train:SetNW2Bool("SkifScheme" .. i, train.Scheme)
                        Train:SetNW2Bool("SkifTPEnabled" .. i, train.EnginesBroken)
                        Train:SetNW2Bool("SkifLVGood" .. i, not train.LVBad)
                        Train:SetNW2Bool("SkifBVEnabled" .. i, train.BVEnabled)
                        Train:SetNW2Bool("SkifPBApply" .. i, not train.ParkingBrakeEnabled)
                        Train:SetNW2Bool("SkifBadCombination" .. i, not train.BadCombination)
                        Train:SetNW2Bool("SkifAsyncInverter" .. i, train.AsyncInverter)
                        Train:SetNW2Bool("SkifHVGood" .. i, not train.HVBad)
                        local orientation = train.Orientation
                        local doorleftopened, doorrightopened = false, false
                        for d = 1, 4 do
                            local l = not train["Door" .. (orientation and d or d + 4) .. "Closed"]
                            local r = not train["Door" .. (orientation and d + 4 or d) .. "Closed"]
                            if l and not doorleftopened then doorleftopened = true end
                            if r and not doorrightopened then doorrightopened = true end
                        end

                        Train:SetNW2Bool("SkifDoorLeft" .. i, doorleftopened)
                        Train:SetNW2Bool("SkifDoorRight" .. i, doorrightopened)
                        self.SchemeEngaged = self.SchemeEngaged or not train.NoAssembly

                        for sfp, sfs in ipairs(self.SFTbl) do
                            for sf in pairs(sfs) do
                                if working and not train[sf] then
                                    sfBroken = sfp .. sf
                                end
                            end
                        end
                        self:CheckWagError(i, "SF", sfBroken)

                        Train:SetNW2Bool("SkifAddressDoorsL" .. i, orientation and train.AddressDoorsL or not orientation and train.AddressDoorsR)
                        Train:SetNW2Bool("SkifAddressDoorsR" .. i, orientation and train.AddressDoorsR or not orientation and train.AddressDoorsL)

                        local cab = not not train.HasCabin
                        Train:SetNW2Bool("SkifHasCabin" .. i, cab)
                        if cab then
                            Train:SetNW2Bool("SkifDoorML" .. i, orientation and train.CabDoorLeft or not orientation and train.CabDoorRight)
                            Train:SetNW2Bool("SkifDoorMR" .. i, orientation and train.CabDoorRight or not orientation and train.CabDoorLeft)
                            Train:SetNW2Bool("SkifDoorT" .. i, train.CabDoorPass)
                            doorsNotClosed = doorsNotClosed or Train.SF80F3.Value == 1 and (not train.CabDoorLeft or not train.CabDoorRight) and trainid ~= Train:GetWagonNumber()
                            cabDoors = cabDoors or not train.CabDoorLeft or not train.CabDoorRight or not train.CabDoorPass
                        end

                        Train:SetNW2Bool("SkifCondK" .. i, train.CondK)
                    end

                    local noOrient = self.Errors.NoOrient
                    self:EndWagonsCheck()

                    if doorsNotClosed and not self.DoorControlTimer then
                        self.DoorControlTimer = true
                    end
                    if not doorsNotClosed and self.DoorControlTimer and not isnumber(self.DoorControlTimer) then
                        self.DoorControlTimer = CurTime() + self.DoorControlDelay + math.Rand(-0.2, 0.2)
                    end
                    if not doorsNotClosed and isnumber(self.DoorControlTimer) then
                        doorsNotClosed = CurTime() < self.DoorControlTimer
                        if not doorsNotClosed then
                            self.DoorControlTimer = nil
                        end
                    end

                    local errPT = self.PTEnabled and CurTime() - self.PTEnabled > 2 + (Train.BUV.Slope1 and 1.2 or 0)

                    Train:SetNW2Int("SkifDoorsAll", doorsNotClosed and 0 or cabDoors and 2 or 1)
                    Train:SetNW2Int("SkifHvAll", hvGood == 0 and 0 or hvBad == 0 and 1 or 2)
                    Train:SetNW2Int("SkifBvAll", bvEnabled == 0 and 0 or bvDisabled == 0 and 1 or 2)
                    Train:SetNW2Bool("SkifCondAny", condAny)
                    Train:SetNW2Bool("SkifVoGood", voGood)
                    Train:SetNW2Int("SkifKTR", Train.EmerBrake.Value == 1 and 1 or -1)
                    Train:SetNW2Int("SkifALS", Train.ALS.Value == 1 and 1 or -1)
                    Train:SetNW2Int("SkifBOSD", Train.DoorBlock.Value == 1 and 0 or -1)

                    Train:SetNW2Bool("SkifShowDoors", doorsNotClosed)
                    Train:SetNW2Bool("SkifShowBV", bvDisabled > 0)
                    Train:SetNW2Bool("SkifShowScheme", self.SchemeTimer and self.SchemeTimer < CurTime())
                    Train:SetNW2Bool("SkifShowPTApply", errPT)
                    Train:SetNW2Bool("SkifShowPBApply", self.Errors.ParkingBrake)
                    Train:SetNW2Bool("SkifShowBUVState", self.Errors.BuvDiscon)
                    Train:SetNW2Bool("SkifShowBTBReady", not btbAll)

                    local schemeShouldAssemble = schemeAny or RvKro and Train.KV765.Position > 0 and not self.PTEnabled and not self.Errors.EmergencyBrake
                    if not schemeAll and schemeShouldAssemble and not self.SchemeTimer then self.SchemeTimer = CurTime() + 1.8 end
                    if (not schemeShouldAssemble or schemeAll) and self.SchemeTimer then self.SchemeTimer = nil end

                    if self.ProstTimer and Train.MfduF8.Value < 0.5 then self.ProstTimer = nil end
                    Train:SetNW2Bool("SkifProstTimer", self.ProstTimer and CurTime() - self.ProstTimer > 0.5)
                    Train:SetNW2Bool("SkifProst", self.Prost)
                    Train:SetNW2Bool("SkifKos", self.Kos)

                    if not self.Errors.NoOrient and Train.Electric.DoorsControl > 0 and Train.DoorLeft.Value > 0 and Train.DoorSelectL.Value > 0 and Train.DoorSelectR.Value == 0 and (not Train.Prost_Kos.BlockDoorsL or Train.DoorBlock.Value == 1) then doorLeft = true end
                    if not self.Errors.NoOrient and Train.Electric.DoorsControl > 0 and Train.DoorRight.Value > 0 and Train.DoorSelectR.Value > 0 and Train.DoorSelectL.Value == 0 and (not Train.Prost_Kos.BlockDoorsR or Train.DoorBlock.Value == 1) then doorRight = true end

                    Train:SetNW2Bool("SkifCond", self.CondLeto)
                    Train:SetNW2Bool("SkifDoorBlockL", self.CurrentSpeed < 1.8 and (not Train.Prost_Kos.BlockDoorsL or Train.DoorBlock.Value == 1))
                    Train:SetNW2Bool("SkifDoorBlockR", self.CurrentSpeed < 1.8 and (not Train.Prost_Kos.BlockDoorsR or Train.DoorBlock.Value == 1))
                    if Train:ReadTrainWire(33) + (1 - Train.Electric.V2) > 0 and self.EmergencyBrake == 1 then self.EmergencyBrake = 0 end

                    if self.BLTimer and CurTime() - self.BLTimer > 0 and Train.RV.KRRPosition == 0 and Train.Electric.SD == 0 and Train.Electric.V2 > 0 and self.EmergencyBrake == 0 then
                        self.State2 = 52
                        self.EmergencyBrake = 1
                    end

                    self:CheckError("RightBlock", (not doorRight or Train.DoorClose.Value > 0) and Train.DoorRight.Value > 0)
                    self:CheckError("LeftBlock", (not doorLeft or Train.DoorClose.Value > 0) and Train.DoorLeft.Value > 0)

                    self:CheckError("BrakeLine", self.BLTimer and CurTime() - self.BLTimer > 0)
                    self:CheckError("RvErr", false)
                    self:CheckError("KmErr", false)
                    self:CheckError("DisableDrive", BARS.DisableDrive or self.Errors.DisableDrive and Train.KV765.Position > 0)
                    if not self.Errors.NoOrient then self:CheckError("NoOrient", noOrient and Train.KV765.Position > 0) end
                    if not self.Errors.Doors then self:CheckError("Doors", doorsNotClosed or self.WasDoors and Train.KV765.Position > 0) end

                    local err11ch = self.WasDoors ~= not not self.Errors.Doors
                    if self.Errors.Doors and err11ch then
                        if not self.AutoChPage then self.AutoChPage = self.State2 end
                        self.State2 = 21
                    end
                    if not self.Errors.Doors and err11ch and self.AutoChPage and not self.AwaitOpenDoors then
                        self.State2 = self.AutoChPage or self.State2
                    end
                    if self.AwaitOpenDoors and (not self.AutoChPage or self.Errors.Doors) then
                        self.AwaitOpenDoors = false
                    end
                    self.WasDoors = not not self.Errors.Doors

                    if sfBroken ~= self.sfBroken and CurTime() - self.BErrorsTimer > 0 then
                        self.sfBroken = sfBroken
                        if sfBroken then
                            self.State2 = 15 + tonumber(sfBroken[1])
                        end
                    end

                    if Train.RV["KRO5-6"] == 0 then
                        local AllowDriveInput = BARS.Brake == 0 and BARS.Drive > 0
                        if AllowDriveInput or Train.KV765.TractiveSetting <= 0 then
                            kvSetting = Train.PpzKm.Value > 0 and Train.KV765.TractiveSetting or self.ControllerState or kvSetting
                            overrideKv = false
                        end

                        Train:SetNW2Bool("SkifBARSPN2", not Train.Prost_Kos.CommandKos and BARS.Brake == 0 and BARS.Active == 1 and BARS.StillBrake > 0 and not Train.Pneumatic.EmerBrakeWork)

                        if Train.Prost_Kos.Command ~= 0 and Train.Prost_Kos.ProstActive == 1 and Train.KV765.Position >= 0 then kvSetting = translate_oka_kv_to_765(Train.Prost_Kos.Command) overrideKv = true end
                        if Train.Prost_Kos.CommandKos then kvSetting = -100 overrideKv = true end
                        if BARS.Brake > 0 then kvSetting = -100 overrideKv = true end
                        if self.Errors.EmergencyBrake and (Train.KV765.Position > 0 or Train.Speed > 1.6) then kvSetting = -100 overrideKv = true end
                        local sb = not overrideKv and BARS.StillBrake == 1
                        if sb then kvSetting = -50 overrideKv = true end

                        if Train.Prost_Kos.Metka and (Train.Prost_Kos.Metka[2] or Train.Prost_Kos.Metka[3] or Train.Prost_Kos.Metka[4]) and (Train.Prost_Kos.DistToSt ~= 0 or Train.Prost_Kos.ProstActive == 1) then
                            Train:SetNW2Int("SkifS", (Train.Prost_Kos.Dist or -10) * 100) --(Train:ReadCell(49165)-5-5)*100)
                        elseif Train:GetNW2Int("SkifS", -1000) ~= -1000 then
                            Train:SetNW2Int("SkifS", -1000)
                        end

                        if not sb and (Train.KV765.TractiveSetting > 0 or Train.KV765.TargetTractiveSetting > 0) and kvSetting <= 0 then
                            Train.KV765:TriggerInput("ResetTractiveSetting", 1)
                        end

                        local find = false
                        for k, v in pairs(Train.Prost_Kos.Metka) do
                            if v and not find then
                                find = true
                                break
                            end
                        end

                        Train:SetNW2Bool("SkifProstMetka", find)
                        Train:SetNW2Bool("SkifProstActive", Train.Prost_Kos.ProstActive == 1 and math.abs(Train.Prost_Kos.Dist or -1000) < 200)
                        Train:SetNW2Bool("SkifProstKos", not Train.Prost_Kos.Stop1 and not Train.Prost_Kos.WrongPath) --or Train.Prost_Kos.PrKos)
                    elseif Train:GetNW2Int("SkifS", -1000) ~= -1000 or Train:GetNW2Bool("SkifProstMetka", false) or Train:GetNW2Bool("SkifProstActive", false) then
                        Train:SetNW2Int("SkifS", -1000)
                        Train:SetNW2Bool("SkifProstMetka", false)
                        Train:SetNW2Bool("SkifProstActive", false)
                    end

                    if Train.Prost_Kos.Programm then
                        Train:SetNW2Int("SkifProstNum", math.random(1, 0xFF))
                    elseif Train.Prost_Kos.Metka1 then
                        Train:SetNW2Int("SkifProstNum", 0xDC)
                    else
                        Train:SetNW2Int("SkifProstNum", 0)
                    end

                    if ptApplied and kvSetting > 0 and not self.PTEnabled then self.PTEnabled = CurTime() end
                    if (not ptApplied or kvSetting <= 0) and self.PTEnabled then self.PTEnabled = nil end

                    self:CheckError("PneumoBrake", errPT and ptApplied, ptApplied)
                    self:CheckError("HV", self.HVBad and CurTime() - self.HVBad > 10)

                    local buv = self.Trains[self.Trains[1]]
                    Train:SetNW2Int("SkifBUVStrength", math.abs(Train.BUV.Strength))
                    if buv and buv.LV then
                        Train:SetNW2Int("SkifPNM", buv.TLPressure * 10)
                        Train:SetNW2Int("SkifPTM", buv.BLPressure * 10)
                        Train:SetNW2Int("SkifUbs", buv.LV)
                        if min then Train:SetNW2Int("SkifPMin", min * 10) end
                        if max then Train:SetNW2Int("SkifPMax", max * 10) end
                        if uLvmin then Train:SetNW2Int("SkifLvMin", uLvmin) end
                        if uLvmax then Train:SetNW2Int("SkifLvMax", uLvmax) end
                        if uHvmin then Train:SetNW2Int("SkifHvMin", uHvmin) end
                        if uHvmax then Train:SetNW2Int("SkifHvMax", uHvmax) end
                    end

                    local speed = 99
                    self.Speed = math.Round(Train.ALSCoil.Speed * 10) / 10
                    speed = self.Speed

                    Train:SetNW2Int("SkifSpeed", BARS.Speed)
                    self.CurrentSpeed = speed == 99 and 0 or speed

                    local driveInput = RvKro > 0 and (Train.KV765.Position > 0 or kvSetting > 0) or RvKrr > 0 and (Train.EmerX1.Value + Train.EmerX2.Value > 0)
                    self.DisableDrive = BARS.DisableDrive or self.Errors.DisableDrive and Train.KV765.Position > 0
                    self.BARS1 = (BARS.StillBrake < 1) and BARS.ATS1 and (driveInput or speed > 0.5)
                    self.BARS2 = (BARS.StillBrake < 1) and BARS.ATS2 and (driveInput or speed > 0.5)

                    self:CheckError("ArsFail", BARS.Active < 1, BARS.ATS1 and 1 or BARS.ATS2 and 2 or nil)
                    self:CheckError("KmErr", Train.KV765.Online < 1)

                    Train:SetNW2Bool("KB", BARS.KB)
                    Train:SetNW2Bool("SkifNextNoFq", BARS.NextNoFq)
                    Train:SetNW2Int("SkifSpeedLimitNext", BARS.NextNoFq and -1 or (BARS.NextLimit or 0))
                    Train:SetNW2Bool("SkifKB", BARS.KB)
                    Train:SetNW2Bool("SkifUOS", BARS.UOS)
                    Train:SetNW2Bool("DisableDrive", self.DisableDrive)
                    Train:SetNW2Bool("SkifBTB", Train.BUV.BTB)
                    Train:SetNW2Bool("SkifKRR", RvKrr > 0)
                    Train:SetNW2Bool("SkifEmerActive", self.Errors.EmergencyBrake)
                    Train:SetNW2Bool("SkifParkEnabled", self.Errors.ParkingBrake)
                    Train:SetNW2Bool("SkifPtApplied", not not ptApplied)
                    Train:SetNW2Bool("SkifPtAppliedRear", self.Trains[self.WagNum] and self.Trains[self.Trains[self.WagNum]] and self.Trains[self.Trains[self.WagNum]].PTEnabled or false)
                    self.AO = Train.ALSCoil.AO

                    for i = 1, self.WagNum do
                        local train = self.Trains[self.Trains[i]]
                        Train:SetNW2Bool("SkifSF" .. i .. "52", train.SF52)
                    end

                    if self.State2 == 11 then
                        for i = 1, self.WagNum do
                            local train = self.Trains[self.Trains[i]]
                            Train:SetNW2Bool("SkifBuksGood" .. i, true)
                            Train:SetNW2Bool("SkifMKState" .. i, not train.MKWork and -1 or train.MKCurrent > 5 and 1 or 0)
                            Train:SetNW2Bool("SkifLightsWork" .. i, train.PassLightEnabled)
                            Train:SetNW2Bool("SkifPantDisabled" .. i, not train.PantDisabled)
                            Train:SetNW2Bool("SkifRessoraGood" .. i, true)
                            Train:SetNW2Bool("SkifPUGood" .. i, true)
                            Train:SetNW2Bool("SkifBUDWork" .. i, train.BUDWork)
                            Train:SetNW2Bool("SkifWagOr" .. i, train.Orientation)
                        end
                    elseif self.State2 == 12 then
                        for i = 1, self.WagNum do
                            local train = self.Trains[self.Trains[i]]
                            Train:SetNW2Bool("SkifEKKGood" .. i, train.WagType == 2)
                            Train:SetNW2Bool("SkifEDTBroken" .. i, train.I < 0)
                            Train:SetNW2Bool("SkifPTGood" .. i, train.PTEnabled)
                            Train:SetNW2Bool("SkifPantDisabled" .. i, not train.PantDisabled)
                        end
                    elseif self.State2 == 13 then
                        for i = 1, self.WagNum do
                            local train = self.Trains[self.Trains[i]]
                            for k = 1, 8 do
                                Train:SetNW2Bool("SkifDPBT" .. k .. i, train["DPBT" .. k])
                            end
                        end
                    elseif self.State2 == 14 then
                        for i = 1, self.WagNum do
                            local train = self.Trains[self.Trains[i]]
                            for k = 1, 4 do
                                Train:SetNW2Bool("SkifPant" .. k .. i, not train.PantDisabled)
                                Train:SetNW2Bool("SkifPant" .. k .. i, not train.PantDisabled)
                            end
                        end
                    elseif self.State2 > 15 and self.State2 < 18 then
                        for i = 1, self.WagNum do
                            local train = self.Trains[self.Trains[i]]
                            for sf in pairs(self.SFTbl[self.State2 - 15]) do
                                Train:SetNW2Bool("SkifSf" .. sf .. i, train[sf])
                            end
                        end
                    elseif self.State2 == 21 then
                        for i = 1, self.WagNum do
                            local train = self.Trains[self.Trains[i]]
                            local orientation = train.Orientation
                            Train:SetNW2Bool("SkifWagOr" .. i, orientation)
                            for d = 1, 4 do
                                Train:SetNW2Bool("SkifDoor" .. d .. "L" .. i, train["Door" .. (orientation and d or d + 4) .. "Closed"])
                                Train:SetNW2Bool("SkifDoor" .. d .. "R" .. i, train["Door" .. (orientation and d + 4 or d) .. "Closed"])
                                Train:SetNW2Bool("SkifDoorReverse" .. d .. "L" .. i, train["DoorReverse" .. (orientation and d or 9 - d)])
                                Train:SetNW2Bool("SkifDoorReverse" .. d .. "R" .. i, train["DoorReverse" .. (orientation and 9 - d or d)])
                            end
                        end
                    elseif self.State2 == 31 or self.State2 == 32 then
                        for i = 1, self.WagNum do
                            local train = self.Trains[self.Trains[i]]
                            Train:SetNW2Int("SkifBrakeStrength" .. i, math.abs(train.BrakeStrength or 0) * 100)
                            Train:SetNW2Int("SkifDriveStrength" .. i, math.abs(train.DriveStrength or 0) * 100)
                            Train:SetNW2Int("SkifPower" .. i, train.ElectricEnergyUsed)
                            Train:SetNW2Int("SkifI" .. i, train.I)
                            Train:SetNW2Int("SkifU" .. i, train.HVVoltage)
                        end
                    elseif self.State2 == 41 then
                        for i = 1, self.WagNum do
                            local train = self.Trains[self.Trains[i]]
                            Train:SetNW2Int("SkifIMK" .. i, train.MKCurrent and train.MKCurrent * 10)
                            Train:SetNW2Int("SkifIVO" .. i, train.VagEqConsumption * 10)
                            Train:SetNW2Int("SkifUBS" .. i, train.LV and train.LV * 10 or 0)
                            Train:SetNW2Int("SkifU" .. i, train.HVVoltage and train.HVVoltage * 10 or 0)
                            Train:SetNW2Int("SkifI" .. i, train.I)
                            Train:SetNW2Int("SkifPower" .. i, train.ElectricEnergyUsed)
                            Train:SetNW2Int("SkifDissipated" .. i, train.ElectricEnergyDissipated)
                        end
                    elseif self.State2 == 51 or self.State2 == 52 then
                        for i = 1, self.WagNum do
                            local train = self.Trains[self.Trains[i]]
                            Train:SetNW2Int("SkifP" .. i, train.BCPressure * 10)
                            Train:SetNW2Int("SkifP2" .. i, (train.BCPressure2 or train.BCPressure) * 10)
                            Train:SetNW2Int("SkifPnm" .. i, train.TLPressure * 10)
                            Train:SetNW2Int("SkifPtm" .. i, train.BLPressure * 10)
                            Train:SetNW2Int("SkifPstt" .. i, train.ParkingBrakePressure * 10)
                            Train:SetNW2Int("SkifPskk" .. i, train.HPPressure * 10)
                            Train:SetNW2Bool("SkifBrakeEquip" .. i, train.BrakeEquip or false)
                            Train:SetNW2Int("SkifPauto1" .. i, train.BTOKTO1 * 10)
                            Train:SetNW2Int("SkifPauto2" .. i, train.BTOKTO2 * 10)
                            Train:SetNW2Int("SkifPauto3" .. i, train.BTOKTO3 * 10)
                            Train:SetNW2Int("SkifPauto4" .. i, train.BTOKTO4 * 10)

                            local green = true
                            for k = 1, 8 do
                                if not train["DPBT" .. k] then
                                    green = false
                                    break
                                end
                            end
                            Train:SetNW2Bool("SkifDPBT" .. i, green)
                        end
                    elseif self.State2 == 81 then
                        

                    elseif self.State2 == 01 then
                        local train = self.Trains[self.Selected]
                        for i = 1, 9 do
                            Train:SetNW2Bool("SkifPVU" .. i, self.PVU[train] and self.PVU[train][i])
                        end
                    end

                    for k = 1, self.WagNum do
                        local train = self.Trains[k]
                        for i = 1, 9 do
                            Train:SetNW2Bool("SkifPVU" .. k .. i, self.PVU[train] and self.PVU[train][i])
                        end
                    end

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
                self.DoorClosed = false
            end

            for i = 1, 9 do
                Train:SetNW2Int("SkifWagNum" .. i, self.Trains[i] or 0)
            end

            local addrDoors = Train:GetNW2Bool("AddressDoors", false) and Train.Electric.UPIPower * (1 - Train.PmvAddressDoors.Value) > 0.5
            self:CState("OpenLeft", doorLeft)
            self:CState("OpenRight", doorRight)
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
            end

            self.ControllerState = kvSetting
            Train:SetNW2Int("SkifThrottle", overrideKv and kvSetting or Train.KV765.TargetTractiveSetting)
            Train:SetNW2Bool("SkifOverrideKv", overrideKv)

            self:CState("RV", RvWork, "BUKP")
            self:CState("Ring", Train.Ring.Value > 0, "BUKP")
            self:CState("DriveStrength", math.abs(kvSetting))
            self:CState("Brake", kvSetting < 0 and 1 or 0)
            self:CState("StrongerBrake", kvSetting < 0 and Train.KV765.Position < -1 and Train.BARS.StillBrake == 0 and 1 or 0)
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

            self.Ring = Train.BARS.Ring > 0
            self.ErrorRinging = ring or (Train.Prost_Kos.Programm and Train.Speed > 2) or self.ErrorRing and CurTime() - self.ErrorRing < 2
            if self.MainMsg < 2 then
                self.PSN = (Train.PpzUpi.Value > 0) and self.State == 5
                self.Compressor = (Train.PpzUpi.Value * Train.SF45.Value * Train.Battery.Value > 0) and self.State == 5 and Train.AK.Value > 0
                self.PassLight = (1 - Train.PmvLights.Value) * Train.SF43.Value > 0 and self.State == 5
            end

            self:CState("ZeroSpeed", self.ZeroSpeed == 1)
            self:CState("TP1", (Train.PmvPant.Value == 0 or Train.PmvPant.Value == 2) and Train.PpzUpi.Value > 0)
            self:CState("TP2", (Train.PmvPant.Value == 0 or Train.PmvPant.Value == 1) and Train.PpzUpi.Value > 0)
            self:CState("PR", Train.Pr.Value * Train.PpzUpi.Value > 0)
            self:CState("Cond1", Train.PpzUpi.Value * (1 - Train.PmvCond.Value) * Train.SF61F8.Value * Train.PpzPrimaryControls.Value * Train.PpzUpi.Value * Train.PpzPrimaryControls.Value * Train.PpzUpi.Value > 0)
            self:CState("ReccOff", Train.PpzUpi.Value * Train.OtklR.Value > 0)
            self:CState("ParkingBrake", Train.PmvParkingBrake.Value * Train.PpzUpi.Value * Train.SF22F3.Value * Train.Electric.V2 > 0)
            self:CState("PassLight", self.PassLight)
            self:CState("DoorTorec", self.DoorTorec)
            self:CState("PSN", self.PSN)
            self:CState("Ticker", true)
            self:CState("PassScheme", true)
            self:CState("Compressor", self.Compressor)
            if self.State >= 4 and self.Active > 0 then
                self:CState("BVOn", Train.KV765.Position <= 0 and Train.EnableBV.Value * Train.PpzUpi.Value > 0)
                self:CState("BVOff", Train.DisableBV.Value * Train.PpzUpi.Value > 0)
            end
        else
            self.Ring = false
        end

        Train:SetNW2Int("SkifARS1", not BARS.BarsPower and 2 or BARS.ATS1Bypass and -1 or not self.BARS1 and 0 or self.DisableDrive and 2 or 1)
        Train:SetNW2Int("SkifARS2", not BARS.BarsPower and 2 or BARS.ATS2Bypass and -1 or not self.BARS2 and 0 or self.DisableDrive and 2 or 1)
        Train:SetNW2Int("SkifMainMsg", self.MainMsg)

        self.EmergencyBrake = self.State == 5 and self.EmergencyBrake or 0
        self:CState("BUPWork", self.State > 0)
        Train:SetNW2Int("SkifSelected", self.Selected)
        if self.State ~= 5 then self.LegacyScreen = false end
        if Train.Electric.UPIPower < 0.5 then
            Train:SetNW2Int("SkifState", 0)
        end
        if Train.PpzAts2.Value + Train.PpzAts1.Value > 0 and Train:GetNW2Int("SkifState") == 5 or Train:GetNW2Int("SkifState") < 5 or not Power then
            Train:SetNW2Int("SkifState", self.State * Train.Electric.UPIPower)
            Train:SetNW2Int("SkifState2", self.State2)
            Train:SetNW2Bool("SkifLegacyScreen", self.LegacyScreen)

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
            Train:SetNW2String("SkifLineName", line)
        end

        self.ZeroSpeed = self.State == 5 and self.MainMsg == 0 and self.CurrentSpeed < 1.8 and 1 or 0

        if self.State > 0 and self.Reset and self.Reset == 1 then self.Reset = false end
    end
else

    function TRAIN_SYSTEM:ClientThink()
        if not self.Train:ShouldDrawPanel("MFDU") then return end
        if not self.DrawTimer then
            render.PushRenderTarget(self.Train.MFDU, 0, 0, 1024, 1024)
            render.Clear(0, 0, 0, 0)
            render.PopRenderTarget()
        end

        local drawThrottle = self.NormalWork and self.DrawMainThrottle
        local skipOther = self.DrawTimer and CurTime() - self.DrawTimer < 0.1
        if not drawThrottle and skipOther then return end
        if not skipOther then self.DrawTimer = CurTime() end

        local state = self.Train:GetNW2Int("SkifState", 0)
        skipOther = skipOther or state == -2
        if not skipOther then
            self.State = state
            self.State2 = self.Train:GetNW2Int("SkifState2", 0)
            self.MainScreen = self.State2 == 0
        end
        render.PushRenderTarget(self.Train.MFDU, 0, 0, 1024, 1024)
        if not skipOther then
            render.Clear(0, 0, 0, 0)
        end
        cam.Start2D()
        if not skipOther then
            self:SkifMonitor(self.Train)
        end
        if state ~= -2 and drawThrottle and self.NormalWork then
            self:DrawMainThrottle()
        end
        cam.End2D()
        render.PopRenderTarget()
    end
end
