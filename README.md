# CGESO

![](https://imgur.com/817R4SR.png)

A public domain leveling guide originally created by Zygor Guides, later discontinued and open-sourced. Now maintained by snichols7778 with contributions from Hydra9268, the project adds leveling, Lorebook, Skyshard, and Delve guides for new content while keeping it alive for as long as ESO exists.

----

Install through the excellent add-on manager <a href="https://www.esoll.es/" target="blank">ESOLL</a>

![](https://i.imgur.com/ThuB17A.jpeg)

### Libraries Required

ESOLL automatically installs the required libraries. If you prefer to install this addon manually, you will need: **LibGPS**, **LibMapPing**, **LibDebugLogger**, and **LibChatMessage**.

----

# Changelog

<details>
<summary>Date TBD - QoL Features &amp; Dual Settings</summary>
<ul>
  <li>Stuck-step detector — long time on the same step offers mark done/skip with a note (viewer overlay; mouselook stays free).</li>
  <li>Bug / author dumps: scrollable label window + <strong>Print to Chat</strong> (no EditBox mouse trap); paste into the CGESO comments on ESOUI via your chat-copy addon.</li>
  <li>Bookmark / resume markers (viewer pin + settings); per-guide notes.</li>
  <li>Quest link from a named step into the journal (Ctrl+click).</li>
  <li>Compact viewer preset (steps = 1, smaller text); optional hide completed goals.</li>
  <li>Zone-change soft nudge when not mid-chapter.</li>
  <li>Suggestion / zone / style / stuck popups: Guide Viewer overlays (not TOPLEVEL dialogs) so mouselook works while they stay up; Alt to click; anchored beside the viewer.</li>
  <li>Authoring: <code>/cgpos history</code>, <code>/cgpos pack</code>, step template, and <code>/cgpos poi</code> wayshrine/door list (Solstice-safe).</li>
  <li>Guide <code>wayshrine Name</code> matching hardened for zones that omit <code>IsPOIWayshrine</code> (e.g. Solstice Rampart Camp); use place name only — the UI already adds “Wayshrine”.</li>
  <li>Full Solstice leveling guide: Discover tip lines converted to <code>wayshrine Place</code> (same greening as MQO).</li>
  <li>Suggestion <strong>Not now</strong> — snoozes for N minutes (default 30); Close (X) still ignores forever.</li>
  <li>Undo last skip / stuck Accept — Home/LAM button and <code>/cgv undo</code>.</li>
  <li>In-guide search — <code>/cgv find &lt;text&gt;</code> then <code>/cgv step N</code>.</li>
  <li>Copy current step for authoring — Home/LAM and <code>/cgv copystep</code> (Print to Chat).</li>
  <li>Nearby wayshrine assist — standing on the matching shrine completes the step if pin APIs lag.</li>
  <li>End-of-guide toast — quiet chat line when <code>|next</code> auto-loads the next guide.</li>
  <li>ESOUI gallery checklist — Home/LAM and <code>/cgv gallery</code> (799×498 stretch-fill PNG).</li>
  <li>Clear / list ignored guides — <code>/cgv ignored</code>, <code>/cgv clearignored</code>, Home/LAM.</li>
  <li>Viewer find box — title-bar button / <code>/cgv findui</code> (overlay EditBox; Esc releases mouse).</li>
  <li>Nearby door / portal assist — optional complete when standing at a matching POI (uses stored goal text only; fixed stack overflow from calling GetText inside IsComplete; ignores “Open … Map” tips).</li>
  <li>Jump to zone guide — title-bar / Home/LAM / <code>/cgv zone</code> loads preferred Full/MQO for the current zone.</li>
  <li>Catch-up skip — <code>/cgv catchup</code> advances past already-complete steps (undoable).</li>
  <li>Hide viewer in combat — existing Auto-hiding toggle (Home/LAM).</li>
  <li>Note badge on viewer — title-bar button when a guide note exists; click to edit.</li>
  <li>Remember Home folder — reopen last Favorites/Suggested/folder.</li>
  <li>Quiet mode — suppresses suggestion ping, zone nudge, extras tip, and end-of-guide toast.</li>
  <li>In-zone extras tip — soft chat when unfinished Skyshards/Lorebooks guides match this zone.</li>
  <li>Upload-day checklist — <code>/cgv upload</code>; MapData scaffold — <code>/cgv mapdata</code> (next id).</li>
  <li>Step history ring — <code>/cgv back</code> / <code>/cgv stephistory</code>.</li>
  <li>Home Favorites/Suggested/search rows can show progress %.</li>
  <li>Suggestion-ready chat ping when the viewer is hidden or you’re in combat.</li>
  <li>Full ↔ MQO switch — <code>/cgv style</code> (same step number when possible).</li>
  <li>Skyshard <code>achieve</code> goals: use character <code>GetSkyshardDiscoveryStatus</code> when U52 <code>GetAchievementCriterionSkyshardId</code> exists (not account-wide criteria alone).</li>
</ul>
</details>

<details>
<summary>11/14/2026 - UI &amp; Guide System Update</summary>
<ul>
  <li>Esc → Settings → Addons panel with profile create, switch, copy, and delete.</li>
  <li>Profile migration on version bump (keeps backups; optional copy into the new profile).</li>
  <li>Guide Home search for zones, guides, and quests; [Full] / [MQO] / [Shards] tags in mixed lists.</li>
  <li>Favorites and Suggested folders in the guide browser.</li>
  <li>Viewer transparency applies to Home menu and popups (backdrop only; text stays readable).</li>
  <li>Brand accent theme, perfect-sizing buttons, Escape closes popups, live opacity/font sync.</li>
  <li>Multi-step viewer with Steps shown setting (1–5).</li>
  <li>Smart skip for impossible and auxiliary travel steps.</li>
  <li>Removed character-level gating (ESO quests scale with the player).</li>
  <li>Suggested next guide: The Wailing Prison first for new characters, then alliance order, then chapters/DLC by release date.</li>
  <li>Full Guide vs Main Quests Only choice (prompt + Settings preference); confirm links switch guides without a full reload.</li>
  <li>Bug report button with a copyable dump (nothing auto-sent).</li>
  <li>Unload unused guide data to reduce memory on slower PCs.</li>
  <li>LibGPS 3.x (LibGPS3) hardening; nested goal conditionals; settings scrollbar; code cleanup and bug fixes.</li>
</ul>
</details>

<details>
<summary>Date TBD - Main Quest Rework</summary>
<ul>
  <li>Aldmeri Dominion (Base Game)</li>
  <li>Daggerfall Covenant (Base Game)</li>
  <li>Ebonheart Pact (Base Game)</li>
  <li>Imperial City</li>
  <li>Craglorn</li>
  <li>Wrothgar</li>
  <li>Thieves Guild</li>
  <li>Dark Brotherhood</li>
  <li>Vvardenfell</li>
  <li>Clockwork City</li>
  <li>Summerset</li>
  <li>Murkmire</li>
  <li>Northern Elsweyr</li>
  <li>Southern Elsweyr</li>
  <li>Western Skyrim</li>
  <li>The Reach</li>
  <li>Blackwood</li>
  <li>The Deadlands</li>
  <li>High Isle</li>
  <li>Firesong</li>
  <li>Telvanni Peninsula</li>
  <li>West Weald</li>
  <li>Delves, Skyshards &amp; Lorebooks</li>
  <li>Companion Guide</li>
</ul>
</details>

<details>
<summary>07/17/2026 - Eastern Solstice</summary>
<ul>
  <li>Eastern Solstice Main Quest Only</li>
  <li>Eastern Solstice Full Guide</li>
  <li>Eastern Solstice Skyshard and Delves Guide</li>
  <li>Eastern Solstice Lorebooks</li>
</ul>
</details>

<details>
<summary>08/16/2025 - Solstice</summary>
<ul>
  <li>Reworked Tutorial</li>
  <li>Solstice Main Quest Only</li>
  <li>Solstice Full Guide</li>
  <li>Solstice Skyshard and Delves Guide</li>
  <li>Solstice Lorebooks</li>
</ul>
</details>

<details>
<summary>10/28/2024 - Gold Road</summary>
<ul>
  <li>Updated Tutorial to Wailing Prison (Update 44)</li>
  <li>Gold Road Main Quest Only</li>
  <li>Gold Road Full Guide</li>
  <li>Gold Road Skyshards &amp; Delves Guide</li>
  <li>Tanlorin Companion &amp; Rapport Guide</li>
  <li>Zerith-var Companion &amp; Rapport Guide</li>
</ul>
</details>

<details>
<summary>01/13/2024 - Southern Elsweyr Full Guide</summary>
<strong>Southern Elsweyr Main Quest Only</strong>
<ul>
  <li>Highlight Objectives</li>
  <li>Minor Fixes</li>
</ul>

<strong>Imperial City Full Guide</strong>
<ul>
  <li>Highlight Objectives</li>
  <li>Major and Minor Fixes</li>
  <li>Completely Revamped</li>
</ul>

<strong>Southern Elsweyr Main Quest Only</strong>
<ul>
  <li>Highlight Objectives</li>
  <li>Major and Minor Fixes</li>
  <li>Completely Revamped</li>
</ul>
</details>

<details>
<summary>01/06/2024 - Full Guide</summary>
<strong>Full Guide</strong>
<ul>
  <li>Major &amp; Minor Changes</li>
  <li>Highlight Objectives</li>
  <li>Major and Minor Fixes</li>
  <li>More Dialogue Options</li>
  <li>Broken Zones Completely Revamped</li>
</ul>

<strong>Main Quest Only</strong>
<ul>
  <li>Major &amp; Minor Changes</li>
  <li>Highlight Objectives</li>
  <li>Major and Minor Fixes</li>
  <li>More Dialogue Options</li>
  <li>Broken Zones Completely Revamped</li>
</ul>
</details>

<details>
<summary>09/17/2023</summary>
<ul>
  <li>Map Revamp</li>
  <li>Main Quest Only (DLC)</li>
  <li>Highlight Objectives</li>
  <li>Minor Fixes</li>
  <li>More Dialogue Options</li>
  <li>Lorebook Guides</li>
  <li>Skyshard &amp; Delve Guide</li>
  <li>Additional Minor Fixes</li>
</ul>
</details>

<details>
<summary>Archives</summary>
<strong>06/09/2023</strong>
<ul>
  <li>Fixed typo in Azandar Al-Cybiades Guide.</li>
  <li>Updated the wayshrine name changed by ZeniMax from <em>Baandari Trading Post Wayshrine</em> to <em>Baandari Market Wayshrine</em>.</li>
</ul>

<strong>06/04/2023 – Necrom: Shadows Over Morrowind</strong>
<ul>
  <li>Renamed ZGESO to CGESO.</li>
  <li>Removed unused legacy code.</li>
  <li>Added <strong>Necrom: Shadows Over Morrowind</strong>.</li>
  <li>Added Full Guide with Skyshards &amp; Delves.</li>
  <li>Added Main Quest Only Guide.</li>
  <li>Added Azandar Al-Cybiades Companion Guide.</li>
  <li>Added Sharp-as-Night Companion Guide.</li>
  <li>Map revamp.</li>
  <li>Updated Legacy Guides.</li>
  <li>Improved Full Guide and Main Quest Only Guides.</li>
  <li>Added highlighted objectives, more dialogue options, and numerous fixes.</li>
  <li>Updated all Skyshards and Delves for Account-Wide Achievements.</li>
</ul>

<strong>02/17/2023</strong>
<ul>
  <li>Fixed Cadwell's Gold error for the Daggerfall Covenant.</li>
</ul>

<strong>11/07/2022</strong>
<ul>
  <li>Fixed Grahtwood map issue.</li>
  <li>Fixed Reaper's March map issue.</li>
</ul>

<strong>11/01/2022 – Firesong</strong>
<ul>
  <li>Rewrote Aldmeri Dominion Legacy Guide for Account-Wide Achievements.</li>
  <li>Completely reimplemented and rewrote the Imperial City Guide and maps.</li>
  <li>Rewrote Daggerfall Covenant Legacy Guide for Account-Wide Achievements.</li>
  <li>Rewrote Ebonheart Pact Legacy Guide for Account-Wide Achievements.</li>
  <li>Added Firesong DLC Guides (Main Quest Only &amp; Full Guide with Skyshards &amp; Delves).</li>
</ul>

<strong>06/06/2022</strong>
<ul>
  <li>Corrected the Vvardenfell step for <em>Examine Bothamul's Orders</em>.</li>
  <li>Updated the README using information from the manifest file.</li>
  <li>Removed unnecessary Lua comments from the manifest file.</li>
  <li>Cleaned up the manifest by keeping only required entries.</li>
  <li>Packaged releases using ZIP format instead of 7z.</li>
</ul>

<strong>06/06/2022</strong>
<ul>
  <li>Completed all DLC Main Quest Only Guides.</li>
  <li>Added Ember Companion Guide.</li>
  <li>Added Isobel Veloise Companion Guide.</li>
  <li>Added Rapport Guides for all four companions.</li>
  <li>Added High Isle &amp; Amenos Main Quest Only Guide.</li>
  <li>Completed the High Isle &amp; Amenos Full Guide.</li>
</ul>

<strong>05/29/2022</strong>
<ul>
  <li>Fixed Isle of Balfiera issue caused by an API change.</li>
</ul>

<strong>04/16/2022</strong>
<ul>
  <li>Fixed Northern Elsweyr map name issue.</li>
</ul>

<strong>04/16/2022</strong>
<ul>
  <li>Created Legacy Main Quest Only Guides.</li>
  <li>Fixed various issues.</li>
</ul>

<strong>11/02/2021</strong>
<ul>
  <li>Fixed typo in Southern Elsweyr.</li>
</ul>

<strong>11/02/2021</strong>
<ul>
  <li>Fixed Vulkhel Guard map issues in the Blackwood Prologue Guide.</li>
</ul>

<strong>10/31/2021 – Deadlands DLC</strong>
<ul>
  <li>Added Skyshards, Delves, and all quests.</li>
</ul>

<strong>Wrothgar</strong>
<ul>
  <li>Added Skyshards, Delves, and missing quests.</li>
  <li>Reorganized quest order to complete side quests alongside the main storyline.</li>
</ul>

<strong>Thieves Guild</strong>
<ul>
  <li>Added Skyshards, Delves, and faction commands for applicable quests.</li>
</ul>

<strong>Dark Brotherhood</strong>
<ul>
  <li>Added Skyshards, Delves, and missing quests.</li>
</ul>

<strong>Vvardenfell</strong>
<ul>
  <li>Added Prologue, Skyshards, Delves, missing quests, and clarification steps.</li>
</ul>

<strong>Clockwork City</strong>
<ul>
  <li>Added Prologue, Skyshards, Delves, missing quests, and clarification steps.</li>
</ul>

<strong>Summerset</strong>
<ul>
  <li>Added Prologue, missing quests, Skyshards, Delves, and command steps to reduce manual skipping.</li>
</ul>

<strong>Murkmire</strong>
<ul>
  <li>Added Prologue, missing quests, Skyshards, and Delves.</li>
  <li>Added command steps to reduce manual skipping.</li>
</ul>

<strong>Northern Elsweyr</strong>
<ul>
  <li>Added Prologue, missing quests, Skyshards, Delves, and command steps.</li>
  <li>Reordered quests for a faster guide.</li>
</ul>

<strong>Blackwood</strong>
<ul>
  <li>Moved Companion quests into their own dedicated guides.</li>
  <li>Each Companion now has an individual guide.</li>
  <li>06/01/2021 – Added Blackwood, Dragonhold (Southern Elsweyr), and Craglorn Guides.</li>
  <li>03/27/2021 – Added Western Skyrim Guides.</li>
  <li>03/13/2021 – Merged miscellaneous updates from Sharlikran.</li>
  <li>03/13/2021 – Removed embedded libraries and fixed <code>/cgpos</code> output.</li>
  <li>03/13/2021 – Fixed two Glenumbra bugs reported by AegonVI.</li>
  <li>03/13/2021 – Reordered Bleakrock quests so the <em>Hero of Bleakrock</em> achievement can be earned.</li>
  <li>11/02/2020 – Updated API support for Dragonhold.</li>
  <li>08/12/2020 – Updated API support for Scalebreaker.</li>
  <li>07/27/2020 – Added Northern Elsweyr Guide.</li>
</ul>
</details>

# Development Guide

### Dev Mode
* /cgv dev

### Creator Mode
* /cgv creator

### Development HOW-TO


`goto wailingprison4_base 50.00,50.00`
* `goto` = Tells the arrow where to point. Auto-advances to the next step if nothing but goto and step exist.
* `wailingprison4_base` = the current map's DDS reference. It only works when the user is in the zone.
* `50.00,50.00` = the floating-point x and y coordinates. Decimal values are optional but highly recommended for precision.
* Tip: Once the map's DDS is declared, you can exclude it in subsequent steps as long as the player stays in that zone. (e.g., `goto 50.00,50.00`)

#### These actions auto-advance to the next step

`accept` = Accept quests.<br/>
`turnin` = Turn in quests.<br/>
`wayshrine` = Discover wayshrines.<br/>
`step` = Declares a guide step (Auto-advance based on `goto` and `step` or if the condition of another action like wayshrine or accept is met).<br/>


#### These actions are purely visual and do not auto-advance to the next step

`talk` = Talk to NPCs.<br/>>
`'` = Adds general information.<br/>


#### Goal Handlers - requires a pipe | in front to activate (e.g. |tip, |q, |count)

`|q` = Creates a step in CGESO's progress bar. It also denotes the current step's quest.

`/` = Placed on the same line after `|q`. The slash checks for a completed task in the Quest Journal for the current step's quest. Important: Must match the task word-for-word, space-for-space to register as completed.

`|tip` = Handler for displaying tips in a small font. Note: placing a `|tip` in a `goto` step prevents the action from automatically going to the next step when meeting the condition.

`|next Aldmeri Dominion Leveling Guides\\Khenarthi's Roost` = Instructs CGESO to go to another guide
* `next` = Handler that tells the guide to load another guide
* `Aldmeri Dominion Leveling Guides\\Khenarthi's Roost` = the RegisterGuide to load

`|count #` = Handler to track a sequence of objectives

For Example:
`|q The Waking Darkness/.*Cleanse the Mausoleums.* |count 2`
* `q` Quest tracking
* `The Waking Darkness` Name of quest
* `/.*Cleanse the Mausoleums.*` Quest objective (Formatting required `/.*Name of Objectve.*`)
* `|count 2` Current objective number

`|or` = Handler for dialog choices. Important: You need to put the |or handler on each selection.

For example<br>
```
'Choose either a Marine or Wizard to help you
|tip It doesn't matter, just personal preference.
'Talk to either _Sergeant Firion_ or _Gathwen_
'Choose the Marine to help you |q The Tempest Unleashed/The Marine |or
'_OR_
'Choose the Wizard to help you |q The Tempest Unleashed/The Wizard |or
step
```

*To see a complete list of Types and Handlers, review Goal.lua. If you have questions, feel free to ask.*

----

### Slash commands

* `/re` = /reloadui
* `/cgpos` - For city and delve data. Also displays the map's correct DDS filename.
* `/cgpos gps` - For general map data. Works in any map.
* `/dump CGFunctionName(arguments)` - A way to execute ESO's and CGESO's public functions<br> (e.g. `/dump CGV.Pointer:GetDistToCoords(alinor_base,48.80,54.64)`)

#### /dump functions of note:

* `/dump CGV.Data:GetQuestIdByName("A City in Black")` - Returns the Quest ID
* `/dump CGV.Quests:IsQuestComplete("A City in Black")` - Returns a boolean
* `/dump CGV.Quests:HasQuest("A City in Black")` - Returns a boolean
* `/dump d(GetCurrentMapIndex())` - Returns the zone's ID. Tip: some functions require the `d()` command to display the output.


----

### Addon Resource

* <a href="https://esoui.com/downloads/fileinfo.php?id=2062#info" target="_blank">Addon page on ESO UI</a>
* <a href="https://esodata.uesp.net/current/index.html" target="_blank">ESO Data for API</a>
* <a href="https://wiki.esoui.com/API" target="_blank">ESO API from the ESOUI Wiki</a>
* <a href="https://wiki.esoui.com/Texture_List" target="_blank">Texture List from the ESOUI Wiki</a>
* <a href="https://mothereff.in/lua-minifier" target="_blank">Lua minifier</a>
* <a href="https://esomap.uesp.net/" target="_blank">ESO Interactive Map</a>
* <a href="https://en.uesp.net/wiki" target="_blank">The Unofficial Elder Scrolls Pages</a>
* <a href="https://game-maps.com/ESO/The-Elder-Scrolls-Online.asp" target="_blank">ESO Maps - The Elder Scrolls Online Walkthrough & Guide</a>
