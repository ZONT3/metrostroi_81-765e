Metrostroi.DefineSystem("81_765_AutoDrive")
TRAIN_SYSTEM.DontAccelerateSimulation = true

function TRAIN_SYSTEM:Initialize()
	self.State = 0 -- 1-двери 2-тяга
	if not TURBOSTROI then
		self.DriveCycle = 0 --цикл программы
		self.ActivationTime = 0 -- Как давно было активировано АВП
		self.ScheduleMode = false -- Ездить по расписанию из MDispatcher
		self.SchedNum = 0 -- порядковый номер станции в расписании. для таблицы на приборке
		self.ADcooldown = CurTime() -- 5fps высчитывание светофоров
		self.Pos = 0 -- местоположение
		--self.Signal = 0 -- светофор
		self.nextMaxS = 0 -- Vmax по следующей Рельсовой Цепи
		self.sRed = false -- след красный / алс 0
		self.NextStop = false -- не отпр со ст - след запрещ.
		self.ADBoost = true -- Режим нагон. Управляется с приборки
		self.BrakeBoost = false -- Вентиль при торможении
		self.TargetSpeed = 0
		self.Command = 0
		self.Sleep = false -- Едем накатом на около-целевой скорости
		self.SleepMargin = 2.5 -- Погрешность наката
		self.MustBrake = false  -- в районе рейки и еще не встал. чтобы не поехал на след. ст
		self.ADnotAvl = false -- АВП нафакапило, и ждет внимания машика
		--self.DoorCD = CurTime() -- Кулдаун опроса стороны платформы
		self.MinWaitTime = 12 -- Мин. время стоянки с дверьми
		self.PlatformRight = false -- Платформа справа
		self.DoorsLeft = false -- запрос на двери
		self.DoorsRight = false
		self.DoorsClose = false
		self.cisStarted = false -- пуск информатора
		self.CisWaitTime = 4 -- за соклько до закрытия дверей пустить инф
		self.Train:SetNW2String("ADversion","2.2.8")
	end
end

function TRAIN_SYSTEM:Inputs()
	return {}
end

function TRAIN_SYSTEM:Outputs()
	return {}
end

if TURBOSTROI then return end

local function CancelAD(self,reason,EB,StillAvl)
	if not StillAvl then
		self.ADnotAvl = true
	end
	self.sRed = false
	self.MustBrake = true
	self.LongStopTimer = nil
	self.LongStopReported = nil
	self.Command = -3
	self.TargetSpeed = 0
	self.DriveCycle = 0
	if reason then
		self.FailReason = reason
		self.Train:SetNW2Int("ADfailReason",reason)
		if reason > 3 then
			--self.Train.BUKP.State2 = 62
			self.Train.sys_Autodrive:ADring(0.28,5)
		end
	end
	if EB then
		self.Train.BUKP.EmergencyBrake = 1
	end
end

function TRAIN_SYSTEM:RedPass() -- Хелпер для разбора полетов, проехал игрок-ли или АВП
	if self.State < 1 then return "" end
	local text = ""
	if CurTime()-self.ActivationTime > 5 then
		text = ", поезд был на АВП." 
	end
	self:ADlog("RedPass",3)
	return text
end

local function GetStationName(st_id) -- Функция от Alexell & Agent Smith - Metrostroi Scoreboard
	if not Metrostroi.StationConfigurations then return "N/A" end
	if Metrostroi.StationConfigurations[st_id] then
		return Metrostroi.StationConfigurations[st_id].names[1]
	else
		return "N/A"
	end
end

function TRAIN_SYSTEM:ReportLongStop()
	local Train = self.Train
	local RN = Train.RouteNumber and Train.RouteNumber.RouteNumber/10 or -1
	local SigName = self.Signal.Name

	local Path = Train:ReadCell(49170)
	local CurrStName = GetStationName(Train:ReadCell(49160),1)
	if CurrStName == "N/A" then
		local NextStName = GetStationName(Train:ReadCell(49169),1)
		local PrevStName = GetStationName(Train:ReadCell(49162),1)
		PrintMessage(HUD_PRINTTALK, Format("[AI] МТ %s, %s - %s %s путь, встал перед %s, запрещающий более 30 сек.", RN,PrevStName,NextStName,Path,SigName))
	else
		PrintMessage(HUD_PRINTTALK, Format("[AI] МТ %s, ст. %s %s путь, встал перед %s, запрещающий более 30 сек.", RN,CurrStName,Path,SigName))
	end
end

function TRAIN_SYSTEM:ADring(interval,count)
	timer.Remove("ADring")
	timer.Create("ADring", interval, count, function()
		if not self.Train or not self.Train.PlayOnce then return end
		self.Train:PlayOnce("ring_ad1","cabin",1.2,1.2)
		self.Train:PlayOnce("ring_ad2","cabin",1.2,1.4)
	end)
end

function TRAIN_SYSTEM:ChangeCab()
	-- rerail - to stop
	for i=1,#self.Train.WagonList do
		local wagon = self.Train.WagonList[i]
		Metrostroi.RerailTrain(wagon)
	end
	
	self.Train.RV:TriggerInput("KROSet",0)
	local RR = self.Train.WagonList[#self.Train.WagonList]
	if not RR.sys_Autodrive then return end
	RR.KV765:TriggerInput("Set4",1)
	timer.Simple(1,function()
		RR.RV:TriggerInput("KROSet",1)
	end)
end

function TRAIN_SYSTEM:CheckForTurnover(text,color)
	if self.NonSupportTurnover then return end

	local trackID = self.Train:ReadCell(65510)
	local X = self.Train:ReadCell(65504)
	local FWD = self.Train:ReadCell(65508) > 0.5
	if not self.MapName then self.MapName = game.GetMap() end
	if self.MapName == "gm_metro_pink_line_redux_v1" then
	
		if trackID == 6 then
			if X < 3 then
				self:ChangeCab()
			end
			if X > 3490 then self:ChangeCab() end
		elseif trackID == 5 then
			if X < 23 then self:ChangeCab() end

			if X > 3620 and X < 3640 and FWD then
				self:ChangeCab()
			end
		elseif trackID == 2 or trackID == 3 then
			if X > 159 then self:ChangeCab() end
		end
	elseif self.MapName == "gm_mustox_neocrimson_line_a" then
		if trackID == 15 then
			if X > 8340 then self:ChangeCab() end
		elseif trackID == 14 then
			if X < 21 then self:ChangeCab() end
		elseif trackID == 9 then
			if X > 186 then self:ChangeCab() end
		elseif trackID == 10 then
			if X > 189 then self:ChangeCab() end
		end
	else
		self.NonSupportTurnover = true 
	end
end

function TRAIN_SYSTEM:ADlog(text,color)
	if not self.Train.CPO then return end
	local Train = self.Train
	local wagnum = string.format("%05d",tonumber(Train.WagonNumber))
	local stID = Train:ReadCell(49169)
	local pathID = Train:ReadCell(49170)
	local X = Train:ReadCell(65504) -- коорда на треке
	local msg = string.format("AD %d %s V=%d Cycle=%d Atime=%d Path=%d St=%d X=%d Map=%s",wagnum,text,Train.Speed,self.DriveCycle,CurTime()-self.ActivationTime,pathID,stID,X,game.GetMap():lower() or "none")
	self.Train.CPO:Logs(msg,color or 2,3)
end
-- написано в последний момент перед релизом, тк раньше работало через модификацию gm track plarform на send стороны на поезд
-- А потом опять вырезана в замену идеально рабочей модификации track platmorm, ибо аснп ненадежно 
--[[function TRAIN_SYSTEM:GetDoorSide() 
	if CurTime() < self.DoorCD then return end
	self.DoorCD = CurTime() + 3
	local tbl = Metrostroi.ASNPSetup[self.Train:GetNW2Int("Announcer",1)]
	if tbl then
		local ID = self.Train:ReadCell(49169)
		local line = self.Train.BMCIS.Line--math.floor(ID/100)
		local stID = ID%100
		local stbl = tbl[line] and tbl[line][stID]
		if stbl then
			self.PlatformRight = stbl.right_doors or false
			return true
		end
	end
	CancelAD(self, 8)
	return false
end]]

function TRAIN_SYSTEM:GetColors(signal)
	if signal.ARSOnly then return "0000" end
	local color = ""
	local idx = 1
	for k = 1, #signal.Lenses do
		for i = 1, #signal.Lenses[k] do
			local brt = tonumber(signal.Sig[idx]) or 0
			local clr = signal.Lenses[k][i]
			color = color..(brt > 1 and clr:lower() or brt > 0 and clr:upper() or "")
			idx = idx + 1
		end
	end
	return color
end

function TRAIN_SYSTEM:GetDispInterval()
	if not Metrostroi.StationConfigurations then return false end
	if not MDispatcher then return false end
	if not MDispatcher.ActiveDispatcher then return false end

	local disp_int = string.Replace(MDispatcher.Interval,":",".")
	disp_int = disp_int:Split(".")
	local mins,secs = tonumber(disp_int[1]) , tonumber(disp_int[2])
	if not mins or not secs then return false end
	disp_int = (mins*60) + secs

	local stID = self.Train:ReadCell(49169)
	local pathID = self.Train:ReadCell(49170)
	if stID == 0 or pathID == 0 then return false end
	--local clock = MDispatcher.Stations[math.floor(stID/100)][pathID][stID].Clock
	local clock -- переписал на ИФы, ибо иногда конфиги говно
	local line = MDispatcher.Stations[math.floor(stID/100)]
	if line then
		local path = line[pathID]
		if path then
			local station = path[stID]
			if station then
				clock = station.Clock
			end
		end
	end

	if not clock then return false end

	local clock_int = math.floor(Metrostroi.GetSyncTime()-(clock:GetIntervalResetTime()+GetGlobalFloat("MetrostroiTY")))
	if clock_int < 0 or clock_int > 599 then return false end
	local WaitTime = math.max(self.MinWaitTime,disp_int-clock_int-5)
	return WaitTime
end

local function SchedWaitTime(depTime)
	local tbl = os.date("!*t", Metrostroi.GetSyncTime())
	local secs = tbl.hour*3600+tbl.min*60+tbl.sec
	return depTime-secs-5 -- 5сек на закр дверей
end

function TRAIN_SYSTEM:GetDepartureTime()
	if self.cycleTimer then return end -- уже получили
	local Train = self.Train
	if not self.ScheduleMode or not Train.ScheduleData then -- расписания нет
		local WaitTime = self:GetDispInterval() or self.MinWaitTime
		return WaitTime
	end
	local stID = Train:ReadCell(49169)
	local tbl = Train.ScheduleData
	local depTime = 0
    for i,row in pairs(tbl["table"]) do
        if row["ID"] == stID then
            depTime = row["Time"]
			self.SchedNum = i 
        end
    end
	local WaitTime = math.max(self.MinWaitTime,SchedWaitTime(depTime))
	--print(depTime,WaitTime)
	Train:SetNW2Int("BUIK:ShedDepTime",CurTime()+WaitTime+0.5)
	return WaitTime
end

function TRAIN_SYSTEM:ADcalculate()
	local Train = self.Train
	-- Получение местоположения состава
	self.Pos = Metrostroi.TrainPositions[Train]

	-- убираем задвоение данных
	if self.Pos then self.Pos = self.Pos[1] end

	-- отмена АВ если нет self.Pos (не на треке)
	if self.Pos==nil then
		CancelAD(self,2,false,true)
		return
	end

	-- Получаем энтити след светофора
	self.Signal = (Metrostroi.GetARSJoint(self.Pos.node1,self.Pos.x,Metrostroi.TrainDirections[Train],Train))

	-- Проверка на красную линзу на след. светофоре				
	if self.Signal then
		local col = self:GetColors(self.Signal)
		if col then
			self.sRed = col:find("[Rr]") ~= nil
		else
			self.sRed = false
		end
	else -- отмена АВ если светофор не найден
		CancelAD(self,3,false,true)
		return
	end

	local BARSspeedLimit = math.floor(Train.BARS.SpeedLimit)
	if BARSspeedLimit == 20 then BARSspeedLimit = 0 end
	local NextSignalLimit = self.Signal.ARSNextSpeedLimit or 0
	if NextSignalLimit==1 then NextSignalLimit=0 end
	local NextSigPos = self.Signal.TrackPosition.x
	local TrainPos = Train:ReadCell(65504)
	local ReikaDist = Train:ReadCell(49165)-7
	local SigDist = NextSigPos-TrainPos
	-- Контроль тупика. Если светофор не дает следущюий светофор, то тормозить перед ним. UPD Однако бывают всякие гвн сигналки типа Саннитауна, где не везде, на главных путях (!), заполнено поле nextsignal.
	--local Deadend = not IsValid(self.Signal.NextSignalLink) or self.Signal.NextSignalLink == self.Signal
	--if Deadend then self.sRed = true end
	local sRedFactor = (ReikaDist < 60 and self.DriveCycle~=5) and 0 or ((self.sRed or NextSignalLimit == 0) and -30 or 0) -- если след К или 0, то на 30м меньше тормозим. На станции игнорим, чтобы до рейки дотянуться

	-- высчет Vmax по следующей Рельсовой Цепи
	self.nextMaxS = math.min((ReikaDist < 60) and 80 or (NextSignalLimit*10),  BARSspeedLimit)
	--print(self.nextMaxS,BARSspeedLimit,NextSignalLimit*10,self.Command)
	-- высчет целевой скорости
	self.TargetSpeed = math.Clamp((SigDist-sRedFactor) / 4+self.nextMaxS-5, -- целевая с учетом светофоров. говнокод, так что с резкими красными может тупить. да и в целом.
						self.nextMaxS, --
						BARSspeedLimit+((not self.ADBoost and BARSspeedLimit > 40) and -12 or 0)) -- на 12 меньше при не нагоне. игнорится при алс 0-40
	-- TODO: учёт энтити через-одного светофора. для всяких кроссов и имейджинов, где на подьезде стопка входных раз в 30м, и чтоб поезд успевал остановиться перед ними.
	-- Плавное обрезание целевой скорости в ноль если следующий красный 
	if sRedFactor ~= 0 then 
		--local jerkFix = (Train.Speed > 6 and 1 or 20)
		--self.TargetSpeed = math.Clamp(self.TargetSpeed,0,(SigDist-15) / jerkFix) -- (-15 метров до красного)
		local JustStop = Train.Speed < 6
		self.TargetSpeed = JustStop and 0 or math.min(--[[SigDist-15 < 100 and 27 or ]]40,self.TargetSpeed,SigDist-25)
		self.SoftBrake = Train.Speed > 40 and SigDist > 50 -- чувствуете запах говна?)
	elseif self.SoftBrake then 
		self.SoftBrake = false
	end
	
	self.NextStop = self.sRed or self.nextMaxS==0
	Train:SetNW2Bool("sRedAD",self.NextStop)

	-- репорт вставания перед запрещающим
	if self.Train.AiMode then
		if self.NextStop and not self.LongStopTimer and Train.Speed < 1 then
			self.LongStopTimer = CurTime() + 30
		elseif self.LongStopTimer and not self.NextStop or Train.Speed > 1 then
			self.LongStopTimer = nil
		end

		if self.LongStopTimer and not self.LongStopReported and self.LongStopTimer < CurTime() then
			self:ReportLongStop()
			self.LongStopReported = true
		elseif self.LongStopReported and not self.NextStop then
			self.LongStopReported = false
		end
	end
end

local function Ventil(self,Speed,targetSpeed)

	if self.SoftBrake then 
		if self.BrakeBoost then
			self.BrakeBoost = false
		end
		return
	end

	-- подыгровка вентилем, если можем пролететь станцию
	if Speed>10 and Speed-targetSpeed > 12 then
		self.BrakeBoost = true
	elseif Speed < 7 or Speed-targetSpeed < 4 then
		self.BrakeBoost = false
	end
	--self.Train.BUKP:CheckError(24,self.BrakeBoost)
	--[[if self.BrakeBoost then
		for i=1,#self.Train.WagonList do
			self.Train.WagonList[i].BUV.PN1=true
		end
	end]]
end

function TRAIN_SYSTEM:ADcommand(mode)
	local Train = self.Train
	local Speed = Train.Speed
	local pitch = self.Train:GetAngles().pitch -- Буст мощности на подьемах/спусках. "-" это наверх!
	local ReikaDist = Train:ReadCell(49165)-7	

	if mode == 0 then -- Не рыпаться
		self.Command = 0
		self.BrakeBoost = false
	elseif mode == 1 then -- Автоведение по перегону
		local cmdSpeed = (self.TargetSpeed)-Speed-(pitch > 4 and 9 or 6)
		if self.Sleep then
			self.Command = 0
			if Speed < 30 or
			math.abs(cmdSpeed) > self.SleepMargin or
			math.abs(pitch) > 0.3
			then self.Sleep = false end
		else
			self.Command = math.floor(math.Clamp(cmdSpeed,
				-- МИН: "-4" если спуск/запрещающий; "-2" если все ок
				(pitch>4 or self.NextStop or self.MustBrake==true) and -4 or -2,

				 --МАКС: "-4" при ЭТ/отс.ЛСД; 0 на Vцел=околонуля; "4" на подьеме/при бусте; При не нагоне: "3" до 38кмч, дальше разгон на "2".
				(Train.BUKP.Errors.EmergencyBrake or Train.BUKP.DoorClosed < 1)  and -4 or self.TargetSpeed < 15 and -1 or (pitch<-2 or self.ADBoost) and 4 or (Speed < 38 and 3 or 2))+0.5)

			-- Режим Накат если едем околоцелевую
			if Speed > 31 and math.abs(cmdSpeed) < 0.3 and math.abs(pitch) < 0.3 then self.Sleep = true end
		end

		-- Заюзать вентиль, если необходимо
		Ventil(self,Speed,self.TargetSpeed+5)

	elseif mode == 2 then -- 2 Автоторм по рейке от сцб
		local targetSpeed = math.Clamp(
		-- Целевая
		(70.5*(math.max(0.0,math.min(1.0,(ReikaDist)/240))^0.54))+0.4*(ReikaDist < 48 and 1 or 0),
		-- Мин
		-20,
		-- Максимальная
		math.min(ReikaDist > 60 and self.sRed and (self.Signal.TrackPosition.x-Train:ReadCell(65504)) < 60 and self.TargetSpeed-9 or self.nextMaxS,53))

		-- задание контроллера
		self.Command = math.floor(math.Clamp(targetSpeed-Speed-1,-4,targetSpeed < 7 and 0 or 4)+0.5)

		-- Заюзать вентиль, если необходимо
		Ventil(self,Speed,targetSpeed)
	end
	if Speed > 1 and ReikaDist < 6 and ReikaDist > -3 then self.MustBrake = true end
end

function TRAIN_SYSTEM:ADcis(program) -- автоинформатор
	local T = self.Train
	local B = T.BUIK 
	if program == 1 then -- прибытие
		if not B.Arrived then
			if B:IsCurrentlyPlaying() then
				B:StopMessage()
				B.DoorAlarm = false
			end
			B:Play()
		end
	else -- отправление
		if not B.Arrived then return end -- значит информатор сбился
		if B:IsCurrentlyPlaying() then -- если все еще играет прибытие
			B:StopMessage()
			B.DoorAlarm = false
		end
		B:Play()
	end
end

function TRAIN_SYSTEM:ChangeCycle(toCycle,seconds)
	if not self.cycleTimer then
		self.cycleTimer = {toCycle,CurTime()+seconds}
	end
end

function TRAIN_SYSTEM:Think(dT)
	local Train = self.Train
	local curT = CurTime()
	local prost = Train.ProstKos 
	local AutoDrive = (Train.AutoDrive.Value > 0.5 and -- tumbler
					Train.BUIK.State > 0 and
					Train.RV.KROPosition > 0.5 and
					(Train.PB.Value < 0.5 and
					Train.Attention.Value < 0.5))
	--local ADswitch = Train.AutoDrive.Value > 0.5
	local ProstControl = prost.Prost and prost.ProstControl

	-- высчитывание локиги. с кулдауном (5 fps)
	if ProstControl or (AutoDrive and Train.Panel.Controller == 0) then
		if self.ADcooldown < curT then
			self.ADcooldown = curT+0.2
			self:ADcalculate()
		end
	end

	-- Переключатель режимов
	if self.cycleTimer and self.cycleTimer[2] < CurTime() then
		self.DriveCycle = self.cycleTimer[1]
		self.cycleTimer = nil
	end

	-- Drive Cycle
	if AutoDrive and Train.Panel.Controller == 0 and self.ADnotAvl==false then
		local ReikaDist = Train:ReadCell(49165)-7
		local WithinReika = ReikaDist < 10 and ReikaDist > -5
		local DoorsClosed = Train.BUKP.DoorClosed > 0.5

		if self.DriveCycle < 1 and not self.cycleTimer then -- если АВП без программы
			if WithinReika and Train.Speed < 1 then
				-- если двери закрыты - открываем и ждем 15с; если открыты, то закрываем и едем
				self.DriveCycle = DoorsClosed and 1 or 3
			else
				-- если не у рейки, то в Движение по перегону
				self.DriveCycle = 6
			end
			self.ActivationTime = curT
		end

		local cycle = self.DriveCycle 
		if cycle == 1 and Train.Speed < 1 then -- открыть двери
			if not WithinReika then
				self:ADlog("Not WTINreika",2)
				CancelAD(self,4)
				return
			end
			self.State = 1
			local doorGood = not Train.BUIK.IsServiceRoute -- типо, не едем ли резервом
			if doorGood then
				if Train.stationDoorSideLeft then
					self.DoorsLeft = true
				else
					self.DoorsRight = true
				end
			end
			--self.Train.BUKP:CheckError(22,Train.DoorClose.Value > 0.5)
			self.DoorsClose = false
			self.cisStarted = false -- сборс фалага пуска информатора
			self.MustBrake = false
			prost.Command = 0
			prost.ProstActive = 0
			prost.CommandStop = false
			self:ADcommand(0)
			self:ChangeCycle(doorGood and 2 or 3,doorGood and 1 or 0.1)
		elseif cycle == 2 then -- открыты, выдержка 15 сек
			if DoorsClosed then self.DriveCycle = 1 return end
			self.State = 1
			self.DoorsLeft = false -- Отжатие запроса дверей, а не их закрытие
			self.DoorsRight = false
			self:ADcommand(0)
			if not self.cisStarted and self.NextStop==false and self.cycleTimer and self.cycleTimer[2] - curT < self.CisWaitTime then -- пуск инф - отпр.
				self:ADcis(2)
				self.cisStarted = true
			end
			if Train.DoorClose.Value > 0.5 then -- опустили ВУД - едем сразу
				if not self.cisStarted then -- информатор
					self:ADcis(2)
					self.cisStarted = true
				end
				self.cycleTimer = nil
				self:ChangeCycle(3,0.2)
				self.DriveCycle = 3
			end
			self:ChangeCycle(3,self:GetDepartureTime() or self.MinWaitTime) -- от расписания, либо 12
		elseif cycle == 3 then 
			if Train.DoorClose.Value > 0.5 or not self.NextStop then -- преждевременное закрытие машиком // закрываем двери если выходной зеленый
				self.State = 1
				self.DoorsClose = true
				self.DoorsLeft = false
				self.DoorsRight = false
				if not self.cisStarted then
					self:ADcis(2)
					self.cisStarted = true
				end
				if not self.NextStop then
					self:ChangeCycle(4,DoorsClosed and 0.1 or 4)
				end
			end
			self:ADcommand(0)
		elseif cycle == 4 then
			if DoorsClosed then -- двери закрылись, отправляемся
				self.State = 2
				self.DoorsClose = false
				self.DoorsLeft = false
				self.DoorsRight = false
				self.cisStarted = false
				self:ADcommand(0)
				self:ADlog("Dep",1)
				self:ChangeCycle(5,0)
			else
				self.DoorsClose = CurTime()%1 > 0.5 -- переигрывание ВУД
			end
		elseif cycle == 5 then -- отправление
			if not DoorsClosed then -- Если пропали двери при отпр
				self:ADlog("Lost LSD while dep",2)
				CancelAD(self,5,true)
				return
			end
			self.State = 2
			self.DoorsLeft = false
			self.DoorsRight = false

			-- ПУСК КОНТРОЛЛЕРА
			self:ADcommand(1)
			self.MustBrake = false
			if Train.Speed > 8 then
				self:ChangeCycle(6,3)
			end
		elseif cycle == 6 --[[and DoorsClosed]] then -- едем по перегону
			self.State = 2
			self.DoorsLeft = false
			self.DoorsRight = false
			self:ADcommand(1)
			if ReikaDist <= 200 and ReikaDist > -6.9 and Train.Speed > 3 then
				self:ChangeCycle(7,0.1) -- переключиться на торм. от ПрОст / АВП
			end
		elseif cycle == 7 then -- Торможение по станции
			if ReikaDist > 200 then -- Уехали от рейки
				if self.MustBrake==false then -- "Хм, ну бывает."
					self:ChangeCycle(6,0.1)
				else -- Проебали рейку
					self:ADlog("Missed st",2)
					CancelAD(self,6,true) -- отказ автоведения
				end
			end
			self.State = 2
			if ProstControl and not (self.NextStop and ReikaDist > 60) then -- Отдаться ПрОсту. + Тормозить АВПшкой, если ПрОст уже схватил, но перед нами еще есть красные перед станцией - Прост их не видит
				self:ADcommand(0)
			else -- Тормозить от АВП
				self:ADcommand(2)
			end
			if Train.Speed < 1 then 
				if WithinReika then -- приехали на ст.
					self:ChangeCycle(1,0.5) -- Открыть двери, вернуться в начало
				elseif self.MustBrake==true then -- А где рейка? Факап.
					self:ADlog("Susp st",2)
					CancelAD(self,7) -- отказ автоведения
				elseif self.MustBrake==false then -- Встали, не доезжая. Дотягиваемся
					self:ChangeCycle(6,0.1)
				end
			end
			if ReikaDist < 29 and not self.cisStarted then -- пуск информатора
				self:ADcis(1)
				self.cisStarted = true
			end
		else
			self.Command = 0
			self.BrakeBoost = false
			self.State = 1
		end
		self:CheckForTurnover()
	elseif self.State ~= 0 or self.Command~=0 then
		self.Command = 0
		self.BrakeBoost = false
		self.DriveCycle = 0
		self.State = 0
		self.MustBrake = false
		self.LongStopTimer = nil
		self.LongStopReported = nil
	end
	if self.ADnotAvl == true and Train.Panel.Controller ~= 0 or Train.AutoDrive.Value < 0.5 then -- ресет
		self.ADnotAvl = false
	end
	Train:SetNW2Bool("AVP:Fail",self.ADnotAvl)
	--дебаг
	if Train.GlassHeating.Value > 0.5 then
		--print(self.DoorsClose)
		--print(self.DriveCycle,"NEXT "..(self.cycleTimer~=nil and (self.cycleTimer[1].."  "..self.cycleTimer[2]) or -1),"CMD  "..self.Command)
		--print(IsValid(self.Signal.NextSignalLink) and self.Signal.NextSignalLink~=self.Signal and "NEXT" or "STOP")
		--print(self.sRed,self.nextMaxS,self.MustBrake)
	end
end
