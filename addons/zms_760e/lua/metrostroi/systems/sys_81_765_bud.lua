--------------------------------------------------------------------------------
-- Блок Управления Дверьми
--------------------------------------------------------------------------------

Metrostroi.DefineSystem("81_765_BUD")
TRAIN_SYSTEM.DontAccelerateSimulation = true

function TRAIN_SYSTEM:Initialize()
    self.Depart = false
    self.DoorLeft = false
    self.DoorRight = false
    self.CloseDoors = false
    self.ManualReverse = false
    self.ReverseWork = false
    self.AddressReadyL = false
    self.AddressReadyR = false
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
        self.DoorSpeedMain = math.Rand(1.1, math.Rand(1.3, 1.6))
        for i = 1, #self.LeftDoorSpeed do
            self.LeftDoorSpeed[i] = math.Rand(self.DoorSpeedMain + 0.1, self.DoorSpeedMain + 0.3)
            self.RightDoorSpeed[i] = math.Rand(self.DoorSpeedMain + 0.1, self.DoorSpeedMain + 0.3)
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
    local workingLeft = working and BUV.Orientation and Wag.SF40.Value > 0 or not BUV.Orientation and Wag.SF41.Value > 0
    local workingRight = working and BUV.Orientation and Wag.SF41.Value > 0 or not BUV.Orientation and Wag.SF40.Value > 0
    local reserveLeft = Wag:ReadTrainWire(38) > 0
    local reserveRight = Wag:ReadTrainWire(37) > 0
    local commandLeft = workingLeft and (BUV.OpenLeft or reserveLeft)
    local commandRight = workingRight and (BUV.OpenRight or reserveRight)
    local commandClose = (BUV.CloseDoors or Wag:ReadTrainWire(39) > 0) and BUV.Power * Wag.SF39.Value > 0
    if commandClose then
        self.DoorLeft = false
        self.DoorRight = false
    elseif commandLeft and commandRight then
        self.DoorLeft = true
        self.DoorRight = true
    elseif commandLeft then
        self.DoorLeft = true
    elseif commandRight then
        self.DoorRight = true
    end

    local sideOpen = (self.DoorLeft and not self.DoorRight or self.DoorRight and not self.DoorLeft) and not commandClose
    local stuckEmpty = true
    local zeroSpeed = Wag.SF80F9.Value > 0 and Wag.Speed < 1.8
    local addrMode = BUV.AddressDoors
    local forceOpen = false

    if addrMode and (commandLeft or commandRight) then
        if not self.ForceOpenTimer then
            self.ForceOpenTimer = CurTime() + 3
        end
        if self.ForceOpenTimer < CurTime() then
            forceOpen = true
        end
    elseif self.ForceOpenTimer then
        self.ForceOpenTimer = nil
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

        local dir = left and self.LeftDoorDir or self.RightDoorDir
        local speed = left and self.LeftDoorSpeed or self.RightDoorSpeed
        local state = left and self.LeftDoorState or self.RightDoorState
        local commandOpen = zeroSpeed and (left and self.DoorLeft or not left and self.DoorRight)
        forceOpen = forceOpen or left and workingLeft and reserveLeft or right and workingRight and reserveRight

        if addrMode then
            local btn = Wag["DoorAddressButton" .. idx]
            if state[i] == 0 and self.ForeignObject[idx] or btn and btn.Value > 0.5 then
                self.OpenButton[idx] = true
            end
        else
            self.OpenButton[idx] = true
        end

        local readyToOpen = false
        if not commandOpen and self.OpenButton[idx] then self.OpenButton[idx] = false end
        if addrMode and commandOpen then
            commandOpen = state[i] > 0 or Wag.RV and (idx == 1 or idx == 5) or forceOpen or self.OpenButton[idx] or false
            readyToOpen = true
        end
        if readyToOpen then
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
                        self.MobsOpening[idx] = CurTime() + math.Rand(20, 120)
                    end
                end

            end
        elseif self.MobsOpening[idx] then
            self.MobsOpening[idx] = false
        end

        if addrMode and self.MobsOpening[idx] and self.MobsOpening[idx] < CurTime() then
            self.MobsOpening[idx] = false
            self.OpenButton[idx] = true
        end

        local announceState = zeroSpeed and (self.Depart and "Depart" or (commandOpen or readyToOpen) and "Open" or not sideOpen and "Closed") or "Moving"

        if block then
            if state[i] > 0 then
                dir[i] = math.max(-1.5, dir[i] - dT / 2 * speed[i])
                state[i] = math.Clamp(state[i] + (dir[i] / speed[i] * dT), 0, 1)
            end
            if state[i] == 0 then dir[i] = 0 end

        elseif manual then
            if not self.WasManual[idx] then
                self.WasManual[idx] = true
                if state[i] == 0 then
                    state[i] = 0.05
                end
            end

            local push = Wag["DoorManualOpenPush" .. idx].Value > 0
            local pull = Wag["DoorManualOpenPull" .. idx].Value > 0
            if push then
                dir[i] = math.Clamp(dir[i] + dT / 0.5 * speed[i], -0.5, 0.5)
            elseif pull or poweron and not zeroSpeed then
                dir[i] = math.Clamp(dir[i] + dT / -0.5 * speed[i], -0.5, 0.5)
            elseif dir[i] ~= 0 then
                if dir[i] > 0 then
                    dir[i] = math.max(0, dir[i] - dT / 4 * speed[i])
                else
                    dir[i] = math.min(0, dir[i] + dT / 4 * speed[i])
                end
            end
            state[i] = math.Clamp(state[i] + (dir[i] / speed[i] * dT), 0, 1)
            if state[i] == 0 or state[i] == 1 then dir[i] = 0 end

        elseif poweron then
            if not self.AutoReverse[idx] and not commandOpen and state[i] < 0.35 and state[i] > 0.15 and self:GetForeignObject(idx) then
                self.AutoReverse[idx] = 1
            elseif commandOpen and self.AutoReverse[idx] then
                self.AutoReverse[idx] = nil
            end
            if self.AutoReverse[idx] == 1 then
                if state[i] >= 0.5 then
                    self.AutoReverse[idx] = 2
                    if self.StuckPass[idx] == 1 and math.random() < 0.92 then
                        self.StuckPass[idx] = 0
                    end
                else
                    commandOpen = true
                    dir[i] = math.max(dir[i], -0.2)
                    if dir[i] >= 0 and dir[i] < 0.5 then dir[i] = 0.5 end
                end
            end

            if self.AutoReverse[idx] and self.AutoReverse[idx] >= 2 and state[i] < 0.35 and self:GetForeignObject(idx) then
                dir[i] = 0
                if not commandClose then self.AutoReverse[idx] = 3 end
                if self.AutoReverse[idx] == 3 and commandClose then self.AutoReverse[idx] = 1 self.ManualReverse = true end
            else
                dir[i] = math.Clamp(dir[i] + dT / (commandOpen and 2 * speed[i] or -speed[i]), -1.5, 1)
            end

            state[i] = math.Clamp(state[i] + (dir[i] / speed[i] * dT), 0, 1)
            if state[i] == 0 or state[i] == 1 then dir[i] = 0 end
            if self.AutoReverse[idx] and self.AutoReverse[idx] >= 2 and state[i] == 0 then
                self.AutoReverse[idx] = nil
            end
        end

        if not manual and self.WasManual[idx] then self.WasManual[idx] = nil end

        if state[i] > 0 then
            Wag.DoorsOpened = true
            if left then
                Wag.LeftDoorsOpen = true
            else
                Wag.RightDoorsOpen = true
            end
            if not zeroSpeed or Wag.BUV.CloseDoorsCommand and not manual then
                announceState = "Closing"
            elseif zeroSpeed and state[i] < 1 and commandOpen and not block then
                announceState = (not addrMode or forceOpen) and "Opening" or "Open"
            end
        end
        if (manual or zeroSpeed and block) and announceState ~= "Closing" then
            announceState = manual and "Closing" or "Closed"
        elseif not self.Depart and announceState ~= "Closing" and readyToOpen and not forceOpen then
            announceState = "Open"
        end

        if self.AutoReverse[idx] then
            self.ReverseWork = true
        end

        BUV:CState("DoorReverse" .. idx, not not self.AutoReverse[idx])
        Wag:SetPackedRatio((left and "DoorL" or "DoorR") .. i, state[i])
        Wag:SetNW2String("DoorAnnounceState" .. idx, poweron and announceState or "Unpowered")
        if self.StuckPass[idx] then stuckEmpty = false end
    end

    Wag:SetPackedBool("DoorL", self.DoorLeft)
    Wag:SetPackedBool("DoorR", self.DoorRight)
    Wag.LeftDoorsOpening = self.DoorLeft
    Wag.RightDoorsOpening = self.DoorRight

    if not Wag.DoorsOpened and not stuckEmpty then
        self.StuckPass = {}
    end

    if not self.ReverseWork then
        self.ManualReverse = false
    end
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
