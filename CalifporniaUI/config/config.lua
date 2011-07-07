Califpornia.CFG["addonskins"] = {
	["DBM"] = true,
}

-- Tooltip
Califpornia.CFG["tooltip"] = {
	["enable"]				 = true,
	["font"]				 	 = {[[Interface\AddOns\CalifporniaUI\media\fonts\normal_font.ttf]], 11, "NORMAL"},
	["you"]				 	 = "<YOU>",		-- Target text when unit targeting you
	["guild_ranks"]		 	 = true,			-- Show guild ranks for players when it's possible
	["aura_owners"]		 	 = true,			-- Show aura autors in aura tooltips
	["guild_color"]			 	 = true,			-- Color of guild tag and rank
	["at_cursor"]			 	 = false,			-- Show tooltip at cursor when it's not at it (spells, players, etc...)
}



Califpornia.CFG["common"] = {
	["screen_spacer"]			 = 10,
}

Califpornia.CFG["altbar"] = {
	["enable"]			 	 = true,
	["font"]				 	 = {[[Interface\AddOns\CalifporniaUI\media\fonts\normal_font.ttf]], 11, "NORMAL"},
	["anchor"]				 = {"TOP", UIParent, "TOP", 0, -6},
}







-- Some minor tweaks
CalifporniaCFG["tweak"] = {
	["auto_accept_invite"]			= true,		-- Auto accept invite from guild/friends
	["auto_duel"]					= false,		-- Auto decline duels
	["auto_trash"]					= true,		-- Auto sell gray items on vendor dialog open
	["auto_repair"]					= true,		-- Auto repair items on vendor dialog open !!! REPAIRS FROM PLAYER'S MONEY !!! GB autorepair TODO
	["auto_greed"]					= true,		-- Auto greed/DE on greens
	["auto_confirm_de"]			= false,		-- Auto confirm disenchant
	["interrupt_announce"]			= true,		-- Announce interrupts in party/raid chat
	["wf_autohide"]				= true,		-- Auto hide WatchFrame in combat
}

-- Lighweight version of OmniCC
CalifporniaCFG["omnicc"] = {
	["enable"]					= false,
	["treshold"]					= 8,			-- Show decimal under X seconds and text turn red
}

-- Nice skinned nameplates - CaelNamePlates by Caellian
CalifporniaCFG["nameplate"] = {
	["enable"]					= true,
	["abbrevn"]					= 20,		-- If name longer than that value, it will be truncated except last word.
}

-- Minimap
CalifporniaCFG["minimap"] = {
	["enable"]					 = true,
	["font"]						 = {[[Interface\AddOns\CalifporniaUI\media\fonts\big_noodle_tilting.ttf]], 12, "OUTLINE"},
}

-- Skin some random ui elements
CalifporniaCFG["skinframe"] = {
	["enable"]					= true,
}

-- Skin some random ui elements
CalifporniaCFG["expbar"] = {
	["enable"]					= true,
}

-- AddOn manager
CalifporniaCFG["addonmanager"] = {
	["enable"]					= true,
}


-- 
CalifporniaCFG["map"] = {
	["enable"] = true,                     -- reskin the map
}
CalifporniaCFG["chat"] = {
	["enable"]				 = true,
	["tabfont"]				 = {[[Interface\AddOns\CalifporniaUI\media\fonts\big_noodle_tilting.ttf]], 12, "OUTLINE"},
	["editboxfont"]				 = {[[Interface\AddOns\CalifporniaUI\media\fonts\normal_font.ttf]], 10, "NORMAL"},
	["whispersound"] = true,				 -- play a sound when receiving whisper
	["filtersysmsg"] = false,				 -- Your share of loot: x (y deposited to guildbank) => +x (y)
	["editboxheight"] = 20,
	["tabtextcolor"] = { 1,1,1 },
}

CalifporniaCFG["mirror"] = {
	["enable"] = true,                     -- blah
	["width"] = 220,                     -- blah
	["height"] = 18,                     -- blah
	["fontsize"] = 13,                     -- blah
	["positions"] = {
		["BREATH"] = {"TOP", "UIParent", "TOP", 0, -96},
		["EXHAUSTION"] = {"TOP", "UIParent", "TOP", 0, -142},
		["FEIGNDEATH"] = {"TOP", "UIParent", "TOP", 0, -198},
	},
	["colors"] = {
		EXHAUSTION = {1, .9, 0},
		BREATH = {0, .5, 1},
		DEATH = {1, .7, 0},
		FEIGNDEATH = {1, .7, 0},
	},
}
CalifporniaCFG["panels"] = {
	["enable"]				 = true,                     -- dont disable :<
	["font"]					 = {[[Interface\AddOns\CalifporniaUI\media\fonts\big_noodle_tilting.ttf]], 12, "OUTLINE"},
	["block_width"]			 = 340,	-- Overall panel block width. applies both to left and right blocks. For right block it will be splitted for minimap and dps/omen panels. minimap always will be square with one side == block_height
	["block_height"]			 = 120,	-- Big panel height. applies both to left and right blocks.
	["mini_height"]			 = 15,	-- Slim info panel height. 
	["spacer"]				 = 3,		-- Panel spacing
	["threatbar"]				 = true,                     -- blah
	["expbar"]				 = true,                     -- blah
	["repbar"]					 = true,                     -- blah
}
CalifporniaCFG["datatext"] = {
	["dur"] = 6,                -- show your equipment durability on panels.
	["system"] = 1,                -- show fps and ms on panels, and total addon memory in tooltip
	["gold"] = 5,                -- show your current gold on panels
	["guild"] = 3,                -- show number on guildmate connected on panels
	["friends"] = 2,                -- show number of friends connected.
	["bags"] = 4,                -- show space used in bags on panels
	["speed"] = 7,
	["stats"] = 8,
	["hpsdps"] = 9,
	["classcolor"] = true,
}

Califpornia.CFG["buffs"] = {
	["enable"] = true,  
	["font"]					 = {[[Interface\AddOns\CalifporniaUI\media\fonts\big_noodle_tilting.ttf]], 11, "OUTLINE"},
	["time_color"]				 = {1,1,1},
	["count_color"]				 = {1,1,1},
	["iconsize"] = 36, -- Buffs and debuffs size
	["rowbuffs"] = 16,
}



CalifporniaCFG["unitframes"] = {
	-- general options
	["enable"] = false,                     -- do i really need to explain this?
	["movable_perchar"]		= true,
	["dps_layout"]				= true,			-- use alternative raid/party layout (false == grid-like layout)
	["showraidmanager"]		= false,			-- show default blizzard raid manager (for ground marks)
	["iconsize"]				= 20,
	["classbar"]				= true,


	["debuff_hl_dispellable"]	= false,			-- highlight only dispellable debuff types. false == show all

	-- Healer raidframes layout options --
	["grid_aggro"]				= true,			-- display aggro borders
	["grid_role"]				= true,			-- display LFD roles
	["grid_icons"]				= 3, 				-- 1 == small icons under character name; 2 == big icons overlaps name; 3 == no icons
	["grid_hl"]				= true,			-- use debuff highlight
	



	-- class specific elements
	["combobar"]	 = true,                     -- rogue/cat combobar at target frame
	["runebar"]	 = true,                     -- DK runes at player frame
	["druidmana"]	 = true,                     -- druid mana bar in bear/cat form at player frame
	["eclipsebar"]	 = true,                     -- druid moonkin eclipse bar at player frame
	["holypower"]	 = false,                     -- paladin holy power bar at player frame
	["soulshards"]	 = true,                     -- warlock soul shard bar at player frame
	["totembar"]	 = true,                     -- shaman totem indicators at player frame
	-- cast bars
	["unitcastbar"] = true,                -- enable castbar
	["cbfont"]				= {[[Interface\AddOns\CalifporniaUI\media\fonts\big_noodle_tilting.ttf]], 12, "OUTLINE"},
	["cblatency"] = false,                 -- enable castbar latency
	["cbicons"] = true,                    -- enable icons on castbar
	
}






CalifporniaCFG["actionbars"] = {
	enable 		= false,

	["btn_spacing"]		= 0,
	["big_button"]			= 48,
	["small_button"]		= 24,

	["big_font"]			= {[[Interface\AddOns\CalifporniaUI\media\fonts\big_noodle_tilting.ttf]], 24, "OUTLINE"},
	["big_macro"]			= true,
	["big_macro_font"]		= {[[Interface\AddOns\CalifporniaUI\media\fonts\big_noodle_tilting.ttf]], 12, "OUTLINE"},
	["small_font"]			= {[[Fonts\ARIALN.ttf]], 10, "OUTLINE"},
	["small_macro"]		= false,
}
