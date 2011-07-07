if CalifporniaCFG["datatext"].stats and Califpornia.CFG["datatext"].hpsdps > 0 then
	local dps_events = {SWING_DAMAGE = true, RANGE_DAMAGE = true, SPELL_DAMAGE = true, SPELL_PERIODIC_DAMAGE = true, DAMAGE_SHIELD = true, DAMAGE_SPLIT = true, SPELL_EXTRA_ATTACKS = true}
	local hps_events = {SPELL_HEAL = true, SPELL_PERIODIC_HEAL = true}
	local Text  =Califpornia.Panels.CreateDataText(Califpornia.CFG["datatext"].hpsdps)

	local DHPS_FEED = CreateFrame("Frame")
	local player_id = UnitGUID("player")
	local pet_id = UnitGUID("pet")
	local dmg_total, last_dmg_amount, amount_healed, amount_over_healed, actual_heals_total, cmbt_time = 0, 0, 0, 0, 0, 0
 
	local show_dps = true -- false - show hps instead. TODO: detect spec 

	DHPS_FEED:EnableMouse(true)
	DHPS_FEED:SetFrameStrata("BACKGROUND")
	DHPS_FEED:SetFrameLevel(3)
	DHPS_FEED:SetHeight(20)
	DHPS_FEED:SetWidth(100)
	DHPS_FEED:SetAllPoints(Text)

	DHPS_FEED:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
	DHPS_FEED:RegisterEvent("PLAYER_LOGIN")

	DHPS_FEED:SetScript("OnUpdate", function(self, elap)
		if UnitAffectingCombat("player") then
			DHPS_FEED:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			cmbt_time = cmbt_time + elap
		else
			DHPS_FEED:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		end
		if show_dps then
			Text:SetText(getDPS())
		else
			Text:SetText(getHPS())
		end
	end)

	function DHPS_FEED:PLAYER_LOGIN()
		DHPS_FEED:RegisterEvent("PLAYER_REGEN_ENABLED")
		DHPS_FEED:RegisterEvent("PLAYER_REGEN_DISABLED")
		DHPS_FEED:RegisterEvent("UNIT_PET")
 
		player_id = UnitGUID("player")
     
		DHPS_FEED:UnregisterEvent("PLAYER_LOGIN")
	end

	-- handler for the combat log. used http://www.wowwiki.com/API_COMBAT_LOG_EVENT for api
	function DHPS_FEED:COMBAT_LOG_EVENT_UNFILTERED(...)         
		if event == "PLAYER_REGEN_DISABLED" then return end
		-- filter for events we only care about. i.e heals
		if hps_events[select(2, ...)] then
			-- only use events from the player
			local id = select(3, ...)
			if id == player_id then
				amount_healed = select(12, ...)
				amount_over_healed = select(13, ...)
				-- add to the total the healed amount subtracting the overhealed amount
				actual_heals_total = actual_heals_total + math.max(0, amount_healed - amount_over_healed)
			end
		elseif dps_events[select(2, ...)] then
			local id = select(3, ...)
			if id == player_id or id == pet_id then
				if select(2, ...) == "SWING_DAMAGE" then
					last_dmg_amount = select(9, ...)
				else
					last_dmg_amount = select(12, ...)
				end
				dmg_total = dmg_total + last_dmg_amount
			end       
		end
	end
 
	function DHPS_FEED:UNIT_PET(unit)
		if unit == "player" then
			pet_id = UnitGUID("pet")
		end
	end
	function DHPS_FEED:PLAYER_REGEN_ENABLED()
		if show_dps then
			Text:SetText(getDPS())
		else
			Text:SetText(getHPS())
		end
	end
   
	function DHPS_FEED:PLAYER_REGEN_DISABLED()
		cmbt_time = 0
		dmg_total = 0
		last_dmg_amount = 0
		actual_heals_total = 0
	end
     
	DHPS_FEED:SetScript("OnMouseDown", function (self, button, down)
		cmbt_time = 0
		dmg_total = 0
		last_dmg_amount = 0
		actual_heals_total = 0
	end)
 
	function getDPS()
		if (dmg_total == 0) then
			return ("0.0 "..hexa..'DPS'..hexb)
		else
			return string.format("%.1f " ..'DPS', (dmg_total or 0) / (cmbt_time or 1))
		end
	end
	function getHps()
		if (actual_heals_total == 0) then
			return ("0.0 "..hexa..'HPS'..hexb)
		else
			return string.format("%.1f " .. 'HPS', (actual_heals_total or 0) / (cmbt_time or 1))
		end
	end
end