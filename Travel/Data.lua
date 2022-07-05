-----------------------------------------
-- LOCALIZED GLOBAL VARIABLES
-----------------------------------------

local ZGV = _G.ZGV
local Data = {}
local Travel

-----------------------------------------
-- SAVED REFERENCES
-----------------------------------------

Travel = ZGV.Travel
Travel.Data = Data

-----------------------------------------
-- MAP DATA
-----------------------------------------

--[[
	\s*(\[.*\]) = ([0-9]*),\n  	->	\t\1 = \2,\n
	\t(\[.*\]) = ([0-9]*)		->	\t\2##\1 = \2
	\t[0-9]*##			->	\t
--]]


Data.MapIdsByName = {

    -- Aldmeri Dominion
    -- Khenarthi's Roost
    ["Khenarthi's Roost"]                   =   1,
    ["Temple of the Mourning Springs"]      =   2,
    ["Hazak's Lair"]                        =   3,
    ["Shattered Shoals"]                    =   4,
    ["The Mangroves"]                       =   5,
    ["Mistral"]                             =   6,
    ["Cat's Eye Quay"]                      =   7,
	
    -- Auridon
    ["Vulkhel Guard"]                       =   8,
    ["Auridon"]                             =   9,
    ["Del's Claim"]                         =  10,
    ["Ondil"]                               =  11,
    ["Phaer Catacombs"]                     =  12,
    ["Inner Tanzelwil"]                     =  13,
    ["Temple of the Vale"]                  =  14,
    ["Sanessalomo's Lair"]                  =  15,
    ["Entila's Folly"]                      =  16,
    ["Smuggler's Tunnel"]                   =  17,
    ["Skywatch"]                            =  18,
    ["The Veiled Keep"]                     =  19,
    ["Ezduiin Undercroft"]                  =  20,
    ["Wansalen"]                            =  21,
    ["Quendeluum South Ruins"]              =  22,
    ["Abandoned Mine"]                      =  23,
    ["Bewan"]                               =  24,
    ["Saltspray Cave"]                      =  25,
    ["Torinaan Shrines"]                    =  26,
    ["Mehrunes' Spite"]                     =  27,
    ["The Vault of Exile"]                  =  28,
    ["Firsthold"]                           =  29,
    ["The Refuge of Dredd"]                 =  30,
	
    -- Grahtwood
    ["Grahtwood"]                           =  31,
    ["Haven"]                               =  32,
    ["Sacred Leap Grotto"]                  =  33,
    ["The Scuttle Pit"]                     =  34,
    ["Brakenleaf"]                          =  35,
    ["Elden Root"]                          =  36,
    ["Cave of Broken Sails"]                =  37,
    ["Grey Mire"]                           =  38,
    ["Barrowbough"]                         =  39,
    ["Cathedral of the Golden Path"]        =  40,
    ["Ne Salas"]                            =  41,
    ["Mobar Mine"]                          =  42,
    ["The Middens"]                         =  43,
    ["Vinedeath Cave"]                      =  44,
    ["Ossuary of Telacar"]                  =  45,
    ["Laeloria Ruins"]                      =  46,
    ["Karthdar"]                            =  47,
    ["Cormount Prison"]                     =  48,
    ["Reliquary Ruins"]                     =  49,
    ["Reliquary Vault"]                     =  50,
    ["Ancient Cave"]                        =  51,
    ["Faltonia's Mine"]                     =  52,
    ["Barkbite Cave"]                       =  53,
    ["Barkbite Mine"]                       =  54,
    ["Redfur Trading Post"]                 =  55,
    ["Tomb Anahbi"]                         =  56,
    ["Burroot Kwama Mine"]                  =  57,
    ["Gil-Var-Delle Abandoned Cave"]        =  58,
    ["Nairume's Prison"]                    =  59,
    ["The Orrery"]                          =  60,
    ["Wormroot Depths"]                     =  61,
	
    -- Greenshade
    ["Marbruk"]                             =  62,
    ["Greenshade"]                          =  63,
    ["Gurzg's Mine"]                        =  64,
    ["Camp Gushnukbur"]                     =  65,
    ["Shrouded Hollow"]                     =  66,
    ["Carac Dena"]                          =  67,
    ["Silatar"]                             =  68,
    ["Hollow Den"]                          =  69,
    ["Shademist Enclave"]                   =  70,
    ["Naril Nagaia"]                        =  71,
    ["Woodhearth"]                          =  72,
    ["Imperial Underground"]                =  73,
    ["Ilmyris"]                             =  74,
    ["Serpent's Grotto"]                    =  75,
    ["The Underroot"]                       =  76,
    ["Abecean Sea"]                         =  77,
    ["Old Merchant Caves"]                  =  78,
    ["Harridan's Lair"]                     =  79,
    ["Nereid Temple Cave"]                  =  80,
    ["Falinesti Cave"]                      =  81,
    ["Hectahame Grotto"]                    =  82,
    ["Isle of Torment"]                     =  83,
    ["Barrow Trench"]                       =  84,
	
	-- Malabal Tor
    ["Malabal Tor"]                         =  85,
    ["Velyn Harbor"]                        =  86,
    ["Stormwarden Undercroft"]              =  87,
    ["Dead Man's Drop"]                     =  88,
    ["Tomb of the Apostates"]               =  89,
	["Hoarvor Pit"]                         =  90,
    ["Vulkwasten"]                          =  91,
    ["Ogrim's Yawn"]                        =  92,
    ["Abamath Ruins"]                       =  93,
    ["Shrine of Mauloch"]                   =  94,
    ["Shael Ruins"]                         =  95,
    ["Belarata"]                            =  96,
    ["Roots of Silvenar"]                   =  97,
    ["Ouze"]                                =  98,
    ["Baandari Trading Post"]               =  99,
    ["Roots of Treehenge"]                  = 100,
    ["Black Vine Ruins"]                    = 101,
    ["The Hunting Grounds"]                 = 102,
    ["Silver Throne Room"]                  = 103,

	--Reaper's March
    ["Reaper's March"]                      = 104,
    ["Vinedusk Village"]                    = 105,
    ["Khaj Rawlith"]                        = 106,
    ["Senalana"]                            = 107,
    ["Arenthia"]                            = 108,
    ["Greenhill Catacombs"]                 = 109,
    ["Thibaut's Cairn"]                     = 110,
    ["Halls of Ichor"]                      = 111,
    ["Rawl'kha"]                            = 112,
    ["Weeping Wind Cave"]                   = 113,
    ["Moonmont Temple"]                     = 114,
    ["Do'Krin Temple"]                      = 115,
    ["The Five Finger Dance"]               = 116,
    ["Claw's Strike"]                       = 117,
    ["S'ren-ja"]                            = 118,
    ["Jode's Light"]                        = 119,
    ["Kuna's Delve"]                        = 120,
    ["Ren-dro Caverns"]                     = 121,
    ["Fort Sphinxmoth"]                     = 122,
    ["Fardir's Folly"]                      = 123,
    ["Dune"]                                = 124,
    ["Temple of the Dance"]                 = 125,
    ["The Demi-Plane of Jode"]              = 126,
    ["The Wild Hunt"]                       = 127,
    ["Urcelmo's Betrayal"]                  = 128,
    ["Den of Lorkhaj"]                      = 129,
	
	-- Daggerfall Covenant
	-- Stros M'Kai
	["Port Hunding"]                        = 130,
	["The Grave"]                           = 131,
	["Stros M'Kai"]                         = 132,
	["Goblin Mines"]                        = 133,
	["Bthzark"]                             = 134,
	
	-- Betnikh
	["Stonetooth Fortress"]                 = 135,
	["Betnikh"]                             = 136,
	["Bloodthorn Lair"]                     = 137,
	["Carzog's Demise"]                     = 138,
	["Moriseli"]                            = 139,

	-- Glenumbra
	["Daggerfall"]                          = 140,
	["Glenumbra"]                           = 141,
	["Ilessan Tower"]                       = 142,
	["East Hut Portal Cave"]                = 143,
	["South Hut Portal Cave"]               = 144,
	["West Hut Portal Cave"]                = 145,
	["North Hut Portal Cave"]               = 146,
	["Silumm"]                              = 147,
	["Enduum"]                              = 148,
	["Dresan Keep"]                         = 149,
	["Aldcroft"]                            = 150,
	["Mines of Khuras"]                     = 151,
	["Camlorn Keep"]                        = 152,
	["Desolation's End"]                    = 153,
	["Ebon Crypt"]                          = 154,
	["Cath Bedraud"]                        = 155,
	["Angof's Sanctum"]                     = 156,
	["Tomb of Lost Kings"]                  = 157,
	["Cryptwatch Fort"]                     = 158,
	["Crosswych"]                           = 159,
	["Crosswych Mine"]                      = 160,
	
	-- Stormhaven	
	["Stormhaven"]                          = 161,
	["Koeglin Village"]                     = 162,
	["Alcaire Castle"]                      = 163,
	["Windridge Cave"]                      = 164,
	["Portdum Watch"]                       = 165,
	["Koeglin Mine"]                        = 166,
	["Pariah Catacombs"]                    = 167,
	["Wayrest"]                             = 168,
	["Farangel's Delve"]                    = 169,
	["Bearclaw Mine"]                       = 170,
	["Godrun's Dream"]                      = 171,
	["Norvulk Ruins"]                       = 172,
	["Aphren's Tomb"]                       = 173,
	["Emeric's Dream"]                      = 174,
	
	-- Rivenspire
	["Rivenspire"]                          = 175,
	["Shornhelm"]                           = 176,
	["Fevered Mews"]                        = 177,
	["Crestshade Mine"]                     = 178,
	["Doomcrag"]                            = 179,
	["Shadowfate Cavern"]                   = 180,
	["Hoarfrost Downs"]                     = 181,
	["Tribulation Crypt"]                   = 182,
	["Lorkrata Ruins"]                      = 183,
	["Edrald Undercroft"]                   = 184,
	["Flyleaf Catacombs"]                   = 185,
	["Northpoint"]                          = 186,
	["Breagha-Fin"]                         = 187,
	["Orc's Finger Ruins"]                  = 188,
	["Hildune's Secret Refuge"]             = 189,
	["Erokii Ruins"]                        = 190,
	["Shrouded Pass"]                       = 191,
	
    -- Alik'r Desert
	["Sentinel"]                            = 192,
	["Alik'r Desert"]                       = 193,
	["Shore Cave"]                          = 194,
	["Impervious Vault"]                    = 195,
	["Santaki"]                             = 196,
	["Salas En"]                            = 197,
	["Ash'abah Pass"]                       = 198,
	["Yokudan Palace"]                      = 199,
	["Divad's Chagrin Mine"]                = 200,
	["Bergama"]                             = 201,
	["Magistrate's Basement"]               = 202,
	["Aldunz"]                              = 203,
	["The Master's Crypt"]                  = 204,
	["Kulati Mines"]                        = 205,
	["Coldrock Diggings"]                   = 206,
	["Sandblown Mine"]                      = 207,
	["Yldzuun"]                             = 208,
	["Kozanset"]                            = 209,
	["Smuggler King's Tunnel"]              = 210,
	["Suturah's Crypt"]                     = 211,

	--Bangkorai
	["Evermore"]                            = 212,
	["Bangkorai"]                           = 213,
	["Bisnensel"]                           = 214,
	["Torog's Spite"]                       = 215,
	["Crypt of the Exiles"]                 = 216,
	["Troll's Toothpick"]                   = 217,
	["Nchu Duabthar Threshold"]             = 218,
	["Viridian Watch"]                      = 219,
	["Bangkorai Garrison"]                  = 220,
	["Sunken Road"]                         = 221,
	["Klathzgar"]                           = 222,
	["Rubble Butte"]                        = 223,
	["Nilata Ruins"]                        = 224,
	["Anexiel's Lair"]                      = 225,
	["Hallin's Stand"]                      = 226,
	["Onsi's Breath Mine"]                  = 227,
	["Hall of Heroes"]                      = 228,
	["The Far Shores"]                      = 229,
	
	-- Ebonheart Pact
	-- Bleakrock Isle
	["Bleakrock Village"]                   = 230,
	["Bleakrock Isle"]                      = 231,
	["Skyshroud Barrow"]                    = 232,
	["Hozzin's Folly"]                      = 233,
	["Orkey's Hollow"]                      = 234,
	["Last Rest"]                           = 235,
}

-----------------------------------------
-- HELPER FUNCTIONS
-----------------------------------------

function Data:CollectMapIds()
	local sv = ZGV.sv.profile
	sv.mapids = {}

	for i = 0,1000 do
		local loczone, _ = _G.GetZoneInfo(i)
		sv.mapids[loczone] = i
	end
end
