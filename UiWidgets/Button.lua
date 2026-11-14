-----------------------------------------
-- LOCALIZED GLOBAL VARIABLES
-----------------------------------------

local CGV = _G.CGV
local tinsert,tremove,sort,cginherits,min,max,floor,type,pairs,ipairs,unpack = table.insert,table.remove,table.sort,table.cginherits,math.min,math.max,math.floor,type,pairs,ipairs,unpack
local CHAIN = CGV.Utils.ChainCall
local ui = CGV.UI
local Button = CGV.Class:New("Button")
local SecButton = CGV.Class:New("SecButton")
local InvisButton = CGV.Class:New("InvisButton")
local DEFAULT_WIDTH = 80
local DEFAULT_HEIGHT = 20
local butColor = {HTMLColor("#333333ff")}
local butHLColor = {HTMLColor("#444444ff")}

local function AccentFill()
  if CGV.Theme and CGV.Theme.AccentTable then
    return CGV.Theme.AccentTable()
  end
  return {HTMLColor("#F55D07ff")}
end

local function AccentHover()
  if CGV.Theme and CGV.Theme.AccentHoverTable then
    return CGV.Theme.AccentHoverTable()
  end
  return AccentFill()
end

-----------------------------------------
-- LOAD TIME SETUP
-----------------------------------------

ui:RegisterWidget("Button",Button)
ui:RegisterWidget("SecButton",SecButton)
ui:RegisterWidget("InvisButton",InvisButton)

-----------------------------------------
-- BUTTON CLASS FUNCTIONS
-----------------------------------------

-- But with a border
function Button:New(parent,name)
  local button = CHAIN(ui:CreateControl(name,parent,CT_BUTTON,Button))
  :SetDimensions(DEFAULT_WIDTH,DEFAULT_HEIGHT)
  :SetText(" ")	-- Creates the button's label
  :SetFontSize(13)	-- Default size, also setsfont
  :SetHorizontalAlignment(TEXT_ALIGN_CENTER)
  :SetVerticalAlignment(TEXT_ALIGN_CENTER)
  :SetHandler("OnMouseEnter",function(me) me:OnEnter() end)
  :SetHandler("OnMouseExit",function(me) me:OnExit() end)
  :SetHandler("OnClicked",function(me) print("Clicked") end)
  .__END

  button.bd = ui:Create("Backdrop",button,name and name.."_BD")

  CHAIN(button)
  :SetBackdropColor(unpack(butColor))

  return button
end

-- Extra width so label text is not flush against the button edges.
local PERFECT_PAD_X = 20
local PERFECT_MIN_W = 60
-- Temporary width used so GetTextWidth is not clipped by the current button size.
local PERFECT_MEASURE_W = 2000

-- Grow/shrink the button to fit its label. Safe when text is longer than the current width
-- (the old path only measured the clipped width and never grew).
function Button:ResizeToPerfect()
  if not self._perfectSizing then return end
  if not self.GetLabelControl then return end
  local label = self:GetLabelControl()
  if not label then return end

  local text = (label.GetText and label:GetText()) or ""
  if text == "" or text == " " then return end

  -- Unclamp: widen past any prior clip so GetTextWidth returns the full string width.
  self:SetWidth(PERFECT_MEASURE_W)
  local w = (label.GetTextWidth and label:GetTextWidth()) or 0

  -- Fallback if the label still reports a clamped/bogus width.
  -- GetFont() returns a global font *name* (e.g. "CommunityFont13Bold"), not a font object —
  -- GetStringWidthScaled requires the userdata from _G[name].
  if w <= 0 or w >= PERFECT_MEASURE_W - 1 then
    local plain = text:gsub("|c%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("|t.-|t", "")
    local fontObj
    if label.GetFont then
      local font = label:GetFont()
      if type(font) == "string" then
        fontObj = _G[font]
      else
        fontObj = font
      end
    end
    if fontObj and _G.GetStringWidthScaled then
      local ok, measured = pcall(_G.GetStringWidthScaled, fontObj, plain, 1)
      if ok and measured and measured > 0 then
        w = measured
      end
    end
    -- Last resort: rough width from character count so the button still grows.
    if w <= 0 then
      local size = (self.GetFontSize and self:GetFontSize()) or 13
      w = (#plain) * (size * 0.55)
    end
  end

  self:SetWidth(max(w + PERFECT_PAD_X, PERFECT_MIN_W))
end

-- Make the button just big enough to hold the text. Updates on text and font changes.
-- Should be called before :SetText()
function Button:SetPerfectSizing(bool)
  local butLabel = self:GetLabelControl()
  self._perfectSizing = not not bool
  if bool then
    butLabel:SetHandler("OnTextChanged", function(me)
        local but = me:GetParent()
        if but and but.ResizeToPerfect then
          but:ResizeToPerfect()
        end
      end)

    -- Font size changes (e.g. live popup sync) do not fire OnTextChanged.
    if not self._perfectFontWrapped then
      self._perfectFontWrapped = true
      local prevSetFontSize = self.SetFontSize
      self.SetFontSize = function(me, size, bold)
        if prevSetFontSize then
          prevSetFontSize(me, size, bold)
        end
        me:ResizeToPerfect()
      end
    end

    self:ResizeToPerfect()
  else
    butLabel:SetHandler("OnTextChanged", nil)
  end
end

function Button:OnEnter()
  if not self.bd then return end

  self:SetBackdropColor(unpack(self._hlColor or butHLColor))
end

function Button:OnExit()
  if not self.bd then return end

  self:SetBackdropColor(unpack(self._baseColor or butColor))
end

-- Primary CTA style — brand accent fill. Easy off via Theme.USE_BRAND_ACCENT.
function Button:SetAccentStyle(enabled)
  if enabled then
    self._baseColor = AccentFill()
    self._hlColor = AccentHover()
  else
    self._baseColor = butColor
    self._hlColor = butHLColor
  end
  if self.bd then
    self:SetBackdropColor(unpack(self._baseColor))
  end
  return self
end

function Button:SetAllFontColor(r,g,b,a)
  CHAIN(self)
  :SetNormalFontColor(r,g,b,a)
  :SetDisabledFontColor(r,g,b,a)
  :SetPressedFontColor(r,g,b,a)
  :SetMouseOverFontColor(r,g,b,a)
end

-----------------------------------------
-- SECBUTTON CLASS FUNCTIONS
-----------------------------------------

-- But without a border
function SecButton:New(parent,name)
  local button = CHAIN(ui:CreateControl(name,parent,CT_BUTTON,SecButton))
  :SetDimensions(DEFAULT_WIDTH,DEFAULT_HEIGHT)
  :SetText(" ")	-- Creates the button's label
  :SetFontSize(13)	-- Default size, also setsfont
  :SetHorizontalAlignment(TEXT_ALIGN_CENTER)
  :SetVerticalAlignment(TEXT_ALIGN_CENTER)
  :SetHandler("OnMouseEnter",function(me) me:OnEnter() end)
  :SetHandler("OnMouseExit",function(me) me:OnExit() end)
  :SetHandler("OnClicked",function(me) print("Clicked") end)
  .__END

  button.bd = ui:Create("SecBackdrop",button,name and name.."_BD")

  CHAIN(button)
  :SetBackdropColor(unpack(butColor))

  return button
end

-----------------------------------------
-- INVISBUTTON CLASS FUNCTIONS
-----------------------------------------

-- but without a backdrop
function InvisButton:New(parent,name)
  local button = CHAIN(ui:CreateControl(name,parent,CT_BUTTON,InvisButton))
  :SetText(" ")	-- Creates the button's label.
  :SetFontSize(13)
  :SetHorizontalAlignment(TEXT_ALIGN_CENTER)
  :SetVerticalAlignment(TEXT_ALIGN_CENTER)
  :SetHandler("OnMouseEnter",function(me) me:OnEnter() end)
  :SetHandler("OnMouseExit",function(me) me:OnExit() end)
  :SetHandler("OnClicked",function(me) print("Clicked") end)
  .__END

  return button
end

-----------------------------------------
-- INHERITANCE
-----------------------------------------

ui:InheritClass(Button,"Backdrop")
ui:InheritClass(SecButton,Button)
ui:InheritClass(InvisButton,Button)
