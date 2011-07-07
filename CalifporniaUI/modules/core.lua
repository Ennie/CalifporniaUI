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
Califpornia.SkinUITab = function(f)
	local sd = CreateFrame("Frame", nil, f)
	sd:SetBackdrop({
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		edgeFile = CalifporniaCFG.media.glowTex,
		edgeSize = 5,
		insets = { left = 5, right = 5, top = 5, bottom = 5 },
	})
	sd:SetPoint("TOPLEFT", 6, -2)
	sd:SetPoint("BOTTOMRIGHT", -6, 0)
	sd:SetBackdropColor(0, 0, 0, .5)
	sd:SetBackdropBorderColor(0, 0, 0)
	sd:SetFrameStrata("LOW")
end
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
Califpornia.CreateBD = function(f)
	f:SetBackdrop({
		bgFile =  "Interface\\ChatFrame\\ChatFrameBackground",
		edgeFile = "Interface\\Buttons\\WHITE8x8",
		edgeSize = 1, 
		insets = {left = -1, right = -1, top = -1, bottom = -1} 
	})
	f:SetBackdropColor(unpack(Califpornia.colors.m_backdrop))
	f:SetBackdropBorderColor(unpack(Califpornia.colors.m_border))
	CreateOuterBorder(f)
	CreateInnerBorder(f)
end

-- Create backdrop
Califpornia.CreateBD1px = function(f)
	f:SetBackdrop({
		bgFile =  "Interface\\ChatFrame\\ChatFrameBackground",
		edgeFile = "Interface\\Buttons\\WHITE8x8",
		edgeSize = 1, 
		insets = {left = 1, right = 1, top = 1, bottom = 1} 
	})
	f:SetBackdropColor(unpack(Califpornia.colors.m_backdrop))
	f:SetBackdropBorderColor(unpack(Califpornia.colors.m_border))
--	CreateOuterBorder(f)
--	CreateInnerBorder(f)
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

-- Public function
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


AnchorFrames = {
}

local t_unlock = false

function AnchorsUnlock()
	print("UI: all frames unlocked")
	for _, v in pairs(AnchorFrames) do
		f = _G[v]
		if f and f:IsUserPlaced() then
			f.dragtexture:SetAlpha(0.7)
			f.text:SetAlpha(1)
			f:EnableMouse(true)
			f:RegisterForDrag("LeftButton")
		end
	end
end

function AnchorsLock()
	print("UI: all frames locked")
	for _, v in pairs(AnchorFrames) do
		f = _G[v]
		if f and f:IsUserPlaced() then
			f.dragtexture:SetAlpha(0)
			f.text:SetAlpha(0)
			f:EnableMouse(nil)
			f:RegisterForDrag(nil)
		end
	end
end

function AnchorsReset()
	for _, v in pairs(AnchorFrames) do
		f = _G[v]
		if f and f:IsUserPlaced() then
			f:SetUserPlaced(false)
		end
	end
	ReloadUI()
end

local function SlashCmd(cmd)
	if (cmd:match"reset") then
		AnchorsReset()
	else
		if t_unlock == false then
			t_unlock = true
			AnchorsUnlock()
		elseif t_unlock == true then
			t_unlock = false
			AnchorsLock()
		end
	end
end

SlashCmdList["ui"] = SlashCmd;
SLASH_ui1 = "/ui";

function CreateAnchor(f, text, width, height)
	f:SetScale(1)
	f:SetFrameStrata("TOOLTIP")
	f:SetScript("OnDragStart", function(s) s:StartMoving() end)
	f:SetScript("OnDragStop", function(s) s:StopMovingOrSizing() end)
	f:SetWidth(width)
	f:SetHeight(height)
	
	local t = f:CreateTexture(nil,"OVERLAY",nil,6)
	t:SetAllPoints(f)
	t:SetTexture(0,0.6,0.6)
	t:SetAlpha(0)
	f.dragtexture = t
	
	--f:SetClampedToScreen(true)
	f:SetMovable(true)
	f:SetUserPlaced(true)
	f.dragtexture:SetAlpha(0)
	f:EnableMouse(nil)
	f:RegisterForDrag(nil)
	f:SetScript("OnEnter", nil)
	f:SetScript("OnLeave", nil)

	f.text = f:CreateFontString(nil, "OVERLAY")
	f.text:SetFont(CalifporniaCFG.media.font, 10)
	f.text:SetJustifyH("LEFT")
	f.text:SetShadowColor(0, 0, 0)
	f.text:SetShadowOffset(1, -1)
	f.text:SetAlpha(0)
	f.text:SetPoint("CENTER")
	f.text:SetText(text)

	tinsert(AnchorFrames, f:GetName())
end



local addonName = select(1, GetAddOnInfo('CalifporniaUI'))
local formatName = '|cffFF0000'..addonName

local textureNormal = "Interface\\AddOns\\CalifporniaUI\\media\\textures\\bcNormal"
local textureShadow = "Interface\\AddOns\\CalifporniaUI\\media\\textures\\bcShadow"

function bcCreateBorder(self, borderSize, R, G, B, uL1, ...)
    if (not self) then
        print(formatName..' error:|r This frame does not exist!') 
        return
    end
    
    if (not self:IsObjectType('Frame')) then
        local frame  = 'frame'
        print(formatName..' error:|r The entered object is not a '..frame..'!') 
        return
    end
    
    local uL2, uR1, uR2, bL1, bL2, bR1, bR2 = ...
    if (uL1) then
        if (not uL2 and not uR1 and not uR2 and not bL1 and not bL2 and not bR1 and not bR2) then
            uL2, uR1, uR2, bL1, bL2, bR1, bR2 = uL1, uL1, uL1, uL1, uL1, uL1, uL1
        end
    end

    if (not self.HasBorder) then
        self.Border = {}
        for i = 1, 8 do
            self.Border[i] = self:CreateTexture(nil, 'OVERLAY')
            self.Border[i]:SetParent(self)
            self.Border[i]:SetTexture(textureNormal)
            self.Border[i]:SetSize(borderSize, borderSize) 
            self.Border[i]:SetVertexColor(R or 1, G or 1, B or 1)
        end
        
        self.Border[1]:SetTexCoord(0, 1/3, 0, 1/3) 
        self.Border[1]:SetPoint('TOPLEFT', self, -(uL1 or 0), uL2 or 0)

        self.Border[2]:SetTexCoord(2/3, 1, 0, 1/3)
        self.Border[2]:SetPoint('TOPRIGHT', self, uR1 or 0, uR2 or 0)

        self.Border[3]:SetTexCoord(0, 1/3, 2/3, 1)
        self.Border[3]:SetPoint('BOTTOMLEFT', self, -(bL1 or 0), -(bL2 or 0))

        self.Border[4]:SetTexCoord(2/3, 1, 2/3, 1)
        self.Border[4]:SetPoint('BOTTOMRIGHT', self, bR1 or 0, -(bR2 or 0))

        self.Border[5]:SetTexCoord(1/3, 2/3, 0, 1/3)
        self.Border[5]:SetPoint('TOPLEFT', self.Border[1], 'TOPRIGHT')
        self.Border[5]:SetPoint('TOPRIGHT', self.Border[2], 'TOPLEFT')

        self.Border[6]:SetTexCoord(1/3, 2/3, 2/3, 1)
        self.Border[6]:SetPoint('BOTTOMLEFT', self.Border[3], 'BOTTOMRIGHT')
        self.Border[6]:SetPoint('BOTTOMRIGHT', self.Border[4], 'BOTTOMLEFT')

        self.Border[7]:SetTexCoord(0, 1/3, 1/3, 2/3)
        self.Border[7]:SetPoint('TOPLEFT', self.Border[1], 'BOTTOMLEFT')
        self.Border[7]:SetPoint('BOTTOMLEFT', self.Border[3], 'TOPLEFT')

        self.Border[8]:SetTexCoord(2/3, 1, 1/3, 2/3)
        self.Border[8]:SetPoint('TOPRIGHT', self.Border[2], 'BOTTOMRIGHT')
        self.Border[8]:SetPoint('BOTTOMRIGHT', self.Border[4], 'TOPRIGHT')
        
        local space
        if (borderSize >= 10) then
            space = 3
        else
            space = borderSize/3.5
        end
        
        self.Shadow = {}
        for i = 1, 8 do
            self.Shadow[i] = self:CreateTexture(nil, 'BORDER')
            self.Shadow[i]:SetParent(self)
            self.Shadow[i]:SetTexture(textureShadow)
            self.Shadow[i]:SetSize(borderSize, borderSize)  
            self.Shadow[i]:SetVertexColor(0, 0, 0, 1)
        end
        
        self.Shadow[1]:SetTexCoord(0, 1/3, 0, 1/3) 
        self.Shadow[1]:SetPoint('TOPLEFT', self, -(uL1 or 0)-space, (uL2 or 0)+space)

        self.Shadow[2]:SetTexCoord(2/3, 1, 0, 1/3)
        self.Shadow[2]:SetPoint('TOPRIGHT', self, (uR1 or 0)+space, (uR2 or 0)+space)

        self.Shadow[3]:SetTexCoord(0, 1/3, 2/3, 1)
        self.Shadow[3]:SetPoint('BOTTOMLEFT', self, -(bL1 or 0)-space, -(bL2 or 0)-space)

        self.Shadow[4]:SetTexCoord(2/3, 1, 2/3, 1)
        self.Shadow[4]:SetPoint('BOTTOMRIGHT', self, (bR1 or 0)+space, -(bR2 or 0)-space)

        self.Shadow[5]:SetTexCoord(1/3, 2/3, 0, 1/3)
        self.Shadow[5]:SetPoint('TOPLEFT', self.Shadow[1], 'TOPRIGHT')
        self.Shadow[5]:SetPoint('TOPRIGHT', self.Shadow[2], 'TOPLEFT')

        self.Shadow[6]:SetTexCoord(1/3, 2/3, 2/3, 1)
        self.Shadow[6]:SetPoint('BOTTOMLEFT', self.Shadow[3], 'BOTTOMRIGHT')
        self.Shadow[6]:SetPoint('BOTTOMRIGHT', self.Shadow[4], 'BOTTOMLEFT')

        self.Shadow[7]:SetTexCoord(0, 1/3, 1/3, 2/3)
        self.Shadow[7]:SetPoint('TOPLEFT', self.Shadow[1], 'BOTTOMLEFT')
        self.Shadow[7]:SetPoint('BOTTOMLEFT', self.Shadow[3], 'TOPLEFT')

        self.Shadow[8]:SetTexCoord(2/3, 1, 1/3, 2/3)
        self.Shadow[8]:SetPoint('TOPRIGHT', self.Shadow[2], 'BOTTOMRIGHT')
        self.Shadow[8]:SetPoint('BOTTOMRIGHT', self.Shadow[4], 'TOPRIGHT')
        
        self.HasBorder = true
    end
end

function bcColorBorder(self, ...)
    local r, g, b, a = ...
    if (not self) then
        print(formatName..' error:|r This frame does not exist!') 
    elseif (self.Border) then
        for i = 1, 8 do
            self.Border[i]:SetVertexColor(r, g, b, a or 1)
        end
    else
        print(formatName..' error:|r Invalid frame! This object has no '..addonName..' border')  
    end
end

function bcColorBorderShadow(self, ...)
    local r, g, b, a = ...
    if (not self) then
        print(formatName..' error:|r This frame does not exist!') 
    elseif (self.Shadow) then
        for i = 1, 8 do
            self.Shadow[i]:SetVertexColor(r, g, b, a or 1)
        end
    else
        print(formatName..' error:|r Invalid frame! This object has no '..addonName..' border')  
    end
end

function bcSetBorderTexture(self, texture)
    if (not self) then
        print(formatName..' error:|r This frame does not exist!') 
    elseif (self.Border) then
        for i = 1, 8 do
            self.Border[i]:SetTexture(texture)
        end
    else
        print(formatName..' error:|r Invalid frame! This object has no '..addonName..' border')  
    end
end

function bcSetBorderShadowTexture(self, texture)
    if (not self) then
        print(formatName..' error:|r This frame does not exist!') 
    elseif (self.Shadow) then
        for i = 1, 8 do
            self.Shadow[i]:SetTexture(texture)
        end
    else
        print(formatName..' error:|r Invalid frame! This object has no '..addonName..' border')  
    end
end

function bcGetBorderInfo(self)
    if (not self) then
        print(formatName..' error:|r This frame does not exist!') 
    elseif (self.Border) then
        local tex = self.Border[1]:GetTexture()
        local size = self.Border[1]:GetSize()
        local r, g, b, a = self.Border[1]:GetVertexColor()
        
        return size, tex, r, g, b, a
    else
        print(formatName..' error:|r Invalid frame! This object has no '..addonName..' border')   
    end
end
