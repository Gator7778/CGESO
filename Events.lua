--[[
	:AddEvent(EVENT,function() end)		- > Calls function
	:AddEvent(Event,"Name")				- > Calls Events:Name or CGV:Name
	:AddEvent(EVENT,table)				- > Calls table:EVENT
	:AddEvent(EVENT)					- > Calls Events:EVENT or CGV:EVENT
--]]

-----------------------------------------
-- LOCALIZED GLOBAL VARIABLES
-----------------------------------------

local CGV = _G.CGV
local Events = {}
local GuiRoot, uiTopLevelControl = _G.GuiRoot, _G.CT_TOPLEVELCONTROL
local eventFrame = CGV.WM:CreateControl("CGV_EventFrame",GuiRoot,uiTopLevelControl)
local tinsert, tremove, type, pairs, ipairs = table.insert, table.remove, type, pairs, ipairs

-----------------------------------------
-- SAVED REFERENCES
-----------------------------------------

CGV.Events = Events

-----------------------------------------
-- LOCAL FUNCTIONS
-----------------------------------------

-- Resolve EVENT_* name for a numeric code. The load-time _G scan can miss
-- entries on modern clients (huge _G), so we fill gaps on demand.
local function ResolveEventName(event)
	local name = rawget(Events.eventList, event)
	if name then return name end
	if type(event) ~= "number" then return nil end
	local safety = 0
	local index, val
	while true do
		local ok, k, v = pcall(next, _G, index)
		if not ok or k == nil then break end
		index = k
		if type(k) == "string" and type(v) == "number" and v == event and k:find("^EVENT_") then
			Events.eventList[event] = k
			Events.eventListR[k] = event
			return k
		end
		safety = safety + 1
		if safety > 100000 then break end
	end
	return nil
end

local function EventHandler(event,...)
	local self = Events
	if not self[event] then return end
	local eventString = ResolveEventName(event)
	if not eventString then
		-- Still dispatch bare function handlers; named/true handlers need a name.
		for _, hand in ipairs(self[event]) do
			if type(hand) == "function" then
				hand(self,event,...)
			end
		end
		return
	end

	for _, hand in ipairs(self[event]) do
		local func
		local funcSelf
		if type(hand) == "function" then
			func = hand
			funcSelf = self
		elseif type(hand) == "string" then
			func = self[hand] or CGV[hand]
			funcSelf = self[hand] and self or CGV
			assert(func,"No function "..hand.." in event handler!")
		elseif type(hand) == "table" then
			func = hand[eventString]
			funcSelf = hand
			assert(func,"No function "..eventString.." in provided table!")
		elseif hand == true then
			func = self[eventString] or CGV[eventString]
			funcSelf = self[eventString] and self or CGV
			assert(func,"No function "..eventString.." in event handler!")
		end
		func(funcSelf,event,...)
	end
end

-----------------------------------------
-- FUNCTIONS
-----------------------------------------

function Events:AddEvent(event,func)
	if not self[event] then
		self[event] = {}
	end

	-- Guarantee a name before we register — EventHandler needs it for `true` handlers.
	if not rawget(self.eventList, event) then
		ResolveEventName(event)
	end

	tinsert(self[event],func or true)
	if #self[event] == 1 then
		eventFrame:RegisterForEvent(event,EventHandler)
	end
end

function Events:RemoveEvent(event,removefunc)
	if not self[event] then return end

	for num,func in ipairs(self[event]) do
		if func == removefunc then
			tremove(self[event],num)

			if #self[event] == 0 then
				eventFrame:UnregisterForEvent(event)
			end
		end
	end
end

-----------------------------------------
-- EVENT FUNCTIONS
-----------------------------------------
-- state = true -> Enter Combat
-- state = false -> Exit Combat
-- https://i.imgur.com/TzfcjTA.png
function CGV:EVENT_PLAYER_COMBAT_STATE(_,state)
	if not state then
		if self.call_after_combat then
			self.call_after_combat()
			self.call_after_combat = nil
		end

	end
end

-- EVENT_ACHIEVEMENT_AWARDED (*string* _name_, *integer* _points_, *integer* _id_, *string* _link_)
function CGV.EVENT_ACHIEVEMENT_AWARDED(_,_,name,points,id,_)
	if (CGV.Creator) then
		CGV:Print("achieve %d", id)
		CGV:Print("|cd3d3d3(Name: %s)|r", name)
	end
end

-- EVENT_ACHIEVEMENT_UPDATED (*integer* _id_)
function CGV.EVENT_ACHIEVEMENT_UPDATED(_,_,id)
	local IgnoreAchievements = {
		[19] = "Treasure Chest Spotter",
		[20] = "Treasure Chest Seeker",
		[21] = "Treasure Chest Stalker",
		[22] = "Treasure Chest Hunter",
		[38] = "Humanoid Slayer",
		[39] = "Daedra Slayer",
		[40] = "Dwarven Construct Slayer",
		[41] = "Nature Slayer",
		[42] = "Undead Slayer",
		[52] = "Quester",
		[53] = "Explorer",
		[54] = "Adventurer",
		[55] = "Master Adventurer",
		[56] = "Indomitable Adventurer",
		[64] = "Apprentice Crafting Harvester",
		[65] = "Journeyman Crafting Harvester",
		[66] = "Expert Crafting Harvester",
		[67] = "Master Crafting Harvester",
		[68] = "Grand Master Crafting Harvester",
		[709] = "Dungeon Lord",
		[710] = "Dungeon Marauder",
		[711] = "Dungeon Annilhilator",
		[752] = "Greater Dungeon Healer",
		[753] = "Dungeon Blocker",
		[754] = "Greater Dungeon Blocker",
		[1019] = "Master Deconstructor",
		[1026] = "Recipe Card",
		[1027] = "Recipe Book",
		[1028] = "Recipe Book Compendium",
		[1148] = "Signed the Manifest",
		[1149] = "Writ Upon the Sky",
	}
	if not IgnoreAchievements[id] then
		if (CGV.Creator or CGV.DEV) then
			local name,desc,_,_,isCompleted,_,_ = _G.GetAchievementInfo(id)
			local isSkyshardAchievement,_ = string.find(name,"Skyshard")
			if (CGV.DEV) then
				CGV:Debug("|cd3d3d3Achievement Updated: %d:%s (isCompleted: %s)|r",id,name,tostring(isCompleted))
				CGV:Debug("|cd3d3d3- isSkyshardAchievement: %s|r", tostring(isSkyshardAchievement))
				CGV:Debug("|cd3d3d3- desc: %s|r", desc)
			end
			if (isCompleted) then
				CGV:Print("achieve %d", id)
				CGV:Print("|cd3d3d3(Name: %s)|r", name)
			else
				local numCriteria = _G.GetAchievementNumCriteria(id)
				if (CGV.DEV) then
					CGV:Debug("|cd3d3d3- numCriteria: %d|r", numCriteria)
				end
					local progress = _G.GetAchievementProgress(id)
				if (isSkyshardAchievement) then
					CGV:Print("Use Skyshard ||achieve %d/#",id)
					CGV:Print("|cffff99- Chose a number below for # above:|r")
					for i = 1, numCriteria do
						local criterionDesc,numCompleted,numRequired = _G.GetAchievementCriterion(id,i)
						if (CGV.DEV) then
							CGV:Debug("|cffff99- # = %d :: %s (Completed: %d/%d)|r", i, criterionDesc, numCompleted, numRequired)
						else
							if (numCompleted == numRequired) then
								CGV:Print("|cffff99- # = %d :: %s|r", i, criterionDesc)		
							end
						end
					end
				else
					for i = 1, numCriteria do
						local criterionDesc,numCompleted,numRequired = _G.GetAchievementCriterion(id,i)
						if (CGV.DEV) then
							CGV:Debug("|cd3d3d3- Criterion.%d: %s (%d/%d)|r", i, criterionDesc, numCompleted, numRequired)
						end
					end
				end
			end
		end
	end
end

-- EVENT_LORE_BOOK_LEARNED (*luaindex* _categoryIndex_, *luaindex* _collectionIndex_, *luaindex* _bookIndex_, *luaindex* _guildIndex_, *bool* _isMaxRank_)
function CGV.EVENT_LORE_BOOK_LEARNED(_,_,cat,col,book,guild,isMaxRank)
	if (CGV.Creator) then
		local title,_,_,_ = _G.GetLoreBookInfo(cat,col,book)
		CGV:Print("lorebook %s/%d/%d/%d",title,cat,col,book)
	end
end

-----------------------------------------
-- STARTUP
-----------------------------------------

tinsert(CGV.startups,function(self)
		local EVENT_PLAYER_COMBAT_STATE = _G.EVENT_PLAYER_COMBAT_STATE
		Events:AddEvent(EVENT_PLAYER_COMBAT_STATE)
	end)
tinsert(CGV.startups,function(self)
	local EVENT_ACHIEVEMENT_AWARDED = _G.EVENT_ACHIEVEMENT_AWARDED
	Events:AddEvent(EVENT_ACHIEVEMENT_AWARDED)
end)
tinsert(CGV.startups,function(self)
	local EVENT_ACHIEVEMENT_UPDATED = _G.EVENT_ACHIEVEMENT_UPDATED
	Events:AddEvent(EVENT_ACHIEVEMENT_UPDATED)
end)
tinsert(CGV.startups,function(self)
	local EVENT_LORE_BOOK_LEARNED = _G.EVENT_LORE_BOOK_LEARNED
	Events:AddEvent(EVENT_LORE_BOOK_LEARNED)
end)

-----------------------------------------
-- EVENT LIST  - now dynamic.
-----------------------------------------
local safenext = function(table,index)
	local ok,k,v = pcall(next,table,index)
	if ok then
		return k,v
	else
		-- when pcall fails, it gives an error message. The failing index will be there!
		local newk = k:match(" function '(.-)'")
		if newk then
			return newk,"PROT/PRIV"
		else
			-- sad failure
		end
	end  -- k has the error message, important
end

local globalprefixes = function(prefix)
	local safeglobalnext = function(_,index)
		local val
		local safety = 0
		repeat
			index,val = safenext(_G,index)
			if index and index:find("^"..prefix) then
				return index,val
			end
			safety = safety + 1
			-- ESO's _G has grown well past the old 20k cap; missing names
			-- caused EventHandler asserts (e.g. EVENT_PLAYER_ACTIVATED).
			if safety > 100000 then
				return "ERR","ERR"
			end
		until not index
	end
	return safeglobalnext,_G,nil
end

Events.eventList = {}

for k,v in globalprefixes("EVENT_") do
	if type(v) == "number" and k ~= "EVENT_GLOBAL_MOUSE_DOWN" and k ~= "EVENT_GLOBAL_MOUSE_UP" then
		Events.eventList[v] = k
	end
end

-- Seed any critical codes the scan still missed (AddEvent also backfills).
do
	local critical = {
		"EVENT_PLAYER_ACTIVATED",
		"EVENT_ADD_ON_LOADED",
		"EVENT_PLAYER_COMBAT_STATE",
		"EVENT_ACHIEVEMENT_AWARDED",
		"EVENT_ACHIEVEMENT_UPDATED",
		"EVENT_LORE_BOOK_LEARNED",
		"EVENT_QUEST_ADDED",
		"EVENT_QUEST_REMOVED",
		"EVENT_QUEST_ADVANCED",
		"EVENT_QUEST_CONDITION_COUNTER_CHANGED",
		"EVENT_QUEST_POSITION_REQUEST_COMPLETE",
		"EVENT_QUEST_LIST_UPDATED",
		"EVENT_ACTION_LAYER_POPPED",
		"EVENT_ACTION_LAYER_PUSHED",
		"EVENT_GAME_FOCUS_CHANGED",
		"EVENT_SCREEN_RESIZED",
	}
	for _, name in ipairs(critical) do
		local code = _G[name]
		if type(code) == "number" and not rawget(Events.eventList, code) then
			Events.eventList[code] = name
		end
	end
end

Events.eventListR = {}

for k,v in pairs(Events.eventList) do
	Events.eventListR[v] = k
end