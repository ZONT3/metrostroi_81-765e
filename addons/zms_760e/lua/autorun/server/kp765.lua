ZMS = ZMS or {}

local mins = Vector(-4.4, -4.4, -0.8)
local maxs = Vector(4.4, 4.4, 0.8)

function ZMS.Kp765Check(wag, wheels, idx)
    local points = ZMS.Kp765Debug or wag.ZmsKpCheck
    local point = points[idx]
    wheels.KpResult = wheels.KpResult or {}

    if wag.Speed >= 1.4 or (wheels.KpResult[idx] or 0) > 0 then
        local start = wheels:LocalToWorld(point)
        local tr = util.TraceHull({
            start = start,
            endpos = start + (-wheels:GetUp() * 4),
            mins = mins,
            maxs = maxs,
            filter = wheels
        })
        if tr.Hit then
            wheels.KpResult[idx] = 0
        else
            wheels.KpResult[idx] = math.min(99, (wheels.KpResult[idx] or 0) + (wag:GetNW2Bool("NerfKpDsHull", false) and 0.5 or 1))
        end
    else
        wheels.KpResult[idx] = 0
    end
end

local vector_up = Vector(0, 0, 1)
function ZMS.Hull765Check(wag)
    local ang = wag:GetAngles()
    ang.p = 0
    ang:Normalize()
    wag.HullCheckResult = (1 - vector_up:Dot(ang:Up())) / (wag:GetNW2Bool("NerfKpDsHull", false) and 0.012 or 0.006)
end


local met = {}
local bogeys = {"FrontBogey", "RearBogey"}

local function find_wagon()
    for w in pairs(Metrostroi.SpawnedTrains) do
        if IsValid(w) and w.ZmsKpCheck then
            for idx = 1, 4 do
                if (not met or not met[w] or not met[w][idx]) then
                    met = met or {}
                    met[w] = met[w] or {}
                    met[w][idx] = true
                    return w, idx
                end
            end
        end
    end
    met = nil
end

hook.Add("Think", "765.KpCheck", function()
    local wag, kp_idx = find_wagon()
    if not wag or not kp_idx then return end

    for _, bogey_k in ipairs(bogeys) do
        local wheels = IsValid(wag[bogey_k]) and IsValid(wag[bogey_k].Wheels) and wag[bogey_k].Wheels
        if wheels then
            ZMS.Kp765Check(wag, wheels, kp_idx)
        end
    end
end)

local constr_met = nil
hook.Add("Think", "765.KpConstraintCheck", function()
    for w in pairs(Metrostroi.SpawnedTrains) do
        if IsValid(w) and w.ZmsKpCheck then
            constr_met = constr_met or {}
            if not constr_met[w] then
                constr_met[w] = true
                for _, bogeyK in ipairs(bogeys) do
                    local bogey = IsValid(w[bogeyK]) and w[bogeyK]
                    local wheels = bogey and IsValid(bogey.Wheels) and bogey.Wheels
                    if bogey and wheels and not IsValid(constraint.Find(bogey, wheels, "Weld", 0, 0)) then
                        wheels.KpConstrFail = true
                    end
                    ZMS.Hull765Check(w)
                end
                return
            end
        end
    end
    constr_met = nil
end)
