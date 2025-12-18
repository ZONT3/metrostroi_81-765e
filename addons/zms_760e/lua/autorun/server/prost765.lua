--[[
    Adding additional info to 760 PrOst KOS tags
    (tipa delayu realistichno, hui znaet)
]]

local MapCorrection = {
    ["gm_metro_kalinin_v3"] = -2.2,
}


timer.Simple(6, function()
    local plates = ents.FindByClass("gmod_track_autodrive_plate")
    local stations = ents.FindByClass("gmod_track_platform")
    local offset = MapCorrection[game.GetMap()] or 0
    for idx, plate in ipairs(plates) do
        if IsValid(plate) and plate.PlateType == 760 and isnumber(plate.Mode) then
            if plate.Mode == 4 then  -- ТПС1
                plate.ProstDistance = 350 + offset
            elseif plate.Mode == 3 then  -- ТПС2
                plate.ProstDistance = 200 + offset
            elseif plate.Mode == 2 then  -- ТНС
                plate.ProstDistance = 52 + offset
            else  -- ВПО
                plate.ProstDistance = 12 + offset
            end
            plate.ProstId = idx
            for _, st in ipairs(stations) do
                if IsValid(st) then
                    local dist = st:GetPos():DistToSqr(plate:GetPos())
                    if (not plate.ProstStation or dist < plate.Prost3dDistanceSqr) then
                        plate.Prost3dDistanceSqr = dist
                        plate.ProstStation = st.StationIndex
                    end
                end
            end
        end
    end
    print(string.format("Updated %d PrOst tags", #plates))
end)
