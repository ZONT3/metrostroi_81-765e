# 81-760Э «Чурá»
Выдуманная переходная модель от 81-760 к 81-765. В будущем может стать самой 81-765.

Аддон в данный момент может иметь проблемы на разных сетапах. Проверьте [баг-трекер](https://steamcommunity.com/workshop/filedetails/discussion/3664991304/755051497180511016/), может быть ваша проблема уже решается и/или имеет временное решение. В данный момент неизвестна стабильность на Rust-турбострое.
**Убедитесь, что у вас удалены все прошлые версии состава!**

Оригинальные скрипты, модели и звуки (кроме Rumble), находящиеся в аддоне — ZONT_ a.k.a. enabled person. Содержит звуки от проекта [Rumble](https://rumblemetrostroi.ru/).

Добровольно поддержать разработку состава _и, возможно, приблизить выход в свет 81-765 «Москва»_ — [Boosty](https://boosty.to/zxcpivo/donate)

## Для авторов контента
### Предупреждение
Создание и публикация кастомных окрасок приветствуется, однако имейте в виду, что модели будут обновляться в будущем, и сделанные до этого окраски будут требовать ремейк. [Вот пример регистрации кастомных скинов и логотипов](https://github.com/ZONT3/metrostroi_81-765e/blob/master/addons/zms_760e/lua/metrostroi/skins/chura.lua).

### Конфигурация информационного комплекса (ЦИК)
ЦИК полностью совместим с конфигами ЦИС от Оки.
Если на карте нет конфигов ЦИС/ИК, но есть хотя бы конфиг АСНП, ЦИК Чуры все еще будет полностью рабочим.
Но для цвета линии на БНТ, полных названий станций на БНТ и БМТ и пересадок на БНТ – очевидно, необходим конфиг ЦИС.

Для отображения иконок пересадок на другие транспортные системы (МЦК, МЦД и пр.), а также информационных иконок, используется расширение конфига ЦИС (назван **ИК**). В аддоне уже есть конфиг для Некрасовской, Калининской, Люблинско-Дмитровской и Чапаевской линий.
[Вот пример](https://github.com/ZONT3/metrostroi_81-765e/blob/master/addons/zms_760e/lua/metrostroi/configmaps/ik765.lua) этого конфига. [И вот шаблоны иконок](https://github.com/ZONT3/metrostroi_81-765e/blob/master/addons/zms_760e/lua/autorun/ik765.lua), зашитых в аддон.

## Дисклеймер
**Модели данного состава созданы автором, впервые открывшим блендер.** В будущем будут переделаны энтузиастами с опытом.
**Аддон преимущественно нацелен на реализацию систем поезда.**

Часть данного состава зависит от контента составов [81-760 «Ока» от CrIcKeT & Hell](https://steamcommunity.com/workshop/filedetails/?id=1919516717) и [81-720А «Яуза» от fixinit75](https://steamcommunity.com/sharedfiles/filedetails/?id=2257845652), скрипты содержат логику звуков экспериментальных ТЭДов от fixinit75 с разрешением от автора.
Контент Оки **не перепакован/скопирован** в этом аддоне.
Если вы считаете, что данный продукт в мастерской нарушает ваши авторские права – просьба
[связаться со мной в стиме](https://steamcommunity.com/id/ZONT3/) прежде чем кидать страйки, и указать какие файлы и какие их части нарушают АП. Заранее спасибо.

## Fair-use
Разрешается ставить этот состав на сервера, однако запрещается закрывать его за платными рангами/привилегиями. Модификация на серверах разрешается, однако просьба оставить ссылку на оригинал.
Повторная публикация без разрешения не приветствуется. Если есть желание улучшения состава, используйте [Pull Request-ы на GitHub](https://github.com/ZONT3/metrostroi_81-765e/pulls), либо пишите мне и скидывайте свои модификации.
Модификация состава с последующей продажей – запрещена, обращайтесь к предыдущему утверждению. Единственный автор (на данный момент) – ZONT_, все продающие и продававшие этот состав с заявлениями, что имеют разрешение от автора – лгут.

## Благодарности
### Поддержка на [Boosty](https://boosty.to/zxcpivo/donate)
- [undodespotta](https://steamcommunity.com/id/PERSONA_dest/)
- **81-710 Метрострой Проект**
- **Павел Прохоров**
- CJ_GTA6, Bonpoc1K, No Name, ЭД2Т-0053, shikidzee
### Техническая консультация
- [✭ ƸRaptorƷ ✭](https://steamcommunity.com/profiles/76561198274130077)
### Поиск информации, альфа тест
- [Sonic](https://steamcommunity.com/profiles/76561199809228380/)
- [Union](https://steamcommunity.com/profiles/76561198045712662/)
### Контент
- Звуки инвертора, грохота, пневматики и др. [Rumble](https://rumblemetrostroi.ru/)
- Шрифт БМТ, скриншоты [GrosBoy](https://steamcommunity.com/profiles/76561198945353398)
- Звук контроллера **PROFNIK**
- Тифон [Kononov](https://steamcommunity.com/id/ytvilageyt)

## Roadmap

- [ ] 81-760E/761E/763E (modding 760A)
  - [x] GRKV
      - [x] Logic
      - [x] MFDU UI
      - [x] Import model
      <!-- - [ ] Modify model/material -->
  - [x] MFDU
      - [x] Change root UI, temporary pages from 760
      - [x] New pages implementation (without 9th)
      - [x] Main message
      - [x] Initialization
        - [x] Password
        - [x] Depot mode
        <!-- - [ ] Buttons check -->
  - [x] BU-IK
      - [x] Cabin Metrospectekhnika implementation
      - [x] Salon BNT
      - [x] Skip message
      - [x] Sarmat-like beep
  - [x] Doors
      - [x] Blink and sound logic
      - [x] Doors delay logic
      - [x] Fasten move time
      - [x] Reduce sound volume
      - [x] Auto-reverse
      - [x] Manual lock
      - [x] Manual open
      - [x] Address door open button (.2)
  - [x] Sounds
      - [x] KATP-3
      - [x] Door alarm
  - [x] Materials
      - [x] MosBrend
      - [x] Skin Customization
  - [ ] Models
      - [x] Console (cringe)
      - [x] Doors (good)
      - [x] Cabin PMV/PPZ
      - [x] Salon BNT
      - [x] BMT
      - [ ] Inter door LED (remake)
      - [ ] Salon CIS
  - [x] BUKP => SAU Skif
      - [x] ARS1/2, ATS1/2
      - [x] Xod => ARS work logic
      - [x] No assemble instead of disable drive in some cases
      - [x] Safety loop improvement
      - [x] Zero speed feature
      - [x] PrOst KOS activation/deactivation logic improvement
      - [x] (after MFDU UI done) BUKP legacy cleanup, old UI removal
  - [ ] Electric
      - [x] BS normalization
      - [x] Cabin light from emergency switch
      - [x] PSN normalization (zaryad AKB)
      - [x] No HV (ATZ)
      - [x] Short circuit (ATZ)
      - [ ] kW/h normalization
  - [ ] Overall logic polishing
    - [x] BUD per-door work (and rewrite)
    - [x] UOS on MFDU
    - [x] Rewrite speed limit logics in BUKP
    - [x] BU-IK Return informer reset 'notlast' message
    - [x] BUKP background initialization right after identification
    - [x] Make RVTB recover in some cases
    - [x] PB/KB acts as KVT as well
    - [ ] New CAMS
    - [x] Uhv without GV behaivor
    - [x] Still brake PN1/PN2 revise
    - [ ] Pneumatic weight load PN setting adjustment
    - [ ] FIX: Doors close delay reset logic
- [ ] 81-765/766/767/.2/.4 (modeling 765, maybe getting rest from 760A code, maybe dependencies (systems) too)
  - [ ] Models (temporary)
    - [x] Mask
    - [x] Body
    - [x] Cabin
    - [x] Console (remake)
  - [ ] Improve sounds
    - [ ] KATP-3
    - [x] ~~Remove~~ or **resolve** RUMBLE dependency
    - [x] Door Alarm
    - [ ] Door drive
      - [x] Early variant
      - [ ] Improved variant
  - [ ] Variations
    - [x] Base entity class `81-765 base` for all wagons
    - [x] Derived entities 81-765, 766, 767 based on wagon base, hiding most of the parameters from the spawner  <-- Chura becomes this
    - [ ] Derived entities .2, .3, .4 based on 81-765, 766, 767 wagons
    - [x] Derived entities 81-765Э, 766Э, 767Э based on 81-765, 766, 767 wagons, revealing all the parameters to the spawner  <-- This becomes Chura
    - [ ] TKL/FL/Normal ARS options
      - [ ] TKL/FL option only for admins, ulx permission and/or per-map
  - [ ] Improvements
    - [ ] Rewrite KRMSh sounds logic so its fill/leak sound plays only when V4 enabled, etc.
    - [ ] Rewrite pant logic
      - [ ] HV per-pant
      - [ ] UKKZ per-pant
    - [x] Rewrite BARS
  
