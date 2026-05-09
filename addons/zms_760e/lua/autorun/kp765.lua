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
    hook.Add("HUDPaintBackground", "765.KpCheckDebug", function()
        local wheels = LocalPlayer():GetNW2Entity("Kp765Debug")
        if not IsValid(wheels) then return end

        local data = LocalPlayer():GetNW2String("Kp765DebugStr", "")
        data = string.Explode(",", data)

        for i, p in ipairs(ZMS.Kp765Debug) do
            local val = math.Clamp((tonumber(data[i] or "3") or 3) / 3, 0, 1)
            local pos = wheels:LocalToWorld(p)
            local scr = pos:ToScreen()
            if scr.visible then
                surface.SetDrawColor(220 * val, 220 * (1 - val), 0)
                surface.DrawRect(scr.x - 6, scr.y - 6, 12, 12)
            end
        end
    end)
end

if SERVER then
    local bogeys = {"FrontBogey", "RearBogey"}
    hook.Add("Think", "765.KpCheckDebug", function()
        for _, ply in player.Iterator() do
            local pos = ply:GetPos()
            local min_dist = nil
            local ent = nil
            for wag in pairs(Metrostroi.SpawnedTrains) do
                if IsValid(wag) and wag.ZmsKpCheck then
                    for _, k in ipairs(bogeys) do
                        if IsValid(wag[k]) and IsValid(wag[k].Wheels) and wag[k].Wheels.KpResult then
                            local e = wag[k].Wheels
                            local dist = e:GetPos():DistToSqr(pos)
                            if not min_dist or dist < min_dist then
                                min_dist = dist
                                ent = e
                            end
                        end
                    end
                end
            end
            if ent then
                local result = {}
                for idx, v in ipairs(ent.KpResult) do
                    result[idx] = v or 0
                end
                ply:SetNW2Entity("Kp765Debug", ent)
                ply:SetNW2String("Kp765DebugStr", table.concat(result, ","))
            end
        end
    end)
end
