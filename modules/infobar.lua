if Califpornia.CFG["expbar"].enable ~= true then return end
local xpcolor = {r = 0.8, g = 0, b = 0}

local mirrorbars = {}

-- Exp bar holder

local infoBarHolder = CreateFrame("Frame", nil, Califpornia.Panels.datamid)
infoBarHolder:SetFrameStrata("LOW")
infoBarHolder:SetFrameLevel(1)
infoBarHolder:SetAllPoints(Califpornia.Panels.datamid)
infoBarHolder:Show()

-- Mirror bar holder

local mirrorBarHolder = CreateFrame("Frame", nil, Califpornia.Panels.datamid)
mirrorBarHolder:SetFrameStrata("LOW")
mirrorBarHolder:SetFrameLevel(1)
mirrorBarHolder:SetAllPoints(Califpornia.Panels.datamid)
mirrorBarHolder:Hide()

local rbar = CreateFrame("StatusBar", "cRested", infoBarHolder)
rbar:SetStatusBarTexture(Califpornia.CFG.media.normTex)
rbar:SetStatusBarColor(Califpornia.colors.m_color.r, Califpornia.colors.m_color.g, Califpornia.colors.m_color.b, 0.5)
rbar:SetFrameStrata("LOW")
rbar:SetFrameLevel(2)
rbar:SetAllPoints(infoBarHolder)
rbar:SetMinMaxValues(0,1)
rbar:SetValue(0)
rbar:Hide()

local xbar = CreateFrame("StatusBar", "cExperience", UIParent)
xbar:SetStatusBarTexture(Califpornia.CFG.media.normTex)
xbar:SetStatusBarColor(Califpornia.colors.m_color.r, Califpornia.colors.m_color.g, Califpornia.colors.m_color.b, 0.8)
xbar:SetFrameStrata("LOW")
xbar:SetFrameLevel(3)
xbar:SetAllPoints(infoBarHolder)
xbar:SetMinMaxValues(0,1)
xbar:SetValue(0)
xbar:Hide()

local repbar = CreateFrame("StatusBar", "cReputation", UIParent)
repbar:SetStatusBarTexture(Califpornia.CFG.media.normTex)
repbar:SetStatusBarColor(Califpornia.colors.m_color.r, Califpornia.colors.m_color.g, Califpornia.colors.m_color.b, 0.8)
repbar:SetFrameStrata("LOW")
repbar:SetFrameLevel(3)
repbar:SetAllPoints(infoBarHolder)
repbar:SetMinMaxValues(0,1)
repbar:SetValue(0)
repbar:Hide()


function UpdExpValue()
	local mxp = UnitXPMax("player")
	local xp = UnitXP("player")
	local rxp = GetXPExhaustion()

	rbar:SetMinMaxValues(0,mxp)
	xbar:SetMinMaxValues(0,mxp)
	xbar:SetValue(xp)

	if rxp then
		if rxp+xp >= mxp then
			rbar:SetValue(mxp)
		else
			rbar:SetValue(rxp+xp)
		end
	else
		rbar:SetValue(0)
	end
end

function UpdRepValue()
	name, standing, minrep, maxrep, value = GetWatchedFactionInfo()
	if name then
		repbar:SetMinMaxValues(minrep,maxrep)
		repbar:SetValue(value)
	else
		repbar:SetValue(0)
	end
end

function ShowBars()
	if UnitLevel("player") ~= MAX_PLAYER_LEVEL then
		rbar:Show()
		xbar:Show()
		repbar:Hide()
		Califpornia.Panels.datamid_holder:Hide()
		infoBarHolder:EnableMouse(true)
	elseif GetWatchedFactionInfo() then
		rbar:Hide()
		xbar:Hide()
		repbar:Show()
		Califpornia.Panels.datamid_holder:Hide()
		infoBarHolder:EnableMouse(true)
	else
		rbar:Hide()
		xbar:Hide()
		repbar:Hide()
		infoBarHolder:EnableMouse(false)
		Califpornia.Panels.datamid_holder:Show()
	end
end

function TTShow()
	mxp = UnitXPMax("player")
	xp = UnitXP("player")
	rxp = GetXPExhaustion()
	name, standing, minrep, maxrep, value = GetWatchedFactionInfo()

	GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
	if UnitLevel("player") ~= MAX_PLAYER_LEVEL then
		GameTooltip:AddDoubleLine(COMBAT_XP_GAIN, xp.."|cffffd100/|r"..mxp.." |cffffd100/|r "..floor((xp/mxp)*1000)/10 .."%",NORMAL_FONT_COLOR.r,NORMAL_FONT_COLOR.g,NORMAL_FONT_COLOR.b,1,1,1)
		if rxp then
			GameTooltip:AddDoubleLine(TUTORIAL_TITLE26, rxp .." |cffffd100/|r ".. floor((rxp/mxp)*1000)/10 .."%", NORMAL_FONT_COLOR.r,NORMAL_FONT_COLOR.g,NORMAL_FONT_COLOR.b,1,1,1)
		end
		if name then
			GameTooltip:AddLine(" ")			
		end
	end
	if name then
		GameTooltip:AddDoubleLine(FACTION, name, NORMAL_FONT_COLOR.r,NORMAL_FONT_COLOR.g,NORMAL_FONT_COLOR.b,1,1,1)
		GameTooltip:AddDoubleLine(STANDING, getglobal("FACTION_STANDING_LABEL"..standing), NORMAL_FONT_COLOR.r,NORMAL_FONT_COLOR.g,NORMAL_FONT_COLOR.b,FACTION_BAR_COLORS[standing].r, FACTION_BAR_COLORS[standing].g, FACTION_BAR_COLORS[standing].b)
		GameTooltip:AddDoubleLine(REPUTATION, value-minrep .."|cffffd100/|r"..maxrep-minrep.." |cffffd100/|r "..floor((value-minrep)/(maxrep-minrep)*1000)/10 .."%", NORMAL_FONT_COLOR.r,NORMAL_FONT_COLOR.g,NORMAL_FONT_COLOR.b,1,1,1)
	end
		
	GameTooltip:Show()
end

function TTHide()
	GameTooltip:Hide()
end

local MBUpdatePositions = function()
	local prev = nil
	local cnt = 0
	for _, bar in next, mirrorbars do
		if bar:IsShown() then
			if prev then
				bar:SetPoint("TOPLEFT", prev, "TOPRIGHT")
			else
				bar:SetPoint("TOPLEFT", mirrorBarHolder, "TOPLEFT")
			end
			prev = bar
			cnt = cnt+1
		end
	end
	if cnt >= 1 then
		mirrorBarHolder:Show()
		infoBarHolder:Hide()
		Califpornia.Panels.datamid_holder:Hide()
		for _, bar in next, mirrorbars do
			if bar:IsShown() then
				bar:SetWidth(mirrorBarHolder:GetWidth()/cnt)
			end
		end
	else
		mirrorBarHolder:Hide()
		ShowBars()
	end
end

local MBOnUpdate = function(self, elapsed)
	if(self.paused) then return end
	self:SetValue(GetMirrorTimerProgress(self.type) / 1e3)
end

local MBStart = function(self, value, maxvalue, scale, paused, text)
	if(paused > 0) then
		self.paused = 1
	elseif(self.paused) then
		self.paused = nil
	end
	self.text:SetText(text)
	self:SetMinMaxValues(0, maxvalue / 1e3)
	self:SetValue(value / 1e3)
	if(not self:IsShown()) then self:Show() end
	MBUpdatePositions()
end

local MBStop = function(self)
	self:SetScript("OnUpdate", nil)
	self:Hide()
	MBUpdatePositions()
end

function MBSpawn(type)
	if(mirrorbars[type]) then return mirrorbars[type] end

	local mirrorbar = CreateFrame("StatusBar", "cMirror", UIParent)
	mirrorbar:SetScript("OnUpdate", MBOnUpdate)
	mirrorbar:SetStatusBarTexture(Califpornia.CFG.media.normTex)
	mirrorbar:SetStatusBarColor(Califpornia.colors.m_color.r, Califpornia.colors.m_color.g, Califpornia.colors.m_color.b, 0.8)
	mirrorbar:SetHeight(mirrorBarHolder:GetHeight())

	local text = mirrorbar:CreateFontString(nil, "OVERLAY")
	text:SetFont(unpack(Califpornia.CFG.panels.font))
	text:SetHeight(mirrorBarHolder:GetHeight())
	text:SetPoint("CENTER", mirrorbar)

	mirrorbar.type = type
	mirrorbar.text = text
	mirrorbar.Start = MBStart
	mirrorbar.Stop = MBStop

	mirrorbars[type] = mirrorbar
	return mirrorbar
end

function MBPauseAll(duration)
	for _, bar in next, mirrorbars do
		bar.paused = val
	end
end

infoBarHolder:SetScript("OnEvent", function(this, event, arg1, arg2, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		UpdExpValue()
		ShowBars()
		for i=1, MIRRORTIMER_NUMTIMERS do
			local type, value, maxvalue, scale, paused, text = GetMirrorTimerInfo(i)
			if(type ~= 'UNKNOWN') then
				MBSpawn(type):Start(value, maxvalue, scale, paused, text)
			end
		end
	elseif event == "MIRROR_TIMER_START" then
		local maxvalue, scale, paused, text = select(1, ...)
		MBSpawn(arg1):Start(arg2, maxvalue, scale, paused, text)
	elseif event == "MIRROR_TIMER_STOP" then
		MBSpawn(arg1):Stop()
	elseif event == "MIRROR_TIMER_PAUSE" then
		if arg1 and arg1 > 0 then
			MBPauseAll(arg1)
		end
	elseif event == "ADDON_LOADED" and arg1 == "CalifporniaUI" then
--		UIParent:UnregisterEvent("MIRROR_TIMER_START")
		infoBarHolder:UnregisterEvent("ADDON_LOADED")
	elseif event == "PLAYER_XP_UPDATE" and arg1 == "player" then
		UpdExpValue()
	elseif event == "PLAYER_LEVEL_UP" then
		UpdExpValue()
		ShowBars()
	elseif event == "MODIFIER_STATE_CHANGED" then
		if (arg1 == "LALT" or arg1 == "RALT") and UnitLevel("player") ~= MAX_PLAYER_LEVEL and GetWatchedFactionInfo() then
			if arg2 == 1 then
				rbar:Hide()
				xbar:Hide()
				repbar:Show()
			elseif arg2 == 0 then
				rbar:Show()
				xbar:Show()
				repbar:Hide()
			end
		end
	elseif event == "UPDATE_FACTION" then
		UpdRepValue()
		ShowBars()
	end
end)


infoBarHolder:EnableMouse(true)
infoBarHolder:SetScript("OnEnter", TTShow)
infoBarHolder:SetScript("OnLeave", TTHide)
infoBarHolder:RegisterEvent("MIRROR_TIMER_START")
infoBarHolder:RegisterEvent("MIRROR_TIMER_STOP")
infoBarHolder:RegisterEvent("MIRROR_TIMER_PAUSE")
infoBarHolder:RegisterEvent("ADDON_LOADED")
infoBarHolder:RegisterEvent("PLAYER_XP_UPDATE")
infoBarHolder:RegisterEvent("PLAYER_LEVEL_UP")
infoBarHolder:RegisterEvent("PLAYER_ENTERING_WORLD")
infoBarHolder:RegisterEvent("UPDATE_FACTION")
infoBarHolder:RegisterEvent("MODIFIER_STATE_CHANGED")
