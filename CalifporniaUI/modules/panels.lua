if not Califpornia.CFG.panels.enable == true then return end

Califpornia.Panels = {}

local function scale(x)
    return 1*math.floor(x/1+.5)
end


-- CreatePanel
Califpornia.Panels.CreatePanel = function(f, w, h, a1, p, a2, x, y)
	local r, g, b =Califpornia.CFG.colors.class_color.r, Califpornia.CFG.colors.class_color.g, Califpornia.CFG.colors.class_color.b
	sh = scale(h)
	sw = scale(w)
	f:SetFrameLevel(1)
	f:SetHeight(sh)
	f:SetWidth(sw)
	f:SetFrameStrata("BACKGROUND")
	f:SetPoint(a1, p, a2, x, y)
	f:SetBackdrop({
	  bgFile =  [=[Interface\ChatFrame\ChatFrameBackground]=],
      edgeFile = "Interface\\Buttons\\WHITE8x8", 
	  tile = false, tileSize = 0, edgeSize = 1, 
	  insets = { left = -1, right = -1, top = -1, bottom = -1}
	})
	f:SetBackdropColor(unpack(Califpornia.CFG.colors.class_backdrop))
	f:SetBackdropBorderColor(unpack(Califpornia.CFG.colors.class_backdrop_border))
	
	Califpornia.Lib.outerBorder(f)
	Califpornia.Lib.innerBorder(f)
end

--Set Datatext Postitions
Califpornia.Panels.CreateDataText = function(p)
	local obj
	if p <= 3 then
		obj  = Califpornia.Panels.dataleft:CreateFontString(nil, "OVERLAY")
	elseif p <= 6 then
		obj  = Califpornia.Panels.dataright:CreateFontString(nil, "OVERLAY")
	else
		obj  = Califpornia.Panels.datamid:CreateFontString(nil, "OVERLAY")
	end
	obj:SetFont(unpack(Califpornia.CFG.panels.font))

	if p == 1 then
		obj:SetHeight(Califpornia.Panels.dataleft:GetHeight())
		obj:SetPoint("LEFT", Califpornia.Panels.dataleft, "LEFT", 10, 0)
	elseif p == 2 then
		obj:SetHeight(Califpornia.Panels.dataleft:GetHeight())
		obj:SetPoint("CENTER", Califpornia.Panels.dataleft, "CENTER", 0, 0)
	elseif p == 3 then
		obj:SetHeight(Califpornia.Panels.dataleft:GetHeight())
		obj:SetPoint("RIGHT", Califpornia.Panels.dataleft, "RIGHT", -10, 0)
	elseif p == 4 then
		obj:SetHeight(Califpornia.Panels.dataright:GetHeight())
		obj:SetPoint("LEFT", Califpornia.Panels.dataright,"LEFT", 10, 0)
	elseif p == 5 then
		obj:SetHeight(DataRightPanel:GetHeight())
		obj:SetPoint("CENTER", Califpornia.Panels.dataright,"CENTER", 0, 0)
	elseif p == 6 then
		obj:SetHeight(Califpornia.Panels.dataright:GetHeight())
		obj:SetPoint("RIGHT", Califpornia.Panels.dataright,"RIGHT", -10, 0)
	elseif p == 7 then
		obj:SetParent(Califpornia.Panels.datamid_holder)
		obj:SetHeight(Califpornia.Panels.datamid:GetHeight())
		obj:SetPoint("LEFT", Califpornia.Panels.datamid,"LEFT", 10, 0)
	elseif p == 8 then
		obj:SetParent(Califpornia.Panels.datamid_holder)
		obj:SetHeight(Califpornia.Panels.datamid:GetHeight())
		obj:SetPoint("CENTER", Califpornia.Panels.datamid,"CENTER", 0, 0)
	elseif p == 9 then
		obj:SetParent(Califpornia.Panels.datamid_holder)
		obj:SetHeight(Califpornia.Panels.datamid:GetHeight())
		obj:SetPoint("RIGHT", Califpornia.Panels.datamid,"RIGHT", -10, 0)
	end
	return obj
end

Califpornia.Panels.dataleft = CreateFrame("Frame", "DataLeftPanel", UIParent)
Califpornia.Panels.CreatePanel(Califpornia.Panels.dataleft, Califpornia.CFG.panels.block_width - Califpornia.CFG.panels.mini_height - Califpornia.CFG.panels.spacer, Califpornia.CFG.panels.mini_height, "BOTTOMLEFT", UIParent, "BOTTOMLEFT", 10, 10)
Califpornia.Lib.frameShadow(Califpornia.Panels.dataleft)
Califpornia.Panels.dataleft:SetFrameLevel(2)

Califpornia.Panels.dataright = CreateFrame("Frame", "DataRightPanel", UIParent)
Califpornia.Panels.CreatePanel(Califpornia.Panels.dataright, Califpornia.CFG.panels.block_width --[[ Califpornia.CFG.panels.mini_height - Califpornia.CFG.panels.spacer]], Califpornia.CFG.panels.mini_height, "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -10, 10)
Califpornia.Lib.frameShadow(Califpornia.Panels.dataright)
Califpornia.Panels.dataright:SetFrameLevel(2)

Califpornia.Panels.dataleftbtn = CreateFrame("Frame", "DataLeftPanelButton", UIParent)
Califpornia.Panels.CreatePanel(Califpornia.Panels.dataleftbtn, Califpornia.CFG.panels.mini_height, Califpornia.CFG.panels.mini_height, "BOTTOMLEFT", Califpornia.Panels.dataleft, "BOTTOMRIGHT", Califpornia.CFG.panels.spacer, 0)
Califpornia.Lib.frameShadow(Califpornia.Panels.dataleftbtn)
Califpornia.Panels.dataleftbtn:SetFrameLevel(2)

Califpornia.Panels.datamid = CreateFrame("Frame", "DataMidPanel", UIParent)
Califpornia.Panels.CreatePanel(Califpornia.Panels.datamid, Califpornia.res_x-2*Califpornia.CFG.panels.block_width-2*Califpornia.CFG.panels.spacer-2*Califpornia.CFG.common.screen_spacer, Califpornia.CFG.panels.mini_height, "LEFT", Califpornia.Panels.dataleftbtn, "RIGHT", Califpornia.CFG.panels.spacer, 0)
Califpornia.Lib.frameShadow(Califpornia.Panels.datamid)
Califpornia.Panels.datamid:SetPoint("RIGHT", Califpornia.Panels.dataright, "LEFT", -Califpornia.CFG.panels.spacer, 0)
Califpornia.Panels.datamid:SetFrameLevel(2)
Califpornia.Panels.datamid_holder = CreateFrame("Frame", "DataMidPanelHolder", UIParent)
Califpornia.Panels.datamid_holder:Hide()

Califpornia.Panels.chat = CreateFrame("Frame", "ChatLBackground", Califpornia.Panels.dataleft)
Califpornia.Panels.CreatePanel(Califpornia.Panels.chat, Califpornia.CFG.panels.block_width, Califpornia.CFG.panels.block_height, "BOTTOMLEFT", Califpornia.Panels.dataleft , "TOPLEFT", 0, Califpornia.CFG.panels.spacer)
Califpornia.Lib.frameShadow(Califpornia.Panels.chat)


--[[Califpornia.Panels.datarightbtn = CreateFrame("Frame", "DataRightPanelButton", UIParent)
Califpornia.Panels.CreatePanel(Califpornia.Panels.datarightbtn, Califpornia.CFG.panels.mini_height, Califpornia.CFG.panels.mini_height, "BOTTOMRIGHT", Califpornia.Panels.dataright, "BOTTOMLEFT", -Califpornia.CFG.panels.spacer, 0)
Califpornia.Lib.frameShadow(Califpornia.Panels.datarightbtn)
Califpornia.Panels.datarightbtn:SetFrameLevel(2)]]

Califpornia.Panels.minimap = CreateFrame("Frame", "CPMiniMap", Califpornia.Panels.dataright)
Califpornia.Panels.CreatePanel(Califpornia.Panels.minimap, Califpornia.CFG.panels.block_height, Califpornia.CFG.panels.block_height, "BOTTOMRIGHT", Califpornia.Panels.dataright, "TOPRIGHT", 0, Califpornia.CFG.panels.spacer)
Califpornia.Lib.frameShadow(Califpornia.Panels.minimap)
Califpornia.Panels.minimap:SetFrameLevel(2)

-- Panel for DPS meter. 
Califpornia.Panels.damage = CreateFrame("Frame", "CPDamage", UIParent)
Califpornia.Panels.CreatePanel(Califpornia.Panels.damage, Califpornia.CFG.panels.block_width - Califpornia.CFG.panels.block_height - Califpornia.CFG.panels.spacer, Califpornia.CFG.panels.block_height, "BOTTOMRIGHT", Califpornia.Panels.minimap, "BOTTOMLEFT", -Califpornia.CFG.panels.spacer, 0)
Califpornia.Lib.frameShadow(Califpornia.Panels.damage)
Califpornia.Panels.damage:SetFrameLevel(2)



-- Panel for Omen.
--[[Califpornia.Panels.omen = CreateFrame("Frame", "CPOmen", UIParent)
Califpornia.Panels.CreatePanel(Califpornia.Panels.omen, Califpornia.CFG.panels.block_width - Califpornia.CFG.panels.block_height - Califpornia.CFG.panels.spacer, Califpornia.CFG.panels.block_height, "BOTTOMLEFT", Califpornia.Panels.dataright, "TOPLEFT", 0, Califpornia.CFG.panels.spacer)
Califpornia.Lib.frameShadow(Califpornia.Panels.omen)
Califpornia.Panels.omen:SetFrameLevel(2)
Califpornia.Panels.omen:Hide()]]

--[[ Toggle panels button

local togglebutton = CreateFrame("Button", "CPTogglePanels", UIParent)
togglebutton:SetPoint("CENTER", Califpornia.Panels.datarightbtn, "CENTER", 0, 0)
togglebutton:SetHeight(16)
togglebutton:SetWidth(16)
togglebutton:SetAlpha(0.8)

local togglebuttontexture = togglebutton:CreateTexture(nil, "BORDER")
togglebuttontexture:SetPoint("CENTER")
togglebuttontexture:SetTexture("Interface\\BUTTONS\\UI-GuildButton-PublicNote-Up")
togglebuttontexture:SetHeight(14)
togglebuttontexture:SetWidth(14)

togglebutton:SetScript("OnMouseUp", function(self, btn)
	if (Califpornia.Panels.damage:IsShown()) then
		Califpornia.Panels.damage:Hide()
		Califpornia.Panels.omen:Show()
	else
		Califpornia.Panels.damage:Show()
		Califpornia.Panels.omen:Hide()
	end
end)



-- Catch up addon events for omen and recount
local eventFrame = CreateFrame("Frame")
local l_omen = false
local l_recount = false
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(self, event, addon)
	if addon == "Omen" then
		local omw = Omen.Anchor
		omw:SetParent(CPOmen)
		l_omen = true
	end
	if addon == "Recount" then
		local rmw = Recount.MainWindow
		rmw:SetParent(CPDamage)
		l_recount = true
	end
	if l_omen and l_recount then
		self:UnregisterEvent("ADDON_LOADED")
	end
end)
]]