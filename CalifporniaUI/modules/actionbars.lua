
-- Hide default action bar artwork
do
	MainMenuBar:SetScale(0.00001)
	MainMenuBar:SetAlpha(0)
	MainMenuBar:EnableMouse(false)
	VehicleMenuBar:SetScale(0.00001)
	VehicleMenuBar:SetAlpha(0)
	PetActionBarFrame:EnableMouse(false)
	ShapeshiftBarFrame:EnableMouse(false)
	
--	local elements = {
--		MainMenuBar, MainMenuBarArtFrame, BonusActionBarFrame, VehicleMenuBar,
--		PossessBarFrame, PetActionBarFrame, ShapeshiftBarFrame,
--		ShapeshiftBarLeft, ShapeshiftBarMiddle, ShapeshiftBarRight,
--	}
	local elements = {
		MainMenuBar, MainMenuBarArtFrame, BonusActionBarFrame, VehicleMenuBar,
		PossessBarFrame,	ShapeshiftBarLeft, ShapeshiftBarMiddle, ShapeshiftBarRight,
	}
	for _, element in pairs(elements) do
		if element:GetObjectType() == "Frame" then
			element:UnregisterAllEvents()
		end
		if element ~= MainMenuBar then --patch 4.0.6 fix, credits to tukz
--			element:HookScript("OnShow", function(s) s:Hide(); end)
			element:Hide()
			element:SetAlpha(0)
		end
--		element:Hide()
	end
	elements = nil

	-- fix main bar keybind not working after a talent switch. :X
	hooksecurefunc('TalentFrame_LoadUI', function()
		PlayerTalentFrame:UnregisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
	end)
end

do
	local uiManagedFrames = {
		"MultiBarLeft",
		"MultiBarRight",
		"MultiBarBottomLeft",
		"MultiBarBottomRight",
		"ShapeshiftBarFrame",
		"PossessBarFrame",
		"PETACTIONBAR_YPOS",
		"MultiCastActionBarFrame",
		"MULTICASTACTIONBAR_YPOS",
		"ChatFrame1",
		"ChatFrame2",
	}
	for _, frame in pairs(uiManagedFrames) do
		UIPARENT_MANAGED_FRAME_POSITIONS[frame] = nil
	end
	uiManagedFrames = nil
end




local function SetButtonFontsBig(button)
	local bname = _G[button:GetName().."Name"]
	local bcount = _G[button:GetName().."Count"]
	local bkey = _G[button:GetName().."HotKey"]
	if Califpornia.CFG.actionbars.big_macro then
		bname:SetFont(unpack(Califpornia.CFG.actionbars.big_macro_font))
	else
		bname:Hide()
	end
	bcount:SetFont(unpack(Califpornia.CFG.actionbars.big_font))
	bkey:SetFont(unpack(Califpornia.CFG.actionbars.big_font))
end

local function SetButtonFontsSmall(button)
	local bname = _G[button:GetName().."Name"]
	local bcount = _G[button:GetName().."Count"]
	local bkey = _G[button:GetName().."HotKey"]
	if Califpornia.CFG.actionbars.small_macro then
		bname:SetFont(unpack(Califpornia.CFG.actionbars.small_font))
	else
		bname:Hide()
	end
	bcount:SetFont(unpack(Califpornia.CFG.actionbars.small_font))
	bkey:SetFont(unpack(Califpornia.CFG.actionbars.small_font))
end

Califpornia.Bars = {}

----------------------------------------------------------------------------------------
-- 			MAIN BAR - big buttons
----------------------------------------------------------------------------------------

Califpornia.Bars["Main"] = CreateFrame("Frame", "CalifporniaActionBarMain", UIParent, "SecureHandlerStateTemplate")
Califpornia.Bars["Main"]:SetWidth(Califpornia.CFG.actionbars.big_button*12+Califpornia.CFG.actionbars.btn_spacing*11)
Califpornia.Bars["Main"]:SetHeight(Califpornia.CFG.actionbars.big_button)
Califpornia.Bars["Main"]:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 52)

local Page = {
--	["DRUID"] = "[bonusbar:1,nostealth] 7; [bonusbar:1,stealth] 8; [bonusbar:2] 8; [bonusbar:3] 9; [bonusbar:4] 10;",
	["DRUID"] = "[bonusbar:1] 7; [bonusbar:2] 8; [bonusbar:3] 9; [bonusbar:4] 10;",
	["WARRIOR"] = "[bonusbar:1] 7; [bonusbar:2] 8; [bonusbar:3] 9;",
	["PRIEST"] = "[bonusbar:1] 7;",
	["ROGUE"] = "[bonusbar:1] 7; [form:3] 7;",
	["DEFAULT"] = "[bonusbar:5] 11; [bar:2] 2; [bar:3] 3; [bar:4] 4; [bar:5] 5; [bar:6] 6;",
}

local function GetBar()
	local condition = Page["DEFAULT"]
	local class = Califpornia.myclass
	local page = Page[class]
	if page then
		condition = condition.." "..page
	end
	condition = condition.." 1"
	return condition
end

function PositionMainBar()
	local button
	for i = 1, NUM_ACTIONBAR_BUTTONS do
		button = _G["ActionButton"..i]
		button:SetSize(Califpornia.CFG.actionbars.big_button, Califpornia.CFG.actionbars.big_button)
		button:SetParent(CalifporniaActionBarMain)
		Califpornia.SkinButton(button, true, false)
		SetButtonFontsBig(button)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", CalifporniaActionBarMain, Califpornia.CFG.actionbars.btn_spacing, Califpornia.CFG.actionbars.btn_spacing)
		else
			local previous = _G["ActionButton"..i-1]
			button:SetPoint("LEFT", previous, "RIGHT", Califpornia.CFG.actionbars.btn_spacing, 0)
		end
	end
end

Califpornia.Bars["Main"]:RegisterEvent("PLAYER_LOGIN")
Califpornia.Bars["Main"]:RegisterEvent("PLAYER_ENTERING_WORLD")
Califpornia.Bars["Main"]:RegisterEvent("KNOWN_CURRENCY_TYPES_UPDATE")
Califpornia.Bars["Main"]:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
Califpornia.Bars["Main"]:RegisterEvent("BAG_UPDATE")
Califpornia.Bars["Main"]:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		local button
		for i = 1, NUM_ACTIONBAR_BUTTONS do
			button = _G["ActionButton"..i]
			self:SetFrameRef("ActionButton"..i, button)
		end	

		self:Execute([[
			buttons = table.new()
			for i = 1, 12 do
				table.insert(buttons, self:GetFrameRef("ActionButton"..i))
			end
			firedonce = false
		]])

		self:SetAttribute("_onstate-page", [[ 
			for i, button in ipairs(buttons) do
				button:SetAttribute("actionpage", tonumber(newstate))
			end
		]])
		
		RegisterStateDriver(self, "page", GetBar())
		RegisterStateDriver(self, "vehicleupdate", "[vehicleui] s2;s1")
	elseif event == "PLAYER_ENTERING_WORLD" then
		PositionMainBar()
	else
		MainMenuBar_OnEvent(self, event, ...)
	end
end)
----------------------------------------------------------------------------------------
-- 			TOP LEFT BAR (aka MultiBarBottomLeft)
----------------------------------------------------------------------------------------

Califpornia.Bars["TopLeft"] = CreateFrame("Frame", "CalifporniaActionBarTopLeft", UIParent)
Califpornia.Bars["TopLeft"]:SetWidth(Califpornia.CFG.actionbars.small_button*12+Califpornia.CFG.actionbars.btn_spacing*11)
Califpornia.Bars["TopLeft"]:SetHeight(Califpornia.CFG.actionbars.small_button)
Califpornia.Bars["TopLeft"]:SetPoint("BOTTOMLEFT", CalifporniaActionBarMain, "TOPLEFT", 0, Califpornia.CFG.actionbars.btn_spacing)
MultiBarBottomLeft:SetParent(Califpornia.Bars["TopLeft"])

do
	local button
	for i=1, NUM_ACTIONBAR_BUTTONS do
		button = _G["MultiBarBottomLeftButton"..i]
		button:ClearAllPoints()
		button:SetSize(Califpornia.CFG.actionbars.small_button, Califpornia.CFG.actionbars.small_button)
		Califpornia.SkinButton(button, true, false)
		SetButtonFontsSmall(button)
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", CalifporniaActionBarTopLeft, Califpornia.CFG.actionbars.btn_spacing, Califpornia.CFG.actionbars.btn_spacing)
		else
			local previous = _G["MultiBarBottomLeftButton"..i-1]
			button:SetPoint("LEFT", previous, "RIGHT", Califpornia.CFG.actionbars.btn_spacing, 0)
		end
	end
	Califpornia.Bars["TopLeft"]:Show()
end
----------------------------------------------------------------------------------------
-- 			TOP RIGHT BAR (aka MultiBarBottomRight)
----------------------------------------------------------------------------------------
Califpornia.Bars["TopRight"] = CreateFrame("Frame", "CalifporniaActionBarTopRight", UIParent)
Califpornia.Bars["TopRight"]:SetWidth(Califpornia.CFG.actionbars.small_button*12+Califpornia.CFG.actionbars.btn_spacing*11)
Califpornia.Bars["TopRight"]:SetHeight(Califpornia.CFG.actionbars.small_button)
Califpornia.Bars["TopRight"]:SetPoint("BOTTOMRIGHT", CalifporniaActionBarMain, "TOPRIGHT", 0, Califpornia.CFG.actionbars.btn_spacing)
MultiBarBottomRight:SetParent(Califpornia.Bars["TopRight"])

do
	local button
	for i=1, NUM_ACTIONBAR_BUTTONS do
		button = _G["MultiBarBottomRightButton"..i]
		button:SetSize(Califpornia.CFG.actionbars.small_button, Califpornia.CFG.actionbars.small_button)
		Califpornia.SkinButton(button, true, false)
		SetButtonFontsSmall(button)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", CalifporniaActionBarTopRight, Califpornia.CFG.actionbars.btn_spacing, Califpornia.CFG.actionbars.btn_spacing)
		else
			local previous = _G["MultiBarBottomRightButton"..i-1]
			button:SetPoint("LEFT", previous, "RIGHT", Califpornia.CFG.actionbars.btn_spacing, 0)
		end
	end
	Califpornia.Bars["TopRight"]:Show()
end

----------------------------------------------------------------------------------------
-- 			BOTTOM Left BAR (aka MultiBarLeft)
----------------------------------------------------------------------------------------
Califpornia.Bars["BottomLeft"] = CreateFrame("Frame", "CalifporniaActionBarBottomLeft", UIParent)
Califpornia.Bars["BottomLeft"]:SetWidth(Califpornia.CFG.actionbars.small_button*12+Califpornia.CFG.actionbars.btn_spacing*11)
Califpornia.Bars["BottomLeft"]:SetHeight(Califpornia.CFG.actionbars.small_button)
Califpornia.Bars["BottomLeft"]:SetPoint("TOPLEFT", CalifporniaActionBarMain, "BOTTOMLEFT", 0, Califpornia.CFG.actionbars.btn_spacing)
MultiBarLeft:SetParent(Califpornia.Bars["BottomLeft"])

do
	for i=1, NUM_ACTIONBAR_BUTTONS do
		local button = _G["MultiBarLeftButton"..i]
		button:SetSize(Califpornia.CFG.actionbars.small_button, Califpornia.CFG.actionbars.small_button)
		Califpornia.SkinButton(button, true, false)
		SetButtonFontsSmall(button)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", CalifporniaActionBarBottomLeft, Califpornia.CFG.actionbars.btn_spacing, Califpornia.CFG.actionbars.btn_spacing)
		else
			local previous = _G["MultiBarLeftButton"..i-1]
			button:SetPoint("LEFT", previous, "RIGHT", Califpornia.CFG.actionbars.btn_spacing, 0)
		end
	end
	Califpornia.Bars["BottomLeft"]:Show()
end
----------------------------------------------------------------------------------------
-- 			BOTTOM Right BAR (aka MultiBarRight)
----------------------------------------------------------------------------------------
Califpornia.Bars["BottomRight"] = CreateFrame("Frame", "CalifporniaActionBarBottomRight", UIParent)
Califpornia.Bars["BottomRight"]:SetWidth(Califpornia.CFG.actionbars.small_button*12+Califpornia.CFG.actionbars.btn_spacing*11)
Califpornia.Bars["BottomRight"]:SetHeight(Califpornia.CFG.actionbars.small_button)
Califpornia.Bars["BottomRight"]:SetPoint("TOPRIGHT", CalifporniaActionBarMain, "BOTTOMRIGHT", 0, Califpornia.CFG.actionbars.btn_spacing)
MultiBarRight:SetParent(Califpornia.Bars["BottomRight"])

do
	for i=1, NUM_ACTIONBAR_BUTTONS do
		local button = _G["MultiBarRightButton"..i]
		button:SetSize(Califpornia.CFG.actionbars.small_button, Califpornia.CFG.actionbars.small_button)
		Califpornia.SkinButton(button, true, false)
		SetButtonFontsSmall(button)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", CalifporniaActionBarBottomRight, Califpornia.CFG.actionbars.btn_spacing, Califpornia.CFG.actionbars.btn_spacing)
		else
			local previous = _G["MultiBarRightButton"..i-1]
			button:SetPoint("LEFT", previous, "RIGHT", Califpornia.CFG.actionbars.btn_spacing, 0)
		end
	end
	Califpornia.Bars["BottomRight"]:Show()
end
----------------------------------------------------------------------------------------
-- 			PET BAR
----------------------------------------------------------------------------------------
local num = NUM_PET_ACTION_SLOTS

Califpornia.Bars["Pet"] = CreateFrame("Frame", "CalifporniaActionBarPet", UIParent)
Califpornia.Bars["Pet"]:SetWidth(Califpornia.CFG.actionbars.small_button*num+Califpornia.CFG.actionbars.btn_spacing*(num-1))
Califpornia.Bars["Pet"]:SetHeight(Califpornia.CFG.actionbars.small_button)
Califpornia.Bars["Pet"]:SetPoint("BOTTOMRIGHT", CalifporniaActionBarMain, "TOPRIGHT", 0, Califpornia.CFG.actionbars.small_button + Califpornia.CFG.actionbars.btn_spacing)
PetActionBarFrame:SetParent(Califpornia.Bars["Pet"])
PetActionBarFrame:EnableMouse(false)

do
	for i = 1, num do
		local button = _G["PetActionButton"..i]
		local cd = _G["PetActionButton"..i.."Cooldown"]
		button:SetSize(Califpornia.CFG.actionbars.small_button, Califpornia.CFG.actionbars.small_button)
		Califpornia.SkinButton(button, true, false)
		SetButtonFontsSmall(button)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", CalifporniaActionBarPet, Califpornia.CFG.actionbars.btn_spacing,0)
		else
			local previous = _G["PetActionButton"..i-1]	
			button:SetPoint("LEFT", previous, "RIGHT", Califpornia.CFG.actionbars.btn_spacing, 0)
		end
		cd:SetAllPoints(button)
	end
end
----------------------------------------------------------------------------------------
-- 			STANCE BAR
----------------------------------------------------------------------------------------
local num = NUM_SHAPESHIFT_SLOTS

Califpornia.Bars["Stance"] = CreateFrame("Frame", "CalifporniaActionBarStance", UIParent)
Califpornia.Bars["Stance"]:SetWidth(Califpornia.CFG.actionbars.small_button*num+Califpornia.CFG.actionbars.btn_spacing*(num-1))
Califpornia.Bars["Stance"]:SetHeight(Califpornia.CFG.actionbars.small_button)
Califpornia.Bars["Stance"]:SetPoint("BOTTOMLEFT", CalifporniaActionBarMain, "TOPLEFT", 0, Califpornia.CFG.actionbars.small_button + Califpornia.CFG.actionbars.btn_spacing)
ShapeshiftBarFrame:SetParent(Califpornia.Bars["Stance"])
ShapeshiftBarFrame:EnableMouse(false)

do
	for i = 1, num do
		local button = _G["ShapeshiftButton"..i]
		button:SetSize(Califpornia.CFG.actionbars.small_button, Califpornia.CFG.actionbars.small_button)
		Califpornia.SkinButton(button, true, false)
		SetButtonFontsSmall(button)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", CalifporniaActionBarStance, Califpornia.CFG.actionbars.btn_spacing,0)
		else
			local previous = _G["ShapeshiftButton"..i-1]	
			button:SetPoint("LEFT", previous, "RIGHT", Califpornia.CFG.actionbars.btn_spacing, 0)
		end
	end
	local function CalifporniaUI_MoveShapeshift()
		ShapeshiftButton1:SetPoint("BOTTOMLEFT", CalifporniaActionBarStance, 0,0)
	end
	hooksecurefunc("ShapeshiftBar_Update", CalifporniaUI_MoveShapeshift);
end
----------------------------------------------------------------------------------------
-- 			EXTRA ACTION BAR (4.3)
----------------------------------------------------------------------------------------
local num = 1 -- (number of extra action buttons)
Califpornia.Bars["Extra"] = CreateFrame("Frame", "CalifporniaActionBarExtra", UIParent)
Califpornia.Bars["Extra"]:SetWidth(Califpornia.CFG.actionbars.small_button*num+Califpornia.CFG.actionbars.btn_spacing*(num-1))
Califpornia.Bars["Extra"]:SetHeight(Califpornia.CFG.actionbars.small_button)
Califpornia.Bars["Extra"]:SetPoint("BOTTOM", CalifporniaActionBarMain, "TOP", 0, Califpornia.CFG.actionbars.small_button + Califpornia.CFG.actionbars.btn_spacing)


for i=1, num do
	local button = _G["ExtraActionButton"..i]
	if not button then return end
	button:SetSize(Califpornia.CFG.actionbars.small_button, Califpornia.CFG.actionbars.small_button)
	Califpornia.SkinButton(button, true, false)
	--SetButtonFontsSmall(button)
	button:ClearAllPoints()
	if i == 1 then
		button:SetPoint("BOTTOMLEFT", CalifporniaActionBarExtra, Califpornia.CFG.actionbars.btn_spacing,0)
	else
		local previous = _G["ExtraActionButton"..i-1]
		button:SetPoint("LEFT", previous, "RIGHT", Califpornia.CFG.actionbars.btn_spacing, 0)
	end
end


Califpornia.Bars["Extra"]:RegisterEvent("UPDATE_EXTRA_ACTIONBAR")
Califpornia.Bars["Extra"]:SetScript("OnEvent", function(self, event, ...)
	if (event == "UPDATE_EXTRA_ACTIONBAR") then
		if (HasExtraActionBar()) then
			self:Show()
		elseif(self:IsShown()) then
			self:Hide()
		end
	end
end)

----------------------------------------------------------------------------------------
-- 			VEHICLE EXIT BUTTON
----------------------------------------------------------------------------------------
Califpornia.Bars["VehicleExit"] = CreateFrame("Frame", "CalifporniaActionBarVehicleExit", UIParent)
Califpornia.Bars["VehicleExit"]:SetWidth(Califpornia.CFG.actionbars.small_button)
Califpornia.Bars["VehicleExit"]:SetHeight(Califpornia.CFG.actionbars.small_button)
Califpornia.Bars["VehicleExit"]:SetPoint("BOTTOM", CalifporniaActionBarMain, "TOP", 0, Califpornia.CFG.actionbars.small_button + Califpornia.CFG.actionbars.btn_spacing)

do
	local vbtn = CreateFrame("BUTTON", nil, CalifporniaActionBarVehicleExit, "SecureActionButtonTemplate");
	vbtn:SetAllPoints(CalifporniaActionBarVehicleExit)
	vbtn:RegisterForClicks("AnyUp")
	vbtn:SetNormalTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Up")
	vbtn:SetPushedTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Down")
	vbtn:SetHighlightTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Down")
	vbtn:SetScript("OnClick", function(self) VehicleExit() end)
	vbtn:RegisterEvent("UNIT_ENTERING_VEHICLE")
	vbtn:RegisterEvent("UNIT_ENTERED_VEHICLE")
	vbtn:RegisterEvent("UNIT_EXITING_VEHICLE")
	vbtn:RegisterEvent("UNIT_EXITED_VEHICLE")
	vbtn:SetScript("OnEvent", function(self,event,...)
		local arg1 = ...;
		if(((event=="UNIT_ENTERING_VEHICLE") or (event=="UNIT_ENTERED_VEHICLE")) and arg1 == "player") then
			--vbtn:SetAlpha(1)
			vbtn:Show()
		elseif(((event=="UNIT_EXITING_VEHICLE") or (event=="UNIT_EXITED_VEHICLE")) and arg1 == "player") then
			--vbtn:SetAlpha(0)
			vbtn:Hide()
		end
	end)  
	--vbtn:SetAlpha(0)
	vbtn:Hide()
end
----------------------------------------------------------------------------------------
-- 			Style flyouts
----------------------------------------------------------------------------------------
local buttons = 0
local function FlyoutButtonPos(self, buttons, direction)
	for i=1, buttons do
		local parent = SpellFlyout:GetParent()
		if not _G["SpellFlyoutButton"..i] then return end
		
		if InCombatLockdown() then return end
 
		Califpornia.SkinButton(_G["SpellFlyoutButton"..i], false, false)
		if direction == "LEFT" then
			if i == 1 then
				_G["SpellFlyoutButton"..i]:ClearAllPoints()
				_G["SpellFlyoutButton"..i]:SetPoint("RIGHT", parent, "LEFT", -4, 0)
			else
				_G["SpellFlyoutButton"..i]:ClearAllPoints()
				_G["SpellFlyoutButton"..i]:SetPoint("RIGHT", _G["SpellFlyoutButton"..i-1], "LEFT", -4, 0)
			end
		else
			if i == 1 then
				_G["SpellFlyoutButton"..i]:ClearAllPoints()
				_G["SpellFlyoutButton"..i]:SetPoint("BOTTOM", parent, "TOP", 0, 4)
			else
				_G["SpellFlyoutButton"..i]:ClearAllPoints()
				_G["SpellFlyoutButton"..i]:SetPoint("BOTTOM", _G["SpellFlyoutButton"..i-1], "TOP", 0, 0)
			end
		end
	end
end
local function styleflyout(self)
	if not self.FlyoutArrow then
		return;
	end
	self.FlyoutBorder:SetAlpha(0)
	self.FlyoutBorderShadow:SetAlpha(0)
	
	SpellFlyoutHorizontalBackground:SetAlpha(0)
	SpellFlyoutVerticalBackground:SetAlpha(0)
	SpellFlyoutBackgroundEnd:SetAlpha(0)
	
	for i=1, GetNumFlyouts() do
		local x = GetFlyoutID(i)
		local _, _, numSlots, isKnown = GetFlyoutInfo(x)
		if isKnown then
			buttons = numSlots
			break
		end
	end
	
	local arrowDistance
	if ((SpellFlyout and SpellFlyout:IsShown() and SpellFlyout:GetParent() == self) or GetMouseFocus() == self) then
		arrowDistance = 5
	else
		arrowDistance = 2
	end
	
	FlyoutButtonPos(self,buttons,"UP")
end
hooksecurefunc("ActionButton_UpdateFlyout", styleflyout)
----------------------------------------------------------------------------------------
-- 			OMG OMG SHAMAN TOTEM BAR
----------------------------------------------------------------------------------------
if Califpornia.myclass ~= "SHAMAN" then return end

if Califpornia.myclass == "SHAMAN" then
	if MultiCastActionBarFrame then
		MultiCastActionBarFrame:SetScript("OnUpdate", nil)
		MultiCastActionBarFrame:SetScript("OnShow", nil)
		MultiCastActionBarFrame:SetScript("OnHide", nil)
		MultiCastActionBarFrame:SetParent(CalifporniaActionBarStance)
		MultiCastActionBarFrame:ClearAllPoints()
		MultiCastActionBarFrame:SetPoint("BOTTOMLEFT", CalifporniaActionBarStance, 0, 0)
 		MultiCastActionBarFrame:SetScale(0.65)
		hooksecurefunc("MultiCastActionButton_Update",function(actionbutton) if not InCombatLockdown() then actionbutton:SetAllPoints(actionbutton.slotButton) end end)
 
		MultiCastActionBarFrame.SetParent = Califpornia.dummy
		MultiCastActionBarFrame.SetPoint = Califpornia.dummy
		MultiCastRecallSpellButton.SetPoint = Califpornia.dummy
	end
end
