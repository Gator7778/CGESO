local CGV = _G.CGV
CGV.GuideMenuTier = "TAM"

CGV:RegisterGuide("Extras\\Extras\\Companions\\Bastian Hallix",[[
loadingimage loadscreen_u30_blackwood_zone_01.dds
description Bastian Hallix Unlock quest and Rapport Quests.
step
'Open _Blackwood_ Map
'Travel to _Leyawiin Outskirts_ |q Competition and Contracts |future
|tip Manually skip to the next step.
step
goto u30_leyawiincity_base 72.11,28.52 |q Competition and Contracts |future
step
goto blackwood_base 30.02,54.17 |q Competition and Contracts |future
step
goto 39.08,55.41 |q Competition and Contracts |future
step
goto 36.99,59.76 |q Competition and Contracts |future
step
goto 37.38,71.47
talk Zeechis
accept Competition and Contracts
step
goto 39.76,74.80
'Go to _Deepscorn Hollow_ |q Competition and Contracts/Go to Deepscorn Hollow
step
goto 39.77,74.78
talk Bastian Hallix |q Competition and Contracts/Talk to Bastian Hallix
step
goto 39.25,75.43
'Examine _Tenarei's Contract_ |q Competition and Contracts/Search the Area
step
goto 39.77,74.78
talk Bastian Hallix |q Competition and Contracts/Talk to Bastian Hallix
step
goto 39.81,75.40
'Open _Deepscorn Hollow_ |q Competition and Contracts/Enter Deepscorn Hollow |future
|tip Manually skip to the next step.
step
goto u30_deepscorn_hollow_base 36.16,39.86
'Open _Ruined Shrine_ |q Competition and Contracts/Explore Deepscorn Hollow
|tip Manually skip to the next step.
step
goto 31.52,48.57 |q Competition and Contracts/Explore Deepscorn Hollow
step
goto 26.76,46.31
'Open _Deepscorn Cavern_ |q Competition and Contracts/Explore Deepscorn Hollow
|tip Manually skip to the next step.
step
goto 25.05,12.90
'Explore _Deepscorn Hollow_ |q Competition and Contracts/Explore Deepscorn Hollow
step
goto 25.05,12.90 
'Unlock _Cell Door_ |q Competition and Contracts/Free Captives
step
goto 25.72,13.42
talk Thadarond |q Competition and Contracts/Talk to Thadarond
step
goto 26.31,13.32
talk Bastian Hallix |q Competition and Contracts/Talk to Bastian Hallix
step
goto 45.35,18.91 |q Competition and Contracts/Continue Exploring Deepscorn Hollow
step
goto 61.45,25.98 |q Competition and Contracts/Continue Exploring Deepscorn Hollow
step
goto 48.70,35.31
'Continue _Exploring Deepscorn Hollow_ |q Competition and Contracts/Continue Exploring Deepscorn Hollow
step
goto 48.70,35.31
'Open _Abandoned Excavation_ |q Competition and Contracts/Follow the Cultist
step
goto 48.40,39.66
talk Fluvius Salva |q Competition and Contracts/Talk to the Cultist
step
goto 48.09,39.79
talk Bastian Hallix |q Competition and Contracts/Talk to Bastian Hallix
step
goto 53.95,44.33
'Open _Deepscorn Hollow_ |q Competition and Contracts/Find Tenarei Vels
|tip Manually skip to the next step.
step
goto 63.56,56.44
'Find _Tenarei Vels_ |q Competition and Contracts/Find Tenarei Vels
step
goto 63.36,56.44
'Break _Crystal Fang_ |q Competition and Contracts/Ritual Orb 1
step
goto 60.29,57.56
'Break _Crystal Fang_ |q Competition and Contracts/Ritual Orb 2
step
goto 60.34,60.90
'Break _Crystal Fang_ |q Competition and Contracts/Free Tenarei Vels
step
goto 52.87,56.77
'Open _Deepscorn Caves_ |q Competition and Contracts/Talk to Tenarei Vels
|tip Manually skip to the next step.
step
goto 45.64,56.78
talk Tenarei Vels |q Competition and Contracts/Talk to Tenarei Vels
step
goto 46.81,70.35 |q Competition and Contracts/Continue to Explore Deepscorn Hollow
step
goto 19.20,62.12
'Continue to _Explore Deepscorn Hollow_ |q Competition and Contracts/Continue to Explore Deepscorn Hollow
step
goto 15.20,62.04
talk Greywyn Blenwyth |q Competition and Contracts/Talk to the Imprisoned Vampire
step
goto 21.09,64.52
'Destroy _Crate_ |q Competition and Contracts/Find the Switch for a Hidden Door
step
goto 21.09,64.52
'Use _Switch_ |q Competition and Contracts/Open the Hidden Passage
step
goto 21.42,65.71
'Open _Inner Sanctum Passage_ |q Competition and Contracts/Go to the Inner Sanctum
|tip Manually skip to the next step.
step
goto 28.92,85.24
'Go to _Inner Sanctum_ |q Competition and Contracts/Go to the Inner Sanctum
step
goto 28.92,85.24
talk Tenarei Vels |q Competition and Contracts/Talk to Tenarei Vels
step
goto 28.88,85.15
talk Bastian Hallix |q Competition and Contracts/Talk to Bastian Hallix
step
goto 29.92,85.34
'Open _Hall of Sithis_ |q Competition and Contracts/Enter the Hall of Sithis
step
goto 48.47,85.41
'Open _Fane of Scorn_ |q Competition and Contracts/Reach the Fane of Scorn
|tip Manually skip to the next step.
step
goto 65.11,80.17
'Reach _Fane of Scorn_ |q Competition and Contracts/Reach the Fane of Scorn
step
goto 65.11,80.17
kill the Daughter of Sithis |q Competition and Contracts/Kill the Daughter of Sithis
step
goto 70.91,80.47
'Open _Private Chamber_ |q Competition and Contracts/Talk to Quistley Silvelle
|tip Manually skip to the next step.
step
goto 81.85,80.52
talk Quistley Silvelle |q Competition and Contracts/Talk to Quistley Silvelle
step
goto 82.50,80.80
talk Tenarei Vels |q Competition and Contracts/Talk to Tenarei Vels
step
goto 81.93,80.96
talk Bastian Hallix |q Competition and Contracts/Talk to Bastian Hallix
step
talk Bastian Hallix
turnin Competition and Contracts
step
'_Next to you_
|tip Reach Friendly rapport with Bastian Hallix.
talk Bastian Hallix
accept Things Lost, Things Found
step
'Open Glenumbra Map
'Travel to _Daggerfall_ in Glenumbra |q Things Lost, Things Found/Meet Quistley Silvelle in Daggerfall
|tip Manually skip to the next step.
step
goto daggerfall_base 51.76,26.03
'Open Rosy Lion Inn |q Things Lost, Things Found/Meet Quistley Silvelle in Daggerfall
|tip Manually skip to the next step.
step
goto 48.61,26.23
|tip Go upstairs.
talk Quistley Silvelle |q Things Lost, Things Found/Talk to Quistley Silvelle |future
step
goto 64.80,39.74 |q Things Lost, Things Found/Go to Illessan Tower |tip Leave Rosy Lion Inn
step
goto glenumbra_base 34.81,72.59
talk Bastian Hallix |q Things Lost, Things Found/Talk to Bastian Hallix |future
step
goto 34.81,72.59
'Open Illessan Tower |q Things Lost, Things Found/Find the Silvelle Ring |future
|tip Manually skip to the next step.
step
goto ilessantower_base 11.64,80.04 |q Things Lost, Things Found/Find the Silvelle Ring |future
step
goto 67.75,80.09 |q Things Lost, Things Found/Find the Silvelle Ring |future
step
goto 60.38,33.31
'Search Coffer |q Things Lost, Things Found/Find the Silvelle Ring |future
|tip Manually skip to the next step.
step
'Open Glenumbra Map
'Travel to _Baelborne Rock_ |q Things Lost, Things Found/Talk to Quistley Silvelle |future
|tip Manually skip to the next step.
step
goto glenumbra_base 35.33,74.21
talk Quistley Silvelle |q Things Lost, Things Found/Talk to Quistley Silvelle |future
step
goto 35.35,74.24
'Examine Letter from Inalieth |q Things Lost, Things Found/Read the Undelivered Letter
step
goto 35.37,74.11
talk Bastian Hallix |q Things Lost, Things Found/Talk to Bastian Hallix
step
goto 37.40,73.03
'Use Baelbourne Rock
'Travel to _Redfur Trading Post_ in Grahtwood |q Things Lost, Things Found/Go to the Hearty Hoarvor Inn in Grahtwood |future
|tip Manually skip to the next step.
step
goto redfurtradingpost_base 66.64,48.00
talk Vayzah |q Things Lost, Things Found/Ask About Inalieth |future
step
goto grahtwood_base 32.18,27.32
talk Inalieth |q Things Lost, Things Found/Talk to Inalieth |future
step
goto 32.07,27.31
talk Bastian Hallix
turnin Things Lost, Things Found
step
'_Next to you_
|tip Reach Close rapport with Bastian Hallix.
talk Bastian Hallix
accept Family Secrets
step
'Open Stormhaven Map
'Travel to _Wayrest_ |q Family Secrets/Find Count Elmonde Auzin in Wayrest
|tip Manually skip to the next step.
step
goto wayrest_base 27.61,38.25 |q Family Secrets/Find Count Elmonde Auzin in Wayrest
step
goto 45.57,17.22
'Open Cloudy Dregs Inn |q Family Secrets/Find Count Elmonde Auzin in Wayrest
|tip Manually skip to the next step.
step
goto 45.96,15.12
talk Count Elmonde Auzin |q Family Secrets/Talk to Count Elmonde Auzin |future
step
goto 45.96,15.12
|tip Watch the dialogue.
talk Bastian Hallix |q Family Secrets/Talk to Bastian Hallix
step
goto 27.61,38.25 |q Family Secrets/Find the Slaver Hideout
step
goto 39.90,51.08
|tip Leave the Inn.
'Use Wayrest Wayshrine
'Travel to _Bonesnap Ruins_ |q Family Secrets/Find the Slaver Hideout
|tip Manually skip to the next step.
step
goto stormhaven_base 23.64,49.43
'Open Koeglin Mine |q Family Secrets/Rescue Countess Clairene Auzin |future
|tip Manually skip to the next step.
step
goto koeglinmine_base 69.89,61.85 |q Family Secrets/Rescue Countess Clairene Auzin |future
step
goto 75.03,32.92 |q Family Secrets/Rescue Countess Clairene Auzin |future
step
goto 55.15,21.39
'Untie Bonds on Countess Clairene Auzin |q Family Secrets/Rescue Countess Clairene Auzin |future
step
goto 48.46,44.31
'Open Koeglin Mine |q Family Secrets/Escort Countess Clairene Auzin out of the Mines
|tip Manually skip to the next step.
step
goto 46.16,67.66 |q Family Secrets/Escort Countess Clairene Auzin out of the Mines
step
goto 22.47,89.96
'Open Stormhaven |q Family Secrets/Escort Countess Clairene Auzin out of the Mines |future
|tip Manually skip to the next step.
step
goto stormhaven_base 23.04,50.20
talk Countess Clairene Auzin |q Family Secrets/Talk to Countess Clairene Auzin |future
|tip Manually skip to the next step.
step
goto 23.04,50.24
'Listen to Bastian Hallix and Clairene Auzin |q Family Secrets/Listen to Bastian Hallix and Clairene Auzin
step
goto 23.04,50.24
talk Bastian Hallix
turnin Family Secrets
]])

CGV:RegisterGuide("Extras\\Extras\\Companions\\Ember",[[
loadingimage loadscreen_hi_systres_zone_01.dds
description Ember Unlock quest and Rapport Quests.
step
'Open _High Isle and Amenos_ Map
'Travel to _Westbay_ |q Tower Full of Trouble |future
|tip Manually skip to the next step.
step
goto u34_gonfalonbaycity_base 5.77,37.85 |q Tower Full of Trouble |future
step
goto u34_systreszone_base 50.13,78.92 |q Tower Full of Trouble |future
step
goto 52.46,73.25
talk Ladlow Meant
accept Tower Full of Trouble
step
goto 53.83,71.96
talk Ember |q Tower Full of Trouble/Talk to Ember |future
step
goto 56.29,70.00
'Place _Protection Wardstone_ |q Tower Full of Trouble/Restore the Meadow Ward
step
goto 51.77,66.87
'Place _Protection Wardstone_ |q Tower Full of Trouble/Restore the Glade Ward
step
goto 50.40,68.53
'Open _Tor Draioch Cave_ |q Tower Full of Trouble/Restore the Cave Ward
|tip Manually skip to the next step.
step
goto 48.56,68.57
'Place _Protection Wardstone_ |q Tower Full of Trouble/Restore the Cave Ward
step
goto 50.21,68.56
'Open _Tor Draioch_ |q Tower Full of Trouble/Talk to Ember
|tip Manually skip to the next step.
step
goto 50.48,68.54
talk Ember |q Tower Full of Trouble/Talk to Ember
step
goto 53.04,69.74
'Open _Tor Draioch_ |q Tower Full of Trouble/Find Information in the Tower
|tip Manually skip to the next step.
step
goto 52.87,69.81
|tip Go upstairs.
'Examine _Sorrows of the Wind_ |q Tower Full of Trouble/Find Information in the Tower
step
goto 52.90,69.68
|tip Go downstairs.
talk Ember |q Tower Full of Trouble/Talk to Ember
step
goto 52.99,69.76
'Open _High Isle_ |q Tower Full of Trouble/Take Ember's Traps
|tip Manually skip to the next step.
step
goto 53.45,69.40
'Take _Ember's Pack_ |q Tower Full of Trouble/Take Ember's Traps
step
goto 54.12,70.14
'Place _Mote Trap_ |q Tower Full of Trouble/.*Set the Mote Traps.* |count 1
step
goto 52.78,70.67
'Place _Mote Trap_ |q Tower Full of Trouble/.*Set the Mote Traps.* |count 2
step
goto 51.32,69.16
'Place _Mote Trap_ |q Tower Full of Trouble/.*Set the Mote Traps.* |count 3
step
goto 52.76,68.71
'Place _Mote Trap_ |q Tower Full of Trouble/.*Set the Mote Traps.* |count 4
step
goto 55.03,69.25
'Meet _Ember at the Livestock Shed_ |q Tower Full of Trouble/Meet Ember at the Livestock Shed
step
goto 55.03,69.25
talk Ember |q Tower Full of Trouble/Talk to Ember
step
goto 55.02,67.99
|tip Run through the two Enchanted Cows.
'Use _Spoon of Undo on Enchanted Cow_ |q Tower Full of Trouble/.*Restore the Livestock.* |count 1
step
goto 54.61,68.95
'Use _Spoon of Undo on Enchanted Cow_ |q Tower Full of Trouble/.*Restore the Livestock.* |count 2
step
goto 54.42,69.74
'Use _Spoon of Undo on Enchanted Cow_ |q Tower Full of Trouble/.*Restore the Livestock.* |count 3
step
goto 53.76,70.92
'Use _Spoon of Undo on Enchanted Cow_ |q Tower Full of Trouble/.*Restore the Livestock.* |count 4
step
goto 52.33,67.79 |q Tower Full of Trouble/Find and Restore Huldressa
step
goto 52.96,68.29
|tip Find Huldressa hes a guar in a pond in front of you in the pond follow her around the pond.
'Use _Spoon of Undo on Huldressa_ |q Tower Full of Trouble/Find and Restore Huldressa
step
goto 53.04,69.74
'Open _Tor Draioch_ |q Tower Full of Trouble/Find Ember in the Tower
step
goto 52.86,69.66
talk Ember |q Tower Full of Trouble/Talk to Ember
step
goto 52.76,69.95
|tip Follow Ember downstairs or she will stop at the bottom of the staircase downstairs.
'Open _Arcane Library_ |q Tower Full of Trouble/Find The Mirrored Way
|tip Manually skip to the next step.
step
goto 52.06,70.88
'Examine _The Mirrored Way_ |q Tower Full of Trouble/Find The Mirrored Way
step
goto 52.70,70.10
'Open _Tor Draioch_ |q Tower Full of Trouble/Talk to Ember
|tip Manually skip to the next step.
step
goto 52.72,69.82
talk Ember |q Tower Full of Trouble/Talk to Ember
step
goto 52.99,69.77
|tip Go upstairs.
'Open _High Isle_ |q Tower Full of Trouble/Go to the Ritual Circle
|tip Manually skip to the next step.
step
goto 50.93,70.63 |q Tower Full of Trouble/Go to the Ritual Circle
step
goto 50.43,71.63
'Go to the _Ritual Circle_ |q Tower Full of Trouble/Go to the Ritual Circle
step
goto 50.40,71.84
'Ignite _Ritual Sconce_ |q Tower Full of Trouble/Help Ember at the Ritual Circle
|tip Manually skip to the next step.
step
goto 50.72,71.47
'Ignite _Ritual Sconce_ |q Tower Full of Trouble/Help Ember at the Ritual Circle
|tip Manually skip to the next step.
step
goto 51.16,71.36
|tip Watch dialogue.
'Ignite _Ritual Sconce_ |q Tower Full of Trouble/Help Ember at the Ritual Circle
step
goto 52.49,71.44
'Follow _Ember_ |q Tower Full of Trouble/Follow Ember
step
goto 53.24,69.77
'Return to _Tower_ |q Tower Full of Trouble/Return to the Tower
step
goto 53.24,69.77
talk Magister Irin |q Tower Full of Trouble/Talk to Magister Irin
step
goto 53.21,69.86
talk Ember
turnin Tower Full of Trouble
step
'_Next to you_
|tip Reach Friendly rapport with Ember.
talk Ember
accept Cold Trail
step
'Open Auridon Map
'Travel to _Skywatch_ |q Cold Trail/Find Brisha In Skywatch
|tip Manually skip to the next step. 
step
goto skywatch_base 41.22,47.67
'Find Brisha In Skywatch |q Cold Trail/Find Brisha In Skywatch
step
goto 41.22,47.67
talk Brisha |q Cold Trail/Talk to Brisha
step
goto 41.22,47.67
talk Ember |q Cold Trail/Talk to Ember
step
goto 18.26,42.13
'Use Skywatch Wayshrine
'Travel to _Sadrith Mora_ in Vvardenfell |q Cold Trail/Go to Sadrith Mora's Gateway Inn
|tip Manually skip to the next step.
step
goto sadrithmora_base 67.43,50.00
'Open Gateway Inn |q Cold Trail/Go to Sadrith Mora's Gateway Inn
step
goto 70.09,50.84
talk Osithos Morelo |q Cold Trail/Ask About Jhaka at the Gateway Inn
step
goto 31.77,54.84
|tip Leave Gateway Inn.
'Go to Tel Naga |q Cold Trail/Go to Tel Naga
step
goto 31.77,54.84
talk Ember |q Cold Trail/Talk to Ember
step
goto 37.01,52.97
'Search Varvisi's Jewelry Pack |q Cold Trail/Distract Varvisi Uleni
step
goto 27.28,57.70
talk Ember |q Cold Trail/Talk to Ember
step
goto 39.68,66.03 |q Cold Trail/Talk to Osithos Morelo
step
goto 67.28,50.20
'Open Gateway Inn |q Cold Trail/Talk to Osithos Morelo
|tip Manually skip to the next step.
step
goto 70.10,50.83
talk Osithos Morelo |q Cold Trail/Talk to Osithos Morelo
step
goto 29.37,57.66
|tip Leave Gateway Inn.
'Use Sadrith Mora Wayshrine
'Travel to _Tel Mora_ |q Cold Trail/Go to Pulk
|tip Manually skip to the next step.
step
goto vvardenfell_base 67.14,42.01
'Go to Pulk |q Cold Trail/Go to Pulk
step
goto 67.14,42.01
talk Ember |q Cold Trail/Talk to Ember |future
step
goto 67.14,42.01
'Open Pulk |q Cold Trail/Find Jhaka |future
|tip Manually skip to the next step.
step
goto pulkupper_base 49.61,47.18 |q Cold Trail/Find Jhaka |future
step
goto 62.84,48.93 |q Cold Trail/Find Jhaka |future
step
goto 56.61,69.95 |q Cold Trail/Find Jhaka |future
step
goto pulklower_base 33.75,75.68 |q Cold Trail/Find Jhaka |future
step
goto 53.99,80.25 |q Cold Trail/Find Jhaka |future
step
goto 73.74,44.84
'Unlock Cage |q Cold Trail/Free Jhaka |future
step
goto 73.74,44.84
talk Jhaka |q Cold Trail/Talk to Jhaka
step
goto 53.11,81.23 |q Cold Trail/Escort Jhaka to Safety
step
goto 29.96,75.97 |q Cold Trail/Escort Jhaka to Safety
step
goto 56.23,69.94 |q Cold Trail/Escort Jhaka to Safety
step
goto 62.06,49.22 |q Cold Trail/Escort Jhaka to Safety
step
goto 41.83,34.34 |q Cold Trail/Escort Jhaka to Safety
step
goto 39.59,18.77 |q Cold Trail/Escort Jhaka to Safety
step
goto 24.12,14.01
'Open Vvardenfell |q Cold Trail/Escort Jhaka to Safety |future
|tip Manually skip to the next step
step
goto Vvardenfell 66.74,41.69
talk Jhaka |q Cold Trail/Talk to Jhaka |future
step
goto 66.79,41.73
talk Ember
turnin Cold Trail
step
'_Next to you_
|tip Reach Close rapport with Ember.
talk Ember
accept Cold Blood, Old Pain
step
'Open Greenshade Map
'Travel to _Marbruk_ |q Cold Blood, Old Pain/Find Jhaka in Marbruk
|tip Manually skip to the next step.
step
goto marbruk_base 62.42,39.33 |q Cold Blood, Old Pain/Find Jhaka in Marbruk
step
goto 58.58,28.80
'Find Jhaka in Marbruk |q Cold Blood, Old Pain/Find Jhaka in Marbruk
step
goto 58.58,28.80
talk Jhaka |q Cold Blood, Old Pain/Talk to Jhaka
step
goto 33.92,60.49
'Use Marbruk Wayshrine
'Travel to _Stonetooth_ in Betnikh |q Cold Blood, Old Pain/Find Guruz in Betnikh
|tip Manually skip to the next step.
step
goto stonetoothfortress_base 25.02,58.64
'Find Guruz in Betnikh |q Cold Blood, Old Pain/Find Guruz in Betnikh
step
goto 25.02,58.64
talk Guruz |q Cold Blood, Old Pain/Talk to Guruz
step
goto 25.02,58.64
talk Ember |q Cold Blood, Old Pain/Talk to Ember
step
goto betnihk_base 28.11,28.39
'Find the Sour Algae |q Cold Blood, Old Pain/.*Find the Sour Algae.* |count 1
step
goto 26.27,29.32
'Find the Sour Algae |q Cold Blood, Old Pain/.*Find the Sour Algae.* |count 2
step
goto 28.25,29.27
talk Ember |q Cold Blood, Old Pain/Talk to Ember
step
goto 28.02,30.01
|tip Watch the dialogue.
'Take Sour Algae Tonic |q Cold Blood, Old Pain/Take the Tonic When Ember Is Finished
step
goto stonetoothfortress_base 25.06,58.61
talk Guruz
'Tell him _I have a drink for you._ |q Cold Blood, Old Pain/Give the Sour Algae Tonic to Guruz
step
goto 25.06,58.61
talk Guruz |q Cold Blood, Old Pain/Talk to Guruz
step
goto 48.03,58.72
'Use Stonetooth Wayshrinbe
'Travel _Stillrise_ in Shadowfen  |q Cold Blood, Old Pain/Go to the Shrine of the Black Maw |future
|tip Manually skip to the next step.
step
goto shadowfen_base 35.86,20.86 |q Cold Blood, Old Pain/Go to the Shrine of the Black Maw |future
step
goto 28.99,16.95
'Oepn Shrine of the Black Maw |q Cold Blood, Old Pain/Search the Shrine for Silverslip |future
|tip Manually skip to the next step.
step
goto shrineofblackworm_base 15.08,35.01 |q Cold Blood, Old Pain/Search the Shrine for Silverslip |future
step
goto 16.13,80.12 |q Cold Blood, Old Pain/Search the Shrine for Silverslip |future
step
goto 52.51,80.35
|tip Watch the dialogue.
'Examine Silverslip's Journal |q Cold Blood, Old Pain/Read Silverslip's Journal |future
step
goto 77.51,42.00 |q Cold Blood, Old Pain/Meet Silverslip Outside
step
goto 63.48,40.68
'Use Shrine of the Black Maw |q Cold Blood, Old Pain/Meet Silverslip Outside
|tip Manually skip to the next step.
step
goto 88.99,10.28
'Open Shadowfen |q Cold Blood, Old Pain/Meet Silverslip Outside
|tip Manually skip to the next step.
step
goto shadowfen_base 28.09,17.24
talk Silverslip |q Cold Blood, Old Pain/Talk to Silverslip |future
step
goto 28.09,17.24
talk Ember
turnin Cold Blood, Old Pain
step
'_Next to you_
|tip Reach Allied rapport with Ember.
talk Ember
accept Green with Envy
step
'Open Bangkorai Map
'Travel to _Eastern Evermore_ |q Green with Envy/Go to Evermore to Meet Izbadd
|tip Manually skip to the next step.
step
goto evermore_base 50.46,46.00 |q Green with Envy/Go to Evermore to Meet Izbadd
step
goto 46.69,38.88
'Go to Evermore to Meet Izbadd |q Green with Envy/Go to Evermore to Meet Izbadd
step
goto 46.69,38.88
talk Izbadd |q Green with Envy/Talk to Izbadd
step
goto 46.69,38.88
talk Ember |q Green with Envy/Talk to Ember
step
goto bangkorai_base 46.62,37.15
'Use Eastern Evermore Wayshrine
'Travel to _Sentinel_ in Alik'r Desert |q Green with Envy/Search Sentinel for Azamel
|tip Manually skip to the next step.
step
goto sentinel_base 39.16,73.45 |q Green with Envy/Search Sentinel for Azamel
step
goto 40.80,56.91
talk Azamel |q Green with Envy/Talk to Azamel |future
step
goto alikr_base 25.05,51.74
'Follow Azamel |q Green with Envy/Follow Azamel
step
goto 25.05,51.74
'Open Sentinel Outlaws Refuge |q Green with Envy/Talk to Azamel |future
|tip Manually skip to the next step.
step
goto alkiroutlawrefuge_base 54.59,55.94
talk Azamel |q Green with Envy/Talk to Azamel |future
|tip Manually skip to the next step.
step
goto 54.59,55.94
talk Ember |q Green with Envy/Talk to Ember
step
goto 51.77,55.43
talk Silverslip |q Green with Envy/Talk to Silverslip |future
|tip Manually skip to the next step.
step
'Open Alik'r Desert Map
'Travel to _Kulati Mines_ |q Green with Envy/Find the Emerald Eye Camp
|tip Manually skip to the next step.
step
goto alikr_base 43.82,46.56
'Find the Emerald Eye Camp |q Green with Envy/Find the Emerald Eye Camp
step
goto 43.82,46.56
'Examine Emerald Eye Mage's Journal |q Green with Envy/Search for Information About Song
step
goto 43.82,46.56
talk Ember |q Green with Envy/Talk to Ember
step
'Open Alik'r Desert Map
'Travel to _Satakaleem_ |q Green with Envy/Go to Motalion Necropolis
|tip Manually skip to the next step.
step
goto 81.89,35.53 |q Green with Envy/Go to Motalion Necropolis
step
goto 80.24,35.48
'Go to Motalion Necropolis |q Green with Envy/Go to Motalion Necropolis
step
goto 80.24,35.48
'Open Motalion Necropolis |q Green with Envy/Find the Emerald Eye's Tomb
|tip Manually skip to the next step.
step
goto 76.88,32.15
'Open Tomb of the Emerald |q Green with Envy/Find the Emerald Eye's Tomb
|tip Manually skip to the next step.
step
goto 75.15,33.46
kill Lord Nabayir |q Green with Envy/Kill Lord Nabayir |future
|tip Manually skip to the next step.
step
goto 74.93,32.98
'Destroy the Confinement Wards |q Green with Envy/.*Destroy the Wards.* |count 1
step
goto 73.97,33.83
'Destroy the Confinement Wards |q Green with Envy/.*Destroy the Wards.* |count 2
step
goto 75.62,33.82
'Destroy the Confinement Wards |q Green with Envy/.*Destroy the Wards.* |count 3
step
goto 75.24,34.35
'Open Chamber of the Emerald Eye |q Green with Envy/Rescue Song
|tip Manually skip to the next step.
step
goto 75.83,35.10
'Destroy The Emerald Eye Relic |q Green with Envy/Rescue Song
step
goto 75.71,34.89
talk Song |q Green with Envy/Talk to Song
step
goto 75.71,34.89
talk Ember
turnin Green with Envy
]])

CGV:RegisterGuide("Extras\\Extras\\Companions\\Isobel Veloise",[[
loadingimage loadscreen_hi_systres_zone_01.dds
description Isobel Veloise Unlock quest and Rapport Quests.
step
'Open _High Isle and Amenos_ Map
'Travel to _Westbay_ |q Tournament of the Heart |future
|tip Manually skip to the next step.
step
goto u34_systreszone_base 43.21,78.03 |q Tournament of the Heart |future
step
goto 29.41,80.51
wayshrine Coral Road
step
goto 20.02,76.13
wayshrine Castle Navire
step
goto 20.02,76.60
talk Lord Remard DeFulley
accept Tournament of the Heart
step
goto 16.09,77.72
talk Isobel Veloise |q Tournament of the Heart/Choose a Trial |future
'Tell her _What do you know about the Order of the Iron Knot?_
'Tell her _Where was the sword lost?_
'Tell her _Let find that hilt for the Iron Knot. To the Library!_
step
goto 18.09,76.83 |q Tournament of the Heart/Meet Isobel at the Castle Library
step
goto 16.49,75.02
'Open _Castle Navire Knight's Wing_ |q Tournament of the Heart/Meet Isobel at the Castle Library |future
|tip Manually skip to the next step.
step
goto u34_navirecommander_base 47.08,19.59
'Examine _The Battle of Meadow Fort_ |q Tournament of the Heart/Research the Duforts |future
step
goto 40.09,17.64
talk Isobel Veloise |q Tournament of the Heart/Talk to Isobel Veloise
step
goto 78.92,29.67
'Open _Castle Navire Courtyard_ |q Tournament of the Heart/Go to the Dufort Ruin
|tip Manually skip to the next step.
step
goto u34_systreszone_base 19.91,76.73 |q Tournament of the Heart/Go to the Dufort Ruin
step
goto 28.90,80.30 |q Tournament of the Heart/Go to the Dufort Ruin
step
goto 35.63,84.13
'Go to the _Dufort Ruin_ |q Tournament of the Heart/Go to the Dufort Ruin
step
goto 35.63,84.13
talk Isobel Veloise |q Tournament of the Heart/Talk to Isobel Veloise |future
step
goto 34.42,86.13 |q Tournament of the Heart/Find Isobel's Path
step
goto 38.14,85.67
'Find _Isobel's Path_ |q Tournament of the Heart/Find Isobel's Path
step
goto 37.86,83.51 |q Tournament of the Heart/Find the Ruin
step
goto 35.75,83.04
'Take _Redheart's Hilt_ |q Tournament of the Heart/Search for the Sword Hilt |future
step
goto 35.71,81.63
'Follow _Isobel Veloise_ |q Tournament of the Heart/Follow Isobel
step
goto 35.71,81.63
talk Isobel Veloise |q Tournament of the Heart/Talk to Isobel
'Tell her _Tell me about the Oaken Order._
'Tell her _Do we talk to the mage, or fight them?_
'Tell her_ Let's get that staff for the Oaken Order._
step
goto 29.30,80.85
talk Isobel Veloise |q Tournament of the Heart/Talk to Isobel Veloise |future
step
goto 32.64,85.82 |q Tournament of the Heart/Find the Wizard's Grotto
step
goto 29.22,86.46 |q Tournament of the Heart/Find the Wizard's Grotto
step
goto 29.27,85.73
|tip Watch the dialogue.
'Find _Wizard's Grotto_ |q Tournament of the Heart/Find the Wizard's Grotto
step
goto 29.21,85.48
'Examine _Cat's Paw Pillar_ |q Tournament of the Heart/Examine A
step
goto 29.33,85.43
'Examine _Wooden Knot Pillar_ |q Tournament of the Heart/Examine B
step
goto 29.42,85.40
'Examine _Forest Heron Pillar_ |q Tournament of the Heart/Examine the Pillars
step
goto 29.35,85.51
talk Isobel Veloise |q Tournament of the Heart/Talk to Isobel Veloise
step
goto 31.95,87.29
'Take _Cat's Paw_ |q Tournament of the Heart/Gather a Cat's Paw Flower
step
goto 31.46,89.34
'Take _Spriggan's Veil_ |q Tournament of the Heart/Gather a Spriggan's Veil
step
goto 28.45,90.12
'Take _Heron's Feather_ |q Tournament of the Heart/Gather a Heron's Feather
step
goto 29.21,85.51
'Place _Cat's Paw Pillar_ |q Tournament of the Heart/Place the Cat's Paw
step
goto 29.31,85.42
'Place _Wooden Knot Pillar_ |q Tournament of the Heart/Place the Spriggan Veil
step
goto 29.42,85.36
'Place _Forest Heron Pillar_ |q Tournament of the Heart/Place the Heron Feather
step
goto 28.04,84.16
'Open _Erlibru's Cottage_ |q Tournament of the Heart/Enter the Elder's Cottage
step
goto 27.81,84.27
talk Erlibru |q Tournament of the Heart/Talk to Erlibru
step
goto 28.02,84.15
'Open _High Isle_ |q Tournament of the Heart/Take the Staff
|tip Manually skip to the next step.
step
goto 27.93,83.97
'Take _Staff of the Wild Woods_ |q Tournament of the Heart/Take the Staff
step
goto 28.08,84.01
talk Isobel Veloise |q Tournament of the Heart/Talk to Isobel
step
'Open _High Isle and Amenos_ Map
'Travel to _Castle Navire_ |q Tournament of the Heart/Meet Isobel at the Castle Chapel
|tip Manually skip to the next step.
step
goto 19.06,75.38
talk Isobel Veloise |q Tournament of the Heart/Talk to Isobel Veloise |future
step
goto 16.47,75.02
'Open _Castle Navire Knight's Wing_ |q Tournament of the Heart/Get a Key to the Catacombs
|tip Manually skip to the next step.
step
goto u34_navirecommander_base 78.47,50.74
'Open _Office of the Knight Commander_ |q Tournament of the Heart/Get a Key to the Catacombs
|tip Manually skip to the next step.
step
goto 86.48,63.23
talk Dame Hendra Trieve |q Tournament of the Heart/Get a Key to the Catacombs
'Tell her _I'm a peasant with a surprisingly full coin purse. [18]_
step
goto 79.73,52.23
'Open _Castle Navire_ |q Tournament of the Heart/Meet Isobel in the Chapel
|tip Manually skip to the next step.
step
goto 78.92,29.78
'Open _Castle Navire Courtyard_ |q Tournament of the Heart/Meet Isobel in the Chapel
|tip Manually skip to the next step.
step
goto u34_systreszone_base 19.12,75.28
'Open _Castle Navire Chapel_ |q Tournament of the Heart/Meet Isobel in the Chapel |future
|tip Manually skip to the next step.
step
goto u34_NavireCryptInt_base 10.46,9.03
'Unlock _Castle Navire Catacombs_ |q Tournament of the Heart/Unlock the Catacombs
step
goto 10.46,9.03
'Open _Castle Navire Catacombs_ |q Tournament of the Heart/Find the Gilded Lute
|tip Manually skip to the next step.
step
goto 39.32,29.63 |q Tournament of the Heart/Find the Gilded Lute
step
goto 42.34,25.32
talk Aspirant Mortens |q Tournament of the Heart/Talk to Aspirant Mortens |future
step
goto 38.97,60.37 |q Tournament of the Heart/Find Aspirant Mortens' Sword
step
goto 44.95,63.32
'Take _Aspirant Mortens' Sword_ |q Tournament of the Heart/Find Aspirant Mortens' Sword
step
goto 36.71,65.27 |q Tournament of the Heart/Talk to Aspirant Mortens
step
goto 42.48,25.32
talk Aspirant Mortens |q Tournament of the Heart/Talk to Aspirant Mortens |future
step
goto 57.00,35.43
'Open _Deep Crypts_ |q Tournament of the Heart/Find the Gilded Lute
|tip Manually skip to the next step.
step
goto 80.65,42.13 |q Tournament of the Heart/Find the Gilded Lute
step
goto 72.00,62.45 |q Tournament of the Heart/Defeat the Mad Duke
step
goto 78.99,85.38
'Take _The Gilded Lute of Sir Brenvale_ |q Tournament of the Heart/Find the Gilded Lute
step
goto 84.30,80.06 |q Tournament of the Heart/Leave the Catacombs
step
goto 80.69,89.27
'Open _High Isle_ |q Tournament of the Heart/Leave the Catacombs |future
|tip Manually skip to the next step.
step
goto u34_systreszone_base 21.34,78.55
talk Isobel Veloise |q Tournament of the Heart/Talk to Isobel
step
goto 13.51,76.32
talk Isobel Veloise |q Tournament of the Heart/Talk to Isobel at the Tourney Pavilion
step
goto 13.95,75.70
'Present _Redheart's Hilt_ |q Tournament of the Heart/Present Redheart's Hilt
step
goto 13.87,75.78
'Present the _Gilded Lute_ |q Tournament of the Heart/Present the Gilded Lute
step
goto 13.92,75.74
'Present _Staff of the Wild Woods_ |q Tournament of the Heart/Present the Staff
step
goto 13.92,75.74
'Watch the _Ceremony_ |q Tournament of the Heart/Watch the Ceremony
step
goto 14.61,75.61
'Open _Castle Navire Knight's Wing_ |q Tournament of the Heart/Go to the Knight Commander's Office
|tip Manually skip to the next step.
step
goto u34_navirecommander_base 78.69,50.86
'Open _Office of the Knight Commander_ |q Tournament of the Heart/Go to the Knight Commander's Office
|tip Manually skip to the next step.
step
goto 79.73,71.82
'Open _Knight Commander's Private Chamber_ |q Tournament of the Heart/Go to the Knight Commander's Office
step
goto 66.90,83.85
talk Knight Commander Jourvel |q Tournament of the Heart/Talk to the Knight Commander
step
goto 66.90,83.85
talk Isobel Veloise
turnin Tournament of the Heart
step
'_Next to you_
|tip Reach Friendly rapport with Isobel Veloise.
talk Isobel Veloise
accept The Lost Symbol
step
'Open Stros M'Kai Map
'Travel to _Port Hunding_ |q The Lost Symbol/Talk to Aurelia Jourvel |future
|tip Manually skip to the next step.
step
goto porthunding_base 41.32,58.47 |q The Lost Symbol/Talk to Aurelia Jourvel |future
step
goto 64.79,62.99
talk Aurelia Jourvel |q The Lost Symbol/Talk to Aurelia Jourvel |future
step
goto 64.79,62.99
talk Captain Marso |q The Lost Symbol/Talk to Captain Marso |future
|tip Manually skip to the next step.
step
goto 60.80,68.11
'Pick Up Betty Netch Ambergris Pomade |q The Lost Symbol/Track Kiv Lindres
|tip Manually skip to the next step.
step
goto 51.57,69.70
'Pick Up Engraved Arm Band |q The Lost Symbol/Track Kiv Lindres
|tip Manually skip to the next step.
step
goto 44.85,63.90
'Examine Kiv's Journal |q The Lost Symbol/Track Kiv Lindres
|tip Manually skip to the next step.
step
goto 28.04,70.57
'Pick Up Crumbly Sweetroll |q The Lost Symbol/Track Kiv Lindres
step
goto 26.92,77.81
talk Aydrah |q The Lost Symbol/Find a Witness to Kiv's Departure
step
goto 26.79,77.98 
talk Isobel Veloise |q The Lost Symbol/Talk to Isobel
step
goto 25.38,78.49
talk Davak Hlaren |q The Lost Symbol/Search for Kiv Lindres in Seyda Neen |future
'Tell him _I'd like to travel to Vvardenfell._
'Tell him _Take me to Seyda Need, then._
|tip Manually skip to the next step.
step 
goto vvardenfell_base 40.98,81.68
talk Galedra Athram |q The Lost Symbol/Search for Kiv Lindres in Seyda Neen |future
|tip Manually skip to the next step.
step
goto 40.92,81.50
'Open The Saucy Nix |q The Lost Symbol/Search Kiv's Belongings
|tip Manually skip to the next step.
step
goto 41.01,81.27
'Search Kiv's Bag |q The Lost Symbol/Search Kiv's Belongings
step
goto 39.95,80.24
|tip Leave The Saucy Nix
'Use Seyda Neen Wayshrine
'Travel to _Wayrest_ in Stormhaven |q The Lost Symbol/Search for Kiv Lindres in Wayrest
|tip Manually skip to the next step.
step
goto wayrest_base 25.03,35.02
talk Julles Laurdon |q The Lost Symbol/Talk to Julles Laurdon |future
step
goto 25.26,35.06
talk Isobel Veloise |q The Lost Symbol/Talk to Isobel
step
goto 39.62,50.20
'Use Wayrest Wayshrine
'Travel to _Belkarth_ in Craglorn |q The Lost Symbol/Search for Kiv Lindres in Belkarth |future
|tip Manually skip to the next step.
step
goto belkarth_base 73.61,51.90
'Open Crossroads Tavern |q The Lost Symbol/Search for Kiv Lindres in Belkarth |future
|tip Manually skip to the next step.
step
goto 76.34,48.96
|tip Go upstairs.
|tip Watch the dialogue.
talk Engelreth Goldleaf |q The Lost Symbol/Talk to Goldleaf |future
step
goto 67.91,56.50
|tip Leave Crossroads Tavern.
'Open Inn Basement |q The Lost Symbol/Confront Kiv Lindres Beneath the Tavern
|tip Manually skip to the next step.
step
goto 71.76,55.62
'Defeat Kiv Lindres Beneath the Tavern |q The Lost Symbol/Confront Kiv Lindres Beneath the Tavern
step
goto 71.76,55.62
talk Kiv Lindres |q The Lost Symbol/Talk to Kiv Lindres
step
goto 71.90,56.35
talk Julles Laurdon |q The Lost Symbol/Choose a Punishment for Kiv
'Tell him _That seems like a fitting punishment._
step
goto craglorn_base 63.24,64.50 |q The Lost Symbol/Find the Stolen Ring |tip Leave the Basement.
step
goto 64.90,59.53
'Dig Dirt Mound |q The Lost Symbol/Find the Stolen Ring
step
goto 64.90,59.53
talk Isobel Veloise |q The Lost Symbol/Talk to Isobel |future
step
'Open High Isle and Amenos Map
'Travel to _Gonfalon Square_ |q The Lost Symbol/Go to Isobel's Home in Gonfalon Bay |future
|tip Manually skip to the next step.
step
goto u34_gonfalonbaycity_base 25.71,58.85
'Open Veloise Townhouse |q The Lost Symbol/Go to Isobel's Home in Gonfalon Bay |future
step
goto 24.92,58.61
|tip Watch the dialogue.
talk Isobel Veloise
turnin The Lost Symbol
step
'_Next to you_
|tip Reach Close rapport with Isobel Veloise.
talk Isobel Veloise
accept A Mother's Request
step
'Open High Isle and Amenos Map
'Travel to _Castle Navire_ |q A Mother's Request/Go to Castle Navire |future
|tip Manually skip to the next step.
step
goto u34_systreszone_base 16.48,75.02
'Open Castle Navire Knight's Wing |q A Mother's Request/Talk to Knight Commander Jourvel |future
|tip Manually skip to the next step.
step
goto u34_navirecommander_base 78.69,51.09
'Open Office of the Knight Commander |q A Mother's Request/Talk to Knight Commander Jourvel
|tip Manually skip to the next step.
step
goto 79.61,71.71
'Open Knight Commander's Private Chambers |q A Mother's Request/Talk to Knight Commander Jourvel
|tip Manually skip to the next step.
step
goto 70.33,83.73
talk Knight Commander Jourvel |q A Mother's Request/Talk to Knight Commander Jourvel
step
goto 78.58,72.85
'Open Office of the Knight Commander |q A Mother's Request/Search Nilsmon's Bunk in the Barracks
|tip Manually skip to the next step.
step
goto 79.61,52.23
'Open Castle Navire |q A Mother's Request/Search Nilsmon's Bunk in the Barracks
|tip Manually skip to the next step.
step
goto 34.25,45.93
'Open Knights' Barracks |q A Mother's Request/Search Nilsmon's Bunk in the Barracks
|tip Manually skip to the next step.
step
goto 46.51,58.99
'Examine The Rose of Navire, Part the First |lorebook The Rose of Navire, Part the First/3/6/80
step
goto 46.51,58.99
'Examine Empty Bottle of "All Flags Rum" |q A Mother's Request/Search Nilsmon's Bunk in the Barracks
step
goto 44.90,62.77
talk Isobel Veloise |q A Mother's Request/Talk to Isobel
step
'Open High Isle and Amenos Map
'Travel to _Gonfalon Square_ |q A Mother's Request/Look for Nilsmon at the Ancient Anchor Inn
|tip Manually skip to the next step.
step
goto u34_gonfalonbaycity_base 43.87,37.21
'Open Ancient Anchor Inn |q A Mother's Request/Look for Nilsmon at the Ancient Anchor Inn
|tip Manually skip to the next step.
step
goto 41.92,34.03
'Examine The Rose of Navire, Part the Second |lorebook The Rose of Navire, Part the Second/3/6/81
step
goto 50.33,55.77
|tip Leave the Inn
'Examine lorebook The Rose of Navire, Part the Third |lorebook The Rose of Navire, Part the Third/3/6/82
step
goto 47.94,65.86
talk Nilsmon Booklover |q A Mother's Request/Talk to Nilsmon |future
step
goto 48.83,51.03 |q A Mother's Request/Talk to a Shipping Clerk
step
goto 61.02,52.40
talk Elzugoth |q A Mother's Request/Talk to a Shipping Clerk
step
goto 63.61,31.26
'Open High Isle |q A Mother's Request/Get the Wine for the Shipping Clerk
|tip Manually skip to the next step.
step
goto u34_gonfalonbaycity_base 68.31,20.63 |q A Mother's Request/Get the Wine for the Shipping Clerk
step
goto 79.89,21.66
'Gather Seathorn |q A Mother's Request/.*Find Seathorn for Halz.* |count 1
step
goto 82.50,25.41
'Gather Seathorn |q A Mother's Request/.*Find Seathorn for Halz.* |count 2
step
goto 82.50,25.41
'Gather Seathorn |q A Mother's Request/.*Find Seathorn for Halz.* |count 3 |future
|tip Manually skip to the next step.
step
goto 63.55,30.89
'Open Gonfalon Bay |q A Mother's Request/Get the Wine for the Shipping Clerk
|tip Manually skip to the next step.
step
goto 54.04,53.66
|tip Go across the docks.
'Open Gonfalon Bay Outlaws Refuge |q A Mother's Request/Get the Wine for the Shipping Clerk |future
|tip Manually skip to the next step.
step
goto u34_gonfalonoutlaw_base 64.39,46.08
talk Halz |q A Mother's Request/Talk to Halz in the Outlaws Refuge |future
|tip Manually skip to the next step.
step
goto 69.01,88.73
'Open Gonfalon Bay |q A Mother's Request/Talk to Elzugoth
|tip Manually skip to the next step.
step
goto u34_gonfalonbaycity_base 61.08,52.08
talk Elzugoth |q A Mother's Request/Talk to Elzugoth
step
goto 47.71,42.85
|tip Go up the stairs.
'Use Gonfalon Square Wayshrine
'Travel to _Northpoint_ in Rivenspire |q A Mother's Request/Go to Northsalt Village |future
|tip Manually skip to the next step.
step
goto northpoint_base 22.21,14.33
'Go to Northsalt Village |q A Mother's Request/Go to Northsalt Village |future
step
goto 31.09,15.20
talk Captain Marso |q A Mother's Request/Talk to Captain Marso
step
goto rivenspire_base 73.64,19.67
'Use Northpoint Wayshrine
'Travel to _Boralis_ |q A Mother's Request/Find Aurelia Jourvel
|tip Manually skip to the next step.
step
goto 79.83,30.23
'Untie Aurelia Jourvel |q A Mother's Request/Untie Aurelia |future
step
goto 80.04,30.29
talk Aurelia Jourvel |q A Mother's Request/Talk to Aurelia Jourvel
step
goto 80.09,30.35
talk Isobel Veloise
turnin A Mother's Request
step
'_Next to you_
|tip Reach Allied rapport with Isobel Veloise.
talk Isobel Veloise
accept The Princess Detective
step
'Open High Isle and Amenos Map
'Travel to _Gonfalon Square_  |q The Princess Detective/Go to the Ancient Anchor Inn |future
|tip Manually skip to the next step.
step
goto u34_gonfalonbaycity_base 43.87,37.36
'Open Ancient Anchor Inn |q The Princess Detective/Go to the Ancient Anchor Inn |future
|tip Manually skip to the next step.
step
goto 43.40,36.42
|tip Go to the third floor.
talk Knight Commander Jourvel |q The Princess Detective/Talk to Knight Commander Jourvel |future
step
goto 44.08,35.26
'Examine Aurelia's Letter |q The Princess Detective/Read Aurelia's Letter
step
goto 44.08,35.26
talk Isobel Veloise |q The Princess Detective/Talk to Isobel
step
goto 47.02,42.81
|tip Leave Ancient Anchor Inn.
'Use Gonfalon Square Wayshrine
'Travel to _Fell's Run_ in Rivenspire |q The Princess Detective/Look for Aurelia in Fell's Run |future
|tip Manually skip to the next step.
step
goto rivenspire_base 71.26,41.86
'Open The Run Inn |q The Princess Detective/Look for Aurelia in Fell's Run |future
step
goto 71.70,41.70
talk Aurelia Jourvel |q The Princess Detective/Talk to Aurelia Jourvel
step
goto 59.10,49.91 |q The Princess Detective/Go to Obisidian Scar |tip Leave the Inn.
step
goto 55.72,46.63
'Go to Obisidian Scar |q The Princess Detective/Go to Obisidian Scar
step
goto 55.63,45.60
|tip You can solo this part of the quest if you have decent AOE. (No boss kills).
'Queue for Obisidian Scar in Dungeon Finder |q The Princess Detective/Find Captain Marso in Obisidian Scar |future
|tip Manually skip to the next step.
step
goto obsidianscar_base 33.70,71.42 |q The Princess Detective/Find Captain Marso in Obisidian Scar |future
step
goto 77.92,71.17 |q The Princess Detective/Find Captain Marso in Obisidian Scar |future
step
goto 78.72,42.43 |q The Princess Detective/Find Captain Marso in Obisidian Scar |future
step
goto 89.38,38.32
|tip Stay on the left side of the cage to avoid boss if go through without group.
'Open Cage |q The Princess Detective/Free Marso
step
goto 77.92,71.17 |q The Princess Detective/Escort Marso Out of Obsidian Scar
step
goto 33.70,71.42 |q The Princess Detective/Escort Marso Out of Obsidian Scar
step
goto 33.31,89.52
'Open Rivenspire |q The Princess Detective/Escort Marso Out of Obsidian Scar |future
|tip Manually skip to the next step.
step
goto rivenspire_base 55.61,46.03
talk Captain Marso |q The Princess Detective/Talk to Captain Marso |future
|tip Manually skip to the next step.
step
goto 59.10,49.91 |q The Princess Detective/Return to the Fell's Run Inn
step
goto 70.87,41.90
talk Ennic Fenvale |q The Princess Detective/Talk to Ennic Fenvale |future
step
goto 67.11,44.67
'Use Fell's Run Wayshrine
'Travel to _Boralis_ |q The Princess Detective/Find Aurelia
|tip Manually skip to the next step.
step
goto 75.64,29.93 |q The Princess Detective/Find Aurelia
step
goto 78.92,34.45
'Untie Aurelia Jourvel |q The Princess Detective/Free Aurelia |future
step
goto 78.85,34.30
talk Isobel Veloise |q The Princess Detective/Talk to Isobel
step
goto 77.34,29.51 |q The Princess Detective/Visit the Couple at the Ancient Anchor Inn
step
goto 73.22,31.12
'Use Boralis Wayshrine
'Travel to _Gonfalon Square_ in High Isle |q The Princess Detective/Visit the Couple at the Ancient Anchor Inn |future
|tip Manually skip to the next step.
step
goto u34_gonfalonbaycity_base 43.95,37.42
'Open The Ancient Anchor Inn |q The Princess Detective/Visit the Couple at the Ancient Anchor Inn |future
|tip Manually skip to the next step.
step
goto 44.14,35.47
|tip Go upstairs to the third floor.
talk Aurelia Jourvel |q The Princess Detective/Talk to Aurelia |future
step
goto 44.14,35.47
talk Isobel Veloise
turnin The Princess Detective
]])

CGV:RegisterGuide("Extras\\Extras\\Companions\\Mirri Elendis",[[
loadingimage loadscreen_deadlandsvault_01.dds
description Guide to Unlock Mirri Elendis and Rapport Quests.
step
'Open _Blackwood_ Map
'Travel to _Leyawiin Outskirts_ Wayshrine |q Shattered and Scattered |future
|tip Manually skip to the next step.
step
goto blackwood_base 21.45,33.07 |q Shattered and Scattered |future
step
goto 31.92,30.26 |q Shattered and Scattered |future
step
goto 37.45,23.78 |q Shattered and Scattered |future
step
goto 34.48,17.46
'Examine _Adventurers Wanted For Exciting Oppertunity!_
accept Shattered and Scattered
step
goto 36.93,14.60
'Find _Ruin_ |q Shattered and Scattered/Find the Ruin
step
goto 36.93,14.60
talk Mirri Elendis |q Shattered and Scattered/Talk to Mirri Elendis
step
goto 37.45,14.26
'Open _Doomvault Vulpinaz_ |q Shattered and Scattered/Enter the Ruin |future
|tip Manually skip to the next step.
step
goto u30_shattered_vault_1_base 39.11,75.73 |q Shattered and Scattered/Reach the Expedition Base Camp
step
goto 50.93,50.31
'Reach the _Expedition Base Camp_ |q Shattered and Scattered/Reach the Expedition Base Camp
step
goto 51.11,49.69
'Use _Grappling Point_ |q Shattered and Scattered/Use Grapple Bow
step
goto 48.80,36.27
'Investigate _Base Camp_ |q Shattered and Scattered/Investigate the Base Camp
step
goto 48.80,36.27
talk Mirri Elendis |q Shattered and Scattered/Talk to Mirri Elendis
step
goto 53.16,22.84
'Destroy the _Soul Siphon Array_ |q Shattered and Scattered/Destroy the Soul Siphon Array
step
goto 45.69,14.22
'Open _Interstitial Corridor_ |q Shattered and Scattered/Follow Mirri Elendis
step
goto 45.51,12.18
talk Mirri |q Shattered and Scattered/Talk to Mirri Elendis
step
goto 53.57,8.01
'Open _Inner Ruins_ |q Shattered and Scattered/Find the Remaining Expedition Members
|tip Manually skip to the next step.
step
goto u30_shattered_vault_2_base 71.67,77.05 |q Shattered and Scattered/Find the Remaining Expedition Members
step
goto 51.96,68.94 |q Shattered and Scattered/Find the Remaining Expedition Members
step
goto 46.84,63.05
'Find the _Remaining Expedition Members_ |q Shattered and Scattered/Find the Remaining Expedition Members
step
goto 46.84,63.05
'Examine _Ardia's Journal_ |q Shattered and Scattered/Examine the Notebook
step
goto 47.27,62.71
talk Mirri Elendis |q Shattered and Scattered/Talk to Mirri Elendis
step
goto 47.70,61.52
'Open _Inner Layer_ |q Shattered and Scattered/Find the Remaining Expedition Members
|tip Manually skip to the next step.
step
goto 43.26,55.29
'Use _Grappling Point_ |q Shattered and Scattered/Find the Remaining Expedition Members
|tip Manually skip to the next step.
step
goto 52.82,23.81
'Find the _Remaining Expedition Members_ |q Shattered and Scattered/Find the Remaining Expedition Members
step
goto 52.82,23.81
'Destroy the _Soul Siphon Array_ |q Shattered and Scattered/Destroy the Soul Siphon Array
step
goto 46.25,16.64
'Open _Doomvault Vulpinaz Interstitial Corridor_ |q Shattered and Scattered/Follow Mirri Elendis
step
goto 46.16,14.76
talk Mirri Elendis |q Shattered and Scattered/Talk to Mirri Elendis
step
goto 54.10,04.78
'Open _Interstitial Corridor_ |q Shattered and Scattered/Find the Remaining Expedition Members
|tip Manually skip to the next step.
step
goto u30_shattered_vault_3_base 45.86,85.86
'Open _Doomvault Vulpinaz Core Layer_ |q Shattered and Scattered/Find the Remaining Expedition Members
|tip Manually skip to the next step.
step
goto 44.14,72.67 
'Find the _Remaining Expedition Members_ |q Shattered and Scattered/Find the Remaining Expedition Members
step
goto 44.14,72.67
talk Ghalor |q Shattered and Scattered/Examine Ghalor
step
goto 44.14,72.67
talk Mirri Elendis |q Shattered and Scattered/Talk to Mirri Elendis
step
goto 33.53,67.67
'Use _Grappling Point_ |q Shattered and Scattered/Find the Remaining Expedition Members
|tip Manually skip to the next step.
step
goto 43.45,55.95 |q Shattered and Scattered/Find the Remaining Expedition Members
step
goto 44.31,36.81
'Use _Grappling Point_ |q Shattered and Scattered/Find the Remaining Expedition Members
|tip Manually skip to the next step.
step
goto 66.29,21.38 
'Find the _Remaining Expedition Members_ |q Shattered and Scattered/Find the Remaining Expedition Members
step
goto 66.29,21.38
'Destroy the _Soul Siphon Array_ |q Shattered and Scattered/Destroy the Soul Siphon Array
step
goto 81.90,32.41
'Open _Deadlands Foothold_ |q Shattered and Scattered/Follow Mirri Elendis
step
goto u30_shattered_vault_4_base 08.56,41.31
talk Mirri Elendis |q Shattered and Scattered/Talk to Mirri Elendis
step
goto 33.01,46.43
'Use _Grappling Point_ |q Shattered and Scattered/Find Liam Elendis
|tip Manually skip to the next step.
step
goto 50.22,48.46
'Find _Liam Elendis_ |q Shattered and Scattered/Find Liam Elendis
step
goto 50.22,48.46
'Use _Daedric Switch_ |q Shattered and Scattered/Use Central Lever
step
goto 55.16,42.45
|tip Jump up the rocks or use Grappling Point.
'Use _Daedric Switch_ |q Shattered and Scattered/Use Leftmost Lever
step
goto 53.75,54.02
|tip Jump up the rocks or use Grappling Point.
'Use _Daedric Switch_ |q Shattered and Scattered/Use Rightmost Lever
step
goto 59.14,48.90
'Open _Doomvault Vulpinaz Anchor Chamber_ |q Shattered and Scattered/Find Liam Elendis
step
goto 79.61,54.99
|tip Use Grappling Point
kill Xigira |q Shattered and Scattered/Destroy the Anchor Stone Array
|tip Manually skip to the next step.
step
goto 91.26,63.28
|tip Skip the two Anchor Stones on the ground and just hit the one up top.
|tip Use Grappling Point
'Destroy the _Anchor Stone Array_ |q Shattered and Scattered/Destroy the Anchor Stone Array
step
goto 95.41,64.34
'Open _Blackwood_ |q Shattered and Scattered/Exit the Ruin |future
|tip Manually skip to the next step.
step
goto blackwood_base 37.71,12.89
talk Mirri Elendis
turnin Shattered and Scattered
step
'_Next to you_
|tip Reach Friendly rapport with Mirri Elendis.
talk Mirri Elendis
accept A Mother's Obsession
step
'Open _Shadowfen_ Map
'Travel to _Stormhold_ |q A Mother's Obsession/Go to the Stormhold Mages Guild
|tip Manually skip to the next step.
step
goto stormhold_base 45.21,47.28
'Open _Mages Guild_ |q A Mother's Obsession/Go to the Stormhold Mages Guild
|tip Manually skip to the next step.
step
goto stormholdguildhall_map 34.11,57.28
talk Mirtulivon |q A Mother's Obsession/Talk to Mirtulivon |future
step
goto 34.11,57.28
talk Mirri Elendis |q A Mother's Obsession/Talk to Mirri Elendis
step
goto 31.19,13.57
'Open _Stormhold_ |q A Mother's Obsession/Find the Antique Inkwell
|tip Manually skip to the next step.
step
goto stormhold_base 58.41,24.13
'Open _Under-Root Bank_ |q A Mother's Obsession/Find the Antique Inkwell
|tip Manually skip to the next step.
step
goto 59.02,20.34
talk Seviel Andril |q A Mother's Obsession/Find the Antique Inkwell
'Tell him _I hear gold makes a pleasant distraction. Maybe you could count yours somewhere else? [69]_
step
goto 59.32,20.22
'Take _Antique Inkwell_ |q A Mother's Obsession/Find the Antique Inkwell
step
goto 45.20,47.28
|tip Leave the bank.
'Open _Mages Guild_ |q A Mother's Obsession/Talk to Mirtulivon
|tip Manually skip to the next step.
step
goto stormholdguildhall_map 34.04,57.29
talk Mirtulivon |q A Mother's Obsession/Talk to Mirtulivon
step
goto 30.49,13.57
'Open _Stormhold_ |q A Mother's Obsession/Go to Edvilda's Camp
|tip Manually skip to the next step.
step
goto stormhold_base 85.66,34.15
'Use _Stormhold_ Wayshrine
'Travel to _Davon's Watch_ in Stonefalls |q A Mother's Obsession/Go to Edvilda's Camp |future
|tip Manually skip to the next step.
step
goto stonefalls_base 76.43,40.25 |q A Mother's Obsession/Go to Edvilda's Camp |future
step
goto 75.94,40.90
'Examine Homemade Scarf |q A Mother's Obsession/.*TRACKER GOAL TEXT.* |count 1 |future
step
goto 75.99,41.17
'Examine Edvilda's Log |lorebook Edvilda's Log Book/3/42/51
step
goto 76.03,41.13
talk Mirri Elendis |q A Mother's Obsession/Talk to Mirri Elendis |future
step
goto 74.70,37.12 |q A Mother's Obsession/Go to the Inner Sea Armature
step
goto 72.08,37.69 |q A Mother's Obsession/Go to the Inner Sea Armature
step
goto 71.79,39.67
'Open Inner Sea Armature |q A Mother's Obsession/Go to the Inner Sea Armature |future
|tip Manually skip to the next step.
step
goto innerseaarmature_base 83.04,37.58 |q A Mother's Obsession/Free Irenni Elendis |future
step
goto 71.39,52.80 |q A Mother's Obsession/Free Irenni Elendis |future
step
goto 50.66,42.67
'Unlock Chain Post Irenni Elendis |q A Mother's Obsession/Free Irenni Elendis |future
step
goto 50.66,42.67
talk Irenni Elendis |q A Mother's Obsession/Talk to Irenni Elendis |future
step
goto 72.74,50.50 |q A Mother's Obsession/Escort Irenni Elendis to Safety
step
goto 83.09,37.55 |q A Mother's Obsession/Escort Irenni Elendis to Safety |future
step
goto 78.43,27.20
'Open Stonefalls |q A Mother's Obsession/Escort Irenni Elendis to Safety |future
|tip Manually skip to the next step.
step
goto stonefalls_base 71.74,39.14
'Wait for Mirri and Irenni to Talk |q A Mother's Obsession/Wait for Mirri and Irenni to Talk |future
step
goto 71.40,38.79
talk Irenni Elendis |q A Mother's Obsession/Talk to Irenni Elendis |future
|tip Manually skip to the next step.
step
goto 71.40,38.79
talk Mirri Elendis
turnin A Mother's Obsession
step
'_Next to you_
|tip Reach Close rapport with Mirri Elendis.
talk Mirri Elendis
accept Dead Weight
step
'Open Stonefalls Map
'Travel to _Othrenis_ |q Dead Weight/Find the Elendis Family Plot in Othrenis |future
|tip Manually skip to the next step.
step
goto 79.38,59.10
'Light Votive Candles |q Dead Weight/Light the Votive Candles |future
step
goto 79.38,59.10
'Watch Mirri Summon Her Ancestor |q Dead Weight/Watch Mirri Summon Her Ancestor
step
goto 79.38,59.10
talk Bralen Elendis |q Dead Weight/Talk to Bralen Elendis
step
goto 79.38,59.10
talk Mirri Elendis |q Dead Weight/Talk to Mirri Elendis
step
goto 72.15,59.12
'Use Othrenis Wayshrine
'Travel to _Vulkhel Guard_ in Auridon |q Dead Weight/Go to the Vulkhel Guard Mages Guild |future
|tip Manually skip to the next step.
step
goto vulkhelguard_base 22.36,53.94
talk Takaano |q Dead Weight/Ask About Onimiril |future
step
goto 42.09,66.46
|tip Follow the Chicken to this spot.
'Grab Chicken |q Dead Weight/Find Arelette the Chicken
step
goto 21.97,54.32
talk Takaano |q Dead Weight/Talk to Takaano
step
goto 54.74,41.05
'Use Vulkhel Guard Wayshrine
'Travel to _Skywatch_ |q Dead Weight/Find Onimiril's Retreat
|tip Manually skip to the next step.
step
goto auridon_base 49.07,41.43 |q Dead Weight/Find Onimiril's Retreat
step
goto 49.34,43.38
kill Onimiril
'Examine Onimiril's Writings |q Dead Weight/Search Onimiril's Retreat |future
step
'Open The Rift Map
'Travel to _Honrich Tower_ |q Dead Weight/Go to Avanchnzel |future
|tip Manually skip to the next step.
step
goto therift_base 38.33,57.37
'Open Avanchnzel |q Dead Weight/Go to Avanchnzel |future
|tip Manually skip to the next step.
step
goto avancheznel_base 9.82,26.41 |q Dead Weight/Find the Dwarven Puzzle Box |future
step
goto 25.27,71.08 |q Dead Weight/Find the Dwarven Puzzle Box |future
step
goto 41.82,81.89
'Take Dwarven Puzzle Box |q Dead Weight/Find the Dwarven Puzzle Box |future
step
goto 25.27,71.08 |q Dead Weight/Talk to Mirri Elendis Outside Avanchnzel
step
goto 9.82,26.41 |q Dead Weight/Talk to Mirri Elendis Outside Avanchnzel
step
goto 23.19,37.51
'Open The Rift |q Dead Weight/Talk to Mirri Elendis Outside Avanchnzel |future
|tip Manually skip to the next step.
step
goto therift_base 38.33,57.38
talk Mirri Elendis |q Dead Weight/Talk to Mirri Elendis Outside Avanchnzel |future
step
goto 42.06,51.83
'Use Honrich Tower
'Travel to _Othrenis_ in Stonefalls |q Dead Weight/Return the Puzzle Box to Mirri's Ancestor |future
|tip Manually skip to the next step.
step
goto stonefalls_base 79.37,59.11
|tip Watch the dialogue.
'Place Bralen Elendis's Shrine |q Dead Weight/Return the Puzzle Box to Mirri's Ancestor |future
step
goto 79.37,59.11
talk Bralen Elendis |q Dead Weight/Talk to Bralen Elendis
step
goto 79.37,59.11
talk Mirri Elendis
turnin Dead Weight
]])

CGV:RegisterGuide("Extras\\Extras\\Companions\\Sharp-as-Night",[[
loadingimage loadscreen_u30_blackwood_zone_01.dds
description Sharp-as-Night Unlock quest and Rapport Quests.
step
'Open _Telvanni Peninsula_ Map
'Travel to _Necrom Outskirts_ |q The Double Edge |future
|tip Manually skip to the next step.
step
goto u38_telvannipeninsula_base 79.95,41.84 |q The Double Edge |future
step
goto u38_Necrom_base 47.76,63.06 |q The Double Edge |future
step
goto u38_telvannipeninsula_base 79.55,37.22
talk Sharp-as-Night
accept The Double Edge
step
goto 78.86,36.54
'Open _Necrom Outaws Refuge_ |q The Double Edge/Talk to Harn Orenvi
|tip Manually skip to the next step.
step
goto u38_NecromOutlawsRefuge02_base 56.19,77.52 |q The Double Edge/Talk to Harn Orenvi
step
goto 62.55,66.57
talk Harn Orenvi |q The Double Edge/Talk to Harn Orenvi
|tip Persuade him.
step
goto 48.13,42.39
'Open _Necrom_ |q The Double Edge/Go to Deredrien's Place
|tip Manually skip to the next step.
step
goto u38_Necrom_base 38.91,43.52 |q The Double Edge/Go to Deredrien's Place
step
goto 48.48,35.15 |q The Double Edge/Go to Deredrien's Place
step
goto 52.83,41.98
'Open _Palace View Apartments_ |q The Double Edge/Go to Deredrien's Place
|tip Manually skip to the next step.
step
goto 50.98,40.69
'Examine _Scattered Papers_ |q The Double Edge/Examine Mess |future
step
goto 51.11,40.64
'Examine _Letter to Deredrien_ |q The Double Edge/Fence's Notes
step
goto 51.07,40.54
'Examine _Rotmeth_ |q The Double Edge/Examine Bottle
step
goto 51.07,40.67
talk Sharp-as-Night |q The Double Edge/Talk to Sharp-as-Night
step
'Open _Telvanni Peninsula_ Map
'Travel to _Necrom Outskirts_ |q The Double Edge/Meet Sharp-as-Night near Reynila's Campsite
|tip Manualy skip to the next step.
step
goto u38_telvannipeninsula_base 53.70,43.70
wayshrine Fungal Lowlands
step
goto 53.70,43.70 |q The Double Edge/Meet Sharp-as-Night near Reynila's Campsite
step
goto 50.98,46.52
talk Sharp-as-Night |q The Double Edge/Meet Sharp-as-Night near Reynila's Campsite
step
goto 50.98,46.52
talk Sharp-as-Night |q The Double Edge/Talk to Sharp-as-Night
step
goto 51.04,42.09
'Examine _Organized Notes_ |lorebook Organization Notes/3/48/77
step
goto 50.57,42.03
'Examine _Lanterns_ |q The Double Edge/Examine Lanterns
step
goto 48.15,43.62
'Examine _Letter from the Reformer_ |q The Double Edge/Investigate Deredrien's Note |future
step
goto 48.26,43.50
talk Sharp-as-Night |q The Double Edge/Talk to Sharp
step
goto 35.91,50.49 |q The Double Edge/Find Mevei Andros in Ald Isra
step
goto 33.16,56.00
wayshrine Ald Isra
step
goto 33.16,56.00 |q The Double Edge/Find Mevei Andros in Ald Isra
step
goto tlv_aldisra_base 90.64,69.69 |q The Double Edge/Find Mevei Andros in Ald Isra
step
goto 42.82,34.70
talk Mevei Andros |q The Double Edge/Talk to Mevei Andros |future
step
goto 90.53,44.25 |q The Double Edge/Meet Sharp on Gorne
step
goto u38_telvannipeninsula_base 33.16,55.88
'Use _Ald Isra_ Wayshrine
'Travel to _Fungal Lowlands_ |q The Double Edge/Meet Sharp on Gorne
|tip Manually skip to the next step.
step
goto 67.40,42.54 |q The Double Edge/Meet Sharp on Gorne
step
goto 70.85,35.36 |q The Double Edge/Meet Sharp on Gorne
step
goto 69.17,32.81 |q The Double Edge/Meet Sharp on Gorne
step
goto 71.92,31.74
|tip Recommended to get a group. This is a public dungeon.
'Travel to _Gorne_ |q The Double Edge/Meet Sharp on Gorne
|tip Manually skip to the next step.
step
goto u38_gorne_main 77.18,31.66
talk Sharp-as-Night |q The Double Edge/Talk to Sharp-as-Night |future
step
goto 65.60,28.54 |q The Double Edge/Find Reynila
step
goto 47.49,22.61 |q The Double Edge/Find Reynila
step
goto 37.18,15.62 |q The Double Edge/Find Reynila
step
goto 21.24,30.87 |q The Double Edge/Find Reynila
step
goto 19.86,38.30 |q The Double Edge/Find Reynila
step
goto 25.52,37.97 |q The Double Edge/Find Reynila
step
goto 33.02,49.94 |q The Double Edge/Find Reynila
step
goto 23.24,54.58 |q The Double Edge/Find Reynila
step
goto 29.96,68.97
|tip Go downstairs.
'Open _Smuggler's Hideout_ |q The Double Edge/Find Reynila
|tip Manually skip to the next step.
step
goto 25.23,81.55
kill Mercenaries |q The Double Edge/Defeat the Mercenaries |future
step
goto 21.51,81.00
'Open _Smuggler's Cove_ |q The Double Edge/Follow Reynila
step
goto 17.65,79.18
talk Reynila Treviri |q The Double Edge/Talk to Reynila
step
goto 17.65,79.18
talk Dimik-ei |q The Double Edge/Talk to Dimik-Ei
step
goto 17.65,79.18
talk Sharp-as-Night
turnin The Double Edge
]])

CGV:RegisterGuide("Extras\\Extras\\Companions\\Azandar Al-Cybiades",[[
loadingimage loadscreen_u30_blackwood_zone_01.dds
description Azandar Al-Cybiades Unlock quest and Rapport Quests.
step
'Open _Telvanni Peninsula_ Map
'Travel to _Necrom Outskirts_ |q The Fateweaver Key |future
|tip Manually skip to the next step.
step
goto u38_telvannipeninsula_base 79.97,41.83 |q The Fateweaver Key |future
step
goto 81.53,37.97 |q The Fateweaver Key |future
step
goto u38_Necrom_base 47.93,58.67
'Open _Necrom_ |q The Fateweaver Key |future
|tip Manually skip to the next step.
step
goto 48.65,49.58
wayshrine Necrom
step
goto 48.65,49.58 |q The Fateweaver Key |future
step
goto 55.82,52.48 |q The Fateweaver Key |future
step
goto 60.30,52.39
'Open _Necrom Bindery_ |q The Fateweaver Key |future
|tip Manually skip to the next step.
step
goto 58.06,52.94
'Use _Portal to Apocrypha: The Endless Library_ |q The Fateweaver Key |future
|tip Manually skip to the next step.
step
goto u38_apocrypha_base 71.43,78.87 |q The Fateweaver Key |future
step
goto 67.73,71.45
wayshrine Tranquil Catalog
step
goto 62.00,57.86
talk Azandar
accept The Fateweaver Key
step
goto u38_ciphersmidden_city_base 73.26,55.19
wayshrine Cipher's Midden
step
goto 52.64,37.16
talk Azandar |q The Fateweaver Key/Talk to Azandar |future
step
goto 42.45,32.75
|tip Follow Green Orb.
'Examine _Book Pile_ |q The Fateweaver Key/Find the Book with Azandar
step
goto u38_apocrypha_base 57.50,52.53
'Chase _Tomeshell_ |q The Fateweaver Key/Chase the Tomeshell
step
goto 57.50,52.53
'Examine _Predestination and Paradox: A Treatise_ |q The Fateweaver Key/Take the Book
step
goto u38_ciphersmidden_city_base 41.01,11.45
talk Azandar |q The Fateweaver Key/Talk to Azandar
step
goto 22.76,71.82
|tip Go upstairs.
'Open _Ciphers Repository_ |q The Fateweaver Key/Search for Tomedust from a Daedric Spell
|tip Manually skip to the next step.
step
goto 10.17,77.73
'Examine _Expunged Daedric Tomedust_ |q The Fateweaver Key/Search for Tomedust from a Daedric Spell
step
goto 22.15,69.47 |q The Fateweaver Key/Find a Seeker Talon |future
step
goto 36.21,72.40 |q The Fateweaver Key/Find a Seeker Talon
step
goto 29.94,92.44 |q The Fateweaver Key/Find a Seeker Talon
step
goto u38_apocrypha_base 52.25,66.71 |q The Fateweaver Key/Find a Seeker Talon
step
goto 50.39,65.45
'Take _Embedded Seeker Talon_ |q The Fateweaver Key/Find a Seeker Talon
step
goto 51.61,67.11 |q The Fateweaver Key/Meet Azandar at the Ritual Altar
step
goto 44.86,68.50 |q The Fateweaver Key/Meet Azandar at the Ritual Altar
step
goto 41.71,59.79
talk Azandar |q The Fateweaver Key/Talk to Azandar |future
step
goto 41.14,60.28
|tip Watch the dialogue.
'Place _Summoning Font_ |q The Fateweaver Key/Present Expunged Tomedust |future
step
goto 40.83,60.03
|tip Watch the dialogue.
'Place _Summoning Font_ |q The Fateweaver Key/Offer Seeker's Talon
step
goto 41.13,59.73
|tip Watch the dialogue.
'Pour _Summoning Font_ |q The Fateweaver Key/Pour Ichor in the Font
step
goto 41.10,59.93
talk Tem |q The Fateweaver Key/Talk to Tem, the Omen of Destiny
step
goto 41.30,59.96
talk Azandar |q The Fateweaver Key/Talk to Azandar |future
|tip Manually skip to the next step.
step
goto 39.47,52.73 |q The Fateweaver Key/Meet Azandar in the Underweave
step
goto 41.88,51.42 |q The Fateweaver Key/Meet Azandar in the Underweave
step
goto 40.36,49.96
|tip Recommended to get a group. This is a public dungeon.
'Enter _The Underweave_ |q The Fateweaver Key/Meet Azandar in the Underweave |future
|tip Manually skip to the next step.
step
goto U38_underweave_central_base 26.93,79.58
talk Azandar |q The Fateweaver Key/Talk to Azandar
step
goto 28.12,34.23 |q The Fateweaver Key/Find Martina's Sanctum in the Underweave's Heart
step
goto 49.69,35.03
'Open _Underweave Nullifactory_ |q The Fateweaver Key/Find Martina's Sanctum in the Underweave's Heart
|tip Manually skip to the next step.
step
goto U38_underweave_process01_base 73.69,55.92 |q The Fateweaver Key/Find Martina's Sanctum in the Underweave's Heart
step
goto 73.93,43.54 |q The Fateweaver Key/Find Martina's Sanctum in the Underweave's Heart
step
goto 81.26,43.66 |q The Fateweaver Key/Find Martina's Sanctum in the Underweave's Heart
step
goto 89.61,90.57
'Open _Underweave Courtyard_ |q The Fateweaver Key/Find Martina's Sanctum in the Underweave's Heart
|tip Manually skip to the next step.
step
goto U38_underweave_central_base 90.02,50.14 |q The Fateweaver Key/Find Martina's Sanctum in the Underweave's Heart
step
goto 86.37,62.24
'Open _Underweave Heart_ |q The Fateweaver Key/Find Martina's Sanctum in the Underweave's Heart
|tip Manually skip to the next step.
step
goto U38_underweave_heart_base 67.46,73.49 |q The Fateweaver Key/Find Martina's Sanctum in the Underweave's Heart
step
goto 18.46,49.82
'Open _Martina's Sanctum_ |q The Fateweaver Key/Search Martina's Sanctum |future
|tip Manually skip to the next step.
step
goto U38_underweave_secretlab_base 56.51,66.41
'Examine _Mysterious Experiment_ |q The Fateweaver Key/Unknown Experiment
step
goto 29.95,83.85
'Examine _The Never-Woven_ |q The Fateweaver Key/Floating Journal
step
goto 47.14,58.59
'Examine _Martina Abor_ |q The Fateweaver Key/Examine Corpse
step
goto 43.49,56.51
talk Azandar |q The Fateweaver Key/Talk to Azandar
step
'Open _Apocrypha_ Map
'Travel to _Cipher's Midden_ |q The Fateweaver Key/Meet Azandar in His Cipher's Midden Chambers
|tip Manually skip to the next step.
step
goto u38_ciphersmidden_city_base 81.85,63.62
'Open _Azandar's Lodgings_ |q The Fateweaver Key/Meet Azandar in His Cipher's Midden Chambers
step
goto 80.84,64.23
talk Azandar |q The Fateweaver Key/Talk to Azandar
step
goto 81.86,64.40
'Activate _Scrying Beacon_ |q The Fateweaver Key/Light Scry Beacon 4 |future
step
goto 83.20,65.38
'Activate _Scrying Beacon_ |q The Fateweaver Key/Light Scry Beacon 1
step
goto 82.27,67.55
'Activate _Scrying Beacon_ |q The Fateweaver Key/Light Scry Beacon 2
step
goto 80.66,67.02
'Activate _Scrying Beacon_ |q The Fateweaver Key/Help Azandar With A Fate Scrying Ritual
step
goto 50.65,35.16 |q The Fateweaver Key/Meet Azandar Near Fathoms Drift
step
goto u38_apocrypha_base 54.60,52.35
'Open _Central Orphic Tunnels_ |q The Fateweaver Key/Meet Azandar Near Fathoms Drift
|tip Manually skip to the next step.
step
goto u38_Tunnel2_base 59.04,33.23 |q The Fateweaver Key/Meet Azandar Near Fathoms Drift
step
goto 41.02,37.74
'Open _Apocrypha: Chroma Incognito_ |q The Fateweaver Key/Meet Azandar Near Fathoms Drift
|tip Manually skip to the next step.
step
goto u38_apocrypha_base 42.50,42.35 |q The Fateweaver Key/Meet Azandar Near Fathoms Drift
step
goto 45.35,32.22 |q The Fateweaver Key/Meet Azandar Near Fathoms Drift
step
goto 41.17,24.01
wayshrine Forlorn Palisades
step
goto 37.63,20.52
talk Azandar |q The Fateweaver Key/Talk to Azandar |future
step
goto 39.05,19.07
'Enter _Fathoms Drift_ |q The Fateweaver Key/Enter Fathom's Drift
|tip Manually skip to the next step.
step
goto U38_CorpuscleBight_01_Base 33.35,74.61
'Untie _Fate Thread_ |q The Fateweaver Key/Seek Threads of Fate
|tip Manually skip to the next step.
step
goto 18.84,67.14
'Untie _Fate Thread_ |q The Fateweaver Key/Seek Threads of Fate
|tip Manually skip to the next step.
step
goto 25.70,58.11
'Untie _Fate Thread_ |q The Fateweaver Key/Seek Threads of Fate
|tip Manually skip to the next step.
step
goto U38_CorpuscleBight_02_Base 25.73,49.68
|tip Go upstairs.
'Untie _Fate Thread_ |q The Fateweaver Key/Seek Threads of Fate
|tip Manually skip to the next step.
step
goto 28.69,40.25
'Untie _Fate Thread_ |q The Fateweaver Key/Seek Threads of Fate
|tip Manually skip to the next step.
step
goto 31.26,36.80
'Open _Fathom Drift Wreckage_ |q The Fateweaver Key/Seek Threads of Fate
|tip Manually skip to the next step.
step
goto 41.41,29.70
'Observe _Azandar's Frayed Fate_ |q The Fateweaver Key/Observe Azandar's Frayed Fate |future
step
goto 41.83,28.88
'Activate _Fatebinding Rune Alpha_ |q The Fateweaver Key/Hit Fate Button
step
goto 42.57,29.09
'Activate _Fatebinding Rune Zeta_ |q The Fateweaver Key/Fate Button B
step
goto 41.64,29.26
talk Azandar |q The Fateweaver Key/Talk to Azandar
step
'Open _Apocrypha_ Map
'Travel to _Cipher's Midden_ |q The Fateweaver Key/Meet Azandar in His Cipher's Midden Chambers
|tip Manually skip to the next step.
step
goto u38_ciphersmidden_city_base 81.27,63.12
'Open _Azandar's Lodgings_ |q The Fateweaver Key/Meet Azandar in His Cipher's Midden Chambers
step
goto 82.61,66.54
talk Azandar
turnin The Fateweaver Key
step
'_Next to you_
|tip Reach Friendly rapport with 
]])