-- Core functions

Califpornia.dummy = function() return end

Califpornia.kill = function(object)
	local objectReference = object
	if type(object) == "string" then
		objectReference = _G[object]
	else
		objectReference = object
	end
	if not objectReference then return end
	if type(objectReference) == "frame" then
		objectReference:UnregisterAllEvents()
	end
	objectReference.Show = Califpornia.dummy
	objectReference:Hide()
end

-- Style functions
-- Create frame shadow
Califpornia.CreateShadow = function(f)
	if f.frameBD then return end
	local frameBD = CreateFrame("Frame", nil, f)
	frameBD = CreateFrame("Frame", nil, f)
	frameBD:SetFrameLevel(1)
	frameBD:SetFrameStrata(f:GetFrameStrata())
	frameBD:SetPoint("TOPLEFT", -4, 4)
	frameBD:SetPoint("BOTTOMLEFT", -4, -4)
	frameBD:SetPoint("TOPRIGHT", 4, 4)
	frameBD:SetPoint("BOTTOMRIGHT", 4, -4)
	frameBD:SetBackdrop( { 
		edgeFile = CalifporniaCFG.media.glowTex, edgeSize = 4,
		insets = {left = 3, right = 3, top = 3, bottom = 3},
		tile = false, tileSize = 0,
	})
	
	frameBD:SetBackdropColor(0, 0, 0, 0)
	frameBD:SetBackdropBorderColor(0, 0, 0, 1)
	f.frameBD = frameBD
end
-- Create inner border
local function CreateInnerBorder(f)
	if f.iborder then return end
	f.iborder = CreateFrame("Frame", nil, f)
	f.iborder:SetPoint("TOPLEFT", 1, -1)
	f.iborder:SetPoint("BOTTOMRIGHT", -1, 1)
	f.iborder:SetFrameLevel(f:GetFrameLevel())
	f.iborder:SetBackdrop({
		edgeFile = "Interface\\Buttons\\WHITE8x8",
		edgeSize = 1,
		insets = { left = -1, right = -1, top = -1, bottom = -1}
	})
	f.iborder:SetBackdropBorderColor(0, 0, 0)
	return f.iborder
end
-- Create outer border
local function CreateOuterBorder(f)
	if f.oborder then return end
	f.oborder = CreateFrame("Frame", nil, f)
	f.oborder:SetPoint("TOPLEFT", -1, 1)
	f.oborder:SetPoint("BOTTOMRIGHT", 1, -1)
	f.oborder:SetFrameLevel(f:GetFrameLevel())
	f.oborder:SetBackdrop({
		edgeFile = "Interface\\Buttons\\WHITE8x8",
		edgeSize = 1, 
		insets = { left = -1, right = -1, top = -1, bottom = -1}
	})
	f.oborder:SetBackdropBorderColor(0, 0, 0)
	return f.oborder
end
-- Create backdrop
Califpornia.CreateBD = function(f,noalpha)
	f:SetBackdrop({
		bgFile =  "Interface\\ChatFrame\\ChatFrameBackground",
		edgeFile = "Interface\\Buttons\\WHITE8x8",
		edgeSize = 1, 
		insets = {left = 1, right = 1, top = 1, bottom = 1} 
	})
	if noalpha then
		f:SetBackdropColor(unpack(Califpornia.colors.m_backdrop_noalpha))
	else
		f:SetBackdropColor(unpack(Califpornia.colors.m_backdrop))
	end
	f:SetBackdropBorderColor(unpack(Califpornia.colors.m_border))
	CreateOuterBorder(f)
	CreateInnerBorder(f)
end

-- Skin button
local function SkinButtonHover(self)
	self:SetBackdropColor(Califpornia.colors.m_color.r, Califpornia.colors.m_color.g, Califpornia.colors.m_color.b, 0.15)
	self:SetBackdropBorderColor(Califpornia.colors.m_color.r, Califpornia.colors.m_color.g, Califpornia.colors.m_color.b)
end
local function SkinButtonNormal(self)
	self:SetBackdropColor(unpack(Califpornia.colors.m_backdrop))
	self:SetBackdropBorderColor(unpack(Califpornia.colors.m_border))
end
Califpornia.SkinUIButton = function(f)
	f:SetNormalTexture("")
	f:SetHighlightTexture("")
	f:SetPushedTexture("")
	f:SetDisabledTexture("")
	Califpornia.CreateBD(f)
	if _G[f:GetName().."Left"] then _G[f:GetName().."Left"]:SetAlpha(0) end
	if _G[f:GetName().."Middle"] then _G[f:GetName().."Middle"]:SetAlpha(0) end
	if _G[f:GetName().."Right"] then _G[f:GetName().."Right"]:SetAlpha(0) end
	f:HookScript("OnEnter", SkinButtonHover)
	f:HookScript("OnLeave", SkinButtonNormal)
end

-- Skin UI tab
Califpornia.SkinUITab = function(f)
	f:SetNormalTexture("")
	f:SetHighlightTexture("")
	f:SetPushedTexture("")
	f:SetDisabledTexture("")

	local sd = CreateFrame("Frame", nil, f)
	sd:SetBackdrop({
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		edgeFile = CalifporniaCFG.media.glowTex,
		edgeSize = 5,
		insets = { left = 5, right = 5, top = 5, bottom = 5 },
	})
	sd:SetPoint("TOPLEFT", 6, 0)
	sd:SetPoint("BOTTOMRIGHT", -6, 0)
	sd:SetBackdropColor(0, 0, 0, .5)
	sd:SetBackdropBorderColor(0, 0, 0)
	sd:SetFrameStrata("LOW")
	sd:SetBackdropColor(unpack(Califpornia.colors.m_backdrop))
--	sd:SetBackdropBorderColor(unpack(Califpornia.colors.m_border))
--	CreateOuterBorder(sd)
end



-- Set datatext colors -- credits to Hydra
hexa, hexb = "|cffFFFFFF", "|r";
if Califpornia.CFG["datatext"].classcolor then
	hexa = string.format("|c%02x%02x%02x%02x", 255, Califpornia.colors.m_color.r * 255, Califpornia.colors.m_color.g * 255, Califpornia.colors.m_color.b * 255) -- Syne <3
end

function SVal(val)
	if val then
		if (val >= 1e6) then
			return ("%.1fm"):format(val / 1e6)
		elseif (val >= 1e3) then
			return ("%.1fk"):format(val / 1e3)
		else
			return ("%d"):format(val)
		end
	end
end
