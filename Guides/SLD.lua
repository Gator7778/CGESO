local ZGV = _G.ZGV
ZGV.GuideMenuTier = "TAM"

ZGV:RegisterGuide("Extras\\Extras\\Skyshards ,Lorebooks, and Delves\\Aldmeri Dominion",[[
loadingimage loadscreen_eldentreeplatform_01.dds
description All Skyshards from Aldmeri Dominion Legacy Zones.
step
'Open Khenarthi's Roost Map
'Travel to _Khenarthi's Roost_ in Khenarthi's Roost
|tip Manually skip to the next step.
step
goto khenarthisroost_base 53.83,70.08
|tip Go up the stairs and behind the building.
'Use Skyshard
|tip Manually skip to the next step.
step
goto 58.83,80.98
|tip Go to the top of the tower.
'Use Skyshard
|tip Manually skip to the next step.
step
'Open Khenarthi's Roost Map
'Travel to _Mistral_
|tip Manually skip to the next step.
step
goto mistral_base 15.16,34.60
'Use Skyshard
|tip Manually skip to the next step.
step
goto khenarthisroost_base 27.70,31.80
step
goto 28.03,36.41
'Use Skyshard
|tip Manually skip to the next step.
step
goto 16.34,55.55
|tip Swim to this Island.
'Use Skyshard
|tip Manually skip to the next step.
step
'Open Auridon Map
'Travel to _Vulkhel Guard_ in Auridon
|tip Manually skip to the next step.
step
goto vulkhelguard_base 43.56,45.48
'Examine Frontier, Conquest |lorebook Frontier, Conquest/1/19/2
step
goto 39.65,40.38
|tip On the Balcony of the Manor.
'Use Skyshard
|tip Manually skip to the next step.
step
goto 22.93,55.24 |lorebook History of the Fighters Guild Pt. 1/1/19/3
step
goto auridon_base 50.86,90.97
'Examine History of the Fighters Guild Pt. 1 |lorebook History of the Fighters Guild Pt. 1/1/19/3
step
goto vulkhelguard_base 22.93,55.24 |lorebook Ayleid Inscriptions Translated/1/19/1
step
goto 39.35,43.81 |lorebook Ayleid Inscriptions Translated/1/19/1
step
goto 50.80,38.66
|tip It's upstairs in Mara's Kiss Public House.
'Examine Ayleid Inscriptions Translated |lorebook Ayleid Inscriptions Translated/1/19/1
step
goto 61.30,24.83 |lorebook History of the Fighters Guild Pt. 2/1/19/4
step
goto auridon_base 59.31,84.91
'Examine History of the Fighters Guild Pt. 2 |lorebook History of the Fighters Guild Pt. 2/1/19/4
step
goto 58.09,89.52
'Open Del's Claim
|tip Manually skip to the next step.
step
goto delsclaim_base 39.66,66.72
step
goto 41.25,40.60
step
goto 24.28,34.32
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
goto 60.90,50.49
step
goto 16.85,89.26
'Open Auridon
|tip Manually skip to the next step.
step
'Examine Ayleid Inscriptions Translated |lorebook Ayleid Inscriptions Translated/1/19/1
step
goto auridon_base 62.39,81.25
|tip required sidequests to open Manion to retrieve Skyshard.
talk Elenwen |q Silsailen Rescue/Talk to Elenwen
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
goto 70.24,83.24
|tip Door on your left.
'Open Silsailen |q Teldur's End/Talk to Elenwen
|tip Manually skip to the next step.
step
goto 70.70,83.20
'Use Skyshard
|tip Manually skip to the next step.
step
goto 70.61,83.00
goto 70.14,83.14
talk Elenwen
|tip Drop down.
|tip She's downstairs inside this big building.
turnin Teldur's End
step
'Open Auridon Map
'Travel to _Windy Glade_
|tip Manually skip to the next step.
step
goto 52.99,81.92
'Examine Origin of the Mages Guild |lorebook Origin of the Mages Guild/1/19/5
step
goto 49.18,76.51
'Examine Monomyth: Dragon God & Missing God |lorebook Monomyth: Dragon God & Missing God/1/10/3
step
goto 47.48,73.27
step
goto 46.90,73.20
step
goto 45.86,74.82
step
goto 43.31,77.60
'Use Skyshard
|tip Manually skip to the next step.
step
'Open Auridon Map
'Travel to _Pher_ |lorebook Ancient Scrolls of the Dwemer II/1/12/2
|tip Manually skip to the next step.
step
goto 59.26,76.69
'Examine Ancient Scrolls of the Dwemer II |lorebook Ancient Scrolls of the Dwemer II/1/12/2
step
goto 64.25,75.50
'Examine Ancient Scrolls of the Dwemer III |lorebook Ancient Scrolls of the Dwemer III/1/12/3
step
'Open Auridon Map
'Travel to _Tanzelwil_
|tip Manually skip to the next step.
step
goto 54.53,69.64
'Examine Ancient Scrolls of the Dwemer I-A |lorebook Ancient Scrolls of the Dwemer I-A/1/12/1
step
goto 54.31,69.87
'Open Ondil
|tip Manually skip to the next step.
step
goto ondil_base 29.65,85.10
step
goto 14.33,73.67
step
goto 61.33,58.04 |achieve 289
step
goto 50.48,26.90
kill Aluvus |achieve 289
step
goto 61.33,58.04
step
goto 84.07,62.40
'Use Skyshard
|tip Manually skip to the next step.
step
goto 61.33,58.04
step
goto 14.33,73.67
step
goto 29.65,85.10
step
goto 7.37,85.75
'Open Auridon |lorebook The Lunar Lorkhan/1/10/2
|tip Manually skip to the next step.
step
goto auridon_base 51.23,68.67 |lorebook The Lunar Lorkhan/1/10/2
step
goto 48.88,67.14
'Examine The Lunar Lorkhan |lorebook The Lunar Lorkhan/1/10/2
step
goto 46.01,66.28 |lorebook Boethiah's Proving/1/8/2
step
goto 39.68,64.57
'Examine Boethiah's Proving |lorebook Boethiah's Proving/1/8/2
step
'Open Auridon Map
'Travel to _Mathiisen_
|tip Manually skip to the next step.
step
goto 51.84,54.52
'Examine Triumphs of a Monarch, Ch. 6 |lorebook Triumphs of a Monarch, Ch. 6/1/9/6
step
goto 49.56,54.56
'Examine Triumphs of a Monarch, Ch. 10 |lorebook Triumphs of a Monarch, Ch. 10/1/9/7
step
goto 49.62,57.34
'Examine Trials of Saint Alessia |lorebook Trials of Saint Alessia/1/9/8
step
goto 51.37,56.54
step
goto 53.65,61.28
step
goto 58.10,61.56
step
|tip Inside the shed.
goto 59.73,58.87
'Examine The Anuad Paraphrased |lorebook The Anuad Paraphrased/1/10/1
step
goto auridon_base 62.39,55.91
|tip Leave the shed.
'Examine Triumphs of a Monarch, Ch. 3 |lorebook Triumphs of a Monarch, Ch. 3/1/9/5
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
'Open Auridon Map
'Travel to _Skywatch_
|tip Manually skip to the next step.
step
goto skywatch_base 26.93,45.69
'Examine Jorunn the Skald-King |lorebook Jorunn the Skald-King/1/9/4
step
goto 54.83,55.54
'Use Skyshard
|tip Manually skip to the next step.
step
goto 40.39,57.82 |lorebook The Illusion of Death/1/9/3
step
goto 46.06,69.75 |lorebook The Illusion of Death/1/9/3
step
goto auridon_base 77.82,56.38 |lorebook The Illusion of Death/1/9/3
step
goto 78.80,51.93 |lorebook The Illusion of Death/1/9/3
step
goto 80.34,51.25
'Examine The Illusion of Death |lorebook The Illusion of Death/1/9/3
step
'Open Auridon Map
'Travel to _Quendeluum_
|tip Manually skip to the next step.
step
goto 59.63,39.73
'Use Skyshard
|tip Manually skip to the next step.
step
goto 59.27,41.20
step
goto 58.06,39.66
step
goto 58.66,37.55
'Examine Great Harbingers of the Companions |lorebook Great Harbingers of the Companions/1/9/2
step
goto 57.60,32.7
|tip Follow path through the tunnel.
'Examine Galerion the Mystic |lorebook Galerion the Mystic/1/9/1
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
'Travel to _Skywatch_
|tip Manually skip to the next step.
step
goto auridon_base 61.03,49.40
step
goto 56.69,45.50
step
goto 55.94,47.31
'Examine Why Don the Veil? |lorebook Why Don the Veil?/1/25/5
step
goto 51.73,40.07
step
goto 50.81,39.44
'Examine Aedra and Daedra |lorebook Aedra and Daedra/1/8/1
step
goto 47.88,36.54
step
goto 47.18,35.30
'Use Skyshard
|tip Manually skip to the next step.
step
goto 47.88,36.54
step
goto 44.89,35.91
'Examine The Lay of Firsthold |lorebook The Lay of Firsthold/1/25/3
step
goto 43.45,40.18
'Open Bewan
|tip Manually skip to the next step.
step
goto bewan_base 43.36,43.54
step
goto 29.68,68.72
step
goto 87.30,70.02
'Use Skyshard
|tip Manually skip to the next step.
step
goto 56.27,21.54
kill Camandar |achieve 293
step
goto 53.25,13.04
step
goto 12.94,05.73
'Open Auridon
|tip Manually skip to the next step.
step
goto auridon_base 42.56,37.51
step
goto 43.17,36.32
step
goto 41.37,34.56
step
goto 40.85,32.67
step
goto 41.79,31.80
|tip Climb the rocks.
'Use Skyshard
|tip Manually skip to the next step.
step
goto 37.58,32.82
step
goto 32.32,32.61
'Examine Thalmor Handbill |lorebook Thalmor Handbill/1/25/10
step
'Open Auridon Map
'Travel to _Greenwater_
|tip Manually skip to the next step.
step
goto 23.92,28.15
'Examine Fang of the Sea Vipers/1/25/6 |lorebook Fang of the Sea Vipers/1/25/6
step
goto 23.57,23.81
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
'Travel to _College_
|tip Manually skip to the next step.
step
goto 52.21,29.76
|tip Go across the bridge.
'Examine Varieties of Faith: The High Elves |lorebook Varieties of Faith: The High Elves/1/25/4
step
goto 55.64,25.52
step
goto 54.03,24.30
|tip Go across the bridge.
'Examine lorebook The Rise of Queen Ayrenn |lorebook The Rise of Queen Ayrenn/1/25/7
step
goto 46.95,16.10
'Examine Life in the Eagle's Shadow |lorebook Life in the Eagle's Shadow/1/25/9
step
goto 44.33,14.27
step
goto 42.90,11.69
step
goto 40.08,13.47
step
goto 43.59,16.73
step
goto 41.49,12.86
|tip Top of the North Beacon Lighthouse.
'Use Skyshard
|tip Manually skip to the next step.
step
'Open Auridon Map
'Travel to _Firsthold_ |lorebook Regarding the Ebonheart Pact/1/25/2
|tip Manually skip to the next step.
step
goto 37.58,23.84
'Examine Regarding the Ebonheart Pact |lorebook Regarding the Ebonheart Pact/1/25/2
step
goto 33.51,14.54
'Examine Crimes of the Daggerfall Covenant |lorebook Crimes of the Daggerfall Covenant/1/25/1
step
'Open Auridon Map
'Travel to _Firsthold_ |lorebook Kinlord Rilis and the Mages Guild/1/25/8 
|tip Manually skip to the next step.
step
goto 34.96,20.35 |lorebook Kinlord Rilis and the Mages Guild/1/25/8 
step
goto firsthold_base 73.09,64.11 |lorebook Kinlord Rilis and the Mages Guild/1/25/8 
step
goto 69.97,56.81 |lorebook Kinlord Rilis and the Mages Guild/1/25/8 
step
goto 73.46,55.88
'Examine Kinlord Rilis and the Mages Guild |lorebook Kinlord Rilis and the Mages Guild/1/25/8
step
'Open Grahtwood Map
'Travel to _Haven_
|tip Manually skip to the next step.
step
goto grahtwood_base 82.92,71.38
'Examine In the Company of Wood Orcs |lorebook In the Company of Wood Orcs/1/26/10
step
goto haven_base 58.26,35.16
'Open Haven City Gates
|tip Manually skip to the next step.
step
goto 39.75,25.18
'Examine The Legend of Vastarie |lorebook The Legend of Vastarie/1/26/9
step
goto 38.50,24.87
'Use Skyshard
|tip Manually skip to the next step.
step
goto 41.14,18.14
'Open Haven City Gates
|tip Manually skip to the next step.
step
goto grahtwood_base 76.69,60.20
'Examine Aurbic Enigma 4: The Elden Tree |lorebook Aurbic Enigma 4: The Elden Tree/1/26/8
step
goto 74.31,56.64
'Examine Ayleid Survivals in Valenwood |lorebook Ayleid Survivals in Valenwood/1/26/7
step
goto 79.82,54.50
step
goto 80.62,50.88
'Open The Scuttle Pit
|tip Manually skip to the next step.
step
goto dessicatedcave_base 50.60,29.62
step
goto 61.87,46.43
'Use Skyshard
|tip Manually skip to the next step.
step
goto 57.61,69.11
step
goto 55.67,84.56
step
goto 32.86,71.85
step
goto 57.54,50.30
step
goto 52.17,28.89
step
goto 36.56,25.25
kill Spider Queen |achieve 574
step
goto 43.26,27.89
step
goto 31.72,40.53
'Open Grahtwood
|tip Manually skip to the next step.
step
goto grahtwood_base 76.92,52.47
step
goto 77.71,48.57
'Examine Magic from the Sky |lorebook Magic from the Sky/1/15/3
step
goto 72.56,41.35
step
goto 72.31,37.19
'Examine Manual of Spellcraft |lorebook Manual of Spellcraft/1/15/4
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
'Open Grahtwood
|tip Manually skip to the next step.
step
goto grahtwood_base 64.20,33.44
'Examine Reality and Other Falsehoods |lorebook Reality and Other Falsehoods/1/15/7
step
goto 64.87,36.30
'Use Skyshard
|tip Manually skip to the next step.
step
goto 63.55,40.16
step
goto 58.37,39.99
step
goto 57.69,35.46
'Examine The Old Ways |lorebook The Old Ways/1/15/5
step
goto 58.95,31.96
'Use Skyshard
step
goto 56.47,26.07
'Examine The House of Troubles |lorebook The House of Troubles/1/8/4
step
goto 59.54,20.72
'Examine The Dreamstride |lorebook The Dreamstride/1/8/3
step
goto 50.14,22.04
step
goto 49.34,23.48
'Examine Guild Memo on Soul-Trapping |lorebook Guild Memo on Soul-Trapping/1/15/8
step
goto 48.27,35.82
'Examine On the Detachment of the Sheath |lorebook On the Detachment of the Sheath/1/15/6
step
goto 44.48,36.56
'Examine Ancient Scrolls of the Dwemer VI |lorebook Ancient Scrolls of the Dwemer VI/1/12/5
step
goto 48.42,44.49
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
goto 61.43,47.80
step
goto 9.51,23.73
'Open Grahtwood
|tip Manually skip to the next step.
step
goto grahtwood_base 50.89,39.33
step
goto 41.46,35.17
step
goto 35.50,36.94
'Examine Ancient Scrolls of the Dwemer X |lorebook Ancient Scrolls of the Dwemer X/1/12/6
step
goto 28.74,33.37
'Examine Before the Ages of Man: Dawn Era |lorebook Before the Ages of Man: Dawn Era/1/16/1
step
goto 26.78,31.07
'Examine Before the Ages of Man: Merethic Era |lorebook Before the Ages of Man: Merethic Era/1/16/2
step
goto 32.73,23.42
'Examine Noxiphilic Sanguivoria |lorebook Noxiphilic Sanguivoria/1/16/4
step
goto 28.80,22.43
|tip Drop down carefully.
'Use Skyshard
|tip Manually skip to the next step.
step
goto 25.63,20.35
'Examine A Werewolf's Confession |lorebook A Werewolf's Confession/1/16/5
step
goto redfurtradingpost_base 22.94,43.59
'Examine Ebony Blade History |lorebook Ebony Blade History/1/16/3
step
goto grahtwood_base 18.38,14.62
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
'Open Grahtwood Map
'Travel to _Gil-Var-Delle_
|tip Manually skip to the next step.
step
goto 36.89,43.22
'Examine Ancient Scrolls of the Dwemer |lorebook Ancient Scrolls of the Dwemer V/1/12/4
step
goto 29.85,43.33
'Examine Monomyth: The Myth of Aurbis |lorebook Monomyth: The Myth of Aurbis/1/10/6
step
'Open Grahtwood Map
'Travel _Falinesti Winter_
|tip Manually skip to the next step.
step
goto 42.68,57.99
'Examine Monomyth: Lorkhan and Satakal |lorebook Monomyth: Lorkhan and Satakal/1/10/4
step
goto 36.59,59.73
step
goto 32.46,60.03
'Use Skyshard
|tip Manually skip to the next step.
step
goto 32.33,60.78
'Examine Monomyth: "Shezarr's Song" |lorebook Monomyth: "Shezarr's Song"/1/10/5
step
'Open Grahtwood Map
'Travel to _Elden Root_
|tip Manually skip to the next step.
step
goto eldenrootgroundfloor_base 72.68,48.26
'Examine Arcana Restored |lorebook Arcana Restored/1/15/1
step
goto 75.25,62.42
'Use Skyshard
|tip Manually skip to the next step.
step
'Open Grahtwood Map
'Travel to _Haven_
|tip Manually skip to the next step.
step
goto haven_base 57.10,37.38
'Open Haven City Gates
|tip Manually skip to the next step.
step
goto 23.57,16.24
'Open Haven City Gates
|tip Manually skip to the next step.
step
goto 68.13,63.90
step
goto grahtwood_base 65.95,64.54
'Examine The Devouring of Gil-Var-Delle |lorebook The Devouring of Gil-Var-Delle/1/26/6
step
goto 64.94,66.70
'Use Skyshard
|tip Manually skip to the next step.
step
'_Fix Coordinate_
'Examine Common Arms of Valenwood |lorebook Common Arms of Valenwood/1/26/4
step
goto 64.91,72.52 |tip Drop down carefully.
step
goto 53.17,72.22
step
goto 50.14,70.35
'Examine The Book of the Great Tree |lorebook The Book of the Great Tree/1/26/3
step
goto 55.00,65.58
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
goto grahtwood_base 48.47,61.73
'Examine Varieties of Faith: The Wood Elves |lorebook Varieties of Faith: The Wood Elves/1/26/2
step
goto 50.16,61.04
step
goto 49.56,59.21
step
goto eldenrootgroundfloor_base 25.68,72.47
'Examine Liminal Bridges |lorebook Liminal Bridges/1/15/2
step
goto grahtwood_base 48.39,51.92
step
goto 47.41,53.63
'Use Skyshard
|tip Manually skip to the next step.
step
goto 48.39,51.92
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
goto 17.02,51.27 |achieve 578
step
goto 10.07,61.68
kill Sgolag |achieve 578
step
'Open Grahtwood Map
'Travel to _Southpoint_
|tip Manually skip to the next step.
step
goto grahtwood_base 45.57,78.02
'Examine War Customs of the Tribal Bosmer |lorebook War Customs of the Tribal Bosmer/1/26/5
step
goto 42.98,74.90
'Examine Varieties of Faith: The Khajiit |lorebook Varieties of Faith: The Khajiit/1/26/1
step
goto 44.74,72.34
'Use Skyshard
|tip Manually skip to the next step.
step
'Use Southpoint Wayshrine
'Travel to _Marbruk_ in Greenshade
|tip Manually skip to the next step.
step
goto marbruk_base 34.41,31.76
'Open Mages Guild
|tip Manually skip to the next step.
step
goto 24.53,36.46
'Examine Monomyth: The Heart of the World |lorebook Monomyth: The Heart of the World/1/10/7
step
goto 31.93,21.59
'Open Marbruk
|tip Manually skip to the next step.
step
goto 28.46,25.26
'Open Mages Guild
|tip Manually skip to the next step.
step
goto 33.73,21.05
'Open Marbruk
|tip Manually skip to the next step.
step
goto 33.62,19.84
'Use Skyshard
|tip Manually skip to the next step.
step
goto 27.50,72.49
step
goto greenshade_base 67.41,63.66
step
goto 70.65,66.39
'Open Passage to the Wood Orc Camp
step
goto 74.32,66.28
step
goto 74.80,62.69
'Examine Ancient Scrolls of the Dwemer XI |lorebook Ancient Scrolls of the Dwemer XI/1/12/7
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
goto 72.83,47.38
step
goto 52.24,46.72
step
goto 9.83,23.66
'Open Greenshade
|tip Manually skip to the next step.
step
goto greenshade_base 75.01,84.54
'Examine Gods and Worship In Tamriel |lorebook Gods and Worship In Tamriel/1/10/9
step
goto 69.27,86.49
step
goto 64.94,89.11
'Examine The Doors of Oblivion, Part 2 |lorebook The Doors of Oblivion, Part 2/1/17/4
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
goto greenshade_base 62.85,79.49
|tip Climb Spiral Rock
'Use Skyshard
|tip Manually skip to the next step.
step
goto 62.46,78.96
'Examine Visions of the Green Pact Bosmer |lorebook Visions of the Green Pact Bosmer/1/27/5
step
goto 64.86,76.70
'Examine Dwarven Automatons |lorebook Dwarven Automatons/1/12/9
step
goto 57.51,65.31
'Examine Words of Clan Mother Ahnissi, Pt. 2 |lorebook Words of Clan Mother Ahnissi, Pt. 2/1/27/2
step
goto 52.79,65.71
'Use Skyshard
|tip Manually skip to the next step.
step
goto 55.05,68.47
step
goto 50.97,68.83
'Examine The Ooze: A Fable |lorebook The Ooze: A Fable/1/27/3
step
'Open Greenshade Map
'Travel to _Greenheart_
|tip Manually skip to the next step.
step
goto 49.20,86.40
'Examine The Wilderking Legend |lorebook The Wilderking Legend/1/27/4
step
'Open Greenshade Map
'Travel to _Greenheart_
step
goto 56.74,75.80
step
goto 50.39,71.28
step
goto 40.16,73.72
'Examine Varieties of Daedra, Part 1 |lorebook Varieties of Daedra, Part 1/1/17/7
step
goto 37.63,77.56
'Examine Invocation of Azura |lorebook Invocation of Azura/1/8/5
step
goto 34.61,73.23
'Use Skyshard
|tip Manually skip to the next step.
step
goto 36.20,71.27
step
goto 36.27,73.73
step
goto 34.89,70.34
|tip Follow ramp up.
'Examine Darkest Darkness |lorebook Darkest Darkness/1/17/2
step
goto 33.59,67.42
'Examine The Firmament |lorebook The Firmament/1/16/6
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
'Open Greenshade Map
'Travel to _Woodhearth_
|tip Manually skip to the next step.
step
goto woodhearth_base 86.19,62.70
'Examine The Pig Children |lorebook The Pig Children/1/16/7
step
goto 69.27,81.48
'Examine The Book of Daedra |lorebook The Book of Daedra/1/17/1
step
goto 63.98,54.90
step
goto 53.67,56.59
step
goto 51.46,73.24
'Examine Sithis |lorebook Sithis/1/16/9
step
goto 48.54,74.38
'Use Skyshard
|tip Manually skip to the next step.
step
goto 63.10,30.52
'Examine Ruminations on the Elder Scrolls |lorebook Ruminations on the Elder Scrolls/1/16/8
step
goto greenshade_base 29.70,57.41
'Use Skyshard
|tip Manually skip to the next step.
step
goto 34.61,56.34
step
goto 31.33,54.75
'Examine Woodhearth: A Pocket Guide |lorebook Woodhearth: A Pocket Guide/1/27/6
step
goto 35.25,48.28
step
goto 35.84,46.01
'Examine The Eldest: A Pilgrim's Tale |lorebook The Eldest: A Pilgrim's Tale/1/27/7
step
goto 46.66,45.72
step
goto 47.05,40.17
'Examine Modern Heretics |lorebook Modern Heretics/1/8/6
step
goto 54.92,44.60
'Examine Gifts of the Nereids |lorebook Gifts of the Nereids/1/27/9
step
goto 52.73,44.63
step
goto 55.80,47.28
|tip Climb to top of the tower.
'Use Skyshard
|tip Manually skip to the next step.
step
goto 63.17,45.16
|tip Climb down the steps and drop down the cliff carefully.
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
'Open Greenshade
|tip Manually skip to the next step.
step
goto greenshade_base 60.35,40.48
'Use Skyshard
|tip Manually skip to the next step.
step
goto 57.96,33.73
step
'Examine The Wood Elf Gourmet, Ch. 1 |lorebook The Wood Elf Gourmet, Ch. 1/1/27/10
step
goto 64.48,37.36
'Examine Vivec and Mephala |lorebook Vivec and Mephala/1/10/10
step
'Open Greenshade Map
'Travel to _Verrant Morass_
|tip Manually skip to the next step.
step
goto 46.01,29.85
'Examine Words of Clan Mother Ahnissi, Pt. 1 |lorebook Words of Clan Mother Ahnissi, Pt. 1/1/27/1
step
goto 45.09,28.59
'Examine The Doors of Oblivion, Part 1 |lorebook The Doors of Oblivion, Part 1/1/17/3
step
goto 40.24,24.87
step
goto 37.77,27.33
'Examine Spirit of the Daedra |lorebook Spirit of the Daedra/1/17/6
step
goto 36.72,29.78
'Examine Nine Commands of the Eight Divines |lorebook Nine Commands of the Eight Divines/1/10/8
step
goto 31.31,38.06
'Examine The Green Pact and the Dominion |lorebook The Green Pact and the Dominion/1/27/8
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
goto 31.30,40.32
'Open Greenshade
|tip Manually skip to the next step.
step
goto greenshade_base 32.69,37.41
'Use Seaside Sanctuary
'Travel to _Verrant Morass_
|tip Manually skip to the next step.
step
goto 33.82,23.69
'Examine Varieties of Daedra, Part 2 |lorebook Varieties of Daedra, Part 2/1/17/8
step
goto 34.32,18.88
'Examine Antecedents of Dwemer Law |lorebook Antecedents of Dwemer Law/1/12/8
step
goto 30.14,15.76
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
goto 63.63,35.41 |achieve 559
step
goto 33.90,24.83 |achieve 559
step
goto 30.86,59.93
kill Overseer Basri |achieve 559
step
'Open Malabal Tor
'Travel to _Velyn Harbor_
|tip Manually skip to the next step.
step
goto velynharbor_base 35.92,54.01
step
goto 75.88,39.51
|tip Upstairs in this building.
'Examine Flesh to Cut from Bone |lorebook Flesh to Cut from Bone/1/18/5
step
goto 79.77,49.65
step
goto 78.95,45.16
'Use Skyshard
|tip Manually skip to the next step.
step
goto malabaltor_base 20.84,53.42
'Examine The Woodsmer |lorebook The Woodsmer/1/21/2
step
goto 23.60,54.28
'Examine The Order of the Ancestor Moth |lorebook The Order of the Ancestor Moth/1/13/7
step
goto 23.10,52.00
step
goto 21.67,48.88
step
goto 21.56,46.07
'Examine Valenwood: A Study |lorebook Valenwood: A Study/1/21/4
step
goto 21.37,45.12
'Use Skyshard
|tip Manually skip to the next step.
step
'Open Malabal Tor Map
'Travel to _Ilayas Ruins_
|tip Manually skip to the next step.
step
goto 27.10,47.30
step
goto 29.50,41.73
step
goto 34.86,41.47
'Examine Pirates of the Abecean |lorebook Pirates of the Abecean/1/21/6
step
goto 35.06,41.56
'Open Dead Man's Drop
|tip Manually skip to the next step.
step
goto deadmansdrop_base 66.38,19.46
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
'Travel to _Ilayas Ruins_
|tip Manually skip to the next step.
step
goto malabaltor_base 19.33,55.81
step
goto 21.79,58.64
'Examine An Accounting of the Elder Scrolls |lorebook An Accounting of the Elder Scrolls/1/13/1
step
goto 34.18,59.34
'Use Skyshard
|tip Manually skip to the next step.
step
goto 32.82,59.40
step
goto 33.42,59.86
'Examine Opusculus Lamae Bal ta Mezzamortie |lorebook Opusculus Lamae Bal ta Mezzamortie/1/8/7
step
goto 31.27,60.19
'Examine The Cleansing of the Fane |lorebook The Cleansing of the Fane/1/13/4
step
goto 37.01,58.21
step
goto 38.10,62.34
|tip Drop down carefully.
'Examine Ancient Scrolls of the Dwemer I-B |lorebook Ancient Scrolls of the Dwemer I-B/1/12/10
step
goto 37.93,62.43
'Open Tomb of the Apostates
|tip Manually skip to the next step.
step
goto tomboftheapostates_base 33.28,84.00 |achieve 297
step
goto 68.83,83.07 |achieve 297
step
goto 62.34,58.82
kill Gwaeregil |achieve 297
step
goto 54.02,16.83
'Use Skyshard
|tip Manually skip to the next step.
step
'Open Malabal Tor Map
'Travel to _Dra'bul_
|tip Manually skip to the next step.
step
goto 35.82,55.54
'Examine The Cantatas of Vivec |lorebook The Cantatas of Vivec/1/18/3
step
goto 37.63,57.99
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
goto 34.44,24.96
step
goto 26.10,43.18
step
goto 45.52,43.30
step
goto 66.50,44.27
'Use Daedric Bindings
kill Oghezai |achieve 298
step
goto 46.64,53.25
|tip Drop down.
'Open Malabal Tor
|tip Manually skip to the next step.
step
goto 50.70,50.37
|tip Drop down carefully.
'Use Skyshard
|tip Manually skip to the next step.
step
'Open Malabal Tor Map
'Travel to _Vulkwasten_
|tip Manually skip to the next step.
step
goto vulkwasten_base 55.36,63.89
step
goto 60.89,58.91
'Examine The Humor of Wood Elves |lorebook The Humor of Wood Elves/1/21/5
step
goto 45.63,38.07
step
goto 46.32,25.38
'Use Skyshard
|tip Manually skip to the next step.
step
goto 43.52,21.26
|tip Drop down carefully.
'Examine The Amulet of Kings |lorebook The Amulet of Kings/1/13/3
step
goto malabaltor_base 50.19,39.79
'Examine Ayleid Cities of Valenwood |lorebook Ayleid Cities of Valenwood/1/21/10
step
goto 47.70,36.71
'Examine Ancient Scrolls of the Dwemer VIII |lorebook Ancient Scrolls of the Dwemer VIII/1/12/12
step
'Open Malabal Tor Map
'Travel to _Vulkwasten_
|tip Manually skip to the next step.
step
goto malabaltor_base 58.23,55.47
step
goto 56.62,64.30
step 
goto 58.20,62.41
'Examine The Book of Dawn and Dusk |lorebook The Book of Dawn and Dusk/1/18/2
step
goto 57.20,70.34
'Examine The Red Paint |lorebook The Red Paint/1/21/9
step
goto 54.90,67.33
step
goto 49.14,66.80
|tip Drop down carefully.
'Use Skyshard
|tip Manually skip to the next step.
step
'Open Malabal Tor Map
'Travel to _Bloodtoil_
|tip Manually skip to the next step.
step
goto 58.12,66.96
step
goto 59.77,72.39
step
goto 62.91,79.22
step
goto 66.39,78.89
'Examine The Battle of Glenumbria Moors |lorebook The Battle of Glenumbria Moors/1/18/1
step
goto 62.52,82.70
'Examine The Last King of the Ayleids |lorebook The Last King of the Ayleids/1/13/6
step
goto 62.56,82.78
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
'Travel to _Abamath_
|tip Manually skip to the next step.
step
goto malabaltor_base 63.12,79.20
step
goto 57.96,79.32
'Examine Tamrielic Artifacts, Part One |lorebook Tamrielic Artifacts, Part One/1/13/8
step
goto 64.59,79.57
step
goto 66.79,67.75
step
goto 67.88,64.88
'Examine The Exclusionary Mandates |lorebook The Exclusionary Mandates/1/13/5
step
goto 72.24,62.83
step
goto 75.36,58.05
step
goto 77.49,57.60
'Examine Ode to the Tundrastriders |lorebook Ode to the Tundrastriders/1/18/6
step
goto 78.81,57.16
'Use Skyshard
|tip Manually skip to the next step.
step
goto 78.27,52.39
'Examine Green Lady, My Lady |lorebook Green Lady, My Lady/1/21/3
step
goto 72.84,49.34
'Examine The Voice of the People |lorebook The Voice of the People/1/21/1
step
goto 70.79,49.24
'Open Roots of Silvenar
|tip Manually skip to the next step.
step
goto rootsofsilvenar_base 25.13,64.34
step
goto 25.13,64.34
'Examine Tamrielic Artifacts Part Three |lorebook Tamrielic Artifacts Part Three/1/13/10
step
goto 53.67,62.13
step
goto 57.15,40.29
'Use Skyshard
|tip Manually skip to the next step.
step
goto 86.49,47.66 |achieve 282
step
goto 88.01,57.13
kill Adavos Dren |achieve 282
step
'Open Malabal Tor Map
'Travel to _Baandari TradingPost_
|tip Manually skip to the next step.
step
goto malabaltor_base 84.95,25.67
step
goto 80.83,23.33
'Examing The Wedding Feast: A Memoir |lorebook The Wedding Feast: A Memoir/1/21/7
step
goto 76.51,29.47
step
goto baandaritradingpost_base 18.46,25.70
'Open Black Vine Ruins
|tip Manually skip to the next step.
step
goto blackvineruins_base 27.49,7.73
step
goto 27.82,38.78
step
goto 15.69,48.36
'Examine The Adabal-a |lorebook The Adabal-a/1/13/2
step
goto 37.89,87.12
'Use Skyshard
|tip Manually skip to the next step.
step
goto 75.29,66.80
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
'Open Black Vine Ruins
|tip Manually skip to the next step.
step
goto 27.59,8.92
step
goto 9.22,7.33
'Open Malabal Tor
|tip Manually skip to the next step.
step
goto malabaltor_base 77.39,34.08
step
goto 76.52,28.92
step
goto 74.41,25.31
step
goto 67.97,23.89
step
goto 64.71,24.20
'Use Skyshard
|tip Manually skip to the next step.
step
goto 64.17,23.46
'Examine The Totems of Hircine |lorebook The Totems of Hircine/1/8/8
step
goto 66.58,25.91
step
goto 64.78,27.98
|tip On the ledge to your left.
'Examine The Five Far Stars |lorebook The Five Far Stars/1/18/4
step
'Open Malabal Tor Map
'Travel to _Vulkwasten_
|tip Manually skip to the next step.
step
goto 58.24,55.18
step
goto 62.67,48.85
step
goto 64.31,44.37
'Examine Tamrielic Artifacts, Part Two |lorebook Tamrielic Artifacts, Part Two/1/13/9
step
goto 64.29,39.46
step
goto 62.15,34.12
step
goto 64.48,31.19
|tip Climb hill.
'Examine Guylaine's Dwemer Architecture |lorebook Guylaine's Dwemer Architecture/1/12/11
step
'Open Reaper's March
'Travel to _Vinedusk_
|tip Manually skip to the next step.
step
goto reapersmarch_base 15.20,42.69
'Examine Ancient Scrolls of the Dwemer IV |lorebook Ancient Scrolls of the Dwemer IV/1/12/16
step
goto 20.26,41.41
step
goto 23.55,34.10
'Examine Words of the Wind |lorebook Words of the Wind/1/18/10
step
goto 24.85,27.72
step
goto 27.57,24.67
'Open Reaper's March
|tip Manually skip to the next step.
step
goto 33.57,20.63
'Examine Proper-Life: Three Chants |lorebook Proper-Life: Three Chants/1/18/7
step
goto 32.32,20.08
step
goto 35.26,13.45
step
goto 34.31,14.99
'Use Skyshard
|tip Manually skip to the next step.
step
goto 36.79,15.02
step
goto 37.84,19.89
'Use Skyshard
|tip Manually skip to the next step.
step
goto 40.68,19.21
'Examine Dwemer Inquiries Volume I |lorebook Dwemer Inquiries Volume I/1/12/13
step
goto 43.28,17.60
step
goto 46.54,12.89
'Examine Song of the Askelde Men |lorebook Song of the Askelde Men/1/18/8
step
goto 46.05,10.72
'Examine The Moon Cats and their Dance |lorebook The Moon Cats and their Dance/1/28/1
step
'Open Reaper's March
'Travel to _Arenthia_
|tip Manually skip to the next step.
step
goto arenthia_base 43.17,55.23
'Open Tower District
step
goto 42.99,78.25
'Examine The Warrior's Charge |lorebook The Warrior's Charge/1/18/9
step
goto 43.17,55.23
'Open Arenthia
step
goto reapersmarch_base 49.32,16.79
step
goto 46.30,27.36
'Examine Dwemer Inquiries Volume II |lorebook Dwemer Inquiries Volume II/1/12/14
step
goto 48.75,25.75
step
goto 54.17,30.06
'Open Kuna's Delve
|tip Manually skip to the next step.
step
goto kunasdelve_base 55.64,64.28
step
goto 65.48,65.24
step
goto 74.40,43.49
'Use Skyshard
|tip Manually skip to the next step.
step
goto 63.23,34.39 |achieve 453
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
goto reapersmarch_base 46.13,33.54
'Examine Dwemer Inquiries Volume III |lorebook Dwemer Inquiries Volume III/1/12/15
step
goto 45.24,30.26
step
goto 42.95,33.37
'Use Skyshard
|tip Manually skip to the next step.
step
goto 37.69,36.44
step
goto 31.88,41.01
step
goto 32.42,42.76
'Examine The Homilies of Blessed Almalexia |lorebook The Homilies of Blessed Almalexia/1/14/1
step
goto 33.64,41.52
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
goto 78.49,43.65
step
goto 66.33,43.62
'Open Upper Vault
|tip Manually skip to the next step.
step
goto 24.60,35.26
step
goto 21.65,20.55
kill Worm Eremite |achieve 454
step
goto 6.68,36.79
'Open Reaper's March
|tip Manually skip to the next step.
step
goto reapersmarch_base 35.58,44.67
step
goto 32.76,47.72
step
goto 34.90,49.31
'Examine The Legendary Scourge |lorebook The Legendary Scourge/1/14/2
step
goto 34.97,53.87
step
goto 33.40,53.83
|tip Drop down carefully
'Use Skyshard
|tip Manually skip to the next step.
step
'Open Reapers March Map
'Travel to _Rawl'kha_
|tip Manually skip to the next step.
step
goto 55.14,57.49
step
goto 55.01,61.10
'Examine The Red Book of Riddles |lorebook The Red Book of Riddles/1/14/7
step
goto 41.44,64.53
|tip Climb the rocks.
'Examine 16 Accords of Madness, Vol. VI |lorebook 16 Accords of Madness, Vol. VI/1/14/8
step
goto 39.64,64.49
|tip Finishing climbing the rocks to the top.
'Use Skyshard
|tip Manually skip to the next step.
step
goto 34.48,60.69
|tip Drop down carefully.
'Examine Crow and Raven: Three Short Fables |lorebook Crow and Raven: Three Short Fables/1/14/9
step
goto 31.45,59.26
'Examine The Lusty Argonian Maid, Volume 1 |lorebook The Lusty Argonian Maid, Volume 1/1/14/3
step
goto 28.11,62.44
'Use Skyshard
|tip Manually skip to the next step.
step
goto 25.71,60.54
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
goto 40.40,19.17
'Open Reaper's March
step
goto reapersmarch_base 25.79,60.73
step
goto 23.40,64.89
step
goto 24.13,65.99
'Examine The Lusty Argonian Maid, Volume 2 |lorebook The Lusty Argonian Maid, Volume 2/1/14/4
step
goto 27.59,61.91
step
goto 31.74,64.34
step
goto 29.58,73.70
'Examine Myths of Sheogorath, Volume 2 |lorebook Myths of Sheogorath, Volume 2/1/14/6
step
goto 30.54,80.74
'Examine Myths of Sheogorath, Volume 1 |lorebook Myths of Sheogorath, Volume 1/1/14/5
step
goto 33.44,74.86
step
goto 44.33,72.47
'Examine Wabbajack |lorebook Wabbajack/1/14/10
step
goto 50.44,75.43
'Open Weeping Wind Cave
|tip Manually skip to the next step.
step
goto weepingwindcave_base 61.67,59.08
step
goto 37.63,83.08
'Use Skyshard
|tip Manually skip to the next step.
step
goto 62.77,51.50
step
goto 53.42,11.67 |achieve 455
step
goto 64.49,31.55
kill Nimriian |achieve 455
step
'Open Reaper's March Map
'Travel to _Willowgrove_
|tip Manually skip to the next step.
step
goto reapersmarch_base 53.89,59.34
step
goto 54.53,50.59
'Examine Master Zoaraym's Tale, Part 2 |lorebook Master Zoaraym's Tale, Part 2/1/28/9
step
goto 58.97,49.95
'Examine Cohort Briefing: Arenthia |lorebook Cohort Briefing: Arenthia/1/28/10
step
goto 56.88,40.80
'Examine Moon-Sugar for Glossy Fur? Yes! |lorebook Moon-Sugar for Glossy Fur? Yes!/1/28/7
step
goto 51.27,38.52
step
goto 50.84,36.50
'Use Skyshard
|tip Manually skip to the next step.
step
goto 52.70,37.00
step
goto 52.75,38.39
step
goto 57.18,38.22
'Examine Master Zoaraym's Tale, Part 1 |lorebook Master Zoaraym's Tale, Part 1/1/28/8
step
goto 59.00,35.77
'Examine The Eagle and the Cat |lorebook The Eagle and the Cat/1/28/5
step
goto 63.34,39.53
'Open Jode's Light
|tip Manually skip to the next step.
step
goto jodeslight_base 15.11,26.38
'Use Skyshard
|tip Manually skip to the next step.
step
goto 16.40,62.71 |achieve 458
step
goto 51.97,58.77
kill Yenadar |achieve 458
step
'Open Reaper's March Map
'Travel to _Dune_
|tip Manually skip to the next step.
step
goto dune_base 32.81,22.76
'Examine Elven Eyes, Elven Spies |lorebook Elven Eyes, Elven Spies/1/28/6
step
goto 47.96,38.15
step
goto 60.03,33.05
|tip Climb the rock.
'Use Skyshard
|tip Manually skip to the next step.
step
goto 64.13,23.15
'Open Walker's Stay
|tip Manually skip to the next step.
step
goto 64.41,23.04
|tip Go upstairs.
'Examine A Looter's Paradise |lorebook A Looter's Paradise/1/28/4
step
'Open Reaper's March
'Travel to _Fort Sphinxmoth_
|tip Manually skip to the next step.
step
goto reapersmarch_base 75.36,20.84 |lorebook Yours for the Taking!/1/28/3
step
goto 77.11,21.72
'Examine Yours for the Taking! |lorebook Yours for the Taking!/1/28/3
step
goto 75.36,20.84
step
goto 76.80,18.70
'Examine Litter-Mates of Darkness |lorebook Litter-Mates of Darkness/1/28/2
step
goto 75.22,18.95
step
goto 76.79,16.78
'Use Skyshard
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
goto 41.58,72.73 |tip Drop down |achieve 622
step
goto 81.72,70.11 |achieve 622
step
goto 76.07,15.93
kill Ravo Peltrasius |achieve 622
step
'Guide Complete Pick your next guide.
]])

ZGV:RegisterGuide("Extras\\Extras\\Skyshards ,Lorebooks, and Delves\\Daggerfall Covenant",[[
loadingimage loadscreen_wgt_throneroom_01.dds
description Coming Soon.
step
'Comming Soon
]])

ZGV:RegisterGuide("Extras\\Extras\\Skyshards ,Lorebooks, and Delves\\Ebonheart Pact",[[
loadingimage loadscreen_tribunal_01.dds
description Coming Soon.
step
'Comming Soon
]])

ZGV:RegisterGuide("Extras\\Extras\\Skyshards ,Lorebooks, and Delves\\Interlude I",[[
loadingimage loadscreen_wrothgarruins.dds
description Coming Soon.
step
'Comming Soon
]])

ZGV:RegisterGuide("Extras\\Extras\\Skyshards ,Lorebooks, and Delves\\Daedric Wars",[[
loadingimage loadscreen_alinorroyalpalace_01.dds
description Coming Soon.
step
'Comming Soon
]])

ZGV:RegisterGuide("Extras\\Extras\\Skyshards ,Lorebooks, and Delves\\Murkmire",[[
loadingimage loadscreen_murkmire_01.dds
description Coming Soon.
step
'Comming Soon
]])

ZGV:RegisterGuide("Extras\\Extras\\Skyshards ,Lorebooks, and Delves\\Season of the Dragon",[[
loadingimage loadscreen_dragonhold_island_01.dds
description Coming Soon.
step
'Comming Soon
]])

ZGV:RegisterGuide("Extras\\Extras\\Skyshards ,Lorebooks, and Delves\\The Dark Heart of Skyrim",[[
loadingimage loadscreen_darkstorm_capper2_01.dds
description Coming Soon.
step
'Comming Soon
]])

ZGV:RegisterGuide("Extras\\Extras\\Skyshards ,Lorebooks, and Delves\\Gates of Oblivion",[[
loadingimage loadscreen_fort_sundercliff_01.dds
description Coming Soon.
step
'Comming Soon
]])

ZGV:RegisterGuide("Extras\\Extras\\Skyshards ,Lorebooks, and Delves\\Legacy of the Breton",[[
loadingimage loadscreen_hi_allflagsisland_01.dds
description Coming Soon.
step
'Comming Soon
]])