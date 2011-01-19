if not CalifporniaCFG["unitframes"].enable == true then return end

local statusbar_texture = CalifporniaCFG.media.normTex
local mfont = CalifporniaCFG.media.uffont
local playerClass = CalifporniaCFG.myclass
oUF.colors.smooth = {42/255,48/255,50/255, 42/255,48/255,50/255, 42/255,48/255,50/255}
oUF.colors.runes = {{0.87, 0.12, 0.23};{0.40, 0.95, 0.20};{0.14, 0.50, 1};{.70, .21, 0.94};}
local cpColor = {{0.99, 0.31, 0.31};{0.99, 0.31, 0.31};{0.85, 0.83, 0.35};{0.85, 0.83, 0.35};{0.33, 0.99, 0.33};}

--backdrop table
local backdrop_tab = { 
	bgFile = CalifporniaCFG.media.bdTex, 
	edgeFile = CalifporniaCFG.media.bdedgeTex,
	tile = false,
	tileSize = 0, 
	edgeSize = 5, 

	insets = { 
		left = 3, 
		right = 3, 
		top = 3, 
		bottom = 3,
	},
}




local error = function(...) print("|cffff0000Error:|r "..string.format(...)) end


------------------------------------------------------------------------
-- MISC functions
------------------------------------------------------------------------
-- returns: player/target, misc, raid
local retVal = function(f, val1, val2, val3, val4, val5)
	if f.mystyle == "player" or f.mystyle == "target" then
		return val1
	elseif f.mystyle == "group" then
		return val4
	elseif f.mystyle == "raid" then
		return val3
	elseif f.mystyle == "slim" then
		return val5
	else
		return val2
	end
end

-- format time for aura icons
local FormatTime = function(s)
	local day, hour, minute = 86400, 3600, 60
	if s >= day then
		return format("%dd", floor(s/day + 0.5)), s % day
	elseif s >= hour then
		return format("%dh", floor(s/hour + 0.5)), s % hour
	elseif s >= minute then
		if s <= minute * 5 then
			return format("%d:%02d", floor(s/60), s % minute), s - floor(s)
		end
		return format("%dm", floor(s/minute + 0.5)), s % minute
	elseif s >= minute / 12 then
		return floor(s + 0.5), (s * 100 - floor(s * 100))/100
	end
	return format("%.1f", s), (s * 100 - floor(s * 100))/100
end

-- Create Buff/Debuff Timer Function 
function CreateBuffTimer(self, elapsed)
	if self.timeLeft then
		self.elapsed = (self.elapsed or 0) + elapsed
		if self.elapsed >= 0.1 then
			if not self.first then
				self.timeLeft = self.timeLeft - self.elapsed
			else
				self.timeLeft = self.timeLeft - GetTime()
				self.first = false
			end
			if self.timeLeft > 0 then
				local time = FormatTime(self.timeLeft)
					self.time:SetText(time)
				if self.timeLeft < 5 then
					self.time:SetTextColor(1, 0.5, 0.5)
				else
					self.time:SetTextColor(.7, .7, .7)
				end
			else
				self.time:Hide()
				self:SetScript("OnUpdate", nil)
			end
			self.elapsed = 0
		end
	end
end
------------------------------------------------------------------------
-- LIB functions
------------------------------------------------------------------------

local lib = CreateFrame("Frame")  

-- generate dropdown menu
lib.gen_dropdown = function(f)
	local unit = f.unit:gsub("(.)", string.upper, 1)
	if unit == "Targettarget" or unit == "focustarget" or unit == "pettarget" then return end

	if _G[unit.."FrameDropDown"] then
		ToggleDropDownMenu(1, nil, _G[unit.."FrameDropDown"], "cursor")
	elseif (f.unit:match("party")) then
		ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..f.id.."DropDown"], "cursor")
	else
		FriendsDropDown.unit = f.unit
		FriendsDropDown.id = f.id
		FriendsDropDown.initialize = RaidFrameDropDown_Initialize
			ToggleDropDownMenu(1, nil, FriendsDropDown, "cursor")
		end
end
 
-- generate backdrop
lib.gen_backdrop = function(f)
	f:SetBackdrop(backdrop_tab);
	f:SetBackdropColor(0,0,0,1)
	f:SetBackdropBorderColor(0,0,0,0.8)
end

-- generate highlight
lib.gen_highlight = function(f)
	local OnEnter = function(f)
		UnitFrame_OnEnter(f)
		f.Highlight:Show()
	end
	local OnLeave = function(f)
		UnitFrame_OnLeave(f)
	f.Highlight:Hide()
	end
	f:SetScript("OnEnter", OnEnter)
	f:SetScript("OnLeave", OnLeave)

	local hl = f.Health:CreateTexture(nil, "OVERLAY")
	hl:SetAllPoints(f.Health)
	hl:SetTexture(CalifporniaCFG.media.hilightTex)
	hl:SetVertexColor(.5,.5,.5,.1)
	hl:SetBlendMode("ADD")
	hl:Hide()
	f.Highlight = hl
end

-- generate font string
lib.gen_fontstring = function(f, name, size, outline)
	local fs = f:CreateFontString(nil, "OVERLAY")
	fs:SetFont(name, size, outline)
	fs:SetShadowColor(0,0,0,0.8)
	fs:SetShadowOffset(1,-1)
	return fs
end  

-- generate icon border
lib.gen_iconborder = function(f)
	if f.frame==nil then
		local frame = CreateFrame("Frame", nil, f)
		frame = CreateFrame("Frame", nil, f)
     
		frame:SetFrameStrata(f:GetFrameStrata())
		frame:SetPoint("TOPLEFT", 4, -4)
		frame:SetPoint("BOTTOMLEFT", 4, 4)
		frame:SetPoint("TOPRIGHT", -4, -4)
		frame:SetPoint("BOTTOMRIGHT", -4, 4)
		frame:SetBackdrop( { 
			edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1,
			insets = {left = 1, right = 1, top = 1, bottom = 1},
			tile = false, tileSize = 0,
		})

		frame:SetBackdropColor(0.1, 0.1, 0.1, 0.7)
		frame:SetBackdropBorderColor(65/255, 74/255, 79/255)
		f.frame = frame
	end
end

-- generate health bar
lib.gen_hpbar = function(f)
	--statusbar
	local s = CreateFrame("StatusBar", nil, f)
	s:SetStatusBarTexture(statusbar_texture)
	s:GetStatusBarTexture():SetHorizTile(true)
	s:SetHeight(retVal(f,40,21,14,24,16))
	s:SetWidth(f:GetWidth())
	s:SetPoint("TOP",0,0)

	--helper
	local h = CreateFrame("Frame", nil, s)
	h:SetFrameLevel(0)
	h:SetPoint("TOPLEFT",-5,5)
	if f.mystyle == "target" or f.mystyle == "player" then
		h:SetPoint("BOTTOMRIGHT",5,-5)
	elseif f.mystyle == "raid" then
		h:SetPoint("BOTTOMRIGHT", 5, -9)
	else
		h:SetPoint("BOTTOMRIGHT", 5, -11)
	end

	lib.gen_backdrop(h)
	f.h = h
	--bg
	local b = s:CreateTexture(nil, "BACKGROUND")
	b:SetTexture(statusbar_texture)
	b:SetAllPoints(s)
	b:SetVertexColor(1, 0.1, 0.1,1)

	f.Health = s
	f.Health.bg2 = b
end

-- generate hp strings
lib.gen_hpstrings = function(f)
	--health/name text strings
	local name = lib.gen_fontstring(f.Health, mfont, retVal(f,15,12,12,12,10), "NONE")
	name:SetPoint("LEFT", f.Health, "TOPLEFT", retVal(f,3,3,2,3,3), retVal(f,-10,-10,-7,-10,-7))
	name:SetJustifyH("LEFT")
	local hpval = lib.gen_fontstring(f.Health, mfont, retVal(f,15,12,12,12,10), "NONE")
	hpval:SetPoint("RIGHT", f.Health, "TOPRIGHT", retVal(f,-3,-3,-3,-3,-3), retVal(f,-10,-10,-7,-10,-10))

	--this will make the name go "..." when its to long
	if f.mystyle == "raid" then
		name:SetPoint("RIGHT", f, "RIGHT", -1, 0)
	else
		name:SetPoint("RIGHT", hpval, "LEFT", -2, 0)
	end
	if f.mystyle == "player" then
		f:Tag(name, "[cpuf:level] [cpuf:color][name][cpuf:afkdnd]")
	elseif f.mystyle == "target" then
		f:Tag(name, "[cpuf:level] [cpuf:color][name][cpuf:afkdnd]")
	elseif f.mystyle == "raid" then
		f:Tag(name, "[cpuf:afkdnd][cpuf:color][name]")
	elseif f.mystyle == "group" then
		f:Tag(name, "[cpuf:level] [cpuf:afkdnd][cpuf:color][name]")
	else
		f:Tag(name, "[cpuf:color][name]")
	end
	f:Tag(hpval, retVal(f,"[cpuf:hp] | [cpuf:color][cpuf:power]","[cpuf:hp]","[cpuf:raidhp]","[cpuf:hp] | [cpuf:color][cpuf:power]","[cpuf:hp]"))
end

-- gen power bar
lib.gen_powerbar = function(f)
	--statusbar
	local s = CreateFrame("StatusBar", nil, f)
	s:SetStatusBarTexture(statusbar_texture)
	s:GetStatusBarTexture():SetHorizTile(true)
	s:SetHeight(retVal(f,15,5,3,12,3))
	s:SetWidth(f:GetWidth())
	s:SetPoint("BOTTOM",f,"BOTTOM",0,0)

	--helper
	if f.mystyle == "target" or f.mystyle == "player" or f.mystyle == "group" then
		local h = CreateFrame("Frame", nil, s)
		h:SetFrameLevel(0)
		h:SetPoint("TOPLEFT",-5,5)
		h:SetPoint("BOTTOMRIGHT",5,-5)
		lib.gen_backdrop(h)
	end

	--bg
	local b = s:CreateTexture(nil, "BACKGROUND")
	b:SetTexture(statusbar_texture)
	b:SetAllPoints(s)

	f.Power = s
	f.Power.bg = b
end

-- portrait update
lib.PortraitPostUpdate = function(element, unit)
	if not UnitExists(unit) or not UnitIsConnected(unit) or not UnitIsVisible(unit) then
		element:Hide()
	else
		element:Show()
		element:SetCamera(0)
	end
end

--gen portrait
lib.gen_portrait = function(f)
	-- portrait
	local p = CreateFrame("PlayerModel", nil, f)
	p:SetFrameLevel(4)
	p:SetHeight(26)
	p:SetWidth(f:GetWidth()-16)
	p:SetPoint("BOTTOM", f, "BOTTOM", 0, 8)

	--helper
	local h = CreateFrame("Frame", nil, p)
	h:SetFrameLevel(3)
	h:SetPoint("TOPLEFT",-5,5)
	h:SetPoint("BOTTOMRIGHT",5,-5)
	lib.gen_backdrop(h)
	
	-- highlight
	local hl = p:CreateTexture(nil, "OVERLAY")
	hl:SetAllPoints(p)
	hl:SetTexture(CalifporniaCFG.media.portraitTex)
	hl:SetVertexColor(.5,.5,.5,.8)
	hl:SetBlendMode("ALPHAKEY")
	p.PostUpdate = lib.PortraitPostUpdate
	f.Portrait = p
end

-- AURAS
-- Post Create Icon Function
local myPostCreateIcon = function(self, button)
	self.showDebuffType = true
	self.disableCooldown = true
	button.cd.noOCC = true
	button.cd.noCooldownCount = true
	button.icon:SetTexCoord(.07, .93, .07, .93)
	button.icon:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0)
	button.icon:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 0)
	button.overlay:SetTexture(border)
	button.overlay:SetTexCoord(0,1,0,1)
	button.overlay.Hide = function(self) self:SetVertexColor(0.3, 0.3, 0.3) end

	button.time = lib.gen_fontstring(button, mfont, 12, "OUTLINE")
	button.time:SetPoint("CENTER", button, 2, 0)
	button.time:SetJustifyH('CENTER')
	button.time:SetVertexColor(1,1,1)

	button.count = lib.gen_fontstring(button, mfont, 10, "OUTLINE")
	button.count:ClearAllPoints()
	button.count:SetPoint("BOTTOMRIGHT", button, 7, -5)
	button.count:SetVertexColor(1,1,1)	

	--helper
	local h = CreateFrame("Frame", nil, button)
	h:SetFrameLevel(0)
	h:SetPoint("TOPLEFT",-5,5)
	h:SetPoint("BOTTOMRIGHT",5,-5)
	lib.gen_backdrop(h)
	lib.gen_iconborder(h)
end	
  
-- Post Update Icon Function
local myPostUpdateIcon = function(self, unit, icon, index, offset, filter, isDebuff)
	local _, _, _, _, _, duration, expirationTime, unitCaster, _ = UnitAura(unit, index, icon.filter)
	if duration and duration > 0 then
		icon.time:Show()
		icon.timeLeft = expirationTime	
		icon:SetScript("OnUpdate", CreateBuffTimer)			
	else
		icon.time:Hide()
		icon.timeLeft = math.huge
		icon:SetScript("OnUpdate", nil)
	end

	-- Desaturate non-Player Debuffs
	if(icon.debuff) then
		if(unit == "target") then	
			if (unitCaster == 'player' or unitCaster == 'vehicle') then
				icon.icon:SetDesaturated(false)			   
			elseif(not UnitPlayerControlled(unit)) then -- If Unit is Player Controlled don't desaturate debuffs
				icon:SetBackdropColor(0, 0, 0)
				icon.overlay:SetVertexColor(0.3, 0.3, 0.3)	
				icon.icon:SetDesaturated(true)  
			end
		end
	end
	
	icon.first = true
end

-- generate auras
lib.gen_auras = function(f)
	Auras = CreateFrame("Frame", nil, f)
	Auras.size = Califpornia.CFG.unitframes.iconsize		
	Auras:SetHeight(41)
	Auras:SetWidth(245)
	Auras.spacing = 5
	if f.mystyle == "target" then
		Auras.numBuffs = 20
		Auras.numDebuffs = 25
	else
		Auras.numBuffs = 5
		Auras.numDebuffs = 5
	end
	Auras.gap = true
	Auras:SetPoint("TOPLEFT", f, "BOTTOMLEFT", 0, -10)
	Auras.initialAnchor = "TOPLEFT"
	Auras["growth-x"] = "RIGHT"		
	Auras["growth-y"] = "DOWN"
	Auras.PostCreateIcon = myPostCreateIcon
	Auras.PostUpdateIcon = myPostUpdateIcon
	f.Auras = Auras
end

-- ICONS
-- raid marks
lib.gen_raidmark = function(f)
	-- helper
	local h = CreateFrame("Frame", nil, f)
	h:SetAllPoints(f)
	h:SetFrameLevel(10)
	h:SetAlpha(0.8)

	-- icon
	local ri = h:CreateTexture(nil,'OVERLAY',h)
	ri:SetPoint("CENTER", f, "TOP", 0, 2)
	local size = retVal(f, 16, 13, 12, 16, 16)
	ri:SetSize(size, size)
	ri:SetTexture(CalifporniaCFG.media.raidIcons)

	f.RaidIcon = ri
end

-- ReadyCheck
lib.gen_readycheck = function(self)
	rCheck = self.Health:CreateTexture(nil, "OVERLAY")
	rCheck:SetSize(14, 14)
	rCheck:SetPoint("BOTTOMLEFT", self.Health, "TOPRIGHT", -13, -12)
	self.ReadyCheck = rCheck
end

-- generate RL/ML/assist icons
lib.gen_infoicons = function(f)
	local h = CreateFrame("Frame",nil,f)
	h:SetAllPoints(f)
	h:SetFrameLevel(10)

	-- group/raid leader icon
	li = h:CreateTexture(nil, "OVERLAY")
	li:SetPoint("TOPLEFT", f, 0, 8)
	li:SetSize(12,12)
	f.Leader = li

	-- assist icon
	ai = h:CreateTexture(nil, "OVERLAY")
	ai:SetPoint("TOPLEFT", f, 0, 8)
	ai:SetSize(12,12)
	f.Assistant = ai

	-- ML icon
	local ml = h:CreateTexture(nil, 'OVERLAY')
	ml:SetSize(10,10)
	ml:SetPoint('LEFT', f.Leader, 'RIGHT')
	f.MasterLooter = ml
end

-- PvP flag
lib.gen_pvpicon = function(f)
	local h = CreateFrame("Frame",nil,f)
	h:SetAllPoints(f)
	h:SetFrameLevel(10)
	f.PvP = h:CreateTexture(nil, "OVERLAY")
	local faction = PvPCheck
		if faction == "Horde" then
			f.PvP:SetTexCoord(0.08, 0.58, 0.045, 0.545)
		elseif faction == "Alliance" then
			f.PvP:SetTexCoord(0.07, 0.58, 0.06, 0.57)
		else
			f.PvP:SetTexCoord(0.05, 0.605, 0.015, 0.57)
		end
	f.PvP:SetHeight(16)
	f.PvP:SetWidth(16)
	f.PvP:SetPoint('BOTTOMLEFT', 10, 13)
--	f.PvP:SetPoint("TOP", 0, 10)
end

-- Combat/resting icon, player only
lib.gen_playericons = function (f)
	local h = CreateFrame("Frame",nil,f)
	h:SetAllPoints(f)
	h:SetFrameLevel(10)

	-- combat icon
	f.Combat = h:CreateTexture(nil, 'OVERLAY')
	f.Combat:SetSize(15,15)
	f.Combat:SetPoint('BOTTOMRIGHT', -10, 13)
	f.Combat:SetTexture('Interface\\CharacterFrame\\UI-StateIcon')
	f.Combat:SetTexCoord(0.58, 0.90, 0.08, 0.41)

	-- rest icon
	f.Resting = h:CreateTexture(nil, 'OVERLAY')
	f.Resting:SetSize(14,14)
	f.Resting:SetPoint('BOTTOMLEFT', 30, 13)
	f.Resting:SetTexture('Interface\\CharacterFrame\\UI-StateIcon')
	f.Resting:SetTexCoord(0.09, 0.43, 0.08, 0.42)
end

-- LFD Role icon
lib.gen_lfdicon = function(f)
	f.LFDRole = f.Power:CreateTexture(nil, 'OVERLAY')
	f.LFDRole:SetSize(13, 13)
	f.LFDRole:SetPoint('CENTER', f, 'RIGHT', 1, 0)
end

-- phase icon 
lib.gen_phaseicon = function(self)
	local picon = self.Health:CreateTexture(nil, 'OVERLAY')
	picon:SetPoint('TOPRIGHT', self, 'TOPRIGHT', 11, 11)
	picon:SetSize(20, 20)

	self.PhaseIcon = picon
end

-- quest icon
lib.gen_questicon = function(self)
	local qicon = self.Health:CreateTexture(nil, 'OVERLAY')
	qicon:SetPoint('TOPLEFT', self, 'TOPLEFT', 0, 8)
	qicon:SetSize(16, 16)

	self.QuestIcon = qicon
end

-- class specific elements
-- COMBOPOINTS
lib.gen_cpbar = function(self)
	if (playerClass ~= "ROGUE" and playerClass ~= "DRUID") then return end

	local combobar =  CreateFrame('Frame', nil, self)
	combobar:SetPoint('BOTTOMLEFT', self.Portrait, 'TOPLEFT', 0, 2)
	combobar:SetHeight(4)
	combobar:SetWidth(self.Portrait:GetWidth())
	local h = CreateFrame("Frame", nil, combobar)
	h:SetFrameLevel(3)
	h:SetPoint("TOPLEFT",-5,5)
	h:SetPoint("BOTTOMRIGHT",5,-5)
	lib.gen_backdrop(h)

	for i = 1, MAX_COMBO_POINTS do
		local cpoint = CreateFrame('StatusBar', nil, combobar)
		cpoint:SetSize((self.Portrait:GetWidth() / MAX_COMBO_POINTS)-2, 4)
		cpoint:SetStatusBarTexture(statusbar_texture)
		cpoint:SetFrameLevel(4)
		cpoint:SetStatusBarColor(unpack(cpColor[i]))
		if (i == 1) then
			cpoint:SetPoint('LEFT', combobar, 'LEFT', 1, 0)
		else
			cpoint:SetPoint('TOPLEFT', combobar[i-1], "TOPRIGHT", 2, 0)
		end
		local cpointBG = cpoint:CreateTexture(nil, 'BACKGROUND')
		cpointBG:SetAllPoints(cpoint)
		cpointBG:SetTexture(statusbar_texture)
		cpoint.bg = cpointBG
		cpoint.bg.multiplier = 0.3
		combobar[i] = cpoint
	end

	self.CPoints = combobar
end
-- HOLY POWER
-- HolyPowerbar
local hpOverride = function(self, event, unit, powerType)
	if(self.unit ~= unit or (powerType and powerType ~= 'HOLY_POWER')) then return end

	local hp = self.HolyPower
	if(hp.PreUpdate) then hp:PreUpdate(unit) end

	local num = UnitPower(unit, SPELL_POWER_HOLY_POWER)
	for i = 1, MAX_HOLY_POWER do
		if(i <= num) then
			hp[i]:SetAlpha(1)
		else
			hp[i]:SetAlpha(0.2)
		end
	end
end

lib.gen_holypower = function(self)
	if playerClass ~= "PALADIN" then return end
	
	self.HolyPower = CreateFrame("Frame", nil, self)
	self.HolyPower:SetPoint('BOTTOMLEFT', self.Portrait, 'TOPLEFT', 0, 2)
	self.HolyPower:SetHeight(4)
	self.HolyPower:SetWidth(self.Portrait:GetWidth())
	local h = CreateFrame("Frame", nil, self.HolyPower)
	h:SetFrameLevel(3)
	h:SetPoint("TOPLEFT",-5,5)
	h:SetPoint("BOTTOMRIGHT",5,-5)
	lib.gen_backdrop(h)
		
	for i = 1, 3 do
		self.HolyPower[i] = CreateFrame("StatusBar", self:GetName().."_Holypower"..i, self)
		self.HolyPower[i]:SetHeight(4)
		self.HolyPower[i]:SetWidth((self.Portrait:GetWidth() / 3)-2)
		self.HolyPower[i]:SetStatusBarTexture(statusbar_texture)
--		self.HolyPower[i]:SetStatusBarColor(.9,.95,.33)
		self.HolyPower[i]:SetStatusBarColor(1,1,0)
		self.HolyPower[i]:SetFrameLevel(4)

		if (i == 1) then
			self.HolyPower[i]:SetPoint('LEFT', self.HolyPower, 'LEFT', 1, 0)
		else
			self.HolyPower[i]:SetPoint('TOPLEFT', self.HolyPower[i-1], "TOPRIGHT", 2, 0)
		end
	end

	self.HolyPower.Override = hpOverride
end

-- DRUID MANA
lib.gen_druidmana = function(self)
	if playerClass ~= "DRUID" then return end

	local druidManaBar =  CreateFrame("Frame", nil, self)
	druidManaBar.colorClass = true
	druidManaBar:SetPoint('BOTTOMLEFT', self.Portrait, 'TOPLEFT', 0, 2)
	druidManaBar:SetHeight(4)
	druidManaBar:SetWidth(self.Portrait:GetWidth())
	druidManaBar:SetFrameLevel(4)
	local bd = CreateFrame("Frame", nil, druidManaBar)
	bd:SetFrameLevel(4)
	bd:SetPoint("TOPLEFT",-5,5)
	bd:SetPoint("BOTTOMRIGHT",5,-5)
	lib.gen_backdrop(bd)

	local ManaBar = CreateFrame('StatusBar', nil, druidManaBar)
	ManaBar:SetPoint('LEFT', druidManaBar, 'LEFT', 0, 0)
	ManaBar:SetSize(druidManaBar:GetWidth(), druidManaBar:GetHeight())
	ManaBar:SetStatusBarTexture(statusbar_texture)
	ManaBar:GetStatusBarTexture():SetHorizTile(true)
	ManaBar:SetFrameLevel(5)

	local DMBText = lib.gen_fontstring(ManaBar, mfont, 10, "OUTLINE")
	DMBText:SetPoint('CENTER', ManaBar, 'CENTER', 0, 0)
	self:Tag(DMBText, '[cpuf:druidmana]')

	druidManaBar.ManaBar = ManaBar
	self.DruidMana = druidManaBar
end

-- ECLIPSE BAR
local eclipseBarBuff = function(self, unit)
	if self.hasSolarEclipse then
		self.eBarBG:SetBackdropBorderColor(1,1,.5,.7)
	elseif self.hasLunarEclipse then
		self.eBarBG:SetBackdropBorderColor(.2,.2,1,.7)
	else
		self.eBarBG:SetBackdropBorderColor(0,0,0,1)
	end
end

lib.gen_eclipse = function(self)
	if playerClass ~= "DRUID" then return end
	
	local eclipseBar = CreateFrame('Frame', nil, self)
	eclipseBar:SetPoint('BOTTOMLEFT', self.Portrait, 'TOPLEFT', 0, 2)
	eclipseBar:SetHeight(4)
	eclipseBar:SetWidth(self.Portrait:GetWidth())
	eclipseBar:SetFrameLevel(4)
	local h = CreateFrame("Frame", nil, eclipseBar)
	h:SetPoint("TOPLEFT",-5,5)
	h:SetPoint("BOTTOMRIGHT",5,-5)
	lib.gen_backdrop(h)
	eclipseBar.eBarBG = h

	local lunarBar = CreateFrame('StatusBar', nil, eclipseBar)
	lunarBar:SetPoint('LEFT', eclipseBar, 'LEFT', 0, 0)
	lunarBar:SetSize(eclipseBar:GetWidth(), eclipseBar:GetHeight())
	lunarBar:SetStatusBarTexture(statusbar_texture)
	lunarBar:SetStatusBarColor(0, .1, .7)
	lunarBar:SetFrameLevel(5)

	local solarBar = CreateFrame('StatusBar', nil, eclipseBar)
	solarBar:SetPoint('LEFT', lunarBar:GetStatusBarTexture(), 'RIGHT', 0, 0)
	solarBar:SetSize(eclipseBar:GetWidth(), eclipseBar:GetHeight())
	solarBar:SetStatusBarTexture(statusbar_texture)
	solarBar:SetStatusBarColor(1,1,.13)
	solarBar:SetFrameLevel(5)

    local EBText = lib.gen_fontstring(solarBar, mfont, 10, "OUTLINE")
	EBText:SetPoint('CENTER', eclipseBar, 'CENTER', 0, 0)
	self:Tag(EBText, '[pereclipse]')
	
	eclipseBar.SolarBar = solarBar
	eclipseBar.LunarBar = lunarBar
	self.EclipseBar = eclipseBar
	self.EclipseBar.PostUnitAura = eclipseBarBuff
end

-- TOTEM BAR
lib.gen_totembar = function(self)
	if playerClass ~= "SHAMAN" then return end

	local width = (self.Portrait:GetWidth()) / 4 - 1
	local height = 4
	local TotemBar = CreateFrame("Frame", nil, self)
	TotemBar:SetPoint('BOTTOMLEFT', self.Portrait, 'TOPLEFT', 0, 2)
	TotemBar:SetWidth(self.Portrait:GetWidth())
	TotemBar:SetHeight(height)
	TotemBar.Destroy = true
	TotemBar.AbbreviateNames = true
	TotemBar.UpdateColors = true
	local bd = CreateFrame("Frame", nil, TotemBar)
	bd:SetFrameLevel(4)
	bd:SetPoint("TOPLEFT",-5,5)
	bd:SetPoint("BOTTOMRIGHT",5,-5)
	lib.gen_backdrop(bd)
	TotemBar.BackDrop = bd
	for i = 1, 4 do
		local t = CreateFrame("Frame", nil, TotemBar)
		t:SetPoint("LEFT", (i - 1) * (width + 2), 0)
		t:SetWidth(width)
		t:SetHeight(height)
	
		local bar = CreateFrame("StatusBar", nil, t)
		bar:SetWidth(width)
		bar:SetPoint"BOTTOM"
		bar:SetHeight(4)
		bar:SetFrameLevel(4)
		bar:SetStatusBarTexture(statusbar_texture)
		t.StatusBar = bar	
		TotemBar[i] = t
	end
	self.TotemBar = TotemBar
end

-- SOUL SHARDS
local ssOverride = function(self, event, unit, powerType)
	if(self.unit ~= unit or (powerType and powerType ~= 'SOUL_SHARDS')) then return end

	local ss = self.SoulShards

	local num = UnitPower(unit, SPELL_POWER_SOUL_SHARDS)
	for i = 1, SHARD_BAR_NUM_SHARDS do
		if(i <= num) then
			ss[i]:SetAlpha(1)
		else
			ss[i]:SetAlpha(0.2)
		end
	end
end

lib.gen_soulshards = function(self)
	if playerClass ~= "WARLOCK" then return end
	
	local shards = CreateFrame('Frame', nil, self)
	shards:SetPoint('BOTTOMLEFT', self.Portrait, 'TOPLEFT', 0, 2)
	shards:SetHeight(4)
	shards:SetWidth(self.Portrait:GetWidth())
	local h = CreateFrame("Frame", nil, shards)
	h:SetFrameLevel(3)
	h:SetPoint("TOPLEFT",-5,5)
	h:SetPoint("BOTTOMRIGHT",5,-5)
	lib.gen_backdrop(h)
	
	for i= 1, 3 do
		local shard = CreateFrame('StatusBar', nil, shards)
		shard:SetSize((self.Portrait:GetWidth() / 3)-2, 4)
		shard:SetStatusBarTexture(statusbar_texture)
		shard:SetStatusBarColor(.86,.44, 1)
		shard:SetFrameLevel(4)
		
		if (i == 1) then
			shard:SetPoint('LEFT', shards, 'LEFT', 1, 0)
		else
			shard:SetPoint('TOPLEFT', shards[i-1], "TOPRIGHT", 2, 0)
		end

		shards[i] = shard
	end
	self.SoulShards = shards
	self.SoulShards.Override = ssOverride
end

-- RUNE BAR
lib.gen_runebar = function(self)
	if playerClass ~= "DEATHKNIGHT" then return end

	local runes = CreateFrame('Frame', nil, self)
	runes:SetPoint('BOTTOMLEFT', self.Portrait, 'TOPLEFT', 0, 2)
	runes:SetHeight(4)
	runes:SetWidth(self.Portrait:GetWidth())
	local h = CreateFrame("Frame", nil, runes)
	h:SetFrameLevel(3)
	h:SetPoint("TOPLEFT",-5,5)
	h:SetPoint("BOTTOMRIGHT",5,-5)
	lib.gen_backdrop(h)
	
	for i= 1, 6 do
		local rune = CreateFrame('StatusBar', nil, runes)
		rune:SetSize((self.Portrait:GetWidth() / 6)-2, 4)
		rune:SetStatusBarTexture(statusbar_texture)
		rune:SetFrameLevel(4)
		
		if (i == 1) then
			rune:SetPoint('LEFT', runes, 'LEFT', 1, 0)
		else
			rune:SetPoint('TOPLEFT', runes[i-1], "TOPRIGHT", 2, 0)
		end
		local runeBG = rune:CreateTexture(nil, 'BACKGROUND')
		runeBG:SetAllPoints(rune)
		runeBG:SetTexture(statusbar_texture)
		rune.bg = runeBG
		rune.bg.multiplier = 0.3
		runes[i] = rune
	end
	self.Runes = runes
end

-- THREAT BORDERS
-- Create Threat Status Border
lib.gen_threatborder = function(self)
	local glowBorder = {edgeFile = "Interface\\ChatFrame\\ChatFrameBackground", edgeSize = 2}
	self.Thtborder = CreateFrame("Frame", nil, self)
	self.Thtborder:SetPoint("TOPLEFT", self, "TOPLEFT", -2, 2)
	self.Thtborder:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 2, -2)
	self.Thtborder:SetBackdrop(glowBorder)
	self.Thtborder:SetFrameLevel(1)
	self.Thtborder:Hide()	
end
  
-- Raid Frames Threat Highlight
function lib.UpdateThreat(self, event, unit)
	if (self.unit ~= unit) then return end
	local status = UnitThreatSituation(unit)
	unit = unit or self.unit
	if status and status > 1 then
		local r, g, b = GetThreatStatusColor(status)
		self.Thtborder:Show()
		self.Thtborder:SetBackdropBorderColor(r, g, b, 1)
	else
		self.Thtborder:SetBackdropBorderColor(r, g, b, 0)
		self.Thtborder:Hide()
	end
end

-- target border
-- Create Target Border
lib.gen_targetborder = function(self)
	local glowBorder = {edgeFile = "Interface\\ChatFrame\\ChatFrameBackground", edgeSize = 1}
	self.TargetBorder = CreateFrame("Frame", nil, self)
	self.TargetBorder:SetPoint("TOPLEFT", self, "TOPLEFT", -1, 1)
	self.TargetBorder:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 1, -1)
	self.TargetBorder:SetBackdrop(glowBorder)
	self.TargetBorder:SetFrameLevel(2)
	self.TargetBorder:SetBackdropBorderColor(.7,.7,.7,1)
	self.TargetBorder:Hide()
end

-- Raid Frames Target Highlight Border
function lib.ChangedTarget(self, event, unit)
	if UnitIsUnit('target', self.unit) then
		self.TargetBorder:Show()
	else
		self.TargetBorder:Hide()
	end
end

-- PLUGIN STUFF
-- oUF_DebuffHighlight
lib.gen_debuff_hl = function(self)
	local dbh = self.Health:CreateTexture(nil, "OVERLAY")
	dbh:SetAllPoints(self.Health)
	dbh:SetTexture(CalifporniaCFG.media.debuff_hl)
	dbh:SetBlendMode("ADD")
	dbh:SetVertexColor(0,0,0,0) -- set alpha to 0 to hide the texture
	self.DebuffHighlight = dbh
	self.DebuffHighlightAlpha = 0.5
	self.DebuffHighlightFilter = true
end

-- Raid Debuffs

lib.gen_raiddebuffs = function(f)
	local instDebuffs = {}
	local instances = CalifporniaCFG.raid_debuffs.instances
	local getzone = function()
		local zone = GetInstanceInfo()
		if instances[zone] then
			instDebuffs = instances[zone]
		else
			instDebuffs = {}
		end
	end

	local debuffs = CalifporniaCFG.raid_debuffs.debuffs
	local CustomFilter = function(icons, ...)
		local _, icon, name, _, _, _, dtype, _, _, _, _, _, spellid = ...
		if instDebuffs[name] then
			icon.priority = instDebuffs[name]
			return true
		elseif instDebuffs[spellid] then
			icon.priority = instDebuffs[spellid]
			return true
		elseif debuffs[name] then
			icon.priority = debuffs[name]
			return true
		elseif debuffs[spellid] then
			icon.priority = debuffs[spellid]
			return true
		else
			icon.priority = 0
		end
	end

	local dbsize = 12
	local rdebuffs = CreateFrame("Frame", nil, f)
	rdebuffs:SetWidth(dbsize)
	rdebuffs:SetHeight(dbsize)
	rdebuffs:SetPoint("BOTTOMLEFT", 1, 2)
	rdebuffs.size = dbsize
	rdebuffs.CustomFilter = CustomFilter

	f.raidDebuffs = rdebuffs
end

-- CAST BARS
lib.gen_castbar = function(f)
	if not CalifporniaCFG.unitframes.unitcastbar then return end
	local cbColor = {95/255, 182/255, 255/255}
	local s = CreateFrame("StatusBar", "oUF_CpUICastbar"..f.mystyle, f)
	if f.mystyle == "player" then
		s:SetHeight(20)
		s:SetWidth(230)
		s:SetPoint("BOTTOMRIGHT",UIParent,"BOTTOM",-24,150)
	elseif f.mystyle == "target" then
		s:SetHeight(20)
		s:SetWidth(245)
		s:SetPoint("BOTTOMLEFT",UIParent,"BOTTOM",24,150)
	elseif f.mystyle == "pet" then
		s:SetHeight(20)
		s:SetWidth(230)
		s:SetPoint("BOTTOMRIGHT",UIParent,"BOTTOM",-24,176)
	else
		s:SetHeight(20)
		s:SetWidth(200)
		s:SetPoint("CENTER",UIParent,"CENTER",10,300)
	end

	s:SetStatusBarTexture(statusbar_texture)
	s:SetStatusBarColor(95/255, 182/255, 255/255,1)
	s:SetFrameLevel(1)

	s.CastingColor = cbColor
	s.CompleteColor = {20/255, 208/255, 0/255}
	s.FailColor = {255/255, 12/255, 0/255}
	s.ChannelingColor = cbColor

	local h = CreateFrame("Frame", nil, s)
	h:SetFrameLevel(0)
	h:SetPoint("TOPLEFT",-5,5)
	h:SetPoint("BOTTOMRIGHT",5,-5)
	h:SetFrameLevel(1)
	lib.gen_backdrop(h)

	sp = s:CreateTexture(nil, "OVERLAY")
	sp:SetBlendMode("ADD")
	sp:SetAlpha(0.5)
	sp:SetHeight(s:GetHeight()*2.5)

	local txt = lib.gen_fontstring(s, mfont, 12, "NONE")
	txt:SetPoint("LEFT", 2, 0)
	txt:SetJustifyH("LEFT")

	local t = lib.gen_fontstring(s, mfont, 12, "NONE")
	t:SetPoint("RIGHT", -2, 0)
	txt:SetPoint("RIGHT", t, "LEFT", -5, 0)

	local i = s:CreateTexture(nil, "ARTWORK")
	i:SetSize(s:GetHeight(),s:GetHeight())
	i:SetPoint("RIGHT", s, "LEFT", -4.5, 0)
	i:SetTexCoord(0.1, 0.9, 0.1, 0.9)

	if f.mystyle ~= "player" then
		-- generate shield
		local shield = s:CreateTexture(nil, "BACKGROUND")
		shield:SetTexture("Interface\\CastingBar\\UI-CastingBar-Small-Shield")
		shield:SetTexCoord(0, 36/256, 0, 1)
		shield:SetWidth(36)
		shield:SetHeight(64)
		shield:SetPoint("CENTER", i, "CENTER", -2, -1)
		shield:Hide()
		s.Shield = shield
	end
	
	local h2 = CreateFrame("Frame", nil, s)
	h2:SetFrameLevel(0)
	h2:SetPoint("TOPLEFT",i,"TOPLEFT",-5,5)
	h2:SetPoint("BOTTOMRIGHT",i,"BOTTOMRIGHT",5,-5)
	lib.gen_backdrop(h2)

	if f.mystyle == "player" then
		local z = s:CreateTexture(nil,"OVERLAY")
		z:SetTexture(statusbar_texture)
		z:SetVertexColor(1,0.1,0,.6)
		z:SetPoint("TOPRIGHT")
		z:SetPoint("BOTTOMRIGHT")
		s:SetFrameLevel(10)
		s.SafeZone = z

		local l = lib.gen_fontstring(s, mfont, 10, "THINOUTLINE")
		l:SetPoint("CENTER", -2, 17)
		l:SetJustifyH("RIGHT")
		l:Hide()
		s.Lag = l
		f:RegisterEvent("UNIT_SPELLCAST_SENT", CalifporniaCFG.castbar.OnCastSent)
	end

	s.OnUpdate = CalifporniaCFG.castbar.OnCastbarUpdate
	s.PostCastStart = CalifporniaCFG.castbar.PostCastStart
	s.PostChannelStart = CalifporniaCFG.castbar.PostCastStart
	s.PostCastStop = CalifporniaCFG.castbar.PostCastStop
	s.PostChannelStop = CalifporniaCFG.castbar.PostChannelStop
	s.PostCastFailed = CalifporniaCFG.castbar.PostCastFailed
	s.PostCastInterrupted = CalifporniaCFG.castbar.PostCastFailed

	f.Castbar = s
	f.Castbar.Text = txt
	f.Castbar.Time = t
	f.Castbar.Icon = i
	f.Castbar.shield = i
	f.Castbar.Spark = sp
end
------------------------------------------------------------------------
-- STYLE function
------------------------------------------------------------------------
local function Shared(self, unit)
	-- shared
	self.menu = lib.gen_dropdown

	-- register for clicks
	self:RegisterForClicks("AnyUp")
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)

	-- per unit
	if (unit == "player") then

		self.mystyle = "player"
		
		-- Size and Scale
		self:SetScale(1)
		self:SetSize(220, 60)

		-- Generate Bars
		lib.gen_hpbar(self)
		lib.gen_hpstrings(self)
		lib.gen_powerbar(self)
		lib.gen_highlight(self)
		lib.gen_raidmark(self)
		lib.gen_portrait(self)
		lib.gen_infoicons(self)
		lib.gen_playericons(self)
		lib.gen_lfdicon(self)
		lib.gen_pvpicon(self)
		-- castbar
		lib.gen_castbar(self)
		--style specific stuff
		self.Health.frequentUpdates = false
		self.Health.colorSmooth = true
		self.Power.colorClass = true
		self.Power.bg.multiplier = 0.5

		-- class specific
		if CalifporniaCFG.unitframes.holypower then lib.gen_holypower(self) end
		if CalifporniaCFG.unitframes.druidmana then lib.gen_druidmana(self) end
		if CalifporniaCFG.unitframes.eclipsebar then lib.gen_eclipse(self) end
		if CalifporniaCFG.unitframes.totembar then lib.gen_totembar(self) end
		if CalifporniaCFG.unitframes.soulshards then lib.gen_soulshards(self) end
		if CalifporniaCFG.unitframes.runebar then lib.gen_runebar(self) end

		-- plugins
		lib.gen_debuff_hl(self)
	end

	if (unit == "target") then

		self.mystyle = "target"
		
		-- Size and Scale
		self:SetScale(1)
		self:SetSize(220, 60)

		-- Generate Bars
		lib.gen_hpbar(self)
		lib.gen_hpstrings(self)
		lib.gen_powerbar(self)
		lib.gen_highlight(self)
		lib.gen_raidmark(self)
		lib.gen_portrait(self)
		-- castbar
		lib.gen_castbar(self)
		--style specific stuff
		self.Health.frequentUpdates = false
		self.Health.colorSmooth = true
		self.Power.colorTapping = true
		self.Power.colorDisconnected = true
		self.Power.colorHappiness = false
		self.Power.colorClass = true
		self.Power.colorReaction = true
		self.Power.colorClass = true
		self.Power.bg.multiplier = 0.5

		lib.gen_infoicons(self)
		lib.gen_pvpicon(self)
		lib.gen_phaseicon(self)
		lib.gen_questicon(self)
		lib.gen_auras(self)

		-- class specific
		if CalifporniaCFG.unitframes.runebar then lib.gen_cpbar(self) end
	end

	if (unit == "targettarget") then

		self.mystyle = "tot"
		
		-- Size and Scale
		self:SetScale(1)
		self:SetSize(120, 27)

		-- Generate Bars
		lib.gen_hpbar(self)
		lib.gen_hpstrings(self)
		lib.gen_powerbar(self)
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

	end

	if (unit == "focus") then

		self.mystyle = "focus"
		
		-- Size and Scale
		self:SetScale(1)
		self:SetSize(122, 27)

		-- Generate Bars
		lib.gen_hpbar(self)
		lib.gen_hpstrings(self)
		lib.gen_powerbar(self)
		lib.gen_highlight(self)
		lib.gen_raidmark(self)
		-- castbar
		lib.gen_castbar(self)

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
	end

	if (unit == "focustarget") then

		self.mystyle = "focustarget"
		
		-- Size and Scale
		self:SetScale(1)
		self:SetSize(120, 27)

		-- Generate Bars
		lib.gen_hpbar(self)
		lib.gen_hpstrings(self)
		lib.gen_powerbar(self)
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
	end

	if (unit == "pet") then

		self.mystyle = "pet"
		
		self.Range = {
			insideAlpha = 1,
			outsideAlpha = .5,
		}
		-- Size and Scale
		self:SetScale(1)
		self:SetSize(122, 27)

		-- Generate Bars
		lib.gen_hpbar(self)
		lib.gen_hpstrings(self)
		lib.gen_powerbar(self)
		lib.gen_highlight(self)
		lib.gen_raidmark(self)
		-- castbar
		lib.gen_castbar(self)

		--style specific stuff
		self.Health.frequentUpdates = false
		self.Health.colorSmooth = true
		self.Power.colorTapping = true
		self.Power.colorDisconnected = true
		self.Power.colorHappiness = true
		self.Power.colorClass = true
		self.Power.colorReaction = true
		self.Power.colorHealth = true
		self.Power.bg.multiplier = 0.5
	end

	if (unit == "pettarget") then

		self.mystyle = "pettarget"
		
		-- Size and Scale
		self:SetScale(1)
		self:SetSize(120, 27)

		-- Generate Bars
		lib.gen_hpbar(self)
		lib.gen_hpstrings(self)
		lib.gen_powerbar(self)
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
	end

	if (unit == "party") then

		self.mystyle = "group"

		self.Range = {
			insideAlpha = 1,
			outsideAlpha = .5,
		}
		
		-- Size and Scale
		self:SetScale(1)
		self:SetSize(180, 40)

		-- Generate Bars
		lib.gen_hpbar(self)
		lib.gen_hpstrings(self)
		lib.gen_powerbar(self)
		lib.gen_highlight(self)
		lib.gen_readycheck(self)
		lib.gen_raidmark(self)
		lib.gen_infoicons(self)
		lib.gen_lfdicon(self)
		lib.gen_targetborder(self)
		lib.gen_threatborder(self)

		--style specific stuff
		self.Health.frequentUpdates = false
		self.Health.colorSmooth = true
		self.Power.colorClass = true
		self.Power.colorDisconnected = true
		self.Power.bg.multiplier = 0.5
		self:RegisterEvent('PLAYER_TARGET_CHANGED', lib.ChangedTarget)
		self:RegisterEvent('PARTY_MEMBERS_CHANGED', lib.ChangedTarget)
		self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", lib.UpdateThreat)
		self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", lib.UpdateThreat)

		-- plugins
		lib.gen_debuff_hl(self)
	end

	-- party target
--	if (self.unit and self.unit:match("party%dtarget")) then
--	if (self:GetAttribute("unitsuffix") == "partyUnitButton%dTarget") then
	if (self:GetAttribute("unitsuffix") == "target" and self:GetParent():GetName():match("oUF_Califpornia_party")) then
		self.mystyle = "partytarget"
		
		-- Size and Scale
		self:SetScale(1)
		self:SetSize(100, 27)

		-- Generate Bars
		lib.gen_hpbar(self)
		lib.gen_hpstrings(self)
		lib.gen_powerbar(self)
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
	end

	-- party pet
	if (self:GetAttribute("unitsuffix") == "pet") then
		self.mystyle = "slim"
		
		-- Size and Scale
		self:SetScale(1)
		self:SetSize(100, 20)

		-- Generate Bars
		lib.gen_hpbar(self)
		lib.gen_hpstrings(self)
		lib.gen_powerbar(self)
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
	end


	if (unit == "raid") then

		self.mystyle = "raid"
		
		self.Range = {
			insideAlpha = 1,
			outsideAlpha = .5,
		}

		-- Generate Bars
		lib.gen_hpbar(self)
		lib.gen_hpstrings(self)
		lib.gen_powerbar(self)
		lib.gen_highlight(self)
		lib.gen_readycheck(self)
		lib.gen_raidmark(self)
		lib.gen_infoicons(self)
		lib.gen_lfdicon(self)

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
		lib.gen_targetborder(self)
		lib.gen_threatborder(self)
		self:RegisterEvent('PLAYER_TARGET_CHANGED', lib.ChangedTarget)
		self:RegisterEvent('RAID_ROSTER_UPDATE', lib.ChangedTarget)
		self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", lib.UpdateThreat)
		self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", lib.UpdateThreat)
		-- plugins
		lib.gen_debuff_hl(self)
		lib.gen_raiddebuffs(self)
	end

	if (unit and unit:find("boss%d")) then

		self.mystyle = "group"

		-- Size and Scale
		self:SetScale(1)
		self:SetSize(180, 24)

		-- Generate Bars
		lib.gen_hpbar(self)
		lib.gen_hpstrings(self)
--		lib.gen_powerbar(self)
		lib.gen_highlight(self)
		lib.gen_raidmark(self)

		--style specific stuff
		self.Health.frequentUpdates = false
		self.Health.colorSmooth = true
--[[		self.Power.colorSmooth = true
		self.Power.colorTapping = true
		self.Power.colorDisconnected = true
		self.Power.colorHappiness = false
		self.Power.colorClass = true
		self.Power.colorReaction = true
		self.Power.colorHealth = true]]


		-- temp
		self.h:SetPoint("BOTTOMRIGHT", 5, -5)

	end

	return self
end
oUF:RegisterStyle('Califpornia', Shared)



------------------------------------------------------------------------
-- SPAWNS
------------------------------------------------------------------------
-- player
local player = oUF:Spawn('player', "oUF_Califpornia_player")
player:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 10, -10)

-- target
local target = oUF:Spawn('target', "oUF_Califpornia_target")
target:SetPoint("TOPLEFT", player, "TOPRIGHT", 8, 0)

-- target of target
local tot = oUF:Spawn('targettarget', "oUF_Califpornia_targettarget")
tot:SetPoint("TOPLEFT", target, "TOPRIGHT", 8, 0)

-- focus
local focus = oUF:Spawn('focus', "oUF_Califpornia_focus")
focus:SetPoint("TOPLEFT", player, "BOTTOMLEFT", 0, -8)

-- focus target
local focustarget = oUF:Spawn('focustarget', "oUF_Califpornia_focustarget")
focustarget:SetPoint("TOPLEFT", focus, "TOPRIGHT", 8, 0)

-- pet
local pet = oUF:Spawn('pet', "oUF_Califpornia_pet")
pet:SetPoint("TOPLEFT", player, "BOTTOMLEFT", 0, -43)

-- focus target
local pettarget = oUF:Spawn('pettarget', "oUF_Califpornia_pettarget")
pettarget:SetPoint("TOPLEFT", pet, "TOPRIGHT", 8, 0)


-- A small helper to change the style into a unit specific, if it exists.
local spawnHelper = function(self, unit, ...)
		self:SetActiveStyle'Califpornia'
		local object = self:Spawn(unit)
		object:SetPoint(...)
		return object
end

oUF:Factory(function(self)
	-- RAID
	CompactRaidFrameContainer:Hide()
	if CalifporniaCFG.unitframes.showraidmanager ~= true then
		CompactRaidFrameManager:SetAlpha(0)
	end

	local maxGroups = 8

	local fheight = 28
	local fwidth = 100

	local raid_groups = {};
	local cur_y;
	local cur_x;

	if CalifporniaCFG.unitframes.alt_layout then
		-- Ennie's raid frame layout, separate group frames
		local party = self:SpawnHeader('oUF_Califpornia_party', nil, 'party',
			'showParty', true,
--		'showPlayer', true,
			'yOffset', -40,
			'xOffset', 0,
			'maxColumns', 1,
--		'unitsPerColumn', 5,
			'unitsPerColumn', 4,
			'columnAnchorPoint', 'TOPLEFT',
			'template', 'oUF_cParty',
			'oUF-initialConfigFunction', [[
				self:SetWidth(180)
				self:SetHeight(40)
			]]
		)
		party:SetPoint("TOPLEFT", player, "BOTTOMLEFT", 0, -130)
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
				"maxColumns", maxGroups,
				"unitsPerColumn", 5,
				"columnSpacing", 7,
				"point", "TOP",
				"columnAnchorPoint", "LEFT",
				"oUF-initialConfigFunction", ([[
				self:SetWidth(%d)
				self:SetHeight(%d)
				]]):format(100, 18))
			raid_groups[i]:SetScale(1)
			--[[ -_- ]]--
			if i == 1 then 
				raid_groups[i]:SetPoint("TOPLEFT", oUF_Califpornia_player, "BOTTOMLEFT", 0, -100)
--			elseif i == 4 or i == 7 then
			elseif i == 6 then
				raid_groups[i]:SetPoint("TOPLEFT", raid_groups[1], "TOPRIGHT", 9, 0)
			else
				raid_groups[i]:SetPoint("TOPLEFT", raid_groups[i-1], "BOTTOMLEFT", 0, -15)
			end
		end
	else
	-- GRID-like raid frame layout
		for i = 1, maxGroups do
			raid_groups[i] = oUF:SpawnHeader("oUF_CalifporniaGrid"..i, nil, "solo,party,raid", 
				"showRaid", true,  
				"showPlayer", true,
				"showSolo", true,
				"showParty", true,
				"xoffset", 5,
				"yOffset", -7,
				"groupFilter", i,
				"groupBy", "GROUP",
				"groupingOrder", "1,2,3,4,5,6,7,8",
				"sortMethod", "INDEX",
				"maxColumns", maxGroups,
				"unitsPerColumn", 5,
				"columnSpacing", 7,
				"point", "LEFT",
				"columnAnchorPoint", "TOP",
				"oUF-initialConfigFunction", ([[
				self:SetWidth(%d)
				self:SetHeight(%d)
				]]):format(fwidth, fheight))
			raid_groups[i]:SetScale(1)
			if i == 1 then 
				raid_groups[i]:SetPoint("TOP", 'UIParent', "BOTTOM", 0, 440)
			else
				raid_groups[i]:SetPoint("TOPLEFT", raid_groups[i-1], "BOTTOMLEFT", 0, -5)
			end
		end
	end

	local boss = {}
	for i = 1, MAX_BOSS_FRAMES do
		boss[i] = oUF:Spawn("boss"..i, "oUF_Califpornia_Boss"..i)
		if i == 1 then
			boss[i]:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -10, -250)
		else
			boss[i]:SetPoint('TOP', boss[i-1], 'BOTTOM', 0, -10)		 
		end
	end
	for i, v in ipairs(boss) do v:Show() end
end)












------------------------------------------------------------------------
-- Right-Click on unit frames menu. 
-- Doing this to remove SET_FOCUS eveywhere.
-- SET_FOCUS work only on default unitframes.
-- Main Tank and Main Assist, use /maintank and /mainassist commands.
------------------------------------------------------------------------
-- remove SET_FOCUS & CLEAR_FOCUS from menu, to prevent errors
do 
    for k,v in pairs(UnitPopupMenus) do
		for x,y in pairs(UnitPopupMenus[k]) do
		if y == "SET_FOCUS" then
			  table.remove(UnitPopupMenus[k],x)
		elseif y == "CLEAR_FOCUS" then
			  table.remove(UnitPopupMenus[k],x)
		end
		end
    end
end


--[[
do
	UnitPopupMenus["SELF"] = { "PVP_FLAG", "LOOT_METHOD", "LOOT_THRESHOLD", "OPT_OUT_LOOT_TITLE", "LOOT_PROMOTE", "DUNGEON_DIFFICULTY", "RAID_DIFFICULTY", "CONVERT_GROUP", "RESET_INSTANCES", "RAID_TARGET_ICON", "SELECT_ROLE", "LEAVE", "CANCEL" };
	UnitPopupMenus["PET"] = { "PET_PAPERDOLL", "PET_RENAME", "PET_ABANDON", "PET_DISMISS", "CANCEL" };
	UnitPopupMenus["PARTY"] = { "MUTE", "UNMUTE", "PARTY_SILENCE", "PARTY_UNSILENCE", "RAID_SILENCE", "RAID_UNSILENCE", "BATTLEGROUND_SILENCE", "BATTLEGROUND_UNSILENCE", "WHISPER", "PROMOTE", "PROMOTE_GUIDE", "LOOT_PROMOTE", "VOTE_TO_KICK", "UNINVITE", "INSPECT", "ACHIEVEMENTS", "TRADE", "FOLLOW", "DUEL", "RAID_TARGET_ICON", "SELECT_ROLE", "PVP_REPORT_AFK", "RAF_SUMMON", "RAF_GRANT_LEVEL", "CANCEL" }
	UnitPopupMenus["PLAYER"] = { "WHISPER", "INSPECT", "INVITE", "ACHIEVEMENTS", "TRADE", "FOLLOW", "DUEL", "RAID_TARGET_ICON", "RAF_SUMMON", "RAF_GRANT_LEVEL", "CANCEL" }
	UnitPopupMenus["RAID_PLAYER"] = { "MUTE", "UNMUTE", "RAID_SILENCE", "RAID_UNSILENCE", "BATTLEGROUND_SILENCE", "BATTLEGROUND_UNSILENCE", "WHISPER", "INSPECT", "ACHIEVEMENTS", "TRADE", "FOLLOW", "DUEL", "RAID_TARGET_ICON", "SELECT_ROLE", "RAID_LEADER", "RAID_PROMOTE", "RAID_DEMOTE", "LOOT_PROMOTE", "RAID_REMOVE", "PVP_REPORT_AFK", "RAF_SUMMON", "RAF_GRANT_LEVEL", "CANCEL" };
	UnitPopupMenus["RAID"] = { "MUTE", "UNMUTE", "RAID_SILENCE", "RAID_UNSILENCE", "BATTLEGROUND_SILENCE", "BATTLEGROUND_UNSILENCE", "RAID_LEADER", "RAID_PROMOTE", "RAID_MAINTANK", "RAID_MAINASSIST", "RAID_TARGET_ICON", "LOOT_PROMOTE", "RAID_DEMOTE", "RAID_REMOVE", "PVP_REPORT_AFK", "CANCEL" };
	UnitPopupMenus["VEHICLE"] = { "RAID_TARGET_ICON", "VEHICLE_LEAVE", "CANCEL" }
	UnitPopupMenus["TARGET"] = { "RAID_TARGET_ICON", "CANCEL" }
	UnitPopupMenus["ARENAENEMY"] = { "CANCEL" }
	UnitPopupMenus["FOCUS"] = { "RAID_TARGET_ICON", "CANCEL" }
	UnitPopupMenus["BOSS"] = { "RAID_TARGET_ICON", "CANCEL" }
end
]]--

