-----------------------------------------
-- ESO ADDON SETTINGS (LibAddonMenu-2.0)
-- Esc → Settings → Addons → Community Leveling Guide
-- Mirrors Home settings (Guide Viewer / Waypoint Arrow / Extras / Profiles / Modes)
-- on the same SavedVariables. Guide list / banners / Start Guide stay Home-only.
-----------------------------------------

local CGV = _G.CGV
local tinsert = table.insert

local function Opt(key, fallback)
  local O = CGV.O
  if O and O[key] then return O[key] end
  return fallback
end

local PANEL_ID = "CGESO_AddonSettings"

local ARROW_ORANGE = { r = 245 / 255, g = 93 / 255, b = 7 / 255, a = 1 }

-----------------------------------------
-- Shared get/set via Option objects (same SV as Home)
-----------------------------------------

local function GetOptionObject(optname)
  return CGV.db and CGV.db.GetOptionObject and CGV.db:GetOptionObject(optname)
end

-- Character-scoped option names (match Options.lua `char = true`).
local CHAR_OPTIONS = {
  guide_style = true,
  creator = true,
  developer = true,
}

-- Prefer Option:SetValue so Home widgets stay in sync when open; runs option.set hooks.
local function SetNamedOption(optname, value)
  local opt = GetOptionObject(optname)
  if opt then
    if opt.frame and opt.frame.SetValue then
      opt.frame:SetValue(value)
    else
      opt:SetValue(value)
    end
    return
  end
  -- Early / fallback before options init
  if CHAR_OPTIONS[optname] then
    local char = CGV.sv and CGV.sv.char
    if char then char[optname] = value end
  elseif CGV.db and CGV.db.profile then
    CGV.db.profile[optname] = value
  end
end

local function GetNamedOption(optname, default)
  local opt = GetOptionObject(optname)
  if opt and opt.GetValue then
    local v = opt:GetValue()
    if v ~= nil then return v end
  end
  if CHAR_OPTIONS[optname] then
    local char = CGV.sv and CGV.sv.char
    if char and char[optname] ~= nil then return char[optname] end
    return default
  end
  local profile = CGV.db and CGV.db.profile
  if profile and profile[optname] ~= nil then
    return profile[optname]
  end
  return default
end

local function GetChar()
  return CGV.sv and CGV.sv.char
end

local function GetCharFlag(name, default)
  local char = GetChar()
  if not char then return default end
  local v = char[name]
  if v == nil then return default end
  return v and true or false
end

local function SetCreatorMode(enabled)
  local char = GetChar()
  if not char then return end
  enabled = not not enabled
  char.creator = enabled
  CGV.Creator = enabled
  if CGV.Print then
    CGV:Print(("Creator Mode is now %s"):format(enabled and "on" or "off"))
  end
end

local function SetDeveloperMode(enabled)
  local char = GetChar()
  if not char then return end
  enabled = not not enabled
  char.developer = enabled
  CGV.DEV = enabled
  if CGV.Print then
    CGV:Print(("Developer Mode is now %s"):format(enabled and "on" or "off"))
  end
end

local function SetViewerOpacity(v)
  SetNamedOption("opacitymain", v)
  if CGV.Viewer and CGV.Viewer.SetAlpha then
    CGV.Viewer:SetAlpha(v)
  end
end

-----------------------------------------
-- PROFILES (create / switch / copy / delete)
-----------------------------------------

local newProfileNameDraft = ""

local function SortedProfileNames()
  local names = {}
  local db = CGV.db
  if db and db.GetProfiles then
    names = db:GetProfiles() or {}
  end
  local cur = db and db.raw and db.raw.curprofile
  if cur and cur ~= "" then
    local found = false
    for i = 1, #names do
      if names[i] == cur then found = true break end
    end
    if not found then tinsert(names, cur) end
  end
  if #names == 0 then
    names = { "main" }
  end
  table.sort(names)
  return names
end

local function OtherProfileNames()
  local cur = CGV.db and CGV.db.raw and CGV.db.raw.curprofile
  local out = {}
  for _, name in ipairs(SortedProfileNames()) do
    if name ~= cur then
      tinsert(out, name)
    end
  end
  return out
end

local function GetCurrentProfileName()
  local names = SortedProfileNames()
  local cur = CGV.db and CGV.db.raw and CGV.db.raw.curprofile
  if cur and cur ~= "" then
    for i = 1, #names do
      if names[i] == cur then return cur end
    end
  end
  return names[1]
end

local function CopyProfileChoices()
  local placeholder = Opt("opt_copy_profile_settings_default", "Choose a profile...")
  local names = OtherProfileNames()
  if #names == 0 then
    return { Opt("opt_lam_profile_none", "(no other profiles)") }
  end
  local choices = { placeholder }
  for _, name in ipairs(names) do
    tinsert(choices, name)
  end
  return choices
end

local function CopyProfileGet()
  return CopyProfileChoices()[1]
end

local function DeleteProfileChoices()
  local placeholder = Opt("opt_delete_profiles_default", "Profiles")
  local names = OtherProfileNames()
  if #names == 0 then
    return { Opt("opt_lam_profile_none", "(no other profiles)") }
  end
  local choices = { placeholder }
  for _, name in ipairs(names) do
    tinsert(choices, name)
  end
  return choices
end

local function DeleteProfileGet()
  return DeleteProfileChoices()[1]
end

local REF_CURRENT = "CGESO_LAM_CurrentProfile"
local REF_COPY = "CGESO_LAM_CopyProfile"
local REF_DELETE = "CGESO_LAM_DeleteProfile"

local function RefreshLamProfileDropdowns()
  local function refresh(refName, choices)
    local ctrl = _G[refName]
    if not (ctrl and ctrl.UpdateChoices) then return end
    ctrl:UpdateChoices(choices)
    if ctrl.UpdateValue then
      ctrl:UpdateValue()
    end
  end
  refresh(REF_CURRENT, SortedProfileNames())
  refresh(REF_COPY, CopyProfileChoices())
  refresh(REF_DELETE, DeleteProfileChoices())
end

local function SwitchProfile(name)
  if not (CGV.db and name and name ~= "") then return end
  if GetCurrentProfileName() == name then return end
  CGV.db:SetCurrentProfile(name)
  RefreshLamProfileDropdowns()
  if CGV.Print then
    CGV:Print((Opt("opt_lam_profile_switched", "Switched to profile %s.")):format(name))
  end
end

local function CreateProfileFromDraft()
  local name = (newProfileNameDraft or ""):match("^%s*(.-)%s*$") or ""
  if name == "" then
    if CGV.Print then CGV:Print(Opt("opt_lam_profile_need_name", "Enter a name for the new profile.")) end
    return
  end
  if CGV.Utils and CGV.Utils.IsAlphanumeric and not CGV.Utils.IsAlphanumeric(name) then
    if CGV.Print then CGV:Print(Opt("opt_lam_profile_bad_name", "Profile name can only contain letters, numbers, and spaces.")) end
    return
  end
  local db = CGV.db
  if not db then return end
  if db.raw and db.raw.profiles and db.raw.profiles[name] then
    if CGV.Print then CGV:Print((Opt("opt_lam_profile_exists", "Profile \"%s\" already exists.")):format(name)) end
    return
  end
  db:SetCurrentProfile(name)
  newProfileNameDraft = ""
  RefreshLamProfileDropdowns()
  if CGV.Print then
    CGV:Print((Opt("opt_lam_profile_created", "Created and switched to profile %s.")):format(name))
  end
end

local function CopyFromProfile(fromName)
  local db = CGV.db
  if not (db and fromName and fromName ~= "") then return end
  if fromName == GetCurrentProfileName() then return end
  if db:CopyProfileSettings(fromName, GetCurrentProfileName()) then
    RefreshLamProfileDropdowns()
    if CGV.Print then
      CGV:Print((Opt("opt_profile_migrate_done", "Copied settings from %s.")):format(fromName))
    end
  end
end

local function DeleteProfileByName(name)
  local db = CGV.db
  if not (db and name and name ~= "") then return end
  if name == GetCurrentProfileName() then
    if CGV.Print then
      CGV:Print(Opt("opt_lam_profile_cant_delete_current", "Cannot delete the current profile. Switch first."))
    end
    return
  end
  db:DeleteProfile(name)
  RefreshLamProfileDropdowns()
  if CGV.Print then
    CGV:Print((Opt("opt_lam_profile_deleted", "Deleted profile %s.")):format(name))
  end
end

-----------------------------------------
-- Build LAM controls
-----------------------------------------

local function GuideStyleChoices()
  return {
    Opt("opt_guide_style_ask", "Ask each time"),
    Opt("opt_guide_style_full", "Full Guide"),
    Opt("opt_guide_style_mqo", "Main Quests Only"),
  }
end

local function GuideStyleValues()
  return { "ask", "full", "mqo" }
end

local function RegisterWithLAM()
  local LAM = _G.LibAddonMenu2
  if not LAM and _G.LibStub then
    LAM = _G.LibStub("LibAddonMenu-2.0", true)
  end
  if not LAM then
    CGV:Debug("&startup LibAddonMenu-2.0 not found; skipping ESO Addon Settings panel")
    return
  end

  local version = (CGV.GetVersion and CGV:GetVersion()) or ""

  local panelData = {
    type = "panel",
    name = "Community Leveling Guide",
    displayName = "|cfd5b02Community Leveling Guide|r",
    author = "snichols7778, Hydra9268",
    version = version,
    website = nil,
    registerForRefresh = true,
    registerForDefaults = true,
  }

  local optionsTable = {
    {
      type = "description",
      text = Opt("opt_lam_intro", "All settings match the in-addon Home panel and share the same SavedVariables. Use Open Full Settings for the guide list and chapter browser."),
      width = "full",
    },
    {
      type = "button",
      name = Opt("opt_lam_open_full", "Open Full Settings"),
      tooltip = Opt("opt_lam_open_full_desc", "Open the Community Leveling Guide Home window (guide list, chapter banners, Start Guide, and settings)."),
      func = function()
        if CGV.Settings and CGV.Settings.OpenSettings then
          CGV.Settings:OpenSettings()
        elseif CGV.Menu and CGV.Menu.Show then
          CGV.Menu:Show()
        end
      end,
      width = "full",
    },

    -----------------------------------------
    -- GUIDE VIEWER
    -----------------------------------------
    {
      type = "submenu",
      name = Opt("opt_viewer", "Guide Viewer"),
      controls = {
        {
          type = "checkbox",
          name = Opt("opt_showviewer", "Enable Guide Viewer"),
          tooltip = Opt("opt_showviewer_desc", "Show the Guide Viewer window."),
          getFunc = function() return GetNamedOption("showviewer", true) end,
          setFunc = function(v) SetNamedOption("showviewer", v) end,
          default = true,
          width = "full",
        },
        {
          type = "slider",
          name = Opt("opt_opacitymain", "Opacity"),
          tooltip = Opt("opt_opacitymain_desc", "Opacity of the Guide Viewer backdrop."),
          min = 0, max = 100, step = 1,
          getFunc = function()
            return zo_round((GetNamedOption("opacitymain", 0.20) or 0.20) * 100)
          end,
          setFunc = function(pct) SetViewerOpacity((pct or 0) / 100) end,
          default = 20,
          width = "half",
        },
        {
          type = "slider",
          name = Opt("opt_framescale", "Scale"),
          tooltip = Opt("opt_framescale_desc", "You can resize the window to match your preferences."),
          min = 50, max = 200, step = 10,
          getFunc = function()
            return zo_round((GetNamedOption("framescale", 1) or 1) * 100)
          end,
          setFunc = function(pct) SetNamedOption("framescale", (pct or 100) / 100) end,
          default = 100,
          width = "half",
        },
        {
          type = "header",
          name = Opt("opt_opacity_presets", "Opacity presets"),
          width = "full",
        },
        {
          type = "button",
          name = Opt("opt_opacity_preset_0", "0%"),
          tooltip = Opt("opt_opacity_preset_0_desc", "Fully transparent backdrop."),
          func = function() SetViewerOpacity(0) end,
          width = "half",
        },
        {
          type = "button",
          name = Opt("opt_opacity_preset_25", "25%"),
          tooltip = Opt("opt_opacity_preset_25_desc", "Light backdrop (25% opaque)."),
          func = function() SetViewerOpacity(0.25) end,
          width = "half",
        },
        {
          type = "button",
          name = Opt("opt_opacity_preset_50", "50%"),
          tooltip = Opt("opt_opacity_preset_50_desc", "Halfway opaque backdrop (50%)."),
          func = function() SetViewerOpacity(0.50) end,
          width = "half",
        },
        {
          type = "button",
          name = Opt("opt_opacity_preset_75", "75%"),
          tooltip = Opt("opt_opacity_preset_75_desc", "Mostly opaque backdrop (75%)."),
          func = function() SetViewerOpacity(0.75) end,
          width = "half",
        },
        {
          type = "button",
          name = Opt("opt_opacity_preset_100", "100%"),
          tooltip = Opt("opt_opacity_preset_100_desc", "Fully opaque backdrop."),
          func = function() SetViewerOpacity(1) end,
          width = "full",
        },
        {
          type = "slider",
          name = Opt("opt_fontsize", "Primary text size"),
          tooltip = Opt("opt_fontsize_desc", "Set your preferred text size."),
          min = 7, max = 16, step = 1,
          getFunc = function() return GetNamedOption("fontsize", 13) end,
          setFunc = function(v) SetNamedOption("fontsize", v) end,
          default = 13,
          width = "half",
        },
        {
          type = "slider",
          name = Opt("opt_fontsecsize", "Secondary text size"),
          tooltip = Opt("opt_fontsecsize_desc", "Secondary text size for notes and descriptions."),
          min = 5, max = 14, step = 1,
          getFunc = function() return GetNamedOption("fontsecsize", 11) end,
          setFunc = function(v) SetNamedOption("fontsecsize", v) end,
          default = 11,
          width = "half",
        },
        {
          type = "slider",
          name = Opt("opt_numStepShow", "Steps shown"),
          tooltip = Opt("opt_numStepShow_desc", "How many guide steps to show at once."),
          min = 1, max = 5, step = 1,
          getFunc = function() return GetNamedOption("numStepShow", 1) end,
          setFunc = function(v) SetNamedOption("numStepShow", v) end,
          default = 1,
          width = "full",
        },
        {
          type = "header",
          name = Opt("opt_guide_style", "Guide Style"),
          width = "full",
        },
        {
          type = "dropdown",
          name = Opt("opt_guide_style", "Guide Style"),
          tooltip = Opt("opt_guide_style_desc", "When a zone has both a Full guide and Main Quests Only, choose which to load — or ask each time."),
          choices = GuideStyleChoices(),
          choicesValues = GuideStyleValues(),
          getFunc = function() return GetNamedOption("guide_style", "ask") end,
          setFunc = function(v) SetNamedOption("guide_style", v) end,
          default = "ask",
          width = "full",
        },
        {
          type = "header",
          name = Opt("opt_smart_skip", "Smart Skip"),
          width = "full",
        },
        {
          type = "checkbox",
          name = Opt("opt_skipimpossible", "Skip impossible steps"),
          tooltip = Opt("opt_skipimpossible_desc", "Automatically advance past steps that cannot be completed."),
          getFunc = function() return GetNamedOption("skipimpossible", true) end,
          setFunc = function(v) SetNamedOption("skipimpossible", v) end,
          default = true,
          width = "full",
        },
        {
          type = "checkbox",
          name = Opt("opt_skipauxsteps", "Skip auxiliary travel steps"),
          tooltip = Opt("opt_skipauxsteps_desc", "Skip tip/text fluff when the next real objective is already done. Never skips blue beacon / marker (goto) travel."),
          getFunc = function() return GetNamedOption("skipauxsteps", false) end,
          setFunc = function(v) SetNamedOption("skipauxsteps", v) end,
          default = false,
          width = "full",
        },
        {
          type = "header",
          name = Opt("opt_auto_hiding", "Auto Hiding"),
          width = "full",
        },
        {
          type = "checkbox",
          name = Opt("opt_hideincombat", "Hide viewer while in combat"),
          tooltip = Opt("opt_hideincombat_desc", "Hide all guide windows during combat."),
          getFunc = function() return GetNamedOption("hideincombat", false) end,
          setFunc = function(v) SetNamedOption("hideincombat", v) end,
          default = false,
          width = "full",
        },
        {
          type = "checkbox",
          name = Opt("opt_hideoninventory", "Hide viewer while inventory is open"),
          tooltip = Opt("opt_hideoninventory_desc", "Hide the Guide Viewer when inventory/map/options etc are opened."),
          getFunc = function() return GetNamedOption("hideoninventory", false) end,
          setFunc = function(v) SetNamedOption("hideoninventory", v) end,
          default = false,
          width = "full",
        },
        {
          type = "checkbox",
          name = Opt("opt_hideonguideconv", "Hide viewer during conversations"),
          tooltip = Opt("opt_hideonguideconv_desc", "Hide the Guide Viewer when entering conversation with npc for the current step."),
          getFunc = function() return GetNamedOption("hideonguideconv", false) end,
          setFunc = function(v) SetNamedOption("hideonguideconv", v) end,
          default = false,
          width = "full",
        },
        {
          type = "button",
          name = Opt("opt_reset", "Reset viewer"),
          tooltip = Opt("opt_reset_desc", "Reset Guide Viewer to original position and size."),
          func = function()
            if CGV.Viewer and CGV.Viewer.ResetAllViewerSettings then
              CGV.Viewer:ResetAllViewerSettings()
            end
          end,
          width = "full",
        },
        {
          type = "description",
          text = Opt("opt_general_tip_desc", "Did you know you can bind keys to control the Level Guides Viewer? Esc → Controls → Keybindings → Community Leveling Guides."),
          width = "full",
        },
      },
    },

    -----------------------------------------
    -- WAYPOINT ARROW
    -----------------------------------------
    {
      type = "submenu",
      name = Opt("opt_arrow", "Waypoint Arrow"),
      controls = {
        {
          type = "checkbox",
          name = Opt("opt_arrowshow", "Enable waypoint arrow"),
          tooltip = Opt("opt_arrowshow_desc", "Display a rotating arrow toward the current waypoint."),
          getFunc = function() return GetNamedOption("arrowshow", true) end,
          setFunc = function(v) SetNamedOption("arrowshow", v) end,
          default = true,
          width = "full",
        },
        {
          type = "checkbox",
          name = Opt("opt_arrowfreeze", "Lock arrow in place"),
          tooltip = Opt("opt_arrowfreeze_desc", "Make the pointer arrow transparent to mouse clicks."),
          getFunc = function() return GetNamedOption("arrowfreeze", false) end,
          setFunc = function(v) SetNamedOption("arrowfreeze", v) end,
          default = false,
          width = "full",
        },
        {
          type = "header",
          name = Opt("opt_arrow_display", "Arrow look and feel:"),
          width = "full",
        },
        {
          type = "colorpicker",
          name = Opt("opt_arrowcolor", "Arrow color"),
          tooltip = Opt("opt_arrowcolor_desc", "Color of the in-world waypoint arrow."),
          getFunc = function()
            local c = GetNamedOption("arrowcolor", ARROW_ORANGE)
            return c.r or 1, c.g or 1, c.b or 1, c.a or 1
          end,
          setFunc = function(r, g, b, a)
            SetNamedOption("arrowcolor", { r = r, g = g, b = b, a = a or 1 })
          end,
          default = ARROW_ORANGE,
          width = "full",
        },
        {
          type = "checkbox",
          name = Opt("opt_arrowcolordist", "Color by distance"),
          tooltip = Opt("opt_arrowcolordist_desc", "Color the arrow by distance, instead of by direction."),
          getFunc = function() return GetNamedOption("arrowcolordist", false) end,
          setFunc = function(v) SetNamedOption("arrowcolordist", v) end,
          default = false,
          width = "full",
        },
        {
          type = "slider",
          name = Opt("opt_arrowalpha", "Opacity"),
          tooltip = Opt("opt_arrowalpha_desc", "Set the opacity of the waypoint arrow graphic."),
          min = 30, max = 100, step = 10,
          getFunc = function()
            return zo_round((GetNamedOption("arrowalpha", 1) or 1) * 100)
          end,
          setFunc = function(pct) SetNamedOption("arrowalpha", (pct or 100) / 100) end,
          default = 100,
          width = "half",
        },
        {
          type = "slider",
          name = Opt("opt_arrowscale", "Scale"),
          tooltip = Opt("opt_arrowscale_desc", "Set the size of the waypointing arrow."),
          min = 50, max = 200, step = 10,
          getFunc = function()
            return zo_round((GetNamedOption("arrowscale", 1) or 1) * 100)
          end,
          setFunc = function(pct) SetNamedOption("arrowscale", (pct or 100) / 100) end,
          default = 100,
          width = "half",
        },
        {
          type = "slider",
          name = Opt("opt_arrowfontsize", "Arrow font size"),
          tooltip = Opt("opt_arrowfontsize_desc", "Set the size of the labels under the arrow."),
          min = 7, max = 16, step = 1,
          getFunc = function() return GetNamedOption("arrowfontsize", 12) end,
          setFunc = function(v) SetNamedOption("arrowfontsize", v) end,
          default = 12,
          width = "full",
        },
        {
          type = "checkbox",
          name = Opt("opt_arrowmeters", "Use metric system"),
          tooltip = Opt("opt_arrowmeters_desc", "Use meters and kilometers instead of yards and miles."),
          getFunc = function() return GetNamedOption("arrowmeters", false) end,
          setFunc = function(v) SetNamedOption("arrowmeters", v) end,
          default = false,
          width = "full",
        },
        {
          type = "button",
          name = Opt("opt_arrow_reset", "Reset Waypointer"),
          tooltip = Opt("opt_arrow_reset_desc", "Reset the Waypointer to its original position and size."),
          func = function()
            if CGV.Pointer and CGV.Pointer.ResetWaypointerSettings then
              CGV.Pointer:ResetWaypointerSettings()
            end
          end,
          width = "full",
        },
        {
          type = "header",
          name = Opt("opt_additional_arrow_functions", "Additional arrow functions:"),
          width = "full",
        },
        {
          type = "checkbox",
          name = Opt("opt_hidearrowwithguide", "Hide waypoint arrow when viewer is closed"),
          tooltip = Opt("opt_hidearrowwithguide_desc", "Make the arrow follow the guide window's visibility."),
          getFunc = function() return GetNamedOption("hidearrowwithguide", true) end,
          setFunc = function(v) SetNamedOption("hidearrowwithguide", v) end,
          default = true,
          width = "full",
        },
      },
    },

    -----------------------------------------
    -- EXTRAS
    -----------------------------------------
    {
      type = "submenu",
      name = Opt("opt_extras", "Extras"),
      controls = {
        {
          type = "checkbox",
          name = Opt("opt_showmapbutton", "Enable Community toggle button"),
          tooltip = Opt("opt_showmapbutton_desc", "Show the Community button that toggles the viewer."),
          getFunc = function() return GetNamedOption("showmapbutton", true) end,
          setFunc = function(v) SetNamedOption("showmapbutton", v) end,
          default = true,
          width = "full",
        },
        {
          type = "checkbox",
          name = Opt("opt_bugreports", "Show bug report button"),
          tooltip = Opt("opt_bugreports_desc", "Show the bug icon on the Guide Viewer."),
          getFunc = function() return GetNamedOption("bugreports", true) end,
          setFunc = function(v) SetNamedOption("bugreports", v) end,
          default = true,
          width = "full",
        },
        {
          type = "checkbox",
          name = Opt("opt_unloadunusedguides", "Unload unused guides"),
          tooltip = Opt("opt_unloadunusedguides_desc", "Free memory by dropping step data for unused guides."),
          getFunc = function() return GetNamedOption("unloadunusedguides", true) end,
          setFunc = function(v) SetNamedOption("unloadunusedguides", v) end,
          default = true,
          width = "full",
        },
      },
    },

    -----------------------------------------
    -- PROFILES
    -----------------------------------------
    {
      type = "submenu",
      name = Opt("opt_profile", "Profiles"),
      controls = {
        {
          type = "description",
          text = Opt("opt_lam_profile_intro", "Create, switch, copy, or delete settings profiles. Same SavedVariables as Home → Profiles."),
          width = "full",
        },
        {
          type = "dropdown",
          name = Opt("opt_existing_profiles", "Current Profile"),
          tooltip = Opt("opt_existing_profiles_desc", "Select a profile to switch to it."),
          choices = SortedProfileNames(),
          getFunc = GetCurrentProfileName,
          setFunc = SwitchProfile,
          width = "full",
          scrollable = true,
          reference = REF_CURRENT,
        },
        {
          type = "editbox",
          name = Opt("opt_lam_profile_new_name", "New profile name"),
          tooltip = Opt("opt_lam_profile_new_name_desc", "Letters, numbers, and spaces only. Click New Profile after typing a name."),
          getFunc = function() return newProfileNameDraft end,
          setFunc = function(text) newProfileNameDraft = text or "" end,
          isMultiline = false,
          width = "full",
        },
        {
          type = "button",
          name = Opt("opt_newprof", "New Profile"),
          tooltip = Opt("opt_newprof_desc", "Create a new profile from the name above and switch to it."),
          func = CreateProfileFromDraft,
          width = "full",
        },
        {
          type = "dropdown",
          name = Opt("opt_copy_profile_settings", "Copy settings from"),
          tooltip = Opt("opt_copy_profile_settings_desc", "Copy options from another profile into the current profile."),
          choices = CopyProfileChoices(),
          getFunc = CopyProfileGet,
          setFunc = function(name)
            local none = Opt("opt_lam_profile_none", "(no other profiles)")
            local placeholder = Opt("opt_copy_profile_settings_default", "Choose a profile...")
            if not name or name == none or name == placeholder then return end
            CopyFromProfile(name)
          end,
          width = "full",
          scrollable = true,
          reference = REF_COPY,
        },
        {
          type = "dropdown",
          name = Opt("opt_delete_profiles", "Delete Profiles"),
          tooltip = Opt("opt_delete_profiles_desc", "Select a profile to delete. Cannot delete your current profile."),
          choices = DeleteProfileChoices(),
          getFunc = DeleteProfileGet,
          setFunc = function(name)
            local none = Opt("opt_lam_profile_none", "(no other profiles)")
            local placeholder = Opt("opt_delete_profiles_default", "Profiles")
            if not name or name == none or name == placeholder then return end
            DeleteProfileByName(name)
          end,
          width = "full",
          scrollable = true,
          reference = REF_DELETE,
          warning = Opt("opt_lam_profile_delete_warn", "Deletion is permanent. Switch away from a profile before deleting it."),
        },
      },
    },

    -----------------------------------------
    -- MODES (+ optional DEV tools)
    -----------------------------------------
    {
      type = "header",
      name = Opt("opt_lam_modes", "Modes"),
      width = "full",
    },
    {
      type = "checkbox",
      name = Opt("opt_creator_mode", "Creation Mode"),
      tooltip = Opt("opt_creator_mode_desc", "Enable guide-author tools. Same as /cgv creator. Character-specific."),
      getFunc = function() return GetCharFlag("creator", false) end,
      setFunc = SetCreatorMode,
      default = false,
      width = "full",
    },
    {
      type = "checkbox",
      name = Opt("opt_developer_mode", "Developer Mode"),
      tooltip = Opt("opt_developer_mode_desc", "Enable developer tools. Same as /cgv developer. Character-specific."),
      getFunc = function() return GetCharFlag("developer", false) end,
      setFunc = SetDeveloperMode,
      default = false,
      warning = Opt("opt_developer_mode_warning", "Reload UI (/reloadui) for Developer options to appear in Full Settings."),
      width = "full",
    },
    {
      type = "checkbox",
      name = "Debug Mode",
      tooltip = Opt("opt_debug_desc", "Extra debug output (Developer)."),
      getFunc = function() return GetNamedOption("debug", false) end,
      setFunc = function(v) SetNamedOption("debug", v) end,
      default = false,
      disabled = function() return not CGV.DEV end,
      width = "full",
    },
    {
      type = "button",
      name = "Survey maps",
      tooltip = "Survey maps (Developer).",
      func = function()
        if CGV.Pointer and CGV.Pointer.SurveyAllMaps then
          CGV.Pointer:SurveyAllMaps()
        end
      end,
      disabled = function() return not CGV.DEV end,
      width = "half",
    },
    {
      type = "button",
      name = "Survey maps (deep)",
      tooltip = "Deep survey maps (Developer).",
      func = function()
        if CGV.Pointer and CGV.Pointer.SurveyAllMaps then
          CGV.Pointer:SurveyAllMaps(true)
        end
      end,
      disabled = function() return not CGV.DEV end,
      width = "half",
    },
  }

  LAM:RegisterAddonPanel(PANEL_ID, panelData)
  LAM:RegisterOptionControls(PANEL_ID, optionsTable)

  CGV.AddonSettingsPanelId = PANEL_ID
  CGV:Debug("&startup Registered LibAddonMenu panel: Community Leveling Guide (full mirror)")
end

tinsert(CGV.startups, function()
  RegisterWithLAM()
end)
