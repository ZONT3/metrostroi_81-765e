Cfg765 = Cfg765 or {}

Cfg765.MapMessages = Cfg765.MapMessages or {}

function Cfg765.SetNotificationPaper(imagePath)
    Cfg765.NotificationPaper = imagePath
    if CLIENT then
        Cfg765.NotificationMaterial = "!notification_paper_765"
        CreateMaterial("notification_paper_765", "VertexLitGeneric", {
            ["$basetexture"] = imagePath,
            ["$alphatest"] = 1,
            ["$model"] = 1,
            ["$phong"] = 1,
            ["$phongboost"] = 1,
            ["$phongfresnelranges"] = "[.5 .5 .5]",
            ["$envmap"] = "env_cubemap",
            ["$envmaptint"] = "[0.01 0.01 0.01]",
        })
    end
end

CV_765_SHOW_UNSAFE_ALS = CreateConVar("metrostroi_765_show_unsafe_als", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Show unsafe options \"AbMode\", \"Als75\" and \"1/4\" even if no map config sets it")

if CLIENT then
    CV_765_LOCK_CAB          = CreateClientConVar("765_lock_cab", "0", true, true, "Lock cabin on spawn", 0, 1)
    CV_765_AUTO_ODOMETER     = CreateClientConVar("765_auto_odometer", "1", true, true, "Use GetUTimeTotalTime-based odometer value on spawn", 0, 1)
    CV_765_BNT_SPRITES_COUNT = CreateClientConVar("765_bnt_sprites", "64", true, false, "MST BNT LED sprites max count", 0, 128)
    CV_765_BNT_SPRITE_TYPE   = CreateClientConVar("765_bnt_sprite_type", "1", true, false, "MST BNT LED sprites max count", 1, 2)

    local function ChuraClientPanel(panel)
        panel:ClearControls()
        panel:SetPadding(0)
        panel:SetSpacing(0)
        panel:Dock(FILL)

        local cb

        panel:Help("Основные опции")

        panel:CheckBox("Закрыть замки кабины при спавне", "765_lock_cab")
        panel:CheckBox("Авто-одометр при спавне", "765_auto_odometer")
        panel:ControlHelp("Задает значение одометра при спавне на основе общего времени игрока, проведенном на текущем сервере. Требует наличие ULX или подобного аддона.")

        panel:Help("")
        panel:Help("Тип спрайта станции БНТ \"МСТ\"")
        cb = panel:ComboBox("Тип", "765_bnt_sprite_type")
        cb:AddChoice("Тип 1", 1)
        cb:AddChoice("Тип 2", 2)
        cb:SetWidth(64)

        panel:Help("")
        panel:Help("")

        hook.Run("765.PopulateOptions", panel)

        -- panel:Help("Оптимизация")
        -- panel:NumSlider("Кол-во спрайтов БНТ \"МСТ\"", "765_bnt_sprites", 0, 128, 0)
        -- panel:ControlHelp("Рекомендуется либо 0, либо 64 или более. Значения 1-63 могут портить общий вид БНТ.")
    end

    hook.Add("PopulateToolMenu", "765.ClientPanel", function()
        spawnmenu.AddToolMenuOption("Utilities", "Metrostroi", "metrostroi765_client_panel", "81-765", "", "", ChuraClientPanel)
    end)
end
