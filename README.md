# Metrostroi 81-765/766/767

Codebase for 81-765-derived trains.

README is currently in WIP state until closed alpha-test.

## 81-765/766/767 «Москва»

TODO

## 81-765Э/766Э/767Э «Чурá»

TODO

## Roadmap

- [ ] Stable Release
  - [ ] Models
    - [ ] 81-765.2/766.2/767.2
    - [ ] 81-765.3/766.3/767.3
    - [ ] 81-765.4/766.4/767.4
  - [ ] Improve sounds
    - [ ] KATP-3
    - [ ] Door alarm
    - [ ] Door drive
      - [x] Early variant
      - [ ] Improved variant
    - [ ] Misc sounds
  - [ ] Variations
    - [ ] TKL/FL/Normal ARS options
      - [ ] TKL is basically ARS 70 -> ARS 75
      - [ ] FL is basically AB mode to implement
      - [ ] Per-Map/Per-Server Configuration
  - [ ] Misc 
    - [ ] Rewrite KRMSh sounds logic so its fill/leak sound plays only when V4 enabled, etc.
    - [ ] Rewrite pant logic
        - [ ] HV per-pant
        - [ ] UKKZ per-pant
    - [ ] Brake squeal remake
- [ ] Beta
  - [ ] Models
    - [x] Early, half-baked variant
      - [x] Basic
      - [ ] Lights for devices in bays, salon
      - [ ] Pneumo bay on 766/767
      - [ ] K35 bay
      - [ ] Rooftop details
      - [ ] Underwagon
    - [ ] Final materials/textures variant
    - [ ] Elements from .2 for Chura
  - [ ] MFDU 2nd page auto-opening should not hide voltages on bottom-left panel
  - [ ] FIX: Doors close delay reset logic
  - [ ] Electric-side doors closed signal ~~*Not found on any schematics*~~ *finally found one*
  - [ ] CIK justifications
    - [ ] LED-based BNT modes
    - [ ] BL-IK re-implementation
    - [ ] Proper font variations for BMT, BNM
    - [ ] Evacuation messages
  - [ ] Curtain in cabin
  - [ ] Passenger-driver call
  - [ ] BU-IK service mode
  - [ ] New CAMS
  - [ ] ASOTP-765
  - [ ] RVS
- [ ] Alpha
  - [ ] KL3
  - [ ] Fix various clientside multiplayer-related issues
  - [ ] LED-based BNT loop routes and bugfixes
  - [ ] AO disappearing should clear ARS brake signal when Vdop > 0 and V==0
    - [ ] KVT on AO shouldn't mute ARS ring and thus wont save from RVTB poweroff
    - [ ] Remove "Forgiveful BARS"
  - [ ] Doors buttonmaps
  - [ ] Tryokhgranka animations
  - [ ] HV circuits rework
  - [ ] Glass in cabin, on doors, windows, devices
  - [ ] Cabin models: buttons, controller variants, console textures
  - [ ] DVORNIK mazafaka
  - [ ] Spawner options justifications according to the following TODO, skis setups, etc.

## TODO

### Moskva options
  - Early
    - No BTBU/SD
    - No move w/o KD (PAK)
    - Bnt Both v1, MSTv1.1 (MM logo)
  - Late
    - BTBU/SD on .0 only
    - Move w/o KD (PAK)
    - Bnt MSTv1.1 (no MM logo), MSTv1.2, SARMATv1, SARMATv1.1

### CIK

|        | MSTv1         | MSTv1.1                | MSTv1.2        | Sarmat v1     | Sarmat v1.1   |
|-------:|---------------|------------------------|----------------|---------------|---------------|
|  BL-IK | LED           | MT cream/white, MM red | MT cream/white | LED           | LED           |
| BNT-IK | MST LED       | MST LED                | LCD 15fps      | Sarmat LED    | LCD 60fps     |
| BMT-IK | Yellow 240x40 | Yellow 240x40          | Yellow 240x40  | Orange 148x24 | Orange 148x24 |
|  BU-IK | MST           | MST                    | MST            | Sarmat        | Sarmat        |
