local map = game.GetMap()

if map:find("imagine_line") then

    -- Конфигурация схем на БНТ для ЦИК "Сармат v1" и "МСТ v1/v1.1"
    -- Конфиги ЦИК (названы конфигами ИК) см. ниже.
    Metrostroi.AddSchemes765("Imagine Line", {
        -- Текстура схемы на БНТ для ЦИК "Сармат v1" и "МСТ v1/v1.1". Содержит оба варианта.
        -- Schemes on the top of the doors. For CIK equipment "Sarmat v1" and "MST v1/v1.1"
        SchemeTex = "models/metrostroi_train/81-765_v1/schemes/scheme_imagine",

        -- Первая линия, сопряжено с конфигом ИК/ЦИС и АСНП.
        -- First line, as in IK/CIS and ASNP configs.
        [1] = {
            -- Config for MST variant / Конфиг для МСТ
            MstLed = {
                -- Светодиоды. Координаты примерно соответствуют координатам на текстуре схемы.
                -- Порядок соответствует порядку в конфиге ИК/ЦИС, как в его поле 'LED'
                -- Если задан id станции, то порядок не имеет значения.
                -- Рекомендуется его задавать всегда, особенно на картах, у которых бывает разное кол-во станций в зависимости от выбранного информатора.
                -- LEDs. Coordinates approx. as is on scheme texture.
                -- Order as in IK/CIS config, same as in its 'LED' field.
                -- If 'id' is defined, the order no matters then.
                -- x    y
                { 251,  76,  id = 700, size = 42 },
                { 912,  76,  id = 701, size = 42 },
                { 1490, 76,  id = 702, size = 42 },
                { 1992, 76,  id = 703, size = 42 },
                { 2456, 76,  id = 704, size = 42 },
                { 2879, 76,  id = 705, size = 42 },
                { 3941, 184, id = 706, size = 54 },  -- Will be automatically merged with below / Будет автоматически объединен с аналогичным снизу
            },

            -- Config for Sarmat variant / Конфиг для Сармата
            -- Опция 'absolute' ставит значки станций по координате Y текстуры схемы. Без нее - работает как поле LED в конфигах АСНП и ЦИС.
            -- The 'absolute' option makes use of Y coordinate of the scheme texture.
            SarmatLed = {
                absolute = true,
                { 46,   id = 700, },
                { 740,  id = 701, top = true },
                { 1333, id = 702, top = true },
                { 1839, id = 703, top = true },
                { 2301, id = 704, top = true },
                { 2730, id = 705, top = true },
                { 3490, id = 706, },
            },

            -- Можно задать цвет светодиодов для линии. Если не задать - используется цвет из конфига ИК с увеличенной яркостью и уменьшенной сатурацией.
            -- Optionally set the LEDs color for the line. If not set, the IK config's color is used, with increased brightness and reduced saturation.
            -- Color = Color(119, 30, 192)
        },

        -- Second line / Вторая линия
        [2] = {
            MstLed = {
                { 420,  290, id = 804, size = 42 },
                { 1731, 290, id = 803, size = 42 },
                { 2745, 290, id = 802, size = 42 },
                { 3941, 184, id = 801, size = 54 },  -- Will be automatically merged with above / Будет автоматически объединен с аналогичным сверху
            },
            SarmatLed = {
                absolute = true,
                { 46,   id = 804, },
                { 1034, id = 803, bot = true },
                { 2229, id = 802, bot = true },
                { 3490, id = 801, },
            },
        },
    })

elseif map:find("crossline_r199h") then
    Metrostroi.AddSchemes765("Crossline r199h", {
        SchemeTex = "models/metrostroi_train/81-765_v1/schemes/scheme_crossline_r199h",
        [0] = {  -- Не использующиеся станции / Unused stations
            -- MstLed = {{ 3654, 164, size = 42 }}  -- Кировская
        },
        [1] = {
            MstLed = {
                { 78,   164, id = 101, size = 42 },
                { 406,  164, id = 102, size = 42 },
                { 729,  164, id = 103, size = 42 },
                { 1076, 164, id = 104, size = 42 },
                { 1431, 164, id = 105, size = 42 },
                { 1997, 164, id = 106, size = 42 },
                { 2616, 164, id = 107, size = 42 },
                { 2990, 164, id = 108, size = 42 },
                { 3332, 164, id = 109, size = 42 },
                { 3995, 164, id = 110, size = 42 },
            },
            SarmatLed = {
                absolute = true,
                { 149,  id = 101, },
                { 388,  id = 102, top = true },
                { 642,  id = 103, bot = true },
                { 951,  id = 104, top = true },
                { 1159, id = 105, bot = true },
                { 1689, id = 106, bot = true },
                { 2317, id = 107, bot = true },
                { 2595, id = 108, top = true },
                { 2861, id = 109, bot = true },
                { 3394, id = 110, },
            },
        },
    })

elseif map:find("gm_mus_orange") and map:find("_h") then
    Metrostroi.AddSchemes765("Orange H", {
        SchemeTex = "models/metrostroi_train/81-765_v1/schemes/scheme_orange_h",
        [1] = {  -- Оранжевая
            MstLed = {
                { 146,  272, id = 401, size = 42 },
                { 523,  272, id = 402, size = 42 },
                { 853,  272, id = 403, size = 42 },
                { 1325, 272, id = 404, size = 42 },
                { 1863, 259, id = 405, size = 42 },
                { 2049, 259, id = 406, size = 42 },
                { 2284, 259, id = 407, size = 42 },
                { 2518, 259, id = 408, size = 42 },
                { 2779, 259, id = 407, size = 42 },
                { 3036, 259, id = 406, size = 42 },
                { 3294, 259, id = 405, size = 42 },
                { 3507, 272, id = 404, size = 42 },
                { 3660, 272, id = 403, size = 42 },
                { 3812, 272, id = 402, size = 42 },
                { 4035, 272, id = 401, size = 42 },
            },
            -- SarmatLed = {
            --     absolute = true,
            -- },
        },
        [2] = {  -- Малиновая
            MstLed = {
                { 146,  223, id = 501, size = 42 },
                { 523,  26,  id = 502, size = 42 },
                { 853,  223, id = 503, size = 42 },
                { 1184, 25,  id = 504, size = 42 },
            },
            -- SarmatLed = {
            --     absolute = true,
            -- },
        },
        [3] = {  -- Бирюзовая
            MstLed = {
                { 1499, 47,  id = 601, size = 42 },
                { 1863, 259, id = 405, size = 42 },
                { 2049, 259, id = 406, size = 42 },
                { 2284, 259, id = 407, size = 42 },
                { 2518, 259, id = 408, size = 42 },
                { 2779, 259, id = 407, size = 42 },
                { 3036, 259, id = 406, size = 42 },
                { 3294, 259, id = 405, size = 42 },
                { 3765, 47,  id = 601, size = 42 },
            },
            -- SarmatLed = {
            --     absolute = true,
            -- },
        },
    })

end
