if not Califpornia.CFG["tooltip"].enable == true then return end


local cfg = {
    scale = 1.0,
    cursor = false,
    titles = true,
    gcolor = { r=1, g=0.1, b=1 },
}

local classification = {
    elite = "+",
    worldboss = "??",
    rare = "R",
    rareelite = "R+",
}

local hex = function(color)
	local format = string.format
	return format('|cff%02x%02x%02x', color.r * 255, color.g * 255, color.b * 255)
end

local function unitColor(unit)
    local color = { r=1, g=1, b=1 }
    if UnitIsPlayer(unit) then
        local _, class = UnitClass(unit)
        color = Califpornia.CFG.colors.all_class_colors[class]
        return color
    else
        local reaction = UnitReaction(unit, "player")
        if reaction then
            color = FACTION_BAR_COLORS[reaction]
            return color
        end
    end
    return color
end

function GameTooltip_UnitColor(unit)
    local color = unitColor(unit)
    return color.r, color.g, color.b
end

local function getTarget(unit)
    if UnitIsUnit(unit, "player") then
        return ("|cffff0000%s|r"):format(Califpornia.CFG.tooltip.you)
    else
        return hex(unitColor(unit))..UnitName(unit).."|r"
    end
end

GameTooltip:HookScript("OnTooltipSetUnit", function(self)
    local name, unit = self:GetUnit()
    if unit then

        local color = unitColor(unit)
        local ricon = GetRaidTargetIndex(unit)

        if ricon then
            local text = GameTooltipTextLeft1:GetText()
            GameTooltipTextLeft1:SetText(("%s %s"):format(ICON_LIST[ricon].."22|t", text))
        end

        if UnitIsPlayer(unit) then
            self:AppendText((" |cff00cc00%s|r"):format(UnitIsAFK(unit) and CHAT_FLAG_AFK or UnitIsDND(unit) and CHAT_FLAG_DND or not UnitIsConnected(unit) and "<DC>" or ""))

            if not cfg.titles then
                local title = UnitPVPName(unit)
                if title then
                    local text = GameTooltipTextLeft1:GetText()
                    title = title:gsub(name, "")
                    text = text:gsub(title, "")
                    if text then GameTooltipTextLeft1:SetText(text) end
                end
            end

            local unitGuild, unitGuildRank = GetGuildInfo(unit)
            local text2 = GameTooltipTextLeft2:GetText()
            if unitGuild and text2 and text2:find("^"..unitGuild) then	
			GameTooltipTextLeft2:SetFormattedText("<%s> %s",unitGuild,unitGuildRank);
	                GameTooltipTextLeft2:SetTextColor(cfg.gcolor.r, cfg.gcolor.g, cfg.gcolor.b)
            end
        end

        local level = UnitLevel(unit)
        if level then
            local unitClass = UnitIsPlayer(unit) and hex(color)..UnitClass(unit).."|r" or ""
            local creature = not UnitIsPlayer(unit) and UnitCreatureType(unit) or ""
            local diff = GetQuestDifficultyColor(level)

            local classify = UnitClassification(unit)
            if level == -1 then
                if classify == "elite" then
                    level = "|cffff0000"..classification["worldboss"]
                else
                    level = "|cffff0000"
                end
            end
            local textLevel = ("%s%s%s|r"):format(hex(diff), tostring(level), classification[classify] or "")

            for i=2, self:NumLines() do
                local tiptext = _G["GameTooltipTextLeft"..i]
                if tiptext:GetText():find(LEVEL) then
                    tiptext:SetText(("%s %s%s %s"):format(textLevel, creature, UnitRace(unit) or "", unitClass):trim())
                end

                if tiptext:GetText():find(PVP) then
                    tiptext:SetText(nil)
                end
            end
        end

        if UnitExists(unit.."target") then
            local tartext = ("%s: %s"):format(TARGET, getTarget(unit.."target"))
            self:AddLine(tartext)
        end

        GameTooltipStatusBar:SetStatusBarColor(color.r, color.g, color.b)

        if UnitIsDeadOrGhost(unit) then
            GameTooltipStatusBar:Hide()
            self:AddLine("|cffFF0000"..DEAD.."|r")
        end
    else
        GameTooltipStatusBar:SetStatusBarColor(0, .9, 0)
    end
    if GameTooltipStatusBar:IsShown() then
        self:AddLine(" ")
        GameTooltipStatusBar:ClearAllPoints()
        GameTooltipStatusBar:SetPoint("TOPLEFT", self:GetName().."TextLeft"..self:NumLines(), "TOPLEFT", 0, -4)
        GameTooltipStatusBar:SetPoint("TOPRIGHT", self, -10, 0)
    end
end)

GameTooltipStatusBar:SetStatusBarTexture(Califpornia.CFG.media.normTex)
local bg = GameTooltipStatusBar:CreateTexture(nil, "BACKGROUND")
bg:SetAllPoints(GameTooltipStatusBar)
bg:SetTexture(Califpornia.CFG.media.normTex)
bg:SetVertexColor(0.5, 0.5, 0.5, 0.5)


local numberize = function(val)
    if (val >= 1e6) then
        return ("%.1fm"):format(val / 1e6)
    elseif (val >= 1e3) then
        return ("%.1fk"):format(val / 1e3)
    else
        return ("%d"):format(val)
    end
end

GameTooltipStatusBar:SetScript("OnValueChanged", function(self, value)
    if not value then
        return
    end
    local min, max = self:GetMinMaxValues()
    if (value < min) or (value > max) then
        return
    end
    local _, unit = GameTooltip:GetUnit()
    if unit then
        min, max = UnitHealth(unit), UnitHealthMax(unit)
        if not self.text then
            self.text = self:CreateFontString(nil, "OVERLAY")
            self.text:SetPoint("CENTER", GameTooltipStatusBar)
            self.text:SetFont(unpack(Califpornia.CFG.tooltip.font))
        end
        self.text:Show()
        local hp = numberize(min).." / "..numberize(max)
        self.text:SetText(hp)
    end
end)

local function style(frame)
    frame:SetScale(cfg.scale)
	frame:SetBackdrop({
		bgFile =  [=[Interface\ChatFrame\ChatFrameBackground]=],
		edgeFile = "Interface\\Buttons\\WHITE8x8", 
		tile = false, tileSize = 0, edgeSize = 1, 
		insets = { left = -1, right = -1, top = -1, bottom = -1}
	})
	frame:SetBackdropColor(unpack(Califpornia.CFG.colors.class_backdrop))
	frame:SetBackdropBorderColor(unpack(Califpornia.CFG.colors.class_backdrop_border))
	Califpornia.CFG.util.outerBorder(frame)
	Califpornia.CFG.util.innerBorder(frame)
	Califpornia.CFG.util.frameShadow(frame)
	
    if frame.GetItem then
        local _, item = frame:GetItem()
        if item then
            local quality = select(3, GetItemInfo(item))
            if(quality) then
                local r, g, b = GetItemQualityColor(quality)
                frame:SetBackdropBorderColor(r/2, g/2, b/2)
            end
        end
    end

    if frame.NumLines then
        for index=1, frame:NumLines() do
            _G[frame:GetName()..'TextLeft'..index]:SetFont(unpack(Califpornia.CFG.tooltip.font))
            _G[frame:GetName()..'TextRight'..index]:SetFont(unpack(Califpornia.CFG.tooltip.font))
        end
    end
end

local tooltips = {
    GameTooltip, 
    ItemRefTooltip, 
    ShoppingTooltip1, 
    ShoppingTooltip2, 
    ShoppingTooltip3,
    WorldMapTooltip, 
    DropDownList1MenuBackdrop, 
    DropDownList2MenuBackdrop,
}

for i, frame in ipairs(tooltips) do
    frame:SetScript("OnShow", function(frame) style(frame) end)
end

hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
    local frame = GetMouseFocus()
    if Califpornia.CFG.tooltip.cursor and frame == WorldFrame then
        tooltip:SetOwner(parent, "ANCHOR_CURSOR")
    else
        tooltip:SetOwner(parent, "ANCHOR_NONE")	
        tooltip:SetPoint("BOTTOMRIGHT", Califpornia.Panels.minimap, "TOPRIGHT", 0, Califpornia.CFG.panels.spacer)
    end
    tooltip.default = 1
end)






local _G = getfenv(0)
local UnitAura = _G.UnitAura
local UnitName = _G.UnitName
local UnitClass = _G.UnitClass
local strformat = _G.string.format
local strsub = _G.string.sub

local TOOLTIP_TEXT = "%s"
local PET_TEXT = "%s <%s>"


local function SetUnitAura(tooltip, unit, id, filter)
	local _, _, _, _, _, _, _, caster = UnitAura(unit, id, filter)
	if caster then
		if caster == "vehicle" or caster == "pet" then
			casterName = strformat(PET_TEXT, UnitName(caster), UnitName("player"))
		elseif strsub(caster, 1, 8) == "partypet" and strsub(caster, -6) ~= "target" then
			local party_id = strsub(caster, 9)
			casterName = strformat(PET_TEXT, UnitName(caster), UnitName("party"..party_id))
		elseif strsub(caster, 1, 7) == "raidpet" and strsub(caster, -6) ~= "target" then
			local raid_id = strsub(caster, 8)
			casterName = strformat(PET_TEXT, UnitName(caster), UnitName("raid"..raid_id))
		else
			casterName = UnitName(caster)
		end
		if (casterName) then
			local c
			if (UnitIsPlayer(caster)) then
				local _, class = UnitClass(caster)
				c = class and RAID_CLASS_COLORS[class]
			end
			if (c) then
				tooltip:AddLine(casterName, c.r, c.g, c.b)
			else				
				tooltip:AddLine(casterName)
			end
		end
		tooltip:Show()
	end
end

local function SetUnitBuff(tooltip, unit, id, filter)
	SetUnitAura(tooltip, unit, id, "HELPFUL "..(filter or ""))
end

local function SetUnitDebuff(tooltip, unit, id, filter)
	SetUnitAura(tooltip, unit, id, "HARMFUL "..(filter or ""))
end

hooksecurefunc(GameTooltip, "SetUnitAura", SetUnitAura)
hooksecurefunc(GameTooltip, "SetUnitBuff", SetUnitBuff)
hooksecurefunc(GameTooltip, "SetUnitDebuff", SetUnitDebuff)