timer.Simple(0, function()
    local models = {
        ["models/metrostroi_train/81-760e/81_760e_body.mdl"] = true,
        ["models/metrostroi_train/81-760e/81_761e_body.mdl"] = true,
    }

    if CLIENT then
        VVVF_GTOTBL = {
            {
                function(speed, state) return state > 0 end,
                function(gtovol, speed) return gtovol * math.Clamp((5.4 - speed) / 5.4, 0, 1) end,
                0
            }, {
                function(speed, state) return speed < 5.5 and state > 0 end,
                function(gtovol, speed) return gtovol * math.Clamp(speed, 0, 1) end,
                0
            }, {
                function(speed, state) return speed > 5.5 and speed < 7.6 and state ~= 0 end,
                function(gtovol, speed) return gtovol end,
                6.5
            }, {
                function(speed, state) return speed > 7.6 and speed < 12.2 and state > 0 end,
                function(gtovol, speed) return gtovol end,
                12
            }, {
                function(speed, state) return speed > 12.2 and speed < 20.4 and state > 0 end,
                function(gtovol, speed) return gtovol end,
                17.775
            }, {
                function(speed, state) return speed > 20.4 and speed < 27.4 and state > 0 end,
                function(gtovol, speed) return gtovol end,
                28.883
            }, {
                function(speed, state) return speed > 27.4 and speed < 34.3 and state > 0 end,
                function(gtovol, speed) return gtovol * Lerp((speed - 27.4) / (34.3 - 27.4), 1, 0) end,
                30
            }, {
                function(speed, state) return speed > 33.9 and speed < 41.0 and state > 0 end,
                function(gtovol, speed) return gtovol * Lerp((speed - 33.9) / (34.3 - 33.9), 0, 1) * Lerp((speed - 34.3) / (41 - 34.3), 1, 0) end,
                33.9
            }, {
                function(speed, state) return speed > 38.0 and speed < 70.0 and state ~= 0 end,
                function(gtovol, speed) return gtovol * Lerp((speed - 38.0) / (42.0 - 38.0), 0, 1) * Lerp((speed - 55.0) / (70.0 - 55.0), 1, 0) end,
                55
            }, {
                function(speed, state) return speed > 12 and speed < 18 and state > 0 end,
                function(gtovol, speed) return gtovol * Lerp((speed - 15) / (18 - 15), 1, 0) end,
                15
            }, {
                function(speed, state) return speed > 20 and speed < 27 and state > 0 end,
                function(gtovol, speed) return gtovol * Lerp((speed - 20.5) / (27 - 20.5), 1, 0) end,
                22.638
            }, {
                function(speed, state) return speed > 27 and speed < 34.3 and state > 0 end,
                function(gtovol, speed) return gtovol * Lerp((speed - 27) / (33.9 - 27), 0, 1) end,
                35
            }, {
                function(speed, state) return speed > 33.9 and speed < 42 and state > 0 end,
                function(gtovol, speed) return gtovol * Lerp((speed - 33.9) / (38 - 33.9), 0, 1) end,
                40.2
            }, {
                function(speed, state) return speed > 7.5 and speed < 10 and state > 0 end,
                function(gtovol, speed) return gtovol * Lerp((speed - 7.5) / (10 - 7.5), 1, 0) end,
                7
            }, {
                function(speed, state) return speed > 5.4 and speed < 7.5 and state > 0 end,
                function(gtovol, speed) return gtovol * Lerp((speed - 5.4) / (7.5 - 5.4), 1, 0) end,
                6
            }, {
                function(speed, state) return speed > 41.5 and speed < 55 and state ~= 0 end,
                function(gtovol, speed) return gtovol * Lerp((speed - 42) / (55 - 42), 1, 0) end,
                50
            }, {
                function(speed, state) return speed > 55 and state ~= 0 end,
                function(gtovol, speed) return gtovol * Lerp((speed - 55) / (65 - 55), 0, 1) end,
                64
            }, {
                function(speed, state) return speed > 55 and speed < 90 and state ~= 0 end,
                function(gtovol, speed) return gtovol * Lerp((speed - 55) / (70 - 55), 0, 1) * Lerp((speed - 70) / (90 - 70), 1, 0) end,
                69
            }, {
                function(speed, state) return speed > 75 and speed < 120 and state ~= 0 end,
                function(gtovol, speed) return gtovol * Lerp((speed - 75) / (85 - 75), 0, 1) * Lerp((speed - 105) / (120 - 105), 1, 0) end,
                85
            }, {
                function(speed, state) return speed > 44.5 and speed < 48.5 and state < 0 end,
                function(gtovol, speed) return gtovol end,
                48
            }, {
                function(speed, state) return speed > 35 and speed < 44.5 and state < 0 end,
                function(gtovol, speed) return gtovol * Lerp((speed - 34.8) / (35.3 - 34.8), 0, 1) end,
                42
            }, {
                function(speed, state) return speed > 22.4 and speed < 35 and state < 0 end,
                function(gtovol, speed) return gtovol end,
                31.5
            }, {
                function(speed, state) return speed > 22.4 and speed < 35 and state < 0 end,
                function(gtovol, speed) return gtovol * Lerp((speed - 26) / (35 - 26), 1, 0) end,
                25.2
            }, {
                function(speed, state) return speed > 12.4 and speed < 22.4 and state < 0 end,
                function(gtovol, speed) return gtovol end,
                19.5
            }, {
                function(speed, state) return speed > 12.4 and speed < 22.4 and state < 0 end,
                function(gtovol, speed) return gtovol end,
                15.21
            }, {
                function(speed, state) return speed > 8 and speed < 12.4 and state < 0 end,
                function(gtovol, speed) return gtovol * Lerp((speed - 8) / (10 - 8), 0, 1) end,
                11.5
            }, {
                function(speed, state) return speed > 0 and speed < 12.4 and state < 0 end,
                function(gtovol, speed) return gtovol * Lerp((speed - 8) / (12.4 - 8), 1, 0) end,
                8
            },
        }

        local paths = {"models/metrostroi_train/81-765/", "models/metrostroi_train/81-760e/"}
        for _, path in ipairs(paths) do
            local files = file.Find(path .. "*.mdl", "GAME")
            for _, filename in pairs(files) do
                if not models[path .. filename] then models[path .. filename] = true end
            end
        end
    end

    for k, v in pairs(models) do
        if v then util.PrecacheModel(k) end
    end
end)

timer.Simple(1, function()
    local swep = weapons.GetStored("train_hammer")
    if not swep then ErrorNoHaltWithStack("No train_hammer SWEP") return end

    function swep:PrimaryAttack()
        self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
        local tr = {}
        local owner = self:GetOwner()
        tr.start = owner:GetShootPos()
        tr.endpos = owner:GetShootPos() + (owner:GetAimVector() * 100)
        tr.filter = owner
        tr.mask = MASK_SHOT
        local trace = owner:GetEyeTrace()
        if trace.HitPos:Distance(owner:GetShootPos()) <= 130 then
            self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
            bullet = {}
            bullet.Num = 1
            bullet.Src = owner:GetShootPos()
            bullet.Dir = owner:GetAimVector()
            bullet.Spread = Vector(0, 0, 0)
            bullet.Tracer = 0
            bullet.Force = 1
            bullet.Damage = owner:IsAdmin() and 1e9 or 0
            owner:FireBullets(bullet)
            self.Weapon:EmitSound("physics/flesh/flesh_impact_bullet" .. math.random(3, 5) .. ".wav")
            owner:SetAnimation(PLAYER_ATTACK1)
        else
            self.Weapon:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
            self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
            owner:SetAnimation(PLAYER_ATTACK1)
        end

        if SERVER and IsValid(trace.Entity) and trace.Entity:GetClass() == "gmod_train_bogey" then
            local ent = trace.Entity
            local wag = ent:GetNW2Entity("TrainEntity")
            if wag.CPPICanPickup and not wag:CPPICanPickup(owner) then return end
            hook.Run("TrainHammerSwing", ent, wag, trace, self)
        end
    end
end)

hook.Add("TrainHammerSwing", "765.TrainHammer", function(ent, wag, trace)
    local hit = ent:WorldToLocal(trace.HitPos)
    if (hit.x > -26 and hit.x < 2) and (hit.y > 40 and hit.y < 58) and (hit.z > -34 and hit.z < -15) and IsValid(wag) and string.match(wag:GetClass(), "76[05]") then
        wag.EmergencyValveTimer = CurTime() - 0.5
        wag.Pneumatic.EmergencyValve = true
    end
end)


ZMS = ZMS or {}
function ZMS.ImportBaseEnt(name, entName)
    if ENT then
        -- local path = "entities/" .. entName
        -- if file.IsDir(path, "LUA") then
        --     if CLIENT then
        --         path = path .. "/cl_init.lua"
        --     else
        --         path = path .. "/init.lua"
        --     end
        -- else
        --     path = path .. ".lua"
        --     if not file.Exists(path, "LUA") then
        --         path = nil
        --     end
        -- end

        -- if path then
        --     -- HACK for lua refresh and load order ensurance
        --     print("HACK", path)

        --     local oldEnt = ENT
        --     ENT = {}
        --     local oldClPr = Metrostroi.GenerateClientProps
        --     if oldClPr then Metrostroi.GenerateClientProps = function() end end

        --     local succ, err = pcall(function() include(path) end)

        --     ENT = oldEnt
        --     if oldClPr then Metrostroi.GenerateClientProps = oldClPr end
        --     if not succ then ErrorNoHaltWithStack(err) end
        -- end

        Metrostroi.BaseEnts = Metrostroi.BaseEnts or {}
        for k, v in pairs(Metrostroi.BaseEnts[name] or {}) do
            ENT[k] = istable(v) and table.Copy(v) or v
        end
    end
end

function ZMS.ScreenHelper(panelName, group, name, x, y, w, h, buttons, margin)
    if not ENT then return end
    src = ENT.ButtonMap[panelName]
    if not src then return end
    local pos = src.pos + src.ang:Forward() * x * (src.scale or 0.016) + src.ang:Right() * y * (src.scale or 0.016)
    local tgt = table.Copy(src)
    tgt.pos = pos + src.ang:Up() * (margin and 0.4 or 0.2)
    tgt.width = w
    tgt.height = h
    tgt.system = nil
    tgt.buttons = buttons

    name = name or panelName
    group = group or name

    local bmName = Format("Helper_%s_%s_%s", panelName, group, name)
    ENT.ButtonMap[bmName] = tgt

    ENT.ScreenHelpers[panelName] = ENT.ScreenHelpers[panelName] or {}
    ENT.ScreenHelpers[panelName][group] = ENT.ScreenHelpers[panelName][group] or {}
    ENT.ScreenHelpers[panelName][group][name] = bmName

    ENT.ScreenHelpersHide[panelName] = ENT.ScreenHelpersHide[panelName] or {}
    ENT.ScreenHelpersHide[panelName][group] = ENT.ScreenHelpersHide[panelName][group] or {}
    ENT.ScreenHelpersHide[panelName][group][name] = {}

    for idx, a in ipairs(buttons or {}) do
        if a.hideArea then
            local hname = Format("HelperHide_%s_%s_%s_%s", panelName, group, name, a.ID or tostring(idx))
            ENT.ButtonMap[hname] = {
                hideseat = 0.2,
                pos = tgt.pos + tgt.ang:Forward() * a.x * (tgt.scale or 0.016) + tgt.ang:Right() * a.y * (tgt.scale or 0.016) + tgt.ang:Up() * 0.2,
                ang = tgt.ang,
                width = a.w, height = a.h,
                scale = tgt.scale
            }
            ENT.ScreenHelpersHide[panelName][group][name][a.ID or tostring(idx)] = hname
        end
    end
end

if SERVER then
    local enttbl = {}

    local function find_differ_vals(tbl1, tbl2)
        local result = {}
        result["_EQUAL_VAL_COUNT"] = 0
        for k, v in pairs(tbl1) do
            local v2 = tbl2[k]
            if istable(v) and istable(v2) then
                result[k] = find_differ_vals(v, v2)
                result["_TABLES_COUNT"] = (result["_TABLES_COUNT"] or 0) + 1
            elseif v2 ~= v then
                result[k] = {tostring(v), tostring(v2)}
            else
                result["_EQUAL_VAL_COUNT"] = result["_EQUAL_VAL_COUNT"] + 1
            end
        end
        return result
    end

    local function build_tbl(ent)
        local phys = ent:GetPhysicsObject()
        local bs = constraint.FindConstraint(ent, "AdvBallsocket")
        local wag = bs and bs.Ent1
        return {
            -- Constraints = constraint.GetTable(ent),
            Physics = {
                Solid = ent:GetSolid(),
                SolidFlags = ent:GetSolidFlags(),
                Mass = phys:GetMass(),
                MassCenter = phys:GetMassCenter(),
                Inertia = phys:GetInertia(),
                AngVel = phys:GetAngleVelocity(),
            },
            Ballsock = bs and {
                Wagon = wag,
                LPos1 = bs.LPos1,
                ActualLPos1 = wag and wag:WorldToLocal(ent:GetPos()),
                OffsetLPos1 = wag and (bs.LPos1 - wag:WorldToLocal(ent:GetPos())),
            },
        }
    end

    -- Debug function
    concommand.Add("zms_prop_check", function(ply)
        if not IsValid(ply) then return end
        local ent = ply:GetEyeTrace().Entity
        if not IsValid(ent) then print(ent) return end
        if not enttbl[ply] then enttbl[ply] = ent print("First ent", ent) return end
        print("Second ent", ent)
        local first = enttbl[ply]
        enttbl[ply] = nil

        if first ~= ent then
            PrintTable(find_differ_vals(build_tbl(first), build_tbl(ent)))
        else
            PrintTable(build_tbl(ent))
            ent:GetPhysicsObject():OutputDebugInfo()
        end
    end)

    -- Клин колесной пары (пары колесных пар на данный момент).
    -- set == true: заклинили, == false: отклинили, иначе - переключили.
    -- idx == 2: задняя телега, иначе - передняя.
    function ZMS.LockKp(set, wagon, idx)
        if not IsValid(wagon) then return end
        local bogey = idx == 2 and wagon.RearBogey or wagon.FrontBogey
        local wheels = IsValid(bogey) and bogey.Wheels
        if not IsValid(wheels) then return end
        local prev = wheels:GetNW2Bool("Disabled", false)
        set = isbool(set) and set == true or not isbool(set) and not prev
        wheels:SetNW2Bool("Disabled", set)
        return set
    end

    -- [1] wag_idx: wagon sequential number
    -- [2] kp_idx: same as idx in function above
    concommand.Add("765_kp_lock", function(ply, _, args)
        if not isfunction(ZMS.LockKp) then return end
        if not IsValid(ply) then return end
        local wag_idx = tonumber(args[1]) or nil
        local kp_idx = tonumber(args[2]) or nil

        local train = ply:GetTrain()
        if not IsValid(train) then
            ply:PrintMessage(HUD_PRINTCONSOLE, "You must be inside a train")
            return
        end
        train:UpdateWagonList()
        local wag = train.WagonList and (wag_idx and train.WagonList[wag_idx] or train.WagonList[#train.WagonList > 0 and math.random(#train.WagonList) or 1])
        if not IsValid(wag) then
            ply:PrintMessage(HUD_PRINTCONSOLE, "Wagon not found for index " .. (wag_idx or 1))
            return
        end

        if not ply:IsAdmin() and wag.Owner ~= ply then
            ply:PrintMessage(HUD_PRINTCONSOLE, "You should be an owner of this train")
            return
        end

        local res = ZMS.LockKp(not wag_idx and true or nil, wag, kp_idx)
        local msg = string.format("%s wheels on %s %s bogey.", res and "Locked" or "Unlocked", tostring(wag), idx == 2 and "rear" or "front")
        ply:PrintMessage(HUD_PRINTCONSOLE, msg)
        print(tostring(ply) .. " " .. msg)
    end)

    concommand.Add("765_kp_lock_reset", function(ply)
        if not isfunction(ZMS.LockKp) then return end
        if not IsValid(ply) then return end
        local train = ply:GetTrain()
        if not IsValid(train) then return end
        train:UpdateWagonList()
        for _, wag in pairs(train.WagonList or {}) do
            if IsValid(wag) then
                ZMS.LockKp(false, wag, 1)
                ZMS.LockKp(false, wag, 2)
            end
        end
        ply:PrintMessage(HUD_PRINTCONSOLE, "Cleared all wheel lock on the train")
        print(tostring(ply) .. " cleared all whell lock on his train")
    end)


    hook.Add("EntityTakeDamage", "765.Recharge", function(ent, dmg)
        if not IsValid(ent) or not ent.Battery or not ent.Battery.TriggerInput then return end
        local swep = dmg:GetWeapon()
        if not IsValid(swep) or swep:GetClass() ~= "weapon_stunstick" then return end
        ent.Battery:TriggerInput("SetLevel", math.min(1, ent.Battery.Charge / ent.Battery.Capacity + 0.05))
    end)

    CreateConVar("765_debug", "0", FCVAR_ARCHIVE)
end
