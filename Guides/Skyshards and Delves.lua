local ZGV = _G.ZGV
ZGV.GuideMenuTier = "TAM"

ZGV:RegisterGuide("Extras\\Extras\\Skyshards and Delves\\Aldmeri Dominion",[[
loadingimage loadscreen_eldentreeplatform_01.dds
description All Skyshards and Delves from Aldmeri Dominion Legacy Zones.
'Open Khenarthi's Roost Map
'Travel to _Khenarthi's Roost_
|tip Manually skip to the next step.
step
goto khenarthisroost_base 53.75,70.05
'Use Skyshard
|tip Manually skip to the next step.
step
goto 58.86,80.96
|tip Drop down carefully.
|tip At the top of the tower.
'Use Skyshard
|tip Manually skip to the next step.
step
goto 54.80,75.03
step
goto 58.39,60.90
step
goto 68.26,57.76
'Use Skyshard
|tip Manually skip to the next step.
step
'Open Khenarthi's Roost Map
'Travel to _Mistral_
|tip Manually skip to the next step.
step
goto mistral_base 15.10,34.53
|tip Behind the embassy.
'Use Skyshard
|tip Manually skip to the next step.
step
goto 27.57,33.13
step
goto 28.03,36.40
'Use Skyshard
|tip Manually skip to the next step.
step
goto 16.43,55.50
|tip Swim to this island.
'Use Skyshard
|tip Manually skip to the next step.
step
'Open Auridon Map
'Travel to _Vulkhel Guard_
|tip Manually skip to the next step.
step
goto vulkhelguard_base 43.45,43.06
step
goto 39.67,40.29
|tip Upstairs and out of the balcony of the manor.
step
goto 55.80,39.83
step
goto 57.79,24.98
step
goto auridon_base 59.59,84.95
step
goto 58.10,85.47
'Open Del's Claim
|tip Manually skip to the next step.
step
goto delsclaim_base 38.45,20.92
step
goto 31.45,21.81
'Use Skyshard
|tip Manually skip to the next step.
step
goto 39.75,11.04 |achieve 288
step
goto 80.23,16.64
kill Polinus |achieve 288
step
goto 16.85,89.26
'Open Auridon
|tip Manually skip to the next step.
step
goto auridon_base 62.39,81.25
|tip Sidequest required to open manor to access Skyshard.
talk Elenwen
accept Silsailen Rescue
step
goto 65.10,80.00
talk Teldur |q Silsailen Rescue/Talk to Teldur
step
goto 65.14,80.02
'Use Well |q Silsailen Rescue/.*Save Villagers.*
|tip Manually skip to the next step.
step
goto 65.41,80.57
kill Heritance enemies
'Collect a Folded Note
accept Real Marines
step
goto 66.38,80.48
'Use the Bucket on Fires in building doorways
'Save 5 Villagers |q Silsailen Rescue/.*Save Villagers.*
step
goto 65.33,78.69
'Open Cellar |q Real Marines/Enter the Cellar
step
goto 64.26,78.83
talk Captain Tendil |q Real Marines/Talk to Captain Tendil
step
goto 63.96,78.68
|tip Leave the Cellar.
'Search Crate |q Real Marines/Recover Supplies
step
goto 62.89,78.30
'Search Crate |q Real Marines/Recover Armor
step
goto 62.76,79.11
'Search Crate |q Real Marines/Recover Weapons
step
goto 65.33,78.66
'Open Cellar |q Real Marines/Talk to Tendil
|tip Manually skip to the next step.
step
goto 64.23,78.84
talk Captain Tendil
turnin Real Marines
step
goto 63.60,82.25 |q Silsailen Rescue/Talk to Elenwen |tip Leave the cellar.
step
goto 62.70,82.89
talk Elenwen |tip She is inside the large storehouse.
turnin Silsailen Rescue
accept Teldur's End
step
goto 62.86,81.05 |q Teldur's End/Find a Way Into Valano Manor
step
goto 66.56,81.18 |q Teldur's End/Find a Way Into Valano Manor
step
goto 70.06,83.06
kill Heritance Soldiers
'Get a Manor Key From the Guards |q Teldur's End/Find a Way Into Valano Manor
|tip Manually skip to the next step.
step
goto 70.17,83.01
'Open Valano Manor |q Teldur's End/Find a Way Into Valano Manor
step
goto 70.80,82.81
talk Teldur |q Teldur's End/Find Teldur
step
goto 70.15,83.14
|tip He's upstairs.
kill Canonreeve Valano |q Teldur's End/Stop Valano
step
goto 70.70,83.20
|tip It's upstairs in this big building, on a balcony outside.
'_Use door to your left_
'Use Skyshard |q Teldur's End/Talk to Elenwen
|tip Manually skip to the next step.
step
goto 70.61,83.00
|tip Drop down to the ground.
'Open Valano Manor |q Teldur's End/Talk to Elenwen
|tip Manually skip to the next step.
step
goto 70.14,83.14
talk Elenwen
|tip She's downstairs inside this big building.
turnin Teldur's End
step
'Open Auridon Map
'Travel to _Windy Glade_
|tip Manually skip to the next step.
step
goto 47.74,76.54
step
goto 43.34,77.58
'Use Skyshard
|tip Manually skip to the next step.
step
'Open Auridon Map
'Travel to _Tanzelwil_
|tip Manually skip to the next step.
step
goto 54.32,69.88
'Open Ondil
|tip Manually skip to the next step.
step
goto ondil_base 29.65,85.10
step
goto 14.33,73.67
step
goto 61.56,54.26
step
goto 83.76,62.32
'Use Skyshard
|tip Manually skip to the next step.
step
goto 61.56,54.26
step
goto 50.48,26.90
kill Aluvus |achieve 289
step
'Open Auridon Map
'Travel to _Mathiisen_
|tip Manually skip to the next step.
step
goto auridon_base 47.31,53.23
'Use Skyshard
|tip Manually skip to the next step.
step
goto 55.40,53.62
step
goto 56.03,55.79
'Open Entila's Folly
|tip Manually skip to the next step.
step
goto entilasfolly_base 61.79,54.14
step
goto 81.81,79.12
'Use Skyshard
|tip Manually skip to the next step.
step
goto 62.63,74.67
step
goto 57.22,64.13 |achieve 290
step
goto 34.91,53.63 |achieve 290
step
goto 33.33,41.97 |achieve 290
step
goto 9.86,46.65
kill Bakhig |achieve 290
step
goto 61.31,34.71
step
goto 81.33,17.66
'Open Auridon
|tip Manually skip to the next step.
step
goto auridon_base 55.40,53.57
step
goto 51.04,56.57
'Use Mathiisen Wayshrine
'Travel to _Skywatch_
|tip Manually skip to the next step.
step
goto skywatch_base 26.51,47.14
step
goto 45.04,50.58
step
goto 54.60,55.62
|tip At the top of the Fighters guild.
'Use Skyshard
|tip Manually skip to the next step.
step
goto 18.39,42.28
'Use Skywatch Wayshrine
'Travel to _Quendeluum_
|tip Manually skip to the next step.
step
goto auridon_base 59.62,39.72
'Use Skyshard
|tip Manually skip to the next step.
step
goto 58.23,40.95
step
goto 58.54,37.71
step
goto 57.72,32.23
'Open Wansalen
|tip Manually skip to the next step.
step
goto wansalen_base 41.92,36.38
step
goto 28.02,54.46
'Use Skyshard
|tip Manually skip to the next step.
step
goto 37.81,87.90
kill Nolonir |achieve 291
step
'Open Auridon Map
'Travel to _College_ Wayshrine
|tip Manually skip to the next step.
step
goto auridon_base 49.11,32.48
step
goto 48.29,36.74
step
goto 47.17,35.30
'Use Skyshard
|tip Manually skip to the next step.
step
goto 48.28,36.72
step
goto 42.99,39.99
step
goto 43.45,40.18
'Open Bewan
|tip Manually skip to the next step.
step
goto bewan_base 43.36,43.54
step
goto 50.48,69.86
step
goto 87.40,69.86
'Use Skyshard
|tip Manually skip to the next step.
step
goto 79.17,43.57
step
goto 56.27,21.54
kill Camandar |achieve 293
step
goto 52.67,12.63
step
goto 12.94,05.73
'Open Auridon
|tip Manually skip to the next step.
step
goto auridon_base 43.31,36.58
step
goto 40.72,34.09
step
goto 41.18,31.80 |tip Climb the rocks.
step
goto 41.82,31.77
'Use Skyshard
|tip Manually skip to the next step.
step
'Open Auridon Map
'Travel to _Greenwater_
|tip Manually skip to the next step.
step
goto 23.59,23.75
step
goto 19.58,21.12
|tip Drop down slowly on the right side of the waterfall.
'Open Mehrunes' Spite
|tip Manually skip to the next step.
step
goto mehrunesspite_base 53.86,70.04
step
goto 71.23,59.88
step
goto 69.39,25.62
'Use Skyshard
|tip Manually skip to the next step.
step
goto 58.84,20.18 |achieve 292
step
goto 56.62,36.94 |achieve 292
step
goto 29.61,39.43
kill Mati |achieve 292
step
'Open Auridon Map
'Travel to _Firsthold_
|tip Manually skip to the next step.
step
goto auridon_base 40.83,20.73
step
goto 44.82,20.80
step
goto 43.32,12.39
step
goto 40.09,13.29
step
goto 43.52,16.91
step
goto 41.50,12.86
|tip At the top of the lighthouse.
'Use Skyshard
|tip Manually skip to the next step.
step
'Open Grahtwood Map
'Travel to _Haven_
|tip Manually skip to the next step.
step
goto haven_base 56.86,37.30
'Open Haven City Gates
|tip Manually skip to the next step.
step
goto 38.42,25.12
'Use Skyshard
|tip Manually skip to the next step.
step
goto 56.82,36.93
'Open Haven City Gates
|tip Manually skip to the next step.
step
goto 58.26,39.15
'Use Haven Wayshrine
'Travel to _Southpoint_
|tip Manually skip to the next step.
step
goto grahtwood_base 44.72,72.37
'Use Skyshard
|tip Manually skip tot he next step
step
goto 44.65,75.79
'Use Southpoint Wayshrine
'Travel to _Gray Mire_
|tip Manually skip to the next step.
step
goto 53.57,66.23
step
goto 56.55,66.50
'Open Ne Salas
|tip Manually skip to the next step.
step
goto nesalas_base 15.74,33.98
step
goto 15.66,76.01
step
goto 57.43,57.64
'Use Skyshard
|tip Manually skip to the next step.
step
goto 64.11,72.37
kill Lieutenant Khari |achieve 573
step
goto 73.93,72.32
step
goto 83.58,9.27
'Open Grahtwood
|tip Manually skip to the next step.
step
goto grahtwood_base 52.53,66.50
step
goto 49.13,59.84
step
goto 52.45,59.84
'Open Mobar Mine
|tip Manually skip to the next step.
step
goto mobarmine_base 88.30,75.21
step
goto 61.44,34.72
step
goto 31.74,28.28
step
goto 39.13,47.71
|tip Up on the wooden walkway.
'Use Skyshard
|tip Manually skip to the next step.
step
goto 17.02,51.27
step
goto 10.07,61.68
kill Sgolag |achieve 578
step
goto 88.50,81.18
'Open Grahtwood
|tip Manually skip to the next step.
step
goto eldenrootgroundfloor_base 27.90,86.33
step
goto 35.02,68.16
step
goto 55.89,64.70
step
goto 65.74,47.06
step
goto 75.20,62.41
'Use Skyshard
|tip Manually skip to the next step.
step
goto grahtwood_base 63.27,62.82
step
goto 64.92,66.68
'Use Skyshard
|tip Manually skip to the next step.
step
goto 60.39,68.03
step
goto 57.85,71.65
'Use Gray Mire Wayshrine
'Travel to _Falinesti Winter_
|tip Manually skip to the next step.
step
goto 37.40,57.91
step
goto 36.42,59.56 |tip Drop down carefully.
step
goto 32.44,60.03
'Use Skyshard
|tip Manually skip to the next step.
step
'Open Grahtwood Map
'Travel to _Falinesti Winter_
|tip Manually skip to the next step.
step
goto 45.59,52.04
step
goto 47.41,53.63
'Use Skyshard
|tip Manually skip to the next step.
step
goto 44.25,49.12
step
goto 46.59,45.08
step
goto 48.42,44.49
|tip Drop down carefully.
'Open Burroot Kwama Mine
|tip Manually skip to the next step.
step
goto burrootkwamamine_base 40.33,77.79
step
goto 75.75,51.95
kill Stormhead the Ravenous |achieve 576
step
goto 78.10,44.28
'Use Skyshard
|tip Manually skip to the next step.
step
'Open Grahtwood Map
'Travel to _Ossuary_
|tip Manually skip to the next step.
step
goto grahtwood_base 80.62,50.88
'Open The Scuttle Pit
|tip Manually skip to the next step.
step
goto dessicatedcave_base 50.60,29.62
step
goto 61.87,46.43
'Use Skyshard
|tip Manually skip to the next step.
step
goto 57.61,69.11 |achieve 574
step
goto 55.67,84.56 |achieve 574
step
goto 32.86,71.85 |achieve 574
step
goto 57.54,50.30 |achieve 574
step
goto 52.17,28.89 |achieve 574
step
goto 36.56,25.25
kill Spider Queen |achieve 574
step
'Open Grahtwood Map
'Travel to _Elden Root Temple_
|tip Manually skip to the next step.
step
goto grahtwood_base 69.31,36.57
step
goto 72.19,36.19
'Open Vinedeath Cave
|tip Manually skip to the next step.
step
goto vindeathcave_base 73.72,74.56
'Use Skyshard
|tip Manually skip to the next step.
step
goto 32.24,76.68
kill Madruin |achieve 575
step
goto 15.64,26.00
|tip Follow the path through the vine door.
'Open Grahtwood
|tip Manually skip to the next step.
step
goto grahtwood_base 66.63,35.53
step
goto 64.99,34.67
step
goto 64.83,36.28
'Use Skyshard
|tip Manually skip to the next step.
step
goto 61.88,33.95
step
goto 58.94,31.91
'Use Skyshard
|tip Manually skip to the next step.
step
goto 59.49,30.84
step
goto 55.08,27.06
'Use Cormount Wayshrine
'Travel to _Redfur Trading Post_
|tip Manually skip to the next step.
step
goto 28.79,22.44
'Use Skyshard
|tip Manually skip to the next step.
step
goto 26.47,17.56
step
goto 21.90,17.11
step
goto 18.38,14.62
'Open Wormroot Depths
|tip Manually skip to the next step.
step
goto wormrootdepths_base 18.62,70.50
'Use Skyshard
|tip Manually skip to the next step.
step
goto 34.45,77.66 |achieve 577
step
goto 77.15,78.67 |achieve 577
step
goto 68.77,34.66
kill Raynia |achieve 577
step
'Open Greenshade Map
'Travel to _Marbruk_
|tip Manually skip to the next step.
step
goto marbruk_base 34.43,31.74
'Open Mages Guild
|tip Manually skip to the next step.
step
goto 31.64,21.54
'Open Marbruk
|tip Manually skip to the next step.
step
goto 28.42,25.62
'Open Mages Guild
|tip Manually skip to the next step.
step
goto 33.74,21.06
'Open Marbruk
|tip Manually skip to the next step.
step
goto 33.41,19.86
'Use Skyshard
|tip Manually skip to the next step.
step
goto 27.02,73.48
step
goto greenshade_base 70.68,66.41
'Open Passage to the Wood Orc Camp
|tip Manually skip to the next step.
step
goto 74.27,66.24
step
goto 73.90,60.88
'Open Gurzag's Mine
|tip Manually skip to the next step.
step
goto gurzagsmine_base 34.62,47.03
step
goto 36.17,76.66
step
goto 67.62,73.97
step
goto 73.03,56.86
step
goto 61.76,57.14
|tip Up the Ramp
'Use Skyshard
|tip Manually skip to the next step.
step
goto 75.72,47.38
kill Retribution |achieve 555
step
'Open Greenshade Map
'Travel to _Labyrinth_
|tip Manually skip to the next step. 
step
goto greenshade_base 64.96,78.60
step
goto 62.85,79.50
|tip Climb the Spiral rock.
'Use Skyshard
|tip Manually skip to the next step.
step
goto 59.03,89.44
step
goto 58.00,89.01
'Open Carac Dena
|tip Manually skip to the next step.
step
goto caracdena_base 15.03,30.23
step
goto 16.25,71.84
step
goto 58.39,63.10
kill Urrumaz the Terrifying |achieve 553
step
goto 54.21,49.61
'Use Skyshard
|tip Manually skip to the next step.
step
'Open Greenshade Map
'Travel to _Labyrinth_
|tip Manually skip to the next step.
step
goto greenshade_base 59.29,67.65
step
goto 55.11,68.37
step
goto 52.79,65.71
'Use Skyshard
|tip Manually skip to the next step.
step
'Open Marbruk Map
'Travel to _Woodhearth_
|tip Manually skip to the next step.
step
goto woodhearth_base 48.56,74.37
'Use Skyshard
|tip Manually skip to the next step.
step
goto 83.56,65.92
step
goto greenshade_base 34.59,73.35
'Use Skyshard
|tip Manually skip to the next step.
step
goto 37.14,68.40
'Open Naril Nagaia
|tip Manually skip to the next step.
step
goto narilnagaia_base 21.44,46.22
step
goto 26.56,73.08
'Use Skyshard
|tip Manually skip to the next step.
step
goto 75.19,62.64
kill Archmage Camaano |achieve 567
step
goto 82.89,61.58
step
goto 85.70,15.79
|tip Follow the path through the metal gate.
'Open Greenshade
|tip Manually skip to the next step.
step
goto greenshade_base 30.92,64.28 |tip Drop down carefully.
step
goto 29.71,57.39
step
goto 25.60,56.15
step
goto 28.83,50.44
'Use Serpent's Grotto Wayshrine
'Travel to _Falinesti_
|tip Manually skip to the next step.
step
goto 60.41,40.54
'Use Skyshard
|tip Manually skip to the next step.
step
goto 58.19,44.48
step
goto 63.16,45.17
'Open Harridan's Lair
|tip Manually skip to the next step.
step
goto harridanslair_base 73.55,74.56
'Use Skyshard
|tip Manually skip to the next step.
step
goto 22.90,77.22
kill Razorclaw |achieve 558
step
goto 15.40,25.93
|tip Follow the path through the vine door.
'Open Greenshade
|tip Manually skip to the next step.
step
goto greenshade_base 52.75,45.48
step
goto 53.68,48.03
step
goto 55.82,47.29
'Use Skyshard
|tip Manually skip to the next step.
step
'Open Greenshade Map
'Travel to _Seaside Sanctuary_
|tip Manually skip to the next step.
step
goto 31.07,40.56
'Open The Underroot
|tip Manually skip to the next step.
step
goto theunderroot_base 57.20,40.93
step
goto 58.35,75.43
step
goto 33.96,77.82
step
goto 57.43,44.64
step
goto 44.20,28.41
step
goto 33.17,27.49
kill Domina Ssaranth |achieve 550
step
goto 46.48,23.95
|tip Carefully jump over to the rock.
'Use Skyshard
|tip Manually skip to the next step.
step
'Open Greenshade Map
'Travel to _Moonhenge_
|tip Manually skip to the next step.
step
goto greenshade_base 30.15,15.70
|tip Drop down carefully.
'Use Skyshard
|tip Manually skip to the next step.
step
goto 29.50,15.11
'Open Barrow Trench
|tip Manually skip to the next step.
step
goto barrowtrench_base 54.62,55.89
'Use Skyshard
|tip Manually skip to the next step.
step
goto 63.63,35.41
step
goto 33.90,24.83
step
goto 30.86,59.93
kill Overseer Basri |achieve 559
step
'Open Malabal Tor Map
'Travel to _Velyn Harbor_
|tip Manually skip to the next step.
step
goto velynharbor_base 41.40,50.66
step
goto 79.60,49.81
step
goto 78.97,45.30
'Use Skyshard
|tip Manually skip to the next step.
step
goto malabaltor_base 22.56,53.52
step
goto 21.54,48.63
step
goto 21.38,45.13
'Use Skyshard
|tip Manually skip to the next step.
step
goto 24.86,53.06
step
goto 31.79,45.81
step
goto 33.36,40.68
step
goto 35.06,41.56
'Open Dead Man's Drop
|tip Manually skip to the next step.
step
goto deadmansdrop_base 68.74,39.88
step
goto 62.40,15.66
step
goto 19.13,13.47
'Use Skyshard
|tip Manually skip to the next step.
step
goto 24.61,44.76 |achieve 274
step
goto 37.96,71.53
kill Captain Shammin |achieve 274
step
'Open Malabal Tor Map
'Travel to _Dra'bul_
|tip Manually skip to the next step.
step
goto 34.23,59.36
'Use Skyshard
|tip Manually skip to the next step.
step
goto 37.93,62.43
'Open Tomb of the Apostates
|tip Manually skip to the next step.
step
goto tomboftheapostates_base 68.83,83.07 |achieve 297
step
goto 62.34,58.82
kill Gwaeregil |achieve 297
step
goto 54.02,16.83
'Use Skyshard
|tip Manually skip to the next step.
step
goto 25.38,44.29
'Open Malabal Tor
|tip Manually skip to the next step.
step
goto malabaltor_base 46.41,59.39
step
goto 46.32,59.34
step
goto 48.59,61.91
step
goto 47.78,65.19
step
goto 49.16,66.86
'Use Skyshard
|tip Manually skip to the next step.
step
'Open Malabal Tor Map
'Travel to _Vulkwasten_
|tip Manually skip to the next step.
step
goto 47.35,56.26
'Open Hoarvor Pit
|tip Manually skip to the next step.
step
goto hoarvorpit_base 70.04,14.07
step
goto 44.12,12.81
'Use Skyshard
|tip Manually skip to the next step.
step
goto 26.10,43.18
step
goto 66.50,44.27
'Use Daedric Bindings
kill Oghezai |achieve 298
step
goto 60.71,45.41 |tip Drop down.
step
goto 46.64,53.25
'Open Malabal Tor
|tip Manually skip to the next step.
step
goto malabaltor_base 50.67,58.35
|tip Drop down carefully.
'Use Skyshard |q Something Rotten/Use Cold Water on Timber Mammoths to Rouse Them |future
|tip Manually skip to the next step.
step
'Open Malabal Tor Map
'Travel to _Vulkwasten_
|tip Manually skip to the next step.
step
goto vulkwasten_base 46.24,25.29
'Use Skyshard
|tip Manually skip to the next step.
step
goto 46.31,78.98
'Use Vulkwasten Wayshrine
'Travel to _Abamath_
|tip Manually skip to the next step.
step
goto malabaltor_base 62.56,82.78
'Open Shael Ruins
|tip Manually skip to the next step.
step
goto shaelruins_base 34.19,40.85
step
goto 46.79,86.25
step
goto 31.52,89.90
'Use Skyshard
|tip Manually skip to the next step.
step
goto 75.39,71.09
kill Arrai |achieve 286
step
'Open Malabal Tor Map
'Travel to _Valeguard_
|tip Manually skip to the next step.
step
goto malabaltor_base 77.96,56.93
step
goto 78.78,57.14
'Use Skyshard
|tip Manually skip to the next step.
step
goto 75.28,55.25
step
goto 76.13,51.10
step
goto 70.79,49.24
'Open Roots of Silvenar
|tip Manually skip to the next step.
step
goto rootsofsilvenar_base 57.15,40.29
'Use Skyshard
|tip Manually skip to the next step.
step
goto 86.49,47.66 |achieve 282
step
goto 88.01,57.13
kill Adavos Dren |achieve 282
step
'Open Malabal Tor Map
'Travel to _Wilding Run_
|tip Manually skip to the next step.
step
goto baandaritradingpost_base 18.46,25.70
'Open Black Vine Ruins
|tip Manually skip to the next step.
step
goto blackvineruins_base 27.49,7.73
step
goto 37.89,87.12
'Use Skyshard
|tip Manually skip to the next step.
step
goto 84.01,49.62
step
goto 54.97,25.97
kill Blackvine Strangler |achieve 281
step
goto 51.60,14.73
step
goto 35.65,13.71
step
goto 32.54,28.84
step
goto 9.22,7.33
'Open Malabal Tor |q The Ties that Bind |future
|tip Manually skip to the next step.
step
goto malabaltor_base 77.44,34.17
'Use Skyshard
|tip Manually skip to the next step.
step
goto 73.62,31.80
step
goto 75.07,25.19
step
goto 64.41,24.16
'Use Skyshard
|tip Manually skip to the next step.
step
'Open Reaper's March
'Travel to _Fort Grimwatch_
|tip Manually skip to the next step.
step
goto reapersmarch_base 37.84,19.89
'Use Skyshard
|tip Manually skip to the next step.
step
goto 35.23,13.47
step
goto 34.31,14.99
'Use Skyshard
|tip Manually skip to the next step.
step
goto 36.30,17.55
step
goto 43.00,24.63
step
goto 43.82,31.60
step
goto 42.97,33.38
'Use Skyshard
|tip Manually skip to the next step.
step
goto 36.44,37.89
step
goto 33.57,39.99
step
goto 36.08,40.88
'Open Thibaut's Cairn
|tip Manually skip to the next step.
step
goto thibautscairn_base 24.49,73.12
step
goto 61.54,83.08
step
goto 87.20,75.19
step
goto 86.53,66.26
step
goto 77.92,66.41
'Use Skyshard
|tip Manually skip to the next step.
step
goto 78.49,43.65 |achieve 454
step
goto 66.33,43.62
'Open Upper Vault |achieve 454
|tip Manually skip to the next step.
step
goto 24.60,35.26 |achieve 454
step
goto 21.65,20.55
kill Worm Eremite |achieve 454
step
'Open Reaper's March Map 
'Travel to _Rawl'kha_
|tip Manually skip to the  next step.
step
goto reapersmarch_base 36.93,52.21
step
goto 34.45,54.68
step
goto 33.40,53.84
'Use Skyshard
|tip Manually skip to the next step.
step
goto 34.29,52.53
step
goto 39.51,62.17
step
goto 41.44,64.49
step
goto 41.09,65.50 |tip Climb the rocks.
step
goto 39.65,64.52
'Use Skyshard
|tip Manually skip to the next step.
step
goto 28.17,62.43
'Use Skyshard
|tip Manually skip to the next step.
step
goto 23.81,60.63
'Open Claw's Strike
|tip Manually skip to the next step.
step
goto clawsstrike_base 11.61,39.22
'Use Skyshard
|tip Manually skip to the next step.
step
goto 88.24,69.19
kill Fishbreath |achieve 456
step
'Open Reaper's March Map
'Travel to _Willowgrove_
|tip Manually skip to the next step.
step
goto reapersmarch_base 50.44,75.43
'Open Weeping Wind Cave
|tip Manually skip to the next step.
step
goto weepingwindcave_base 61.67,59.08
step
goto 37.63,83.08
'Use Skyshard
|tip Manually skip to the next step.
step
goto 62.77,51.50 |achieve 455
step
goto 53.42,11.67 |achieve 455
step
goto 64.49,31.55
kill Nimriian |achieve 455
step
'Open Reaper's March Map
'Travel to _S'ren-ja_
|tip Manually skip to the next step.
step
goto reapersmarch_base 50.85,36.50
step
goto 54.17,30.06
'Open Kuna's Delve
|tip Manually skip to the next step.
step
goto kunasdelve_base 55.64,64.28
step
goto 74.40,43.49
'Use Skyshard
|tip Manually skip to the next step.
step
goto 18.85,30.44
kill Limbrender |achieve 453
step
goto 52.93,64.40
step
goto 30.20,85.63
'Open Reaper's March
|tip Manually skip to the next step.
step
goto reapersmarch_base 54.46,32.44
step
goto 59.13,33.69
step
goto 63.34,39.53
'Open Jode's Light
|tip Manually skip to the next step.
step
goto jodeslight_base 15.11,26.38
'Use Skyshard
|tip Manually skip to the next step.
step
goto 16.40,62.71
step
goto 51.97,58.77
kill Yenadar |achieve 458
step
goto 50.03,16.67
'Open Reaper's March
|tip Manually skip to the next step.
step
goto dune_base 41.67,52.69
step
goto 59.95,32.97
|tip Climb the rock.
'Use Skyshard
|tip Manually skip to the next step.
step
goto 48.05,38.05
step
goto 33.03,25.91
'Use Dune Wayshrine
'Travel to _Fort Sphinxmoth_
|tip Manually skip to the next step.
step
goto reapersmarch_base 76.81,16.77
'Use Skyshard
|tip Manually skip to the next step.
step
goto 75.33,12.79
'Open Fardir's Folly
|tip Manually skip to the next step.
step
goto fardirsfolly_base 40.96,10.40
step
goto 40.49,50.77
step
goto 24.13,57.16
step
goto 9.18,76.38
step
goto 20.99,89.37
step
goto 31.70,89.21
step
goto 32.76,40.17
'Use Skyshard
|tip Manually skip to the next step.
step
goto 41.58,72.73 |achieve 622
step
goto 81.72,70.11 |achieve 622
step
goto 76.07,15.93
kill Ravo Peltrasius |achieve 622
step
|tip Manually skip to the next step to advance to the guide. |next Extras\\Extras\\Skyshards and Delves\\Daggerfall Covenant
]])

ZGV:RegisterGuide("Extras\\Extras\\Skyshards and Delves\\Daggerfall Covenant",[[
loadingimage loadscreen_wgt_throneroom_01.dds
description All Skyshards and Delves from Daggerfall Covenant.
step
'_Recommended to start with Aldmeri Dominion for easy flow between guides._
'Open Betnikh Map
'Travel to _Stonetooth_
|tip Manually skip to the next step.
]])

ZGV:RegisterGuide("Extras\\Extras\\Skyshards and Delves\\Ebonheart Pact",[[
loadingimage loadscreen_tribunal_01.dds
description All Skyshards and Delves from Ebonheart Pact.
step
'_Recommended to start with Aldmeri Dominion for easy flow between guides._
]])

ZGV:RegisterGuide("Extras\\Extras\\Skyshards and Delves\\Interlude I",[[
loadingimage loadscreen_wrothgarruins.dds
description All Skyshards and Delves from Coldharbour, Craglorn, Wrothgar, Thieves Guild, and Dark Brotherhood
step
'Comming Soon
]])

ZGV:RegisterGuide("Extras\\Extras\\Skyshards and Delves\\Daedric Wars",[[
loadingimage loadscreen_alinorroyalpalace_01.dds
description All Skyshards and Delves from Vvardenfell, Clockwork City, and Summerset
step
'Comming Soon
]])

ZGV:RegisterGuide("Extras\\Extras\\Skyshards and Delves\\Murkmire",[[
loadingimage loadscreen_murkmire_01.dds
description All Skyshards and Delves from Murkmire
step
'Comming Soon
]])

ZGV:RegisterGuide("Extras\\Extras\\Skyshards and Delves\\Season of the Dragon",[[
loadingimage loadscreen_dragonhold_island_01.dds
description All Skyshards and Delves from Northern and Southern Elsweyr
step
'Comming Soon
]])

ZGV:RegisterGuide("Extras\\Extras\\Skyshards and Delves\\The Dark Heart of Skyrim",[[
loadingimage loadscreen_darkstorm_capper2_01.dds
description All Skyshards and Delves from Western Skyrim and The Reach
step
'Comming Soon
]])

ZGV:RegisterGuide("Extras\\Extras\\Skyshards and Delves\\Gates of Oblivion",[[
loadingimage loadscreen_fort_sundercliff_01.dds
description All Skyshards and Delves from Blackwood, Fargrave, and The Deadlands
step
'Comming Soon
]])

ZGV:RegisterGuide("Extras\\Extras\\Skyshards and Delves\\Legacy of the Breton",[[
loadingimage loadscreen_hi_allflagsisland_01.dds
description All Skyshards and Delves from High Isle and Amenos
step
'Comming Soon
]])