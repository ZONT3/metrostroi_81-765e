local map = game.GetMap()

if map:find("mus_neoorange") then
    Metrostroi.AddSchemes765("Neoorange Dev", {
        SchemeTex = "models/metrostroi_train/81-765_v1/schemes/765_neoorange",
        [1] = {
            MstLed = {
                { 522,  183, id = 462, size = 34 }, -- Икарус
                { 816,  183, id = 461, size = 34 }, -- СМРК
                { 1113, 183, id = 460, size = 34 }, -- Флора
                { 1411, 183, id = 458, size = 34 }, -- Аэропорт
                { 1640, 183, id = 457, size = 41 }, -- Славная Страна
                { 2020, 183, id = 456, size = 41 }, -- Литиевая
                { 2373, 183, id = 455, size = 34 }, -- Арсенал
                { 2623, 183, id = 454, size = 41 }, -- Парк
                { 2925, 183, id = 453, size = 34 }, -- GCFScape
                { 3223, 183, id = 452, size = 34 }, -- VHE
                { 3517, 183, id = 451, size = 34 }, -- Уолл. Брина

                Color = Color(255, 183, 122)
            },
            SarmatLed = {
                absolute = true,
                { 305,  id = 462, top = true}, -- Икарус
                { 600,  id = 461, top = true }, -- СМРК
                { 880,  id = 460, top = true }, -- Флора
                { 1180, id = 458, top = true }, -- Аэропорт
                { 1510, id = 457, top = true }, -- Славная Страна
                { 1850, id = 456, top = true }, -- Литиевая
                { 2130, id = 455, top = true }, -- Арсенал
                { 2370, id = 454, top = true }, -- Парк
                { 2630, id = 453, top = true }, -- GCFScape
                { 2920, id = 452, top = true }, -- VHE
                { 3220, id = 451, top = true }, -- Уолл. Брина
            },
        },
    })
end