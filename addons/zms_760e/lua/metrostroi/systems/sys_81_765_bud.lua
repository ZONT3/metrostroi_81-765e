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
    self.Working = {}
    self.Starting = {}

    self.DoorClosed = {}
    self.DoorOpen = {}
    self.DoorCommand = {}
    self.DoorCommandPrev = {}
    self.DoorCommandDelay = {}
    self.DoorReverseMalfunc = {}
    self.CloseDelay = {}
    self.DoorsDelayMax = 0.5
    for idx = 1, 8 do self.DoorCommand[idx] = false end

    if not TURBOSTROI then
        self.LeftDoorClosed = {0, 0, 0, 0}
        self.RightDoorClosed = {0, 0, 0, 0}
        self.LeftDoorState = {0, 0, 0, 0}
        self.RightDoorState = {0, 0, 0, 0}
        self.LeftDoorDir = {0, 0, 0, 0}
        self.RightDoorDir = {0, 0, 0, 0}
        self.LeftDoorSpeed = {0, 0, 0, 0}
        self.RightDoorSpeed = {0, 0, 0, 0}
        self.OpenedTimer = {}
        self.ReverseDelay = {}
        self.ForeignObject = {}
        self.AutoReverse = {}
        self.ReverseFailed = {0, 0, 0, 0, 0, 0, 0, 0}
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
    if name ~= "Depart" then return end
    self.Depart = value
    if not value then
        for idx = 1, 8 do
            self.OpenButton[idx] = (math.random() < math.min(0.6, self.Train:GetNW2Float("PassengerCount") / 200)) and CurTime() or self.OpenButton[idx]
        end
    end
end


if TURBOSTROI then return end

if SERVER then
    local DoorSFs = {
        "SF80F14", "SF80F13", "SF80F12", "SF80F14",
        "SF80F14", "SF80F12", "SF80F13", "SF80F12"
    }

    function TRAIN_SYSTEM:Think(dT)
        local Wag = self.Train
        local BUV = Wag.BUV

        Wag.LeftDoorsOpen = false
        Wag.RightDoorsOpen = false
        Wag.DoorsOpened = false

        self.ReverseWork = false

        self.AnnounceStates = self.AnnounceStates or {}

        local masterPower = Wag.Electric.KM > 0
        local masterWorking = masterPower and BUV.BUDWork

        if masterPower and not masterWorking then
            self.DoorLeft = false
            self.DoorRight = false
            for idx = 1, 8 do self.DoorCommand[idx] = false end
        end

        local stuckEmpty = true
        local zeroSpeed = BUV.ZeroSpeed > 0
        local bupActive = BUV.BupActive and zeroSpeed
        local addrMode = BUV.AddressDoors
        local addrForceOpen = false
        local reverseMode = Wag:GetNW2Int("DoorReverseMode", 1)

        if self.BupActive ~= bupActive then
            if not self.BupChanging then
                self.BupChanging = CurTime() + math.Rand(0.08, 0.2) + (bupActive and 0.5 or 0)
            elseif CurTime() >= self.BupChanging then
                self.BupChanging = nil
                self.BupActive = bupActive
            end
        end

        local visualZeroSpeed = zeroSpeed
        if zeroSpeed then
            visualZeroSpeed = false
            if not self.VisualZeroSpeedTimer then
                self.VisualZeroSpeedTimer = CurTime() + 1.4
            elseif CurTime() >= self.VisualZeroSpeedTimer then
                visualZeroSpeed = true
            end
        elseif self.VisualZeroSpeedTimer then
            self.VisualZeroSpeedTimer = nil
        end

        local workingLeft = masterWorking and BUV.Orientation and (Wag.SF80F10.Value * Wag.SF80F7.Value) > 0 or not BUV.Orientation and (Wag.SF80F10.Value * Wag.SF80F7.Value) > 0
        local workingRight = masterWorking and BUV.Orientation and (Wag.SF80F11.Value * Wag.SF80F6.Value) > 0 or not BUV.Orientation and (Wag.SF80F11.Value * Wag.SF80F6.Value) > 0
        local reserveLeft = Wag:ReadTrainWire(38) > 0
        local reserveRight = Wag:ReadTrainWire(37) > 0
        local selectLeft = workingLeft and BUV.SelectLeft
        local selectRight = workingRight and BUV.SelectRight
        local commandLeft = workingLeft and (selectLeft and BUV.OpenLeft or reserveLeft)
        local commandRight = workingRight and (selectRight and BUV.OpenRight or reserveRight)
        local commandClose = (masterWorking and BUV.CloseDoors and BUV.Power * Wag.SF80F8.Value > 0 and Wag:ReadTrainWire(40) < 1 or masterPower and Wag:ReadTrainWire(39) > 0)

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
            self.OpenTimer = nil
            for idx = 1, 8 do self.DoorCommand[idx] = false end
        elseif commandLeft and commandRight then
            self.DoorLeft = true
            self.DoorRight = true
            for idx = 1, 8 do
                if not addrMode then self.DoorCommand[idx] = true
                elseif addrForceOpen or BUV.WagIdx == 1 and (idx == 1 or idx == 5)
                then self.OpenButton[idx] = CurTime() end
            end
        elseif commandLeft then
            self.DoorLeft = true
            for idx = 1, 4 do
                if not addrMode then self.DoorCommand[idx] = true
                elseif addrForceOpen or BUV.WagIdx == 1 and idx == 1
                then self.OpenButton[idx] = CurTime() end
            end
        elseif commandRight then
            self.DoorRight = true
            for idx = 5, 8 do
                if not addrMode then self.DoorCommand[idx] = true
                elseif addrForceOpen or BUV.WagIdx == 1 and idx == 5
                then self.OpenButton[idx] = CurTime() end
            end
        end

        if not zeroSpeed then
            for idx = 1, 8 do self.DoorCommand[idx] = false end
        end

        self.AddressReadyL = false
        self.AddressReadyR = false

        local anyClosingLeft, anyClosingRight = false, false

        for idx = 1, 8 do
            local sf = Wag[DoorSFs[idx]]
            local poweron = masterPower and sf and sf.Value > 0
            local working = masterWorking and sf and sf.Value > 0
            if not working and self.Working[idx] then self.Working[idx] = false self.Starting[idx] = false end
            if working and not self.Working[idx] and not self.Starting[idx] then self.Starting[idx] = CurTime() + 5 end
            if self.Starting[idx] and CurTime() >= self.Starting[idx] then self.Starting[idx] = false self.Working[idx] = true end
            working = self.Working[idx]
            poweron = poweron and (working or self.Starting[idx] and self.Starting[idx] - CurTime() < 0.3)

            if not working then
                self.DoorCommand[idx] = false
            end

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

            local closedState = left and self.LeftDoorClosed or self.RightDoorClosed
            if (
                self.DoorClosed[idx] and not self.AutoReverse[idx] and not closedState[i] and
                math.random() < 0.004 + (self.DoorReverseMalfunc[idx] or 0)
            ) then self.AutoReverse[idx] = 1 print(self.Train:GetWagonNumber(), idx, "protivoza4atie") end
            closedState[i] = self.DoorClosed[idx] and (closedState[i] or CurTime() + 0.05)
            local isclosed = closedState[i] and CurTime() >= closedState[i]

            if wagCommandOpen and not self.OpenTimer then
                self.OpenTimer = CurTime() + 2.7
            end

            if manual or block then
                self.DoorCommand[idx] = false
                readyToOpen = false
            end

            local addressActive = addrMode and working
            if self.OpenButton[idx] and (not addressActive or not bupActive and CurTime() >= self.OpenButton[idx] + 60) then
                self.OpenButton[idx] = false
            elseif addressActive and not self.OpenButton[idx] then
                local btn = Wag["DoorAddressButton" .. idx]
                if state[i] == 0 and self.ForeignObject[idx] or btn and btn.Value > 0.5 then
                    self.OpenButton[idx] = CurTime()
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
                        elseif math.random() < 0.9 then
                            self.MobsOpening[idx] = CurTime() + math.Rand(16, 600)
                        end
                    end
                end
            elseif self.MobsOpening[idx] then
                self.MobsOpening[idx] = false
            end

            if not self.DoorClosed[idx] and not self.OpenedTimer[idx] then
                self.OpenedTimer[idx] = CurTime() + 28
            elseif self.DoorClosed[idx] and self.OpenedTimer[idx] then
                self.OpenedTimer[idx] = nil
            end

            if readyToOpen and not self.DoorCommand[idx] and (curForceOpen or self.OpenButton[idx] or self.MobsOpening[idx] and CurTime() >= self.MobsOpening[idx]) then
                self.OpenButton[idx] = CurTime()
                self.DoorCommand[idx] = zeroSpeed
            end

            local announceState = "Unpowered"
            if manual and not block then
                announceState = poweron and "Closing" or announceState
                if not self.WasManual[idx] then
                    dir[i] = dir[i] + 0.1
                    self.WasManual[idx] = true
                    self.AutoReverse[idx] = 4
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

                self.OpenButton[idx] = false

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
                    self.BupChanging and "Moving" or
                    not commandOpen and not isclosed and "Closing" or
                    not commandOpen and isclosed and (
                        not visualZeroSpeed and "Moving" or
                        not selected and addrMode and "Moving" or
                        bupActive and readyToOpen and (self.Depart and "Depart" or "ReadyToOpen") or
                        "Closed"
                    ) or
                    self.Depart and "Depart" or
                    commandOpen and not self.DoorOpen[idx] and (
                        block and "Closed" or
                        addrMode and "OpeningAddr" or
                        "Opening"
                    ) or
                    not bupActive and "Unpowered" or
                    commandOpen and "Open" or
                    -- fallback, should not reach!
                    isclosed and "Opening" or "Closing"
                )

                if announceState == "Closing" and working and bupActive then
                    if left then anyClosingLeft = true
                    else anyClosingRight = true end
                end

                if commandOpen and self.AutoReverse[idx] then
                    self.AutoReverse[idx] = nil
                    self.ReverseDelay[idx] = nil
                    self.ReverseFailed[idx] = 0
                end
                local shouldReverse = not self.AutoReverse[idx] or reverseMode == 3 and self.AutoReverse[idx] == 2 and CurTime() - (self.ReverseDelay[idx] or 0) > 1
                if shouldReverse and not commandOpen and state[i] < 0.65 and state[i] >= 0.15 and dir[i] > -0.4 / speed then
                    self.AutoReverse[idx] = 1 + math.min(0.85, state[i] + 0.4)
                    self.ReverseDelay[idx] = CurTime() + 0.4
                end
                if self:IsReverseOpening(idx) then
                    if state[i] >= math.max(self.AutoReverse[idx] - 1, 0.35) then
                        self.AutoReverse[idx] = 2
                        self.ReverseFailed[idx] = self.ReverseFailed[idx] + 1
                        self.ReverseDelay[idx] = CurTime() + 0.4
                        if self.StuckPass[idx] == 1 and math.random() < 0.9 then
                            self.StuckPass[idx] = 0
                            print(self.Train:GetWagonNumber(), idx, "otjali")
                        elseif self.StuckPass[idx] == 1 then
                            print(self.Train:GetWagonNumber(), idx, "zastryal")
                        end
                    else
                        commandOpen = true
                    end
                end
                if self.AutoReverse[idx] and self.AutoReverse[idx] >= 2 and (reverseMode ~= 2 or self.ReverseFailed[idx] < 2) then
                    if not commandClose then self.AutoReverse[idx] = 3 end
                    if commandClose and self.AutoReverse[idx] == 3 then
                        if reverseMode == 3 then
                            self.AutoReverse[idx] = 2
                            self.ReverseFailed[idx] = 0
                            self.ReverseDelay[idx] = CurTime()
                        else
                            self.AutoReverse[idx] = 1 + math.Clamp(state[i] + 0.2, 0.35, 0.85)
                        end
                    end
                end
                if reverseMode == 3 and self.AutoReverse[idx] and self.AutoReverse[idx] >= 2 and self.ReverseFailed[idx] >= 3 then
                    if self.AutoReverse[idx] == 2 then
                        self.AutoReverse[idx] = 1
                    else
                        self.ReverseDelay[idx] = CurTime() + 1
                    end
                end

                local stuck = false
                if not commandOpen and state[i] >= 0.15 and state[i] < 0.65 then
                    stuck = self:GetForeignObject(idx)
                end

                if self.AutoReverse[idx] then self.CloseDelay[idx] = 0 end

                if not self.ReverseDelay[idx] or CurTime() >= self.ReverseDelay[idx] then
                    if commandOpen or not self.DoorClosed[idx] and self.CloseDelay[idx] and CurTime() >= self.CloseDelay[idx] then
                        dir[i] = math.Clamp(dir[i] + dT * (not stuck and 0.5 or -1.5) * (commandOpen and 1 or -1), -1 / speed, not stuck and (1 / speed) or 0)
                    elseif not commandOpen and not self.DoorClosed[idx] and not self.CloseDelay[idx] then
                        self.CloseDelay[idx] = self.DoorOpen[idx] and (CurTime() + 2.1 + self.DoorsDelayMax * (i % 2 == 0 and BUV.WagIdx - 1 or BUV.TrainLen - BUV.WagIdx - 1) / BUV.TrainLen) or 0
                        clState = 1
                    end
                else
                    dir[i] = 0
                end

                if (commandOpen or self.DoorClosed[idx]) and self.CloseDelay[idx] then
                    self.CloseDelay[idx] = nil
                end

                if self.OpenButton[idx] and self.Depart and (not zeroSpeed or commandClose and not selected and zeroSpeed) then
                    self.OpenButton[idx] = false
                end

            elseif dir[i] ~= 0 then
                local sgn = dir[i] > 0 and -1 or dir[i] < 0 and 1 or 0
                dir[i] = math.Clamp(dir[i] + dT * sgn * 0.15, -1 / speed, 1 / speed)
                local sgn2 = dir[i] > 0 and -1 or dir[i] < 0 and 1 or 0
                if sgn ~= sgn2 then
                    dir[i] = 0
                end
                self.OpenButton[idx] = false
            end

            if not manual and self.WasManual[idx] then self.WasManual[idx] = false end

            state[i] = math.Clamp(state[i] + dir[i] * dT, 0, not manual and 1 or 0.98)
            if state[i] <= 0 or state[i] >= 1 then dir[i] = 0 end

            if closedState[i] and CurTime() >= closedState[i] and (self.AutoReverse[idx] and self.AutoReverse[idx] >= 2 or self.ReverseFailed[idx] > 0) then
                self.AutoReverse[idx] = nil
                self.ReverseDelay[idx] = nil
                self.ReverseFailed[idx] = 0
            end

            if self.AutoReverse[idx] and self.AutoReverse[idx] < 4 then
                self.ReverseWork = true
            end

            if self.StuckPass[idx] then stuckEmpty = false end

            BUV:CState("DoorAod" .. idx, manual)
            BUV:CState("DoorReverse" .. idx, not manual and self.AutoReverse[idx] and self.AutoReverse[idx] < 4)
            Wag:SetPackedRatio("Door" .. idx, math.Clamp(state[i], 0, 1))
            Wag:SetPackedRatio("DoorDir" .. idx, dir[i])
            Wag:SetNW2Int("DoorButtonLed" .. idx, addrMode and
                (self.OpenButton[idx] or readyToOpen) and poweron and working and not manual and (
                    (not self.DoorCommand[idx] and not isclosed or self.OpenButton[idx] and isclosed and selected and self.Depart) and 2 or 1) or 0)

            self.AnnounceStates[idx] = announceState
        end

        Wag:SetPackedBool("DoorL", self.DoorLeft)
        Wag:SetPackedBool("DoorR", self.DoorRight)
        Wag.LeftDoorsOpening = self.DoorLeft
        Wag.RightDoorsOpening = self.DoorRight

        for idx = 1, 8 do
            local selected = idx < 5 and selectLeft or idx >= 5 and selectRight
            local openTimer = selected and self.OpenTimer and CurTime() < self.OpenTimer
            local anyClosing = idx < 5 and anyClosingLeft or idx >= 5 and anyClosingRight
            local announceState = self.AnnounceStates[idx]
            if openTimer and announceState == "OpeningAddr" then
                announceState = "Opening"
            end
            if announceState == "ReadyToOpen" then
                announceState = openTimer and "OpeningAddr" or "Open"
            end
            if announceState == "Closed" and anyClosing then announceState = "ClosingAwaiting" end
            if announceState == "Closing" and self:IsReverseOpening(idx) or self.AutoReverse[idx] == 3 and reverseMode == 3 then announceState = "ClosingAwaiting" end
            Wag:SetNW2String("DoorAnnounceState" .. idx, announceState)
        end

        if not self.Depart and commandClose and Wag.DoorsOpened then
            self.Depart = true
        end

        if not Wag.DoorsOpened and not stuckEmpty then
            self.StuckPass = {}
        end
        if self.Depart and (not zeroSpeed or commandLeft or commandRight) then self.Depart = false end
    end

    function TRAIN_SYSTEM:IsReverseOpening(idx)
        return self.AutoReverse[idx] and self.AutoReverse[idx] >= 1 and self.AutoReverse[idx] < 2
    end

    function TRAIN_SYSTEM:GetForeignObject(idx)
        if not self.ForeignObject[idx] and not self.StuckPass[idx] then
            local passCount = math.max(0, self.Train:GetNW2Float("PassengerCount"))
            local canStuck = 0
            if self.OpenedTimer[idx] and self.OpenedTimer[idx] >= CurTime() then
                canStuck = math.pow((self.OpenedTimer[idx] - CurTime()) / 28, 2) * passCount / 1700
            end

            local base = canStuck
            canStuck = math.Clamp(canStuck, 0, 0.08)

            local dynamic = math.min(0.65, canStuck + (idx < 5 and self.Train.CanStuckPassengerLeft or idx >= 5 and self.Train.CanStuckPassengerRight or 0) * 0.5)
            local static = math.max(passCount > 120 and (canStuck + math.pow(math.min(120, passCount - 120) / 240, 3) * 0.08) or 0, base)
            canStuck = math.max(dynamic, static)

            self.StuckPass[idx] = math.random() < canStuck and 1 or 0

            if self.StuckPass[idx] == 1 then print(
                self.Train:GetWagonNumber(), idx, "zajali",
                math.Round(base, 3),
                math.Round(self.OpenedTimer[idx] and self.OpenedTimer[idx] >= CurTime() and ((self.OpenedTimer[idx] - CurTime()) / 14) or 0, 3),
                math.Round(dynamic, 3), math.Round(static, 3), math.Round(canStuck, 3)
            ) end
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

    function TRAIN_SYSTEM:ClientThink(dT)
        local Wag = self.Train
        local leftSideBuzzer, rightSideBuzzer = true, true
        for idx = 1, 8 do
            if Wag:GetNW2String("DoorAnnounceState" .. idx, "Closed") ~= "Closing" then
                if idx < 5 then
                    leftSideBuzzer = false
                    idx = 4
                else
                    rightSideBuzzer = false
                    break
                end
            end
        end
        Wag:SetSoundState("door_alarm_l", leftSideBuzzer and 1 or 0, leftSideBuzzer and 1 or 0)
        Wag:SetSoundState("door_alarm_r", rightSideBuzzer and 1 or 0, rightSideBuzzer and 1 or 0)

        for idx = 1, 8 do
            local announceState = Wag:GetNW2String("DoorAnnounceState" .. idx, "Closed")
            local buzzer = announceState == "Closing" and not (idx < 5 and leftSideBuzzer or idx >= 5 and rightSideBuzzer)
            Wag:SetSoundState("door_alarm_" .. idx, buzzer and 1 or 0, buzzer and 1 or 0)

            local outer, inter
            local blink1 = CurTime() % 0.4 >= 0.25
            local blink2 = (CurTime() + 0.2) % 0.4 >= 0.25

            local delay = self.DelayTimer[idx] and CurTime() < self.DelayTimer[idx] or announceState ~= "Open" and self.WasOpen[idx]
            if delay and not self.DelayTimer[idx] then
                self.DelayTimer[idx] = CurTime() + 0.2
                self.WasOpen[idx] = false
            elseif not delay then
                self.DelayTimer[idx] = nil
            end

            if announceState == "Moving" then
                outer = mat_off
                inter = mat_white
            elseif announceState == "Closed" then
                outer = mat_red
                inter = mat_red
            elseif announceState == "Closing" or announceState == "ClosingAwaiting" then
                outer = (announceState == "ClosingAwaiting" or blink1) and mat_off or mat_red
                inter = blink2 and mat_off or mat_red
            elseif announceState == "Depart" then
                outer = mat_red
                inter = not delay and mat_red or mat_off
            elseif announceState == "Open" then
                self.WasOpen[idx] = true
                outer = mat_green
                inter = mat_green
            elseif announceState == "Opening" or announceState == "OpeningAddr" then
                outer = announceState == "OpeningAddr" and mat_green or blink1 and mat_off or mat_red
                inter = blink2 and mat_off or mat_red
            else  -- Unpowered
                outer = mat_off
                inter = mat_off
            end

            local did = "Door" .. idx
            local doorEnt = Wag.ClientEnts[did]
            if IsValid(doorEnt) then
                doorEnt:SetSubMaterial(3, outer)
                doorEnt:SetSubMaterial(4, inter)
            end

            local state = Wag:GetPackedRatio("Door" .. idx)
            Wag:HidePanel("DoorManual" .. idx, not Wag:GetNW2Bool("DoorManualOpenLever" .. idx, false))
            Wag:HidePanel("DoorManualOutside" .. idx, not Wag:GetNW2Bool("DoorManualOpenLever" .. idx, false))
            local open = state > 0
            Wag:HidePanel("DoorManualBlock" .. idx, open)
            Wag:HidePanel("DoorAddressOpen" .. idx, open or not Wag:GetNW2Bool("AddressDoors", false))
            Wag:HidePanel("DoorAddressOpenOutside" .. idx, open or not Wag:GetNW2Bool("AddressDoors", false))
            local btnKey = "DoorArrdessButton" .. idx
            Wag:ShowHide(btnKey, Wag:GetNW2Bool("AddressDoors", false))

            local door = Wag.ClientEnts["Door" .. idx]
            local targetState = 1 - (Wag:GetPackedRatio("Door" .. idx) or 0)
            local animState = targetState
            local delta = 0
            local prev = 1
            if IsValid(door) then
                local dir = -(Wag:GetPackedRatio("DoorDir" .. idx) or 0)
                animState = door.AnimState or animState
                prev = animState
                if dir == 0 then
                    local d1 = targetState - animState
                    if math.abs(d1) > 0.001 then
                        dir = d1 > 0 and 1 or -1
                    end
                    animState = math.Clamp(animState + dir * dT, 0, 1)
                    local d2 = targetState - animState
                    if d1 * d2 < 0 then animState = targetState end
                else
                    animState = math.Clamp(animState + dir * dT, 0, 1)
                end
                delta = animState - prev
                door:SetPoseParameter("position", animState)
                door.AnimState = animState
            end

            self.LedBlink = self.LedBlink or {}
            self.LedPrev = self.LedPrev or {}
            local btn = Wag.ClientEnts[btnKey]
            if IsValid(btn) then
                btn:SetPoseParameter("position", animState)

                local led = Wag:GetNW2Int("DoorButtonLed" .. idx, 0)
                local ledBlink = CurTime() % .9 < .45
                if not ledBlink and self.LedBlink[idx] and CurTime() >= self.LedBlink[idx] then self.LedBlink[idx] = nil end
                self.LedBlink[idx] = led > 0 and (
                    announceState == "Closed" or announceState == "Moving" or announceState == "Closing" or
                    animState < 1 and announceState == "OpeningAddr" or
                    animState < 1 and animState > 0.01 and announceState == "Open"
                ) or self.LedBlink[idx]
                self.LedBlink[idx] = self.LedBlink[idx] == true and CurTime() + 1 or self.LedBlink[idx]
                if self.LedBlink[idx] then
                    if led > 0 then self.LedPrev[idx] = led end
                    led = ledBlink and self.LedPrev[idx] or 0
                end
                btn:SetSubMaterial(1, led > 0 and announceState ~= "Unpowered" and (
                    led == 2 and
                    "models/metrostroi_train/81-765/led_red" or
                    "models/metrostroi_train/81-765/led_green"
                ) or "models/metrostroi_train/81-765/led_off")
            end

            self.RandSet = self.RandSet or {}
            local randSet = self.RandSet[idx] or math.random(2)
            self:SetDoorSound(idx, "door_closed", randSet, delta > 0 and animState >= 1)
            self:SetDoorSound(idx, "door_opens", randSet, delta < 0 and prev >= 1)
            self:SetDoorSound(idx, "door_opened", randSet, delta < 0 and animState <= 0)
            self:SetDoorSound(idx, "door_loop", randSet, math.abs(delta) > 0.001)
            if animState <= 0 or animState >= 1 then randSet = nil end
            self.RandSet[idx] = randSet
        end
    end

    function TRAIN_SYSTEM:SetDoorSound(idx, kind, randSet, val)
        local sid = string.format("%s%d_%d", kind, randSet, idx)
        if kind ~= "door_loop" then
            if val then self.Train:PlayOnce(sid, "", 1, 1) end
            return
        end
        self.Train:SetSoundState(sid, val and 1 or 0, 1)
        for otherSet = 1, 2 do
            if otherSet ~= randSet then
                self.Train:SetSoundState(string.format("%s%d_%d", kind, otherSet, idx), 0, 1)
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
