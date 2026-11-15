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
local LINE_HEIGHT = 18 -- ZoFontGame ~line; used to size scroll content

local function CountLines(text)
	if not text or text == "" then return 1 end
	local n = 1
	for _ in tostring(text):gmatch("\n") do
		n = n + 1
	end
	return n
end

local function RefreshDumpScroll(frame, text)
	local scroll = frame.scroll
	local child = frame.scroll.scrollchild
	local box = frame.copybox
	if not (scroll and child and box) then return end

	local viewH = scroll:GetHeight()
	if viewH < 100 then viewH = 600 end
	local contentH = math.max(viewH, CountLines(text) * LINE_HEIGHT + 24)

	box:ClearAnchors()
	box:SetAnchor(uiTopLeft, child, uiTopLeft, 4, 0)
	box:SetAnchor(uiTopRight, child, uiTopRight, -4, 0)
	box:SetHeight(contentH)

	child:SetHeight(contentH)

	-- Tell ZO_ScrollContainer the extents changed so the scrollbar appears.
	if _G.ZO_Scroll_OnExtentsChanged then
		_G.ZO_Scroll_OnExtentsChanged(scroll)
	elseif scroll.scroll and scroll.scroll.UpdateScrollBars then
		scroll.scroll:UpdateScrollBars()
	end
end

function BugReport:CreateDumpFrameBasic()
	local name = "CGESO_DumpFrameBasic"

	local frame = CHAIN(UI:Create("Frame",guiRoot,name))
		:SetSize(1024,700)
		:SetPoint(uiCenter)
		:Hide()
		:SetCanDrag(true)
		.__END

	BugReport.BasicFrame = frame

	frame.scroll = CHAIN(WM:CreateControlFromVirtual(name.."_Scroll",frame,"ZO_ScrollContainer"))
		:SetAnchor(uiTopLeft,frame,uiTopLeft,8,50)
		:SetAnchor(uiBottomRight,frame,uiBottomRight,-1,-38)
		.__END

	frame.scroll.scrollchild = CHAIN(getControl(frame.scroll:GetName().."ScrollChild"))
		:ClearAnchors()
		:SetAnchor(uiTopLeft,frame.scroll)
		:SetAnchor(uiTopRight,frame.scroll)
		:SetHeight(50)
		.__END

	-- Selectable multi-line text lives IN the scroll child so long dumps (POI lists) scroll.
	frame.copybox = CHAIN(WM:CreateControl(name.."copybox",frame.scroll.scrollchild,ctEditBox))
		:SetAnchor(uiTopLeft, frame.scroll.scrollchild, uiTopLeft, 4, 0)
		:SetAnchor(uiTopRight, frame.scroll.scrollchild, uiTopRight, -4, 0)
		:SetHeight(50)
		:SetMouseEnabled(true)
		:SetFont("ZoFontGame")
		:SetMultiLine(true)
		:SetMaxInputChars(999999)
		:SetHandler("OnMouseDown", function(self) self:TakeFocus() end)
		:SetHandler("OnMouseUp", function(self)
				-- First click focuses; second / drag can select. Don't force SelectAll every up
				-- so wheel-scrolling + partial select still work.
			end)
		:SetHandler("OnMouseWheel", function(_, delta)
				-- EditBox eats wheel events; forward them to the scroll bar.
				local scroll = frame.scroll
				local bar = scroll and getControl(scroll:GetName() .. "ScrollBar")
				if bar and bar.GetValue and bar.SetValue then
					local cur = bar:GetValue() or 0
					bar:SetValue(math.max(0, cur - delta * LINE_HEIGHT * 3))
				elseif scroll and _G.ZO_Scroll_ScrollRelative then
					_G.ZO_Scroll_ScrollRelative(scroll, -delta * LINE_HEIGHT * 3)
				end
			end)
		.__END

	-- Kept for layout helpers / optional non-edit view (unused while copybox is shown).
	frame.display = CHAIN(UI:Create("Label",frame.scroll.scrollchild,name.."display"))
		:SetAnchor(uiTopLeft,frame.scroll.scrollchild)
		:SetAnchor(uiTopRight,frame.scroll.scrollchild)
		:SetCanWrap(true)
		:SetHidden(true)
		.__END

	frame.close = CHAIN(UI:Create("GuideButton",frame,name.."_Close","Close"))
		:SetPoint(uiTopRight, frame, -5, 5)
		:SetHandler("OnClicked",function(self)
				frame:Hide()
				BugReport.report = ""
			end)
		.__END

	frame.title = CHAIN(UI:Create("Label",frame,name.."_MainText",14,"bold"))
		:SetPoint(uiTopLeft,frame,10,10)
		:SetText("No text")
		.__END

	frame.hint = CHAIN(UI:Create("Label",frame,name.."_Hint",12))
		:SetPoint(uiTopLeft,frame.title,uiBottomLeft,0,4)
		:SetWidth(980)
		:SetCanWrap(true)
		:SetText("Scroll or mouse-wheel to browse. Click the text, Ctrl+C to copy, then paste into the CGESO comments on ESOUI. Nothing is sent automatically.")
		.__END

	frame.CloseButton = CHAIN(UI:Create("Button",frame,name.."_Close2"))
		:SetSize(100,25)
		:SetText("Close")
		:SetPoint(uiBottomRight, frame,-5,-5)
		:SetHandler("OnClicked",function(...)
				frame:Hide()
				BugReport.report = ""
			end)
		.__END
end


-- Show dump in a selectable edit box so the player can Ctrl+C it.
-- Nothing is uploaded — ESO addons cannot send mail/HTTP from here.
function BugReport:ShowDump(text,title)
	local frame

	if not self.BasicFrame then
		self:CreateDumpFrameBasic()
	end

	frame = self.BasicFrame

	assert(frame,"Could not create a BasicFrame for BugReport")

	text = text or ""
	frame.title:SetText(title or "Bug Report")
	frame.copybox:SetText(text)
	frame.copybox:SetHidden(false)
	frame:Show()

	-- Size after Show so scroll:GetHeight() is valid, then focus for Ctrl+C.
	RefreshDumpScroll(frame, text)
	frame.copybox:TakeFocus()
	frame.copybox:SelectAll()
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
