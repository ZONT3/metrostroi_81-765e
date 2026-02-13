--------------------------------------------------------------------------------
-- UI МФДУ САУ Скиф-М 81-765
-- Автор - ZONT_ a.k.a. enabled person
--------------------------------------------------------------------------------
if SERVER then
    AddCSLuaFile()
    return
end

local MainMsg = {
    "РВ Выключены",
    "Хвостовая кабина",
    "Включены 2 РВ",
    "Сбой РВ"
}

function TRAIN_SYSTEM:SkifMonitor()
    local mainMsg = self.Train:GetNW2Int("Skif:MainMsg", 0)
    local rv = self.Train:GetNW2Int("Skif:RV", 0)
    if self.MainMsg and self.MainMsg > 0 and mainMsg == 0 then
        if not self.ClientInitTimer then
            self.ClientInitTimer = CurTime() + math.Rand(0.3, 1.4)
        elseif CurTime() > self.ClientInitTimer then
            self.MainMsg = 0
        end
    elseif self.ClientInitTimer then
        self.ClientInitTimer = nil
        self.MainMsg = mainMsg
    else
        self.MainMsg = mainMsg
    end

    self.NormalWork = self.MainMsg == 0 and self.State == 5
    if self.NormalWork then
        local Wag = self.Train

        self.AlsArs = Wag:GetNW2Bool("Skif:AlsArs")
        self.UOS = Wag:GetNW2Bool("Skif:Uos", false)
        self.FreqMode = self.UOS and "УОС" or self.AlsArs and "2/6" or "ДАУ"
        self.SpeedNext = Wag:GetNW2Bool("Skif:NextNoFreq", false) and "ОЧ" or Wag:GetNW2Int("Skif:NextSpeedLimit", 0)
        self.SpeedLimit = Wag:GetNW2Bool("Skif:Sao", false) and "АО" or Wag:GetNW2Bool("Skif:NoFreq", false) and "ОЧ" or Wag:GetNW2Int("Skif:SpeedLimit", 0)
        self.Speed = Wag:GetNW2Int("Skif:Speed", 0)

        self.Page = 0
        self.SubPage = 1
        if not self.MainScreen then
            local page = math.floor(self.State2 / 10)
            if page == 1 then
                self.Page = 1
                self.SubPage = self.State2 % 10
                local title = "Вагонное оборудование"
                if self.SubPage > 8 then self.SubPage = 1 end
                if self.SubPage == 2 then title = "УККЗ"
                elseif self.SubPage == 3 then title = "ДПБТ"
                elseif self.SubPage == 4 then title = "Токоприемники"
                elseif self.SubPage == 5 then title = "Буксы"
                elseif self.SubPage == 6 then title = "Автоматы 1"
                elseif self.SubPage == 7 then title = "Автоматы 2"
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
            elseif page == 7 then
                self.Page = 7
                self:DrawPage(self.DrawAutodrive, "Автоведение")
            elseif page == 8 then
                self.Page = 8
                self:DrawPage(self.DrawMessages, "Журнал")
            elseif page == 0 then
                self.Page = 10
                self:DrawPage(self.DrawPvu, "Повагонное управление")
            end
        end

        if self.Page == 0 then
            self:DrawMain(self.Train)
        end

    elseif self.MainMsg > 0 or self.State >= 1 and self.State < 5 and rv == 0 then
        local msg = MainMsg[self.MainMsg > 0 and self.MainMsg or 1]
        if self.MainMsg > 2 then
            self:DrawErr(msg)
        else
            self:DrawIdle(msg, false, self.MainMsg == 2)
        end

    elseif rv ~= 0 then
        if self.State == 1 then
            self:DrawIdle("Идентификация", true)
        elseif self.State == 2 then
            self:DrawDepot()
        else
            self:DrawIdent()
        end
    end
end

local scrW, scrH = 1024, 768
local scrOffsetX, scrOffsetY = 0, 0

local sizeFooter = 72
local sizeStatus = 150
local sizeButtonGap = 4
local sizeButtonW = (scrW - sizeButtonGap * 9) / 10
local sizeStatusSide = sizeButtonW * 2 + sizeButtonGap * 2
local sizeThrottleMeasure = 54
local sizeThrottleMeasureLine = 10
local sizeThrottleMargin = 4
local sizeThrottleLabelsH = 36
local sizeThrottleW = sizeButtonW - sizeButtonGap
local sizeThrottleBarW = sizeThrottleW - sizeThrottleMeasure - sizeThrottleMargin
local sizeTopBar = 72
local sizeRightBarW = 80
local sizeRightBarMargin = 6
local sizeMainMargin = 12
local sizeMainW = scrW - sizeThrottleW - sizeThrottleMargin - sizeRightBarW - sizeRightBarMargin
local sizeMainH = scrH - sizeFooter - sizeStatus - sizeMainMargin * 3 - sizeTopBar
local sizeThrottleBarH = sizeMainH - sizeThrottleLabelsH * 2

local colorBlack = Color(0, 0, 0)
local colorBrightText = Color(255, 255, 255)
local colorMain = Color(204, 204, 204)
local colorMainDarker = Color(46, 46, 46)
local colorMainDisabled = Color(26, 26, 26)
local colorGreen = Color(159, 245, 20)
local colorYellow = Color(238, 224, 25)
local colorRed = Color(223, 28, 28)
local colorBlue = Color(31, 200, 230)

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

    mvm = "zxc765/mvm.png",
    niip = "zxc765/niip.png",
    pivo = "zxc765/PIVO_logo_lt.png",
}
for idx, icoPath in pairs(icons) do
    local paths = istable(icoPath) and icoPath or {icoPath, isnumber(idx) and idx > 10 and idx <= 20 and icoPath or nil}
    for pidx, path in ipairs(paths) do
        if isnumber(idx) and idx > 10 and idx <= 20 and pidx == 2 then
            path = string.Explode(".", path)
            path[1] = path[1] .. "_g"
            path = table.concat(path, ".")
        end
        local ico = Material(path, "smooth ignorez")
        paths[pidx] = ico
    end
    icons[idx] = paths
end

surface.CreateFont("Mfdu765.24", {
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

surface.CreateFont("Mfdu765.28", {
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

surface.CreateFont("Mfdu765.40", {
    font = "Open Sans",
    extended = true,
    size = 40,
    weight = 500,
})

surface.CreateFont("Mfdu765.DepotMode", {
    font = "Open Sans",
    extended = true,
    size = 50,
    weight = 500,
})

surface.CreateFont("Mfdu765.Message", {
    font = "Open Sans",
    extended = true,
    size = 42,
    weight = 600,
})

surface.CreateFont("Mfdu765.Speed", {
    font = "Open Sans",
    extended = true,
    size = 120,
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

surface.CreateFont("Mfdu765.DoorsLabels", {
    font = "Open Sans",
    extended = true,
    size = 40,
    weight = 400,
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

surface.CreateFont("Mfdu765.MainGridLabels", {
    font = "Open Sans",
    extended = true,
    size = 36,
    weight = 700,
})

surface.CreateFont("Mfdu765.28.600", {
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

surface.CreateFont("Mfdu765.IdleMessage", {
    font = "Open Sans",
    extended = true,
    size = 64,
    weight = 600,
})

surface.CreateFont("Mfdu765.AutodriveVals", {
    font = "Open Sans",
    extended = true,
    size = 50,
    weight = 700,
})

surface.CreateFont("Mfdu765.PvuWag", {
    font = "Open Sans",
    extended = true,
    size = 38,
    weight = 500,
})

local function drawBox(x, y, w, h, color, bgColor, borderSize)
    surface.SetDrawColor(color)
    surface.DrawRect(x, y, w, h)
    if bgColor then surface.SetDrawColor(bgColor) else surface.SetDrawColor(0, 0, 0) end
    surface.DrawRect(x + borderSize, y + borderSize, w - borderSize * 2, h - borderSize * 2)
end

function TRAIN_SYSTEM:DrawErr(msg)
    surface.SetDrawColor(colorMain)
    surface.DrawRect(scrOffsetX, scrOffsetY, scrW + scrOffsetX, scrH + scrOffsetY)
    draw.SimpleText(msg, "Mfdu765.IdleMessage", scrW / 2, scrOffsetY + 100, colorBlack, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
end

function TRAIN_SYSTEM:DrawIdle(msg, passwd, rear)
    surface.SetDrawColor(colorBlack)
    surface.DrawRect(scrOffsetX, scrOffsetY, scrW + scrOffsetX, scrH + scrOffsetY)
    draw.SimpleText(msg, "Mfdu765.IdleMessage", scrW / 2, scrOffsetY + 50, (passwd or rear) and colorMain or colorYellow, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(icons.mvm[1])
    surface.DrawTexturedRect(0, scrOffsetY + scrH - 270, 300, 300)
    surface.SetMaterial(icons.niip[1])
    surface.DrawTexturedRect(340 + 40, scrOffsetY + scrH - 245, 240, 240)
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(icons.pivo[1])
    surface.DrawTexturedRect(scrW - 280, scrOffsetY + scrH - 245, 240, 240)

    local Wag = self.Train

    if passwd then
        passwd = Wag:GetNW2String("Skif:Pass", "")
        local w = draw.SimpleText(passwd, "Mfdu765.IdleMessage", scrW / 2, scrOffsetY + 300, colorBlue, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        if CurTime() % 1.0 > 0.5 then
            draw.SimpleText("|", "Mfdu765.IdleMessage", scrW / 2 + w / 2 + 4, scrOffsetY + 294, colorBlue, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        end
    end

    if rear then
        local gap = 80
        local x = scrW / 2 - gap * 1.5
        local y = scrH / 2 + 20 + scrOffsetY
        local ytop = y - 12
        local ybot = y + 12

        local ptm = Wag:GetNW2Int("Skif:Ptm", "---")
        draw.SimpleText("Pтм", "Mfdu765.24", x, ytop, colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
        draw.SimpleText(isnumber(ptm) and (ptm == 0 and "0" or string.format("%.1f", ptm / 10)) or ptm, "Mfdu765.StatusValue", x, y, colorBlue, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("атм", "Mfdu765.24", x, ybot, colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

        x = x + gap
        local pnm = Wag:GetNW2Int("Skif:Pnm", "---")
        draw.SimpleText("Pнм", "Mfdu765.24", x, ytop, colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
        draw.SimpleText(isnumber(pnm) and (pnm == 0 and "0" or string.format("%.1f", pnm / 10)) or pnm, "Mfdu765.StatusValue", x, y, colorBlue, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("атм", "Mfdu765.24", x, ybot, colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

        x = x + gap
        local ubs = Wag:GetNW2Int("Skif:Ubs", "---")
        draw.SimpleText("Uбс", "Mfdu765.24", x, ytop, colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
        draw.SimpleText(isnumber(ubs) and (ubs == 0 and "0" or string.format("%.1f", ubs / 10)) or ubs, "Mfdu765.StatusValue", x, y, colorGreen, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("в", "Mfdu765.24", x, ybot, colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

        x = x + gap
        local uhv = Wag:GetNW2Int("Skif:Uhv", "---")
        draw.SimpleText("Uкс", "Mfdu765.24", x, ytop, colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
        draw.SimpleText(isnumber(uhv) and (uhv == 0 and "0" or string.format("%.1f", uhv / 10)) or uhv, "Mfdu765.StatusValue", x, y, colorYellow, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("в", "Mfdu765.24", x, ybot, colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

        x = scrW / 2
        y = y - 150
        ybot = y + 40 + scrOffsetY
        local speed = Wag:GetNW2Int("Skif:Speed", "---")
        draw.SimpleText(speed, "Mfdu765.Speed", x, y, colorGreen, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("км/ч", "Mfdu765.24", x, ybot, colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    end
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
    local line = Wag:GetNW2String("Skif:LineName", "---")
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

    draw.SimpleText(title, "Mfdu765.40", scrW / 2, y, colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText(Wag:GetNW2String("Skif:Date", ""), "Mfdu765.TopBarSmall", scrW - x, y - 12, colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText(Wag:GetNW2String("Skif:Time", "--:--:--"), "Mfdu765.TopBarSmall", scrW - x, y + 12, colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

local sizeMainLinesH = 50
local sizeMainSpeedH = 74
local sizeMainLinesGapSmall = 4
local sizeMainLinesGap = 75
local sizeSpeedMargin = 84
local posPageStartY = sizeTopBar + sizeMainMargin + sizeBorder
local posAlsModeY = posPageStartY + 45
local posMainLinesStartX = sizeThrottleW + sizeMainMargin
function TRAIN_SYSTEM:DrawMainPage()
    draw.SimpleText("Режим " .. self.FreqMode, "Mfdu765.40", posMainLinesStartX, posAlsModeY, colorMain, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    local x, y = posMainLinesStartX + sizeSpeedMargin, posAlsModeY + sizeMainLinesGap + sizeMainSpeedH
    draw.SimpleText(tostring(self.Speed), "Mfdu765.Speed", x + 8, y - 0.2 * sizeMainSpeedH, colorGreen, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
    draw.SimpleText("км/ч", "Mfdu765.SpeedTextMain", x + 8, y - 0.6 * sizeMainSpeedH, colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

    y = y + sizeMainLinesGapSmall + sizeMainLinesH
    draw.SimpleText("V", "Mfdu765.SpeedLetter", x, y + 10, colorRed, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
    draw.SimpleText("доп", "Mfdu765.BodyTextLarge", x, y + 10, colorRed, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
    draw.SimpleText(tostring(self.SpeedLimit), "Mfdu765.SpeedLetter", x, y, colorRed, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

    if self.AlsArs then
        y = y + sizeMainLinesGapSmall * 2 + sizeMainLinesH * 2
        draw.SimpleText("V", "Mfdu765.SpeedLetter", x, y, colorYellow, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
        draw.SimpleText("пред", "Mfdu765.BodyTextLarge", x, y, colorYellow, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
        draw.SimpleText(tostring(self.SpeedNext), "Mfdu765.SpeedLetter", x, y - 10, colorYellow, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    end

    self:DrawMainStatus(self.Train, sizeThrottleW + sizeMainMargin + 490, posPageStartY + 4, sizeMainW - 500, sizeMainH - 8)
end


local sizeStatusIcon = 52
local sizeStatusIconSpread = 8
local sizeMessageW = scrW - sizeStatusSide * 2 - sizeBorder * 2
local sizeMessageH = sizeStatus - sizeStatusIcon - sizeMainMargin
local sizeStatusIconsGap = (sizeMessageW - sizeStatusIcon * 10) / 9
local sizeMessageBorder = 6
local sizeStatusVoltageMargin = 32
local voltageList = {
    {"Skif:LvMin", "бс min"},
    {"Skif:LvMax", "бс max"},
    {"Skif:HvMin", "кс min"},
    {"Skif:HvMax", "кс max"},
}
local pneumoList = {
    {"Skif:PNM", "нм"},
    {"Skif:PTM", "тм"},
    {"Skif:PMin", "тц min"},
    {"Skif:PMax", "тц max"},
}
local rightBarList = {
    {"Skif:ARS1", "АРС1"},
    {"Skif:ARS2", "АРС2"},
    {"Skif:BvAll", "БВ"},
    {"Skif:BTB", "БТБ", true},
    {"Skif:KTR", "КТР"},
    {"Skif:ALS", "АЛС"},
    {"Skif:BOSD", "БОСД"},
}
local statusGetters = {
    -- ВО
    function(self, Wag) return Wag:GetNW2Bool("Skif:VoGood", false) and colorMain or colorRed end,
    -- Двери
    function(self, Wag) return Wag:GetNW2Int("Skif:DoorsAll", 0) == 1 and colorGreen or Wag:GetNW2Int("Skif:DoorsAll", 0) == 2 and colorYellow or colorRed end,
    -- Тяг.привод
    function(self, Wag) return colorMain end,
    -- Напряжение
    function(self, Wag) return Wag:GetNW2Int("Skif:HvAll", 0) == 1 and colorGreen or Wag:GetNW2Int("Skif:HvAll", 0) == 2 and colorYellow or colorRed end,
    -- Пневматика
    function(self, Wag) return colorMain end,
    -- Кондиционер
    function(self, Wag) return Wag:GetNW2Bool("Skif:CondAny", false) and (Wag:GetNW2Bool("Skif:Cond", false) and colorYellow or colorBlue) or colorMain end,
    -- Автоведение
    function(self, Wag) return --[[Wag:GetNW2Bool("AVP:Fail", false) and colorRed or Wag:GetNW2Int("Skif:AVP:State", 0) > 0 and colorGreen or]] colorMain end,
    -- Сообщения
    function(self, Wag) return colorMain end,
    -- Сервис
    function(self, Wag) return colorMain end,
    -- ПВУ
    function(self, Wag) return Wag:GetNW2Bool("Skif:Pvu", false) and colorYellow or colorMain end,

    -- Противоюз
    function(self, Wag) return colorMainDisabled end,
    -- Ст.тормоз
    function(self, Wag) return Wag:GetNW2Bool("Skif:ParkEnabled", false) and colorGreen or colorMainDisabled end,
    -- Пневмотормоз
    function(self, Wag) return Wag:GetNW2Bool("Skif:PtApplied", false) and colorYellow or colorMainDisabled end,
    -- Пт вкл в хв
    function(self, Wag) return Wag:GetNW2Bool("Skif:PtAppliedRear", false) and colorYellow or colorMainDisabled end,
    -- Экст.т.
    function(self, Wag) return Wag:GetNW2Bool("Skif:EmerActive", false) and colorRed or colorMainDisabled end,
    -- Автоведение
    function(self, Wag) return Wag:GetNW2Bool("AVP:Fail", false) and (CurTime()%0.8 > 0.4 and colorRed or colorMainDisabled) or Wag:GetNW2Int("Skif:AVP:State", 0) > 1 and colorGreen or Wag:GetNW2Int("Skif:AVP:State", 0) > 0 and colorYellow or Wag:GetNW2Bool("Skif:AVP:Button",false) and colorMain or colorMainDisabled end,
    -- Пр.Ост.
    function(self, Wag)
        return
            not Wag:GetNW2Bool("Skif:Prost", false) and colorMainDisabled or
            Wag:GetNW2Bool("Skif:ProstActive", false) and CurTime() % 0.5 < 0.25 and colorGreen or colorMain
    end,
    -- Кос
    function(self, Wag)
        return
            not Wag:GetNW2Bool("Skif:Kos", false) and colorMainDisabled or
            Wag:GetNW2Bool("Skif:KosActive", false) and not Wag:GetNW2Bool("Skif:KosCommand", false) and colorGreen or
            Wag:GetNW2Bool("Skif:KosCommand", false) and CurTime() % 0.5 < 0.25 and colorRed or colorMain
    end,
    -- КРР
    function(self, Wag) return Wag:GetNW2Bool("Skif:KRR", false) and colorYellow or colorMainDisabled end,
    -- Подъем
    function(self, Wag) return Wag:GetNW2Bool("AccelRateLamp", false) and colorGreen or colorMainDisabled end,
}
local errorsCat = {
    {"А", colorRed}, {"Б", colorYellow}, {"В", colorBlue}
}
function TRAIN_SYSTEM:DrawStatus(Wag)
    local errCat = Wag:GetNW2Int("Skif:ErrorCat", 0)
    if errorsCat[errCat] then
        local cat, color = unpack(errorsCat[errCat])
        local msg = string.Split(Wag:GetNW2String("Skif:ErrorStr", ""), "\n")
        local x, y = sizeStatusSide + sizeBorder, scrOffsetY + scrH - sizeFooter - sizeMessageH - sizeMainMargin
        drawBox(x, y, sizeMessageW, sizeMessageH, color, nil, sizeMessageBorder)
        if #msg > 1 then
            draw.SimpleText(msg[1], "Mfdu765.Message", x + sizeMessageW / 2, y +     sizeMessageH / 4 + 6, colorBrightText, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText(msg[2], "Mfdu765.Message", x + sizeMessageW / 2, y + 3 * sizeMessageH / 4 - 6, colorBrightText, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        else
            draw.SimpleText(msg[1], "Mfdu765.Message", x + sizeMessageW / 2, y + sizeMessageH / 2, colorBrightText, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        draw.SimpleText(cat, "Mfdu765.24", x + sizeMessageW - 12, y + 4, color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
    end

    local w, h = sizeStatusSide - sizeBorder * 2, sizeStatus - sizeStatusVoltageMargin - sizeBorder * 2
    if self.Page == 0 then
        for idx, v in ipairs(voltageList) do
            local x = (w / 4) * (((idx - 1) % 2) * 2 + 1) + sizeBorder
            local y = (h / 4) * (math.floor((idx - 1) / 2) * 2 + 1) + (scrOffsetY + scrH - sizeFooter - sizeMainMargin - sizeStatus)
            local k, text = unpack(v)
            local val = tostring(Wag:GetNW2Int(k, "Н/Д"))
            draw.SimpleText("U", "Mfdu765.40", x - 26, y + 4, colorBrightText, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
            draw.SimpleText(text, "Mfdu765.24", x + 14, y, colorBrightText, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
            draw.SimpleText(val, "Mfdu765.StatusValue", x, y - 4, colorYellow, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
            if idx > 2 then
                draw.SimpleText("В", "Mfdu765.24", x, y + 58, colorBrightText, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
            end
        end
    else
        local x = 1 * w / 6 + sizeBorder
        local y = scrOffsetY + scrH - sizeFooter - sizeBorder - 64
        draw.SimpleText("V", "Mfdu765.40", x - 12, y + 10, colorRed, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
        draw.SimpleText("доп", "Mfdu765.24", x + 10, y + 8, colorRed, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
        draw.SimpleText(self.SpeedLimit, "Mfdu765.StatusValueSpeed", x, y - 4, colorRed, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

        if self.AlsArs then
            x = 5 * w / 6 + sizeBorder
            draw.SimpleText("V", "Mfdu765.40", x - 18, y + 10, colorYellow, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
            draw.SimpleText("пред", "Mfdu765.24", x + 10, y + 8, colorYellow, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
            draw.SimpleText(self.SpeedNext, "Mfdu765.StatusValueSpeed", x, y - 4, colorYellow, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        end

        x = 1 * w / 2 + sizeBorder
        y = scrOffsetY + scrH - sizeFooter - sizeBorder - 32
        draw.SimpleText(self.Speed, "Mfdu765.StatusValueSpeed", x, y - 4, colorGreen, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
        draw.SimpleText("км/ч", "Mfdu765.24", x, y - 8, colorBrightText, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

        x = w / 2
        y = scrOffsetY + scrH - sizeFooter - sizeBorder - sizeStatus * 0.75
        draw.SimpleText("Режим " .. self.FreqMode, "Mfdu765.24", x, y, colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    for idx, v in ipairs(pneumoList) do
        local x = (w / 4) * (((idx - 1) % 2) * 2 + 1) + scrW + sizeBorder - sizeStatusSide
        local y = (h / 4) * (math.floor((idx - 1) / 2) * 2 + 1) + (scrOffsetY + scrH - sizeFooter - sizeMainMargin - sizeStatus)
        local k, text = unpack(v)
        local val = Wag:GetNW2Int(k, "Н/Д")
        val = isnumber(val) and val / 10 or val
        draw.SimpleText("P", "Mfdu765.40", x - (idx > 2 and 24 or 16), y + 4, colorBrightText, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
        draw.SimpleText(text, "Mfdu765.24", x + (idx > 2 and 14 or 8), y, colorBrightText, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
        draw.SimpleText(not isnumber(val) and val or string.format("%.1f", val), "Mfdu765.StatusValue", x, y - 4, colorBlue, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        if idx > 2 then
            draw.SimpleText("Атм", "Mfdu765.24", x, y + 58, colorBrightText, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
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
        draw.SimpleText(text, "Mfdu765.28", x + sizeRightBarW / 2, y + h / 2 - 1, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    for idx, icon in ipairs(icons) do
        if idx > 10 then break end
        local x, y = (idx - 1) * (sizeButtonW + sizeButtonGap), scrOffsetY + scrH - sizeFooter
        local getter = statusGetters[idx]
        icon = idx == 6 and icon[Wag:GetNW2Bool("Skif:Cond", false) and 2 or 1] or icon[1]
        surface.SetDrawColor(self.Page == idx and (self.Select > 0 or Wag:GetNW2Int("Skif:PvuWag", 0) > 0) and colorBlue or getter and getter(self, Wag) or colorMain)
        surface.SetMaterial(icon)
        surface.DrawTexturedRect(x + sizeButtonBorder, y + sizeButtonBorder, sizeButtonW - sizeButtonBorder * 2, sizeFooter - sizeButtonBorder * 2)
    end

    for idx, icon in ipairs(icons) do
        if idx <= 10 then continue end
        local x, y = sizeStatusSide + sizeBorder + (idx - 11) * (sizeStatusIcon + sizeStatusIconsGap) - sizeStatusIconSpread, scrOffsetY + scrH - sizeFooter - sizeStatus - sizeMainMargin + sizeBorder * 2 - sizeStatusIconSpread
        local getter = statusGetters[idx]
        local color = getter and getter(self, Wag) or colorMainDisabled
        local light = color ~= colorMainDisabled and color ~= colorMain
        surface.SetDrawColor(color)
        surface.SetMaterial(icon[light and 2 or 1])
        surface.DrawTexturedRect(x, y, sizeStatusIcon + sizeStatusIconSpread * 2, sizeStatusIcon + sizeStatusIconSpread * 2)
    end
end

function TRAIN_SYSTEM:DrawMainThrottle()
    local Wag = self.Train
    local thr = Wag:GetNW2Int("Skif:Throttle", 0)
    local override = Wag:GetNW2Bool("Skif:OverrideKv")
    if override or override ~= self.LastOverride or not self.LastThrUpd or thr * (self.Throttle or 0) < 0 then
        self.Throttle = thr
    else
        local dT = CurTime() - self.LastThrUpd
        if self.Throttle ~= thr then
            local sgn = (thr > self.Throttle and 1 or -1)
            self.Throttle = (self.Throttle or 0) + sgn * (Wag.KvSettingSpeed or 80) * dT
            if self.Throttle > thr and sgn > 0 or self.Throttle < thr and sgn < 0 then
                self.Throttle = thr
            end
        end
    end
    self.LastOverride = override
    self.LastThrUpd = CurTime()

    surface.SetDrawColor(0, 0, 0)
    surface.DrawRect(0, scrOffsetY + sizeTopBar + sizeMainMargin, sizeThrottleBarW + sizeThrottleMeasure, sizeThrottleBarH + sizeThrottleLabelsH * 2)

    drawBox(sizeThrottleMeasure, scrOffsetY + sizeTopBar + sizeMainMargin + sizeThrottleLabelsH, sizeThrottleBarW, sizeThrottleBarH, colorMain, colorMainDarker, sizeBorder)
    surface.SetDrawColor(colorMain)
    local x, y = sizeThrottleMeasure - sizeThrottleMeasureLine, scrOffsetY + sizeTopBar + sizeMainMargin + sizeThrottleLabelsH
    local h = (sizeThrottleBarH - sizeBorder / 1.5) / 20
    for idx = -10, 10 do
        local label = math.abs(idx) * 10
        local even = label == 0 or label % 20 == 0
        surface.DrawRect(even and x - sizeThrottleMeasureLine or x, y, sizeThrottleMeasureLine * (even and 2 or 1), sizeBorder)
        if even then
            draw.SimpleText(tostring(label), "Mfdu765.24", x - sizeThrottleMeasureLine - 3, y - 1, colorMain, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        end
        y = y + h
    end

    draw.SimpleText("ХОД", "Mfdu765.28", sizeThrottleW - 4, scrOffsetY + sizeTopBar + sizeMainMargin + sizeBorder, colorMain, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
    draw.SimpleText("ТОРМОЗ", "Mfdu765.28", sizeThrottleW - 4, y + sizeBorder * 2 - h, colorMain, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

    self:DrawThrottle(
        self.Throttle or 0,
        sizeThrottleMeasure + sizeBorder, scrOffsetY + sizeTopBar + sizeMainMargin + sizeThrottleLabelsH,
        sizeThrottleBarW - sizeBorder * 2
    )
end

local sizeCellBorderRadius = 8
function TRAIN_SYSTEM:DrawGrid(x, y, w, h, vertical, cellGap, labels, labelFont, wagNumbers, wagNumbersFont, leftOffset, topOffset, getter, drawRow)
    if not isfunction(getter) then return end
    local wagc = istable(wagNumbers) and #wagNumbers or 8
    if not istable(wagNumbers) then
        local ind = not wagNumbers
        wagNumbers = {}
        for idx = 1, self.WagNum do
            table.insert(wagNumbers, tostring(ind and idx or self.Train:GetNW2Int("Skif:WagNum" .. idx, "?????")))
        end
    end

    local cellMarginX, cellMarginY = 0, 0
    if istable(cellGap) then
        cellMarginX = cellGap[2] or cellMarginX
        cellMarginY = cellGap[3] or cellMarginY
        cellGap = cellGap[1]
    end

    local colCount = vertical and wagc or #labels
    local rowCount = vertical and #labels or wagc
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
                istable(drawCurRow) and drawCurRow or colorMain, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER
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
                if color == "toggle" then
                    local cx, cy, cw, ch = x + cellMarginX, y + cellMarginY + (cellH - 50) / 2, (cellW - cellMarginX * 2) / 2 - 1, 50
                    draw.RoundedBox(sizeCellBorderRadius, cx, cy, cw, ch, not text and colorRed or colorMainDisabled)
                    draw.SimpleText("Выкл", textFont or "Mfdu765.28", cx + cw / 2, cy + ch / 2, text and colorMain or colorBlack, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    cx = cx + cw + 2
                    draw.RoundedBox(sizeCellBorderRadius, cx, cy, cw, ch, text and colorGreen or colorMainDisabled)
                    draw.SimpleText("Вкл", textFont or "Mfdu765.28", cx + cw / 2, cy + ch / 2, not text and colorMain or colorBlack, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                else
                    if color then
                        draw.RoundedBox(sizeCellBorderRadius, x + cellMarginX, y + cellMarginY, cellW - cellMarginX * 2, cellH - cellMarginY * 2, color)
                    end
                    if text then
                        draw.SimpleText(text, textFont or "Mfdu765.28", x + cellW / 2, y + cellH / 2, textColor or colorBlack, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    end
                end
            end

            x = x + cellW + cellGap
        end

        y = y + cellH + cellGap
        x = x0
    end
end

local sizeIdentCw, sizeIdentCh = 40, 80
local sizeIdentGap = 4
function TRAIN_SYSTEM:DrawIdent()
    surface.SetDrawColor(colorBlack)
    surface.DrawRect(scrOffsetX, scrOffsetY, scrW + scrOffsetX, scrH + scrOffsetY)
    draw.SimpleText("Вагоны не идентифицированы", "Mfdu765.IdleMessage", scrW / 2, scrOffsetY + 100, colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    surface.SetDrawColor(255, 255, 255)

    local cw, ch = sizeIdentCw, sizeIdentCh
    local linew = cw * self.WagNum + sizeIdentGap * (self.WagNum - 1)
    local cx, cy = scrW / 2 - linew / 2, 400
    for idx = 1, self.WagNum do
        draw.SimpleText(idx, "Mfdu765.DoorsSide", cx + cw / 2, cy - 2, colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
        draw.RoundedBox(sizeCellBorderRadius, cx, cy, cw, ch, self.Train:GetNW2Bool("Skif:WagI" .. idx, false) and colorGreen or colorRed)
        cx = cx + sizeIdentGap + cw
    end
end

local depotEntry = {
    "1. Идентификация машиниста", "2. Число вагонов в составе",
    "3. Ввод номеров вагонов",    "4. Диаметры бандажа КП",
    "5. Версия ПО",               "6. Номер маршрута",
    "7. Пульты",                  "8. Выбор линии",
}
local sizeDepotHeader = sizeFooter
local posDepotBody = scrOffsetY + sizeDepotHeader + sizeMainMargin
local sizeDepotBody = scrH - sizeDepotHeader * 2 - sizeMainMargin * 2
local sizeDepotRowW = scrW - sizeButtonBorder * 2
local sizeDepotRowH = (sizeDepotBody - sizeButtonBorder * 2) / 8
local sizeDepotCol = sizeDepotRowW * 0.65
local sizeDepotCol2 = sizeDepotRowW - sizeDepotCol
function TRAIN_SYSTEM:DrawDepot()
    surface.SetDrawColor(colorBlack)
    surface.DrawRect(0, scrOffsetY, scrW, scrH)
    drawBox(0, scrOffsetY, scrW, sizeDepotHeader, colorMain, colorBlack, sizeButtonBorder)
    drawBox(0, scrOffsetY + scrH - sizeDepotHeader, scrW, sizeDepotHeader, colorMain, colorBlack, sizeButtonBorder)
    drawBox(0, posDepotBody, scrW, sizeDepotBody, colorMain, colorBlack, sizeButtonBorder)

    local Wag = self.Train
    local x = scrW / 2
    local y = scrOffsetY + sizeDepotHeader / 2
    draw.SimpleText(self.State2 == 1 and "Ввод номеров вагонов" or "РЕЖИМ ДЕПО", "Mfdu765.DepotMode", x, y, colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    y = scrOffsetY + scrH - sizeDepotHeader / 2
    x = sizeButtonBorder + sizeDepotRowW / 4
    draw.SimpleText(Wag:GetNW2String("Skif:Date", ""), "Mfdu765.DepotMode", x, y, colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    x = sizeButtonBorder + 3 * sizeDepotRowW / 4
    draw.SimpleText(Wag:GetNW2String("Skif:Time", "--:--:--"), "Mfdu765.DepotMode", x, y, colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    local wagn = Wag:GetNW2Int("Skif:WagNum", 0)

    local tbl = depotEntry
    if self.State2 == 1 then
        tbl = {}
        for idx = 1, wagn do
            tbl[idx] = "Вагон №" .. idx
        end
    end

    x = sizeButtonBorder
    y = posDepotBody + sizeButtonBorder
    for idx = 1, 8 do
        local entry = tbl[idx]
        if idx % 2 ~= 0 then
            surface.SetDrawColor(colorMainDarker)
            surface.DrawRect(x, y, sizeDepotRowW, sizeDepotRowH)
        end

        if entry then
            draw.SimpleText(entry, "Mfdu765.DepotMode", x + 50, y + sizeDepotRowH / 2, colorMain, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

            local ent = Wag:GetNW2String("Skif:Enter", "-")
            local entering = ent ~= "-"
            local sel = Wag:GetNW2Int("Skif:DepotSel", 0) == idx
            local text
            if sel and entering then
                text = ent
            elseif self.State2 == 1 then
                text = Wag:GetNW2String("Skif:WagNum" .. idx, "?????")
            elseif idx == 2 then
                text = Wag:GetNW2Int("Skif:WagNum", "---")
            elseif idx == 6 then
                text = Wag:GetNW2Int("Skif:RouteNumber", "---")
                if isnumber(text) then text = string.format("%03d", text) end
            elseif idx == 5 then
                text = Wag.Version
            else
                text = "выбор"
            end
            text = tostring(text)

            surface.SetFont("Mfdu765.DepotMode")
            local tw, th = surface.GetTextSize(#text > 0 and text or "1")
            local tx, ty = x + sizeDepotCol + sizeDepotCol2 / 2, y + sizeDepotRowH / 2
            if entering and sel then
                surface.SetDrawColor(colorBlue)
                surface.DrawRect(tx - tw / 2, ty - th / 2, tw, th)
            end
            local color = entering and sel and colorBlack or sel and colorBlue or colorMain
            draw.SimpleText(text, "Mfdu765.DepotMode", tx, ty, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        y = y + sizeDepotRowH
    end

    surface.SetDrawColor(colorMain)
    surface.DrawRect(sizeButtonBorder + sizeDepotCol, posDepotBody, sizeButtonBorder * 2, sizeDepotBody)
end

function TRAIN_SYSTEM:DrawPage(func, title, ...)
    self:DrawStatic()
    self:DrawTopBar(self.Train, title)
    self:DrawStatus(self.Train)
    func(self, self.Train, sizeThrottleW + sizeBorder, scrOffsetY + sizeTopBar + sizeMainMargin + sizeBorder, sizeMainW - sizeBorder * 2, sizeMainH - sizeBorder * 2, ...)
end

local posDoorsGridX = 68
local posDoorsGridY = 140
local sizeDoorBlock = 42
local doorsLabels = {"M", "1", "2", "3", "4", "T", "5", "6", "7", "8", "M"}
function TRAIN_SYSTEM:DrawDoorsPage(Wag, x, y, w, h)
    local gx, gy = x + posDoorsGridX, y + posDoorsGridY
    local gw, gh = w - posDoorsGridX - sizeMainMargin, h - posDoorsGridY - sizeMainMargin
    self:DrawGrid(
        gx, gy, gw, gh, false, sizeMainMargin * 0.75,
        doorsLabels, "Mfdu765.DoorsLabels",
        true, "Mfdu765.24",
        sizeMainMargin, sizeMainMargin / 2,
        function(wagIdx, doorIdx)
            local color
            local isHead = Wag:GetNW2Bool("Skif:HasCabin" .. wagIdx, false)
            local buvDisabled = not Wag:GetNW2Bool("Skif:BUVState" .. wagIdx, false)
            local pvu = not buvDisabled and Wag:GetNW2Bool("Skif:PVU1" .. wagIdx, false)
            local addr, aod = false, false
            if doorIdx == 1 then
                color = isHead and Wag:GetNW2Bool("Skif:DoorML" .. wagIdx, false) and colorGreen or isHead and colorRed or nil
                pvu = false
            elseif doorIdx == 11 then
                color = isHead and Wag:GetNW2Bool("Skif:DoorMR" .. wagIdx, false) and colorGreen or isHead and colorRed or nil
                pvu = false
            elseif doorIdx == 6 then
                color = isHead and Wag:GetNW2Bool("Skif:DoorT" .. wagIdx, false) and colorGreen or isHead and colorRed or nil
                pvu = false
            else
                local left = doorIdx < 6
                local door = string.format("%d%s%d", left and doorIdx - 1 or 11 - doorIdx, left and "L" or "R", wagIdx)
                addr = Wag:GetNW2Bool("Skif:AddressDoors" .. (left and "L" or "R") .. wagIdx, false)
                aod = Wag:GetNW2Bool("Skif:DoorAod" .. door, false)
                color = not buvDisabled and Wag:GetNW2Bool("Skif:Door" .. door, false) and colorGreen or Wag:GetNW2Bool("Skif:DoorReverse" .. door, false) and colorYellow or colorRed
            end
            return color, color and (buvDisabled and "X" or aod and "А" or pvu and "Р" or addr and "И" or nil)
        end
    )
    local sideTextPos = y + posDoorsGridY / 2 - 16
    local leftTextPos = gx + 1.00 * gw / 4 - sizeDoorBlock / 2
    local rightTextPos = gx + 3 * gw / 4 - sizeDoorBlock / 2 - 28
    local blLeftPos = surface.GetTextSize("Левые") / 2 + leftTextPos + 32
    local blRightPos = surface.GetTextSize("Правые") / 2 + rightTextPos + 32
    draw.SimpleText("Левые", "Mfdu765.DoorsSide", leftTextPos, sideTextPos, colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText("Правые", "Mfdu765.DoorsSide", rightTextPos, sideTextPos, colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.RoundedBox(sizeCellBorderRadius, blLeftPos, sideTextPos - sizeDoorBlock / 2, sizeDoorBlock, sizeDoorBlock, Wag:GetNW2Bool("Skif:DoorBlockL", false) and colorGreen or colorRed)
    draw.RoundedBox(sizeCellBorderRadius, blRightPos, sideTextPos - sizeDoorBlock / 2, sizeDoorBlock, sizeDoorBlock, Wag:GetNW2Bool("Skif:DoorBlockR", false) and colorGreen or colorRed)
    draw.SimpleText("Б", "Mfdu765.28", blLeftPos + sizeDoorBlock / 2, sideTextPos, colorBlack, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText("Б", "Mfdu765.28", blRightPos + sizeDoorBlock / 2, sideTextPos, colorBlack, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

local asyncLabels = {
    "СБОР СХЕМЫ", "БВ", "Отказ ИНВ", "Защита ИНВ", "Перегрев ИНВ", "Отказ ЭТ", "Неиспр. ВТР"
}
local asyncStates = {
    "Skif:Scheme", "Skif:BV"
}
function TRAIN_SYSTEM:DrawAsyncPage(Wag, x, y, w, h)
    local gw, gh = w * 0.35 - sizeBorder * 2, h - 64 - sizeBorder * 6
    local gx, gy = x + w - gw - sizeBorder * 6, y + 64
    self:DrawGrid(
        gx, gy, gw, gh, true, sizeMainMargin * 0.75,
        asyncLabels, "Mfdu765.28",
        false, "Mfdu765.28",
        sizeMainMargin, sizeMainMargin / 2,
        function(wagIdx, idx)
            if not Wag:GetNW2Bool("Skif:AsyncInverter" .. wagIdx, false) then return end
            local k = asyncStates[idx]
            local text = nil
            if idx == 2 then
                if not Wag:GetNW2Bool("Skif:Battery" .. wagIdx, false) or not Wag:GetNW2Bool("Skif:BUVState" .. wagIdx, false) or not Wag:GetNW2Bool("Skif:InvSf" .. wagIdx, false) then
                    text = "X"
                elseif Wag:GetNW2Bool("Skif:PVU7" .. wagIdx, false) then
                    text = "Р"
                end
            end
            return (not k or Wag:GetNW2Bool(k .. wagIdx, false)) and colorGreen or colorRed, text
        end
    )

    local barW = sizeThrottleBarW * 0.9
    local xb, yb = x + sizeThrottleMargin, scrOffsetY + sizeTopBar + sizeMainMargin + sizeThrottleLabelsH
    for idx = 1, Wag:GetNW2Int("Skif:WagNum", 0) do
        drawBox(xb, yb, barW, sizeThrottleBarH, colorMain, colorMainDarker, sizeBorder)
        local thr = - Wag:GetNW2Int("Skif:DriveStrength" .. idx, 0)
        if thr == 0 then
            thr = Wag:GetNW2Int("Skif:BrakeStrength" .. idx, 0)
        end
        self:DrawThrottle(math.Clamp(thr * 100 / 150, -100, 100), xb, yb, barW)

        local color = not Wag:GetNW2Bool("Skif:AsyncInverter" .. idx, false) and colorMainDarker or Wag:GetNW2Bool("Skif:HVGood" .. idx, false) and colorGreen or colorRed
        draw.RoundedBox(
            sizeCellBorderRadius, xb + sizeBorder, yb + sizeThrottleBarH + sizeBorder,
            barW - sizeBorder * 2, barW - sizeBorder, color
        )
        local textColor = color == colorMainDarker and colorMain or colorBlack
        draw.SimpleText(tostring(idx), "Mfdu765.28", xb + barW / 2, yb + sizeThrottleBarH + sizeBorder + barW / 2 - 1, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

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
            draw.SimpleText(tostring(label), "Mfdu765.24", xb + sizeThrottleMeasureLine * 2 + 3, yb - 1, colorMain, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
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
                draw.SimpleText(tostring(val), font or "Mfdu765.28", x + cw / 2, y + rowTall / 2, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
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
            if idx > Wag:GetNW2Int("Skif:WagNum", 0) then return end
            local async = Wag:GetNW2Bool("Skif:AsyncInverter" .. idx, false)
            if row == 1 then
                return Wag:GetNW2Int("Skif:WagNum" .. idx, "?????")
            -- pizdec
            elseif row == 2 then
                local val = Wag:GetNW2Int("Skif:U" .. idx, 0) / 10
                if not async then
                    return nil, nil, val >= 550 and colorGreen or colorRed
                else
                    return val, val >= 550 and colorGreen or colorRed
                end
            elseif row == 3 then
                local val = Wag:GetNW2Int("Skif:UBS" .. idx, 0) / 10
                return val, val >= 62 and colorGreen or colorRed
            elseif row == 4 then
                local hv = Wag:GetNW2Int("Skif:U" .. idx, 0) / 10
                local val = Lerp(math.Clamp((hv - 550) / (720 - 550), 0, 1), 0, Wag:GetNW2Int("Skif:UBS" .. idx, 0) / 10) or 0
                return math.Round(val), val >= 62 and colorGreen or colorRed
            elseif row == 5 then
                if not async then return end
                local val = Wag:GetNW2Int("Skif:IMK" .. idx, 0) / 10
                return val, colorGreen
            elseif row == 6 then
                if not async then return end
                local val = Wag:GetNW2Int("Skif:I" .. idx, 0) / 10
                return val, colorGreen
            elseif row == 7 then
                return 0, colorGreen
            elseif row == 8 then
                local val = Wag:GetNW2Int("Skif:IVO" .. idx, 0) / 10
                return val, colorGreen
            elseif row == 9 then
                return Wag:GetNW2Int("Skif:Power" .. idx, 0), colorGreen
            elseif row == 10 then
                return Wag:GetNW2Int("Skif:Dissipated" .. idx, 0), colorGreen
            elseif row == 11 then
                return Wag:GetNW2Int("Skif:Power" .. idx, 0) - Wag:GetNW2Int("Skif:Dissipated" .. idx, 0), colorGreen
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
            if idx > Wag:GetNW2Int("Skif:WagNum", 0) then return end
            if row == 1 then
                return Wag:GetNW2Int("Skif:WagNum" .. idx, "?????")
            -- YandereDev, ty cho?
            elseif row == 2 then
                local val = Wag:GetNW2Bool("Skif:EmerActive" .. idx, false)
                return nil, nil, val and colorGreen or colorRed
            elseif row == 3 then
                local val = Wag:GetNW2Bool("Skif:PTApply" .. idx, false)
                return nil, nil, val and colorGreen or colorRed
            elseif row == 4 then
                local val = Wag:GetNW2Bool("Skif:PBApply" .. idx, false)
                return nil, nil, val and colorGreen or colorRed
            elseif row == 5 then
                local val = Wag:GetNW2Bool("Skif:DPBT" .. idx, false)
                return nil, nil, val and colorGreen or colorRed
            elseif row == 6 then
                local val = Wag:GetNW2Int("Skif:Pskk" .. idx, 0) >= 10
                return nil, nil, val and colorGreen or colorRed
            elseif row == 7 then
                local val = Wag:GetNW2Bool("Skif:BrakeEquip" .. idx, false)
                return nil, nil, val and colorGreen or colorRed
            elseif row == 8 then
                local val = Wag:GetNW2Int("Skif:P" .. idx, 0) / 10
                return val > 0 and string.format("%.1f", val) or "0", colorGreen
            elseif row == 9 then
                local val = Wag:GetNW2Int("Skif:P2" .. idx, 0) / 10
                return val > 0 and string.format("%.1f", val) or "0", colorGreen
            elseif row == 10 then
                local val = Wag:GetNW2Int("Skif:Pnm" .. idx, 0) / 10
                return val > 0 and string.format("%.1f", val) or "0", val >= 5.5 and colorGreen or colorRed
            elseif row == 11 then
                local val = Wag:GetNW2Int("Skif:Ptm" .. idx, 0) / 10
                return val > 0 and string.format("%.1f", val) or "0", val >= 2.9 and colorGreen or colorRed
            elseif row == 12 then
                local val = Wag:GetNW2Int("Skif:Pstt" .. idx, 0) / 10
                return val > 0 and string.format("%.1f", val) or "0", colorGreen
            elseif row == 13 then
                local val = Wag:GetNW2Int("Skif:Pskk" .. idx, 0) / 10
                return val > 0 and string.format("%.1f", val) or "0", colorGreen
            elseif row == 14 then
                local val = Wag:GetNW2Int("Skif:Pauto1" .. idx, 0) / 10
                return val > 0 and string.format("%.1f", val) or "0", val >= 1.0 and colorGreen or colorRed
            elseif row == 15 then
                local val = Wag:GetNW2Int("Skif:Pauto2" .. idx, 0) / 10
                return val > 0 and string.format("%.1f", val) or "0", val >= 1.0 and colorGreen or colorRed
            elseif row == 16 then
                local val = Wag:GetNW2Int("Skif:Pauto3" .. idx, 0) / 10
                return val > 0 and string.format("%.1f", val) or "0", val >= 1.0 and colorGreen or colorRed
            elseif row == 17 then
                local val = Wag:GetNW2Int("Skif:Pauto4" .. idx, 0) / 10
                return val > 0 and string.format("%.1f", val) or "0", val >= 1.0 and colorGreen or colorRed
            end
        end
    end, 26, 1)
end


local sizeVoIndexW, sizeVoIndexH = 220, 48
local sizeVoCellMargin = 16
local voFields = {
    {
        {"БУКСЫ", "Skif:BuksGood"},
        {"МК", function(Wag, idx) return not Wag:GetNW2Bool("Skif:AsyncInverter" .. idx, false) and -2 or Wag:GetNW2Int("Skif:MKState" .. idx, -1) end, function(val) return val > 0 and colorGreen or val > -2 and (val < 0 and colorRed or colorMainDisabled) or nil end},
        {"Освещение", "Skif:LightsWork"},
        {"ТКПР", "Skif:PantDisabled"},
        {"Напряжение КС", "Skif:HVGood"},
        {"ПСН", "Skif:PSNEnabled"},
        {"Рессора", "Skif:RessoraGood"},
        {"БУПУ", "Skif:PUGood"},
        {"БУД", "Skif:BUDWork"},
        {"Ориентация", "Skif:WagOr", function(val) return nil, val and "О" or "П", val and colorYellow or colorGreen end},
    }, {
        {"", "Skif:UKKZ1"},
        {"", "Skif:UKKZ2"},
        {"", "Skif:UKKZ3"},
        {"", "Skif:UKKZ4"},
        {"", function() return true end, function() return nil end},
        {"", function() return true end, function() return nil end},
        {"", function() return true end, function() return nil end},
        {"", function() return true end, function() return nil end},
    }, {
        {"", "Skif:DPBT1"},
        {"", "Skif:DPBT2"},
        {"", "Skif:DPBT3"},
        {"", "Skif:DPBT4"},
        {"", "Skif:DPBT5"},
        {"", "Skif:DPBT6"},
        {"", "Skif:DPBT7"},
        {"", "Skif:DPBT8"},
    }, {
        {"", "Skif:Pant1"},
        {"", "Skif:Pant2"},
        {"", "Skif:Pant3"},
        {"", "Skif:Pant4"},
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
    if voPage == 1 or voPage > 5 then
        draw.SimpleText("Параметр", "Mfdu765.VoLabel", x + sizeVoIndexW / 2, y + sizeVoIndexH - sizeVoCellMargin / 2, colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
    end

    local indexW = voPage > 1 and voPage < 6 and 0 or sizeVoIndexW
    local gx, gy, gw, gh = x + indexW, y + sizeVoIndexH, w - indexW, h - sizeVoIndexH - 4

    if voPage > 5 then
        self:DrawSfPage(Wag, gx, gy, gw, gh, voPage - 5)
        return
    end

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
                return Wag:GetNW2Bool("Skif:HasCabin" .. idx, false) and (Wag:GetNW2Bool("Skif:CondK" .. idx, false) and colorGreen or colorRed) or nil
            end
            return Wag:GetNW2Bool("Skif:Cond" .. field .. idx, false) and colorGreen or colorRed
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

    draw.SimpleText("Режим: " .. (Wag:GetNW2Bool("Skif:Cond", false) and "Лето" or "Зима"), "Mfdu765.BodyTextLarge", x + w / 2 - sizeButtonW / 2, gy + gh + 212, self.Select > 0 and colorBlue or colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    surface.SetDrawColor(Wag:GetNW2Bool("Skif:CondAny", false) and (Wag:GetNW2Bool("Skif:Cond", false) and colorYellow or colorBlue) or colorMain)
    surface.SetMaterial(icons[6][Wag:GetNW2Bool("Skif:Cond", false) and 2 or 1])
    local icw, ich = sizeButtonW * 0.7, sizeFooter * 0.7
    surface.DrawTexturedRect(x + w / 2 + 70, gy + gh + 218 - ich / 2, icw, ich)

    draw.SimpleText("Загрузка: " .. (Wag:GetNW2Bool("Skif:CondAny", false) and "33 %" or "0 %"), "Mfdu765.BodyTextSmall", x + 4, gy + gh + 290, colorMain, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

local mainGridLabels = {
    "Двери", "БВ", "Сбор схемы", "ПТ вкл", "Ст. тормоз", "БУВ", "БТБ гот."
}
local mainGridData = {
    {"Skif:Doors", "Skif:ShowDoors"},
    {"Skif:BV", "Skif:ShowBV"},
    {"Skif:Scheme", "Skif:ShowScheme"},
    {"Skif:PTApply", "Skif:ShowPTApply"},
    {"Skif:PBApply", "Skif:ShowPBApply"},
    {"Skif:BUVState", "Skif:ShowBUVState"},
    {"Skif:BTBReady", "Skif:ShowBTBReady"},
}
local noAsync = { ["Skif:BV"] = true, ["Skif:Scheme"] = true }
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
            return not (not Wag:GetNW2Bool("Skif:AsyncInverter" .. idx, false) and noAsync[mainGridData[field][1]]) and (Wag:GetNW2Bool(mainGridData[field][1] .. idx, false) and colorGreen or colorRed) or nil
        end,
        function(field)
            return mainGridDraw[field]
        end
    )
end

local autodriveTagLabels = { "Данные метки:" }
local autodriveTagHeader = { "1", "2", "3", "4", "5", "6", "7", "8" }
local autodriveDetailLabels = { "Активация АВП:", "Нагон АВП:", "Режим КОС:", "Режим ПРОСТ:", "Таймер метки:", "Кол-во чтений метки:"}
local autodriveDetailHeader = { "" }
function TRAIN_SYSTEM:DrawAutodrive(Wag, x, y, w, h)
    local gx, gy, gw, gh = x + 200, y + 375, w - 210, 50
    self:DrawGrid(
        gx, gy, gw, gh, true, sizeMainMargin * 0.75,
        autodriveTagLabels, "Mfdu765.28",
        autodriveTagHeader, "Mfdu765.28",
        sizeMainMargin, 6,
        function(idx)
            return nil, string.format("%02X", Wag:GetNW2Int("Skif:ProstData" .. idx, 0)), colorMain, "Mfdu765.AutodriveVals"
        end
    )

    gx, gy, gw, gh = x + w / 3.3, y + 10, 180, h - 110
    self:DrawGrid(
        gx, gy, gw, gh, true, 0,
        autodriveDetailLabels, "Mfdu765.28",
        autodriveDetailHeader, "Mfdu765.28",
        sizeMainMargin * 2, 0,
        function(_, field)
            if field == 1 then
		local active = Wag:GetNW2Int("Skif:AVP:State", 0) > 0
                return active and colorGreen or colorMainDisabled, active and "Активен" or "Отключен", active and colorBlack or colorMain
            elseif field == 5 then
                return nil, string.format("%08d", Wag:GetNW2Int("Skif:ProstDist", 0)), colorMain, "Mfdu765.AutodriveVals"
            elseif field == 6 then
                return nil, Wag:GetNW2Int("Skif:ProstReadings", 0), colorMain, "Mfdu765.AutodriveVals"
            else
                return "toggle", field == 2 and Wag:GetNW2Bool("Skif:AVP:Boost", false) or field == 3 and Wag:GetNW2Bool("Skif:Kos", false) or field == 4 and Wag:GetNW2Bool("Skif:Prost", false)
            end
        end,
        function(field)
            return field > 1 and self.Select == field - 1 and colorBlue or true
        end
    )
end

function TRAIN_SYSTEM:DrawSfPage(Wag, x, y, w, h, pg)
    if not self.SfLabels then
        self.SfLabels = {}
        self.SfGetters = {}
        for p, sfs in ipairs(self.SFTbl) do
            self.SfLabels[p] = {}
            self.SfGetters[p] = {}
            local prevName = nil
            for sf, name in pairs(sfs) do
                if prevName and name == prevName and name ~= "Питание ЦУ" then
                    table.insert(self.SfGetters[p][#self.SfGetters[p]], sf)
                else
                    table.insert(self.SfGetters[p], {sf})
                    table.insert(self.SfLabels[p], name)
                    prevName = name
                end
            end
        end
    end

    self:DrawGrid(
        x, y, w, h, true, {2, sizeVoCellMargin},
        self.SfLabels[pg], "Mfdu765.VoLabel",
        true, "Mfdu765.VoLabel",
        0, sizeVoCellMargin / 2,
        function(idx, field)
            for _, sf in ipairs(self.SfGetters[pg][field]) do
                if not Wag:GetNW2Bool("Skif:Sf" .. sf .. idx, false) then
                    return colorRed
                end
            end
            return colorGreen
        end
    )
end

local sizeMsgDate, sizeMsgTime, sizeMsgCat = 80, 80, 40
local sizeMsgHeader, sizeMsgFooter = 40, 50
local msgNull = {timeAppeared = "--:--:--"}
function TRAIN_SYSTEM:DrawMessages(Wag, x, y, w, h)
    local ver = Wag:GetNW2Int("Skif:LogVer", -1)
    if self.MsgVer ~= ver then
        self.MsgData = {}
        for idx = 1, Wag:GetNW2Int("Skif:LogLen", 0) do
            local solved = Wag:GetNW2String("Skif:LogSolved" .. idx, "")
            table.insert(self.MsgData, {
                text = Wag:GetNW2String("Skif:LogMsg" .. idx, ""),
                cat = Wag:GetNW2String("Skif:LogCat" .. idx, ""),
                dateAppeared = Wag:GetNW2String("Skif:LogApDate" .. idx, ""),
                timeAppeared = Wag:GetNW2String("Skif:LogApTime" .. idx, ""),
                timeSolved = solved ~= "" and solved or nil,
            })
        end
        self.MsgVer = ver
    end

    local x0, y0 = x, y
    local sizeMsgText = w - sizeMsgDate - sizeMsgTime - sizeMsgCat - sizeBorder * 3
    local sizeMsgH = (h - sizeMsgHeader - sizeMsgFooter - sizeBorder * 2) / 26
    x, y = x + sizeMsgDate / 2, y + sizeMsgHeader / 2
    draw.SimpleText("Дата", "Mfdu765.28", x, y - 2, colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    x = x + sizeMsgDate / 2 + sizeBorder + sizeMsgTime / 2
    draw.SimpleText("Время", "Mfdu765.28", x, y - 2, colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    x = x + sizeMsgTime / 2 + sizeBorder + sizeMsgCat / 2
    draw.SimpleText("Тип", "Mfdu765.28", x, y - 2, colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    x = x + sizeMsgCat / 2 + sizeBorder + sizeMsgText / 2
    draw.SimpleText("Описание сообщения", "Mfdu765.28", x, y - 2, colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    local textX = x
    local selected = self.Select > 0 and self.Select or 1
    x, y = x0, y0 + sizeMsgHeader + sizeBorder
    for idx, msg in ipairs(self.MsgData or {}) do
        local textColor = selected == idx and colorBlack or colorMain
        if selected == idx then
            surface.SetDrawColor(colorBlue)
            surface.DrawRect(x, y, w, sizeMsgH)
        end
        x = x + sizeMsgDate / 2
        draw.SimpleText(msg.dateAppeared, "Mfdu765.24", x, y + sizeMsgH / 2 - 2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        x = x + sizeMsgDate / 2 + sizeBorder + sizeMsgTime / 2
        draw.SimpleText(msg.timeAppeared, "Mfdu765.24", x, y + sizeMsgH / 2 - 2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        x = x + sizeMsgTime / 2 + sizeBorder + sizeMsgCat / 2
        draw.SimpleText(msg.cat, "Mfdu765.24", x, y + sizeMsgH / 2 - 2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        x = x + sizeMsgCat / 2 + sizeBorder + 2
        draw.SimpleText(msg.text, "Mfdu765.24", x, y + sizeMsgH / 2 - 2, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        x = x0
        y = y + sizeMsgH
    end

    surface.SetDrawColor(colorMainDisabled)
    surface.DrawRect(x0, y0 + sizeMsgHeader, w, sizeBorder)
    surface.DrawRect(x0, y0 + h - sizeMsgFooter - sizeBorder, w, sizeBorder)
    x = x0
    x = x + sizeMsgDate
    surface.DrawRect(x, y0, sizeBorder, h - sizeMsgFooter)
    x = x + sizeBorder + sizeMsgTime
    surface.DrawRect(x, y0, sizeBorder, h - sizeMsgFooter)
    x = x + sizeBorder + sizeMsgCat
    surface.DrawRect(x, y0, sizeBorder, h - sizeMsgFooter)

    x = x0 + sizeMsgDate + sizeBorder / 2
    y = y0 + h - sizeMsgFooter / 2
    local msg = self.MsgData and self.MsgData[selected] or msgNull
    draw.SimpleText("Возник:", "Mfdu765.28", x - 2, y - 2, colorMain, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    draw.SimpleText(msg.timeAppeared, "Mfdu765.28.600", x + 2, y - 2, msg.timeSolved and colorGreen or colorRed, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    x = textX
    if not msg.timeSolved then
        draw.SimpleText("Не устранен", "Mfdu765.28", x, y - 2, colorRed, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    else
        draw.SimpleText("Устранен:", "Mfdu765.28", x - 2, y - 2, colorMain, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        draw.SimpleText(msg.timeSolved, "Mfdu765.28.600", x + 2, y - 2, colorGreen, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
end

local pvuTable = {
    { "Skif:Doors", "Двери" },
    { function(Wag, idx) return Wag:GetNW2Int("Skif:MKState" .. idx, -1) >= 0 end, "МК" },
    { "Skif:LightsWork", "Свет" },
    { "Skif:PantDisabled", "ТкПр" },
    { "Skif:TPEnabled", "ТП" },
    { "Skif:PSNEnabled", "ПСН" },
    { "Skif:BV", "БВ" },
}
function TRAIN_SYSTEM:DrawPvu(Wag, x, y, w, h)
    local x0 = x + sizeMainMargin
    x = x0
    y = y + sizeMainMargin

    local cw = (w - sizeMainMargin - sizeBorder - sizeMainMargin * 8) / 8
    local ch = (h - sizeMainMargin - sizeBorder - sizeMainMargin * 8) / 8
    local selWag = Wag:GetNW2Int("Skif:PvuWag", 0)
    local sel = Wag:GetNW2Int("Skif:PvuSel", 0)

    for idx = 1, self.WagNum do
        drawBox(x, y, cw, ch, colorMain, colorBlack, sizeBorder)
        draw.SimpleText(tostring(Wag:GetNW2Int("Skif:WagNum" .. idx, "?????")), "Mfdu765.PvuWag", x + cw / 2 - 2, y + ch / 2, selWag == idx and colorBlue or colorMain, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        x = x + cw + sizeMainMargin
    end
    x = x0
    y = y + ch + sizeMainMargin

    for pvu, pv in ipairs(pvuTable) do
        local getter, name = unpack(pv)
        for idx = 1, self.WagNum do
            if Wag:GetNW2Bool("Skif:AsyncInverter" .. idx, false) or (pvu ~= 2 and pvu ~= 5 and pvu ~= 7) then
                local val = isfunction(getter) and getter(Wag, idx) or not isfunction(getter) and Wag:GetNW2Bool(getter .. idx, false)
                local pvuVal = Wag:GetNW2Bool("Skif:PVU" .. pvu .. idx, false)
                drawBox(x, y, cw, ch, pvuVal and colorRed or colorMain, idx == selWag and sel == pvu and colorBlue or colorBlack, sizeButtonBorder)
                draw.SimpleText(name, "Mfdu765.24", x + cw / 2 - 2, y + ch / 2, val and colorGreen or colorRed, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
            x = x + cw + sizeMainMargin
        end
        x = x0
        y = y + ch + sizeMainMargin
    end
end
