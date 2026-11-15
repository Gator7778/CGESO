-----------------------------------------
-- INFORMATION
-- Guide events and actions (e.g. "goto")
-----------------------------------------

-----------------------------------------
-- LOCALIZED GLOBAL VARIABLES
-----------------------------------------

local CGV = _G.CGV
local GetCurrentMapIndex = _G.GetCurrentMapIndex
local GuideViewer = _G.GuideViewer
local GetNumPOIs = _G.GetNumPOIs
local IsPOIWayshrine = _G.IsPOIWayshrine
local GetPOIInfo = _G.GetPOIInfo
local zo_plainstrfind = _G.zo_plainstrfind
local GetPOIMapInfo = _G.GetPOIMapInfo
local GetMapPlayerPosition = _G.GetMapPlayerPosition
local MAP_PIN_TYPE_POI_COMPLETE = _G.MAP_PIN_TYPE_POI_COMPLETE
local GetLoreBookInfo = _G.GetLoreBookInfo
local GetAchievementInfo = _G.GetAchievementInfo
local GetAchievementCriterion = _G.GetAchievementCriterion
local zo_loadstring = _G.zo_loadstring
local zo_max = _G.zo_max
local GoalProto = {}
local Goal = CGV.Class:New("Goal")
local GoalProto_mt = { __index=Goal }
local GOALTYPES = {}
local empty_table = {}
local tinsert, min, type, ipairs = table.insert, math.min, type, ipairs
local L = CGV.L
local split = _G.zo_strsplit

-- Parser functions
local ParseMapXYDist = CGV.Parser.ParseMapXYDist
local MakeCondition = CGV.Parser.MakeCondition
local ParseQuest = CGV.Parser.ParseQuest
local ParseId = CGV.Parser.ParseId

local INDENT = ""

-----------------------------------------
-- SAVED REFERENCES
-----------------------------------------

CGV.GoalProto = GoalProto
CGV.GOALTYPES = GOALTYPES

-----------------------------------------
-- LOAD TIME SETUP
-----------------------------------------

setmetatable( GOALTYPES, { __index = function() return empty_table end } )

-----------------------------------------
-- LOCAL FUNCTIONS
-----------------------------------------

local function COLOR_LOC(s)			return "|cffee77"..tostring(s).."|r" end
local function COLOR_COUNT(s)		return "|cffffcc"..tostring(s).."|r" end
local function COLOR_ITEM(s)		return "|caaeeff"..tostring(s).."|r" end
local function COLOR_QUEST(s)		return "|ceebbff"..tostring(s).."|r" end
local function COLOR_NPC(s)			return "|caaffaa"..tostring(s).."|r" end
local function COLOR_TIP(s)			return "|ceeeecc"..tostring(s).."|r" end

-- Brace helpers for nested {cond??a::b} / {expr} in goal text.
local function MatchBrace(s, open)
	local depth = 0
	for i = open, #s do
		local ch = s:byte(i)
		if ch == 123 then -- {
			depth = depth + 1
		elseif ch == 125 then -- }
			depth = depth - 1
			if depth == 0 then return i end
		end
	end
end

local function FindTopLevel(s, token, start)
	local depth = 0
	local tlen = #token
	local i = start or 1
	while i <= #s do
		local ch = s:byte(i)
		if ch == 123 then
			depth = depth + 1
			i = i + 1
		elseif ch == 125 then
			depth = depth - 1
			i = i + 1
		elseif depth == 0 and s:sub(i, i + tlen - 1) == token then
			return i
		else
			i = i + 1
		end
	end
end

-----------------------------------------
-- GOALHANDLERS
-----------------------------------------
-- Pretty much Goal Types, but not exactly.

GOALTYPES['only'] = {  -- |only, |only if
	parse = function(self,params,step,data)
		local chunkcount = data.chunkcount

		local cond = params:match("^if%s+(.*)$")
		if cond then
			-- condition match and is a |only if
			local subject = chunkcount == 1 and step or self -- If this is the first chunk for this line, then it is a |only if for a step.

			local fun,err = MakeCondition(cond,true)
			if not fun then return err end

			subject.condition_visible_raw = cond
			subject.condition_visible = fun

			return false,"cancel goal"
		else
			self.requirement = params
		end
	end,
}

GOALTYPES['complete'] = {
	parse = function(self,params)
		--local chunkcount = data.chunkcount

		local cond = params:match("^if%s+(.*)$")
		if cond then
			-- condition match and is a |only if
			local subject = self -- If this is the first chunk for this line, then it is a |only if for a step.

			local fun,err = MakeCondition(cond,true)
			if not fun then return err end

			subject.condition_complete_raw = cond
			subject.condition_complete = fun
		else
			CGV:Error("||complete needs 'if'. because.")
			self.action = nil -- rip in peace goal. wipe out because this is a command for steps.
		end
	end,
}

GOALTYPES['next'] = {
	parse = function(self,params)
		params = params:gsub("^\"(.-)\"$","%1")
		if params == "" then
			params = "+1"
		end
		self.next = params
	end,
}

GOALTYPES['nextreload'] = {
	parse = function(self,params)
		params = params:gsub("^\"(.-)\"$","%1")
		if params == "" then
			params = "+1"
		end
		self.nextreload = params
	end,
}

GOALTYPES['sticky'] = {
	parse = function(self)
		self.sticky = true
	end,
}

GOALTYPES['n'] = {
	parse = function(self)
		self.force_nocomplete = true
	end,
}

GOALTYPES['c'] = {
	parse = function(self)
		self.force_complete = true
	end,
}

GOALTYPES['sub'] = {
	parse = function(self)
		self.subgoal = true  -- obsolete! do not use!
	end,
}

GOALTYPES['opt'] = {
	parse = function(self)
		self.optional = true
	end,
}

GOALTYPES['future'] = {
	parse = function(self)
		self.future = true
	end,
}

GOALTYPES['noway'] = {
	parse = function(self)
		self.force_noway = true
	end,
}

GOALTYPES['or'] = {
	parse = function(self,params)
		self.orlogic = params and tonumber(params) or 1
	end,
}

GOALTYPES['override'] = {
	parse = function(self)
		self.override = true
	end,
}

GOALTYPES['tip'] = {
	parse = function(self,params)
		self.tooltip = params
	end,
}

GOALTYPES['q'] = {
	parse = function(self,params)
		self.quest, self.questcondtxt = ParseQuest(params)
		if not self.quest then return "no quest in parameter" end
	end,
}

GOALTYPES['_item'] = {
	parse = function(self,params)
		local count,objinfo,objid
		local obj = ""

		-- 4 Itemname##id
		count,objinfo = params:match("^([0-9]*)%s*(.*)$")
		if not count then
			objinfo = params
		end

		local function parse(str)
			-- check for plural
			local name,plural = str:match("^(.+)(%+)$")
			if plural then
				str = name
			end

			local tar, tarid = ParseId(str)

			if plural and tar then
				tar = GuideViewer("Specials").plural(tar)
			end

			return tar,tarid
		end

		self.count = tonumber(count) or 0

		local mult = {split(",",objinfo)}
		if #mult > 1 then
			local targets = {}
			self.targets = targets
			for i,info in ipairs(mult) do
				-- Name##Id are split, parse each individually and then put it in the targets table.
				local tar,tarid = parse(info)
				tinsert(targets,{tar,tarid})
				objid = objid or tarid	-- Multi-target goals only keep the first target id in objid.
				if tar then
					obj = obj .. tar .. (i<#mult and ", " or "")	-- Append the target name to the obj, if not the last one then include a ,
				end
			end
		else
			obj, objid = parse(objinfo)
		end

		-- now object##id
		self.target,self.targetid = obj,objid

		-- something missing?
		if not self.targetid and not self.target then
			return "no parameter"
		end
	end
}

GOALTYPES['count'] = {
	parse = function(self,params)
		self.count = tonumber(params)
	end
}
-----------------------------------------
-- GOALTYPES
-----------------------------------------

GOALTYPES['goto'] = {
	parse = function(self,params,step,data) -- Called on the game's initial load
		local prevmap = data.prevmap
		local params2,title = params:match('^(.-)%s*"(.*)"')
		if title then
			params = params2
		end

		local map,x,y,dist,err = ParseMapXYDist(params)
		if err then
			return err
		end

		self.map = (map or self.map or step.map or prevmap)
		if not self.map then
			return "'".. (self.action or "?") .."' has no map parameter, neither has one been given before."
		end

		self.x = x or self.x
		self.y = y or self.y

		-- Adjusting the speed between zone maps and non-zone maps
		self.dist = CGV.Utils.DistanceOffsetForGoto(dist,self.dist)

		self.waytitle = title
	end,
	iscompletable = function(self) -- Called repeatedly

		local step = self.parentStep
		local all_gotos = true

		for _,goal in ipairs(step.goals) do
			if goal.action ~= "goto" -- A non-goto step or a goto step that is force_complete
			or goal.force_complete then
				all_gotos = false
				break
			end
		end

		return (self.force_complete or all_gotos) -- If the goto has a |c then it is completable. Or if there are only gotos present in this step.
	end,
	iscomplete = function(self) -- Called repeatedly

		self.dist = CGV.Utils.DistanceOffsetForIsComplete()

		local dist = CGV.Pointer:GetDistToCoords(self.map,self.x,self.y)

		if self.dist and (
			( self.dist > 0 and dist < self.dist ) or
			( self.dist < 0 and dist > self.dist )
			) then
			return true,true
		end

		return false,true
	end,
}

GOALTYPES['buy'] = 			GOALTYPES['collect']
GOALTYPES['gather'] = 		GOALTYPES['collect']
GOALTYPES['collect'] = 		{ parse = GOALTYPES['_item'].parse, }
GOALTYPES['kill'] = 		{ parse = GOALTYPES['_item'].parse, }
GOALTYPES['wayshrine'] = 	{ parse = function(self,params,_,_)

								local mapid, map = string.match(params,"([^/]+)/([^/]+)")

								if tonumber(mapid) then
									self.wayshrine_zoneid = tonumber(mapid)
									self.wayshrine = map
								elseif mapid then -- string
									self.wayshrine_zoneid = CGV.Pointer.Zones[mapid] and CGV.Pointer.Zones[mapid].id
									self.wayshrine = map
								else
									self.wayshrine = params
								end
								-- Guide lines are "wayshrine Rampart Camp" — strip a trailing
								-- " Wayshrine" so we don't search/display "… Wayshrine Wayshrine".
								if self.wayshrine then
									self.wayshrine = tostring(self.wayshrine)
										:gsub("%s+[Ww]ayshrine%s*$", "")
										:match("^%s*(.-)%s*$")
								end
							end,

							iscomplete = function(self)

							-- Retry lookup if we never found a POI (0) or timed out.
							local needSearch = not self.wayshrine_POIIndex
								or self.wayshrine_POIIndex == 0
							local now = _G.GetFrameTimeSeconds and _G.GetFrameTimeSeconds()
							if needSearch and self._wayshrine_next_try and now
								and now < self._wayshrine_next_try then
								needSearch = false
							end

							if needSearch then
								self.wayshrine_POIIndex = nil

								local function NormalizePOIName(s)
									s = tostring(s or "")
										:gsub("|c%x%x%x%x%x%x", "")
										:gsub("|r", "")
										:gsub("%s+[Ww]ayshrine%s*$", "")
										:match("^%s*(.-)%s*$") or ""
									return s:lower()
								end

								local want = NormalizePOIName(self.wayshrine)
								local function NameMatches(poiText)
									local got = NormalizePOIName(poiText)
									if got == "" or want == "" then return false end
									-- Exact, or either side is a prefix (Rampart Camp ↔ Rampart Camp Wayshrine).
									if got == want then return true end
									if got:sub(1, #want) == want then return true end
									if want:sub(1, #got) == got then return true end
									local fb, fi = zo_plainstrfind(poiText, self.wayshrine)
									return fb and fi == 1
								end

								local function TryZone(zid)
									if not zid or zid <= 0 then return end
									local num = GetNumPOIs(zid)
									if not num or num < 1 then return end
									for i = 1, num do
										-- Some zones (e.g. Solstice) omit IsPOIWayshrine — accept exact
										-- name match, or flag/name containing "wayshrine".
										local text = GetPOIInfo(zid, i)
										if text and text ~= "" and NameMatches(text) then
											local flagged = IsPOIWayshrine(zid, i)
												or tostring(text):lower():find("wayshrine", 1, true)
											local exact = NormalizePOIName(text) == want
											if flagged or exact then
												self.wayshrine_zoneid = zid
												self.wayshrine_POIIndex = i
												if CGV.db.profile.debug_wayshrines then
													CGV:Debug("Found wayshrine '%s' zone %d POI %d (%s).",
														self.wayshrine, zid, i, text)
												end
												return true
											end
										end
									end
								end

								-- Prefer the player's current zone index first (correct for Solstice).
								local curZ = _G.GetCurrentMapZoneIndex and _G.GetCurrentMapZoneIndex()
								if TryZone(curZ) then
									-- found
								elseif self.wayshrine_zoneid and TryZone(self.wayshrine_zoneid) then
									-- found via explicit id
								else
									-- Fallback: scan a reasonable zone-index range (not 1..999 every tick).
									for zid = 1, 2000 do
										if zid ~= curZ and zid ~= self.wayshrine_zoneid then
											if TryZone(zid) then break end
										end
									end
								end

								if not self.wayshrine_POIIndex then
									CGV:Debug("Wayshrine '%s' not found (will retry).", tostring(self.wayshrine))
									self.wayshrine_POIIndex = 0
									-- Retry in a few seconds instead of locking forever.
									if _G.GetFrameTimeSeconds then
										self._wayshrine_next_try = _G.GetFrameTimeSeconds() + 5
									end
								end
							end

							if not self.wayshrine_zoneid or not self.wayshrine_POIIndex or self.wayshrine_POIIndex == 0 then
								return false, false
							end

							local poiX,poiY,typ,_ = GetPOIMapInfo( self.wayshrine_zoneid, self.wayshrine_POIIndex, true ) --true=truthful call! don't be fooled by our own Pointer.lua and its foglight!

							if typ == MAP_PIN_TYPE_POI_COMPLETE then
								return true,true
							end

							-- Nearby assist: standing on the matching shrine completes even if pin lag.
							local nearOn = not (CGV.db and CGV.db.profile and CGV.db.profile.wayshrine_nearby == false)
							if nearOn and poiX and poiY and GetMapPlayerPosition then
								local px, py = GetMapPlayerPosition("player")
								if px and py then
									local dx, dy = px - poiX, py - poiY
									if (dx * dx + dy * dy) <= (0.018 * 0.018) then
										return true, true
									end
								end
							end

							return false,self.wayshrine_POIIndex > 0
						end,
						}

GOALTYPES['learnskill'] = {
	parse = function(self,params)
		self.skillname = params
	end,
}

GOALTYPES['Use'] = {
	parse = GOALTYPES['_item'].parse,
}

GOALTYPES['Examine'] = {
	parse = GOALTYPES['_item'].parse,
}

GOALTYPES['accept'] = {
	parse = function(self,params)
		if not params then
			return "no quest parameter"
		end
		self.quest = ParseId(params)  -- legacy. Get rid of the ID.

		if not self.quest then
			return "no quest parameter"
		end
	end,
	iscomplete = function(self)
		return (CGV.Quests:HasQuest(self.quest) or CGV.Quests:IsQuestComplete(self.quest)) , true
	end,
}

GOALTYPES['turnin'] = {
	parse = GOALTYPES['accept'].parse,
	iscomplete = function(self)
		local completed = CGV.Quests:IsQuestComplete(self.quest)
		local hasQuest = CGV.Quests:HasQuest(self.quest)
		return completed,hasQuest
	end,
}

GOALTYPES['talk'] = {
	parse = function(self,params)
		self.npc,self.npcid = ParseId(params)
		if not self.npc and not self.npcid then
			return "no npc"
		end
	end,
}

GOALTYPES['equip'] = {
	parse = GOALTYPES['_item'].parse,
}

GOALTYPES['confirm'] = {
	parse = function(self,params)
		self.action = self.action or "confirm"
		self.always = (params == "always")
	end,
	iscomplete = function(self)
		local complete = not not self.clicked
		return complete,true
	end,
	onclick = function(self)
		-- Confirm hyperlink: mark clicked, then switch guides live (no ReloadUI).
		self.clicked = true
		if self.nextreload then
			local raw = self.nextreload
			local title = CGV:SanitizeGuideTitle(raw)
			-- Remember Full vs MQO when the player picks from a fork (e.g. end of Wailing Prison).
			if CGV.SetGuideStylePreference then
				if title:find("Main Quests Only", 1, true) then
					CGV:SetGuideStylePreference("mqo")
				elseif tostring(raw):find("Leveling Guides", 1, true)
					or (title:match("^LEVELING/")
						and not title:find("Cyrodiil", 1, true)
						and not title:find("Wailing Prison", 1, true)) then
					CGV:SetGuideStylePreference("full")
				end
			end
			CGV:SetGuide(title, 1)
			return true -- halt auto next-step; SetGuide already loaded the guide
		end
	end,
}

GOALTYPES['lorebook'] = {
	parse = function(self,params,_,_)
		if not params then
			return "no lorebook parameter"
		end
		local _,cat,col,book = params:match("^(.-)(%d+)/(%d+)/(%d+)$")
		self.lorebook_cat = tonumber(cat)
		self.lorebook_col = tonumber(col)
		self.lorebook_book = tonumber(book)

		if not self.lorebook_book then
			return "no lorebook cat/col/book parameter"
		end
	end,
	iscomplete = function(self)
		local _,_,known = GetLoreBookInfo(self.lorebook_cat,self.lorebook_col,self.lorebook_book)
		return known , true
	end,
	gettext = function(self)
		local title = GetLoreBookInfo(self.lorebook_cat,self.lorebook_col,self.lorebook_book)
		return L['stepgoal_lorebook']:format(title)
	end
}

GOALTYPES['achieve'] = {
	parse = function(self,params)
		if not params then
			return "no achieve parameter"
		end
		self.achieve_id,self.achieve_crit = params:match("(%d+)/(%d+)$")
		if not self.achieve_crit then
			self.achieve_id = params:match("(%d+)$")
		end
		self.achieve_id = tonumber(self.achieve_id)
		self.achieve_crit = tonumber(self.achieve_crit)
		if not self.achieve_id then
			return "no achieve id"
		end
	end,
	iscomplete = function(self,override_achieve_id,override_achieve_crit)
		local _,_,_,_,isCompleted,_,_ = GetAchievementInfo(override_achieve_id or self.achieve_id)
		if isCompleted or not (override_achieve_crit or self.achieve_crit) then
			return isCompleted , true
		else
			local _,numcom,numreq = GetAchievementCriterion(override_achieve_id or self.achieve_id,override_achieve_crit or self.achieve_crit)
			return numcom == numreq, true, (numcom/zo_max(1,(numreq or 1)))
		end
	end,
	gettext = function(self)
		local name
		if not self.achieve_crit then
			name = GetAchievementInfo(self.achieve_id)
		else
			name = GetAchievementCriterion(self.achieve_id,self.achieve_crit)
		end
		return L['stepgoal_achieve']:format(name)
	end
}

GOALTYPES['ding'] = {
	parse = function(self,params)
		self.dinglevel = tonumber(params)
	end,
	iscomplete = function(self)
		return CGV.Utils.GetPlayerPreciseLevel()>=self.dinglevel,true
	end,
}

GOALTYPES['text'] = {
	parse = function(self,params)
		-- highlight _text_
		params = params:gsub("_(.-)_","|cffee88%1|r")
		self.text = params
	end,
}


-----------------------------------------
-- GUIDEPROTO FUNCTIONS
-----------------------------------------

function GoalProto:New()
	local goal = {}

	setmetatable(goal,GoalProto_mt)
	return goal
end

-----------------------------------------
-- GOAL CLASS FUNCTIONS
-----------------------------------------

function Goal:GetQuest()
	if not self.quest then return end
	return CGV.Quests:GetQuest(self.quest)
end

function Goal:GetQuestGoalStatus()
	if not self.quest then
		return false,"no quest"
	end
	return CGV.Quests:GetCompletionStatus(self.quest,self.questcondtxt)
end

function Goal:GetQuestGoalCounts()
	local _,_,expl,curv,maxv,_ = self:GetQuestGoalStatus()

	if expl ~= "cond completion" then return end
	if not curv then return end

	local goalcountnow,goalcountneeded,remaining

	goalcountnow = curv or 0
	goalcountneeded = min(self.count or 9999,maxv or 9999)	-- If limit is < maxvalue then prefer that to allow guide to dictate only collecting a certain number in a single area.
	remaining = goalcountneeded-goalcountnow

	if remaining <= 0 then
		remaining = goalcountneeded
	end
	if goalcountneeded == 1 then
		remaining = nil
	end	-- If we only need 1 then don't need to explictly show a number. Nil this out to not show a num

	return goalcountnow,goalcountneeded,remaining
end

function Goal:GetText()
	local GOALTYPE = GOALTYPES[self.action]
	local text = "?"
	local progtext
	local _done
	local complete,ext
	local goalcountnow,goalcountneeded,remaining
	local base, data

	if self.quest then	-- Is there a quest to go with this step?
		goalcountnow,goalcountneeded,remaining = self:GetQuestGoalCounts()
	end

	complete,ext = self:IsComplete()

	_done = complete and "_done" or ""

	if self.text then
		-- Scriptable goal text: {expr} and nested {cond??true::false}.
		-- Brace matching (not [^}]- gsub) so inner ternaries work.
		if not self.textsubs then
			self.textsubs = {}
		end
		local textsubs = self.textsubs
		local guide = self.parentStep and self.parentStep.parentGuide
		local step = self.parentStep

		local function cache_get(key, builder)
			local f = textsubs[key]
			if f == nil then
				f = builder()
				textsubs[key] = f
			end
			return f
		end

		local function run_cached(f)
			if type(f) == "function" then
				CGV.Parser.ConditionEnv._SetLocal(guide, step, self)
				return tostring(f())
			end
			return tostring(f)
		end

		local expand

		local function eval_brace(content)
			local qpos = FindTopLevel(content, "??", 1)
			local cpos = qpos and FindTopLevel(content, "::", qpos + 2)
			if qpos and cpos then
				local condcode = content:sub(1, qpos - 1)
				local a = content:sub(qpos + 2, cpos - 1)
				local b = content:sub(cpos + 2)
				local f = cache_get("T:" .. content, function()
					local condfun, err = zo_loadstring(condcode:find("return") and condcode or "return " .. condcode)
					if not condfun then
						return "(" .. tostring(err) .. ")"
					end
					setfenv(condfun, CGV.Parser.ConditionEnv)
					return function()
						CGV.Parser.ConditionEnv._SetLocal(guide, step, self)
						if condfun() then
							return expand(a)
						else
							return expand(b)
						end
					end
				end)
				return run_cached(f)
			end

			local f = cache_get("S:" .. content, function()
				local fun, err = zo_loadstring(content:find("return") and content or "return " .. content)
				if fun then
					setfenv(fun, CGV.Parser.ConditionEnv)
					return fun
				end
				return "(" .. tostring(err) .. ")"
			end)
			return run_cached(f)
		end

		expand = function(s)
			local out = {}
			local i = 1
			local len = #s
			while i <= len do
				local open = s:find("{", i, true)
				if not open then
					out[#out + 1] = s:sub(i)
					break
				end
				if open > i then
					out[#out + 1] = s:sub(i, open - 1)
				end
				local close = MatchBrace(s, open)
				if not close then
					out[#out + 1] = s:sub(open)
					break
				end
				out[#out + 1] = eval_brace(s:sub(open + 1, close - 1))
				i = close + 1
			end
			return table.concat(out)
		end

		text = expand(self.text):gsub("#(%d+)#", COLOR_COUNT(remaining))

	elseif self.action == "tip" then
		text = self.tooltip

	elseif self.action == "accept" then
		base = L["stepgoal_accept".._done]
		data = COLOR_QUEST(L["questtitle"]:format(self.quest or "?quest?"))

	elseif self.action == "turnin" then
		base = L["stepgoal_turnin".._done]
		data = COLOR_QUEST(L["questtitle"]:format(self.quest or "?quest?"))

	elseif self.action == "talk" then
		base = L["stepgoal_talk".._done]
		data = COLOR_NPC(self.npc)

	elseif self.action == "kill" then
		base = L["stepgoal_kill".._done]
		data = COLOR_NPC(self.target)

	elseif self.action == "confirm" then
		text = L["stepgoal_confirm"]

	elseif self.action == "wayshrine" then
		base = L["stepgoal_wayshrine".._done]
		data = COLOR_NPC(self.wayshrine)

	elseif self.action == "goto" then
		local curZone = _G.GetMapName()
		local mapname = CGV.Pointer.Zones[self.map] and CGV.Pointer.Zones[self.map].name or self.map or curZone.."(?)"

		if mapname ~= curZone then
			if self.x and self.y then -- different map
				text = COLOR_LOC(L['map_coords']:format(CGV.Utils.Delocalize(mapname),self.x * 100,self.y * 100)) -- and coords
			else
				text = COLOR_LOC(CGV.Utils.Delocalize(mapname))	-- just the map
			end
		else
			if self.x and self.y then
				text = COLOR_LOC(L['coords']:format(self.x*100,self.y * 100)) -- same map
			else
				text = COLOR_LOC(CGV.Utils.Delocalize(mapname))	-- just the map
			end
		end
		if self.waytitle then
			text = self.waytitle.." ("..text..")"
		end
		text = ( L["stepgoal_goto"]):format( text )
	end

	if base and data then
		local num = remaining or self.count
		if num and num > 1 then
			data = num .. " " .. data
		end
		text = base:format(data)
	end

	if text == "?" and GOALTYPE.gettext then
		text = GOALTYPE.gettext(self)
	end

	if text == "?" and L["stepgoal_"..self.action] then  -- fallback: just plain text in L
		text = L["stepgoal_"..self.action]
	end

	-- Add the indent!
	local indent = INDENT:rep(self.indent or 0)
	text = text and indent..text

	-- apply the (2/4) totals now, or not
	if goalcountnow and goalcountneeded and goalcountneeded>0 then
		progtext=L["completion_goal"]:format(goalcountnow,goalcountneeded)
	end

	if progtext then
		local col1,col2

		if complete then
			col1,col2 = "",""
		elseif ext then
			col1,col2 = " |cffbbbb","|r"
		else
			col1,col2 = " |caaaaaa","|r"
		end

		text = text .. col1 .. progtext .. col2
	end

	return text
end

function Goal:tostring()
	return self:GetText()
end

function Goal:GetTipText()
	if not self.tooltip then return end
	local indent = INDENT:rep(self.indent or 0)
	local text = indent..COLOR_TIP(self.tooltip)

	return text
end

function Goal:IsVisible()
	if self.hidden then return false end
	if self.condition_visible then
		if self.condition_visible_raw == "default" then
			-- oo, special case: show this only if no others are visible!
			for _,goal in ipairs(self.parentStep.goals) do
				if goal ~= self and goal.condition_visible and goal:IsVisible() then return false end
			end
			return true
		else
			CGV.Parser.ConditionEnv._SetLocal(self.parentStep.parentGuide,self.parentStep,self)
			local ok,ret = pcall(self.condition_visible)
			if ok then
				return ret
			else
				CGV:Error("Error in step %s, goal %s, only if %s: %s", self.parentStep.num, self.num, self.condition_visible_raw or "", ret:gsub("\n.*",""))
			end
		end
	end
	if self.requirement then
		return CGV.Utils.RaceClassMatch(self.requirement)
	end
	return true
end

-- returns: true = complete, false = incomplete
-- second return: true = completable, false = incompletable
function Goal:IsComplete()
	-- is now a wrapper for sticky reasons.
	if self.sticky_complete then
		return true,true
	end
	local iscomplete,ispossible,v1,v2,v3 = self:IsCompleteCheck()
	if iscomplete and self.sticky then
		self.sticky_complete=true
	end
	if self:IsCompletable() then
		if iscomplete and not self.was_complete then
			self:OnComplete()
		elseif not iscomplete and self.was_complete then
			self:OnDiscomplete()
		end
		self.was_complete=iscomplete
	end

	if self.map then
		self:CheckVisited()
	end

	return iscomplete,ispossible,v1,v2,v3
end

function Goal:OnComplete()
	if self.parentStep.current_waypoint_goal == self.num then
		CGV.Pointer:CycleWaypoint(1,"no cycle")
	end
end

function Goal:OnDiscomplete()
end

function Goal:CheckVisited()
	if self.map then
		if self.status == "incomplete" then return end
		local isvisited = GOALTYPES['goto'].iscomplete(self)  -- "test as if it's a goto step"
		if isvisited and not self.was_visited then
			self:OnVisited()
		elseif not isvisited and self.was_visited then
			self:OnDevisited()
		end
		self.was_visited=isvisited
	end
end

function Goal:OnVisited()
	self.parentStep.current_waypoint_goal = self.num
	CGV.Pointer:CycleWaypoint(1,"no cycle")
end

function Goal:OnDevisited()
end

function Goal:IsCompleteCheck()
	-- If the quest is complete then all related goals are complete.
	local iscomplete,ispossible,explanation,curv,maxv,debugs

	if self.condition_complete then
		CGV.Parser.ConditionEnv._SetLocal(self.parentStep.parentGuide, self.parentStep, self)
		local ok,iscomplete = pcall(self.condition_complete)
		if ok then
			if iscomplete then
				return true,true
			else
				-- fall through!
			end
		else
			CGV:Error("Error in step %s, goal %s, complete if %s: %s", self.parentStep.num, self.num, self.condition_complete_raw or "", iscomplete:gsub("\n.*",""))
		end
	end

	if self.quest and self.action~="accept" and self.action~="turnin" then  -- let accept goals complete on their own
		repeat
			CGV:Debug("&goal completing..............")
			iscomplete,ispossible,explanation,curv,maxv,debugs = CGV.Quests:GetCompletionStatus(self.quest, self.questcondtxt)
			CGV:Debug("&goal completion: complete:|cffffff%s|r, possible:|cffffff%s|r, why:|cffffff%s|r ... match: |cffaaee%s|r",tostring(iscomplete),tostring(ispossible),tostring(explanation),tostring(debugs))

			local _ = CGV.Quests:GetQuest(self.quest)

			if iscomplete then

				-- complete means complete, leave it at that!
				if explanation == "quest complete"
					or explanation == "quest POI complete"
					or explanation == "past stage"
					or explanation == "cond recently completed" then
					return "past",true
				end
				return true,true,self.count and 1

			elseif false and explanation == "step END" and self.optstep then
				return true,true

			elseif false and explanation == "future stage" then
				if self.future then break end  -- fall through
				return false,false

			elseif explanation == "not in journal" then
				if self.future and GOALTYPES[self.action].iscomplete then break end  -- fall through if can complete
				if self.future and not GOALTYPES[self.action].iscomplete then -- pretend completable. EVIL. SHAME.
					return false,true, "future step? pretend completable. shame!"
				end
				return false,false

			elseif false and explanation == "no stagenum" or explanation == "stage completion" then
				-- quest in journal, but no stage mentioned, and surely not complete
				-- or, stage mentioned, but it's current, so
				if self:IsCompletable("by type") then break end  -- fall through
				return iscomplete,ispossible -- always false,true

			elseif explanation == "step completion" or explanation == "step overrides cond" then
				if ispossible and self:IsCompletable("by type") then break end  -- fall through
				return iscomplete,ispossible

			elseif explanation == "cond completion" then  -- possible, countable
				if self.count and self.count > 0 and curv then -- If we only want a specific amount of items at this point then allow them to collect 1/5 and complete this step.
					if curv >= self.count then
						iscomplete = true
					end
				end
				if iscomplete then
					return true, ispossible, (curv and curv / (self.count or maxv or 1))
				end
				if self:IsCompletable("by type") then break end -- let the goto complete it!
				return false, ispossible, (curv and curv / (self.count or maxv or 1))

			elseif false and explanation == "current stage unknown" then	-- RAISE ALARM?
				return false,false

			elseif self.future and not GOALTYPES[self.action].iscomplete then -- simulate completability. EVIL.
				return false,true, "future step? pretend completable"

			elseif self.future then -- how did we end up here?
				break

			else
				return iscomplete,ispossible

			end

			-- letting possibles through. They'll be either current-stages-only, or incomplete vague objectives.
		until false
	end

	if self.achieve_id then
		iscomplete,ispossible = GOALTYPES['achieve'].iscomplete(self)
		if iscomplete then
			return true,true
		end
	end

	if self.lorebook_book then  -- it's lore-based, then?
		iscomplete,ispossible = GOALTYPES['lorebook'].iscomplete(self)
		if iscomplete then
			return true,true
		end
	end

	local giscomplete,gispossible
	local GOALTYPE = GOALTYPES[self.action]
	if GOALTYPE and GOALTYPE.iscomplete then
		giscomplete,gispossible = GOALTYPE.iscomplete(self)
	end

	return giscomplete or iscomplete,gispossible or ispossible
end

function Goal:IsCompletable(by_type)
	local GOALTYPE = GOALTYPES[self.action] -- All goals have goaltypes

	if self.force_nocomplete then return false end -- the almighty |n
	if self.condition_complete then return true end -- we have a script, so obey

	if not by_type and self.action ~= "goto" then
		-- lorebook goals store lorebook_book (not lorebook) — match that so Examine|lorebook steps complete
		if self.quest or self.lorebook_book or self.achieve_id then
			return true
		end	-- there is a quest/lore/achieve associated with this goal so can be completed. Unless it's a goto. These are only completed by |c.
	end

	if GOALTYPE.iscompletable then
		return GOALTYPE.iscompletable(self)
	end -- This may or maynot be there if it is only sometimes completable.

	if GOALTYPE.iscomplete then return true end	-- There is a way to complete this goal

	-- Nothing above? Okay can't complete.
	return false
end

function Goal:UpdateStatus()
	self.status = self:GetStatus()
	return self.status
end

-- True fluff only (used by aux-step skip). Never treat goto / beacon "reach next
-- marker" travel as auxiliary — those are required waypoint steps.
function Goal:IsAuxiliary()
	return self.action == "text" or self.action == "tip"
end

function Goal:GetQuest()
	if self.quest then
		return CGV.Quests:GetQuest(self.quest)
	end
end

function Goal:GetStatus()

	-- a good place to check for quest coordinates as any...
	if self.action == "goto" and self.quest and self.questcondtxt then
		local quest = CGV.Quests:GetQuest(self.quest)
		if quest and quest.steps then
			local snum,cnum = quest:FindStepCond(self.questcondtxt)
			if snum then
				local cond = quest.steps[snum] and quest.steps[snum].conditions and quest.steps[snum].conditions[cnum]
				if cond and cond.x and cond.x ~= self.x then
					self.x,self.y = cond.x,cond.y
					self.m = CGV.Pointer:GetMapTex()
					CGV:SetWaypoint() -- update, really
				end
			end
		end
	end

	if not self:IsVisible() then
		return "hidden"
	end
	if not self:IsCompletable() then
		return "passive"
	end
	local iscomplete,_,progress,_ = self:IsComplete()
	if iscomplete then
		return "complete"
	end

	return "incomplete",progress
end

function Goal:OnClick()
	if GOALTYPES[self.action].onclick then
		return GOALTYPES[self.action].onclick(self)
	end
end

-----------------------------------------
-- DEBUG
-----------------------------------------

function GoalProto:Debug(...)
	local str = ...
	CGV:Debug("&goal "..str, select(2,...) )
end
