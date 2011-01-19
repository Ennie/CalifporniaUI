if not CalifporniaCFG["actionbars"].enable then return end

local barcfg = CalifporniaCFG['actionbars'].bar2


local bar = CreateFrame("Frame","CalifporniaUI_MultiBarBottomLeft",UIParent, "SecureHandlerStateTemplate")

	bar:SetWidth(barcfg.buttonsize*12+barcfg.buttonspacing*11)
	bar:SetHeight(barcfg.buttonsize)
	bar:SetPoint(barcfg.pos.a1,barcfg.pos.af,barcfg.pos.a2,barcfg.pos.x,barcfg.pos.y)
--	bar:SetHitRectInsets(-cfg.barinset, -cfg.barinset, -cfg.barinset, -cfg.barinset)
	
	bar:SetScale(barcfg.barscale)


	MultiBarBottomLeft:SetParent(bar)
	
	local Group = CalifporniaCFG.BF:Group('CalifporniaUI', 'MultiBarBottomLeft')
	Group:Skin('DsmFade', barcfg.gloss, barcfg.backdrop, {})
	for i=1, 12 do
		local button = _G["MultiBarBottomLeftButton"..i]
		button:SetSize(barcfg.buttonsize, barcfg.buttonsize)
		_G["MultiBarBottomLeftButton"..i.."HotKey"]:SetFont(CalifporniaCFG.media.abfont, barcfg.fontsize, "OUTLINE")
				local name = _G[button:GetName().."Name"]
				name:Hide()
				local count = _G[button:GetName().."Count"]
				count:SetFont(CalifporniaCFG.media.abfont, barcfg.fontsize, "OUTLINE")
		Group:AddButton(button)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", bar, 0,0)
		else
			local previous = _G["MultiBarBottomLeftButton"..i-1]			
			if barcfg.uselayout2x6 and i == 7 then
				previous = _G["MultiBarBottomLeftButton1"]
				button:SetPoint("BOTTOMLEFT", previous, "TOPLEFT", 0, barcfg.buttonspacing)
			else
				button:SetPoint("LEFT", previous, "RIGHT", barcfg.buttonspacing, 0)
			end
			
		end
	end
	
	if barcfg.showonmouseover then		
		local function lighton(alpha)
			if MultiBarBottomLeft:IsShown() then
				for i=1, 12 do
					local pb = _G["MultiBarBottomLeftButton"..i]
					pb:SetAlpha(alpha)
				end
			end
		end		
		bar:EnableMouse(true)
		bar:SetScript("OnEnter", function(self) lighton(1) end)
		bar:SetScript("OnLeave", function(self) lighton(0) end)	
		for i=1, 12 do
			local pb = _G["MultiBarBottomLeftButton"..i]
			pb:SetAlpha(0)
			pb:HookScript("OnEnter", function(self) lighton(1) end)
			pb:HookScript("OnLeave", function(self) lighton(0) end)
		end		
	end