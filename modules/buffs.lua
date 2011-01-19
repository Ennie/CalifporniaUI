if not Califpornia.CFG.buffs.enable then return end
local rowbuffs = 16


local Group = CalifporniaCFG.BF:Group('CalifporniaUI', 'BuffBar')
Group:Skin('DsmFade', true, false, {})


local cache = {}

local function BFSkinButton(button)
	if button and not cache[button] then
		button:SetHeight(Califpornia.CFG.buffs.iconsize)
		button:SetWidth(Califpornia.CFG.buffs.iconsize)
		Group:AddButton(button)

		local btime = _G[button:GetName().."Duration"]
--		local btime = _G[button:GetName().."Duration"]
		if btime then
			btime:SetFont(unpack(Califpornia.CFG.buffs.font))
		end
		cache[button] = true


--[[	button.time = lib.gen_fontstring(button, mfont, 12, "OUTLINE")
	button.time:SetPoint("CENTER", button, 2, 0)
	button.time:SetJustifyH('CENTER')
	button.time:SetVertexColor(1,1,1)

	button.count = lib.gen_fontstring(button, mfont, 10, "OUTLINE")
	button.count:ClearAllPoints()
	button.count:SetPoint("BOTTOMRIGHT", button, 7, -5)
	button.count:SetVertexColor(1,1,1)	]]


	end
end

TemporaryEnchantFrame:ClearAllPoints()
TemporaryEnchantFrame:SetPoint("TOPRIGHT", UIParent, -8, -8)
TemporaryEnchantFrame.SetPoint = CalifporniaCFG.dummy

TempEnchant1:ClearAllPoints()
TempEnchant2:ClearAllPoints()
TempEnchant1:SetPoint("TOPRIGHT", UIParent, -8, -8)
TempEnchant2:SetPoint("RIGHT", TempEnchant1, "LEFT", -4, 0)

for i = 1, 3 do
	BFSkinButton(_G["TempEnchant"..i])
--[[	local f = CreateFrame("Frame", nil, _G["TempEnchant"..i])
	f:SetFrameLevel(1)
	f:SetHeight(30)
	f:SetWidth(30)
	f:SetFrameStrata("BACKGROUND")
	f:SetPoint("CENTER", _G["TempEnchant"..i], "CENTER", 0, 0)
	_G["TempEnchant"..i.."Border"]:Hide()
	_G["TempEnchant"..i.."Icon"]:SetTexCoord(.08, .92, .08, .92)
	_G["TempEnchant"..i.."Icon"]:SetPoint("TOPLEFT", _G["TempEnchant"..i], 2, -2)
	_G["TempEnchant"..i.."Icon"]:SetPoint("BOTTOMRIGHT", _G["TempEnchant"..i], -2, 2)
	_G["TempEnchant"..i]:SetHeight(30)
	_G["TempEnchant"..i]:SetWidth(30)	
	_G["TempEnchant"..i.."Duration"]:ClearAllPoints()
	_G["TempEnchant"..i.."Duration"]:SetPoint("BOTTOM", 0, 13)
	_G["TempEnchant"..i.."Duration"]:SetFont(CalifporniaCFG.media.font, 12)]]
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




local f = CreateFrame("Frame")
f:SetScript("OnEvent", function() mainhand, _, _, offhand = GetWeaponEnchantInfo() end)
f:RegisterEvent("UNIT_INVENTORY_CHANGED")
f:RegisterEvent("PLAYER_EVENTERING_WORLD")

hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", UpdateBuffAnchors)
hooksecurefunc("DebuffButton_UpdateAnchors", UpdateDebuffAnchors)
