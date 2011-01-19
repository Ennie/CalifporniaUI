if not CalifporniaCFG["skinframe"].enable == true then return end

local font, fontsize = CalifporniaCFG.media.font, CalifporniaCFG.media.fs_skinframe
local glowTex = "Interface\\Buttons\\WHITE8x8"
local bgtexture = [=[Interface\ChatFrame\ChatFrameBackground]=]

function frameShadow(f)
    if f.frameBD==nil then
      local frameBD = CreateFrame("Frame", nil, f)
      frameBD = CreateFrame("Frame", nil, f)
      frameBD:SetFrameLevel(1)
      frameBD:SetFrameStrata(f:GetFrameStrata())
      frameBD:SetPoint("TOPLEFT", -4, 4)
      frameBD:SetPoint("BOTTOMLEFT", -4, -4)
      frameBD:SetPoint("TOPRIGHT", 4, 4)
      frameBD:SetPoint("BOTTOMRIGHT", 4, -4)
      frameBD:SetBackdrop( { 
         edgeFile = CalifporniaCFG.media.glowTex, edgeSize = 4,
         insets = {left = 3, right = 3, top = 3, bottom = 3},
         tile = false, tileSize = 0,
      })
      
      frameBD:SetBackdropColor(0, 0, 0, 0)
      frameBD:SetBackdropBorderColor(0, 0, 0, 1)
      f.frameBD = frameBD
    end
end

function CreateInnerBorder(f)
	if f.iborder then return end
	f.iborder = CreateFrame("Frame", nil, f)
	f.iborder:SetPoint("TOPLEFT", 1, -1)
	f.iborder:SetPoint("BOTTOMRIGHT", -1, 1)
	f.iborder:SetFrameLevel(f:GetFrameLevel())
	f.iborder:SetBackdrop({
	  edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1,
	  insets = { left = -1, right = -1, top = -1, bottom = -1}
	})
	f.iborder:SetBackdropBorderColor(0, 0, 0)
	return f.iborder
end

function CreateOuterBorder(f)
	if f.oborder then return end
	f.oborder = CreateFrame("Frame", nil, f)
	f.oborder:SetPoint("TOPLEFT", -1, 1)
	f.oborder:SetPoint("BOTTOMRIGHT", 1, -1)
	f.oborder:SetFrameLevel(f:GetFrameLevel())
	f.oborder:SetBackdrop({
	  edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1, 
	  insets = { left = -1, right = -1, top = -1, bottom = -1}
	})
	f.oborder:SetBackdropBorderColor(0, 0, 0)
	return f.oborder
end

function qBD(f)
	f:SetBackdrop({
		bgFile =  bgtexture,
        edgeFile = glowTex, edgeSize = 1, 
		insets = {left = 1, right = 1, top = 1, bottom = 1} 
	})
	f:SetBackdropColor(unpack(CalifporniaCFG.colors.class_backdrop))
	f:SetBackdropBorderColor(unpack(CalifporniaCFG.colors.class_backdrop_border))
	CreateOuterBorder(f)
	CreateInnerBorder(f)
end

function Kill(object)
	object.Show = dummy
	object:Hide()
end

local function SetModifiedBackdrop(self)
	local color = CalifporniaCFG.colors.class_color
	self:SetBackdropColor(color.r, color.g, color.b, 0.15)
	self:SetBackdropBorderColor(color.r, color.g, color.b)
end

local function SetOriginalBackdrop(self)
	self:SetBackdropColor(unpack(CalifporniaCFG.colors.class_backdrop))
	self:SetBackdropBorderColor(unpack(CalifporniaCFG.colors.class_backdrop_border))
end

function qBS(f)
	local sd = CreateFrame("Frame", nil, parent)
	sd.size = size or 3
	sd.offset = offset or 0
	sd:SetBackdrop({
		edgeSize = sd.size,
	})
	sd:SetPoint("TOPLEFT", parent, -sd.size - 1 - sd.offset, sd.size + 1 + sd.offset)
	sd:SetPoint("BOTTOMRIGHT", parent, sd.size + 1 + sd.offset, -sd.size - 1 - sd.offset)
	sd:SetBackdropBorderColor(r or 0, g or 0, b or 0)
	sd:SetAlpha(alpha or 1)
end

local function SkinButton(f)
	f:SetNormalTexture("")
	f:SetHighlightTexture("")
	f:SetPushedTexture("")
	f:SetDisabledTexture("")
	qBD(f)
	f:HookScript("OnEnter", SetModifiedBackdrop)
	f:HookScript("OnLeave", SetOriginalBackdrop)
end

local Skin = CreateFrame("Frame")
Skin:RegisterEvent("ADDON_LOADED")
Skin:SetScript("OnEvent", function(self, event, addon)
		local skins = {
			-- boom
--			"CharacterFrame",
--			"GearManagerDialog",
--			"ReputationDetailFrame",
--			"GearManagerDialogPopup",

--			"AddFriendFrame", 
--			"FriendsFriendsFrame",
--			"FriendsFriendsList",			

			"StaticPopup1",
			"StaticPopup2",
			"GameMenuFrame",
			"InterfaceOptionsFrame",
			"VideoOptionsFrame",
			"AudioOptionsFrame",
			"LFDDungeonReadyStatus",
			"BNToastFrame",
			"TicketStatusFrameButton",
			"DropDownList1MenuBackdrop",
			"DropDownList2MenuBackdrop",
			"DropDownList1Backdrop",
			"DropDownList2Backdrop",
			"LFDSearchStatus",
			"AutoCompleteBox", -- this is the /w *nickname* box, press tab
			"ReadyCheckFrame",
			"ColorPickerFrame",
			"GhostFrameContentsFrame",
		}

		-- reskin popup buttons
		for i = 1, 3 do
			for j = 1, 3 do
				SkinButton(_G["StaticPopup"..i.."Button"..j])
			end
		end
		
		for i = 1, getn(skins) do
			qBD(_G[skins[i]])
			if _G[skins[i]] ~= _G["GhostFrameContentsFrame"] and _G[skins[i]] ~= _G["AutoCompleteBox"] then -- frame to blacklist from create shadow function
			frameShadow(_G[skins[i]])
			end
		end
		
		local ChatMenus = {
			"ChatMenu",
			"EmoteMenu",
			"LanguageMenu",
			"VoiceMacroMenu",
		}
 
		for i = 1, getn(ChatMenus) do
			if _G[ChatMenus[i]] == _G["ChatMenu"] then
				_G[ChatMenus[i]]:HookScript("OnShow", function(self) qBD(self) self:ClearAllPoints() self:SetPoint("BOTTOMLEFT", ChatFrame1, "TOPLEFT", 0, 30) end)
			else
				_G[ChatMenus[i]]:HookScript("OnShow", function(self) qBD(self) end)
			end
		end
		
		-- reskin all esc/menu buttons
		local BlizzardMenuButtons = {
			"Options", 
			"SoundOptions", 
			"UIOptions", 
			"Keybindings", 
			"Macros",
			"AddonManager",
			"Ratings",
			"AddOns", 
			"Logout", 
			"Quit", 
			"Continue", 
			"MacOptions"
		}
		
		for i = 1, getn(BlizzardMenuButtons) do
			local MenuButtons = _G["GameMenuButton"..BlizzardMenuButtons[i]]
			if MenuButtons then
				SkinButton(MenuButtons)
				_G["GameMenuButton"..BlizzardMenuButtons[i].."Left"]:SetAlpha(0)
				_G["GameMenuButton"..BlizzardMenuButtons[i].."Middle"]:SetAlpha(0)
				_G["GameMenuButton"..BlizzardMenuButtons[i].."Right"]:SetAlpha(0)
			end
		end
		
		if IsAddOnLoaded("OptionHouse") then
			SkinButton(GameMenuButtonOptionHouse)
		end
		
		-- hide header textures and move text/buttons.
		local BlizzardHeader = {
			"GameMenuFrame", 
			"InterfaceOptionsFrame", 
			"AudioOptionsFrame", 
			"GameMenuButtonTemplate",
			"VideoOptionsFrame"
		}
		
		for i = 1, getn(BlizzardHeader) do
			local title = _G[BlizzardHeader[i].."Header"]			
			if title then
				title:SetTexture("")
				title:ClearAllPoints()
				if title == _G["GameMenuFrameHeader"] then
					title:SetPoint("TOP", GameMenuFrame, 0, 7)
				else
					title:SetPoint("TOP", BlizzardHeader[i], 0, 0)
				end
			end
		end
		
--		local buttons = {"ChatConfigFrameOkayButton", "ChatConfigFrameDefaultButton", "DressUpFrameCancelButton", "DressUpFrameResetButton", "WhoFrameWhoButton", "WhoFrameAddFriendButton", "WhoFrameGroupInviteButton", "SendMailMailButton", "SendMailCancelButton", "OpenMailReplyButton", "OpenMailDeleteButton", "OpenMailCancelButton", "OpenMailReportSpamButton", "aMailButton", "QuestLogFrameAbandonButton", "QuestLogFramePushQuestButton", "QuestLogFrameTrackButton", "QuestLogFrameCancelButton", "QuestFrameAcceptButton", "QuestFrameDeclineButton", "QuestFrameCompleteQuestButton", "QuestFrameCompleteButton", "QuestFrameGoodbyeButton", "GossipFrameGreetingGoodbyeButton", "QuestFrameGreetingGoodbyeButton", "ChannelFrameNewButton", "RaidFrameRaidInfoButton", "RaidFrameConvertToRaidButton", "TradeFrameTradeButton", "TradeFrameCancelButton", "StackSplitOkayButton", "StackSplitCancelButton", "TabardFrameAcceptButton", "TabardFrameCancelButton"}
--		local alphabuttons = {"GameMenuButtonOptions", "GameMenuButtonSoundOptions", "GameMenuButtonUIOptions", "GameMenuButtonKeybindings", "GameMenuButtonMacros", "GameMenuButtonAddOns", "GameMenuButtonLogout", "GameMenuButtonQuit", "GameMenuButtonContinue", "GameMenuButtonMacOptions", "FriendsFrameAddFriendButton", "FriendsFrameSendMessageButton", "LFDQueueFrameFindGroupButton", "LFDQueueFrameCancelButton", "LFRQueueFrameFindGroupButton", "LFRQueueFrameAcceptCommentButton", "PVPFrameLeftButton", "PVPHonorFrameWarGameButton", "PVPFrameRightButton", "RaidFrameNotInRaidRaidBrowserButton", "WorldStateScoreFrameLeaveButton", "SpellBookCompanionSummonButton", "AddFriendEntryFrameAcceptButton", "AddFriendEntryFrameCancelButton", "FriendsFriendsSendRequestButton", "FriendsFriendsCloseButton", "ColorPickerOkayButton", "ColorPickerCancelButton", "FriendsFrameIgnorePlayerButton", "FriendsFrameUnsquelchButton", "LFDDungeonReadyDialogEnterDungeonButton", "LFDDungeonReadyDialogLeaveQueueButton", "LFRBrowseFrameSendMessageButton", "LFRBrowseFrameInviteButton", "LFRBrowseFrameRefreshButton", "LFDRoleCheckPopupAcceptButton", "LFDRoleCheckPopupDeclineButton", "GuildInviteFrameJoinButton", "GuildInviteFrameDeclineButton", "FriendsFramePendingButton1AcceptButton", "FriendsFramePendingButton1DeclineButton"}
		-- here we reskin all "normal" buttons
		local BlizzardButtons = {
			-- PEWPEW
--			"GearManagerDialogDeleteSet", 
--			"GearManagerDialogEquipSet", 
--			"GearManagerDialogSaveSet",
--			"GearManagerDialogPopupOkay",
--			"GearManagerDialogPopupCancel",

			"VideoOptionsFrameOkay", 
			"VideoOptionsFrameCancel", 
			"VideoOptionsFrameDefaults", 
			"VideoOptionsFrameApply", 
			"AudioOptionsFrameOkay", 
			"AudioOptionsFrameCancel", 
			"AudioOptionsFrameDefaults",
			"InterfaceOptionsFrameDefaults", 
			"InterfaceOptionsFrameOkay", 
			"InterfaceOptionsFrameCancel",
			"ReadyCheckFrameYesButton",
			"ReadyCheckFrameNoButton",
			"btn_aLoadFrame",
			"btn2_aLoadFrame",
		}
		
		for i = 1, getn(BlizzardButtons) do
		local Buttons = _G[BlizzardButtons[i]]
			if Buttons then
				SkinButton(Buttons)
			end
		end
		
		-- if a button position or text is not really where we want, we move it here
		_G["VideoOptionsFrameCancel"]:ClearAllPoints()
		_G["VideoOptionsFrameCancel"]:SetPoint("RIGHT",_G["VideoOptionsFrameApply"],"LEFT",-4,0)		 
		_G["VideoOptionsFrameOkay"]:ClearAllPoints()
		_G["VideoOptionsFrameOkay"]:SetPoint("RIGHT",_G["VideoOptionsFrameCancel"],"LEFT",-4,0)	
		_G["AudioOptionsFrameOkay"]:ClearAllPoints()
		_G["AudioOptionsFrameOkay"]:SetPoint("RIGHT",_G["AudioOptionsFrameCancel"],"LEFT",-4,0)
		_G["InterfaceOptionsFrameOkay"]:ClearAllPoints()
		_G["InterfaceOptionsFrameOkay"]:SetPoint("RIGHT",_G["InterfaceOptionsFrameCancel"],"LEFT", -4,0)
		_G["ColorPickerCancelButton"]:ClearAllPoints()
		_G["ColorPickerOkayButton"]:ClearAllPoints()
		_G["ColorPickerCancelButton"]:SetPoint("BOTTOMRIGHT", ColorPickerFrame, "BOTTOMRIGHT", -6, 6)
		_G["ColorPickerOkayButton"]:SetPoint("RIGHT",_G["ColorPickerCancelButton"],"LEFT", -4,0)
		_G["ReadyCheckFrameYesButton"]:SetParent(_G["ReadyCheckFrame"])
		_G["ReadyCheckFrameNoButton"]:SetParent(_G["ReadyCheckFrame"]) 
		_G["ReadyCheckFrameYesButton"]:SetPoint("RIGHT", _G["ReadyCheckFrame"], "CENTER", -1, 0)
		_G["ReadyCheckFrameNoButton"]:SetPoint("LEFT", _G["ReadyCheckFrameYesButton"], "RIGHT", 3, 0)
		_G["ReadyCheckFrameText"]:SetParent(_G["ReadyCheckFrame"])	
		_G["ReadyCheckFrameText"]:ClearAllPoints()
		_G["ReadyCheckFrameText"]:SetPoint("TOP", 0, -12)
		
		-- others
		_G["ReadyCheckListenerFrame"]:SetAlpha(0)
		_G["ReadyCheckFrame"]:HookScript("OnShow", function(self) if UnitIsUnit("player", self.initiator) then self:Hide() end end) -- bug fix, don't show it if initiator

		-- character frame fixes
--		GearManagerDialog:ClearAllPoints()
--		GearManagerDialog:SetPoint("TOPLEFT", PaperDollFrame, "TOPRIGHT", 10, 0)
end)