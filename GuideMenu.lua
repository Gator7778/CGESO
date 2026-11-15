-----------------------------------------
-- INFORMATION
-- :SetPoint(POINT ORIGIN, UI reference, X, Y)
-----------------------------------------

-----------------------------------------
-- LOCALIZED GLOBAL VARIABLES
-----------------------------------------

local CGV = _G.CGV
local TOPLEFT, TOPRIGHT, BOTTOMLEFT, BOTTOMRIGHT, CENTER = _G.TOPLEFT, _G.TOPRIGHT, _G.BOTTOMLEFT, _G.BOTTOMRIGHT, _G.CENTER
local TOP, RIGHT, BOTTOM, LEFT = _G.TOP, _G.RIGHT, _G.BOTTOM, _G.LEFT
local CT_TEXTURE = _G.CT_TEXTURE

local Menu = {}
local Settings = {
	opt_groups = {},
	OptionUI = {},
}
local GuideMenu = {}

-- Soft accent hover for list rows (Theme.lua — flip USE_BRAND_ACCENT to revert)
local BUTTON_HIGHLIGHT_TEXTURE = (CGV.Theme and CGV.Theme.AccentSoftTable(0.55)) or {245/255,93/255,7/255,.55}

local name = "CommunityMenu"
local GUIDEMENU_TAB_ID = "guides"
local SETTINGS_TAB_ID = "settings"

local DEFAULT_WIDTH = 980
local DEFAULT_HEIGHT = 760
local HEADER_HEIGHT = 60
local FOOTER_HEIGHT = 25
local LEFT_COLUMN_WIDTH = 250
local SCROLL_WIDTH = 15
local GUIDE_IMAGE_WIDTH = 512
-- Display height for Home banners (DDS is 512×256; stretch slightly taller to fill panel).
local GUIDE_IMAGE_HEIGHT = 312
local WELCOME_GUIDE_IMAGE = (CGV.DIR or "CGESO").."/Viewer/Skins/Stealth/cgeso-SOTWC.dds"
local OPTIONS_LEFT_OFFSET = 15
local OPTIONS_VERT_OFFSET = 8
-- Gap between last option (e.g. tip text) and Default/Accept buttons.
local OPTIONS_BOTTOM_PAD = 36
local DEFAULT_ANCHOR= {	CENTER, }
-- Guide Home list math (DEFAULT_HEIGHT 760, HEADER 60, FOOTER 25 → mainBackdrop ~675):
--   header≈30 + search 22+4 + pads ≈ 60 → list grows with frame; RefreshUI measures fit.
-- Pool is larger; RefreshUI hides any row past the measured fit.
local GUIDE_LIST_ROW_HEIGHT = 22
-- Tall enough for DEFAULT_HEIGHT 760 (list host ≈ 590px → ~26 rows).
local GUIDE_MENU_BUTTON_POOL = 28
local GUIDE_MENU_FALLBACK_LINES = 16 -- if host height not ready yet
-- Settings left category list (same row height; scrolls when groups > visible lines)
local SETTINGS_LIST_ROW_HEIGHT = GUIDE_LIST_ROW_HEIGHT
local SETTINGS_BUTTON_POOL = 20
local SETTINGS_FALLBACK_LINES = 12

local GuideStatusColor = {
	["SUGGESTED"]	= "FFCC40",
	["VALID"]		= "40BF40",
	["COMPLETE"]	= "808080",
	["INVALID"] 	= "E60000",
	["HEADER"] 		= "FFFFFF",
	["FOLDER"] 		= "FFFFFF",
}

local FOLDER_FAVORITES = "__favorites__"
local FOLDER_SUGGESTED = "__suggested__"
local RIGHT_MOUSE_BUTTON = _G.RIGHT_MOUSE_BUTTON or 2

local tinsert,type,pairs,ipairs,class = table.insert,type,pairs,ipairs,_G.class
local CHAIN = CGV.Utils.ChainCall
local ui = CGV.UI
local wm = _G.WINDOW_MANAGER
local L = CGV.L
local GuiRoot = _G.GuiRoot
local titlebar = _G.titlebar

-----------------------------------------
-- METATABLE SETUP
-----------------------------------------

setmetatable(Settings.OptionUI, {
		__index = function(_,tab)
			error(("Option Type %s is not available."):format(tostring(tab)))
		end
	})

-----------------------------------------
-- SAVED REFERENCES
-----------------------------------------

CGV.Menu = Menu
CGV.Settings = Settings
CGV.GuideMenu = GuideMenu
Menu.Settings = Settings
Menu.GuideMenu = GuideMenu

-----------------------------------------
-- LOCAL FUNCTIONS
-----------------------------------------

local function GetOpinionFrame(parent,name,opt,notooltip)
	local opt_frame = CHAIN(ui:Create("InvisFrame", parent, name))
		:SetResizeToFitDescendents(true)
		:SetMouseEnabled(true)
		.__END
	if opt_frame.SetClampedToScreen then
		opt_frame:SetClampedToScreen(false)
	end

	if not notooltip then
		opt_frame:AddTooltip(opt.title,opt.desc)
	end

	-- Invisible sizing backdrop for ResizeToFitDescendents. SecBackdrop IS the CT_BACKDROP
	-- (no .bd child), so SetBackdropColor is a no-op — must SetCenterColor or rows stay
	-- opaque gray and paint under the HUD when options overflow the Home frame.
	opt_frame.bd = CHAIN(ui:Create("SecBackdrop",opt_frame,name and name.."_BD"))
		:SetCenterColor(0,0,0,0)
		:SetEdgeColor(0,0,0,0)
		:SetExcludeFromResizeToFitExtents(false)
		.__END

	return opt_frame
end

local function GetInlineDesc(parent,name)
	local desc = CHAIN(ui:Create("Label",parent,name,11))
		:SetCanWrap(true)
		.__END
	return desc
end

local function SetTextureBlock(tex,nh,nv,h,v)
	tex:SetTextureCoords((nh-1)/h,nh/h,(nv-1)/v,nv/v)
	tex:SetTextureCoords((nh-1)/h,nh/h,(nv-1)/v,nv/v)
end

local function SetIcon(self,nh,nv,h,v,sec)
	local icon = sec and self.iconover or self.icon
	if nh > 0 then
		icon:Show()
	else
		icon:Hide()
	end
	icon:SetTexture(CGV.DIR.."/Viewer/Skins/Stealth/guideicons-small.dds")
	SetTextureBlock(icon,nh,nv,h,v)
end

-----------------------------------------
-- CREATE MENU FUNCTIONS
-----------------------------------------

function Menu:CreateBaseMenu()

	if self.Frame then return end

	-- main window
	local frame =  CHAIN(ui:Create("Frame",GuiRoot,name))
		:SetPoint(unpack(DEFAULT_ANCHOR))
		:SetCanDrag(1)
		:SetSize(DEFAULT_WIDTH,DEFAULT_HEIGHT)
		:SetMouseEnabled(true)
		:Hide()
		.__END
	self.Frame = frame

	-- Footer band (height = FOOTER_HEIGHT). Version + settings stay vertically centered if FOOTER_HEIGHT changes.
	frame.footer = CHAIN(ui:Create("InvisFrame",frame,name.."_Footer"))
		:SetPoint(BOTTOMLEFT,frame,BOTTOMLEFT,0,0)
		:SetPoint(BOTTOMRIGHT,frame,BOTTOMRIGHT,0,0)
		:SetHeight(FOOTER_HEIGHT)
		.__END

	-- Guide version, lower left (LEFT↔LEFT keeps label mid-line centered in the footer)
	frame.version = CHAIN(ui:Create("Label",frame.footer,name.."_VerTitle",12,"bold"))
		:SetPoint(LEFT,frame.footer,LEFT,10,0)
		:SetText("VER:")
		.__END

	frame.versionNum = CHAIN(ui:Create("Label",frame.footer,name.."_VerNum",12))
		:SetPoint(LEFT,frame.version,RIGHT,3,0)
		:SetText("|cffaa00"..CGV.version.."|r")
		.__END

	-- Community Leveling Guides logo, upper right, left of close button
	frame.logo = CHAIN(ui:Create("Logo",frame,name.."_Logo","Logo"))
		:SetTexture(CGV.DIR .. "/Viewer/Skins/Stealth/communityguidelogo.dds")
		:SetSize(300,40)
		:SetPoint(TOPRIGHT, titlebar, -5, 10)
		.__END

	-- Close button, upper right
	frame.close = CHAIN(ui:Create("GuideButton",frame,name.."_Close","Close"))
		:SetPoint(TOPRIGHT, titlebar, -5, 5)
		:SetSize(20,20)
		:SetHandler("OnClicked",function()
				Menu:Hide()
			end)
		.__END

	-- Guide title
	frame.tabhandler = CHAIN(ui:Create(
			"Tabs",
			frame,
			name,
			{
				{
					id = GUIDEMENU_TAB_ID,
					name = "Home",
					size = { 120, 40 },
					fontsize = 25,
					point = { TOPLEFT, -12, 9 },
					handler = function()
						Menu:SetTab(GUIDEMENU_TAB_ID)
					end
				},
				{
					id = SETTINGS_TAB_ID,
					name = "",
					size = { 120, 40 },
					fontsize = 25,
					handler=function()
						Menu:SetTab(SETTINGS_TAB_ID)
					end
				},
			}
		))
	.__END

	-- Settings Gear button, bottom right (centered in footer band)
	frame.settings = CHAIN(ui:Create("GuideButton",frame.footer,name.."_Settings","Settings"))
		:SetPoint(RIGHT,frame.footer,RIGHT,-5,0)
		.__END
	-- Secondary Frame (contains the menu, scroll bar, and guide information)
	frame.mainBackdrop = CHAIN(ui:Create("SecFrame", frame, name.. "_mainBackdrop"))
		:SetPoint( TOPLEFT,frame, TOPLEFT,1,HEADER_HEIGHT)
		:SetPoint(BOTTOMRIGHT,frame,BOTTOMRIGHT,-1,-FOOTER_HEIGHT)
		:SetBackdropColor(.15,.15,.15,1) -- #252526; alpha set via SetBackdropOpacity
		.__END
	-- Nested SecFrames default ClampToScreen; that shoves settings past Home after alt-tab.
	if frame.mainBackdrop.SetClampedToScreen then
		frame.mainBackdrop:SetClampedToScreen(false)
	end
	if frame.mainBackdrop.SetClipsChildren then
		frame.mainBackdrop:SetClipsChildren(true)
	end
	if frame.SetClipsChildren then
		frame:SetClipsChildren(true)
	end

	-- Soft 2px accent under header (SecFrame so color tints correctly — plain Texture looked red)
	frame.headerAccent = CHAIN(ui:Create("SecFrame",frame,name.."_HeaderAccent"))
		:SetHeight(2)
		:SetPoint(TOPLEFT,frame.mainBackdrop,TOPLEFT,0,0)
		:SetPoint(TOPRIGHT,frame.mainBackdrop,TOPRIGHT,0,0)
		:SetBackdropColor(unpack((CGV.Theme and CGV.Theme.AccentTable()) or {HTMLColor("#F55D07ff")}))
		:SetBackdropEdgeColor(0,0,0,0)
		.__END

	self:SetBackdropOpacity()
	self:RegisterChromeRedraw()
	self:SetTab(GUIDEMENU_TAB_ID)	-- Set the default tab
end

-- Known chrome RGB (alpha comes from opacitymain). Always re-apply full SetBackdropColor —
-- SetBackdropAlpha re-reads GetCenterColor, which ESO can wipe to 0 after alt-tab.
local MENU_FRAME_RGB = {0, 0, 0}
local MENU_MAIN_RGB = {.15, .15, .15}
local MENU_SCROLL_RGB = {.4, .4, .4}
local MENU_SEARCH_RGB = {.2, .2, .2}

local function SetChromeColor(ctrl, rgb, a)
	if not (ctrl and ctrl.SetBackdropColor and rgb) then return end
	ctrl:SetBackdropColor(rgb[1], rgb[2], rgb[3], a)
end

-- Same as Guide Viewer / popups: fade chrome backdrops only; text and buttons stay readable.
function Menu:SetBackdropOpacity(a)
	if a == nil and CGV.db and CGV.db.profile then
		a = CGV.db.profile.opacitymain
	end
	if a == nil then a = 0.20 end
	if a < 0 then a = 0 elseif a > 1 then a = 1 end

	local frame = self.Frame
	if not frame then return end

	if frame.SetAlpha then
		frame:SetAlpha(1)
	end

	-- Full redraw (not SetBackdropAlpha) so wiped CT_BACKDROP colors come back after focus/resize.
	SetChromeColor(frame, MENU_FRAME_RGB, a)
	SetChromeColor(frame.mainBackdrop, MENU_MAIN_RGB, a)

	local accent = (CGV.Theme and CGV.Theme.AccentTable and CGV.Theme.AccentTable()) or {HTMLColor("#F55D07ff")}
	if frame.headerAccent and frame.headerAccent.SetBackdropColor then
		frame.headerAccent:SetBackdropColor(accent[1], accent[2], accent[3], a)
		if frame.headerAccent.SetBackdropEdgeColor then
			frame.headerAccent:SetBackdropEdgeColor(0, 0, 0, 0)
		end
	end

	-- Nested Home / Settings scroll tracks + search
	local gm = GuideMenu.Frame
	if gm then
		SetChromeColor(gm.guideBoxScrollBack, MENU_SCROLL_RGB, a)
		SetChromeColor(gm.searchBox, MENU_SEARCH_RGB, a)
	end
	local sm = Settings.Frame
	if sm then
		SetChromeColor(sm.optionTypesScrollBack, MENU_SCROLL_RGB, a)
	end
end

-- Re-paint whole Home/Settings chrome after alt-tab / resize (backdrops can go blank).
function Menu:RefreshChrome()
	if not self.Frame or self.Frame:IsHidden() then return end
	-- Nested Invis/SecFrames default to SetClampedToScreen — after alt-tab ESO can shove
	-- them past the Home frame. Re-pin size + Settings anchors before redrawing.
	if self.Frame.SetDimensions then
		self.Frame:SetDimensions(DEFAULT_WIDTH, DEFAULT_HEIGHT)
	end
	if self.Frame.mainBackdrop and self.Frame.mainBackdrop.SetClampedToScreen then
		self.Frame.mainBackdrop:SetClampedToScreen(false)
	end
	if Settings.LayoutChrome then
		Settings:LayoutChrome()
	end
	self:SetBackdropOpacity()
	if GuideMenu.Frame and not GuideMenu.Frame:IsHidden() and GuideMenu.RefreshUI then
		GuideMenu:RefreshUI()
	end
	if Settings.Frame and not Settings.Frame:IsHidden() and Settings.RefreshUI then
		Settings:RefreshUI()
	end
end

function Menu:RegisterChromeRedraw()
	if self._chromeRedrawRegistered then return end
	self._chromeRedrawRegistered = true

	local EM = _G.EVENT_MANAGER
	if not EM then return end

	local function redrawSoon()
		if not Menu.Frame or Menu.Frame:IsHidden() then return end
		Menu:RefreshChrome()
		-- One deferred pass — textures sometimes aren't ready on the focus frame.
		if _G.zo_callLater then
			_G.zo_callLater(function()
				Menu:RefreshChrome()
			end, 50)
		end
	end

	local focusEv = _G.EVENT_GAME_FOCUS_CHANGED
	if type(focusEv) == "number" then
		EM:RegisterForEvent("CGESO_MenuChromeFocus", focusEv, function(_, hasFocus)
			if hasFocus then
				redrawSoon()
			end
		end)
	end

	local resizeEv = _G.EVENT_SCREEN_RESIZED
	if type(resizeEv) == "number" then
		EM:RegisterForEvent("CGESO_MenuChromeResize", resizeEv, function()
			redrawSoon()
		end)
	end
end

-----------------------------------------
-- GUIDEMENU UI FUNCTIONS
-----------------------------------------

function GuideMenu:Create()
	if not Menu.Frame then
		Menu:CreateBaseMenu()
	end
	if self.Frame then return end
	local guideMenuName = name.. "_GuideMenu"

	local HEADER_PADDING = 5

	local frame = CHAIN(ui:Create("InvisFrame", Menu.Frame.mainBackdrop,guideMenuName))
		:SetAllPoints()
		:Hide()
		.__END

	self.Frame = frame

	frame.guideBox = CHAIN(ui:Create("InvisFrame", frame, guideMenuName.. "_GuideBox"))
		:SetPoint(TOPLEFT) :SetPoint(BOTTOMLEFT)
		:SetWidth(LEFT_COLUMN_WIDTH)
		.__END

	frame.guideBoxScroll = CHAIN(wm:CreateControl(name.."_Slider",frame,_G.CT_SLIDER))
		:SetMouseEnabled(true)
		:SetThumbTexture(_G.tex,_G.tex,_G.tex,SCROLL_WIDTH,50,0,0,1,1)
		:SetThumbFlushWithExtents(true)
		:SetValue(0)
		:SetValueStep(1)
		:SetWidth(SCROLL_WIDTH)
		:SetAnchor(TOPLEFT,frame.guideBox,TOPRIGHT)
		:SetAnchor(BOTTOMLEFT,frame.guideBox,BOTTOMRIGHT)
		:SetOrientation(_G.ORIENTATION_VERTICAL)
		:SetHandler("OnValueChanged",function(self,value)
				GuideMenu.offset = value
				GuideMenu:RefreshUI()
			end)
		.__END

	frame.guideBoxScrollBack = CHAIN(ui:Create("SecFrame", frame, guideMenuName.. "_ScrollBack"))
		:SetPoint(TOPLEFT,frame.guideBoxScroll,TOPLEFT)
		:SetPoint(BOTTOMRIGHT,frame.guideBoxScroll,BOTTOMRIGHT)
		:SetBackdropColor(.4,.4,.4,1)
		.__END

	frame.guideInfoBox = CHAIN(ui:Create("InvisFrame", frame, guideMenuName.. "_GuideInfoBox"))
		:SetPoint(TOPLEFT,frame.guideBoxScroll,TOPRIGHT)
		:SetPoint(BOTTOMRIGHT)
		:SetWidth(LEFT_COLUMN_WIDTH)
		.__END

	-- Keep header + search + list entirely inside guideBox so height math is self-contained.
	frame.header = CHAIN(ui:Create("Label",frame.guideBox,guideMenuName.."_Header",15,"bold"))
		:SetPoint(TOPLEFT,frame.guideBox,TOPLEFT,HEADER_PADDING,6)
		:SetPoint(TOPRIGHT,frame.guideBox,TOPRIGHT,-2,6)
		:SetText (CGV.Utils.faction_names_short[CGV.Utils.GetFaction()]:upper() .. (CGV.VETERAN_FACTION and " VETERAN" or "") .. " LEVELING")
		.__END

	-- Zone / guide / quest search (session-only filter)
	local searchPlaceholder = (CGV.O and CGV.O["opt_guide_search_placeholder"]) or "Search zone, guide, or quest..."
	frame.searchLabel = CHAIN(ui:Create("Label",frame.guideBox,guideMenuName.."_SearchHint",11))
		:SetText(searchPlaceholder)
		.__END

	frame.searchBox = CHAIN(ui:Create("EditBox",frame.guideBox,guideMenuName.."_Search"))
		:ClearAnchors()
		:SetPoint(TOPLEFT,frame.header,BOTTOMLEFT,-HEADER_PADDING,4)
		:SetPoint(TOPRIGHT,frame.header,BOTTOMRIGHT,HEADER_PADDING,4)
		:SetHeight(22)
		:SetMaxInputChars(64)
		:SetText("")
		:SetHandler("OnTextChanged",function(me)
				GuideMenu.searchtext = me:GetText() or ""
				GuideMenu.offset = 0
				if frame.guideBoxScroll then
					frame.guideBoxScroll:SetValue(0)
				end
				frame.searchLabel:SetHidden(GuideMenu.searchtext ~= "")
				GuideMenu:RefreshUI()
			end)
		:SetHandler("OnFocusGained",function()
				frame.searchLabel:SetHidden(true)
			end)
		:SetHandler("OnFocusLost",function(me)
				frame.searchLabel:SetHidden((me:GetText() or "") ~= "")
			end)
		.__END

	CHAIN(frame.searchLabel)
		:SetPoint(LEFT,frame.searchBox,LEFT,4,0)
		:SetMouseEnabled(false)

	-- Opaque-zero SecFrame + clipsChildren: leftover rows are also Hide()'d from measured height.
	frame.guideListHost = CHAIN(ui:Create("SecFrame",frame.guideBox,guideMenuName.."_ListHost"))
		:ClearAnchors()
		:SetPoint(TOPLEFT,frame.searchBox,BOTTOMLEFT,0,4)
		:SetPoint(BOTTOMRIGHT,frame.guideBox,BOTTOMRIGHT,0,0)
		:SetBackdropColor(0,0,0,0)
		:SetBackdropEdgeColor(0,0,0,0)
		.__END
	if frame.guideListHost.SetClipsChildren then
		frame.guideListHost:SetClipsChildren(true)
	end

	-- Scroll bar tracks the list host only (not header/search).
	CHAIN(frame.guideBoxScroll)
		:ClearAnchors()
		:SetAnchor(TOPLEFT,frame.guideListHost,TOPRIGHT,0,0)
		:SetAnchor(BOTTOMLEFT,frame.guideListHost,BOTTOMRIGHT,0,0)

	------------------------------
	-- Setup Left column buttons (pool; visible count from host height)
	-----------------------------
	frame.buttons = {}
	self.maxLines = GUIDE_MENU_FALLBACK_LINES
	local ROWHEIGHT = GUIDE_LIST_ROW_HEIGHT
	for i = 1, GUIDE_MENU_BUTTON_POOL do
		local buttonName = guideMenuName.."_But"..i

		local button = CHAIN(ui:Create("SecButton",frame.guideListHost,buttonName))
			:SetHeight(ROWHEIGHT)
			:EnableMouseButton(RIGHT_MOUSE_BUTTON, true)
			:SetHandler("OnMouseEnter",function(me)
					me.highlight:Show()
				end)
			:SetHandler("OnMouseExit",function(me)
					me.highlight:Hide()
				end)
			:SetHandler("OnClicked",function(me,button) GuideMenu:MenuButton_OnClick(me,button) end)
			:SetHandler("OnMouseDoubleClick",function(me)
					if me.target.type == "folder" then
					else
						GuideMenu:SetCurrentGuide(me.target)
					end
				end)
			:Hide()
			.__END

		button.highlight = CHAIN(ui:Create("Texture",button,buttonName.."_Highlight"))
			:SetColor(unpack(BUTTON_HIGHLIGHT_TEXTURE))
			:SetPoint(button)
			:Hide()
			.__END

		if i == 1 then
			CHAIN(button)
			:ClearAnchors()
			:SetPoint(TOPLEFT,frame.guideListHost,TOPLEFT,0,0)
			:SetPoint(TOPRIGHT,frame.guideListHost,TOPRIGHT,0,0)
		else
			local previousButton = frame.buttons[i-1]
			CHAIN(button)
			:ClearAnchors()
			:SetPoint(TOPLEFT,previousButton,BOTTOMLEFT)
			:SetPoint(TOPRIGHT,previousButton,BOTTOMRIGHT)
		end

		button.icon = CHAIN(ui:Create("Texture",button,buttonName.."_Icon"))
			:SetPoint(LEFT,button,LEFT,10,0)
			:SetSize(17,17)
			:SetTexture(CGV.DIR.."/Viewer/Skins/Stealth/guideicons-small.dds")
			.__END

		button.label = CHAIN(ui:Create("Label",button,buttonName.."_Label",13))
			:SetPoint(LEFT,button.icon,RIGHT,5,0)
			:SetPoint(RIGHT)
			:SetText("No label?!!?")
			.__END

		button.SetIcon = SetIcon
		frame.buttons[i] = button
	end

	frame.guideListHost:SetHandler("OnEffectivelyShown",function()
			GuideMenu:RefreshUI()
		end)

	------------------------------
	-- Setup Right information panel
	-----------------------------
	-- Centered column (GUIDE_IMAGE_*); welcome stacks mid-panel, selected guides top+scroll.
	local DETAIL_IMAGE_HEIGHT = GUIDE_IMAGE_HEIGHT
	local getControl = _G.GetControl

	frame.rightStack = CHAIN(ui:Create("InvisFrame",frame.guideInfoBox,guideMenuName.."_RightStack"))
		:SetWidth(GUIDE_IMAGE_WIDTH)
		:SetResizeToFitDescendents(true)
		:SetMouseEnabled(false)
		:SetPoint(CENTER,frame.guideInfoBox,CENTER)
		.__END

	frame.GuideTitle = CHAIN(ui:Create("Label",frame.rightStack,guideMenuName.."_GuideTitle",17,"bold"))
		:SetPoint(TOPLEFT,frame.rightStack,TOPLEFT,0,0)
		:SetWidth(GUIDE_IMAGE_WIDTH-20)
		.__END

	-- Action buttons under the title
	frame.SuggestButton = CHAIN(ui:Create("Button",frame.rightStack,guideMenuName.."_SuggestButton"))
		:SetPoint(TOPLEFT,frame.GuideTitle,BOTTOMLEFT,0,8)
		:SetSize(100,20)
		:SetText("Load Suggested")
		:SetFontSize(13)
		:SetAccentStyle(true)
		:SetHandler("OnClicked",function()
				local best = CGV:GetBestSuggestedGuide()
				if best then
					CGV:PromptGuideStyleOrLoad(best, function(guide)
						GuideMenu:SelectGuide(guide)
						GuideMenu:SetCurrentGuide(guide)
					end)
				else
					CGV:Print((CGV.O and CGV.O["opt_guide_no_suggested"]) or "No suggested guide for your zone right now.")
				end
			end)
		.__END

	frame.FavButton = CHAIN(ui:Create("Button",frame.rightStack,guideMenuName.."_FavButton"))
		:SetPoint(LEFT,frame.SuggestButton,RIGHT,8,0)
		:SetSize(70,20)
		:SetText("Favorite")
		:SetFontSize(13)
		:SetAccentStyle(true)
		:SetHandler("OnClicked",function()
				if GuideMenu.selectedguide then
					CGV:ToggleFavoriteGuide(GuideMenu.selectedguide)
					GuideMenu:RefreshUI()
				end
			end)
		:Hide()
		.__END

	frame.OkButton = CHAIN(ui:Create("Button",frame.rightStack,guideMenuName.."_OkButton"))
		:SetPoint(LEFT,frame.FavButton,RIGHT,8,0)
		:SetSize(80,20)
		:SetText("Start Guide")
		:SetFontSize(14)
		:SetAccentStyle(true)
		:SetHandler("OnClicked",function()
				GuideMenu:SetCurrentGuide(GuideMenu.selectedguide)
			end)
		.__END

	local ac = (CGV.Theme and CGV.Theme.AccentCode()) or "F55D07"
	local str = ("|c%sNote:|r If you change to another guide before completing an active guide, you may lose your progress in the current guide. We |c%sdo not recommend|r changing guides until you complete the current."):format(ac, ac)
	CGV.Viewer:add_tooltip(frame.OkButton,str)

	-- Short meta line (levels / next) sits above the image
	frame.GuideMeta = CHAIN(ui:Create("Label",frame.rightStack,guideMenuName.."_GuideMeta",13))
		:SetPoint(TOPLEFT,frame.SuggestButton,BOTTOMLEFT,0,8)
		:SetWidth(GUIDE_IMAGE_WIDTH)
		:SetVerticalAlignment(_G.TEXT_ALIGN_TOP)
		:SetCanWrap(true)
		.__END

	frame.GuideImage = CHAIN(ui:Create("Texture",frame.rightStack,guideMenuName.."_GuideTexture"))
		:SetPoint(TOPLEFT,frame.GuideMeta,BOTTOMLEFT,0,8)
		:SetSize(GUIDE_IMAGE_WIDTH,DETAIL_IMAGE_HEIGHT)
		:SetTexture(WELCOME_GUIDE_IMAGE)
		:SetColor(1,1,1,1)
		:Hide()
		.__END

	-- Credits / description under the banner (inside centered stack for welcome)
	frame.GuideData = CHAIN(ui:Create("Label",frame.rightStack,guideMenuName.."_GuideData",14))
		:SetPoint(TOPLEFT,frame.GuideImage,BOTTOMLEFT,0,8)
		:SetWidth(GUIDE_IMAGE_WIDTH)
		:SetVerticalAlignment(_G.TEXT_ALIGN_TOP)
		:SetCanWrap(true)
		.__END

	-- Scrollable description for selected guides (fills below the centered column)
	frame.guideDataScroll = CHAIN(wm:CreateControlFromVirtual(guideMenuName.."_GuideDataScroll",frame.guideInfoBox,"ZO_ScrollContainer"))
		:SetHidden(true)
		.__END

	frame.guideDataScrollChild = CHAIN(getControl(frame.guideDataScroll:GetName().."ScrollChild"))
		:ClearAnchors()
		:SetAnchor(TOPLEFT,frame.guideDataScroll)
		:SetAnchor(TOPRIGHT,frame.guideDataScroll)
		.__END

	frame.GuideDataScrollLabel = CHAIN(ui:Create("Label",frame.guideDataScrollChild,guideMenuName.."_GuideDataScrollLabel",14))
		:SetPoint(TOPLEFT,frame.guideDataScrollChild,TOPLEFT,0,0)
		:SetPoint(TOPRIGHT,frame.guideDataScrollChild,TOPRIGHT,0,0)
		:SetVerticalAlignment(_G.TEXT_ALIGN_TOP)
		:SetCanWrap(true)
		.__END

	frame._detailImageHeight = DETAIL_IMAGE_HEIGHT

	Menu:SetBackdropOpacity()
end

-- Center the right column in guideInfoBox (welcome = mid panel; selected = top, H-centered).
function GuideMenu:LayoutRightColumn(mode)
	local frame = self.Frame
	if not (frame and frame.rightStack and frame.guideInfoBox) then return end

	local stack = frame.rightStack
	local box = frame.guideInfoBox
	CHAIN(stack)
		:SetWidth(GUIDE_IMAGE_WIDTH)
		:ClearAnchors()

	if mode == "welcome" then
		stack:SetPoint(CENTER, box, CENTER)
	else
		stack:SetPoint(TOP, box, TOP, 0, 12)
	end
end

-- How many list rows fit inside guideListHost without drawing past the Home frame.
-- Uses measured host height so the list fills the taller Home window.
function GuideMenu:GetVisibleListLines()
	local frame = self.Frame
	if not frame or not frame.guideListHost or not frame.buttons then
		return GUIDE_MENU_FALLBACK_LINES
	end

	local hostH = frame.guideListHost:GetHeight() or 0
	if hostH < GUIDE_LIST_ROW_HEIGHT then
		-- Frame may not be laid out yet; use chrome-subtracted fallback.
		hostH = DEFAULT_HEIGHT - HEADER_HEIGHT - FOOTER_HEIGHT - 80
	end

	local n = math.floor(hostH / GUIDE_LIST_ROW_HEIGHT)
	if n < 1 then n = 1 end
	if n > #frame.buttons then n = #frame.buttons end
	if (n * GUIDE_LIST_ROW_HEIGHT) > hostH then
		n = n - 1
		if n < 1 then n = 1 end
	end
	return n
end

-- Trim + lowercase search box text (shared by RefreshUI and kind tags).
function GuideMenu:GetSearchNeedle()
	return (self.searchtext or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
end

-- Short list tag + full detail label. Disambiguates same zone names (Full / MQO / Shards).
function GuideMenu:GetGuideKindInfo(guide)
	if not guide or guide.type == "folder" then return nil end
	local title = guide.title or ""
	local O = CGV.O
	if title:find("Main Quests Only", 1, true) then
		return {
			tag = (O and O["opt_guide_kind_mqo_tag"]) or "MQO",
			full = (O and O["opt_guide_kind_mqo"]) or "Main Quests Only",
		}
	end
	if title:find("Skyshards", 1, true) then
		return {
			tag = (O and O["opt_guide_kind_skyshards_tag"]) or "Shards",
			full = (O and O["opt_guide_kind_skyshards"]) or "Skyshards & Delves",
		}
	end
	-- Sanitized titles look like LEVELING/Auridon (faction prefix stripped).
	if title:match("^LEVELING/") or title:find("Leveling Guides", 1, true) then
		return {
			tag = (O and O["opt_guide_kind_leveling_tag"]) or "Full",
			full = (O and O["opt_guide_kind_leveling"]) or "Leveling",
		}
	end
	return nil
end

-- Kind tags only in mixed flat lists (search / favorites / suggested).
function GuideMenu:ShouldShowGuideKind()
	return self:GetSearchNeedle() ~= ""
		or self.folder == FOLDER_FAVORITES
		or self.folder == FOLDER_SUGGESTED
end

function GuideMenu:GetGuideRowLabel(guide, statuscolor)
	local name = guide.title_short or ""
	if guide.type == "folder" then
		return "|c"..(statuscolor or "ffffff")..name
	end
	if CGV:IsFavoriteGuide(guide) then
		name = "★ "..name
	end
	-- Kind first so row ellipsis still shows [MQO]/[Full]/[Shards].
	if self:ShouldShowGuideKind() then
		local info = self:GetGuideKindInfo(guide)
		if info then
			name = "|cffaaaa["..info.tag.."]|r "..name
		end
	end
	-- Progress % on Favorites / Suggested / search rows (cheap when already parsed).
	if self:ShouldShowGuideKind() and guide.GetCompletionText
		and (CGV.db and CGV.db.profile and CGV.db.profile.home_progress ~= false) then
		local pct = guide:GetCompletionText("steps")
		if pct and pct ~= "..." and pct ~= "?" and pct ~= "-" then
			name = name.." |cffaaaa"..pct.."|r"
		end
	end
	return "|c"..(statuscolor or "ffffff")..name
end

function GuideMenu:RefreshUI()
	if not self.Frame then
		self:Create()
	end

	local frame = self.Frame
	local buts = frame.buttons

	local folders = {}
	local guides = {}

	if not self.folder then
		self.folder = ""
	end

	local needle = self:GetSearchNeedle()

	if needle ~= "" then
		-- Title / description / quest names (|q, accept, turnin)
		for _, guide in ipairs(CGV.registeredguides) do
			if guide and guide:MatchesSearch(needle) then
				table.insert(guides, guide)
			end
		end
		frame.header:SetText((CGV.O and CGV.O["opt_guide_search_results"]) or "Search results")
	elseif self.folder == FOLDER_FAVORITES then
		table.insert(folders,{type="folder",title="",title_short="( up )"})
		for _,guide in ipairs(CGV:GetFavoriteGuides()) do
			table.insert(guides, guide)
		end
		frame.header:SetText((CGV.O and CGV.O["opt_guide_favorites"]) or "Favorites")
	elseif self.folder == FOLDER_SUGGESTED then
		table.insert(folders,{type="folder",title="",title_short="( up )"})
		for _,guide in ipairs(CGV:GetSuggestedGuideList()) do
			table.insert(guides, guide)
		end
		frame.header:SetText((CGV.O and CGV.O["opt_guide_suggested"]) or "Suggested")
	else
		if self.folder then
			if #self.folder > 0 then
				local parentfolder = self.folder:match("(.+)/[^/]+")
				table.insert(folders,{type="folder",title=parentfolder,title_short="( up )"})
			end
			-- Pin Favorites / Suggested at the root of the guide browser
			if self.folder == "" then
				table.insert(folders,{type="folder",title=FOLDER_FAVORITES,title_short=(CGV.O and CGV.O["opt_guide_favorites"]) or "★ Favorites"})
				table.insert(folders,{type="folder",title=FOLDER_SUGGESTED,title_short=(CGV.O and CGV.O["opt_guide_suggested"]) or "Suggested"})
			end
			local topfolders_seen = {}
			local folderslash = self.folder == "" and "" or self.folder.."/"
			for _,guide in ipairs(CGV.registeredguides) do
				local wholefolder,topfolder = guide.title:match("LEVELING/("..folderslash.."([^/]+))/.+")
				if not topfolder then
					wholefolder,topfolder = guide.title:match("Extras/("..folderslash.."([^/]+))/.+")
				end
				if topfolder and not topfolders_seen[topfolder] then
					topfolders_seen[topfolder] = true
					table.insert(folders,{type="folder",title=wholefolder,title_short=topfolder})
				end
			end

			for _,guide in ipairs(CGV.registeredguides) do
				if guide.title:match("^LEVELING/"..folderslash.."[^/]+$")
					or guide.title:match("^Extras/"..folderslash.."[^/]+$") then
					table.insert(guides,guide)
				end
			end
		end

		frame.header:SetText(self.folder == "" and "All Guides" or self.folder or "Leveling Guides")
	end

	-- Zone name first, then full path (keeps Full / MQO / Shards for the same zone together).
	table.sort(guides, function(a, b)
			local as, bs = a.title_short or "", b.title_short or ""
			if as ~= bs then return as < bs end
			return (a.title or "") < (b.title or "")
		end)

	for i,f in ipairs(folders) do
		table.insert(guides,i,f)
	end

	local zo_min, zo_max = _G.zo_min, _G.zo_max
	local maxLines = self:GetVisibleListLines()
	self.maxLines = maxLines
	self.offset = self.offset and zo_min(#guides,zo_max(0,self.offset)) or 0

	frame.guideBoxScroll:SetMinMax(0, zo_max(0, #guides - maxLines))

	local hei = zo_min(1, maxLines / math.max(#guides, 1))  if hei==1 then
		hei = 0
	end
	local tex = _G.tex
	frame.guideBoxScroll:SetThumbTexture(tex,tex,tex,SCROLL_WIDTH,frame.guideBoxScroll:GetHeight() * hei,0,0,1,1)

	-------------------------------
	-- UPDATE THE BUTTONS (hide any row past measured fit)
	-------------------------------

	for i,button in ipairs(buts) do
		if i > maxLines then
			button:Hide()
		else
			local guide = guides[i+self.offset]

			if guide then
				button.target = guide

				local status = guide.GetStatus and guide:GetStatus() or ""

				if guide.type=="folder" then
					button:SetIcon(1,1,2,2)
				else
					button:SetIcon(2,1,2,2)
				end

				button.icon:Show()

				local statuscolor = GuideStatusColor[status] or "ffffff"
				if self.selectedguide and self.selectedguide==guide then
					local muted = (CGV.Theme and CGV.Theme.AccentMutedTable()) or {245/255,93/255,7/255,0.9}
					button:SetBackdropColor(unpack(muted))
					button.bd:Show()

					statuscolor = "ffffff"
				else
					button.bd:Hide()
				end

				local label = self:GetGuideRowLabel(guide, statuscolor)
				button.label:SetText(label..(guide.parse_error and "-|cff0000ERROR|r" or ""))
				button:Show()
			else
				button:Hide()
			end
		end
	end

	-------------------------------
	-- DISPLAY THE GUIDE
	-------------------------------

	if self.selectedguide then

		local g = self.selectedguide

		local detailTitle = (CGV:IsFavoriteGuide(g) and "★ " or "")..(g.title_short or "")
		local kindInfo = self:GetGuideKindInfo(g)
		if kindInfo then
			detailTitle = detailTitle.." |cffaaaa("..kindInfo.full..")|r"
		end
		frame.GuideTitle:SetText(detailTitle)

		local meta = ""
		if g.next then
			meta = meta .. "|cffeebbNext guide:|r ".. g.next:match(".+/(.-)$") .."\n"
		end
		if frame.GuideMeta then
			frame.GuideMeta:SetText(meta)
			if meta == "" then
				CHAIN(frame.GuideMeta):SetHeight(0):SetHidden(true)
			else
				CHAIN(frame.GuideMeta):SetWidth(GUIDE_IMAGE_WIDTH):SetCanWrap(true):SetHidden(false)
			end
		end

		-- Description scrolls under the centered column
		local desc = g.description or g.desc or ""
		if frame.GuideData then
			CHAIN(frame.GuideData):SetText(""):SetHeight(0):SetHidden(true)
		end
		if frame.GuideDataScrollLabel then
			frame.GuideDataScrollLabel:SetText(desc)
			frame.GuideDataScrollLabel:SetCanWrap(true)
		end

		frame.OkButton:Show()
		if frame.FavButton then
			frame.FavButton:SetText(CGV:IsFavoriteGuide(g) and "Unfavorite" or "Favorite")
			frame.FavButton:Show()
		end
		if frame.SuggestButton then frame.SuggestButton:Show() end

		local imgH = frame._detailImageHeight or GUIDE_IMAGE_HEIGHT
		local aboveImage = (meta ~= "" and frame.GuideMeta) or frame.SuggestButton
		if g.image then
			CHAIN(frame.GuideImage)
			:ClearAnchors()
			:SetPoint(TOPLEFT,aboveImage,BOTTOMLEFT,0,8)
			:SetSize(GUIDE_IMAGE_WIDTH,imgH)
			:SetTexture(g.image)
			:SetHeight(imgH)
			:Show()
		else
			CHAIN(frame.GuideImage)
			:ClearAnchors()
			:SetPoint(TOPLEFT,aboveImage,BOTTOMLEFT,0,0)
			:SetHeight(0)
			:Hide()
		end

		self:LayoutRightColumn("selected")

		if frame.guideDataScroll then
			-- ESO allows only two anchors; pin under the banner column and to panel bottom.
			local scrollTop = (g.image and frame.GuideImage) or aboveImage
			local halfW = GUIDE_IMAGE_WIDTH / 2
			CHAIN(frame.guideDataScroll)
				:ClearAnchors()
				:SetAnchor(TOPLEFT,scrollTop,BOTTOMLEFT,0,8)
				:SetAnchor(BOTTOMRIGHT,frame.guideInfoBox,BOTTOM,halfW,-8)
				:SetHidden(false)
		end

		if g.parse_error then
			CGV:Print(g.parse_error)
		end
	else
		frame.GuideTitle:SetText("Welcome to the Community Leveling Guides for ESO")
		if frame.GuideMeta then
			CHAIN(frame.GuideMeta):SetText(""):SetHeight(0):SetHidden(true)
		end
		local credits = "Imperial City, Craglorn, Southern Elsweyr, Western Skyrim, The Reach, Blackwood, Fargrave, The Deadlands, High Isle and Amenos, Galan and Y'ffelon, Apocrypha, Telvanni Peninsula, West Weald, Solstice, Sheogorath guides authored by |cffaa00snichols7778|r\nSummerset, Murkmire and Elsweyr guides authored by |cffaa00Hydra9268|r\nAdditional support by |cffaa00Sharlikran|r, |cffaa00Krandor1|r\n|c999999Original guide and Addon created by Zygor Guides|r"
		local welcomeImgH = frame._detailImageHeight or GUIDE_IMAGE_HEIGHT
		CHAIN(frame.GuideImage)
			:ClearAnchors()
			:SetPoint(TOPLEFT,frame.SuggestButton,BOTTOMLEFT,0,10)
			:SetSize(GUIDE_IMAGE_WIDTH,welcomeImgH)
			:SetWidth(GUIDE_IMAGE_WIDTH)
			:SetHeight(welcomeImgH)
			:SetTexture(WELCOME_GUIDE_IMAGE)
			:SetColor(1,1,1,1)
			:SetHidden(false)
			:Show()
		-- Credits live in the centered stack (not a full-height scroll), so H+V center works.
		if frame.GuideData then
			CHAIN(frame.GuideData)
				:ClearAnchors()
				:SetPoint(TOPLEFT,frame.GuideImage,BOTTOMLEFT,0,8)
				:SetWidth(GUIDE_IMAGE_WIDTH)
				:SetText(credits)
				:SetCanWrap(true)
				:SetHidden(false)
		end
		if frame.guideDataScroll then
			frame.guideDataScroll:SetHidden(true)
		end
		frame.OkButton:Hide()
		if frame.FavButton then frame.FavButton:Hide() end
		if frame.SuggestButton then frame.SuggestButton:Show() end

		self:LayoutRightColumn("welcome")
	end

	frame:Show()
end

-----------------------------------------
-- SETTINGS UI FUNCTIONS
-----------------------------------------

function Settings:Create()
	if not Menu.Frame then
		Menu:CreateBaseMenu()
	end
	if self.Frame then return end
	local setname = name.. "_SettingsMenu"

	local HEADER_PADDING = 5

	local frame = CHAIN(ui:Create("InvisFrame", Menu.Frame.mainBackdrop,setname))
		:SetAllPoints()
		:Hide()
		.__END
	if frame.SetClampedToScreen then
		frame:SetClampedToScreen(false)
	end
	if frame.SetClipsChildren then
		frame:SetClipsChildren(true)
	end

	self.Frame = frame

	frame.optionTypesBox = CHAIN(ui:Create("InvisFrame", frame, setname.. "_OptionsBox"))
		:SetPoint(TOPLEFT)
		:SetPoint(BOTTOMLEFT)
		:SetWidth(LEFT_COLUMN_WIDTH)
		.__END
	if frame.optionTypesBox.SetClampedToScreen then
		frame.optionTypesBox:SetClampedToScreen(false)
	end

	-- Real vertical scrollbar for the category list (same pattern as Guide Home).
	frame.optionTypesScroll = CHAIN(wm:CreateControl(setname.."_Slider",frame,_G.CT_SLIDER))
		:SetMouseEnabled(true)
		:SetThumbTexture(_G.tex,_G.tex,_G.tex,SCROLL_WIDTH,50,0,0,1,1)
		:SetThumbFlushWithExtents(true)
		:SetValue(0)
		:SetValueStep(1)
		:SetWidth(SCROLL_WIDTH)
		:SetOrientation(_G.ORIENTATION_VERTICAL)
		:SetHandler("OnValueChanged",function(_,value)
				Settings.offset = value
				Settings:RefreshUI()
			end)
		.__END

	frame.optionTypesScrollBack = CHAIN(ui:Create("SecFrame", frame, setname.. "_ScrollBack"))
		:SetPoint(TOPLEFT,frame.optionTypesScroll,TOPLEFT)
		:SetPoint(BOTTOMRIGHT,frame.optionTypesScroll,BOTTOMRIGHT)
		:SetBackdropColor(.4,.4,.4,1)
		.__END
	if frame.optionTypesScrollBack.SetClampedToScreen then
		frame.optionTypesScrollBack:SetClampedToScreen(false)
	end

	-- Right pane: pin to Settings frame edges only (no SetWidth fight; clip so content can't paint under HUD).
	frame.optionsBox = CHAIN(ui:Create("InvisFrame", frame, setname.. "_GuideInfoBox"))
		:ClearAnchors()
		:SetPoint(TOPLEFT,frame.optionTypesScroll,TOPRIGHT,0,0)
		:SetPoint(BOTTOMRIGHT,frame,BOTTOMRIGHT,0,0)
		.__END
	if frame.optionsBox.SetClampedToScreen then
		frame.optionsBox:SetClampedToScreen(false)
	end
	if frame.optionsBox.SetClipsChildren then
		frame.optionsBox:SetClipsChildren(true)
	end
	-- Alias: older copy-paste used guideInfoBox; never leave it nil (nil → GuiRoot anchors break on alt-tab).
	frame.guideInfoBox = frame.optionsBox

	-- Header lives inside the left column so list height math stays self-contained.
	frame.header = CHAIN(ui:Create("Label",frame.optionTypesBox,setname.."_Header",0,"bold"))
		:SetPoint(TOPLEFT,frame.optionTypesBox,TOPLEFT,HEADER_PADDING,2)
		:SetPoint(TOPRIGHT,frame.optionTypesBox,TOPRIGHT,-2,2)
		:SetText("")
		.__END

	frame.optionListHost = CHAIN(ui:Create("SecFrame",frame.optionTypesBox,setname.."_ListHost"))
		:ClearAnchors()
		:SetPoint(TOPLEFT,frame.header,BOTTOMLEFT,-HEADER_PADDING,4)
		:SetPoint(BOTTOMRIGHT,frame.optionTypesBox,BOTTOMRIGHT,0,0)
		:SetBackdropColor(0,0,0,0)
		:SetBackdropEdgeColor(0,0,0,0)
		.__END
	if frame.optionListHost.SetClampedToScreen then
		frame.optionListHost:SetClampedToScreen(false)
	end
	if frame.optionListHost.SetClipsChildren then
		frame.optionListHost:SetClipsChildren(true)
	end

	CHAIN(frame.optionTypesScroll)
		:ClearAnchors()
		:SetAnchor(TOPLEFT,frame.optionListHost,TOPRIGHT,0,0)
		:SetAnchor(BOTTOMLEFT,frame.optionListHost,BOTTOMRIGHT,0,0)

	------------------------------
	-- Setup Left column buttons (pool; visible count from host height)
	-----------------------------

	frame.buttons={}
	self.maxLines = SETTINGS_FALLBACK_LINES
	self.offset = 0
	local ROWHEIGHT = SETTINGS_LIST_ROW_HEIGHT
	for i = 1, SETTINGS_BUTTON_POOL do
		local buttonName = setname.."_But"..i

		local button = CHAIN(ui:Create("SecButton",frame.optionListHost,buttonName))
			:SetHeight(ROWHEIGHT)
			:SetHandler("OnMouseEnter",function(me)
					me.highlight:Show()
				end)
			:SetHandler("OnMouseExit",function(me)
					me.highlight:Hide()
				end)
			:SetHandler("OnClicked",function(me,button) Settings:MenuButton_OnClick(me,button)
				end)
			:Hide()
			.__END

		-- Texture for when the button is hovered over.
		button.highlight = CHAIN(ui:Create("Texture",button,buttonName.."_Highlight"))
			:SetColor(unpack(BUTTON_HIGHLIGHT_TEXTURE))
			:SetPoint(button)
			:Hide()
			.__END

		if i == 1 then
			CHAIN(button)
			:ClearAnchors()
			:SetPoint(TOPLEFT,frame.optionListHost,TOPLEFT,0,0)
			:SetPoint(TOPRIGHT,frame.optionListHost,TOPRIGHT,0,0)
		else
			local previousButton = frame.buttons[i-1]
			CHAIN(button)
			:ClearAnchors()
			:SetPoint(TOPLEFT,previousButton,BOTTOMLEFT)
			:SetPoint(TOPRIGHT,previousButton,BOTTOMRIGHT)
		end

		button.icon = CHAIN(ui:Create("Texture",button,buttonName.."_Icon"))
			:SetPoint(LEFT,button,LEFT,10,0)
			:SetSize(17,17)
			:SetTexture(CGV.DIR.."/Viewer/Skins/Stealth/guideicons-small.dds")
			.__END

		button.label = CHAIN(ui:Create("Label",button,buttonName.."_Label",15))
			:SetPoint(LEFT,button.icon,RIGHT,5,0)
			:SetPoint(RIGHT)
			:SetText("No label?!!?")
			.__END

		button.SetIcon = SetIcon
		frame.buttons[i] = button
	end

	------------------------------
	-- Setup Right information panel
	-----------------------------

	-- All right-panel chrome anchors to optionsBox (same Settings frame), never GuiRoot.
	frame.OptionTitle = CHAIN(ui:Create("Label",frame.optionsBox,setname.."_GroupTitle",17))
		:SetPoint(TOPLEFT,frame.optionsBox,TOPLEFT,HEADER_PADDING,2)
		:SetPoint(TOPRIGHT,frame.optionsBox,TOPRIGHT,-HEADER_PADDING,0)
		:SetText("Options")
		.__END

	frame.OptionDesc = CHAIN(ui:Create("Label",frame.optionsBox,setname.."_GroupDesc",12))
		:SetPoint(TOPRIGHT,frame.OptionTitle,TOPRIGHT)
		:SetPoint(TOPLEFT,frame.OptionTitle,BOTTOMLEFT,5,5)
		:SetCanWrap(true)
		:SetText("Desc")
		.__END

	-- Footer buttons stay outside the scroll so tips never cover them.
	local ButtonHortPad = 10
	frame.OkButton = CHAIN(ui:Create("Button",frame.optionsBox,setname.."_OkButton"))
		:SetPoint(BOTTOMRIGHT,frame.optionsBox,BOTTOMRIGHT,-ButtonHortPad,-10)
		:SetText("Accept")
		:SetFontSize(14)
		:SetAccentStyle(true)
		:SetHandler("OnClicked",function()
				Menu:Hide()
			end)
		.__END

	frame.DefaultButton = CHAIN(ui:Create("Button",frame.optionsBox,setname.."_DefaultButton"))
		:SetPoint(BOTTOMLEFT,frame.optionsBox,BOTTOMLEFT,ButtonHortPad,-10)
		:SetText("Default")
		:SetFontSize(14)
		:SetHandler("OnClicked",function()
				Settings:ShowDefaultPopup()
			end)
		.__END

	-- Real scroll viewport: options (incl. tips) stay above Default/Accept and cannot spill past Home.
	frame.OptionsScroll = CHAIN(wm:CreateControlFromVirtual(setname.."_OptionsScroll",frame.optionsBox,"ZO_ScrollContainer"))
		:ClearAnchors()
		:SetAnchor(TOPLEFT,frame.OptionDesc,BOTTOMLEFT,-HEADER_PADDING,0)
		:SetAnchor(BOTTOMRIGHT,frame.OkButton,TOPRIGHT,0,-OPTIONS_BOTTOM_PAD)
		.__END
	if frame.OptionsScroll.SetClampedToScreen then
		frame.OptionsScroll:SetClampedToScreen(false)
	end

	local getControl = _G.GetControl
	frame.OptionsScrollBase = CHAIN(getControl(frame.OptionsScroll:GetName().."ScrollChild"))
		:ClearAnchors()
		:SetAnchor(TOPLEFT,frame.OptionsScroll)
		:SetAnchor(TOPRIGHT,frame.OptionsScroll)
		.__END
	if frame.OptionsScrollBase.SetClampedToScreen then
		frame.OptionsScrollBase:SetClampedToScreen(false)
	end

	-- Keep footer buttons above any option overflow.
	if frame.OkButton.SetDrawTier then
		frame.OkButton:SetDrawTier(_G.DT_HIGH or 2)
		frame.DefaultButton:SetDrawTier(_G.DT_HIGH or 2)
	end

	self:LayoutChrome()
	Menu:SetBackdropOpacity()
end

-- Re-pin Settings chrome inside Home/mainBackdrop (call after create and on focus/resize).
function Settings:LayoutChrome()
	local frame = self.Frame
	local menu = Menu.Frame
	if not (frame and menu and menu.mainBackdrop) then return end

	local function nestSafe(ctrl, clip)
		if not ctrl then return end
		if ctrl.SetClampedToScreen then
			ctrl:SetClampedToScreen(false)
		end
		if clip and ctrl.SetClipsChildren then
			ctrl:SetClipsChildren(true)
		end
	end

	nestSafe(menu.mainBackdrop, true)
	nestSafe(frame, true)
	nestSafe(frame.optionTypesBox, false)
	nestSafe(frame.optionListHost, true)
	nestSafe(frame.optionsBox, true)
	nestSafe(frame.OptionsScroll, false)
	nestSafe(frame.OptionsScrollBase, false)

	CHAIN(frame)
		:ClearAnchors()
		:SetPoint(TOPLEFT,menu.mainBackdrop,TOPLEFT,0,0)
		:SetPoint(BOTTOMRIGHT,menu.mainBackdrop,BOTTOMRIGHT,0,0)

	if frame.optionTypesScroll then
		CHAIN(frame.optionsBox)
			:ClearAnchors()
			:SetPoint(TOPLEFT,frame.optionTypesScroll,TOPRIGHT,0,0)
			:SetPoint(BOTTOMRIGHT,frame,BOTTOMRIGHT,0,0)
	end

	local ButtonHortPad = 10
	local headerPad = 5
	if frame.OkButton then
		CHAIN(frame.OkButton)
			:ClearAnchors()
			:SetPoint(BOTTOMRIGHT,frame.optionsBox,BOTTOMRIGHT,-ButtonHortPad,-10)
	end
	if frame.DefaultButton then
		CHAIN(frame.DefaultButton)
			:ClearAnchors()
			:SetPoint(BOTTOMLEFT,frame.optionsBox,BOTTOMLEFT,ButtonHortPad,-10)
	end

	if frame.OptionsScroll and frame.OptionDesc and frame.OkButton then
		CHAIN(frame.OptionsScroll)
			:ClearAnchors()
			:SetAnchor(TOPLEFT,frame.OptionDesc,BOTTOMLEFT,-headerPad,0)
			:SetAnchor(BOTTOMRIGHT,frame.OkButton,TOPRIGHT,0,-OPTIONS_BOTTOM_PAD)
	end

	if frame.OptionsScrollBase and frame.OptionsScroll then
		CHAIN(frame.OptionsScrollBase)
			:ClearAnchors()
			:SetAnchor(TOPLEFT,frame.OptionsScroll)
			:SetAnchor(TOPRIGHT,frame.OptionsScroll)
	end
end

function Settings:CreateDefaultPopup()
	if self.DefaultPopup then return end

	local popup = CHAIN(CGV.Popup:New("Community_Settings_Reset_Default_Popup"))
		:SetText(L['static_options'])
		:SetDimensionConstraints(375) -- Force minWidth to 375 for the buttons to fit nicely
		.__END

	-- No settings button for settings popup. That would be silly
	popup.settings:Hide()

	-- Need a third button for cancel
	popup.cancelbutton = CHAIN(ui:Create("Button",popup,popup:GetName().."_Cancel"))
		:SetPoint(TOP,popup.text,BOTTOM,0,10) -- 10 is BUT_Y_OFFSET from Popup.lua
		:SetWidth(105)
		:SetText(L['static_cancel'])
		:SetFontSize(CGV.db.profile.fontsize,true)
		:SetHandler("OnClicked",function(me)
				local pop = me:GetParent() -- Just hide the popup
				pop.private:Hide(pop)
			end)
		.__END

	-- Accept button is all Settings to Default
	CHAIN(popup.acceptbutton)
		:ClearAllPoints()
		:SetWidth(105)
		:SetPoint(RIGHT,popup.cancelbutton,LEFT,-5,0)
		:SetText(L['static_allsetting'])

	-- Decline button is these settings to default
	CHAIN(popup.declinebutton)
		:ClearAllPoints()
		:SetWidth(105)
		:SetPoint(LEFT,popup.cancelbutton,RIGHT,5,0)
		:SetText(L['static_thesesetting'])

	popup.OnAccept = function()
		-- All option groups to default!
		for _,opt_groups in ipairs(Settings.opt_groups) do
			opt_groups:SetToDefault()
		end
	end

	popup.OnDecline = function()
		-- Currently shown option group to default!
		Settings.selectedgroup:SetToDefault()
	end

	self.DefaultPopup = popup
end

function Settings:ShowDefaultPopup()
	if not self.DefaultPopup then
		self:CreateDefaultPopup()
	end
	self.DefaultPopup:Show()
end

-- Create the UI for a options group from all the options. Puts the frame with all the options in group.frame
function Settings:CreateOptionsUI(group)
	if group.frame then return end
	local name = "CommunityOptionPanel_Group_"..group.title
	local lastobj, lastfrontobj

	-- Size to content inside ZO_ScrollContainer child (TOPLEFT/TOPRIGHT only — not BOTTOMRIGHT fill).
	local frame = CHAIN(ui:Create("InvisFrame", self.Frame.OptionsScrollBase, name))
		:ClearAnchors()
		:SetPoint(TOPLEFT,self.Frame.OptionsScrollBase,TOPLEFT,0,0)
		:SetPoint(TOPRIGHT,self.Frame.OptionsScrollBase,TOPRIGHT,0,0)
		:SetResizeToFitDescendents(true)
		.__END
	if frame.SetClampedToScreen then
		frame:SetClampedToScreen(false)
	end

	for _,option in ipairs(group.options) do
		local data = option.data
		local typ = data.type

		local obj = self.OptionUI[typ](self,option,frame)	-- This obj is a frame that contains the actual option UI

		if typ ~= "execute"	-- Execute buttons are unnecessary, they run a function on clicked
		and typ ~= "header"	-- headers are dumber
		and typ ~= "desc" -- desc ^^^^
		and typ ~= "buttongroup" -- multi-button rows have no stored value
		then
			assert(obj.SetValue,"All option objects must have a :SetValue method")
			obj:SetValue(option:GetValue())
		end

		option.frame = obj
		obj.option = option

		local frameWidth = frame:GetWidth()

		if not lastfrontobj then
			-- This is the first option so it goes at the top of the frame
			obj:SetPoint(TOPLEFT,frame,TOPLEFT,0,OPTIONS_VERT_OFFSET)
			obj:SetWidth(frameWidth)

			lastfrontobj = obj
		elseif not data.column or data.column == "one" then
			-- First column, just put it on the next row.
			obj:SetPoint(TOPLEFT,lastfrontobj,BOTTOMLEFT,0,OPTIONS_VERT_OFFSET)
			obj:SetWidth(frameWidth)

			lastfrontobj = obj
		elseif data.column == "two" then
			-- The lastobj was the obj at the front of the row. Half it's size.
			local half = frameWidth/2
			lastobj:SetWidth(half)
			obj:SetPoint(TOPLEFT,lastobj,TOPRIGHT)
			obj:SetWidth(half)

		elseif data.column == "three" then
			-- Need to make the first and second column 1/3 the full size.
			local third = frameWidth/3
			lastfrontobj:SetWidth(third)
			lastobj:SetWidth(third)

			obj:SetPoint(TOPLEFT,lastobj,TOPRIGHT)
			obj:SetWidth(third)
		else

			error("Column can only be nil/one/two/three")
		end

		-- Equal-width button rows need final option width before laying out.
		if obj.LayoutContent then
			obj:LayoutContent()
		end

		lastobj = obj
		if obj.SetClampedToScreen then
			obj:SetClampedToScreen(false)
		end

	end

	group.frame = frame
	self:SizeOptionsScrollChild(group)
end

-- Grow ZO_ScrollContainer child to option content so tips scroll above Default/Accept.
function Settings:SizeOptionsScrollChild(group)
	local frame = self.Frame
	if not (frame and frame.OptionsScrollBase) then return end
	local gframe = group and group.frame
	local h = 1
	if gframe then
		if gframe.GetHeight then
			h = gframe:GetHeight() or 1
		end
		-- Fallback: bottom of last visible child
		if (not h or h < 8) and gframe.GetNumChildren then
			local n = gframe:GetNumChildren() or 0
			for i = 1, n do
				local child = gframe:GetChild(i)
				if child and child.GetBottom and gframe.GetTop then
					local bh = (child:GetBottom() or 0) - (gframe:GetTop() or 0)
					if bh > h then h = bh end
				end
			end
		end
	end
	if h < 1 then h = 1 end
	frame.OptionsScrollBase:SetHeight(h + 12)
	-- Reset scroll to top when swapping groups / after focus re-layout.
	if frame.OptionsScroll then
		if frame.OptionsScroll.SetVerticalScroll then
			frame.OptionsScroll:SetVerticalScroll(0)
		elseif _G.ZO_Scroll_SetScrollTop then
			_G.ZO_Scroll_SetScrollTop(frame.OptionsScroll, 0)
		end
	end
end

function Settings:GetVisibleListLines()
	local frame = self.Frame
	local host = frame and frame.optionListHost
	local hostH = host and host:GetHeight() or 0
	if not hostH or hostH < 1 then
		hostH = DEFAULT_HEIGHT - HEADER_HEIGHT - FOOTER_HEIGHT - 40
	end
	local lines = math.floor(hostH / SETTINGS_LIST_ROW_HEIGHT)
	if lines < 1 then lines = SETTINGS_FALLBACK_LINES end
	if lines > SETTINGS_BUTTON_POOL then lines = SETTINGS_BUTTON_POOL end
	return lines
end

function Settings:RefreshUI()
	if not self.Frame then
		self:Create()
	end
	self:LayoutChrome()
	local frame = self.Frame
	local buts = frame.buttons

	local opt_groups = self.opt_groups
	local zo_min, zo_max = _G.zo_min, _G.zo_max
	local maxLines = self:GetVisibleListLines()
	self.maxLines = maxLines
	self.offset = self.offset and zo_min(#opt_groups, zo_max(0, self.offset)) or 0

	if frame.optionTypesScroll then
		frame.optionTypesScroll:SetMinMax(0, zo_max(0, #opt_groups - maxLines))
		local hei = zo_min(1, maxLines / math.max(#opt_groups, 1))
		if hei == 1 then hei = 0 end
		local tex = _G.tex
		frame.optionTypesScroll:SetThumbTexture(tex,tex,tex,SCROLL_WIDTH,frame.optionTypesScroll:GetHeight() * hei,0,0,1,1)
	end

	-------------------------------
	-- UPDATE THE BUTTONS (scroll offset; hide rows past measured fit)
	-------------------------------

	for i,button in ipairs(buts) do
		if i > maxLines then
			button:Hide()
		else
			local group = opt_groups[i + self.offset]

			if group then
				button.group = group

				button:SetIcon(1,1,2,2)
				button.icon:Show()

				if self.selectedgroup and self.selectedgroup == group then
					local muted = (CGV.Theme and CGV.Theme.AccentMutedTable()) or {245/255,93/255,7/255,0.9}
					button:SetBackdropColor(unpack(muted))
					button.bd:Show()
				else
					button.bd:Hide()
				end

				button.label:SetText(group.title)
				button:Show()
			else
				button:Hide()
			end
		end
	end

-------------------------------
-- DISPLAY THE OPTION GROUP
-------------------------------

	for _,group in ipairs(opt_groups) do
		if group.frame then
			group.frame:Hide()
		end		-- Hide all the frames, then only show when needed
	end

	if self.selectedgroup then					-- Should always be a selectedgroup hopefully
		local g = self.selectedgroup
		frame.OptionTitle:SetText(g.title)
		frame.OptionDesc:SetText(g.desc or "")

		if not g.frame then
			self:CreateOptionsUI(g)				-- Need to create the UI for this group from the options it has.
		end

		g.frame:Show()
		self:SizeOptionsScrollChild(g)

		frame.DefaultButton:Show()
		frame.OkButton:Show()
	else
		frame.OptionTitle:SetText("")
		frame.OptionDesc:SetText("")
		frame.DefaultButton:Hide()
		frame.OkButton:Hide()
	end

	if self.DefaultPopup and self.DefaultPopup:IsShown() then
		self.DefaultPopup:Hide()
	end	-- Hide popup if it is visible

	frame:Show()
end

-----------------------------------------
-- VARIOUS DIFFERENT SETTINGS UIS
-----------------------------------------

Settings.OptionUI["dropdown"] = function(self,option,parent)
	local name = parent:GetName().."_Option"..option.num

	local opt_frame = GetOpinionFrame(parent, name, option)

	local label = CHAIN(ui:Create("Label",opt_frame,name.."_Label"))
		:SetPoint(TOPLEFT,OPTIONS_LEFT_OFFSET,0)
		:SetText(option.title)
		.__END

	local dropdown = CHAIN(ui:Create("Dropdown",opt_frame,name.."_Dropdown"))
		:SetPoint(TOPLEFT,label,BOTTOMLEFT)
		:AddTooltip(option.title,option.desc,opt_frame)
		:SetDefaultText(option.data.defaultext)
		.__END

	if option.data.width then
		dropdown:SetWidth(option.data.width)
	end

	-- Pullout must not live under the ResizeToFit option row (inflates layout).
	-- Parent to the TopLevel menu so alt-tab / hide doesn't leave it sizing the group frame.
	local pulloutHost = Menu.Frame or parent
	dropdown.pullout:SetParent(pulloutHost)
	CHAIN(dropdown.pullout)
		:ClearAnchors()
		:SetAnchor(TOPLEFT,dropdown,BOTTOMLEFT)

	if option:GetDescStyle() == "inline" then
		local desc = CHAIN(GetInlineDesc(opt_frame,name.."_InlineDesc"))
			-- Get creative with Points. Can't anchor to bottomright of opt_frame because it resizes to fit descendents. Parent to topRight then overwrite top with a topleft and get the
			:SetPoint(TOPRIGHT,opt_frame,TOPRIGHT,-5,0)
			:SetPoint(TOPLEFT,dropdown,BOTTOMLEFT)
			:SetText(option.desc)
			.__END

		opt_frame.desc = desc
	end

	opt_frame.label = label
	opt_frame.dropdown = dropdown

	-- Stow away a reference
	dropdown.option = option
	opt_frame.option = option

	-- Going to call set value on the frame, make a wrapper to the thing that needs to actually get the value set.
	opt_frame.SetValue = function(me,value)
		me.dropdown:SetValue(value)
	end

	local valuetbl = option.data.values
	if type(valuetbl)=="function" then
		valuetbl = valuetbl(dropdown)
	end
	assert(type(valuetbl) == "table", "Dropdown values must be a table or a function. Not: "..type(valuetbl))

	for value,names in pairs(valuetbl) do
		local item = dropdown:AddItem(names,value,function(me)
				-- Whenever an item is clicked set the value of this option.
				if me.dropdown.option then
					me.dropdown.option:SetValue(me:GetValue())
				end
			end)
	end

	return opt_frame
end

--[[
Relavant data values:
min - min
max - max
step - step size between min/max
ispercent - min/max are percentages.
--]]
Settings.OptionUI["slider"] = function(self,option,parent)
	local name = parent:GetName().."_Option"..option.num

	local opt_frame = GetOpinionFrame(parent, name, option)

	local slider = CHAIN(ui:Create("Slider",opt_frame,name.."_Slider"))
		:SetPoint(LEFT,OPTIONS_LEFT_OFFSET,0)
		:SetIsPercent(option.data.ispercent)
		:SetMinMax(option.data.min,option.data.max)
		:SetStep(option.data.step)
		:AddTooltip(option.title,option.desc,opt_frame)
		:AddValueChangedCallback(function(me,value)
				if me.option then
					me.option:SetValue(value)
				end
			end)
		.__END

	local label = CHAIN(ui:Create("Label",opt_frame,name.."_Label"))
		:SetPoint(BOTTOM,slider,TOP)
		:SetText(option.title)
		.__END

	if option:GetDescStyle() == "inline" then
		error("No inline description for slider available atm.")
	end

	opt_frame.label = label
	opt_frame.slider = slider

	-- Stow away a reference
	slider.option = option
	opt_frame.option = option

	-- Going to call set value on the frame, make a wrapper to the thing that needs to actually get the value set.
	opt_frame.SetValue = function(me,value)
		me.slider:SetValue(value)
	end

	return opt_frame
end

--[[
Relavant data values:
nupe
--]]
Settings.OptionUI["toggle"] = function(self,option,parent)
	local name = parent:GetName().."_Option"..option.num

	local opt_frame = GetOpinionFrame(parent, name, option)

	local toggle = CHAIN(ui:Create("ToggleButton",opt_frame,name.."_Toggle"))
		:SetSize(15,15)
		:SetPoint(TOPLEFT,OPTIONS_LEFT_OFFSET,0)
		:SetText(option.title)
		:AddTooltip(option.title,option.desc,opt_frame)
		:AddValueChangedCallback(function(me,value)
				if me.option then
					me.option:SetValue(value)
				end
			end)
		.__END

	if option:GetDescStyle() == "inline" then
		local desc = CHAIN(GetInlineDesc(opt_frame,name.."_InlineDesc"))
			-- Get creative with Points. Can't anchor to bottomright of opt_frame because it resizes to fit descendents. Parent to topRight then overwrite top with a topleft and get the
			:SetPoint(TOPRIGHT,opt_frame,TOPRIGHT,-5,0)
			:SetPoint(TOPLEFT,toggle,BOTTOMLEFT)
			:SetText(option.desc)
			.__END

		opt_frame.desc = desc
	end

	opt_frame.toggle = toggle

	-- Stow away a reference
	toggle.option = option
	opt_frame.option = option

	-- Going to call set value on the frame, make a wrapper to the thing that needs to actually get the value set.
	opt_frame.SetValue = function(me,value)
		me.toggle:SetValue(value)
	end

	return opt_frame
end

--[[
Relavant data values:
func - Function to perform when pressed
--]]
Settings.OptionUI["execute"] = function(self,option,parent)
	local name = parent:GetName().."_Option"..option.num

	local opt_frame = GetOpinionFrame(parent, name, option)

	local button = CHAIN(ui:Create("Button",opt_frame,name.."_Button"))
		:SetText(option.title)
		:SetPoint(LEFT,OPTIONS_LEFT_OFFSET,0)
		:AddTooltip(option.title,option.desc,opt_frame)
		:SetHandler("OnClicked",option.data.func)
		.__END

	if option.data.width then
		button:SetWidth(option.data.width)
	end

	if option:GetDescStyle() == "inline" then
		error("No inline description for slider available atm.")
	end

	opt_frame.button = button

	-- Stow away a reference
	button.option = option
	opt_frame.option = option

	return opt_frame
end

--[[
Relavant data values:
buttons - array of { name, desc, value }
func - function(value) when a button is clicked
Equal-width buttons in one row, fitted to the option panel width.
--]]
Settings.OptionUI["buttongroup"] = function(self,option,parent)
	local name = parent:GetName().."_Option"..option.num
	local GAP = 4
	local BTN_HEIGHT = 22
	local RIGHT_PAD = 5

	local opt_frame = GetOpinionFrame(parent, name, option, "true")
	opt_frame:SetResizeToFitDescendents(false)
	opt_frame:SetHeight(BTN_HEIGHT)

	local buttonDefs = option.data.buttons or {}
	opt_frame.buttons = {}

	for i, btnData in ipairs(buttonDefs) do
		local btn = CHAIN(ui:Create("Button",opt_frame,name.."_Btn"..i))
			:SetHeight(BTN_HEIGHT)
			:SetText(btnData.name or "")
			:AddTooltip(btnData.name or "", btnData.desc or "", opt_frame)
			:SetHandler("OnClicked",function()
					if option.data.func then
						option.data.func(btnData.value)
					end
				end)
			.__END
		opt_frame.buttons[i] = btn
	end

	opt_frame.LayoutContent = function(me)
		local count = #me.buttons
		if count == 0 then return end

		local width = me:GetWidth()
		if not width or width < 80 then
			width = parent:GetWidth() or 400
		end

		local usable = width - OPTIONS_LEFT_OFFSET - RIGHT_PAD
		if usable < 80 then usable = 80 end

		local btnW = (usable - GAP * (count - 1)) / count
		if btnW < 36 then btnW = 36 end

		for i, btn in ipairs(me.buttons) do
			btn:ClearAllPoints()
			btn:SetDimensions(btnW, BTN_HEIGHT)
			if i == 1 then
				btn:SetPoint(TOPLEFT, OPTIONS_LEFT_OFFSET, 0)
			else
				btn:SetPoint(TOPLEFT, me.buttons[i - 1], TOPRIGHT, GAP, 0)
			end
		end

		me:SetHeight(BTN_HEIGHT)
	end

	opt_frame.option = option
	return opt_frame
end

--[[
Relavant data values:
- Just a header...
--]]
Settings.OptionUI["header"] = function(self,option,parent)
	local name = parent:GetName().."_Option"..option.num
	local LINE_PADDING = 3

	local opt_frame = GetOpinionFrame(parent, name, option, "true")

	local label = CHAIN(ui:Create("Label",opt_frame,name.."_Label",14,"bold"))
		:SetPoint(CENTER)
		:SetText(option.title)
		.__END

	label.leftLine = CHAIN(ui:Create("Texture",label,name.."_Left"))
		:SetPoint(RIGHT,label,LEFT,-LINE_PADDING,0)
		:SetPoint(LEFT,opt_frame)
		:SetHeight(1)
		.__END

	label.rightLine = CHAIN(ui:Create("Texture",label,name.."_Right"))
		:SetPoint(LEFT,label,RIGHT,LINE_PADDING,0)
		:SetPoint(RIGHT,opt_frame)
		:SetHeight(1)
		.__END

	opt_frame.label = label

	-- Stow away a reference
	label.option = option
	opt_frame.option = option

	return opt_frame
end

--[[
Relavant data values:
- Just a description...
--]]
Settings.OptionUI["desc"] = function(self,option,parent)
	local name = parent:GetName().."_Option"..option.num

	local opt_frame = GetOpinionFrame(parent, name, option, "true")

	local label = CHAIN(ui:Create("Label",opt_frame,name.."_Label",12))
		:SetPoint(LEFT)
		:SetPoint(RIGHT)
		:SetCanWrap(true)
		:SetText(option.title)
		.__END

	opt_frame.label = label

	-- Stow away a reference
	label.option = option
	opt_frame.option = option

	return opt_frame
end

--[[
Relavant data values:
- Just a header...
--]]
Settings.OptionUI["color"] = function(self,option,parent)
	local name = parent:GetName().."_Option"..option.num

	local opt_frame = GetOpinionFrame(parent, name, option)

	local colorpicker = CHAIN(ui:Create("ColorPicker",opt_frame,name.."_ColorPicker"))
		:SetSize(20,20)
		:SetPoint(TOPLEFT,OPTIONS_LEFT_OFFSET,0)
		:AddTooltip(option.title,option.desc,opt_frame)
		:AddValueChangedCallback(function(me,r,g,b,a)
				local value = { r = r, g = g, b = b, a = a }
				if me.option then
					me.option:SetValue(value)
				end
			end)
		.__END

	local label = CHAIN(ui:Create("Label",opt_frame,name.."_Label"))
		:SetPoint(LEFT,colorpicker,RIGHT,5,0)
		:SetText(option.title)
		.__END

	if option:GetDescStyle() == "inline" then
		local desc = CHAIN(GetInlineDesc(opt_frame,name.."_InlineDesc"))
			-- Get creative with Points. Can't anchor to bottomright of opt_frame because it resizes to fit descendents. Parent to topRight then overwrite top with a topleft and get the
			:SetPoint(TOPRIGHT,opt_frame,TOPRIGHT,-5,0)
			:SetPoint(TOPLEFT,colorpicker,BOTTOMLEFT)
			:SetText(option.desc)
			.__END

		opt_frame.desc = desc
	end

	opt_frame.colorpicker = colorpicker
	opt_frame.label = label

	-- Going to call set value on the frame, make a wrapper to the thing that needs to actually get the value set.
	opt_frame.SetValue = function(me,...)
		me.colorpicker:SetValue(...)
	end

	-- Stow away a reference
	colorpicker.option = option
	opt_frame.option = option

	return opt_frame
end

-----------------------------------------
-- MENU CONTROL FUNCTIONS
-----------------------------------------

-- Either SETTINGS_TAB_ID or GUIDEMENU_TAB_ID
function Menu:SetTab(tab)

	self:Show()

	self.Frame.tabhandler:SetCurrentTab(tab,1)	-- Set the tab, block the handler so no infinite loop is started

	GuideMenu:ShowIf(tab == GUIDEMENU_TAB_ID)
	Settings:ShowIf(tab == SETTINGS_TAB_ID)
end

function Menu:Show()

	if not self.Frame then
		self:CreateBaseMenu()
	end

	self:RegisterChromeRedraw()
	self.Frame:Show()
	self:RefreshChrome()
end

function Menu:Hide()
	if not self.Frame then return end

	-- Hide any menus that may be open.
	GuideMenu:Hide()
	Settings:Hide()

	self.Frame:Hide()
end

function Menu:Toggle()
	if not self.Frame or self.Frame:IsHidden() then
		self:Show()
	else
		self:Hide()
	end
end

-----------------------------------------
-- GUIDEMENU CONTROL FUNCTIONS
-----------------------------------------

function GuideMenu:Show()

	Menu:Show()

	if Menu.Frame and Menu.Frame.tabhandler:GetCurrentTab() ~= GUIDEMENU_TAB_ID then
		Menu:SetTab(GUIDEMENU_TAB_ID)
	end -- Make sure all other views are hidden

	if not self.Frame then
		self:Create()
	end

	self.Frame:Show()
	self:Refresh()
end

function GuideMenu:ShowIf(bool)
	if bool then
		self:Show()
	else
		self:Hide()
	end
end

function GuideMenu:Hide()
	if not self.Frame then return end

	self.Frame:Hide()
end

function GuideMenu:MenuButton_OnClick(button,mouseButton)
	if not button.target then return end
	if button.target.type == "folder" then
		self.folder = button.target.title
		self.offset = 0
		if self.Frame and self.Frame.guideBoxScroll then
			self.Frame.guideBoxScroll:SetValue(0)
		end
		self:RefreshUI()
		return
	end
	-- Right-click toggles favorite without changing selection focus unnecessarily
	if mouseButton == RIGHT_MOUSE_BUTTON then
		CGV:ToggleFavoriteGuide(button.target)
		self:RefreshUI()
		return
	end
	GuideMenu:SelectGuide(button.target)
end

function GuideMenu:SelectGuide(guide)
	if type(guide) == "table" and class(guide) == "Guide" then
		GuideMenu.selectedguide = guide
	else
		error("Selected Guide isn't a guide?!? It is a "..tostring(guide))
		GuideMenu.selectedguide = guide
	end
	self:Refresh()
end

function GuideMenu:SetCurrentGuide(guide)
	local g = (class(guide) == "Guide" and guide) or (class(self.selectedguide) == "Guide" and self.selectedguide)
	if g then
		CGV:SetGuide(g,g.CurrentStepNum)
		Menu:Hide()
	end
end

-- Display the current guide - assuming we're in LIST VIEW.
function GuideMenu:Refresh()
	self:RefreshUI()  -- that's pretty much the same, let's make it easier.
end

-----------------------------------------
-- SETTINGS CONTROL FUNCTIONS
-----------------------------------------

function Settings:Show()
	Menu:Show()
	if Menu.Frame and Menu.Frame.tabhandler:GetCurrentTab() ~= SETTINGS_TAB_ID then
		Menu:SetTab(SETTINGS_TAB_ID)
	end 	-- Make sure all other views are hidden

	if not self.Frame then
		self:Create()
	end
	self.Frame:Show()
	self:Refresh()
end

function Settings:ShowIf(bool)
	if bool then
		self:Show()
	else
		self:Hide()
	end
end

function Settings:Hide()
	if not self.Frame then return end

	if self.DefaultPopup and self.DefaultPopup:IsShown() then
		self.DefaultPopup:Hide()
	end	-- Hide popup if it is visible

	self.Frame:Hide()
end

function Settings:Refresh()
	if not self.selectedgroup then
		self:OpenSettings()
		return
	end	-- If no group to open to then open to the main group and let it recall refresh

	self:RefreshUI()
end

function Settings:GetOptionGroupByName(name)
	local opt_group

	for _,opt_g in ipairs(self.opt_groups) do
		if opt_g.group_name == name then
			opt_group = opt_g
		end
	end

	assert(opt_group,"Group \'"..name.."\' not a valid group")

	return opt_group
end

function Settings:OpenSettings(group)
	group = group or "viewer" -- Open to viewer if nothing else is given

	local opt_group = self:GetOptionGroupByName(group)

	self:SelectGroup(opt_group)

	self:Show()

	-- After a profile version bump, offer to copy from the stashed backup.
	if CGV.db and CGV.db.MaybeShowProfileMigrationPopup then
		CGV.db:MaybeShowProfileMigrationPopup()
	end
end

function Settings:MenuButton_OnClick(button,_)
	if not button.group then return end

	self:SelectGroup(button.group)

	self:Refresh()
end

function Settings:SelectGroup(group)
	assert(group,"Must have a group to open to")
	self.selectedgroup = group
end

-----------------------------------------
-- ADDING SETTINGS CONTROL FUNCTIONS
-----------------------------------------

function Settings:AddOptionGroup(opt_group)
	assert(class(opt_group) == "OptionGroup","AddOptionGroup trying to add a opt_group that isn't a OptionGroup")

	tinsert(self.opt_groups,opt_group)
end

-----------------------------------------
-- DEBUG
-----------------------------------------

function GuideMenu:Debug(...)
	local str = ...
	CGV:Debug("&guidemenu "..str, select(2,...) )
end
