-----------------------------------------
-- LOCALIZED GLOBAL VARIABLES
-----------------------------------------

local CGV = _G.CGV
local GuideProto = {}
local Guide = CGV.Class:New("Guide")
local Guide_mt = { __index=Guide }
local tinsert,_,_,min,max,floor,type,_,ipairs,_ = table.insert,table.remove,table.sort,math.min,math.max,math.floor,type,pairs,ipairs,_G.class
local L = CGV.L
local Utils = CGV.Utils

-----------------------------------------
-- SAVED REFERENCES
-----------------------------------------

CGV.GuideProto = GuideProto

GuideProto.Types 	= {
						LEVELING = 1,
						TEST = 99,
					}

GuideProto.SubTypes = {
						TRI = 0,
						TAM = 1,
						MOR = 2,
					}
GuideProto.Sides 	= {
						AD = 1,
						DC = 2,
						EP = 3,
					}

-----------------------------------------
-- GUIDEPROTO FUNCTIONS
-----------------------------------------

function GuideProto:New(title,data,extra)
	local path,tit = title:match("^(.*)/+(.-)$")
	local guidetype = path:match("^(.-)/") or path

	local guide = {
		title = title,
		title_short = tit or title,
		rawdata = data,
		extra = extra,
		num = #CGV.registeredguides+1,
		parsed = nil,
		fully_parsed = nil,
		type = guidetype,
		subtype = 0 or CGV.GuideMenuTier
	}

	-- Always step-based progress. ESO quests scale with character (One Tamriel) — no level gating.
	guide.completionmode = guide.completionmode or "steps"

	if CGV:NeedsAnimatedPopup(guide) then
		CGV.AnimatePopup = true
		return nil
	end

	setmetatable(guide,Guide_mt)
	return guide
end

-----------------------------------------
-- GUIDE CLASS FUNCTIONS
-----------------------------------------

function Guide:Parse(fully)
	if not self.rawdata or (self.parsed and self.fully_parsed) then return end
	if self.parse_failed then return end

	if fully then
		GuideProto:Debug("Parsing guide: "..self.title)
	end

	local lastparsed = { linenum =- 2,linedata = "-?-" }
	local success,parsed,err,linenum,stepnum,linedata = pcall(CGV.Parser.ParseEntry,CGV.Parser,self,fully,lastparsed)

	if not success then
		linenum,stepnum,linedata = lastparsed.linenum or -1, -1, lastparsed.linedata or "--"
	end

	if CGV.sv and CGV.sv.profile and CGV.sv.profile.ignoreErrors then -- Allow loading still, but make sure the message gets spat out.
		if not parsed then
			if err then
				CGV:Error(L["message_errorloading_full"],self.title,linenum or 0,stepnum or "?",linedata or "???",err)
			else
				CGV:Error(L["message_errorloading_brief"],self.title)
			end
		end
		parsed = true
	end

	if not success then -- crashed!
		local err = parsed

		local errortext = L["message_errorloading_critical"]:format(self.title or "no title?",err or "no err?",linenum or -1,linedata or -1)
		CGV:Error(("%s"):format(errortext))
		self.parse_failed = true
		self.parse_error = errortext
		return nil

	elseif not parsed then -- just failed
		local errortext
		local line = _G.line
		if err then
			errortext = L["message_errorloading_full"]:format(self.title,line or 0,stepnum or "?",linedata or "???",err)
		else
			errortext = L["message_errorloading_brief"]:format(self.title)
		end
		CGV:Error(("%s"):format(errortext))
		self.parse_failed = true
		self.parse_error = errortext
		return nil

	else
		self.parsed = true

		if self.steps and (#self.steps>0) then
			self.fully_parsed = true

			-- cap it with a finisher step
			local step = CGV.StepProto:New()
			step.finish = true
			local goal = CGV.GoalProto:New()
			goal.action = "text"
			goal.text = "This guide is now complete."

			step:AddGoal(goal)
			self:AddStep(step)

			self.steplabels = {}
			for si,steps in ipairs(self.steps) do
				local label = steps.label
				if label then
					if not self.steplabels[label] then
						self.steplabels[label] = {}
					end
					tinsert(self.steplabels[label],si)
				end
			end
		end
	end

end


function Guide:DoCond(which,...)
	-- No startlevel/endlevel gates — ESO quests scale with character.
	-- Custom condition_* scripts still apply when present.
	if which == "valid" and not self.condition_valid then
		return true
	end

	if which == "suggested" and not self.condition_suggested then
		-- Without an explicit suggested script, treat leveling/extras as suggested when valid.
		return self.type == "LEVELING" or self.type == "Extras"
	end

	if which == "end" and not self.condition_end then
		-- Complete only via steps / explicit end condition — never by character level.
		return false
	end

	if which and self['condition_'..which] then
		local isOK,err = pcall(self['condition_'..which],self,...)
		if isOK then
			return err,self['condition_'..which..'_msg']
		else
			CGV:Print("ERROR parsing condition for guide:\n"..self.title.."\n"..self['condition_'..which.."_raw"].."\nError: "..err)
			return false,"ERROR: "..(self['condition_'..which..'_msg'] or "")
		end
	end
end

function Guide:GetStatus()
	local ret,msg

	ret,msg = self:DoCond("invalid")
	if ret then 
		return "INVALID",msg 
	end

	ret,msg = self:DoCond("valid")
	if ret then
		ret,msg = self:DoCond("end")
		if ret then
			return "COMPLETE",msg
		end
		msg = "" -- end condition message is not valid when the guide is still in progress

		if self.condition_suggested_raw or self.type=="LEVELING" then
			ret,msg = self:DoCond("suggested")
			if ret then
				return "SUGGESTED" 
			end
		end

		return "VALID",msg
	else
		return "INVALID",msg
	end
end

function Guide:Load(step)
  CGV:SetGuide(self,step)
end

-- Cached lowercase quest names from rawdata (|q / accept / turnin). Avoids :lower() on full guides.
function Guide:GetQuestSearchText()
  if self._questSearchText ~= nil then return self._questSearchText end

  local raw = self.rawdata
  if not raw or raw == "" then
    self._questSearchText = ""
    return self._questSearchText
  end

  local names, seen = {}, {}
  local function add(name)
    name = name and name:match("^%s*(.-)%s*$")
    if not name or name == "" or seen[name] then return end
    seen[name] = true
    names[#names + 1] = name
  end

  for name in raw:gmatch("|q ([^/|\r\n]+)") do add(name) end
  for name in raw:gmatch("accept ([^\r\n|]+)") do add(name) end
  for name in raw:gmatch("turnin ([^\r\n|]+)") do add(name) end

  self._questSearchText = table.concat(names, "\n"):lower()
  return self._questSearchText
end

-- needle should already be trimmed + lowercased (see GuideMenu:GetSearchNeedle).
function Guide:MatchesSearch(needle)
  if not needle or needle == "" then return true end

  if (self.title or ""):lower():find(needle, 1, true) then return true end
  if (self.title_short or ""):lower():find(needle, 1, true) then return true end

  local desc = self.description
  if desc and desc:lower():find(needle, 1, true) then return true end

  local quests = self:GetQuestSearchText()
  return quests ~= "" and quests:find(needle, 1, true) ~= nil
end

-- Drop parsed step/goal tables to free memory. Metadata (title, next, rawdata) stays.
-- Next time this guide is selected, SetGuide → Parse(true) rebuilds steps (brief hitch).
function Guide:Unload()
  if not self.fully_parsed and not self.steps then
    return
  end

  GuideProto:Debug("Unloading guide steps: "..tostring(self.title))

  self.steps = nil
  self.steplabels = nil
  self.fully_parsed = nil
  -- Keep self.parsed / header fields so the guide still appears in menus.
  -- Parse(true) will rebuild steps because fully_parsed is clear.

  if collectgarbage then
    collectgarbage("step", 200)
  end
end

function Guide:SetAsCurrent()
  CGV.CurrentGuide = self
  CGV.CurrentGuideName = self.title
  CGV.sv.char.guidename = self.title

  -- Clear this stuff because it gets set after
  CGV.CurrentStep = nil
  CGV.CurrentStepNum = nil
end

function Guide:GetCurStep()
  return self:GetStep(CGV.CurrentStepNum)
end

function Guide:GetStep(num)
  if not num then return end
  return self.steps[num]
end

function Guide:AddStep(step)
  step.parentGuide = self
  step.num = #self.steps+1

  tinsert(self.steps,step)
end

function Guide:GetFirstValidStep(start)
	if not self.fully_parsed then return end
	start = start or 1
	local startstep = self:GetStep(start)
	if start ~= 1 and not startstep then
		return self:GetFirstValidStep(1)
	end

	assert(startstep,"GetFirstValidStep: no starting step at 1?? what the hell??")

	-- starting step is good?
	if startstep:AreRequirementsMet() then
		return startstep
	end

	-- no? let's go forward...
	local nextvalid = startstep:GetNextValidStep()
	if nextvalid then
		return nextvalid
	end

	if start ~= 1 then
		return self:GetFirstValidStep(1)
	end -- restart at 1, maybe that helps

	return self.steps[1] -- always returns something, or breaks.
end

function Guide:GetCompletion(mode)
	mode = mode or self.completionmode

	if self.parse_failed then
		return "error","parsing failed"
	end

	if mode == "steps" then
		-- request full parsing for those
		if not self.fully_parsed then
			CGV:Debug("Guide:GetCompletion : '"..self.title.."' needs parsing for completion type '"..mode.."'")
			return "loading"
		end
	end

	if mode == "none" then
		return "none"

	elseif mode == "level" then
		-- Legacy mode: fall through to steps (quests scale; level progress is meaningless).
		return self:GetCompletion("steps")

	elseif mode == "steps" then
		local count,comp = 0,0
		local prevStepComp = true	-- Start as true, there is no previous step to the first step.
		local curStepComp = self.steps[1]:IsComplete(1)
		local nextStepComp

		for si = 1, #self.steps do
			local step = self.steps[si]
			local nextstep = self.steps[si+1]

			if not nextstep then -- If no next step just true it.
				nextStepComp = true
			else
				nextStepComp = nextstep:IsComplete(1)
			end

			if step:AreRequirementsMet() -- Valid step?
			and not step.finish	-- Not last step
			then
				count = count + 1
				if curStepComp then	-- If this step is complete, easy
					comp = comp + 1
				elseif (prevStepComp and nextStepComp) then -- If the steps on both sides of this step are complete, lets say this step is complete. Rough, but for progress bar.
					comp = comp + 1
				end
			end

			-- going to next step, adjust variables.
			prevStepComp = curStepComp
			curStepComp = nextStepComp
		end

		return count > 0 and comp / count or 0, comp,count
	end
	-- other completions might not need a full parse.
	return "error","we don't know if this guide completes or not"
end

-- Returns percentage in text form #%, a description, and a numeric percent for ease of use.
function Guide:GetCompletionText(mode)
	mode = mode or self.completionmode
	local comp,a,b,_,_ = self:GetCompletion(mode)
	assert(comp) -- Sanity!

	if comp == "loading" then
		return "...","(loading)", 0
	end
	if comp == "error" or type(comp) ~= "number" then
		return "?",("(an error occurred: %s)"):format(a or "black magic"), 0
	end

	comp = floor(comp*100)

	if mode == "none" then
		return "-", "This guide does not complete.", comp
	elseif mode == "level" or mode == "steps" then
		return comp.."%", ("Steps completed: %d/%d"):format(a,b), comp
	else
		return comp.."%", "", comp
	end
end

function Guide:AdvertiseWithPopup(nodelay)
	if not (CGV.Frame and CGV.Frame:IsShown()) then return end -- If CGV is hidden then we don't need to be suggesting guides.

	local delay = not nodelay

	-- Don't suggest a guide while in combat. Wait until combat is done.
	if delay and Utils.IsPlayerInCombat() then
		CGV.call_after_combat = function()
			self:AdvertiseWithPopup(true)
		end
		CGV:Print(L['guide_next_ready'])

		return
	end

	-- If Full and MQO both exist and style is unset/ask, choose style first.
	local fullGuide, mqoGuide = CGV:GetGuideStylePair(self)
	local style = CGV:GetGuideStylePreference()
	if fullGuide and mqoGuide and style == "ask" then
		CGV:PromptGuideStyleOrLoad(self)
		return
	end

	local target = CGV:GetPreferredGuideVariant(self) or self

	local popup = CGV.AdvertisePopup
	if not popup then
		-- This text hides unless needed
		popup = CGV.Popup:New("Community_AdvertiseGuide_Popup","sis")
		popup:EnableGuideViewerAnchor()

		popup.OnAccept = function(me)
			CGV:SetGuide(me.guide, me.guide.CurrentStepNum or 1)
		end

		popup.OnDecline = function(me)
			CGV.db.char.ignoredguides[me.guide.title] = true
		end

		CGV.AdvertisePopup = popup
	elseif popup.EnableGuideViewerAnchor then
		popup:EnableGuideViewerAnchor()
	end

	-- Restore default labels (style popup may have renamed them).
	popup.acceptbutton:SetText(L['static_accept'])
	popup.declinebutton:SetText(L['static_decline'])
	if popup.acceptbutton.ResizeToPerfect then popup.acceptbutton:ResizeToPerfect() end
	if popup.declinebutton.ResizeToPerfect then popup.declinebutton:ResizeToPerfect() end

	popup:SetText(L['static_nextguide'],target.title_short,L['static_nextguide_anyzone'])
	popup:SetDimensionConstraints(225,nil,625,nil)
	popup.guide = target

	CGV.pause = true -- to avoid a loop of "step complete" clicks.

	if not CGV.AdvertisePopup:IsShown() then
		CGV.AdvertisePopup:Show()
	end
end

function Guide:tostring()
  return self.title_short
end

-----------------------------------------
-- DEBUG
-----------------------------------------

function GuideProto:Debug(...)
  local str = ...
  CGV:Debug("&guide "..str, select(2,...) )
end
