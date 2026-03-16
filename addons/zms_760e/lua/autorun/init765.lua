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
