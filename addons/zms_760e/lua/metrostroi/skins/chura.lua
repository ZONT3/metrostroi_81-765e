Metrostroi.AddSkin("train", "760e.MosBrend", {
    name = "Стандартный",
    typ = "81-760e",
    textures = { },
    def = true,
})

Metrostroi.AddSkin("train", "760e.Wa2k", {
    name = "WA2000",
    typ = "81-760e",
    textures = {
        ["head"] =       "models/metrostroi_train/81-765/liveries/head_wa2k",
        ["hull"] =       "models/metrostroi_train/81-765/liveries/hull_wa2k",
        ["hull_761e"] =  "models/metrostroi_train/81-765/liveries/hull_761e_wa2k",
        ["int_0"] =      "models/metrostroi_train/81-760/int_wa2k",
    }
})

Metrostroi.AddSkin("765logo", "Pivo", {
    --   Leave it as is for now
    typ = "81-760e",

    --   Display name in spawner (should be a translation string, but i don't give a shit for now)
    name = "Пиво",

    --   Path to the material file (anything that Material(path) accepts)
    path = "zxc765/PIVO_logo_lt.png",

    --   [Optional] Params for Material(path, params) call, default value is following:
    -- params = "smooth ignorez"

    --   [Optional] Animation function
    --   called in CLIENT realm, 25 FPS, if 'BLIK:Anim' is TRUE on wagon ('Анимация БЛ-ИК' spawner option)
    --     self: cliendside metrostroi system object (front_ik)
    --     mat: loaded MATERIAL object
    --     w, h: dimensions of the BL-IK screen
    anim = function(self, mat, w, h)
        local rot = 360 * (CurTime() % 15) / 15
        surface.SetMaterial(mat)
        surface.SetDrawColor(255, 255, 255)
        surface.DrawTexturedRectRotated(w / 2, h / 2, w - 64, h - 64, rot)
    end,

    --   [Optional] Render function
    --   called in CLIENT realm, 0.5 FPS (once per 2 seconds),
    --   if 'BLIK:Anim' is FALSE on wagon OR the previous 'anim' func is not provided.
    --   Default value is following:
    -- static = function(self, mat, w, h)
    --     surface.SetMaterial(mat)
    --     surface.SetDrawColor(255, 255, 255)
    --     surface.DrawTexturedRectRotated(w / 2, h / 2, w - 64, h - 64, 0)
    -- end
})

Metrostroi.AddSkin("765logo", "MosMetro", {
    typ = "81-760e",
    name = "Московский Метрополитен",
    path = "zxc765/MosMetro.png",
})

Metrostroi.AddSkin("765logo", "MosBrend", {
    typ = "81-760e",
    name = "Московский Транспорт",
    path = "zxc765/bl/MosBrend.png",
})

Metrostroi.AddSkin("765logo", "MosBrendR", {
    typ = "81-760e",
    name = "Московский Транспорт (красный)",
    path = "zxc765/bl/MosBrendRed.png",
})


function BLIK_ANIM_FROM_FRAMES(frameCount, duration, cols, rows)
    if CLIENT then
        local cw, ch = 1 / cols, 1 / rows
        return function(self, mat, w, h)
            local idx = math.min(frameCount - 1, math.floor(frameCount * (CurTime() % duration) / duration))
            local u, v = idx % cols, math.floor(idx / cols)
            surface.SetDrawColor(255, 255, 255, 255)
            surface.SetMaterial(mat)
            surface.DrawTexturedRectUV(0, 0, w, h, u * cw, v * ch, (u + 1) * cw, (v + 1) * ch)
        end
    else
        return function() end
    end
end

function BLIK_ANIM_STATIC(cols, rows)
    if CLIENT then
        local cw, ch = 1 / cols, 1 / rows
        return function(self, mat, w, h)
            surface.SetDrawColor(255, 255, 255, 255)
            surface.SetMaterial(mat)
            surface.DrawTexturedRectUV(0, 0, w, h, 0, 0, cw, ch)
        end
    else
        return function() end
    end
end

Metrostroi.AddSkin("765logo", "MosBrend3D", {
    typ = "81-760e",
    name = "Московский Транспорт (3D, LCD)",
    path = "zxc765/bl/MosBrendAnim.png",
    anim = BLIK_ANIM_FROM_FRAMES(32, 5, 8, 4),  -- frameCount, duration, cols, rows
    static = BLIK_ANIM_STATIC(8, 4),  -- cols, rows
})

Metrostroi.AddSkin("765logo", "MosMetro765", {
    typ = "81-760e",
    name = "МосМетро (3D, 81-765 САРМАТ LED 128px)",
    path = "zxc765/bl/MosMetroAnim765.png",
    anim = BLIK_ANIM_FROM_FRAMES(64, 10, 8, 8),  -- frameCount, duration, cols, rows
    static = BLIK_ANIM_STATIC(8, 8),  -- cols, rows
})

Metrostroi.AddSkin("765logo", "MosMetro765x64", {
    typ = "81-760e",
    name = "МосМетро (3D, 81-765 САРМАТ LED 64px)",
    path = "zxc765/bl/MosMetroAnim765x64.png",
    anim = BLIK_ANIM_FROM_FRAMES(64, 10, 8, 8),  -- frameCount, duration, cols, rows
    static = BLIK_ANIM_STATIC(8, 8),  -- cols, rows
})

Metrostroi.AddSkin("765logo", "MosMetro775", {
    typ = "81-760e",
    name = "МосМетро (3D, 81-775 LCD)",
    path = "zxc765/bl/MosMetroAnim775.png",
    anim = BLIK_ANIM_FROM_FRAMES(64, 5, 8, 8),  -- frameCount, duration, cols, rows
    static = BLIK_ANIM_STATIC(8, 8),  -- cols, rows
})
