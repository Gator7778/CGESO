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
