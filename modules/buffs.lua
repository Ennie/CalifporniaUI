if not Califpornia.CFG.buffs.enable then return end

local cache = {}

local function lSetTimeText(button, time)
	if( time <= 0 ) then
		button:SetText("");
	elseif( time < 3600 ) then
		local d, h, m, s = ChatFrame_TimeBreakDown(time);
		button:SetFormattedText("%02d:%02d", m, s);
	else
		local d, h, m, s = ChatFrame_TimeBreakDown(time);
		button:SetFormattedText("%02d:%02d", h, m);
	end
end

local function BFSkinButton(button)
	if button and not cache[button] then
		button:SetHeight(Califpornia.CFG.buffs.iconsize)
		button:SetWidth(Califpornia.CFG.buffs.iconsize)
		Califpornia.SkinButton(button, false, false)

		local btime = _G[button:GetName().."Duration"]
		if btime then
			btime:SetFont(unpack(Califpornia.CFG.buffs.font))
			btime:SetVertexColor(unpack(Califpornia.CFG.buffs.time_color))
			btime:SetJustifyH('CENTER')
			btime:ClearAllPoints()
			btime:SetPoint("CENTER", button, 1, 0)
		end
		local bcount = _G[button:GetName().."Count"]
		if bcount then
			bcount:SetFont(unpack(Califpornia.CFG.buffs.font))
			bcount:SetVertexColor(unpack(Califpornia.CFG.buffs.count_color))
			bcount:SetJustifyH('RIGHT')
			bcount:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -3, 0)
		end
		cache[button] = true
	end
end

TemporaryEnchantFrame:ClearAllPoints()
TemporaryEnchantFrame:SetPoint("TOPRIGHT", UIParent, -8, -8)
TemporaryEnchantFrame.SetPoint = Califpornia.dummy

TempEnchant1:ClearAllPoints()
TempEnchant2:ClearAllPoints()
TempEnchant1:SetPoint("TOPRIGHT", UIParent, -8, -8)
TempEnchant2:SetPoint("RIGHT", TempEnchant1, "LEFT", -4, 0)

for i = 1, 3 do
	BFSkinButton(_G["TempEnchant"..i])
end


local function UpdateDebuffAnchors(buttonName, index)
	local debuff = _G[buttonName..index];
	debuff:ClearAllPoints()
	BFSkinButton(debuff)
	if index == 1 then
		debuff:SetPoint("TOPRIGHT", UIParent, -8, -100)
	else
		debuff:SetPoint("RIGHT", _G[buttonName..(index-1)], "LEFT", -4, 0)
	end
end

local function UpdateBuffAnchors()
	buttonName = "BuffButton"
	local buff, previousBuff, aboveBuff;
	local numBuffs = 0;
	for i=1, BUFF_ACTUAL_DISPLAY do
		local buff = _G[buttonName..i]
			numBuffs = numBuffs + 1
			BFSkinButton(buff)
			buff:ClearAllPoints()
			if ( (numBuffs > 1) and (mod(numBuffs, Califpornia.CFG.buffs.rowbuffs) == 1) ) then
				if ( numBuffs == Califpornia.CFG.buffs.rowbuffs+1 ) then
					buff:SetPoint("TOPRIGHT", UIParent, -8, -50)
				else
					buff:SetPoint("TOPRIGHT", UIParent, -8, -8)
				end
				aboveBuff = buff;
			elseif ( numBuffs == 1 ) then
				local mainhand, _, _, offhand, _, _, hand3 = GetWeaponEnchantInfo()
					if (mainhand and offhand and hand3) and not UnitHasVehicleUI("player") then
						buff:SetPoint("RIGHT", TempEnchant3, "LEFT", -4, 0)
					elseif ((mainhand and offhand) or (mainhand and hand3) or (offhand and hand3)) and not UnitHasVehicleUI("player") then
						buff:SetPoint("RIGHT", TempEnchant2, "LEFT", -4, 0)
					elseif ((mainhand and not offhand and not hand3) or (offhand and not mainhand and not hand3) or (hand3 and not mainhand and not offhand)) and not UnitHasVehicleUI("player") then
						buff:SetPoint("RIGHT", TempEnchant1, "LEFT", -4, 0)
					else
						buff:SetPoint("TOPRIGHT", UIParent, -8, -8)
					end
			else
				buff:SetPoint("RIGHT", previousBuff, "LEFT", -4, 0)
			end
			previousBuff = buff


	end

end

local function UpdateBuffsDuration(buffButton, timeLeft)
	local duration = getglobal(buffButton:GetName().."Duration");
	if( timeLeft ) then
		lSetTimeText(duration, timeLeft);
		duration:Show();
	else
		duration:Hide();
	end
end



local f = CreateFrame("Frame")
f:SetScript("OnEvent", function() mainhand, _, _, offhand = GetWeaponEnchantInfo() end)
f:RegisterEvent("UNIT_INVENTORY_CHANGED")
f:RegisterEvent("PLAYER_EVENTERING_WORLD")

hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", UpdateBuffAnchors)
hooksecurefunc("DebuffButton_UpdateAnchors", UpdateDebuffAnchors)
hooksecurefunc("AuraButton_UpdateDuration", UpdateBuffsDuration)

