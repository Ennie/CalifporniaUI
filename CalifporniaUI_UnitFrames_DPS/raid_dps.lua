local addonName, ns = ...
local cfg = CalifporniaUI_UnitFrames.cfg
local lib = CalifporniaUI_UnitFrames.lib



local function CreateRaidStyleDPS(self, unit, isSingle)
		lib.init(self)
		self:SetScale(cfg.raid_dps.scale)
		self:SetSize(106, 20)

		self.Range = {
			insideAlpha = 1,
			outsideAlpha = .5,
		}

		-- Generate Bars
		lib.gen_hpbar(self, 16)
		lib.gen_namestring(self, 12, 'raid')
		lib.gen_infostring(self, 12, 'raid')
		lib.gen_powerbar(self,3)
		self.bd = lib.gen_backdrop(self, 0)
		lib.gen_highlight(self)
		lib.gen_raidmark(self)
		lib.gen_ttborder(self)
		lib.gen_auras(self,'raid')
		lib.gen_lfdicon(self,true)
		lib.gen_infoicons(self)

		-- Frame specific stuff
		self.Health.frequentUpdates = false
		self.Health.colorSmooth = true
		self.Power.colorDisconnected = true
		self.Power.colorClass = true
		self.Power.colorReaction = true
		self.Power.bg.multiplier = 0.5
		-- plugins
		lib.gen_debuff_hl(self)
end
oUF:RegisterStyle("RaidDPS", CreateRaidStyleDPS)

oUF:Factory(function(self)
--[[		CompactRaidFrameManager:UnregisterAllEvents()
		CompactRaidFrameManager.Show = dummy
		CompactRaidFrameManager:Hide()

		CompactRaidFrameContainer:UnregisterAllEvents()
		CompactRaidFrameContainer.Show = dummy
		CompactRaidFrameContainer:Hide()

]]

	CompactRaidFrameContainer:Hide()
	CompactRaidFrameContainer.Show = Califpornia.dummy
	if cfg.misc.blizzmanager ~= true then
		CompactRaidFrameManager:SetAlpha(0)
	end
	local maxGroups = 5
	if cfg.raid_dps.all_groups then
		maxGroups = 8
	end

		oUF:SetActiveStyle("RaidDPS")
		-- DPS raid layot, very minimalistic. 
		local raid_groups = {}
		for i = 1, maxGroups do
			raid_groups[i] = oUF:SpawnHeader("oUF_CalifporniaRaid"..i, nil, "raid", 
				"showRaid", true,  
				"showPlayer", true,
				"showSolo", false,
				"showParty", false,
				"xoffset", 4,
				"yOffset", -5,
				"groupFilter", i,
				"groupBy", "GROUP",
				"groupingOrder", "1,2,3,4,5,6,7,8",
				"sortMethod", "INDEX",
				"maxColumns", 1,
				"unitsPerColumn", 5,
				"columnSpacing", 7,
				"point", "TOP",
				"columnAnchorPoint", "LEFT")
			raid_groups[i]:SetScale(1)
			if i == 1 then 
				raid_groups[i]:SetPoint(unpack(cfg.positions.raid_dps))
			elseif i == 6 and cfg.raid_dps.all_groups then
				raid_groups[i]:SetPoint("TOPLEFT", raid_groups[1], "TOPRIGHT", 9, 0)
			else
				raid_groups[i]:SetPoint("TOPLEFT", raid_groups[i-1], "BOTTOMLEFT", 0, -15)
			end
		end
end)