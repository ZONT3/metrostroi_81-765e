--------------------------------------------------------------------------------
-- Блок Управления Дверьми
-- Автор - ZONT_ a.k.a. enabled person
--------------------------------------------------------------------------------

Metrostroi.DefineSystem("81_765_BUD")
TRAIN_SYSTEM.DontAccelerateSimulation = true

function TRAIN_SYSTEM:Initialize()
    self.Depart = false
    self.DoorLeft = false
    self.DoorRight = false
    self.CloseDoors = false
    self.ReverseWork = false
    self.AddressReadyL = false
    self.AddressReadyR = false
    self.Working = false
    self.Starting = false

    self.DoorClosed = {}
    self.DoorOpen = {}
    self.DoorCommand = {}
    self.DoorCommandPrev = {}
    self.DoorCommandDelay = {}
    self.CloseDelay = {}
    self.DoorsDelayMax = 0.5
    for idx = 1, 8 do self.DoorCommand[idx] = false end

    if not TURBOSTROI then
        self.LeftDoorState = {0, 0, 0, 0}
        self.RightDoorState = {0, 0, 0, 0}
        self.LeftDoorDir = {0, 0, 0, 0}
        self.RightDoorDir = {0, 0, 0, 0}
        self.LeftDoorSpeed = {0, 0, 0, 0}
        self.RightDoorSpeed = {0, 0, 0, 0}
        self.ForeignObject = {}
        self.AutoReverse = {}
        self.StuckPass = {}
        self.WasManual = {}
        self.OpenButton = {}
        self.MobsOpening = {}
        self.DoorSpeedMain = math.Rand(1.17, 1.185)
        for i = 1, 4 do
            self.LeftDoorSpeed[i] = math.Rand(self.DoorSpeedMain + 0.15, self.DoorSpeedMain + 0.185)
            self.RightDoorSpeed[i] = math.Rand(self.DoorSpeedMain + 0.15, self.DoorSpeedMain + 0.185)
        end
    end

    for idx = 1, 8 do
        self.Train:LoadSystem("DoorManualBlock" .. idx, "Relay", "Switch", { bass = true })
        self.Train:LoadSystem("DoorManualOpenLever" .. idx, "Relay", "Switch", { bass = true })
        self.Train:LoadSystem("DoorManualOpenLeverPl" .. idx, "Relay", "Switch", { bass = true })
        self.Train:LoadSystem("DoorManualOpenPush" .. idx, "Relay", "Switch", { bass = true })
        self.Train:LoadSystem("DoorManualOpenPull" .. idx, "Relay", "Switch", { bass = true })
        self.Train:LoadSystem("DoorAddressButton" .. idx, "Relay", "Switch", { bass = true })
    end
end

function TRAIN_SYSTEM:Outputs()
    return {}
end

function TRAIN_SYSTEM:Inputs()
    return {}
end

function TRAIN_SYSTEM:TriggerInput(name, value)
    if name == "Depart" then self.Depart = value end
end

function TRAIN_SYSTEM:Think(dT)
    local Wag = self.Train
    local BUV = Wag.BUV

    Wag.LeftDoorsOpen = false
    Wag.RightDoorsOpen = false
    Wag.DoorsOpened = false

    self.ReverseWork = false

    local poweron = Wag.Electric.Battery80V > 62
    local working = poweron and BUV.ADUDWork

    if not working and self.Working then self.Working = false self.Starting = false end
    if working and not self.Working and not self.Starting then self.Starting = CurTime() + 5 end
    if self.Starting and CurTime() >= self.Starting then self.Starting = false self.Working = true end
    working = self.Working
    poweron = working or self.Starting and self.Starting - CurTime() < 0.3

    if poweron and not working then
        self.DoorLeft = false
        self.DoorRight = false
        for idx = 1, 8 do self.DoorCommand[idx] = false end
    end

    local stuckEmpty = true
    local zeroSpeed = Wag.SF80F9.Value > 0 and Wag.Speed < 2.6
    local buvZeroSpeed = zeroSpeed and BUV.ZeroSpeed
    local addrMode = BUV.AddressDoors
    local addrForceOpen = false

    local workingLeft = working and BUV.Orientation and Wag.SF40.Value > 0 or not BUV.Orientation and Wag.SF41.Value > 0
    local workingRight = working and BUV.Orientation and Wag.SF41.Value > 0 or not BUV.Orientation and Wag.SF40.Value > 0
    local reserveLeft = Wag:ReadTrainWire(38) > 0
    local reserveRight = Wag:ReadTrainWire(37) > 0
    local selectLeft = workingLeft and BUV.SelectLeft
    local selectRight = workingRight and BUV.SelectRight
    local commandLeft = workingLeft and (selectLeft and BUV.OpenLeft or reserveLeft)
    local commandRight = workingRight and (selectRight and BUV.OpenRight or reserveRight)
    local commandClose = (working and BUV.CloseDoors and BUV.Power * Wag.SF39.Value > 0 or poweron and Wag:ReadTrainWire(39) > 0)

    if addrMode and (commandLeft or commandRight) then
        if not self.ForceOpenTimer then
            self.ForceOpenTimer = CurTime() + 2.5
        end
        if self.ForceOpenTimer < CurTime() then
            addrForceOpen = true
        end
    elseif self.ForceOpenTimer then
        self.ForceOpenTimer = nil
    end

    if commandClose then
        self.DoorLeft = false
        self.DoorRight = false
        for idx = 1, 8 do self.DoorCommand[idx] = false end
    elseif commandLeft and commandRight then
        self.DoorLeft = true
        self.DoorRight = true
        for idx = 1, 8 do if not addrMode or addrForceOpen or (idx == 1 or idx == 5) and BUV.WagIdx == 1 then self.DoorCommand[idx] = true end end
    elseif commandLeft then
        self.DoorLeft = true
        for idx = 1, 4 do if not addrMode or addrForceOpen or idx == 1 and BUV.WagIdx == 1 then self.DoorCommand[idx] = true end end
    elseif commandRight then
        self.DoorRight = true
        for idx = 5, 8 do if not addrMode or addrForceOpen or idx == 5 and BUV.WagIdx == 1 then self.DoorCommand[idx] = true end end
    end

    if not zeroSpeed then
        for idx = 1, 8 do self.DoorCommand[idx] = false end
    end

    self.AddressReadyL = false
    self.AddressReadyR = false

    for idx = 1, 8 do
        local manual = Wag["DoorManualOpenLever" .. idx].Value * Wag["DoorManualOpenLeverPl" .. idx].Value == 1
        local block = Wag["DoorManualBlock" .. idx].Value == 1
        Wag:SetNW2Bool("DoorManualOpenLever" .. idx, manual)
        Wag:SetNW2Bool("DoorManualBlock" .. idx, block)

        local left = idx < 5
        local i = left and idx or (9 - idx)

        local speed = left and self.LeftDoorSpeed[i] or self.RightDoorSpeed[i]
        local dir = left and self.LeftDoorDir or self.RightDoorDir
        local state = left and self.LeftDoorState or self.RightDoorState
        local wagCommandOpen = left and self.DoorLeft or not left and self.DoorRight
        local selected = left and selectLeft or not left and selectRight
        local readyToOpen = addrMode and wagCommandOpen
        local curForceOpen = addrForceOpen or left and reserveLeft or not left and reserveRight

        self.DoorOpen[idx] = state[i] >= 1
        self.DoorClosed[idx] = state[i] <= 0
        if not self.DoorClosed[idx] then
            Wag.DoorsOpened = true
            if left then
                Wag.LeftDoorsOpen = true
            else
                Wag.RightDoorsOpen = true
            end
        end

        if manual or block then
            self.DoorCommand[idx] = false
            readyToOpen = false
        end

        if self.OpenButton[idx] and not buvZeroSpeed and CurTime() >= self.OpenButton[idx] then
            self.OpenButton[idx] = false
        elseif addrMode and working and selected then
            local btn = Wag["DoorAddressButton" .. idx]
            if state[i] == 0 and self.ForeignObject[idx] or btn and btn.Value > 0.5 then
                self.OpenButton[idx] = CurTime() + 8
            end
        end

        if readyToOpen and working then
            if left then
                self.AddressReadyL = true
            else
                self.AddressReadyR = true
            end
            if not self.OpenButton[idx] and not self.MobsOpening[idx] then
                local platform = Wag.LastPlatform
                if not IsValid(platform) or Wag ~= platform.CurrentTrain then
                    platform = nil
                    for _, w in ipairs(Wag.WagonList) do
                        if IsValid(w.LastPlatform) and w.LastPlatform.CurrentTrain == w then
                            platform = w.LastPlatform
                            break
                        end
                    end
                end
                if IsValid(platform) then
                    local halflen = Wag.BUV.TrainLen / 2
                    local wagWeight = math.Clamp(Lerp(math.abs(halflen - Wag.BUV.WagIdx) / halflen, 0.2, 1.0), 0.2, 1.0) / 4
                    local passLoad = wagWeight + platform:PopulationCount() / (200 * halflen)
                    -- print(wagWeight, passLoad - wagWeight, passLoad)
                    local open = math.random() < passLoad
                    if open then
                        self.MobsOpening[idx] = CurTime() + math.Rand(0.2, math.Rand(1.5, math.Rand(2, math.min(10, 10 / (passLoad - 0.3)))))
                    else
                        self.MobsOpening[idx] = CurTime() + math.Rand(16, 600)
                    end
                end
            end
        elseif self.MobsOpening[idx] then
            self.MobsOpening[idx] = false
        end

        if readyToOpen and not self.DoorCommand[idx] and (curForceOpen or self.OpenButton[idx] or self.MobsOpening[idx] and CurTime() >= self.MobsOpening[idx]) then
            self.DoorCommand[idx] = true
        end

        local announceState = "Unpowered"
        if manual and not block then
            announceState = poweron and "Closing" or announceState
            if not self.WasManual[idx] then
                dir[i] = dir[i] + 0.1
                self.WasManual[idx] = true
            end

            local factor = poweron and not zeroSpeed and -0.5 or 0
            local push = Wag["DoorManualOpenPush" .. idx]
            local pull = Wag["DoorManualOpenPull" .. idx]
            local force = 1
            if push and push.Value > 0.5 then factor = factor + 0.6 force = 0.6 end
            if pull and pull.Value > 0.5 then factor = factor - 0.6 force = 0.6 end

            dir[i] = math.Clamp(dir[i] + dT * math.Clamp(factor, -0.8, 0.8), -1 / speed * force, 1 / speed * force)

            local sgn = dir[i] > 0 and -1 or dir[i] < 0 and 1 or 0
            if factor == 0 then
                dir[i] = math.Clamp(dir[i] + dT * sgn * 0.15, -1 / speed, 1 / speed)
            end
            local sgn2 = dir[i] > 0 and -1 or dir[i] < 0 and 1 or 0
            if sgn ~= sgn2 then
                dir[i] = 0
            end

        elseif poweron then
            local commandOpen = self.DoorCommand[idx]
            if commandOpen ~= self.DoorCommandPrev[idx] then
                if self.DoorCommandPrev[idx] == nil or not commandOpen then
                    self.DoorCommandPrev[idx] = commandOpen
                else
                    if not self.DoorCommandDelay[idx] then
                        self.DoorCommandDelay[idx] = CurTime() + self.DoorsDelayMax * (i % 2 == 0 and BUV.WagIdx - 1 or BUV.TrainLen - BUV.WagIdx - 1) / BUV.TrainLen
                        commandOpen = self.DoorCommandPrev[idx]
                    elseif CurTime() >= self.DoorCommandDelay[idx] then
                        self.DoorCommandPrev[idx] = commandOpen
                    else
                        commandOpen = self.DoorCommandPrev[idx]
                    end
                end
            elseif self.DoorCommandDelay[idx] then
                self.DoorCommandDelay[idx] = nil
            end

            announceState = (
                not working and "Closing" or
                not commandOpen and not self.DoorClosed[idx] and "Closing" or
                not commandOpen and self.DoorClosed[idx] and (
                    (not zeroSpeed or not buvZeroSpeed) and "Moving" or
                    zeroSpeed and not selected and "Moving" or
                    zeroSpeed and readyToOpen and not self.Depart and "Open" or
                    "Closed"
                ) or
                commandOpen and not self.Depart and not self.DoorOpen[idx] and (block and "Closed" or addrMode and "Open" or "Opening") or
                self.Depart and "Depart" or
                not buvZeroSpeed and "Moving" or
                commandOpen and "Open" or
                -- fallback, should not reach!
                self.DoorClosed[idx] and "Opening" or "Closing"
            )

            if commandOpen and self.AutoReverse[idx] then self.AutoReverse[idx] = nil end
            if not commandOpen and not self.AutoReverse[idx] and state[i] < 0.65 and state[i] >= 0.15 and dir[i] > -0.4 / speed then
                self.AutoReverse[idx] = 1
                if self.StuckPass[idx] == 1 and math.random() < 0.9 then
                    self.StuckPass[idx] = 0
                end
            end
            if self.AutoReverse[idx] == 1 then
                if state[i] >= 0.85 then
                    self.AutoReverse[idx] = 2
                else
                    commandOpen = true
                end
            end
            if self.AutoReverse[idx] and self.AutoReverse[idx] >= 2 then
                if not commandClose then self.AutoReverse[idx] = 3 end
                if commandClose and self.AutoReverse[idx] == 3 then
                    self.AutoReverse[idx] = nil
                end
            end

            local stuck = false
            if not commandOpen and state[i] >= 0.15 and state[i] < 0.65 then
                stuck = self:GetForeignObject(idx)
            end

            if commandOpen or not self.DoorClosed[idx] and self.CloseDelay[idx] and CurTime() >= self.CloseDelay[idx] then
                dir[i] = math.Clamp(dir[i] + dT * (not stuck and 0.5 or -1.5) * (commandOpen and 1 or -1), -1 / speed, 1 / (not stuck and speed or 10))
            elseif not commandOpen and not self.DoorClosed[idx] and not self.CloseDelay[idx] then
                self.CloseDelay[idx] = self.DoorOpen[idx] and (CurTime() + 1.8 + self.DoorsDelayMax * (i % 2 == 0 and BUV.WagIdx - 1 or BUV.TrainLen - BUV.WagIdx - 1) / BUV.TrainLen) or 0
            elseif self.DoorClosed[idx] and self.CloseDelay[idx] then
                self.CloseDelay[idx] = nil
            end

        elseif dir[i] ~= 0 then
            local sgn = dir[i] > 0 and -1 or dir[i] < 0 and 1 or 0
            dir[i] = math.Clamp(dir[i] + dT * sgn * 0.15, -1 / speed, 1 / speed)
            local sgn2 = dir[i] > 0 and -1 or dir[i] < 0 and 1 or 0
            if sgn ~= sgn2 then
                dir[i] = 0
            end
        end

        if not manual and self.WasManual[idx] then self.WasManual[idx] = false end

        state[i] = math.Clamp(state[i] + dir[i] * dT, 0, not manual and 1 or 0.98)
        if state[i] <= 0 or state[i] >= 1 then dir[i] = 0 end

        if state[i] <= 0 and self.AutoReverse[idx] then
            self.AutoReverse[idx] = nil
        end

        if self.AutoReverse[idx] then
            self.ReverseWork = true
        end

        BUV:CState("DoorAod" .. idx, manual)
        BUV:CState("DoorReverse" .. idx, not not self.AutoReverse[idx])
        Wag:SetPackedRatio((left and "DoorL" or "DoorR") .. i, state[i])
        Wag:SetNW2String("DoorAnnounceState" .. idx, announceState)
        if self.StuckPass[idx] then stuckEmpty = false end
    end

    Wag:SetPackedBool("DoorL", self.DoorLeft)
    Wag:SetPackedBool("DoorR", self.DoorRight)
    Wag.LeftDoorsOpening = self.DoorLeft
    Wag.RightDoorsOpening = self.DoorRight

    if not Wag.DoorsOpened and not stuckEmpty then
        self.StuckPass = {}
    end
    if self.Depart and not Wag.DoorsOpened then self.Depart = false end
end

function TRAIN_SYSTEM:GetForeignObject(idx)
    if not self.ForeignObject[idx] and not self.StuckPass[idx] then
        local canStuck = idx < 5 and self.Train.CanStuckPassengerLeft or idx >= 5 and self.Train.CanStuckPassengerRight
        if canStuck then
            self.StuckPass[idx] = math.random() < (isnumber(canStuck) and math.max(0.002, canStuck) or 0.1) and 1 or 0
        end
    end
    return self.ForeignObject[idx] or self.StuckPass[idx] == 1
end

function TRAIN_SYSTEM:OpenDoorMenu(ply, idx)
    local block = self.Train["DoorManualBlock" .. idx]
    local lever = self.Train["DoorManualOpenLever" .. idx]
    local leverPl = self.Train["DoorManualOpenLeverPl" .. idx]
    if block and lever and leverPl then
        net.Start("BUD765.DoorMenu")
            net.WriteEntity(self.Train)
            net.WriteUInt(idx, 8)
            net.WriteBool(block.Value == 1)
            net.WriteBool(lever.Value == 1)
            net.WriteBool(leverPl.Value == 1)
        net.Send(ply)
    end
end

if TURBOSTROI then return end

if SERVER then
    util.AddNetworkString("BUD765.DoorMenu")
    net.Receive("BUD765.DoorMenu", function(_, ply)
        local wagon = net.ReadEntity()
        local switch = net.ReadString()
        if not IsValid(wagon) then return end
        switch = wagon[switch] or nil
        if wagon.BUD and switch and switch.TriggerInput then
            switch:TriggerInput("Set", switch.Value == 0 and 1 or 0)
        end
    end)
else
    local mat_off = "models/metrostroi_train/81-765/led_off"
    local mat_red = "models/metrostroi_train/81-765/led_red"
    local mat_green = "models/metrostroi_train/81-765/led_green"
    local mat_white = "models/metrostroi_train/81-765/led_white"

    function TRAIN_SYSTEM:ClientInitialize()
        self.WasOpen = {}
        self.DelayTimer = {}
    end

    function TRAIN_SYSTEM:ClientThink()
        if (self.nextClThink or 0) > CurTime() then return end
        self.nextClThink = CurTime() + 0.05

        local Wag = self.Train
        for idx = 1, 8 do
            local state = Wag:GetNW2String("DoorAnnounceState" .. idx, "Closed")
            local alarm = state == "Closing"
            Wag:SetSoundState("door_alarm_" .. idx, alarm and 1 or 0, alarm and 1 or 0)

            local door, inter
            local blink = CurTime() % 0.4 >= 0.25

            local delay = self.DelayTimer[idx] and CurTime() < self.DelayTimer[idx] or state ~= "Open" and self.WasOpen[idx]
            if delay and not self.DelayTimer[idx] then
                self.DelayTimer[idx] = CurTime() + 0.2
                self.WasOpen[idx] = false
            elseif not delay then
                self.DelayTimer[idx] = nil
            end

            if state == "Moving" then
                door = mat_off
                inter = mat_white
            elseif state == "Closed" then
                door = mat_red
                inter = mat_red
            elseif state == "Closing" then
                door = blink and mat_off or mat_red
                inter = blink and mat_off or mat_red
            elseif state == "Depart" then
                door = mat_red
                inter = not delay and mat_red or mat_off
            elseif state == "Open" then
                self.WasOpen[idx] = true
                door = mat_green
                inter = mat_green
            elseif state == "Opening" then
                door = blink and mat_off or mat_red
                inter = blink and mat_off or mat_red
            else  -- Unpowered
                door = mat_off
                inter = mat_off
            end

            local left = idx < 5
            local i = (left and idx or (9 - idx)) - 1
            local did = "door" .. i .. "x" .. (left and 1 or 0)
            local doorEnt = Wag.ClientEnts[did]
            if IsValid(doorEnt) then
                doorEnt:SetSubMaterial(0, door)
                doorEnt:SetSubMaterial(6, inter)
            end
        end
    end

    local panel = nil

    local function addButton(parent, stext, state, scolor, btext, benabled, switchName)
        local bpanel = vgui.Create("DPanel")
        bpanel:Dock( TOP )
        bpanel:DockMargin( 5, 0, 5, 5 )
        bpanel:DockPadding( 5, 5, 5, 5 )
        if benabled then
            local button = vgui.Create("DButton",bpanel)
            button:Dock(RIGHT)
            button:SetText(btext)
            button:DockPadding( 5, 5, 5, 5 )
            button:SizeToContents()
            button:SetContentAlignment(5)
            button:SetEnabled(benabled)
            button.DoClick = function()
                if not panel or not IsValid(panel.wagon) then return end
                net.Start("BUD765.DoorMenu")
                    net.WriteEntity(panel.wagon)
                    net.WriteString(switchName .. panel.doorIdx)
                net.SendToServer()
                panel:Close()
            end
        end

        vgui.MetrostroiDrawCutText(bpanel, stext, false, "DermaDefaultBold")
        vgui.MetrostroiDrawCutText(bpanel, state, scolor, "DermaDefaultBold")

        bpanel:InvalidateLayout( true )
        bpanel:SizeToChildren(true,true )
        parent:AddItem(bpanel)
    end

    net.Receive("BUD765.DoorMenu", function()
        local wagon = net.ReadEntity()
        local idx = net.ReadUInt(8)
        local block = net.ReadBool()
        local lever = net.ReadBool()
        local leverPl = net.ReadBool()

        if IsValid(panel) then panel:Close() end
        panel = vgui.Create("DFrame")
        panel:SetDeleteOnClose(true)
        panel:SetTitle("Дверной проем №" .. idx)
        panel:SetSize(0, 0)
        panel:SetDraggable(true)
        panel:SetSizable(false)
        panel:MakePopup()

        panel.wagon = wagon
        panel.doorIdx = idx

        local scrollPanel = vgui.Create("DScrollPanel", panel)

        addButton(scrollPanel, "Ручная блокировка",
            block and "Заблокировано" or "Разблокировано",
            block and Color(150,50,0) or Color(0,150,0),
            block and "Разблокировать" or "Блокировать", true,
            "DoorManualBlock")
        addButton(scrollPanel, "Переключатель ручного открытия",
            not leverPl and "Опломбирован" or not lever and "Распломбирован, выключен" or "Включен",
            not leverPl and Color(0,150,0) or not lever and Color(150,150,0) or Color(150,50,0),
            not leverPl and "Распломбировать" or lever and "Выключить" or "Включить", true,
            not leverPl and "DoorManualOpenLeverPl" or "DoorManualOpenLever")

        scrollPanel:Dock( FILL )
        scrollPanel:InvalidateLayout( true )
        scrollPanel:SizeToChildren(false,true)
        local spPefromLayout = scrollPanel.PerformLayout
        function scrollPanel:PerformLayout()
            spPefromLayout(self)
            if not self.First then self.First = true return end
            local _, y = scrollPanel:ChildrenSize()
            if self.Centered then return end
            self.Centered = true
            panel:SetSize(512,math.min(350, y) + 35)
            panel:Center()
        end
    end)
end
