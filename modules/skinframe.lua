if not CalifporniaCFG["skinframe"].enable == true then return end








-- [[ Addon core ]]

local Skin = CreateFrame("Frame", nil, UIParent)
Skin:RegisterEvent("ADDON_LOADED")
Skin:SetScript("OnEvent", function(self, event, addon)	
	if addon == "CalifporniaUI" then

		-- [[ Headers ]]
		local header = {"GameMenuFrame", "InterfaceOptionsFrame", "AudioOptionsFrame", "VideoOptionsFrame", "ChatConfigFrame", "ColorPickerFrame"}
		for i = 1, getn(header) do
		local title = _G[header[i].."Header"]
			if title then
				title:SetTexture("")
				title:ClearAllPoints()
				if title == _G["GameMenuFrameHeader"] then
					title:SetPoint("TOP", GameMenuFrame, 0, 7)
				else
					title:SetPoint("TOP", header[i], 0, 0)
				end
			end
		end

		-- [[ Simple backdrops ]]
		local skins = {"AutoCompleteBox", "BNToastFrame", "TicketStatusFrameButton", "DropDownList1Backdrop", "DropDownList2Backdrop", "DropDownList1MenuBackdrop", "DropDownList2MenuBackdrop", "LFDSearchStatus", "FriendsTooltip", "GhostFrame", "GhostFrameContentsFrame", "DropDownList1MenuBackdrop", "DropDownList2MenuBackdrop", "DropDownList1Backdrop", "DropDownList2Backdrop"}

		for i = 1, getn(skins) do
			Califpornia.CreateBD(_G[skins[i]])
		end

		local shadowskins = {"StaticPopup1", "StaticPopup2", "GameMenuFrame", "InterfaceOptionsFrame", "VideoOptionsFrame", "AudioOptionsFrame", "LFDDungeonReadyStatus", "ChatConfigFrame", "AutoCompleteBox", "SpellBookFrame", "CharacterFrame", "PVPFrame", "GearManagerDialog", "WorldStateScoreFrame", "GearManagerDialogPopup", "StackSplitFrame", "AddFriendFrame", "FriendsFriendsFrame", "ColorPickerFrame", "ReadyCheckFrame", "PetStableFrame", "LFDDungeonReadyDialog", "ReputationDetailFrame", "LFDRoleCheckPopup"}

		for i = 1, getn(shadowskins) do
			Califpornia.CreateBD(_G[shadowskins[i]])
			Califpornia.CreateShadow(_G[shadowskins[i]])
		end

		local simplebds = {"SpellBookCompanionModelFrame", "PrimaryProfession1", "PrimaryProfession2", "SecondaryProfession1", "SecondaryProfession2", "SecondaryProfession3", "SecondaryProfession4", "ChatConfigCategoryFrame", "ChatConfigBackgroundFrame", "ChatConfigChatSettingsLeft", "ChatConfigChatSettingsClassColorLegend", "ChatConfigChannelSettingsLeft", "ChatConfigChannelSettingsClassColorLegend", "FriendsFriendsList"}
		for i = 1, getn(simplebds) do
			local simplebd = _G[simplebds[i]]
			if simplebd then Califpornia.CreateBD(simplebd, .25) end
		end

		for i = 1, 5 do
			local tab = _G["SpellBookSkillLineTab"..i]
			local a1, p, a2, x, y = tab:GetPoint()
			local bg = CreateFrame("Frame", nil, tab)
			bg:SetPoint("TOPLEFT", -1, 1)
			bg:SetPoint("BOTTOMRIGHT", 1, -1)
			bg:SetFrameLevel(tab:GetFrameLevel()-1)
			tab:SetPoint(a1, p, a2, x + 11, y)
--			Califpornia.CreateShadow(tab, 5, 0, 0, 0, 1, 1)
--			Califpornia.CreateShadow(tab)
			Califpornia.CreateBD(bg)
--			Califpornia.SkinButton(tab, true, false)
			select(3, tab:GetRegions()):SetTexCoord(.08, .92, .08, .92)
			select(4, tab:GetRegions()):SetTexCoord(.08, .92, .08, .92)
		end
		-- [[ Backdrop frames ]]

		FriendsBD = CreateFrame("Frame", nil, FriendsFrame)
		FriendsBD:SetPoint("TOPLEFT", 10, -30)
		FriendsBD:SetPoint("BOTTOMRIGHT", -34, 76)

		QuestBD = CreateFrame("Frame", nil, QuestLogFrame)
		QuestBD:SetPoint("TOPLEFT", 6, -9)
		QuestBD:SetPoint("BOTTOMRIGHT", -2, 6)
		QuestBD:SetFrameLevel(QuestLogFrame:GetFrameLevel()-1)

		QFBD = CreateFrame("Frame", nil, QuestFrame)
		QFBD:SetPoint("TOPLEFT", 6, -15)
		QFBD:SetPoint("BOTTOMRIGHT", -26, 64)
		QFBD:SetFrameLevel(QuestFrame:GetFrameLevel()-1)

		QDBD = CreateFrame("Frame", nil, QuestLogDetailFrame)
		QDBD:SetPoint("TOPLEFT", 6, -9)
		QDBD:SetPoint("BOTTOMRIGHT", 0, 0)
		QDBD:SetFrameLevel(QuestLogDetailFrame:GetFrameLevel()-1)

		GossipBD = CreateFrame("Frame", nil, GossipFrame)
		GossipBD:SetPoint("TOPLEFT", 6, -15)
		GossipBD:SetPoint("BOTTOMRIGHT", -26, 64)

		LFDBD = CreateFrame("Frame", nil, LFDParentFrame)
		LFDBD:SetPoint("TOPLEFT", 10, -10)
		LFDBD:SetPoint("BOTTOMRIGHT", 0, 0)

		LFRBD = CreateFrame("Frame", nil, LFRParentFrame)
		LFRBD:SetPoint("TOPLEFT", 10, -10)
		LFRBD:SetPoint("BOTTOMRIGHT", 0, 4)

		MerchBD = CreateFrame("Frame", nil, MerchantFrame)
		MerchBD:SetPoint("TOPLEFT", 10, -10)
		MerchBD:SetPoint("BOTTOMRIGHT", -34, 61)
		MerchBD:SetFrameLevel(MerchantFrame:GetFrameLevel()-1)

		MailBD = CreateFrame("Frame", nil, MailFrame)
		MailBD:SetPoint("TOPLEFT", 10, -12)
		MailBD:SetPoint("BOTTOMRIGHT", -34, 73)

		OMailBD = CreateFrame("Frame", nil, OpenMailFrame)
		OMailBD:SetPoint("TOPLEFT", 10, -12)
		OMailBD:SetPoint("BOTTOMRIGHT", -34, 73)
		OMailBD:SetFrameLevel(OpenMailFrame:GetFrameLevel()-1)

		DressBD = CreateFrame("Frame", nil, DressUpFrame)
		DressBD:SetPoint("TOPLEFT", 10, -10)
		DressBD:SetPoint("BOTTOMRIGHT", -30, 72)
		DressBD:SetFrameLevel(DressUpFrame:GetFrameLevel()-1)

		TaxiBD = CreateFrame("Frame", nil, TaxiFrame)
		TaxiBD:SetPoint("TOPLEFT", 3, -23)
		TaxiBD:SetPoint("BOTTOMRIGHT", -5, 3)
		TaxiBD:SetFrameStrata("LOW")
		TaxiBD:SetFrameLevel(TaxiFrame:GetFrameLevel()-1)

		NPCBD = CreateFrame("Frame", nil, QuestNPCModel)
		NPCBD:SetPoint("TOPLEFT", 9, -6)
		NPCBD:SetPoint("BOTTOMRIGHT", 4, -66)
		NPCBD:SetFrameLevel(QuestNPCModel:GetFrameLevel()-1)

		TradeBD = CreateFrame("Frame", nil, TradeFrame)
		TradeBD:SetPoint("TOPLEFT", 10, -12)
		TradeBD:SetPoint("BOTTOMRIGHT", -30, 52)
		TradeBD:SetFrameLevel(TradeFrame:GetFrameLevel()-1)

		ItemBD = CreateFrame("Frame", nil, ItemTextFrame)
		ItemBD:SetPoint("TOPLEFT", 16, -8)
		ItemBD:SetPoint("BOTTOMRIGHT", -28, 62)
		ItemBD:SetFrameLevel(ItemTextFrame:GetFrameLevel()-1)

		TabardBD = CreateFrame("Frame", nil, TabardFrame)
		TabardBD:SetPoint("TOPLEFT", 16, -8)
		TabardBD:SetPoint("BOTTOMRIGHT", -28, 76)
		TabardBD:SetFrameLevel(TabardFrame:GetFrameLevel()-1)

		local FrameBDs = {"FriendsBD", "QuestBD", "QFBD", "QDBD", "GossipBD", "LFDBD", "LFRBD", "MerchBD", "MailBD", "OMailBD", "DressBD", "TaxiBD", "TradeBD", "ItemBD", "TabardBD"}
		for i = 1, getn(FrameBDs) do
			FrameBD = _G[FrameBDs[i]]
			if FrameBD then
				Califpornia.CreateBD(FrameBD)
				Califpornia.CreateShadow(FrameBD)
			end
		end

		Califpornia.CreateBD(NPCBD)

		if Califpornia.myclass == "HUNTER" or Califpornia.myclass == "MAGE" or Califpornia.myclass == "DEATHKNIGHT" or Califpornia.myclass == "WARLOCK" then
			if Califpornia.myclass == "HUNTER" then
				for i = 1, 10 do
					local bd = CreateFrame("Frame", nil, _G["PetStableStabledPet"..i])
					bd:SetPoint("TOPLEFT", -1, 1)
					bd:SetPoint("BOTTOMRIGHT", 1, -1)
					Califpornia.CreateBD(bd)
					bd:SetBackdropColor(0, 0, 0, 0)
					_G["PetStableStabledPet"..i]:SetNormalTexture("")
					_G["PetStableStabledPet"..i]:GetRegions():SetTexCoord(.08, .92, .08, .92)
				end
			end

			PetModelFrameShadowOverlay:Hide()
			PetPaperDollFrameExpBar:GetRegions():Hide()
			select(2, PetPaperDollFrameExpBar:GetRegions()):Hide()
			PetPaperDollFrameExpBar:SetStatusBarTexture(Califpornia.CFG.media.normTex)

			local bbg = CreateFrame("Frame", nil, PetPaperDollFrameExpBar)
			bbg:SetPoint("TOPLEFT", -1, 1)
			bbg:SetPoint("BOTTOMRIGHT", 1, -1)
			bbg:SetFrameLevel(PetPaperDollFrameExpBar:GetFrameLevel()-1)
			Califpornia.CreateBD(bbg)
		end

		-- [[ Hide regions ]]

		select(3, CharacterFrame:GetRegions()):Hide()
		for i = 1, 5 do
			select(i, CharacterModelFrame:GetRegions()):Hide()
		end
		for i = 1, 3 do
			select(i, QuestLogFrame:GetRegions()):Hide()
		end
		QuestLogDetailFrame:GetRegions():Hide()
		QuestFrame:GetRegions():Hide()
		GossipFrame:GetRegions():Hide()
		for i = 1, 6 do
			for j = 1, 3 do
				select(i, _G["FriendsTabHeaderTab"..j]:GetRegions()):Hide()
				select(i, _G["FriendsTabHeaderTab"..j]:GetRegions()).Show = Califpornia.dummy
			end
		end
		select(6, FriendsFrame:GetRegions()):Hide()
		select(3, SpellBookFrame:GetRegions()):Hide()
		SpellBookCompanionModelFrameShadowOverlay:Hide()
		select(3, PVPFrame:GetRegions()):Hide()
		LFRParentFrame:GetRegions():Hide()
		for i = 1, 5 do
			select(i, MailFrame:GetRegions()):Hide()
		end
		OpenMailFrame:GetRegions():Hide()
		select(12, OpenMailFrame:GetRegions()):Hide()
		select(13, OpenMailFrame:GetRegions()):Hide()
		for i = 4, 7 do
			select(i, SendMailFrame:GetRegions()):Hide()
		end
		MerchantFrame:GetRegions():Hide()
		DressUpFrame:GetRegions():Hide()
		select(2, DressUpFrame:GetRegions()):Hide()
		for i = 8, 11 do
			select(i, DressUpFrame:GetRegions()):Hide()
		end
		select(6, TaxiFrame:GetRegions()):Hide()
		TradeFrame:GetRegions():Hide()
		select(2, TradeFrame:GetRegions()):Hide()
		for i = 1, 4 do
			select(i, GearManagerDialogPopup:GetRegions()):Hide()
		end
		StackSplitFrame:GetRegions():Hide()
		ItemTextFrame:GetRegions():Hide()
		select(3, ItemTextScrollFrame:GetRegions()):Hide()
		select(3, PetStableFrame:GetRegions()):Hide()
		select(4, ReputationDetailFrame:GetRegions()):Hide()
		select(5, ReputationDetailFrame:GetRegions()):Hide()
		select(2, QuestNPCModel:GetRegions()):Hide()
		QuestNPCModel:SetPoint("LEFT", QuestLogDetailWindow, "RIGHT", 10, 10)
		TabardFrame:GetRegions():Hide()
		BNToastFrameCloseButton:SetAlpha(0)
		PetStableModelShadow:Hide()
		LFDParentFramePortrait:Hide()

		local slots = {
			"Head", "Neck", "Shoulder", "Shirt", "Chest", "Waist", "Legs", "Feet", "Wrist",
			"Hands", "Finger0", "Finger1", "Trinket0", "Trinket1", "Back", "MainHand",
			"SecondaryHand", "Ranged", "Tabard",
		}

		for i = 1, getn(slots) do
			_G["Character"..slots[i].."Slot"]:SetNormalTexture("")
			_G["Character"..slots[i].."Slot"]:GetRegions():SetTexCoord(.08, .92, .08, .92)
			local bd = CreateFrame("Frame", nil, _G["Character"..slots[i].."Slot"])
			bd:SetPoint("TOPLEFT", -1, 1)
			bd:SetPoint("BOTTOMRIGHT", 1, -1)
			Califpornia.CreateBD(bd)
			bd:SetBackdropColor(0, 0, 0, 0)
		end

		-- reputation bars
		for i=1, NUM_FACTIONS_DISPLAYED, 1 do
			_G["ReputationBar"..i.."ReputationBar"]:SetStatusBarTexture(Califpornia.CFG.media.normTex)
			local bbg = CreateFrame("Frame", nil, _G["ReputationBar"..i.."ReputationBar"])
			bbg:SetPoint("TOPLEFT", -1, 1)
			bbg:SetPoint("BOTTOMRIGHT", 1, -1)
			bbg:SetFrameLevel(_G["ReputationBar"..i.."ReputationBar"]:GetFrameLevel()-1)
			Califpornia.CreateBD(bbg)
		end

		Califpornia.SkinUIButton(_G["ReadyCheckFrameYesButton"])
		Califpornia.SkinUIButton(_G["ReadyCheckFrameNoButton"])
		_G["ReadyCheckFrameYesButton"]:SetParent(_G["ReadyCheckFrame"])
		_G["ReadyCheckFrameNoButton"]:SetParent(_G["ReadyCheckFrame"]) 
		_G["ReadyCheckFrameYesButton"]:SetPoint("RIGHT", _G["ReadyCheckFrame"], "CENTER", -1, 0)
		_G["ReadyCheckFrameNoButton"]:SetPoint("LEFT", _G["ReadyCheckFrameYesButton"], "RIGHT", 3, 0)
		_G["ReadyCheckFrameText"]:SetParent(_G["ReadyCheckFrame"])	
		_G["ReadyCheckFrameText"]:ClearAllPoints()
		_G["ReadyCheckFrameText"]:SetPoint("TOP", 0, -12)
		
		-- others
		_G["ReadyCheckListenerFrame"]:SetAlpha(0)
		_G["ReadyCheckFrame"]:HookScript("OnShow", function(self) if UnitIsUnit("player", self.initiator) then self:Hide() end end)

		-- [[ Text colour functions ]]

		NORMAL_QUEST_DISPLAY = "|cffffffff%s|r"
		TRIVIAL_QUEST_DISPLAY = "|cffffffff%s (low level)|r"

		local newquestcolor = function(template, parentFrame, acceptButton, material)
			QuestInfoTitleHeader:SetTextColor(1, 1, 1);
			QuestInfoDescriptionHeader:SetTextColor(1, 1, 1);
			QuestInfoObjectivesHeader:SetTextColor(1, 1, 1);
			QuestInfoRewardsHeader:SetTextColor(1, 1, 1);
			-- other text
			QuestInfoDescriptionText:SetTextColor(1, 1, 1);
			QuestInfoObjectivesText:SetTextColor(1, 1, 1);
			QuestInfoGroupSize:SetTextColor(1, 1, 1);
			QuestInfoRewardText:SetTextColor(1, 1, 1);
			-- reward frame text
			QuestInfoItemChooseText:SetTextColor(1, 1, 1);
			QuestInfoItemReceiveText:SetTextColor(1, 1, 1);
			QuestInfoSpellLearnText:SetTextColor(1, 1, 1);		
			QuestInfoXPFrameReceiveText:SetTextColor(1, 1, 1);

			local numObjectives = GetNumQuestLeaderBoards();
			local objective;
			local text, type, finished;
			local numVisibleObjectives = 0;
			for i = 1, numObjectives do
				text, type, finished = GetQuestLogLeaderBoard(i);
				if (type ~= "spell") then
					numVisibleObjectives = numVisibleObjectives+1;
					objective = _G["QuestInfoObjective"..numVisibleObjectives];
					objective:SetTextColor(1, 1, 1);
				end
			end
		end

		local newgossipcolor = function()
			GossipGreetingText:SetTextColor(1, 1, 1)
		end
		function QuestFrame_SetTitleTextColor(fontString)
			fontString:SetTextColor(1, 1, 1)
		end

		function QuestFrame_SetTextColor(fontString)
			fontString:SetTextColor(1, 1, 1);
		end

		function GossipFrameOptionsUpdate(...)
			local titleButton;
			local titleIndex = 1;
			local titleButtonIcon;
			for i=1, select("#", ...), 2 do
				if ( GossipFrame.buttonIndex > NUMGOSSIPBUTTONS ) then
					message("This NPC has too many quests and/or gossip options.");
				end
				titleButton = _G["GossipTitleButton" .. GossipFrame.buttonIndex];
				titleButton:SetFormattedText("|cffffffff%s|r", select(i, ...));
				GossipResize(titleButton);
				titleButton:SetID(titleIndex);
				titleButton.type="Gossip";
				titleButtonIcon = _G[titleButton:GetName() .. "GossipIcon"];
				titleButtonIcon:SetTexture("Interface\\GossipFrame\\" .. select(i+1, ...) .. "GossipIcon");
				titleButtonIcon:SetVertexColor(1, 1, 1, 1);
				GossipFrame.buttonIndex = GossipFrame.buttonIndex + 1;
				titleIndex = titleIndex + 1;
				titleButton:Show();
			end
		end

		local newspellbookcolor = function(self)
			local slot, slotType = SpellBook_GetSpellBookSlot(self);
			local name = self:GetName();
			-- local spellString = _G[name.."SpellName"];
			local subSpellString = _G[name.."SubSpellName"]

			-- spellString:SetTextColor(1, 1, 1)
			subSpellString:SetTextColor(1, 1, 1)
			if slotType == "FUTURESPELL" then
				local level = GetSpellAvailableLevel(slot, SpellBookFrame.bookType)
				if (level and level > UnitLevel("player")) then
					self.RequiredLevelString:SetTextColor(.7, .7, .7)
					self.SpellName:SetTextColor(.7, .7, .7)
					subSpellString:SetTextColor(.7, .7, .7)
				end
			end
		end

		local newprofcolor = function(frame, index)
			if index then
				local rank = GetProfessionInfo(index)
				-- frame.rank:SetTextColor(1, 1, 1)
				frame.professionName:SetTextColor(1, 1, 1)
			else
				frame.missingText:SetTextColor(1, 1, 1)
				frame.missingHeader:SetTextColor(1, 1, 1)
			end
		end

		local newprofbuttoncolor = function(self)
			self.spellString:SetTextColor(1, 1, 1);	
			self.subSpellString:SetTextColor(1, 1, 1)
		end	
	
		ItemTextFrame:HookScript("OnEvent", function(self, event, ...)
			if event == "ITEM_TEXT_BEGIN" then
				ItemTextTitleText:SetText(ItemTextGetItem())
				ItemTextScrollFrame:Hide()
				ItemTextCurrentPage:Hide()
				ItemTextStatusBar:Hide()
				ItemTextPrevPageButton:Hide()
				ItemTextNextPageButton:Hide()
				ItemTextPageText:SetTextColor(1, 1, 1)
				return
			end
		end)

		function PaperDollFrame_SetLevel()
			local primaryTalentTree = GetPrimaryTalentTree()
			local classDisplayName, class = UnitClass("player")
			local classColor = Califpornia.colors.class_colors[class]
			local classColorString = format("ff%.2x%.2x%.2x", classColor.r * 255, classColor.g * 255, classColor.b * 255)
			local specName

			if (primaryTalentTree) then
				_, specName = GetTalentTabInfo(primaryTalentTree);
			end

			if (specName and specName ~= "") then
				CharacterLevelText:SetFormattedText(PLAYER_LEVEL, UnitLevel("player"), classColorString, specName, classDisplayName);
			else
				CharacterLevelText:SetFormattedText(PLAYER_LEVEL_NO_SPEC, UnitLevel("player"), classColorString, classDisplayName);
			end
		end

		hooksecurefunc("QuestInfo_Display", newquestcolor)
		hooksecurefunc("GossipFrameUpdate", newgossipcolor)
		hooksecurefunc("SpellButton_UpdateButton", newspellbookcolor)
		hooksecurefunc("FormatProfession", newprofcolor)
		hooksecurefunc("UpdateProfessionButton", newprofbuttoncolor)

		-- [[ Change positions ]]

		ChatConfigFrameDefaultButton:SetWidth(125)
		ChatConfigFrameDefaultButton:ClearAllPoints()
		ChatConfigFrameDefaultButton:SetPoint("TOP", ChatConfigCategoryFrame, "BOTTOM", 0, -4)
		ChatConfigFrameOkayButton:ClearAllPoints()
		ChatConfigFrameOkayButton:SetPoint("TOPRIGHT", ChatConfigBackgroundFrame, "BOTTOMRIGHT", 0, -4)

		_G["VideoOptionsFrameCancel"]:ClearAllPoints()
		_G["VideoOptionsFrameCancel"]:SetPoint("RIGHT",_G["VideoOptionsFrameApply"],"LEFT",-4,0)		 
		_G["VideoOptionsFrameOkay"]:ClearAllPoints()
		_G["VideoOptionsFrameOkay"]:SetPoint("RIGHT",_G["VideoOptionsFrameCancel"],"LEFT",-4,0)	
		_G["AudioOptionsFrameOkay"]:ClearAllPoints()
		_G["AudioOptionsFrameOkay"]:SetPoint("RIGHT",_G["AudioOptionsFrameCancel"],"LEFT",-4,0)		 	 
		_G["InterfaceOptionsFrameOkay"]:ClearAllPoints()
		_G["InterfaceOptionsFrameOkay"]:SetPoint("RIGHT",_G["InterfaceOptionsFrameCancel"],"LEFT", -4,0)

		GearManagerDialog:ClearAllPoints()
		GearManagerDialog:SetPoint("TOPLEFT", PaperDollFrame, "TOPRIGHT", 10, 0)

		QuestLogFrameShowMapButton:Hide()
		QuestLogFrameShowMapButton.Show = Califpornia.dummy

		local questlogcontrolpanel = function()
			local parent
			if QuestLogFrame:IsShown() then
				parent = QuestLogFrame
				QuestLogControlPanel:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", 9, 6)
			elseif QuestLogDetailFrame:IsShown() then
				parent = QuestLogDetailFrame
				QuestLogControlPanel:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", 9, 0)
			end
		end

		hooksecurefunc("QuestLogControlPanel_UpdatePosition", questlogcontrolpanel)

		QuestLogFramePushQuestButton:ClearAllPoints()
		QuestLogFramePushQuestButton:SetPoint("LEFT", QuestLogFrameAbandonButton, "RIGHT", 1, 0)
		QuestLogFramePushQuestButton:SetWidth(100)
		QuestLogFrameTrackButton:ClearAllPoints()
		QuestLogFrameTrackButton:SetPoint("LEFT", QuestLogFramePushQuestButton, "RIGHT", 1, 0)

		FriendsFrameStatusDropDown:ClearAllPoints()
		FriendsFrameStatusDropDown:SetPoint("TOPLEFT", FriendsFrame, "TOPLEFT", 10, -40)
		FriendsFrameCloseButton:ClearAllPoints()
		FriendsFrameCloseButton:SetPoint("LEFT", FriendsFrameBroadcastInput, "RIGHT", 20, 0)

		RaidFrameConvertToRaidButton:ClearAllPoints()
		RaidFrameConvertToRaidButton:SetPoint("TOPLEFT", FriendsFrame, "TOPLEFT", 30, -44)
		RaidFrameRaidInfoButton:ClearAllPoints()
		RaidFrameRaidInfoButton:SetPoint("TOPRIGHT", FriendsFrame, "TOPRIGHT", -70, -44)

		TaxiFrameCloseButton:ClearAllPoints()
		TaxiFrameCloseButton:SetPoint("TOPRIGHT", TaxiRouteMap, "TOPRIGHT")

		local a1, p, a2, x, y = ReputationDetailFrame:GetPoint()
		ReputationDetailFrame:SetPoint(a1, p, a2, x + 10, y)

		-- [[ Tabs ]]
		for i = 1, 5 do
			Califpornia.SkinUITab(_G["SpellBookFrameTabButton"..i])
		end

		for i = 1, 4 do
			Califpornia.SkinUITab(_G["FriendsFrameTab"..i])
			if _G["CharacterFrameTab"..i] then
				Califpornia.SkinUITab(_G["CharacterFrameTab"..i])
			end
		end

		for i = 1, 3 do
			Califpornia.SkinUITab(_G["PVPFrameTab"..i])
			Califpornia.SkinUITab(_G["WorldStateScoreFrameTab"..i])
		end

		for i = 1, 2 do
			Califpornia.SkinUITab(_G["LFRParentFrameTab"..i])
			Califpornia.SkinUITab(_G["MerchantFrameTab"..i])
			Califpornia.SkinUITab(_G["MailFrameTab"..i])
		end

		-- [[ Buttons ]]

		for i = 1, 3 do
			for j = 1, 3 do
				Califpornia.SkinUIButton(_G["StaticPopup"..i.."Button"..j])
			end
		end

		local buttons = {"VideoOptionsFrameOkay", "VideoOptionsFrameCancel", "VideoOptionsFrameDefaults", "VideoOptionsFrameApply", "AudioOptionsFrameOkay", "AudioOptionsFrameCancel", "AudioOptionsFrameDefaults", "InterfaceOptionsFrameDefaults", "InterfaceOptionsFrameOkay", "InterfaceOptionsFrameCancel", "ChatConfigFrameOkayButton", "ChatConfigFrameDefaultButton", "DressUpFrameCancelButton", "DressUpFrameResetButton", "WhoFrameWhoButton", "WhoFrameAddFriendButton", "WhoFrameGroupInviteButton", "GearManagerDialogDeleteSet", "GearManagerDialogEquipSet", "GearManagerDialogSaveSet", "SendMailMailButton", "SendMailCancelButton", "OpenMailReplyButton", "OpenMailDeleteButton", "OpenMailCancelButton", "OpenMailReportSpamButton", "aMailButton", "QuestLogFrameAbandonButton", "QuestLogFramePushQuestButton", "QuestLogFrameTrackButton", "QuestLogFrameCancelButton", "QuestFrameAcceptButton", "QuestFrameDeclineButton", "QuestFrameCompleteQuestButton", "QuestFrameCompleteButton", "QuestFrameGoodbyeButton", "GossipFrameGreetingGoodbyeButton", "QuestFrameGreetingGoodbyeButton", "ChannelFrameDaughterFrameCancelButton", "ChannelFrameDaughterFrameOkayButton", "ChannelFrameNewButton", "RaidFrameRaidInfoButton", "RaidFrameConvertToRaidButton", "TradeFrameTradeButton", "TradeFrameCancelButton", "GearManagerDialogPopupOkay", "GearManagerDialogPopupCancel", "StackSplitOkayButton", "StackSplitCancelButton", "TabardFrameAcceptButton", "TabardFrameCancelButton", "GameMenuButtonOptions", "GameMenuButtonSoundOptions", "GameMenuButtonUIOptions", "GameMenuButtonKeybindings", "GameMenuButtonMacros", "GameMenuButtonAddOns", "GameMenuButtonLogout", "GameMenuButtonQuit", "GameMenuButtonContinue", "GameMenuButtonMacOptions", "FriendsFrameAddFriendButton", "FriendsFrameSendMessageButton", "LFDQueueFrameFindGroupButton", "LFDQueueFrameCancelButton", "LFRQueueFrameFindGroupButton", "LFRQueueFrameAcceptCommentButton", "PVPFrameLeftButton", "PVPHonorFrameWarGameButton", "PVPFrameRightButton", "RaidFrameNotInRaidRaidBrowserButton", "WorldStateScoreFrameLeaveButton", "SpellBookCompanionSummonButton", "AddFriendEntryFrameAcceptButton", "AddFriendEntryFrameCancelButton", "FriendsFriendsSendRequestButton", "FriendsFriendsCloseButton", "ColorPickerOkayButton", "ColorPickerCancelButton", "FriendsFrameIgnorePlayerButton", "FriendsFrameUnsquelchButton", "LFDDungeonReadyDialogEnterDungeonButton", "LFDDungeonReadyDialogLeaveQueueButton", "LFRBrowseFrameSendMessageButton", "LFRBrowseFrameInviteButton", "LFRBrowseFrameRefreshButton", "LFDRoleCheckPopupAcceptButton", "LFDRoleCheckPopupDeclineButton", "GuildInviteFrameJoinButton", "GuildInviteFrameDeclineButton", "FriendsFramePendingButton1AcceptButton", "FriendsFramePendingButton1DeclineButton"}
		for i = 1, getn(buttons) do
		local reskinbutton = _G[buttons[i]]
			if reskinbutton then
				Califpornia.SkinUIButton(reskinbutton)
			end
		end

	-- [[ Load on Demand Addons ]]

	elseif addon == "Blizzard_ArchaeologyUI" then
		Califpornia.CreateBD(ArchaeologyFrame)
		Califpornia.CreateShadow(ArchaeologyFrame)
		Califpornia.SkinUIButton(ArchaeologyFrameArtifactPageSolveFrameSolveButton)
		Califpornia.SkinUIButton(ArchaeologyFrameArtifactPageBackButton)
		select(3, ArchaeologyFrame:GetRegions()):Hide()
		ArchaeologyFrameSummaryPage:GetRegions():SetTextColor(1, 1, 1)
		ArchaeologyFrameArtifactPage:GetRegions():SetTextColor(1, 1, 1)
		ArchaeologyFrameArtifactPageHistoryScrollChild:GetRegions():SetTextColor(1, 1, 1)
		ArchaeologyFrameHelpPage:GetRegions():SetTextColor(1, 1, 1)
		select(5, ArchaeologyFrameHelpPage:GetRegions()):SetTextColor(1, 1, 1)
		ArchaeologyFrameHelpPageHelpScrollHelpText:SetTextColor(1, 1, 1)
		ArchaeologyFrameCompletedPage:GetRegions():SetTextColor(1, 1, 1)
		select(2, ArchaeologyFrameCompletedPage:GetRegions()):SetTextColor(1, 1, 1)
		select(5, ArchaeologyFrameCompletedPage:GetRegions()):SetTextColor(1, 1, 1)
		select(8, ArchaeologyFrameCompletedPage:GetRegions()):SetTextColor(1, 1, 1)
		select(11, ArchaeologyFrameCompletedPage:GetRegions()):SetTextColor(1, 1, 1)
		for i = 1, 10 do
			_G["ArchaeologyFrameSummaryPageRace"..i]:GetRegions():SetTextColor(1, 1, 1)
		end
		for i = 1, ARCHAEOLOGY_MAX_COMPLETED_SHOWN do
			local bu = _G["ArchaeologyFrameCompletedPageArtifact"..i]
			bu:GetRegions():Hide()
			select(2, bu:GetRegions()):Hide()
			select(3, bu:GetRegions()):SetTexCoord(.08, .92, .08, .92)
			select(4, bu:GetRegions()):SetTextColor(1, 1, 1)
			select(5, bu:GetRegions()):SetTextColor(1, 1, 1)
			local bg = CreateFrame("Frame", nil, bu)
			bg:SetPoint("TOPLEFT", -1, 1)
			bg:SetPoint("BOTTOMRIGHT", 1, -1)
			bg:SetFrameLevel(bu:GetFrameLevel()-1)
			Califpornia.CreateBD(bg, .25)
			local vline = CreateFrame("Frame", nil, bu)
			vline:SetPoint("LEFT", 44, 0)
			vline:SetSize(1, 44)
			Califpornia.CreateBD(vline)
		end
	elseif addon == "Blizzard_AuctionUI" then
		local AuctionBD = CreateFrame("Frame", nil, AuctionFrame)
		AuctionBD:SetPoint("TOPLEFT", 2, -10)
		AuctionBD:SetPoint("BOTTOMRIGHT", 0, 10)
		AuctionBD:SetFrameStrata("MEDIUM")
		Califpornia.CreateBD(AuctionBD)
		Califpornia.CreateShadow(AuctionBD)
		Califpornia.CreateBD(AuctionProgressFrame)
		Califpornia.CreateShadow(AuctionProgressFrame)
		AuctionDressUpFrame:ClearAllPoints()
		AuctionDressUpFrame:SetPoint("LEFT", AuctionFrame, "RIGHT", 10, 0)
		Califpornia.CreateBD(AuctionDressUpFrame)
		Califpornia.CreateShadow(AuctionDressUpFrame)

		local ABBD = CreateFrame("Frame", nil, AuctionProgressBar)
		ABBD:SetPoint("TOPLEFT", -1, 1)
		ABBD:SetPoint("BOTTOMRIGHT", 1, -1)
		ABBD:SetFrameLevel(AuctionProgressBar:GetFrameLevel()-1)
		Califpornia.CreateBD(ABBD, .25)

		AuctionFrame:GetRegions():Hide()
		for i = 1, 4 do
			select(i, AuctionProgressFrame:GetRegions()):Hide()
		end
		select(2, AuctionProgressBar:GetRegions()):Hide()
		for i = 1, 4 do
			select(i, AuctionDressUpFrame:GetRegions()):Hide()
		end
		for i = 1, 3 do
			Califpornia.SkinUITab(_G["AuctionFrameTab"..i])
		end
		local abuttons = {"BrowseBidButton", "BrowseBuyoutButton", "BrowseCloseButton", "BrowseSearchButton", "BrowseResetButton", "BidBidButton", "BidBuyoutButton", "BidCloseButton", "AuctionsCloseButton", "AuctionDressUpFrameResetButton", "AuctionsCancelAuctionButton", "AuctionsCreateAuctionButton", "AuctionsNumStacksMaxButton", "AuctionsStackSizeMaxButton"}
		for i = 1, getn(abuttons) do
			local reskinbutton = _G[abuttons[i]]
			if reskinbutton then
				Califpornia.SkinUIButton(reskinbutton)
			end
		end

		BrowseBuyoutButton:ClearAllPoints()
		BrowseBuyoutButton:SetPoint("RIGHT", BrowseCloseButton, "LEFT", -1, 0)
		BrowseBidButton:ClearAllPoints()
		BrowseBidButton:SetPoint("RIGHT", BrowseBuyoutButton, "LEFT", -1, 0)
		BidBuyoutButton:ClearAllPoints()
		BidBuyoutButton:SetPoint("RIGHT", BidCloseButton, "LEFT", -1, 0)
		BidBidButton:ClearAllPoints()
		BidBidButton:SetPoint("RIGHT", BidBuyoutButton, "LEFT", -1, 0)
		AuctionsCancelAuctionButton:ClearAllPoints()
		AuctionsCancelAuctionButton:SetPoint("RIGHT", AuctionsCloseButton, "LEFT", -1, 0)
	elseif addon == "Blizzard_AchievementUI" then
		Califpornia.CreateBD(AchievementFrame)
		Califpornia.CreateShadow(AchievementFrame)
		for i = 1, 13 do
			select(i, AchievementFrame:GetRegions()):Hide()
		end
		AchievementFrameSummary:GetRegions():Hide()
		for i = 1, 4 do
			select(i, AchievementFrameHeader:GetRegions()):Hide()
		end
		AchievementFrameHeader:ClearAllPoints()
		AchievementFrameHeader:SetPoint("TOP", AchievementFrame, "TOP", 0, 40)
		AchievementFrameFilterDropDown:ClearAllPoints()
		AchievementFrameFilterDropDown:SetPoint("RIGHT", AchievementFrameHeader, "RIGHT", -120, -1)
		for i = 1, 3 do
			if _G["AchievementFrameTab"..i] then
				for j = 1, 6 do
					select(j, _G["AchievementFrameTab"..i]:GetRegions()):Hide()
					select(j, _G["AchievementFrameTab"..i]:GetRegions()).Show = Califpornia.dummy
				end
				local sd = CreateFrame("Frame", nil, _G["AchievementFrameTab"..i])
				sd:SetPoint("TOPLEFT", 6, -4)
				sd:SetPoint("BOTTOMRIGHT", -6, -2)
				sd:SetFrameStrata("LOW")
				sd:SetBackdrop({
					bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
					edgeFile = CalifporniaCFG.media.glowTex,
					edgeSize = 5,
					insets = { left = 5, right = 5, top = 5, bottom = 5 },
				})
				sd:SetBackdropColor(0, 0, 0, .5)
				sd:SetBackdropBorderColor(0, 0, 0)
			end
		end
	elseif addon == "Blizzard_BindingUI" then
		local BindingBD = CreateFrame("Frame", nil, KeyBindingFrame)
		BindingBD:SetPoint("TOPLEFT", 2, 0)
		BindingBD:SetPoint("BOTTOMRIGHT", -38, 10)
		BindingBD:SetFrameLevel(KeyBindingFrame:GetFrameLevel()-1)
		Califpornia.CreateBD(BindingBD)
		Califpornia.CreateShadow(BindingBD)
		KeyBindingFrameHeader:SetTexture("")
		Califpornia.SkinUIButton(KeyBindingFrameDefaultButton)
		Califpornia.SkinUIButton(KeyBindingFrameUnbindButton)
		Califpornia.SkinUIButton(KeyBindingFrameOkayButton)
		Califpornia.SkinUIButton(KeyBindingFrameCancelButton)
		KeyBindingFrameOkayButton:ClearAllPoints()
		KeyBindingFrameOkayButton:SetPoint("RIGHT", KeyBindingFrameCancelButton, "LEFT", -1, 0)
		KeyBindingFrameUnbindButton:ClearAllPoints()
		KeyBindingFrameUnbindButton:SetPoint("RIGHT", KeyBindingFrameOkayButton, "LEFT", -1, 0)
	elseif addon == "Blizzard_Calendar" then
		for i = 1, 15 do
			if i ~= 10 and i ~= 11 and i ~= 12 and i ~= 13 and i ~= 14 then select(i, CalendarViewEventFrame:GetRegions()):Hide() end
		end
		for i = 1, 9 do
			select(i, CalendarViewHolidayFrame:GetRegions()):Hide()
			select(i, CalendarViewRaidFrame:GetRegions()):Hide()
		end
		for i = 1, 3 do
			select(i, CalendarViewEventTitleFrame:GetRegions()):Hide()
			select(i, CalendarViewHolidayTitleFrame:GetRegions()):Hide()
			select(i, CalendarViewRaidTitleFrame:GetRegions()):Hide()
		end
		CalendarViewEventInviteListSection:GetRegions():Hide()
		CalendarViewEventInviteList:GetRegions():Hide()
		CalendarViewEventDescriptionContainer:GetRegions():Hide()
		select(5, CalendarViewEventCloseButton:GetRegions()):Hide()
		select(5, CalendarViewHolidayCloseButton:GetRegions()):Hide()
		select(5, CalendarViewRaidCloseButton:GetRegions()):Hide()
		local CalBD = CreateFrame("Frame", nil, CalendarFrame)
		CalBD:SetPoint("TOPLEFT", 11, 0)
		CalBD:SetPoint("BOTTOMRIGHT", -9, 3)
		CalBD:SetFrameStrata("MEDIUM")
		Califpornia.CreateBD(CalBD)
		Califpornia.CreateShadow(CalBD)
		Califpornia.CreateBD(CalendarViewEventFrame)
		Califpornia.CreateShadow(CalendarViewEventFrame)
		Califpornia.CreateBD(CalendarViewHolidayFrame)
		Califpornia.CreateShadow(CalendarViewHolidayFrame)
		Califpornia.CreateBD(CalendarViewRaidFrame)
		Califpornia.CreateShadow(CalendarViewRaidFrame)
		Califpornia.CreateBD(CalendarViewEventInviteList, .25)
		Califpornia.CreateBD(CalendarViewEventDescriptionContainer, .25)
		-- No, I don't have a better way to do this
		for i = 1, 6 do
			local vline = CreateFrame("Frame", nil, _G["CalendarDayButton"..i])
			vline:SetHeight(546)
			vline:SetWidth(1)
			vline:SetPoint("TOP", _G["CalendarDayButton"..i], "TOPRIGHT")
			Califpornia.CreateBD(vline)
		end
		for i = 1, 36, 7 do
			local hline = CreateFrame("Frame", nil, _G["CalendarDayButton"..i])
			hline:SetWidth(637)
			hline:SetHeight(1)
			hline:SetPoint("LEFT", _G["CalendarDayButton"..i], "TOPLEFT")
			Califpornia.CreateBD(hline)
		end
		local cbuttons = { "CalendarViewEventAcceptButton", "CalendarViewEventTentativeButton", "CalendarViewEventDeclineButton", "CalendarViewEventRemoveButton" }
		for i = 1, getn(cbuttons) do
		local cbutton = _G[cbuttons[i]]
			if cbutton then
				Califpornia.SkinUIButton(cbutton)
			end
		end
		CalendarCloseButton:ClearAllPoints()
		CalendarCloseButton:SetPoint("TOPRIGHT", CalBD, "TOPRIGHT")
	elseif addon == "Blizzard_GlyphUI" then
		GlyphFrame:GetRegions():Hide()
	elseif addon == "Blizzard_GuildUI" then
		Califpornia.CreateBD(GuildFrame)
		Califpornia.CreateShadow(GuildFrame)
		Califpornia.CreateBD(GuildMemberDetailFrame)
		Califpornia.CreateShadow(GuildMemberDetailFrame)
		Califpornia.CreateBD(GuildMemberNoteBackground, .25)
		Califpornia.CreateBD(GuildMemberOfficerNoteBackground, .25)
		Califpornia.CreateBD(GuildLogFrame)
		Califpornia.CreateShadow(GuildLogFrame)
		Califpornia.CreateBD(GuildLogContainer, .25)
		Califpornia.CreateBD(GuildNewsFiltersFrame)
		Califpornia.CreateShadow(GuildNewsFiltersFrame)
		Califpornia.CreateBD(GuildTextEditFrame)
		Califpornia.CreateShadow(GuildTextEditFrame)
		Califpornia.CreateBD(GuildTextEditContainer)
		for i = 1, 5 do
			Califpornia.SkinUITab(_G["GuildFrameTab"..i])
		end
		select(18, GuildFrame:GetRegions()):Hide()
		select(21, GuildFrame:GetRegions()):Hide()
		select(22, GuildFrame:GetRegions()):Hide()
		select(5, GuildInfoFrame:GetRegions()):Hide()
		select(11, GuildMemberDetailFrame:GetRegions()):Hide()
		select(12, GuildMemberDetailFrame:GetRegions()):Hide()
		for i = 1, 9 do
			select(i, GuildLogFrame:GetRegions()):Hide()
			select(i, GuildNewsFiltersFrame:GetRegions()):Hide()
			select(i, GuildTextEditFrame:GetRegions()):Hide()
		end
		select(2, GuildNewPerksFrame:GetRegions()):Hide()
		select(3, GuildNewPerksFrame:GetRegions()):Hide()
		GuildAllPerksFrame:GetRegions():Hide()
		GuildNewsFrame:GetRegions():Hide()
		GuildRewardsFrame:GetRegions():Hide()
		GuildNewsFiltersFrame:ClearAllPoints()
		GuildNewsFiltersFrame:SetPoint("TOPLEFT", GuildFrame, "TOPRIGHT", 10, -10)
		GuildMemberDetailFrame:ClearAllPoints()
		GuildMemberDetailFrame:SetPoint("TOPLEFT", GuildFrame, "TOPRIGHT", 10, -10)
		GuildLevelFrame:SetAlpha(0)
		Califpornia.SkinUIButton(GuildMemberGroupInviteButton)
		Califpornia.SkinUIButton(GuildMemberRemoveButton)
		local closebutton = select(4, GuildTextEditFrame:GetChildren())
		Califpornia.SkinUIButton(closebutton)
		local logbutton = select(3, GuildLogFrame:GetChildren())
		Califpornia.SkinUIButton(logbutton)
		local gbuttons = {"GuildAddMemberButton", "GuildViewLogButton", "GuildControlButton", "GuildTextEditFrameAcceptButton"}
		for i = 1, getn(gbuttons) do
		local gbutton = _G[gbuttons[i]]
			if gbutton then
				Califpornia.SkinUIButton(gbutton)
			end
		end
		-- guild xp
		for i = 1, 3, 1 do
			select(i, GuildXPBar:GetRegions()):Hide()
		end
		_G["GuildXPBarProgress"]:SetTexture(Califpornia.CFG.media.normTex)
		_G["GuildXPBarCap"]:SetTexture(Califpornia.CFG.media.normTex)
		for i = 1, 4 do
			_G["GuildXPBarDivider"..i]:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
--			_G["GuildXPBarDivider"..i]:SetWidth(12)
			_G["GuildXPBarDivider"..i]:SetBlendMode("ADD")
		end
		-- guild rep
		for i = 2, 4, 1 do
			select(i, GuildFactionBar:GetRegions()):Hide()
		end
		GuildFactionBar:SetStatusBarTexture(Califpornia.CFG.media.normTex)
		local bbg = CreateFrame("Frame", nil, GuildFactionBar)
		bbg:SetPoint("TOPLEFT", -1, 1)
		bbg:SetPoint("BOTTOMRIGHT", 1, -1)
		bbg:SetFrameLevel(GuildFactionBar:GetFrameLevel()-1)
		Califpornia.CreateBD(bbg)
	elseif addon == "Blizzard_GuildBankUI" then
		Califpornia.CreateBD(GuildBankFrame)
		Califpornia.CreateShadow(GuildBankFrame)
		for i = 1, 4 do
			Califpornia.SkinUITab(_G["GuildBankFrameTab"..i])
		end
		Califpornia.SkinUIButton(GuildBankFrameWithdrawButton)
		Califpornia.SkinUIButton(GuildBankFrameDepositButton)
	elseif addon == "Blizzard_InspectUI" then
		Califpornia.CreateBD(InspectFrame)
		Califpornia.CreateShadow(InspectFrame)

		local slots = {
			"Head", "Neck", "Shoulder", "Shirt", "Chest", "Waist", "Legs", "Feet", "Wrist",
			"Hands", "Finger0", "Finger1", "Trinket0", "Trinket1", "Back", "MainHand",
			"SecondaryHand", "Ranged", "Tabard",
		}

		for i = 1, getn(slots) do
			local bd = CreateFrame("Frame", nil, _G["Inspect"..slots[i].."Slot"])
			bd:SetPoint("TOPLEFT", -1, 1)
			bd:SetPoint("BOTTOMRIGHT", 1, -1)
			Califpornia.CreateBD(bd)
			bd:SetBackdropColor(0, 0, 0, 0)
			_G["Inspect"..slots[i].."Slot"]:SetNormalTexture("")
			_G["Inspect"..slots[i].."Slot"]:GetRegions():SetTexCoord(.08, .92, .08, .92)
		end

		for i = 1, 4 do
			Califpornia.SkinUITab(_G["InspectFrameTab"..i])
		end
		select(3, InspectFrame:GetRegions()):Hide()
		InspectGuildFrame:GetRegions():Hide()
		for i = 1, 5 do
			select(i, InspectModelFrame:GetRegions()):Hide()
		end
		for i = 1, 4 do
			select(i, InspectTalentFrame:GetRegions()):Hide()
		end
		for i = 1, 3 do
			for j = 1, 6 do
				select(j, _G["InspectTalentFrameTab"..i]:GetRegions()):Hide()
				select(j, _G["InspectTalentFrameTab"..i]:GetRegions()).Show = Califpornia.dummy
			end
		end
	elseif addon == "Blizzard_ItemSocketingUI" then
		local SocketBD = CreateFrame("Frame", nil, ItemSocketingFrame)
		SocketBD:SetPoint("TOPLEFT", 12, -8)
		SocketBD:SetPoint("BOTTOMRIGHT", -2, 24)
		SocketBD:SetFrameLevel(ItemSocketingFrame:GetFrameLevel()-1)
		Califpornia.CreateBD(SocketBD)
		Califpornia.CreateShadow(SocketBD)
		ItemSocketingFrame:GetRegions():Hide()
		Califpornia.SkinUIButton(ItemSocketingSocketButton)
		ItemSocketingSocketButton:ClearAllPoints()
		ItemSocketingSocketButton:SetPoint("BOTTOMRIGHT", ItemSocketingFrame, "BOTTOMRIGHT", -10, 28)
	elseif addon == "Blizzard_MacroUI" then
		local MacroBD = CreateFrame("Frame", nil, MacroFrame)
		MacroBD:SetPoint("TOPLEFT", 12, -10)
		MacroBD:SetPoint("BOTTOMRIGHT", -33, 68)
		MacroBD:SetFrameLevel(MacroFrame:GetFrameLevel()-1)
		Califpornia.CreateBD(MacroBD)
		Califpornia.CreateShadow(MacroBD)
		Califpornia.CreateBD(MacroFrameTextBackground, .25)
		Califpornia.CreateBD(MacroPopupFrame)
		Califpornia.CreateShadow(MacroPopupFrame)
		for i = 1, 6 do
			select(i, MacroFrameTab1:GetRegions()):Hide()
			select(i, MacroFrameTab2:GetRegions()):Hide()
			select(i, MacroFrameTab1:GetRegions()).Show = Califpornia.dummy
			select(i, MacroFrameTab2:GetRegions()).Show = Califpornia.dummy
		end
		for i = 1, 8 do
			if i ~= 6 then select(i, MacroFrame:GetRegions()):Hide() end
		end
		for i = 1, 5 do
			select(i, MacroPopupFrame:GetRegions()):Hide()
		end
		Califpornia.SkinUIButton(MacroDeleteButton)
		Califpornia.SkinUIButton(MacroNewButton)
		Califpornia.SkinUIButton(MacroExitButton)
		Califpornia.SkinUIButton(MacroEditButton)
		Califpornia.SkinUIButton(MacroPopupOkayButton)
		Califpornia.SkinUIButton(MacroPopupCancelButton)
		MacroPopupFrame:ClearAllPoints()
		MacroPopupFrame:SetPoint("LEFT", MacroFrame, "RIGHT", -14, 16)
	elseif addon == "Blizzard_RaidUI" then
		for i = 1, 5 do
			if i ~= 3 and i ~= 2 then select(i, CompactRaidFrameManagerDisplayFrame:GetRegions()):Hide() end
		end
		for i = 1, 8 do
			select(i, CompactRaidFrameManager:GetRegions()):Hide()
		end
		Califpornia.CreateBD(CompactRaidFrameManagerDisplayFrame)
		Califpornia.CreateShadow(CompactRaidFrameManagerDisplayFrame)
		local rbuttons = {"CompactRaidFrameManagerToggleButton", "CompactRaidFrameManagerDisplayFrameFilterRoleTank", "CompactRaidFrameManagerDisplayFrameFilterRoleHealer", "CompactRaidFrameManagerDisplayFrameFilterRoleDamager", "CompactRaidFrameManagerDisplayFrameFilterGroup1", "CompactRaidFrameManagerDisplayFrameFilterGroup2", "CompactRaidFrameManagerDisplayFrameFilterGroup3", "CompactRaidFrameManagerDisplayFrameFilterGroup4", "CompactRaidFrameManagerDisplayFrameFilterGroup5", "CompactRaidFrameManagerDisplayFrameFilterGroup6", "CompactRaidFrameManagerDisplayFrameFilterGroup7", "CompactRaidFrameManagerDisplayFrameFilterGroup8", "CompactRaidFrameManagerDisplayFrameLockedModeToggle", "CompactRaidFrameManagerDisplayFrameHiddenModeToggle", "CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateRolePoll", "CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheck", "CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton", "RaidFrameRaidBrowserButton"}
		for i = 1, getn(rbuttons) do
			local rbutton = _G[rbuttons[i]]
			if rbutton then
				Califpornia.SkinUIButton(rbutton)
			end
		end
		CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:SetText("Mark") -- because the texture is hidden, don't want an empty button
		CompactRaidFrameManagerDisplayFrameOptionsButton:Hide()
		local a1, p, a2, x, y = CompactRaidFrameManagerToggleButton:GetPoint()
		CompactRaidFrameManagerToggleButton:SetPoint(a1, p, a2, x + 5, y)
	elseif addon == "Blizzard_ReforgingUI" then
		Califpornia.CreateBD(ReforgingFrame)
		Califpornia.CreateShadow(ReforgingFrame)
		select(3, ReforgingFrame:GetRegions()):Hide()
		Califpornia.SkinUIButton(ReforgingFrameRestoreButton)
		Califpornia.SkinUIButton(ReforgingFrameReforgeButton)
	elseif addon == "Blizzard_TalentUI" then
		Califpornia.CreateBD(PlayerTalentFrame)
		Califpornia.CreateShadow(PlayerTalentFrame)
		local talentbuttons = { "PlayerTalentFrameToggleSummariesButton", "PlayerTalentFrameLearnButton", "PlayerTalentFrameResetButton", "PlayerTalentFrameActivateButton"}
		for i = 1, getn(talentbuttons) do
		local reskinbutton = _G[talentbuttons[i]]
			if reskinbutton then
				Califpornia.SkinUIButton(reskinbutton)
			end
		end	
		select(3, PlayerTalentFrame:GetRegions()):Hide()
		for i = 1, 3 do
			if _G["PlayerTalentFrameTab"..i] then
				Califpornia.SkinUITab(_G["PlayerTalentFrameTab"..i])
				Califpornia.SkinUIButton(_G["PlayerTalentFramePanel"..i.."SelectTreeButton"])
			end
		end
		for i = 1, 2 do
			local tab = _G["PlayerSpecTab"..i]
			local a1, p, a2, x, y = PlayerSpecTab1:GetPoint()
			local bg = CreateFrame("Frame", nil, tab)
			bg:SetPoint("TOPLEFT", -1, 1)
			bg:SetPoint("BOTTOMRIGHT", 1, -1)
			bg:SetFrameLevel(tab:GetFrameLevel()-1)
			hooksecurefunc("PlayerTalentFrame_UpdateTabs", function()
				PlayerSpecTab1:SetPoint(a1, p, a2, x + 11, y + 10)
				PlayerSpecTab2:SetPoint("TOP", PlayerSpecTab1, "BOTTOM")
			end)
			Califpornia.CreateShadow(tab, 5, 0, 0, 0, 1, 1)
			Califpornia.CreateBD(bg, 1)
			select(2, tab:GetRegions()):SetTexCoord(.08, .92, .08, .92)
		end
	elseif addon == "Blizzard_TradeSkillUI" then
		Califpornia.CreateBD(TradeSkillFrame)
		Califpornia.CreateShadow(TradeSkillFrame)
		select(3, TradeSkillFrame:GetRegions()):Hide()
		select(3, TradeSkillFrame:GetRegions()).Show = Califpornia.dummy
		select(21, TradeSkillFrame:GetRegions()):Hide()
		select(22, TradeSkillFrame:GetRegions()):Hide()
		local tradeskillbuttons = {"TradeSkillCreateButton", "TradeSkillCreateAllButton", "TradeSkillCancelButton"}
		for i = 1, getn(tradeskillbuttons) do
		local button = _G[tradeskillbuttons[i]]
			if button then
				Califpornia.SkinUIButton(button)
			end
		end
	elseif addon == "Blizzard_TrainerUI" then
		Califpornia.CreateBD(ClassTrainerFrame)
		Califpornia.CreateShadow(ClassTrainerFrame)
		select(3, ClassTrainerFrame:GetRegions()):Hide()
		select(19, ClassTrainerFrame:GetRegions()):Hide()
		Califpornia.SkinUIButton(ClassTrainerTrainButton)
	elseif addon == "Blizzard_TimeManager" then
--		local TimemgrBD = CreateFrame("Frame", nil, TimeManagerFrame)
--		TimemgrBD:SetPoint("TOPLEFT", 12, -8)
--		TimemgrBD:SetPoint("BOTTOMRIGHT", -2, 24)
--		TimemgrBD:SetFrameLevel(TimeManagerFrame:GetFrameLevel()-1)
		Califpornia.CreateBD(TimeManagerFrame)
		Califpornia.CreateShadow(TimeManagerFrame)
		Califpornia.SkinUIButton(TimeManagerAlarmEnabledButton)
	end

	-- [[ Mac Options ]]

	if IsMacClient() then
		Califpornia.CreateBD(MacOptionsFrame)
		MacOptionsFrameHeader:SetTexture("")
		MacOptionsFrameHeader:ClearAllPoints()
		MacOptionsFrameHeader:SetPoint("TOP", MacOptionsFrame, 0, 0)
 
		Califpornia.CreateBD(MacOptionsFrameMovieRecording, .25)
		Califpornia.CreateBD(MacOptionsITunesRemote, .25)

		local macbuttons = {"MacOptionsButtonKeybindings", "MacOptionsButtonCompress", "MacOptionsFrameCancel", "MacOptionsFrameOkay", "MacOptionsFrameDefaults"}
		for i = 1, getn(macbuttons) do
		local button = _G[macbuttons[i]]
			if button then
				Califpornia.SkinUIButton(button)
			end
		end
 
		_G["MacOptionsButtonCompress"]:SetWidth(136)
 
		_G["MacOptionsFrameCancel"]:SetWidth(96)
		_G["MacOptionsFrameCancel"]:SetHeight(22)
		_G["MacOptionsFrameCancel"]:ClearAllPoints()
		_G["MacOptionsFrameCancel"]:SetPoint("LEFT", _G["MacOptionsButtonKeybindings"], "RIGHT", 107, 0)
 
		_G["MacOptionsFrameOkay"]:SetWidth(96)
		_G["MacOptionsFrameOkay"]:SetHeight(22)
		_G["MacOptionsFrameOkay"]:ClearAllPoints()
		_G["MacOptionsFrameOkay"]:SetPoint("LEFT", _G["MacOptionsButtonKeybindings"], "RIGHT", 5, 0)
 
		_G["MacOptionsButtonKeybindings"]:SetWidth(96)
		_G["MacOptionsButtonKeybindings"]:SetHeight(22)
		_G["MacOptionsButtonKeybindings"]:ClearAllPoints()
		_G["MacOptionsButtonKeybindings"]:SetPoint("LEFT", _G["MacOptionsFrameDefaults"], "RIGHT", 5, 0)
 
		_G["MacOptionsFrameDefaults"]:SetWidth(96)
		_G["MacOptionsFrameDefaults"]:SetHeight(22)
	end
end)