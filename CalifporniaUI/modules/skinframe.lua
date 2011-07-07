
local tukuiskin = true -- set to false to override Tukui-specific skin, only applies to Tukui users.
local maxbags = 32 -- change if you have a bag with more than 32 slots

-- [[ Tutorial ]]

--[[

	You can easily add skins for addons yourself, using Aurora's simple functions.
	Here's how:

	First, find out the name of your frame, its buttons, and its tabs. You can do so using the /framestack command. Write down these names somewhere.

	Secondly, add a section in Aurora for the addon. Add the following line:
		elseif addon == "addonname"
	to the section under Load on Demand Addons.

	Then, use these functions where needed (all functions are prefixed with Aurora.):

	====

	CreateBD(frame, alpha)				Easily change or set the backdrop of the frame.

							frame: The name of the frame
							alpha: Specifies the backdrop colour alpha. Default value: .5

	CreateSD(frame, size, r, g, b, alpha, offset)	Create a shadowy border around the frame. Only used when using the Aurora skin.

							frame: The name of the frame
							size: Size of the border
							r, g, b: Colour of the border
							alpha: Specifies the border colour alpha. Default value: 1
							offset: The space between the frame and the shadow. Gap size = offset + 1. Default value: 0

	CreatePulse(frame, speed, mult, alpha)		Repeatedly make the frame change from full alpha to hidden. Used on button glow.

							frame: The name of the frame
							speed: Time in seconds between each alpha update. Default value: .05
							mult: Multiplier for speed. Default value: 1
							alpha: Maximum alpha of the frame. Default value: 1

	CreateTab(frame)				Restyle a tab that uses the default tab template.

							frame: The name of the frame

	Reskin(frame)					Restyle a button that uses the default button template.

							frame: The name of the frame

	dummy						Overwrite an existing function with an empty function

	====

	For example, you have an addon called "MyAddon" with a frame called "MyFrame". It has two buttons, an Okay button and a Cancel button, and three tabs; tab1, tab2 and tab3.
	The buttons and tabs are named after the frame.
	It would look a little like this:

		elseif addon == "MyAddon" then
			Aurora.CreateBD("MyFrame")
			Aurora.CreateSD("MyFrame")

			Aurora.Reskin("MyFrameOkayButton")
			Aurora.Reskin("MyFrameCancelButton")

			for i = 1, 3 do
				local tab = _G["MyFrameTab"..i]
				Aurora.CreateTab(tab)
			end
		...

	This should work for most simple addons, but others might require a more complicated approach.

	Have fun!

]]

-- [[ FreeUI functions ]]

local class = Califpornia.myclass

Aurora = {
	["backdrop"] = "Interface\\ChatFrame\\ChatFrameBackground",
	["glow"] = CalifporniaCFG.media.glowTex,
}

Aurora.dummy = function() end


-- [[ Addon core ]]

local Skin = CreateFrame("Frame", nil, UIParent)

	Aurora.CreateBD = Califpornia.CreateBD

	Aurora.CreateSD = function() end

	Aurora.CreateBDSD = function(frame)
		Aurora.CreateBD(frame)
		Aurora.CreateSD(frame)
	end

	Aurora.CreateTab = Califpornia.SkinUITab
--	Aurora.CreateTab = function (frame)
--		Califpornia.CreateBD(frame)
--		bcCreateBorder(frame, 12, 6, 6, 6, -3, 14, -3, 14, -3, 1, -3, 1) 
--	end



	Aurora.Reskin = Califpornia.SkinUIButton

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

		local skins = {"AutoCompleteBox", "BNToastFrame", "TicketStatusFrameButton", "DropDownList1Backdrop", "DropDownList2Backdrop", "DropDownList1MenuBackdrop", "DropDownList2MenuBackdrop", "LFDSearchStatus", "FriendsTooltip", "GhostFrame", "GhostFrameContentsFrame", "DropDownList1MenuBackdrop", "DropDownList2MenuBackdrop", "DropDownList1Backdrop", "DropDownList2Backdrop", "GearManagerDialogPopup"}

		for i = 1, getn(skins) do
			Aurora.CreateBD(_G[skins[i]])
		end

		local shadowskins = {"StaticPopup1", "StaticPopup2", "GameMenuFrame", "InterfaceOptionsFrame", "VideoOptionsFrame", "AudioOptionsFrame", "LFDDungeonReadyStatus", "ChatConfigFrame", "SpellBookFrame", "CharacterFrame", "PVPFrame", "WorldStateScoreFrame", "StackSplitFrame", "AddFriendFrame", "FriendsFriendsFrame", "ColorPickerFrame", "ReadyCheckFrame", "PetStableFrame", "LFDDungeonReadyDialog", "TokenFramePopup", "ReputationDetailFrame", "LFDRoleCheckPopup", "RaidInfoFrame", "PVPBannerFrame", "RolePollPopup", "LFDParentFrame"}

		for i = 1, getn(shadowskins) do
			Aurora.CreateBD(_G[shadowskins[i]])
			Aurora.CreateSD(_G[shadowskins[i]])
		end

		local simplebds = {"SpellBookCompanionModelFrame", "PrimaryProfession1", "PrimaryProfession2", "SecondaryProfession1", "SecondaryProfession2", "SecondaryProfession3", "SecondaryProfession4", "ChatConfigCategoryFrame", "ChatConfigBackgroundFrame", "ChatConfigChatSettingsLeft", "ChatConfigChatSettingsClassColorLegend", "ChatConfigChannelSettingsLeft", "ChatConfigChannelSettingsClassColorLegend", "FriendsFriendsList", "QuestLogCount", "FriendsFrameBroadcastInput", "HelpFrameKnowledgebaseSearchBox", "HelpFrameTicketScrollFrame"}
		for i = 1, getn(simplebds) do
			local simplebd = _G[simplebds[i]]
			Aurora.CreateBD(simplebd, .25)
		end

		for i = 1, 5 do
			local tab = _G["SpellBookSkillLineTab"..i]
			local a1, p, a2, x, y = tab:GetPoint()
			local bg = CreateFrame("Frame", nil, tab)
			bg:SetPoint("TOPLEFT", -1, 1)
			bg:SetPoint("BOTTOMRIGHT", 1, -1)
			bg:SetFrameLevel(tab:GetFrameLevel()-1)
			if IsAddOnLoaded("Tukui") and tukuiskin == true then
				tab:SetPoint(a1, p, a2, x + 5, y)
				bg:SetPoint("TOPLEFT", -2, 2)
				bg:SetPoint("BOTTOMRIGHT", 2, -2)
				Aurora.CreateBD(bg)
			else
				tab:SetPoint(a1, p, a2, x + 11, y)
				Aurora.CreateSD(tab, 5, 0, 0, 0, 1, 1)
				Aurora.CreateBD(bg, 1)
			end
			select(3, tab:GetRegions()):SetTexCoord(.08, .92, .08, .92)
			select(4, tab:GetRegions()):SetTexCoord(.08, .92, .08, .92)
		end

		-- [[ SpellBook buttons ]]

		for i = 1, 12 do
			local btn = _G["SpellBookCompanionButton"..i]
			local bg = CreateFrame("Frame", nil, btn)
			bg:SetPoint("TOPLEFT", -1, 1)
			bg:SetPoint("BOTTOMRIGHT", 1, -1)
			bg:SetFrameLevel(btn:GetFrameLevel()-1)
			Aurora.CreateSD(btn, 5, 0, 0, 0, 1, 1)
			Aurora.CreateBD(bg, 1)
			select(3, btn:GetRegions()):SetTexCoord(.08, .92, .08, .92)
			select(4, btn:GetRegions()):SetTexCoord(.08, .92, .08, .92)
		end


		-- [[ Backdrop frames ]]

		FriendsBD = CreateFrame("Frame", nil, FriendsFrame)
		FriendsBD:SetPoint("TOPLEFT", 10, -30)
		FriendsBD:SetPoint("BOTTOMRIGHT", -34, 76)

		QuestBD = CreateFrame("Frame", nil, QuestLogFrame)
		QuestBD:SetPoint("TOPLEFT", 6, -9)
		QuestBD:SetPoint("BOTTOMRIGHT", -2, 6)
		QuestBD:SetFrameLevel(QuestLogFrame:GetFrameLevel()-1)

		GuildRegistrarBD = CreateFrame("Frame", nil, GuildRegistrarFrame)
		GuildRegistrarBD:SetPoint("TOPLEFT", 6, -15)
		GuildRegistrarBD:SetPoint("BOTTOMRIGHT", -26, 64)
		GuildRegistrarBD:SetFrameLevel(GuildRegistrarFrame:GetFrameLevel()-1)

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
		GossipBD:SetFrameLevel(GossipFrame:GetFrameLevel()-1)

		PetitionBD = CreateFrame("Frame", nil, PetitionFrame)
		PetitionBD:SetPoint("TOPLEFT", 6, -15)
		PetitionBD:SetPoint("BOTTOMRIGHT", -26, 64)

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
		NPCBD:SetPoint("TOPLEFT")
		NPCBD:SetPoint("RIGHT")
		NPCBD:SetPoint("BOTTOM", QuestNPCModelTextScrollFrame)
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

		GMBD = CreateFrame("Frame", nil, HelpFrame)
		GMBD:SetPoint("TOPLEFT")
		GMBD:SetPoint("BOTTOMRIGHT")
		GMBD:SetFrameLevel(HelpFrame:GetFrameLevel()-1)

		local FrameBDs = {"FriendsBD", "QuestBD", "GuildRegistrarBD", "QFBD", "QDBD", "GossipBD", "LFRBD", "MerchBD", "MailBD", "OMailBD", "DressBD", "TaxiBD", "TradeBD", "ItemBD", "TabardBD", "GMBD", "PetitionBD"}
		for i = 1, getn(FrameBDs) do
			FrameBD = _G[FrameBDs[i]]
			if FrameBD then
				Aurora.CreateBD(FrameBD)
				Aurora.CreateSD(FrameBD)
			end
		end

		Aurora.CreateBD(NPCBD)

		local line = CreateFrame("Frame", nil, QuestNPCModel)
		line:SetPoint("BOTTOMLEFT", 0, -1)
		line:SetPoint("BOTTOMRIGHT", 0, -1)
		line:SetHeight(1)
		line:SetFrameLevel(QuestNPCModel:GetFrameLevel()-1)
		Aurora.CreateBD(line, 0)

		if class == "HUNTER" or class == "MAGE" or class == "DEATHKNIGHT" or class == "WARLOCK" then
			if class == "HUNTER" then
				for i = 1, 10 do
					local bd = CreateFrame("Frame", nil, _G["PetStableStabledPet"..i])
					bd:SetPoint("TOPLEFT", -1, 1)
					bd:SetPoint("BOTTOMRIGHT", 1, -1)
					Aurora.CreateBD(bd)
					bd:SetBackdropColor(0, 0, 0, 0)
					_G["PetStableStabledPet"..i]:SetNormalTexture("")
					_G["PetStableStabledPet"..i]:GetRegions():SetTexCoord(.08, .92, .08, .92)
				end
			end

			PetModelFrameShadowOverlay:Hide()
			PetPaperDollFrameExpBar:GetRegions():Hide()
			select(2, PetPaperDollFrameExpBar:GetRegions()):Hide()

			local bbg = CreateFrame("Frame", nil, PetPaperDollFrameExpBar)
			bbg:SetPoint("TOPLEFT", -1, 1)
			bbg:SetPoint("BOTTOMRIGHT", 1, -1)
			bbg:SetFrameLevel(PetPaperDollFrameExpBar:GetFrameLevel()-1)
			Aurora.CreateBD(bbg, .25)
		end

		local tempfix = false
		PaperDollSidebarTab3:HookScript("OnClick", function()
			if not tempfix then
			for i = 1, 8 do
				local bu = _G["PaperDollEquipmentManagerPaneButton"..i]
				local bd = select(4, bu:GetRegions())
				local ic = select(9, bu:GetRegions())

				bd:Hide()
				bd.Show = Aurora.dummy
				ic:SetTexCoord(.08, .92, .08, .92)

				local f = CreateFrame("Frame", nil, bu)
				f:SetPoint("TOPLEFT", ic, -1, 1)
				f:SetPoint("BOTTOMRIGHT", ic, 1, -1)
				f:SetFrameLevel(bu:GetFrameLevel()-1)
				Aurora.CreateBD(f, 0)
			end
			tempfix = true
			end
		end)

		GhostFrameContentsFrameIcon:SetTexCoord(.08, .92, .08, .92)

		local GhostBD = CreateFrame("Frame", nil, GhostFrameContentsFrame)
		GhostBD:SetPoint("TOPLEFT", GhostFrameContentsFrameIcon, -1, 1)
		GhostBD:SetPoint("BOTTOMRIGHT", GhostFrameContentsFrameIcon, 1, -1)
		Aurora.CreateBD(GhostBD, 0)

		-- [[ Hide regions ]]

		CharacterFramePortrait:Hide()
		for i = 1, 5 do
			select(i, CharacterModelFrame:GetRegions()):Hide()
		end
		for i = 1, 3 do
			select(i, QuestLogFrame:GetRegions()):Hide()
			for j = 1, 2 do
				select(i, _G["PVPBannerFrameCustomization"..j]:GetRegions()):Hide()
			end
		end
		QuestLogDetailFrame:GetRegions():Hide()
		QuestFramePortrait:Hide()
		GossipFramePortrait:Hide()
		for i = 1, 6 do
			for j = 1, 3 do
				select(i, _G["FriendsTabHeaderTab"..j]:GetRegions()):Hide()
				select(i, _G["FriendsTabHeaderTab"..j]:GetRegions()).Show = Aurora.dummy
			end
		end
		FriendsFrameTitleText:Hide()
		SpellBookFramePortrait:Hide()
		SpellBookCompanionModelFrameShadowOverlay:Hide()
		PVPFramePortrait:Hide()
		PVPHonorFrameBGTex:Hide()
		LFRParentFrameIcon:Hide()
		for i = 1, 5 do
			select(i, MailFrame:GetRegions()):Hide()
		end
		OpenMailFrameIcon:Hide()
		OpenMailHorizontalBarLeft:Hide()
		select(13, OpenMailFrame:GetRegions()):Hide()
		OpenStationeryBackgroundLeft:Hide()
		OpenStationeryBackgroundRight:Hide()
		for i = 4, 7 do
			select(i, SendMailFrame:GetRegions()):Hide()
		end
		SendStationeryBackgroundLeft:Hide()
		SendStationeryBackgroundRight:Hide()
		MerchantFramePortrait:Hide()
		DressUpFramePortrait:Hide()
		select(2, DressUpFrame:GetRegions()):Hide()
		for i = 8, 11 do
			select(i, DressUpFrame:GetRegions()):Hide()
		end
		TaxiFrameTitleText:Hide()
		TradeFrameRecipientPortrait:Hide()
		TradeFramePlayerPortrait:Hide()
		for i = 1, 4 do
			select(i, GearManagerDialogPopup:GetRegions()):Hide()
		end
		StackSplitFrame:GetRegions():Hide()
		ItemTextFrame:GetRegions():Hide()
		ItemTextScrollFrameMiddle:Hide()
		PetStableFramePortrait:Hide()
		ReputationDetailCorner:Hide()
		ReputationDetailDivider:Hide()
		QuestNPCModelShadowOverlay:Hide()
		TabardFrame:GetRegions():Hide()
		PetStableModelShadow:Hide()
		LFDParentFrameEyeFrame:Hide()
		RaidInfoFrame:GetRegions():Hide()
		RaidInfoDetailFooter:Hide()
		RaidInfoDetailHeader:Hide()
		RaidInfoDetailCorner:Hide()
		for i = 1, 9 do
			select(i, QuestLogCount:GetRegions()):Hide()
		end
		for i = 4, 8 do
			select(i, FriendsFrameBroadcastInput:GetRegions()):Hide()
			select(i, HelpFrameKnowledgebaseSearchBox:GetRegions()):Hide()
		end
		select(3, PVPBannerFrame:GetRegions()):Hide()
		for i = 1, 9 do
			select(i, HelpFrame:GetRegions()):Hide()
		end
		HelpFrameHeader:Hide()
		ReadyCheckListenerFrame:GetRegions():SetAlpha(0)
		HelpFrameLeftInset:GetRegions():Hide()
		for i = 10, 13 do
			select(i, HelpFrameLeftInset:GetRegions()):Hide()
		end
		LFDParentFrameRoleBackground:Hide()
		LFDQueueFrameCapBarShadow:Hide()
		LFDQueueFrameBackground:Hide()
		select(4, HelpFrameTicket:GetChildren()):Hide()
		HelpFrameKnowledgebaseStoneTex:Hide()
		HelpFrameKnowledgebaseNavBarOverlay:Hide()
		GhostFrameLeft:Hide()
		GhostFrameRight:Hide()
		GhostFrameMiddle:Hide()
		for i = 3, 6 do
			select(i, GhostFrame:GetRegions()):Hide()
		end
		PaperDollSidebarTabs:GetRegions():Hide()
		select(2, PaperDollSidebarTabs:GetRegions()):Hide()
		select(6, PaperDollEquipmentManagerPaneEquipSet:GetRegions()):Hide()

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
			Aurora.CreateBD(bd)
			bd:SetBackdropColor(0, 0, 0, 0)
		end

		_G["ReadyCheckFrame"]:HookScript("OnShow", function(self) if UnitIsUnit("player", self.initiator) then self:Hide() end end)


		-- [[ Text colour functions ]]

		NORMAL_QUEST_DISPLAY = "|cffffffff%s|r"
		TRIVIAL_QUEST_DISPLAY = "|cffffffff%s (low level)|r"

		GameFontBlackMedium:SetTextColor(1, 1, 1)
		QuestFont:SetTextColor(1, 1, 1)
		MailTextFontNormal:SetTextColor(1, 1, 1)
		InvoiceTextFontNormal:SetTextColor(1, 1, 1)
		InvoiceTextFontSmall:SetTextColor(1, 1, 1)

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
			local classColor = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
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

		QuestLogFrameShowMapButton:Hide()
		QuestLogFrameShowMapButton.Show = Aurora.dummy

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
--		RaidFrameRaidInfoButton:ClearAllPoints()
--		RaidFrameRaidInfoButton:SetPoint("TOPRIGHT", FriendsFrame, "TOPRIGHT", -70, -44)

		TaxiFrameCloseButton:ClearAllPoints()
		TaxiFrameCloseButton:SetPoint("TOPRIGHT", TaxiRouteMap, "TOPRIGHT")

		local a1, p, a2, x, y = ReputationDetailFrame:GetPoint()
		ReputationDetailFrame:SetPoint(a1, p, a2, x + 10, y)

		hooksecurefunc("QuestFrame_ShowQuestPortrait", function(parentFrame, portrait, text, name, x, y)
			QuestNPCModel:SetPoint("TOPLEFT", parentFrame, "TOPRIGHT", x+8, y)
		end)

		PaperDollEquipmentManagerPaneEquipSet:SetWidth(PaperDollEquipmentManagerPaneEquipSet:GetWidth()-1)

		local a3, p2, a4, x2, y2 = PaperDollEquipmentManagerPaneSaveSet:GetPoint()
		PaperDollEquipmentManagerPaneSaveSet:SetPoint(a3, p2, a4, x2 + 1, y2)

		local a5, p3, a6, x3, y3 = GearManagerDialogPopup:GetPoint()
		GearManagerDialogPopup:SetPoint(a5, p3, a6, x3+1, y3)

		DressUpFrameResetButton:ClearAllPoints()
		DressUpFrameResetButton:SetPoint("RIGHT", DressUpFrameCancelButton, "LEFT", -1, 0)

		SendMailMailButton:ClearAllPoints()
		SendMailMailButton:SetPoint("RIGHT", SendMailCancelButton, "LEFT", -1, 0)

		OpenMailDeleteButton:ClearAllPoints()
		OpenMailDeleteButton:SetPoint("RIGHT", OpenMailCancelButton, "LEFT", -1, 0)

		OpenMailReplyButton:ClearAllPoints()
		OpenMailReplyButton:SetPoint("RIGHT", OpenMailDeleteButton, "LEFT", -1, 0)

		-- [[ Tabs ]]

		for i = 1, 5 do
			Aurora.CreateTab(_G["SpellBookFrameTabButton"..i])
		end

		for i = 1, 4 do
			Aurora.CreateTab(_G["FriendsFrameTab"..i])
			if _G["CharacterFrameTab"..i] then
				Aurora.CreateTab(_G["CharacterFrameTab"..i])
			end
		end

		for i = 1, 3 do
			Aurora.CreateTab(_G["PVPFrameTab"..i])
			Aurora.CreateTab(_G["WorldStateScoreFrameTab"..i])
		end

		for i = 1, 2 do
			Aurora.CreateTab(_G["LFRParentFrameTab"..i])
			Aurora.CreateTab(_G["MerchantFrameTab"..i])
			Aurora.CreateTab(_G["MailFrameTab"..i])
		end

		-- [[ Buttons ]]

		for i = 1, 2 do
			for j = 1, 3 do
				Aurora.Reskin(_G["StaticPopup"..i.."Button"..j])
			end
		end
		local buttons = {"VideoOptionsFrameOkay", "VideoOptionsFrameCancel", "VideoOptionsFrameDefaults", "VideoOptionsFrameApply", "AudioOptionsFrameOkay", "AudioOptionsFrameCancel", "AudioOptionsFrameDefaults", "InterfaceOptionsFrameDefaults", "InterfaceOptionsFrameOkay", "InterfaceOptionsFrameCancel", "ChatConfigFrameOkayButton", "ChatConfigFrameDefaultButton", "DressUpFrameCancelButton", "DressUpFrameResetButton", "WhoFrameWhoButton", "WhoFrameAddFriendButton", "WhoFrameGroupInviteButton", "SendMailMailButton", "SendMailCancelButton", "OpenMailReplyButton", "OpenMailDeleteButton", "OpenMailCancelButton", "OpenMailReportSpamButton", "QuestLogFrameAbandonButton", "QuestLogFramePushQuestButton", "QuestLogFrameTrackButton", "QuestLogFrameCancelButton", "QuestFrameAcceptButton", "QuestFrameDeclineButton", "QuestFrameCompleteQuestButton", "QuestFrameCompleteButton", "QuestFrameGoodbyeButton", "GossipFrameGreetingGoodbyeButton", "QuestFrameGreetingGoodbyeButton", "ChannelFrameNewButton", "RaidFrameRaidInfoButton", "RaidFrameConvertToRaidButton", "TradeFrameTradeButton", "TradeFrameCancelButton", "GearManagerDialogPopupOkay", "GearManagerDialogPopupCancel", "StackSplitOkayButton", "StackSplitCancelButton", "TabardFrameAcceptButton", "TabardFrameCancelButton", "GameMenuButtonHelp", "GameMenuButtonOptions", "GameMenuButtonUIOptions", "GameMenuButtonKeybindings", "GameMenuButtonMacros", "GameMenuButtonLogout", "GameMenuButtonQuit", "GameMenuButtonContinue", "GameMenuButtonMacOptions", "FriendsFrameAddFriendButton", "FriendsFrameSendMessageButton", "LFDQueueFramePartyBackfillBackfillButton", "LFDQueueFramePartyBackfillNoBackfillButton", "LFDQueueFrameFindGroupButton", "LFDQueueFrameCancelButton", "LFRQueueFrameFindGroupButton", "LFRQueueFrameAcceptCommentButton", "PVPFrameLeftButton", "PVPHonorFrameWarGameButton", "PVPFrameRightButton", "RaidFrameNotInRaidRaidBrowserButton", "WorldStateScoreFrameLeaveButton", "SpellBookCompanionSummonButton", "AddFriendEntryFrameAcceptButton", "AddFriendEntryFrameCancelButton", "FriendsFriendsSendRequestButton", "FriendsFriendsCloseButton", "ColorPickerOkayButton", "ColorPickerCancelButton", "FriendsFrameIgnorePlayerButton", "FriendsFrameUnsquelchButton", "LFDDungeonReadyDialogEnterDungeonButton", "LFDDungeonReadyDialogLeaveQueueButton", "LFRBrowseFrameSendMessageButton", "LFRBrowseFrameInviteButton", "LFRBrowseFrameRefreshButton", "LFDRoleCheckPopupAcceptButton", "LFDRoleCheckPopupDeclineButton", "GuildInviteFrameJoinButton", "GuildInviteFrameDeclineButton", "FriendsFramePendingButton1AcceptButton", "FriendsFramePendingButton1DeclineButton", "RaidInfoExtendButton", "RaidInfoCancelButton", "PaperDollEquipmentManagerPaneEquipSet", "PaperDollEquipmentManagerPaneSaveSet", "PVPBannerFrameAcceptButton", "PVPColorPickerButton1", "PVPColorPickerButton2", "PVPColorPickerButton3", "HelpFrameButton1", "HelpFrameButton2", "HelpFrameButton3", "HelpFrameButton4", "HelpFrameButton5", "HelpFrameButton6", "HelpFrameAccountSecurityOpenTicket", "HelpFrameCharacterStuckStuck", "HelpFrameReportLagLoot", "HelpFrameReportLagAuctionHouse", "HelpFrameReportLagMail", "HelpFrameReportLagChat", "HelpFrameReportLagMovement", "HelpFrameReportLagSpell", "HelpFrameReportAbuseOpenTicket", "HelpFrameOpenTicketHelpTopIssues", "HelpFrameOpenTicketHelpOpenTicket", "ReadyCheckFrameYesButton", "ReadyCheckFrameNoButton", "RolePollPopupAcceptButton", "HelpFrameTicketSubmit", "HelpFrameTicketCancel", "HelpFrameKnowledgebaseSearchButton", "GhostFrame", "GuildRegistrarFrameGoodbyeButton", "GuildRegistrarFramePurchaseButton", "GuildRegistrarFrameCancelButton", "PetitionFrameRequestButton", "PetitionFrameRenameButton", "PetitionFrameCancelButton", "DeclensionFrameOkayButton"}
		for i = 1, getn(buttons) do
		local reskinbutton = _G[buttons[i]]
			if reskinbutton then
				Aurora.Reskin(reskinbutton)
			else
				print("Button "..buttons[i].." was not found.")
			end
		end

		Aurora.Reskin(select(6, PVPBannerFrame:GetChildren()))

	-- [[ Load on Demand Addons ]]

	elseif addon == "Blizzard_ArchaeologyUI" then
		Aurora.CreateBD(ArchaeologyFrame)
		Aurora.CreateSD(ArchaeologyFrame)
		Aurora.Reskin(ArchaeologyFrameArtifactPageSolveFrameSolveButton)
		Aurora.Reskin(ArchaeologyFrameArtifactPageBackButton)
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
			Aurora.CreateBD(bg, .25)
			local vline = CreateFrame("Frame", nil, bu)
			vline:SetPoint("LEFT", 44, 0)
			vline:SetSize(1, 44)
			Aurora.CreateBD(vline)
		end
	elseif addon == "Blizzard_AuctionUI" then
		local AuctionBD = CreateFrame("Frame", nil, AuctionFrame)
		AuctionBD:SetPoint("TOPLEFT", 2, -10)
		AuctionBD:SetPoint("BOTTOMRIGHT", 0, 10)
		AuctionBD:SetFrameStrata("MEDIUM")
		Aurora.CreateBD(AuctionBD)
		Aurora.CreateSD(AuctionBD)
		Aurora.CreateBD(AuctionProgressFrame)
		Aurora.CreateSD(AuctionProgressFrame)
		AuctionDressUpFrame:ClearAllPoints()
		AuctionDressUpFrame:SetPoint("LEFT", AuctionFrame, "RIGHT", -3, 0)
		AuctionDressUpFrameCloseButton:ClearAllPoints()
		AuctionDressUpFrameCloseButton:SetPoint("TOPRIGHT", AuctionDressUpModel, "TOPRIGHT")
		Aurora.CreateBD(AuctionDressUpModel)
		Aurora.CreateBD(BrowseName, .25)

		local ABBD = CreateFrame("Frame", nil, AuctionProgressBar)
		if IsAddOnLoaded("Tukui") and tukuiskin == true then
			ABBD:SetPoint("TOPLEFT", -2, 2)
			ABBD:SetPoint("BOTTOMRIGHT", 2, -2)
		else
			ABBD:SetPoint("TOPLEFT", -1, 1)
			ABBD:SetPoint("BOTTOMRIGHT", 1, -1)
		end
		ABBD:SetFrameLevel(AuctionProgressBar:GetFrameLevel()-1)
		Aurora.CreateBD(ABBD, .25)

		AuctionFrame:GetRegions():Hide()
		for i = 1, 4 do
			select(i, AuctionProgressFrame:GetRegions()):Hide()
		end
		select(2, AuctionProgressBar:GetRegions()):Hide()
		for i = 1, 4 do
			select(i, AuctionDressUpFrame:GetRegions()):Hide()
		end
		for i = 4, 8 do
			select(i, BrowseName:GetRegions()):Hide()
		end

		for i = 1, 3 do
			Aurora.CreateTab(_G["AuctionFrameTab"..i])
		end

		local abuttons = {"BrowseBidButton", "BrowseBuyoutButton", "BrowseCloseButton", "BrowseSearchButton", "BrowseResetButton", "BidBidButton", "BidBuyoutButton", "BidCloseButton", "AuctionsCloseButton", "AuctionDressUpFrameResetButton", "AuctionsCancelAuctionButton", "AuctionsCreateAuctionButton", "AuctionsNumStacksMaxButton", "AuctionsStackSizeMaxButton"}
		for i = 1, getn(abuttons) do
			local reskinbutton = _G[abuttons[i]]
			if reskinbutton then
				Aurora.Reskin(reskinbutton)
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

		for i = 1, 8 do
			local bu = _G["BrowseButton"..i]
			local it = _G["BrowseButton"..i.."Item"]
			local ic = _G["BrowseButton"..i.."ItemIconTexture"]

			it:SetNormalTexture("")
			ic:SetTexCoord(.08, .92, .08, .92)

			local bg = CreateFrame("Frame", nil, it)
			bg:SetPoint("TOPLEFT", -1, 1)
			bg:SetPoint("BOTTOMRIGHT", 1, -1)
			bg:SetFrameLevel(it:GetFrameLevel()-1)
			Aurora.CreateBD(bg, 0)

			_G["BrowseButton"..i.."Left"]:Hide()
			select(6, _G["BrowseButton"..i]:GetRegions()):Hide()
			_G["BrowseButton"..i.."Right"]:Hide()

			local bd = CreateFrame("Frame", nil, bu)
			bd:SetPoint("TOPLEFT")
			bd:SetPoint("BOTTOMRIGHT", 0, 5)
			bd:SetFrameLevel(bu:GetFrameLevel()-1)
			Aurora.CreateBD(bd, .25)

			bu:SetHighlightTexture("Interface\\ChatFrame\\ChatFrameBackground")
			local hl = bu:GetHighlightTexture()
			hl:SetVertexColor(r, g, b, .2)
			hl:ClearAllPoints()
			hl:SetPoint("TOPLEFT", 0, -1)
			hl:SetPoint("BOTTOMRIGHT", -1, 6)
		end
	elseif addon == "Blizzard_AchievementUI" then
		Aurora.CreateBD(AchievementFrame)
		Aurora.CreateSD(AchievementFrame)
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
					select(j, _G["AchievementFrameTab"..i]:GetRegions()).Show = Aurora.dummy
				end
				local sd = CreateFrame("Frame", nil, _G["AchievementFrameTab"..i])
				sd:SetPoint("TOPLEFT", 6, -4)
				sd:SetPoint("BOTTOMRIGHT", -6, -2)
				sd:SetFrameStrata("LOW")
				if IsAddOnLoaded("Tukui") and tukuiskin == true then
					local F, C, L = unpack(Tukui)
					sd:SetBackdrop({
						bgFile = Aurora.backdrop,
						edgeFile = Aurora.backdrop,
						tile = false, tileSize = 0, edgeSize = 1, 
	 					insets = { left = -1, right = -1, top = -1, bottom = -1}
					})
					sd:SetBackdropColor(unpack(C["media"].backdropcolor))
					sd:SetBackdropBorderColor(unpack(C["media"].bordercolor))
				else
					sd:SetBackdrop({
						bgFile = Aurora.backdrop,
						edgeFile = Aurora.glow,
						edgeSize = 5,
						insets = { left = 5, right = 5, top = 5, bottom = 5 },
					})
					sd:SetBackdropColor(0, 0, 0, .5)
					sd:SetBackdropBorderColor(0, 0, 0)
				end
			end
		end
	elseif addon == "Blizzard_BindingUI" then
		local BindingBD = CreateFrame("Frame", nil, KeyBindingFrame)
		BindingBD:SetPoint("TOPLEFT", 2, 0)
		BindingBD:SetPoint("BOTTOMRIGHT", -38, 10)
		BindingBD:SetFrameLevel(KeyBindingFrame:GetFrameLevel()-1)
		Aurora.CreateBD(BindingBD)
		Aurora.CreateSD(BindingBD)
		KeyBindingFrameHeader:SetTexture("")
		Aurora.Reskin(KeyBindingFrameDefaultButton)
		Aurora.Reskin(KeyBindingFrameUnbindButton)
		Aurora.Reskin(KeyBindingFrameOkayButton)
		Aurora.Reskin(KeyBindingFrameCancelButton)
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
		Aurora.CreateBD(CalBD)
		Aurora.CreateSD(CalBD)
		Aurora.CreateBD(CalendarViewEventFrame)
		Aurora.CreateSD(CalendarViewEventFrame)
		Aurora.CreateBD(CalendarViewHolidayFrame)
		Aurora.CreateSD(CalendarViewHolidayFrame)
		Aurora.CreateBD(CalendarViewRaidFrame)
		Aurora.CreateSD(CalendarViewRaidFrame)
		Aurora.CreateBD(CalendarViewEventInviteList, .25)
		Aurora.CreateBD(CalendarViewEventDescriptionContainer, .25)
		-- No, I don't have a better way to do this
		for i = 1, 6 do
			local vline = CreateFrame("Frame", nil, _G["CalendarDayButton"..i])
			vline:SetHeight(546)
			vline:SetWidth(1)
			vline:SetPoint("TOP", _G["CalendarDayButton"..i], "TOPRIGHT")
			Aurora.CreateBD(vline)
		end
		for i = 1, 36, 7 do
			local hline = CreateFrame("Frame", nil, _G["CalendarDayButton"..i])
			hline:SetWidth(637)
			hline:SetHeight(1)
			hline:SetPoint("LEFT", _G["CalendarDayButton"..i], "TOPLEFT")
			Aurora.CreateBD(hline)
		end
		local cbuttons = { "CalendarViewEventAcceptButton", "CalendarViewEventTentativeButton", "CalendarViewEventDeclineButton", "CalendarViewEventRemoveButton" }
		for i = 1, getn(cbuttons) do
		local cbutton = _G[cbuttons[i]]
			if cbutton then
				Aurora.Reskin(cbutton)
			end
		end
		CalendarCloseButton:ClearAllPoints()
		CalendarCloseButton:SetPoint("TOPRIGHT", CalBD, "TOPRIGHT")
	elseif addon == "Blizzard_GlyphUI" then
		Aurora.CreateBD(GlyphFrameSearchBox, .25)
		GlyphFrame:GetRegions():Hide()
		select(10, GlyphFrameSideInset:GetRegions()):Hide()
		for i = 4, 8 do
			select(i, GlyphFrameSearchBox:GetRegions()):Hide()
		end
	elseif addon == "Blizzard_GMSurveyUI" then
		local f = CreateFrame("Frame", nil, GMSurveyFrame)
		f:SetPoint("TOPLEFT")
		f:SetPoint("BOTTOMRIGHT", -32, 4)
		f:SetFrameLevel(GMSurveyFrame:GetFrameLevel()-1)
		Aurora.CreateBD(f)
		Aurora.CreateSD(f)

		Aurora.CreateBD(GMSurveyCommentFrame, .25)

		for i = 1, 11 do
			select(i, GMSurveyFrame:GetRegions()):Hide()
		end
		for i = 1, 10 do
			Aurora.CreateBD(_G["GMSurveyQuestion"..i], .25)
		end
		for i = 1, 3 do
			select(i, GMSurveyHeader:GetRegions()):Hide()
		end

		Aurora.Reskin(GMSurveySubmitButton)
		Aurora.Reskin(GMSurveyCancelButton)
	elseif addon == "Blizzard_GuildBankUI" then
		local f = CreateFrame("Frame", nil, GuildBankFrame)
		f:SetPoint("TOPLEFT", 10, -8)
		f:SetPoint("BOTTOMRIGHT", 0, 6)
		f:SetFrameLevel(GuildBankFrame:GetFrameLevel()-1)
		Aurora.CreateBD(f)
		Aurora.CreateSD(f)

		GuildBankEmblemFrame:Hide()
		for i = 1, 4 do
			Aurora.CreateTab(_G["GuildBankFrameTab"..i])
		end
		Aurora.Reskin(GuildBankInfoSaveButton)
		Aurora.Reskin(GuildBankFrameWithdrawButton)
		Aurora.Reskin(GuildBankFrameDepositButton)

		GuildBankFrameWithdrawButton:ClearAllPoints()
		GuildBankFrameWithdrawButton:SetPoint("RIGHT", GuildBankFrameDepositButton, "LEFT", -1, 0)

		for i = 1, 7 do
			for j = 1, 14 do
				local co = _G["GuildBankColumn"..i]
				local bu = _G["GuildBankColumn"..i.."Button"..j]
				local ic = _G["GuildBankColumn"..i.."Button"..j.."IconTexture"]
				local nt = _G["GuildBankColumn"..i.."Button"..j.."NormalTexture"]

				co:GetRegions():Hide()
				ic:SetTexCoord(.08, .92, .08, .92)
				nt:SetAlpha(0)

				local bg = CreateFrame("Frame", nil, bu)
				bg:SetPoint("TOPLEFT", -1, 1)
				bg:SetPoint("BOTTOMRIGHT", 1, -1)
				bg:SetFrameLevel(bu:GetFrameLevel()-1)
				Aurora.CreateBD(bg, 0)
			end
		end

		for i = 1, 8 do
			local tb = _G["GuildBankTab"..i]
			local bu = _G["GuildBankTab"..i.."Button"]
			local ic = _G["GuildBankTab"..i.."ButtonIconTexture"]
			local nt = _G["GuildBankTab"..i.."ButtonNormalTexture"]

			local bg = CreateFrame("Frame", nil, bu)
			bg:SetPoint("TOPLEFT", -1, 1)
			bg:SetPoint("BOTTOMRIGHT", 1, -1)
			bg:SetFrameLevel(bu:GetFrameLevel()-1)
			Aurora.CreateBD(bg, 1)
			Aurora.CreateSD(bu, 5, 0, 0, 0, 1, 1)

			local a1, p, a2, x, y = bu:GetPoint()
			bu:SetPoint(a1, p, a2, x + 11, y)

			ic:SetTexCoord(.08, .92, .08, .92)
			tb:GetRegions():Hide()
			nt:Hide()
		end
	elseif addon == "Blizzard_GuildUI" then
		Aurora.CreateBD(GuildFrame)
		Aurora.CreateSD(GuildFrame)
		Aurora.CreateBD(GuildMemberDetailFrame)
		Aurora.CreateSD(GuildMemberDetailFrame)
		Aurora.CreateBD(GuildMemberNoteBackground, .25)
		Aurora.CreateBD(GuildMemberOfficerNoteBackground, .25)
		Aurora.CreateBD(GuildLogFrame)
		Aurora.CreateSD(GuildLogFrame)
		Aurora.CreateBD(GuildLogContainer, .25)
		Aurora.CreateBD(GuildNewsFiltersFrame)
		Aurora.CreateSD(GuildNewsFiltersFrame)
		Aurora.CreateBD(GuildTextEditFrame)
		Aurora.CreateSD(GuildTextEditFrame)
		Aurora.CreateBD(GuildTextEditContainer)
		for i = 1, 5 do
			Aurora.CreateTab(_G["GuildFrameTab"..i])
		end
		select(18, GuildFrame:GetRegions()):Hide()
		select(21, GuildFrame:GetRegions()):Hide()
		select(22, GuildFrame:GetRegions()):Hide()
		select(5, GuildInfoFrameInfo:GetRegions()):Hide()
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
		select(2, GuildNewsBossModel:GetRegions()):Hide()

		local a1, p, a2, x, y = GuildNewsBossModel:GetPoint()
		GuildNewsBossModel:ClearAllPoints()
		GuildNewsBossModel:SetPoint(a1, p, a2, x+5, y)

		local f = CreateFrame("Frame", nil, GuildNewsBossModel)
		f:SetPoint("TOPLEFT")
		f:SetPoint("BOTTOMRIGHT", 0, -52)
		f:SetFrameLevel(GuildNewsBossModel:GetFrameLevel()-1)
		Aurora.CreateBD(f)

		local line = CreateFrame("Frame", nil, GuildNewsBossModel)
		line:SetPoint("BOTTOMLEFT", 0, -1)
		line:SetPoint("BOTTOMRIGHT", 0, -1)
		line:SetHeight(1)
		line:SetFrameLevel(GuildNewsBossModel:GetFrameLevel()-1)
		Aurora.CreateBD(line, 0)

		GuildNewsFiltersFrame:ClearAllPoints()
		GuildNewsFiltersFrame:SetPoint("TOPLEFT", GuildFrame, "TOPRIGHT", 10, -10)
		GuildMemberDetailFrame:ClearAllPoints()
		GuildMemberDetailFrame:SetPoint("TOPLEFT", GuildFrame, "TOPRIGHT", 10, -10)
		GuildLevelFrame:SetAlpha(0)
		local closebutton = select(4, GuildTextEditFrame:GetChildren())
		Aurora.Reskin(closebutton)
		local logbutton = select(3, GuildLogFrame:GetChildren())
		Aurora.Reskin(logbutton)
		local gbuttons = {"GuildAddMemberButton", "GuildViewLogButton", "GuildControlButton", "GuildTextEditFrameAcceptButton", "GuildMemberGroupInviteButton", "GuildMemberRemoveButton", "GuildRecruitmentMessageButton", "GuildRecruitmentDeclineButton", "GuildRecruitmentInviteButton",  "GuildRecruitmentListGuildButton"}
		for i = 1, getn(gbuttons) do
		local gbutton = _G[gbuttons[i]]
			if gbutton then
				Aurora.Reskin(gbutton)
			end
		end

		for i = 1, 3 do
			for j = 1, 6 do
				select(j, _G["GuildInfoFrameTab"..i]:GetRegions()):Hide()
				select(j, _G["GuildInfoFrameTab"..i]:GetRegions()).Show = Aurora.dummy
			end
		end
	elseif addon == "Blizzard_InspectUI" then
		Aurora.CreateBD(InspectFrame)
		Aurora.CreateSD(InspectFrame)

		local slots = {
			"Head", "Neck", "Shoulder", "Shirt", "Chest", "Waist", "Legs", "Feet", "Wrist",
			"Hands", "Finger0", "Finger1", "Trinket0", "Trinket1", "Back", "MainHand",
			"SecondaryHand", "Ranged", "Tabard",
		}

		for i = 1, getn(slots) do
			local bd = CreateFrame("Frame", nil, _G["Inspect"..slots[i].."Slot"])
			bd:SetPoint("TOPLEFT", -1, 1)
			bd:SetPoint("BOTTOMRIGHT", 1, -1)
			Aurora.CreateBD(bd)
			bd:SetBackdropColor(0, 0, 0, 0)
			_G["Inspect"..slots[i].."Slot"]:SetNormalTexture("")
			_G["Inspect"..slots[i].."Slot"]:GetRegions():SetTexCoord(.08, .92, .08, .92)
		end

		for i = 1, 4 do
			Aurora.CreateTab(_G["InspectFrameTab"..i])
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
				select(j, _G["InspectTalentFrameTab"..i]:GetRegions()).Show = Aurora.dummy
			end
		end
	elseif addon == "Blizzard_ItemSocketingUI" then
		local SocketBD = CreateFrame("Frame", nil, ItemSocketingFrame)
		SocketBD:SetPoint("TOPLEFT", 12, -8)
		SocketBD:SetPoint("BOTTOMRIGHT", -2, 24)
		SocketBD:SetFrameLevel(ItemSocketingFrame:GetFrameLevel()-1)
		Aurora.CreateBD(SocketBD)
		Aurora.CreateSD(SocketBD)
		ItemSocketingFrame:GetRegions():Hide()
		Aurora.Reskin(ItemSocketingSocketButton)
		ItemSocketingSocketButton:ClearAllPoints()
		ItemSocketingSocketButton:SetPoint("BOTTOMRIGHT", ItemSocketingFrame, "BOTTOMRIGHT", -10, 28)
	elseif addon == "Blizzard_LookingForGuildUI" then
		Aurora.CreateBD(LookingForGuildFrame)
		Aurora.CreateSD(LookingForGuildFrame)
		Aurora.CreateBD(LookingForGuildInterestFrame, .25)
		LookingForGuildInterestFrame:GetRegions():Hide()
		Aurora.CreateBD(LookingForGuildAvailabilityFrame, .25)
		LookingForGuildAvailabilityFrame:GetRegions():Hide()
		Aurora.CreateBD(LookingForGuildRolesFrame, .25)
		LookingForGuildRolesFrame:GetRegions():Hide()
		Aurora.CreateBD(LookingForGuildCommentFrame, .25)
		LookingForGuildCommentFrame:GetRegions():Hide()
		Aurora.CreateBD(LookingForGuildCommentInputFrame, .12)
		for i = 1, 5 do
			Aurora.CreateBD(_G["LookingForGuildBrowseFrameContainerButton"..i], .25)
		end
		for i = 1, 9 do
			select(i, LookingForGuildCommentInputFrame:GetRegions()):Hide()
		end
		for i = 1, 3 do
			for j = 1, 6 do
				select(j, _G["LookingForGuildFrameTab"..i]:GetRegions()):Hide()
				select(j, _G["LookingForGuildFrameTab"..i]:GetRegions()).Show = Aurora.dummy
			end
		end
		for i = 18, 20 do
			select(i, LookingForGuildFrame:GetRegions()):Hide()
		end
		Aurora.Reskin(LookingForGuildBrowseButton)
		Aurora.Reskin(LookingForGuildRequestButton)
	elseif addon == "Blizzard_MacroUI" then
		local MacroBD = CreateFrame("Frame", nil, MacroFrame)
		MacroBD:SetPoint("TOPLEFT", 12, -10)
		MacroBD:SetPoint("BOTTOMRIGHT", -33, 68)
		MacroBD:SetFrameLevel(MacroFrame:GetFrameLevel()-1)
		Aurora.CreateBD(MacroBD)
		Aurora.CreateSD(MacroBD)
		Aurora.CreateBD(MacroFrameTextBackground, .25)
		Aurora.CreateBD(MacroPopupFrame)
		Aurora.CreateSD(MacroPopupFrame)
		for i = 1, 6 do
			select(i, MacroFrameTab1:GetRegions()):Hide()
			select(i, MacroFrameTab2:GetRegions()):Hide()
			select(i, MacroFrameTab1:GetRegions()).Show = Aurora.dummy
			select(i, MacroFrameTab2:GetRegions()).Show = Aurora.dummy
		end
		for i = 1, 8 do
			if i ~= 6 then select(i, MacroFrame:GetRegions()):Hide() end
		end
		for i = 1, 5 do
			select(i, MacroPopupFrame:GetRegions()):Hide()
		end
		Aurora.Reskin(MacroDeleteButton)
		Aurora.Reskin(MacroNewButton)
		Aurora.Reskin(MacroExitButton)
		Aurora.Reskin(MacroEditButton)
		Aurora.Reskin(MacroPopupOkayButton)
		Aurora.Reskin(MacroPopupCancelButton)
		MacroPopupFrame:ClearAllPoints()
		MacroPopupFrame:SetPoint("LEFT", MacroFrame, "RIGHT", -14, 16)
	elseif addon == "Blizzard_ReforgingUI" then
		Aurora.CreateBD(ReforgingFrame)
		Aurora.CreateSD(ReforgingFrame)
		select(3, ReforgingFrame:GetRegions()):Hide()
		Aurora.Reskin(ReforgingFrameRestoreButton)
		Aurora.Reskin(ReforgingFrameReforgeButton)
	elseif addon == "Blizzard_TalentUI" then
		Aurora.CreateBD(PlayerTalentFrame)
		Aurora.CreateSD(PlayerTalentFrame)
		local talentbuttons = {"PlayerTalentFrameToggleSummariesButton", "PlayerTalentFrameLearnButton", "PlayerTalentFrameResetButton", "PlayerTalentFrameActivateButton"}
		for i = 1, getn(talentbuttons) do
		local reskinbutton = _G[talentbuttons[i]]
			if reskinbutton then
				Aurora.Reskin(reskinbutton)
			end
		end	
		PlayerTalentFramePortrait:Hide()
		PlayerTalentFrameTitleGlowLeft:SetAlpha(0)
		PlayerTalentFrameTitleGlowRight:SetAlpha(0)
		PlayerTalentFrameTitleGlowCenter:SetAlpha(0)
		for i = 1, 3 do
			if _G["PlayerTalentFrameTab"..i] then
				Aurora.CreateTab(_G["PlayerTalentFrameTab"..i])
			end
		end
		for i = 1, 2 do
			local tab = _G["PlayerSpecTab"..i]
			local a1, p, a2, x, y = PlayerSpecTab1:GetPoint()
			local bg = CreateFrame("Frame", nil, tab)
			bg:SetPoint("TOPLEFT", -1, 1)
			bg:SetPoint("BOTTOMRIGHT", 1, -1)
			bg:SetFrameLevel(tab:GetFrameLevel()-1)
			if IsAddOnLoaded("Tukui") and tukuiskin == true then
				hooksecurefunc("PlayerTalentFrame_UpdateTabs", function()
					PlayerSpecTab1:SetPoint(a1, p, a2, x + 5, y + 10)
					PlayerSpecTab2:SetPoint("TOP", PlayerSpecTab1, "BOTTOM")
				end)
				bg:SetPoint("TOPLEFT", -2, 2)
				bg:SetPoint("BOTTOMRIGHT", 2, -2)
				Aurora.CreateBD(bg)
			else
				hooksecurefunc("PlayerTalentFrame_UpdateTabs", function()
					PlayerSpecTab1:SetPoint(a1, p, a2, x + 11, y + 10)
					PlayerSpecTab2:SetPoint("TOP", PlayerSpecTab1, "BOTTOM")
				end)
				Aurora.CreateSD(tab, 5, 0, 0, 0, 1, 1)
				Aurora.CreateBD(bg, 1)
			end
			select(2, tab:GetRegions()):SetTexCoord(.08, .92, .08, .92)
		end
	elseif addon == "Blizzard_TradeSkillUI" then
		Aurora.CreateBD(TradeSkillFrame)
		Aurora.CreateSD(TradeSkillFrame)
		Aurora.CreateBD(TradeSkillGuildFrame)
		Aurora.CreateSD(TradeSkillGuildFrame)
		Aurora.CreateBD(TradeSkillFrameSearchBox, .25)
		Aurora.CreateBD(TradeSkillGuildFrameContainer, .25)

		select(3, TradeSkillFrame:GetRegions()):Hide()
		select(3, TradeSkillFrame:GetRegions()).Show = Aurora.dummy
		for i = 18, 20 do
			select(i, TradeSkillFrame:GetRegions()):Hide()
			select(i, TradeSkillFrame:GetRegions()).Show = Aurora.dummy
		end
		select(21, TradeSkillFrame:GetRegions()):Hide()
		select(22, TradeSkillFrame:GetRegions()):Hide()
		for i = 1, 3 do
			select(i, TradeSkillExpandButtonFrame:GetRegions()):Hide()
			select(i, TradeSkillFilterButton:GetRegions()):Hide()
		end
		for i = 1, 9 do
			select(i, TradeSkillGuildFrame:GetRegions()):Hide()
		end
		for i = 4, 8 do
			select(i, TradeSkillFrameSearchBox:GetRegions()):Hide()
		end

		local a1, p, a2, x, y = TradeSkillGuildFrame:GetPoint()
		TradeSkillGuildFrame:ClearAllPoints()
		TradeSkillGuildFrame:SetPoint(a1, p, a2, x + 16, y)

		local tradeskillbuttons = {"TradeSkillCreateButton", "TradeSkillCreateAllButton", "TradeSkillCancelButton", "TradeSkillViewGuildCraftersButton", "TradeSkillFilterButton"}
		for i = 1, getn(tradeskillbuttons) do
		local button = _G[tradeskillbuttons[i]]
			if button then
				Aurora.Reskin(button)
			end
		end
	elseif addon == "Blizzard_TrainerUI" then
		Aurora.CreateBD(ClassTrainerFrame)
		Aurora.CreateSD(ClassTrainerFrame)
		select(3, ClassTrainerFrame:GetRegions()):Hide()
		select(19, ClassTrainerFrame:GetRegions()):Hide()
		Aurora.Reskin(ClassTrainerTrainButton)
	end
	-- [[ Mac Options ]]

	if IsMacClient() then
		Aurora.CreateBD(MacOptionsFrame)
		MacOptionsFrameHeader:SetTexture("")
		MacOptionsFrameHeader:ClearAllPoints()
		MacOptionsFrameHeader:SetPoint("TOP", MacOptionsFrame, 0, 0)
 
		Aurora.CreateBD(MacOptionsFrameMovieRecording, .25)
		Aurora.CreateBD(MacOptionsITunesRemote, .25)

		local macbuttons = {"MacOptionsButtonKeybindings", "MacOptionsButtonCompress", "MacOptionsFrameCancel", "MacOptionsFrameOkay", "MacOptionsFrameDefaults"}
		for i = 1, getn(macbuttons) do
		local button = _G[macbuttons[i]]
			if button then
				Aurora.Reskin(button)
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

-- TODO: separate it as addonskin rewrite
local SkinAddon = function (addon)
	if addon == "clique" or ((addon == "all") and IsAddOnLoaded("Clique")) then
		print('Skinning Clique')
		-- buttons
		Aurora.Reskin(CliqueConfigPage1ButtonSpell)
		Aurora.Reskin(CliqueConfigPage1ButtonOther)
		Aurora.Reskin(CliqueConfigPage1ButtonOptions)
		Aurora.Reskin(CliqueConfigPage2ButtonBinding)
		Aurora.Reskin(CliqueConfigPage2ButtonSave)
		Aurora.Reskin(CliqueConfigPage2ButtonCancel)
		Aurora.Reskin(CliqueDialogButtonAccept)
		Aurora.Reskin(CliqueDialogButtonBinding)
 
		-- frames
		Aurora.CreateBD(CliqueConfigPage1)
		Aurora.CreateBD(CliqueConfigPage2)
		Aurora.CreateBDSD(CliqueConfig)
		Aurora.CreateBDSD(CliqueDialog)
		Aurora.CreateBD(CliqueClickGrabber)

		CliqueConfigPage1:SetPoint("TOPLEFT", CliqueConfig, 4, -24)
		CliqueConfigPage1:SetPoint("BOTTOMRIGHT", CliqueConfig, -6, 30)
		CliqueConfigPage2:SetPoint("TOPLEFT", CliqueConfig, 4, -24)
		CliqueConfigPage2:SetPoint("BOTTOMRIGHT", CliqueConfig, -6, 30)
		CliqueClickGrabber:SetPoint("TOPLEFT", CliqueConfigPage2, "BOTTOMLEFT", 4, 164)
		CliqueClickGrabber:SetPoint("BOTTOMRIGHT", CliqueConfigPage2, -4, 4)

		-- misc
		CliqueConfigPortrait:Hide()
--[[
		local tab = CliqueSpellTab
		local a1, p, a2, x, y = tab:GetPoint()
		local bg = CreateFrame("Frame", nil, tab)
		bg:SetPoint("TOPLEFT", -1, 1)
		bg:SetPoint("BOTTOMRIGHT", 1, -1)
		bg:SetFrameLevel(tab:GetFrameLevel()-1)
		tab:SetPoint(a1, p, a2, x + 11, y)
		Aurora.CreateSD(tab, 5, 0, 0, 0, 1, 1)
		Aurora.CreateBD(bg, 1)
		select(3, tab:GetRegions()):SetTexCoord(.08, .92, .08, .92)
		select(4, tab:GetRegions()):SetTexCoord(.08, .92, .08, .92)]]
	elseif addon == "Blizzard_RaidUI" or ((addon == "all") and IsAddOnLoaded("Blizzard_RaidUI")) then
		print('Blizzard_RaidUI loaded. Skinning...')
		Aurora.Reskin(RaidFrameRaidBrowserButton)
		Aurora.Reskin(RaidFrameReadyCheckButton)
	end
end


local AddonSkinner = CreateFrame("Frame")
AddonSkinner:RegisterEvent("ADDON_LOADED")
AddonSkinner:RegisterEvent("PLAYER_LOGIN")
AddonSkinner:SetScript("OnEvent", function(self, event, addon)
	if event=="ADDON_LOADED" then
		SkinAddon(addon)
	else
		SkinAddon("all")
	end
end)