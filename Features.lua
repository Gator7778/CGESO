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
	if not popup then
		popup = CGV.Popup:New("CGESO_StuckStep_Popup")
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
	local header = ("-- Guide note for: %s\n-- Edit the text below, Ctrl+C, then run:\n-- /cgv note <your text>\n-- Or paste here and use Accept in chat after copying.\n\n"):format(guide.title_short or guide.title)
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

	self._lastNudgeZone = zoneLower
	self._nudgeCooldownUntil = GetFrameTimeSeconds() + 120
	self:ShowZoneNudgePopup(best, zone)
end

function Features:ShowZoneNudgePopup(guide, zone)
	local popup = self.ZoneNudgePopup
	if not popup then
		popup = CGV.Popup:New("CGESO_ZoneNudge_Popup")
		popup.OnAccept = function(me)
			if me.guide then
				CGV:SetGuide(CGV.GetPreferredGuideVariant and CGV:GetPreferredGuideVariant(me.guide) or me.guide)
			end
		end
		self.ZoneNudgePopup = popup
	end
	popup.guide = guide
	popup:SetText(
		"You're in a different zone.",
		guide.title_short or guide.title or "?",
		("Load the %s guide?\n(Decline keeps your current guide.)"):format(zone or "this zone")
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
		CGV.BugReport:ShowDump(text, "Step template (Ctrl+C to copy)")
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
		CGV.BugReport:ShowDump(text, "MapData pack (Ctrl+C to copy)")
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
			local isShrine = IsPOIWayshrine and IsPOIWayshrine(zid, i)
			local lower = name:lower()
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

	d(("|cfd5b02POIs in %s|r (zoneIndex %d, %d pins)"):format(zone, zid, num))
	d("|c88ff88Wayshrines:|r")
	if #shrines == 0 then
		d("  (none flagged IsPOIWayshrine — listing name matches / all pins below)")
	else
		for _, r in ipairs(shrines) do d(r) end
	end
	if #doors > 0 then
		d("|cffaa55Doors / entrances / portals (by name):|r")
		for _, r in ipairs(doors) do d(r) end
	end
	-- Always dump a full numbered list so Solstice (and similar) still works
	-- when IsPOIWayshrine returns false for valid travel pins.
	d("|cffffffAll POIs (index = GetPOIInfo):|r")
	for i = 1, num do
		local name = GetPOIInfo(zid, i)
		if name and name ~= "" then
			local isShrine = IsPOIWayshrine and IsPOIWayshrine(zid, i)
			local _, _, pinType = GetPOIMapInfo(zid, i, true)
			local done = (pinType == MAP_PIN_TYPE_POI_COMPLETE)
			d(("  %3d  %s%s%s"):format(
				i,
				name,
				isShrine and "  [WS]" or "",
				done and "  done" or ""
			))
		end
	end

	local dump = table.concat(lines, "\n")
	if CGV.BugReport and CGV.BugReport.ShowDump then
		CGV.BugReport:ShowDump(dump .. "\n\n-- Full index list is also in chat.", "Zone POIs (Ctrl+C)")
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

	-- Hook FocusStep to reset stuck timer.
	if CGV.FocusStep then
		local orig = CGV.FocusStep
		CGV.FocusStep = function(self, num, quiet)
			local r1, r2, r3 = orig(self, num, quiet)
			Features:NotifyStepFocused()
			return r1, r2, r3
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
