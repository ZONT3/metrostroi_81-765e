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
                -- LEDs. Coordinates approx. as is on scheme texture.
                -- Order as in IK/CIS config, same as in its 'LED' field
                -- x    y
                { 251,  76,  size = 42 },
                { 912,  76,  size = 42 },
                { 1490, 76,  size = 42 },
                { 1992, 76,  size = 42 },
                { 2456, 76,  size = 42 },
                { 2879, 76,  size = 42 },
                { 3941, 184, size = 54 },  -- Will be automatically merged with below / Будет автоматически объединен с аналогичным снизу
            },

            -- Config for Sarmat variant / Конфиг для Сармата
            -- Конфиг как в поле LED конфигов АСНП или ЦИС, длина полосок измеряется в любых юнитах, относительно суммы всех полосок.
            -- В этом примере используются расстояния на текстуре в пикселях, но можно использовать любых "попугаев".
            -- Опция 'alignRight' ставит значки станций по правому краю своих полосок. Без нее - ставятся по центру.
            -- Config as is in ASNP or CIS configs. The strip length is measured in any units you prefer and calculated against the sum of lenghts.
            -- In that specific example, we use lengths in pixels of the scheme texture.
            -- The 'alignRight' option makes the station icons aligned to the right of their strips. Without that option, station icons will be at the center of their strips.
            SarmatLed = { alignRight = true, 0, 692, 593, 522, 456, 422, 745 },

            -- Можно задать цвет светодиодов для линии. Если не задать - используется цвет из конфига ИК с увеличенной яркостью и уменьшенной сатурацией.
            -- Optionally set the LEDs color for the line. If not set, the IK config's color is used, with increased brightness and reduced saturation.
            -- Color = Color(119, 30, 192)
        },

        -- Second line / Вторая линия
        [2] = {
            MstLed = {
                { 420,  290,  size = 42 },
                { 1731, 290,  size = 42 },
                { 2745, 290,  size = 42 },
                { 3941, 184,  size = 54 },  -- Will be automatically merged with above / Будет автоматически объединен с аналогичным сверху
            },
            SarmatLed = { alignRight = true, 0, 999, 1187, 1244 },
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
                { 78,   164, size = 42 },
                { 406,  164, size = 42 },
                { 729,  164, size = 42 },
                { 1076, 164, size = 42 },
                { 1431, 164, size = 42 },
                { 1997, 164, size = 42 },
                { 2616, 164, size = 42 },
                { 2990, 164, size = 42 },
                { 3332, 164, size = 42 },
                { 3995, 164, size = 42 },
            },
            -- marginRight делает отступ справа от последней станции. Нужно при использовании alignRight, если последняя станция находится не с краю.
            SarmatLed = { alignRight = true, marginRight = 100, 107, 236, 251, 303, 219, 530, 632, 266, 274, 522 },
        },
    })

end
