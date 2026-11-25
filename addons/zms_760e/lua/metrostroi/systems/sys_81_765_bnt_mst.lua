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
local led_offset_x, led_offset_y = -1, -2
local ft_strip = 0.4

local led_size = 8
local icon_size = 16 * led_size
local icon_box = icon_size + 3 * led_size
local string_w = scw_display - icon_box * 2

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
local tex_arrow_b = Metrostroi765GetBlurredTex("765_TexB_MstArrow", tex_arrow, icon_size, icon_size, 4, 4)
local tex_x_b = Metrostroi765GetBlurredTex("765_TexB_MstX", tex_x, icon_size, icon_size, 4, 4)

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

surface.CreateFont("CIK765.BntMst.B", {
    font = "BntMst1_v1",
    size = 112,
    weight = 0,
    blursize = 16,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = true,
    additive = true,
    outline = true,
    extended = true
})


function TRAIN_SYSTEM:ClientInitialize()
    self.Font = "CIK765.BntMst"
    self.FontBlur = "CIK765.BntMst.B"
end

function TRAIN_SYSTEM:ClientThink()
    local Wag = self.Train

    if Wag:GetNW2Int("BntType", 1) ~= 3 then return end

    local BNT = Wag.BNT
    self.Working = Wag:GetNW2Bool("BNT:Working", false)

    if not self.NextDrawStrip or CurTime() >= self.NextDrawStrip then
        self.NextDrawStrip = CurTime() + ft_strip
        self.GlowingDots = {}
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


function TRAIN_SYSTEM:DrawStation(x, y, idx, size, color, elapsed, enroute, counter)
    local tex = (enroute and counter or not enroute and elapsed) and tex_led_on or tex_led_off
    color = enroute and (counter and enroute or color_off) or elapsed and color or color_off
    surface.SetDrawColor(color)
    surface.SetTexture(tex)
    surface.DrawTexturedRectRotated(x, y, size, size, (idx * 243.786) % 360)
    if tex == tex_led_on or enroute and not counter then
        table.insert(self.GlowingDots, { x = x, y = y, color = color, unlit = enroute and not counter })
    end
end

function TRAIN_SYSTEM:DrawStrip()
    local Wag = self.Train

    local bnt = Wag.BNT
    local sarmat = Wag.BNT_SARMAT
    if not sarmat or not bnt then return end

    local path = sarmat.Path
    local depart = sarmat.Depart
    local station = sarmat.Station
    local mst_led = bnt.MstLed

    local power = Wag:GetNW2Bool("BNT:PowerLeft", false) or Wag:GetNW2Bool("BNT:PowerRight", false)
    local color = mst_led and mst_led.Color and bnt:GetCachedColor(mst_led.Color) or bnt.LineColorBright or color_white
    local enroute_color = mst_led and mst_led.EnrouteColor and bnt:GetCachedColor(mst_led.EnrouteColor) or color_green
    local cur_idx = station and (station.ledIdxMst or station.ledIdx)
    self.Counter = not self.Counter

    -- MST config
    if mst_led then
        for idx, cur_led in ipairs(mst_led) do
            local elapsed = cur_idx and (not path and cur_idx >= idx or path and idx >= cur_idx)
            self:DrawStation(cur_led[1] + led_offset_x, cur_led[2] + led_offset_y, idx, cur_led.size, color, elapsed, idx == cur_idx and depart and enroute_color, self.Counter)
        end
        for idx, cur_led in ipairs(mst_led.other) do
            self:DrawStation(cur_led[1] + led_offset_x, cur_led[2] + led_offset_y, idx + #mst_led, cur_led.size, color, false, false, false)
        end
        return
    end

    -- Fallback
    if not cur_idx then return end
    if not power then return end

    local led = bnt.LED
    if not led or bnt.LedSum < 1 then return end

    local k = (scw_strip - 512) / bnt.LedSum
    local x = 256
    local y0 = math.floor(sch_strip * 0.45)

    for idx, cur_led in ipairs(led) do
        local elapsed = not path and cur_idx >= idx or path and idx >= cur_idx
        local x1 = x + k * cur_led / 2
        self:DrawStation(x1, y0, idx, 42, color, elapsed, idx == cur_idx and depart and enroute_color, self.Counter)
        x = x + k * cur_led
    end
end

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
    local station = sarmat.Station
    local terminus = sarmat.Terminus
    local arrived = sarmat.Arrived or sarmat.InitDone
    local depart = sarmat.Depart

    local exit_here = Wag:GetNW2Bool(left and "BNT:SelectLeft" or "BNT:SelectRight", false)
    local tex = exit_here and tex_arrow or tex_x
    local tex_b = exit_here and tex_arrow_b or tex_x_b
    local color = arrived and exit_here and color_ru or color_red

    render.OverrideBlend(
        true,
        BLEND_SRC_ALPHA, BLEND_ONE,                 BLENDFUNC_ADD,
        BLEND_DST_ALPHA, BLEND_ONE_MINUS_SRC_ALPHA, BLENDFUNC_ADD
    )
        surface.SetDrawColor(color)
        surface.SetTexture(tex)
        surface.DrawTexturedRect(led_size * 2, 0, icon_size, icon_size)
        surface.DrawTexturedRect(scw_display - icon_box + led_size, 0, icon_size, icon_size)
    render.OverrideBlend(false)

    surface.SetDrawColor(color.r, color.g, color.b, 50)
    surface.SetMaterial(tex_b)
    surface.DrawTexturedRect(led_size * 2 - 4, -4, icon_size + 8, icon_size + 8)
    surface.DrawTexturedRect(scw_display - icon_box + led_size - 4, -4, icon_size + 8, icon_size + 8)

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


Metrostroi765MstSprites = Metrostroi765MstSprites or {}
local angle_zero = Angle(0, 0, 0)
local to_render_sort = function(a, b) return a.dist < b.dist end
local sprite_mats = { Metrostroi.MakeSpriteTexture("sprites/light_glow02", true), Metrostroi.MakeSpriteTexture("81-765_v1_assets/sprites/light_glow_x", true) }
local strips_panels = {}
for idx = 1, 4 do
    table.insert(strips_panels, "BNT_MST_STRIP_L" .. idx)
    table.insert(strips_panels, "BNT_MST_STRIP_R" .. idx)
end

local function get_vis_handle(wag, id)
    wag.MstBntVisHandles = wag.MstBntVisHandles or {}
    local handle = wag.MstBntVisHandles[id]
    if not handle then
        handle = util.GetPixelVisibleHandle()
        wag.MstBntVisHandles[id] = handle
    end
    return handle
end

hook.Add("Think", "Metrostroi.765.MstBntSprites", function()
    local ply = LocalPlayer()
    if not ply or not CV_765_BNT_SPRITES_COUNT then return end

    local ply_pos = ply:EyePos()
    local to_render = {}
    for wag in pairs(Metrostroi.SpawnedTrains) do
        if wag and wag.BNT_MST and wag.BNT_MST.GlowingDots and wag:IsValid() and wag:ShouldRenderClientEnts() then
            for dot_idx, dot in ipairs(wag.BNT_MST.GlowingDots) do
                for _, panel_k in ipairs(strips_panels) do
                    local panel = wag.ButtonMap[panel_k]
                    if panel and wag:ShouldDrawPanel(panel_k) then
                        local pos, ang = LocalToWorld(Vector(dot.x * (panel.scale or 1), -dot.y * (panel.scale or 1), 0), angle_zero, panel.pos, panel.ang)
                        table.insert(to_render, {
                            pos = pos, ang = ang, wag = wag, color = dot.color, unlit = dot.unlit,
                            dist = wag:LocalToWorld(pos):DistToSqr(ply_pos),
                            id = Format("%d.%s", wag:EntIndex(), tostring(pos))
                        })
                    end
                end
            end
        end
    end

    table.sort(to_render, to_render_sort)

    local count = CV_765_BNT_SPRITES_COUNT:GetInt()

    for idx = 1, count do
        local sprite = Metrostroi765MstSprites[idx]
        local rd = to_render[idx]

        if rd and not sprite then
            sprite = { }
            Metrostroi765MstSprites[idx] = sprite
        end

        if sprite then
            if rd then
                sprite.id = rd.id
                sprite.wag = rd.wag
                sprite.pos = rd.pos
                sprite.color = rd.color or color_white
                sprite.unlit = rd.unlit
                sprite.visible = true
            else
                sprite.visible = false
                sprite.wag = nil
                sprite.pos = nil
            end
        end
    end
end)

local function color_a2b(col, a)
    return Color(col.r * a, col.g * a, col.b * a)
end
hook.Add("PostDrawTranslucentRenderables", "Metrostroi.765.MstBntSprites.Draw", function(_, b)
    if b then return end
    local count = CV_765_BNT_SPRITES_COUNT and CV_765_BNT_SPRITES_COUNT:GetInt() or 0

    local original_mat = sprite_mats[1]
    local sprite_mat = sprite_mats[CV_765_BNT_SPRITE_TYPE:GetInt()] or original_mat
    local size = sprite_mat == original_mat and 1.2 or 1.8

    cam.IgnoreZ(true)
    for idx, sprite in pairs(Metrostroi765MstSprites) do
        if idx > count or not sprite or not sprite.visible then break end

        local wag = sprite.wag
        if wag and wag:IsValid() then
            local pos = wag:LocalToWorld(sprite.pos)
            local visibility = util.PixelVisible(pos, 1, get_vis_handle(sprite.wag, sprite.id))
            if not sprite.unlit and visibility > 0 then
                render.SetMaterial(sprite_mat)
                render.DrawSprite(pos, size, size, color_a2b(sprite.color, visibility))
            end
        end
    end
    cam.IgnoreZ(false)
end)
