-----------------------------------------
-- LOCALIZED GLOBAL VARIABLES
-----------------------------------------

local CGV = _G.CGV
local GetZoneNameByIndex = _G.GetZoneNameByIndex
local GetCurrentMapZoneIndex = _G.GetCurrentMapZoneIndex
local Viewer
-- Poll interval for step completion (kept snappy; lorebooks also force a check on learn).
local LONG_STEP_INTERVAL = 0.25
local SHORT_STEP_INTERVAL = 0.08
local completeionInterval = LONG_STEP_INTERVAL
local tinsert,tremove,type,ipairs,class = table.insert,table.remove,type,ipairs,_G.class
local CHAIN = CGV.Utils.ChainCall
local L = CGV.L

-----------------------------------------
-- SAVED REFERENCES
-----------------------------------------

CGV.guidesets = {}
CGV.registeredguides = {}	CGV.rg = CGV.registeredguides
CGV.registered_includes = {}

CGV.CurrentGuide = nil
CGV.CurrentGuideName = nil
CGV.CurrentStep	= nil
CGV.CurrentStepNum = nil

-----------------------------------------
-- CURRENT GUIDE MANAGEMENT FUNCTIONS
-----------------------------------------

function CGV:PreviousStep(fast,quiet)
	if not self.CurrentGuide then return end

	self.LastSkip = -1

	local step,backed = self:GetPreviousValidStep()
	if not step then return end

	self:Debug("PreviousStep to "..step.num..(fast and ' (fast)' or ''))

	-- drop 'backed' history states
	local history = self.sv.char.stephistory
	for _ = 1, backed do
		tremove(history)
	end

	if #history == 0 then
		self.fastforward = false
		self.pause = true
	else
		self.fastforward = fast
		self.pause = not fast
	end

	self:FocusStep(step,quiet)
end

function CGV:SkipStep(fast,quiet)
	if not self.CurrentGuide then return end

	self.LastSkip = 1
	self.fastforward = fast

	local step

	self.force_pause = _G.IsAltKeyDown() and _G.IsControlKeyDown()

	if self.force_pause then  -- forced next+1 step
		step=self.CurrentGuide.steps[self.CurrentStepNum+1]
		self.CurrentStep.needsreload=nil
	end

	if not step then -- when not forced, that is: usually.
		local step2,stepnum,guide

		local instantskip = nil

		if fast and instantskip then
			step2,stepnum,guide = self.CurrentStep:GetNextCompletableStep()
		else
			step2,stepnum,guide = self.CurrentStep:GetNextValidStep()
		end  -- always returns a step, unless we're at the end.

		if guide then
			-- Step-level |next Title → load that guide (not a suggestion popup).
			self:AdvanceToNextGuide(guide, stepnum or 1)
			return
		end
		step = step2
	end

	if step then
		-- not last step
		self:Debug("SkipStep to ".. step.num..(fast and ' (fast)' or ''))

		if step.num == #self.CurrentGuide.steps then
			self.pause = true -- final step
		else
			self.pause = not fast
		end

		if self.force_pause then
			self.pause = true
		end

		self:FocusStep(step,quiet)
	else
		self.pause = true
		self.fastforward = false
		-- End of guide: explicit guide |next advances; zone suggestion is separate.
		if self.CurrentGuide.next and self:AdvanceToNextGuide(self.CurrentGuide.next, 1) then
			return
		elseif self:MaybeSuggestNextGuide() then
			return
		elseif self.CurrentGuide.steps and #self.CurrentGuide.steps > 1 then
			if not self.EndGuidePopup then
				local popup = CGV.Popup:New("Community_EndGuide_Popup")
				local BOTTOM = _G.BOTTOM

				popup.declinebutton:Hide()
				CHAIN(popup.acceptbutton)
				:ClearAllPoints()
				:SetPoint(BOTTOM,popup,BOTTOM,0,-5)

				self.EndGuidePopup = popup
			end

			if self.EndGuidePopup.lastguide ~= self.CurrentGuide then		-- Don't show this again if it has shown for this guide.
				self.EndGuidePopup.lastguide = self.CurrentGuide

				self.EndGuidePopup:SetText(L['static_endguide'])
				self.EndGuidePopup:Show()
			end
		end
	end
end

-- return step = step obj
-- return backed = num of valid history skips
function CGV:GetPreviousValidStep()
	local step
	local hist = CGV.sv.char.stephistory
	local hlen = #hist
	local stepnum
	local backed=0
	local okaytostay
	repeat
		-- pop stepnum from history
		stepnum = hist[hlen-backed]

		-- valid number?
		if stepnum then
			-- get the step
			local s = self.CurrentGuide.steps[stepnum]
			if s then
				backed = backed + 1
				step = s
			end
		else
			-- we broke history or it just ran out, whatever
			CGV:Debug("step history broken, omg")

			-- Empty step history: jump to first valid step (no confirmation).
			local s = self.CurrentGuide:GetFirstValidStep()  -- always returns something, or breaks.
			if s then
				backed = hlen
				step = s
				okaytostay = true
			end
		end
	until (step:AreRequirementsMet() or self.db.profile.showwrongsteps) and (step~=self.CurrentStep or okaytostay)
	return step,backed
end

function CGV:FocusStep(num,quiet)
	if type(num) == "string" and self.CurrentGuide.steplabels then
		local s = num
		num = self.CurrentGuide.steplabels[num]
		if num then
			num = num[1]
		end

		self:Debug("FocusStep: "..s.." = "..tostring(num))
	end
	if type(num) == "table" then
		num = num.num
	end
	if not num or num <= 0 then return end
	if not self.CurrentGuide then return end
	if not self.CurrentGuide.steps then return end
	if num > #self.CurrentGuide.steps then return end

	self:Debug("FocusStep "..num..(quiet and " (quiet)" or ""))

	-- Record step into history
	if self.LastSkip > 0 and self.CurrentStep then
		tinsert(self.sv.char.stephistory,self.CurrentStep.num)
	end

	local step = self.CurrentGuide.steps[num]

	step:SetAsCurrent()

	-- Whoa whoa. The step might load a different guide at this point! Play safe.
	local cs = self.CurrentStep
	local cg = self.CurrentGuide
	if (cs ~= self.CurrentStep) or (cg ~= self.CurrentGuide) then
		self:Debug("FocusStep: guide or step changed! bailing.")
		return
	end

	self.stepchanged = true

	local stepcomplete,_ = self.CurrentStep:IsComplete()
	if self.pause then
		self.LastSkip = 1
		if not stepcomplete then
			self:Debug("unpausing")
			self.pause = nil
		end
	end

	if step:AreRequirementsMet() then
		self.stepMatchedReqs = step
	end

	if not quiet then
		self:FocusStepUnquiet()
	end
end

function CGV:FocusStepUnquiet()
	self:SetWaypoint()

	Viewer:Update(true)
	local PlaySound, SOUNDS = _G.PlaySound, _G.SOUNDS
	PlaySound(SOUNDS.NOTE_PAGE_TURN)
end

function CGV:SetWaypoint(what)
	local set = false
	local ZO_WorldMap_UpdateMap = _G.ZO_WorldMap_UpdateMap
	if what == false then
		CGV.Pointer:ClearWaypoints()
		set = true
	else
		CGV.Pointer:ClearWaypoints("way")
		if tonumber(what) then
			local goal=self.CurrentStep.goals[tonumber(what)]
			if goal and goal.x then
				CGV.Pointer:SetWaypoint(goal.map or nil,goal.floor or 0,goal.x,goal.y,{title=goal:GetText()})
				set = true
			end
		else
			-- set up waypoints
			for gi,goal in ipairs(self.CurrentStep.goals) do
				if goal.x and goal.y and not goal.force_noway then
					CGV.Pointer:SetWaypoint(goal.map or nil,goal.floor or 0,goal.x,goal.y,{title = goal:GetText(),goalnum = gi})
					set = true
				end
			end
			-- point to first completable
			CGV.Pointer:SetArrowToFirstCompletableGoal()
		end
	end
	ZO_WorldMap_UpdateMap()
	return set
end

function CGV:TryToCompleteStep(force)
	if not (self.CurrentStep and self.CurrentGuide) then return end
	if not self.Frame:IsShown() then return end

	local stepcomplete, steppossible, completing
	local t, elapsed
	local confirmcompleted, confirmfound

	-- prevent overtime checks
	t = _G.GetFrameTimeSeconds()
	elapsed = t - (self.lastStepComplete or 0)
	self.lastStepComplete = t

	self.completionelapsed = (self.completionelapsed or 0) + elapsed
	if self.completionelapsed < completeionInterval and not force then return end	-- throttle updating
	self.completionelapsed = 0

	stepcomplete,steppossible = self.CurrentStep:IsComplete()
	if not self.CurrentStep:AreRequirementsMet() and self.stepMatchedReqs ~= self.CurrentStep then
		stepcomplete,steppossible = true,true
	end

	completing = stepcomplete

	-- Smart skip: unmet requirements, impossible steps, or aux/travel that leads nowhere useful.
	-- (No level checks — ESO quests scale with character.)
	local profile = self.db and self.db.profile
	if profile then
		if not self.CurrentStep:AreRequirementsMet()
		or (profile.skipimpossible and not steppossible)
		or (profile.skipauxsteps and self.CurrentStep:IsAuxiliarySkippable()) then
			completing = true
		end
	end

	if not completing then
		completeionInterval = LONG_STEP_INTERVAL
		self.pause = nil
	end

	-- Is one of the goals a confirm that is not completed?
	for _,goal in ipairs(self.CurrentStep.goals) do
		if goal.action == "confirm" and goal.always then
			confirmfound = true
			if goal.status == "complete" then
				confirmcompleted = true
			end
		end
	end
	if confirmfound and not confirmcompleted then
		completing = false
	end

	if self.pause then
		completeionInterval = LONG_STEP_INTERVAL
		self.LastSkip = 1
	else
		if completing then
			self:Debug("Skipping step: "..self.CurrentStepNum.." ("..(stepcomplete and "complete" or (steppossible and "possible?" or "impossible"))..")")
			local s = ""
			for gn,goal in ipairs(self.CurrentStep.goals) do
				s = s .. "["..gn.."] ".. goal:GetText().." ("..(goal.status or "").."),  "
			end
			self:Debug("Skipped goals were: %s",s)

			-- do, do, do the SKIP!
			if self.LastSkip < 0 then
				self:PreviousStep(true)
			else
				self:SkipStep(true)
			end
			self.fastforward = true

			completeionInterval = completeionInterval * 0.8
			if completeionInterval < SHORT_STEP_INTERVAL then
				completeionInterval = SHORT_STEP_INTERVAL
			end

			local PlaySound, SOUNDS = _G.PlaySound, _G.SOUNDS
			PlaySound(SOUNDS.POSITIVE_CLICK)

			-- A step was completed, update the ProgressBar
			Viewer:UpdateProgressBar()
		else
			completeionInterval = LONG_STEP_INTERVAL
			self.pause = nil
			self.fastforward = nil
			self.LastSkip = 1
		end
	end

	-- Refresh goal counts (e.g. 0/5) even when the step did not advance.
	Viewer:Update()
end

-----------------------------------------
-- GEN FUNCTIONS
-----------------------------------------

-- IN: "Community's Daggerfall Covenant Leveling Guides"
-- OUT: "LEVELING"
function CGV:SanitizeGuideTitle(title)
	title = title:gsub([[\]],[[/]])
	title = title:gsub("//","/")
	title = title :gsub("CGV's ","")
	title = title
	:gsub("^Legacy ","")
	:gsub("^Aldmeri Dominion ","")
	:gsub("^Ebonheart Pact ","")
	:gsub("^Daggerfall Covenant ","")

	-- fix old-style guide paths
	title = title
	:gsub("^Leveling.-/","LEVELING/")

	return title
end

function CGV:GetGuideByTitle(title)
	if not title then return end
	title = CGV:SanitizeGuideTitle(title)  -- code-side fix for "legacy" guides.
	for _,v in ipairs(self.registeredguides) do
		if v.title == title then
			return v
		end
	end
end

-- Unload every fully-parsed guide except the current one.
function CGV:UnloadUnusedGuides()
	local cur = self.CurrentGuide
	for _, guide in ipairs(self.registeredguides) do
		if guide and guide ~= cur and guide.fully_parsed then
			guide:Unload()
		end
	end
end

-- Load the guide named by |next (header or step goal). Respects Full/MQO preference.
-- Returns true if a load or style prompt was started.
function CGV:AdvanceToNextGuide(titleOrGuide, step)
	step = step or 1
	local guide
	if type(titleOrGuide) == "table" then
		guide = titleOrGuide
	elseif type(titleOrGuide) == "string" then
		guide = self:GetGuideByTitle(titleOrGuide)
		if not guide then
			guide = self:GetGuideByTitle(self:SanitizeGuideTitle(titleOrGuide))
		end
	end
	if not guide then
		self:Print(("|cff4400ERROR!|r Cannot advance to guide '|cffff88%s|r'."):format(tostring(titleOrGuide)))
		return false
	end

	local ignored = (self.db.char and self.db.char.ignoredguides) or {}
	if ignored[guide.title] then
		return false
	end

	-- Prefer remembered Full/MQO; if "ask" and both exist, PromptGuideStyleOrLoad asks once.
	self:PromptGuideStyleOrLoad(guide, function(chosen)
		self:SetGuide(chosen, step)
	end)
	return true
end

-- Zone-based suggestion popup only (Load Suggested / end-of-guide with no |next).
-- Explicit |next advances via AdvanceToNextGuide — keep that path separate.
-- Returns true if a popup was shown.
function CGV:MaybeSuggestNextGuide()
	local cur = self.CurrentGuide
	if not cur then return false end
	if not (self.Frame and self.Frame:IsShown()) then return false end

	-- Still exclusive-suggested: don't push another guide yet.
	if cur:GetStatus() == "SUGGESTED" and cur.condition_suggested_exclusive then
		return false
	end

	local ignored = (self.db.char and self.db.char.ignoredguides) or {}
	local best = self:GetBestSuggestedGuide()
	if not best or best.title == cur.title or ignored[best.title] then
		return false
	end

	-- One popup per finished guide → suggested title (avoid spam).
	if self._suggestedNextFor == cur.title and self._suggestedNextTitle == best.title then
		return false
	end
	self._suggestedNextFor = cur.title
	self._suggestedNextTitle = best.title

	best:AdvertiseWithPopup()
	return true
end

-- Brand-new characters: tutorial first, then alliance zone order, then chapters/DLC by release date.
-- Titles match SanitizeGuideTitle results for Full leveling guides (MQO uses different paths).
local WAILING_PRISON_TITLE = "LEVELING/The Wailing Prison"
local SOUL_SHRIVEN_QUEST = "Soul Shriven in Coldharbour"

local FACTION_ZONE_ORDER = {
	AD = {
		"LEVELING/Khenarthi's Roost",
		"LEVELING/Auridon",
		"LEVELING/Grahtwood",
		"LEVELING/Greenshade",
		"LEVELING/Malabal Tor",
		"LEVELING/Reaper's March",
	},
	DC = {
		"LEVELING/Stros M'Kai",
		"LEVELING/Betnikh",
		"LEVELING/Glenumbra",
		"LEVELING/Stormhaven",
		"LEVELING/Rivenspire",
		"LEVELING/Alik'r Desert",
		"LEVELING/Bangkorai",
	},
	EP = {
		"LEVELING/Bleakrock Isle",
		"LEVELING/Bal Foyen",
		"LEVELING/Stonefalls",
		"LEVELING/Deshaan",
		"LEVELING/Shadowfen",
		"LEVELING/Eastmarch",
		"LEVELING/The Rift",
	},
}

-- After the player's alliance path + Coldharbour: chapters/DLC by ESO release date.
local EXPANSION_RELEASE_ORDER = {
	"LEVELING/Craglorn",           -- May 2014
	-- Imperial City (Apr 2015) is MQO-only in this pack; Full path continues at Craglorn/Wrothgar.
	"LEVELING/Wrothgar",           -- Nov 2015 (Orsinium)
	"LEVELING/Thieves Guild",      -- Mar 2016
	"LEVELING/Dark Brotherhood",   -- May 2016
	"LEVELING/Vvardenfell",        -- Jun 2017 (Morrowind)
	"LEVELING/Clockwork City",     -- Oct 2017
	"LEVELING/Summerset",          -- May 2018
	"LEVELING/Murkmire",           -- Oct 2018
	"LEVELING/Northern Elsweyr",   -- Jun 2019 (Elsweyr)
	"LEVELING/Southern Elsweyr",   -- Oct 2019 (Dragonhold)
	"LEVELING/Western Skyrim",     -- May 2020 (Greymoor)
	"LEVELING/The Reach",          -- Nov 2020 (Markarth)
	"LEVELING/Blackwood",          -- Jun 2021
	"LEVELING/Fargrave",           -- Nov 2021 (The Deadlands)
	"LEVELING/High Isle",          -- Jun 2022
	"LEVELING/Galen",              -- Nov 2022 (Firesong)
	"LEVELING/Telvanni Peninsula", -- Jun 2023 (Necrom)
	"LEVELING/West Weald",         -- Jun 2024 (Gold Road)
	"LEVELING/Solstice",           -- 2025
}

local function IsSoulShrivenComplete()
	local QT = CGV.QuestTracker
	return QT and QT.IsQuestComplete and QT:IsQuestComplete(SOUL_SHRIVEN_QUEST) and true or false
end

-- Ordered Full-guide titles for this character: tutorial → alliance → Coldharbour → expansions.
function CGV:GetProgressionGuideTitles()
	local titles = { WAILING_PRISON_TITLE }
	local faction = (CGV.Utils and CGV.Utils.GetFaction and CGV.Utils.GetFaction("player", "novet")) or "AD"
	if faction ~= "AD" and faction ~= "DC" and faction ~= "EP" then
		faction = "AD"
	end
	local zones = FACTION_ZONE_ORDER[faction]
	if zones then
		for i = 1, #zones do
			titles[#titles + 1] = zones[i]
		end
	end
	titles[#titles + 1] = "LEVELING/Coldharbour"
	for i = 1, #EXPANSION_RELEASE_ORDER do
		titles[#titles + 1] = EXPANSION_RELEASE_ORDER[i]
	end
	return titles
end

function CGV:GetGuideProgressionIndex(guide)
	if not guide or not guide.title then return nil end
	local title = guide.title
	local short = guide.title_short
	local order = self:GetProgressionGuideTitles()
	for i = 1, #order do
		local want = order[i]
		if title == want then
			return i
		end
		-- MQO / alternate paths: match by zone short name inside the same progression slot.
		local zone = want:match("([^/]+)$")
		if zone and short and short == zone then
			return i
		end
		if zone and title:find(zone, 1, true) then
			return i
		end
	end
	return nil
end

function CGV:FindSuggestedGuides()
	local suggested = {}
	for _,guide in ipairs(self.registeredguides) do
		if guide:GetStatus() == "SUGGESTED" then
			if guide.condition_suggested_exclusive then
				return {guide}
			else
				if not suggested[guide.type] then
					suggested[guide.type] = {}
				end
				tinsert(suggested[guide.type],guide)
			end
		end
	end
	return suggested
end

-- Best guide right now: Wailing Prison for new chars, else current-zone match,
-- else next title in faction → expansion release order.
-- No level scoring — ESO quests scale with character.
function CGV:GetBestSuggestedGuide()
	local ignored = (self.db and self.db.char and self.db.char.ignoredguides) or {}

	local function usable(guide)
		if not guide or not guide.title or ignored[guide.title] then return false end
		local status = guide:GetStatus()
		return status == "SUGGESTED" or status == "VALID"
	end

	-- New characters: always start with The Wailing Prison until Soul Shriven is done.
	if not IsSoulShrivenComplete() then
		local wailing = self:GetGuideByTitle(WAILING_PRISON_TITLE)
		if usable(wailing) or (wailing and wailing:GetStatus() ~= "INVALID" and not ignored[wailing.title]) then
			return wailing, 1000
		end
	end

	local zone = GetZoneNameByIndex(GetCurrentMapZoneIndex()) or ""
	local zoneLower = zone:lower()
	local best, bestScore = nil, -1

	if zoneLower ~= "" then
		for _, guide in ipairs(self.registeredguides) do
			if usable(guide) and (guide.type == "LEVELING" or not guide.type or guide.type == "Extras") then
				local title = (guide.title or ""):lower()
				local short = (guide.title_short or ""):lower()
				if title:find(zoneLower, 1, true) or short:find(zoneLower, 1, true) then
					local score = 25
					if guide:GetStatus() == "SUGGESTED" then score = score + 10 end
					if guide.title:match("^LEVELING/") then score = score + 2 end
					if score > bestScore then
						bestScore = score
						best = guide
					end
				end
			end
		end
		if best then
			return best, bestScore
		end
	end

	-- No zone match: next step in the recommended path after the current guide.
	local progression = self:GetProgressionGuideTitles()
	local curIdx = self.CurrentGuide and self:GetGuideProgressionIndex(self.CurrentGuide) or 0
	local start = (curIdx or 0) + 1
	if start < 1 then start = 1 end
	for i = start, #progression do
		local g = self:GetGuideByTitle(progression[i])
		if usable(g) and (not self.CurrentGuide or g.title ~= self.CurrentGuide.title) then
			return g, 50
		end
	end
	-- Wrap: first usable progression guide.
	for i = 1, #progression do
		local g = self:GetGuideByTitle(progression[i])
		if usable(g) then
			return g, 1
		end
	end

	return nil, -1
end

function CGV:IsFavoriteGuide(guide)
	local title = type(guide) == "table" and guide.title or guide
	local favs = self.sv and self.sv.char and self.sv.char.favoriteguides
	return title and favs and favs[title] and true or false
end

function CGV:ToggleFavoriteGuide(guide)
	local title = type(guide) == "table" and guide.title or guide
	if not title or not self.sv or not self.sv.char then return false end
	self.sv.char.favoriteguides = self.sv.char.favoriteguides or {}
	local favs = self.sv.char.favoriteguides
	if favs[title] then
		favs[title] = nil
		self:Print(("Removed favorite: %s"):format(type(guide) == "table" and (guide.title_short or title) or title))
		return false
	else
		favs[title] = true
		self:Print(("Favorited: %s"):format(type(guide) == "table" and (guide.title_short or title) or title))
		return true
	end
end

function CGV:GetFavoriteGuides()
	local list = {}
	local favs = self.sv and self.sv.char and self.sv.char.favoriteguides
	if not favs then return list end
	for _, guide in ipairs(self.registeredguides) do
		if guide and guide.title and favs[guide.title] then
			tinsert(list, guide)
		end
	end
	return list
end

function CGV:GetSuggestedGuideList()
	local list = {}
	local seen = {}
	local ignored = (self.db and self.db.char and self.db.char.ignoredguides) or {}

	-- Progression path first (Wailing Prison → faction → expansions by release date).
	local progression = self:GetProgressionGuideTitles()
	for i = 1, #progression do
		local guide = self:GetGuideByTitle(progression[i])
		if guide and guide.title and not seen[guide.title] and not ignored[guide.title] then
			local status = guide:GetStatus()
			if status == "SUGGESTED" or status == "VALID" then
				tinsert(list, guide)
				seen[guide.title] = true
			end
		end
	end

	-- Then any other currently suggested guides, ordered by progression index when known.
	local suggested = self:FindSuggestedGuides()
	local leveling = suggested.LEVELING or suggested
	local extras = {}
	if type(leveling) == "table" then
		for _, guide in ipairs(leveling) do
			if guide and guide.title and not seen[guide.title] and not ignored[guide.title] then
				tinsert(extras, guide)
				seen[guide.title] = true
			end
		end
	end
	table.sort(extras, function(a, b)
		local ai = self:GetGuideProgressionIndex(a) or 9999
		local bi = self:GetGuideProgressionIndex(b) or 9999
		if ai ~= bi then return ai < bi end
		return (a.title_short or a.title or "") < (b.title_short or b.title or "")
	end)
	for i = 1, #extras do
		tinsert(list, extras[i])
	end

	return list
end

-----------------------------------------
-- FULL vs MAIN QUEST ONLY
-----------------------------------------

-- Full / MQO zone name mismatches (same chapter, different guide titles).
local GUIDE_STYLE_ZONE_ALIASES = {
	["Fargrave"] = "The Deadlands",
	["The Deadlands"] = "Fargrave",
	["Galen"] = "Firesong",
	["Firesong"] = "Galen",
}

local function IsMQOGuide(guide)
	local title = guide and guide.title or ""
	return title:find("Main Quests Only", 1, true) ~= nil
end

local function IsFullLevelingGuide(guide)
	local title = guide and guide.title or ""
	return title:match("^LEVELING/") ~= nil
end

local function ZoneKeysForGuide(guide)
	local short = guide and guide.title_short
	if not short or short == "" then return {} end
	local keys = { short }
	local alias = GUIDE_STYLE_ZONE_ALIASES[short]
	if alias then keys[#keys + 1] = alias end
	return keys
end

-- Returns fullGuide, mqoGuide (either may be nil).
function CGV:GetGuideStylePair(guide)
	if not guide then return nil, nil end

	local fullGuide, mqoGuide
	if IsFullLevelingGuide(guide) then
		fullGuide = guide
	elseif IsMQOGuide(guide) then
		mqoGuide = guide
	else
		-- Companions / other extras: no Full↔MQO pair.
		return guide, nil
	end

	local keys = ZoneKeysForGuide(guide)
	for _, g in ipairs(self.registeredguides) do
		if g and g.title and g ~= guide then
			local short = g.title_short
			local match = false
			for i = 1, #keys do
				if short == keys[i] then match = true break end
			end
			if match then
				if not fullGuide and IsFullLevelingGuide(g) then
					fullGuide = g
				elseif not mqoGuide and IsMQOGuide(g) then
					mqoGuide = g
				end
			end
		end
		if fullGuide and mqoGuide then break end
	end

	return fullGuide, mqoGuide
end

function CGV:GetGuideStylePreference()
	local style = self.sv and self.sv.char and self.sv.char.guide_style
	if style == "full" or style == "mqo" or style == "ask" then
		return style
	end
	return "ask"
end

function CGV:SetGuideStylePreference(style)
	if not (self.sv and self.sv.char) then return end
	if style ~= "full" and style ~= "mqo" and style ~= "ask" then
		style = "ask"
	end
	self.sv.char.guide_style = style
end

-- Pick Full or MQO from a suggested guide using saved preference (no popup).
-- When preference is "ask", returns the Full guide if present, else the given guide.
function CGV:GetPreferredGuideVariant(guide)
	if not guide then return nil end
	local fullGuide, mqoGuide = self:GetGuideStylePair(guide)
	local style = self:GetGuideStylePreference()
	if style == "mqo" and mqoGuide then
		return mqoGuide
	end
	if style == "full" and fullGuide then
		return fullGuide
	end
	-- ask / missing half of the pair
	return fullGuide or mqoGuide or guide
end

-- Ask Full vs MQO when both exist and preference is "ask"; otherwise load preferred.
-- onLoad(guide) is called instead of SetGuide when provided (e.g. Guide Menu select).
function CGV:PromptGuideStyleOrLoad(guide, onLoad)
	if not guide then return false end

	local fullGuide, mqoGuide = self:GetGuideStylePair(guide)
	local style = self:GetGuideStylePreference()
	local loadFn = onLoad or function(g)
		self:SetGuide(g)
	end

	local function loadChosen(chosen, remember)
		if remember then
			self:SetGuideStylePreference(remember)
		end
		if chosen then
			loadFn(chosen)
		end
	end

	-- Only one style available (e.g. The Wailing Prison): load it.
	if not (fullGuide and mqoGuide) then
		loadChosen(fullGuide or mqoGuide or guide, nil)
		return true
	end

	if style == "full" then
		loadChosen(fullGuide, nil)
		return true
	end
	if style == "mqo" then
		loadChosen(mqoGuide, nil)
		return true
	end

	-- Preference is "ask": show Full vs Main Quests Only (plain text; brand orange).
	local popup = self.GuideStylePopup
	if not popup then
		popup = CGV.Popup:New("Community_GuideStyle_Popup")
		self.GuideStylePopup = popup
	end

	local ac = (CGV.Theme and CGV.Theme.AccentCode and CGV.Theme.AccentCode()) or "F55D07"
	local zoneName = (fullGuide and fullGuide.title_short) or (mqoGuide and mqoGuide.title_short) or guide.title_short or ""
	local orange = function(s) return "|c"..ac..(s or "").."|r" end

	local function colorButtonLabel(but, hex)
		if not but or not but.GetLabelControl then return end
		local label = but:GetLabelControl()
		if label and label.SetColor then
			local r = tonumber(hex:sub(1,2), 16) / 255
			local g = tonumber(hex:sub(3,4), 16) / 255
			local b = tonumber(hex:sub(5,6), 16) / 255
			label:SetColor(r, g, b, 1)
		end
	end

	popup.acceptbutton:SetText("Full Guide")
	popup.declinebutton:SetText("Main Quests Only")
	colorButtonLabel(popup.acceptbutton, ac)
	colorButtonLabel(popup.declinebutton, ac)
	if popup.acceptbutton.ResizeToPerfect then popup.acceptbutton:ResizeToPerfect() end
	if popup.declinebutton.ResizeToPerfect then popup.declinebutton:ResizeToPerfect() end

	popup.OnAccept = function()
		loadChosen(fullGuide, "full")
	end
	popup.OnDecline = function()
		loadChosen(mqoGuide, "mqo")
	end
	popup.OnEscape = function() end
	popup.OnClose = function()
		-- Restore default button labels/colors for other popups.
		popup.acceptbutton:SetText(L["static_accept"] or "Accept")
		popup.declinebutton:SetText(L["static_decline"] or "Decline")
		colorButtonLabel(popup.acceptbutton, "FFFFFF")
		colorButtonLabel(popup.declinebutton, "FFFFFF")
		if popup.acceptbutton.ResizeToPerfect then popup.acceptbutton:ResizeToPerfect() end
		if popup.declinebutton.ResizeToPerfect then popup.declinebutton:ResizeToPerfect() end
	end

	popup:SetText(orange("Recommended guide:"), orange(zoneName), orange("Full Guide or Main Quests Only?"))
	popup:SetDimensionConstraints(225, nil, 625, nil)

	-- Sit above the guide selection window: popup bottom → menu top (no overlap).
	local menu = CGV.Menu and CGV.Menu.Frame
	if menu then
		if CGV.GuideMenu and CGV.GuideMenu.Show then
			CGV.GuideMenu:Show()
		elseif CGV.Menu.Show then
			CGV.Menu:Show()
		end
		popup:ClearAnchors()
		popup:SetPoint(BOTTOM, menu, TOP, 0, -4)
		if popup.SetDrawTier and _G.DT_HIGH then
			popup:SetDrawTier(_G.DT_HIGH)
		end
		if popup.SetDrawLayer and _G.DL_OVERLAY then
			popup:SetDrawLayer(_G.DL_OVERLAY)
		end
		if popup.SetDrawLevel then
			popup:SetDrawLevel(200)
		end
	end

	CGV.pause = true
	if not popup:IsShown() then
		popup:Show()
	end
	return true
end

-----------------------------------------
-- SETUP FUNCTIONS
-----------------------------------------

function CGV:RegisterGuide(title,data,extra)
	title = self:SanitizeGuideTitle(title)

	local guide = CGV.GuideProto:New(title,data,extra)

	if guide then
		guide:Parse(false)
	end

	tinsert(self.registeredguides,guide)
end

function CGV:RegisterInclude(title,text)
	self.registered_includes[title] = {text=text}

	self.registered_includes[title].GetParsed = function (self,params)
		local function parse_param(param)
			return params and params[param] or ""
		end
		return self.text:gsub("%%(%w+)%%",parse_param)
	end
end

function CGV:DoMutex(m)
	if self.guidesets[m] then
		return true
	else
		self.guidesets[m] = true
	end
end

-----------------------------------------
-- LOAD FUNCTIONS
-----------------------------------------

function CGV:SetGuide(name,step)

	if not name then
		self.pause = nil Viewer:Update(true)
		return
	end

	step = step or 1

	local guide
	local err

	-- Get the guide object
	if type(name) == "number" then
		local num = name
		if self.registeredguides[num] then
			guide = self.registeredguides[num]
		else
			err = "No guide by that number"
		end
	elseif type(name) == "string" then
		guide = self:GetGuideByTitle(name)
		if not guide then
			err = "No guide by that title"
		end
	else
		guide = name  --omg, object
	end

	if guide then
		assert(class(guide) == "Guide","Must be a Guide object to set guide.")
		if guide.steps and step > #guide.steps then
			step = 1
		end  -- safety check
		local status,msg = guide:GetStatus()
		-- Use title_short instead of title because matching with backslashes in it seems off?
		if status == "INVALID" and not CGV.db.char.goodbadguides[guide.title_short] then
			if not self.BadGuidePopup then
				local popup = CGV.Popup:New("Community_BadGuide_Popup")

				popup.OnAccept = function(me)
					CGV.db.char.goodbadguides[me.guide.title_short]=true
					CGV:SetGuide(me.guide,me.step)
				end

				popup.OnDecline = function()
					CGV.GuideMenu:Show()
				end

				self.BadGuidePopup = popup
			end

			self.BadGuidePopup:SetText(L['static_badguide']:format(guide.title_short,msg or ""))

			self.BadGuidePopup.guide = guide
			self.BadGuidePopup.step = step

			self.BadGuidePopup:Show()

			return "BAD"
		end

		-- Free the previous guide's step tables (helps slower PCs).
		local unload = self.db.profile.unloadunusedguides ~= false
		if unload and self.CurrentGuide and self.CurrentGuide ~= guide then
			self.CurrentGuide:Unload()
		end

		guide:Parse(true) -- Make sure this is parsed (reparses if it was unloaded)

		if guide.steps and #guide.steps > 0 and not guide.parse_failed then
			local name = guide.title

			guide:SetAsCurrent()

			self.sv.char.stephistory = {}
			--self:Print(L["message_loadedguide"]:format(guide.title))
			self:Debug("Guide loaded: "..name)
			self:FocusStep(step)

			-- Drop any other fully-parsed guides still sitting in memory.
			if unload then
				self:UnloadUnusedGuides()
			end
		else
			err = "Guide not parsed"
		end

	else
		err = err or L["message_missingguide"]:format(name or "-")
	end

	if err then
		self:Error("Unable to load guide "..(guide and type(guide)=="table" and guide.title or name or "-")..": "..err)
		self.CurrentGuide = nil
		self.CurrentGuideName = nil
		self.CurrentStep = nil
		self.CurrentStepNum = nil
	end

	self.pause = nil

	Viewer:Update(true)
end

function CGV:GuideLoadStartup()
	--self:Debug("&startup GuideLoadStartup starts, SV are" .. (self.sv.char and "" or " NOT") .. " loaded")
	if not self.guidesloaded then return end -- let the OnGuidesLoaded func call us.
	if self.guidestartcomplete then return end

	local history = self.db.char.stephistory -- Save step history. Gets reset in SetGuide, but at startup we don't want it reset

	self:SetGuide(self.sv.char.guidename,self.sv.char.step)
	self.db.char.stephistory = history

	if not self.CurrentGuide then
		-- New / unset characters: Wailing Prison first; apply Full/MQO preference without blocking on a popup.
		local best = self:GetBestSuggestedGuide()
		if best then
			self:SetGuide(self:GetPreferredGuideVariant(best) or best)
		else
			self:SetGuide(CGV:SanitizeGuideTitle("LEVELING/"..GetZoneNameByIndex(GetCurrentMapZoneIndex())))
		end
	end

	Viewer:Update(true)
	self.guidestartcomplete = true
end

-----------------------------------------
-- STARTUP
-----------------------------------------

tinsert(CGV.startups,function(self)
		Viewer = CGV.Viewer
	end)

