local map = game.GetMap()

if map:find("imagine_line") then

    Metrostroi.AddSchemes765("Imagine Line Dev", {
        SchemeTex = "models/metrostroi_train/81-765_v1/schemes/765_imagine",

        [1] = {
            MstLed = {
                { 512,  182,  id = 700, size = 38 }, -- Касторская
                { 952,  182,  id = 701, size = 38 }, -- Проспект Метростроителей
                { 1391, 182,  id = 702, size = 38 }, -- Россошанская
                { 1918, 293,  id = 703, size = 38 }, -- Красный Маяк
                { 2360, 293,  id = 704, size = 38 }, -- Инженерная
                { 2803, 293,  id = 705, size = 38 }, -- Северная
                { 3249, 214, id = 706, size = 38 },  -- Проспект Энергетиков
            },

            SarmatLed = {
                absolute = true,
                { 292,   id = 700, bot = true }, -- Касторская
                { 780,  id = 701, bot = true }, -- Проспект Метростроителей
                { 1270, id = 702, bot = true }, -- Россошанская
                { 1770, id = 703, bot = true }, -- Красный Маяк
                { 2258, id = 704, bot = true }, -- Инженерная
                { 2730, id = 705, bot = true }, -- Северная 
                { 3230, id = 706, bot = true }, -- Проспект Энергетиков
            },
        },

        [2] = {
            MstLed = {
                { 1920,  71, id = 804, size = 38 }, -- Восход
                { 2360, 71, id = 803, size = 38 }, -- Селигерская Роща
                { 2803, 71, id = 802, size = 38 }, -- Владимирская
                { 3249, 154, id = 801, size = 38 },  -- Проспект Энергетиков
            },
            SarmatLed = {
                absolute = true,
                { 1030,   id = 804, top = true}, -- Восход
                { 1510, id = 803, top = true}, -- Селигерская Роща
                { 2004, id = 802, top = true}, -- Владимирская
                { 2500, id = 801, top = true}, -- Проспект Энергетиков
            },
        },
    })

end