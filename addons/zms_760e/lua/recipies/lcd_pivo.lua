MEL.DefineRecipe("pivo_lcd", {"gmod_subway_81-765e", "gmod_subway_81-766e", "gmod_subway_81-767e"})
RECIPE.Description = "Adds Pixelated LCD Shader for PIVO trains"

function RECIPE:InjectSpawner(entclass)
    if entclass == "gmod_subway_81-765e" then
        MEL.AddSpawnerField(entclass, {
            Name = "PixelatedLCD",
            Translation = "Pixelated LCD",
            Type = "Boolean",
            Section = "Settings",
            Subsection = "VisualSettings",
            Default = true,
        })
    end
end

local function metrostroiDrawRect(x, y, w, h)
    Pixelated.DrawTexturedRect(x - w / 2, y - h / 2, w, h)
end

local function DrawPixelatedScreenVityaz(self, panel_name, pos, ang, scale)
    if not Pixelated then return end

    Pixelated.SetBaseTexture(self.MFDU)
    Pixelated.SetPixelMask("pixelated/pixelstripes1")
    Pixelated.SetPixelLuma(3)
    Pixelated.SetPixelLayout(Pixelated.LAYOUT_SQUARE, 0)

    Pixelated.Start3D2D(pos, ang, scale)
        Pixelated.DrawWithFunc(function()
            Pixelated.SetDrawColor(255, 255, 255)
            metrostroiDrawRect(1024 / 2, math.floor(768 / 2), 1024, 768, 0)
        end, false)
    Pixelated.End3D2D()

    Pixelated.SetDefaultPixelMask()
end

local function DrawPixelatedScreenBuik(self, panel_name, pos, ang, scale)
    if not Pixelated then return end

    Pixelated.SetBaseTexture(self.BUIK)
    Pixelated.SetPixelMask("pixelated/pixelstripes1")
    Pixelated.SetPixelLuma(3)
    Pixelated.SetPixelLayout(Pixelated.LAYOUT_SQUARE, 0)

    Pixelated.Start3D2D(pos, ang, scale)
        Pixelated.DrawWithFunc(function()
            Pixelated.SetDrawColor(255, 255, 255)
            metrostroiDrawRect(2486 / 2, 496 / 2, 2486, 496, 0)
        end, false)
    Pixelated.End3D2D()

    Pixelated.SetDefaultPixelMask()
end

local function DrawPixelatedScreenCAMS(self, panel_name, pos, ang, scale)
    if not Pixelated then return end

    Pixelated.SetBaseTexture(self.CAMS)
    Pixelated.SetPixelMask("pixelated/pixelstripes1")
    Pixelated.SetPixelLuma(3)
    Pixelated.SetPixelLayout(Pixelated.LAYOUT_SQUARE, 0)

    Pixelated.Start3D2D(pos, ang, scale)
        Pixelated.DrawWithFunc(function()
            Pixelated.SetDrawColor(255, 255, 255)
            metrostroiDrawRect(1280 / 2, 512, 1280, 1024)
        end, false)
    Pixelated.End3D2D()

    Pixelated.SetDefaultPixelMask()
end

local function DrawPixelatedScreenBNT(rt)
    return function(self, panel_name, pos, ang, scale)
        if not Pixelated then return end

        Pixelated.SetBaseTexture(self[rt])
        Pixelated.SetPixelMask("pixelated/pixelstripes1")
        Pixelated.SetPixelLuma(3)
        Pixelated.SetPixelLayout(Pixelated.LAYOUT_SQUARE, 0)

        Pixelated.Start3D2D(pos, ang, scale)
            Pixelated.DrawWithFunc(function()
                Pixelated.SetDrawColor(255, 255, 255)
                metrostroiDrawRect(1920, 256, 3840, 512)
            end, false)
        Pixelated.End3D2D()

        Pixelated.SetDefaultPixelMask()
    end
end

function RECIPE:Inject(ent, entclass)
    MEL.InjectIntoClientFunction(ent, "Initialize", function(wagon)
        wagon.PixelatedCustomDraw = {}

        wagon.PixelatedCustomDraw["MFDU"] = DrawPixelatedScreenVityaz
        wagon.PixelatedCustomDraw["BUIK"] = DrawPixelatedScreenBuik
        wagon.PixelatedCustomDraw["CAMS"] = DrawPixelatedScreenCAMS
        for idx = 1, 4 do
            wagon.PixelatedCustomDraw["BNTL" .. idx] = DrawPixelatedScreenBNT("LBnt")
            wagon.PixelatedCustomDraw["BNTR" .. idx] = DrawPixelatedScreenBNT("RBnt")
        end
    end, 1)

    MEL.InjectIntoClientFunction(ent, "Think", function(wagon)
        wagon.PixelatedEnableCustom = wagon:GetNW2Bool("PixelatedLCD", false)
    end)
end
