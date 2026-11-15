-----------------------------------------
-- LOCALIZED GLOBAL VARIABLES
-----------------------------------------

local CGV = _G.CGV
local tinsert = table.insert

local help_string = [[	Options:
	reset - Reset Guide Viewer to original position and settings.
	show - Show the Guide Viewer.
	hide - Hide the Guide Viewer.
	config - Show configuration.
	creator - Activates Creator Mode.
	dev - Activates Development Mode.
	bookmark - Bookmark the current guide step.
	resume - Resume the bookmarked step.
	compact - Apply compact viewer preset.
	quest - Open the step's quest in the journal.
	note <text> - Save a per-guide note (in bug dumps).
	undo - Undo last skip / mark done.
	find <text> - Search steps in the current guide.
	step <n> - Jump to step number in the current guide.
	copystep - Dump the current step for authoring (Print to Chat).
	gallery - ESOUI gallery export checklist (799×498).
	upload - Upload-day checklist.
	mapdata / scaffold - Next-xpac MapData id scaffold.
	back - Step history back.
	stephistory - Show step history ring.
	style / mqo / full - Switch Full ↔ MQO for this zone.
	ignored / unignore [title] / clearignored - Manage forever-ignored suggestions.
	findui - Toggle viewer find box.
	zone - Load this zone’s preferred guide.
	catchup - Advance past already-complete steps.
]]

if CGV.DEV then
	help_string = help_string .. [[
	debug - Toggle debug on and off.
	error - Toggle ignore errors. Requires a reload.
]]
end

-----------------------------------------
-- FUNCTIONS
-----------------------------------------

function CGV.SlashCommandHandler(text)
	local self = CGV
	text = text or ""
	local cmd, rest = text:match("^(%S+)%s*(.-)$")
	cmd = ((cmd or text) or ""):lower()
	rest = rest or ""

	if cmd == "debug" then
		self.sv.profile.debug = not self.sv.profile.debug
		self:Print(("Debug is %s"):format(
			self.sv.profile.debug and "on" or "off"
		))
	elseif cmd == "error" then
		self.sv.profile.ignoreErrors = not self.sv.profile.ignoreErrors
		self:Print("Please reload for errors to be handled properly.")
	elseif cmd == "report" or cmd == "bug" then
		if not self.BugReport then
			self:Print("BugReport feature not loaded. Sorry!")
			return
		end

		self.BugReport:ShowReport()
	elseif cmd == "reset" then
		self.Viewer:ResetAllViewerSettings()
	elseif cmd == "show" then
		self.Viewer:Show_GuideViewer()
	elseif cmd == "hide" then
		self.Viewer:Hide_GuideViewer()
	elseif cmd == "config" then
		self.Settings:OpenSettings()
	elseif cmd == "creator" then
		self.sv.char.creator = not self.sv.char.creator
		self.Creator = self.sv.char.creator

		self:Print(("Creator Mode is now %s"):format(
			self.Creator and "on" or "off"
		))
	elseif cmd == "dev" or cmd == "developer" then
		self.sv.char.developer = not self.sv.char.developer
		self.DEV = self.sv.char.developer

		self:Print(("Developer Mode is now %s"):format(
			self.DEV and "on" or "off"
		))
	elseif cmd == "bookmark" then
		if self.Features then self.Features:SetBookmark() end
	elseif cmd == "resume" then
		if self.Features then self.Features:ResumeBookmark() end
	elseif cmd == "compact" then
		if self.Features then self.Features:ApplyCompactPreset() end
	elseif cmd == "quest" then
		if self.Features then self.Features:OpenQuestInJournal() end
	elseif cmd == "note" then
		if not self.Features then return end
		if rest == "" or rest == "edit" then
			self.Features:PromptGuideNote()
		elseif rest == "clear" then
			self.Features:SetGuideNote("")
		else
			self.Features:SetGuideNote(rest)
		end
	elseif cmd == "undo" then
		if self.Features then self.Features:UndoLastSkip() end
	elseif cmd == "find" or cmd == "search" then
		if self.Features then self.Features:SearchCurrentGuide(rest) end
	elseif cmd == "step" then
		if self.Features then self.Features:JumpToStepNum(rest) end
	elseif cmd == "copystep" or cmd == "copy" then
		if self.Features then self.Features:CopyCurrentStep() end
	elseif cmd == "gallery" then
		if self.Features then self.Features:ShowGalleryChecklist() end
	elseif cmd == "upload" then
		if self.Features then self.Features:ShowUploadChecklist() end
	elseif cmd == "mapdata" or cmd == "scaffold" then
		if self.Features then self.Features:ShowMapDataScaffold() end
	elseif cmd == "back" then
		if self.Features then self.Features:StepHistoryBack() end
	elseif cmd == "stephistory" or cmd == "history" then
		if self.Features then self.Features:PrintStepHistory() end
	elseif cmd == "style" or cmd == "mqo" or cmd == "full" or cmd == "switch" then
		if self.Features then self.Features:SwitchGuideStyle() end
	elseif cmd == "ignored" then
		if self.Features then self.Features:ListIgnoredGuides() end
	elseif cmd == "clearignored" then
		if self.Features then self.Features:ClearIgnoredGuides() end
	elseif cmd == "unignore" then
		if self.Features then self.Features:UnignoreGuide(rest) end
	elseif cmd == "findui" then
		if self.Features then self.Features:ToggleViewerFind() end
	elseif cmd == "zone" or cmd == "jumpzone" then
		if self.Features then self.Features:JumpToZoneGuide() end
	elseif cmd == "catchup" or cmd == "catch" then
		if self.Features then self.Features:CatchUpSkip() end
	else
		self:Print(help_string)
	end
end

-----------------------------------------
-- LOCAL FUNCTIONS
-----------------------------------------

local function registerSlashCommands()
	local slashCommands = _G.SLASH_COMMANDS

	slashCommands["/cgv"] = CGV.SlashCommandHandler
	slashCommands["/community"] = slashCommands["/cgv"]
	slashCommands["/run"] = slashCommands["/script"]
	slashCommands["/re"] = slashCommands["/reloadui"]
end

-----------------------------------------
-- STARTUP
-----------------------------------------

tinsert(CGV.startups, function()
	registerSlashCommands()
end)
