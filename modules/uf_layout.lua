if CalifporniaCFG["unitframes"].enable ~= true then return end

local statusbar_texture = Califpornia.CFG.media.normTex
local mfont = Califpornia.CFG.media.uffont
local playerClass = Califpornia.CFG.myclass
oUF.colors.smooth = {42/255,48/255,50/255, 42/255,48/255,50/255, 42/255,48/255,50/255}
oUF.colors.runes = {{0.87, 0.12, 0.23};{0.40, 0.95, 0.20};{0.14, 0.50, 1};{.70, .21, 0.94};}
oUF.colors.totems = {
	{ 255/255, 072/255, 000/255 }, -- fire
	{ 073/255, 230/255, 057/255 }, -- earth
	{ 069/255, 176/255, 218/255 }, -- water
	{ 157/255, 091/255, 231/255 }  -- air
}
local cpColor = {{0.99, 0.31, 0.31};{0.99, 0.31, 0.31};{0.85, 0.83, 0.35};{0.85, 0.83, 0.35};{0.33, 0.99, 0.33};}

--backdrop table
local backdrop_tab = { 
	bgFile = Califpornia.CFG.media.bdTex, 
	edgeFile = Califpornia.CFG.media.bdedgeTex,
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
lib.gen_backdrop_old = function(f)
	f:SetBackdrop(backdrop_tab);
	f:SetBackdropColor(0,0,0,1)
	f:SetBackdropBorderColor(0,0,0,0.8)
end
lib.gen_backdrop = function(anchorFrame, frameLevel, outset)
	if not outset then
		outset = 5
	end
	local hintFrame = CreateFrame("Frame", nil, anchorFrame)
	hintFrame:SetPoint("TOPLEFT",-outset,outset)
	hintFrame:SetPoint("BOTTOMRIGHT",outset,-outset)
	hintFrame:SetFrameLevel(frameLevel)
	hintFrame:SetBackdrop(backdrop_tab);
	hintFrame:SetBackdropColor(0,0,0,1)
	hintFrame:SetBackdropBorderColor(0,0,0,0.8)
	hintFrame.origColor = {0,0,0,0.8}
	return hintFrame
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
	hl:SetTexture(Califpornia.CFG.media.hilightTex)
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
lib.gen_hpbar = function(f,barheight)
	--statusbar
	local s = CreateFrame("StatusBar", nil, f)
	s:SetStatusBarTexture(Califpornia.CFG.media.normTex)
	s:GetStatusBarTexture():SetHorizTile(true)
	s:SetHeight(barheight)
	s:SetWidth(f:GetWidth())
	s:SetPoint("TOP",0,0)

	--bg
	local b = s:CreateTexture(nil, "BACKGROUND")
	b:SetTexture(Califpornia.CFG.media.normTex)
	b:SetAllPoints(s)
	b:SetVertexColor(1, 0.1, 0.1,1)

	f.Health = s
	f.Health.bg2 = b
end

-- generate hp strings
lib.gen_namestring = function(f,fs,ftype)
	if not ftype then
		ftype = ''
	end
	local name = lib.gen_fontstring(f.Health, Califpornia.CFG.media.uffont, fs, "NONE")
	name:SetJustifyH("LEFT")
	if ftype == 'player' then
		name:SetPoint("TOPLEFT", f.Health, "TOPLEFT", 3, -3)
		f:Tag(name, "[cpuf:level] [cpuf:color][name][cpuf:afkdnd]")
		name:SetPoint("RIGHT", f, "RIGHT", -60, 0)
	elseif ftype == 'tot' then
		name:SetPoint("TOPLEFT", f.Health, "TOPLEFT", 3, -3)
		f:Tag(name, "[cpuf:level] [cpuf:color][name]")
		name:SetPoint("RIGHT", f, "RIGHT", -22, 0)
	elseif ftype == 'raid' then
		name:SetPoint("TOPLEFT", f.Health, "TOPLEFT", 3, -3)
		f:Tag(name, "[cpuf:afkdnd][cpuf:color][name]")
		name:SetPoint("RIGHT", f, "RIGHT", -10, 0)
	elseif ftype == 'grid' then
		name:SetPoint("TOPLEFT", f.Health, "TOPLEFT", 1, -1)
		f:Tag(name, "[cpuf:afkdnd][cpuf:color][name]")
		name:SetPoint("RIGHT", f, "RIGHT", -10, 0)
	end
end
lib.gen_infostring = function(f,fs,ftype)
	if not ftype then
		ftype = ''
	end
	local infostr = lib.gen_fontstring(f.Health, Califpornia.CFG.media.uffont, fs, "NONE")
	infostr:SetJustifyH("RIGHT")

	if ftype == 'player' then
		f:Tag(infostr, "[cpuf:hp] | [cpuf:color][cpuf:power]")
		infostr:SetPoint("TOPRIGHT", f.Health, "TOPRIGHT", -1, -3)
	elseif ftype == 'tot' then
		f:Tag(infostr, "[cpuf:hp]")
		infostr:SetPoint("TOPRIGHT", f.Health, "TOPRIGHT", -1, -3)
	elseif ftype == 'raid' then
		f:Tag(infostr, "[cpuf:raidhp]")
		infostr:SetPoint("TOPRIGHT", f.Health, "TOPRIGHT", -1, -3)
	elseif ftype == 'grid' then
		f:Tag(infostr, "[cpuf:raidhp]")
		infostr:SetPoint("TOPRIGHT", f.Health, "TOPRIGHT", -1, -1)
	end
end

-- gen power bar
lib.gen_powerbar = function(f,barheight)
	--statusbar
	local s = CreateFrame("StatusBar", nil, f)
	s:SetStatusBarTexture(Califpornia.CFG.media.normTex)
	s:GetStatusBarTexture():SetHorizTile(true)
	s:SetHeight(barheight)
	s:SetWidth(f:GetWidth())
	s:SetPoint("BOTTOM",f,"BOTTOM",0,0)

	--bg
	local b = s:CreateTexture(nil, "BACKGROUND")
	b:SetTexture(Califpornia.CFG.media.normTex)
	b:SetAllPoints(s)

	f.Power = s
	f.Power.bg = b
end

-- gen alt power bar
lib.gen_altpowerbar = function(f,btype)
	--statusbar
	local s = CreateFrame("StatusBar", nil, f)
	s:SetStatusBarTexture(Califpornia.CFG.media.normTex)
	s:GetStatusBarTexture():SetHorizTile(true)
	s:SetHeight(24)
	s:SetWidth(180)
	if btype == 'player' then
		s:SetPoint("CENTER", UIPARENT, "CENTER", -300, 250)
	else
		s:SetPoint("CENTER", UIPARENT, "CENTER", -300, 220)
	end
	s:SetStatusBarColor(Califpornia.colors.m_color.r,Califpornia.colors.m_color.g,Califpornia.colors.m_color.b)

	--bg
	local b = s:CreateTexture(nil, "BACKGROUND")
	b:SetTexture(Califpornia.CFG.media.normTex)
	b:SetAllPoints(s)
	b:SetVertexColor(Califpornia.colors.m_color.r,Califpornia.colors.m_color.g,Califpornia.colors.m_color.b, 0.5) 

	--value
	local infostr = lib.gen_fontstring(s, Califpornia.CFG.media.uffont, 15, "OUTLINE")
	infostr:SetJustifyH("RIGHT")
	infostr:SetPoint("TOPRIGHT", s, "TOPRIGHT", -1, -3)
	infostr:SetText('0 / 100')

	lib.gen_backdrop(s,0)

	f.AltPowerBar = s
	f.AltPowerBar = s
	f.AltPowerBar.bg = b

	f.AltPowerBar.PostUpdate = function(self, min, cur, max)
		infostr:SetText(cur..' / '..max)
	end
end

-- portrait update
lib.PortraitPostUpdate = function(element, unit)
--	if not UnitExists(unit) or not UnitIsConnected(unit) or not UnitIsVisible(unit) then
--		element:Hide()
--	else
--		element:Show()
		element:SetCamera(0)
--	end
end

--gen portrait
lib.gen_portrait = function(f, w, h, o)
	if not o then
		o = 8
	end
	-- portrait
	local p = CreateFrame("PlayerModel", nil, f)
	p:SetFrameLevel(4)
	p:SetHeight(h)
	p:SetWidth(w)
	p:SetPoint("BOTTOM", f, "BOTTOM", 0, o)

	lib.gen_backdrop(p,4)
	
	-- highlight
	local hl = p:CreateTexture(nil, "OVERLAY")
	hl:SetAllPoints(p)
	hl:SetTexture(Califpornia.CFG.media.portraitTex)
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
	lib.gen_backdrop_old(h)
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
lib.gen_auras = function(f,rtype)
	if not rtype then
		rtype = 'default'
	end
	Auras = CreateFrame("Frame", nil, f)
	if rtype == "target" then
		Auras.size = Califpornia.CFG.unitframes.iconsize		
		Auras:SetHeight(41)
		Auras:SetWidth(f:GetWidth())
		Auras.spacing = 5
		Auras.numBuffs = 20
		Auras.numDebuffs = 25
		Auras.gap = true
		Auras:SetPoint("TOPLEFT", f, "BOTTOMLEFT", 0, -8)
	elseif rtype == "raid" then
		Auras.size = f.Health:GetHeight()
		Auras:SetHeight(f:GetHeight())
		Auras:SetWidth(5*Auras.size)
		Auras.spacing = 5
		Auras.numBuffs = 0
		Auras.numDebuffs = 5
		Auras.gap = true
		Auras:SetPoint("TOPLEFT", f.Health, "TOPRIGHT", 6, 0)
--		Auras.CustomFilter = debuffFilter
	elseif rtype == "grid" then
		if Califpornia.CFG.unitframes.grid_icons == 1 then
			Auras.size = 12
			Auras.spacing = 3
			Auras.numBuffs = 3
			Auras.numDebuffs = 4
		else
			Auras.size = 18
			Auras.spacing = 2
			Auras.numBuffs = 1
			Auras.numDebuffs = 3
		end
		Auras:SetHeight(Auras.size)
		Auras:SetWidth(f.Health:GetWidth()-4)
		Auras.gap = false
		Auras:SetPoint("BOTTOMLEFT", f.Health, 1, 0)
--		Auras.CustomFilter = debuffFilter
	else
		Auras.size = f:GetHeight()/2-3
		Auras:SetHeight(f:GetHeight())
		Auras:SetWidth(5*Auras.size)
		Auras.spacing = 5
		Auras.numBuffs = 5
		Auras.numDebuffs = 5
		Auras.gap = true
		Auras:SetPoint("TOPLEFT", f, "TOPRIGHT", 6, 0)
	end
	Auras.initialAnchor = "TOPLEFT"
	Auras["growth-x"] = "RIGHT"		
	Auras["growth-y"] = "DOWN"
	if rtype ~= "grid" then
		Auras.PostCreateIcon = myPostCreateIcon
		Auras.PostUpdateIcon = myPostUpdateIcon
	else
		Auras.PostCreateIcon = function(self, button)
			self.showDebuffType = true
			self.disableCooldown = false
			button.cd.noOCC = true
			button.cd.noCooldownCount = true
			button:EnableMouse(false)
--			button.icon:SetTexCoord(.07, .93, .07, .93)
--			button.icon:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0)
--			button.icon:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 0)
		end
	end
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
	ri:SetTexture(Califpornia.CFG.media.raidIcons)

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
	f.PvP:SetHeight(14)
	f.PvP:SetWidth(14)
	f.PvP:SetPoint('TOPRIGHT', -8, 10)
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
	f.Combat:SetPoint('RIGHT', f.Portrait, -4, 0)
	f.Combat:SetTexture('Interface\\CharacterFrame\\UI-StateIcon')
	f.Combat:SetTexCoord(0.58, 0.90, 0.08, 0.41)

	-- rest icon
	f.Resting = h:CreateTexture(nil, 'OVERLAY')
	f.Resting:SetSize(14,14)
	f.Resting:SetPoint('LEFT', f.Portrait, 4, 0)
	f.Resting:SetTexture('Interface\\CharacterFrame\\UI-StateIcon')
	f.Resting:SetTexCoord(0.09, 0.43, 0.08, 0.42)
end

-- LFD Role icon
lib.gen_lfdicon = function(f, isRaid)
	f.LFDRole = f.Power:CreateTexture(nil, 'OVERLAY')
	f.LFDRole:SetSize(13, 13)
	if isRaid then
		f.LFDRole:SetPoint('CENTER', f.Health, 'LEFT', 0, 0)
	else
		f.LFDRole:SetPoint('CENTER', f.Power, 'TOPRIGHT', 2, 0)
	end
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
	if (Califpornia.myclass ~= "ROGUE" and Califpornia.myclass ~= "DRUID") or not Califpornia.CFG.unitframes.combobar then return end

	local combobar =  CreateFrame('Frame', nil, self)
	combobar:SetPoint('BOTTOMLEFT', self.Portrait, 'TOPLEFT', 0, 2)
	combobar:SetHeight(4)
	combobar:SetWidth(self.Portrait:GetWidth())
	self.Portrait:SetHeight(self.Portrait:GetHeight() - 4)
	lib.gen_backdrop(combobar,3)

	for i = 1, MAX_COMBO_POINTS do
		local cpoint = CreateFrame('StatusBar', nil, combobar)
		cpoint:SetSize((self.Portrait:GetWidth() / MAX_COMBO_POINTS)-2, 4)
		cpoint:SetStatusBarTexture(Califpornia.CFG.media.normTex)
		cpoint:SetFrameLevel(4)
		cpoint:SetStatusBarColor(unpack(cpColor[i]))
		if (i == 1) then
			cpoint:SetPoint('LEFT', combobar, 'LEFT', 1, 0)
		else
			cpoint:SetPoint('TOPLEFT', combobar[i-1], "TOPRIGHT", 2, 0)
		end
		local cpointBG = cpoint:CreateTexture(nil, 'BACKGROUND')
		cpointBG:SetAllPoints(cpoint)
		cpointBG:SetTexture(Califpornia.CFG.media.normTex)
		cpoint.bg = cpointBG
		cpoint.bg.multiplier = 0.3
		combobar[i] = cpoint
	end

	self.CPoints = combobar
end

-- Class Bars
lib.gen_classbar = function(self)
	if CalifporniaCFG.unitframes.classbar and (Califpornia.myclass == "WARLOCK" or Califpornia.myclass == "DEATHKNIGHT" or Califpornia.myclass == "PALADIN" or Califpornia.myclass == "DRUID" or Califpornia.myclass == "SHAMAN") then 
		local barFrame = CreateFrame("Frame", nil, self)
		barFrame:SetPoint('BOTTOMLEFT', self.Portrait, 'TOPLEFT', 0, 2)
		barFrame:SetHeight(4)
		barFrame:SetWidth(self.Portrait:GetWidth())
		barFrame:SetFrameLevel(4)

		-- shaman totem bar with backdrops is just ugly
		if Califpornia.myclass ~= "SHAMAN" then
			barFrame.bd = lib.gen_backdrop(barFrame,3)
		end

		-- toggle portrait height for non-permanent class bars (druid mana and eclipse)
		barFrame:Hide()
		barFrame:SetScript("OnShow", function(self)
			local pf = self:GetParent()
			pf.Portrait:SetHeight(pf.Portrait:GetHeight() - 4)
		end)
		barFrame:SetScript("OnHide", function(self)
			local pf = self:GetParent()
			pf.Portrait:SetHeight(pf.Portrait:GetHeight() + 4)
		end)
		if Califpornia.myclass ~= "DRUID" then
			barFrame:Show()
		end
		-- oh crap, it's because of 2 class plugins :<
		local barFrame2
		if Califpornia.myclass == "DRUID" then
			barFrame2 = CreateFrame("Frame", nil, self)
			barFrame2:SetPoint('BOTTOMLEFT', self.Portrait, 'TOPLEFT', 0, 2)
			barFrame2:SetHeight(4)
			barFrame2:SetWidth(self.Portrait:GetWidth())
			barFrame2:SetFrameLevel(4)
			barFrame2.bd = lib.gen_backdrop(barFrame2,3)
			barFrame2:Hide()
			barFrame2:SetScript("OnShow", function(self)
				local pf = self:GetParent()
				pf.Portrait:SetHeight(pf.Portrait:GetHeight() - 4)
			end)
			barFrame2:SetScript("OnHide", function(self)
				local pf = self:GetParent()
				pf.Portrait:SetHeight(pf.Portrait:GetHeight() + 4)
			end)
		end
		-- Holy Power
		if Califpornia.myclass == "PALADIN" then
			local hpOverride = function(self, event, unit, powerType)
				if(self.unit ~= unit or (powerType and powerType ~= "HOLY_POWER")) then return end
				
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
			for i = 1, 3 do
				local holyShard = CreateFrame("StatusBar", self:GetName().."_Holypower"..i, self)
				holyShard:SetHeight(4)
				holyShard:SetWidth((barFrame:GetWidth() / 3)-2)
				holyShard:SetStatusBarTexture(Califpornia.CFG.media.normTex)
				holyShard:SetStatusBarColor(1,1,0)
				holyShard:SetFrameLevel(4)
				
				if (i == 1) then
					holyShard:SetPoint("LEFT", barFrame, "LEFT", 0, 0)
				else
					holyShard:SetPoint("TOPLEFT", barFrame[i-1], "TOPRIGHT", 3, 0)
				end
				barFrame[i] = holyShard
			end
			self.HolyPower = barFrame
			self.HolyPower.Override = hpOverride
		elseif Califpornia.myclass == "WARLOCK" then
			local ssOverride = function(self, event, unit, powerType)
				if(self.unit ~= unit or (powerType and powerType ~= "SOUL_SHARDS")) then return end
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
			
			for i= 1, 3 do
				local shard = CreateFrame("StatusBar", nil, barFrame)
				shard:SetHeight(4)
				shard:SetWidth((barFrame:GetWidth() / 3)-2)
				shard:SetStatusBarTexture(Califpornia.CFG.media.normTex)
				shard:SetStatusBarColor(.86,.44, 1)
				shard:SetFrameLevel(4)
				
				if (i == 1) then
					shard:SetPoint("LEFT", barFrame, "LEFT", 0, 0)
				else
					shard:SetPoint("TOPLEFT", barFrame[i-1], "TOPRIGHT", 3, 0)
				end
				barFrame[i] = shard
			end
			self.SoulShards = barFrame
			self.SoulShards.Override = ssOverride
		elseif Califpornia.myclass == "DRUID" then
			-- eclipse
			local eclipseBarBuff = function(self, unit)
				if self.hasSolarEclipse then
					self.eBarBG:SetBackdropBorderColor(1,1,.5,.7)
				elseif self.hasLunarEclipse then
					self.eBarBG:SetBackdropBorderColor(.2,.2,1,.7)
				else
					self.eBarBG:SetBackdropBorderColor(0,0,0,1)
				end
			end
			
			barFrame.eBarBG = barFrame.bd
			
			local lunarBar = CreateFrame("StatusBar", nil, barFrame)
			lunarBar:SetPoint("LEFT", barFrame, "LEFT", 0, 0)
			lunarBar:SetSize(barFrame:GetWidth(), barFrame:GetHeight())
			lunarBar:SetStatusBarTexture(Califpornia.CFG.media.normTex)
			lunarBar:SetStatusBarColor(0, .1, .7)
			lunarBar:SetFrameLevel(5)
			barFrame.LunarBar = lunarBar
			
			local solarBar = CreateFrame("StatusBar", nil, barFrame)
			solarBar:SetPoint("LEFT", lunarBar:GetStatusBarTexture(), "RIGHT", 0, 0)
			solarBar:SetSize(barFrame:GetWidth(), barFrame:GetHeight())
			solarBar:SetStatusBarTexture(Califpornia.CFG.media.normTex)
			solarBar:SetStatusBarColor(1,1,.13)
			solarBar:SetFrameLevel(5)
			barFrame.SolarBar = solarBar
			
			local EBText = lib.gen_fontstring(solarBar, mfont, 10, "OUTLINE")
			EBText:SetPoint("CENTER", barFrame, "CENTER", 0, 0)
			self:Tag(EBText, "[pereclipse]")
			
			self.EclipseBar = barFrame
			self.EclipseBar.PostUnitAura = eclipseBarBuff

			-- mana bar
			local ManaBar = CreateFrame('StatusBar', nil, barFrame2)
			ManaBar:SetPoint('LEFT', barFrame2, 'LEFT', 0, 0)
			ManaBar:SetSize(barFrame2:GetWidth(), barFrame2:GetHeight())
			ManaBar:SetStatusBarTexture(Califpornia.CFG.media.normTex)
			ManaBar:GetStatusBarTexture():SetHorizTile(true)
			ManaBar:SetFrameLevel(5)

			local MBText = lib.gen_fontstring(ManaBar, mfont, 10, "OUTLINE")
			MBText:SetPoint('CENTER', ManaBar, 'CENTER', 0, 0)
			self:Tag(MBText, '[cpuf:druidmana]')

			barFrame2.ManaBar = ManaBar
			self.DruidMana = barFrame2
		elseif playerClass == "DEATHKNIGHT" then
			for i= 1, 6 do
				local rune = CreateFrame("StatusBar", nil, barFrame)
				rune:SetSize((barFrame:GetWidth() / 6)-2, 4)
				rune:SetStatusBarTexture(Califpornia.CFG.media.normTex)
				rune:SetFrameLevel(4)
				
				if (i == 1) then
					rune:SetPoint("LEFT", barFrame, "LEFT", 1, 0)
				else
					rune:SetPoint("TOPLEFT", barFrame[i-1], "TOPRIGHT", 2, 0)
				end
				
				local runeBG = rune:CreateTexture(nil, "BACKGROUND")
				runeBG:SetAllPoints(rune)
				runeBG:SetTexture(Califpornia.CFG.media.normTex)
				rune.bg = runeBG
				rune.bg.multiplier = 0.3
				barFrame[i] = rune
			end
			self.Runes = barFrame
		elseif playerClass == "SHAMAN" then
			barFrame.Destroy = true
			barFrame.UpdateColors = true

			for i = 1, 4 do
				local totem = CreateFrame("Frame", nil, barFrame)
				totem:SetSize((barFrame:GetWidth() / 4)-i+1, 4)
				if i == 1 then
					totem:SetPoint("LEFT", barFrame, "LEFT", 0, 0)
				else
					totem:SetPoint("LEFT", barFrame[i-1], "RIGHT", 2, 0)
				end
				totem:SetFrameLevel(4)
				lib.gen_backdrop(totem, 3)

				local bar = CreateFrame("StatusBar", nil, totem)
				bar:SetAllPoints(totem)
				bar:SetStatusBarTexture(Califpornia.CFG.media.normTex)
				totem.StatusBar = bar

				totem.bg = totem:CreateTexture(nil, "BACKGROUND")
				totem.bg:SetAllPoints()
				totem.bg:SetTexture(Califpornia.CFG.media.normTex)
				totem.bg.multiplier = 0.3

				barFrame[i] = totem
			end
			self.TotemBar = barFrame
		end
	end
end

-- THREAT BORDERS
-- Create Threat Status Border
lib.gen_ttborder = function(self)
	self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", lib.UpdBorder)
	self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", lib.UpdBorder)
end
  
-- Raid Frames Threat Highlight
function lib.UpdBorder(self, event, unit)
	if (self.unit ~= unit) then return end
	local status = UnitThreatSituation(unit)
	unit = unit or self.unit
	if status and status > 1 then
		local r, g, b = GetThreatStatusColor(status)
		self.bd:SetBackdropBorderColor(r, g, b, 1)
	else
		self.bd:SetBackdropBorderColor(unpack(self.bd.origColor))
	end
end
-- PLUGIN STUFF
-- oUF_DebuffHighlight
lib.gen_debuff_hl = function(self)
	local dbh = self.Health:CreateTexture(nil, "OVERLAY")
	dbh:SetAllPoints(self.Health)
	dbh:SetTexture(Califpornia.CFG.media.debuff_hl)
	dbh:SetBlendMode("ADD")
	dbh:SetVertexColor(0,0,0,0) -- set alpha to 0 to hide the texture
	self.DebuffHighlight = dbh
	self.DebuffHighlightAlpha = 0.5
	self.DebuffHighlightFilter = Califpornia.CFG.unitframes.debuff_hl_dispellable
end

-- oUF_CombatFeedback
lib.gen_combatfeedback = function(f)
	local cbft = lib.gen_fontstring(f.Portrait, Califpornia.CFG.media.uffont, 15, "OUTLINE")
	cbft:SetPoint("CENTER", f.Portrait, "CENTER")
	cbft.maxAlpha = 1
	f.CombatFeedbackText = cbft
end

-- CAST BARS
local cbDefaultColor = {137/255, 153/255, 170/255}

local function customTimeText(element, duration)
	element.Time:SetFormattedText("%.1f / %.1f", element.channeling and duration or (element.max - duration), element.max)
end

local function customDelayText(element, duration)
	element.Time:SetFormattedText("%.1f |cffff0000-%.1f|r / %.1f", element.channeling and duration or (element.max - duration), element.delay, element.max)
end

local function postCastStart(element, unit)
	if element.Text then
		local text = element.Text:GetText()
		element.Text:SetText("|cffffff88"..text.."|r")
	end
		local cbColor = RAID_CLASS_COLORS[select(2,  UnitClass(unit))]	
		local myMulti = 0.2
		if UnitIsPlayer(unit) and cbColor then
			element:SetStatusBarColor(cbColor.r, cbColor.g, cbColor.b)
		else
			element:SetStatusBarColor(cbDefaultColor[1], cbDefaultColor[2], cbDefaultColor[3])	
		end
end

lib.gen_castbar = function(self, unit)
	local cbHeight = 16

	local castbar = CreateFrame("StatusBar", "CalifporniaUICastbar"..unit, f)
	castbar:SetStatusBarTexture(Califpornia.CFG.media.normTex)
	castbar:SetFrameLevel(5)
	
	lib.gen_backdrop(castbar, 0)

	local bgoverlay = castbar:CreateTexture(nil, "BACKGROUND", nil, -5)
	bgoverlay:SetPoint("TOPLEFT", castbar,"TOPLEFT", 0, 0)
	bgoverlay:SetPoint("BOTTOMRIGHT", castbar,"BOTTOMRIGHT", 0, 0)
	bgoverlay:SetTexture(Califpornia.CFG.media.portraitTex)
	bgoverlay:SetVertexColor(0, 0, 0, 0.8)

	local castbarDummy = CreateFrame("Frame", nil, castbar)
	castbarDummy:SetSize(cbHeight, cbHeight)
	castbarDummy:SetPoint("TOPRIGHT", castbar, "TOPLEFT", -5, 0)
	lib.gen_backdrop(castbarDummy, 0)

	local castbarIcon = castbarDummy:CreateTexture(nil, "ARTWORK")
	castbarIcon:SetAllPoints(castbarDummy)
	castbarIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	castbar.Icon = castbarIcon

	if unit == "player" then
		castbar:SetSize(186, cbHeight)
		castbar:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOM", -4,115)
	elseif unit == "target" then
		castbar:SetSize(186, cbHeight)
		castbar:SetPoint("BOTTOMLEFT", UIParent, "BOTTOM", 25,115)
	elseif unit == "focus" then
		castbar:SetSize(200, cbHeight)
		castbar:SetPoint("CENTER", UIPARENT, "CENTER", 10, 220)
	elseif unit == "pet" then
		castbar:SetSize(186, cbHeight)
		castbar:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOM", -4,140)
	end
		local castbarBG = castbar:CreateTexture(nil, "BACKGROUND", nil, -6)
		castbarBG:SetAllPoints(castbar)
		castbar.bg = castbarBG

		local castbarTime = lib.gen_fontstring(castbar, unpack(Califpornia.CFG.unitframes.cbfont))
		castbarTime:SetPoint("RIGHT", castbar, "RIGHT", -2, 0)
		castbarTime:SetJustifyH("RIGHT")
		castbar.Time = castbarTime
		
		local castbarText = lib.gen_fontstring(castbar, unpack(Califpornia.CFG.unitframes.cbfont))
		castbarText:SetPoint("LEFT", castbar, "LEFT", 2, 0)
		castbarText:SetPoint("RIGHT", castbarTime, "LEFT", -4, 0)
		castbarText:SetJustifyH("LEFT")
		castbar.Text = castbarText
	
	if unit == "player" then
		castbar.SafeZone = castbar:CreateTexture(nil, "OVERLAY", nil, -4)
		castbar.SafeZone:SetAlpha(0.35)
	elseif unit == "target" or unit == "focus" then
		local shield = castbar:CreateTexture(nil, "BACKGROUND")
		shield:SetTexture("Interface\\CastingBar\\UI-CastingBar-Small-Shield")
		shield:SetTexCoord(0, 36/256, 0, 1)
		shield:SetWidth(24)
		shield:SetHeight(48)
		shield:SetPoint("CENTER", castbar.Icon, "CENTER", 0, 0)
		shield:Hide()
		castbar.Shield = shield
	end
	

	local spark = castbar:CreateTexture(nil, "OVERLAY")
	spark:SetBlendMode("ADD")
	spark:SetAlpha(0.3)
	spark:SetHeight(cbHeight*2.5)
	castbar.Spark = spark
	
	self.Castbar = castbar
	if castbar.Time then 
		self.Castbar.CustomTimeText = customTimeText
		self.Castbar.CustomDelayText = customDelayText
	end
	self.Castbar.PostCastStart = postCastStart
	self.Castbar.PostChannelStart = postCastStart
end

lib.init = function(self)
	self.menu = lib.gen_dropdown

	-- register for clicks
	self:RegisterForClicks("AnyUp")
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
end
------------------------------------------------------------------------
-- STYLE function
------------------------------------------------------------------------
local function CreatePlayerStyle(self, unit, isSingle)
		lib.init(self)
		self.mystyle = "player"
		
		-- Size and Scale
		self:SetScale(1)
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
		self.Power.colorClass = true
		self.Power.bg.multiplier = 0.5

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
		self:SetScale(1)
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
		self:SetScale(1)
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
end
local function CreateFocusStyle(self, unit, isSingle)
		lib.init(self)
		self.mystyle = "focus"

		-- Size and Scale
		self:SetScale(1)
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
		-- plugins
		lib.gen_debuff_hl(self)
end
local function CreateFocusTargetStyle(self, unit, isSingle)
		lib.init(self)
		self.mystyle = "focustarget"
		
		-- Size and Scale
		self:SetScale(1)
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
end
local function CreatePetStyle(self, unit, isSingle)
		lib.init(self)
		self.mystyle = "pet"
		
		self.Range = {
			insideAlpha = 1,
			outsideAlpha = .5,
		}
		-- Size and Scale
		self:SetScale(1)
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
		-- plugins
		lib.gen_debuff_hl(self)
end
local function CreatePetTargetStyle(self, unit, isSingle)
		lib.init(self)
		self.mystyle = "pettarget"
		
		-- Size and Scale
		self:SetScale(1)
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
		self:SetScale(1)
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

		-- plugins
		lib.gen_debuff_hl(self)

	-- party target
	elseif (unit == "partytarget") then
--	elseif (self:GetAttribute("unitsuffix") == "target") then
		self.mystyle = "partytarget"
		
		-- Size and Scale
		self:SetScale(1)
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

	
	-- party pet
	elseif (unit == "partypet") then
--	elseif (self:GetAttribute("unitsuffix") == "pet") then
		self.mystyle = "slim"
		
		-- Size and Scale
		self:SetScale(1)
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
		-- plugins
		lib.gen_debuff_hl(self)
	end
end

local function CreateBossStyle(self, unit, isSingle)
	lib.init(self)

		self.mystyle = "group"

		-- Size and Scale
		self:SetScale(1)
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

end
local function CreateArenaStyle(self, unit, isSingle)
	lib.init(self)
	if (unit and unit:find("arena%d")) then

		self.mystyle = "group"

		-- Size and Scale
		self:SetScale(1)
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

		-- Frame specific stuff
		self.Health.frequentUpdates = false
		self.Health.colorSmooth = true
		self.Power.colorDisconnected = true
		self.Power.colorClass = true
		self.Power.bg.multiplier = 0.5

	-- arena target
	elseif (unit and unit:find("arena%dtarget")) then
		
		-- Size and Scale
		self:SetScale(1)
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

	-- arena pet
	elseif (unit and unit:find("arena%dtarget")) then

		-- Size and Scale
		self:SetScale(1)
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
	end
end

local function CreateRaidStyleDPS(self, unit, isSingle)
		lib.init(self)
		self:SetScale(1)
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

local function CreateRaidStyleGRID(self, unit, isSingle)
		lib.init(self)

		local fheight = 28
		local hheight = 24
		if Califpornia.CFG.unitframes.grid_icons == 3 then
			fheight = 18
			hheight = 14
		end

		self:SetScale(1)
		self:SetSize(100, fheight)

		self.Range = {
			insideAlpha = 1,
			outsideAlpha = .5,
		}

		-- Generate Bars
		lib.gen_hpbar(self, hheight)
		lib.gen_namestring(self, 12, 'grid')
		lib.gen_infostring(self, 12, 'grid')
		lib.gen_powerbar(self,3)
		self.bd = lib.gen_backdrop(self, 0, 4)
		lib.gen_highlight(self)
		lib.gen_raidmark(self)
		if Califpornia.CFG.unitframes.grid_aggro then
			lib.gen_ttborder(self)
		end
		if Califpornia.CFG.unitframes.grid_icons ~= 3 then
			lib.gen_auras(self,'grid')
		end
		if Califpornia.CFG.unitframes.grid_role then
			lib.gen_lfdicon(self,true)
		end
		lib.gen_infoicons(self)

		-- Frame specific stuff
		self.Health.frequentUpdates = false
		self.Health.colorSmooth = true
--		self.Power.colorDisconnected = true
		self.Power.colorClass = true
		self.Power.colorReaction = true
		self.Power.bg.multiplier = 0.5
		-- plugins
		if Califpornia.CFG.unitframes.grid_hl then
			lib.gen_debuff_hl(self)
		end
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

oUF:RegisterStyle("RaidDPS", CreateRaidStyleDPS)
oUF:RegisterStyle("RaidGRID", CreateRaidStyleGRID)
--oUF:RegisterStyle("oUF_MT", CreateMTStyle)

------------------------------------------------------------------------
-- SPAWNS
------------------------------------------------------------------------

oUF:Factory(function(self)

	self:SetActiveStyle("Player")
	local player = self:Spawn("player", "oUF_Player")
	player:SetPoint("TOPLEFT", UIParent, "TOPLEFT", Califpornia.CFG.common.screen_spacer, -Califpornia.CFG.common.screen_spacer)

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
	party:SetPoint("TOPLEFT", UIParent, "TOPLEFT", Califpornia.CFG.common.screen_spacer, -150)

	oUF:SetActiveStyle("Arena")
	local arena = {}
	local arenatarget = {}
	local arenapet = {}
	for i = 1, 5 do
		arena[i] = self:Spawn("arena"..i, "oUF_Arena"..i)
		arenatarget[i] = self:Spawn("arena"..i.."target", "oUF_Arena"..i.."target"):SetPoint("TOPLEFT",arena[i], "BOTTOMLEFT", 0, -6)
		arenapet[i] = self:Spawn("arena"..i.."pet", "oUF_Arena"..i.."pet"):SetPoint("TOPRIGHT",arena[i], "BOTTOMRIGHT", 0, -6)
		if i == 1 then
			arena[i]:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -Califpornia.CFG.common.screen_spacer, -150)
		else
			arena[i]:SetPoint("TOP", arena[i-1], "BOTTOM", 0, -50)
		end
	end

	oUF:SetActiveStyle("Boss")
	local boss = {}
	for i = 1, MAX_BOSS_FRAMES do
		boss[i] = self:Spawn("boss"..i, "oUF_Califpornia_Boss"..i)
		if i == 1 then
			boss[i]:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -Califpornia.CFG.common.screen_spacer, -150)
		else
			boss[i]:SetPoint('TOP', boss[i-1], 'BOTTOM', 0, -50)
		end
	end

	-- RAID
	CompactRaidFrameContainer:Hide()
	if Califpornia.CFG.unitframes.showraidmanager ~= true then
		CompactRaidFrameManager:SetAlpha(0)
	end

	local maxGroups = 5
	if Califpornia.CFG.unitframes.allgroups then
		maxGroups = 8
	end
	local raid_groups = {}


	if Califpornia.CFG.unitframes.dps_layout then
		oUF:SetActiveStyle("RaidDPS")
		-- DPS raid layot, very minimalistic. 
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
				raid_groups[i]:SetPoint("TOPLEFT", UIParent, Califpornia.CFG.common.screen_spacer, -150)
			elseif i == 6 and Califpornia.CFG.unitframes.allgroups then
				raid_groups[i]:SetPoint("TOPLEFT", raid_groups[1], "TOPRIGHT", 9, 0)
			else
				raid_groups[i]:SetPoint("TOPLEFT", raid_groups[i-1], "BOTTOMLEFT", 0, -15)
			end
		end
	else
		oUF:SetActiveStyle("RaidGRID")
		-- GRID-like raid layot, very minimalistic. 
		for i = 1, maxGroups do
			raid_groups[i] = oUF:SpawnHeader("oUF_CalifporniaRaid"..i, nil, "solo,raid", 
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
				"columnAnchorPoint", "LEFT")
			raid_groups[i]:SetScale(1)
			if i == 1 then 
				raid_groups[i]:SetPoint("BOTTOMLEFT", UIParent, "BOTTOM", -260, 182)
			else
				raid_groups[i]:SetPoint("BOTTOMLEFT", raid_groups[i-1], "TOPLEFT", 0, 3)
			end
		end
	end

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
				"columnAnchorPoint", "TOP")
			raid_groups[i]:SetScale(1)
			if i == 1 then 
				raid_groups[i]:SetPoint("TOP", 'UIParent', "BOTTOM", 0, 440)
			else
				raid_groups[i]:SetPoint("TOPLEFT", raid_groups[i-1], "BOTTOMLEFT", 0, -5)
			end
		end

]]--

