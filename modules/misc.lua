----------------------------------------------------------------------------------------
-- General options   
----------------------------------------------------------------------------------------
local csf = CreateFrame("Frame")
csf:SetScript("OnEvent", function()
SetCVar("cameraDistanceMax", 50)
SetCVar("cameraDistanceMaxFactor", 3.4)
SetCVar("nameplateShowFriends", 0)
SetCVar("nameplateShowEnemies", 1)
SetCVar( "bloattest", 1)
SetCVar( "spreadnameplates", 0)
SetCVar( "consolidateBuffs", 0)
SetCVar("ShowClassColorInNameplate", 1)
SetCVar("buffDurations",1) 
end)
csf:RegisterEvent("PLAYER_LOGIN")
------------------------------------------------------------------------
-- Auto vendor trash
------------------------------------------------------------------------
local f = CreateFrame("Frame")
f:SetScript("OnEvent", function()
	if CalifporniaCFG["tweak"].auto_trash  then
		local c = 0
		for b=0,4 do
			for s=1,GetContainerNumSlots(b) do
				local l = GetContainerItemLink(b, s)
				if l then
					local p = select(11, GetItemInfo(l))*select(2, GetContainerItemInfo(b, s))
					if select(3, GetItemInfo(l))==0 then
						UseContainerItem(b, s)
						PickupMerchantItem()
						c = c+p
					end
				end
			end
		end
		if c>0 then
			local g, s, c = math.floor(c/10000) or 0, math.floor((c%10000)/100) or 0, c%100
			DEFAULT_CHAT_FRAME:AddMessage("Vendor trash sold for".." |cffffffff"..g.."|cffffd700g|r".." |cffffffff"..s.."|cffc7c7cfs|r".." |cffffffff"..c.."|cffeda55fc|r"..".",255,255,0)
		end
	end
	if CalifporniaCFG["tweak"].auto_repair  then
		cost, possible = GetRepairAllCost()
		if cost>0 then
			if possible then
				RepairAllItems()
				local c = cost%100
				local s = math.floor((cost%10000)/100)
				local g = math.floor(cost/10000)
				DEFAULT_CHAT_FRAME:AddMessage("Repaired for".." |cffffffff"..g.."|cffffd700g|r".." |cffffffff"..s.."|cffc7c7cfs|r".." |cffffffff"..c.."|cffeda55fc|r"..".",255,255,0)
			else
				DEFAULT_CHAT_FRAME:AddMessage("You don't have enough money for repair!",255,0,0)
			end
		end
	end
end)
f:RegisterEvent("MERCHANT_SHOW")
----------------------------------------------------------------------------------------
-- buy max number value with alt
----------------------------------------------------------------------------------------
local savedMerchantItemButton_OnModifiedClick = MerchantItemButton_OnModifiedClick
function MerchantItemButton_OnModifiedClick(self, ...)
	if ( IsAltKeyDown() ) then
		local maxStack = select(8, GetItemInfo(GetMerchantItemLink(self:GetID())))
		local name, texture, price, quantity, numAvailable, isUsable, extendedCost = GetMerchantItemInfo(self:GetID())
		if ( maxStack and maxStack > 1 ) then
			BuyMerchantItem(self:GetID(), floor(maxStack / quantity))
		end
	end
	savedMerchantItemButton_OnModifiedClick(self, ...)
end
----------------------------------------------------------------------------------------
-- Auto greed/disenchant on green items
----------------------------------------------------------------------------------------
if CalifporniaCFG["tweak"].auto_greed  then
	local autogreed = CreateFrame("frame")
	autogreed:RegisterEvent("START_LOOT_ROLL")
	autogreed:SetScript("OnEvent", function(self, event, id)
		local name = select(2, GetLootRollItemInfo(id))
		if (name == select(1, GetItemInfo(43102))) then
			RollOnLoot(id, 2)
		end
		if CalifporniaCFG.level ~= MAX_PLAYER_LEVEL then return end
		if(id and select(4, GetLootRollItemInfo(id))==2 and not (select(5, GetLootRollItemInfo(id)))) then
			if RollOnLoot(id, 3) then
				RollOnLoot(id, 3)
			else
				RollOnLoot(id, 2)
			end
		end
	end) 
end
----------------------------------------------------------------------------------------
-- Disenchant confirmation(tekKrush by Tekkub)
----------------------------------------------------------------------------------------
if CalifporniaCFG["tweak"].auto_confirm_de then
	local acd = CreateFrame("Frame")
	acd:RegisterEvent("CONFIRM_DISENCHANT_ROLL")
	acd:SetScript("OnEvent", function(self, event, id, rollType)
		for i=1,STATICPOPUP_NUMDIALOGS do
			local frame = _G["StaticPopup"..i]
			if frame.which == "CONFIRM_LOOT_ROLL" and frame.data == id and frame.data2 == rollType and frame:IsVisible() then StaticPopup_OnClick(frame, 1) end
		end
	end)
	
	StaticPopupDialogs["LOOT_BIND"].OnCancel = function(self, slot)
	if GetNumPartyMembers() == 0 and GetNumRaidMembers() == 0 then ConfirmLootSlot(slot) end
	end
end
----------------------------------------------------------------------------------------
-- Auto decline duels
----------------------------------------------------------------------------------------
if CalifporniaCFG["tweak"].auto_duel then
    local dd = CreateFrame("Frame")
    dd:RegisterEvent("DUEL_REQUESTED")
    dd:SetScript("OnEvent", function(self, event, name)
		HideUIPanel(StaticPopup1)
		CancelDuel()
		aInfoText_ShowText(L_DUEL..name)
		print(format("|cff00ffff"..L_DUEL..name))
    end)
end
------------------------------------------------------------------------
-- Auto accept invite
------------------------------------------------------------------------
if CalifporniaCFG["tweak"].auto_accept_invite then
local tAutoAcceptInvite = CreateFrame("Frame")
tAutoAcceptInvite:RegisterEvent("PARTY_INVITE_REQUEST")
tAutoAcceptInvite:RegisterEvent("PARTY_MEMBERS_CHANGED")

local hidestatic -- used to hide static popup when auto-accepting
	
tAutoAcceptInvite:SetScript("OnEvent", function(self, event, ...)
		arg1 = ...
		local leader = arg1
		local ingroup = false
		
		if event == "PARTY_INVITE_REQUEST" then
			if MiniMapLFGFrame:IsShown() then return end -- Prevent losing que inside LFD if someone invites you to group
			if GetNumPartyMembers() > 0 or GetNumRaidMembers() > 0 then return end
			hidestatic = true
		
			-- Update Guild and Friendlist
			if GetNumFriends() > 0 then ShowFriends() end
			if IsInGuild() then GuildRoster() end
			
			for friendIndex = 1, GetNumFriends() do
				local friendName = GetFriendInfo(friendIndex)
				if friendName == leader then
					AcceptGroup()
					ingroup = true
					break
				end
			end
			
			if not ingroup then
				for guildIndex = 1, GetNumGuildMembers(true) do
					local guildMemberName = GetGuildRosterInfo(guildIndex)
					if guildMemberName == leader then
						AcceptGroup()
						break
					end
				end
			end
		elseif event == "PARTY_MEMBERS_CHANGED" and hidestatic == true then
			StaticPopup_Hide("PARTY_INVITE")
			hidestatic = false
		end
end)
end

----------------------------------------------------------------------------------------
-- Quest level(yQuestLevel by yleaf)
----------------------------------------------------------------------------------------
local function qlupdate()
	local buttons = QuestLogScrollFrame.buttons
	local numButtons = #buttons
	local scrollOffset = HybridScrollFrame_GetOffset(QuestLogScrollFrame)
	local numEntries, numQuests = GetNumQuestLogEntries()
	
	for i = 1, numButtons do
		local questIndex = i + scrollOffset
		local questLogTitle = buttons[i]
		if questIndex <= numEntries then
			local title, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily = GetQuestLogTitle(questIndex)
			if not isHeader then
				questLogTitle:SetText("[" .. level .. "] " .. title)
				QuestLogTitleButton_Resize(questLogTitle)
			end
		end
	end
end

hooksecurefunc("QuestLog_Update", qlupdate)
QuestLogScrollFrameScrollBar:HookScript("OnValueChanged", qlupdate)
----------------------------------------------------------------------------------------
-- Force readycheck warning 
----------------------------------------------------------------------------------------
local ShowReadyCheckHook = function(self, initiator, timeLeft)
	if initiator ~= "player" then
		PlaySound("ReadyCheck")
	end
end
hooksecurefunc("ShowReadyCheck", ShowReadyCheckHook)
----------------------------------------------------------------------------------------
--Moving TicketStatusFrame, Battlefield score frame, CaptureBar
----------------------------------------------------------------------------------------
--BuffFrame:ClearAllPoints()
--BuffFrame:SetPoint("TOPRIGHT",UIParent,"TOPRIGHT")
--BuffFrame:SetWidth(32)
--DebuffButton1:ClearAllPoints()
--DebuffButton1:SetPoint("TOPRIGHT",UIParent,"TOPRIGHT", -10, -10)



TicketStatusFrame:ClearAllPoints()
TicketStatusFrame:SetPoint("BOTTOMRIGHT",UIParent,"BOTTOMRIGHT", -10, 146)
TicketStatusFrame.SetPoint = function() end

local fontName = CalifporniaCFG.media.dmgfont
local fontHeight = 24

local function FS_SetFont()
	DAMAGE_TEXT_FONT = fontName
	COMBAT_TEXT_HEIGHT = fontHeight
	COMBAT_TEXT_CRIT_MAXHEIGHT = fontHeight + 2
	COMBAT_TEXT_CRIT_MINHEIGHT = fontHeight - 2
	local fName, fHeight, fFlags = CombatTextFont:GetFont()
	CombatTextFont:SetFont(fontName, fontHeight, fFlags)
end
FS_SetFont()
----------------------------------------------------------------------------------------
-- Interrupt announcer
----------------------------------------------------------------------------------------
if CalifporniaCFG["tweak"].interrupt_announce then
	local OUTPUT = "СБИЛ! %s: %s (%s)";
	local function OnEvent(self, event, ...)
		if ( event == "PLAYER_LOGIN" ) then
			self:UnregisterEvent("PLAYER_LOGIN");
			self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
		elseif ( event == "COMBAT_LOG_EVENT_UNFILTERED" ) then
			local timestamp, eventType, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, spellID, spellName, _, _, extraSkillName = ...;
			if ( eventType == "SPELL_INTERRUPT" ) and sourceName == UnitName("player") then
				local text		= OUTPUT:format(spellName, extraSkillName, destName);
				local numParty	= GetNumPartyMembers();
				local numRaid	= GetNumRaidMembers();
				if ( numRaid > 5 ) then
					SendChatMessage(text, "RAID");
			        elseif ( numRaid < 5 ) then
					SendChatMessage(text, "PARTY");
				elseif ( numParty > 0 ) then
					SendChatMessage(text, "PARTY");
				else
					SendChatMessage(text, "SAY");
				end;
			end;
		end;
	end;
	local Interrupt = CreateFrame("Frame");
	Interrupt:RegisterEvent("PLAYER_LOGIN");
	Interrupt:SetScript("OnEvent", OnEvent);
end

----------------------------------------------------------------------------------------
-- Exp/rep bar - jExpBar
----------------------------------------------------------------------------------------
if Califpornia.CFG["expbar"].enable then


local myscale = 1

local xpcolor = {r = 0.8, g = 0, b = 0}

	local bf = CreateFrame("Frame", nil, UIParent)
	bf:SetFrameStrata("LOW")
	bf:SetFrameLevel(2)
	bf:SetWidth(Califpornia.Panels.dataright:GetWidth())
	bf:SetHeight(Califpornia.Panels.dataright:GetHeight())
	bf:SetPoint("BOTTOMRIGHT", Califpornia.Panels.minimap, "TOPRIGHT", 0, Califpornia.CFG.panels.spacer)
	Califpornia.Lib.frame1px(bf)
	CalifporniaCFG.util.frameShadow(bf)
	bf:Show()

	local bbg = bf:CreateTexture(nil,"BACKGROUND")
	bbg:SetTexture(Califpornia.CFG.media.normTex)
	bbg:SetVertexColor(xpcolor.r,xpcolor.g,xpcolor.b, 0.2)
	bbg:SetWidth(bf:GetWidth())
	bbg:SetHeight(bf:GetHeight())
	bbg:SetPoint("CENTER", 0, 0)
	bbg:Show()

	local rbar = CreateFrame("StatusBar", "jRestBar", UIParent)
	rbar:SetStatusBarTexture(Califpornia.CFG.media.normTex)
	rbar:SetStatusBarColor(1,.6,0, 0.7)
	rbar:SetFrameStrata("LOW")
	rbar:SetFrameLevel(1)
	rbar:SetWidth(bf:GetWidth())
	rbar:SetHeight(bf:GetHeight())
--	rbar:SetPoint("BOTTOM", 0, ypos*myscale)
--	rbar:SetPoint("BOTTOMRIGHT", Califpornia.Panels.minimap, "TOPRIGHT", 0, 10)
	rbar:SetAllPoints(bf)
	rbar:SetMinMaxValues(0,1)
	rbar:SetValue(0)
	rbar:Show()

	local xbar = CreateFrame("StatusBar", "jExpBar", UIParent)
	xbar:SetStatusBarTexture(Califpornia.CFG.media.normTex)
	xbar:SetStatusBarColor(xpcolor.r,xpcolor.g,xpcolor.b, 0.85)
	xbar:SetFrameStrata("LOW")
	xbar:SetFrameLevel(3)
	xbar:SetWidth(bf:GetWidth())
	xbar:SetHeight(bf:GetHeight())
--	xbar:SetPoint("BOTTOM", 0, ypos*myscale)
--	xbar:SetPoint("BOTTOMRIGHT", Califpornia.Panels.minimap, "TOPRIGHT", 0, 10)
	xbar:SetAllPoints(bf)
	xbar:Show()

function rbar_ReSetValue(rxp, xp, mxp)
	if rxp then
		if rxp+xp >= mxp then
			rbar:SetValue(mxp)
		else
			rbar:SetValue(rxp+xp)
		end
	else
		rbar:SetValue(0)
	end
end	

function bf_ShowRep()
	name, standing, minrep, maxrep, value = GetWatchedFactionInfo()
	if name then
		bbg:SetVertexColor(FACTION_BAR_COLORS[standing].r, FACTION_BAR_COLORS[standing].g, FACTION_BAR_COLORS[standing].b, 0.2)
		xbar:SetStatusBarColor(FACTION_BAR_COLORS[standing].r, FACTION_BAR_COLORS[standing].g, FACTION_BAR_COLORS[standing].b, 0.85)
		xbar:SetMinMaxValues(minrep,maxrep)
		xbar:SetValue(value)
		rbar:SetValue(0)
	else
		mxp = UnitXPMax("player")
		xp = UnitXP("player")
		rxp = GetXPExhaustion()
		bf_ShowXP(rxp, xp, mxp)
	end
end

function bf_ShowXP(rxp, xp, mxp)
	bbg:SetVertexColor(xpcolor.r,xpcolor.g,xpcolor.b, 0.2)
	xbar:SetStatusBarColor(xpcolor.r,xpcolor.g,xpcolor.b, 0.85)
	xbar:SetMinMaxValues(0,mxp)
	xbar:SetValue(xp)
	rbar:SetMinMaxValues(0,mxp)
	rbar_ReSetValue(rxp, xp, mxp)
end

function bf_OnEvent(this, event, arg1, arg2, arg3, arg4, ...)
	mxp = UnitXPMax("player")
	xp = UnitXP("player")
	rxp = GetXPExhaustion()
	
	if UnitLevel("player") == MAX_PLAYER_LEVEL and not GetWatchedFactionInfo() then
		bf:Hide()
		rbar:Hide()
	else
		bf:Show()
		rbar:Show()
	end

	if event == "PLAYER_ENTERING_WORLD" then
		if UnitLevel("player") == MAX_PLAYER_LEVEL then
			bf_ShowRep()
		else
			bf_ShowXP(rxp, xp, mxp)
		end
	elseif event == "PLAYER_XP_UPDATE" and arg1 == "player" then
		xbar:SetValue(xp)
		rbar_ReSetValue(rxp, xp, mxp)
	elseif event == "PLAYER_LEVEL_UP" then
		if UnitLevel("player") == MAX_PLAYER_LEVEL then
			bf_ShowRep()
		else
			bf_ShowXP(rxp, xp, mxp)
		end
	elseif event == "MODIFIER_STATE_CHANGED" then
		if arg1 == "LCTRL" or arg1 == "RCTRL" then
			if arg2 == 1 then
				bf_ShowRep()
			elseif arg2 == 0 and UnitLevel("player") ~= MAX_PLAYER_LEVEL then
				bf_ShowXP(rxp, xp, mxp)
			end
		end
	elseif event == "UPDATE_FACTION" then
		if UnitLevel("player") == MAX_PLAYER_LEVEL then
			bf_ShowRep()
		end
	end
end

function bf_OnEnter()
	mxp = UnitXPMax("player")
	xp = UnitXP("player")
	rxp = GetXPExhaustion()
	name, standing, minrep, maxrep, value = GetWatchedFactionInfo()

	GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
	if UnitLevel("player") ~= MAX_PLAYER_LEVEL then
		GameTooltip:AddDoubleLine(COMBAT_XP_GAIN, xp.."|cffffd100/|r"..mxp.." |cffffd100/|r "..floor((xp/mxp)*1000)/10 .."%",NORMAL_FONT_COLOR.r,NORMAL_FONT_COLOR.g,NORMAL_FONT_COLOR.b,1,1,1)
		if rxp then
			GameTooltip:AddDoubleLine(TUTORIAL_TITLE26, rxp .." |cffffd100/|r ".. floor((rxp/mxp)*1000)/10 .."%", NORMAL_FONT_COLOR.r,NORMAL_FONT_COLOR.g,NORMAL_FONT_COLOR.b,1,1,1)
		end
		if name then
			GameTooltip:AddLine(" ")			
		end
	end
	if name then
		GameTooltip:AddDoubleLine(FACTION, name, NORMAL_FONT_COLOR.r,NORMAL_FONT_COLOR.g,NORMAL_FONT_COLOR.b,1,1,1)
		GameTooltip:AddDoubleLine(STANDING, getglobal("FACTION_STANDING_LABEL"..standing), NORMAL_FONT_COLOR.r,NORMAL_FONT_COLOR.g,NORMAL_FONT_COLOR.b,FACTION_BAR_COLORS[standing].r, FACTION_BAR_COLORS[standing].g, FACTION_BAR_COLORS[standing].b)
		GameTooltip:AddDoubleLine(REPUTATION, value-minrep .."|cffffd100/|r"..maxrep-minrep.." |cffffd100/|r "..floor((value-minrep)/(maxrep-minrep)*1000)/10 .."%", NORMAL_FONT_COLOR.r,NORMAL_FONT_COLOR.g,NORMAL_FONT_COLOR.b,1,1,1)
	end
		
	GameTooltip:Show()
end

function bf_OnLeave()
	GameTooltip:Hide()
end

	bf:EnableMouse(true)
	bf:SetScript("OnEvent", bf_OnEvent)
	bf:SetScript("OnEnter", bf_OnEnter)
	bf:SetScript("OnLeave", bf_OnLeave)
	bf:RegisterEvent("PLAYER_XP_UPDATE")
	bf:RegisterEvent("PLAYER_LEVEL_UP")
	bf:RegisterEvent("PLAYER_ENTERING_WORLD")
	bf:RegisterEvent("UPDATE_FACTION")
	bf:RegisterEvent("MODIFIER_STATE_CHANGED")
end

----------------------------------------------------------------------------------------
-- Default configuration for some addons
----------------------------------------------------------------------------------------
local SetRecountZ = function()
RecountDB.profiles = {
		["Default"] = {
			["GraphWindowY"] = 0,
			["MainWindow"] = {
				["ShowScrollbar"] = false,
				["Position"] = {
					["y"] = -424.1001533438775,
					["x"] = 403.6004844354235,
					["w"] = 278.4998643976458,
					["h"] = 147.2500268494951,
				},
				["BarText"] = {
					["NumFormat"] = 3,
				},
				["Buttons"] = {
					["CloseButton"] = false,
					["LeftButton"] = false,
					["RightButton"] = false,
				},
				["RowSpacing"] = 0,
			},
			["AutoDeleteNewInstance"] = false,
			["ReportLines"] = 15,
			["DeleteNewInstanceOnly"] = false,
			["Colors"] = {
				["Window"] = {
					["Background"] = {
						["a"] = 0,
					},
					["Title"] = {
						["a"] = 0,
					},
				},
				["Bar"] = {
					["Bar Text"] = {
						["a"] = 1,
					},
					["Total Bar"] = {
						["a"] = 1,
					},
				},
			},
			["DeleteJoinRaid"] = false,
			["DeleteJoinGroup"] = false,
			["GraphWindowX"] = 0,
			["Locked"] = true,
			["Scaling"] = 0.8,
			["BarTextColorSwap"] = false,
			["BarTexture"] = "Minimalist",
			["CurDataSet"] = "OverallData",
			["MainWindowWidth"] = 278.4998839384297,
			["MainWindowHeight"] = 147.2500366198871,
		},
}
Recount.db:SetProfile('Default')

end

SLASH_SETRECOUNT1 = "/setrecount"
SlashCmdList["SETRECOUNT"] = function() SetRecountZ() end


-- WF autohide
if CalifporniaCFG["tweak"].wf_autohide then
local wfhider = CreateFrame("Frame")
local wf = WatchFrame

local wf_hidden = false


wfhider:RegisterEvent("PLAYER_REGEN_DISABLED")
wfhider:RegisterEvent("PLAYER_REGEN_ENABLED")
wfhider:SetScript("OnEvent", function(self, event, ...)
		if event == "PLAYER_REGEN_DISABLED" and not WatchFrame.userCollapsed then
		WatchFrame.userCollapsed = true;
			wf_hidden = true
			WatchFrame_Collapse(wf);
		end
		if event == "PLAYER_REGEN_ENABLED" and wf_hidden then
			wf_hidden = false
			WatchFrame.userCollapsed = nil;
			WatchFrame_Expand(wf);
		end
end)
end
