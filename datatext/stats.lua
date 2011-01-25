--------------------------------------------------------------------
 -- STATS
--------------------------------------------------------------------
if CalifporniaCFG["datatext"].stats and Califpornia.CFG["datatext"].stats > 0 then
	local Stat = CreateFrame("Frame")
	Stat:EnableMouse(true)
	Stat:SetFrameStrata("BACKGROUND")
	Stat:SetFrameLevel(3)

	local Text  =Califpornia.Panels.CreateDataText(Califpornia.CFG["datatext"].stats)

	local statstype = 3 -- 1 for tank, 2 for healer, 3 for meleeDPS, 4 for casterDPS, 5 for hunters :D


	local function GetCrit()
		local critchance
		if statstype == 2 or statstype == 4 then
			critchance = GetSpellCritChance(1)
		elseif statstype == 5 then
			critchance = GetRangedCritChance()
		else
			critchance = GetCritChance()
		end
		return format("%.2f", critchance)
	end

	local function GetHaste()
		local haste
		if statstype == 2 or statstype == 4 then
			haste = GetCombatRatingBonus(20)
		elseif statstype == 5 then
			haste = GetCombatRatingBonus(19)
		else
			haste = GetCombatRatingBonus(18)
		end
		return format("%.2f", haste)
	end
	local function GetHit()
		local hit
		if statstype == 2 or statstype == 4 then
			hit = GetCombatRatingBonus(8)
		elseif statstype == 5 then
			hit = GetCombatRatingBonus(7)
		else
			hit = GetCombatRatingBonus(6)
		end
		return format("%.2f", hit)
	end

	local function GetMastery()
		return format("%.2f", 8+GetCombatRatingBonus(26))
	end

	local function GetPower()
		if statstype == 2 or statstype == 4 then
			return GetSpellBonusHealing()
		elseif statstype == 5 then
			return GetSpellBonusDamage(7)
		else
			local base, posBuff, negBuff = UnitAttackPower("player");
			return base + posBuff + negBuff;
		end
	end


	local function GetArmor()
		return SVal(select(2, UnitArmor("player")))
	end

	local function GetAvoidance()
		local targetlv, playerlv = UnitLevel("target"), UnitLevel("player")
		local dodge, parry, block, leveldifference, basemisschance
		if targetlv == -1 then
			basemisschance = (5 - (3*.2))  --Boss Value
			leveldifference = 3
		elseif targetlv > playerlv then
			basemisschance = (5 - ((targetlv - playerlv)*.2)) --Mobs above player level
			leveldifference = (targetlv - playerlv)
		elseif targetlv < playerlv and targetlv > 0 then
			basemisschance = (5 + ((playerlv - targetlv)*.2)) --Mobs below player level
			leveldifference = (targetlv - playerlv)
		else
			basemisschance = 5 --Sets miss chance of attacker level if no target exists, lv80=5, 81=4.2, 82=3.4, 83=2.6
			leveldifference = 0
		end

		if leveldifference >= 0 then
			dodge = (GetDodgeChance()-leveldifference*.2)
			parry = (GetParryChance()-leveldifference*.2)
			block = (GetBlockChance()-leveldifference*.2)
		else
			dodge = (GetDodgeChance()+abs(leveldifference*.2))
			parry = (GetParryChance()+abs(leveldifference*.2))
			block = (GetBlockChance()+abs(leveldifference*.2))
		end
		MissChance = (basemisschance + 1/(0.0625 + 0.956/(GetCombatRating(CR_DEFENSE_SKILL)/4.91850*0.04)))
		return  string.format("%.2f", dodge+parry+block+MissChance)
	end

	Stat:RegisterEvent("UNIT_AURA")
	Stat:RegisterEvent("UNIT_STATS")
	Stat:RegisterEvent("UNIT_INVENTORY_CHANGED")
	Stat:RegisterEvent("PLAYER_TARGET_CHANGED")
	Stat:RegisterEvent("PLAYER_ENTERING_WORLD")
	Stat:SetScript("OnEvent", function(self)
		Text:SetText(hexa..GetPower()..hexb.."|r"..'AP '..hexa..GetCrit()..'%'..hexb.."|r"..'Crit '..hexa..GetHaste()..'%'..hexb.."|r"..'Haste')
		self:SetAllPoints(Text)
	end)
	Stat:SetScript("OnEnter", function(self)
		if not InCombatLockdown() then
			--tooltip blead`
		end
	end)
	Stat:SetScript("OnLeave", function() GameTooltip:Hide() end)


end