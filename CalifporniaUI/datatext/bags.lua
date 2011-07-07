--------------------------------------------------------------------
 -- BAGS
--------------------------------------------------------------------

if CalifporniaCFG["datatext"].bags and Califpornia.CFG["datatext"].bags > 0 then
	local Stat = CreateFrame("Frame")
	Stat:EnableMouse(true)
	Stat:SetFrameStrata("BACKGROUND")
	Stat:SetFrameLevel(3)

	local Text  =Califpornia.Panels.CreateDataText(Califpornia.CFG["datatext"].bags)

	local function OnEvent(self, event, ...)
		local free, total, used = 0, 0, 0
		for i = 0, NUM_BAG_SLOTS do
			free, total = free + GetContainerNumFreeSlots(i), total + GetContainerNumSlots(i)
		end
		used = total - free
		Text:SetText(BAGSLOT..": "..hexa..free..hexb)
		Stat:SetAllPoints(Text)
		Stat:SetScript("OnEnter", function()
		if not InCombatLockdown() then
			GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 6);
			GameTooltip:ClearAllPoints()
			GameTooltip:SetPoint("BOTTOM", self, "TOP", 0, 1)
			GameTooltip:ClearLines()
			GameTooltip:AddDoubleLine("Bags")
			GameTooltip:AddLine(" ")
			GameTooltip:AddDoubleLine("Total:",total,0, 0.6, 1, 1, 1, 1)
			GameTooltip:AddDoubleLine("Used:",used,0, 0.6, 1, 1, 1, 1)
		end
		GameTooltip:Show()
	end)
	Stat:SetScript("OnLeave", function() GameTooltip:Hide() end)
	end
          
	Stat:RegisterEvent("PLAYER_LOGIN")
	Stat:RegisterEvent("BAG_UPDATE")
	Stat:SetScript("OnEvent", OnEvent)
	Stat:SetScript("OnMouseDown", function() OpenAllBags() end)
end
