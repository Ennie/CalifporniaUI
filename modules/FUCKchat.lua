if not CalifporniaCFG.chat.enable then return end


SetCVar("showTimestamps", "none")
InterfaceOptionsSocialPanelTimestamps.cvar = "none"

local _G = _G
local hooks = {}
local type = type


local Chat = CreateFrame("Frame")


-- Global constants
_G.CHAT_BATTLEGROUND_GET = "|Hchannel:Battleground|h".."[BG]".."|h %s:\32"
_G.CHAT_BATTLEGROUND_LEADER_GET = "|Hchannel:Battleground|h".."[BG]".."|h %s:\32"
_G.CHAT_BN_WHISPER_GET = "W from".." %s:\32"
_G.CHAT_BN_WHISPER_INFORM_GET = "W to".." %s:\32"
_G.CHAT_BN_WHISPER_SEND = "W to".." %s:\32"
_G.CHAT_GUILD_GET = "|Hchannel:Guild|h".."[G]".."|h %s:\32"
_G.CHAT_OFFICER_GET = "|Hchannel:o|h".."[O]".."|h %s:\32"
_G.CHAT_PARTY_GET = "|Hchannel:Party|h".."[P]".."|h %s:\32"
_G.CHAT_PARTY_GUIDE_GET = "|Hchannel:party|h".."[P]".."|h %s:\32"
_G.CHAT_PARTY_LEADER_GET = "|Hchannel:party|h".."[P]".."|h %s:\32"
_G.CHAT_RAID_GET = "|Hchannel:raid|h".."[R]".."|h %s:\32"
_G.CHAT_RAID_LEADER_GET = "|Hchannel:raid|h".."[R]".."|h %s:\32"
_G.CHAT_RAID_WARNING_GET = "[W]".." %s:\32"
_G.CHAT_SAY_GET = "%s:\32"
_G.CHAT_WHISPER_GET = "W from".." %s:\32"
_G.CHAT_WHISPER_INFORM_GET = "W to".." %s:\32"
_G.CHAT_WHISPER_SEND = "W to".." %s:\32"
_G.CHAT_YELL_GET = "%s:\32"
_G.CHAT_MONSTER_YELL_GET = "%s: "
_G.CHAT_MONSTER_WHISPER_GET = "From %s: "
_G.CHAT_CHANNEL_LIST_GET = "|Hchannel:%d|h%s|h:\32"
_G.CHAT_YOU_CHANGED_NOTICE = "Changed: |Hchannel:%d|h%s|h"
_G.CHAT_YOU_JOINED_NOTICE = "Joined: |Hchannel:%d|h%s|h"
_G.CHAT_YOU_LEFT_NOTICE = "Left: |Hchannel:%d|h%s|h"
_G.CHAT_SUSPENDED_NOTICE = "Banned from: |Hchannel:%d|h%s|h ";

_G.CHAT_FLAG_AFK = "|cffFF0000".."[AFK]".."|r "
_G.CHAT_FLAG_DND = "|cffE7E716".."[DND]".."|r "
_G.CHAT_FLAG_GM = "|cff4154F5".."[GM]".."|r "
 
_G.ERR_FRIEND_ONLINE_SS = "|Hplayer:%s|h[%s]|h ".."is now |cff298F00online|r".."!"
_G.ERR_FRIEND_OFFLINE_S = "%s ".."is now |cffff0000offline|r".."!"




local function AddMessage(self, text, ...)
	if(type(text) == "string") then
		text = text:gsub('|h%[(%d+)%. .-%]|h', '|h[%1]|h')
		text = string.format("|h%s[%s]|r|h %s", "|cff999999", date("%H:%M.%S"), text)
	end
	return hooks[self](self, text, ...)
end


-- blah
local function SetChatInputStyle(id)
	-- Kills off the retarded new circle around the editbox
	Califpornia.kill(_G["ChatFrame"..id.."EditBoxFocusLeft"])
	Califpornia.kill(_G["ChatFrame"..id.."EditBoxFocusMid"])
	Califpornia.kill(_G["ChatFrame"..id.."EditBoxFocusRight"])

	-- Kill off editbox artwork
	local a, b, c = select(6, _G["ChatFrame"..id.."EditBox"]:GetRegions()); 
	Califpornia.kill(a);
	Califpornia.kill(b);
	Califpornia.kill(c)
				
	-- Disable alt key usage
	_G["ChatFrame"..id.."EditBox"]:SetAltArrowKeyMode(false)
	
	-- hide editbox on login
	_G["ChatFrame"..id.."EditBox"]:Hide()

	-- script to hide editbox instead of fading editbox to 0.35 alpha via IM Style
	_G["ChatFrame"..id.."EditBox"]:HookScript("OnEditFocusLost", function(self) self:Hide() end)

	_G["ChatFrame"..id.."Tab"]:HookScript("OnClick", function() _G["ChatFrame"..id.."EditBox"]:Hide() end)

	local editbox = _G["ChatFrame"..id.."EditBox"]
	local eheader = _G["ChatFrame"..id.."EditBoxHeader"]
	local left, mid, right = select(6, editbox:GetRegions())
	left:Hide(); mid:Hide(); right:Hide()
	editbox:ClearAllPoints();
	editbox:SetPoint("BOTTOMLEFT", Califpornia.Panels.chat, "TOPLEFT", 0, Califpornia.CFG.panels.spacer)
	editbox:SetWidth(Califpornia.Panels.chat:GetWidth())
	editbox:SetHeight(Califpornia.CFG["chat"].editboxheight)
	editbox:SetFont(unpack(Califpornia.CFG.chat.editboxfont))
	eheader:SetFont(unpack(Califpornia.CFG.chat.editboxfont))
	Califpornia.Lib.frame1px(editbox)
	Califpornia.Lib.frameShadow(editbox)
end

local function SetChatTabStyle(id)
	local tab = _G["ChatFrame"..id.."Tab"]

	-- Removes Default ChatFrame Tabs texture				
	Kill(_G["ChatFrame"..id.."TabLeft"])
	Kill(_G["ChatFrame"..id.."TabMiddle"])
	Kill(_G["ChatFrame"..id.."TabRight"])

	Kill(_G["ChatFrame"..id.."TabSelectedLeft"])
	Kill(_G["ChatFrame"..id.."TabSelectedMiddle"])
	Kill(_G["ChatFrame"..id.."TabSelectedRight"])
	
	Kill(_G["ChatFrame"..id.."TabHighlightLeft"])
	Kill(_G["ChatFrame"..id.."TabHighlightMiddle"])
	Kill(_G["ChatFrame"..id.."TabHighlightRight"])

	-- Killing off the new chat tab selected feature
	Kill(_G["ChatFrame"..id.."TabSelectedLeft"])
	Kill(_G["ChatFrame"..id.."TabSelectedMiddle"])
	Kill(_G["ChatFrame"..id.."TabSelectedRight"])
	Kill(_G["ChatFrame"..id.."TabGlow"])
	
	tab.leftSelectedTexture:Hide()
	tab.middleSelectedTexture:Hide()
	tab.rightSelectedTexture:Hide()
	tab.leftSelectedTexture.Show = tab.leftSelectedTexture.Hide
	tab.middleSelectedTexture.Show = tab.middleSelectedTexture.Hide
	tab.rightSelectedTexture.Show = tab.rightSelectedTexture.Hide

--	local  op = tab:GetPoint()
--	tab:SetPoint()

	_G["ChatFrame"..id.."TabText"]:SetTextColor(unpack(Califpornia.CFG["chat"].tabtextcolor))
	_G["ChatFrame"..id.."TabText"]:SetFont(unpack(Califpornia.CFG.chat.tabfont))
	_G["ChatFrame"..id.."TabText"].SetTextColor = Califpornia.dummy
--	local originalpoint = select(2, _G["ChatFrame"..id.."TabText"]:GetPoint())
--	_G["ChatFrame"..id.."TabText"]:SetPoint("LEFT", originalpoint, "RIGHT", -2, -2)
	_G["ChatFrame"..id.."TabText"]:Show()
	_G["ChatFrame"..id.."TabText"]:SetAlpha(1)

end

local function RemoveChatButtons(id)
	Califpornia.kill(_G["ChatFrame"..id.."ButtonFrameUpButton"])
	Califpornia.kill(_G["ChatFrame"..id.."ButtonFrameDownButton"])
	Califpornia.kill(_G["ChatFrame"..id.."ButtonFrameBottomButton"])
	Califpornia.kill(_G["ChatFrame"..id.."ButtonFrameMinimizeButton"])
	Califpornia.kill(_G["ChatFrame"..id.."ButtonFrame"])
end


function SetChatPos(frame)
	frame:ClearAllPoints()
--	frame:SetPoint("BOTTOMLEFT", TukuiInfoLeft, "TOPLEFT", 0, TukuiDB.Scale(6))
	frame:SetPoint("TOPLEFT", Califpornia.Panels.chat, "TOPLEFT", 2, -2)
	frame:SetPoint("BOTTOMRIGHT", Califpornia.Panels.chat, "BOTTOMRIGHT", -2, 2)
	FCF_SavePositionAndDimensions(frame)
end

local function SetChatStyle(frame)
	local id = frame:GetID()
	local chat = frame:GetName()

	-- kill crap

	-- yeah baby
	_G[chat]:SetClampRectInsets(0,0,0,0)
	
	-- Removes crap from the bottom of the chatbox so it can go to the bottom of the screen.
	_G[chat]:SetClampedToScreen(false)
			
	-- Stop the chat chat from fading out
	_G[chat]:SetFading(false)
	RemoveChatButtons(id)
	SetChatTabStyle(id)
	SetChatInputStyle(id)


	SetChatPos(_G[chat])
	-- reassign AddMessage if not combat log
	if _G[chat] ~= _G["ChatFrame2"] then
		hooks[_G[chat]] = _G[chat].AddMessage
		_G[chat].AddMessage = AddMessage
	end
end


--Chat:RegisterEvent("ADDON_LOADED")
Chat:RegisterEvent("PLAYER_ENTERING_WORLD")
Chat:SetScript("OnEvent", function(self, event, ...)
	Califpornia.kill(ChatFrameMenuButton)
	Califpornia.kill(FriendsMicroButton)
	for i = 1, NUM_CHAT_WINDOWS do
		local frame = _G[format("ChatFrame%s", i)]
		SetChatStyle(frame)
		FCFTab_UpdateAlpha(frame)
	end
end)


-- Setup temp chat (BN, WHISPER) when needed.
local function SetupTempChat()
	local frame = FCF_GetCurrentChatFrame()
	SetChatStyle(frame)
end
hooksecurefunc("FCF_OpenTemporaryWindow", SetupTempChat)


------------------------------------------------------------------------
--	Enhance/rewrite a Blizzard feature, chatframe mousewheel.
------------------------------------------------------------------------

local ScrollLines = 3 -- set the jump when a scroll is done !
function FloatingChatFrame_OnMouseScroll(self, delta)
	if delta < 0 then
		if IsShiftKeyDown() then
			self:ScrollToBottom()
		else
			for i = 1, ScrollLines do
				self:ScrollDown()
			end
		end
	elseif delta > 0 then
		if IsShiftKeyDown() then
			self:ScrollToTop()
		else
			for i = 1, ScrollLines do
				self:ScrollUp()
			end
		end
	end
end
------------------------------------------------------------------------
--	 copy chat links
------------------------------------------------------------------------
local SetItemRef_orig = SetItemRef
function ReURL_SetItemRef(link, text, button, chatFrame)
	if (strsub(link, 1, 3) == "url") then
		local ChatFrameEditBox = ChatEdit_ChooseBoxForSend()
		local url = strsub(link, 5);
		if (not ChatFrameEditBox:IsShown()) then
			ChatEdit_ActivateChat(ChatFrameEditBox)
		end
		ChatFrameEditBox:Insert(url)
		ChatFrameEditBox:HighlightText()

	else
		SetItemRef_orig(link, text, button, chatFrame)
	end
end
SetItemRef = ReURL_SetItemRef

function ReURL_AddLinkSyntax(chatstring)
	if (type(chatstring) == "string") then
		local extraspace;
		if (not strfind(chatstring, "^ ")) then
			extraspace = true;
			chatstring = " "..chatstring;
		end
		chatstring = gsub (chatstring, " www%.([_A-Za-z0-9-]+)%.(%S+)%s?", ReURL_Link("www.%1.%2"))
		chatstring = gsub (chatstring, " (%a+)://(%S+)%s?", ReURL_Link("%1://%2"))
		chatstring = gsub (chatstring, " ([_A-Za-z0-9-%.]+)@([_A-Za-z0-9-]+)(%.+)([_A-Za-z0-9-%.]+)%s?", ReURL_Link("%1@%2%3%4"))
		chatstring = gsub (chatstring, " (%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?):(%d%d?%d?%d?%d?)%s?", ReURL_Link("%1.%2.%3.%4:%5"))
		chatstring = gsub (chatstring, " (%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%s?", ReURL_Link("%1.%2.%3.%4"))
		if (extraspace) then
			chatstring = strsub(chatstring, 2);
		end
	end
	return chatstring
end

REURL_COLOR = "9999FF"
ReURL_Brackets = true
ReUR_CustomColor = true

function ReURL_Link(url)
	if (ReUR_CustomColor) then
		if (ReURL_Brackets) then
			url = " |cff"..REURL_COLOR.."|Hurl:"..url.."|h["..url.."]|h|r "
		else
			url = " |cff"..REURL_COLOR.."|Hurl:"..url.."|h"..url.."|h|r "
		end
	else
		if (ReURL_Brackets) then
			url = " |Hurl:"..url.."|h["..url.."]|h "
		else
			url = " |Hurl:"..url.."|h"..url.."|h "
		end
	end
	return url
end

--Hook all the AddMessage funcs
for i=1, NUM_CHAT_WINDOWS do
	local frame = getglobal("ChatFrame"..i)
	local addmessage = frame.AddMessage
	frame.AddMessage = function(self, text, ...) addmessage(self, ReURL_AddLinkSyntax(text), ...) end
end
-----------------------------------------------------------------------------
-- Copy Chat (by Shestak)
-----------------------------------------------------------------------------
local lines = {}
local frame = nil
local editBox = nil
local isf = nil

local function CreatCopyFrame()
	frame = CreateFrame("Frame", "CopyFrame", UIParent)
	frame:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8x8",
			edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
			tile = 0, tileSize = 0, edgeSize = 1, 
			insets = { left = -1, right = -1, top = -1, bottom = -1 }
	})
	frame:SetBackdropColor(unpack(CalifporniaCFG.colors.class_backdrop))
	frame:SetBackdropBorderColor(unpack(CalifporniaCFG.colors.class_backdrop_border))
	
	frame:SetWidth(500)
	frame:SetHeight(300)
	frame:SetScale(0.9)
	frame:SetPoint("LEFT", UIParent, "LEFT", 10, 0)
	frame:Hide()
	frame:SetFrameStrata("DIALOG")
	CalifporniaCFG.util.frameShadow(frame)
	local scrollArea = CreateFrame("ScrollFrame", "CopyScroll", frame, "UIPanelScrollFrameTemplate")
	scrollArea:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -30)
	scrollArea:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 8)
	editBox = CreateFrame("EditBox", "CopyBox", frame)
	editBox:SetMultiLine(true)
	editBox:SetMaxLetters(99999)
	editBox:EnableMouse(true)
	editBox:SetAutoFocus(false)
	editBox:SetFontObject(ChatFontNormal)
	editBox:SetWidth(500)
	editBox:SetHeight(300)
	editBox:SetScript("OnEscapePressed", function() frame:Hide() end)
	scrollArea:SetScrollChild(editBox)
	local close = CreateFrame("Button", "CopyCloseButton", frame, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", frame, "TOPRIGHT")
	isf = true
end

local function GetLines(...)
	--[[		Grab all those lines		]]--
	local ct = 1
	for i = select("#", ...), 1, -1 do
		local region = select(i, ...)
		if region:GetObjectType() == "FontString" then
			lines[ct] = tostring(region:GetText())
			ct = ct + 1
		end
	end
	return ct - 1
end

local function Copy(cf)
	local _, size = cf:GetFont()
	FCF_SetChatWindowFontSize(cf, cf, 0.01)
	local lineCt = GetLines(cf:GetRegions())
	local text = table.concat(lines, "\n", 1, lineCt)
	FCF_SetChatWindowFontSize(cf, cf, size)
	if not isf then CreatCopyFrame() end
	frame:Show()
	editBox:SetText(text)
	editBox:HighlightText(0)
end

function ChatCopyButtons()
	for i = 1, NUM_CHAT_WINDOWS do
		local cf = _G[format("ChatFrame%d",  i)]

		local button = CreateFrame("Button", format("ButtonCF%d", i), cf)
		button:SetPoint("BOTTOMRIGHT", Califpornia.Panels.chat, "TOPRIGHT", 4, 2)
		button:SetHeight(20)
		button:SetWidth(20)
		button:SetAlpha(0.8)
--		SettingsDB.SkinFadedPanel(button)
--		button:SetBackdropBorderColor(SettingsDB.color.r, SettingsDB.color.g, SettingsDB.color.b)

		local buttontexture = button:CreateTexture(nil, "BORDER")
		buttontexture:SetPoint("CENTER")
		buttontexture:SetTexture("Interface\\BUTTONS\\UI-GuildButton-PublicNote-Up")
		buttontexture:SetHeight(16)
		buttontexture:SetWidth(16)
						
		button:SetScript("OnMouseUp", function(self, btn)
			if i == 1 and btn == "RightButton" then
				ToggleFrame(ChatMenu)
			else
				Copy(cf)
			end
		end)
	end
end
ChatCopyButtons()
------------------------------------------------------------------------
--	 /tt - tell your current target.
------------------------------------------------------------------------
for i = 1, NUM_CHAT_WINDOWS do
	local editBox = _G["ChatFrame"..i.."EditBox"]
	editBox:HookScript("OnTextChanged", function(self)
	   local text = self:GetText()
	   if text:len() < 5 then
		  if text:sub(1, 4) == "/tt " then
			 local unitname, realm
			 unitname, realm = UnitName("target")
			 if unitname then unitname = gsub(unitname, " ", "") end
			 if unitname and not UnitIsSameServer("player", "target") then
				unitname = unitname .. "-" .. gsub(realm, " ", "")
			 end
			 ChatFrame_SendTell((unitname or "Invalid Target"), ChatFrame1)
		  end
	   end
	end)
end

------------------------------------------------------------------------
--	Play sound files system
------------------------------------------------------------------------

if CalifporniaCFG.chat.whispersound then
	local SoundSys = CreateFrame("Frame")
	SoundSys:RegisterEvent("CHAT_MSG_WHISPER")
	SoundSys:RegisterEvent("CHAT_MSG_BN_WHISPER")
	SoundSys:HookScript("OnEvent", function(self, event, ...)
		if event == "CHAT_MSG_WHISPER" or "CHAT_MSG_BN_WHISPER" then
			PlaySoundFile(CalifporniaCFG["media"].whisper)
		end
	end)
end

if CalifporniaCFG.chat.filtersysmsg then
	local frame = CreateFrame("FRAME", "CashFlowLiteFrame");
	frame:RegisterEvent('PLAYER_LOGIN');
	local function eventHandler(self, event, ...)
		COPPER_AMOUNT = "%d|cFF954F28"..COPPER_AMOUNT_SYMBOL.."|r";
		SILVER_AMOUNT = "%d|cFFC0C0C0"..SILVER_AMOUNT_SYMBOL.."|r";
		GOLD_AMOUNT = "%d|cFFF0D440"..GOLD_AMOUNT_SYMBOL.."|r";
		YOU_LOOT_MONEY = "+%s";
		YOU_LOOT_MONEY_GUILD = "+%s (%s)";
		LOOT_MONEY_SPLIT = "+%s.";
		LOOT_MONEY_SPLIT_GUILD = "+%s. (%s)";
	end
	frame:SetScript("OnEvent", eventHandler);
end

----------------------------------------------------------------------------------------
-- Chat settings command, thx to Tukz
----------------------------------------------------------------------------------------

if CalifporniaCFG.chat.enable == true then
	local function SetChatSetz()
		FCF_ResetChatWindows()
		FCF_SetWindowName(ChatFrame1, "Gen")
		SetChatStyle(ChatFrame1)
		FCF_SetLocked(ChatFrame1, 1)
		FCF_DockFrame(ChatFrame2)
		FCF_SetWindowName(ChatFrame2, "Log")
		SetChatStyle(ChatFrame2)
		FCF_SetLocked(ChatFrame2, 1)
		FCF_OpenNewWindow('Private')
		FCF_DockFrame(ChatFrame3)
		SetChatStyle(ChatFrame3)
		FCF_SetLocked(ChatFrame3, 1)
		FCF_OpenNewWindow('Spam')
		FCF_DockFrame(ChatFrame4)
		SetChatStyle(ChatFrame4)
		FCF_SetLocked(ChatFrame4, 1)
--		ChatFrame4:Show()
--		for i = 1, NUM_CHAT_WINDOWS do
--			_G["ChatFrame"..i]:SetClampRectInsets(0,0,0,0)
--			_G["ChatFrame"..i]:SetWidth(CalifporniaCFG["chat"].chatframewidth)
--			_G["ChatFrame"..i]:SetHeight(CalifporniaCFG["chat"].chatframeheight)
--		end

		ChatFrame_RemoveAllMessageGroups(ChatFrame1)
		ChatFrame_AddMessageGroup(ChatFrame1, "SAY")
		ChatFrame_AddMessageGroup(ChatFrame1, "EMOTE")
		ChatFrame_AddMessageGroup(ChatFrame1, "YELL")
		ChatFrame_AddMessageGroup(ChatFrame1, "GUILD")
		ChatFrame_AddMessageGroup(ChatFrame1, "OFFICER")
		ChatFrame_AddMessageGroup(ChatFrame1, "GUILD_ACHIEVEMENT")
		ChatFrame_AddMessageGroup(ChatFrame1, "WHISPER")
		ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_SAY")
		ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_EMOTE")
		ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_YELL")
		ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_WHISPER")
		ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_BOSS_EMOTE")
		ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_BOSS_WHISPER")
		ChatFrame_AddMessageGroup(ChatFrame1, "PARTY")
		ChatFrame_AddMessageGroup(ChatFrame1, "PARTY_LEADER")
		ChatFrame_AddMessageGroup(ChatFrame1, "RAID")
		ChatFrame_AddMessageGroup(ChatFrame1, "RAID_LEADER")
		ChatFrame_AddMessageGroup(ChatFrame1, "RAID_WARNING")
		ChatFrame_AddMessageGroup(ChatFrame1, "BATTLEGROUND")
		ChatFrame_AddMessageGroup(ChatFrame1, "BATTLEGROUND_LEADER")
		ChatFrame_AddMessageGroup(ChatFrame1, "BG_HORDE")
		ChatFrame_AddMessageGroup(ChatFrame1, "BG_ALLIANCE")
		ChatFrame_AddMessageGroup(ChatFrame1, "BG_NEUTRAL")
		ChatFrame_AddMessageGroup(ChatFrame1, "SYSTEM")
		ChatFrame_AddMessageGroup(ChatFrame1, "ERRORS")
		ChatFrame_AddMessageGroup(ChatFrame1, "AFK")
		ChatFrame_AddMessageGroup(ChatFrame1, "DND")
		ChatFrame_AddMessageGroup(ChatFrame1, "IGNORED")
		ChatFrame_AddMessageGroup(ChatFrame1, "ACHIEVEMENT")
		ChatFrame_AddMessageGroup(ChatFrame1, "BN_WHISPER")
		ChatFrame_AddMessageGroup(ChatFrame1, "BN_CONVERSATION")
		ChatFrame_AddMessageGroup(ChatFrame1, "BN_INLINE_TOAST_ALERT")

		ChatFrame_RemoveAllMessageGroups(ChatFrame3)
		ChatFrame_AddMessageGroup(ChatFrame3, "WHISPER")
		ChatFrame_AddMessageGroup(ChatFrame3, "BN_WHISPER")

		ChatFrame_RemoveAllMessageGroups(ChatFrame4)
		ChatFrame_AddMessageGroup(ChatFrame4, "COMBAT_XP_GAIN")
		ChatFrame_AddMessageGroup(ChatFrame4, "COMBAT_HONOR_GAIN")
		ChatFrame_AddMessageGroup(ChatFrame4, "COMBAT_FACTION_CHANGE")
		ChatFrame_AddMessageGroup(ChatFrame4, "LOOT")
		ChatFrame_AddMessageGroup(ChatFrame4, "MONEY")


		ToggleChatColorNamesByClassGroup(true, "SAY")
		ToggleChatColorNamesByClassGroup(true, "EMOTE")
		ToggleChatColorNamesByClassGroup(true, "YELL")
		ToggleChatColorNamesByClassGroup(true, "GUILD")
		ToggleChatColorNamesByClassGroup(true, "OFFICER")
		ToggleChatColorNamesByClassGroup(true, "GUILD_ACHIEVEMENT")
		ToggleChatColorNamesByClassGroup(true, "ACHIEVEMENT")
		ToggleChatColorNamesByClassGroup(true, "WHISPER")
		ToggleChatColorNamesByClassGroup(true, "PARTY")
		ToggleChatColorNamesByClassGroup(true, "PARTY_LEADER")
		ToggleChatColorNamesByClassGroup(true, "RAID")
		ToggleChatColorNamesByClassGroup(true, "RAID_LEADER")
		ToggleChatColorNamesByClassGroup(true, "RAID_WARNING")
		ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND")
		ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND_LEADER")	
		ToggleChatColorNamesByClassGroup(true, "CHANNEL1")
		ToggleChatColorNamesByClassGroup(true, "CHANNEL2")
		ToggleChatColorNamesByClassGroup(true, "CHANNEL3")
		ToggleChatColorNamesByClassGroup(true, "CHANNEL4")
		ToggleChatColorNamesByClassGroup(true, "CHANNEL5")
		ReloadUI()
	end
	SLASH_SETCHAT1 = "/setchat"
	SlashCmdList["SETCHAT"] = SetChatSetz
end