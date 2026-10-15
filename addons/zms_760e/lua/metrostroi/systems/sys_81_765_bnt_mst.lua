--------------------------------------------------------------------------------
-- Блок наддверного табло ЦИК «Метроспецтехника» v1 (бегущая строка)
-- Автор - ZONT_ a.k.a. enabled person
--------------------------------------------------------------------------------
Metrostroi.DefineSystem("81_765_BNT_MST")
TRAIN_SYSTEM.DontAccelerateSimulation = true

function TRAIN_SYSTEM:Initialize()
end

function TRAIN_SYSTEM:Outputs()
end

function TRAIN_SYSTEM:Inputs()
    return {}
end

if TURBOSTROI then return end
function TRAIN_SYSTEM:TriggerInput(name, value)
end

function TRAIN_SYSTEM:Think(dT)
end


if not CLIENT then return end


local scw_display, sch_display = 2080, 128
local scw_strip, sch_strip = 4096, 364
local led_offset_x, led_offset_y = 0, -2
local ft_strip = 0.4

local color_white = Color(255, 255, 255)
local color_off = Color(128, 128, 128)
local color_green = Color(62, 255, 62)
local color_red = Color(255, 24, 24)
local color_eng = Color(255, 178, 62)
local color_ru = Color(105, 255, 125)
local tex_screen = surface.GetTextureID("81-765_v1_assets/rt/mst_led_screen")
local tex_led_on = surface.GetTextureID("81-765_v1_assets/rt/mst_led_on")
local tex_led_off = surface.GetTextureID("81-765_v1_assets/rt/mst_led_off")
local tex_arrow = surface.GetTextureID("81-765_v1_assets/rt/mst_arrow")
local tex_x = surface.GetTextureID("81-765_v1_assets/rt/mst_x")

surface.CreateFont("CIK765.BntMst", {
    font = "BntMst1_v1",
    size = 112,
    weight = 0,
    blursize = false,
    antialias = false,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = true,
    outline = false,
    extended = true,
    scanlines = false,
})


function TRAIN_SYSTEM:ClientInitialize()
    self.Font = "CIK765.BntMst"
end

function TRAIN_SYSTEM:ClientThink()
    local Wag = self.Train
    if Wag:GetNW2Int("BntType", 1) ~= 3 then return end
    local BNT = Wag.BNT
    self.Working = Wag:GetNW2Bool("BNT:Working", false)

    if not self.NextDrawStrip or CurTime() >= self.NextDrawStrip then
        self.NextDrawStrip = CurTime() + ft_strip
        if BNT and (BNT:ShouldDrawPanel("BNT_MST_STRIP_L") or BNT:ShouldDrawPanel("BNT_MST_STRIP_R")) then
            render.PushRenderTarget(self.Train.Bnt_MST_Strip, 0, 0, scw_strip, sch_strip)
            render.Clear(0, 0, 0, 0)
            cam.Start2D()
            self:DrawStrip()
            cam.End2D()
            render.PopRenderTarget()
        end
    end

    if BNT and BNT:ShouldDrawPanel("BNT_MST_L") then
        render.PushRenderTarget(self.Train.LBnt_MST, 0, 0, scw_display, sch_display)
        render.Clear(0, 0, 0, 0)
        cam.Start2D()
        self:DrawDisplay(true)
        cam.End2D()
        render.PopRenderTarget()
    end
    if BNT and BNT:ShouldDrawPanel("BNT_MST_R") then
        render.PushRenderTarget(self.Train.RBnt_MST, 0, 0, scw_display, sch_display)
        render.Clear(0, 0, 0, 0)
        cam.Start2D()
        self:DrawDisplay(false)
        cam.End2D()
        render.PopRenderTarget()
    end
end


local function update_cfg(Wag, scheme, route)
    local bntCfg = Metrostroi.BntSchemes765 and Metrostroi.BntSchemes765[scheme]
    if not bntCfg then return end
    local mstLed = bntCfg and bntCfg[route] and bntCfg[route].MstLed
    if not mstLed then mstLed = {} end

    local otherLeds = {}
    local ledMap = {}
    for _, cur_led in ipairs(mstLed) do
        ledMap[Format("%d_%d", cur_led[1], cur_led[2])] = true
    end
    for idx, otherCfg in ipairs(bntCfg) do
        local leds = otherCfg.MstLed
        if leds and idx ~= route then
            for _, cur_led in ipairs(leds) do
                if not ledMap[Format("%d_%d", cur_led[1], cur_led[2])] then
                    table.insert(otherLeds, cur_led)
                end
            end
        end
    end
    mstLed.other = otherLeds
    return mstLed
end

local function draw_station(x, y, idx, size, color, elapsed, enroute, counter)
    surface.SetDrawColor(enroute and (counter and color_green or color_off) or elapsed and color or color_off)
    surface.SetTexture((enroute and counter or not enroute and elapsed) and tex_led_on or tex_led_off)
    surface.DrawTexturedRectRotated(x, y, size, size, (idx * 243.786) % 360)
end

function TRAIN_SYSTEM:DrawStrip()
    local Wag = self.Train

    local bnt = Wag.BNT
    local sarmat = Wag.BNT_SARMAT
    if not sarmat or not bnt then return end

    local route = Wag:GetNW2Int("BNT:Route", 1)
    local scheme = Wag:GetNW2Int("Scheme765", 1)
    if self.BntCfgVer ~= Metrostroi.BntSchemes765Ver or self.Route ~= route or self.Scheme ~= scheme then
        self.BntCfgVer = Metrostroi.BntSchemes765Ver
        self.Route = route
        self.Scheme = scheme
        self.MstLed = update_cfg(Wag, scheme, route)
    end
    local mst_led = self.MstLed

    local station_idx = sarmat.StationIdx
    local path = sarmat.Path
    local depart = sarmat.Depart

    local station = bnt.Stations[station_idx]

    local power = Wag:GetNW2Bool("BNT:PowerLeft", false) or Wag:GetNW2Bool("BNT:PowerRight", false)
    local color = bnt.LineColorBright or color_white
    local cur_idx = station and station.ledIdx
    self.Counter = not self.Counter

    -- MST config
    if mst_led then
        for idx, cur_led in ipairs(mst_led) do
            local elapsed = cur_idx and (not path and cur_idx >= idx or path and idx >= cur_idx)
            draw_station(cur_led[1] + led_offset_x, cur_led[2] + led_offset_y, idx, cur_led.size, color, elapsed, idx == cur_idx and depart, self.Counter)
        end
        for idx, cur_led in ipairs(mst_led.other) do
            draw_station(cur_led[1] + led_offset_x, cur_led[2] + led_offset_y, idx + #mst_led, cur_led.size, color, false, false, false)
        end
        return
    end

    if not cur_idx then return end
    if not power then return end

    -- Fallback
    local led = bnt.LED
    if not led or bnt.LedSum < 1 then return end

    local k = (scw_strip - 64) / bnt.LedSum
    local x = 32
    local y0 = math.floor(sch_strip * 0.45)

    for idx, cur_led in ipairs(led) do
        local elapsed = not path and cur_idx >= idx or path and idx >= cur_idx
        local x1 = x + k * cur_led / 2
        draw_station(x1, y0, idx, 32, color, elapsed, idx == cur_idx and depart, self.Counter)
        x = x + k * cur_led
    end
end

local led_size = 8
local icon_size = 16 * led_size
local icon_box = icon_size + 3 * led_size
local string_w = scw_display - icon_box * 2
function TRAIN_SYSTEM:DrawDisplay(left)
    local Wag = self.Train

    local bnt = Wag.BNT
    local sarmat = Wag.BNT_SARMAT
    if not sarmat or not bnt then return end

    local power = left and Wag:GetNW2Bool("BNT:PowerLeft", false) or not left and Wag:GetNW2Bool("BNT:PowerRight", false)
    local looped = sarmat.DrawDisplay(self, power, left, icon_box, 8, string_w, sch_display, tex_screen, 2048, 64, 4096, 128)
    if not power then return end

    local cache_invalidated = looped
    local station_idx = sarmat.StationIdx
    local terminus = sarmat.Terminus
    local arrived = sarmat.Arrived or sarmat.InitDone
    local depart = sarmat.Depart

    local exit_here = Wag:GetNW2Bool(left and "BNT:SelectLeft" or "BNT:SelectRight", false)
    local tex = exit_here and tex_arrow or tex_x
    local color = arrived and exit_here and color_ru or color_red

    render.OverrideBlend(
        true,
        BLEND_SRC_ALPHA, BLEND_ONE,                 BLENDFUNC_ADD,
        BLEND_DST_ALPHA, BLEND_ONE_MINUS_SRC_ALPHA, BLENDFUNC_ADD
    )    surface.SetDrawColor(color)
    surface.SetTexture(tex)
    surface.DrawTexturedRect(led_size * 2, 0, icon_size, icon_size)
    surface.DrawTexturedRect(scw_display - icon_box + led_size, 0, icon_size, icon_size)
    render.OverrideBlend(false)

    local cache_state = (
        not self.Working and "w" or
        Format(
            "%s%d",
            terminus and "t" or
            arrived and "a" or
            "d",
            station_idx
        )
    )

    if cache_state ~= self.CacheState then
        self.CacheState = cache_state
        self.LoopCnt = 0
        cache_invalidated = true
    end

    if not cache_invalidated then return end

    local station = bnt.Stations and bnt.Stations[station_idx]

    if station then
        local eng = self.LoopCnt % 2 == 1 and station.nameEng
        if terminus then
            self.Text = sarmat.CacheText(self, eng and "This train terminates here. Please leave the train." or "Конечная. Поезд дальше не идет. Пожалуйста, выйдите из вагонов.", true)
            self.Text.color = eng and color_eng or color_red
            return
        elseif depart then
            self.Text = sarmat.CacheText(self, eng and "the next station is " .. eng or "следующая станция " .. station.name, true)
            self.Text.color = eng and color_eng or color_ru
            return
        elseif arrived then
            self.Text = sarmat.CacheText(self, eng or station.name, true)
            self.Text.color = eng and color_eng or color_ru
            return
        end
    end

    self.Text = sarmat.CacheText(self, "Цифровой информационный комплекс КБ МЕТРОСПЕЦТЕХНИКА", true)
    self.Text.color = color_eng
end
