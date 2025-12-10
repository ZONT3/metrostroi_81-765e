if SERVER then
    AddCSLuaFile()
    return
end


function TRAIN_SYSTEM:Ui765()
    self.MainMsg = self.Train:GetNW2Int("VityazMainMsg", 0)
    if self.MainMsg == 0 and self.State == 5 and not self.LegacyScreen then
        local Wag = self.Train

        self.AlsArs = Wag:GetNW2Bool("PmvFreq")
        local ao = Wag:GetNW2Bool("AOState", false)
        local vigilance = Wag:GetNW2Bool("VityazKB", false)
        local speedNextNofq = Wag:GetNW2Bool("VityazNextNoFq", false)
        local speedNext = self.AlsArs and (speedNextNofq and "0" or Wag:GetNW2Int("VityazSpeedLimitNext", "0")) or "---"
        self.SpeedNext = isnumber(speedNext) and speedNext < 30 and "0" or tostring(speedNext)
        local speedLimit = Wag:GetNW2Int("VityazSpeedLimit", 0)
        self.SpeedLimit = ao and "АО" or speedLimit == 19 and (not vigilance and "ОЧ" or "20") or speedLimit < 30 and not vigilance and "0" or tostring(speedLimit)
        self.Speed = Wag:GetNW2Int("VityazSpeed", 0)

        self.Page = 0
        self.SubPage = 1
        if not self.MainScreen then
            local page = math.floor(self.State2 / 10)
            if page == 1 then
                self.Page = 1
                self.SubPage = self.State2 % 10
                local title = "Вагонное оборудование"
                if self.SubPage > 5 then self.SubPage = 1 end
                if self.SubPage == 2 then title = "УККЗ"
                elseif self.SubPage == 3 then title = "ДПБТ"
                elseif self.SubPage == 4 then title = "Токоприемники"
                elseif self.SubPage == 5 then title = "Буксы"
                end
                self:DrawPage(self.DrawVoPage, title)
            elseif page == 2 then
                self.Page = 2
                self:DrawPage(self.DrawDoorsPage, "Двери")
            elseif page == 3 then
                self.Page = 3
                self:DrawPage(self.DrawAsyncPage, "Тяговый привод")
            elseif page == 4 then
                self.Page = 4
                self:DrawPage(self.DrawElectric, "Электрическая энергия")
            elseif page == 5 then
                self.Page = 5
                self:DrawPage(self.DrawPneumatic, "Пневматическая система")
            elseif page == 6 then
                self.Page = 6
                self:DrawPage(self.DrawCondPage, "Климатическая система")
            end
        end

        if self.Page == 0 then
            self:DrawMain(self.Train)
        end
    else
        return true
    end
end

local scrW, scrH = 1024, 920
local scrOffsetX, scrOffsetY = 0, 20

local sizeFooter = 92
local sizeStatus = 172
local sizeButtonGap = 4
local sizeButtonW = (scrW - sizeButtonGap * 9) / 10
local sizeStatusSide = sizeButtonW * 2 + sizeButtonGap * 2
local sizeThrottleMeasure = 54
local sizeThrottleMeasureLine = 10
local sizeThrottleMargin = 4
local sizeThrottleLabelsH = 36
local sizeThrottleW = sizeButtonW - sizeButtonGap
local sizeThrottleBarW = sizeThrottleW - sizeThrottleMeasure - sizeThrottleMargin
local sizeTopBar = 86
local sizeRightBarW = 80
local sizeRightBarMargin = 6
local sizeMainMargin = 12
local sizeMainW = scrW - sizeThrottleW - sizeThrottleMargin - sizeRightBarW - sizeRightBarMargin
local sizeMainH = scrH - sizeFooter - sizeStatus - sizeMainMargin * 3 - sizeTopBar
local sizeThrottleBarH = sizeMainH - sizeThrottleLabelsH * 2

local colorBlack = Color(0, 0, 0)
local colorMain = Color(255, 255, 255)
local colorMainDarker = Color(61, 61, 61)
local colorMainDisabled = Color(31, 31, 31)
local colorGreen = Color(165, 255, 21)
local colorYellow = Color(238, 224, 25)
local colorRed = Color(223, 28, 28)
local colorBlue = Color(27, 174, 219)

local icons = {
    "zxc765/mfdu_vo.png",
    "zxc765/mfdu_doors.png",
    "zxc765/mfdu_async.png",
    "zxc765/mfdu_hvlv.png",
    "zxc765/mfdu_pneumo.png",
    {"zxc765/mfdu_cond.png", "zxc765/mfdu_cond_l.png"},
    "zxc765/mfdu_autodrive.png",
    "zxc765/mfdu_messages.png",
    "zxc765/mfdu_maintenance.png",
    "zxc765/mfdu_pvu.png",

    "zxc765/mfdu_st_antiskid.png",
    "zxc765/mfdu_st_park.png",
    "zxc765/mfdu_st_brake.png",
    "zxc765/mfdu_st_brake_rear.png",
    "zxc765/mfdu_st_emer.png",
    "zxc765/mfdu_st_autodrive.png",
    "zxc765/mfdu_st_prost.png",
    "zxc765/mfdu_st_kos.png",
    "zxc765/mfdu_st_krr.png",
    "zxc765/mfdu_st_climb.png",
}
for idx, icoPath in ipairs(icons) do
    local paths = istable(icoPath) and icoPath or {icoPath}
    for pidx, path in ipairs(paths) do
        local ico = Material(path, "smooth")
        ico:SetInt("$flags", bit.bor(ico:GetInt("$flags"), 32768))
        paths[pidx] = ico
    end
    icons[idx] = paths
end

surface.CreateFont("Mfdu765.Throttle", {
    font = "Open Sans",
    extended = true,
    size = 24,
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

surface.CreateFont("Mfdu765.ThrottleLabel", {
    font = "Open Sans",
    extended = true,
    size = 28,
})

surface.CreateFont("Mfdu765.TopBarSmall", {
    font = "Open Sans",
    extended = true,
    size = 26,
    weight = 400,
})

surface.CreateFont("Mfdu765.TopBar", {
    font = "Open Sans",
    extended = true,
    size = 40,
    weight = 500,
})

surface.CreateFont("Mfdu765.Message", {
    font = "Open Sans",
    extended = true,
    size = 46,
    weight = 600,
})

surface.CreateFont("Mfdu765.MessageType", {
    font = "Open Sans",
    extended = true,
    size = 24,
    weight = 500,
})

surface.CreateFont("Mfdu765.Speed", {
    font = "Open Sans",
    extended = true,
    size = 120,
    weight = 500,
})

surface.CreateFont("Mfdu765.SpeedText", {
    font = "Open Sans",
    extended = true,
    size = 48,
    weight = 500,
})

surface.CreateFont("Mfdu765.SpeedTextMain", {
    font = "Open Sans",
    extended = true,
    size = 48,
    weight = 600,
})

surface.CreateFont("Mfdu765.SpeedLetter", {
    font = "Open Sans",
    extended = true,
    size = 62,
    weight = 500,
})

surface.CreateFont("Mfdu765.StatusSmall", {
    font = "Open Sans",
    extended = true,
    size = 24,
})

surface.CreateFont("Mfdu765.StatusLarge", {
    font = "Open Sans",
    extended = true,
    size = 40,
})

surface.CreateFont("Mfdu765.StatusValue", {
    font = "Open Sans",
    extended = true,
    size = 40,
    weight = 600,
})

surface.CreateFont("Mfdu765.StatusValueSpeed", {
    font = "Open Sans",
    extended = true,
    size = 64,
    weight = 600,
})

surface.CreateFont("Mfdu765.CellText", {
    font = "Open Sans",
    extended = true,
    size = 28,
})

surface.CreateFont("Mfdu765.DoorsLabels", {
    font = "Open Sans",
    extended = true,
    size = 40,
    weight = 400,
})

surface.CreateFont("Mfdu765.DoorsWagnumbers", {
    font = "Open Sans",
    extended = true,
    size = 24,
})

surface.CreateFont("Mfdu765.DoorsSide", {
    font = "Open Sans",
    extended = true,
    size = 40,
    weight = 600,
})

surface.CreateFont("Mfdu765.BodyTextLarge", {
    font = "Open Sans",
    extended = true,
    size = 48,
    weight = 500,
})

surface.CreateFont("Mfdu765.BodyTextSmall", {
    font = "Open Sans",
    extended = true,
    size = 32,
    weight = 400,
})

surface.CreateFont("Mfdu765.BodyTextSmallBold", {
    font = "Open Sans",
    extended = true,
    size = 32,
    weight = 600,
})

surface.CreateFont("Mfdu765.AsyncLabels", {
    font = "Open Sans",
    extended = true,
    size = 28,
    weight = 600,
})

surface.CreateFont("Mfdu765.MainGridLabels", {
    font = "Open Sans",
    extended = true,
    size = 36,
    weight = 700,
})

surface.CreateFont("Mfdu765.TableText", {
    font = "Open Sans",
    extended = true,
    size = 28,
    weight = 500,
})

surface.CreateFont("Mfdu765.TableTextBold", {
    font = "Open Sans",
    extended = true,
    size = 28,
    weight = 600,
})

surface.CreateFont("Mfdu765.VoLabel", {
    font = "Open Sans",
    extended = true,
    size = 32,
    weight = 500,
})

surface.CreateFont("Mfdu765.VoLabelBigger", {
    font = "Open Sans",
    extended = true,
    size = 46,
    weight = 500,
})

local function drawBox(x, y, w, h, color, bgColor, borderSize)
    surface.SetDrawColor(color)
    surface.DrawRect(x, y, w, h)
    if bgColor then surface.SetDrawColor(bgColor) else surface.SetDrawColor(0, 0, 0) end
    surface.DrawRect(x + borderSize, y + borderSize, w - borderSize * 2, h - borderSize * 2)
end

local sizeBorder = 2
local sizeButtonBorder = 4
function TRAIN_SYSTEM:DrawMain(Wag)
    self:DrawStatic()
    self:DrawTopBar(Wag, "Основной экран")
    self:DrawStatus(Wag)
    self:DrawMainPage(Wag)
end

function TRAIN_SYSTEM:DrawStatic()
    surface.SetDrawColor(0, 0, 0)
    surface.DrawRect(0, 0, scrW, scrH)

    drawBox(sizeThrottleW, scrOffsetY + sizeTopBar + sizeMainMargin, sizeMainW, sizeMainH, colorMain, nil, sizeBorder)

    local statusY = scrOffsetY + scrH - sizeFooter - sizeMainMargin - sizeStatus
    drawBox(0, statusY, scrW, sizeStatus, colorMainDarker, nil, sizeBorder)
    surface.SetDrawColor(colorMainDarker)
    surface.DrawRect(sizeStatusSide, statusY, sizeBorder, sizeStatus)
    surface.DrawRect(scrW - sizeStatusSide, statusY, sizeBorder, sizeStatus)

    drawBox(0, scrOffsetY + 0, scrW, sizeTopBar, colorMainDarker, nil, sizeBorder)

    do
        local x, y = 0, scrOffsetY + scrH - sizeFooter
        for idx = 1, 10 do
            drawBox(x, y, sizeButtonW, sizeFooter, idx == self.Page and colorBlue or colorMain, nil, sizeButtonBorder)
            x = x + sizeButtonGap + sizeButtonW
        end
    end

    do
        drawBox(sizeThrottleMeasure, scrOffsetY + sizeTopBar + sizeMainMargin + sizeThrottleLabelsH, sizeThrottleBarW, sizeThrottleBarH, colorMain, colorMainDarker, sizeBorder)
        surface.SetDrawColor(colorMain)
        local x, y = sizeThrottleMeasure - sizeThrottleMeasureLine, scrOffsetY + sizeTopBar + sizeMainMargin + sizeThrottleLabelsH
        local h = (sizeThrottleBarH - sizeBorder / 1.5) / 20
        for idx = -10, 10 do
            local label = math.abs(idx) * 10
            local even = label == 0 or label % 20 == 0
            surface.DrawRect(even and x - sizeThrottleMeasureLine or x, y, sizeThrottleMeasureLine * (even and 2 or 1), sizeBorder)
            if even then
                draw.SimpleText(tostring(label), "Mfdu765.Throttle", x - sizeThrottleMeasureLine - 3, y - 1, colorMain, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
            end
            y = y + h
        end

        draw.SimpleText("ХОД", "Mfdu765.ThrottleLabel", sizeThrottleW - 4, scrOffsetY + sizeTopBar + sizeMainMargin + sizeBorder, colorMain, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
        draw.SimpleText("ТОРМОЗ", "Mfdu765.ThrottleLabel", sizeThrottleW - 4, y + sizeBorder * 2 - h, colorMain, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
    end
end

function TRAIN_SYSTEM:DrawThrottle(throttle, x0, y0, w)
    local maxH = (sizeThrottleBarH - sizeBorder) / 2
    if throttle ~= 0 then
        local x, y = x0, y0
        local h = math.min(maxH - sizeBorder, math.abs(throttle / 100) * maxH + sizeBorder / 2)
        if throttle > 0 then
            h = math.min(maxH - sizeBorder / 2, math.abs(throttle / 100) * maxH + sizeBorder / 2)
            y = y + maxH - h + sizeBorder / 2
            surface.SetDrawColor(colorGreen)
        else
            y = y + maxH + sizeBorder
            surface.SetDrawColor(204, 204, 30)
        end
        surface.DrawRect(x, y, w, h)
    end
    surface.SetDrawColor(colorMain)
    surface.DrawRect(x0, y0 + maxH, w, sizeBorder)
end

function TRAIN_SYSTEM:DrawTopBar(Wag, title)
    local line = Wag:GetNW2String("VityazLineName", "---")
    local line1, line2
    if #line >= 28 and #string.Replace(line, "-", "") > 0 then
        local lines = string.Split(line, "-")
        if #lines > 2 then
            local splIdx = math.floor(#lines / 2)
            line1 = table.concat(lines, "-", 1, splIdx)
            line2 = table.concat(lines, "-", splIdx + 1)
        elseif #lines > 1 then
            line1, line2 = unpack(lines)
        else
            line = string.sub(line, 1, 28) .. "..."
        end
    end

    local x, y = sizeStatusSide / 2, scrOffsetY + sizeTopBar / 2
    if line1 and line2 then
        draw.SimpleText(line1, "Mfdu765.TopBarSmall", x, y - 12, colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(line2, "Mfdu765.TopBarSmall", x, y + 12, colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    else
        draw.SimpleText(line, "Mfdu765.TopBarSmall", x, y, colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    draw.SimpleText(title, "Mfdu765.TopBar", scrW / 2, y, colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    local timeStr = Wag:GetNW2String("VityazTime", "------")
    local time = string.format("%s:%s:%s", timeStr:sub(1, 2), timeStr:sub(3, 4), timeStr:sub(5, 6))
    local dateStr = Wag:GetNW2String("VityazDate")
    local date = string.format("%s.%s.%s", dateStr:sub(1, 2), dateStr:sub(3, 4), dateStr:sub(5, 8))
    draw.SimpleText(date, "Mfdu765.TopBarSmall", scrW - x, y - 12, colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText(time, "Mfdu765.TopBarSmall", scrW - x, y + 12, colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

local sizeMainLinesH = 50
local sizeMainSpeedH = 80
local sizeMainLinesGapSmall = 4
local sizeMainLinesGap = 90
local sizeSpeedMargin = 84
local posPageStartY = sizeTopBar + sizeMainMargin + sizeBorder
local posAlsModeY = posPageStartY + sizeMainLinesGap
local posMainLinesStartX = sizeThrottleW + sizeMainMargin
function TRAIN_SYSTEM:DrawMainPage()
    draw.SimpleText("Режим " .. (self.AlsArs and "2/6" or "ДАУ"), "Mfdu765.TopBar", posMainLinesStartX, posAlsModeY, colorMain, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    local x, y = posMainLinesStartX + sizeSpeedMargin, posAlsModeY + sizeMainLinesGap + sizeMainSpeedH
    draw.SimpleText(tostring(self.Speed), "Mfdu765.Speed", x + 8, y - 0.2 * sizeMainSpeedH, colorGreen, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
    draw.SimpleText("км/ч", "Mfdu765.SpeedTextMain", x + 8, y - 0.6 * sizeMainSpeedH, colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

    y = y + sizeMainLinesGapSmall + sizeMainLinesH
    draw.SimpleText("V", "Mfdu765.SpeedLetter", x, y + 10, colorRed, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
    draw.SimpleText("доп", "Mfdu765.SpeedText", x, y + 10, colorRed, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
    draw.SimpleText(tostring(self.SpeedLimit), "Mfdu765.SpeedLetter", x, y, colorRed, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

    if self.AlsArs then
        y = y + sizeMainLinesGapSmall * 2 + sizeMainLinesH * 2
        draw.SimpleText("V", "Mfdu765.SpeedLetter", x, y, colorYellow, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
        draw.SimpleText("пред", "Mfdu765.SpeedText", x, y, colorYellow, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
        draw.SimpleText(tostring(self.SpeedNext), "Mfdu765.SpeedLetter", x, y - 10, colorYellow, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    end

    self:DrawMainStatus(self.Train, sizeThrottleW + sizeMainMargin + 490, posPageStartY + 4, sizeMainW - 500, sizeMainH - 8)
end


local sizeStatusIcon = 52
local sizeMessageW = scrW - sizeStatusSide * 2 - sizeBorder * 2
local sizeMessageH = sizeStatus - sizeStatusIcon - sizeMainMargin
local sizeStatusIconsGap = (sizeMessageW - sizeStatusIcon * 10) / 9
local sizeMessageBorder = 6
local sizeStatusVoltageMargin = 32
local LegacyErrors = {
    {"Сбой КМ.", true},
    {"Сбой РВ.", true},
    {"Отс. связь с БУВ-М.", true},
    {"Вагон не ориентирован.", true},
    {"Запрет ТР от АРС.",},
    {"Экстренное торможение.", true},
    {"Стояночный тормоз прижат.", true},
    {"Дверной проем.",},
    {"Пневмотормоз вкл.", true},
    {"Напряжение КС.",},
    {"Двери не закрыты.", true},
    {"Открыта кабина ХВ.",},
    {"Включи МК и ПСН.",},
    {"Включи ПСН.",},
    {"Включи МК.",},
    {"Освещение не вкл.",},
    {"Конд. не исправен.",},
    {"Нет контроля дв.", true},
    {"Включи автомат.",},
    {"Низкое давление ТМ.", true},
}
local voltageList = {
    {"VityazLvMin", "бс min"},
    {"VityazLvMax", "бс max"},
    {"VityazHvMin", "кс min"},
    {"VityazHvMax", "кс max"},
}
local pneumoList = {
    {"VityazPNM", "нм"},
    {"VityazPTM", "тм"},
    {"VityazPMin", "тц min"},
    {"VityazPMax", "тц max"},
}
local rightBarList = {
    {"VityazARS1", "АРС1"},
    {"VityazARS2", "АРС2"},
    {"VityazBvAll", "БВ"},
    {"VityazBTB", "БТБ", true},
    {"VityazKTR", "КТР"},
    {"VityazALS", "АЛС"},
    {"VityazBOSD", "БОСД"},
}
local statusGetters = {
    -- ВО
    function(self, Wag) return Wag:GetNW2Bool("VityazVoGood", false) and colorMain or colorRed end,
    -- Двери
    function(self, Wag) return Wag:GetNW2Int("VityazDoorsAll", 0) == 1 and colorGreen or Wag:GetNW2Int("VityazDoorsAll", 0) == 2 and colorYellow or colorRed end,
    -- Тяг.привод
    function(self, Wag) return colorMain end,
    -- Напряжение
    function(self, Wag) return Wag:GetNW2Int("VityazHvAll", 0) == 1 and colorGreen or Wag:GetNW2Int("VityazHvAll", 0) == 2 and colorYellow or colorRed end,
    -- Пневматика
    function(self, Wag) return colorMain end,
    -- Кондиционер
    function(self, Wag) return Wag:GetNW2Bool("VityazCondAny", false) and (Wag:GetNW2Bool("VityazCond", false) and colorYellow or colorBlue) or colorMain end,
    -- Автоведение
    function(self, Wag) return colorMain end,
    -- Сообщения
    function(self, Wag) return colorMain end,
    -- Сервис
    function(self, Wag) return colorMain end,
    -- ПВУ
    function(self, Wag) return colorMain end,

    -- Противоюз
    function(self, Wag) return colorMainDisabled end,
    -- Ст.тормоз
    function(self, Wag) return Wag:GetNW2Bool("VityazParkEnabled", false) and colorGreen or colorMainDisabled end,
    -- Пневмотормоз
    function(self, Wag) return Wag:GetNW2Bool("VityazPtApplied", false) and colorYellow or colorMainDisabled end,
    -- Пт вкл в хв
    function(self, Wag) return Wag:GetNW2Bool("VityazPtAppliedRear", false) and colorYellow or colorMainDisabled end,
    -- Экст.т.
    function(self, Wag) return Wag:GetNW2Bool("VityazEmerActive", false) and colorRed or colorMainDisabled end,
    -- Автоведение
    function(self, Wag) return colorMainDisabled end,
    -- Пр.Ост.
    function(self, Wag)
        if not Wag:GetNW2Bool("VityazProst", false) then return colorMainDisabled end
        local metka = Wag:GetNW2Bool("VityazProstMetka", false)
        local vityazs = Wag:GetNW2Int("VityazS", -1000) / 100
        local prostact = vityazs ~= -1000 and metka and vityazs > 200
        return Wag:GetNW2Bool("VityazProstActive", false) and (CurTime() % 1 < 0.4 and colorGreen or colorMain) or prostact and colorGreen or colorMain
    end,
    -- Кос
    function(self, Wag) return not Wag:GetNW2Bool("VityazKos", false) and colorMainDisabled or Wag:GetNW2Bool("VityazProstKos", false) and Wag:GetNW2Bool("VityazProstMetka", false) and colorGreen or colorMain end,
    -- КРР
    function(self, Wag) return Wag:GetNW2Bool("VityazKRR", false) and colorYellow or colorMainDisabled end,
    -- Подъем
    function(self, Wag) return Wag:GetNW2Bool("AccelRateLamp", false) and colorGreen or colorMainDisabled end,
}
function TRAIN_SYSTEM:DrawStatus(Wag)
    self:DrawThrottle(
        Wag:GetNW2Int("VityazThrottle", 0),
        sizeThrottleMeasure + sizeBorder, scrOffsetY + sizeTopBar + sizeMainMargin + sizeThrottleLabelsH,
        sizeThrottleBarW - sizeBorder * 2
    )

    local err = Wag:GetNW2Int("VityazError", 0)
    if err > 0 and LegacyErrors[err] then
        local msg, isErr = unpack(LegacyErrors[err])
        local color = not isErr and colorYellow or colorRed
        local x, y = sizeStatusSide + sizeBorder, scrOffsetY + scrH - sizeFooter - sizeMessageH - sizeMainMargin
        drawBox(x, y, sizeMessageW, sizeMessageH, color, nil, sizeMessageBorder)
        draw.SimpleText(msg, "Mfdu765.Message", x + sizeMessageW / 2, y + sizeMessageH / 2, colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(isErr and "А" or "Б", "Mfdu765.MessageType", x + sizeMessageW - 12, y + 4, color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
    end

    local w, h = sizeStatusSide - sizeBorder * 2, sizeStatus - sizeStatusVoltageMargin - sizeBorder * 2
    if self.Page == 0 then
        for idx, v in ipairs(voltageList) do
            local x = (w / 4) * (((idx - 1) % 2) * 2 + 1) + sizeBorder
            local y = (h / 4) * (math.floor((idx - 1) / 2) * 2 + 1) + (scrOffsetY + scrH - sizeFooter - sizeMainMargin - sizeStatus)
            local k, text = unpack(v)
            local val = tostring(Wag:GetNW2Int(k, "Н/Д"))
            draw.SimpleText("U", "Mfdu765.StatusLarge", x - 26, y + 4, colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
            draw.SimpleText(text, "Mfdu765.StatusSmall", x + 14, y, colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
            draw.SimpleText(val, "Mfdu765.StatusValue", x, y - 4, colorYellow, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
            if idx > 2 then
                draw.SimpleText("В", "Mfdu765.StatusSmall", x, y + 58, colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
            end
        end
    else
        local x = 1 * w / 6 + sizeBorder
        local y = scrOffsetY + scrH - sizeFooter - sizeBorder - 64
        draw.SimpleText("V", "Mfdu765.StatusLarge", x - 12, y + 10, colorRed, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
        draw.SimpleText("доп", "Mfdu765.StatusSmall", x + 10, y + 8, colorRed, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
        draw.SimpleText(self.SpeedLimit, "Mfdu765.StatusValueSpeed", x, y - 4, colorRed, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

        x = 5 * w / 6 + sizeBorder
        draw.SimpleText("V", "Mfdu765.StatusLarge", x - 18, y + 10, colorYellow, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
        draw.SimpleText("пред", "Mfdu765.StatusSmall", x + 10, y + 8, colorYellow, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
        draw.SimpleText(self.SpeedNext, "Mfdu765.StatusValueSpeed", x, y - 4, colorYellow, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

        x = 1 * w / 2 + sizeBorder
        y = scrOffsetY + scrH - sizeFooter - sizeBorder - 32
        draw.SimpleText(self.Speed, "Mfdu765.StatusValueSpeed", x, y - 4, colorGreen, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
        draw.SimpleText("км/ч", "Mfdu765.StatusSmall", x, y - 8, colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

        x = w / 2
        y = scrOffsetY + scrH - sizeFooter - sizeBorder - sizeStatus * 0.75
        draw.SimpleText("Режим " .. (self.AlsArs and "2/6" or "ДАУ"), "Mfdu765.StatusSmall", x, y, colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    for idx, v in ipairs(pneumoList) do
        local x = (w / 4) * (((idx - 1) % 2) * 2 + 1) + scrW + sizeBorder - sizeStatusSide
        local y = (h / 4) * (math.floor((idx - 1) / 2) * 2 + 1) + (scrOffsetY + scrH - sizeFooter - sizeMainMargin - sizeStatus)
        local k, text = unpack(v)
        local val = Wag:GetNW2Int(k, "Н/Д")
        val = isnumber(val) and val / 10 or val
        draw.SimpleText("P", "Mfdu765.StatusLarge", x - (idx > 2 and 24 or 16), y + 4, colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
        draw.SimpleText(text, "Mfdu765.StatusSmall", x + (idx > 2 and 14 or 8), y, colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
        draw.SimpleText(not isnumber(val) and val or isnumber(val) and val > 0 and string.format("%.1f", val) or "0", "Mfdu765.StatusValue", x, y - 4, colorBlue, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        if idx > 2 then
            draw.SimpleText("Атм", "Mfdu765.StatusSmall", x, y + 58, colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
        end
    end

    h = (sizeMainH - sizeBorder * 6) / 7
    for idx, v in ipairs(rightBarList) do
        local k, text, isBool = unpack(v)
        local x = scrW - sizeRightBarW
        local y = (idx - 1) * (h + sizeBorder) + scrOffsetY + sizeTopBar + sizeMainMargin
        local val = not isBool and Wag:GetNW2Int(k, -1) or Wag:GetNW2Bool(k, false) and 0 or 1
        local color = val == 2 and colorYellow or val == 1 and colorGreen or val == 0 and colorRed or colorMainDarker
        local textColor = color == colorMainDarker and colorMain or colorBlack
        drawBox(x, y, sizeRightBarW, h, colorMain, color, sizeBorder)
        draw.SimpleText(text, "Mfdu765.ThrottleLabel", x + sizeRightBarW / 2, y + h / 2 - 1, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    for idx, icon in ipairs(icons) do
        if idx > 10 then break end
        local x, y = (idx - 1) * (sizeButtonW + sizeButtonGap), scrOffsetY + scrH - sizeFooter
        local getter = statusGetters[idx]
        icon = idx == 6 and icon[Wag:GetNW2Bool("VityazCond", false) and 2 or 1] or icon[1]
        surface.SetDrawColor(getter and getter(self, Wag) or colorMainDisabled)
        surface.SetMaterial(icon)
        surface.DrawTexturedRect(x + sizeButtonBorder, y + sizeButtonBorder, sizeButtonW - sizeButtonBorder * 2, sizeFooter - sizeButtonBorder * 2)
    end

    for idx, icon in ipairs(icons) do
        if idx <= 10 then continue end
        local x, y = sizeStatusSide + sizeBorder + (idx - 11) * (sizeStatusIcon + sizeStatusIconsGap), scrOffsetY + scrH - sizeFooter - sizeStatus - sizeMainMargin + sizeBorder * 2
        local getter = statusGetters[idx]
        surface.SetDrawColor(getter and getter(self, Wag) or colorMainDisabled)
        surface.SetMaterial(icon[1])
        surface.DrawTexturedRect(x, y, sizeStatusIcon, sizeStatusIcon)
    end
end

local sizeCellBorderRadius = 8
function TRAIN_SYSTEM:DrawGrid(x, y, w, h, vertical, cellGap, labels, labelFont, wagNumbers, wagNumbersFont, leftOffset, topOffset, getter, drawRow)
    if not isfunction(getter) then return end
    if not istable(wagNumbers) then
        local ind = not wagNumbers
        wagNumbers = {}
        for idx = 1, self.Train:GetNW2Int("VityazWagNum", 0) do
            table.insert(wagNumbers, tostring(ind and idx or self.Train:GetNW2Int("VityazWagNum" .. idx, "?????")))
        end
    end

    local cellMarginX, cellMarginY = 0, 0
    if istable(cellGap) then
        cellMarginX = cellGap[2] or cellMarginX
        cellMarginY = cellGap[3] or cellMarginY
        cellGap = cellGap[1]
    end

    local colCount = vertical and 8 or #labels
    local rowCount = vertical and #labels or 8
    local cellW = (w - cellGap * (colCount - 1)) / colCount
    local cellH = (h - cellGap * (rowCount - 1)) / rowCount
    local x0 = x
    for row = 1, rowCount do
        if vertical then rowLabel = labels[row] else rowLabel = wagNumbers[row] end
        if not rowLabel then return end
        local drawCurRow = not isfunction(drawRow) or drawRow(row)
        if drawCurRow and #rowLabel > 0 then
            draw.SimpleText(
                tostring(rowLabel),
                vertical and labelFont or wagNumbersFont, x - leftOffset, y + cellH / 2,
                colorMain, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER
            )
        end
        for col = 1, colCount do
            local colLabel
            if vertical then colLabel = wagNumbers[col] else colLabel = labels[col] end
            if not colLabel then break end
            if row == 1 and #colLabel > 0 then
                draw.SimpleText(
                    tostring(colLabel),
                    vertical and wagNumbersFont or labelFont, x + cellW / 2, y - topOffset,
                    colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM
                )
            end

            if drawCurRow then
                local wagIdx = vertical and col or row
                local color, text, textColor, textFont = getter(wagIdx, vertical and row or col)
                if color then
                    draw.RoundedBox(sizeCellBorderRadius, x + cellMarginX, y + cellMarginY, cellW - cellMarginX * 2, cellH - cellMarginY * 2, color)
                end
                if text then
                    draw.SimpleText(text, textFont or "Mfdu765.CellText", x + cellW / 2, y + cellH / 2, textColor or colorBlack, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end
            end

            x = x + cellW + cellGap
        end

        y = y + cellH + cellGap
        x = x0
    end
end

function TRAIN_SYSTEM:DrawPage(func, title, ...)
    self:DrawStatic()
    self:DrawTopBar(self.Train, title)
    self:DrawStatus(self.Train)
    func(self, self.Train, sizeThrottleW + sizeBorder, scrOffsetY + sizeTopBar + sizeMainMargin + sizeBorder, sizeMainW - sizeBorder * 2, sizeMainH - sizeBorder * 2, ...)
end

local posDoorsGridX = 68
local posDoorsGridY = 190
local sizeDoorBlock = 42
local doorsLabels = {"M", "1", "2", "3", "4", "T", "5", "6", "7", "8", "M"}
function TRAIN_SYSTEM:DrawDoorsPage(Wag, x, y, w, h)
    local gx, gy = x + posDoorsGridX, y + posDoorsGridY
    local gw, gh = w - posDoorsGridX - sizeMainMargin, h - posDoorsGridY - sizeMainMargin
    self:DrawGrid(
        gx, gy, gw, gh, false, sizeMainMargin * 0.75,
        doorsLabels, "Mfdu765.DoorsLabels",
        true, "Mfdu765.DoorsWagnumbers",
        sizeMainMargin, sizeMainMargin / 2,
        function(wagIdx, doorIdx)
            local color
            local isHead = Wag:GetNW2Bool("VityazHasCabin" .. wagIdx, false)
            local buvDisabled = not Wag:GetNW2Bool("VityazBUVState" .. wagIdx, false)
            local pvu = not buvDisabled and Wag:GetNW2Bool("VityazPVU" .. wagIdx .. "2", false)
            local addr = false
            if doorIdx == 1 then
                color = isHead and Wag:GetNW2Bool("VityazDoorML" .. wagIdx, false) and colorGreen or isHead and colorRed or nil
                pvu = false
            elseif doorIdx == 11 then
                color = isHead and Wag:GetNW2Bool("VityazDoorMR" .. wagIdx, false) and colorGreen or isHead and colorRed or nil
                pvu = false
            elseif doorIdx == 6 then
                color = isHead and Wag:GetNW2Bool("VityazDoorT" .. wagIdx, false) and colorGreen or isHead and colorRed or nil
                pvu = false
            else
                local left = doorIdx < 6
                local door = string.format("%d%s%d", left and doorIdx - 1 or 11 - doorIdx, left and "L" or "R", wagIdx)
                addr = Wag:GetNW2Bool("VityazAddressDoors" .. (left and "L" or "R") .. wagIdx, false)
                color = not buvDisabled and Wag:GetNW2Bool("VityazDoor" .. door, false) and colorGreen or Wag:GetNW2Bool("VityazDoorReverse" .. door, false) and colorYellow or colorRed
            end
            return color, color and (buvDisabled and "X" or pvu and "Р" or addr and "И" or nil)
        end
    )
    local sideTextPos = y + posDoorsGridY / 2
    local leftTextPos = gx + 1.00 * gw / 4 - sizeDoorBlock / 2
    local rightTextPos = gx + 3 * gw / 4 - sizeDoorBlock / 2 - 28
    local blLeftPos = surface.GetTextSize("Левые") / 2 + leftTextPos + 32
    local blRightPos = surface.GetTextSize("Правые") / 2 + rightTextPos + 32
    draw.SimpleText("Левые", "Mfdu765.DoorsSide", leftTextPos, sideTextPos, colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText("Правые", "Mfdu765.DoorsSide", rightTextPos, sideTextPos, colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.RoundedBox(sizeCellBorderRadius, blLeftPos, sideTextPos - sizeDoorBlock / 2, sizeDoorBlock, sizeDoorBlock, Wag:GetNW2Bool("VityazDoorBlockL", false) and colorGreen or colorRed)
    draw.RoundedBox(sizeCellBorderRadius, blRightPos, sideTextPos - sizeDoorBlock / 2, sizeDoorBlock, sizeDoorBlock, Wag:GetNW2Bool("VityazDoorBlockR", false) and colorGreen or colorRed)
    draw.SimpleText("Б", "Mfdu765.CellText", blLeftPos + sizeDoorBlock / 2, sideTextPos, colorBlack, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText("Б", "Mfdu765.CellText", blRightPos + sizeDoorBlock / 2, sideTextPos, colorBlack, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

local asyncLabels = {
    "СБОР СХЕМЫ", "БВ", "Отказ ИНВ", "Защита ИНВ", "Перегрев ИНВ", "Отказ ЭТ", "Неиспр. ВТР"
}
local asyncStates = {
    "VityazScheme", "VityazBV"
}
function TRAIN_SYSTEM:DrawAsyncPage(Wag, x, y, w, h)
    local gw, gh = w * 0.35 - sizeBorder * 2, h - 64 - sizeBorder * 6
    local gx, gy = x + w - gw - sizeBorder * 6, y + 64
    self:DrawGrid(
        gx, gy, gw, gh, true, sizeMainMargin * 0.75,
        asyncLabels, "Mfdu765.AsyncLabels",
        false, "Mfdu765.AsyncLabels",
        sizeMainMargin, sizeMainMargin / 2,
        function(wagIdx, idx)
            if not Wag:GetNW2Bool("VityazAsyncInverter" .. wagIdx, false) then return end
            local k = asyncStates[idx]
            local text = nil
            if idx == 2 then
                if not Wag:GetNW2Bool("VityazBattery" .. wagIdx, false) or not Wag:GetNW2Bool("VityazBUVState" .. wagIdx, false) or not Wag:GetNW2Bool("VityazSF" .. wagIdx .. "52", false) then
                    text = "X"
                elseif Wag:GetNW2Bool("VityazPVU" .. wagIdx .. "1", false) then
                    text = "Р"
                end
            end
            return (not k or Wag:GetNW2Bool(k .. wagIdx, false)) and colorGreen or colorRed, text
        end
    )

    local barW = sizeThrottleBarW * 0.9
    local xb, yb = x + sizeThrottleMargin, scrOffsetY + sizeTopBar + sizeMainMargin + sizeThrottleLabelsH
    for idx = 1, Wag:GetNW2Int("VityazWagNum", 0) do
        drawBox(xb, yb, barW, sizeThrottleBarH, colorMain, colorMainDarker, sizeBorder)
        local thr = - Wag:GetNW2Int("VityazDriveStrength" .. idx, 0)
        if thr == 0 then
            thr = Wag:GetNW2Int("VityazBrakeStrength" .. idx, 0)
        end
        self:DrawThrottle(math.Clamp(thr * 100 / 15, -100, 100), xb, yb, barW)

        local color = not Wag:GetNW2Bool("VityazAsyncInverter" .. idx, false) and colorMainDarker or Wag:GetNW2Bool("VityazHVGood" .. idx, false) and colorGreen or colorRed
        draw.RoundedBox(
            sizeCellBorderRadius, xb + sizeBorder, yb + sizeThrottleBarH + sizeBorder,
            barW - sizeBorder * 2, barW - sizeBorder, color
        )
        local textColor = color == colorMainDarker and colorMain or colorBlack
        draw.SimpleText(tostring(idx), "Mfdu765.ThrottleLabel", xb + barW / 2, yb + sizeThrottleBarH + sizeBorder + barW / 2 - 1, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        xb = xb + barW + sizeBorder
    end

    surface.SetDrawColor(colorMain)
    xb, yb = xb - sizeBorder, yb
    local mh = (sizeThrottleBarH - sizeBorder / 1.5) / 20
    for idx = -10, 10 do
        local label = math.abs(idx) * 10
        local even = label == 0 or label % 20 == 0
        surface.DrawRect(xb, yb, sizeThrottleMeasureLine * (even and 2 or 1), sizeBorder)
        if even then
            draw.SimpleText(tostring(label), "Mfdu765.Throttle", xb + sizeThrottleMeasureLine * 2 + 3, yb - 1, colorMain, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
        yb = yb + mh
    end
end

local sizeBoxMarginX = 8
local sizeBoxMarginY = 4
function TRAIN_SYSTEM:DrawTable(x, y, w, h, rows, cols, colLengths, getter, boxMarginX, boxMarginY)
    if not isfunction(getter) then return end
    local colLen = w - (cols - 1) * sizeBorder
    local fixedCols = 0
    for k, v in pairs(colLengths) do
        colLen = colLen - v
        fixedCols = fixedCols + 1
    end
    colLen = colLen / (cols - fixedCols)
    boxMarginX = boxMarginX or sizeBoxMarginX
    boxMarginY = boxMarginY or sizeBoxMarginY

    local rowTall = h / rows
    local x0 = x
    for row = 1, rows do
        surface.SetDrawColor(row % 2 == 0 and colorMainDarker or colorBlack)
        surface.DrawRect(x, y, w, rowTall)
        for col = 1, cols do
            local cw = colLengths[col] or colLen
            local val, color, boxColor, font = getter(row, col)
            color = color or (not boxColor or boxColor == colorMainDisabled or boxColor == colorMainDarker) and colorMain or colorBlack
            if boxColor then
                draw.RoundedBox(sizeCellBorderRadius, x + boxMarginX, y + boxMarginY, cw - boxMarginX * 2, rowTall - boxMarginY * 2, boxColor)
            end
            if val then
                draw.SimpleText(tostring(val), font or "Mfdu765.TableText", x + cw / 2, y + rowTall / 2, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
            if row % 2 ~= 0 and col < cols then
                surface.SetDrawColor(colorMainDarker)
                surface.DrawRect(x + cw, y, sizeBorder, rowTall)
            end
            x = x + cw + sizeBorder
        end
        y = y + rowTall
        x = x0
    end
end

local elRowIndex = {"Параметр", "Uкс, В", "Uбс, В", "Uзу, В", "Ⅰмк, А", "Ⅰтп, А", "Ⅰзу, А", "Ⅰво, А", "Pп, кВт/ч", "Pр, кВт/ч", "Pоб, кВт/ч"}
local elRowLen = {[1] = 108}
function TRAIN_SYSTEM:DrawElectric(Wag, x, y, w, h)
    self:DrawTable(x, y, w, h - sizeMainMargin, #elRowIndex, 9, elRowLen, function(row, col)
        if col == 1 then
            return elRowIndex[row]
        else
            local idx = (col - 1)
            if idx > Wag:GetNW2Int("VityazWagNum", 0) then return end
            local async = Wag:GetNW2Bool("VityazAsyncInverter" .. idx, false)
            if row == 1 then
                return Wag:GetNW2Int("VityazWagNum" .. idx, "?????")
            -- pizdec
            elseif row == 2 then
                local val = Wag:GetNW2Int("VityazU" .. idx, 0) / 10
                if not async then
                    return nil, nil, val >= 550 and colorGreen or colorRed
                else
                    return val, val >= 550 and colorGreen or colorRed
                end
            elseif row == 3 then
                local val = Wag:GetNW2Int("VityazUBS" .. idx, 0) / 10
                return val, val >= 62 and colorGreen or colorRed
            elseif row == 4 then
                local hv = Wag:GetNW2Int("VityazU" .. idx, 0) / 10
                local val = Lerp(math.Clamp((hv - 550) / (720 - 550), 0, 1), 0, Wag:GetNW2Int("VityazUBS" .. idx, 0) / 10) or 0
                return math.Round(val), val >= 62 and colorGreen or colorRed
            elseif row == 5 then
                if not async then return end
                local val = Wag:GetNW2Int("VityazIMK" .. idx, 0) / 10
                return val, colorGreen
            elseif row == 6 then
                if not async then return end
                local val = Wag:GetNW2Int("VityazI" .. idx, 0) / 10
                return val, colorGreen
            elseif row == 7 then
                return 0, colorGreen
            elseif row == 8 then
                local val = Wag:GetNW2Int("VityazIVO" .. idx, 0) / 10
                return val, colorGreen
            elseif row == 9 then
                return Wag:GetNW2Int("VityazPower" .. idx, 0), colorGreen
            elseif row == 10 then
                return Wag:GetNW2Int("VityazDissipated" .. idx, 0), colorGreen
            elseif row == 11 then
                return Wag:GetNW2Int("VityazPower" .. idx, 0) - Wag:GetNW2Int("VityazDissipated" .. idx, 0), colorGreen
            end
        end
    end)
end


local pnRowIndex = {
    "Параметр", "Экстрен. тормоз", "ПТ вкл.", "Ст. тормоз", "ДПБТ", "Скач. камера", "Торм. оборуд.",
    "Pтц1, Атм", "Pтц2, Атм", "Pнм, Атм", "Pтм, Атм", "Pст, Атм", "Pск, Атм", "Pавто1, Атм", "Pавто2, Атм", "Pавто3, Атм", "Pавто4, Атм"
}
local pnRowLen = {[1] = 200}
function TRAIN_SYSTEM:DrawPneumatic(Wag, x, y, w, h)
    self:DrawTable(x, y, w, h - sizeMainMargin, #pnRowIndex, 9, pnRowLen, function(row, col)
        if col == 1 then
            return pnRowIndex[row]
        else
            local idx = (col - 1)
            if idx > Wag:GetNW2Int("VityazWagNum", 0) then return end
            if row == 1 then
                return Wag:GetNW2Int("VityazWagNum" .. idx, "?????")
            -- YandereDev, ty cho?
            elseif row == 2 then
                local val = Wag:GetNW2Bool("VityazEmerActive" .. idx, false)
                return nil, nil, val and colorGreen or colorRed
            elseif row == 3 then
                local val = Wag:GetNW2Bool("VityazPTApply" .. idx, false)
                return nil, nil, val and colorGreen or colorRed
            elseif row == 4 then
                local val = Wag:GetNW2Bool("VityazPBApply" .. idx, false)
                return nil, nil, val and colorGreen or colorRed
            elseif row == 5 then
                local val = Wag:GetNW2Bool("VityazDPBT" .. idx, false)
                return nil, nil, val and colorGreen or colorRed
            elseif row == 6 then
                local val = Wag:GetNW2Int("VityazPskk" .. idx, 0) >= 10
                return nil, nil, val and colorGreen or colorRed
            elseif row == 7 then
                local val = Wag:GetNW2Bool("VityazBrakeEquip" .. idx, false)
                return nil, nil, val and colorGreen or colorRed
            elseif row == 8 then
                local val = Wag:GetNW2Int("VityazP" .. idx, 0) / 10
                return val > 0 and string.format("%.1f", val) or "0", colorGreen
            elseif row == 9 then
                local val = Wag:GetNW2Int("VityazP2" .. idx, 0) / 10
                return val > 0 and string.format("%.1f", val) or "0", colorGreen
            elseif row == 10 then
                local val = Wag:GetNW2Int("VityazPnm" .. idx, 0) / 10
                return val > 0 and string.format("%.1f", val) or "0", val >= 5.5 and colorGreen or colorRed
            elseif row == 11 then
                local val = Wag:GetNW2Int("VityazPtm" .. idx, 0) / 10
                return val > 0 and string.format("%.1f", val) or "0", val >= 2.9 and colorGreen or colorRed
            elseif row == 12 then
                local val = Wag:GetNW2Int("VityazPstt" .. idx, 0) / 10
                return val > 0 and string.format("%.1f", val) or "0", colorGreen
            elseif row == 13 then
                local val = Wag:GetNW2Int("VityazPskk" .. idx, 0) / 10
                return val > 0 and string.format("%.1f", val) or "0", colorGreen
            elseif row == 14 then
                local val = Wag:GetNW2Int("VityazPauto1" .. idx, 0) / 10
                return val > 0 and string.format("%.1f", val) or "0", val >= 1.0 and colorGreen or colorRed
            elseif row == 15 then
                local val = Wag:GetNW2Int("VityazPauto2" .. idx, 0) / 10
                return val > 0 and string.format("%.1f", val) or "0", val >= 1.0 and colorGreen or colorRed
            elseif row == 16 then
                local val = Wag:GetNW2Int("VityazPauto3" .. idx, 0) / 10
                return val > 0 and string.format("%.1f", val) or "0", val >= 1.0 and colorGreen or colorRed
            elseif row == 17 then
                local val = Wag:GetNW2Int("VityazPauto4" .. idx, 0) / 10
                return val > 0 and string.format("%.1f", val) or "0", val >= 1.0 and colorGreen or colorRed
            end
        end
    end, 26, 1)
end


local sizeVoIndexW, sizeVoIndexH = 220, 48
local sizeVoCellMargin = 16
local voFields = {
    {
        {"БУКСЫ", "VityazBuksGood"},
        {"МК", function(Wag, idx) return not Wag:GetNW2Bool("VityazAsyncInverter" .. idx, false) and -2 or Wag:GetNW2Int("VityazMKState" .. idx, -1) end, function(val) return val > 0 and colorGreen or val > -2 and (val < 0 and colorRed or colorMainDisabled) or nil end},
        {"Освещение", "VityazLightsWork"},
        {"ТКПР", "VityazPantDisabled"},
        {"Напряжение КС", "VityazHVGood"},
        {"ПСН", "VityazPSNEnabled"},
        {"Рессора", "VityazRessoraGood"},
        {"БУПУ", "VityazPUGood"},
        {"БУД", "VityazBUDWork"},
        {"Ориентация", "VityazWagOr", function(val) return nil, val and "О" or "П", val and colorYellow or colorGreen end},
    }, {
        {"", function() return true end},
        {"", function() return true end},
        {"", function() return true end},
        {"", function() return true end},
        {"", function() return true end, function() return nil end},
        {"", function() return true end, function() return nil end},
        {"", function() return true end, function() return nil end},
        {"", function() return true end, function() return nil end},
    }, {
        {"", "VityazDPBT1"},
        {"", "VityazDPBT2"},
        {"", "VityazDPBT3"},
        {"", "VityazDPBT4"},
        {"", "VityazDPBT5"},
        {"", "VityazDPBT6"},
        {"", "VityazDPBT7"},
        {"", "VityazDPBT8"},
    }, {
        {"", "VityazPant1"},
        {"", "VityazPant2"},
        {"", "VityazPant3"},
        {"", "VityazPant4"},
        {"", function() return true end, function() return nil end},
        {"", function() return true end, function() return nil end},
        {"", function() return true end, function() return nil end},
        {"", function() return true end, function() return nil end},
    }, {
        {"", function() return true end},
        {"", function() return true end},
        {"", function() return true end},
        {"", function() return true end},
        {"", function() return true end},
        {"", function() return true end},
        {"", function() return true end},
        {"", function() return true end},
    }
}
local voLabels = {}
for idx, fields in ipairs(voFields) do voLabels[idx] = {} for fIdx, field in ipairs(fields) do voLabels[idx][fIdx] = field[1] end end
local voDefaultValGetter = function(Wag, idx, k) return Wag:GetNW2Bool(k .. idx, false) end
local voDefaultGetter = function(val) return val and colorGreen or colorRed end
function TRAIN_SYSTEM:DrawVoPage(Wag, x, y, w, h)
    local voPage = self.SubPage
    if voPage == 1 then
        draw.SimpleText("Параметр", "Mfdu765.VoLabel", x + sizeVoIndexW / 2, y + sizeVoIndexH - sizeVoCellMargin / 2, colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
    end

    local indexW = voPage > 1 and 0 or sizeVoIndexW
    local gx, gy, gw, gh = x + indexW, y + sizeVoIndexH, w - indexW, h - sizeVoIndexH - 4
    self:DrawGrid(
        gx, gy, gw, gh, true, {2, sizeVoCellMargin},
        voLabels[voPage] or {}, "Mfdu765.VoLabel",
        true, "Mfdu765.VoLabel",
        0, sizeVoCellMargin / 2,
        function(idx, field)
            local fieldData = voFields[voPage] and voFields[voPage][field]
            local _, valGetter, getter = unpack(fieldData or {})
            if valGetter then
                local k = isstring(valGetter) and valGetter or nil
                valGetter = isfunction(valGetter) and valGetter or voDefaultValGetter
                local val = valGetter(Wag, idx, k)
                getter = getter or voDefaultGetter
                local bColor, text, textColor = getter(val)
                return bColor, text or voPage > 1 and tostring(field) or nil, textColor, "Mfdu765.VoLabelBigger"
            end
        end
    )
end

local condLabels = { "Кондиционер 1", "Кондиционер 2", "Кондиционер К" }
function TRAIN_SYSTEM:DrawCondPage(Wag, x, y, w, h)
    local voPage = self.SubPage
    if voPage == 1 then
        draw.SimpleText("Параметр", "Mfdu765.VoLabel", x + sizeVoIndexW / 2, y + sizeVoIndexH - sizeVoCellMargin / 2, colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
    end

    local indexW = voPage > 1 and 0 or sizeVoIndexW
    local gx, gy, gw, gh = x + indexW, y + sizeVoIndexH, w - indexW, 110
    self:DrawGrid(
        gx, gy, gw, gh, true, {2, sizeVoCellMargin},
        condLabels, "Mfdu765.VoLabel",
        true, "Mfdu765.VoLabel",
        0, sizeVoCellMargin / 2,
        function(idx, field)
            if field == 3 then
                return Wag:GetNW2Bool("VityazHasCabin" .. idx, false) and (Wag:GetNW2Bool("VityazCondK" .. idx, false) and colorGreen or colorRed) or nil
            end
            return Wag:GetNW2Bool("VityazCond" .. field .. idx, false) and colorGreen or colorRed
        end
    )

    draw.SimpleText("Температура", "Mfdu765.BodyTextLarge", x + w / 2, gy + gh + 16, colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    local cw = w / 3
    draw.SimpleText("Кабина:", "Mfdu765.BodyTextSmall", x + cw / 2, gy + gh + 128, colorMain, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    draw.SimpleText("20.0 ℃", "Mfdu765.BodyTextSmallBold", x + cw / 2 + 100, gy + gh + 128, colorMain, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    draw.SimpleText("Салон:", "Mfdu765.BodyTextSmall", x + cw + cw / 2 - 46, gy + gh + 128, colorMain, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    draw.SimpleText("max 20.0 ℃", "Mfdu765.BodyTextSmallBold", x + cw + cw / 2 + 114, gy + gh + 110, colorMain, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    draw.SimpleText("min 20.0 ℃", "Mfdu765.BodyTextSmallBold", x + cw + cw / 2 + 114, gy + gh + 146, colorMain, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    draw.SimpleText("Внешняя:", "Mfdu765.BodyTextSmall", x + cw * 2 + cw / 2, gy + gh + 128, colorMain, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    draw.SimpleText("18.5 ℃", "Mfdu765.BodyTextSmallBold", x + cw * 2 + cw / 2 + 100, gy + gh + 128, colorMain, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

    draw.SimpleText("Режим: " .. (Wag:GetNW2Bool("VityazCond", false) and "Лето" or "Зима"), "Mfdu765.BodyTextLarge", x + w / 2 - sizeButtonW / 2, gy + gh + 212, colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    surface.SetDrawColor(Wag:GetNW2Bool("VityazCondAny", false) and (Wag:GetNW2Bool("VityazCond", false) and colorYellow or colorBlue) or colorMain)
    surface.SetMaterial(icons[6][Wag:GetNW2Bool("VityazCond", false) and 2 or 1])
    local icw, ich = sizeButtonW * 0.7, sizeFooter * 0.7
    surface.DrawTexturedRect(x + w / 2 + 70, gy + gh + 218 - ich / 2, icw, ich)

    draw.SimpleText("Загрузка: " .. (Wag:GetNW2Bool("VityazCondAny", false) and "33 %" or "0 %"), "Mfdu765.BodyTextSmall", x + 4, gy + gh + 290, colorMain, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

local mainGridLabels = {
    "Двери", "БВ", "Сбор схемы", "ПТ включен", "Ст. тормоз", "БУВ", "БТБ гот."
}
local mainGridData = {
    {"VityazDoors", "VityazShowDoors"},
    {"VityazBV", "VityazShowBV"},
    {"VityazScheme", "VityazShowScheme"},
    {"VityazPTApply", "VityazShowPTApply"},
    {"VityazPBApply", "VityazShowPBApply"},
    {"VityazBUVState", "VityazShowBUVState"},
    {"VityazBTBReady", "VityazShowBTBReady"},
}
local noAsync = { ["VityazBV"] = true, ["VityazScheme"] = true }
local mainGridDraw = {}
function TRAIN_SYSTEM:DrawMainStatus(Wag, x, y, w, h)
    local gx, gy, gw, gh = x - 10, y + 64, w, h - 64
    local drawGrid = false
    for idx, d in ipairs(mainGridData) do
        mainGridDraw[idx] = Wag:GetNW2Bool(mainGridData[idx][2], false)
        if mainGridDraw[idx] then drawGrid = true end
    end
    if not drawGrid then return end
    self:DrawGrid(
        gx, gy, gw, gh, true, sizeMainMargin * 0.75,
        mainGridLabels, "Mfdu765.MainGridLabels",
        false, "Mfdu765.MainGridLabels",
        sizeMainMargin, sizeMainMargin / 2,
        function(idx, field)
            return not (not Wag:GetNW2Bool("VityazAsyncInverter" .. idx, false) and noAsync[mainGridData[field][1]]) and (Wag:GetNW2Bool(mainGridData[field][1] .. idx, false) and colorGreen or colorRed) or nil
        end,
        function(field)
            return mainGridDraw[field]
        end
    )
end
