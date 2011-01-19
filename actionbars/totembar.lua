if not CalifporniaCFG["actionbars"].enable then return end

local barcfg = CalifporniaCFG['actionbars'].totembar
if (barcfg.disable or CalifporniaCFG.myclass ~= "SHAMAN" )then return end

    local bar = _G['MultiCastActionBarFrame']

    if bar then
  MultiCastFlyoutFrame.top:Hide()
  MultiCastFlyoutFrame.middle:Hide()

      local holder = CreateFrame("Frame","CalifporniaCFG_TotemBar",UIParent, "SecureHandlerStateTemplate")
	bar:SetHeight(barcfg.buttonsize)
      holder:SetWidth(bar:GetWidth())
      holder:SetHeight(bar:GetHeight())
            
      bar:SetParent(holder)
      bar:SetAllPoints(holder)
      
      local function moveTotem(self,a1,af,a2,x,y,...)
        if x ~= barcfg.pos.x then
          --print('doing')
          bar:SetAllPoints(holder)
        end
      end
            
      hooksecurefunc(bar, "SetPoint", moveTotem)  
      holder:SetPoint(barcfg.pos.a1,barcfg.pos.af,barcfg.pos.a2,barcfg.pos.x,barcfg.pos.y)  

      holder:SetScale(barcfg.barscale)
      
      bar:SetMovable(true)
      bar:SetUserPlaced(true)
      bar:EnableMouse(false)
	bar:SetScale(0.7)
    end
  