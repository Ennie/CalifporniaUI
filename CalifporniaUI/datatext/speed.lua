--------------------------------------------------------------------
 -- UNIT SPEED
--------------------------------------------------------------------
if CalifporniaCFG["datatext"].speed and Califpornia.CFG["datatext"].speed > 0 then
	local Stat = CreateFrame("Frame")
	Stat:EnableMouse(false)
	Stat:SetFrameStrata("BACKGROUND")
	Stat:SetFrameLevel(3)

	local Text  =Califpornia.Panels.CreateDataText(Califpornia.CFG["datatext"].speed)

	local Stat = CreateFrame("Frame")
	Stat:SetScript("OnUpdate", function(self)
		local _, runSpeed, flightSpeed, swimSpeed = GetUnitSpeed("player")
		runSpeed = runSpeed/BASE_MOVEMENT_SPEED*100
		flightSpeed = flightSpeed/BASE_MOVEMENT_SPEED*100
		swimSpeed = swimSpeed/BASE_MOVEMENT_SPEED*100

		-- Determine whether to display running, flying, or swimming speed 
		local speed = runSpeed
		local swimming = IsSwimming("player")
		if (swimming) then
			speed = swimSpeed
		elseif (IsFlying("player")) then
			speed = flightSpeed
		end

		-- Hack so that your speed doesn't appear to change when jumping out of the water
		if (IsFalling(unit)) then
			if (Stat.wasSwimming) then
				speed = swimSpeed
			end
		else
			Stat.wasSwimming = swimming
		end
	
		Stat.speed = speed
		Stat.runSpeed = runSpeed
		Stat.flightSpeed = flightSpeed
		Stat.swimSpeed = swimSpeed

		Text:SetFormattedText(STAT_MOVEMENT_SPEED..": "..hexa.."%d%%"..hexb, speed+0.5)
		self:SetAllPoints(Text)
	end)
	Stat:SetScript("OnEnter", function(self)
		if not InCombatLockdown() then
			GameTooltip:SetOwner(Stat, "ANCHOR_TOP");
			GameTooltip:SetText(HIGHLIGHT_FONT_COLOR_CODE..format(PAPERDOLLFRAME_TOOLTIP_FORMAT, STAT_MOVEMENT_SPEED).." "..format("%d%%", Stat.speed+0.5)..FONT_COLOR_CODE_CLOSE);
	
			GameTooltip:AddLine(format(STAT_MOVEMENT_GROUND_TOOLTIP, Stat.runSpeed+0.5));
			GameTooltip:AddLine(format(STAT_MOVEMENT_SWIM_TOOLTIP, Stat.swimSpeed+0.5));
			GameTooltip:Show()
		end
	end)
	Stat:SetScript("OnLeave", function() GameTooltip:Hide() end)
end



-- new blizzard code, should use it instead
--[[
function MovementSpeed_OnEnter(statFrame)
	if (MOVING_STAT_CATEGORY) then return; end
	
	GameTooltip:SetOwner(statFrame, "ANCHOR_RIGHT");
	GameTooltip:SetText(HIGHLIGHT_FONT_COLOR_CODE..format(PAPERDOLLFRAME_TOOLTIP_FORMAT, STAT_MOVEMENT_SPEED).." "..format("%d%%", statFrame.speed+0.5)..FONT_COLOR_CODE_CLOSE);
	
	GameTooltip:AddLine(format(STAT_MOVEMENT_GROUND_TOOLTIP, statFrame.runSpeed+0.5));
	if (statFrame.unit ~= "pet") then
		GameTooltip:AddLine(format(STAT_MOVEMENT_FLIGHT_TOOLTIP, statFrame.flightSpeed+0.5));
	end
	GameTooltip:AddLine(format(STAT_MOVEMENT_SWIM_TOOLTIP, statFrame.swimSpeed+0.5));
	GameTooltip:Show();
	
	statFrame.UpdateTooltip = MovementSpeed_OnEnter;
end
 
]]