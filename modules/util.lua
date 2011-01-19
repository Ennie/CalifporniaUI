CalifporniaCFG.util = { }

local function scale(x)
    return 1*math.floor(x/1+.5)
end

-- Create frame shadow
CalifporniaCFG.util.frameShadow = function(f)
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

-- Create frame inner border
CalifporniaCFG.util.innerBorder = function(f)
	if f.iborder then return end
	f.iborder = CreateFrame("Frame", nil, f)
	f.iborder:SetPoint("TOPLEFT", 1, -1)
	f.iborder:SetPoint("BOTTOMRIGHT", -1, 1)
	f.iborder:SetFrameLevel(f:GetFrameLevel())
	f.iborder:SetBackdrop({
		edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1,
		insets = { left = -1, right = -1, top = -1, bottom = -1}
	})
	f.iborder:SetBackdropBorderColor(0, 0, 0)
	return f.iborder
end

-- Create frame outer border
CalifporniaCFG.util.outerBorder = function(f)
	if f.oborder then return end
	f.oborder = CreateFrame("Frame", nil, f)
	f.oborder:SetPoint("TOPLEFT", -1, 1)
	f.oborder:SetPoint("BOTTOMRIGHT", 1, -1)
	f.oborder:SetFrameLevel(f:GetFrameLevel())
	f.oborder:SetBackdrop({
		edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1, 
		insets = { left = -1, right = -1, top = -1, bottom = -1}
	})
	f.oborder:SetBackdropBorderColor(0, 0, 0)
	return f.oborder
end

-- Create frame backdrop (ex-qBD by Qulight)
CalifporniaCFG.util.cBackDrop = function(f)
	f:SetBackdrop({
		bgFile =  bgtexture,
	  edgeFile = glowTex, edgeSize = 1, 
		insets = {left = 1, right = 1, top = 1, bottom = 1} 
	})
	f:SetBackdropColor(unpack(CalifporniaCFG.colors.class_backdrop))
	f:SetBackdropBorderColor(unpack(CalifporniaCFG.colors.class_backdrop_border))
	CalifporniaCFG.util.outerBorder(f)
	CalifporniaCFG.util.innerBorder(f)
end
-- Create frame with 1px border
CalifporniaCFG.util.frame1px = function(f)
	f:SetBackdrop({
		bgFile =  [=[Interface\ChatFrame\ChatFrameBackground]=],
        edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1, 
		insets = {left = -1, right = -1, top = -1, bottom = -1} 
	})
	f:SetBackdropColor(unpack(CalifporniaCFG.colors.class_backdrop))
	f:SetBackdropBorderColor(unpack(CalifporniaCFG.colors.class_backdrop_border))
	CalifporniaCFG.util.outerBorder(f)
	CalifporniaCFG.util.innerBorder(f)
end
-- CreatePanel
CalifporniaCFG.util.CreatePanel = function(f, w, h, a1, p, a2, x, y)
	local r, g, b =CalifporniaCFG.colors.class_color.r, CalifporniaCFG.colors.class_color.g, CalifporniaCFG.colors.class_color.b
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
	f:SetBackdropColor(unpack(CalifporniaCFG.colors.class_backdrop))
	f:SetBackdropBorderColor(unpack(CalifporniaCFG.colors.class_backdrop_border))
	
	CalifporniaCFG.util.outerBorder(f)
	CalifporniaCFG.util.innerBorder(f)
end

Califpornia.Lib = CalifporniaCFG.util