--------------------------------------------------------------------------------
-- Блок Управления и Контроля Поезда (Витязь)
--------------------------------------------------------------------------------
Metrostroi.DefineSystem("81_760E_BUKP")
TRAIN_SYSTEM.DontAccelerateSimulation = true

local BTN_DOWN = "VityazF7"
local BTN_UP = "VityazF6"
local BTN_ENTER = "VityazF8"
local BTN_MODE = "VityazF9"
local BTN_CLEAR = "VityazF5"

local MAINMSG_NONE = 0
local MAINMSG_RVOFF = 1
local MAINMSG_REAR = 2
local MAINMSG_2RV = 3
local MAINMSG_RVFAIL = 4

local ErrorsA = {
    {"RvErr", "Сбой РВ."},
    {"KmErr", "Сбой КМ."},
    {"BuvDiscon", "Нет связи с БУВ-С.", "Нет связи с БУВ-С на %d вагоне."},
    {"NoOrient", "Вагон не ориентирован.", "Вагон %d не ориентирован."},
    {"BrakeLine", "Низкое давление ТМ."},
    {"DisableDrive", "Запрет ТР от АРС.",},
    {"EmergencyBrake", "Экстренное торможение."},
    {"ParkingBrake", "Стояночный тормоз прижат.", "Стояночный тормоз прижат\nна %d вагоне."},
    {"PneumoBrake", "Пневмотормоз включен.", "Пневмотормоз включен\nна %d вагоне."},
    {"Doors", "Двери не закрыты.", "Двери не закрыты на %d вагоне."},
}
local ErrorsB = {
    {"HV", "Напряжение КС.",},
    {"RearCabin", "Открыта кабина ХВ.",},
}
local ErrorsC = {
    {"SF", "Включи автомат.", "Включи автомат на %d вагоне."},
    {"PassLights", "Освещение не включено.", "Освещение не включено\nна %d вагоне.",},
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

    self.Train:LoadSystem("VityazF1", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("VityazF2", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("VityazF3", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("VityazF4", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("Vityaz1", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("Vityaz4", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("Vityaz7", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("Vityaz2", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("Vityaz5", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("Vityaz8", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("Vityaz0", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("Vityaz3", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("Vityaz6", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("Vityaz9", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("VityazF5", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("VityazF6", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("VityazF7", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("VityazF8", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("VityazF9", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("VityazHelp", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("VityazKontr", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("VityazTV", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("VityazTV1", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("VityazTV2", "Relay", "Switch", { bass = true })
    self.Train:LoadSystem("VityazP", "Relay", "Switch", { bass = true })

    self.TriggerNames = {"VityazF1", "VityazF2", "VityazF3", "VityazF4", "Vityaz1", "Vityaz2", "Vityaz3", "Vityaz4", "Vityaz5", "Vityaz6", "Vityaz7", "Vityaz8", "Vityaz9", "Vityaz0", "VityazKontr", "VityazHelp", "VityazF6", "VityazF7", "VityazF5", "VityazF9", "VityazF8", "VityazTV", "VityazTV1", "VityazTV2", "VityazP", "AttentionMessage"}
    self.Triggers = {}
    for k, v in pairs(self.TriggerNames) do
        if self.Train[v] then self.Triggers[v] = self.Train[v].Value > 0.5 end
    end

    self.State = 0
    self.State2 = 0
    self.MainScreen = true
    self.LegacyScreen = false
    self.Trains = {}
    self.Errors = {}
    self.WagErrors = {}
    self.ErrorsLog = {}
    self.Error = 0
    self.ErrorParams = {}
    self.Counter = 0
    self.Password = ""
    self.Selected = 0
    self.err = 0
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
    self.States = {}
    self.NextState = {
        ["1"] = {
            true, --6
            true,
            true,
            true,
            true
        },
        ["2"] = nil, --1
        ["3"] = {
            true --2
        },
        ["4"] = nil, --1
        ["5"] = {
            true --2
        },
        ["6"] = nil, --1
        ["7"] = {
            true --2
        },
        ["8"] = nil, --1
        ["9"] = {
            true, --3
            true
        },
    }

    self.PVU = {}
    self.Active = 0
    self.MainMsg = 0
    self.Count = 0
    self.EnginesStrength = 0
    self.ControllerState = 0
    self.EmergencyBrake = 0
    self.BTB = 0
    self.CurrentSpeed = 0
    self.ZeroSpeed = 0
    self.Errors.Doors = false
    self.Speed = 0
    self.CurTime = CurTime()
    self.Prost = false
    self.Kos = false
    self.Ovr = false
    self.DoorClosed = false
    self.CurTime1 = CurTime()
    self.FirstPressed = {}
end

function TRAIN_SYSTEM:Outputs()
    return {"State", "ControllerState", "EmergencyBrake", "BTB", "WagNum", "Prost", "Kos", "err", "CurrentSpeed", "InitTimer", "ZeroSpeed", "Active"}
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

local SFTbl = {
    [1] = {
        [1] = "31",
        [2] = "32",
        [3] = "47", --АДУД
        [4] = "45",
        [5] = "43",
        [6] = "33",
        [7] = "36",
        [8] = "48", --АДУВ
    },
    [2] = {
        [1] = "49",
        [2] = "34",
        [3] = "50",
        [4] = "51",
        [5] = "39",
        [6] = "40",
        [7] = "52",
    },
    [3] = {
        [1] = "41",
        [2] = "53",
        [3] = "54",
        [4] = "42",
    },
    [11] = {
        [1] = "-", --"31",
        [2] = "-", --"32",
        [3] = "47", --АДУД
        [4] = "-", --"45",
        [5] = "43",
        [6] = "-", --"33",
        [7] = "-", --"36",
        [8] = "48", --АДУВ
    },
    [12] = {
        [1] = "49",
        [2] = "-", --"34",
        [3] = "-", --"50",
        [4] = "-", --"51",
        [5] = "39",
        [6] = "40",
        [7] = "-", --"52",
    },
    [13] = {
        [1] = "41",
        [2] = "53",
        [3] = "54",
        [4] = "-",
    },
}

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

    TRAIN_SYSTEM.VityazPass = "7777"
    TRAIN_SYSTEM.Checks = {
        KAH = false,
        ALS = false,
        Ring = false,
        --DoorSelectL=false,DoorSelectR=false,
        DoorBlock = false,
        DoorClose = false,
        AttentionMessage = false,
        Attention = false,
        AttentionBrake = false,
        Headlights1 = false,
        Headlights2 = false,
        DoorLeft = false,
        DoorRight = false,
        SA16 = false,
        SA17 = false,
        SA15 = false,
        SA3 = false,
        SA2 = false,
        SA5 = false,
        SA11 = false,
        SA12 = false,
        AccelRate = false,
        EmergencyDoors = false,
        EnableBV = false,
        DisableBV = false,
        EmerBrake = false,
        PB = false,
        Pr = false,
        OtklR = false,
    }

    function TRAIN_SYSTEM:Trigger(name, value)
        local Train = self.Train
        local char = name:gsub("Vityaz", "")
        char = tonumber(char)
        if Train.SF23F8.Value == 0 then return end
        local RV = (1 - Train.RV["KRO5-6"]) + Train.RV["KRR15-16"]
        if self.State > 0 and (name == "VityazTV1" or name == "VityazTV2") and value then self.TV = true end
        if self.TV and (self.State > 0) and name == "VityazTV" and value then self.TV = false end
        if self.State == -3 then
            for k, v in pairs(self.TriggerNames) do
                if name == v then Train:SetNW2Bool("VityazMNMM" .. k, value) end
            end
            --if self.WagNum ~= math.min(8,#Train.WagonList) then self.WagNum = math.min(8,#Train.WagonList) end
        elseif self.State == 1 and RV ~= 0 then
            if name == BTN_CLEAR and value then self.Password = self.Password:sub(1, -2) end
            if name == BTN_ENTER and value then
                if self.Password == self.VityazPass then
                    --self.PassedState2 = false
                    self.State = 2
                    self.State2 = 0
                    self.Selected = 0
                else
                    self.Password = ""
                end
            end

            if char and #self.Password < 4 and value then self.Password = self.Password .. char end
            Train:SetNW2String("VityazPass", self.Password)
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

                        --os.date("!*t",75600)
                        --print(date.year)
                        if self.Selected == 2 then
                            --self.Date1 = (self.Date1 and self.Date1 - 0.5 - (tonumber(self.Time:sub(1,2))*3600+tonumber(self.Time:sub(3,4))*60+tonumber(self.Time:sub(5,6)))+tonumber(self.Entering:sub(1,2))*3600+tonumber(self.Entering:sub(3,4))*60+tonumber(self.Entering:sub(5,6)) or Metrostroi.GetSyncTime()-10800-(os.date("!*t",Metrostroi.GetSyncTime()).hour*3600+os.date("!*t",Metrostroi.GetSyncTime()).min*60+os.date("!*t",Metrostroi.GetSyncTime()).sec)+tonumber(self.Entering:sub(1,2))*3600+tonumber(self.Entering:sub(3,4))*60+tonumber(self.Entering:sub(5,6))-0.5)
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
                    if name == BTN_UP and value and self.Selected > 0 then self.Selected = self.Selected - 1 end
                    if name == BTN_DOWN and value and self.Selected < 9 then self.Selected = self.Selected + 1 end
                    if name == BTN_ENTER and value then --self.Selected == 0 and self.PassedState2 then
                        if self.WagNum > 0 then
                            for i = 1, self.WagNum do
                                Train:CANWrite("BUKP", Train:GetWagonNumber(), "BUV", self.Trains[i], "Orientate", i % 2 > 0)
                            end
                        end

                        self.State = 3
                    end

                    if name == BTN_MODE and value then
                        if self.Selected == 0 then self.State2 = 1 end
                        --if self.Selected == 1 then self.State2 = 2 self.Selected = 0 end
                        if self.Selected > 0 then self.Entering = "" end
                    end
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
                    Train:SetNW2String("VityazEnter", self.Entering)
                else
                    if name == BTN_UP and value and self.Selected > 0 then self.Selected = self.Selected - 1 end
                    if name == BTN_DOWN and value and self.Selected < 8 then self.Selected = self.Selected + 1 end
                end
            end
        elseif self.State == 3 and name == BTN_ENTER and value and RV ~= 0 then
            self.State = 2
        elseif self.State == 4 and name == BTN_ENTER and value and RV ~= 0 then
            self.Errors = {}
            --self:CState("BVInit",false)
            self.State2 = 11
            self.Prost = true
            self.Kos = true
            self.Ovr = true
            self.BErrorsTimer = CurTime() + 3
            self.InitTimer = CurTime() + 1
            self.State = 5
        elseif self.State == 5 and value then
            if self.ProstTimer and CurTime() - self.ProstTimer > 0.5 and char then
                if char == 3 then
                    self.Prost = not self.Prost
                    self.Kos = self.Prost
                elseif char == 9 then
                    self.Prost = self.Kos and not self.Prost
                elseif char == 0 and Train.BKL then
                    self.Kos = not self.Kos
                    self.Prost = self.Kos
                    self.Ovr = self.Kos
                end
            else
                if char and self.State2 ~= 01 then
                    if char == 0 then self.Selected = 1 end
                    if char == math.floor(self.State2 / 10) and not self.MainScreen then
                        self.LegacyScreen = not self.LegacyScreen
                    else
                        self.LegacyScreen = char == 0
                    end
                    self.MainScreen = false
                    self.State2 = tonumber(char .. "1")
                    self.AutoChPage = nil
                end

                local interceptScroll = false
                if self.State2 == 61 and (name == BTN_DOWN or name == BTN_UP) then
                    interceptScroll = true
                    self.CondLeto = not self.CondLeto
                end

                if not interceptScroll then
                    if name == BTN_DOWN and self.State2 ~= 01 and self.NextState[tostring(self.State2)[1]] and (tonumber(tostring(self.State2)[2]) == #self.NextState[tostring(self.State2)[1]] + 1) then
                        self.State2 = tonumber(tostring(self.State2)[1] .. "1")
                    elseif name == BTN_DOWN and self.State2 ~= 01 and self.NextState[tostring(self.State2)[1]] and self.NextState[tostring(self.State2)[1]][tonumber(tostring(self.State2)[2])] then
                        self.State2 = self.State2 + 1
                    end

                    if name == BTN_UP and self.State2 ~= 01 and self.NextState[tostring(self.State2)[1]] and tostring(self.State2)[2] == "1" then
                        self.State2 = tonumber(tostring(self.State2)[1] .. tostring(#self.NextState[tostring(self.State2)[1]] + 1))
                    elseif name == BTN_UP and self.State2 ~= 01 and self.NextState[tostring(self.State2)[1]] and self.NextState[tostring(self.State2)[1]][tonumber(tostring(self.State2)[2]) - 1] then
                        self.State2 = self.State2 - 1
                    end
                end

                if name == BTN_MODE and self.LegacyScreen and (self.State2 == 71 or self.State2 == 72) then self.CondLeto = not self.CondLeto end
                if name == BTN_CLEAR then self.MainScreen = true self.LegacyScreen = false self.State2 = 11 end
            end

            if name == BTN_ENTER then
                self.ProstTimer = CurTime()
                --self.PrevState2 = self.State2
                -- self.MainScreen = true
            end

            if not self.LegacyScreen and math.floor(self.State2 / 10) == 1 and self.State2 > 15 then
                self.State2 = name == BTN_UP and 15 or 11
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
            if name == BTN_ENTER then self.State2 = 11 end
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
        elseif id <= #ErrorsA and self.Errors[id] and self.Errors[id] ~= CurTime() or self.Errors[id] == false then
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
            self.Train:SetNW2Int("VityazErrorCat", 0)
            self.Train:SetNW2String("VityazErrorStr", "")
        elseif self.Error ~= errId or self.ErrorParams[0] ~= param then
            if errId ~= Error2id["Doors"] or self.Train.Speed >= 1.8 then
                self.ErrorRing = CurTime()
            end

            self.Train:SetNW2Int("VityazErrorCat", category)

            local str = ErrorsCat[category][errId - start + 1]
            if isnumber(param) and str[3] then
                self.Train:SetNW2String("VityazErrorStr", string.format(str[3], param))
            else
                self.Train:SetNW2String("VityazErrorStr", str[2])
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
        if self.Train:GetNW2Int("VityazMCU1", 0) == 0 then
            self.Train:SetNW2Int("VityazMCU1", math.random(1, 0xFFFF))
            self.Train:SetNW2Int("VityazMCU2", math.random(1, 0xFFFF))
        end

        if self.State > 0 and self.Reset and self.Reset ~= 1 then self.Reset = false end
        if self.WagList ~= #self.Train.WagonList and self.Train.BUV.OrientateBUP == self.Train:GetWagonNumber() then
            self.Reset = 1
            self.InitTimer = CurTime() + 0.5
            self.WagList = #self.Train.WagonList
        end

        local Train = self.Train
        local Power = Train.Electric.Battery80V > 62
        local VityazWork = (Train.SF23F7.Value + Train.SF23F8.Value > 0) and Power --[[or self.State == 5]]
        if not VityazWork and self.State ~= (Power and -2 or 0) and (not Power or self.State ~= -3) then
            if self.State == 0 and self.State ~= -3 then
                self.State = -3
                self.State2 = 0
            else
                self.State = Power and -2 or 0
            end

            self.HVBad = CurTime()
            self.VityazTimer = nil
        end

        if Power and not VityazWork and self.State == -2 then
            self.State = -3
            self.CurrentSpeed = 0
            self.Speed = 0
            self.State2 = 1
        end

        if VityazWork and (self.State == 0 or self.State == -2 or Power and self.State == -3) then
            self.State = Power and -1 or -3
            self.VityazTimer = CurTime()
            self.Reset = nil
            self.Compressor = false
            self.Ring = false
            self.Error = 0
            self.ErrorRing = nil
        end

        if Power and not self.Timer then
            self.Timer = CurTime()
            Train:SetNW2Int("VityazTimer", CurTime())
        elseif not Power then
            self.TV = false
            self.Timer = nil
            self.Count = 0
        end

        if self.State == -1 and CurTime() - self.VityazTimer > 1 then
            self.State = 1
            self.State2 = 0
            self.VityazTimer = false
            self.Counter = 0
            self.Password = ""
            Train:SetNW2String("VityazPass", "")
            self.States = {}
            self.PVU = {}
            for k, v in ipairs(self.Trains) do
                if self.Trains[v] then self.Trains[v] = {} end
            end

            self.PTEnabled = nil
            self.HVBad = CurTime()
        end

        if self.State == -3 or self.State > 0 then
            for k, v in pairs(self.TriggerNames) do
                if Train[v] and (Train[v].Value > 0.5) ~= self.Triggers[v] then
                    self:Trigger(v, Train[v].Value > 0.5)
                    self.Triggers[v] = Train[v].Value > 0.5
                    if Train[v].Value > 0.5 then self.Count = self.Count + 1 end
                end
            end

            Train:SetNW2Int("VityazCount", self.Count)
            self.Counter = self.Counter + math.random(3, 4) / 10
            if self.Counter > 0xFF then self.Counter = 0 end
            if Train.SF23F7.Value + Train.SF23F8.Value > 0 and self.State == 5 or Train:GetNW2Int("VityazState") < 5 then Train:SetNW2Int("VityazCounter", self.Counter) end
        end

        local RV = (1 - Train.RV["KRO5-6"]) + Train.RV["KRR15-16"]
        Train:SetNW2Int("VityazRV", RV)
        self.Active = (RV * Train.SF23F2.Value ~= 0) and 1 or 0

        --self:CState("KVT",Train.BARS.KVT or RV==0 or self.State < 5 or Train.ALS.Value == 1)
        if self.State < 5 and self.Prost then
            self.Prost = false
            self.Kos = false
            self.Ovr = false
        end

        Train:SetNW2Bool("VityazTV", (self.State > 0 or self.State == -3) and self.TV)
        --self.Active = 0--(RV > 0 and not Back and self.State == 5) and 1 or 0
        local BARS = Train.BARS
        if Power then
            self.DeltaTime = CurTime() - self.CurTime
            self.CurTime = CurTime()
            Train:SetNW2Int("VityazSpeedLimit", BARS.NoFreq and 19 or math.floor(BARS.SpeedLimit))
            if self.DateEntered or self.Date1 or self.Date then
                --[[
                self.Date = os.date("%d%m%Y",self.Date1)
                if self.Date == nil then
                    self.Date1 = tonumber(self.Time:sub(1,2))*3600+tonumber(self.Time:sub(3,4))*60+tonumber(self.Time:sub(5,6))+75600--10800
                end
                self.Date1 = self.Date1 + self.DeltaTime]]
                self.Date = self.Date1 and self.Date1.day .. self.Date1.month .. self.Date1.year or self.Date
                local dat = {
                    day = self.Date1 and self.Date1.day or self.Date:sub(1, 2),
                    month = self.Date1 and self.Date1.month or self.Date:sub(3, 4),
                    year = self.Date1 and self.Date1.year or self.Date:sub(5, -1)
                }

                self.dat = dat
                --if not self.Date1 then self.Date1 = {day=nil,month=nil,year=nil} end
                if self.Date and self.Time and self.Time:sub(1, 2) == "00" and self.Time:sub(3, 4) == "00" and self.Time:sub(5, 6) == "00" and CurTime() - self.CurTime1 >= 1 then
                    self.CurTime1 = CurTime()
                    if not self.Date1 then
                        self.Date1 = {
                            day = self.Date:sub(1, 2),
                            month = self.Date:sub(3, 4),
                            year = self.Date:sub(5, -1)
                        }
                    end

                    --print(self.Time)
                    if IsValidDate(Format("%02d", tonumber(dat.day) + 1) .. "." .. dat.month .. "." .. dat.year) then
                        self.Date1.day = Format("%02d", tonumber(dat.day) + 1)
                    elseif IsValidDate("01." .. Format("%02d", tonumber(dat.month) + 1) .. "." .. dat.year) then
                        self.Date1.day = "01"
                        self.Date1.month = Format("%02d", tonumber(dat.month) + 1)
                    else --if IsValidDate("01.01."..Format("%04d",tonumber(self.Date1.year)+1)) then
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
                --print(self.Time)
                self.Time = os.date("%H%M%S", self.Timer1)
                self.Timer1 = self.Timer1 + self.DeltaTime
            else
                self.Time = os.date("!%H%M%S", Metrostroi.GetSyncTime())
            end

            if self.State >= 2 then
                Train:SetNW2String("VityazTime", self.Time)
                Train:SetNW2String("VityazDate", self.Date1 and self.Date1.day .. self.Date1.month .. self.Date1.year or self.dat.day .. self.dat.month .. self.dat.year) --or self.Date1.day..self.Date1.month..self.Date1.year)
            end
            if self.State == 2 then
                Train:SetNW2String("VityazRouteNumber", self.RouteNumber)
                Train:SetNW2Int("VityazWagNum", self.WagNum)
                Train:SetNW2String("VityazDepotCode", self.DepotCode)
                Train:SetNW2String("VityazDepeatStation", self.DepeatStation)
                Train:SetNW2String("VityazPath", self.Path)
                Train:SetNW2String("VityazDir", self.Dir)
                Train:SetNW2String("VityazDBand", self.DBand)
                Train:SetNW2String("VityazDeadlock", self.Deadlock)
                Train:SetNW2String("VityazEnter", self.Entering or "-")
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

                        if not train.WagNOrientated and train.BUVWork and not train.BadCombination and not find then --and train.PTEnabled then
                            Train:SetNW2Bool("VityazWagI" .. i, true)
                        else
                            Train:SetNW2Bool("VityazWagI" .. i, false)
                            initialized = false
                        end
                    else
                        initialized = false
                    end
                end

                if initialized then
                    local i = 1
                    for k, v in pairs(self.Checks) do
                        Train:SetPackedBool("VityazBTest" .. k, false)
                        self.Checks[k] = false
                        i = i + 1
                    end

                    Train:SetNW2Int("VityazBTest", 0)
                    if self.WagNum > 0 then
                        --self:CState("BVInit",true)
                        self.FirstPressed = {}
                        for k, v in pairs(self.Checks) do
                            if Train[k] and Train[k].Value > 0 or k:find("Headlights") and (Train.HeadlightsSwitch.Value == tonumber(k[11])) then self.FirstPressed[k] = true end
                        end

                        --self.Slope = false
                        self.State = 4
                    end
                end
            end

            if self.State == 4 then
                local i = 1
                local num = 0
                for k, v in pairs(self.Checks) do
                    if (Train[k] and Train[k].Value > 0 or k:find("Headlights") and Train.HeadlightsSwitch.Value == tonumber(k[11])) and not self.FirstPressed[k] then
                        Train:SetNW2Bool("VityazBTest" .. k, true)
                        self.Checks[k] = true
                    elseif Train[k] and Train[k].Value == 0 or k:find("Headlights") and Train.HeadlightsSwitch.Value ~= tonumber(k[11]) then
                        self.FirstPressed[k] = false
                    end

                    i = i + 1
                    if v then num = num + 1 end
                end

                if not self.Slope and Train.AccelRate.Value > 0 and Train.BARS.Speed <= 2 then self.Slope = true end
                --self:CState("BVOn",Train.Panel.Controller <= 0 and Train.EnableBV.Value > 0)
                --if self.Slope and (not self.SchemeEngaged or Train.BARS.Speed > 2) then self.Slope = false end				
                Train:SetNW2Int("VityazBTest", num)
            end

            local stength = 0
            local EnginesStrength = 0
            if self.InitTimer and CurTime() - self.InitTimer > 0 then self.InitTimer = nil end
            local RvKro = (1 - Train.RV["KRO5-6"]) * Train.SF23F3.Value
            local RvKrr = Train.RV["KRR15-16"] * Train.SF23F1.Value
            local RvWork = self.InitTimer and true or RvKro + RvKrr > 0.5 and RvKro + RvKrr < 1.5
            local doorLeft, doorRight, doorClose = false, false, false
            if self.State == 5 and (Train.SF23F8.Value == 1) then
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
                        Train:SetNW2Bool("VityazDoors" .. i, doorclose)
                        Train:SetNW2Bool("VityazBV" .. i, train.BVEnabled)
                        Train:SetNW2Bool("VityazBUVState" .. i, working) --"БУВ" --train.BUVWork 
                        Train:SetNW2Bool("VityazBattery" .. i, train.Battery) --Батарея
                        Train:SetNW2Bool("VityazBTBReady" .. i, train.BTBReady) --"БТБ ГОТ"
                        Train:SetNW2Bool("VityazEPTGood" .. i, train.EmergencyBrakeGood) --"ЭТ ЭФФ"
                        Train:SetNW2Bool("VityazEmerActive" .. i, not train.EmergencyBrake) --"ЭКС ТОРМ"
                        Train:SetNW2Bool("VityazPTApply" .. i, not train.PTEnabled) --"ПТ ВКЛ"
                        Train:SetNW2Bool("VityazPSNEnabled" .. i, train.PSNEnabled) --"ББЭ"
                        Train:SetNW2Bool("VityazPSNWork" .. i, train.PSNWork) --"ББЭ"
                        Train:SetNW2Bool("VityazCond1" .. i, train.Cond1) --"Конд1"
                        Train:SetNW2Bool("VityazCond2" .. i, train.Cond2) --"Конд2"
                        Train:SetNW2Bool("VityazPSNBroken" .. i, not train.PSNBroken) --"ИСПР"
                        Train:SetNW2Bool("VityazScheme" .. i, train.Scheme)
                        Train:SetNW2Bool("VityazTPEnabled" .. i, train.EnginesBroken) --"ТЯГ ПРИВ" FIXME
                        Train:SetNW2Bool("VityazLVGood" .. i, not train.LVBad) --"НАПР БС"
                        Train:SetNW2Bool("VityazBVEnabled" .. i, train.BVEnabled) --"ЗАЩИТ ТП"
                        Train:SetNW2Bool("VityazPBApply" .. i, not train.ParkingBrakeEnabled) --"СТ ТОРМ"
                        Train:SetNW2Bool("VityazBadCombination" .. i, not train.BadCombination) --"ЗАПР КОМ"
                        Train:SetNW2Bool("VityazAsyncInverter" .. i, train.AsyncInverter)
                        Train:SetNW2Bool("VityazHVGood" .. i, not train.HVBad)
                        local orientation = train.Orientation
                        --Train:SetNW2Bool("VityazWagOr"..i,orientation)
                        local doorleftopened, doorrightopened = false, false
                        for d = 1, 4 do
                            local l = not train["Door" .. (orientation and d or d + 4) .. "Closed"]
                            local r = not train["Door" .. (orientation and d + 4 or d) .. "Closed"]
                            if l and not doorleftopened then doorleftopened = true end
                            if r and not doorrightopened then doorrightopened = true end
                        end

                        Train:SetNW2Bool("VityazDoorLeft" .. i, doorleftopened)
                        Train:SetNW2Bool("VityazDoorRight" .. i, doorrightopened)
                        --Train:SetNW2Bool("VityazAKB"..i,train.Electric.Battery80V < 62)
                        self.SchemeEngaged = self.SchemeEngaged or not train.NoAssembly

                        local sfWas = sfBroken
                        for i = 1, 3 do
                            for k = 1, #SFTbl[i] do
                                if working and not train["SF" .. SFTbl[i][k]] then
                                    sfBroken = 10 * i + k
                                    self.err19state = i
                                end
                            end
                        end
                        if sfWas ~= sfBroken then
                            self:CheckWagError(i, "SF", sfBroken)
                        end

                        Train:SetNW2Bool("VityazAddressDoorsL" .. i, orientation and train.AddressDoorsL or not orientation and train.AddressDoorsR)
                        Train:SetNW2Bool("VityazAddressDoorsR" .. i, orientation and train.AddressDoorsR or not orientation and train.AddressDoorsL)

                        local cab = not not train.HasCabin
                        Train:SetNW2Bool("VityazHasCabin" .. i, cab)
                        if cab then
                            Train:SetNW2Bool("VityazDoorML" .. i, orientation and train.CabDoorLeft or not orientation and train.CabDoorRight)
                            Train:SetNW2Bool("VityazDoorMR" .. i, orientation and train.CabDoorRight or not orientation and train.CabDoorLeft)
                            Train:SetNW2Bool("VityazDoorT" .. i, train.CabDoorPass)
                            doorsNotClosed = doorsNotClosed or Train.SF80F3.Value == 1 and (not train.CabDoorLeft or not train.CabDoorRight) and trainid ~= Train:GetWagonNumber()
                            cabDoors = cabDoors or not train.CabDoorLeft or not train.CabDoorRight or not train.CabDoorPass
                        end

                        Train:SetNW2Bool("VityazCondK" .. i, train.CondK)
                    end

                    local noOrient = self.Errors.NoOrient
                    self:EndWagonsCheck()

                    local errPT = self.PTEnabled and CurTime() - self.PTEnabled > 2 + (Train.BUV.Slope1 and 1.2 or 0)

                    Train:SetNW2Int("VityazDoorsAll", doorsNotClosed and 0 or cabDoors and 2 or 1)
                    Train:SetNW2Int("VityazHvAll", hvGood == 0 and 0 or hvBad == 0 and 1 or 2)
                    Train:SetNW2Int("VityazBvAll", bvEnabled == 0 and 0 or bvDisabled == 0 and 1 or 2)
                    Train:SetNW2Bool("VityazCondAny", condAny)
                    Train:SetNW2Bool("VityazVoGood", voGood)
                    Train:SetNW2Int("VityazKTR", Train.EmerBrake.Value == 1 and 1 or -1)
                    Train:SetNW2Int("VityazALS", Train.ALS.Value == 1 and 1 or -1)
                    Train:SetNW2Int("VityazBOSD", Train.DoorBlock.Value == 1 and 0 or -1)

                    Train:SetNW2Bool("VityazShowDoors", doorsNotClosed)
                    Train:SetNW2Bool("VityazShowBV", bvDisabled > 0)
                    Train:SetNW2Bool("VityazShowScheme", self.SchemeTimer and self.SchemeTimer < CurTime())
                    Train:SetNW2Bool("VityazShowPTApply", errPT)
                    Train:SetNW2Bool("VityazShowPBApply", self.Errors.ParkingBrake)
                    Train:SetNW2Bool("VityazShowBUVState", self.Errors.BuvDiscon)
                    Train:SetNW2Bool("VityazShowBTBReady", not btbAll)

                    local schemeShouldAssemble = schemeAny or RvKro and Train.KV765.Position > 0 and not self.PTEnabled and not self.Errors.EmergencyBrake
                    if not schemeAll and schemeShouldAssemble and not self.SchemeTimer then self.SchemeTimer = CurTime() + 1.8 end
                    if (not schemeShouldAssemble or schemeAll) and self.SchemeTimer then self.SchemeTimer = nil end

                    if self.ProstTimer and Train.VityazF8.Value < 0.5 then self.ProstTimer = nil end
                    Train:SetNW2Bool("VityazProstTimer", self.ProstTimer and CurTime() - self.ProstTimer > 0.5)
                    Train:SetNW2Bool("VityazProst", self.Prost)
                    Train:SetNW2Bool("VityazKos", self.Kos)
                    --Door controls
                    if not self.Errors.NoOrient and Train.Electric.DoorsControl > 0 and Train.DoorLeft.Value > 0 and Train.DoorSelectL.Value > 0 and Train.DoorSelectR.Value == 0 and (not Train.Prost_Kos.BlockDoorsL or Train.DoorBlock.Value == 1) then doorLeft = true end
                    if not self.Errors.NoOrient and Train.Electric.DoorsControl > 0 and Train.DoorRight.Value > 0 and Train.DoorSelectR.Value > 0 and Train.DoorSelectL.Value == 0 and (not Train.Prost_Kos.BlockDoorsR or Train.DoorBlock.Value == 1) then doorRight = true end
                    Train:SetNW2Bool("VityazCond", self.CondLeto)
                    --Train:SetNW2Bool("VityazCondWork",self.States["Cond1"])		
                    Train:SetNW2Bool("VityazDoorBlockL", self.CurrentSpeed < 1.8 and (not Train.Prost_Kos.BlockDoorsL or Train.DoorBlock.Value == 1))
                    Train:SetNW2Bool("VityazDoorBlockR", self.CurrentSpeed < 1.8 and (not Train.Prost_Kos.BlockDoorsR or Train.DoorBlock.Value == 1))
                    if Train:ReadTrainWire(33) + (1 - Train.Electric.V2) > 0 and self.EmergencyBrake == 1 then self.EmergencyBrake = 0 end

                    if self.BLTimer and CurTime() - self.BLTimer > 0 and Train.RV.KRRPosition == 0 and Train.Electric.SD == 0 and Train.Electric.V2 > 0 and self.EmergencyBrake == 0 then
                        self.State2 = 52
                        self.MainScreen = false
                        self.EmergencyBrake = 1
                    end

                    self:CheckError("BrakeLine", self.BLTimer and CurTime() - self.BLTimer > 0)
                    self:CheckError("RvErr", false)
                    self:CheckError("KmErr", false)
                    self:CheckError("DisableDrive", BARS.DisableDrive or self.Errors.DisableDrive and Train.KV765.Position > 0)
                    if not self.Errors.NoOrient then self:CheckError("NoOrient", noOrient and Train.KV765.Position > 0) end
                    if not self.Errors.Doors then self:CheckError("Doors", doorsNotClosed or self.WasDoors and Train.KV765.Position > 0) end

                    local err11ch = self.WasDoors ~= not not self.Errors.Doors
                    if self.MainScreen and self.Errors.Doors and err11ch then
                        self.AutoChPage = self.State2
                        self.State2 = 21
                        self.MainScreen = false
                    end
                    if not self.Errors.Doors and err11ch and self.AutoChPage and not self.AwaitOpenDoors then
                        self.State2 = self.AutoChPage
                        self.MainScreen = true
                    end
                    if self.AwaitOpenDoors and (not self.AutoChPage or self.Errors.Doors) then
                        self.AwaitOpenDoors = false
                    end
                    self.WasDoors = not not self.Errors.Doors

                    if not sfBroken then
                        self:CheckError("SF", false)
                    end
                    if sfBroken ~= self.sfBroken and self.err19state and CurTime() - self.BErrorsTimer > 0 then
                        self.sfBroken = sfBroken
                        -- if sfBroken then
                        --     self.State2 = 90 + self.err19state
                        --     self.LegacyScreen = true
                        -- end
                    end

                    if Train.RV["KRO5-6"] == 0 then
                        local AllowDriveInput = BARS.Brake == 0 and BARS.Drive > 0
                        if AllowDriveInput or Train.KV765.TractiveSetting <= 0 then
                            stength = Train.KV765.TractiveSetting
                        end

                        Train:SetNW2Bool("VityazBARSPN2", not Train.Prost_Kos.CommandKos and BARS.Brake == 0 and BARS.Active == 1 and BARS.StillBrake > 0 and not Train.Pneumatic.EmerBrakeWork)

                        local override = false
                        if Train.Prost_Kos.Command ~= 0 and Train.Prost_Kos.ProstActive == 1 and Train.KV765.Position >= 0 then stength = translate_oka_kv_to_765(Train.Prost_Kos.Command) override = true end
                        if Train.Prost_Kos.CommandKos then stength = -100 override = true end
                        if BARS.Brake > 0 then stength = -100 override = true end
                        if self.Errors.EmergencyBrake and (Train.KV765.Position > 0 or Train.Speed > 1.6) then stength = -100 override = true end
                        local sb = not override and (BARS.StillBrake == 1 or Train.Speed < 0.5 and BARS.PN1 == 1)
                        if sb then stength = -50 override = true end

                        if Train.Prost_Kos.Metka and (Train.Prost_Kos.Metka[2] or Train.Prost_Kos.Metka[3] or Train.Prost_Kos.Metka[4]) and (Train.Prost_Kos.DistToSt ~= 0 or Train.Prost_Kos.ProstActive == 1) then
                            Train:SetNW2Int("VityazS", (Train.Prost_Kos.Dist or -10) * 100) --(Train:ReadCell(49165)-5-5)*100)
                        elseif Train:GetNW2Int("VityazS", -1000) ~= -1000 then
                            Train:SetNW2Int("VityazS", -1000)
                        end

                        if not sb and (Train.KV765.TractiveSetting > 0 or Train.KV765.TargetTractiveSetting > 0) and stength <= 0 then
                            Train.KV765:TriggerInput("ResetTractiveSetting", 1)
                        end

                        local find = false
                        for k, v in pairs(Train.Prost_Kos.Metka) do
                            if v and not find then
                                find = true
                                break
                            end
                        end

                        Train:SetNW2Bool("VityazProstMetka", find)
                        Train:SetNW2Bool("VityazProstActive", Train.Prost_Kos.ProstActive == 1 and math.abs(Train.Prost_Kos.Dist or -1000) < 200)
                        Train:SetNW2Bool("VityazProstKos", not Train.Prost_Kos.Stop1 and not Train.Prost_Kos.WrongPath) --or Train.Prost_Kos.PrKos)
                    elseif Train:GetNW2Int("VityazS", -1000) ~= -1000 or Train:GetNW2Bool("VityazProstMetka", false) or Train:GetNW2Bool("VityazProstActive", false) then
                        Train:SetNW2Int("VityazS", -1000)
                        Train:SetNW2Bool("VityazProstMetka", false)
                        Train:SetNW2Bool("VityazProstActive", false)
                    end

                    if Train.Prost_Kos.Programm then
                        Train:SetNW2Int("VityazProstNum", math.random(1, 0xFF))
                    elseif Train.Prost_Kos.Metka1 then
                        Train:SetNW2Int("VityazProstNum", 0xDC)
                    else
                        Train:SetNW2Int("VityazProstNum", 0)
                    end

                    if ptApplied and stength > 0 and not self.PTEnabled then self.PTEnabled = CurTime() end
                    if (not ptApplied or stength <= 0) and self.PTEnabled then self.PTEnabled = nil end

                    self:CheckError("PneumoBrake", errPT and ptApplied, ptApplied)
                    self:CheckError("HV", self.HVBad and CurTime() - self.HVBad > 10)

                    Train:SetNW2Int("VityazThrottle", math.Round(stength or 0))
                    local buv = self.Trains[self.Trains[1]]
                    Train:SetNW2Int("VityazBUVStrength", math.abs(Train.BUV.Strength))
                    if buv and buv.LV then
                        Train:SetNW2Int("VityazPNM", buv.TLPressure * 10)
                        Train:SetNW2Int("VityazPTM", buv.BLPressure * 10)
                        Train:SetNW2Int("VityazUbs", buv.LV)
                        if min then Train:SetNW2Int("VityazPMin", min * 10) end
                        if max then Train:SetNW2Int("VityazPMax", max * 10) end
                        if uLvmin then Train:SetNW2Int("VityazLvMin", uLvmin) end
                        if uLvmax then Train:SetNW2Int("VityazLvMax", uLvmax) end
                        if uHvmin then Train:SetNW2Int("VityazHvMin", uHvmin) end
                        if uHvmax then Train:SetNW2Int("VityazHvMax", uHvmax) end
                    end

                    local speed = 99
                    self.Speed = math.Round(Train.ALSCoil.Speed * 10) / 10 --math.floor(Train.ALSCoil.Speed)
                    speed = self.Speed

                    Train:SetNW2Int("VityazSpeed", BARS.Speed) --Train.Speedometer.State > 0 and math.floor(Train.BARS.Speed) or 99)
                    self.CurrentSpeed = speed == 99 and 0 or speed

                    local driveInput = RvKro > 0 and (Train.KV765.Position > 0) or RvKrr > 0 and (Train.EmerX1.Value + Train.EmerX2.Value > 0)
                    self.DisableDrive = BARS.DisableDrive or self.Errors.DisableDrive and Train.KV765.Position > 0
                    self.BARS1 = BARS.PN1 < 1 and BARS.ATS1 and (driveInput or speed > 0)
                    self.BARS2 = BARS.PN1 < 1 and BARS.ATS2 and (driveInput or speed > 0)

                    Train:SetNW2Bool("KB", BARS.KB)
                    Train:SetNW2Bool("VityazNextNoFq", BARS.NextNoFq)
                    Train:SetNW2Int("VityazSpeedLimitNext", BARS.NextNoFq and -1 or (BARS.NextLimit or 0))
                    Train:SetNW2Bool("VityazKB", BARS.KB)
                    Train:SetNW2Bool("VityazUOS", BARS.UOS)
                    Train:SetNW2Bool("DisableDrive", self.DisableDrive)
                    Train:SetNW2Bool("VityazBTB", Train.BUV.BTB)
                    Train:SetNW2Bool("VityazKRR", RvKrr > 0)
                    Train:SetNW2Bool("VityazEmerActive", self.Errors.EmergencyBrake)
                    Train:SetNW2Bool("VityazParkEnabled", self.Errors.ParkingBrake)
                    Train:SetNW2Bool("VityazPtApplied", not not ptApplied)
                    Train:SetNW2Bool("VityazPtAppliedRear", self.Trains[self.WagNum] and self.Trains[self.Trains[self.WagNum]] and self.Trains[self.Trains[self.WagNum]].PTEnabled or false)
                    self.AO = Train.ALSCoil.AO

                    for i = 1, self.WagNum do
                        local train = self.Trains[self.Trains[i]]
                        Train:SetNW2Bool("VityazSF" .. i .. "52", train.SF52)
                    end

                    if self.err == 0 then
                        if self.State2 == 11 then
                            for i = 1, self.WagNum do
                                local train = self.Trains[self.Trains[i]]
                                Train:SetNW2Bool("VityazBuksGood" .. i, true)
                                Train:SetNW2Bool("VityazMKState" .. i, not train.MKWork and -1 or train.MKCurrent > 5 and 1 or 0) --"МК"
                                Train:SetNW2Bool("VityazLightsWork" .. i, train.PassLightEnabled) --"ОСВ ВКЛ"
                                Train:SetNW2Bool("VityazPantDisabled" .. i, not train.PantDisabled) --"ТКПР"
                                Train:SetNW2Bool("VityazRessoraGood" .. i, true)
                                Train:SetNW2Bool("VityazPUGood" .. i, true)
                                Train:SetNW2Bool("VityazBUDWork" .. i, train.BUDWork)
                                Train:SetNW2Bool("VityazWagOr" .. i, train.Orientation)

                                Train:SetNW2Bool("VityazMKWork" .. i, train.MKWork) --"МК"
                                Train:SetNW2Bool("VityazPTWork" .. i, not train.PTBad) --"ТОРМ ОБ" !
                                Train:SetNW2Bool("VityazEmPT" .. i, train.ReserveChannelBraking) --"ТОРМ РК"
                                Train:SetNW2Bool("VityazDoorBlock" .. i, train.Blocks) --"ТОРЦ ДВ" FIXME
                            end
                        elseif self.State2 == 12 then
                            for i = 1, self.WagNum do
                                local train = self.Trains[self.Trains[i]]
                                Train:SetNW2Bool("VityazEKKGood" .. i, train.WagType == 2) --"МежВаг С"
                                Train:SetNW2Bool("VityazEDTBroken" .. i, train.I < 0) --"ОТКАЗ ЭТ" FIXME
                                Train:SetNW2Bool("VityazPTGood" .. i, train.PTEnabled) --"ПТ ЭФФ"
                                Train:SetNW2Bool("VityazPantDisabled" .. i, not train.PantDisabled) --"ТКПР ОТЖ"
                            end
                        elseif self.State2 == 13 then
                            for i = 1, self.WagNum do
                                local train = self.Trains[self.Trains[i]]
                                for k = 1, 8 do
                                    Train:SetNW2Bool("VityazDPBT" .. k .. i, train["DPBT" .. k]) --not train.PTEnabled and not train.ParkingBrakeEnabled) --"ДПБТ1-8"
                                end
                            end
                        elseif self.State2 == 14 then
                            for i = 1, self.WagNum do
                                local train = self.Trains[self.Trains[i]]
                                for k = 1, 4 do
                                    if k == 1 or k == 3 then
                                        Train:SetNW2Bool("VityazPant" .. k .. i, not train.PantDisabled) --"ТП1-3"
                                    else
                                        Train:SetNW2Bool("VityazPant" .. k .. i, not train.PantDisabled) --"ТП2-4"
                                    end
                                end
                            end
                        elseif self.State2 == 21 then
                            for i = 1, self.WagNum do
                                local train = self.Trains[self.Trains[i]]
                                local orientation = train.Orientation
                                Train:SetNW2Bool("VityazWagOr" .. i, orientation)
                                for d = 1, 4 do
                                    Train:SetNW2Bool("VityazDoor" .. d .. "L" .. i, train["Door" .. (orientation and d or d + 4) .. "Closed"])
                                    Train:SetNW2Bool("VityazDoor" .. d .. "R" .. i, train["Door" .. (orientation and d + 4 or d) .. "Closed"])
                                    Train:SetNW2Bool("VityazDoorReverse" .. d .. "L" .. i, train["DoorReverse" .. (orientation and d or 9 - d)])
                                    Train:SetNW2Bool("VityazDoorReverse" .. d .. "R" .. i, train["DoorReverse" .. (orientation and 9 - d or d)])
                                end
                            end
                        elseif self.State2 == 31 or self.State2 == 32 then
                            for i = 1, self.WagNum do
                                local train = self.Trains[self.Trains[i]]
                                Train:SetNW2Int("VityazBrakeStrength" .. i, math.abs(train.BrakeStrength or 0) * 10)
                                Train:SetNW2Int("VityazDriveStrength" .. i, math.abs(train.DriveStrength or 0) * 10)
                                Train:SetNW2Int("VityazPower" .. i, train.ElectricEnergyUsed)
                                Train:SetNW2Int("VityazI" .. i, train.I)
                                Train:SetNW2Int("VityazU" .. i, train.HVVoltage)
                            end
                        elseif self.State2 == 41 then
                            for i = 1, self.WagNum do
                                local train = self.Trains[self.Trains[i]]
                                Train:SetNW2Int("VityazIMK" .. i, train.MKCurrent and train.MKCurrent * 10)
                                Train:SetNW2Int("VityazIVO" .. i, train.VagEqConsumption * 10)
                                Train:SetNW2Int("VityazUBS" .. i, train.LV and train.LV * 10 or 0)
                                Train:SetNW2Int("VityazU" .. i, train.HVVoltage and train.HVVoltage * 10 or 0)
                                Train:SetNW2Int("VityazI" .. i, train.I)
                                Train:SetNW2Int("VityazPower" .. i, train.ElectricEnergyUsed)
                                Train:SetNW2Int("VityazDissipated" .. i, train.ElectricEnergyDissipated)
                            end
                        elseif self.State2 == 51 or self.State2 == 52 then
                            for i = 1, self.WagNum do
                                local train = self.Trains[self.Trains[i]]
                                Train:SetNW2Int("VityazP" .. i, train.BCPressure * 10)
                                Train:SetNW2Int("VityazP2" .. i, (train.BCPressure2 or train.BCPressure) * 10)
                                Train:SetNW2Int("VityazPnm" .. i, train.TLPressure * 10)
                                Train:SetNW2Int("VityazPtm" .. i, train.BLPressure * 10)
                                Train:SetNW2Int("VityazPstt" .. i, train.ParkingBrakePressure * 10)
                                Train:SetNW2Int("VityazPskk" .. i, train.HPPressure * 10)
                                Train:SetNW2Bool("VityazBrakeEquip" .. i, train.BrakeEquip or false)
                                Train:SetNW2Int("VityazPauto1" .. i, train.BTOKTO1 * 10)
                                Train:SetNW2Int("VityazPauto2" .. i, train.BTOKTO2 * 10)
                                Train:SetNW2Int("VityazPauto3" .. i, train.BTOKTO3 * 10)
                                Train:SetNW2Int("VityazPauto4" .. i, train.BTOKTO4 * 10)

                                local green = true
                                for k = 1, 8 do
                                    if not train["DPBT" .. k] then
                                        green = false
                                        break
                                    end
                                end
                                Train:SetNW2Bool("VityazDPBT" .. i, green)
                            end
                        elseif self.State2 == 81 then
                            for i = 1, self.WagNum do
                                local train = self.Trains[self.Trains[i]]
                                local orientation = train.Orientation
                                Train:SetNW2Bool("VityazWagOr" .. i, orientation)
                            end
                        elseif self.State2 == 91 then
                            for i = 1, self.WagNum do
                                local train = self.Trains[self.Trains[i]]
                                for k = 1, #SFTbl[1] do
                                    Train:SetNW2Bool("VityazSF" .. i .. SFTbl[1][k], train["SF" .. SFTbl[1][k]])
                                end
                            end
                        elseif self.State2 == 92 then
                            for i = 1, self.WagNum do
                                local train = self.Trains[self.Trains[i]]
                                for k = 1, #SFTbl[2] do
                                    Train:SetNW2Bool("VityazSF" .. i .. SFTbl[2][k], train["SF" .. SFTbl[2][k]])
                                end
                            end
                        elseif self.State2 == 93 then
                            for i = 1, self.WagNum do
                                local train = self.Trains[self.Trains[i]]
                                for k = 1, #SFTbl[3] do
                                    Train:SetNW2Bool("VityazSF" .. i .. SFTbl[3][k], train["SF" .. SFTbl[3][k]])
                                end
                            end
                        elseif self.State2 == 01 then
                            local train = self.Trains[self.Selected]
                            for i = 1, 9 do
                                Train:SetNW2Bool("VityazPVU" .. i, self.PVU[train] and self.PVU[train][i])
                            end
                        end
                    end

                    Train:SetNW2Int("VityazErr", self.err)

                    for k = 1, self.WagNum do
                        local train = self.Trains[k]
                        for i = 1, 9 do
                            Train:SetNW2Bool("VityazPVU" .. k .. i, self.PVU[train] and self.PVU[train][i])
                        end
                    end

                    if not self.Slope and Train.AccelRate.Value > 0 and (Train.BARS.Speed <= 2 or stength == 0) then
                        self.Slope = true
                        self.SlopeSpeed = Train.BARS.Speed <= 2
                    end

                    if self.Slope and (not self.SchemeEngaged or not self.SlopeSpeed and stength ~= 0) then self.Slope = false end
                else
                    if not self.InitTimer then self.Reset = nil end
                    self.AO = false
                    self.TimeEntered = nil
                    self.DateEntered = nil
                    self.EmergencyBrake = 0
                    self.BTB = 0
                    --self.Slope = false
                    --if Back then self.BErrorsTimer = CurTime()+3 end--self.State2 = 11 
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

                if not (Train.DoorBlock.Value * Train.EmergencyDoors.Value == 1) and (Train.SF23F8.Value * Train.DoorClose.Value) == 1 then doorClose = true end
                --if Train.DoorClose.Value == 1 then doorClose = true end
            else
                self.DoorClosed = false
            end

            for i = 1, 9 do
                Train:SetNW2Int("VityazWagNum" .. i, self.Trains[i] or 0)
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

            if self.MainScreen and not self.LegacyScreen and addrDoors and (Train.DoorLeft.Value + Train.DoorRight.Value) * (1 - Train.DoorClose.Value) > 0 then
                self.AutoChPage = self.State2
                self.State2 = 21
                self.MainScreen = false
                self.AwaitOpenDoors = true
            end

            --[[
            if CurTime()%1 < 0.035 and self.EnginesStrength ~= 0 then
                RunConsoleCommand("say",self.EnginesStrength)
            end]]
            --print(self.EnginesStrength)
            self:CState("RV", RvWork, "BUKP")
            self:CState("Ring", Train.Ring.Value > 0, "BUKP")
            self.ControllerState = stength
            self:CState("DriveStrength", math.abs(stength))
            self:CState("Brake", stength < 0 and 1 or 0)
            self:CState("StrongerBrake", stength < 0 and Train.KV765.Position < -1 and Train.BARS.StillBrake == 0 and 1 or 0)
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
                if (Train.SF23F8.Value > 0) and self.State == 5 then
                    self.PSN = true
                else
                    self.PSN = false
                end

                if (Train.SF23F8.Value * Train.SF45.Value * Train.Battery.Value > 0) and self.State == 5 then
                    self.Compressor = Train.AK.Value > 0
                else
                    self.Compressor = false
                end

                if (1 - Train.PmvLights.Value) * Train.SF43.Value > 0 and self.State == 5 then
                    self.PassLight = true
                else
                    self.PassLight = false
                end

                if (Train.PowerOff.Value * Train.SF23F8.Value * Train.SF30F1.Value > 0) and self.State == 5 and self.MainMsg == 0 then
                    self.PowerOff = true
                else
                    self.PowerOff = false
                end
            end

            self:CState("ZeroSpeed", self.ZeroSpeed == 1)
            self:CState("PowerOff", self.PowerOff)
            self:CState("TP1", (Train.PmvPant.Value == 0 or Train.PmvPant.Value == 2) and Train.SF23F8.Value > 0)
            self:CState("TP2", (Train.PmvPant.Value == 0 or Train.PmvPant.Value == 1) and Train.SF23F8.Value > 0)
            self:CState("PR", Train.Pr.Value * Train.SF23F8.Value > 0)
            self:CState("Cond1", Train.SF23F8.Value * (1 - Train.PmvCond.Value) * Train.SF61F8.Value * Train.SF23F3.Value * Train.SF23F8.Value * Train.SF23F1.Value * Train.SF23F8.Value > 0)
            self:CState("ReccOff", Train.SF23F8.Value * Train.OtklR.Value > 0)
            self:CState("ParkingBrake", Train.PmvParkingBrake.Value * Train.SF23F8.Value * Train.SF22F3.Value * Train.Electric.V2 > 0)
            self:CState("PassLight", self.PassLight)
            self:CState("DoorTorec", self.DoorTorec)
            self:CState("PSN", self.PSN)
            self:CState("Ticker", true)
            self:CState("PassScheme", true)
            self:CState("Compressor", self.Compressor)
            if self.State >= 4 and self.Active > 0 then
                self:CState("BVOn", Train.KV765.Position <= 0 and Train.EnableBV.Value * Train.SF23F8.Value > 0)
                self:CState("BVOff", Train.DisableBV.Value * Train.SF23F8.Value > 0)
            end
        else
            local ring = false
            for i = 2, self.WagNum do
                local train = self.Trains[self.Trains[i]]
                if train and train.Ring then ring = true end
            end

            self.Ring = false
        end

        Train:SetNW2Int("VityazARS1", BARS.ATS1Disabled and -1 or not self.BARS1 and 0 or self.DisableDrive and 2 or 1)
        Train:SetNW2Int("VityazARS2", BARS.ATS2Disabled and -1 or not self.BARS2 and 0 or self.DisableDrive and 2 or 1)
        Train:SetNW2Int("VityazMainMsg", self.MainMsg)

        self.EmergencyBrake = self.State == 5 and self.EmergencyBrake or 0
        self:CState("BUPWork", self.State > 0)
        Train:SetNW2Int("VityazSelected", self.Selected)
        if self.State ~= 5 then self.MainScreen = true self.LegacyScreen = false end
        if Train.SF23F7.Value + Train.SF23F8.Value > 0 and Train:GetNW2Int("VityazState") == 5 or Train:GetNW2Int("VityazState") < 5 or not Power then
            Train:SetNW2Int("VityazState", self.State)
            Train:SetNW2Int("VityazState2", self.State2)
            Train:SetNW2Bool("VityazMainScreen", self.MainScreen)
            Train:SetNW2Bool("VityazLegacyScreen", self.LegacyScreen)

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
            Train:SetNW2String("VityazLineName", line)
        end

        self.ZeroSpeed = self.State == 5 and self.MainMsg == 0 and self.CurrentSpeed < 1.8 and 1 or 0

        if self.State > 0 and self.Reset and self.Reset == 1 then self.Reset = false end
    end
else
    local function createFont(name, font, size, weight, blur, scanlines, underline)
        surface.CreateFont("Metrostroi_760_" .. name, {
            font = font,
            size = size,
            weight = weight or 400,
            blursize = blur or false,
            antialias = false,
            underline = underline,
            italic = false,
            strikeout = false,
            symbol = false,
            rotary = false,
            shadow = true,
            additive = false,
            outline = true,
            extended = true,
            scanlines = scanlines or false,
        })
    end

    createFont("Vityaz", "DejaVu Sans Mono", 43, 0, 0, 0, false) --size=41
    createFont("Vityaz45", "DejaVu Sans Mono", 45, 0, 0, 0, false) --size=41
    createFont("Vityaz1", "Times New Roman", 43, 1000, 0, 0, false) --size=41
    createFont("VityazA", "Arial", 44, 0, 0, 0, false) --size=42
    createFont("VityazC", "Arial", 40, 0, 0, 0, false) --size=42
    createFont("VityazB", "DejaVu Sans Mono", 36, 0, 0, 0, false)
    createFont("VityazD", "DejaVu Sans Mono", 31, 0, 0, 0, false)
    --createFont("Vityaz1","DejaVu Sans Mono",80,1000,0,0,false)
    function TRAIN_SYSTEM:ClientThink()
        if not self.Train:ShouldDrawPanel("Vityaz") then return end
        if not self.DrawTimer then
            render.PushRenderTarget(self.Train.Vityaz, 0, 0, 1024, 1024)
            render.Clear(0, 0, 0, 0)
            render.PopRenderTarget()
        end

        if self.DrawTimer and CurTime() - self.DrawTimer < 0.1 then return end
        self.DrawTimer = CurTime()
        local state = self.Train:GetNW2Int("SF23F8") * self.Train:GetNW2Int("VityazState", 0)
        local counter = self.Train:GetNW2Int("VityazCounter", 0)
        if self.Counter ~= counter or (state <= 0 and state ~= -2) and self.State ~= state then
            self.Counter = counter
            if state ~= -2 then
                self.State = state
                self.State2 = self.Train:GetNW2Int("VityazState2", 0)
                self.MainScreen = self.Train:GetNW2Bool("VityazMainScreen", false)
                self.LegacyScreen = self.Train:GetNW2Bool("VityazLegacyScreen", false)
            end
            render.PushRenderTarget(self.Train.Vityaz, 0, 0, 1024, 1024)
            render.Clear(0, 0, 0, 0)
            cam.Start2D()
            if self:Ui765() then
                self:VityazMonitor(self.Train)
            end
            cam.End2D()
            render.PopRenderTarget()
        end
    end

    function TRAIN_SYSTEM:PrintText(x, y, text, col, align, fix)
        local str = {utf8.codepoint(text, 1, -1)}
        if align == "right" and str then x = x - #str end
        for i = 1, #str do
            local char = utf8.char(str[i])
            local x1 = (x + i) * 24 - 8 --*25
            local y1 = y * 34 + 30 + 10 --*36
            if self.State == 1 and not text:find("█") and isnumber(tonumber(char)) then y1 = y1 + 2 end
            if y >= 23 and not text:find("█") then y1 = y1 + 3 end
            if text == "Р" then
                x1 = x1 + 1
                y1 = y1 + 3
            end

            local font = "Metrostroi_760_Vityaz"
            if self.State == -3 and self.Train:GetNW2Int("VityazState2", 0) == 0 then --старая версия
                font = font .. "1"
            end

            if self.State ~= -3 then
                if char == "⎕" then
                    x1 = x1 - 2
                    y1 = y1 + 2
                    font = font .. "45"
                end

                if char == "█" then
                    font = font .. "B"
                    x1 = x1 - 3
                end

                if isnumber(tonumber(char)) then
                    font = font .. "A"
                    y1 = y1 - 1
                end

                --if char == "Л" then font = font.."A" end
                if char == "3" then x1 = x1 + 2 end
                if char == "." or char == ":" or char == "i" then x1 = x1 + 1 end
                if char == "Д" or char == "ж" then x1 = x1 - 3 end
                if char == "д" then x1 = x1 - 1.5 end
                if char == "г" then x1 = x1 + 2 end
                if char == "т" then
                    font = font .. "A"
                    x1 = x1 + 1
                end

                if char == "в" then x1 = x1 + 2 end
                if char == "°" then x1 = x1 + 4 end
                if char == "%" or char == "?" then
                    font = font .. "A"
                    y1 = y1 + 3
                end
            else
                if char == "." or char == ":" or char == "i" then x1 = x1 + 1 end
                if char == "A" then x1 = x1 - 3 end
                if char == "t" then x1 = x1 - 3 end
                if char == "ш" then x1 = x1 + 2 end
            end

            if char == "╳" then
                font = font .. "C"
                x1 = x1 - 2
                y1 = y1 + 1
            end

            --if fix and y>=23 then font = "Metrostroi_760_VityazD" end
            if self.State == -3 then
                y1 = y1 + 15
                x1 = x1 + 15
                font = "Metrostroi_760_VityazC"
            end

            draw.SimpleText(char, font, x1, y1, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    local VO = {"БУВ", "BUVState", "БТБ ГОТ", "BTBReady", "ПТ ЭФФ", "PTGood", "ЭТ ЭФФ", "EPTGood", "ТОРМ ОБ", "PTWork", "ЭКС ТОРМ", "EmerActive", "ТОРМ РК", "EmPT", "ПТ ВКЛ", "PTApply", "ОТКАЗ ЭТ", "EDTBroken", "ИСТОЩ ЭТ", "EDTDone", "СТ ТОРМ", "PBApply", "МежВаг С", "EKKGood", "ЗАЩ ББЭ", "BBEProtection", "ББЭ", "BBEEnabled", "НАПР БС", "LVGood", "МК", "MKWork", "ЗАЩИТ ТП", "BVEnabled", "ТЯГ ПРИВ", "TPEnabled", "ТКПР ОТЖ", "PantDisabled", "ЗАПР КОМ", "BadCombination", "ОСВ ВКЛ", "LightsWork", "ВЕНТИЛ 1", "Vent1Work", "ВЕНТИЛ 2", "Vent2Work", "НАПР КС", "HVGood", "ТОРЦ ДВ", "DoorBlock",}
    local Errors = {
        "Сбой КМ",
        "Сбой РВ",
        "Отс. связь с БКВУ", --"Неисправность БКВУ",
        "Вагон не ориент.",
        "Запрет ТР АРС", --БАРС
        "Экстренное торм.",
        "Ст. тормоз прижат",
        "Дверной проем",
        "Пневмотормоз вкл.",
        "Uкс не в норме",
        "Двери не закрыты", --11
        "Открыта кабина ХВ", -- 12
        "Включи МК и ПСН", --"Защита ИПП", 14  13 
        "Включи ПСН", --"Неисправность МК", 15  14
        "Включи МК", --16 --"Буксы не в норме",   15	
        "Освещение не вкл.", --16
        "Конд. не исправен", --17
        "Нет контроля дв.", --18
        "Включи автомат", --"Кузов не в норме", 19
        "Низкое давление ТМ",
    }

    local ErrorNums = {21, 23, 25, 62, 38, 79, 54, 12, 61, 84, 83, 37, 85, 47, 69, 77, 78, 43, 34}
    local purple = Color(200, 100, 150)
    local red = Color(220, 50, 50)
    local green = Color(50, 255, 50)
    local yellow = Color(238, 208, 130) --228,208,130
    local white = Color(240, 240, 240)
    local blue = Color(240, 240, 240)
    local blue2 = Color(0, 77, 117) --0,59,90	
    local grey = Color(170, 170, 170)
    local grey2 = Color(55, 55, 55)
    local mfdu_rect = surface.GetTextureID("mfdu/mfdu_rect")
    function TRAIN_SYSTEM:VityazMonitor(Train)
        local state2 = Train:GetNW2Int("VityazState2", 0)
        local rv = Train:GetNW2Int("VityazRV", 0)
        local wagnum = Train:GetNW2Int("VityazWagNum", 0)
        local mainmsg = Train:GetNW2Int("VityazMainMsg", 0)
        local sel = Train:GetNW2Int("VityazSelected", 0)
        local err = Train:GetNW2Int("VityazError")
        local VityazTime = Train:GetNW2String("VityazTime"):sub(1, 2) .. ":" .. Train:GetNW2String("VityazTime"):sub(3, 4) .. ":" .. Train:GetNW2String("VityazTime"):sub(5, 6)
        if self.State ~= 0 then
            surface.SetDrawColor(0, 0, 0, 195)
            surface.DrawRect(0, 0, 1024, 1024)
        end

        self.AO = Train:GetNW2Bool("AOState", false)
        if Train:GetNW2Bool("VityazTV", false) then
            surface.SetDrawColor(0, 90, 255)
            surface.DrawRect(0, 0, 1024, 1024)
        elseif self.State >= 1 and self.State < 5 and rv == 0 then
            self:PrintText(16, 2, "РВ выключены", yellow)
        elseif self.State == -3 then
            if state2 == 0 then
                -- старая версия тест пу
                surface.SetDrawColor(0, 90, 255)
                surface.DrawRect(0, 0, 1024, 1024)
                self:PrintText(15, 1, "ТЕСТ ПУ", yellow)
                for i = 1, 10 do
                    surface.SetDrawColor(Train:GetNW2Bool("VityazMNMM" .. (i + 4)) and red or green)
                    surface.DrawRect(40 + (i - 1) * 90, 720, 60, 67)
                end

                for i = 1, 7 do
                    surface.SetDrawColor(Train:GetNW2Bool("VityazMNMM" .. (i + 14)) and red or green)
                    surface.DrawRect(850, 110 + (i - 1) * 80, 60, 67)
                end

                for i = 1, 4 do
                    surface.SetDrawColor(Train:GetNW2Bool("VityazMNMM" .. (i + 21)) and red or green)
                    surface.DrawRect(40, 110 + (i - 1) * 80, 60, 67)
                end
            else
                -- новая версия тест мфду-м
                local Timer = os.date("%H %M %S", CurTime() - Train:GetNW2Int("VityazTimer", 0) + 75600)
                local Count = Format("%05d", Train:GetNW2Int("VityazCount", 0))
                local CPU = Format("%03d", 6)
                local CPUt = Format("%03d", 65)
                local MCU1, MCU2 = Format("%04X", Train:GetNW2Int("VityazMCU1", 0)), Format("%04X", Train:GetNW2Int("VityazMCU2", 0))
                Metrostroi.DrawRectOutline(3, 12, 958, 826, grey, 3)
                self:PrintText(0, 0, "Тест МФДУ-М    141201 49774", grey)
                self:PrintText(14, 0, "(      .     )", grey2)
                self:PrintText(0, 1, "7e3a291e68a0639eec49331e6e6f63a0", grey)
                self:PrintText(0, 2, "CRC16 MCU1:       MCU2:", grey2)
                self:PrintText(12, 2, MCU1 .. "        " .. MCU2, grey)
                self:PrintText(0, 3, "Время непр.работы:", grey2)
                self:PrintText(19, 3, Timer, grey)
                self:PrintText(19, 3, "  :  :", grey2)
                self:PrintText(0, 4, "Разрешение экрана:     x     (  )", grey2)
                self:PrintText(19, 4, "0800 0600  32", grey)
                surface.SetDrawColor(Color(220, 30, 30, 129))
                surface.DrawRect(17, 208, 171, 171)
                surface.SetDrawColor(Color(50, 255, 50, 129))
                surface.DrawRect(208, 208, 171, 171)
                surface.SetDrawColor(Color(20, 50, 255, 129))
                surface.DrawRect(401, 208, 171, 171)
                surface.SetDrawColor(Color(230, 230, 230, 100))
                surface.DrawRect(594, 208, 171, 171)
                self:PrintText(0, 7, "Красный Зеленый  Синий   Белый", Color(2, 2, 2))
                self:PrintText(0, 10, "Обм S-PORT CANG1 CANG2 CANP1 CANP2", grey2)
                self:PrintText(0, 11, "Прд", grey2)
                self:PrintText(4, 11, "000000 00000 00000 00000 00000", grey)
                self:PrintText(0, 12, "Прм", grey2)
                self:PrintText(4, 12, "000000 00000 00000 00000 00000", grey)
                self:PrintText(0, 13, "Ошб", grey2)
                self:PrintText(4, 13, "000000 00000 00000 00000 00000", grey)
                self:PrintText(0, 14, "Кнопочные панели", grey2)
                self:PrintText(0, 15, "Нажатий:", grey2)
                self:PrintText(11, 15, Count, grey)
                self:PrintText(0, 17, "CPU:          %", grey2)
                self:PrintText(11, 17, CPU, grey)
                self:PrintText(0, 18, "t CPU:        °C", grey2)
                self:PrintText(11, 18, CPUt, grey)
                for i = 1, 10 do
                    --surface.SetDrawColor(255,255,255)
                    surface.SetDrawColor(Train:GetNW2Bool("VityazMNMM" .. (i + 4)) and Color(150, 150, 150) or Color(255, 255, 255))
                    surface.SetTexture(mfdu_rect)
                    surface.DrawTexturedRectRotated(64 + 80 * (i - 1), 752, 90, 110, 0)
                    self:PrintText(3.33 * (i - 1) + 1.4, 20.5, tostring(i == 10 and 0 or i), grey)
                end

                for i = 1, 7 do
                    surface.SetDrawColor(Train:GetNW2Bool("VityazMNMM" .. (i + 14)) and Color(150, 150, 150) or Color(255, 255, 255))
                    surface.SetTexture(mfdu_rect)
                    surface.DrawTexturedRectRotated(905, 75 + (i - 1) * 96, 96, 110, 0)
                end

                draw.SimpleText("КОНТР", "Metrostroi_760_VityazD", 904, 85 - 5, grey, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                draw.SimpleText("?", "Metrostroi_760_VityazB", 906, 85 + 96 - 10, grey, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                draw.SimpleText("СБР", "Metrostroi_760_VityazB", 904, 85 + 96 * 4 - 10, grey, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                draw.SimpleText("ВЫБ", "Metrostroi_760_VityazB", 904, 85 + 96 * 5 - 10, grey, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                draw.SimpleText("ВВОД", "Metrostroi_760_VityazB", 904, 85 + 96 * 6 - 20, grey, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                draw.SimpleText("РЕЖ", "Metrostroi_760_VityazB", 904, 85 + 96 * 6 + 10, grey, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        elseif self.State == 1 then
            self:PrintText(13, 11, "ВВЕДИТЕ ПАРОЛЬ", yellow)
            local pass = Train:GetNW2String("VityazPass", "")
            self:PrintText(18, 13, "████", blue2)
            for i = 1, #pass do
                if pass[i] ~= "" then self:PrintText(17 + i, 13, pass[i], white) end
            end
        elseif self.State == 2 then
            local enter = Train:GetNW2String("VityazEnter", "-")
            if enter == "-" then enter = false end
            if state2 == 0 then
                self:PrintText(37, 3 + sel * 2, "<", blue)
                self:PrintText(11, 1, "Режим  ДЕПО", yellow)
                self:PrintText(2, 3, "1 Номера вагонов", yellow)
                --self:PrintText(10,2,"вагонов",yellow)
                self:PrintText(36, 3, ">", blue, "right")
                self:PrintText(2, 5, "2 Дата", yellow)
                --if sel==1 and enter then self:PrintText(36,5,enter..string.rep("█",4-#enter),yellow,"right") else self:PrintText(36,5,Train:GetNW2String("VityazDate","0"),yellow,"right") end
                if sel == 1 and enter then
                    self:PrintText(36, 5, enter:sub(1, 2) .. string.rep(" ", 2 - #enter:sub(1, 2)) .. "." .. enter:sub(3, 4) .. string.rep(" ", 2 - #enter:sub(3, 4)) .. "." .. enter:sub(5, 8) .. string.rep(" ", 4 - #enter:sub(5, 8)), yellow, "right")
                else
                    self:PrintText(36, 5, Train:GetNW2String("VityazDate"):sub(1, 2) .. "." .. Train:GetNW2String("VityazDate"):sub(3, 4) .. "." .. Train:GetNW2String("VityazDate"):sub(5, 8), yellow, "right")
                end

                self:PrintText(2, 7, "3 Время", yellow)
                if sel == 2 and enter then
                    self:PrintText(36, 7, enter:sub(1, 2) .. string.rep(" ", 2 - #enter:sub(1, 2)) .. ":" .. enter:sub(3, 4) .. string.rep(" ", 2 - #enter:sub(3, 4)) .. ":" .. enter:sub(5, 6) .. string.rep(" ", 2 - #enter:sub(5, 6)), yellow, "right")
                else
                    self:PrintText(36, 7, VityazTime, yellow, "right")
                end

                self:PrintText(2, 9, "4 Маршрут", yellow)
                if sel == 3 and enter then
                    self:PrintText(36, 9, enter .. string.rep(" ", 2 - #enter), yellow, "right")
                else
                    self:PrintText(36, 9, Format("%02d", Train:GetNW2String("VityazRouteNumber", "0")), yellow, "right")
                end

                self:PrintText(2, 11, "5 Кол-во вагонов", yellow)
                if sel == 4 and enter then
                    self:PrintText(36, 11, enter .. string.rep(" ", 1 - #enter), yellow, "right")
                else
                    self:PrintText(36, 11, Format("%d", Train:GetNW2Int("VityazWagNum", "0")), yellow, "right")
                end

                self:PrintText(2, 13, "6 Код депо", yellow)
                if sel == 5 and enter then
                    self:PrintText(36, 13, enter .. string.rep(" ", 3 - #enter), yellow, "right")
                else
                    self:PrintText(36, 13, Format("%03d", Train:GetNW2String("VityazDepotCode", "0")), yellow, "right")
                end

                self:PrintText(2, 15, "7 Номер станции", yellow)
                --self:PrintText(4,5,"отправления",yellow)
                if sel == 6 and enter then
                    self:PrintText(36, 15, enter .. string.rep(" ", 2 - #enter), yellow, "right")
                else
                    self:PrintText(36, 15, Format("%02d", Train:GetNW2String("VityazDepeatStation", "0")), yellow, "right")
                end

                self:PrintText(2, 17, "8 Номер пути", yellow)
                if sel == 7 and enter then
                    self:PrintText(36, 17, enter .. string.rep(" ", 1 - #enter), yellow, "right")
                else
                    self:PrintText(36, 17, Format("%d", Train:GetNW2String("VityazPath", "0")), yellow, "right")
                end

                self:PrintText(2, 19, "9 Направление", yellow)
                if sel == 8 and enter then
                    self:PrintText(36, 19, enter .. string.rep(" ", 1 - #enter), yellow, "right")
                else
                    self:PrintText(36, 19, Format("%d", Train:GetNW2String("VityazDir", "0")), yellow, "right")
                end

                self:PrintText(1, 21, "10 Диаметр бандажа", yellow)
                if sel == 9 and enter then
                    self:PrintText(36, 21, enter .. string.rep(" ", 3 - #enter), yellow, "right")
                else
                    self:PrintText(36, 21, Format("%03d", Train:GetNW2String("VityazDBand", "0")), yellow, "right")
                end
            elseif state2 == 1 then
                self:PrintText(16, 1, "НОМЕРА ВАГОНОВ", yellow)
                self:PrintText(5, 3, "№ ваг", yellow)
                self:PrintText(23, 3, "заводской №", yellow)
                for i = 1, 8 do
                    self:PrintText(7, 3 + i * 2, tostring(i), yellow)
                    if not enter or sel ~= i - 1 then self:PrintText(25, 3 + i * 2, Format("%05d", Train:GetNW2Int("VityazWagNum" .. i)), yellow) end
                end

                if enter then self:PrintText(25, 5 + sel * 2, enter .. string.rep(" ", 5 - #enter), yellow) end
                self:PrintText(33, 5 + sel * 2, "<", blue)
            end
        elseif self.State == 3 then
            self:PrintText(7, 2, "Вагоны не идентифицированы", yellow)
            for i = 1, wagnum do
                self:PrintText(15 + i, 4, "█", Train:GetNW2Bool("VityazWagI" .. i, false) and green or purple)
            end
        elseif self.State == 4 then
            self:PrintText(14, 2, "Основной  ПУ", yellow) --ОПУ
            self:PrintText(13, 4, "█", Train:GetNW2Bool("VityazBTestOtklR") and green or purple) --Откл рекуперации
            self:PrintText(15, 4, "█", Train:GetNW2Bool("VityazBTestPr") and green or purple) --Прогрев колодок
            self:PrintText(17, 4, "█", Train:GetNW2Bool("VityazBTestKAH") and green or purple) --КАХ
            self:PrintText(19, 4, "█", Train:GetNW2Bool("VityazBTestALS") and green or purple) --АЛС
            self:PrintText(21, 4, "█", Train:GetNW2Bool("VityazBTestAccelRate") and green or purple) --Подъем
            self:PrintText(23, 4, "█", Train:GetNW2Bool("VityazBTestRing") and green or purple) --Передача упр
            self:PrintText(25, 4, "█", Train:GetNW2Bool("VityazBTestDisableBV") and green or purple) --Откл бв
            self:PrintText(27, 4, "█", Train:GetNW2Bool("VityazBTestEnableBV") and green or purple) --Вкл бв (автоведение)
            self:PrintText(9, 6, "█", Train:GetNW2Bool("VityazBTestDoorBlock") and green or purple)
            self:PrintText(27, 6, "█", Train:GetNW2Bool("VityazBTestHeadlights1") and green or purple) --фары 1 гр
            self:PrintText(30, 6, "█", Train:GetNW2Bool("VityazBTestHeadlights2") and green or purple) --фары 2 гр
            self:PrintText(34, 6, "█", Train:GetNW2Bool("VityazBTestEmerBrake") and green or purple) --Тормоз рез
            self:PrintText(13, 7, "█", Train:GetNW2Bool("VityazBTestDoorClose") and green or purple) --Закрыть двери
            self:PrintText(21, 7, "█", Train:GetNW2Bool("VityazBTestAttentionMessage") and green or purple) --Воспр сообщ
            self:PrintText(23, 7, "█", Train:GetNW2Bool("VityazBTestAttentionBrake") and green or purple) --Воспр торм
            self:PrintText(25, 7, "█", Train:GetNW2Bool("VityazBTestAttention") and green or purple) --Бдительность машиниста
            self:PrintText(13, 9, "█", Train:GetNW2Bool("VityazBTestDoorLeft") and green or purple) --Двери левые
            self:PrintText(24, 9, "█", Train:GetNW2Bool("VityazBTestDoorRight") and green or purple) --Двери правые
            self:PrintText(6, 10, "█", Train:GetNW2Bool("VityazBTestPB") and green or purple) --ПБ
            self:PrintText(10, 12, "Вспомогательный  ПУ", yellow) --ВПУ
            self:PrintText(11, 15, "█", Train:GetNW2Bool("VityazBTestSA2") and green or purple) --МК ОСН SA2
            self:PrintText(13, 15, "█", Train:GetNW2Bool("VityazBTestSA3") and green or purple) --Вкл псн SA3
            self:PrintText(16, 15, "█", Train:GetNW2Bool("VityazBTestSA5") and green or purple) --Освещение салона SA5
            self:PrintText(19, 15, "█", Train:GetNW2Bool("VityazBTestSA11") and green or purple) --Блокировка дверей кабины машиниста SA11
            self:PrintText(21, 15, "█", Train:GetNW2Bool("VityazBTestSA12") and green or purple) --Блокировка дверей салона SA12
            self:PrintText(24, 15, "█", Train:GetNW2Bool("VityazBTestSA15") and green or purple) --Двери торц
            self:PrintText(26, 15, "█", Train:GetNW2Bool("VityazBTestSA16") and green or purple) --Отж 1 гр
            self:PrintText(28, 15, "█", Train:GetNW2Bool("VityazBTestSA17") and green or purple) --Отж 2 гр
            self:PrintText(10, 17, "Исправных клавиш", yellow)
            self:PrintText(29, 17, tostring(Train:GetNW2Int("VityazBTest")), yellow, "right")
        elseif self.State == 5 and mainmsg > 0 then
            if mainmsg == 3 then
                self:PrintText(16, 2, "ВКЛЮЧЕНЫ 2 РВ", yellow)
            elseif mainmsg == 2 then
                self:PrintText(16, 2, "ХВОСТОВОЙ ПУ", yellow)
            elseif mainmsg == 1 then
                self:PrintText(16, 2, "РВ выключены", yellow)
            elseif mainmsg == 4 then
                self:PrintText(16, 2, "Сбой РВ", yellow)
            end

            if mainmsg < 3 then
                self.SpeedLimitNext = nil
                self.SpeedLimit = nil
            end
        elseif self.State == 5 then
            --local BUVState = Train:GetNW2Bool("VityazBUVState"..i,false)
            self:PrintText(5, 0, "РЕЖИМ:", yellow)
            if not Train:GetNW2Bool("VityazBARSPN2", false) then
                local strength = Train:GetNW2Int("VityazThrottle", 0)
                if strength > 0 then
                    self:PrintText(11, 0, string.format("Х%03d%%", strength), yellow, true)
                elseif strength < 0 then
                    self:PrintText(11, 0, string.format("Т%03d%%", math.abs(strength)), yellow, true)
                else
                    self:PrintText(11, 0, "ВЫБЕГ", yellow, true)
                end
            else
                self:PrintText(11, 0, "ТОРМ.УД.", yellow, true)
            end

            self:PrintText(1, 1, "█", blue2)
            if CurTime() % 1 < 0.4 then self:PrintText(1, 1, "?", yellow) end
            self:PrintText(10, 2, "№ вагона:", yellow, "right")
            for i = 1, wagnum do
                self:PrintText(10 + i, 2, tostring(i), blue, true)
            end

            self:PrintText(7, 4, "Двери", yellow, "right")
            self:PrintText(8, 4, "Л", Train:GetNW2Bool("VityazDoorBlockL", false) and green or purple, "right")
            self:PrintText(9, 4, "П", Train:GetNW2Bool("VityazDoorBlockR", false) and green or purple, "right")
            self:PrintText(10, 4, ":", yellow, "right")
            for i = 1, wagnum do
                if not Train:GetNW2Bool("VityazBattery" .. i, false) then
                    if CurTime() % 1 > 0.4 then self:PrintText(10 + i, 4, "█", red) end
                else
                    if not Train:GetNW2Bool("VityazBUVState" .. i, false) then
                        self:PrintText(10 + i, 4, "╳", Train:GetNW2Bool("VityazDoors" .. i, false) and green or purple)
                    elseif Train:GetNW2Bool("VityazPVU" .. i .. "2", false) then
                        self:PrintText(10 + i, 4, "Р", Train:GetNW2Bool("VityazDoors" .. i, false) and green or purple)
                    else
                        local right = Train:GetNW2Bool("VityazDoorRight" .. i, false)
                        local left = Train:GetNW2Bool("VityazDoorLeft" .. i, false)
                        if left and not right then
                            self:PrintText(10 + i, 4, "Л", purple)
                        elseif right and not left then
                            self:PrintText(10 + i, 4, "П", purple)
                        elseif left and right then
                            self:PrintText(10 + i, 4, "█", purple)
                        else
                            self:PrintText(10 + i, 4, "█", green)
                        end
                    end
                end
            end

            self:PrintText(10, 5, "БВ:", yellow, "right")
            for i = 1, wagnum do
                if not Train:GetNW2Bool("VityazAsyncInverter" .. i, false) then
                    self:PrintText(10 + i, 5, "-", white)
                elseif not Train:GetNW2Bool("VityazBattery" .. i, false) or not Train:GetNW2Bool("VityazBUVState" .. i, false) or not Train:GetNW2Bool("VityazSF" .. i .. "52", false) then
                    self:PrintText(10 + i, 5, "╳", Train:GetNW2Bool("VityazBV" .. i, false) and green or purple)
                elseif Train:GetNW2Bool("VityazPVU" .. i .. "1", false) then
                    self:PrintText(10 + i, 5, "Р", Train:GetNW2Bool("VityazBV" .. i, false) and green or purple)
                else
                    self:PrintText(10 + i, 5, "█", Train:GetNW2Bool("VityazBV" .. i, false) and green or purple)
                end
            end

            self:PrintText(10, 6, "Сбор сх:", yellow, "right")
            for i = 1, wagnum do
                if not Train:GetNW2Bool("VityazAsyncInverter" .. i, false) then
                    self:PrintText(10 + i, 6, "-", white)
                elseif Train:GetNW2Bool("VityazBUVState" .. i, false) and Train:GetNW2Bool("VityazBattery" .. i, false) and Train:GetNW2Bool("VityazSF" .. i .. "52", false) then
                    self:PrintText(10 + i, 6, "█", Train:GetNW2Bool("VityazScheme" .. i, false) and green or purple, false, true)
                else
                    self:PrintText(10 + i, 6, "╳", Train:GetNW2Bool("VityazScheme" .. i, false) and green or purple, false, true)
                end
            end

            if Train:GetNW2Bool("AccelRateLamp", false) then self:PrintText(10, 6.1, "П", white) end
            self:PrintText(10, 7, "Пт вкл:", yellow, "right")
            for i = 1, wagnum do
                if Train:GetNW2Bool("VityazBUVState" .. i, false) then
                    self:PrintText(10 + i, 7, "█", Train:GetNW2Bool("VityazPTApply" .. i, false) and green or purple)
                else
                    self:PrintText(10 + i, 7, "╳", Train:GetNW2Bool("VityazPTApply" .. i, false) and green or purple)
                end
            end

            self:PrintText(10, 8, "Ст торм:", yellow, "right")
            for i = 1, wagnum do
                if Train:GetNW2Bool("VityazBUVState" .. i, false) then
                    self:PrintText(10 + i, 8, "█", Train:GetNW2Bool("VityazPBApply" .. i, false) and green or purple)
                else
                    self:PrintText(10 + i, 8, "╳", Train:GetNW2Bool("VityazPBApply" .. i, false) and green or purple)
                end
            end

            self:PrintText(10, 9, "Эксторм:", yellow, "right")
            for i = 1, wagnum do
                if Train:GetNW2Bool("VityazBUVState" .. i, false) then
                    self:PrintText(10 + i, 9, "█", Train:GetNW2Bool("VityazEmerActive" .. i, false) and green or purple)
                else
                    self:PrintText(10 + i, 9, "╳", Train:GetNW2Bool("VityazEmerActive" .. i, false) and green or purple)
                end
            end

            self:PrintText(10, 10, "БКВУ:", yellow, "right")
            for i = 1, wagnum do
                self:PrintText(10 + i, 10, "█", Train:GetNW2Bool("VityazBUVState" .. i, false) and green or purple)
            end

            self:PrintText(10, 11, "ПСН:", yellow, "right")
            for i = 1, wagnum do
                if not Train:GetNW2Bool("VityazAsyncInverter" .. i, false) then
                    self:PrintText(10 + i, 11, "-", white)
                elseif not Train:GetNW2Bool("VityazBUVState" .. i, false) then
                    self:PrintText(10 + i, 11, "╳", Train:GetNW2Bool("VityazPSNWork" .. i, false) and green or purple)
                elseif Train:GetNW2Bool("VityazPVU" .. i .. "8", false) then
                    self:PrintText(10 + i, 11, "Р", Train:GetNW2Bool("VityazPSNWork" .. i, false) and green or purple)
                else
                    self:PrintText(10 + i, 11, "█", Train:GetNW2Bool("VityazPSNWork" .. i, false) and green or purple)
                end
            end

            self:PrintText(10, 12, "Рессора:", yellow, "right")
            for i = 1, wagnum do
                if not Train:GetNW2Bool("VityazBUVState" .. i, false) then
                    self:PrintText(10 + i, 12, "╳", green)
                else
                    self:PrintText(10 + i, 12, "█", green)
                end
            end

            self:PrintText(10, 13, "Неис ТП:", yellow, "right")
            for i = 1, wagnum do
                if not Train:GetNW2Bool("VityazAsyncInverter" .. i, false) then
                    self:PrintText(10 + i, 13, "-", white)
                elseif not Train:GetNW2Bool("VityazBUVState" .. i, false) then
                    self:PrintText(10 + i, 13, "╳", Train:GetNW2Bool("VityazTPEnabled" .. i, false) and green or purple)
                elseif Train:GetNW2Bool("VityazPVU" .. i .. "9", false) then
                    self:PrintText(10 + i, 13, "Р", Train:GetNW2Bool("VityazTPEnabled" .. i, false) and green or purple)
                else
                    self:PrintText(10 + i, 13, "█", Train:GetNW2Bool("VityazTPEnabled" .. i, false) and green or purple)
                end
            end

            self:PrintText(10, 14, "БТБ гот:", yellow, "right")
            for i = 1, wagnum do
                if not Train:GetNW2Bool("VityazBUVState" .. i, false) then
                    self:PrintText(10 + i, 14, "╳", Train:GetNW2Bool("VityazBTBReady" .. i, false) and green or purple)
                else
                    self:PrintText(10 + i, 14, "█", Train:GetNW2Bool("VityazBTBReady" .. i, false) and green or purple)
                end
            end

            if Train:GetNW2Bool("VityazCond", false) then
                self:PrintText(9, 15, "Л", green, "right")
            else
                self:PrintText(9, 15, "З", Color(30, 200, 255), "right")
            end

            if Train:GetNW2Bool("VityazCond", false) then
                self:PrintText(9, 16, "Л", green, "right")
            else
                self:PrintText(9, 16, "З", Color(30, 200, 255), "right")
            end

            self:PrintText(7, 15, "Конд1", yellow, "right")
            self:PrintText(10, 15, ":", yellow, "right")
            for i = 1, wagnum do
                if not Train:GetNW2Bool("VityazBUVState" .. i, false) then
                    self:PrintText(10 + i, 15, "╳", Train:GetNW2Bool("VityazCond1" .. i, false) and green or purple)
                else
                    self:PrintText(10 + i, 15, "█", Train:GetNW2Bool("VityazCond1" .. i, false) and green or purple)
                end
            end

            self:PrintText(7, 16, "Конд2", yellow, "right")
            self:PrintText(10, 16, ":", yellow, "right")
            for i = 1, wagnum do
                if not Train:GetNW2Bool("VityazBUVState" .. i, false) then
                    self:PrintText(10 + i, 16, "╳", Train:GetNW2Bool("VityazCond2" .. i, false) and green or purple)
                else
                    self:PrintText(10 + i, 16, "█", Train:GetNW2Bool("VityazCond2" .. i, false) and green or purple)
                end
            end

            self:PrintText(1, 18, "Pmin", yellow)
            self:PrintText(2, 19, Format("%.1f", Train:GetNW2Int("VityazPMin", 0) / 10), blue)
            self:PrintText(6, 18, "Pmax", yellow)
            self:PrintText(7, 19, Format("%.1f", Train:GetNW2Int("VityazPMax", 0) / 10), blue, false)
            local NM = Format("%.1f", Train:GetNW2Int("VityazPNM", 0) / 10)
            self:PrintText(12, 18, "Pнм", yellow)
            self:PrintText(12, 19, NM, tonumber(NM) <= 5.5 and red or blue)
            self:PrintText(16, 18, "Uбс", yellow)
            local Ubs = Train:GetNW2Int("VityazUbs", 0)
            self:PrintText(17, 19, Format("%02d", Ubs), blue)
            if err > 0 then self:PrintText(19, 21, Errors[err], yellow, "right") end
            --self:PrintText(19,12.6,"ВО",yellow,"right")
            --self:PrintText(21,12.6,"ВО",yellow,"right")
            self.Speed = Train:GetNW2Int("VityazSpeed", 0)
            local speedL = Train:GetNW2Int("VityazSpeedLimit", 0)
            if self.AO then self:PrintText(21, 9, "АО", green, true) end
            self.RezhimARS = Train:GetNW2Bool("PmvFreq") and "2/6" or (Train:GetNW2Bool("STL", false) and "ДАУ" or "1/5")
            local speedLN = Train:GetNW2Int("VityazSpeedLimitNext", -1) == 20 and 0 or Train:GetNW2Int("VityazSpeedLimitNext", -1)
            self:PrintText(24, 3, "V доп", yellow, true)
            self:PrintText(24, 5, "V факт", yellow, true)
            if self.RezhimARS == "2/6" or self.RezhimARS == "ДАУ" then self:PrintText(24, 7, "V пред", yellow, true) end
            local Prost = Train:GetNW2Bool("VityazProst", false)
            local Kos = Train:GetNW2Bool("VityazKos", false)
            local Metka, ProstActive, Kos2 = Train:GetNW2Bool("VityazProstMetka", false), Train:GetNW2Bool("VityazProstActive", false), Train:GetNW2Bool("VityazProstKos", false)
            if ProstActive and self.Speed > 0 then
                if CurTime() % 1 < 0.4 then if Prost then self:PrintText(21, 0, "ПРОСТ", Metka and green or (Train:GetNW2Bool("BKL", false) and Color(80, 80, 80) or Color(170, 170, 170)), true) end end
            else
                local vityazs = Train:GetNW2Int("VityazS", -1000) / 100
                local prostact = vityazs ~= -1000 and (vityazs < 200 and ProstActive or Metka and vityazs > 200)
                if Prost then self:PrintText(21, 0, "ПРОСТ", prostact and self.Speed > 0 and green or (Train:GetNW2Bool("BKL", false) and Color(80, 80, 80) or Color(170, 170, 170)), true) end
            end

            if Kos then self:PrintText(27, 0, "КОС", (Metka and Kos2) and green or (Train:GetNW2Bool("BKL", false) and Color(80, 80, 80) or Color(170, 170, 170)), true) end
            if Train:GetNW2Int("VityazS", -1000) > -10 and (ProstActive and self.Speed > 0 or not ProstActive) then
                local vityazs = Train:GetNW2Int("VityazS", -1000) / 100
                local s = Format("%.2f", math.abs(vityazs))
                while string.len(s) < 6 do
                    s = "0" .. s
                end

                self:PrintText(19, 1, (vityazs < 0 and "-" or "") .. s, Color(128, 128, 128), "right") --Расстояние
            end

            local ars1 = Train:GetNW2Int("VityazARS1", -1)
            local ars2 = Train:GetNW2Int("VityazARS2", -1)
            self:PrintText(24, 1, "БТБ", yellow, true)
            self:PrintText(28, 1, "█", Train:GetNW2Bool("VityazBTB", false) and red or green)
            self:PrintText(31, 1, "АРС", yellow, true)
            self:PrintText(35, 1, "█", ars1 == 0 and red or ars1 == 1 and green or ars1 == 2 and yellow or grey2)
            self:PrintText(37, 1, "█", ars2 == 0 and red or ars2 == 1 and green or ars2 == 2 and yellow or grey2)
            self:PrintText(24, 9, "РЕЖИМ: " .. (Train:GetNW2Bool("VityazUOS", false) and "УОС" or self.RezhimARS), yellow)
            local nextnofq, KB = Train:GetNW2Bool("VityazNextNoFq", false), Train:GetNW2Bool("VityazKB", false)
            for i = 0, 2 - ((self.RezhimARS == "2/6" or self.RezhimARS == "ДАУ") and 0 or 1) do
                self:PrintText(35, 3 + i * 2, "км/ч", yellow)
            end

            self:PrintText(34, 5, tostring(self.Speed), blue, "right")
            if speedL < 21 then
                self:PrintText(34, 3, KB and "20" or speedL == 19 and "ОЧ" or "0", blue, "right")
            else
                self:PrintText(34, 3, tostring(speedL), blue, "right")
            end

            self.SpeedLimit = speedL < 21 and (KB and 20 or 0) or speedL
            if speedLN < 21 and self.RezhimARS ~= "1/5" then
                self:PrintText(34, 7, nextnofq and "ОЧ" or "0", blue, "right")
            elseif self.RezhimARS ~= "1/5" then
                self:PrintText(34, 7, tostring(speedLN), blue, "right")
            end

            if self.RezhimARS == "1/5" then
                self.SpeedLimitNext = speedLN == -1 and -1 or speedLN < 21 and 0 or -1
            else
                self.SpeedLimitNext = speedLN < 21 and 0 or speedLN --[[(KB and 20 or 0)]]
            end

            local ERROR_BKPU = Train:GetNW2Int("VityazErr", 0)
            if ERROR_BKPU > 0 then
                self:PrintText(21, 12, "НЕИСПРАВНОСТЬ АРС", red)
                self:PrintText(26, 14, "ПЕРЕВЕДИ", red)
                self:PrintText(23, 16, "БЛОКИРАТОР В", red)
                self:PrintText(22, 18, "ПОЛОЖЕНИЕ БКПУ" .. ERROR_BKPU, red)
            elseif ERROR_BKPU == -1 then
                self:PrintText(23, 15, "НАЖАТА  КНОПКА", yellow)
                self:PrintText(21, 17, "БЛОКИРОВКА ДВЕРЕЙ", red)
            elseif state2 == 11 then
                self:PrintText(23, 11, "СОСТОЯНИЕ ВО 1", yellow)
                self:PrintText(21, 12, "№ вагона:", yellow)
                for i = 1, wagnum do
                    self:PrintText(30 + i, 12, tostring(i), blue)
                end

                self:PrintText(21, 14, "Буксы", yellow)
                for i = 1, wagnum do
                    self:PrintText(30 + i, 14, "█", green)
                end

                self:PrintText(21, 15, "МК", yellow)
                for i = 1, wagnum do
                    if not Train:GetNW2Bool("VityazAsyncInverter" .. i, false) then
                        self:PrintText(30 + i, 15, "-", white)
                    elseif Train:GetNW2Bool("VityazPVU" .. i .. "3", false) then
                        self:PrintText(30 + i, 15, "Р", Train:GetNW2Bool("VityazMKWork" .. i, false) and green or purple)
                    else
                        self:PrintText(30 + i, 15, "█", Train:GetNW2Bool("VityazMKWork" .. i, false) and green or purple)
                    end
                end

                self:PrintText(21, 16, "ЗУ АКБ", yellow)
                for i = 1, wagnum do
                    if not Train:GetNW2Bool("VityazAsyncInverter" .. i, false) then
                        self:PrintText(30 + i, 16, "-", white)
                    else
                        self:PrintText(30 + i, 16, "█", Train:GetNW2Bool("VityazAKB" .. i, false) and green or green)
                    end
                end

                self:PrintText(21, 17, "Осв вкл", yellow)
                for i = 1, wagnum do
                    if Train:GetNW2Bool("VityazPVU" .. i .. "5", false) then
                        self:PrintText(30 + i, 17, "Р", Train:GetNW2Bool("VityazLightsWork" .. i, false) and green or purple)
                    else
                        self:PrintText(30 + i, 17, "█", Train:GetNW2Bool("VityazLightsWork" .. i, false) and green or purple)
                    end
                end

                self:PrintText(21, 18, "Торм об", yellow)
                for i = 1, wagnum do
                    self:PrintText(30 + i, 18, "█", Train:GetNW2Bool("VityazPTWork" .. i, false) and green or purple)
                end

                self:PrintText(21, 19, "Торм рк", yellow)
                for i = 1, wagnum do
                    self:PrintText(30 + i, 19, "█", Train:GetNW2Bool("VityazEmPT" .. i, false) and green or purple)
                end

                self:PrintText(21, 20, "СОЗВ1", yellow)
                for i = 1, wagnum do
                    self:PrintText(30 + i, 20, "-", white)
                end

                self:PrintText(21, 21, "СОЗВ2", yellow)
                for i = 1, wagnum do
                    self:PrintText(30 + i, 21, "-", white)
                end

                self:PrintText(21, 22, "Торц.Дв", yellow)
                for i = 1, wagnum do
                    self:PrintText(30 + i, 22, "-", white) --Train:GetNW2Bool("VityazDoorBlock"..i,false) and green or purple)
                end
            elseif state2 == 12 then
                self:PrintText(23, 11, "СОСТОЯНИЕ ВО 2", yellow)
                self:PrintText(21, 12, "№ вагона:", yellow)
                for i = 1, wagnum do
                    self:PrintText(30 + i, 12, tostring(i), blue)
                end

                self:PrintText(21, 14, "ТКПР Отж.", yellow)
                for i = 1, wagnum do
                    if Train:GetNW2Bool("VityazPVU" .. i .. "4", false) then
                        self:PrintText(30 + i, 14, "Р", Train:GetNW2Bool("VityazPantDisabled" .. i, false) and green or purple)
                    else
                        self:PrintText(30 + i, 14, "█", Train:GetNW2Bool("VityazPantDisabled" .. i, false) and green or purple)
                    end
                end

                self:PrintText(21, 15, "Uкс", yellow)
                for i = 1, wagnum do
                    if not Train:GetNW2Bool("VityazAsyncInverter" .. i, false) then
                        self:PrintText(30 + i, 15, "-", white)
                    else
                        self:PrintText(30 + i, 15, "█", Train:GetNW2Bool("VityazHVGood" .. i, false) and green or purple)
                    end
                end

                self:PrintText(21, 16, "ПТ Эфф.", yellow)
                for i = 1, wagnum do
                    self:PrintText(30 + i, 16, "█", Train:GetNW2Bool("VityazPTGood" .. i, false) and green or purple)
                end

                self:PrintText(21, 17, "Отказ ЭТ", yellow)
                for i = 1, wagnum do
                    if not Train:GetNW2Bool("VityazAsyncInverter" .. i, false) then
                        self:PrintText(30 + i, 17, "-", white)
                    else
                        self:PrintText(30 + i, 17, "█", Train:GetNW2Bool("VityazEDTBroken" .. i, false) and green or purple)
                    end
                end

                self:PrintText(21, 18, "Защ.Инв", yellow)
                for i = 1, wagnum do
                    if not Train:GetNW2Bool("VityazAsyncInverter" .. i, false) then
                        self:PrintText(30 + i, 18, "-", white)
                    else
                        self:PrintText(30 + i, 18, "█", green)
                    end
                end

                self:PrintText(21, 19, "Перег.Инв", yellow)
                for i = 1, wagnum do
                    if not Train:GetNW2Bool("VityazAsyncInverter" .. i, false) then
                        self:PrintText(30 + i, 19, "-", white)
                    else
                        self:PrintText(30 + i, 19, "█", green)
                    end
                end

                self:PrintText(21, 20, "Неисп.ВТР", yellow)
                for i = 1, wagnum do
                    if not Train:GetNW2Bool("VityazAsyncInverter" .. i, false) then
                        self:PrintText(30 + i, 20, "-", white)
                    else
                        self:PrintText(30 + i, 20, "█", green)
                    end
                end

                self:PrintText(21, 21, "Межв.соед", yellow)
                for i = 1, wagnum do
                    self:PrintText(30 + i, 21, "█", Train:GetNW2Bool("VityazEKKGood" .. i, false) and green or purple)
                end
            elseif state2 == 13 then
                self:PrintText(23, 11, "СОСТОЯНИЕ ВО 3", yellow)
                self:PrintText(21, 12, "№ вагона:", yellow)
                for i = 1, wagnum do
                    self:PrintText(30 + i, 12, tostring(i), blue)
                end

                for k = 1, 8 do
                    self:PrintText(21, 13 + k, "ДПБТ" .. tostring(k), yellow)
                    for i = 1, wagnum do
                        self:PrintText(30 + i, 13 + k, "█", Train:GetNW2Bool("VityazDPBT" .. k .. i, false) and green or purple)
                    end
                end
            elseif state2 == 14 then
                self:PrintText(23, 11, "ТОКОПРИЕМНИКИ", yellow)
                self:PrintText(20, 12, "№ваг", yellow)
                for i = 1, wagnum do
                    self:PrintText(22, 13 + i, tostring(i), blue)
                end

                for k = 1, 4 do
                    self:PrintText(21 + k * 4, 12, "ТП" .. tostring(k), yellow)
                    for i = 1, wagnum do
                        self:PrintText(22 + k * 4, 13 + i, "█", Train:GetNW2Bool("VityazPant" .. k .. i, false) and green or purple)
                        --if Train:GetNW2Bool("VityazPVU"..i.."4",false) then--and not Train:GetNW2Bool("VityazPant"..k..i,false) then
                        --self:PrintText(22+k*4,13+i,"Р",red)
                        --end
                    end
                end
            elseif state2 == 15 then
                self:PrintText(22, 11, "НЕИСПРАВНОСТЬ ЮЗ", yellow)
                self:PrintText(20, 12, "№ваг", yellow)
                for i = 1, wagnum do
                    self:PrintText(22, 13 + i, tostring(i), blue)
                end

                for k = 1, 4 do
                    self:PrintText(21 + k * 4, 12, "СК" .. tostring(k), yellow)
                    for i = 1, wagnum do
                        self:PrintText(22 + k * 4, 13 + i, "█", green)
                    end
                end
            elseif state2 == 16 then
                self:PrintText(24, 11, "КОНТРОЛЬ КЗ", yellow)
                self:PrintText(21, 12, "№ вагона:", yellow)
                for i = 1, wagnum do
                    self:PrintText(30 + i, 12, tostring(i), blue)
                end

                for k = 1, 4 do
                    self:PrintText(21, 13 + k, "УККЗ " .. tostring(k), yellow)
                    for i = 1, wagnum do
                        self:PrintText(30 + i, 13 + k, "█", green)
                    end
                end
            elseif state2 == 21 then
                self:PrintText(22, 11, "СОСТОЯНИЕ ДВЕРЕЙ", yellow)
                self:PrintText(21, 12, "№", yellow)
                self:PrintText(23, 12, "левые", yellow)
                self:PrintText(30, 12, "правые", yellow)
                self:PrintText(37, 12, "ОР", yellow)
                for i = 1, wagnum do
                    self:PrintText(21, 13 + i, tostring(i), blue)
                    for d = 1, 4 do
                        self:PrintText(23 + d, 13 + i, "█", Train:GetNW2Bool("VityazDoor" .. d .. "L" .. i, false) and green or purple)
                        self:PrintText(29 + d, 13 + i, "█", Train:GetNW2Bool("VityazDoor" .. d .. "R" .. i, false) and green or purple)
                    end

                    if Train:GetNW2Bool("VityazWagOr" .. i) then
                        self:PrintText(37, 13 + i, "О", yellow)
                    else
                        self:PrintText(37, 13 + i, "П", yellow)
                    end
                end
            elseif state2 == 31 then
                self:PrintText(25, 11, "УСИЛИЕ", yellow)
                self:PrintText(21, 12, "№", yellow)
                self:PrintText(23, 12, "ТЯГ", yellow)
                self:PrintText(28, 12, "ТОРМ", yellow)
                self:PrintText(35, 11, "ПОТР", yellow)
                self:PrintText(35, 12, "МОЩН", yellow)
                for i = 1, wagnum do
                    local DriveStrength = Train:GetNW2Bool("VityazAsyncInverter" .. i, false) and Format("%04.1f", Train:GetNW2Int("VityazDriveStrength" .. i, 0) / 10) or "-"
                    local BrakeStrength = Train:GetNW2Bool("VityazAsyncInverter" .. i, false) and Format("%04.1f", Train:GetNW2Int("VityazBrakeStrength" .. i, 0) / 10) or "-"
                    local EnginesStrength = Format("%06d", Train:GetNW2Int("VityazPower" .. i, 000000))
                    self:PrintText(21, 13 + i, tostring(i), blue)
                    self:PrintText(27, 13 + i, BrakeStrength, yellow, "right")
                    self:PrintText(32, 13 + i, DriveStrength, yellow, "right")
                    self:PrintText(40, 13 + i, EnginesStrength, yellow, "right")
                end
            elseif state2 == 32 then
                self:PrintText(21, 12, "ваг", yellow)
                self:PrintText(21, 11, "№", yellow)
                self:PrintText(26, 12, "Uкс", yellow)
                self:PrintText(33, 12, "ПОТР", yellow)
                self:PrintText(33, 11, "ТОК", yellow)
                for i = 1, wagnum do
                    local I = Train:GetNW2Bool("VityazAsyncInverter" .. i, false) and (Train:GetNW2Int("VityazI" .. i, 0000) < 0 and "-" or "") .. Format("%04d", math.abs(Train:GetNW2Int("VityazI" .. i, 0000))) or "-"
                    local U = Train:GetNW2Bool("VityazAsyncInverter" .. i, false) and (Train:GetNW2Int("VityazU" .. i, 0000) < 0 and "-" or "") .. Format("%04d", math.abs(Train:GetNW2Int("VityazU" .. i, 0000))) or "-"
                    self:PrintText(21, 13 + i, tostring(i), blue)
                    self:PrintText(29, 13 + i, U, yellow, "right")
                    self:PrintText(37, 13 + i, I, yellow, "right")
                end
            elseif state2 == 41 then
                self:PrintText(25, 11, "ТОКИ", yellow)
                self:PrintText(21, 12, "№", yellow)
                self:PrintText(24, 12, "ВО", yellow)
                self:PrintText(29, 12, "МК", yellow)
                self:PrintText(33, 11, "НАПРЯЖ", yellow)
                self:PrintText(35, 12, "БС", yellow)
                for i = 1, wagnum do
                    local IVO = ((Train:GetNW2Int("VityazIVO" .. i, 0) / 10) <= 0 and "-" or "") .. Format("%02d", math.abs(Train:GetNW2Int("VityazIVO" .. i, 0) / 10))
                    local IMK = Train:GetNW2Bool("VityazAsyncInverter" .. i, false) and Format("%02d", Train:GetNW2Int("VityazIMK" .. i, 0) / 10) or "-"
                    local UBS = Train:GetNW2Bool("VityazAsyncInverter" .. i, false) and Format("%02d", Train:GetNW2Int("VityazUBS" .. i, 0) / 10) or "-"
                    self:PrintText(21, 13 + i, tostring(i), blue)
                    self:PrintText(26, 13 + i, IVO, yellow, "right")
                    self:PrintText(31, 13 + i, IMK, yellow, "right")
                    self:PrintText(37, 13 + i, UBS, yellow, "right")
                end
            elseif state2 == 51 then
                self:PrintText(25, 11, "ДАВЛЕНИЕ", yellow)
                self:PrintText(21, 12, "№ ваг", yellow)
                for i = 1, wagnum do
                    self:PrintText(23, 13 + i, tostring(i), blue)
                end

                self:PrintText(29, 12, "Pтц1", yellow)
                for i = 1, wagnum do
                    local Ptrain = Format("% 4.1f", Train:GetNW2Int("VityazP" .. i, 0) / 10)
                    self:PrintText(29, 13 + i, Ptrain, yellow)
                end

                self:PrintText(35, 12, "Pтц2", yellow)
                for i = 1, wagnum do
                    local Ptrain = Format("% 4.1f", Train:GetNW2Int("VityazP" .. i, 0) / 10)
                    self:PrintText(35, 13 + i, Ptrain, yellow)
                end
            elseif state2 == 52 then
                self:PrintText(25, 11, "ДАВЛЕНИЕ", yellow)
                self:PrintText(20, 12, "№ваг", yellow)
                for i = 1, wagnum do
                    self:PrintText(22, 13 + i, tostring(i), blue)
                end

                self:PrintText(25, 12, "Pстт", yellow)
                for i = 1, wagnum do
                    local Ptrain = Format("% 4.1f", Train:GetNW2Int("VityazPstt" .. i, 0) / 10)
                    self:PrintText(25, 13 + i, Ptrain, yellow)
                end

                self:PrintText(30, 12, "Pтм", yellow)
                for i = 1, wagnum do
                    local Ptrain = Format("% 4.1f", Train:GetNW2Int("VityazPtm" .. i, 0) / 10)
                    self:PrintText(30, 13 + i, Ptrain, tonumber(Ptrain) <= 2.8 and red or yellow)
                end

                self:PrintText(35, 12, "Pскк", yellow)
                for i = 1, wagnum do
                    local Ptrain = Format("% 4.1f", Train:GetNW2Int("VityazPskk" .. i, 0) / 10)
                    self:PrintText(35, 13 + i, Ptrain, yellow)
                end
            elseif state2 == 61 then
                local temp = Format("% +4.1f", 25)
                self:PrintText(22, 11, "ТЕМПЕРАТУРА " .. temp, yellow)
                self:PrintText(20, 12, "№ваг", yellow)
                for i = 1, wagnum do
                    self:PrintText(22, 13 + i, tostring(i), blue)
                end

                self:PrintText(26, 12, "Внутр1", yellow)
                for i = 1, wagnum do
                    self:PrintText(26, 13 + i, temp, yellow)
                end

                self:PrintText(33, 12, "Внутр2", yellow)
                for i = 1, wagnum do
                    self:PrintText(33, 13 + i, temp, yellow)
                end
            elseif state2 == 71 then
                self:PrintText(24, 11, "КОНДИЦИОНЕР", yellow)
                self:PrintText(36, 11, "1", yellow)
                self:PrintText(21, 12, "№ вагона:", yellow)
                for i = 1, wagnum do
                    self:PrintText(30 + i, 12, tostring(i), blue)
                end

                self:PrintText(21, 14, "Лето", yellow)
                for i = 1, wagnum do
                    self:PrintText(30 + i, 14, "█", Train:GetNW2Bool("VityazCond", false) and green or purple)
                end

                self:PrintText(21, 15, "Вентил.", yellow)
                for i = 1, wagnum do
                    self:PrintText(30 + i, 15, "█", purple)
                end

                self:PrintText(21, 16, "Обогрев", yellow)
                for i = 1, wagnum do
                    self:PrintText(30 + i, 16, "█", Train:GetNW2Bool("VityazCond1" .. i, false) and not Train:GetNW2Bool("VityazCond", false) and green or purple)
                end

                self:PrintText(21, 17, "Охлажд.", yellow)
                for i = 1, wagnum do
                    self:PrintText(30 + i, 17, "█", Train:GetNW2Bool("VityazCond1" .. i, false) and Train:GetNW2Bool("VityazCond", false) and green or purple)
                end

                self:PrintText(21, 18, "Ошибка", yellow)
                for i = 1, wagnum do
                    self:PrintText(30 + i, 18, "█", green)
                end

                self:PrintText(21, 19, "Обмен", yellow)
                for i = 1, wagnum do
                    self:PrintText(30 + i, 19, "█", green)
                end

                self:PrintText(21, 20, "Пр.отказ", yellow)
                for i = 1, wagnum do
                    self:PrintText(30 + i, 20, "█", green)
                end

                self:PrintText(21, 21, "Режим", yellow)
                self:PrintText(31, 21, "РУЧНОЙ", blue) --АВТО
            elseif state2 == 72 then
                self:PrintText(24, 11, "КОНДИЦИОНЕР", yellow)
                self:PrintText(36, 11, "2", yellow)
                self:PrintText(21, 12, "№ вагона:", yellow)
                for i = 1, wagnum do
                    self:PrintText(30 + i, 12, tostring(i), blue)
                end

                self:PrintText(21, 14, "Лето", yellow)
                for i = 1, wagnum do
                    self:PrintText(30 + i, 14, "█", Train:GetNW2Bool("VityazCond", false) and green or purple)
                end

                self:PrintText(21, 15, "Вентил.", yellow)
                for i = 1, wagnum do
                    self:PrintText(30 + i, 15, "█", purple)
                end

                self:PrintText(21, 16, "Обогрев", yellow)
                for i = 1, wagnum do
                    self:PrintText(30 + i, 16, "█", Train:GetNW2Bool("VityazCond1" .. i, false) and not Train:GetNW2Bool("VityazCond", false) and green or purple)
                end

                self:PrintText(21, 17, "Охлажд.", yellow)
                for i = 1, wagnum do
                    self:PrintText(30 + i, 17, "█", Train:GetNW2Bool("VityazCond1" .. i, false) and Train:GetNW2Bool("VityazCond", false) and green or purple)
                end

                self:PrintText(21, 18, "Ошибка", yellow)
                for i = 1, wagnum do
                    self:PrintText(30 + i, 18, "█", green)
                end

                self:PrintText(21, 19, "Обмен", yellow)
                for i = 1, wagnum do
                    self:PrintText(30 + i, 19, "█", green)
                end

                self:PrintText(21, 20, "Пр.отказ", yellow)
                for i = 1, wagnum do
                    self:PrintText(30 + i, 20, "█", green)
                end

                self:PrintText(21, 21, "Режим", yellow)
                self:PrintText(31, 21, "РУЧНОЙ", blue) --АВТО
            elseif state2 == 81 then
                self:PrintText(25, 11, "НОМЕРА ВАГОНОВ", yellow)
                self:PrintText(21, 12, "№ ваг", yellow)
                self:PrintText(29, 12, "зав №", yellow)
                self:PrintText(37, 12, "ОР", yellow)
                for i = 1, wagnum do
                    self:PrintText(23, 13 + i, tostring(i), blue)
                    if Train:GetNW2Bool("VityazWagOr" .. i) then
                        self:PrintText(37, 13 + i, "О", yellow)
                    else
                        self:PrintText(37, 13 + i, "П", yellow)
                    end

                    local Num = Format("%05d", Train:GetNW2Int("VityazWagNum" .. i))
                    self:PrintText(34, 13 + i, Num, yellow, "right")
                end
            elseif state2 == 91 then
                self:PrintText(21, 11, "СОСТОЯНИЕ АВТОМАТОВ", yellow)
                self:PrintText(21, 12, "№ вагона:", yellow)
                for i = 1, wagnum do
                    self:PrintText(30 + i, 12, tostring(i), blue)
                end

                self:PrintText(21, 14, "ЦУП", yellow)
                self:PrintText(21, 15, "ППП ваг.", yellow)
                self:PrintText(21, 16, "АДУД", yellow)
                self:PrintText(21, 17, "ПСН", yellow)
                self:PrintText(21, 18, "Освещение", yellow)
                self:PrintText(21, 19, "ППП поезд", yellow)
                self:PrintText(21, 20, "Пож.сист.", yellow)
                self:PrintText(21, 21, "АДУВ", yellow)
                for i = 1, wagnum do
                    if Train:GetNW2Bool("VityazAsyncInverter" .. i, false) then
                        for k = 1, #SFTbl[1] do
                            self:PrintText(30 + i, 13 + k, "█", Train:GetNW2Bool("VityazSF" .. i .. SFTbl[1][k], false) and green or purple)
                        end
                    else
                        for k = 1, #SFTbl[11] do
                            self:PrintText(30 + i, 13 + k, SFTbl[11][k] ~= "-" and "█" or "-", SFTbl[11][k] ~= "-" and (Train:GetNW2Bool("VityazSF" .. i .. SFTbl[1][k], false) and green or purple) or white)
                        end
                    end
                end
            elseif state2 == 92 then
                self:PrintText(21, 11, "СОСТОЯНИЕ АВТОМАТОВ", yellow)
                self:PrintText(21, 12, "№ вагона:", yellow)
                for i = 1, wagnum do
                    self:PrintText(30 + i, 12, tostring(i), blue)
                end

                self:PrintText(21, 15, "БОДВ", yellow)
                self:PrintText(21, 16, "Осушитель", yellow)
                self:PrintText(21, 17, "Цепи осн.", yellow)
                self:PrintText(21, 18, "Цепи рез.", yellow)
                self:PrintText(21, 19, "Дв. закр.", yellow)
                self:PrintText(21, 20, "Дв.откр.Л", yellow)
                self:PrintText(21, 21, "Инвертор", yellow)
                for i = 1, wagnum do
                    if Train:GetNW2Bool("VityazAsyncInverter" .. i, false) then
                        for k = 1, #SFTbl[2] do
                            self:PrintText(30 + i, 14 + k, "█", Train:GetNW2Bool("VityazSF" .. i .. SFTbl[2][k], false) and green or purple)
                        end
                    else
                        for k = 1, #SFTbl[12] do
                            self:PrintText(30 + i, 14 + k, SFTbl[12][k] ~= "-" and "█" or "-", SFTbl[12][k] ~= "-" and (Train:GetNW2Bool("VityazSF" .. i .. SFTbl[2][k], false) and green or purple) or white)
                        end
                    end
                end
            elseif state2 == 93 then
                self:PrintText(21, 11, "СОСТОЯНИЕ АВТОМАТОВ", yellow)
                self:PrintText(21, 12, "№ вагона:", yellow)
                for i = 1, wagnum do
                    self:PrintText(30 + i, 12, tostring(i), blue)
                end

                self:PrintText(21, 14, "Дв.откр.П", yellow)
                self:PrintText(21, 15, "Токопр.", yellow)
                self:PrintText(21, 16, "Видео", yellow)
                self:PrintText(21, 17, "Дв. торц.", yellow)
                for i = 1, wagnum do
                    if Train:GetNW2Bool("VityazAsyncInverter" .. i, false) then
                        for k = 1, #SFTbl[3] - 1 do
                            self:PrintText(30 + i, 13 + k, "█", Train:GetNW2Bool("VityazSF" .. i .. SFTbl[3][k], false) and green or purple)
                        end

                        self:PrintText(30 + i, 17, "-", white)
                    else
                        for k = 1, #SFTbl[13] do
                            self:PrintText(30 + i, 13 + k, SFTbl[13][k] ~= "-" and "█" or "-", SFTbl[13][k] ~= "-" and (Train:GetNW2Bool("VityazSF" .. i .. SFTbl[3][k], false) and green or purple) or white)
                        end
                    end
                end
            elseif state2 == 01 then
                self:PrintText(21, 11, "ПОВАГОННОЕ УПРАВЛ-Е", yellow)
                self:PrintText(23, 12, "вагон  №", yellow)
                for i = 1, 9 do
                    self:PrintText(21, 12 + i, tostring(i), yellow)
                end

                self:PrintText(37, 12, tostring(sel), blue)
                if Train:GetNW2Bool("VityazAsyncInverter" .. sel, false) then
                    self:PrintText(23, 13, "БВ", yellow)
                    self:PrintText(36, 13, Train:GetNW2Bool("VityazPVU1") and "ВЫКЛ" or "ВКЛ", yellow)
                    self:PrintText(23, 15, "Компрессор", yellow)
                    self:PrintText(36, 15, Train:GetNW2Bool("VityazPVU3") and "ВЫКЛ" or "ВКЛ", yellow)
                    --self:PrintText(23,18,"Блок т/дв",yellow)
                    --self:PrintText(36,18,Train:GetNW2Bool("VityazPVU6") and "ВЫКЛ" or "ВКЛ",yellow)
                    --self:PrintText(23,19,"",yellow)
                    --self:PrintText(36,19,Train:GetNW2Bool("VityazPVU7") and "ВЫКЛ" or "ВКЛ",yellow)
                    self:PrintText(23, 20, "ПСН", yellow)
                    self:PrintText(36, 20, Train:GetNW2Bool("VityazPVU8") and "ВЫКЛ" or "ВКЛ", yellow)
                    self:PrintText(23, 21, "Тяг. привод", yellow)
                    self:PrintText(36, 21, Train:GetNW2Bool("VityazPVU9") and "ВЫКЛ" or "ВКЛ", yellow)
                end

                self:PrintText(23, 14, "Двери", yellow)
                self:PrintText(36, 14, Train:GetNW2Bool("VityazPVU2") and "БЛОК" or "НЕБЛ", yellow)
                self:PrintText(23, 16, "Токоприемник", yellow)
                self:PrintText(36, 16, Train:GetNW2Bool("VityazPVU4") and "ОТЖ" or "ПРИЖ", yellow)
                self:PrintText(23, 17, "Освещение", yellow)
                self:PrintText(36, 17, Train:GetNW2Bool("VityazPVU5") and "ВЫКЛ" or "ВКЛ", yellow)
            end

            if state2 == 01 then
                surface.SetDrawColor(60, 120, 45)
                surface.DrawRect(0, 806, 970, 36)
                if Train:GetNW2Bool("VityazAsyncInverter" .. sel, false) then
                    self:PrintText(2, 23, "БВ", yellow)
                    self:PrintText(9, 23, "МК", yellow)
                    self:PrintText(28, 23, "ПСН", yellow)
                    self:PrintText(32, 23, "ТП", yellow)
                end

                self:PrintText(6, 23, "ДВ", yellow)
                self:PrintText(12, 23, "ТКПР", yellow)
                self:PrintText(17, 23, "ОСВ", yellow)
                --self:PrintText(21,23,"ТДВ",yellow)
            elseif Train:GetNW2Bool("VityazProstTimer", false) then
                surface.SetDrawColor(20, 50, 255)
                surface.DrawRect(0, 806, 970, 36)
                self:PrintText(1, 23, "ТЕСТ", yellow)
                self:PrintText(9, 23, "КОС", yellow)
                self:PrintText(33, 23, "ПРЦ", yellow) --33
                --if Train:GetNW2Bool("BKL",false) then
                --self:PrintText(37,23,"ОВР",yellow)--33 бкл
                --end
            else
                surface.SetDrawColor(20, 55, 255)
                surface.DrawRect(0, 806, 970, 36)
                self:PrintText(2, 23, "ВО", yellow)
                self:PrintText(6, 23, "ДВ", yellow)
                self:PrintText(10, 23, "ТП", yellow)
                self:PrintText(13, 23, "Ток", yellow)
                self:PrintText(17, 23, "Ртц", yellow)
                self:PrintText(21, 23, "t°", yellow)
                self:PrintText(24, 23, "КНД", yellow)
                self:PrintText(29, 23, "№", yellow)
                self:PrintText(32, 23, "SF", yellow)
                self:PrintText(36, 23, "ПВУ", yellow)
            end
        end

        if self.State > 0 and not Train:GetNW2Bool("VityazTV", false) then
            self:PrintText(0, 0, Format("%02X", Train:GetNW2Int("VityazCounter", 0)), Color(48, 213, 200))
            self:PrintText(2, 0, Format("%02X", Train:GetNW2Int("VityazProstNum", 0)), white)
            if self.State < 5 or self.State == 5 and mainmsg > 0 then self:PrintText(4, 0, "0000", yellow) end
        end

        if self.State > 1 and not Train:GetNW2Bool("VityazTV", false) then self:PrintText(32, 0, VityazTime, blue, false) end
        --if (Train:GetNW2Int("VityazSpeedLimit",0)) == 35 and (self.SpeedLimit ~= (KRO+KRR == 0 and 0 or 35) or self.SpeedLimitNext) then
        --self.SpeedLimit = (KRO+KRR == 0 and 0 or 35)
        --self.SpeedLimitNext = nil
        if self.State < 5 then
            self.SpeedLimit = Train:GetNW2Int("VityazSpeedLimit", 0) == 35 and 35
            self.SpeedLimitNext = nil
        end
        --[[
        if self.State <= 0 and self.SpeedLimit then
            self.SpeedLimitNext = nil
            self.SpeedLimit = nil
        end]]
    end
end
