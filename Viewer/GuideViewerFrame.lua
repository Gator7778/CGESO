-----------------------------------------
-- LOCALIZED GLOBAL VARIABLES
-----------------------------------------

local CGV = _G.CGV
local EVENT_ACTION_LAYER_POPPED = _G.EVENT_ACTION_LAYER_POPPED
local EVENT_ACTION_LAYER_PUSHED = _G.EVENT_ACTION_LAYER_PUSHED
local EVENT_PLAYER_COMBAT_STATE = _G.EVENT_PLAYER_COMBAT_STATE
local IsActionLayerActiveByName = _G.IsActionLayerActiveByName
local TOP,TOPRIGHT,RIGHT,BOTTOMRIGHT,LEFT,TOPLEFT,BOTTOM,BOTTOMLEFT,CENTER = _G.TOP,_G.TOPRIGHT,_G.RIGHT,_G.BOTTOMRIGHT,_G.LEFT,_G.TOPLEFT,_G.BOTTOM,_G.BOTTOMLEFT,_G.CENTER
local LEFT_MOUSE_BUTTON,RIGHT_MOUSE_BUTTON = _G.LEFT_MOUSE_BUTTON,_G.RIGHT_MOUSE_BUTTON
local Zgoo = _G.Zgoo
local GuiRoot = _G.GuiRoot
local TEXT_ALIGN_CENTER = _G.TEXT_ALIGN_CENTER
local zo_floatsAreEqual = _G.zo_floatsAreEqual
local GOAL_FONTSIZE = _G.GOAL_FONTSIZE
local Viewer = {}
local FrameUI = CGV.Class:New("FrameUI")
local StepUI = CGV.Class:New("StepUI")
local GoalUI = CGV.Class:New("GoalUI")
local name = "CGVF"
local DEFAULT_ANCHOR = { -- Set point using Top so that goals grow downward properly
	TOPRIGHT,
	_G['GuiRoot'],
	LEFT,
	100,
	225,
}
local DEFAULT_MINIMAP_ANCHOR = { -- Set point using Top so that goals grow downward properly
	TOPRIGHT,
	_G['GuiRoot'],
	TOPRIGHT,
	0,
	0,
}
local MINIMAP_BUTTON_SIZE = 25

local UPDATETIME = .1				-- Try to update only 10 times/s
local PROG_UPDATETIME = 10			-- Progress bar updates nicely for step based whenever a step is advanced, but try to update periodically too for level based.
local ARROW_DOWN_STARTTIMER = 0.5	-- Wait 0.5 second before going forward/backwards steps.
local ARROW_DOWN_REPETITION = 0.05	-- 20/sec repetition

local DEFAULT_WIDTH = 350
local DEFAULT_HEIGHT = 175
local MIN_WIDTH = 200
local MAX_WIDTH = 600

-- Backdrop-only opacity so the world shows through; text/icons stay fully opaque.
local DEFAULT_VIEWER_OPACITY = 0.20
-- Prior shipped defaults; migrate these once to the current default (custom slider values stay).
local PRIOR_DEFAULT_OPACITIES = { 0.65, 0.42 }

local TITLE_BAR_HEIGHT = 90
local GUIDE_BAR_HEIGHT = 20
local PROGRESS_BAR_HEIGHT = 7

local CUR_STEP_WIDTH = 32			-- 3 digits
local VIEWER_BOT_PADDING = 5

local SMALL_PADDING = 5
local BIG_PADDING = 10

local GOAL_ICON_SIZE = 15
local GOAL_ICON_PADDING = 2

local PROG_BAR_TYPE_STEP = "steps"
local PROG_BAR_TYPE_LEVEL = "level"

local PROG_BAR_COLOR_STEP = {0.0,0.8,0.0,1.0}
local PROG_BAR_COLOR_LEVEL = {1/255,162/255,253/255,1.0}

local ActionLabels = {} -- filled at startup

local actionicon={
	["accept"]	=5,
	["turnin"]	=6,
	["kill"]	=7,
	["from"]	=7,
	["get"]		=8,
	["collect"]	=8,
	["buy"]		=8,
	["goal"]	=9,
	["home"]	=10,
	["goto"]	=12,
	["talk"]	=13,
	["next"]	=14
}
setmetatable(actionicon,{__index=function() return 2 end})
local tinsert,cginherits,type,ipairs = table.insert,table.cginherits,type,ipairs
local CHAIN = CGV.Utils.ChainCall
local ui = CGV.UI
local L = CGV.L

-----------------------------------------
-- SAVED REFERENCES
-----------------------------------------

CGV.Viewer = Viewer
CGV.Viewer.name = name

-----------------------------------------
-- LOCAL FUNCTIONS
-----------------------------------------

local function setupActionLayers()
	local num = _G.GetNumActionLayers()
	for i=1,num do
		local name,_ = _G.GetActionLayerInfo(i)

		ActionLabels[i] = name
	end
end

-----------------------------------------
-- CREATION FUNCTIONS
-----------------------------------------

function Viewer:add_tooltip(control,text)
	control:AddTooltip(nil,text,control,TOP,0,0,BOTTOM)
end

function Viewer:CreateCGVF()
	if self.Frame then return end

	-- Master frame is only needed so that the viewer can point off of it. Viewer needs to use SetPoint(TOP) so that it expands down nicely when moving stepsg
	local master = CHAIN(ui:Create("InvisFrame",GuiRoot,name.."_Master",1))	-- toplevel
		:SetMovable(true)
		:SetHandler("OnMoveStop", function(me)
				local isValidAnchor, point, relativeTo, relativePoint, offsetX, offsetY = me:GetAnchor()

				if isValidAnchor then
					CGV.sv.profile.vieweranchor = {
						point,
						relativeTo:GetName(), -- Can not store userdata. Just put a string in and it will be forced to GuiRoot when setting
						relativePoint,
						offsetX,
						offsetY
					}
				end
			end)
		.__END

	-- Lets set the point! Use either from Saved Vars or default
	CGV.sv.profile.vieweranchor = CGV.sv.profile.vieweranchor and #CGV.sv.profile.vieweranchor==5 and CGV.sv.profile.vieweranchor or DEFAULT_ANCHOR
	local point, relativeTo, relativePoint, offsetX, offsetY = unpack(CGV.sv.profile.vieweranchor)
	relativeTo = GuiRoot -- Force to GuiRoot.
	master:SetPoint(point, relativeTo, relativePoint, offsetX, offsetY)

	local fwidth = CGV.sv.profile.viewerwidth or DEFAULT_WIDTH
	local frame =  CHAIN(ui:Create("Frame",master,name,"true"))	-- Not toplevel
		:SetPoint(TOP)
		:SetSize(fwidth,DEFAULT_HEIGHT) -- Height doesn't need to be saved because that is based on goals
		:SetDimensionConstraints(MIN_WIDTH,nil,MAX_WIDTH,nil)
		:SetResizeHandleSize(4)
		:SetMouseEnabled(true) -- Just enable mouse so it can drag master
		:SetHandler("OnMouseDown",function()
				Viewer.moving = master:StartMoving() -- Blocking in stepbox:OnResizedToFit so that viewer isn't resized without need
			end)
		:SetHandler("OnMouseUp",function()
				master:StopMovingOrResizing()
				Viewer.moving = nil
			end)
		:SetHandler("OnResizeStop",function(me)
				Viewer:ResizeToFitSteps() -- Can't prevent vertical resizing, just make it look normal again when they stop.
				Viewer:UpdateProgressBar()
				CGV.sv.profile.viewerwidth = me:GetWidth()
			end)
		:SetHandler("OnUpdate",function(me,time)
				me:OnUpdate(time)
			end)
		.__END
	CGV.Frame = frame
	self.Frame = frame
	frame.master = master

	-- Title Bar
	-- Invisible frame
	local tname = name.."_TitleBar"
	local titlebar = CHAIN(ui:Create("InvisFrame",frame,tname))
		:SetPoint(TOPRIGHT)
		:SetPoint(TOPLEFT)
		:SetHeight(TITLE_BAR_HEIGHT)
		.__END

	titlebar.help = CHAIN(ui:Create("GuideButton",titlebar,tname.."_Help","Help"))
		:SetPoint(TOPLEFT, titlebar, BIG_PADDING, SMALL_PADDING )
		:SetHandler("OnClicked",function() self:HelpButton_OnClick() end)
		.__END

	titlebar.bug = CHAIN(ui:Create("GuideButton",titlebar,tname.."_bug","Debug"))
		:SetPoint(LEFT, titlebar.help, RIGHT, BIG_PADDING, 0 )
		:SetHandler("OnClicked",function(_,but)
				if but == RIGHT_MOUSE_BUTTON then
					if Zgoo and _G.IsShiftKeyDown() then
						Zgoo(CGV.CurrentGuide)
					else
						Zgoo(CGV.CurrentStep)
					end
				else
					-- normal report
					CGV.BugReport:ShowReport()
				end
			end)
		.__END

	local s = "Click to generate a bug report.\nOpens a copyable dump — nothing is sent automatically."
	if Zgoo and CGV.DEV then
		s = s .. "\nDEV:\nRight click to Zgoo the current step.\nShift-Right click to Zgoo current guide."
	end
	Viewer:add_tooltip(titlebar.bug,s)
	-- Default on; Extras → “Show bug report button” toggles visibility.
	titlebar.bug:SetHidden(not (CGV.db.profile.bugreports ~= false))

	titlebar.title = CHAIN(ui:Create("Logo",titlebar,tname.."_Title"))
		:SetPoint(CENTER,titlebar,0,-8)
		.__END

	titlebar.close = CHAIN(ui:Create("GuideButton",titlebar,tname.."_Close","Close"))
		:SetPoint(TOPRIGHT, titlebar, - BIG_PADDING, SMALL_PADDING )
		:SetHandler("OnClicked",function() self:CloseButton_OnClick() end)
		.__END

	-- Spacer / reserved slot next to the guide picker (kept for layout anchors).
	titlebar.something = CHAIN(ui:Create("GuideButton",titlebar,tname.."_something","Close"))
		:SetPoint(BOTTOMRIGHT, titlebar, - BIG_PADDING, 0 )
		:SetHandler("OnClicked",function() self:CloseButton_OnClick() end)
		:Hide()
		.__END

	titlebar.prevStep = CHAIN(ui:Create("GuideButton",titlebar,tname.."_PrevStep","Left"))
		:SetPoint(BOTTOMLEFT,titlebar,BIG_PADDING,0)
		:SetHandler("OnClicked",function(_,but) self:PrevStepButton_OnClick(but) end)
		:SetHandler("OnMouseDown",function()
				Viewer.prevDownTime = _G.GetFrameTimeSeconds()
				Viewer.lastArrowSurfUpdate = 0
			end)
		:SetHandler("OnMouseUp",function()
				Viewer.prevDownTime = nil
			end)
		.__END
		s = "Left click to move back one step. Right click to fast REWIND steps."
		CGV.Viewer:add_tooltip(titlebar.prevStep,s)

	titlebar.nextStep = CHAIN(ui:Create("GuideButton",titlebar,tname.."_NextStep","Right"))
		:SetPoint(LEFT,titlebar.prevStep,RIGHT,CUR_STEP_WIDTH,0) -- Some padding on each side, then the width of the number.
		:SetHandler("OnClicked",function(_,but) self:NextStepButton_OnClick(but) end)
		:SetHandler("OnMouseDown",function()
				Viewer.nextDownTime = _G.GetFrameTimeSeconds()
				Viewer.lastArrowSurfUpdate = 0
			end)
		:SetHandler("OnMouseUp",function()
				Viewer.nextDownTime = nil
			end)
		.__END
		s = "Left click to move forward one step. Right click to fast FORWARD steps."
		CGV.Viewer:add_tooltip(titlebar.nextStep,s)

	titlebar.stepLabel = CHAIN(ui:Create("Label",titlebar,tname.."_StepLabel"))
		:SetPoint(TOPLEFT,titlebar.prevStep,TOPRIGHT)
		:SetPoint(TOPRIGHT,titlebar.nextStep,TOPLEFT)
		:SetText("-")
		:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
		.__END

	titlebar.guideSelect = CHAIN(ui:Create("GuideButton",titlebar,tname.."_GuidePicker","Down"))
		:SetPoint(RIGHT,titlebar.something,LEFT,-BIG_PADDING,0)
		:SetSize(GUIDE_BAR_HEIGHT,GUIDE_BAR_HEIGHT)
		:SetHandler("OnClicked",function(_,but) self:GuideSelectButton_OnClick(but) end)
		.__END

	titlebar.guideBox = CHAIN(ui:Create("SecFrame",titlebar,tname.."_GuideBox"))
		:SetPoint(LEFT,titlebar.nextStep,RIGHT,BIG_PADDING,0)
		:SetPoint(RIGHT,titlebar.guideSelect,LEFT,0,0)
		:SetHeight(GUIDE_BAR_HEIGHT)
		.__END

	titlebar.guideLabel = CHAIN(ui:Create("Label",titlebar.guideBox,tname.."_GuideLabel"))
		:SetPoint(TOPLEFT,SMALL_PADDING,0)
		:SetAnchor(BOTTOMRIGHT,titlebar.guideSelect,BOTTOMLEFT,-SMALL_PADDING,0)
		:SetText("Guide")
		.__END

	frame.TitleBar = titlebar

	-- Step Box
	frame.stepbox = CHAIN(ui:Create("SecFrame",frame,name.."_StepBox"))
		:SetAnchor(TOPLEFT,titlebar,BOTTOMLEFT,BIG_PADDING,BIG_PADDING)
		:SetAnchor(TOPRIGHT,titlebar,BOTTOMRIGHT,-BIG_PADDING,BIG_PADDING)
		:SetResizeToFitDescendents(true)
		:SetHandler("OnResizedToFit",function(_,...)
				if Viewer.moving then return end
				Viewer:Debug("Stepbox Resized to %d %d",...)
				Viewer:ResizeToFitSteps() -- Time to fix the guide viewer.
			end)
		.__END

	-- Below Steps
	frame.settings = CHAIN(ui:Create("GuideButton",frame,name.."_Settings","Settings"))
		:SetPoint(TOPRIGHT, frame.stepbox, BOTTOMRIGHT, 0, SMALL_PADDING )
		.__END

	local pboffset = (((frame.settings:GetHeight() + SMALL_PADDING + VIEWER_BOT_PADDING) -- Total space below stepbox
			- PROGRESS_BAR_HEIGHT) / 2)
	frame.progress = CHAIN(ui:Create("ProgressBar",frame,name.."_ProgressBar"))
		:SetPoint(TOPLEFT, frame.stepbox, BOTTOMLEFT, 0, pboffset)
		:SetPoint(RIGHT, frame.settings, LEFT, -SMALL_PADDING, 0 )
		:SetHeight(PROGRESS_BAR_HEIGHT)
		:SetShowLabelOnHover(true)
		:SetHandler("OnMouseUp",function()
				Viewer:ChangeProgressType()
			end)
		:HookHandler("OnMouseEnter",function(me)
				if me.tooltip == "none" then return end
				me.tooltipShown = true

				CHAIN(CGV.Tooltip)
				:ClearLines()
				:SetWidth(0)
				:SetOwner(frame,TOP,0,0,BOTTOM)
				:AddLine(me.tooltip)
				:Show()
			end)
		:HookHandler("OnMouseExit",function(me)
				me.tooltipShown = nil

				CGV.Tooltip:Hide()
			end)
		.__END

	frame.stepuis = {}	-- Step UIs

	-- Inherit all functions in the FrameUI Class in this file. Can't use a metatable because it already has metatable
	cginherits(frame,FrameUI)

	-- Create the minimap button to go on screen at all times
	Viewer:CreateMiniMapButton()

	self:UpdateViewer()
	frame:ShowIf(CGV.sv.profile.showviewer)
end

-- icon on GuiRoot that users can click to toggle the guide viewer.
function Viewer:CreateMiniMapButton()
	local mbut = name.."_ScreenToggle"

	local frame = CHAIN(ui:Create("Frame",GuiRoot,mbut)) -- toplevel
		:SetMovable(true)
		:SetMouseEnabled(true)
		:SetSize(MINIMAP_BUTTON_SIZE,MINIMAP_BUTTON_SIZE)
		:AddTooltip(L["name"],L['minimap_tooltip'],nil,TOP,0,0,BOTTOM)
		:SetHandler("OnMouseUp", function(me,but)
				if me.recentlyMoved then me.recentlyMoved = nil return end -- If dragged don't trigger
				if but == LEFT_MOUSE_BUTTON then
					Viewer:Toggle_GuideViewer()
				elseif but == RIGHT_MOUSE_BUTTON then
					CGV.Settings:OpenSettings()
				end
			end)
		:SetHandler("OnMoveStop", function(me)
				local isValidAnchor, point, relativeTo, relativePoint, offsetX, offsetY = me:GetAnchor()

				if isValidAnchor then
					if CGV.sv.profile.minibutanchor[1] ~= point or
					CGV.sv.profile.minibutanchor[3] ~= relativePoint or
					not zo_floatsAreEqual(CGV.sv.profile.minibutanchor[4],offsetX) or
					not zo_floatsAreEqual(CGV.sv.profile.minibutanchor[5],offsetY) then
						me.recentlyMoved = true

						CGV.sv.profile.minibutanchor = {
							point,
							relativeTo:GetName(), -- Can not store userdata. Just put a string in and it will be forced to GuiRoot when setting
							relativePoint,
							offsetX,
							offsetY
						}
					end
				end
			end)
		.__END

	CGV.sv.profile.minibutanchor = CGV.sv.profile.minibutanchor and #CGV.sv.profile.minibutanchor == 5 and CGV.sv.profile.minibutanchor or DEFAULT_MINIMAP_ANCHOR
	local point, relativeTo, relativePoint, offsetX, offsetY = unpack(CGV.sv.profile.minibutanchor)
	relativeTo = GuiRoot -- Force to GuiRoot.
	frame:SetPoint(point, relativeTo, relativePoint, offsetX, offsetY)

	frame.Z = CHAIN(ui:Create("LetterZ",frame,mbut.."_ZZZZ"))
		:SetAllPoints()
		.__END

	frame:ShowIf(CGV.sv.profile.showmapbutton)
	self.MinimapButton = frame
end

function Viewer:CreateStepUI(parent,stepnum)
	if not stepnum then return end
	local stepName = name.."_Step"..stepnum
	local stepbox = parent.stepbox
	local stepuis = parent.stepuis

	local stepui = CHAIN(ui:Create("InvisFrame",stepbox,stepName))
		:SetResizeToFitDescendents(true)
		:SetHandler("OnResizedToFit",function(me,...)
				Viewer:Debug("Step %s Resized to %d %d",me:GetName(),...)
			end)
		.__END

	-- First one is anchored to the stepbox, rest are the step above it.
	if stepnum == 1 then
		CHAIN(stepui)
		:SetPoint(TOPLEFT)
		:SetPoint(TOPRIGHT)
	else
		local anchorParent = stepuis[stepnum-1]
		CHAIN(stepui)
		:SetPoint(TOPLEFT,anchorParent,BOTTOMLEFT)
		:SetPoint(TOPRIGHT,anchorParent,BOTTOMRIGHT)
	end

	stepui.goaluis = {}	-- Goal UIs

	cginherits(stepui,StepUI)

	return stepui
end

function Viewer:CreateGoalUI(parent,goalnum)
	if not goalnum then return end
	local goalName = parent:GetName().."_Goal"..goalnum
	local goaluis = parent.goaluis

	local goalui = CHAIN(ui:Create("SecFrame",parent,goalName))
		:SetResizeToFitDescendents(true)
		:SetMouseEnabled(true)
		:SetHandler("OnMouseUp",function(me,but) me:OnMouseUp(but) end)
		:SetHandler("OnResizedToFit",function(me,...)
				Viewer:Debug("Goal %s Resized to %d %d",me:GetName(),...)
			end)
		.__END

	if goalnum == 1 then
		CHAIN(goalui)
		:SetPoint(TOPLEFT)
		:SetPoint(TOPRIGHT)
	else
		local anchorParent = goaluis[goalnum-1]
		CHAIN(goalui)
		:SetPoint(TOPLEFT,anchorParent,BOTTOMLEFT)
		:SetPoint(TOPRIGHT,anchorParent,BOTTOMRIGHT)
	end

	goalui.icon = CHAIN(ui:Create("Texture",goalui,goalName.."_Icon"))
		:SetPoint(LEFT,GOAL_ICON_PADDING,0)	-- LEFT anchor avoids ~5px extra row height vs TOPRIGHT on descendents sizing
		:SetSize(GOAL_ICON_SIZE,GOAL_ICON_SIZE)
		:SetTexture(CGV.DIR .. "/Viewer/Skins/Stealth/stepicons.dds")
		.__END

	local labelOffset = GOAL_ICON_SIZE + GOAL_ICON_PADDING * 2 -- Width of the icon, plus double it's offset
	-- Note: Don't anchor the label off of the icon because run into issues of vertically centering a single line/multiple lines.

	goalui.label = CHAIN(ui:Create("Label",goalui,goalName.."_Label",GOAL_FONTSIZE))
		:SetPoint(LEFT,goalui,LEFT,labelOffset,0)
		:SetPoint(RIGHT)
		:SetCanWrap(true)
		:SetText(goalName)
		:SetHandler("OnTextChanged", function(me)
				local goalui = me:GetParent()
				if not goalui.dirty then return end	-- This is needed because sometimes OnTextChanged will trigger multiple times w/o text actually changing and do bad things

				Viewer:Debug("%s Changed",me:GetName())

				-- Reposition the icon based on if there is 1 line or multiple.
				goalui.icon:ClearAllPoints()
				if me:DidLineWrap() then
					goalui.icon:SetPoint(TOPLEFT,GOAL_ICON_PADDING,GOAL_ICON_PADDING)
				else
					goalui.icon:SetPoint(LEFT,GOAL_ICON_PADDING,0)
				end

				goalui.dirty = nil
			end)
		.__END

	cginherits(goalui,GoalUI)

	return goalui
end

-----------------------------------------
-- FRAME CLASS FUNCTIONS
-----------------------------------------

function FrameUI:GetStepUI(stepnum)
	local stepuis = self.stepuis
	local stepui
	if stepuis[stepnum] then
		-- Step is already available for this, just return it.
		stepui = stepuis[stepnum]

	else
		stepui = Viewer:CreateStepUI(self,stepnum)

		tinsert(stepuis,stepui)
	end

	return stepui
end

function FrameUI:GetStepSkipCount(time)
	if time<2 then return 1
	elseif time<3 then return 2
	elseif time<4 then return 5
	else return 10
	end 
end

-- Hide step slots beyond the number the user wants visible.
function FrameUI:HideExtraSteps(keep)
	keep = keep or 0
	for i, stepframe in ipairs(self.stepuis) do
		if i > keep then
			stepframe:ClearAndHide()
		end
	end
end

-- Soft alpha pulse for attention (bug report pending / no guide loaded).
local function PulseAlpha(control, active)
	if not control or control:IsHidden() then return end
	if active then
		local phase = (_G.GetFrameTimeMilliseconds() % 700) / 700
		-- 0.4 ↔ 1.0 triangle wave
		local a = phase < 0.5 and (0.4 + phase * 1.2) or (1.0 - (phase - 0.5) * 1.2)
		control:SetAlpha(a)
	else
		control:SetAlpha(1)
	end
end

function FrameUI:OnUpdate(time)

	local titlebar = Viewer.Frame and Viewer.Frame.TitleBar
	local bug = titlebar and titlebar.bug
	local hasBug = CGV.BugReport and CGV.BugReport.report and #CGV.BugReport.report > 0
	PulseAlpha(bug, hasBug)

	local guideSelect = titlebar and titlebar.guideSelect
	local needGuide = (not CGV.CurrentGuide) and (not CGV.loading)
	PulseAlpha(guideSelect, needGuide)
	if titlebar and titlebar.guideBox and titlebar.guideBox.SetBackdropAlpha then
		-- Subtle box pulse with the picker when no guide is loaded
		if needGuide then
			local phase = (_G.GetFrameTimeMilliseconds() % 700) / 700
			local a = phase < 0.5 and (0.55 + phase * 0.7) or (0.9 - (phase - 0.5) * 0.7)
			titlebar.guideBox:SetBackdropAlpha(a)
		else
			titlebar.guideBox:SetBackdropAlpha(1)
		end
	end

	if (Viewer.prevDownTime or Viewer.nextDownTime) and (time - (self.lastArrowSurfUpdate or 0) > ARROW_DOWN_REPETITION) then  -- time for next repetition click!
		-- and now the FAST step surfing
		if Viewer.prevDownTime and (time - Viewer.prevDownTime) > ARROW_DOWN_STARTTIMER then
			local stepskipcount = self:GetStepSkipCount(time - Viewer.prevDownTime)
			Viewer:PrevStep_GuideViewer(stepskipcount)
		elseif Viewer.nextDownTime and (time - Viewer.nextDownTime) > ARROW_DOWN_STARTTIMER then
			local stepskipcount = self:GetStepSkipCount(time - Viewer.nextDownTime)
			Viewer:NextStep_GuideViewer(stepskipcount)
		end
		self.lastArrowSurfUpdate = time
	end

	if time - (self.lastUpdate or 0) < UPDATETIME then return end	-- throttle it based on time.
	self.lastUpdate = time

	CGV:TryToCompleteStep(CGV.fastforward)

	if CGV.Features and CGV.Features.OnViewerUpdate then
		CGV.Features:OnViewerUpdate()
	end

	-- Try to update the Progress bar periodically incase they are not advancing steps
	if time - (self.lastProgBarUpdate or 0) > PROG_UPDATETIME then
		self.lastProgBarUpdate = time
		Viewer:UpdateProgressBar()
	end
end

-----------------------------------------
-- STEP CLASS FUNCTIONS
-----------------------------------------

function StepUI:GetGoalUI(goalnum)
	local goaluis = self.goaluis
	local goalui
	if goaluis[goalnum] then
		-- Step is already available for this, just return it.
		goalui = goaluis[goalnum]

	else
		goalui = Viewer:CreateGoalUI(self,goalnum)

		tinsert(goaluis,goalui)
	end

	return goalui
end

function StepUI:HideExtraGoals()
	for _,goalframe in ipairs(self.goaluis) do
		if goalframe.updated then
			goalframe:Show()
		else
			goalframe:Hide()
			goalframe.goal = nil
		end

		goalframe.updated = nil
	end
end

-- Clear all goals and hide this step slot (past end of guide, or unused slot).
function StepUI:ClearAndHide()
	for _,goalframe in ipairs(self.goaluis) do
		goalframe.updated = nil
		goalframe.goal = nil
		goalframe:Hide()
	end
	self:Hide()
end

-----------------------------------------
-- GOAL CLASS FUNCTIONS
-----------------------------------------

function GoalUI:SetText(text)
	self.label:SetText(text)
end

function GoalUI:SetIcon(texture,_)
	if type(texture) == "string" then
		self.icon:SetTexture(texture)
	elseif type(texture) == "table" then
		self.icon:SetTexture(unpack(texture))
	elseif type(texture) == "number" then
		self.icon:SetTextureCoords((texture-1)/16,texture/16,0,1)
	end
end

function GoalUI:OnMouseUp(but)
	if self.goal and self.goal.action == "confirm" then -- Has a |confirm
		-- |confirm |nextreload … switches guides live on click (still a hyperlink).
		local halt = self.goal:OnClick()
		if not halt then Viewer:NextStepButton_OnClick() end
	end
	-- Quest link: Ctrl+click a goal that names a quest → open journal.
	if but ~= RIGHT_MOUSE_BUTTON and self.goal and self.goal.quest
		and _G.IsControlKeyDown and _G.IsControlKeyDown()
		and CGV.Features and CGV.Features.OpenQuestInJournal
		and CGV.db and CGV.db.profile and CGV.db.profile.questlink ~= false then
		CGV.Features:OpenQuestInJournal(self.goal.quest)
	end
	if but == RIGHT_MOUSE_BUTTON and Zgoo then
		Zgoo("CGV.CurrentStep.goals["..(self.goal.num).."]")
	end
end

-----------------------------------------
-- GUIDE BUTTON FUNCTIONS
-----------------------------------------

function Viewer:CloseButton_OnClick()
	self:Hide_GuideViewer()
end

function Viewer:HelpButton_OnClick()
	if not self.HelpPopup then
		local popup = CGV.Popup:New("Community_Help_Popup")

		popup:SetMouseEnabled(true)
		popup:SetMovable(true)

		popup.declinebutton:Hide()

		CHAIN(popup.acceptbutton)
			:ClearAllPoints()
			:SetPoint(BOTTOM, popup, BOTTOM, 0, -5)

		self.HelpPopup = popup
	end

	self.HelpPopup:SetText(L["static_help"])
	self.HelpPopup:SetDimensionConstraints(225, nil, 625, nil)
	self.HelpPopup:Show()
end

function Viewer:PrevStepButton_OnClick(but)
	if _G.IsControlKeyDown() and not _G.IsAltKeyDown() then
		CGV:FocusStep(1)
		CGV.pause = nil
	else
		self:PrevStep_GuideViewer(1,but == RIGHT_MOUSE_BUTTON)
	end
end

function Viewer:NextStepButton_OnClick(but)
	self:NextStep_GuideViewer(1,but == RIGHT_MOUSE_BUTTON)
end

function Viewer:GuideSelectButton_OnClick()
	CGV.GuideMenu:Show()
end

-----------------------------------------
-- VIEWER FUNCTIONS
-----------------------------------------

-- Can pass a parameter to show/hide to not toggle the main CGV option. This is done when hid because of an action layer change
function Viewer:Show_GuideViewer(notoggle)
	if not self.Frame then
		self:CreateCGVF()
	end

	if not notoggle then
		CGV.sv.profile.showviewer = true
	end

	self.Frame:Show()

	self:Update(1)
end

function Viewer:Hide_GuideViewer(notoggle)
	if not self.Frame then return end

	if not notoggle then
		CGV.sv.profile.showviewer = false
	end

	self.Frame:Hide()
end

function Viewer:ShowIf_GuideViewer(bool)
	if not self.Frame then return end

	if bool then
		self:Show_GuideViewer()
	else
		self:Hide_GuideViewer()
	end
end

function Viewer:Toggle_GuideViewer()
	if self:GuideViewer_IsShown() then
		self:Hide_GuideViewer()
	else
		self:Show_GuideViewer()
	end
end

function Viewer:GuideViewer_IsShown()
	return self.Frame and self.Frame:IsShown()
end

function Viewer:NextStep_GuideViewer(count,fast)
	count = count or 1
	if not self.Frame then return end

	for i = 1,count do
		CGV:SkipStep(fast,i<count)
	end
end

function Viewer:PrevStep_GuideViewer(count,fast)
	count = count or 1
	if not self.Frame then return end

	for i = 1,count do
		CGV:PreviousStep(fast,i<count)
	end
end

-----------------------------------------
-- VIEWER UPDATE FUNCTIONS
-----------------------------------------

-- Updates the steps and all that jazz
function Viewer:Update(full)
	if not self.Frame or not self.Frame:IsShown() then return end
	local Fr = self.Frame

	if CGV.loading then
		Fr.TitleBar.guideLabel:SetText("Still loading?!?")
	else
		local curGuide = CGV.CurrentGuide

		if curGuide and curGuide.steps and curGuide.fully_parsed then

			if full then
				Fr.TitleBar.stepLabel:SetText(CGV.CurrentStepNum)
				Fr.TitleBar.guideLabel:SetText(curGuide.title_short)
			end

			-- Slot 1 = current step; slots 2..N = upcoming steps. Hide empty / unused slots.
			local numShow = CGV.sv.profile.numStepShow or 1
			if numShow < 1 then numShow = 1 end
			local curStepNum = CGV.CurrentStepNum or 1

			for slot = 1, numShow do
				local stepframe = Fr:GetStepUI(slot)
				local guideStepNum = curStepNum + slot - 1
				local step = curGuide:GetStep(guideStepNum)

				if step and step.goals then
					stepframe:Show()

					local goalnum = 1	-- goalnum incremented manually so tip lines can be added
					for _,goal in ipairs(step.goals) do while(1) do
						local goalframe = stepframe:GetGoalUI(goalnum)
						local text = goal:GetText()
						local status = goal:GetStatus()
						if status == "hidden" then break end	-- Don't display a hidden goal.

						goalnum = goalnum + 1

						goalframe.goal = goal

						goalframe:SetText(text)
						goalframe.dirty = true	-- Just set the text, So don't trigger a OnTextChanged until it is dirty again.
						goalframe.updated = true

						-- Have a tip
						if goal.tooltip then
							-- appended to the end of a goal. Get another goal line and put the tip on that line.
							local tiptext = goal:GetTipText()
							local tipframe

							if goal.action~="tip" then
								tipframe = CHAIN(stepframe:GetGoalUI(goalnum))
								-- Tip line attached to another goal — set icon/backdrop here.
								:SetBackdropColor(0,0,0,0)
								:SetIcon(1)
								.__END

								goalnum = goalnum + 1
							else
								-- Step tip. Just use the regular goalframe
								tipframe = goalframe
							end

							-- Update the text for being a tip
							tipframe:SetText(tiptext)
							tipframe.updated = true

							tipframe.label:SetFontSize(CGV.sv.profile.fontsecsize)
						else
							goalframe.label:SetFontSize(CGV.sv.profile.fontsize)
						end

						-- ICONS (always shown; from stepicons.dds)
						goalframe.icon:Show()

						if goal.next then
							goalframe:SetIcon(actionicon.next)

						elseif status == "passive" then

							if 	goal.action == "talk" or
								goal.action == "from" or
								goal.action == "goto" or
								goal.action == "goldcollect" or
								goal.action == "goldtracker" then
									goalframe:SetIcon(actionicon[goal.action])
							else
								goalframe:SetIcon(1)
							end

						elseif status == "incomplete" then

							goalframe:SetIcon(actionicon[goal.action])

						elseif status == "complete" then

							goalframe:SetIcon(3)

						elseif status == "impossible" then

							goalframe:SetIcon(actionicon[goal.action])

						elseif status == "obsolete" then

							goalframe:SetIcon(actionicon[goal.action])

						else -- maybe hidden, maybe WTF
							goalframe:SetIcon(1)
						end

						-- Backdrops — incomplete/current steps use translucent brand accent.
						-- Alpha lives in Theme.ACCENT_ROW_ALPHA (set to 1 for solid).

						local arr = (CGV.Pointer.ArrowFrame and CGV.Pointer.ArrowFrame.waypoint and CGV.Pointer.ArrowFrame.waypoint.goalnum==goal.num and 0.3) or 0
						local ar, ag, ab, aa = 245/255, 93/255, 7/255, 0.40
						if CGV.Theme and CGV.Theme.AccentRowTable then
							ar, ag, ab, aa = unpack(CGV.Theme.AccentRowTable(arr > 0))
						elseif CGV.Theme and CGV.Theme.Accent then
							ar, ag, ab = CGV.Theme.Accent()
							aa = (CGV.Theme.ACCENT_ROW_ALPHA or 0.40)
						end

						if goal:IsCompletable() then
							local complete,possible = goal:IsComplete()
							if complete == "past" then
								goalframe:SetBackdropColor(0,1,0,.5)  -- saving this for future use, I guess. We don't really show many CURRENT and COMPLETE steps, they're usually past already.
							elseif complete then
								goalframe:SetBackdropColor(arr,1,arr,.5)
							elseif possible then
								goalframe:SetBackdropColor(ar, ag, ab, aa)
							else
								goalframe:SetBackdropColor(0.6+arr,0.6+arr,0.6+arr,.5)
							end
						else
							if arr > 0 then
								goalframe:SetBackdropColor(ar, ag, ab, aa)
							else
								goalframe:SetBackdropColor(0, 0, 0, 0)
							end
						end


						break end
					end

					-- Hide/Show goals properly.
					stepframe:HideExtraGoals()

				else
					-- Past end of guide (or missing step) — clear and hide this slot.
					stepframe:ClearAndHide()
				end
			end

			-- Drop any previously created slots beyond the current setting.
			Fr:HideExtraSteps(numShow)

		else
			-- No current guide.
			if #CGV.registeredguides > 0 then
				Fr.TitleBar.guideLabel:SetText(L["guide_notselected"])
			else
				Fr.TitleBar.guideLabel:SetText(L["guide_notloaded"])
			end

			Fr:HideExtraSteps(0)
		end
	end

	if full then self:UpdateProgressBar() end
end

-- Updates the visuals on the viewer itself.
function Viewer:UpdateViewer()
	-- Defaults: backdrop opacity 20% (DEFAULT_VIEWER_OPACITY = 0.20).
	-- v3: migrated opaque / prior 0.65 / 0.42 → 0.20 once.
	-- v4: force 0.20 once more so existing chars pick up the translucent default.
	local opacity = CGV.sv.profile.opacitymain
	if not CGV.sv.profile.opacity_default_v3 then
		local nearPrior = false
		if opacity then
			for _, prior in ipairs(PRIOR_DEFAULT_OPACITIES) do
				if zo_floatsAreEqual(opacity, prior, 0.02) then
					nearPrior = true
					break
				end
			end
		end
		if opacity == nil or opacity >= 0.99 or nearPrior then
			opacity = DEFAULT_VIEWER_OPACITY
			CGV.sv.profile.opacitymain = opacity
		end
		CGV.sv.profile.opacity_default_v3 = true
		CGV.sv.profile.opacity_backdrop_only = true
		CGV.sv.profile.opacity_default_v2 = true
	end
	if not CGV.sv.profile.opacity_default_v4 then
		opacity = DEFAULT_VIEWER_OPACITY
		CGV.sv.profile.opacitymain = opacity
		CGV.sv.profile.opacity_default_v4 = true
		CGV.sv.profile.opacity_backdrop_only = true
	end

	self:SetAlpha(opacity or DEFAULT_VIEWER_OPACITY)
	self:SetScale(CGV.sv.profile.framescale)

	CGV.sv.profile.vieweranchor = CGV.sv.profile.vieweranchor and #CGV.sv.profile.vieweranchor==5 and CGV.sv.profile.vieweranchor or DEFAULT_ANCHOR
	local point, relativeTo, relativePoint, offsetX, offsetY = unpack(CGV.sv.profile.vieweranchor)
	relativeTo = GuiRoot		-- Force to GuiRoot.
	CHAIN(self.Frame.master)
		:ClearAllPoints()
		:SetPoint(point, relativeTo, relativePoint, offsetX, offsetY)

	self:Update()
end

-- Progress is always step-based (level mode retired — quests scale with character).
function Viewer:ChangeProgressType(mode)
	CGV.sv.profile.viewerProgBar = PROG_BAR_TYPE_STEP
	self:UpdateProgressBar()
end

function Viewer:UpdateProgressBar()
	if not self.Frame or not self.Frame:IsShown() then return end
	local progressbar = self.Frame.progress
	local curGuide = CGV.CurrentGuide

	local progressText, tooltip, progress, label

	progress = 0
	CGV.sv.profile.viewerProgBar = PROG_BAR_TYPE_STEP

	self:Debug("Updating Progress Bar")

	if not curGuide then
		-- No guide, no progress
		label = L['frame_guide_none']
	else
		progressText, tooltip, progress = curGuide:GetCompletionText(PROG_BAR_TYPE_STEP)
		if not progress then return end

		if progress == 100 then
			label = L['frame_guide_complete']
		else
			label = (L['frame_guide_progress']:format(progress))
		end
		progressbar:SetColor(PROG_BAR_COLOR_STEP)
	end

	progressbar.tooltip = tooltip or "none"

	progressbar:SetPercent(progress)
	progressbar:SetText(label)

	-- If we are hovering over the PB then need to update the tooltip too.
	if progressbar.tooltipShown then
		progressbar:GetHandler("OnMouseEnter")(progressbar)
	end
end

-- Called from UI Creation handlers
-- Resize the Viewer to fit the stepbox
function Viewer:ResizeToFitSteps()
	if not self.Frame then return end

	self:Debug("Resizing To Fit Steps")

	local frame = self.Frame
	local top = frame:GetTop()
	local bot = frame.settings:GetBottom()	-- This is anchored to the bottom of the stepbox.
	local scale = frame:GetScale()
	local belowStepHeight = VIEWER_BOT_PADDING * scale		-- Multiple this by the scale because it isn't an offset that scales properly, but height where scale matters.

	local frameHeight = (bot-top) +	belowStepHeight		-- (Top of the whole frame to the bottom of the stepbox) + Padding for bottom of frame
	frameHeight = frameHeight / scale		-- Whole height / scale so that it is the right size... mathz

	frame:SetHeight(frameHeight)

	-- When changing the frame it sometimes loses it's anchor to master. Strongely enforce it.
	CHAIN(frame)
		:ClearAllPoints()
		:SetPoint(TOP,frame.master)
end

-- Apply opacity to viewer backdrops only so the world shows through while text/icons stay readable.
function Viewer:SetAlpha(a)
	if not self.Frame then return end

	a = a or DEFAULT_VIEWER_OPACITY
	if a < 0 then a = 0 elseif a > 1 then a = 1 end

	local frame = self.Frame
	frame:SetBackdropAlpha(a)

	if frame.stepbox and frame.stepbox.SetBackdropAlpha then
		frame.stepbox:SetBackdropAlpha(a)
	end

	local guideBox = frame.TitleBar and frame.TitleBar.guideBox
	if guideBox and guideBox.SetBackdropAlpha then
		guideBox:SetBackdropAlpha(a)
	end

	-- Keep Home menu + popups in sync with the opacity slider.
	if CGV.Menu and CGV.Menu.SetBackdropOpacity then
		CGV.Menu:SetBackdropOpacity(a)
	end
	if CGV.PopupHandler and CGV.PopupHandler.SyncLiveSettings then
		CGV.PopupHandler:SyncLiveSettings()
	end
end

function Viewer:SetScale(scale)
	if not self.Frame then return end

	local frame = self.Frame

	frame:SetScale(scale)
end

function Viewer:ResetToDefaultPosition()
	CGV.sv.profile.vieweranchor = DEFAULT_ANCHOR

	CHAIN(Viewer.Frame.master)
		:ClearAllPoints()
		:SetPoint(unpack(CGV.sv.profile.vieweranchor))
end

function Viewer:ResetToDefaultWidth()
	CGV.sv.profile.viewerwidth = DEFAULT_WIDTH

	Viewer.Frame:SetWidth(CGV.sv.profile.viewerwidth)
end

function Viewer:ResetAllViewerSettings()
	local opt_group = CGV.Settings:GetOptionGroupByName("viewer")

	opt_group:SetToDefault()	-- Set all options in our setting menu to default.

	-- Few extra things to reset
	self:ResetToDefaultWidth()
	self:ResetToDefaultPosition()

	-- Force it to show up
	self:Show_GuideViewer()
end

function Viewer:HandleActionLayer()
	local isActive = IsActionLayerActiveByName

	if (( isActive("GameMenu")							-- GameMenu
			or isActive("User Interface Shortcuts")			-- User Interface Shortcuts
			or isActive("Notifications")					-- Notifications
			or isActive("Siege")							-- Siege
			or isActive("Dialogs") )						-- Dialogs
		and CGV.sv.profile.hideoninventory
	)
	or (isActive("Conversation")						-- Conversation
		and (CGV.sv.profile.hideonguideconv				-- Hide when convo with guide person starts, hide with anyone.
			or 	(CGV.sv.profile.hideoninventory and (CGV.Pointer.curdist and CGV.Pointer.curdist or 0) > 10) )	-- Don't hide if talking to someone directed by the guide. >10 yd away means they are not in the guide.
	)
	then
		if Viewer:GuideViewer_IsShown() then
			self.hiddeninlayer = true

			CGV.Menu:Hide()								-- Hide guide menu. Don't worry about reopening
			self:Hide_GuideViewer(1)					-- Don't toggle the hide/show viewer option
		end
	else
		if self.hiddeninlayer then
			self.hiddeninlayer = nil

			self:Show_GuideViewer(1)
		end
	end

	_G.ZO_WorldMap_UpdateMap()								-- workaround: map sometimes stale after layer changes
end


-----------------------------------------
-- EVENTS
-----------------------------------------

--[[
	1. General						-- Always open, Don't hide
	2. User Interface Shortcuts	-- Hide
	3. Siege
	4. Dialogs
	5. Notifications
	6. MouseUIMode					-- Nupe
	7. Conversation					-- Hide
	8. Guild
	9. RadialMenu					-- Don't hide
	10. Death						-- Don't hide
	11. Loot						-- Don't hide
	12. GameMenu					-- Hide
	13. Keybind Window
	14. Addons
	15. OptionsWindow

	If 13/14/15 is open then
		12 is open

	if 8 is open then
		2 is open
--]]

function Viewer:EVENT_ACTION_LAYER_PUSHED(_,_,_)
	--print(ActionLabels[layerIndex],ActionLabels[activeLayerIndex])
	Viewer:HandleActionLayer()
end

function Viewer:EVENT_ACTION_LAYER_POPPED(_,_,_)
	--print(ActionLabels[layerIndex],ActionLabels[activeLayerIndex])
	Viewer:HandleActionLayer()
end

-- state = true -> Enter Combat
-- state = false -> Exit Combat
function Viewer:EVENT_PLAYER_COMBAT_STATE(_,state)
	if not CGV.sv.profile.hideincombat then return end

	if state then
		self.hiddenincombat = true
		CGV.Menu:Hide()						-- Hide guide menu. Don't worry about reopening
		self:Hide_GuideViewer(1)			-- Don't toggle the hide/show viewer option
	elseif self.hiddenincombat then
		self.hiddenincombat = nil

		self:Show_GuideViewer(1)
	end

end
-----------------------------------------
-- DEBUG
-----------------------------------------

function Viewer:Debug(...)
	local str = ...
	CGV:Debug("&viewer "..str, select(2,...) )
end

-----------------------------------------
-- STARTUP
-----------------------------------------

tinsert(CGV.startups,function(self)
		self.Events:AddEvent(EVENT_ACTION_LAYER_POPPED, Viewer)
		self.Events:AddEvent(EVENT_ACTION_LAYER_PUSHED, Viewer)
		self.Events:AddEvent(EVENT_PLAYER_COMBAT_STATE, Viewer)

		setupActionLayers()
	end)
