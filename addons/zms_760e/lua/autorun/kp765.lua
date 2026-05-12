-- Debug. Nothing to see here.
if true then return end

ZMS = ZMS or {}
ZMS.Kp765Debug = {
    Vector( 41,  54, -18),
    Vector( 41, -54, -18),
    Vector(-41,  54, -18),
    Vector(-41, -54, -18),
}

if CLIENT then
    local mins = Vector(-2, -2, -2)
    local maxs = Vector(2, 2, 2)
    hook.Add("Think", "765.KpCheckDebug", function()
        local wheels = LocalPlayer():GetNW2Entity("Kp765Debug")
        if not IsValid(wheels) then return end

        local data = LocalPlayer():GetNW2String("Kp765DebugStr", "")
        data = string.Explode(",", data)

        for i, p in ipairs(ZMS.Kp765Debug) do
            local val = math.Clamp((tonumber(data[i] or "3") or 3) / 3, 0, 1)
            local pos = wheels:LocalToWorld(p)
            debugoverlay.Box(pos, mins, maxs, 0.2, Color(220 * val, 220 * (1 - val), 0))
        end

        local wag = LocalPlayer():GetNW2Entity("Hull765Debug")
        if not IsValid(wag) then return end
        local hull_val_raw = LocalPlayer():GetNW2Float("Hull765DebugVal", 0)
        local hull_val = math.Clamp(hull_val_raw / 1, 0, 1)
        debugoverlay.Axis(wag:GetPos(), wag:GetAngles(), 10, 0.1, true)
        debugoverlay.Sphere(wag:GetPos(), 10, 0.1, Color(220 * hull_val, 220 * (1 - hull_val), 0), true)
        debugoverlay.Text(wag:GetPos(), tostring(hull_val_raw), 0.1)
    end)
end

if SERVER then
    local bogeys = {"FrontBogey", "RearBogey"}
    hook.Add("Think", "765.KpCheckDebug", function()
        for _, ply in player.Iterator() do
            local pos = ply:GetPos()
            local min_dist = nil
            local ent = nil
            local wagon = nil
            for wag in pairs(Metrostroi.SpawnedTrains) do
                if IsValid(wag) and wag.ZmsKpCheck then
                    for _, k in ipairs(bogeys) do
                        if IsValid(wag[k]) and IsValid(wag[k].Wheels) and wag[k].Wheels.KpResult then
                            local e = wag[k].Wheels
                            local dist = e:GetPos():DistToSqr(pos)
                            if not min_dist or dist < min_dist then
                                min_dist = dist
                                ent = e
                                wagon = wag
                            end
                        end
                    end
                end
            end
            if ent then
                local result = {}
                for idx, v in ipairs(ent.KpResult) do
                    result[idx] = math.Round(v, 1) or 0
                end
                ply:SetNW2Entity("Kp765Debug", ent)
                ply:SetNW2String("Kp765DebugStr", table.concat(result, ","))
                ply:SetNW2Entity("Hull765Debug", wagon)
                ply:SetNW2Float("Hull765DebugVal", wagon.HullCheckResult or 0)
            end
        end
    end)
end
