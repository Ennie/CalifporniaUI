local addonName, ns = ...


local function LoadConfigFromVar(conf)
	print ('loading config')
	if conf == nil then return end
	for group,options in pairs(conf) do
		if Califpornia.CFG[group] then
			local count = 0
			for option,value in pairs(options) do
				if Califpornia.CFG[group][option] ~= nil then
					if Califpornia.CFG[group][option] == value then
						conf[group][option] = nil	
					else
						count = count+1
						Califpornia.CFG[group][option] = value
					end
				end
			end
			if count == 0 then conf[group] = nil end
		else
			conf[group] = nil
		end
	end 
end







CalifporniaUI = CreateFrame("frame", "CalifporniaUI", UIParent)
CalifporniaUI:RegisterEvent("VARIABLES_LOADED")
CalifporniaUI:SetScript("OnEvent", function()
	CalifporniaDB = CalifporniaDB or {}
	-- some basic variables
	CalifporniaUI.info = {
		["name"] = "|cffaa0000"..addonName.."|r",
		["version"] = GetAddOnMetadata(addonName, "Version"),
		["patch"] = GetBuildInfo(),
		["locale"] = GetLocale(),
	}
	CalifporniaUI.character = {
		["realm"] = GetRealmName(),
		["name"] = UnitName("player"),
		["class"] = select(2, UnitClass("player")),
	}

	LoadConfigFromVar(CalifporniaDB.Config)
	-- Load character settings
	if CalifporniaDB.CharConfig ~= nil and CalifporniaDB.CharConfig[CalifporniaUI.character.realm] ~= nil then
		LoadConfigFromVar(CalifporniaDB.CharConfig[CalifporniaUI.character.realm][CalifporniaUI.character.name])
	end




	-- Create Interface Options panel
	CalifporniaUI.ConfigFrame = CreateFrame("frame", CalifporniaUI.info.name, InterfaceOptionsFramePanelContainer)
	CalifporniaUI.ConfigFrame.name = CalifporniaUI.info.name
	CalifporniaUI.SubConfigFrame = CreateFrame("Frame")
	CalifporniaUI.SubConfigFrame.name = 'test 2'-- CalifporniaUI.info.name
	CalifporniaUI.SubConfigFrame.parent = CalifporniaUI.info.name

	local logo = CalifporniaUI.ConfigFrame:CreateTexture(nil, "OVERLAY")
	logo:SetPoint("TOP", CalifporniaUI.ConfigFrame, 0, -10)
	logo:SetSize(512, 128)
	logo:SetTexture("Interface\\AddOns\\CalifporniaUI\\media\\logo.blp")
--	dbh:SetVertexColor(0,0,0,0) -- set alpha to 0 to hide the texture


	InterfaceOptions_AddCategory(CalifporniaUI.ConfigFrame)
	InterfaceOptions_AddCategory(CalifporniaUI.SubConfigFrame, CalifporniaUI.ConfigFrame)

	-- clean up
	CalifporniaUI:UnregisterEvent("VARIABLES_LOADED")
	CalifporniaUI:SetScript("OnEvent", nil)
end)
