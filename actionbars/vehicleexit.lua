if not CalifporniaCFG["actionbars"].enable then return end

local barcfg = CalifporniaCFG['actionbars'].vehicleexit
if barcfg.disable then return end


  local bar = CreateFrame("Frame","CalifporniaUI_VehicleExit",UIParent, "SecureHandlerStateTemplate")
  bar:SetHeight(barcfg.buttonsize)
  bar:SetWidth(barcfg.buttonsize)
  bar:SetPoint(barcfg.pos.a1,barcfg.pos.af,barcfg.pos.a2,barcfg.pos.x,barcfg.pos.y)
--  bar:SetHitRectInsets(-cfg.barinset, -cfg.barinset, -cfg.barinset, -cfg.barinset)
  
  bar:SetScale(barcfg.barscale)

  
  local veb = CreateFrame("BUTTON", nil, bar, "SecureActionButtonTemplate");
  veb:SetAllPoints(bar)
  veb:RegisterForClicks("AnyUp")
  veb:SetNormalTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Up")
  veb:SetPushedTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Down")
  veb:SetHighlightTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Down")
  veb:SetScript("OnClick", function(self) VehicleExit() end)
  veb:RegisterEvent("UNIT_ENTERING_VEHICLE")
  veb:RegisterEvent("UNIT_ENTERED_VEHICLE")
  veb:RegisterEvent("UNIT_EXITING_VEHICLE")
  veb:RegisterEvent("UNIT_EXITED_VEHICLE")
  veb:SetScript("OnEvent", function(self,event,...)
    local arg1 = ...;
    if(((event=="UNIT_ENTERING_VEHICLE") or (event=="UNIT_ENTERED_VEHICLE")) and arg1 == "player") then
      veb:SetAlpha(1)
    elseif(((event=="UNIT_EXITING_VEHICLE") or (event=="UNIT_EXITED_VEHICLE")) and arg1 == "player") then
      veb:SetAlpha(0)
    end
  end)  
  veb:SetAlpha(0)