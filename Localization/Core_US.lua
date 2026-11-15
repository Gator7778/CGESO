-----------------------------------------
-- INFORMATION
-- 	Loaded before CGESO.lua
-- 	Options get put in "Option" instead of in the main group. No reason to comingle them.
-----------------------------------------

-----------------------------------------
-- LOCALIZED GLOBAL VARIABLES
-----------------------------------------

local type,pairs,ipairs = type,pairs,ipairs
local GuideViewer = _G.GuideViewer
local COLOR_TIP_MOUSE = "|cddff00"
local plurals = {
	Ballista = "Ballistae",
	Bark = 1,
	Briarthorn = 1,
	Blood = 1,
	Bruiseweed = 1,
	Cargo = 1,
	Child = "Children",
	Chutney = 1,
	Dirt = 1,
	Down = 1,
	Dreamfoil = 1,
	drunk = 1,
	Dust = 1,
	Earth = 1,
	Felsworn = 1,
	Felweed = 1,
	Ferocious = 1,
	Flesh = 1,
	Flour = 1,
	Gizmo = "Gizmos",
	Glory = 1,
	Gromsblood = 1,
	Grow = 1,
	Harvest = 1,
	Heartwood = 1,
	Honey = 1,
	Ichor = 1,
	Infantry = 1,
	Kingsblood = 1,
	Leather = 1,
	Lumber = 1,
	Lotus = "Lotuses",
	Mageroyal = 1,
	Meat = 1,
	Milk = 1,
	Mogu = 1,
	mogu = 1,
	Mojo = 1,
	Nitroglycerin = 1,
	Nitrate = 1,
	Oil = 1,
	Ore = 1,
	Port = 1,
	Prey = 1,
	Pulp = 1,
	Rice = 1,
	Sap = 1,
	Silk = 1,
	Snuff = 1,
	Spawn = 1,
	Stuff = 1,
	Supplies = 1,
	Talisman = "Talismans",
	Tooth = "Teeth",
	Topaz = 1,
	Truegold = 1,
	Venom = 1,
	Vermin = 1,
	Venison = 1,
	Vrykul = 1,
	Water = 1,
	wildlife = 1,
	Witchban = 1,
	Worgen = 1,
	Wood = 1
}

local specials = {
	{'in a duel',1},
	{'Scarlet Crusader slain',"Scarlet Crusaders"},
	{'Citizen of Havenshire slain',"Citizens of Havenshire"},
	{'Garm Invader slain',"Garm Invaders"},
	{'En\'kilah Casualty',"En'kilah mobs"},
	{'(.*) [sS]lain$',"%1"},
	{'(.*) Weed$',"%1 Weeds"},
	{'Smelt ',1},
	{'Miners\' Gear',1},
	{'Miracle%-Grow',1},
}

local wordspecials = {
	['haman$']="hamans",
	['(%a)man$']="%1men",
	['(%a)us$']="%1i",
	['%a*[fF]ish$']=1,
	['%a*[cC]loth$']=1,
}

-----------------------------------------
-- FUNCTIONS
-----------------------------------------
GuideViewer("Main", "enUS", function() local f = {

			-- GENERAL
			["name"] = "|cff8800Leveling Guides|r",

			-- STARTUP
			['welcome_guides'] = "%d guides are loaded.",

			["message_errorloading_full"] = "|cff4444Error|r loading guide |caaffaa%s|r\nline: %d   step: %s\ncode:|cffeeaa%s |cff0000<=====|cff8800 %s|r",
			["message_errorloading_brief"] = "|cff4444Error|r loading guide |caaffaa%s|r",
			["message_errorloading_critical"] = "|cff4444CRITICAL Error|r loading guide |caaffaa%s|r\nError: %s\nLine: %d\nData: %s",
			["message_loadedguide"] = "Activated guide: |caaffaa%s|r",
			["message_missingguide"] = "|cff4444Missing|r guide: |caaffaa%s|r",
			["title_noguide"] = "Community Leveling Guides (no guide loaded)",

			-- GUIDE VIEWER
			['guide_notselected'] = "- select a guide -",
			['guide_notloaded'] = "|cff0000- none loaded -",

			-- PROGRESS BAR
			['frame_guide_none'] = "No guide loaded",
			['frame_guide_step'] = "Step: %d/%d",
			['frame_guide_switch_level'] = "|cffff00Click|c00ff00 to switch to level based.",
			['frame_guide_switch_step'] = "|cffff00Click|c00ff00 to switch to step based.",
			['frame_guide_maxlevel'] = "Max level reached!",
			['frame_guide_complete'] = "Guide complete!",
			['frame_guide_progress'] = "Guide progress: %d%%",

			-- GUIDE MESSAGES
			['guide_level_req'] = "Level %s or higher is required.",
			['guide_level_reached'] = "Level %s reached",
			['guide_next_ready'] = "Next guide is ready. Just finish your combat.",

			-- GOAL STRINGS
			["questtitle"] = "`%s'",
			["coords"] = "%d,%d",
			["map_coords"] = "%s %d,%d",
			["completion_goal"] = "(%s/%s)",

			["stepgoal_accept"] = "Accept %s",
			["stepgoal_accept_done"] = "Accepted %s",
			["stepgoal_turnin"] = "Turn in %s",
			["stepgoal_turnin_done"] = "Turned in %s",
			["stepgoal_talk"] = "Talk to %s",
			["stepgoal_talk_done"] = "Talked to %s",
			["stepgoal_goto"] = "Go to %s",
			["stepgoal_go to_leave"] = "Leave %s",
			["stepgoal_at_suff"] = " (%s)",
			["stepgoal_collect"] = "Collect %s",
			["stepgoal_confirm"] = "Click here to proceed",
			["stepgoal_wayshrine"] = "Discover the %s Wayshrine",
			["stepgoal_wayshrine_done"] = "Discovered the %s Wayshrine",
			["stepgoal_kill"] = "Kill %s",
			["stepgoal_kill_done"] = "Killed %s",
			["stepgoal_lorebook"] = "Read lore book: \"%s\"",
			["stepgoal_achieve"] = "Earn achievement: \"%s\"",

			-- WAYPOINTER
			["dist_km"] = "%.1f km",
			["dist_m"] = "%d m",
			['dist_mi'] = "%.1f miles",
			['dist_yd'] = "%d yd",

			-- BINDINGS
			["bind_tog"] = "Toggle Guide Viewer",
			["bind_next"] = "Next Step",
			["bind_prev"] = "Previous Step",
			["bind_waypointcycle_next"] = "Cycle multiple waypoints",
			["bind_waypointcycle_prev"] = "Cycle multiple waypoints backwards",

			-- STATIC POPUPS
			['static_accept'] = "Accept",
			['static_decline'] = "Decline",
			['static_notnow'] = "Not now",
			['static_cancel'] = "Cancel",

			['static_options'] = "Do you want to reset all settings to their defaults,or only settings on this page?",
			['static_allsetting']	= "All Settings",
			['static_thesesetting']	= "These Settings",

			['static_nextguide'] = "\nYou're now ready to proceed to:\n",
			['static_nextguide_anyzone'] = "\nThis is the recommended next zone. However, since ESO has no zone level restrictions anymore, you're free to visit any other zone and load a guide for it manually.",
			['static_guide_style'] = "\nRecommended guide:\n",
			['static_guide_style_detail'] = "\nLoad the Full leveling guide, or Main Quests Only?\nYour choice is remembered for this character (change it under Settings).\n",
			['static_guide_style_full'] = "Full Guide",
			['static_guide_style_mqo'] = "Main Quests Only",
			['static_badguide'] = "\nThe selected guide:\n|cffee00%s|r\n is |cffbbaaimproper|r for your character.\n|cff6644%s|r\n\nDo you really want to load it?",
			["static_endguide"] = "\nYou've reached the end of the current guide.",
			["static_help"] = "\nYou can set keybindings in Esc-Controls-Keybindings.\n\nPlease visit |cfe6100tinyurl.com/ESOUI-CLG|r if you need additional assistance.",

			['static_profile'] = "Switch to profile %s?",
			['static_deleteprofile'] = "Delete profile %s?",
			['static_reset_profile'] = "Reset profile %s?",
			['static_newprofile'] = "Select a name for a new profile.",
			['static_newprofile_error'] = "|cff0000Name can only contain letters, numbers, and spaces.",
			['static_profile_migrate'] = "\nYour settings profile was updated.\n",
			['static_char_migrate'] = "\nYour character settings were updated.\n",
			['static_profile_migrate_detail'] = "Copy your previous options from the backup into the new profile? Decline keeps defaults; the backup stays listed under Profiles → Copy settings from.",
			['static_copy_profile_settings'] = "Copy settings from \"%s\" into the current profile?",

			-- MINIMAP BUTTON
			["minimap_tooltip"] = COLOR_TIP_MOUSE.."Click|r to toggle guide window\n"..COLOR_TIP_MOUSE.."Right-click|r to configure\n",

			['tip_header'] = "Leveling Guides Tips",
			['tip_keybind'] = "Did you know you can bind keys to control the Level Guides Viewer?\n\nIt's far easier to navigate between steps by pressing keys, rather than have to click the buttons with your mouse.\n\nWould you like to set up your keybinds now?",
		}
		--for k,v in pairs(f) do
		--if type(v)=="string" then  f[k]=v:gsub("<<(.-)>>",COLOR_TIP_MOUSE.."%1"..COLOR_TIP)  end
		--end
		return f
end)

GuideViewer("Option", "enUS", function() local f = {

			------ ESO ADDON SETTINGS (LAM) -------
			["opt_lam_intro"] = "All settings match the in-addon Home panel and share the same SavedVariables. Use Open Full Settings for the guide list and chapter browser.",
			["opt_lam_open_full"] = "Open Full Settings",
			["opt_lam_open_full_desc"] = "Open the Community Leveling Guide settings window.",
			["opt_lam_modes"] = "Modes",
			["opt_creator_mode"] = "Creation Mode",
			["opt_creator_mode_desc"] = "Enable guide-author tools: print achieve/lorebook lines for guide writing. Same as /cgv creator. Character-specific.",
			["opt_developer_mode"] = "Developer Mode",
			["opt_developer_mode_desc"] = "Enable developer tools: extra debug output, map surveying helpers, and Developer options in Full Settings after reload. Same as /cgv developer. Character-specific.",
			["opt_developer_mode_warning"] = "Reload UI (/reloadui) for Developer options to appear in Full Settings.",
			["opt_lam_profile_intro"] = "Create, switch, copy, or delete settings profiles. The same controls are under Profiles in Full Settings.",
			["opt_lam_profile_new_name"] = "New profile name",
			["opt_lam_profile_new_name_desc"] = "Letters, numbers, and spaces only. Click New Profile after typing a name.",
			["opt_lam_profile_none"] = "(no other profiles)",
			["opt_lam_profile_switched"] = "Switched to profile %s.",
			["opt_lam_profile_created"] = "Created and switched to profile %s.",
			["opt_lam_profile_deleted"] = "Deleted profile %s.",
			["opt_lam_profile_need_name"] = "Enter a name for the new profile.",
			["opt_lam_profile_bad_name"] = "Profile name can only contain letters, numbers, and spaces.",
			["opt_lam_profile_exists"] = "Profile \"%s\" already exists.",
			["opt_lam_profile_cant_delete_current"] = "Cannot delete the current profile. Switch first.",
			["opt_lam_profile_delete_warn"] = "Deletion is permanent. Switch away from a profile before deleting it.",

			------ VIEWER -------
			["opt_viewer"] = "Guide Viewer",
			["opt_viewer_desc"] = "",

			["opt_showviewer"] = "Enable Guide Viewer",
			["opt_showviewer_desc"] = "Show the Guide Viewer window.",

			["opt_opacitymain"] = "Opacity",
			["opt_opacitymain_desc"] = "Opacity of the Guide Viewer backdrop (0%–100%). Lower values let the world show through; text stays readable.",

			["opt_opacity_presets"] = "Opacity presets",
			["opt_opacity_preset_0"] = "0%",
			["opt_opacity_preset_0_desc"] = "Fully transparent backdrop. Guide text stays readable.",
			["opt_opacity_preset_25"] = "25%",
			["opt_opacity_preset_25_desc"] = "Light backdrop (25% opaque).",
			["opt_opacity_preset_50"] = "50%",
			["opt_opacity_preset_50_desc"] = "Halfway opaque backdrop (50%).",
			["opt_opacity_preset_75"] = "75%",
			["opt_opacity_preset_75_desc"] = "Mostly opaque backdrop (75%).",
			["opt_opacity_preset_100"] = "100%",
			["opt_opacity_preset_100_desc"] = "Fully opaque backdrop.",

			["opt_framescale"] = "Scale",
			["opt_framescale_desc"] = "You can resize the window to match your preferences.",

			["opt_fontsize"] = "Primary text size",
			["opt_fontsize_desc"] = "Set your preferred text size. Note that the window scale affects this, too.",
			["opt_fontsecsize"] = "Secondary text size",
			["opt_fontsecsize_desc"] = "Set your preferred secondary text size, used to display additional descriptions and notes.",
			["opt_numStepShow"] = "Steps shown",
			["opt_numStepShow_desc"] = "How many guide steps to show at once. Slot 1 is the current step; extra slots preview upcoming steps. Unused slots hide automatically.",

			["opt_guide_style"] = "Guide Style",
			["opt_guide_style_desc"] = "When a zone has both a Full guide and Main Quests Only, choose which to load — or ask each time.",
			["opt_guide_style_ask"] = "Ask each time",
			["opt_guide_style_full"] = "Full Guide",
			["opt_guide_style_mqo"] = "Main Quests Only",

			["opt_smart_skip"] = "Smart Skip",
			["opt_skipimpossible"] = "Skip impossible steps",
			["opt_skipimpossible_desc"] = "Automatically advance past steps that cannot be completed (for example wrong faction or hidden goals).",
			["opt_skipauxsteps"] = "Skip auxiliary travel steps",
			["opt_skipauxsteps_desc"] = "Skip tip/text fluff when the next real objective is already done or impossible. Never skips blue beacon / “reach next marker” (goto) travel. Off by default.",

			["opt_qol"] = "Quality of Life",
			["opt_stuckstep"] = "Stuck-step detector",
			["opt_stuckstep_desc"] = "After staying on the same step for a while, offer to mark it done / skip with a short note.",
			["opt_stuckstep_minutes"] = "Stuck-step wait (minutes)",
			["opt_stuckstep_minutes_desc"] = "How long on one step before the stuck-step popup appears.",
			["opt_bookmarks"] = "Enable bookmarks",
			["opt_bookmarks_desc"] = "Allow bookmark / resume markers for the current guide.",
			["opt_bookmark_set"] = "Bookmark this step",
			["opt_bookmark_set_desc"] = "Save a resume marker for the current guide and step.",
			["opt_bookmark_resume"] = "Resume bookmark",
			["opt_bookmark_resume_desc"] = "Jump to the bookmarked step for the current guide.",
			["opt_questlink"] = "Quest link to journal",
			["opt_questlink_desc"] = "Ctrl+click a step goal that names a quest to open / focus it in the journal. Also /cgv quest.",
			["opt_zone_nudge"] = "Zone-change soft nudge",
			["opt_zone_nudge_desc"] = "When you enter a zone with a different guide and you are not mid-chapter, softly suggest loading it.",
			["opt_compact_preset"] = "Apply compact viewer",
			["opt_compact_preset_desc"] = "Sets Steps shown = 1 and smaller primary/secondary text.",
			["opt_guidenote"] = "Edit guide note",
			["opt_guidenote_desc"] = "Open a copyable note for the current guide. Included in bug dumps. Save with /cgv note <text>.",
			["opt_hidecompletedgoals"] = "Hide completed goals",
			["opt_hidecompletedgoals_desc"] = "Hide goals already marked complete in the Guide Viewer.",
			["opt_suggest_snooze_minutes"] = "Suggestion snooze (minutes)",
			["opt_suggest_snooze_minutes_desc"] = "How long “Not now” hides a guide suggestion before it can appear again.",
			["opt_wayshrine_nearby"] = "Nearby wayshrine assist",
			["opt_wayshrine_nearby_desc"] = "Mark a wayshrine step complete when you stand on the matching shrine (helps when pin APIs lag).",
			["opt_endguide_toast"] = "End-of-guide toast",
			["opt_endguide_toast_desc"] = "Print a quiet “Guide complete — next: …” chat line when |next auto-loads the next guide.",
			["opt_undo_skip"] = "Undo last skip",
			["opt_undo_skip_desc"] = "Restore the step from before the last skip / stuck-step Accept. Also /cgv undo.",
			["opt_find_step"] = "Find in current guide",
			["opt_find_step_desc"] = "Search step/quest text in the loaded guide. Use /cgv find <text>, then /cgv step N.",
			["opt_copy_step"] = "Copy current step",
			["opt_copy_step_desc"] = "Dump the current step for authoring (Print to Chat). Also /cgv copystep.",
			["opt_gallery_checklist"] = "ESOUI gallery checklist",
			["opt_gallery_checklist_desc"] = "Show 799×498 stretch-fill PNG export rules. Also /cgv gallery.",
			["opt_door_nearby"] = "Nearby door / portal assist",
			["opt_door_nearby_desc"] = "Mark Open/Enter-style goals complete when standing at a matching door/portal POI.",
			["opt_suggest_ready_ping"] = "Suggestion-ready chat ping",
			["opt_suggest_ready_ping_desc"] = "Print a chat line when a guide suggestion is ready but the viewer is hidden or you’re in combat.",
			["opt_home_progress"] = "Show progress % on Home rows",
			["opt_home_progress_desc"] = "Append step completion % on Favorites, Suggested, and search results (parsed guides only).",
			["opt_clear_ignored"] = "Clear ignored guides",
			["opt_clear_ignored_desc"] = "Clear forever-ignored suggestion guides (from Close-X). Also /cgv clearignored.",
			["opt_list_ignored"] = "List ignored guides",
			["opt_list_ignored_desc"] = "Show forever-ignored guides. Also /cgv ignored.",
			["opt_switch_style"] = "Switch Full ↔ MQO",
			["opt_switch_style_desc"] = "Jump to the other style for this zone at the same step number. Also /cgv style.",
			["opt_step_back"] = "Step history back",
			["opt_step_back_desc"] = "Go to the previous step in the history ring. Also /cgv back.",
			["opt_upload_checklist"] = "Upload-day checklist",
			["opt_upload_checklist_desc"] = "Version bump, gallery, README reminders. Also /cgv upload.",
			["opt_mapdata_scaffold"] = "MapData scaffold",
			["opt_mapdata_scaffold_desc"] = "Next MapData id + stub notes for a new chapter. Also /cgv mapdata.",
			["opt_viewer_find"] = "Find in guide (viewer)",
			["opt_viewer_find_desc"] = "Open the viewer find box. Also title-bar button or /cgv findui.",

			["opt_guide_search_placeholder"] = "Search zone, guide, or quest...",
			["opt_guide_search_results"] = "Search results",
			["opt_guide_kind_mqo"] = "Main Quests Only",
			["opt_guide_kind_mqo_tag"] = "MQO",
			["opt_guide_kind_leveling"] = "Leveling",
			["opt_guide_kind_leveling_tag"] = "Full",
			["opt_guide_kind_skyshards"] = "Skyshards & Delves",
			["opt_guide_kind_skyshards_tag"] = "Shards",

			["opt_guide_favorites"] = "★ Favorites",
			["opt_guide_suggested"] = "Suggested",
			["opt_guide_no_suggested"] = "No suggested guide for your zone right now.",
			["opt_auto_hiding"] = "Auto Hiding",

			["opt_hideincombat"] = "Hide viewer while in combat",
			["opt_hideincombat_desc"] = "Hide all guide windows during combat, if your screen gets too cramped.",

			["opt_hideoninventory"] = "Hide viewer while inventory is open",
			["opt_hideoninventory_desc"] = "Hide the Guide Viewer when inventory/map/options etc are opened.",

			["opt_hideonguideconv"] = "Hide viewer during conversations",
			["opt_hideonguideconv_desc"] = "Hide the Guide Viewer when entering conversation with npc for the current step.",

			["opt_reset"] = "Reset viewer",
			["opt_reset_desc"] = "Reset Guide Viewer to original position and size.",

			['opt_general_tip'] = "Leveling Guides Tips",
			['opt_general_tip_desc'] = "\n|cfd5b02Did you know you can bind keys to control the Level Guides Viewer?|r It's far easier to navigate between steps by pressing keys rather than clicking the buttons with your mouse. You can access this by Esc-Controls-Keybindings and scroll down to Community Leveling Guides.",

			------ ARROW -------
			['opt_arrow'] = "Waypoint Arrow",
			['opt_arrow_desc'] = "", -- "These settings control the direction arrow",-- and map markers.",
			['opt_arrowshow'] = "Enable waypoint arrow",
			['opt_arrowshow_desc'] = "Display a rotating arrow, indicating the direction towards the current waypoint.",
			['opt_arrow_display'] = "Arrow look and feel:",
			['opt_arrowfreeze'] = "Lock arrow in place",
			['opt_arrowfreeze_desc'] = "Make the pointer arrow transparent to mouse clicks.",
			['opt_arrowcolor'] = "Arrow color",
			['opt_arrowcolor_desc'] = "Color of the in-world waypoint arrow.",
			['opt_arrowcolordist'] = "Color by distance",
			['opt_arrowcolordist_desc'] = "Color the arrow by distance, instead of by direction.",
			['opt_arrowscale'] = "Scale",
			['opt_arrowscale_desc'] = "Set the size of the waypointing arrow.",
			['opt_arrowalpha'] = "Opacity",
			['opt_arrowalpha_desc'] = "Set the opacity of the waypoint arrow graphic. Title and distance text under the arrow stay fully opaque.",
			['opt_arrowfontsize'] = "Arrow font size",
			['opt_arrowfontsize_desc'] = "Set the size of the labels under the arrow.",
			['opt_arrowmeters'] = "Use metric system",
			['opt_arrowmeters_desc'] = "Use meters and kilometers instead of yards and miles.",
			['opt_arrow_reset'] = "Reset Waypointer",
			['opt_arrow_reset_desc'] = "Reseting the Waypointer to it's original position and size.",
			['opt_additional_arrow_functions'] = "Additional arrow functions:",
			['opt_hidearrowwithguide'] = "Hide waypoint arrow when viewer is closed",
			['opt_hidearrowwithguide_desc'] = "Select this to make the arrow follow the guide window's visibility.\nLeave unchecked if you want the arrow to stay visible when you hide the guides.",

			------ EXTRAS -------
			["opt_extras"] = "Extras",
			["opt_extras_desc"] = "",

			["opt_showmapbutton"] = "Enable Community toggle button",
			["opt_showmapbutton_desc"] = "Show the Community button that toggles the viewer.",

			["opt_revealmappoi"] = "Reveal map locations",
			["opt_revealmappoi_desc"] = "Show all unknown locations on the world map.",

			["opt_bugreports"] = "Show bug report button",
			["opt_bugreports_desc"] = "Show the bug icon on the Guide Viewer. Click it to build a text report (guide, step, location, debug log). Nothing is sent automatically — use Print to Chat, copy with your chat-copy addon, and paste into the Community Leveling Guide comments on ESOUI.",

			["opt_unloadunusedguides"] = "Unload unused guides",
			["opt_unloadunusedguides_desc"] = "Free memory by dropping step data for guides you are not using. Recommended on slower PCs. Opening a guide again re-parses it (short delay). Does not require /reloadui.",

			["opt_authoring"] = "Authoring",
			["opt_cgpos_template"] = "Copy step template",
			["opt_cgpos_template_desc"] = "Build a step/goto/talk template at your current map position. Also available as /cgpos template.",
			["opt_cgpos_pack"] = "Copy MapData pack",
			["opt_cgpos_pack_desc"] = "One dump with goto, DDS/offsets, and step template for MapData paste. Also /cgpos pack.",
			["opt_cgpos_history"] = "Show /cgpos history",
			["opt_cgpos_history_desc"] = "Print recent /cgpos and /cgpos gps dumps. Also available as /cgpos history.",
			["opt_poi_list"] = "List zone wayshrines / doors",
			["opt_poi_list_desc"] = "Lists live POIs for the current zone index. Use when guide wayshrine Name fails (e.g. Solstice). Also /cgpos poi.",

			------ PROFILE --------
			['opt_profile'] = "Profiles",
			['opt_profile_desc'] = "You can change the active database profile so that you can have different settings for every character.",

			['opt_new_profile'] = "You can either create a new profile by entering a name in the edit box or choosing one existing profile.",
			['opt_existing_profiles'] = "Current Profile",	['opt_existing_profiles_desc'] = "You can select a profile to change to it. Some settings may require you to reload to display correctly.",

			['opt_newprof'] = "New Profile",
			['opt_newprof_desc'] = "Create a new Profile",

			['opt_copy_profile_settings'] = "Copy settings from",
			['opt_copy_profile_settings_default'] = "Choose a profile...",
			['opt_copy_profile_settings_desc'] = "Copy options from another profile (including backups after an update) into the current profile. Does not delete the source.",
			['opt_profile_migrate_done'] = "Copied settings from %s.",

			['opt_delete_profiles_default'] = "Profiles",
			['opt_delete_profiles'] = "Delete Profiles",
			['opt_delete_profiles_desc'] = "Select a profile to delete. Can not delete your current profile.",

			['opt_profile_reset'] = "Reset Profile",
			['opt_profile_reset_desc'] = "Reset this profile to original settings.",

			['opt_char_profiles'] = "Character Profile-DEV ONLY",
			['opt_char_profiles_desc'] = "Copy the history from another character. Things like quest history. REQUIRES A RELOAD",

			------ DEVELOPER/DEBUG -------
			["opt_dev"] = "Developer/Debug",
			["opt_dev_desc"] = "Options for developing CGV and various debug options.",

			["opt_debug"] = "Toggle debug",
			["opt_debug_desc"] = "",

		}
		--for k,v in pairs(f) do
		--if type(v)=="string" then  f[k]=v:gsub("<<(.-)>>",COLOR_TIP_MOUSE.."%1"..COLOR_TIP)  end
		--end
		return f
end)

GuideViewer("Specials", "enUS", function() return {
			['plural'] = function (word)
				if not word then return end
				-- one-shot special cases
				for _,data in ipairs(specials) do
					if word:match(data[1]) then
						return data[2] == 1 and word or word:gsub(data[1],data[2])
					end
				end

				-- breakdown.
				local rest = ""
				local preof,postof = word:match("^(.-) of (.+)$")
				if preof then
					word = preof
					rest = " of "..postof
				else
					local obj,verb = word:match("^(.+)( %a-ed)$")
					local notverbs = _G.notverbs
					if obj and not notverbs[verb:sub(2)] then
						word = obj
						rest = verb
					end
				end

				local notlastw,lastw = word:match("^(.+%s)(.-)$")
				if lastw then
					word = lastw
				else
					notlastw = ""
				end

				-- got a proper exception for this word?
				if plurals[word] then
					return notlastw .. (plurals[word]==1 and word or plurals[word]) .. rest
					-- well, got a regexp for it?
				else
					for sing,plur in pairs(wordspecials) do
						if word:match(sing) then
							return notlastw .. (plur == 1 and word or word:gsub(sing,plur)) .. rest
						end
					end

					--else...

					-- just use language defaults, I guess.
					local last = word:sub(-1)
					if (last == "y" and not word:sub(-2):match("[aeiou]y")) then
						return notlastw .. word:sub(1,-2).."ies" .. rest
					elseif word:sub(-2) == "ff" then
						return notlastw .. word:sub(1,-3).."ves" .. rest
					elseif last == "f" then
						return notlastw .. word:sub(1,-2).."ves" .. rest
					elseif word:sub(-2) == "fe" then
						return notlastw .. word:sub(1,-3).."ves" .. rest
					elseif word:sub(-3) == "ess" then
						return notlastw .. word.."es" .. rest
					elseif word:sub(-2) == "ch" or word:sub(-2)=="sh" then
						return notlastw .. word.."es" .. rest
					elseif last == "x" then
						return notlastw .. word.."es" .. rest
					elseif last == "s" then
						return notlastw .. word .. rest
					elseif last == "o" then
						return notlastw .. word .."es" .. rest
						-- the following is to prevent pluralization of goal items ending with a double-quote
					elseif last == "\"" then
						return notlastw .. word .. rest
						--print(notlastw.."..."..word.."..."..rest)
					else
						return notlastw .. word.."s" .. rest
					end
				end
			end,

			['contract_mobs'] = function(mobs)

				if not mobs[1].name and type(mobs) == "table" then
					local l = mobs
					mobs = {}
					for i = 1,#l do
						mobs[i] = { name = l[i] }
					end
				end

				if mobs[1].name:match("^Echo of") then return nil end

				local common,lastcommon,all
				for i = 1,5 do
					common = mobs[1].name:match("^([%a']+" .. (" [%a']+"):rep(i-1) .. ")")
					if not common then break end
					all = true
					for m = 2,#mobs do
						if mobs[m].name:find(common) ~=1 then
							all = false
							break
						end
					end
					if all then
						lastcommon = common
					else
						break
					end
				end

				if lastcommon then
					return GuideViewer("Specials")['contract_mobs_start'](lastcommon)
				end

				-- start failed? let's try end.
				lastcommon = nil
				for i = 1,5 do
					common = mobs[1].name:match("([%a']+" .. (" [%a']+"):rep(i-1) .. ")$")
					if not common then break end
					all = true
					for m = 2,#mobs do
						if mobs[m].name:sub(-#common) ~= common then
							all = false
							break
						end
					end
					if all then
						lastcommon = common
					else
						break
					end
				end

				if lastcommon then
					return GuideViewer("Specials")['contract_mobs_end'](lastcommon)
				end

				--else
				return nil
			end,

			['contract_mobs_start'] = function(s) return s.." mobs" end,
			['contract_mobs_end'] = function(s) return GuideViewer("Specials")['plural'](s) end,
} end)


