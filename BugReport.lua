-----------------------------------------
-- LOCALIZED GLOBAL VARIABLES
-----------------------------------------

local CGV = _G.CGV
local BugReport = {}
local guiRoot, uiCenter, uiTopLeft, uiBottomLeft, uiBottomRight, uiTopRight, ctEditBox = _G.GuiRoot, _G.CENTER, _G.TOPLEFT, _G.BOTTOMLEFT, _G.BOTTOMRIGHT, _G.TOPRIGHT, _G.CT_EDITBOX
local tinsert,type,pairs,ipairs = table.insert,type,pairs,ipairs
local CHAIN = CGV.Utils.ChainCall
local UI, WM = CGV.UI, _G.WINDOW_MANAGER
local getControl = _G.GetControl

-----------------------------------------
-- SAVED REFERENCES
-----------------------------------------

CGV.BugReport = BugReport

-----------------------------------------
-- PUBLIC FUNCTIONS
-- /run d(CGV.BugReport:ShowReport())
-----------------------------------------

-----------------------------------------
-- FUNCTIONS
-----------------------------------------
local LINE_HEIGHT = 22

local function CountLines(text)
	if not text or text == "" then return 1 end
	local n = 1
	for _ in tostring(text):gmatch("\n") do
		n = n + 1
	end
	return n
end

local function ScrollDumpToTop(frame)
	local scroll = frame and frame.scroll
	if not scroll then return end
	local bar = getControl(scroll:GetName() .. "ScrollBar")
	if bar and bar.SetValue then
		bar:SetValue(0)
	end
	if _G.ZO_Scroll_ResetToTop then
		_G.ZO_Scroll_ResetToTop(scroll)
	end
end

-- NO EditBox — it traps ESO mouselook until PrintScreen. Label + chat copy only.
local function CloseDumpFrame(frame)
	if frame then frame:Hide() end
	BugReport.report = ""
	BugReport._dumpText = nil
end

local function PrintDumpToChat(text)
	text = text or ""
	d("|cfd5b02CGESO dump — use your chat-copy addon on the lines below:|r")
	local maxChunk = 350
	local start = 1
	local n = #text
	local part = 1
	while start <= n do
		local stop = math.min(start + maxChunk - 1, n)
		-- Prefer breaking on a newline.
		if stop < n then
			local nl = text:sub(start, stop):match(".*\n()")
			if nl and nl > 1 then
				stop = start + nl - 2
			end
		end
		d(text:sub(start, stop))
		start = stop + 1
		part = part + 1
		if part > 80 then
			d("|cfd5b02…truncated — dump too long for chat; browse the window instead.|r")
			break
		end
	end
	d("|cfd5b02— end of dump —|r")
end

local function RefreshDumpScroll(frame, text)
	local scroll = frame.scroll
	local child = frame.scroll.scrollchild
	local body = frame.body
	if not (scroll and child and body) then return end

	if frame.hint then
		local hintBottom = frame.hint:GetBottom()
		local frameTop = frame:GetTop()
		local scale = frame:GetScale() or 1
		if hintBottom and frameTop and scale > 0 then
			local topPad = ((frameTop - hintBottom) / scale) + 8
			if topPad < 56 then topPad = 56 end
			if topPad > 120 then topPad = 120 end
			scroll:ClearAnchors()
			scroll:SetAnchor(uiTopLeft, frame, uiTopLeft, 8, topPad)
			scroll:SetAnchor(uiBottomRight, frame, uiBottomRight, -1, -42)
		end
	end

	local viewW = scroll:GetWidth()
	local viewH = scroll:GetHeight()
	if viewW < 100 then viewW = 1000 end
	if viewH < 100 then viewH = 600 end
	local contentW = math.max(100, viewW - 24)
	local contentH = math.max(viewH, CountLines(text) * LINE_HEIGHT + 64)

	child:ClearAnchors()
	child:SetAnchor(uiTopLeft, scroll, uiTopLeft, 0, 0)
	child:SetWidth(contentW)
	child:SetHeight(contentH)

	body:ClearAnchors()
	body:SetAnchor(uiTopLeft, child, uiTopLeft, 4, 0)
	body:SetWidth(contentW - 8)
	body:SetText(text)

	-- Label height from text; keep scroll child at least that tall.
	local labelH = body.GetTextHeight and body:GetTextHeight() or contentH
	if labelH < contentH then labelH = contentH end
	child:SetHeight(labelH + 16)

	if _G.ZO_Scroll_OnExtentsChanged then
		_G.ZO_Scroll_OnExtentsChanged(scroll)
	end
	ScrollDumpToTop(frame)
end

function BugReport:CreateDumpFrameBasic()
	-- New name so leftover EditBox controls from older builds are not reused.
	local name = "CGESO_DumpFrameLabel"

	if BugReport.BasicFrame and BugReport.BasicFrame:GetName() ~= name then
		BugReport.BasicFrame:SetHidden(true)
		BugReport.BasicFrame = nil
	end

	local frame = BugReport.BasicFrame
	if not frame then
		frame = CHAIN(UI:Create("Frame",guiRoot,name))
			:SetSize(1024,700)
			:SetPoint(uiCenter)
			:Hide()
			:SetCanDrag(true)
			:SetMouseEnabled(true)
			:SetHandler("OnKeyUp", function(me, key)
					if key == _G.KEY_ESCAPE then
						CloseDumpFrame(me)
						return true
					end
				end)
			.__END
		BugReport.BasicFrame = frame
	end

	if not frame.scroll then
		frame.scroll = CHAIN(WM:CreateControlFromVirtual(name.."_Scroll",frame,"ZO_ScrollContainer"))
			:SetAnchor(uiTopLeft,frame,uiTopLeft,8,72)
			:SetAnchor(uiBottomRight,frame,uiBottomRight,-1,-42)
			.__END

		frame.scroll.scrollchild = CHAIN(getControl(frame.scroll:GetName().."ScrollChild"))
			:ClearAnchors()
			:SetAnchor(uiTopLeft, frame.scroll, uiTopLeft, 0, 0)
			:SetWidth(1000)
			:SetHeight(50)
			.__END
	end

	-- Kill any old editbox if present from a prior BasicFrame layout.
	local legacyBox = getControl("CGESO_DumpFrameBasiccopybox")
	if legacyBox then
		legacyBox:SetHidden(true)
		if legacyBox.LoseFocus then pcall(function() legacyBox:LoseFocus() end) end
		if legacyBox.SetMouseEnabled then legacyBox:SetMouseEnabled(false) end
		if legacyBox.SetEditEnabled then legacyBox:SetEditEnabled(false) end
	end
	frame.copybox = nil

	if not frame.body then
		frame.body = CHAIN(UI:Create("Label",frame.scroll.scrollchild,name.."body",13))
			:SetAnchor(uiTopLeft, frame.scroll.scrollchild, uiTopLeft, 4, 0)
			:SetWidth(990)
			:SetCanWrap(true)
			:SetMouseEnabled(false) -- never steal focus
			:SetText("")
			.__END
	end

	if not frame.close then
		frame.close = CHAIN(UI:Create("GuideButton",frame,name.."_Close","Close"))
			:SetPoint(uiTopRight, frame, -5, 5)
			:SetHandler("OnClicked",function()
					CloseDumpFrame(frame)
				end)
			.__END
	end

	if not frame.title then
		frame.title = CHAIN(UI:Create("Label",frame,name.."_MainText",14,"bold"))
			:SetPoint(uiTopLeft,frame,10,10)
			:SetText("No text")
			.__END
	end

	local hintText = "Mouse-wheel to browse (no click). Use Print to Chat, then your chat-copy addon. Close or Esc dismisses — no mouse trap."
	if not frame.hint then
		frame.hint = CHAIN(UI:Create("Label",frame,name.."_Hint",12))
			:SetPoint(uiTopLeft,frame.title,uiBottomLeft,0,4)
			:SetWidth(980)
			:SetCanWrap(true)
			:SetText(hintText)
			.__END
	else
		frame.hint:SetText(hintText)
	end

	if not frame.PrintButton then
		frame.PrintButton = CHAIN(UI:Create("Button",frame,name.."_Print"))
			:SetSize(140,25)
			:SetText("Print to Chat")
			:SetPoint(uiBottomLeft, frame, 8, -5)
			:SetHandler("OnClicked",function()
					PrintDumpToChat(BugReport._dumpText or "")
				end)
			.__END
	end

	if not frame.CloseButton then
		frame.CloseButton = CHAIN(UI:Create("Button",frame,name.."_Close2"))
			:SetSize(100,25)
			:SetText("Close")
			:SetPoint(uiBottomRight, frame,-5,-5)
			:SetHandler("OnClicked",function()
					CloseDumpFrame(frame)
				end)
			.__END
	end
end


-- Scrollable label dump — no EditBox (EditBox traps mouselook in ESO).
-- Copy via Print to Chat + Shawn's chat-copy addon.
function BugReport:ShowDump(text,title)
	self:CreateDumpFrameBasic()

	local frame = self.BasicFrame
	assert(frame,"Could not create a dump frame")

	text = text or ""
	BugReport._dumpText = text
	frame.title:SetText(title or "Bug Report")
	frame:Show()
	RefreshDumpScroll(frame, text)
	_G.zo_callLater(function()
		if not frame:IsHidden() then
			RefreshDumpScroll(frame, text)
		end
	end, 10)
end

local lastreport

function BugReport:AddToReport(text)
	if text == lastreport then return end
	lastreport = text
	self.report = self.report or ""
	self.report = self.report .. "\n" .. text
end

function BugReport:GetReport()

	local GetUnitLevel, GetMapPlayerPosition, GetMapTileTexture, GetCurrentMapZoneIndex = _G.GetUnitLevel, _G.GetMapPlayerPosition, _G.GetMapTileTexture, _G.GetCurrentMapZoneIndex
	local playerX, playerY = GetMapPlayerPosition("player")
	local step = CGV.CurrentStep
	local guide = CGV.CurrentGuide
	local t = "" -- text

	t = t .. "NOTES: (edit below, then paste into the CGESO comments on ESOUI)\n\n"
	local notes = CGV.Features and CGV.Features:GetBugNotes() or ""
	if notes ~= "" then
		t = t .. notes .. "\n\n"
	end
	if CGV.Features and CGV.Features.BuildGuideNoteBlock then
		t = t .. CGV.Features:BuildGuideNoteBlock()
	end

	t = t .. ("VERSION: %s\n"):format(CGV.version)
	t = t .. ("FACTION: %s\n"):format(CGV.Utils.GetFaction())
	t = t .. ("LEVEL: %s\n"):format(GetUnitLevel("player"))
	t = t .. ("GUIDE: %s\n"):format(guide and guide.title or "NONE")
	if guide and guide.title_short then
		t = t .. ("GUIDE SHORT: %s\n"):format(guide.title_short)
	end
	t = t .. "\n"
	t = t .. ("CURRENT LOCATION:\n")
	t = t .. ("ARTMAP: %s\n MAP ZONE INDEX: #%d\n COORDINATES: %.3f,%.3f\n"):format( GetMapTileTexture(), GetCurrentMapZoneIndex(), playerX * 100, playerY * 100 )
	t = t .. "\n"

	-- Always attach guide name, step number, and step text (feature 2).
	if CGV.Features and CGV.Features.BuildStepTextBlock then
		t = t .. CGV.Features:BuildStepTextBlock() .. "\n"
	elseif not step then
		t = t .. "STEP: NONE\n"
	else
		t = t .. ("STEP: %s\n"):format(step.num)
	end

	if not step then
		-- already noted above
	else
		if not step.goals then
			t = t .. "\nGOALS: NONE\n"
		else
			t = t .. "\nGOALS:\n"
			for goalIn, goalOut in ipairs(step.goals) do
				t = t .. (" - %d. %s  <%s> [%s]"):format( goalIn, goalOut:GetText():gsub("|c......",""):gsub("|r",""), goalOut.action, goalOut:GetStatus() )
				if goalOut.x then  t = t .. (" [%s %.2f,%.2f <%d]"):format( goalOut.map or "?", goalOut.x * 100, goalOut.y * 100, goalOut.dist )  end
				if goalOut.quest then t = t .. (" [quest %s]"):format(tostring(goalOut.quest)) end
				for k,v in pairs(goalOut) do
					if type(v)~="function"
					and type(v)~="table"
					and k ~= "x"
					and k ~= "y"
					and k ~= "map"
					and k ~= "dist"
					and k ~= "indent"
					and k ~= "text"
					and k ~= "action"
					and k ~= "num"
					and k ~= "status"
					and k ~= "quest"
					and k ~= "questid"
					and k ~= "queststagenum"
					and k ~= "queststepnum"
					and k ~= "questcondnum"
					and k ~= "questcondtxt"
					then
						t = t .. " " .. k .. "=" .. tostring(v)
					end
				end
				t = t .. "\n"
			end
			t = t .. "\n"
		end
	end

	self.report = self.report or ""
	t = t .. self.report

	if self.report=="" then t = t .. "- no detailed report available -\n" end

	t = t .. "\nDEBUG LOG:\n" .. CGV.Log:Dump()

	return t
end

-- MAIN FUNCTION
function BugReport:ShowReport()
	self:ShowDump(self:GetReport(),"Bug Report")
end


-----------------------------------------
-- DEBUG
-----------------------------------------
--[[
function MyObject:Debug(...)
	local str = ...
	CGV:Debug("&myobj "..str, select(2,...) )
end
--]]

-----------------------------------------
-- STARTUP
-----------------------------------------

tinsert(CGV.startups,function(self)
end)
