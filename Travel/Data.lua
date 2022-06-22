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
