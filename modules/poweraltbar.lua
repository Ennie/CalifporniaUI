-- Config
AltPowerSettings = {
	StatusTex = [[Interface\AddOns\SmellyPowerBar\Media\Bubble.tga]],		-- Texture for statusbar
	PanelTex = [[Interface\AddOns\SmellyPowerBar\Media\Flat.tga]],		-- Texture for panel
	font = [[Interface\AddOns\SmellyPowerBar\Media\arial.ttf]],		-- Font
	fontsize = 15, 		-- Font size
	barWidth = 150,		-- Bar width
	barHeight = 23,		-- Bar height
	anchor = {"TOP", UIParent, "TOP", 0, -6},	-- Defualt anchor of the bar
	
	-- Coloring config
	colors = {
		{0, 0, 0},			-- Backdrop color of panel
		{.2, .2, .2, 1},	-- Backdrop border color of panel	
		{0, 1, 0},			-- Color of statusbar
	},
}

-- Get rid of old Alt Power Bar
PlayerPowerBarAlt:SetAlpha(0)

local AltPowerBar = {}
function AltPowerBar:Create()
	local frame = self.frame
	--Create Background and Border
	local AltPowerBG = CreateFrame("Frame", "AltPowerBG", frame)
	AltPowerBG:SetHeight(AltPowerSettings.barHeight)
	AltPowerBG:SetWidth(AltPowerSettings.barWidth)
	AltPowerBG:SetPoint(unpack(AltPowerSettings.anchor))
	AltPowerBG:SetBackdrop({
		bgFile = AltPowerSettings.PanelTex, 
		edgeFile = AltPowerSettings.PanelTex, 
		tile = false, tileSize = 0, edgeSize = 1, 
		insets = { left = -1, right = -1, top = -1, bottom = -1}
	})
	AltPowerBG:SetBackdropColor(unpack(AltPowerSettings.colors[1]))
	AltPowerBG:SetBackdropBorderColor(unpack(AltPowerSettings.colors[2]))
	AltPowerBG:SetMovable(true)
	AltPowerBG:SetClampedToScreen(true)
	AltPowerBG:SetUserPlaced(true)
	
	-- For Tukui users :D
	if IsAddOnLoaded("Tukui") then
		TukuiDB.SetTemplate(AltPowerBG)
		AltPowerBG:SetBackdropColor(unpack(TukuiCF["media"].backdropcolor))
	end

	-- Create Status Bar and Text
	local AltPowerBar = CreateFrame("StatusBar", "AltPowerBar", AltPowerBG)
	AltPowerBar:SetStatusBarTexture(AltPowerSettings.StatusTex)
	AltPowerBar:SetMinMaxValues(0, 100)
	AltPowerBar:SetPoint("TOPLEFT", AltPowerBG, "TOPLEFT", 2, -2)
	AltPowerBar:SetPoint("BOTTOMRIGHT", AltPowerBG, "BOTTOMRIGHT", -2, 2)
	AltPowerBar:SetStatusBarColor(unpack(AltPowerSettings.colors[3]))

	local AltPowerText = AltPowerBar:CreateFontString(nil, "OVERLAY")
	AltPowerText:SetFont(AltPowerSettings.font, AltPowerSettings.fontsize, "THINOUTLINE")
	AltPowerText:SetPoint("CENTER", AltPowerBG, "CENTER")

	--Event handling
	frame:RegisterEvent("UNIT_POWER")
	frame:RegisterEvent("UNIT_POWER_BAR_SHOW")
	frame:RegisterEvent("UNIT_POWER_BAR_HIDE")
	frame:SetScript("OnEvent", function() 
		self:ShowBar() 
	end)

	-- Update Functions
	-- Credits To Foof for code design
	AltPowerBar.TimeSinceLastUpdate = 0
	AltPowerBar:SetScript("OnUpdate", function(self, elapsed)
		self.TimeSinceLastUpdate = self.TimeSinceLastUpdate + elapsed; 
		
		if (self.TimeSinceLastUpdate > 0.07) then
			self:SetMinMaxValues(0, UnitPowerMax("player", ALTERNATE_POWER_INDEX))
			local power = UnitPower("player", ALTERNATE_POWER_INDEX)
			local mpower = UnitPowerMax("player", ALTERNATE_POWER_INDEX)
			self:SetValue(power)
			if (AltPowerText) then
				AltPowerText:SetText(power.."/"..mpower)
			end
			self.TimeSinceLastUpdate = 0
		end
	end)
end

-- Move function
-- Credits to Hydra for code design
local pmove = false 
local function POWER()
	if pmove == false then
		pmove = true
		print("Power Bar unlocked")
		AltPowerBG:EnableMouse(true)
		AltPowerBG:Show()
		AltPowerBG:RegisterForDrag("LeftButton")
		AltPowerBG:SetScript("OnDragStart", AltPowerBG.StartMoving)
		AltPowerBG:SetScript("OnDragStop", AltPowerBG.StopMovingOrSizing)
	elseif pmove == true then
		AltPowerBG:Hide()
		AltPowerBG:EnableMouse(false)
		pmove = false
		print("Power Bar locked")
	end
end
SLASH_POWER1 = "/pmove"
SlashCmdList["POWER"] = POWER

-- Hide / Show function
function AltPowerBar:ShowBar()
	if UnitAlternatePowerInfo("player") then
		AltPowerBG:Show()
	else
		AltPowerBG:Hide()
	end
end

-- Event Trigger
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", function()
	AltPowerBar:Create()
	AltPowerBar:ShowBar()
end)
AltPowerBar.frame = frame