-----------------------------------------
-- LOCALIZED GLOBAL VARIABLES
-----------------------------------------

local CGV = _G.CGV
local tinsert,tremove,sort,min,max,floor,type,pairs,ipairs,class = table.insert,table.remove,table.sort,math.min,math.max,math.floor,type,pairs,ipairs,_G.class
local print = CGV.print
local CHAIN = CGV.Utils.ChainCall
local ui = CGV.UI
local L = CGV.L
local O = CGV.O
local SvName = "CGESOSettings"
if CGV.DEV_SV_SUFFIX then
  SvName = SvName..CGV.DEV_SV_SUFFIX
end
local PROFILE_VERSION = 2
local CHAR_VERSION = 2
local SavedVars = {}
local DEFAULT_PROFILE = "main"

local INLINE = "inline"

local OptionGroup = CGV.Class:New("OptionGroup")
local OptionGroup_meta = {__index = OptionGroup}
local Option = CGV.Class:New("Option")
local Option_meta = {__index = Option}

local mostRecentOptGroup

local TOP, BOTTOM = _G.TOP, _G.BOTTOM
local GetDisplayName = _G.GetDisplayName

-----------------------------------------
-- SAVED REFERENCES
-----------------------------------------

CGV.sv = SavedVars
CGV.db = CGV.sv
CGV.db.rawname = SvName

-----------------------------------------
-- DEFAULT OPTION TABLES
-----------------------------------------

-- Character specific
-- Can add a never_reset = true, value to a table of values to not reset those options.
local defaultChar = {
  savedquests = {
    never_reset = true,
    --[[
			[questid] = {
				[stepnum] = {
					[1] = steptext,
					[2] = condition1Text,
					[3] = condition2Text,
					...
				}
			}
		--]]
  },

  completedquests = {
    never_reset = true,
    --[[
			[questid] =
			 if true then all quest steps are complete and everything is done
			 if table then
				{
					[1] = up to what quest step,
					[2] = table of conditions in this step.
				}
		--]]
  },

  -- Some character information stored for use when examining SV
  info = {
    level = 0,
    faction = "None",
    date = "0/0/0",
  },

  stephistory = {},
  goodbadguides = {},
  ignoredguides = {},
  favoriteguides = {
    never_reset = true,
  },
  -- guideTitle → step number for resume markers
  bookmarks = {
    never_reset = true,
  },
  -- guideTitle → { text, step } player notes
  guidenotes = {
    never_reset = true,
  },
  bugnotes = "",
  -- "ask" = prompt Full vs Main Quests Only when both exist; "full" / "mqo" remember the choice.
  guide_style = "ask",
  creator = false,
  developer = false,
}

-- These are the account settings like options that will likely be the same for all characters.
local defaultAccount = {
  -- collecting data
  data = {
    never_reset = true,
    questIds = [[]],
    npcIds = [[]],
    itemIds = [[]],
    objectIds = [[]],
  },

  Zones = {},
  ZoneNameToTex = {},

  minibutanchor = {},

  -- Real Options?
  viewerProgBar = "steps",

  -- Waypoint arrow tint — brand orange #F55D07 (first install / profile reset).
  arrowcolor = { r = 245 / 255, g = 93 / 255, b = 7 / 255, a = 1 },

  -- Debug options
  debug = false,
  debug_flags = {

  },
  ignoreErrors = false,
  --loadguidesfully = false, -- headers only at startup; full parse on demand
  unloadunusedguides = true, -- free step data for guides you're not using (helps slower PCs)
}

-----------------------------------------
-- OPTIONGROUP CLASS FUNCTIONS
-----------------------------------------

function OptionGroup:New(opt_group_name,data)
  assert(opt_group_name,"Options group must have a name to display with.")

  local opt_group = {
    options = {}, -- Each option group will have options in it.
    data = data,
    group_name = opt_group_name,
    title =  data and data.name or (opt_group_name and O["opt_"..opt_group_name]),
    desc = data and data.desc or (opt_group_name and O["opt_"..opt_group_name.."_desc"]),
  }

  setmetatable(opt_group,OptionGroup_meta)

  mostRecentOptGroup = opt_group -- Used for adding options to a group

  CGV.Settings:AddOptionGroup(opt_group)--self.opt_groups,opt_group)

  SavedVars.opt_groups = CGV.Settings.opt_groups
end

function OptionGroup:AddOption(opt)
  assert(class(opt)=="Option","Must be an Option to add it.")

  tinsert(self.options,opt)
end

-- Set all options in this option group to default
function OptionGroup:SetToDefault()
  for i,opt in ipairs(self.options) do
    opt:SetToDefault()
  end
end

function OptionGroup:SetupAllValues()
  for i,opt in ipairs(self.options) do
    opt:SetupValue()
  end
end

function OptionGroup:tostring()
  return "OptionGroup - "..self.title
end

-----------------------------------------
-- OPTION CLASS FUNCTIONS
-----------------------------------------

--[[
	General data choices in options:
    type - Type of UI component
      - string. Possible types seen below
    char - Can signal that the option is in .char instead of .profile. True for .char.
      - T/F
    set - Additional setter mechanism run when the value of the option gets changed.
      - function(option,value)
    get - Addiional code ran when the UI gets the value for the option returns a value
      - function(option)
    _default - value for default use. Can set here or in appropriate default table above. defaultChar or defaultAccount
      - W/e is appropriate for that option
    name - Title for an option that gets put in a label above it. If not passed, then uses O[opt_'optname']
      - String
    desc - description for an option that gets put in a tooltip. If not passed then uses O[opt_'optname'_desc]
      - String
    column - Puts an option in a column.
      - String - one/two/three. Only creates columns as needed
    descStyle - How to display the description
      - String - INLINE
    width - Wider control (dropdown only at present)
      - Int...

	Option Types:
		dropdown -
			values = table or function that returns a table.
				table is full of (value = "text") pairs for dropdown options.
			defaultext = string to set the text of the dd when nothing is selected
		slider -
			min - min value for slider
			max - .... yeah
			step - size of steps between min and max
			ispercent - Are min/max percentages?
		toggle -
			nuthing
		execute -
			func - Function ran when clicked.
			width - Width of the button.
		header -
			nothing special. Just gets a title
		color -
			nothing special. _default values are set with a table where {r=r,g=g,b=b,a=a}
--]]

function Option:New(optname,data)
  assert(mostRecentOptGroup,"Must create a options group before creating options")

  local opt = {
    char = data.char,
    optname = optname,
    default = data._default,
    data = data,
    set = data.set,
    get = data.get,
    title = data.name or (optname and O["opt_"..optname]),
    desc = data.desc or (optname and O["opt_"..optname.."_desc"]),
    num = #mostRecentOptGroup.options + 1,
  }

  setmetatable(opt,Option_meta)
  mostRecentOptGroup:AddOption(opt)	-- Put it in whatever the last option group was

  --opt:SetupValue()
end

-- Handles making sure the current value of the option is valid. If
function Option:SetupValue()
  if not (self.optname or self.get) then return end		-- Has an optname or a get to get a current value.

  if self.data.type=="execute" then return end

  if self.optname then
    local defaults = self.char and defaultChar or defaultAccount

    -- Set the default after so we know what sv table to pull from.
    if self.default == nil then	-- nil is not fine, try to find a proper value still.
      self.default = defaults[self.optname]
    end

    defaults[self.optname] = self.default		-- Stick this into the default table for profile reseting

    assert(self.default~=nil,("No default for %s, all options must have a default value"):format(self.optname))
  end

  local curValue = self:GetValue()
  -- Assume a 3 option t/f settings. True/False for on/off. Nil means it hasn't been set yet, so set it to default.
  -- If the type doesn't match then something is wrong, Force to default
  if self.default and type(curValue) ~= type(self.default) then
    self:SetValue(self.default)
  else
    self:SetValue(curValue)
  end

  curValue = self:GetValue()

  if self.frame and self.frame.SetValue then
    -- If this options already has a frame with a SetValue option, set it's value to current.
    self.frame:SetValue(curValue)
  end
end

function Option:SetValue(value)
  if not self.optname then return end
  if self.char then
    SavedVars.char[self.optname] = value
  else
    SavedVars.profile[self.optname] = value
  end

  if self.set then
    self:set(value)
  end
end

function Option:GetValue()
  if not (self.optname or self.get) then return end
  if self.get then
    return self:get()
  end

  if self.char then
    return SavedVars.char[self.optname]
  else
    return SavedVars.profile[self.optname]
  end
end

function Option:GetDescStyle()
  return self.data.descStyle
end

-- If the frame for this option is created then just SetValue there, so it sets it's visual correct and then it will call SetValue
function Option:SetToDefault()
  if not self.default then return end

  if self.frame and
  self.frame.SetValue then
    self.frame:SetValue(self.default)
  elseif self.SetValue then
    self:SetValue(self.default)
  end
end

function Option:tostring()
  return "Option - "..self.title
end

-----------------------------------------
-- ACTUAL MAKING OPTIONS FUNCTIONS
-----------------------------------------

function SavedVars:InitializeOptions()
  local AddOptionGroup = function(...) OptionGroup:New(...) end
  local AddOption = function(...) Option:New(...) end

  -- VIEWER
  AddOptionGroup("viewer")
  do
    AddOption("showviewer",{
        type = "toggle",
        set = function(i,v) CGV.Viewer:ShowIf_GuideViewer(v) end,
        _default = true,
      })
    AddOption("opacitymain",{
        type = "slider",
        min = 0, max = 1, step = .01, ispercent = true,
        set = function(i,v)
          CGV.Viewer:SetAlpha(v) -- also syncs Home menu + popups via Viewer:SetAlpha
        end,
        -- Backdrop-only opacity; keeps guide text readable while the world shows through.
        _default = 0.20,
      })
    AddOption('framescale',{
        type = 'slider',
        min = 0.5, max = 2.0, step = 0.1, ispercent = true,
        column = "two",
        set = function(i,v) CGV.Viewer:SetScale(v)  end,
        _default = 1,
      })

    -- Quick opacity presets (backdrop-only). Sync slider UI when present.
    local function SetViewerOpacityPreset(v)
      local opt = SavedVars:GetOptionObject("opacitymain")
      if opt and opt.frame and opt.frame.SetValue then
        opt.frame:SetValue(v)
      elseif opt then
        opt:SetValue(v)
      else
        SavedVars.profile.opacitymain = v
        if CGV.Viewer then CGV.Viewer:SetAlpha(v) end
        if CGV.PopupHandler and CGV.PopupHandler.SyncLiveSettings then
          CGV.PopupHandler:SyncLiveSettings()
        end
      end
    end

    AddOption(nil,{
        type = "header",
        name = O["opt_opacity_presets"],
      })
    AddOption(nil,{
        type = "buttongroup",
        buttons = {
          { name = O["opt_opacity_preset_0"], desc = O["opt_opacity_preset_0_desc"], value = 0 },
          { name = O["opt_opacity_preset_25"], desc = O["opt_opacity_preset_25_desc"], value = 0.25 },
          { name = O["opt_opacity_preset_50"], desc = O["opt_opacity_preset_50_desc"], value = 0.50 },
          { name = O["opt_opacity_preset_75"], desc = O["opt_opacity_preset_75_desc"], value = 0.75 },
          { name = O["opt_opacity_preset_100"], desc = O["opt_opacity_preset_100_desc"], value = 1 },
        },
        func = SetViewerOpacityPreset,
      })

    AddOption('fontsize',{
        type = 'slider',
        min = 7, max = 16, step = 1,
        set = function(i,v)
          CGV.Viewer:Update()
          if CGV.PopupHandler and CGV.PopupHandler.SyncLiveSettings then
            CGV.PopupHandler:SyncLiveSettings()
          end
        end,
        _default = 13,
      })
    AddOption('fontsecsize',{
        type = 'slider',
        min = 5, max = 14, step = 1,
        column = "two",
        set = function(i,v)
          CGV.Viewer:Update()
          if CGV.PopupHandler and CGV.PopupHandler.SyncLiveSettings then
            CGV.PopupHandler:SyncLiveSettings()
          end
        end,
        _default = 11,
      })
    AddOption('numStepShow',{
        type = 'slider',
        min = 1, max = 5, step = 1,
        set = function(i,v) CGV.Viewer:Update(true) end,
        _default = 1,
      })

    AddOption(nil,{
      type="header",
      name=O["opt_guide_style"]
      })
    AddOption("guide_style",{
        type = "dropdown",
        char = true,
        width = 220, -- Fits "Ask each time" / "Main Quests Only" without truncation
        values = {
          ask = O["opt_guide_style_ask"] or "Ask each time",
          full = O["opt_guide_style_full"] or "Full Guide",
          mqo = O["opt_guide_style_mqo"] or "Main Quests Only",
        },
        _default = "ask",
      })

    AddOption(nil,{
      type="header",
      name=O["opt_smart_skip"]
      })
    AddOption("skipimpossible",{
        type = "toggle",
        _default = true,
      })
    AddOption("skipauxsteps",{
        type = "toggle",
        -- Safer off: only tip/text fluff is skipped when enabled; gotos/beacons always stay.
        _default = false,
      })

    AddOption(nil,{
      type="header",
      name=O["opt_qol"] or "Quality of Life",
      })
    AddOption("stuckstep",{
        type = "toggle",
        _default = true,
      })
    AddOption("stuckstep_minutes",{
        type = "slider",
        min = 1, max = 60, step = 1,
        _default = 10,
      })
    AddOption("bookmarks",{
        type = "toggle",
        _default = true,
        set = function(_, v)
          if CGV.Viewer and CGV.Viewer.Frame and CGV.Viewer.Frame.TitleBar and CGV.Viewer.Frame.TitleBar.bookmark then
            CGV.Viewer.Frame.TitleBar.bookmark:SetHidden(not v)
          end
        end,
      })
    AddOption(nil,{
        type = "execute",
        width = 150,
        name = O["opt_bookmark_set"] or "Bookmark this step",
        desc = O["opt_bookmark_set_desc"] or "Save a resume marker for the current guide and step.",
        func = function()
          if CGV.Features then CGV.Features:SetBookmark() end
        end,
      })
    AddOption(nil,{
        type = "execute",
        width = 150,
        name = O["opt_bookmark_resume"] or "Resume bookmark",
        desc = O["opt_bookmark_resume_desc"] or "Jump to the bookmarked step for the current guide.",
        func = function()
          if CGV.Features then CGV.Features:ResumeBookmark() end
        end,
      })
    AddOption(nil,{
        type = "execute",
        width = 150,
        name = O["opt_guidenote"] or "Edit guide note",
        desc = O["opt_guidenote_desc"] or "Open a copyable note for the current guide (included in bug dumps).",
        func = function()
          if CGV.Features then CGV.Features:PromptGuideNote() end
        end,
      })
    AddOption("questlink",{
        type = "toggle",
        _default = true,
      })
    AddOption("zone_nudge",{
        type = "toggle",
        _default = true,
      })
    AddOption("hidecompletedgoals",{
        type = "toggle",
        set = function()
          if CGV.Viewer and CGV.Viewer.Update then CGV.Viewer:Update(true) end
        end,
        _default = false,
      })
    AddOption(nil,{
        type = "execute",
        width = 150,
        name = O["opt_compact_preset"] or "Apply compact viewer",
        desc = O["opt_compact_preset_desc"] or "Steps shown = 1, smaller primary/secondary text.",
        func = function()
          if CGV.Features then CGV.Features:ApplyCompactPreset() end
        end,
      })

    AddOption(nil,{
      type="header",
      name=O["opt_auto_hiding"]
      })
    AddOption("hideincombat",{
        type = "toggle",
        --set = function(i,v) end,
        _default = false,
      })
    AddOption("hideoninventory",{
        type = "toggle",
        set = function(i,v) CGV.Viewer:HandleActionLayer() end,
        _default = false,
      })
    AddOption("hideonguideconv",{
        type = "toggle",
        set = function(i,v) CGV.Viewer:HandleActionLayer() end,
        _default = false,
      })
    AddOption(nil,{
        type = "execute",
        width = 150,
        name = O["opt_reset"],
        desc = O["opt_reset_desc"],
        func = function()
          CGV.Viewer:ResetAllViewerSettings()
        end,
      })
    AddOption(nil,{
        type="header",
        name=O["opt_general_tip"]
      })
    AddOption(nil,{
        type="desc",
        name=O["opt_general_tip_desc"]
      })
  end

  -- ARROW
  AddOptionGroup("arrow")
  do
    AddOption('arrowshow',{
        type = 'toggle',
        set = function(i,v) CGV.Pointer:UpdateArrowVisibility() end,
        _default=true,
      })

    AddOption('arrowfreeze',{
        type = 'toggle',
        set = function(i,v) CGV.Pointer:SetupArrow() end,
        _default=false,
        column = "two",
      })


    AddOption(nil,{
        type="header",
        name=O["opt_arrow_display"]
      })
    AddOption('arrowcolor',{
        type = 'color',
        -- Default matches brand orange #F55D07 used by the Stealth arrow skin.
        _default = { r = 245 / 255, g = 93 / 255, b = 7 / 255, a = 1 },
        -- Tint is read each frame in Arrow.lua (desaturate + SetColor); no position refresh needed.
      })
    AddOption('arrowcolordist',{
        type = 'toggle',
        _default = false,
      })

    AddOption('arrowalpha',{
        type = 'slider',
        min = 0.3, max = 1.0, step = 0.1, ispercent = true,
        set = function(i,v)
          if CGV.Pointer and CGV.Pointer.SetArrowAlpha then
            CGV.Pointer:SetArrowAlpha(v)
          elseif CGV.Pointer and CGV.Pointer.SetupArrow then
            CGV.Pointer:SetupArrow()
          end
        end,
        _default = 1.0,
      })
    AddOption('arrowscale',{
        type = 'slider',
        min = 0.5, max = 2.0, step = 0.1, ispercent = true,
        set = function(i,v)	CGV.Pointer:SetupArrow()  end,
        column = "two",
        _default = 1.0,
      })
    AddOption('arrowfontsize',{
        type = 'slider',
        min = 7, max = 16, step = 1,
        set = function(i,v) CGV.Pointer:SetFontSize(v)  end,
        column = "three",
        _default = 12,
      })

    AddOption('arrowmeters',{
        type = 'toggle',
        _default=false,
      })
    AddOption(nil,{
        type = "execute",
        width = 150,
        name = O["opt_arrow_reset"],
        desc = O["opt_arrow_reset_desc"],
        func = function()
          CGV.Pointer:ResetWaypointerSettings()
        end,
      })

    AddOption(nil,{
        type="header",
        name=O["opt_additional_arrow_functions"]
      })
    AddOption('hidearrowwithguide',{
        type = 'toggle',
        _default = true,
      })

  end

  -- EXTRAS
  AddOptionGroup("extras")
  do
    AddOption("showmapbutton",{
        type = "toggle",
        set = function(i,v) if not CGV.Viewer.MinimapButton then return end CGV.Viewer.MinimapButton:ShowIf(v) end,
        _default = true,
    })
    AddOption("bugreports",{
        type = "toggle",
        name = O["opt_bugreports"],
        desc = O["opt_bugreports_desc"],
        _default = true,
        set = function(i,v)
          if CGV.Viewer and CGV.Viewer.Frame and CGV.Viewer.Frame.TitleBar and CGV.Viewer.Frame.TitleBar.bug then
            CGV.Viewer.Frame.TitleBar.bug:SetHidden(not v)
          end
        end,
    })
    AddOption("unloadunusedguides",{
        type = "toggle",
        name = O["opt_unloadunusedguides"],
        desc = O["opt_unloadunusedguides_desc"],
        _default = true,
        set = function(i,v)
          if v and CGV.UnloadUnusedGuides then
            CGV:UnloadUnusedGuides()
          end
        end,
    })
    AddOption(nil,{
        type="header",
        name=O["opt_authoring"] or "Authoring",
      })
    AddOption(nil,{
        type = "execute",
        width = 150,
        name = O["opt_cgpos_template"] or "Copy step template",
        desc = O["opt_cgpos_template_desc"] or "Build a step/goto template at your position (also /cgpos template).",
        func = function()
          if CGV.Features then CGV.Features:CopyStepTemplate() end
        end,
    })
    AddOption(nil,{
        type = "execute",
        width = 150,
        name = O["opt_cgpos_pack"] or "Copy MapData pack",
        desc = O["opt_cgpos_pack_desc"] or "goto + offsets + step template in one dump (also /cgpos pack).",
        func = function()
          if CGV.Features then CGV.Features:CopyMapDataPack() end
        end,
    })
    AddOption(nil,{
        type = "execute",
        width = 150,
        name = O["opt_cgpos_history"] or "Show /cgpos history",
        desc = O["opt_cgpos_history_desc"] or "Print recent /cgpos dumps (also /cgpos history).",
        func = function()
          if CGV.Features then CGV.Features:PrintCgposHistory() end
        end,
    })
    AddOption(nil,{
        type = "execute",
        width = 150,
        name = O["opt_poi_list"] or "List zone wayshrines / doors",
        desc = O["opt_poi_list_desc"] or "Live POI list for this zone (works when wayshrine Name fails, e.g. Solstice). Also /cgpos poi.",
        func = function()
          if CGV.Features then CGV.Features:ListZoneWayshrinesAndDoors() end
        end,
    })
  end

  -- PROFILES
  AddOptionGroup("profile")
  do
    AddOption(nil,{
        type="desc",
        name=O["opt_new_profile"]
      })
    AddOption(nil,{
        type = "dropdown",
        values = function(me)
          -- Set the callback for adjusting values onopen when needed
          me:RegisterOnOpenCallback(function(me)
              local opt = SavedVars:GetOptionObject(nil,O['opt_existing_profiles'])
              local dropdown = opt.frame and opt.frame.dropdown

              local profiles = SavedVars:GetProfiles()
              -- Stored the currently selected value before clearing them
              local value = me:GetValue()

              -- Clear items in pullout
              me:ClearItems()

              -- Repopulate pullout appropriately.
              for i,name in ipairs(profiles) do
                me:AddItem(name,name,function(item,value)
                    if SavedVars.raw.curprofile == value then return end

                    SavedVars.ProfilePopup = SavedVars.ProfilePopup or CGV.Popup:New("CGESO_Change_Profile_Popup")

                    SavedVars.ProfilePopup.OnAccept = function(me)
                      SavedVars:SetCurrentProfile(value)
                    end

                    SavedVars.ProfilePopup.OnClose = function(me)
                      -- When decline make sure the text of DD is proper
                      if dropdown then dropdown:SetValue(SavedVars.raw.curprofile) end
                    end

                    SavedVars.ProfilePopup:SetText(L['static_profile']:format(value))
                    SavedVars.ProfilePopup:Show()
                  end)
              end

              -- See if the previous value is still available in the table
              local val = me:HasValue(value)

              -- If it is then set it has the current value again.
              if val then me:SetValue(value) end
            end)

          -- Set the initial values too.
          local profiles = SavedVars:GetProfiles()

          local returns = {}

          for i,name in ipairs(profiles) do
            returns[name] = name
          end

          return returns
        end,
        get = function() return self.raw.curprofile end,
        name = O['opt_existing_profiles'],
        desc = O['opt_existing_profiles_desc'],
        descStyle = INLINE,
        width = 150,
      })
    AddOption(nil,{
        type = "execute",
        width = 150,
        name = O["opt_newprof"],
        desc = O["opt_newprof_desc"],
        func = function()
          if not SavedVars.NewProfilePopup then
            local popup = _G.CGESO_New_Profile_Popup or CGV.Popup:New("CGESO_New_Profile_Popup")

            -- Only allow alphanumeric characters... Don't want to let users screw up their SV files by naming it with strange characters.
            popup.edit = CHAIN(_G.CGESO_New_Profile_Popup_Edit or ui:Create("EditBox",popup,"CGESO_New_Profile_Popup_Edit"))
            :SetPoint(TOP,popup.text,BOTTOM,0,5)
            :SetText("Set Name")
            :HookHandler("OnMouseDown",function(me) me:SelectAll() end)
            :HookHandler("OnTextChanged",function(me)
                local text = me:GetText()

                if CGV.Utils.IsAlphanumeric(text) then
                  popup.text2:Hide()
                  popup.text2:SetHeight(1)
                else
                  popup.text2:Show()
                  popup.text2:SetCanWrap(true)
                end

              end)
            .__END

            CHAIN(popup.text2)
            :ClearAllPoints()
            :SetText(L['static_newprofile_error'])
            :SetPoint(TOP,popup.edit,BOTTOM)

            SavedVars.NewProfilePopup = popup
          end

          SavedVars.NewProfilePopup.OnAccept = function(me)
            local name = me.edit:GetText()
            if not CGV.Utils.IsAlphanumeric(name) then
              local err = L['static_newprofile_error'] or "Name can only contain letters, numbers, and spaces."
              CGV:Print(err:gsub("|c%x%x%x%x%x%x",""):gsub("|r",""))
              return
            end

            local opt = SavedVars:GetOptionObject(nil,O['opt_existing_profiles'])

            if opt.frame and opt.frame.dropdown then
              -- Fixes the dropdown to have the current profile selected and visually right.
              local item = opt.frame.dropdown:AddItem(name,name)
              opt.frame.dropdown:SetValue(item)
            end

            SavedVars:SetCurrentProfile(name)
          end

          CHAIN(SavedVars.NewProfilePopup)
          :SetText(L['static_newprofile'])
          :Show()
        end,
      })
    AddOption(nil,{
        type = "dropdown",
        values = function(me)
          me:RegisterOnOpenCallback(function(me)
              local profiles = SavedVars:GetProfiles()
              local value = me:GetValue()
              me:ClearItems()

              for _, name in ipairs(profiles) do
                if name ~= SavedVars.raw.curprofile then
                  me:AddItem(name, name, function(_, fromName)
                      SavedVars.CopySettingsPopup = SavedVars.CopySettingsPopup or CGV.Popup:New("CGESO_Copy_Settings_Popup")
                      local opt = SavedVars:GetOptionObject(nil, O["opt_copy_profile_settings"])
                      local dropdown = opt and opt.frame and opt.frame.dropdown

                      SavedVars.CopySettingsPopup.OnAccept = function()
                        if SavedVars:CopyProfileSettings(fromName, SavedVars.raw.curprofile) then
                          CGV:Print((O["opt_profile_migrate_done"] or "Copied settings from %s."):format(fromName))
                        end
                      end
                      SavedVars.CopySettingsPopup.OnClose = function()
                        if dropdown then dropdown:SetValue() end
                      end
                      SavedVars.CopySettingsPopup:SetText(
                        (L["static_copy_profile_settings"] or "Copy settings from \"%s\" into the current profile?"):format(fromName)
                      )
                      SavedVars.CopySettingsPopup:Show()
                    end)
                end
              end

              local val = me:HasValue(value)
              if val then me:SetValue(value) end
            end)

          local profiles = SavedVars:GetProfiles()
          local returns = {}
          for _, name in ipairs(profiles) do
            if name ~= SavedVars.raw.curprofile then
              returns[name] = name
            end
          end
          return returns
        end,
        defaultext = O["opt_copy_profile_settings_default"],
        name = O["opt_copy_profile_settings"],
        desc = O["opt_copy_profile_settings_desc"],
        descStyle = INLINE,
        width = 150,
      })
    AddOption(nil,{
        type = "execute",
        width = 150,
        name = O["opt_profile_reset"],
        desc = O["opt_profile_reset_desc"],
        column = "two",
        func = function()

          SavedVars.ResetProfilePopup = SavedVars.ResetProfilePopup or CGV.Popup:New("Community_Reset_Profile_Popup")

          SavedVars.ResetProfilePopup.OnAccept = function(me)
            for i,opt_groups in ipairs(SavedVars.opt_groups) do
              opt_groups:SetToDefault()
            end

            CGV.Viewer:ResetAllViewerSettings()
            CGV.Pointer:ResetWaypointerSettings()
          end

          SavedVars.ResetProfilePopup:SetText(L['static_reset_profile']:format(SavedVars.raw.curprofile))
          SavedVars.ResetProfilePopup:Show()
        end,
      })
    AddOption(nil,{
        type = "dropdown",
        values = function(me)
          -- Set the callback for adjusting values onopen when needed
          me:RegisterOnOpenCallback(function(me)
              local profiles = SavedVars:GetProfiles()
              -- Stored the currently selected value before clearing them
              local value = me:GetValue()

              -- Clear items in pullout
              me:ClearItems()

              -- Repopulate pullout appropriately. Don't put the current profile in the list.
              for i,name in ipairs(profiles) do if name ~= SavedVars.raw.curprofile then
                me:AddItem(name,name,function(item,value)
                    local opt = SavedVars:GetOptionObject(nil,O['opt_delete_profiles'])
                    local dropdown = opt.frame and opt.frame.dropdown

                    SavedVars.DeleteProfilePopup = SavedVars.DeleteProfilePopup or CGV.Popup:New("Community_Delete_Profile_Popup")

                    -- Just delete the profile, dd updates properly when next opened.
                    SavedVars.DeleteProfilePopup.OnAccept = function(me)
                      SavedVars:DeleteProfile(value)
                    end

                    -- Clear the dd's current item.
                    SavedVars.DeleteProfilePopup.OnClose = function(me)
                      if dropdown then dropdown:SetValue() end
                    end

                    SavedVars.DeleteProfilePopup:SetText(L['static_deleteprofile']:format(value))
                    SavedVars.DeleteProfilePopup:Show()
                  end)
              end end

              -- See if the previous value is still available in the table
              local val = me:HasValue(value)

              -- If it is then set it has the current value again.
              if val then me:SetValue(value) end
            end)

          -- Set the initial values too.
          local profiles = SavedVars:GetProfiles()

          local returns = {}

          for i,name in ipairs(profiles) do
            returns[name] = name
          end

          return returns
        end,
        defaultext = O['opt_delete_profiles_default'],
        name = O['opt_delete_profiles'],
        desc = O['opt_delete_profiles_desc'],
        descStyle = INLINE,
        width = 150,
      })
    if CGV.DEV then
      -- DEV char-profile picker can list characters from other factions.
      AddOption(nil,{
          type = "dropdown",
          values = function(me)
            -- Set the callback for adjusting values onopen when needed
            me:RegisterOnOpenCallback(function(me)
                local profiles = SavedVars:GetCharProfiles()
                -- Stored the currently selected value before clearing them
                local value = me:GetValue()

                -- Clear items in pullout
                me:ClearItems()

                -- Repopulate pullout appropriately. Don't put the current profile in the list.
                for i,name in ipairs(profiles) do if CGV.Utils.GetPlayerName() ~= name then
                  me:AddItem(name,name,function(item,value)
                      if CGV.Utils.GetPlayerName() == value then return end
                      local opt = SavedVars:GetOptionObject(nil,O['opt_delete_profiles'])
                      local dropdown = opt.frame and opt.frame.dropdown

                      SavedVars.CopyProfilePopup = SavedVars.CopyProfilePopup or CGV.Popup:New("Community_Copy_Profile_Popup")

                      -- Just delete the profile, dd updates properly when next opened.
                      SavedVars.CopyProfilePopup.OnAccept = function(me)
                        local prof = SavedVars.raw.characters[value]

                        local new = table.cgclone(prof)

                        self.char = new

                        SavedVars.raw.characters[CGV.Utils.GetPlayerName()] = new
                      end

                      -- Clear the dd's current item.
                      SavedVars.CopyProfilePopup.OnClose = function(me)
                        if dropdown then dropdown:SetValue() end
                      end

                      SavedVars.CopyProfilePopup:SetText(("Copy from Character %s"):format(value))
                      SavedVars.CopyProfilePopup:Show()

                    end)
                end end

                -- See if the previous value is still available in the table
                local val = me:HasValue(value)

                -- If it is then set it has the current value again.
                if val then me:SetValue(value) end
              end)

            -- Set the initial values too.
            local profiles = SavedVars:GetCharProfiles()

            local returns = {}

            for i,name in ipairs(profiles) do
              returns[name] = name
            end

            return returns
          end,
          defaultext = "Char Profiles",
          name = O['opt_char_profiles'],
          desc = O['opt_char_profiles_desc'],
          descStyle = INLINE,
          width = 150,
        })
    end

  end

  -- DEVELOPER
  if CGV.DEV then
    AddOptionGroup("dev")
    do
      AddOption("debug",{
          type = "toggle",
          name = "Debug Mode"
        })
      AddOption("surveymaps",{
          type = "execute",
          name = "Survey maps",
          func = function() CGV.Pointer:SurveyAllMaps() end,
        })
      AddOption("surveymapsdeep",{
          type = "execute",
          name = "Survey maps (deep)",
          func = function() CGV.Pointer:SurveyAllMaps(true) end,
        })
    end
  end

	--[[
	-- TESTING
	AddOptionGroup("TESTING",{name = "TESTING",desc = "Settings to just show testing of various option types and positionings."})
	do
		AddOption("skin2",{
			type = "dropdown",
			values = {
				s1 = "111",
				s2 = "2222",
			},
			desc = "In line descriptions!",
			descStyle = INLINE,
			name = "Hi",
			column = "one",
			_default = "s1",
		})
		AddOption("accent2",{
			type = "color",
			name = "Color Picker!!",
			column = "three",
			desc = "In line descriptions! With Some word wrapping",
			descStyle = "inline",
			_default = {r = 0, g = 1, b = 0, a = .3},
		})
	end
	--]]

end

-----------------------------------------
-- SAVED VARIABLE FUNCTIONS
-----------------------------------------

--[[
		ZO_SavedVars:New(arg1,arg2,arg3,arg4)
		-- arg 1 - Name for the addon's SV. Same as in the .txt
		-- arg 2 - Version of the SV. Older versions likely removed?
		-- arg 3 - Can keep multiple profiles of the same set of variables. So prof1 and prof2
		-- arg 4 - Actual table.
--]]

function SavedVars:Setup()
  CGV:Debug("&startup SV: Setting up saved vars...")
  if GetDisplayName()=="" then
    CGV.ERROR_GETDISPLAYNAME_FAIL=true
  end

  local fac = CGV.Utils.GetFaction()
  local name = CGV.Utils.GetPlayerName()

  CGV:Debug("&startup SV: faction "..(fac or "NONE")..", name "..(name or "NONE"))

  assert(fac,"No faction known at options load time!")
  assert(name,"No player name known at options load time!")

  -- If SV does not exist then use ZOS function to create it.
  if not _G[SvName] then
    _G.ZO_SavedVars:New(SvName, 100007, nil, {})
    CGV:Debug("&startup SV: Created a new sv file")
  else
    CGV:Debug("&startup SV: loaded SV file properly")
  end

  local raw, prof,charProf

  raw = _G[SvName]
  if not raw then error("Settings are missing entirely!") end
  self.raw = raw

  -- Setup raw tables if needed
  raw.global = raw.global or {}
  raw.profiles = raw.profiles or {}
  raw.characters = raw.characters or {}
  raw.factions = raw.factions or {}
  raw.factions[fac] = raw.factions[fac] or {}

  if raw.Default then copySvOldToNew() end	-- 4/14/2014 switch from ZOS SV to our own managed.

  ----------------------
  -- SETUP PROFILE
  ----------------------
  self:SetCurrentProfile() -- Uses raw.curprofile then if that isn't available uses DEFAULT_PROFILE

  ----------------------
  -- SETUP CHARACTER PROFILE
  ----------------------
  self:SetCurrentCharacterProfile()


  self.faction = self.faction or raw.factions[fac]

  -- Store some character information at startup
  self.char.info.level = CGV.Utils.GetPlayerPreciseLevel()
  self.char.info.faction = fac
  self.char.info.date = _G.GetDate()
  self.char.info.time = _G.GetFormattedTime()

  --[[
	if self.char.savedquests then
		self.faction.savedquests = self.char.savedquests
		self.char.savedquests = nil
	end
	if self.profile.data then
		self.faction.data = self.profile.data
		self.profile.data = nil
	end
	--]]

  self:InitializeOptions()

  self.initialized = true

  SavedVars:SetupAllOptionGroups()
end

-- Unique name for a stashed/backup profile (e.g. "main backup", "main backup 2").
function SavedVars:MakeUniqueProfileName(base)
  local profiles = self.raw.profiles
  if not profiles[base] then return base end
  local i = 2
  while profiles[base.." "..i] do
    i = i + 1
  end
  return base.." "..i
end

function SavedVars:MakeUniqueCharProfileName(base)
  local chars = self.raw.characters
  if not chars[base] then return base end
  local i = 2
  while chars[base.." "..i] do
    i = i + 1
  end
  return base.." "..i
end

-- Creates a new profile in CGVS.profiles[pname]. Does not assign it to SV.profile. If data is passed uses that, otherwise uses default
function SavedVars:CreateNewProfile(pname,data)
  if not pname then return end

  data = data or defaultAccount

  self.raw.profiles[pname] = table.cgclone(data)

  self.raw.profiles[pname].version = PROFILE_VERSION

  return self.raw.profiles[pname]
end

-- Copy account-profile settings from one named profile into another (keeps version current).
function SavedVars:CopyProfileSettings(fromName, toName)
  local raw = self.raw
  local from = raw.profiles[fromName]
  toName = toName or raw.curprofile
  local to = raw.profiles[toName]
  if not from or not to then return false end

  for k, v in pairs(from) do
    if k ~= "version" then
      if type(v) == "table" then
        to[k] = table.cgclone(v)
      else
        to[k] = v
      end
    end
  end
  to.version = PROFILE_VERSION

  if toName == raw.curprofile then
    self.profile = to
    if self.initialized then
      self:SetupAllOptionGroups()
      if CGV.Viewer and CGV.Viewer.UpdateViewer then CGV.Viewer:UpdateViewer() end
      if CGV.Pointer and CGV.Pointer.UpdateArrowPosition then CGV.Pointer:UpdateArrowPosition() end
      if CGV.PopupHandler and CGV.PopupHandler.SyncLiveSettings then CGV.PopupHandler:SyncLiveSettings() end
    end
  end
  return true
end

function SavedVars:CopyCharProfileSettings(fromName, toName)
  local raw = self.raw
  local from = raw.characters[fromName]
  toName = toName or CGV.Utils.GetPlayerName()
  local to = raw.characters[toName]
  if not from or not to then return false end

  for k, v in pairs(from) do
    if k ~= "version" then
      if type(v) == "table" then
        if type(to[k]) == "table" and to[k].never_reset then
          -- keep never_reset destination tables intact (quest history etc.) unless cloning whole char
        end
        to[k] = table.cgclone(v)
      else
        to[k] = v
      end
    end
  end
  to.version = CHAR_VERSION

  if toName == CGV.Utils.GetPlayerName() then
    self.char = to
  end
  return true
end

-- Prefer the passed name, then try to just reset the current profile, worse cause just resort to using default
function SavedVars:SetCurrentProfile(name)
  local raw = self.raw
  local prof

  name = name or raw.curprofile or DEFAULT_PROFILE

  prof = raw.profiles[name]

  if not prof then
    -- Brand new — create defaults
    prof = self:CreateNewProfile(name)
  elseif not prof.version or prof.version < PROFILE_VERSION then
    -- Outdated: stash the old table, create fresh defaults, offer copy UI
    local backupName = self:MakeUniqueProfileName(name.." backup")
    raw.profiles[backupName] = prof
    prof = self:CreateNewProfile(name)
    self.pendingProfileMigration = {
      kind = "profile",
      from = backupName,
      to = name,
    }
  end

  raw.curprofile = name
  self.profile = prof

  -- After we are initalized then we are changing a profile so make sure we update every properly.
  if self.initialized then
    SavedVars:SetupAllOptionGroups()
    CGV.Viewer:UpdateViewer()		-- Update Viewer options
    CGV.Pointer:UpdateArrowPosition()	-- Update Waypointer
    if CGV.PopupHandler and CGV.PopupHandler.SyncLiveSettings then
      CGV.PopupHandler:SyncLiveSettings()
    end
  end
end

function SavedVars:DeleteProfile(name)
  local raw = self.raw

  if name == raw.curprofile then
    CGV:Error("Can not delete your current profile. Change profile before deleting.")
    return
  end

  raw.profiles[name] = nil
end

-- Creates a new profile in CGVS.characters[charname]. Does not assign it to SV.char. If data is passed uses that, otherwise uses default
function SavedVars:CreateNewCharProfile(cname,data)
  if not cname then return end

  data = data or defaultChar

  self.raw.characters[cname] = table.cgclone(data)

  self.raw.characters[cname].version = CHAR_VERSION

  return self.raw.characters[cname]
end

-- returns a table of profiles that can be iterated with ipairs
function SavedVars:GetProfiles()
  local profs = self.raw.profiles
  local table = {}

  for name,data in pairs(profs) do
    tinsert(table,name)
  end

  return table
end

function SavedVars:GetCurrentProfileName()
  local curProf = self.raw.curprofile

  return curProf
end

function SavedVars:GetCharProfiles()
  local profs = self.raw.characters
  local table = {}

  for name,data in pairs(profs) do
    tinsert(table,name)
  end

  return table
end

function SavedVars:SetCurrentCharacterProfile()
  local name = CGV.Utils.GetPlayerName()
  local raw = self.raw
  local charProf

  charProf = raw.characters[name]

  if not charProf then
    charProf = self:CreateNewCharProfile(name)
  elseif not charProf.version or charProf.version < CHAR_VERSION then
    local backupName = self:MakeUniqueCharProfileName(name.." backup")
    raw.characters[backupName] = charProf
    charProf = self:CreateNewCharProfile(name)
    -- Prefer account-profile migration popup if both fire; otherwise queue char migrate.
    if not self.pendingProfileMigration then
      self.pendingProfileMigration = {
        kind = "char",
        from = backupName,
        to = name,
      }
    end
  end

  self.char = charProf
end

-- Offer to copy settings from a stashed backup after a version bump (does not wipe the backup).
function SavedVars:MaybeShowProfileMigrationPopup()
  local pend = self.pendingProfileMigration
  if not pend then return end
  self.pendingProfileMigration = nil

  if not (CGV.Popup and CGV.Frame) then
    -- Viewer not ready yet — keep pending for Startup / OpenSettings
    self.pendingProfileMigration = pend
    return
  end

  local popup = self.MigrationPopup or CGV.Popup:New("CGESO_Profile_Migration_Popup")
  self.MigrationPopup = popup

  popup.OnAccept = function()
    if pend.kind == "char" then
      SavedVars:CopyCharProfileSettings(pend.from, pend.to)
      CGV:Print((O and O["opt_profile_migrate_done"]) or ("Copied character settings from %s."):format(pend.from))
    else
      SavedVars:CopyProfileSettings(pend.from, pend.to)
      CGV:Print((O and O["opt_profile_migrate_done"]) or ("Copied settings from %s."):format(pend.from))
    end
  end

  popup.OnDecline = function()
    -- Keep defaults; backup profile remains available under Profiles → Copy settings from
  end

  local title = (pend.kind == "char")
    and (L["static_char_migrate"] or "Character settings were updated.")
    or (L["static_profile_migrate"] or "Profile settings were updated.")
  local detail = L["static_profile_migrate_detail"]
    or ("Copy your previous options from \"%s\" into the new profile? Decline keeps defaults; the backup stays in the list."):format(pend.from)

  popup:SetText(title, pend.from, detail)
  popup:Show()
end

-- Iterates through all options and makes sure they are valid and sets their values
function SavedVars:SetupAllOptionGroups()
  for i,opt_group in ipairs(CGV.Settings.opt_groups) do
    opt_group:SetupAllValues()
  end
end

-- Can get an option by either optname or title.
function SavedVars:GetOptionObject(optname,title)
  if not (optname or title) then return end

  for i,optgroup in ipairs(self.opt_groups) do
    for k, opt in ipairs(optgroup.options) do
      if (optname and opt.optname == optname) or
      (title and opt.title == title) then
        return opt
      end
    end
  end
end

function SavedVars:TableToDefault(tab,defaults)
  tab = getmetatable(tab) and getmetatable(tab).__index or tab
  if not tab then return end

  for name,value in pairs(tab) do
    if not defaults[name] then
      -- Do nothing? This value is extra in our SV but not in defaults. Get rid of it then
      tab[name] = nil
    elseif type(value) == "table" then
      if not value.never_reset then		-- Some data we don't want to reset so dont.
        self:TableToDefault(tab[name],defaults[name])
      end
    else
      tab[name] = defaults[name]
    end
  end
end

function SavedVars:ResetCharToDefaults()
  self:TableToDefault(self.char,defaultChar)
end

function SavedVars:ResetProfileToDefaults()
  self:TableToDefault(self.profile,defaultAccount)
end

-----------------------------------------
-- DEBUG
-----------------------------------------

--[[
function MyObject:Debug(...)
	local str = ...
	CGV:Debug("&myobj "..str, select(2,...) )
end
]]--

function copySvOldToNew()
  local raw = _G[SvName]
  local old = raw.Default

  for actName, t in pairs(old) do if actName~="" then
    for name, tt in pairs(t) do
      if name == "$AccountWide" then
        -- Profile
        SavedVars:CreateNewProfile(actName,tt.main)

        -- IF this account is our current account, use that profile. Otherwise use w/e name was found first.
        if actName == GetDisplayName() then
          raw.curprofile = actName
        else
          raw.curprofile = raw.curprofile or actName
        end
      else
        -- Character
        SavedVars:CreateNewCharProfile(name,tt.main)
      end
    end
  end end

  -- Old settings are copied into new... Get rid of old.. BY FIRE BE PURGED
  raw.Default = nil
end