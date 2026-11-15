local map = game.GetMap()

if map:find("crossline_r199h") then
    Metrostroi.AddSchemes765("Crossline Redux Dev", {
        SchemeTex = "models/metrostroi_train/81-765_v1/schemes/765_crosslineredux",
        [0] = {  -- Не использующиеся станции / Unused stations
            MstLed = {{ 3386, 184, size = 38 }}  -- Кировская
        },
        [1] = {
            MstLed = {
                { 411,  184, id = 101, size = 38 }, -- Международная
                { 686,  184, id = 102, size = 38 }, -- Парк Культуры
                { 971,  184, id = 103, size = 38 }, -- Политехническая
                { 1416, 184, id = 104, size = 38 }, -- Проспект Суворова
                { 1744, 184, id = 105, size = 38 }, -- Нахимовская
                { 2073, 184, id = 106, size = 38 }, -- Октябрьская
                { 2401, 184, id = 107, size = 38 }, -- Речная
                { 2729, 184, id = 108, size = 38 }, -- Пролетарская
                { 3057, 184, id = 109, size = 38 }, -- Олимпийская
                { 3715, 184, id = 110, size = 38 }, -- Молодёжная

                Color = Color(255, 125, 130)
            },
            SarmatLed = {
                absolute = true,
                { 200,  id = 101, top = true}, -- Международная
                { 456,  id = 102, bot = true }, -- Парк Культуры
                { 659,  id = 103, top = true }, -- Политехническая
                { 1130,  id = 104, top = true }, -- Проспект Суворова
                { 1450, id = 105, top = true }, -- Нахимовская
                { 1750, id = 106, top = true }, -- Октябрьская
                { 2070, id = 107, top = true }, -- Речная
                { 2375, id = 108, top = true }, -- Пролетарская
                { 2680, id = 109, top = true }, -- Олимпийская
                { 3310, id = 110, top = true }, -- Молодёжная
            },
        },
    })

end