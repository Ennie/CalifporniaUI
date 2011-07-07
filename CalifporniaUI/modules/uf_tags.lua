if not CalifporniaCFG["unitframes"].enable == true then return end

local function hex(r, g, b)
	if r then
		if (type(r) == 'table') then
			if(r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
		end
		return ('|cff%02x%02x%02x'):format(r * 255, g * 255, b * 255)
	end
end

------------------------------------------------------------------------
--	Tags
------------------------------------------------------------------------
-- health
oUF.Tags['cpuf:hp']  = function(u) 
	if UnitIsDead(u) or UnitIsGhost(u) or not UnitIsConnected(u) then
		return oUF.Tags['cpuf:DDG'](u)
	else
		local per = oUF.Tags['perhp'](u).."%" or 0
		local min, max = UnitHealth(u), UnitHealthMax(u)
		if min~=max then 
			return SVal(min)
		else
			return SVal(max)
		end
	  end
end
oUF.TagEvents['cpuf:hp'] = 'UNIT_HEALTH'
oUF.Tags['cpuf:hpper']  = function(u) 
	if UnitIsDead(u) or UnitIsGhost(u) or not UnitIsConnected(u) then
		return oUF.Tags['cpuf:DDG'](u)
	else
		local per = oUF.Tags['perhp'](u).."%" or 0
		return per
	  end
end
oUF.TagEvents['cpuf:hpper'] = 'UNIT_HEALTH'


-- power
oUF.Tags['cpuf:power']  = function(u) 
	local min, max = UnitPower(u), UnitPowerMax(u)
	if min~=max then 
		return SVal(min)
	else
		return SVal(max)
	end
end
oUF.TagEvents['cpuf:power'] = 'UNIT_POWER UNIT_MAXPOWER'

-- raid health
oUF.Tags['cpuf:raidhp']  = function(u) 
	if UnitIsDead(u) or UnitIsGhost(u) or not UnitIsConnected(u) then
		return oUF.Tags['cpuf:DDG'](u)
	else
		local per = oUF.Tags['perhp'](u).."%" or 0
		return per
	end
end
oUF.TagEvents['cpuf:raidhp'] = 'UNIT_HEALTH'

-- color
oUF.Tags['cpuf:color'] = function(u, r)
	local _, class = UnitClass(u)
	local reaction = UnitReaction(u, "player")

	if UnitIsDead(u) or UnitIsGhost(u) or not UnitIsConnected(u) then
		return "|cffA0A0A0"
	elseif (UnitIsTapped(u) and not UnitIsTappedByPlayer(u)) then
		return hex(oUF.colors.tapped)
	elseif (u == "pet") and GetPetHappiness() then
		return hex(oUF.colors.happiness[GetPetHappiness()])
	elseif (UnitIsPlayer(u)) then
		return hex(oUF.colors.class[class])
	elseif reaction then
		return hex(oUF.colors.reaction[reaction])
	else
		return hex(1, 1, 1)
	end
end
oUF.TagEvents['cpuf:color'] = 'UNIT_REACTION UNIT_HEALTH UNIT_HAPPINESS'

-- AFK/DND
oUF.Tags["cpuf:afkdnd"] = function(unit) 
	return UnitIsAFK(unit) and "|cffCFCFCF <afk>|r" or UnitIsDND(unit) and "|cffCFCFCF <dnd>|r" or ""
end
oUF.TagEvents["cpuf:afkdnd"] = "PLAYER_FLAGS_CHANGED"

-- dead/ghost/disconnected
oUF.Tags['cpuf:DDG'] = function(u)
	if UnitIsDead(u) then
		return "|cffCFCFCF Dead|r"
	elseif UnitIsGhost(u) then
		return "|cffCFCFCF Ghost|r"
	elseif not UnitIsConnected(u) then
		return "|cffCFCFCF D/C|r"
	end
end
oUF.TagEvents['cpuf:DDG'] = 'UNIT_HEALTH'

-- lvl
oUF.Tags["cpuf:level"] = function(unit)
	local c = UnitClassification(unit)
	local l = UnitLevel(unit)
	local d = GetQuestDifficultyColor(l)
	local str = l

	if l <= 0 then l = "??" end
	if c == "worldboss" then
		str = string.format("|cff%02x%02x%02xBoss|r",250,20,0)
	elseif c == "eliterare" then
		str = string.format("|cff%02x%02x%02x%s|r|cff0080FFR|r+",d.r*255,d.g*255,d.b*255,l)
	elseif c == "elite" then
		str = string.format("|cff%02x%02x%02x%s|r+",d.r*255,d.g*255,d.b*255,l)
	elseif c == "rare" then
		str = string.format("|cff%02x%02x%02x%s|r|cff0080FFR|r",d.r*255,d.g*255,d.b*255,l)
	else
		if not UnitIsConnected(unit) then
			str = "??"
		else
			if UnitIsPlayer(unit) then
				str = string.format("|cff%02x%02x%02x%s",d.r*255,d.g*255,d.b*255,l)
			elseif UnitPlayerControlled(unit) then
				str = string.format("|cff%02x%02x%02x%s",d.r*255,d.g*255,d.b*255,l)
			else
				str = string.format("|cff%02x%02x%02x%s",d.r*255,d.g*255,d.b*255,l)
			end
		end		
	end
	return str
end
oUF.TagEvents["cpuf:level"] = "UNIT_LEVEL PLAYER_LEVEL_UP UNIT_CLASSIFICATION_CHANGED"

-- druid mana
oUF.Tags['cpuf:druidmana']  = function() 
	local min, max = UnitPower('player', SPELL_POWER_MANA), UnitPowerMax('player', SPELL_POWER_MANA)
	if min~=max then 
		return SVal(min)
	else
		return SVal(max)
	end
end
oUF.TagEvents['cpuf:druidmana'] = 'UNIT_POWER UNIT_MAXPOWER'











