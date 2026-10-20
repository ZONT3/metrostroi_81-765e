-- Прибор пожарный управления поездной

Metrostroi.DefineSystem("81_765_PPUP")
TRAIN_SYSTEM.DontAccelerateSimulation = true

function TRAIN_SYSTEM:Initialize()
    self.State = -10
    self.NextState = -1
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
    local Wag = self.Train
    local power = Wag.Electric.UPI2Power * Wag.SF90F1.Value > 0
    if power then
        if self.NextState < 0 and self.State < 1 then
            if self.State < -5 then
                self.State = -5
                self.NextState = CurTime() + 0.2
            elseif self.State == -4 then
                self.NextState = CurTime() + math.Rand(0.4, 0.6)
                Wag:PlayOnce("ppup_start", "cabin")
            elseif self.State == -3 then
                self.L1 = true
                self.L2 = true
                self.L3 = true
                self.L4 = true
                self.FireL = true
                self.MsgL = false
                self.WarnL = true
                self.NextState = CurTime() + 0.01
            elseif self.State == -2 then
                self.L1 = false
                self.L2 = false
                self.L3 = false
                self.L4 = false
                self.FireL = true
                self.MsgL = false
                self.WarnL = true
                self.NextState = CurTime() + 2
            elseif self.State == -1 then
                self.FireL = false
                self.MsgL = true
                self.WarnL = false
                self.NextState = CurTime() + 8
            elseif self.State == 0 then
                self.State = 1
                self.ReadyMessage = CurTime() + 3
            end

        elseif self.NextState >= 0 then
            if CurTime() >= self.NextState then
                self.State = self.State + 1
                self.NextState = -1
            end
        end

        if self.State == 1 then
            self.MsgL = true
            self.WarnL = false
            self.L3 = true
            self.L4 = true

            Wag:SetNW2String("PPUP:TimeDate", os.date("%H:%M:%S  %d.%m.%Y"))

            if self.ReadyMessage and CurTime() >= self.ReadyMessage then
                Wag:PlayOnce("ppup_started", "cabin")
                self.ReadyMessage = nil
            end
        end

    else -- not power
        self.State = -10
        self.NextState = -1
        self.L1 = false
        self.L2 = false
        self.L3 = false
        self.L4 = false
        self.FireL = false
        self.MsgL = false
        self.WarnL = false
        self.ReadyMessage = nil
    end

    Wag:SetNW2Int("PPUP:State", self.State)
    Wag:SetNW2Bool("PPUP:ButtonL1", self.L1)
    Wag:SetNW2Bool("PPUP:ButtonL2", self.L2)
    Wag:SetNW2Bool("PPUP:ButtonL3", self.L3)
    Wag:SetNW2Bool("PPUP:ButtonL4", self.L4)
    Wag:SetNW2Bool("PPUP:Fire", self.FireL)
    Wag:SetNW2Bool("PPUP:Msg", self.MsgL)
    Wag:SetNW2Bool("PPUP:Warn", self.WarnL)
end


if not CLIENT then return end


local scw, sch = 512, 128
local color_bright = Color(73, 199, 42)
local color_default = Color(33, 128, 10)
local color_bg = Color(5, 12, 7)
local color_bgc = Color(60, 160, 77, 1)

function TRAIN_SYSTEM:ClientInitialize()
end

function TRAIN_SYSTEM:ClientThink()
    local Wag = self.Train
    local warn = Wag:GetNW2Bool("PPUP:Msg", false) and Wag:GetNW2Bool("PPUP:Warn", false)
    Wag:HideButton("!PPUPWarn", not warn)
    Wag:HideButton("!PPUPMsg", warn)
    if Wag:ShouldDrawPanel("PPUP") then
        render.PushRenderTarget(Wag.PPUP, 0, 0, scw, sch)
        render.Clear(0, 0, 0, 0)
        cam.Start2D()
        self:DrawDisplay()
        cam.End2D()
        render.PopRenderTarget()
    end
end

function print_text(x, y, text, color)
    local str = {utf8.codepoint(text, 1, -1)}
    for idx = 1, #str do
        local char = utf8.char(str[idx])
        if color.a > 1 then
            draw.SimpleText(char, "MetrostroiSubway_IGLAb", -6 + (x + idx) * 25, 22 + y * 36 + 1, ColorAlpha(color, color.a * 0.08), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        draw.SimpleText(char, "MetrostroiSubway_IGLA", -6 + (x + idx) * 25, 22 + y * 36, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end

local fill = string.rep(utf8.char(0x2588), 20)
local start_lines = {
    "КБ\"МЕТРОСПЕЦТЕХНИКА\"",
    "АСОТП-765 ВЕРСИЯ 0.0"
}
local start_len = 20
local start_pause = 15

function TRAIN_SYSTEM:DrawDisplay()
    surface.SetDrawColor(color_bg)
    surface.DrawRect(0, 0, 512, 80)
    print_text(0, 0, fill, color_bgc)
    print_text(0, 1, fill, color_bgc)

    local Wag = self.Train
    local state = Wag:GetNW2Int("PPUP:State", -10)

    if state == -1 then
        if not self.StartAnimation then
            self.StartAnimation = CurTime() + 1.1
        end
        local anim = 1 - math.Clamp((self.StartAnimation - CurTime()) / 0.5, 0, 1)
        anim = math.ceil(anim * (start_len * 2 + start_pause))
        for idx = 1, start_len * 2 + start_pause do
            if idx > anim then break end
            local line_idx = idx > start_len and 2 or 1
            local line = start_lines[line_idx]
            if idx <= start_len or idx > start_len + start_pause then
                local str_idx = idx > start_len and idx - start_len - start_pause or idx
                print_text(str_idx - 1, line_idx - 1, utf8.GetChar(line, str_idx), color_bright)
            end
        end
        return
    elseif state == 1 then
        print_text(0, 0, Wag:GetNW2String("PPUP:TimeDate", "--:--:--  --.--.----"), color_bright)
        print_text(0, 1, "НОРМА     ЗВУК  МЕНЮ", color_bright)
    end

    if self.StartAnimation then
        self.StartAnimation = nil
    end
end
