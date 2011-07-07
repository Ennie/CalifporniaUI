if not CalifporniaCFG["map"].enable ~= true then return end


WORLDMAP_WINDOWED_SIZE = 0.85 --Slightly increase the size of blizzard small map
local mapscale = WORLDMAP_WINDOWED_SIZE

local ft = CalifporniaCFG.media.font -- Map font
local fontsize = 22 -- Map Font Size

local mapbg = CreateFrame("Frame", nil, WorldMapDetailFrame)


--Create move button for map
local movebutton = CreateFrame ("Frame", nil, WorldMapFrameSizeUpButton)
movebutton:SetHeight(32)
movebutton:SetWidth(32)
movebutton:SetPoint("TOP", WorldMapFrameSizeUpButton, "BOTTOM", -1, 4)
movebutton:SetBackdrop( { 
	bgFile = CalifporniaCFG.media.cross,
})
movebutton:EnableMouse(true)

movebutton:SetScript("OnMouseDown", function()
	local maplock = GetCVar("advancedWorldMap")
	if maplock ~= "1" then return end
	WorldMapScreenAnchor:ClearAllPoints()
	WorldMapFrame:ClearAllPoints()
	WorldMapFrame:StartMoving();
end)

movebutton:SetScript("OnMouseUp", function()
	local maplock = GetCVar("advancedWorldMap")
	if maplock ~= "1" then return end
	WorldMapFrame:StopMovingOrSizing()
	WorldMapScreenAnchor:StartMoving()
	WorldMapScreenAnchor:SetPoint("TOPLEFT", WorldMapFrame)
	WorldMapScreenAnchor:StopMovingOrSizing()
end)


-- look if map is not locked
local MoveMap = GetCVarBool("advancedWorldMap")
if MoveMap == nil then
	SetCVar("advancedWorldMap", 1)
end

-- new frame to put zone and title text in
local ald = CreateFrame ("Frame", nil, WorldMapButton)
ald:SetFrameStrata("HIGH")
ald:SetFrameLevel(0)

--for the larger map
local alds = CreateFrame ("Frame", nil, WorldMapButton)
alds:SetFrameStrata("HIGH")
alds:SetFrameLevel(0)

local SmallerMapSkin = function()
	-- don't need this
	CalifporniaCFG.util.frame1px(mapbg)
	CalifporniaCFG.util.frameShadow(mapbg)

	
	-- map border and bg
	mapbg:SetScale(1 / mapscale)
	mapbg:SetPoint("TOPLEFT", WorldMapDetailFrame, -2, 2)
	mapbg:SetPoint("BOTTOMRIGHT", WorldMapDetailFrame, 2, -2)
	mapbg:SetFrameStrata("MEDIUM")
	mapbg:SetFrameLevel(20)
	
	-- move buttons / texts and hide default border
	WorldMapButton:SetAllPoints(WorldMapDetailFrame)
	WorldMapFrame:SetFrameStrata("MEDIUM")
	WorldMapFrame:SetClampedToScreen(true) 
	WorldMapDetailFrame:SetFrameStrata("MEDIUM")
	WorldMapTitleButton:Show()	
	WorldMapFrameMiniBorderLeft:Hide()
	WorldMapFrameMiniBorderRight:Hide()
	WorldMapFrameSizeUpButton:Show()
	WorldMapFrameSizeUpButton:ClearAllPoints()
	WorldMapFrameSizeUpButton:SetPoint("TOPRIGHT", WorldMapButton, "TOPRIGHT", 3, -18)
	WorldMapFrameSizeUpButton:SetFrameStrata("HIGH")
	WorldMapFrameSizeUpButton:SetFrameLevel(18)
	WorldMapFrameCloseButton:ClearAllPoints()
	WorldMapFrameCloseButton:SetPoint("TOPRIGHT", WorldMapButton, "TOPRIGHT", 3, 3)
	WorldMapFrameCloseButton:SetFrameStrata("HIGH")
	WorldMapFrameCloseButton:SetFrameLevel(18)
	WorldMapFrameSizeDownButton:SetPoint("TOPRIGHT", WorldMapFrameMiniBorderRight, "TOPRIGHT", -66, 7)
	WorldMapFrameTitle:ClearAllPoints()
	WorldMapFrameTitle:SetPoint("BOTTOMLEFT", WorldMapDetailFrame, 9, 10)
	WorldMapFrameTitle:SetFont(ft, fontsize, "OUTLINE")
	WorldMapFrameTitle:SetShadowOffset(1, -1)
	WorldMapFrameTitle:SetParent(ald)		
	WorldMapTitleButton:SetFrameStrata("MEDIUM")
	WorldMapTooltip:SetFrameStrata("TOOLTIP")

	
	WorldMapQuestShowObjectives:SetParent(ald)
	WorldMapQuestShowObjectives:ClearAllPoints()
	WorldMapQuestShowObjectives:SetPoint("BOTTOMRIGHT", WorldMapButton, "BOTTOMRIGHT", 0, 10)
	WorldMapQuestShowObjectives:SetFrameStrata("HIGH")
	WorldMapQuestShowObjectivesText:SetFont(ft, fontsize, "THINOUTLINE")
	WorldMapQuestShowObjectivesText:SetShadowOffset(1, -1)
	WorldMapQuestShowObjectivesText:ClearAllPoints()
	WorldMapQuestShowObjectivesText:SetPoint("RIGHT", WorldMapQuestShowObjectives, "LEFT", -4, 1)
	
	WorldMapShowDigSites:SetParent(ald)
	WorldMapShowDigSitesText:ClearAllPoints()
	WorldMapShowDigSitesText:SetPoint("BOTTOMLEFT", WorldMapQuestShowObjectivesText, "TOPLEFT", 0, 2)
	WorldMapShowDigSitesText:SetFont(ft, fontsize, "THINOUTLINE")
	WorldMapShowDigSitesText:SetShadowOffset(1, -1)	
	WorldMapShowDigSites:ClearAllPoints()
	WorldMapShowDigSites:SetPoint("BOTTOM", WorldMapQuestShowObjectives, "TOP", 0, 2)
	WorldMapShowDigSites:SetFrameStrata("HIGH")
	
	WorldMapFrameAreaFrame:SetFrameStrata("DIALOG")
	WorldMapFrameAreaFrame:SetFrameLevel(20)
	WorldMapFrameAreaLabel:SetFont(ft, fontsize*3, "OUTLINE")
	WorldMapFrameAreaLabel:SetShadowOffset(2, -2)
	WorldMapFrameAreaLabel:SetTextColor(0.90, 0.8294, 0.6407)
	
	-- 3.3.3, hide the dropdown added into this patch
	WorldMapLevelDropDown:SetAlpha(0)
	WorldMapLevelDropDown:SetScale(0.00001)

	-- fix tooltip not hidding after leaving quest # tracker icon
	hooksecurefunc("WorldMapQuestPOI_OnLeave", function() WorldMapTooltip:Hide() end)
end
hooksecurefunc("WorldMap_ToggleSizeDown", function() SmallerMapSkin() end)

local BiggerMapSkin = function()
	-- 3.3.3, show the dropdown added into this patch
	WorldMapLevelDropDown:SetAlpha(1)
	WorldMapLevelDropDown:SetScale(1)
	
	local fs = fontsize*0.7
	
	WorldMapQuestShowObjectives:SetParent(alds)
	WorldMapQuestShowObjectives:ClearAllPoints()
	WorldMapQuestShowObjectives:SetPoint("BOTTOMRIGHT", WorldMapButton, "BOTTOMRIGHT", 0, -28)
	WorldMapQuestShowObjectives:SetFrameStrata("HIGH")
	WorldMapQuestShowObjectivesText:SetFont(ft, fs, "THINOUTLINE")
	WorldMapQuestShowObjectivesText:SetShadowOffset(1, -1)
	WorldMapQuestShowObjectivesText:ClearAllPoints()
	WorldMapQuestShowObjectivesText:SetPoint("RIGHT", WorldMapQuestShowObjectives, "LEFT", -4, 1)
	
	WorldMapShowDigSites:SetParent(alds)
	WorldMapShowDigSitesText:ClearAllPoints()
	WorldMapShowDigSitesText:SetPoint("RIGHT", WorldMapQuestShowObjectivesText, "LEFT", -45, 0)
	WorldMapShowDigSitesText:SetFont(ft, fs, "THINOUTLINE")
	WorldMapShowDigSitesText:SetShadowOffset(1, -1)	
	WorldMapShowDigSites:ClearAllPoints()
	WorldMapShowDigSites:SetPoint("LEFT", WorldMapShowDigSitesText, "RIGHT", 2, 0)
	WorldMapShowDigSites:SetFrameStrata("HIGH")
	
	WorldMapFrameAreaFrame:SetFrameStrata("DIALOG")
	WorldMapFrameAreaFrame:SetFrameLevel(20)
	WorldMapFrameAreaLabel:SetFont(ft, fontsize*3, "OUTLINE")
	WorldMapFrameAreaLabel:SetShadowOffset(2, -2)
	WorldMapFrameAreaLabel:SetTextColor(0.90, 0.8294, 0.6407)
	
end
hooksecurefunc("WorldMap_ToggleSizeUp", function() BiggerMapSkin() end)

mapbg:SetScript("OnShow", function(self)
	local SmallerMap = GetCVarBool("miniWorldMap")
	if SmallerMap == nil then
		BiggerMapSkin()
	end
	self:SetScript("OnShow", function() end)
end)

local addon = CreateFrame('Frame')
addon:RegisterEvent('PLAYER_ENTERING_WORLD')
addon:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_ENTERING_WORLD" then
		ShowUIPanel(WorldMapFrame)
		HideUIPanel(WorldMapFrame)
		WorldMap_ToggleSizeDown()
	end
end)


-- BG TINY MAP (BG, mining, etc)
local tinymap = CreateFrame("Frame", "CpUITinyMapMover", UIParent)
tinymap:SetPoint("CENTER")
tinymap:SetSize(223, 150)
tinymap:EnableMouse(true)
tinymap:SetMovable(true)
tinymap:RegisterEvent("ADDON_LOADED")
tinymap:SetPoint("CENTER", UIParent, 0, 0)
tinymap:SetFrameLevel(20)
tinymap:Hide()

-- create minimap background
local tinymapbg = CreateFrame("Frame", nil, tinymap)
tinymapbg:SetAllPoints()
tinymapbg:SetFrameLevel(8)
--TukuiDB.SetTemplate(tinymapbg)

tinymap:SetScript("OnEvent", function(self, event, addon)
	if addon ~= "Blizzard_BattlefieldMinimap" then return end
		
	-- show holder
	self:Show()

	BattlefieldMinimap:SetScript("OnShow", function()
--		TukuiDB.Kill(BattlefieldMinimapCorner)
--		TukuiDB.Kill(BattlefieldMinimapBackground)
--		TukuiDB.Kill(BattlefieldMinimapTab)
--		TukuiDB.Kill(BattlefieldMinimapTabLeft)
--		TukuiDB.Kill(BattlefieldMinimapTabMiddle)
--		TukuiDB.Kill(BattlefieldMinimapTabRight)
		BattlefieldMinimap:SetParent(self)
		BattlefieldMinimap:SetPoint("TOPLEFT", self, "TOPLEFT", 2, -2)
		BattlefieldMinimap:SetFrameStrata(self:GetFrameStrata())
		BattlefieldMinimap:SetFrameLevel(self:GetFrameLevel() + 1)
		BattlefieldMinimapCloseButton:ClearAllPoints()
		BattlefieldMinimapCloseButton:SetPoint("TOPRIGHT", -4, 0)
		BattlefieldMinimapCloseButton:SetFrameLevel(self:GetFrameLevel() + 1)
		self:SetScale(1)
		self:SetAlpha(1)
	end)
	
	BattlefieldMinimap:SetScript("OnHide", function()
		self:SetScale(0.00001)
		self:SetAlpha(0)
	end)
	
	self:SetScript("OnMouseUp", function(self, btn)
		if btn == "LeftButton" then
			self:StopMovingOrSizing()
			if OpacityFrame:IsShown() then OpacityFrame:Hide() end -- seem to be a bug with default ui in 4.0, we hide it on next click
		elseif btn == "RightButton" then
			ToggleDropDownMenu(1, nil, BattlefieldMinimapTabDropDown, self:GetName(), 0, -4)
			if OpacityFrame:IsShown() then OpacityFrame:Hide() end -- seem to be a bug with default ui in 4.0, we hide it on next click
		end
	end)
	
	self:SetScript("OnMouseDown", function(self, btn)
		if btn == "LeftButton" then
			if BattlefieldMinimapOptions.locked then
				return
			else
				self:StartMoving()
			end
		end
	end)
end)

--[[
local coords = CreateFrame("Frame", "CoordsFrame", WorldMapFrame)
local fontheight = select(2, WorldMapQuestShowObjectivesText:GetFont())*1.1
--coords.PlayerText = TukuiDB.SetFontString(CoordsFrame, CalifporniaCFG["media"].font, fontheight, "THINOUTLINE")
--coords.MouseText = TukuiDB.SetFontString(CoordsFrame, CalifporniaCFG["media"].font, fontheight, "THINOUTLINE")
coords.PlayerText:SetTextColor(WorldMapQuestShowObjectivesText:GetTextColor())
coords.MouseText:SetTextColor(WorldMapQuestShowObjectivesText:GetTextColor())
coords.PlayerText:SetPoint("TOPLEFT", WorldMapButton, "TOPLEFT", 5, -5)
coords.PlayerText:SetText("Player:   0, 0")
coords.MouseText:SetPoint("TOPLEFT", coords.PlayerText, "BOTTOMLEFT", 0, -5)
coords.MouseText:SetText("Mouse:   0, 0")

local int = 0
coords:SetScript("OnUpdate", function(self, elapsed)
	int = int + 1
	
	if int >= 3 then
		local inInstance, _ = IsInInstance()
		local x,y = GetPlayerMapPosition("player")
		x = math.floor(100 * x)
		y = math.floor(100 * y)
		if x ~= 0 and y ~= 0 then
			self.PlayerText:SetText(PLAYER..":   "..x..", "..y)
		else
			self.PlayerText:SetText(" ")
		end

		local scale = WorldMapDetailFrame:GetEffectiveScale()
		local width = WorldMapDetailFrame:GetWidth()
		local height = WorldMapDetailFrame:GetHeight()
		local centerX, centerY = WorldMapDetailFrame:GetCenter()
		local x, y = GetCursorPosition()
		local adjustedX = (x / scale - (centerX - (width/2))) / width
		local adjustedY = (centerY + (height/2) - y / scale) / height	
		
		if (adjustedX >= 0  and adjustedY >= 0 and adjustedX <= 1 and adjustedY <= 1) then
			adjustedX = math.floor(100 * adjustedX)
			adjustedY = math.floor(100 * adjustedY)
			coords.MouseText:SetText(MOUSE_LABEL..":   "..adjustedX..", "..adjustedY)
		else
			coords.MouseText:SetText(" ")
		end
		
		int = 0
	end
end)
]]