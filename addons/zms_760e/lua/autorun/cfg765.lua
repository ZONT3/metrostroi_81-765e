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
