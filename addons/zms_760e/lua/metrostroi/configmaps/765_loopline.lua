-- Важно добавлять это!
if not Cfg765 then return end

local map = game.GetMap()
if map ~= "gm_mus_loopline_e" and map ~= "gm_mus_loopline_r" then return end

-- Станцию Парк поезд проследует без остановки
-- Формат пути к файлу: file://путь,длительность
-- Путь относительно директории sound/
Cfg765.MapMessages[1] = "file://subway_announcers/asnp/boiko_new/loopline/skip_park.mp3,5.091938"
-- Можно и прямой ссылкой на веб-ресурс, при этом длительность НЕ указываем
-- Cfg765.MapMessages[1] = "https://steamusercontent-a.akamaihd.net/ugc/13614774836284261489/0D1AFCAED2F09DCB354A1DB285231C025695E2E0/"
-- Не рекомендуется занимать оба экстр. сообщения, т.к. это не даст возможность игрокам ставить свои.

-- Оригинальное разрешение 1024x768. В после конвертации в .vtf - 1024x1024
Cfg765.SetNotificationPaper("models/metrostroi_train/81-765/custom/notification_park.vtf")

-- ЦИК для ремастера, нужен для бэкпорта под информаторы со старой карты
if map ~= "gm_mus_loopline_r" then return end
local cfg = {{
    LED = {5, 5, 5, 5, 5, 5},
    Name = "Кольцевая Линия",
    Loop = true,
    Line = 3,
    Color = Color(0, 129, 200),
    English = true,
    {351, "Первоапрельская", "Pervoaprelskaya",},
    {352, "Парк", "Park", true, "Парк", 1, "Park", Color(232, 117, 17),},
    {353, "Метростроителей", "Metrostroiteley", true, "Метростроителей", 2, "Metrostroiteley", Color(224, 4, 135),},
    {354, "Морская", "Morskaya",},
    {355, "Славная Страна", "Slavnaya Strana", true, "Славная Страна", 1, "Slavnaya Strana", Color(232, 117, 17),},
    {356, "Пионерская", "Pionerskaya", true, "Пионерская", 2, "Pionerskaya", Color(224, 4, 135),},
},
{
    LED = {5, 5, 5, 5, 5, 5},
    Name = "Первоапрельская - Первоапрельская",
    Loop = false,
    Line = 3,
    Color = Color(0, 129, 200),
    English = true,
    {351, "Первоапрельская", "Pervoaprelskaya",},
    {352, "Парк", "Park", true, "Парк", 1, "Park", Color(232, 117, 17),},
    {353, "Метростроителей", "Metrostroiteley", true, "Метростроителей", 2, "Metrostroiteley", Color(224, 4, 135),},
    {354, "Морская", "Morskaya",},
    {355, "Славная Страна", "Slavnaya Strana", true, "Славная Страна", 1, "Slavnaya Strana", Color(232, 117, 17),},
    {356, "Пионерская", "Pionerskaya", true, "Пионерская", 2, "Pionerskaya", Color(224, 4, 135),},
    {351, "Первоапрельская", "Pervoaprelskaya",},
},
{
    LED = {5, 5, 5, 5, 5, 5},
    Name = "Парк - Парк",
    Loop = false,
    Line = 3,
    Color = Color(0, 129, 200),
    English = true,
    {352, "Парк", "Park", true, "Парк", 1, "Park", Color(232, 117, 17),},
    {353, "Метростроителей", "Metrostroiteley", true, "Метростроителей", 2, "Metrostroiteley", Color(224, 4, 135),},
    {354, "Морская", "Morskaya",},
    {355, "Славная Страна", "Slavnaya Strana", true, "Славная Страна", 1, "Slavnaya Strana", Color(232, 117, 17),},
    {356, "Пионерская", "Pionerskaya", true, "Пионерская", 2, "Pionerskaya", Color(224, 4, 135),},
    {351, "Первоапрельская", "Pervoaprelskaya",},
    {352, "Парк", "Park", true, "Парк", 1, "Park", Color(232, 117, 17),},
},
{
    LED = {5, 5, 5, 5, 5, 5},
    Name = "Морская - Морская",
    Loop = false,
    Line = 3,
    Color = Color(0, 129, 200),
    English = true,
    {354, "Морская", "Morskaya",},
    {355, "Славная Страна", "Slavnaya Strana", true, "Славная Страна", 1, "Slavnaya Strana", Color(232, 117, 17),},
    {356, "Пионерская", "Pionerskaya", true, "Пионерская", 2, "Pionerskaya", Color(224, 4, 135),},
    {351, "Первоапрельская", "Pervoaprelskaya",},
    {352, "Парк", "Park", true, "Парк", 1, "Park", Color(232, 117, 17),},
    {353, "Метростроителей", "Metrostroiteley", true, "Метростроителей", 2, "Metrostroiteley", Color(224, 4, 135),},
    {354, "Морская", "Morskaya",},
},
{
    LED = {5, 5, 5, 5, 5, 5},
    Name = "Славная страна - Славная страна",
    Loop = false,
    Line = 3,
    Color = Color(0, 129, 200),
    English = true,
    {355, "Славная Страна", "Slavnaya Strana", true, "Славная Страна", 1, "Slavnaya Strana", Color(232, 117, 17),},
    {356, "Пионерская", "Pionerskaya", true, "Пионерская", 2, "Pionerskaya", Color(224, 4, 135),},
    {351, "Первоапрельская", "Pervoaprelskaya",},
    {352, "Парк", "Park", true, "Парк", 1, "Park", Color(232, 117, 17),},
    {353, "Метростроителей", "Metrostroiteley", true, "Метростроителей", 2, "Metrostroiteley", Color(224, 4, 135),},
    {354, "Морская", "Morskaya",},
    {355, "Славная Страна", "Slavnaya Strana", true, "Славная Страна", 1, "Slavnaya Strana", Color(232, 117, 17),},
},
{
    LED = {5, 5, 5, 5, 5, 5},
    Name = "Пионерская - Пионерская",
    Loop = false,
    Line = 3,
    Color = Color(0, 129, 200),
    English = true,
    {356, "Пионерская", "Pionerskaya", true, "Пионерская", 2, "Pionerskaya", Color(224, 4, 135),},
    {351, "Первоапрельская", "Pervoaprelskaya",},
    {352, "Парк", "Park", true, "Парк", 1, "Park", Color(232, 117, 17),},
    {353, "Метростроителей", "Metrostroiteley", true, "Метростроителей", 2, "Metrostroiteley", Color(224, 4, 135),},
    {354, "Морская", "Morskaya",},
    {355, "Славная Страна", "Slavnaya Strana", true, "Славная Страна", 1, "Slavnaya Strana", Color(232, 117, 17),},
    {356, "Пионерская", "Pionerskaya", true, "Пионерская", 2, "Pionerskaya", Color(224, 4, 135),},
}}

-- Сам бэкпорт.
-- Для обратной совместимости с конфигами АСНП от оригинального loopline_e
for cfgidx, cfgx in ipairs(cfg) do
    local newy = {}
    for idx, cfgy in ipairs(cfgx) do
        local x = {}
        for k, v in ipairs(cfgy) do
            if k == 1 then
                x[k] = v + 300
            else
                x[k] = v
            end
        end
        table.insert(newy, x)
    end
    table.Add(cfgx, newy)
end

Metrostroi.AddCISConfig("[ИК] Loopline Remastered", cfg)
