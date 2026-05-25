if not Cfg765 then return end
local map = game.GetMap()

if map:find("crossline_r") then
    Cfg765.SetNotificationPaper("models/metrostroi_train/81-765/custom/notification_kirovskaya.vtf")
elseif map:find("jar_imagine_line") then
    Cfg765.SetNotificationPaper("models/metrostroi_train/81-765/custom/notification_energetik.vtf")
end

