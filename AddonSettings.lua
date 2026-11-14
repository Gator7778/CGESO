-----------------------------------------
-- ESO ADDON SETTINGS (LibAddonMenu-2.0)
-- Lists "Community Leveling Guide" under Esc → Settings → Addons
-- and mirrors key options; full UI remains GuideMenu Settings.
-----------------------------------------

local CGV = _G.CGV
local tinsert = table.insert

-- Options localization (GuideViewer "Option" table → CGV.O)
local function Opt(key, fallback)
  local O = CGV.O
  if O and O[key] then return O[key] end
  return fallback
end

local PANEL_ID = "CGESO_AddonSettings"

local function GetProfile()
  return CGV.db and CGV.db.profile
end

-- Prefer updating through the Option object so GuideMenu controls stay in sync when open.
local function SetProfileOption(optname, value)
  local opt = CGV.db and CGV.db.GetOptionObject and CGV.db:GetOptionObject(optname)
  if opt and opt.frame and opt.frame.SetValue then
    opt.frame:SetValue(value)
  elseif opt and opt.SetValue then
    opt:SetValue(value)
  else
    local profile = GetProfile()
    if profile then
      profile[optname] = value
    end
  end
end

local function GetProfileOption(optname, default)
  local profile = GetProfile()
  if not profile then return default end
  local v = profile[optname]
  if v == nil then return default end
  return v
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

-- Same saved vars / live flags as /cgv creator and /cgv developer
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

-----------------------------------------
-- PROFILES (create / switch / copy / delete)
-----------------------------------------

local newProfileNameDraft = ""

-- LAM2 dropdowns require non-empty choices AND getFunc() ∈ choices.
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

-- Action dropdowns (copy / delete): choices always include the selected getFunc value.
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
  local choices = CopyProfileChoices()
  return choices[1]
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
  local choices = DeleteProfileChoices()
  return choices[1]
end

-- LAM2 requires choices to be a table (not a function). Refresh via control references.
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
      text = Opt("opt_lam_intro", "Quick settings for Community Leveling Guide. Use Open Full Settings for the complete options UI."),
      width = "full",
    },
    {
      type = "button",
      name = Opt("opt_lam_open_full", "Open Full Settings"),
      tooltip = Opt("opt_lam_open_full_desc", "Open the Community Leveling Guide settings window (Guide Viewer, Waypoint Arrow, and more)."),
      func = function()
        if CGV.Settings and CGV.Settings.OpenSettings then
          CGV.Settings:OpenSettings()
        end
      end,
      width = "full",
    },
    {
      type = "header",
      name = Opt("opt_viewer", "Guide Viewer"),
      width = "full",
    },
    {
      type = "checkbox",
      name = Opt("opt_showviewer", "Enable Guide Viewer"),
      tooltip = Opt("opt_showviewer_desc", "Show the Guide Viewer window."),
      getFunc = function() return GetProfileOption("showviewer", true) end,
      setFunc = function(v)
        SetProfileOption("showviewer", v)
        if CGV.Viewer and CGV.Viewer.ShowIf_GuideViewer then
          CGV.Viewer:ShowIf_GuideViewer(v)
        end
      end,
      default = true,
      width = "full",
    },
    {
      type = "slider",
      name = Opt("opt_opacitymain", "Opacity"),
      tooltip = Opt("opt_opacitymain_desc", "Opacity of the Guide Viewer backdrop."),
      min = 0,
      max = 100,
      step = 1,
      getFunc = function()
        return zo_round((GetProfileOption("opacitymain", 0.20) or 0.20) * 100)
      end,
      setFunc = function(pct)
        SetProfileOption("opacitymain", (pct or 0) / 100)
        if CGV.Viewer and CGV.Viewer.SetAlpha then
          CGV.Viewer:SetAlpha((pct or 0) / 100)
        end
      end,
      default = 20,
      width = "full",
    },
    {
      type = "header",
      name = Opt("opt_arrow", "Waypoint Arrow"),
      width = "full",
    },
    {
      type = "checkbox",
      name = Opt("opt_arrowshow", "Enable waypoint arrow"),
      tooltip = Opt("opt_arrowshow_desc", "Display a rotating arrow toward the current waypoint."),
      getFunc = function() return GetProfileOption("arrowshow", true) end,
      setFunc = function(v)
        SetProfileOption("arrowshow", v)
        if CGV.Pointer and CGV.Pointer.UpdateArrowVisibility then
          CGV.Pointer:UpdateArrowVisibility()
        end
      end,
      default = true,
      width = "full",
    },
    {
      type = "colorpicker",
      name = Opt("opt_arrowcolor", "Arrow color"),
      tooltip = Opt("opt_arrowcolor_desc", "Color of the in-world waypoint arrow."),
      getFunc = function()
        local c = GetProfileOption("arrowcolor", { r = 245 / 255, g = 93 / 255, b = 7 / 255, a = 1 })
        return c.r or 1, c.g or 1, c.b or 1, c.a or 1
      end,
      setFunc = function(r, g, b, a)
        SetProfileOption("arrowcolor", { r = r, g = g, b = b, a = a or 1 })
        -- Tint updates live on the next arrow SetAngle; no position refresh needed.
      end,
      default = { r = 245 / 255, g = 93 / 255, b = 7 / 255, a = 1 },
      width = "full",
    },
    {
      type = "header",
      name = Opt("opt_profile", "Profiles"),
      width = "full",
    },
    {
      type = "description",
      text = Opt("opt_lam_profile_intro", "Create, switch, copy, or delete settings profiles. The same controls are under Profiles in Full Settings."),
      width = "full",
    },
    {
      type = "dropdown",
      name = Opt("opt_existing_profiles", "Current Profile"),
      tooltip = Opt("opt_existing_profiles_desc", "Select a profile to switch to it. Some settings may require a reload to display correctly."),
      -- LAM2 needs a real table here (functions break widget creation).
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
      tooltip = Opt("opt_copy_profile_settings_desc", "Copy options from another profile (including backups after an update) into the current profile. Does not delete the source."),
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
    {
      type = "header",
      name = Opt("opt_lam_modes", "Modes"),
      width = "full",
    },
    {
      type = "checkbox",
      name = Opt("opt_creator_mode", "Creation Mode"),
      tooltip = Opt("opt_creator_mode_desc", "Enable guide-author tools: print achieve/lorebook lines for guide writing. Same as /cgv creator. Character-specific."),
      getFunc = function() return GetCharFlag("creator", false) end,
      setFunc = SetCreatorMode,
      default = false,
      width = "full",
    },
    {
      type = "checkbox",
      name = Opt("opt_developer_mode", "Developer Mode"),
      tooltip = Opt("opt_developer_mode_desc", "Enable developer tools: extra debug output, map surveying helpers, and Developer options in Full Settings after reload. Same as /cgv developer. Character-specific."),
      getFunc = function() return GetCharFlag("developer", false) end,
      setFunc = SetDeveloperMode,
      default = false,
      warning = Opt("opt_developer_mode_warning", "Reload UI (/reloadui) for Developer options to appear in Full Settings."),
      width = "full",
    },
  }

  LAM:RegisterAddonPanel(PANEL_ID, panelData)
  LAM:RegisterOptionControls(PANEL_ID, optionsTable)

  CGV.AddonSettingsPanelId = PANEL_ID
  CGV:Debug("&startup Registered LibAddonMenu panel: Community Leveling Guide")
end

tinsert(CGV.startups, function()
  RegisterWithLAM()
end)
