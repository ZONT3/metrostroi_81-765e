-- FIXME remove
-- AddCSLuaFile()

return [[
#81-760E

[ru]

Entities.gmod_subway_81-760e.Name = 81-760Э (Чура головной)
Entities.gmod_subway_81-761e.Name = 81-761Э (Чура промежуточный моторный)
Entities.gmod_subway_81-763e.Name = 81-763Э (Чура промежуточный немоторный)

#Cameras:

#Autobreakers

#Spawner:
Entities.gmod_subway_81-760e.Spawner.Texture.Name            = @[Common.Spawner.Texture]
Entities.gmod_subway_81-760e.Spawner.PassTexture.Name        = @[Common.Spawner.PassTexture]
Entities.gmod_subway_81-760e.Spawner.CabTexture.Name         = @[Common.Spawner.CabTexture]
Entities.gmod_subway_81-760e.Spawner.Announcer.Name          = @[Common.Spawner.Announcer]
Entities.gmod_subway_81-760e.Spawner.Scheme.Name             = @[Common.Spawner.Scheme]
Entities.gmod_subway_81-760e.Spawner.PassSchemesInvert.Name  = @[Common.Spawner.SchemeInvert]
Entities.gmod_subway_81-760e.Spawner.SpawnMode.Name          = @[Common.Spawner.SpawnMode]
Entities.gmod_subway_81-760e.Spawner.SpawnMode.1             = @[Common.Spawner.SpawnMode.Full]
Entities.gmod_subway_81-760e.Spawner.SpawnMode.2             = @[Common.Spawner.SpawnMode.Deadlock]
Entities.gmod_subway_81-760e.Spawner.SpawnMode.3             = @[Common.Spawner.SpawnMode.NightDeadlock]
Entities.gmod_subway_81-760e.Spawner.SpawnMode.4             = @[Common.Spawner.SpawnMode.Depot]
Entities.gmod_subway_81-760e.Spawner.CISConfig.Name          = @[Spawner.760.CISConfig]

Entities.gmod_subway_81-760e.Spawner.HSEngines.Name          = @[Common.720.HSEngines]
Entities.gmod_subway_81-760e.Spawner.FirstONIX.Name          = @[Common.720.FirstONIX]
Entities.gmod_subway_81-760e.Spawner.VVVFSound.Name          = @[Common.720.VVVFSound]
Entities.gmod_subway_81-760e.Spawner.VVVFSound.1             = Стоковый КАТП-1 (ДТА) с 81-760
Entities.gmod_subway_81-760e.Spawner.VVVFSound.2             = @[Common.720.VVVFSound.1]  # ALSTOM ONIX IGBT
Entities.gmod_subway_81-760e.Spawner.VVVFSound.3             = @[Common.720.VVVFSound.2]  # ТМХ КАТП-1
Entities.gmod_subway_81-760e.Spawner.VVVFSound.4             = @[Common.720.VVVFSound.3]  # ТМХ КАТП-3
Entities.gmod_subway_81-760e.Spawner.VVVFSound.5             = @[Common.720.VVVFSound.4]  # Hitachi GTO
Entities.gmod_subway_81-760e.Spawner.VVVFSound.6             = @[Common.720.VVVFSound.5]  # Hitachi IGBT
Entities.gmod_subway_81-760e.Spawner.VVVFSound.7             = @[Common.720.VVVFSound.6]  # Hitachi VFI-HD1420F
Entities.gmod_subway_81-760e.Spawner.VVVFSound.8             = КАТП-3 Экспериментальный

#760E
Entities.gmod_subway_81-760e.Buttons.PVZ.SF31Toggle          = @[Common.760.SF31]
Entities.gmod_subway_81-760e.Buttons.PVZ.SF32Toggle          = @[Common.760.SF32]
Entities.gmod_subway_81-760e.Buttons.PVZ.SF33Toggle          = @[Common.760.SF33]
Entities.gmod_subway_81-760e.Buttons.PVZ.SF34Toggle          = @[Common.760.SF34]
Entities.gmod_subway_81-760e.Buttons.PVZ.SF36Toggle          = @[Common.760.SF36]
Entities.gmod_subway_81-760e.Buttons.PVZ.SF37Toggle          = @[Common.760.SF37]
Entities.gmod_subway_81-760e.Buttons.PVZ.SF38Toggle          = @[Common.760.SF38]
Entities.gmod_subway_81-760e.Buttons.PVZ.SF39Toggle          = @[Common.760.SF39]
Entities.gmod_subway_81-760e.Buttons.PVZ.SF40Toggle          = @[Common.760.SF40]
Entities.gmod_subway_81-760e.Buttons.PVZ.SF41Toggle          = @[Common.760.SF41]
Entities.gmod_subway_81-760e.Buttons.PVZ.SF42Toggle          = @[Common.ALL.Unsused1]
Entities.gmod_subway_81-760e.Buttons.PVZ.SF43Toggle          = @[Common.760.SF43]
Entities.gmod_subway_81-760e.Buttons.PVZ.SF44Toggle          = @[Common.760.SF44]
Entities.gmod_subway_81-760e.Buttons.PVZ.SF45Toggle          = @[Common.760.SF45]
Entities.gmod_subway_81-760e.Buttons.PVZ.SF46Toggle          = @[Common.760.SF46]
Entities.gmod_subway_81-760e.Buttons.PVZ.SF47Toggle          = @[Common.760.SF47]
Entities.gmod_subway_81-760e.Buttons.PVZ.SF48Toggle          = @[Common.760.SF48]
Entities.gmod_subway_81-760e.Buttons.PVZ.SF49Toggle          = @[Common.760.SF49]
Entities.gmod_subway_81-760e.Buttons.PVZ.SF50Toggle          = @[Common.760.SF50]
Entities.gmod_subway_81-760e.Buttons.PVZ.SF51Toggle          = @[Common.760.SF51]
Entities.gmod_subway_81-760e.Buttons.PVZ.SF52Toggle          = @[Common.760.SF52]
Entities.gmod_subway_81-760e.Buttons.PVZ.SF53Toggle          = @[Common.760.SF53]
Entities.gmod_subway_81-760e.Buttons.PVZ.SF54Toggle          = @[Common.760.SF54]
Entities.gmod_subway_81-760e.Buttons.PVZ.SF55Toggle          = @[Common.760.SF22F1]
Entities.gmod_subway_81-760e.Buttons.PVZ.SF56Toggle          = @[Common.760.SF56]
Entities.gmod_subway_81-760e.Buttons.PVZ.SF57Toggle          = @[Common.760.SF57]

Entities.gmod_subway_81-760e.Buttons.CabinDoorR.CabinDoorRight       = @[Common.ALL.CabinDoor]
Entities.gmod_subway_81-760e.Buttons.CabinDoorR1.CabinDoorRight      = @[Common.ALL.CabinDoor]
Entities.gmod_subway_81-760e.Buttons.CabinDoorL.CabinDoorLeft        = @[Common.ALL.CabinDoor]
Entities.gmod_subway_81-760e.Buttons.CabinDoorL1.CabinDoorLeft       = @[Common.ALL.CabinDoor]
Entities.gmod_subway_81-760e.Buttons.PassengerDoor.PassengerDoor     = @[Common.ALL.PassDoor]
Entities.gmod_subway_81-760e.Buttons.PassengerDoor2.PassengerDoor    = @[Common.ALL.PassDoor]

Entities.gmod_subway_81-760e.Buttons.FrontPneumatic.FrontBrakeLineIsolationToggle    = @[Common.ALL.FrontBrakeLineIsolationToggle]
Entities.gmod_subway_81-760e.Buttons.FrontPneumatic.FrontTrainLineIsolationToggle    = @[Common.ALL.FrontTrainLineIsolationToggle]
Entities.gmod_subway_81-760e.Buttons.RearPneumatic.RearTrainLineIsolationToggle      = @[Common.ALL.RearTrainLineIsolationToggle]
Entities.gmod_subway_81-760e.Buttons.RearPneumatic.RearBrakeLineIsolationToggle      = @[Common.ALL.RearBrakeLineIsolationToggle]
Entities.gmod_subway_81-760e.Buttons.GV.GVToggle                                     = @[Common.720.BRU]
Entities.gmod_subway_81-760e.Buttons.BTO.K29Toggle                                   = K29 (@[Common.ALL.KRMH])
Entities.gmod_subway_81-760e.Buttons.BTO.K9Toggle                                    = K9 (@[Common.ALL.RVTB])

Entities.gmod_subway_81-760e.Buttons.ASNP.R_ASNPMenuSet      = @[Common.ASNP.ASNPMenu]
Entities.gmod_subway_81-760e.Buttons.ASNP.R_ASNPUpSet        = @[Common.ASNP.ASNPUp]
Entities.gmod_subway_81-760e.Buttons.ASNP.R_ASNPDownSet      = @[Common.ASNP.ASNPDown]
Entities.gmod_subway_81-760e.Buttons.ASNP.R_ASNPOnToggle     = @[Common.ASNP.ASNPOn]

Entities.gmod_subway_81-760e.Buttons.IGLAButtons.IGLA1Set          = @[Common.IGLA.Button1]
Entities.gmod_subway_81-760e.Buttons.IGLAButtons.IGLA2Set          = @[Common.IGLA.Button2]
Entities.gmod_subway_81-760e.Buttons.IGLAButtons.IGLA23            = @[Common.IGLA.Button23]
Entities.gmod_subway_81-760e.Buttons.IGLAButtons.IGLA3Set          = @[Common.IGLA.Button3]
Entities.gmod_subway_81-760e.Buttons.IGLAButtons.IGLA4Set          = @[Common.IGLA.Button4]

Entities.gmod_subway_81-760e.Buttons.RV.EmerX1Set                = @[Common.720.EmerX1]
Entities.gmod_subway_81-760e.Buttons.RV.EmerX2Set                = @[Common.720.EmerX2]
Entities.gmod_subway_81-760e.Buttons.RV.EmergencyCompressorSet   = @[Common.720.EmergencyCompressor]

Entities.gmod_subway_81-760e.Buttons.PU2.DoorSelectLToggle           = @[Common.720.DoorSelectL]
Entities.gmod_subway_81-760e.Buttons.PU2.DoorSelectRToggle           = @[Common.720.DoorSelectR]
Entities.gmod_subway_81-760e.Buttons.PU2.DoorLeftSet                 = @[Common.720.KDL]
Entities.gmod_subway_81-760e.Buttons.PU2.R_MicroSet                  = @[Common.760.R_Micro]
Entities.gmod_subway_81-760e.Buttons.PU2.HeadlightsSwitch+           = @[Common.ALL.VF] @[Common.ALL.Up]
Entities.gmod_subway_81-760e.Buttons.PU2.HeadlightsSwitch-           = @[Common.ALL.VF] @[Common.ALL.Down]
Entities.gmod_subway_81-760e.Buttons.PU2.DoorCloseToggle             = @[Common.720.DoorClose]
Entities.gmod_subway_81-760e.Buttons.PU2.AttentionMessageSet         = @[Common.720.AttentionMessage]
Entities.gmod_subway_81-760e.Buttons.PU2.AttentionSet                = @[Common.ARS.KB]
Entities.gmod_subway_81-760e.Buttons.PU2.AttentionBrakeSet           = @[Common.ARS.KVT]
Entities.gmod_subway_81-760e.Buttons.PU2.HornBSet                    = @[Common.ALL.Horn]
Entities.gmod_subway_81-760e.Buttons.PU2.DoorRightSet                = @[Common.720.KDP]
Entities.gmod_subway_81-760e.Buttons.PU2.R_Program1Set               = @[Common.720.R_Program1]

Entities.gmod_subway_81-760e.Buttons.PU3.EmerBrakeAddSet             = @[Common.720.EBrakeAdd]
Entities.gmod_subway_81-760e.Buttons.PU3.EmerBrakeReleaseSet         = @[Common.720.EBrakeRelease]
Entities.gmod_subway_81-760e.Buttons.PU3.EmerBrakeToggle             = @[Common.720.EBrakeToggle]
Entities.gmod_subway_81-760e.Buttons.PU3.EmergencyBrakeToggle        = @[Common.720.EmergencyBrake]
Entities.gmod_subway_81-760e.Buttons.PU3.R_Program11Set              = @[Common.720.R_Program1]
Entities.gmod_subway_81-760e.Buttons.PU3.SDToggle                    = @[Common.765.PMO.ABSD]
Entities.gmod_subway_81-760e.Buttons.PU3.SDkToggle                   = @[Common.765.PMO.ABSDCover]
Entities.gmod_subway_81-760e.Buttons.PU3.ABESDToggle                 = @[Common.765.PMO.ABESD]
Entities.gmod_subway_81-760e.Buttons.PU3.ABESDkToggle                = @[Common.765.PMO.ABESDCover]
Entities.gmod_subway_81-760e.Buttons.PU3.EmergencyCompressor2Set     = @[Common.720.EmergencyCompressor]
Entities.gmod_subway_81-760e.Buttons.PU3.HornCSet                    = @[Common.ALL.Horn]

Entities.gmod_subway_81-760e.Buttons.PU5.DoorBlockToggle             = @[Common.720.DoorBlock]
Entities.gmod_subway_81-760e.Buttons.PU5.!HVoltage                   = @[Common.760.HVoltage]
Entities.gmod_subway_81-760e.Buttons.PU5.!DoorsClosed                = @[Common.ALL.LSD]
Entities.gmod_subway_81-760e.Buttons.PU5.R_LineToggle                = @[Common.720.R_Line]
Entities.gmod_subway_81-760e.Buttons.PU5.AccelRateSet                = @[Common.720.AccelRate]
Entities.gmod_subway_81-760e.Buttons.PU5.EnableBVSet                 = @[Common.720.EnableBV]
Entities.gmod_subway_81-760e.Buttons.PU5.DisableBVSet                = @[Common.720.DisableBV]
Entities.gmod_subway_81-760e.Buttons.PU5.RingSet                     = @[Common.720.Ring]
Entities.gmod_subway_81-760e.Buttons.PU5.KAHToggle                   = @[Common.720.KAH]
Entities.gmod_subway_81-760e.Buttons.PU5.ALSToggle                   = @[Common.720.ALS]
Entities.gmod_subway_81-760e.Buttons.PU5.ALSkToggle                  = @[Common.720.ALSK]
Entities.gmod_subway_81-760e.Buttons.PU5.WiperToggle                 = @[Common.720.Wiper]
Entities.gmod_subway_81-760e.Buttons.PU5.WasherSet                   = @[Common.722.GlassWasher]
Entities.gmod_subway_81-760e.Buttons.PU5.GlassHeatingToggle          = @[Common.760.GlassHeating]
Entities.gmod_subway_81-760e.Buttons.PU5.PrToggle                    = @[Common.760.Pr]
Entities.gmod_subway_81-760e.Buttons.PU5.SCToggle                    = @[Common.ALL.Unsused1]
Entities.gmod_subway_81-760e.Buttons.PU5.AutoDriveToggle             = @[Common.ALL.Unsused1]
Entities.gmod_subway_81-760e.Buttons.PU5.OtklRToggle                 = @[Common.760.OtklR]
Entities.gmod_subway_81-760e.Buttons.PU5.R_ToBackSet                 = @[Common.760.R_ToBack]
Entities.gmod_subway_81-760e.Buttons.PU5.R_ChangeRouteToggle         = @[Common.760.R_ChangeRoute]

Entities.gmod_subway_81-760e.Buttons.MfduButtons.Mfdu1Set        = Скиф: 1
Entities.gmod_subway_81-760e.Buttons.MfduButtons.Mfdu2Set        = Скиф: 2
Entities.gmod_subway_81-760e.Buttons.MfduButtons.Mfdu3Set        = Скиф: 3
Entities.gmod_subway_81-760e.Buttons.MfduButtons.Mfdu4Set        = Скиф: 4
Entities.gmod_subway_81-760e.Buttons.MfduButtons.Mfdu5Set        = Скиф: 5
Entities.gmod_subway_81-760e.Buttons.MfduButtons.Mfdu6Set        = Скиф: 6
Entities.gmod_subway_81-760e.Buttons.MfduButtons.Mfdu7Set        = Скиф: 7
Entities.gmod_subway_81-760e.Buttons.MfduButtons.Mfdu8Set        = Скиф: 8
Entities.gmod_subway_81-760e.Buttons.MfduButtons.Mfdu9Set        = Скиф: 9
Entities.gmod_subway_81-760e.Buttons.MfduButtons.Mfdu0Set        = Скиф: 0
Entities.gmod_subway_81-760e.Buttons.MfduButtons.MfduF5Set       = Скиф: Сброс
Entities.gmod_subway_81-760e.Buttons.MfduButtons.MfduF6Set       = Скиф: Вверх
Entities.gmod_subway_81-760e.Buttons.MfduButtons.MfduF7Set       = Скиф: Вниз
Entities.gmod_subway_81-760e.Buttons.MfduButtons.MfduF8Set       = Скиф: Ввод
Entities.gmod_subway_81-760e.Buttons.MfduButtons.MfduF9Set       = Скиф: Выбор

Entities.gmod_subway_81-760e.Buttons.K35.UAVAToggle                  = K35 (@[Common.ALL.UAVA2])
Entities.gmod_subway_81-760e.Buttons.Chair.Chair                     = @[Common.760.Seat]

Entities.gmod_subway_81-760e.Buttons.VoltHelper1.!Battery            = @[Common.ALL.BatteryVoltage]
Entities.gmod_subway_81-760e.Buttons.VoltHelper1.!HV                 = @[Common.ALL.HighVoltage]

Entities.gmod_subway_81-760e.Buttons.Closet1.Closet1           = @[Common.760.Cabinet]
Entities.gmod_subway_81-760e.Buttons.Closet1Op.Closet1          = @[Common.760.Cabinet]
Entities.gmod_subway_81-760e.Buttons.K31Cap.K31Cap                   = @[Common.760.Cap] K31

Entities.gmod_subway_81-760e.Buttons.StopKran.EmergencyBrakeValveToggle          = @[Common.ALL.EmergencyBrakeValve]

#761e
Entities.gmod_subway_81-761e.Buttons.Battery.BatteryToggle   = @[Common.ALL.VB]

Entities.gmod_subway_81-761e.Buttons.BoxR.EmergencyBrakeValveToggle      = @[Common.ALL.EmergencyBrakeValve]
Entities.gmod_subway_81-761e.Buttons.Power.PowerOnSet        = @[Common.760A.PowerOn]

Entities.gmod_subway_81-761e.Buttons.PVZ.SF31Toggle          = @[Common.760.SF31]
Entities.gmod_subway_81-761e.Buttons.PVZ.SF32Toggle          = @[Common.760.SF32]
Entities.gmod_subway_81-761e.Buttons.PVZ.SF33Toggle          = @[Common.760.SF33]
Entities.gmod_subway_81-761e.Buttons.PVZ.SF34Toggle          = @[Common.760.SF34]
Entities.gmod_subway_81-761e.Buttons.PVZ.SF36Toggle          = @[Common.760.SF36]
Entities.gmod_subway_81-761e.Buttons.PVZ.SF37Toggle          = @[Common.760.SF37]
Entities.gmod_subway_81-761e.Buttons.PVZ.SF38Toggle          = @[Common.760.SF38]
Entities.gmod_subway_81-761e.Buttons.PVZ.SF39Toggle          = @[Common.760.SF39]
Entities.gmod_subway_81-761e.Buttons.PVZ.SF40Toggle          = @[Common.760.SF40]
Entities.gmod_subway_81-761e.Buttons.PVZ.SF41Toggle          = @[Common.760.SF41]
Entities.gmod_subway_81-761e.Buttons.PVZ.SF42Toggle          = @[Common.ALL.Unsused1]
Entities.gmod_subway_81-761e.Buttons.PVZ.SF43Toggle          = @[Common.760.SF43]
Entities.gmod_subway_81-761e.Buttons.PVZ.SF44Toggle          = @[Common.760.SF44]
Entities.gmod_subway_81-761e.Buttons.PVZ.SF45Toggle          = @[Common.760.SF45]
Entities.gmod_subway_81-761e.Buttons.PVZ.SF46Toggle          = @[Common.760.SF46]
Entities.gmod_subway_81-761e.Buttons.PVZ.SF47Toggle          = @[Common.760.SF47]
Entities.gmod_subway_81-761e.Buttons.PVZ.SF48Toggle          = @[Common.760.SF48]
Entities.gmod_subway_81-761e.Buttons.PVZ.SF49Toggle          = @[Common.760.SF49]
Entities.gmod_subway_81-761e.Buttons.PVZ.SF50Toggle          = @[Common.760.SF50]
Entities.gmod_subway_81-761e.Buttons.PVZ.SF51Toggle          = @[Common.760.SF51]
Entities.gmod_subway_81-761e.Buttons.PVZ.SF52Toggle          = @[Common.760.SF52]
Entities.gmod_subway_81-761e.Buttons.PVZ.SF53Toggle          = @[Common.760.SF53]
Entities.gmod_subway_81-761e.Buttons.PVZ.SF54Toggle          = @[Common.760.SF54]
Entities.gmod_subway_81-761e.Buttons.PVZ.SF55Toggle          = @[Common.760.SF22F1]
Entities.gmod_subway_81-761e.Buttons.PVZ.SF56Toggle          = @[Common.760.SF56]
Entities.gmod_subway_81-761e.Buttons.PVZ.SF57Toggle          = @[Common.760.SF57]
Entities.gmod_subway_81-761e.Buttons.PVZ.SF58Toggle          = @[Common.760.SF58]
Entities.gmod_subway_81-761e.Buttons.PVZ.SF59Toggle          = @[Common.ALL.Unsused1]

Entities.gmod_subway_81-761e.Buttons.ClosetCapL.CouchCapL          = @[Common.760.Cabinet]
Entities.gmod_subway_81-761e.Buttons.ClosetCapLop.CouchCapL        = @[Common.760.Cabinet]
Entities.gmod_subway_81-761e.Buttons.ClosetCapR.CouchCapR          = @[Common.760.Cabinet]
Entities.gmod_subway_81-761e.Buttons.ClosetCapRop.CouchCapR        = @[Common.760.Cabinet]

#763e
Entities.gmod_subway_81-763e.Buttons.Battery.BatteryToggle   = @[Common.ALL.VB]

Entities.gmod_subway_81-763e.Buttons.BoxR.EmergencyBrakeValveToggle      = @[Common.ALL.EmergencyBrakeValve]
Entities.gmod_subway_81-763e.Buttons.Power.PowerOnSet        = @[Common.760A.PowerOn]

Entities.gmod_subway_81-763e.Buttons.PVZ.SF34Toggle          = @[Common.760A.SF34]
Entities.gmod_subway_81-763e.Buttons.PVZ.SF35Toggle          = @[Common.760A.SF30F2]
Entities.gmod_subway_81-763e.Buttons.PVZ.SF36Toggle          = @[Common.760.SF36]
Entities.gmod_subway_81-763e.Buttons.PVZ.SF37Toggle          = @[Common.760.SF37]
Entities.gmod_subway_81-763e.Buttons.PVZ.SF38Toggle          = @[Common.760.SF38]
Entities.gmod_subway_81-763e.Buttons.PVZ.SF39Toggle          = @[Common.760.SF39]
Entities.gmod_subway_81-763e.Buttons.PVZ.SF40Toggle          = @[Common.760.SF40]
Entities.gmod_subway_81-763e.Buttons.PVZ.SF41Toggle          = @[Common.760.SF41]
Entities.gmod_subway_81-763e.Buttons.PVZ.SF42Toggle          = @[Common.ALL.Unsused1]
Entities.gmod_subway_81-763e.Buttons.PVZ.SF43Toggle          = @[Common.760.SF43]
Entities.gmod_subway_81-763e.Buttons.PVZ.SF44Toggle          = @[Common.760.SF44]
Entities.gmod_subway_81-763e.Buttons.PVZ.SF46Toggle          = @[Common.760.SF46]
Entities.gmod_subway_81-763e.Buttons.PVZ.SF47Toggle          = @[Common.760.SF47]
Entities.gmod_subway_81-763e.Buttons.PVZ.SF48Toggle          = @[Common.760.SF48]
Entities.gmod_subway_81-763e.Buttons.PVZ.SF49Toggle          = @[Common.760.SF49]
Entities.gmod_subway_81-763e.Buttons.PVZ.SF53Toggle          = @[Common.760.SF53]
Entities.gmod_subway_81-763e.Buttons.PVZ.SF54Toggle          = @[Common.760.SF54]
Entities.gmod_subway_81-763e.Buttons.PVZ.SF55Toggle          = @[Common.760.SF22F1]
Entities.gmod_subway_81-763e.Buttons.PVZ.SF56Toggle          = @[Common.760.SF56]
Entities.gmod_subway_81-763e.Buttons.PVZ.SF57Toggle          = @[Common.760.SF57]

Entities.gmod_subway_81-763e.Buttons.ClosetCapL.CouchCapL          = @[Common.760.Cabinet]
Entities.gmod_subway_81-763e.Buttons.ClosetCapLop.CouchCapL        = @[Common.760.Cabinet]
Entities.gmod_subway_81-763e.Buttons.ClosetCapR.CouchCapR          = @[Common.760.Cabinet]
Entities.gmod_subway_81-763e.Buttons.ClosetCapRop.CouchCapR        = @[Common.760.Cabinet]
]]
