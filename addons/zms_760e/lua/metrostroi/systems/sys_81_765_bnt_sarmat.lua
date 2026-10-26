--------------------------------------------------------------------------------
-- Блок наддверного табло ЦИК «Сармат» v1 (бегущая строка)
-- Автор - ZONT_ a.k.a. enabled person
--------------------------------------------------------------------------------
Metrostroi.DefineSystem("81_765_BNT_SARMAT")
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


local scw, sch = 2040, 280
local text_speed = 720  -- px/s
local run_speed = 12  -- led/s
local tex2scr = scw / 3430
local tex2scr_offset = 46

local led_size = 8
local icon_size = 20 * led_size
local string_w = scw - icon_size - led_size
local string_h = 20 * led_size
local strip_w = scw
local strip_h = led_size * 4

local color_default = Color(70, 245, 221)
local color_red = Color(241, 57, 57)
local tex_screen = surface.GetTextureID("81-765_v1_assets/rt/sarmat_led_screen")
local tex_arrow = surface.GetTextureID("81-765_v1_assets/rt/sarmat_arrow")
local tex_x = surface.GetTextureID("81-765_v1_assets/rt/sarmat_x")

surface.CreateFont("CIK765.BntSarmat", {
    font = "BntSarmat1_v1",
    size = 128,
    weight = 0,
    blursize = false,
    antialias = true,
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
    self.Font = "CIK765.BntSarmat"
end

function TRAIN_SYSTEM:ClientThink()
    local Wag = self.Train

    self.Working = Wag:GetNW2Bool("BNT:Working", false)
    self:UpdateState()

    if Wag:GetNW2Int("BntType", 1) ~= 4 then return end

    local BNT = Wag.BNT
    if BNT and BNT:ShouldDrawPanel("BNT_SARMAT_L") then
        render.PushRenderTarget(self.Train.LBnt_Sarmat, 0, 0, scw, sch)
        render.Clear(0, 0, 0, 0)
        cam.Start2D()
        self:DrawBnt(true)
        cam.End2D()
        render.PopRenderTarget()
    end
    if BNT and BNT:ShouldDrawPanel("BNT_SARMAT_R") then
        render.PushRenderTarget(self.Train.RBnt_Sarmat, 0, 0, scw, sch)
        render.Clear(0, 0, 0, 0)
        cam.Start2D()
        self:DrawBnt(false)
        cam.End2D()
        render.PopRenderTarget()
    end
end

function TRAIN_SYSTEM:UpdateState()
    local Wag = self.Train
    local station_idx = Wag:GetNW2Int("BNT:Station", 0)
    local terminus = Wag:GetNW2Bool("BNT:Terminus", false)
    local arrived_time = Wag:GetNW2Int("BNT:ArrivedAnim", 0) / 10
    local depart_time = Wag:GetNW2Int("BNT:DepartAnim", 0) / 10
    local init_time = Wag:GetNW2Int("BNT:InitDoneAnim", 0) / 10
    local init_done = init_time > arrived_time and init_time > depart_time
    local arrived = not init_done and depart_time < arrived_time
    arrived = not terminus and arrived or terminus and arrived and CurTime() - arrived_time < 6
    terminus = terminus and not arrived
    local depart = self.Working and not init_done and not arrived and not terminus

    local stations = Wag.BNT and Wag.BNT.Stations
    local loop = Wag:GetNW2Int("BNT:Loop", 0) > 0
    local stlen = loop and #stations

    self.StationIdx = station_idx
    self.Station = stations and stations[stlen and station_idx > stlen and (station_idx % stlen) or station_idx]
    self.InitDone = init_done
    self.Terminus = terminus
    self.Arrived = arrived
    self.Depart = depart
    self.Path = Wag:GetNW2Bool("BNT:Path", false)
    self.Loop = loop
end


-- Hardcoded characters that our font supports
local valid_seq = " .,АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдеёжзийклмнопрстуфхцчшщъыьэюяABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzЄєІіЇїЎўҐґ"
local valid_map = {}
for _, cp in utf8.codes(valid_seq) do
    valid_map[cp] = true
end
local function sanitize_text(text)
    local seq = {}
    for _, cp in utf8.codes(utf8.force(text)) do
        table.insert(seq, utf8.char(cp ~= 0xFFFD and valid_map[cp] and cp or 0xFFFD))
    end
    return seq
end

local function print_text(char_seq, tx, x0, y0, w, h, font, color)
    local x = math.Round(tx / led_size) * led_size + x0
    render.OverrideBlend(
        true,
        BLEND_SRC_ALPHA, BLEND_ONE,                 BLENDFUNC_ADD,
        BLEND_DST_ALPHA, BLEND_ONE_MINUS_SRC_ALPHA, BLENDFUNC_ADD
    )
    render.SetScissorRect(x0, 0, x0 + w, h, true)
    surface.SetFont(font)
    surface.SetTextColor(color or color_default)
    for idx, chr in ipairs(char_seq) do
        surface.SetTextPos(x, y0)
        surface.DrawText(chr)
        local x1 = surface.GetTextPos()
        x = x1 + led_size
    end
    render.SetScissorRect(0, 0, 0, 0, false)
    render.OverrideBlend(false)
end

local function draw_station(x, y0, top, bot)
    surface.DrawRect(x, y0 + 8, 8, 16)
    if top then surface.DrawRect(x + 8, y0, 16, 8) end
    if bot then surface.DrawRect(x + 8, y0 + 24, 16, 8) end
    surface.DrawRect(x + 24, y0 + 8, 8, 16)
end

local empty_table = {}
local function draw_strip(Wag, depart, station, path)
    local bnt = Wag.BNT
    local led = bnt and bnt.LED
    if not led or bnt.LedSum < 1 then return end
    if not station or not (station.ledIdx or station.ledIdxSarmat) then return end

    local k = strip_w / bnt.LedSum
    local x0, x = 0, 0
    local y0 = sch - strip_h - 5
    local y1 = y0 + led_size
    local strh = led_size * 2
    local cur_idx = station.ledIdxSarmat or station.ledIdx
    local absolute = led.absolute
    local align_right = not absolute and led.alignRight

    render.OverrideBlend(true, BLEND_ONE, BLEND_ONE, BLENDFUNC_ADD, BLEND_ZERO, BLEND_ONE, BLENDFUNC_ADD)
    surface.SetDrawColor(led.Color and bnt:GetCachedColor(led.Color) or bnt.LineColorBright or color_default)

    local ledlen = #led
    for idx = 1, ledlen + 1 do
        local extra = idx > ledlen
        local cur_led = idx > ledlen and strip_w or led[idx]
        local d = empty_table
        if istable(cur_led) then d = cur_led; cur_led = d[1] end

        local station_draw = not path and cur_idx >= idx or path and idx >= cur_idx
        local path_draw = not path and cur_idx >= idx or path and idx > cur_idx

        local x1
        if not extra then
            x1 = absolute and ((cur_led - tex2scr_offset) * tex2scr) or (x + k * cur_led / (align_right and 1 or 2))
            x1 = math.Clamp(
                math.Round(x1 / led_size) * led_size - 2 * led_size,
                0, scw - 4 * led_size
            )
        else
            x1 = cur_led
        end

        local in_progress = path_draw and depart and (not path and idx == cur_idx or path and idx == cur_idx + 1)
        local both = idx == cur_idx or not d.top and not d.bot
        if station_draw and not extra then draw_station(x1, y0, both or d.top, both or d.bot) end

        if path_draw then
            local distance = x1 - x0
            if in_progress then
                local led_distance = math.ceil(distance / led_size) - 1
                local run_time = (led_distance + 7) / run_speed
                local progress = math.floor((led_distance + 7) * (CurTime() % run_time) / run_time) - 1
                for i = 0, led_distance do
                    if progress > i or i % 2 == 0 then
                        surface.DrawRect(not path and (x0 + led_size * i) or (x1 - led_size * (i + 1)), y1, led_size, strh)
                    end
                end
                station_draw = station_draw and progress > led_distance + 2
                if path then
                    if station_draw then
                        surface.DrawRect(x0 - led_size * 3, y1, strh, strh)
                    else
                        station_draw = true
                    end
                end
            else
                surface.DrawRect(x0, y1, distance, strh)
            end
        end

        if station_draw and (not depart or path_draw) then
            surface.DrawRect(x1 + led_size, y1, strh, strh)
        end

        if not absolute and not extra then x = x + k * cur_led end
        x0 = x1 + 4 * led_size
    end

    render.OverrideBlend(false)
end

function TRAIN_SYSTEM:CacheText(text, looped)
    local seq = sanitize_text(text)
    local x = 0
    surface.SetFont(self.Font)
    for idx, chr in ipairs(seq) do
        local w = surface.GetTextSize(chr)
        x = x + w + 8
    end
    return {
        char_seq = seq,
        width = math.max(0, x - 8),
        x = looped and string_w + led_size or 120,
        delay = looped and 0 or CurTime() + 2.0
    }
end

function TRAIN_SYSTEM:DrawDisplay(power, primary, text_x0, text_y0, text_w, text_h, screen_tex, tex_x0, tex_y0, w, h)
    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetTexture(screen_tex)
    surface.DrawTexturedRectRotated(tex_x0, tex_y0, w, h, 0)

    if not power then return false end

    local text = self.Text
    if text and text.x >= -text.width and text.x <= text_w then
        print_text(text.char_seq, text.x, text_x0, text_y0, text_w, text_h, self.Font, text.color)
    end

    if not primary then return end

    if not self.LastDraw then self.LastDraw = CurTime() return false end
    local dT = CurTime() - self.LastDraw
    self.LastDraw = CurTime()

    local looped = false
    self.LoopCnt = self.LoopCnt or 0

    if text and text.delay >= 0 and CurTime() >= text.delay then
        text.x = text.x - text_speed * dT
        if text.x < -text.width - text_w * 0.2 then
            text.x = text_w + led_size * 2
            self.LoopCnt = (self.LoopCnt + 1) % 2
            looped = true
        end
    end

    return looped
end

function TRAIN_SYSTEM:DrawBnt(left)
    local Wag = self.Train
    local power = left and Wag:GetNW2Bool("BNT:PowerLeft", false) or not left and Wag:GetNW2Bool("BNT:PowerRight", false)

    local looped = self:DrawDisplay(power, left, 0, 16, string_w, string_h, tex_screen, 1024, 128, 2048, 256)

    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetTexture(tex_screen)
    surface.DrawTexturedRectRotated(1024, 128 + sch - 37, 2048, 256, 0)

    local station_idx = self.StationIdx
    local station = self.Station
    local init_done = self.InitDone
    local terminus = self.Terminus
    local arrived = self.Arrived
    local depart = self.Depart

    if power then
        if arrived then
            local exit_here = Wag:GetNW2Bool(left and "BNT:SelectLeft" or "BNT:SelectRight", false)
            surface.SetDrawColor(exit_here and color_default or color_red)
            surface.SetTexture(exit_here and tex_arrow or tex_x)
            surface.DrawTexturedRectRotated(scw - 80, string_h / 2, 160, 160, 0)
        end
        if self.Working and (arrived or depart or terminus) then
            draw_strip(Wag, depart, station, self.Path)
        end
    end

    if not left then return end

    local cache_invalidated = looped

    local cache_state = (
        not self.Working and "w" or
        init_done and "i" or
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
        self.LoopOverride = nil
        cache_invalidated = true
    end
    if self.LoopOverride and CurTime() >= self.LoopOverride then
        self.LoopOverride = nil
        self.LoopCnt = (self.LoopCnt + 1) % 2
        cache_invalidated = true
    end

    if not self.Working then
        if cache_invalidated then
            self.Text = self:CacheText("Цифpoвoй информaционный кoмплекc HПП \"CAPMAT\" г.Рocтoв-нa-Дoну.", true)
        end
        return
    end

    if init_done then
        if cache_invalidated then
            self.Text = self:CacheText("Файл загружен")
            self.Text.x = led_size
            self.Text.delay = -1
        end
        return
    end

    if not cache_invalidated then return end

    if not Wag.BNT or not Wag.BNT.Stations then
        self.CacheState = nil
        return
    end

    if not station or not station.name then
        self.Text = self:CacheText("Ошибка чтения из файла")
        self.Text.x = led_size
        self.Text.delay = -1
        return
    end
    local eng = self.LoopCnt % 2 == 1 and station.nameEng
    local ru = not eng
    if terminus then
        self.Text = self:CacheText(ru and "Конечная. Поезд дальше не идет. Просьба выйти из вагонов." or "The train terminates here. Please leave the train.")
    elseif arrived then
        self.Text = self:CacheText(eng and eng .. " station" or "Станция " .. station.name)
        if self.Text.width <= string_w - 120 and ru then
            self.LoopOverride = CurTime() + 1.8
        end
    else
        self.Text = self:CacheText(eng and "Next station is " .. eng or "Следующая станция " .. station.name, true)
    end
end
