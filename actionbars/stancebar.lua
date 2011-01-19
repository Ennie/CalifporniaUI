if not CalifporniaCFG["actionbars"].enable then return end
local barcfg = CalifporniaCFG['actionbars'].stancebar
  
if barcfg.disable then return end

	local num = NUM_SHAPESHIFT_SLOTS
	
	local bar = CreateFrame("Frame","CalifporniaUI_StanceBar",UIParent, "SecureHandlerStateTemplate")
	bar:SetWidth(barcfg.buttonsize*num+barcfg.buttonspacing*(num-1))
	bar:SetHeight(barcfg.buttonsize)
	bar:SetPoint(barcfg.pos.a1,barcfg.pos.af,barcfg.pos.a2,barcfg.pos.x,barcfg.pos.y)
--	bar:SetHitRectInsets(-cfg.barinset, -cfg.barinset, -cfg.barinset, -cfg.barinset)
	
	bar:SetScale(barcfg.barscale)


	ShapeshiftBarFrame:SetParent(bar)
	ShapeshiftBarFrame:EnableMouse(false)
	
	local Group = CalifporniaCFG.BF:Group('CalifporniaUI', 'StanceBar')
	Group:Skin('DsmFade', barcfg.gloss, barcfg.backdrop, {})
for i=1, num do
	local button = _G["ShapeshiftButton"..i]
	button:SetSize(barcfg.buttonsize, barcfg.buttonsize)
	button:ClearAllPoints()
	_G["ShapeshiftButton"..i.."HotKey"]:SetFont(CalifporniaCFG.media.abfont, barcfg.fontsize, "OUTLINE")
	Group:AddButton(button)
	if i == 1 then
		button:SetPoint("BOTTOMLEFT", bar, 0,0)
	else
		local previous = _G["ShapeshiftButton"..i-1]	
		button:SetPoint("LEFT", previous, "RIGHT", barcfg.buttonspacing, 0)
	end
	end
	
	local function CalifporniaUI_MoveShapeshift()
	ShapeshiftButton1:SetPoint("BOTTOMLEFT", bar, 0,0)
	end
	hooksecurefunc("ShapeshiftBar_Update", CalifporniaUI_MoveShapeshift);
	
	
	if barcfg.showonmouseover then	
	local function lighton(alpha)
		if ShapeshiftBarFrame:IsShown() then
		for i=1, num do
			local pb = _G["ShapeshiftButton"..i]
			pb:SetAlpha(alpha)
		end
		end
	end	
	bar:EnableMouse(true)
	bar:SetScript("OnEnter", function(self) lighton(1) end)
	bar:SetScript("OnLeave", function(self) lighton(0) end)
	for i=1, num do
		local pb = _G["ShapeshiftButton"..i]
		pb:SetAlpha(0)
		pb:HookScript("OnEnter", function(self) lighton(1) end)
		pb:HookScript("OnLeave", function(self) lighton(0) end)
	end	
	end