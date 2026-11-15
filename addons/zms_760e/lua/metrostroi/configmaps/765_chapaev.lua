local map = game.GetMap()

if map:find("chapaevskaya_line_redux") then
    Metrostroi.AddSchemes765("Chapaevskaya Line Dev", {
        SchemeTex = "models/metrostroi_train/81-765_v1/schemes/765_chapaev",
        [1] = {
            MstLed = {
                { 514,  183, id = 101, size = 34 }, -- Заря
                { 937,  183, id = 102, size = 34 }, -- Чапаевский Парк
                { 1423, 183, id = 103, size = 34 }, -- Ярославская
                { 1794, 183, id = 104, size = 41 }, -- Перловская
                { 2293, 183, id = 105, size = 34 }, -- Куликовская
                { 2655, 183, id = 106, size = 41 }, -- Токоями
                { 3087, 183, id = 107, size = 34 }, -- Есенинская
                { 3509, 183, id = 108, size = 34 }, -- Красноярская

                Color = Color(219, 175, 255)
            },
            SarmatLed = {
                absolute = true,
                { 370,  id = 101, top = true}, -- Заря
                { 770,  id = 102, top = true }, -- Чапаевский Парк
                { 1160,  id = 103, top = true }, -- Ярославская
                { 1490, id = 104, top = true }, -- Перловская
                { 1950, id = 105, top = true }, -- Куликовская
                { 2300, id = 106, top = true }, -- Токоями
                { 2750, id = 107, top = true }, -- Есенинская
                { 3150, id = 108, top = true }, -- Красноярская
            },
        },
    })


end