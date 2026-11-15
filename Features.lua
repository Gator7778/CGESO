-----------------------------------------
-- QoL FEATURES
-- Stuck-step, bug context, bookmarks, quest-link,
-- compact preset, zone nudge, /cgpos helpers,
-- guide notes, hide-completed, wayshrine/door list.
-- Settings live in Options.lua + AddonSettings.lua (Home + LAM).
-----------------------------------------

local CGV = _G.CGV
local tinsert, tremove, ipairs, type, tostring = table.insert, table.remove, ipairs, type, tostring
local GetFrameTimeSeconds = _G.GetFrameTimeSeconds
local GetMapPlayerPosition = _G.GetMapPlayerPosition
local GetZoneNameByIndex = _G.GetZoneNameByIndex
local GetCurrentMapZoneIndex = _G.GetCurrentMapZoneIndex
local GetMapName = _G.GetMapName
local GetNumPOIs = _G.GetNumPOIs
local GetPOIInfo = _G.GetPOIInfo
local GetPOIMapInfo = _G.GetPOIMapInfo
local IsPOIWayshrine = _G.IsPOIWayshrine
local SCENE_MANAGER = _G.SCENE_MANAGER
local MAP_PIN_TYPE_POI_COMPLETE = _G.MAP_PIN_TYPE_POI_COMPLETE

local Features = {}
CGV.Features = Features

local CGPOS_HISTORY_MAX = 25

-----------------------------------------
-- PROFILE / CHAR HELPERS
-----------------------------------------

local function Profile()
	return CGV.db and CGV.db.profile
end

local function Char()
	return CGV.sv and CGV.sv.char
end

local function OptBool(name, default)
	local p = Profile()
	if not p or p[name] == nil then return default end
	return not not p[name]
end

local function OptNum(name, default)
	local p = Profile()
	if not p or p[name] == nil then return default end
	return tonumber(p[name]) or default
end

local function StripColors(s)
	if not s then return "" end
	return tostring(s):gsub("|c%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("|t.-|t", "")
end

-----------------------------------------
-- 1. STUCK-STEP DETECTOR
-----------------------------------------

Features.stuckKey = nil
Features.stuckSince = nil
Features.stuckOfferedKey = nil

function Features:NotifyStepFocused()
	local guide = CGV.CurrentGuide
	local step = CGV.CurrentStep
	if not guide or not step then
		self.stuckKey = nil
		self.stuckSince = nil
		return
	end
	local key = (guide.title or "?") .. "#" .. tostring(step.num)
	if key ~= self.stuckKey then
		self.stuckKey = key
		self.stuckSince = GetFrameTimeSeconds()
	end
end

function Features:CheckStuckStep()
	if not OptBool("stuckstep", true) then return end
	if not (CGV.Frame and CGV.Frame:IsShown()) then return end
	if not CGV.CurrentGuide or not CGV.CurrentStep then return end
	if CGV.pause or CGV.fastforward then return end

	local key = (CGV.CurrentGuide.title or "?") .. "#" .. tostring(CGV.CurrentStep.num)
	if key ~= self.stuckKey then
		self:NotifyStepFocused()
		return
	end
	if self.stuckOfferedKey == key then return end

	local minutes = OptNum("stuckstep_minutes", 10)
	if minutes < 1 then minutes = 1 end
	local since = self.stuckSince or GetFrameTimeSeconds()
	if (GetFrameTimeSeconds() - since) < (minutes * 60) then return end

	self.stuckOfferedKey = key
	self:ShowStuckPopup()
end

function Features:ShowStuckPopup()
	local step = CGV.CurrentStep
	local guide = CGV.CurrentGuide
	if not step or not guide then return end

	local popup = self.StuckPopup
	if popup and popup.IsModalTopLevel and popup:IsModalTopLevel() then
		popup:Hide()
		self.StuckPopup = nil
		popup = nil
	end
	if not popup then
		popup = CGV.Popup:New("CGESO_StuckStep_Overlay",nil,true)
		popup:EnableGuideViewerAnchor()
		popup.OnAccept = function()
			-- Mark done / skip this step.
			if CGV.SkipStep then
				CGV:SkipStep(true)
			end
		end
		popup.OnDecline = function()
			-- Stay; do not re-offer until the step changes.
		end
		self.StuckPopup = popup
	elseif popup.EnableGuideViewerAnchor then
		popup:EnableGuideViewerAnchor()
	end

	local stepText = ""
	if step.goals then
		for _, goal in ipairs(step.goals) do
			if goal and goal.GetText then
				local t = StripColors(goal:GetText())
				if t ~= "" then
					stepText = stepText .. (stepText ~= "" and "\n" or "") .. t
				end
			end
		end
	end
	if stepText == "" then stepText = "(no step text)" end

	local mins = OptNum("stuckstep_minutes", 10)
	popup:SetText(
		("You've been on this step for %d+ minutes."):format(mins),
		("Step %s — %s"):format(tostring(step.num), guide.title_short or guide.title or "?"),
		stepText .. "\n\nAccept = skip / mark done. Decline = stay."
	)
	popup:Show()
end

-----------------------------------------
-- 2. BUG REPORT CONTEXT / NOTES
-----------------------------------------

function Features:BuildStepTextBlock()
	local step = CGV.CurrentStep
	if not step then return "STEP TEXT: (none)\n" end
	local lines = { ("STEP NUMBER: %s"):format(tostring(step.num)), "STEP TEXT:" }
	if step.goals then
		for i, goal in ipairs(step.goals) do
			local t = goal.GetText and StripColors(goal:GetText()) or ""
			tinsert(lines, ("  %d. %s"):format(i, t ~= "" and t or "(empty)"))
		end
	else
		tinsert(lines, "  (no goals)")
	end
	return table.concat(lines, "\n") .. "\n"
end

function Features:GetBugNotes()
	local char = Char()
	return (char and char.bugnotes) or ""
end

function Features:SetBugNotes(text)
	local char = Char()
	if not char then return end
	char.bugnotes = text or ""
end

-----------------------------------------
-- PER-GUIDE NOTES
-----------------------------------------

function Features:GetGuideNotesTable()
	local char = Char()
	if not char then return {} end
	if type(char.guidenotes) ~= "table" then
		char.guidenotes = {}
	end
	return char.guidenotes
end

function Features:GetGuideNote(guideTitle)
	guideTitle = guideTitle or (CGV.CurrentGuide and CGV.CurrentGuide.title)
	if not guideTitle then return "" end
	local notes = self:GetGuideNotesTable()
	local entry = notes[guideTitle]
	if type(entry) == "table" then
		return entry.text or "", entry.step
	end
	return entry or "", nil
end

function Features:SetGuideNote(text, guideTitle, stepNum)
	guideTitle = guideTitle or (CGV.CurrentGuide and CGV.CurrentGuide.title)
	stepNum = stepNum or (CGV.CurrentStep and CGV.CurrentStep.num)
	if not guideTitle then
		if CGV.Print then CGV:Print("No guide for notes.") end
		return false
	end
	local notes = self:GetGuideNotesTable()
	text = text or ""
	if text == "" then
		notes[guideTitle] = nil
	else
		notes[guideTitle] = { text = text, step = stepNum }
	end
	if CGV.Print then
		CGV:Print(text == "" and ("Cleared note for %s"):format(guideTitle)
			or ("Saved note for %s (step %s)"):format(guideTitle, tostring(stepNum or "?")))
	end
	return true
end

-- Edit via dump box (avoids EditBox inside ResizeToFit popups).
function Features:PromptGuideNote()
	local guide = CGV.CurrentGuide
	if not guide then
		if CGV.Print then CGV:Print("Load a guide first.") end
		return
	end
	local existing = self:GetGuideNote(guide.title)
	local starter = existing ~= "" and existing or ""
	local header = ("-- Guide note for: %s\n-- Print to Chat → copy, then run:\n-- /cgv note <your text>\n\n"):format(guide.title_short or guide.title)
	if CGV.BugReport and CGV.BugReport.ShowDump then
		CGV.BugReport:ShowDump(header .. starter, "Guide note — copy text, then /cgv note …")
	end
	if CGV.Print then
		CGV:Print("Edit the note dump, copy your text, then: /cgv note your text here")
	end
end

function Features:BuildGuideNoteBlock()
	local guide = CGV.CurrentGuide
	if not guide then return "" end
	local text, step = self:GetGuideNote(guide.title)
	if not text or text == "" then return "" end
	return ("GUIDE NOTE (step %s):\n%s\n\n"):format(tostring(step or "?"), text)
end

-----------------------------------------
-- 3. BOOKMARKS / RESUME
-----------------------------------------

function Features:GetBookmarks()
	local char = Char()
	if not char then return {} end
	if type(char.bookmarks) ~= "table" then
		char.bookmarks = {}
	end
	return char.bookmarks
end

function Features:SetBookmark(guideTitle, stepNum)
	if not OptBool("bookmarks", true) then
		if CGV.Print then CGV:Print("Bookmarks are disabled in settings.") end
		return false
	end
	guideTitle = guideTitle or (CGV.CurrentGuide and CGV.CurrentGuide.title)
	stepNum = stepNum or (CGV.CurrentStep and CGV.CurrentStep.num)
	if not guideTitle or not stepNum then
		if CGV.Print then CGV:Print("No guide/step to bookmark.") end
		return false
	end
	local marks = self:GetBookmarks()
	marks[guideTitle] = tonumber(stepNum) or 1
	if CGV.Print then
		CGV:Print(("Bookmarked step %d in %s"):format(marks[guideTitle], guideTitle))
	end
	return true
end

function Features:ClearBookmark(guideTitle)
	guideTitle = guideTitle or (CGV.CurrentGuide and CGV.CurrentGuide.title)
	if not guideTitle then return end
	local marks = self:GetBookmarks()
	marks[guideTitle] = nil
	if CGV.Print then CGV:Print(("Cleared bookmark for %s"):format(guideTitle)) end
end

function Features:ResumeBookmark(guideTitle)
	if not OptBool("bookmarks", true) then
		if CGV.Print then CGV:Print("Bookmarks are disabled in settings.") end
		return false
	end
	guideTitle = guideTitle or (CGV.CurrentGuide and CGV.CurrentGuide.title)
	if not guideTitle then
		if CGV.Print then CGV:Print("No guide to resume.") end
		return false
	end
	local marks = self:GetBookmarks()
	local step = marks[guideTitle]
	if not step then
		if CGV.Print then CGV:Print(("No bookmark for %s"):format(guideTitle)) end
		return false
	end
	if CGV.CurrentGuide and CGV.CurrentGuide.title == guideTitle then
		CGV:FocusStep(step)
	else
		CGV:SetGuide(guideTitle, step)
	end
	if CGV.Print then
		CGV:Print(("Resumed %s at step %d"):format(guideTitle, step))
	end
	return true
end

-----------------------------------------
-- 4. QUEST LINK → JOURNAL
-----------------------------------------

function Features:FindQuestNameFromStep(step)
	step = step or CGV.CurrentStep
	if not step or not step.goals then return nil end
	for _, goal in ipairs(step.goals) do
		if goal.quest and goal.quest ~= "" then
			return goal.quest
		end
	end
end

function Features:OpenQuestInJournal(questName)
	if not OptBool("questlink", true) then return false end
	questName = questName or self:FindQuestNameFromStep()
	if not questName or questName == "" then
		if CGV.Print then CGV:Print("No quest name on this step.") end
		return false
	end

	local journalIndex = CGV.Quests and CGV.Quests:FindQuest(questName)
	if not journalIndex then
		if CGV.Print then
			CGV:Print(("Quest \"%s\" is not in your journal."):format(questName))
		end
		return false
	end

	-- Open journal if possible, then focus / assist the quest.
	if SCENE_MANAGER and SCENE_MANAGER.Show then
		pcall(function() SCENE_MANAGER:Show("questJournal") end)
	end

	local qj = _G.QUEST_JOURNAL_KEYBOARD or _G.QUEST_JOURNAL_MANAGER or _G.ZO_QuestJournal_Keyboard
	if qj then
		if type(qj.FocusQuestWithIndex) == "function" then
			pcall(function() qj:FocusQuestWithIndex(journalIndex) end)
		elseif type(qj.SelectQuest) == "function" then
			pcall(function() qj:SelectQuest(journalIndex) end)
		end
	end

	local tracker = _G.FOCUSED_QUEST_TRACKER or _G.QUEST_TRACKER
	if tracker and type(tracker.ForceAssist) == "function" then
		pcall(function() tracker:ForceAssist(journalIndex) end)
	elseif type(_G.SetAssistedQuestByIndex) == "function" then
		pcall(function() _G.SetAssistedQuestByIndex(journalIndex) end)
	end

	if CGV.Print then
		CGV:Print(("Opened journal for \"%s\"."):format(questName))
	end
	return true
end

-----------------------------------------
-- 5. COMPACT VIEWER PRESET
-----------------------------------------

function Features:ApplyCompactPreset()
	local p = Profile()
	if not p then return end
	p.numStepShow = 1
	p.fontsize = 11
	p.fontsecsize = 9

	-- Sync Home option widgets if present.
	if CGV.db and CGV.db.GetOptionObject then
		for _, name in ipairs({ "numStepShow", "fontsize", "fontsecsize" }) do
			local opt = CGV.db:GetOptionObject(name)
			if opt then
				if opt.frame and opt.frame.SetValue then
					opt.frame:SetValue(p[name])
				elseif opt.SetValue then
					opt:SetValue(p[name])
				end
			end
		end
	end

	if CGV.Viewer then
		if CGV.Viewer.Update then CGV.Viewer:Update(true) end
		if CGV.Viewer.ResizeToFitSteps then CGV.Viewer:ResizeToFitSteps() end
	end
	if CGV.PopupHandler and CGV.PopupHandler.SyncLiveSettings then
		CGV.PopupHandler:SyncLiveSettings()
	end
	if CGV.Print then
		CGV:Print("Compact viewer preset applied (1 step, smaller text).")
	end
end

-----------------------------------------
-- 6. ZONE-CHANGE SOFT NUDGE
-----------------------------------------

Features._lastNudgeZone = nil
Features._nudgeCooldownUntil = 0

local function GuideMatchesZone(guide, zoneLower)
	if not guide or zoneLower == "" then return false end
	local title = (guide.title or ""):lower()
	local short = (guide.title_short or ""):lower()
	return title:find(zoneLower, 1, true) or short:find(zoneLower, 1, true)
end

local function IsMidChapter()
	local guide = CGV.CurrentGuide
	if not guide then return false end
	local pct = nil
	if guide.GetCompletion then
		local ok, result = pcall(function()
			local s, _, comp = guide:GetCompletion()
			return tonumber(comp) or (type(s) == "string" and tonumber(s:match("(%d+)"))) or nil
		end)
		if ok then pct = result end
	end
	if not pct then
		local n = CGV.CurrentStepNum or 1
		local total = guide.steps and #guide.steps or 1
		if total <= 1 then return false end
		pct = (n / total) * 100
	end
	return pct > 5 and pct < 95
end

function Features:MaybeZoneNudge()
	if not OptBool("zone_nudge", true) then return end
	if not (CGV.Frame and CGV.Frame:IsShown()) then return end
	if GetFrameTimeSeconds() < (self._nudgeCooldownUntil or 0) then return end

	local zone = GetZoneNameByIndex(GetCurrentMapZoneIndex()) or ""
	local zoneLower = zone:lower()
	if zoneLower == "" then return end
	if self._lastNudgeZone == zoneLower then return end

	local cur = CGV.CurrentGuide
	if cur and GuideMatchesZone(cur, zoneLower) then
		self._lastNudgeZone = zoneLower
		return
	end

	-- Soft: don't interrupt mid-chapter progress on another guide.
	if cur and IsMidChapter() then
		return
	end

	local best = CGV.GetBestSuggestedGuide and CGV:GetBestSuggestedGuide()
	if not best then return end
	if cur and best.title == cur.title then
		self._lastNudgeZone = zoneLower
		return
	end
	if not GuideMatchesZone(best, zoneLower) then
		-- Best isn't for this zone — still ok if title matches zone string via GetBest.
		-- Only nudge when best looks like this zone.
		return
	end

	local ignored = (CGV.db and CGV.db.char and CGV.db.char.ignoredguides) or {}
	if ignored[best.title] then return end
	if self.IsSuggestionSnoozed and self:IsSuggestionSnoozed(best.title) then return end

	self._lastNudgeZone = zoneLower
	self._nudgeCooldownUntil = GetFrameTimeSeconds() + 120
	self:ShowZoneNudgePopup(best, zone)
end

function Features:ShowZoneNudgePopup(guide, zone)
	local popup = self.ZoneNudgePopup
	if popup and popup.IsModalTopLevel and popup:IsModalTopLevel() then
		popup:Hide()
		self.ZoneNudgePopup = nil
		popup = nil
	end
	if not popup then
		popup = CGV.Popup:New("CGESO_ZoneNudge_Overlay",nil,true)
		popup:EnableGuideViewerAnchor()
		popup.OnAccept = function(me)
			me._suggestHandled = true
			if me.guide then
				CGV:SetGuide(CGV.GetPreferredGuideVariant and CGV:GetPreferredGuideVariant(me.guide) or me.guide)
			end
		end
		popup.OnDecline = function(me)
			me._suggestHandled = true
			if me.guide and me.guide.title then
				Features:SnoozeSuggestion(me.guide.title)
			end
		end
		self.ZoneNudgePopup = popup
	elseif popup.EnableGuideViewerAnchor then
		popup:EnableGuideViewerAnchor()
	end
	popup.guide = guide
	popup._suggestHandled = nil
	if popup.declinebutton then
		popup.declinebutton:SetText(CGV.L and CGV.L['static_notnow'] or "Not now")
		if popup.declinebutton.ResizeToPerfect then popup.declinebutton:ResizeToPerfect() end
	end
	popup:SetText(
		"You're in a different zone.",
		guide.title_short or guide.title or "?",
		("Load the %s guide?\nNot now = snooze. Close keeps your current guide."):format(zone or "this zone")
	)
	popup:Show()
end

function Features:OnZoneChanged()
	-- Defer slightly so map/zone APIs settle.
	if self._zoneNudgePending then return end
	self._zoneNudgePending = true
	_G.zo_callLater(function()
		self._zoneNudgePending = false
		self:MaybeZoneNudge()
	end, 1500)
end

-----------------------------------------
-- 7. AUTHORING: /cgpos HISTORY + TEMPLATE
-----------------------------------------

Features.cgposHistory = Features.cgposHistory or {}

function Features:RecordCgpos(entry)
	if type(entry) ~= "string" or entry == "" then return end
	tinsert(self.cgposHistory, 1, {
		time = GetFrameTimeSeconds(),
		text = entry,
	})
	while #self.cgposHistory > CGPOS_HISTORY_MAX do
		tremove(self.cgposHistory)
	end
end

function Features:PrintCgposHistory()
	if #self.cgposHistory == 0 then
		d("|cfd5b02/cgpos history:|r no entries yet. Run |cffffff/cgpos|r or |cffffff/cgpos gps|r first.")
		return
	end
	d(("|cfd5b02/cgpos history|r (%d):"):format(#self.cgposHistory))
	for i, e in ipairs(self.cgposHistory) do
		d(("|cffaa55#%d|r %s"):format(i, e.text:gsub("\n", " · ")))
	end
end

function Features:BuildStepTemplate()
	local map = (CGV.Pointer and CGV.Pointer.GetMapTex and CGV.Pointer:GetMapTex()) or "?"
	local x, y = GetMapPlayerPosition("player")
	x = (x or 0) * 100
	y = (y or 0) * 100
	local zone = GetZoneNameByIndex(GetCurrentMapZoneIndex()) or GetMapName() or ""
	local lines = {
		("step\t\t-- %s"):format(zone),
		("\tgoto %s %.2f,%.2f"):format(map, x, y),
		("\ttalk "),
		("\taccept "),
		("\tturnin "),
	}
	return table.concat(lines, "\n")
end

function Features:CopyStepTemplate()
	local text = self:BuildStepTemplate()
	self:RecordCgpos("template:\n" .. text)
	if CGV.BugReport and CGV.BugReport.ShowDump then
		CGV.BugReport:ShowDump(text, "Step template (Print to Chat)")
	else
		d("|cfd5b02Step template:|r")
		d(text)
	end
	return text
end

-- One pasteable pack: goto line + MapData-style offsets (for authoring / Solstice fixes).
function Features:CopyMapDataPack()
	local Pointer = CGV.Pointer
	local GPS = _G.LibGPS3
	local tex = Pointer and Pointer.GetMapTex and Pointer:GetMapTex() or "?"
	local x, y = GetMapPlayerPosition("player")
	x = (x or 0) * 100
	y = (y or 0) * 100
	local offsetX, offsetY, scaleX = 0, 0, 0
	local gps = GPS and GPS.GetCurrentMapMeasurement and GPS:GetCurrentMapMeasurement()
	if gps then
		offsetX = gps.GetOffset and select(1, gps:GetOffset()) or gps.offsetX or 0
		offsetY = gps.GetOffset and select(2, gps:GetOffset()) or gps.offsetY or 0
		scaleX = gps.GetScale and select(1, gps:GetScale()) or gps.scaleX or 0
	end
	local zone = GetZoneNameByIndex(GetCurrentMapZoneIndex()) or GetMapName() or ""
	local lines = {
		("-- MapData / guide pack: %s"):format(zone),
		("-- DDS / tex: %s"):format(tex),
		("goto %s %.2f,%.2f"):format(tex, x, y),
		("xoffset = %.19f"):format(offsetX),
		("yoffset = %.19f"):format(offsetY),
		("scale = %.19f"):format(scaleX),
		(""),
		self:BuildStepTemplate(),
	}
	local text = table.concat(lines, "\n")
	self:RecordCgpos("pack:\n" .. text)
	if CGV.BugReport and CGV.BugReport.ShowDump then
		CGV.BugReport:ShowDump(text, "MapData pack (Print to Chat)")
	else
		d(text)
	end
	return text
end

-----------------------------------------
-- WAYSHRINE / DOOR LIST (Creator; Solstice-safe)
-- Lists POIs from the live zone API instead of the
-- guide `wayshrine Name` matcher (which fails in some zones).
-----------------------------------------

function Features:ListZoneWayshrinesAndDoors()
	local zid = GetCurrentMapZoneIndex()
	if not zid or zid <= 0 then
		d("|cfd5b02POI list:|r no zone index yet — open the map once.")
		return
	end
	local zone = GetZoneNameByIndex(zid) or GetMapName() or "?"
	local tex = (CGV.Pointer and CGV.Pointer.GetMapTex and CGV.Pointer:GetMapTex()) or "?"
	local num = GetNumPOIs and GetNumPOIs(zid) or 0
	local lines = {
		("-- POIs for %s (zoneIndex %d) tex=%s"):format(zone, zid, tex),
		("-- Use these names/indexes when `wayshrine Name` fails (e.g. Solstice)."),
		("-- Click a line format below into your guide, or goto from /cgpos pack."),
	}
	local shrines, doors = {}, {}
	for i = 1, num do
		local name = GetPOIInfo(zid, i)
		if name and name ~= "" then
			local _, _, pinType = GetPOIMapInfo(zid, i, true)
			local done = (pinType == MAP_PIN_TYPE_POI_COMPLETE)
			local lower = name:lower()
			local isShrine = (IsPOIWayshrine and IsPOIWayshrine(zid, i))
				or lower:find("wayshrine", 1, true)
			local isDoor = lower:find("door", 1, true) or lower:find("entrance", 1, true) or lower:find("portal", 1, true)
			local row = ("  [%d] %s%s%s"):format(
				i,
				name,
				isShrine and "  |c88ff88(wayshrine)|r" or "",
				done and "  |cffaa55[discovered]|r" or "  |caaaaaa[undiscovered]|r"
			)
			local plain = ("-- POI %d: %s%s"):format(i, name, isShrine and " (wayshrine)" or "")
			if isShrine then
				tinsert(shrines, row)
				tinsert(lines, ("wayshrine %s"):format(name:gsub("%s+Wayshrine%s*$", ""):gsub("^%s+", ""):gsub("%s+$", "")))
				tinsert(lines, plain)
			elseif isDoor then
				tinsert(doors, row)
				tinsert(lines, plain)
			end
		end
	end

	d(("|cfd5b02POIs in %s|r (zoneIndex %d, %d pins) — scrollable dump window"):format(zone, zid, num))
	if #shrines == 0 then
		d("|c88ff88Wayshrines:|r (none flagged IsPOIWayshrine — see full index in dump)")
	else
		d(("|c88ff88Wayshrines:|r %d (see dump window)"):format(#shrines))
	end

	-- Full index lives in the scrollable dump (not chat-only).
	tinsert(lines, "")
	tinsert(lines, "-- All POIs (index = GetPOIInfo):")
	for i = 1, num do
		local name = GetPOIInfo(zid, i)
		if name and name ~= "" then
			local lower = name:lower()
			local isShrine = (IsPOIWayshrine and IsPOIWayshrine(zid, i))
				or lower:find("wayshrine", 1, true)
			local _, _, pinType = GetPOIMapInfo(zid, i, true)
			local done = (pinType == MAP_PIN_TYPE_POI_COMPLETE)
			tinsert(lines, ("  %3d  %s%s%s"):format(
				i,
				name,
				isShrine and "  [WS]" or "",
				done and "  done" or ""
			))
		end
	end

	local dump = table.concat(lines, "\n")
	if CGV.BugReport and CGV.BugReport.ShowDump then
		CGV.BugReport:ShowDump(dump, "Zone POIs (scroll + Print to Chat)")
	end
	return dump
end

function Features:FormatCgposDump(kind)
	local Pointer = CGV.Pointer
	local GPS = _G.LibGPS3
	local tex = Pointer and Pointer.GetMapTex and Pointer:GetMapTex() or "?"
	local x, y = GetMapPlayerPosition("player")
	x = (x or 0) * 100
	y = (y or 0) * 100

	local offsetX, offsetY, scaleX = 0, 0, 0
	local gps = GPS and GPS.GetCurrentMapMeasurement and GPS:GetCurrentMapMeasurement()
	if gps then
		offsetX = gps.GetOffset and select(1, gps:GetOffset()) or gps.offsetX or 0
		offsetY = gps.GetOffset and select(2, gps:GetOffset()) or gps.offsetY or 0
		scaleX = gps.GetScale and select(1, gps:GetScale()) or gps.scaleX or 0
	elseif Pointer and Pointer.Zones and Pointer.Zones[tex] then
		local Z = Pointer.Zones[tex]
		offsetX = Z.xoffset or 0
		offsetY = Z.yoffset or 0
		scaleX = Z.scale or 0
	end

	if kind == "gps" then
		return ("%s\nxoffset=%.19f\nyoffset=%.19f\nscale=%.19f\npos=%.2f,%.2f"):format(
			tex, offsetX, offsetY, scaleX, x, y)
	end
	local Z = Pointer and Pointer.Zones and Pointer.Zones[tex]
	return ("%s\nxoffset=%.19f\nyoffset=%.19f\nscale=%.19f\npos=%.2f,%.2f"):format(
		tex,
		Z and Z.xoffset or offsetX,
		Z and Z.yoffset or offsetY,
		scaleX,
		x, y)
end

-----------------------------------------
-- SUGGESTION SNOOZE ("Not now")
-----------------------------------------

Features.suggestionSnooze = Features.suggestionSnooze or {}

function Features:SnoozeSuggestion(title, seconds)
	if not title then return end
	seconds = seconds or (OptNum("suggest_snooze_minutes", 30) * 60)
	if seconds < 60 then seconds = 60 end
	self.suggestionSnooze = self.suggestionSnooze or {}
	self.suggestionSnooze[title] = GetFrameTimeSeconds() + seconds
	d(("|cfd5b02CGESO:|r snoozed suggestion for %d min — %s"):format(
		math.floor(seconds / 60 + 0.5), tostring(title)))
end

function Features:IsSuggestionSnoozed(title)
	if not title then return false end
	local untilT = self.suggestionSnooze and self.suggestionSnooze[title]
	if not untilT then return false end
	if GetFrameTimeSeconds() >= untilT then
		self.suggestionSnooze[title] = nil
		return false
	end
	return true
end

-----------------------------------------
-- UNDO LAST SKIP / MARK DONE
-----------------------------------------

function Features:RecordUndoPoint()
	local guide = CGV.CurrentGuide
	local step = CGV.CurrentStep
	if not guide or not step then return end
	self.undoPoint = {
		title = guide.title,
		step = step.num,
	}
end

function Features:UndoLastSkip()
	local u = self.undoPoint
	if not u or not u.title or not u.step then
		d("|cfd5b02CGESO:|r nothing to undo.")
		return
	end
	self.undoPoint = nil
	if CGV.SetGuide then
		CGV:SetGuide(u.title, u.step)
		d(("|cfd5b02CGESO:|r restored step %s"):format(tostring(u.step)))
	end
end

-----------------------------------------
-- IN-GUIDE STEP SEARCH
-----------------------------------------

function Features:SearchCurrentGuide(query)
	query = tostring(query or ""):match("^%s*(.-)%s*$") or ""
	if query == "" then
		d("|cfd5b02/cgv find <text>|r — search the current guide.")
		return
	end
	local guide = CGV.CurrentGuide
	if not guide or not guide.steps then
		d("|cfd5b02CGESO:|r no current guide.")
		return
	end
	local q = query:lower()
	local hits = {}
	for i, step in ipairs(guide.steps) do
		local blob = ""
		if step.goals then
			for _, goal in ipairs(step.goals) do
				if goal then
					if goal.GetText then blob = blob .. " " .. StripColors(goal:GetText()) end
					if goal.quest then blob = blob .. " " .. tostring(goal.quest) end
					if goal.wayshrine then blob = blob .. " " .. tostring(goal.wayshrine) end
					if goal.action then blob = blob .. " " .. tostring(goal.action) end
				end
			end
		end
		if blob:lower():find(q, 1, true) then
			local preview = StripColors(blob):gsub("%s+", " "):match("^%s*(.-)%s*$") or ""
			if #preview > 90 then preview = preview:sub(1, 87) .. "…" end
			tinsert(hits, { num = i, preview = preview })
		end
	end
	if #hits == 0 then
		d(("|cfd5b02CGESO find:|r no steps matching \"%s\""):format(query))
		return
	end
	local lines = { ("-- Find \"%s\" in %s (%d hits)"):format(
		query, guide.title_short or guide.title or "?", #hits) }
	d(("|cfd5b02CGESO find:|r %d hit(s) — /cgv step N to jump"):format(#hits))
	for _, h in ipairs(hits) do
		d(("  |cffffff%d|r  %s"):format(h.num, h.preview))
		tinsert(lines, ("%d  %s"):format(h.num, h.preview))
		if #lines > 60 then
			tinsert(lines, "…truncated")
			break
		end
	end
	if CGV.BugReport and CGV.BugReport.ShowDump then
		CGV.BugReport:ShowDump(table.concat(lines, "\n"), "Guide find (Print to Chat)")
	end
end

function Features:JumpToStepNum(num)
	num = tonumber(num)
	if not num then
		d("|cfd5b02/cgv step <number>|r")
		return
	end
	local guide = CGV.CurrentGuide
	if not guide or not guide.steps or not guide.steps[num] then
		d("|cfd5b02CGESO:|r invalid step.")
		return
	end
	self:RecordUndoPoint()
	if CGV.FocusStep then
		CGV:FocusStep(guide.steps[num])
	elseif CGV.SetGuide then
		CGV:SetGuide(guide, num)
	end
end

-----------------------------------------
-- COPY CURRENT STEP (AUTHORING)
-----------------------------------------

function Features:CopyCurrentStep()
	local guide = CGV.CurrentGuide
	local step = CGV.CurrentStep
	if not step then
		d("|cfd5b02CGESO:|r no current step.")
		return
	end
	local lines = {
		("-- Current step %s — %s"):format(
			tostring(step.num),
			guide and (guide.title_short or guide.title) or "?"),
		"step",
	}
	if step.goals then
		for _, goal in ipairs(step.goals) do
			if goal then
				local action = goal.action or ""
				local text = goal.GetText and StripColors(goal:GetText()) or ""
				if action == "goto" and goal.map and goal.x and goal.y then
					tinsert(lines, ("goto %s %.2f,%.2f"):format(
						goal.map, goal.x * 100, goal.y * 100))
				elseif action == "wayshrine" and goal.wayshrine then
					tinsert(lines, ("wayshrine %s"):format(goal.wayshrine))
				elseif action ~= "" and text ~= "" then
					tinsert(lines, ("-- %s: %s"):format(action, text))
				elseif text ~= "" then
					tinsert(lines, ("-- %s"):format(text))
				end
			end
		end
	end
	local text = table.concat(lines, "\n")
	if CGV.BugReport and CGV.BugReport.ShowDump then
		CGV.BugReport:ShowDump(text, "Current step (Print to Chat)")
	else
		d(text)
	end
	return text
end

-----------------------------------------
-- ESOUI GALLERY CHECKLIST
-----------------------------------------

function Features:ShowGalleryChecklist()
	local text = table.concat({
		"ESOUI gallery export checklist",
		"",
		"1. Capture full in-game screenshots (not cropped UI-only).",
		"2. Export as PNG, stretch-fill to exactly 799×498.",
		"3. No side bars, letterboxing, or black pillars.",
		"4. Prefer Guide Viewer, Home, Settings, waypoint, and zone shots.",
		"5. Upload on ESOUI when bumping the addon version.",
		"",
		"Preference: stretch-fill 799×498 PNG — no side bars.",
	}, "\n")
	if CGV.BugReport and CGV.BugReport.ShowDump then
		CGV.BugReport:ShowDump(text, "ESOUI gallery checklist")
	end
	d("|cfd5b02CGESO:|r ESOUI gallery — 799×498 stretch-fill PNG, no side bars.")
	return text
end

-----------------------------------------
-- CLEAR IGNORED GUIDES
-----------------------------------------

function Features:ListIgnoredGuides()
	local ignored = (CGV.db and CGV.db.char and CGV.db.char.ignoredguides) or {}
	local lines = { "-- Ignored guides (Close-X forever on suggestions)" }
	local n = 0
	for title, v in pairs(ignored) do
		if v then
			n = n + 1
			tinsert(lines, title)
			d(("  |cffffff%s|r"):format(tostring(title)))
		end
	end
	if n == 0 then
		d("|cfd5b02CGESO:|r no ignored guides.")
		tinsert(lines, "(none)")
	else
		d(("|cfd5b02CGESO:|r %d ignored — /cgv unignore or Clear ignored guides"):format(n))
	end
	if CGV.BugReport and CGV.BugReport.ShowDump then
		CGV.BugReport:ShowDump(table.concat(lines, "\n"), "Ignored guides")
	end
end

function Features:ClearIgnoredGuides()
	if not (CGV.db and CGV.db.char) then return end
	CGV.db.char.ignoredguides = {}
	d("|cfd5b02CGESO:|r cleared ignored guides.")
end

function Features:UnignoreGuide(title)
	title = tostring(title or ""):match("^%s*(.-)%s*$") or ""
	if title == "" then
		self:ListIgnoredGuides()
		return
	end
	local ignored = CGV.db and CGV.db.char and CGV.db.char.ignoredguides
	if ignored and ignored[title] then
		ignored[title] = nil
		d(("|cfd5b02CGESO:|r unignored %s"):format(title))
	else
		-- fuzzy: match short name
		local hit
		if ignored then
			for t, v in pairs(ignored) do
				if v and (t == title or (tostring(t):lower():find(title:lower(), 1, true))) then
					ignored[t] = nil
					hit = t
					break
				end
			end
		end
		if hit then
			d(("|cfd5b02CGESO:|r unignored %s"):format(hit))
		else
			d("|cfd5b02CGESO:|r not found in ignored list.")
		end
	end
end

-----------------------------------------
-- STEP HISTORY RING
-----------------------------------------

local STEP_HISTORY_MAX = 20
Features.stepHistory = Features.stepHistory or {}

function Features:PushStepHistory(guideTitle, stepNum)
	if not guideTitle or not stepNum then return end
	self.stepHistory = self.stepHistory or {}
	local last = self.stepHistory[1]
	if last and last.title == guideTitle and last.step == stepNum then
		return
	end
	tinsert(self.stepHistory, 1, { title = guideTitle, step = stepNum })
	while #self.stepHistory > STEP_HISTORY_MAX do
		tremove(self.stepHistory)
	end
end

function Features:StepHistoryBack()
	local h = self.stepHistory
	if not h or #h < 2 then
		d("|cfd5b02CGESO:|r no earlier step in history.")
		return
	end
	-- [1] is current; jump to [2] and rotate
	local prev = h[2]
	tremove(h, 1)
	if CGV.SetGuide then
		CGV:SetGuide(prev.title, prev.step)
		d(("|cfd5b02CGESO:|r history → step %s"):format(tostring(prev.step)))
	end
end

function Features:PrintStepHistory()
	local h = self.stepHistory or {}
	d(("|cfd5b02CGESO step history|r (%d) — /cgv back"):format(#h))
	for i, e in ipairs(h) do
		d(("  %d. step %s — %s"):format(i, tostring(e.step), tostring(e.title)))
		if i >= 12 then break end
	end
end

-----------------------------------------
-- MQO ↔ FULL JUMP
-----------------------------------------

function Features:SwitchGuideStyle()
	local cur = CGV.CurrentGuide
	if not cur or not CGV.GetGuideStylePair then
		d("|cfd5b02CGESO:|r no current guide.")
		return
	end
	local fullGuide, mqoGuide = CGV:GetGuideStylePair(cur)
	if not fullGuide or not mqoGuide then
		d("|cfd5b02CGESO:|r no Full/MQO pair for this guide.")
		return
	end
	local target = (cur == mqoGuide or (cur.title and mqoGuide.title and cur.title == mqoGuide.title))
		and fullGuide or mqoGuide
	-- Prefer same step number when possible; else step 1.
	local stepNum = (CGV.CurrentStep and CGV.CurrentStep.num) or 1
	if target.steps and not target.steps[stepNum] then
		stepNum = 1
	end
	self:RecordUndoPoint()
	CGV:SetGuide(target, stepNum)
	d(("|cfd5b02CGESO:|r switched to %s (step %s)"):format(
		target.title_short or target.title or "?", tostring(stepNum)))
end

-----------------------------------------
-- DOOR / PORTAL NEARBY ASSIST
-----------------------------------------

function Features:IsNearMatchingDoorPOI(needle)
	if not OptBool("door_nearby", true) then return false end
	needle = StripColors(needle or ""):lower()
	if needle == "" then return false end
	-- Only for open/enter/portal style goals.
	if not (needle:find("open", 1, true) or needle:find("enter", 1, true)
		or needle:find("portal", 1, true) or needle:find("door", 1, true)
		or needle:find("climb", 1, true) or needle:find("travel", 1, true)) then
		return false
	end
	local zid = GetCurrentMapZoneIndex and GetCurrentMapZoneIndex()
	if not zid or zid <= 0 or not GetNumPOIs then return false end
	local px, py = GetMapPlayerPosition("player")
	if not px then return false end
	local num = GetNumPOIs(zid) or 0
	local near2 = 0.02 * 0.02
	for i = 1, num do
		local name = GetPOIInfo(zid, i)
		if name and name ~= "" then
			local lower = name:lower()
			local isDoor = lower:find("door", 1, true) or lower:find("entrance", 1, true)
				or lower:find("portal", 1, true) or lower:find("gate", 1, true)
			if isDoor then
				-- needle mentions this POI name (or stripped place)
				local place = lower:gsub("%s+wayshrine%s*$", "")
				local hit = false
				if #place >= 4 and needle:find(place, 1, true) then hit = true end
				if not hit then
					for token in place:gmatch("%S+") do
						if #token >= 4 and needle:find(token, 1, true) then hit = true break end
					end
				end
				if hit then
					local poiX, poiY = GetPOIMapInfo(zid, i, true)
					if poiX and poiY then
						local dx, dy = px - poiX, py - poiY
						if (dx * dx + dy * dy) <= near2 then
							return true
						end
					end
				end
			end
		end
	end
	return false
end

-----------------------------------------
-- UPLOAD-DAY CHECKLIST
-----------------------------------------

function Features:ShowUploadChecklist()
	local ver = tostring(CGV.version or "?")
	local toc = "?"
	if CGV.AddonVersion then toc = tostring(CGV.AddonVersion) end
	local text = table.concat({
		"CGESO upload-day checklist",
		"",
		("Current version string: %s"):format(ver),
		("AddOnVersion: %s"):format(toc),
		"",
		"1. Bump Version + AddOnVersion in CGESO.txt (Shawn owns the numbers).",
		"2. Date the README TBD changelog block (and keep Summary accurate).",
		"3. ESOUI gallery: stretch-fill 799×498 PNG — no side bars (see /cgv gallery).",
		"4. Confirm no Art/ gallery folder left inside the addon zip.",
		"5. Libraries: LibGPS3, LibMapPing, LibDebugLogger, LibChatMessage (ESOLL).",
		"6. Smoke: viewer, suggestion overlay mouse, /cgpos poi, one wayshrine green.",
		"7. Zip and upload to ESOUI / GitHub yourself (agents do not push).",
		"",
		"When ready: bump versions, then package.",
	}, "\n")
	if CGV.BugReport and CGV.BugReport.ShowDump then
		CGV.BugReport:ShowDump(text, "Upload-day checklist")
	end
	d("|cfd5b02CGESO:|r upload checklist opened — bump version when YOU upload.")
	return text
end

-----------------------------------------
-- NEXT-XPAC MAPDATA SCAFFOLD
-----------------------------------------

function Features:ShowMapDataScaffold()
	local lastId = 0
	local MD = CGV.MapData
	if MD then
		for _, block in pairs(MD) do
			if type(block) == "table" then
				for k, row in pairs(block) do
					if type(row) == "table" and type(row.id) == "number" and row.id > lastId then
						lastId = row.id
					elseif type(k) == "number" and type(row) == "string" and k > lastId then
						lastId = k
					end
				end
			end
		end
	end
	local nextId = lastId + 1
	local text = table.concat({
		"Next-xpac MapData scaffold",
		"",
		("Highest MapData id found: %d"):format(lastId),
		("Next new minimap name should use id: %d"):format(nextId),
		"",
		"Rules (preferences):",
		"- Same minimap name → reuse same id.",
		"- New name → last id + 1.",
		"- DDS names from UESP esofiles update-N/maps.zip (full xpac folder, not QoL).",
		"- Wire offsets from /cgpos gps; Shawn hand-tunes instance/door entrances only.",
		"- Do not invent overland offsets.",
		"",
		"Stub example (paste into Travel/MapData.lua when chapter lands):",
		"",
		"-- CHAPTERNAME",
		'["Zone Display Name"] = [[texname_base]],',
		'["texname_base"] = { name = "Zone Display Name", id = '
			.. tostring(nextId) .. ", xoffset = 0, yoffset = 0, scale = 0, },",
		("  [%d] = \"Zone Display Name\","):format(nextId),
		"",
		"Latest content dump note: update-51 (as of 2026-11-14). Re-check before next chapter.",
		"Run /cgpos pack in-zone after maps exist to fill real offsets.",
	}, "\n")
	if CGV.BugReport and CGV.BugReport.ShowDump then
		CGV.BugReport:ShowDump(text, "MapData scaffold")
	end
	d(("|cfd5b02CGESO:|r MapData next id ≈ %d — see dump."):format(nextId))
	return text
end

-----------------------------------------
-- SUGGESTION-READY CHAT PING
-----------------------------------------

function Features:PingSuggestionReady(guide)
	if not OptBool("suggest_ready_ping", true) then return end
	local name = guide and (guide.title_short or guide.title) or "a guide"
	d(("|cfd5b02CGESO:|r suggestion ready — open the Guide Viewer (%s)"):format(tostring(name)))
end

-----------------------------------------
-- VIEWER FIND OVERLAY (non-modal)
-----------------------------------------

function Features:ToggleViewerFind()
	local viewer = CGV.Frame or (CGV.Viewer and CGV.Viewer.Frame)
	if not viewer then
		d("|cfd5b02CGESO:|r open the Guide Viewer first.")
		return
	end
	local ui, CHAIN = CGV.UI, CGV.Utils.ChainCall
	local name = "CGESO_ViewerFindOverlay"
	local frame = self.FindOverlay
	if frame and not frame:IsHidden() then
		frame:SetHidden(true)
		if frame.edit and frame.edit.LoseFocus then pcall(function() frame.edit:LoseFocus() end) end
		if _G.SetGameCameraUIMode then pcall(function() _G.SetGameCameraUIMode(false) end) end
		return
	end
	if not frame then
		frame = CHAIN(ui:Create("Frame", viewer:GetParent() or _G.GuiRoot, name, true))
			:SetSize(280, 54)
			:SetPoint(_G.TOP, viewer, _G.TOP, 0, -58)
			:SetMouseEnabled(true)
			.__END
		frame.label = CHAIN(ui:Create("Label", frame, name.."_L", 12))
			:SetPoint(_G.TOPLEFT, frame, 8, 4)
			:SetText("Find in guide — Enter = search")
			.__END
		frame.edit = CHAIN(ui:Create("EditBox", frame, name.."_E"))
			:SetPoint(_G.TOPLEFT, frame, 8, 22)
			:SetDimensions(200, 22)
			:SetMaxInputChars(80)
			.__END
		frame.go = CHAIN(ui:Create("Button", frame, name.."_Go"))
			:SetSize(56, 22)
			:SetText("Go")
			:SetPoint(_G.LEFT, frame.edit, _G.RIGHT, 6, 0)
			:SetHandler("OnClicked", function()
				local q = frame.edit:GetText() or ""
				if frame.edit.LoseFocus then frame.edit:LoseFocus() end
				frame:SetHidden(true)
				if _G.SetGameCameraUIMode then pcall(function() _G.SetGameCameraUIMode(false) end) end
				Features:SearchCurrentGuide(q)
			end)
			.__END
		frame.edit:SetHandler("OnEnter", function(me)
			local q = me:GetText() or ""
			me:LoseFocus()
			frame:SetHidden(true)
			if _G.SetGameCameraUIMode then pcall(function() _G.SetGameCameraUIMode(false) end) end
			Features:SearchCurrentGuide(q)
		end)
		frame.edit:SetHandler("OnEscape", function(me)
			me:LoseFocus()
			frame:SetHidden(true)
			if _G.SetGameCameraUIMode then pcall(function() _G.SetGameCameraUIMode(false) end) end
			return true
		end)
		self.FindOverlay = frame
	end
	frame:SetHidden(false)
	if frame.edit.TakeFocus then frame.edit:TakeFocus() end
end

-----------------------------------------
-- TICK / EVENTS / SLASH
-----------------------------------------

function Features:OnViewerUpdate()
	self:CheckStuckStep()
end

local function registerSlash()
	local slash = _G.SLASH_COMMANDS
	local prev = slash["/cgpos"]
	slash["/cgpos"] = function(args)
		args = (args or ""):match("^%s*(.-)%s*$") or ""
		local cmd = args:lower()
		if cmd == "history" then
			Features:PrintCgposHistory()
			return
		end
		if cmd == "template" or cmd == "step" then
			Features:CopyStepTemplate()
			return
		end
		if cmd == "pack" or cmd == "mapdata" then
			Features:CopyMapDataPack()
			return
		end
		if cmd == "poi" or cmd == "wayshrines" or cmd == "doors" then
			Features:ListZoneWayshrinesAndDoors()
			return
		end
		-- Run original, then record.
		if prev then prev(args) end
		local kind = (cmd == "gps") and "gps" or "pos"
		local dump = Features:FormatCgposDump(kind)
		Features:RecordCgpos(dump)
	end
end

tinsert(CGV.startups, function()
	registerSlash()

	-- Hook FocusStep to reset stuck timer + step history ring.
	if CGV.FocusStep then
		local orig = CGV.FocusStep
		CGV.FocusStep = function(self, num, quiet)
			local r1, r2, r3 = orig(self, num, quiet)
			Features:NotifyStepFocused()
			local g = CGV.CurrentGuide
			local s = CGV.CurrentStep
			if g and s then
				Features:PushStepHistory(g.title, s.num)
			end
			return r1, r2, r3
		end
	end

	-- Undo point before skip / mark done.
	if CGV.SkipStep then
		local origSkip = CGV.SkipStep
		CGV.SkipStep = function(self, ...)
			Features:RecordUndoPoint()
			return origSkip(self, ...)
		end
	end

	-- Zone change → soft nudge.
	if CGV.Events and _G.EVENT_ZONE_CHANGED then
		CGV.Events:AddEvent(_G.EVENT_ZONE_CHANGED, function()
			Features:OnZoneChanged()
		end)
	end
	if CGV.Events and _G.EVENT_PLAYER_ACTIVATED then
		CGV.Events:AddEvent(_G.EVENT_PLAYER_ACTIVATED, function()
			Features:OnZoneChanged()
		end)
	end

	Features:NotifyStepFocused()
	CGV:Debug("&startup Features QoL ready")
end)
