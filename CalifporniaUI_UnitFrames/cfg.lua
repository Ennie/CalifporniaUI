local addonName, ns = ...
local LSM = LibStub("LibSharedMedia-3.0") 

CalifporniaUI_UnitFrames = {}

CalifporniaUI_UnitFrames.cfg = {
	["positions"] = {
		["raid_heal"]		= {"BOTTOMLEFT", UIParent, "BOTTOM", -260, 182},
		["raid_dps"]		= {"TOPLEFT", UIParent, 10, -150},

	},
	["castbar"] = {
		["font"]		= {LSM:Fetch("font", "Big Noodle Titling"), 12, "OUTLINE"},
	},
	["misc"] = {
		["scale"]			= 1,
		["iconsize"]		= 20,
		["color_by_class"]	= true, -- color resource by class, by resource type otherwise
		["arena"]			= true,
		["boss"]			= true,
		["blizzmanager"]	= false,
		["hl_dispellable"]	= false,
		["smooth"]		= false,
		["classbar"]		= true,
		["combobar"]		= true,
	},
	["media"] = {
		["hl_tex"]			= LSM:Fetch("statusbar", "X-Perl"),
		["sb_tex"]		= LSM:Fetch("statusbar", "Minimalist"),
		["bd_tex"]		= LSM:Fetch("border", "BackDrop"),
		["bdedge_tex"]	= LSM:Fetch("border", "BackDropEdge"),
		["font"]			= LSM:Fetch("font", "Big Noodle Titling"),
		["mfont"]			= LSM:Fetch("font", "Big Noodle Titling"),
		["raidicons"]		= LSM:Fetch("background", "CoolRaidIcons"),
	},
	["party"] = {
		["scale"]			= 1,
		["raid_heal"]		= true,
		["raid_dps"]		= false,
	},
	["mt"] = {
		["raid_heal"]		= false,
		["raid_dps"]		= false,
	},
	["raid_dps"] = {
		["scale"]			= 1,
		["all_groups"]		= false,
	},
	["raid_heal"] = {
		["scale"]			= 1,
		["all_groups"]		= true,
		["show_pets"]		= true,
		["lfd_roles"]		= true,
		["threat_border"]	= true,
		["debuff_hl"]		= true,
		["slim_layout"]	= false, -- slim layout without aura icons
	},
	["aura_filter"] = {
		-- [spell_id] = player_only
		DEATHKNIGHT = {
		},
		DRUID = {
			[33763] = true,		-- Lifebloom
			[8936] = true,		-- Regrowth
			[774] = true,		-- Rejuvenation
			[48438] = true,		-- Wild Growth
		},
		HUNTER = {
			[34477] = true,		-- Misdirection
		},
		MAGE = {
			[54646] = true,		-- Focus Magic
		},
		PALADIN = {
			[53563] = false,	-- Beacon of Light
			[25771] = false,	-- Forbearance
			[1038] = false,		-- Hand of Salvation
			[1022] = false,		-- Hand of Protection
			[6940] = false,		-- Hand of Sacrifice
--			[1038] = false,		-- Hand of Salvation
--			[1038] = false,		-- Hand of Salvation
		},
		PRIEST = { 
			[6788] = false, -- Power Word: Shield
			[139] = false, -- Renew
			[33076] = false, -- Prayer of Mending
		},
		ROGUE = {
--			57934, -- Tricks of the Trade
		},
		SHAMAN = {
			[974] = true,		-- Earth Shield
			[61295] = true,		-- Riptide
		},
		WARLOCK = {
--			20707, -- Soulstone Resurrection
		},
		WARRIOR = {
--			50720, -- Vigilance
		},
		["COMMON"] = {
			-- Tank SAVES
			-- Paladin
			[498] = false,		-- Divine Protection
			[31850] = false,	-- Ardent Defender
			[86659] = false,	-- GoAK shieldwall
			[642] = false,		-- Divine Shield

			[93326] = false, -- test
		},
	},
}
