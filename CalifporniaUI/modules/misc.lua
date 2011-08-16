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
-- 4.1.0 fix -- SetCVar( "spreadnameplates", 0)
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
			
			local BNtotal = BNGetNumFriends()
			if BNtotal > 0 then
				for i = 1, BNtotal do
					local friendName, toonID, client, isOnline = select(4, BNGetFriendInfo(i))
					if client == "WoW" and isOnline and CanCooperateWithToon(toonID) and friendName == leader then
						AcceptGroup()
						ingroup = true
						break
					end
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
TicketStatusFrame:SetPoint("BOTTOMRIGHT",UIParent,"BOTTOMRIGHT", -Califpornia.CFG.common.screen_spacer, 124)
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
			local timestamp, eventType, hideCaster, sourceGUID, sourceName, sourceFlags, srcFlags2, destGUID, destName, destFlags, destFlags2, spellID, spellName, _, _, extraSkillName = ...;
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
-- EQUIPPED avg ilvl in paperdoll
----------------------------------------------------------------------------------------
function TableSum(table)
	local retVal = 0

	for _, n in ipairs(table) do
		retVal = retVal + n
	end

	return retVal
end

function GetUnitItemLevel(unit)
	local items = {}

	if unit and UnitIsPlayer(unit) and CheckInteractDistance(unit, 1) then
		for i = 1, 18, 1 do
			local itemID = GetInventoryItemID(unit, i) or 0
			local itemLevel = select(4, GetItemInfo(itemID))

			if itemLevel and itemLevel > 0 and i ~= 4 then
				tinsert(items, itemLevel)
			end
		end
	end

	local count, sum = #(items), TableSum(items)

	if sum >= count and count > 0 then
		if floor(sum/count)+0.5 < sum/count then
			return ceil(sum/count)
		else
			return floor(sum/count)
		end
	else
		return nil
	end
end

local f = CreateFrame("Frame", nil, UIParent)
local function OnEvent(self, event, ...)
	if ( event == "VARIABLES_LOADED" ) then

		PAPERDOLL_STATINFO["EQUIPPEDILVL"] = {
			updateFunc = function(statFrame, unit)
				PaperDollFrame_SetLabelAndText(statFrame, "Equipped iLvl", GetUnitItemLevel("player"))
				statFrame:Show()
			end
		}
		tinsert(PAPERDOLL_STATCATEGORIES["GENERAL"].stats, 4, "EQUIPPEDILVL")
		self:UnregisterEvent("VARIABLES_LOADED")
	end
end
f:RegisterEvent("VARIABLES_LOADED")
f:SetScript("OnEvent", OnEvent)
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


-- WF autohide on BossFrame show by Haste
if Califpornia.CFG["tweak"].wf_autohide then
	local wfhider = CreateFrame'Frame'

	wfhider:RegisterEvent("PLAYER_ENTERING_WORLD")
	wfhider:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
	wfhider:RegisterEvent("UNIT_TARGETABLE_CHANGED")
	wfhider:RegisterEvent("PLAYER_REGEN_ENABLED")

	local BossExists = function()
		for i=1,MAX_BOSS_FRAMES do
			if(UnitExists('boss' .. i)) then
				return true
			end
		end
	end

	-- Defensive coding inc.
	wfhider:SetScript('OnEvent', function(self, event)
		if(BossExists()) then
			if(not WatchFrame.collapsed) then
				WatchFrame_CollapseExpandButton_OnClick(WatchFrame_CollapseExpandButton)
			end
		elseif(WatchFrame.collapsed and not InCombatLockdown()) then
			WatchFrame_CollapseExpandButton_OnClick(WatchFrame_CollapseExpandButton)
		end
	end)
end
