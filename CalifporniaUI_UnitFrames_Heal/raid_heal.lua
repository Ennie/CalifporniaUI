local addonName, ns = ...
local cfg = CalifporniaUI_UnitFrames.cfg
local lib = CalifporniaUI_UnitFrames.lib

local function CreateRaidStyleGRID(self, unit, isSingle)
		lib.init(self)

--		local fheight = 28
--		local hheight = 24
--		if not cfg.raid_heal.slim_layout then
			fheight = 22
			hheight = 18
--		end

		self:SetScale(cfg.raid_heal.scale)
		self:SetSize(100, fheight)

		self.Range = {
			insideAlpha = 1,
			outsideAlpha = .5,
		}

		-- Generate Bars
		lib.gen_hpbar(self, hheight)
		lib.gen_namestring(self, 14, 'grid')
		lib.gen_infostring(self, 14, 'grid')
		lib.gen_powerbar(self,3)
		self.bd = lib.gen_backdrop(self, 0, 4)
		lib.gen_highlight(self)
		lib.gen_raidmark(self)
		if cfg.raid_heal.threat_border then
			lib.gen_ttborder(self)
		end
--		if not cfg.raid_heal.slim_layout then
			lib.gen_auras(self,'grid')
--		end
		if cfg.raid_heal.lfd_roles then
			lib.gen_lfdicon(self,true)
		end
		lib.gen_infoicons(self)
		lib.healcomm(self)
		-- Frame specific stuff
		self.Health.frequentUpdates = false
		self.Health.colorSmooth = true
--		self.Power.colorDisconnected = true
		self.Power.colorClass = true
		self.Power.colorReaction = true
		self.Power.bg.multiplier = 0.5
		-- plugins
		if cfg.raid_heal.debuff_hl then
			lib.gen_debuff_hl(self)
		end
end
oUF:RegisterStyle("RaidGRID", CreateRaidStyleGRID)



oUF:Factory(function(self)
	CompactRaidFrameContainer:Hide()
	CompactRaidFrameContainer.Show = Califpornia.dummy
	if cfg.misc.blizzmanager ~= true then
		CompactRaidFrameManager:SetAlpha(0)
	end
	local maxGroups = 5
	if cfg.raid_heal.all_groups then
		maxGroups = 8
	end
		oUF:SetActiveStyle("RaidGRID")
		-- GRID-like raid layot
		local raid_groups = {}
		for i = 1, maxGroups do
			raid_groups[i] = oUF:SpawnHeader("oUF_CalifporniaGRID"..i, nil, "solo,party,raid", 
				"showRaid", true,  
				"showPlayer", true,
				"showSolo", true,
				"showParty", true,
				"xoffset", 3,
				"yOffset", -5,
				"groupFilter", i,
				"groupBy", "GROUP",
				"groupingOrder", "1,2,3,4,5,6,7,8",
				"sortMethod", "INDEX",
				"maxColumns", 1,
				"unitsPerColumn", 5,
				"columnSpacing", 7,
				"point", "LEFT",
				"columnAnchorPoint", "LEFT",
				"oUF-initialConfigFunction", ([[
					self:SetWidth(%d)
					self:SetHeight(%d)
				]]):format(100, 22))
			raid_groups[i]:SetScale(1)
			if i == 1 then 
				raid_groups[i]:SetPoint(unpack(cfg.positions.raid_heal))
			else
				raid_groups[i]:SetPoint("BOTTOMLEFT", raid_groups[i-1], "TOPLEFT", 0, 3)
			end
		end
end)