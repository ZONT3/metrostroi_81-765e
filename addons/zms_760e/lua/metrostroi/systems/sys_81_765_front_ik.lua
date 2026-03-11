--------------------------------------------------------------------------------
-- ТМ-ИК, ТНМ-ИК, БЛ-ИК
-- Автор - ZONT_ a.k.a. enabled person
--------------------------------------------------------------------------------
Metrostroi.DefineSystem("81_765_FrontIK")
TRAIN_SYSTEM.DontAccelerateSimulation = true

function TRAIN_SYSTEM:Initialize()
    self.RouteNumber = -1
    self.Train.RouteNumber = self
end

function TRAIN_SYSTEM:Outputs()
end

function TRAIN_SYSTEM:Inputs()
    return {}
end

if TURBOSTROI then return end

if SERVER then
    function TRAIN_SYSTEM:TriggerInput(name, val1, val2, val3)
        local Wag = self.Train
        if name == "SetRoute" then
            if val2 then
                self.RouteNumber = tonumber(val2)
                Wag:SetNW2Int("BNMIK:RouteNumber", self.RouteNumber)
            end
            local station = val1
            if val3 and val3 > 0 then
                local cfg = Metrostroi.CISConfig[Wag:GetNW2Int("CISConfig", -1)]
                cfg = cfg and cfg[Wag:GetNW2Int("IK:Route", -1)]
                for _, cisCfg in ipairs(cfg or {}) do
                    if cisCfg[1] == val3 then
                        station = cisCfg[2] and utf8.len(cisCfg[2]) < 26 and cisCfg[2] or station
                        break
                    end
                end
            end
            Wag:SetNW2String("BMIK:Station", station)
        elseif name == "SetRouteNum" then
            self.RouteNumber = tonumber(val1)
            Wag:SetNW2Int("BNMIK:RouteNumber", self.RouteNumber)
        end
    end

    function TRAIN_SYSTEM:Think()
        local power = self.Train.Electric.Battery80V > 62 and self.Train.SF45F11.Value > 0.5
        self.Train:SetNW2Bool("BMIK:Power", power)
        if not power then
            self.Train:SetNW2String("BMIK:Station", "")
            self.Train:SetNW2Int("BNMIK:RouteNumber", 0)
        else
            local ply = self.Train.Owner
            if IsValid(ply) then
                local str = ply:GetInfo("760_last")
                if str and #str > 0 and self.LastLast ~= str then
                    self.Train:SetNW2String("BMIK:Station", str)
                    self.LastLast = str
                end
            end
        end
    end

else
    local scw_bm, sch_bm = 1380, 230
    local scw_bnm, sch_bnm = 380, 190
    local scw_bl, sch_bl = 380, 380
    local line_w = 1340
    local blFt = 1 / 25

    local YELLOW = Color(236, 233, 19)
    local ORANGE = Color(255, 151, 17)
    local GREEN  = Color(29, 248, 127)
    local COLORS = { YELLOW, ORANGE, GREEN }

    function TRAIN_SYSTEM:ClientThink()
        local Wag = self.Train
        local power = Wag:GetNW2Bool("BMIK:Power", power)
        self.Color = COLORS[Wag:GetNW2Int("CikColor", 1)] or YELLOW
        self.Working = Wag:GetNW2Bool("IK:Working", true)
        local fail = not self.Working and power
        if not fail then
            if not self.NextDrawBm or CurTime() >= self.NextDrawBm then
                self.NextDrawBm = CurTime() + 2
                if Wag:ShouldDrawPanel("BMIK") then
                    render.PushRenderTarget(self.Train.BMIK, 0, 0, scw_bm, sch_bm)
                    render.Clear(0, 0, 0, 0)
                    cam.Start2D()
                        if power then
                            self:DrawBm()
                        end
                    cam.End2D()
                    render.PopRenderTarget()
                end
                if Wag:ShouldDrawPanel("BNMIK") then
                    render.PushRenderTarget(self.Train.BNMIK, 0, 0, scw_bnm, sch_bnm)
                    render.Clear(0, 0, 0, 0)
                    cam.Start2D()
                        if power then
                            self:DrawBnm()
                        end
                    cam.End2D()
                    render.PopRenderTarget()
                end
            end

            if not self.NextDrawBl or CurTime() >= self.NextDrawBl then
                local logo = Wag:GetNW2String("BLIK:Logo")
                local repo = Metrostroi.Skins["765logo"]
                local cfg = logo ~= "-" and logo ~= "" and repo and repo[logo] or nil
                if cfg and not isstring(cfg.path) then cfg = nil end
                local anim = Wag:GetNW2Bool("BLIK:Anim", false) and cfg and isfunction(cfg.anim)
                self.NextDrawBl = CurTime() + (anim and blFt or 2)
                if Wag:ShouldDrawPanel("BLIK") then
                    render.PushRenderTarget(self.Train.BLIK, 0, 0, scw_bl, sch_bl)
                    render.Clear(0, 0, 0, 0)
                    cam.Start2D()
                        if power then
                            self:DrawBl(cfg, anim)
                        end
                    cam.End2D()
                    render.PopRenderTarget()
                end
            end
        end
    end

    surface.CreateFont("BMIK:Size1", {
        font = "Moscow2017_EMU",
        extended = true,
        size = 255,
        weight = 500,
        antialias = true,
    })
    surface.CreateFont("BMIK:Size2", {
        font = "Moscow2017_EMU Light",
        extended = true,
        size = 146,
        weight = 400,
        antialias = true,
    })
    surface.CreateFont("BNMIK", {
        font = "Moscow2017_EMU",
        extended = true,
        size = 180,
        weight = 500,
        antialias = true,
    })

    local function getLen(font, text)
        surface.SetFont(font)
        return surface.GetTextSize(text)
    end

    function TRAIN_SYSTEM:DrawBm()
        local curText = self.Train:GetNW2String("BMIK:Station", "")
        if true then
            self.BmText = curText
            self.BmLines = 1
            surface.SetFont("BMIK:Size1")
            local len = surface.GetTextSize(curText)
            self.BmFont = len >= line_w and "BMIK:Size2" or "BMIK:Size1"
            if len >= line_w then
                surface.SetFont("BMIK:Size2")
                len = surface.GetTextSize(curText)
            end
            if len >= line_w then
                local lines = string.Split(curText, " ")
                self.BmDisplText = table.remove(lines, 1)
                local buffer = #lines > 0 and string.format("%s %s", self.BmDisplText, lines[1]) or nil
                while buffer and getLen(self.BmFont, buffer) < line_w do
                    table.remove(lines, 1)
                    self.BmDisplText = buffer
                    if #lines > 0 then
                        buffer = string.format("%s %s", self.BmDisplText, lines[1])
                    else
                        break
                    end
                end
                if #lines > 0 then
                    self.BmLines = 2
                    self.BmDisplText2 = table.concat(lines, " ")
                end

                if len >= line_w then
                    local toTurncate = self.BmLines > 1 and self.BmDisplText2 or self.BmDisplText
                    surface.SetFont(self.BmFont)
                    len = surface.GetTextSize(toTurncate)
                    if len >= line_w then
                        self[self.BmLines > 1 and "BmDisplText2" or "BmDisplText"] = utf8.sub(toTurncate, 1, 15) .. "."
                    end
                end
            else
                self.BmDisplText = curText
            end
        end
        if self.BmLines == 1 then
            draw.SimpleText(self.BmDisplText, self.BmFont, scw_bm / 2 + 12, sch_bm / 2 + 24, self.Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        else
            draw.SimpleText(self.BmDisplText, self.BmFont, scw_bm / 2 + 12, sch_bm / 2 - 56 + 12, self.Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText(self.BmDisplText2, self.BmFont, scw_bm / 2 + 12, sch_bm / 2 + 56 + 12, self.Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    function TRAIN_SYSTEM:DrawBnm()
        local curText = self.Train:GetNW2Int("BNMIK:RouteNumber", 0)
        if self.BnmText ~= curText then
            self.BnmText = curText
            self.BnmDisplText = Format("%03d", curText)
        end
        draw.SimpleText(self.BnmDisplText, "BNMIK", scw_bnm / 2, sch_bnm / 2 + 18, self.Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local function defaultRender(_, mat, w, h)
        surface.SetMaterial(mat)
        surface.SetDrawColor(255, 255, 255)
        surface.DrawTexturedRectRotated(w / 2, h / 2, w - 64, h - 64, 0)
    end

    function TRAIN_SYSTEM:DrawBl(cfg, anim)
        if cfg then
            if not self.BlMat then self.BlMat = {} end
            local mat = self.BlMat[cfg.path]
            if not mat then mat = Material(cfg.path, cfg.params or "smooth ignorez") end
            self.BlMat[cfg.path] = mat
            local fnc = anim and cfg.anim or cfg.static or defaultRender
            fnc(self, mat, scw_bl, sch_bl)
            -- TODO else draw error msg
        end
    end
end
