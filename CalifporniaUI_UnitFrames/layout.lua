local addonName, ns = ...
local cfg = CalifporniaUI_UnitFrames.cfg
local lib = CalifporniaUI_UnitFrames.lib


------------------------------------------------------------------------
-- STYLE function
------------------------------------------------------------------------
local function CreatePlayerStyle(self, unit, isSingle)
		lib.init(self)
		self.mystyle = "player"
		
		-- Size and Scale
		self:SetScale(cfg.misc.scale)
		self:SetSize(220, 54)

		-- Generate Bars
		lib.gen_hpbar(self,37)
		lib.gen_namestring(self, 15, 'player')
		lib.gen_infostring(self, 15, 'player')
		lib.gen_powerbar(self,15)
		lib.gen_backdrop(self, 0)
		lib.gen_highlight(self)
		lib.gen_portrait(self, self:GetWidth()-16, 24)
		lib.gen_combatfeedback(self)
		lib.gen_raidmark(self)
		lib.gen_infoicons(self)
		lib.gen_playericons(self)
		lib.gen_lfdicon(self)
		lib.gen_pvpicon(self)

		-- castbar
		lib.gen_castbar(self, 'player')

		-- frame specific stuff
		self.Health.frequentUpdates = false
		self.Health.colorSmooth = true
		self.Health.Smooth = cfg.misc.smooth
		if cfg.misc.color_by_class then
			self.Power.colorClass = true
		else
			self.Power.colorPower = true
		end
		self.Power.bg.multiplier = 0.5
		self.Power.Smooth = cfg.misc.smooth

		-- class specific
		lib.gen_classbar(self)

		-- plugins
		lib.gen_debuff_hl(self)
		lib.gen_altpowerbar(self,'player')
end
local function CreateTargetStyle(self, unit, isSingle)
		lib.init(self)

		self.mystyle = "target"
		
		-- Size and Scale
		self:SetScale(cfg.misc.scale)
		self:SetSize(220, 54)

		-- Generate Bars
		lib.gen_hpbar(self,37)
		lib.gen_namestring(self, 15, 'player')
		lib.gen_infostring(self, 15, 'player')
		lib.gen_powerbar(self,15)
		lib.gen_backdrop(self, 0)
		lib.gen_highlight(self)
		lib.gen_portrait(self, self:GetWidth()-16, 24)
		lib.gen_combatfeedback(self)
		lib.gen_raidmark(self)

		-- castbar
		lib.gen_castbar(self, 'target')

		-- frame specific stuff
		self.Health.frequentUpdates = false
		self.Health.colorSmooth = true
		self.Power.colorTapping = true
		self.Power.colorDisconnected = true
		self.Power.colorHappiness = false
		self.Power.colorClass = true
		self.Power.colorReaction = true
		self.Power.bg.multiplier = 0.5
		self.Health.Smooth = cfg.misc.smooth
		self.Power.Smooth = cfg.misc.smooth

		lib.gen_infoicons(self)
		lib.gen_pvpicon(self)
		lib.gen_phaseicon(self)
		lib.gen_questicon(self)
		lib.gen_auras(self,'target')

		-- class specific
		lib.gen_cpbar(self)
		-- plugins
		lib.gen_debuff_hl(self)
		lib.gen_altpowerbar(self,'target')
end
local function CreateToTStyle(self, unit, isSingle)
		lib.init(self)

		self.mystyle = "tot"
		
		-- Size and Scale
		self:SetScale(cfg.misc.scale)
		self:SetSize(106, 24)

		-- Generate Bars
		lib.gen_hpbar(self, 16)
		lib.gen_namestring(self, 12, 'tot')
		lib.gen_infostring(self, 12, 'tot')
		lib.gen_powerbar(self,6)
		lib.gen_backdrop(self, 0)
		lib.gen_highlight(self)
		lib.gen_raidmark(self)

		-- frame specific stuff
		self.Health.frequentUpdates = false
		self.Health.colorSmooth = true
		self.Power.colorTapping = true
		self.Power.colorDisconnected = true
		self.Power.colorHappiness = false
		self.Power.colorClass = true
		self.Power.colorReaction = true
		self.Power.colorHealth = true
		self.Power.bg.multiplier = 0.5
		self.Health.Smooth = cfg.misc.smooth
		self.Power.Smooth = cfg.misc.smooth
end
local function CreateFocusStyle(self, unit, isSingle)
		lib.init(self)
		self.mystyle = "focus"

		-- Size and Scale
		self:SetScale(cfg.misc.scale)
		self:SetSize(106, 24)

		-- Generate Bars
		lib.gen_hpbar(self, 16)
		lib.gen_namestring(self, 12, 'tot')
		lib.gen_infostring(self, 12, 'tot')
		lib.gen_powerbar(self,6)
		lib.gen_backdrop(self, 0)
		lib.gen_highlight(self)
		lib.gen_raidmark(self)

		-- castbar
		lib.gen_castbar(self, 'focus')

		-- frame specific stuff
		self.Health.frequentUpdates = false
		self.Health.colorSmooth = true
		self.Power.colorTapping = true
		self.Power.colorDisconnected = true
		self.Power.colorHappiness = false
		self.Power.colorClass = true
		self.Power.colorReaction = true
		self.Power.colorHealth = true
		self.Power.bg.multiplier = 0.5
		self.Health.Smooth = cfg.misc.smooth
		self.Power.Smooth = cfg.misc.smooth
		-- plugins
		lib.gen_debuff_hl(self)
end
local function CreateFocusTargetStyle(self, unit, isSingle)
		lib.init(self)
		self.mystyle = "focustarget"
		
		-- Size and Scale
		self:SetScale(cfg.misc.scale)
		self:SetSize(106, 24)

		-- Generate Bars
		lib.gen_hpbar(self, 16)
		lib.gen_namestring(self, 12, 'tot')
		lib.gen_infostring(self, 12, 'tot')
		lib.gen_powerbar(self,6)
		lib.gen_backdrop(self, 0)
		lib.gen_highlight(self)
		lib.gen_raidmark(self)

		--style specific stuff
		self.Health.frequentUpdates = false
		self.Health.colorSmooth = true
		self.Power.colorTapping = true
		self.Power.colorDisconnected = true
		self.Power.colorHappiness = false
		self.Power.colorClass = true
		self.Power.colorReaction = true
		self.Power.colorHealth = true
		self.Power.bg.multiplier = 0.5
		self.Health.Smooth = cfg.misc.smooth
		self.Power.Smooth = cfg.misc.smooth
end
local function CreatePetStyle(self, unit, isSingle)
		lib.init(self)
		self.mystyle = "pet"
		
		self.Range = {
			insideAlpha = 1,
			outsideAlpha = .5,
		}
		-- Size and Scale
		self:SetScale(cfg.misc.scale)
		self:SetSize(106, 24)

		-- Generate Bars
		lib.gen_hpbar(self, 16)
		lib.gen_namestring(self, 12, 'tot')
		lib.gen_infostring(self, 12, 'tot')
		lib.gen_powerbar(self,6)
		lib.gen_backdrop(self, 0)
		lib.gen_highlight(self)
		lib.gen_raidmark(self)

		-- castbar
		lib.gen_castbar(self, 'pet')

		-- frame specific stuff
		self.Health.frequentUpdates = false
		self.Health.colorSmooth = true
		self.Power.colorTapping = true
		self.Power.colorDisconnected = true
		self.Power.colorHappiness = true
		self.Power.colorClass = true
		self.Power.colorReaction = true
		self.Power.colorHealth = true
		self.Power.bg.multiplier = 0.5
		self.Health.Smooth = cfg.misc.smooth
		self.Power.Smooth = cfg.misc.smooth
		-- plugins
		lib.gen_debuff_hl(self)
end
local function CreatePetTargetStyle(self, unit, isSingle)
		lib.init(self)
		self.mystyle = "pettarget"
		
		-- Size and Scale
		self:SetScale(cfg.misc.scale)
		self:SetSize(106, 24)

		-- Generate Bars
		lib.gen_hpbar(self, 16)
		lib.gen_namestring(self, 12, 'tot')
		lib.gen_infostring(self, 12, 'tot')
		lib.gen_powerbar(self,6)
		lib.gen_backdrop(self, 0)
		lib.gen_highlight(self)
		lib.gen_raidmark(self)

		-- frame specific stuff
		self.Health.frequentUpdates = false
		self.Health.colorSmooth = true
		self.Power.colorTapping = true
		self.Power.colorDisconnected = true
		self.Power.colorHappiness = false
		self.Power.colorClass = true
		self.Power.colorReaction = true
		self.Power.colorHealth = true
		self.Power.bg.multiplier = 0.5
		self.Health.Smooth = cfg.misc.smooth
		self.Power.Smooth = cfg.misc.smooth
end
local function CreatePartyStyle(self, unit, isSingle)
	lib.init(self)
	if (unit == "party") then

		self.mystyle = "group"

		self.Range = {
			insideAlpha = 1,
			outsideAlpha = .5,
		}
		
		-- Size and Scale
		self:SetScale(cfg.party.scale)
		self:SetSize(180, 42)

		-- Generate Bars
		lib.gen_hpbar(self,28)
		lib.gen_namestring(self, 12, 'player')
		lib.gen_infostring(self, 12, 'player')
		lib.gen_powerbar(self,10)
		self.bd = lib.gen_backdrop(self, 0)
		lib.gen_highlight(self)
		lib.gen_portrait(self, self:GetWidth()-16, 18, 6)
		lib.gen_combatfeedback(self)
		lib.gen_raidmark(self)
		lib.gen_infoicons(self)
		lib.gen_lfdicon(self)
		lib.gen_ttborder(self)
		lib.gen_auras(self)

		--style specific stuff
		self.Health.frequentUpdates = false
		self.Health.colorSmooth = true
		self.Power.colorClass = true
		self.Power.colorDisconnected = true
		self.Power.bg.multiplier = 0.5
		self.Health.Smooth = cfg.misc.smooth
		self.Power.Smooth = cfg.misc.smooth

		-- plugins
		lib.gen_debuff_hl(self)

	-- party target
--	elseif (unit == "partytarget") then
	elseif (self:GetAttribute("unitsuffix") == "target" and unit == "partytarget") then
		self.mystyle = "partytarget"
		
		-- Size and Scale
		self:SetScale(cfg.party.scale)
		self:SetSize(86, 19)

		-- Generate Bars
		lib.gen_hpbar(self, 16)
		lib.gen_namestring(self, 12, 'tot')
		lib.gen_infostring(self, 12, 'tot')
		lib.gen_powerbar(self,2)
		lib.gen_backdrop(self, 0)
		lib.gen_highlight(self)
		lib.gen_raidmark(self)

		-- Frame specific stuff
		self.Health.frequentUpdates = false
		self.Health.colorSmooth = true
		self.Power.colorTapping = true
		self.Power.colorDisconnected = true
		self.Power.colorHappiness = false
		self.Power.colorClass = true
		self.Power.colorReaction = true
		self.Power.colorHealth = true
		self.Power.bg.multiplier = 0.5
		self.Health.Smooth = cfg.misc.smooth
		self.Power.Smooth = cfg.misc.smooth

	
	-- party pet
--	elseif (unit == "partypet") then
	elseif (self:GetAttribute("unitsuffix") == "pet" and unit == "partypet") then
		self.mystyle = "slim"
		
		-- Size and Scale
		self:SetScale(cfg.party.scale)
		self:SetSize(86, 19)

		-- Generate Bars
		lib.gen_hpbar(self, 16)
		lib.gen_namestring(self, 12, 'tot')
		lib.gen_infostring(self, 12, 'tot')
		lib.gen_powerbar(self,2)
		self.bd = lib.gen_backdrop(self, 0)
		lib.gen_highlight(self)
		lib.gen_raidmark(self)
		lib.gen_ttborder(self)

		-- Frame specific stuff
		self.Health.frequentUpdates = false
		self.Health.colorSmooth = true
		self.Power.colorReaction = true
		self.Power.colorHealth = true
		self.Power.bg.multiplier = 0.5
		self.Health.Smooth = cfg.misc.smooth
		self.Power.Smooth = cfg.misc.smooth
		-- plugins
		lib.gen_debuff_hl(self)
	end
end

local function CreateBossStyle(self, unit, isSingle)
	lib.init(self)

		self.mystyle = "group"

		-- Size and Scale
		self:SetScale(cfg.misc.scale)
		self:SetSize(180, 42)

		-- Generate Bars
		lib.gen_hpbar(self,28)
		lib.gen_namestring(self, 12, 'player')
		lib.gen_infostring(self, 12, 'player')
		lib.gen_powerbar(self,10)
		lib.gen_backdrop(self, 0)
		lib.gen_highlight(self)
		lib.gen_portrait(self, self:GetWidth()-16, 18, 6)
		lib.gen_raidmark(self)

		-- Frame specific stuff
		self.Health.frequentUpdates = false
		self.Health.colorSmooth = true
		self.Power.colorReaction = true
		self.Power.bg.multiplier = 0.5
		self.Health.Smooth = cfg.misc.smooth
		self.Power.Smooth = cfg.misc.smooth

end
local function CreateArenaStyle(self, unit, isSingle)
	lib.init(self)
		self.mystyle = "group"

		-- Size and Scale
		self:SetScale(cfg.misc.scale)
		self:SetSize(180, 42)

		-- Generate Bars
		lib.gen_hpbar(self,28)
		lib.gen_namestring(self, 12, 'player')
		lib.gen_infostring(self, 12, 'player')
		lib.gen_powerbar(self,10)
		lib.gen_backdrop(self, 0)
		lib.gen_highlight(self)
		lib.gen_portrait(self, self:GetWidth()-16, 18, 6)
		lib.gen_combatfeedback(self)
		lib.gen_raidmark(self)
		lib.gen_auras(self, 'arena')

		-- Frame specific stuff
		self.Health.frequentUpdates = false
		self.Health.colorSmooth = true
		self.Power.colorDisconnected = true
		self.Power.colorClass = true
		self.Power.bg.multiplier = 0.5
		self.Health.Smooth = cfg.misc.smooth
		self.Power.Smooth = cfg.misc.smooth
end
-- arena target
local function CreateArenaTargetStyle(self, unit, isSingle)
	lib.init(self)
		
		-- Size and Scale
		self:SetScale(cfg.misc.scale)
		self:SetSize(86, 19)

		-- Generate Bars
		lib.gen_hpbar(self, 16)
		lib.gen_namestring(self, 12, 'tot')
		lib.gen_infostring(self, 12, 'tot')
		lib.gen_powerbar(self,2)
		lib.gen_backdrop(self, 0)
		lib.gen_highlight(self)
		lib.gen_raidmark(self)

		-- Frame specific stuff
		self.Health.frequentUpdates = false
		self.Health.colorSmooth = true
		self.Power.colorDisconnected = true
		self.Power.colorClass = true
		self.Power.colorReaction = true
		self.Power.colorHealth = true
		self.Power.bg.multiplier = 0.5
		self.Health.Smooth = cfg.misc.smooth
		self.Power.Smooth = cfg.misc.smooth
end
-- arena pet
local function CreateArenaPetStyle(self, unit, isSingle)
	lib.init(self)

		-- Size and Scale
		self:SetScale(cfg.misc.scale)
		self:SetSize(86, 19)

		-- Generate Bars
		lib.gen_hpbar(self, 16)
		lib.gen_namestring(self, 12, 'tot')
		lib.gen_infostring(self, 12, 'tot')
		lib.gen_powerbar(self,2)
		lib.gen_backdrop(self, 0)
		lib.gen_highlight(self)
		lib.gen_raidmark(self)

		-- Frame specific stuff
		self.Health.frequentUpdates = false
		self.Health.colorSmooth = true
		self.Power.colorDisconnected = true
		self.Power.colorReaction = true
		self.Power.colorHealth = true
		self.Power.bg.multiplier = 0.5
		self.Health.Smooth = cfg.misc.smooth
		self.Power.Smooth = cfg.misc.smooth
end

local function CreateMTStyle(self, unit, isSingle)
		lib.init(self)
		self.mystyle = "focus"

		-- Size and Scale
		self:SetScale(cfg.misc.scale)
		self:SetSize(106, 24)

		-- Generate Bars
		lib.gen_hpbar(self, 16)
		lib.gen_namestring(self, 12, 'tot')
		lib.gen_infostring(self, 12, 'tot')
		lib.gen_powerbar(self,6)
		lib.gen_backdrop(self, 0)
		lib.gen_highlight(self)
		lib.gen_raidmark(self)

		-- frame specific stuff
		self.Health.frequentUpdates = false
		self.Health.colorSmooth = true
		self.Power.colorTapping = true
		self.Power.colorDisconnected = true
		self.Power.colorHappiness = false
		self.Power.colorClass = true
		self.Power.colorReaction = true
		self.Power.colorHealth = true
		self.Power.bg.multiplier = 0.5
		self.Health.Smooth = cfg.misc.smooth
		self.Power.Smooth = cfg.misc.smooth
		-- plugins
		lib.gen_debuff_hl(self)
end	

oUF:RegisterStyle("Player", CreatePlayerStyle)
oUF:RegisterStyle("Target", CreateTargetStyle)
oUF:RegisterStyle("ToT", CreateToTStyle)
oUF:RegisterStyle("Focus", CreateFocusStyle)
oUF:RegisterStyle("FocusTarget", CreateFocusTargetStyle)
oUF:RegisterStyle("Pet", CreatePetStyle)
oUF:RegisterStyle("PetTarget", CreatePetTargetStyle)
oUF:RegisterStyle("Boss", CreateBossStyle)
oUF:RegisterStyle("Party", CreatePartyStyle)
oUF:RegisterStyle("Arena", CreateArenaStyle)
oUF:RegisterStyle("ArenaPet", CreateArenaPetStyle)
oUF:RegisterStyle("ArenaTarget", CreateArenaTargetStyle)
oUF:RegisterStyle("MT", CreateMTStyle)

------------------------------------------------------------------------
-- SPAWNS
------------------------------------------------------------------------

oUF:Factory(function(self)
	local isDPS = IsAddOnLoaded("CalifporniaUI_UnitFrames_DPS")


	self:SetActiveStyle("Player")
	local player = self:Spawn("player", "oUF_Player")
	player:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 10, -10)

	self:SetActiveStyle("Target")
	local target = self:Spawn("Target", "oUF_Target")
	target:SetPoint("TOPLEFT", player, "TOPRIGHT", 8, 0)

	self:SetActiveStyle("ToT")
	local targettarget = self:Spawn("targettarget", "oUF_tot")
	targettarget:SetPoint("TOPLEFT", target, "TOPRIGHT", 8, 0)

	self:SetActiveStyle("Pet")
	local pet = self:Spawn("pet", "oUF_pet")
	pet:SetPoint("TOPLEFT", player, "BOTTOMLEFT", 0, -43)

	self:SetActiveStyle("PetTarget")
	local pettarget = self:Spawn("pettarget", "oUF_pettarget")
	pettarget:SetPoint("TOPLEFT", pet, "TOPRIGHT", 8, 0)

	self:SetActiveStyle("Focus")
	local focus = self:Spawn("focus", "oUF_focus")
	focus:SetPoint("TOPLEFT", player, "BOTTOMLEFT", 0, -8)

	self:SetActiveStyle("FocusTarget")
	local focustarget = self:Spawn("focustarget", "oUF_focustarget")
	focustarget:SetPoint("TOPLEFT", focus, "TOPRIGHT", 8, 0)

	-- PARTY
	self:SetActiveStyle("Party")
	local party = self:SpawnHeader('oUF_Party', nil, 'party',
		'showParty', true,
		'showSolo', false,
		'showPlayer', false,
		'showRaid', false,
		'yOffset', -50,
		'xOffset', 0,
		'maxColumns', 1,
		'unitsPerColumn', 4,
		'columnAnchorPoint', 'TOPLEFT',
		'template', 'oUF_cParty',
		'oUF-initialConfigFunction', [[
			self:SetWidth(180)
			self:SetHeight(40)
		]]
	)
	party:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 10, -150)

	-- MainTank
	if (isDPS and cfg.mt.raid_dps) or cfg.mt.raid_heal then
		oUF:SetActiveStyle("MT")
		local tank = oUF:SpawnHeader('oUF_MT', nil, 'raid',
			'oUF-initialConfigFunction', ([[
				self:SetWidth(%d)
				self:SetHeight(%d)
			]]):format(100, 25),
			'showRaid', true,
			'groupFilter', 'MAINTANK',
			'yOffset', 3,
			'point' , 'BOTTOM',
			'template', 'oUF_CMT'
		)
		tank:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 10, 300)
	end

	if cfg.misc.arena then
		Arena_LoadUI = function() end
		oUF:SetActiveStyle("Arena")
		local arena = {}
		for i = 1, 5 do
			arena[i] = self:Spawn("arena"..i, "oUF_Arena"..i)
			if i == 1 then
				arena[i]:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -10, -150)
			else
				arena[i]:SetPoint("TOP", arena[i-1], "BOTTOM", 0, -50)
			end
		end

		oUF:SetActiveStyle("ArenaPet")
		local arenapet = {}
		for i = 1, 5 do
			arenapet[i] = self:Spawn("arenapet"..i, "oUF_Arena"..i.."pet"):SetPoint("TOPRIGHT",arena[i], "BOTTOMRIGHT", 0, -6)
		end

		oUF:SetActiveStyle("ArenaTarget")
		local arenatarget = {}
		for i = 1, 5 do
			arenatarget[i] = self:Spawn("arena"..i.."target", "oUF_Arena"..i.."target"):SetPoint("TOPLEFT",arena[i], "BOTTOMLEFT", 0, -6)
		end
	end

	if cfg.misc.boss then
		oUF:SetActiveStyle("Boss")
		local boss = {}
		for i = 1, MAX_BOSS_FRAMES do
			boss[i] = self:Spawn("boss"..i, "oUF_Califpornia_Boss"..i)
			if i == 1 then
				boss[i]:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -10, -150)
			else
				boss[i]:SetPoint('TOP', boss[i-1], 'BOTTOM', 0, -50)
			end
		end
	end
end)



------------------------------------------------------------------------
-- Right-Click on unit frames menu. 
-- Doing this to remove SET_FOCUS eveywhere.
-- SET_FOCUS work only on default unitframes.
-- same shit with all frame movement related items
-- Main Tank and Main Assist, use /maintank and /mainassist commands.
------------------------------------------------------------------------
-- remove SET_FOCUS & CLEAR_FOCUS from menu, to prevent errors

do 
	local remove_items = {"SET_FOCUS", "CLEAR_FOCUS", "MOVE_PLAYER_FRAME", "MOVE_TARGET_FRAME", "LOCK_FOCUS_FRAME", "UNLOCK_FOCUS_FRAME"}
	for k,v in pairs(UnitPopupMenus) do
		for x,y in pairs(UnitPopupMenus[k]) do
			for i = 1, getn(remove_items) do
				if y ==  remove_items[i] then
					  table.remove(UnitPopupMenus[k],x)
				end
			end
		end
	end
end


StaticPopupDialogs["TOGGLE_RAID"] = {
	text = "Choose your raidframes layout",
	button1 = "DPS / TANK",
	button2 = "HEALER",
	OnAccept = function() DisableAddOn("CalifporniaUI_UnitFrames_Heal") EnableAddOn("CalifporniaUI_UnitFrames_DPS") ReloadUI() end,
	OnCancel = function() EnableAddOn("CalifporniaUI_UnitFrames_Heal") DisableAddOn("CalifporniaUI_UnitFrames_DPS") ReloadUI() end,
	timeout = 0,
	whileDead = 1,
}
SLASH_TOGGLERAID1 = "/toggleraid"
SlashCmdList["TOGGLERAID"] = function() StaticPopup_Show("TOGGLE_RAID") end

local OnLogon = CreateFrame("Frame")
OnLogon:RegisterEvent("PLAYER_ENTERING_WORLD")
OnLogon:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	if (IsAddOnLoaded("CalifporniaUI_UnitFrames_DPS") and IsAddOnLoaded("CalifporniaUI_UnitFrames_Heal")) then
		StaticPopup_Show("TOGGLE_RAID")
	end
end)

