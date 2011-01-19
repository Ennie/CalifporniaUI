CalifporniaCFG["chat"] = {
	["enable"] = true,                     -- blah
	["whispersound"] = true,				 -- play a sound when receiving whisper
	["filtersysmsg"] = true,				 -- Your share of loot: x (y deposited to guildbank) => +x (y)
	["chatbar"] = false,
	["chatframewidth"] = 398,
	["chatframeheight"] = 114,
	["editboxwidth"] = 400,
	["editboxheight"] = 20,
	["tabtextcolor"] = { 1,1,1 },
	["ChatFrame"] = {"BOTTOMLEFT", UIParent, "BOTTOMLEFT", 12, 34},
}

local Chat = CreateFrame("Frame")
local tabalpha = 1
local tabnoalpha = 0
local _G = _G
local origs = {}
local type = type

SetCVar("showTimestamps", "none")
InterfaceOptionsSocialPanelTimestamps.cvar = "none"

local font, fontSize = CalifporniaCFG.media.font, 14

-- function to rename channel and other stuff
local AddMessage = function(self, text, ...)
	if(type(text) == "string") then
		text = text:gsub('|h%[(%d+)%. .-%]|h', '|h[%1]|h')
		text = date("[%I:%M:%S] ")..text
	end
	return origs[self](self, text, ...)
end

for i = 1, 10 do
	local x=({_G["ChatFrame"..i.."EditBox"]:GetRegions()})
	x[9]:SetAlpha(0)
	x[10]:SetAlpha(0)
	x[11]:SetAlpha(0)
end


_G.CHAT_BATTLEGROUND_GET = "|Hchannel:Battleground|h".."[BG]".."|h %s:\32"
_G.CHAT_BATTLEGROUND_LEADER_GET = "|Hchannel:Battleground|h".."[BG]".."|h %s:\32"
_G.CHAT_BN_WHISPER_GET = "W from".." %s:\32"
_G.CHAT_BN_WHISPER_SEND = "W to".." %s:\32"
_G.CHAT_BN_WHISPER_INFORM = "W to".." %s:\32"
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
_G.CHAT_WHISPER_SEND = "W to".." %s:\32"
_G.CHAT_WHISPER_INFORM = "W to".." %s:\32"
_G.CHAT_YELL_GET = "%s:\32"
 
_G.CHAT_FLAG_AFK = "|cffFF0000".."[AFK]".."|r "
_G.CHAT_FLAG_DND = "|cffE7E716".."[DND]".."|r "
_G.CHAT_FLAG_GM = "|cff4154F5".."[GM]".."|r "
 
_G.ERR_FRIEND_ONLINE_SS = "|Hplayer:%s|h[%s]|h ".."is now |cff298F00online|r".."!"
_G.ERR_FRIEND_OFFLINE_S = "%s ".."is now |cffff0000offline|r".."!"

function Kill(object)
	if object.UnregisterAllEvents then
		object:UnregisterAllEvents()
	end
	object.Show = dummy
	object:Hide()
end
-- Hide friends micro button (added in 3.3.5)
Kill(FriendsMicroButton)

-- hide chat bubble menu button
Kill(ChatFrameMenuButton)

-- set the chat style
local function SetChatStyle(frame)
	local id = frame:GetID()
	local chat = frame:GetName()
	local tab = _G[chat.."Tab"]
	
	ChatFrameMenuButton:Hide()
	ChatFrameMenuButton:SetScript("OnShow", function(self) self:Hide() end)

	-- always set alpha to 1, don't fade it anymore
	tab:SetAlpha(1)
	tab.SetAlpha = UIFrameFadeRemoveFrame
	
	
	-- hide text when setting chat
--	_G[chat.."TabText"]:Hide()
	
	-- now show text if mouse is found over tab.
--	tab:HookScript("OnEnter", function() _G[chat.."TabText"]:Show() end)
--	tab:HookScript("OnLeave", function() _G[chat.."TabText"]:Hide() end)
	
	_G[chat.."TabText"]:SetTextColor(unpack(CalifporniaCFG["chat"].tabtextcolor))
	_G[chat.."TabText"]:SetFont(font,11,"OUTLINE")
	_G[chat.."TabText"].SetTextColor = CalifporniaCFG.dummy
	local originalpoint = select(2, _G[chat.."TabText"]:GetPoint())
	_G[chat.."TabText"]:SetPoint("LEFT", originalpoint, "RIGHT", 0, -2)
	
	
	-- yeah baby
	_G[chat]:SetClampRectInsets(0,0,0,0)
	
	-- Removes crap from the bottom of the chatbox so it can go to the bottom of the screen.
	_G[chat]:SetClampedToScreen(false)
			
	-- Stop the chat chat from fading out
	_G[chat]:SetFading(false)
	
	-- move the chat edit box
	_G[chat.."EditBox"]:ClearAllPoints();
	_G[chat.."EditBox"]:SetPoint("TOPLEFT", ChatFrame1, "TOPLEFT", -10, 38)
	_G[chat.."EditBox"]:SetPoint("BOTTOMRIGHT", ChatFrame1, "TOPRIGHT", 10, 18)	
	
	-- Hide textures
	for j = 1, #CHAT_FRAME_TEXTURES do
		_G[chat..CHAT_FRAME_TEXTURES[j]]:SetTexture(nil)
	end

	-- Removes Default ChatFrame Tabs texture				
	Kill(_G[format("ChatFrame%sTabLeft", id)])
	Kill(_G[format("ChatFrame%sTabMiddle", id)])
	Kill(_G[format("ChatFrame%sTabRight", id)])

	Kill(_G[format("ChatFrame%sTabSelectedLeft", id)])
	Kill(_G[format("ChatFrame%sTabSelectedMiddle", id)])
	Kill(_G[format("ChatFrame%sTabSelectedRight", id)])
	
	Kill(_G[format("ChatFrame%sTabHighlightLeft", id)])
	Kill(_G[format("ChatFrame%sTabHighlightMiddle", id)])
	Kill(_G[format("ChatFrame%sTabHighlightRight", id)])

	-- Killing off the new chat tab selected feature
	Kill(_G[format("ChatFrame%sTabSelectedLeft", id)])
	Kill(_G[format("ChatFrame%sTabSelectedMiddle", id)])
	Kill(_G[format("ChatFrame%sTabSelectedRight", id)])
	Kill(_G[format("ChatFrame%sTabGlow", id)])
	
	tab.leftSelectedTexture:Hide()
	tab.middleSelectedTexture:Hide()
	tab.rightSelectedTexture:Hide()
	tab.leftSelectedTexture.Show = tab.leftSelectedTexture.Hide
	tab.middleSelectedTexture.Show = tab.middleSelectedTexture.Hide
	tab.rightSelectedTexture.Show = tab.rightSelectedTexture.Hide
	
	-- Kills off the new method of handling the Chat Frame scroll buttons as well as the resize button
	-- Note: This also needs to include the actual frame textures for the ButtonFrame onHover
	Kill(_G[format("ChatFrame%sButtonFrameUpButton", id)])
	Kill(_G[format("ChatFrame%sButtonFrameDownButton", id)])
	Kill(_G[format("ChatFrame%sButtonFrameBottomButton", id)])
	Kill(_G[format("ChatFrame%sButtonFrameMinimizeButton", id)])
	Kill(_G[format("ChatFrame%sButtonFrame", id)])

	-- Kills off the retarded new circle around the editbox
	Kill(_G[format("ChatFrame%sEditBoxFocusLeft", id)])
	Kill(_G[format("ChatFrame%sEditBoxFocusMid", id)])
	Kill(_G[format("ChatFrame%sEditBoxFocusRight", id)])

	-- Kill off editbox artwork
	local a, b, c = select(6, _G[chat.."EditBox"]:GetRegions()); Kill (a); Kill (b); Kill (c)
				
	-- Disable alt key usage
	_G[chat.."EditBox"]:SetAltArrowKeyMode(false)
	
	-- hide editbox on login
	_G[chat.."EditBox"]:Hide()

	-- script to hide editbox instead of fading editbox to 0.35 alpha via IM Style
	_G[chat.."EditBox"]:HookScript("OnEditFocusLost", function(self) self:Hide() end)
	
	-- hide edit box every time we click on a tab
	_G[chat.."Tab"]:HookScript("OnClick", function() _G[chat.."EditBox"]:Hide() end)
	_G[chat.."TabText"]:Show()
			
	-- rename combag log to log
	if _G[chat] == _G["ChatFrame2"] then
		FCF_SetWindowName(_G[chat], "Log")
	end
			
	-- Texture and align the chat edit box
		local editbox = _G["ChatFrame"..id.."EditBox"]
		local left, mid, right = select(6, editbox:GetRegions())
		left:Hide(); mid:Hide(); right:Hide()
		editbox:ClearAllPoints();
		editbox:SetPoint("BOTTOMLEFT", UIParent, 10, 152)
		editbox:SetWidth(CalifporniaCFG["chat"].editboxwidth)
		editbox:SetHeight(CalifporniaCFG["chat"].editboxheight)
		CalifporniaCFG.util.frame1px(editbox)
		CalifporniaCFG.util.frameShadow(editbox)
		
	if _G[chat] ~= _G["ChatFrame2"] then
		origs[_G[chat]] = _G[chat].AddMessage
		_G[chat].AddMessage = AddMessage
	end
end

-- Setup chatframes 1 to 10 on login.
local function SetupChat(self)	
	for i = 1, NUM_CHAT_WINDOWS do
		local frame = _G[format("ChatFrame%s", i)]
		SetChatStyle(frame)
		FCFTab_UpdateAlpha(frame)
	end
				
	-- Remember last channel
	ChatTypeInfo.WHISPER.sticky = 0
	ChatTypeInfo.BN_WHISPER.sticky = 0
	ChatTypeInfo.OFFICER.sticky = 1
	ChatTypeInfo.RAID_WARNING.sticky = 0
	ChatTypeInfo.CHANNEL.sticky = 1
end

local function SetupChatPosAndFont(self)	
	for i = 1, NUM_CHAT_WINDOWS do
		local chat = _G[format("ChatFrame%s", i)]
		local tab = _G[format("ChatFrame%sTab", i)]
		local id = chat:GetID()
		local name = FCF_GetChatWindowInfo(id)
		local point = GetChatWindowSavedPosition(id)
		local _, fontSize = FCF_GetChatWindowInfo(id)
		
--[[		-- well... tukui font under fontsize 12 is unreadable.
		if fontSize < 12 then		
			FCF_SetChatWindowFontSize(nil, chat, 12)
		else
			FCF_SetChatWindowFontSize(nil, chat, fontSize)
		end
	]]	
		-- force chat position on #1 and #4, needed if we change ui scale or resolution
		-- also set original width and height of chatframes 1 and 4 if first time we run tukui.
		-- doing resize of chat also here for users that hit "cancel" when default installation is show.
		ChatFrame1:ClearAllPoints()
		ChatFrame1:SetPoint(unpack(CalifporniaCFG["chat"].ChatFrame))
	end
			
	-- reposition battle.net popup over chat #1
	BNToastFrame:HookScript("OnShow", function(self)
		self:ClearAllPoints()
		self:SetPoint("BOTTOMLEFT", ChatFrame1, "TOPLEFT", 0, 5)
	end)
end

Chat:RegisterEvent("ADDON_LOADED")
Chat:RegisterEvent("PLAYER_ENTERING_WORLD")
Chat:SetScript("OnEvent", function(self, event, ...)
	for i = 1, NUM_CHAT_WINDOWS do
		_G["ChatFrame"..i]:SetClampRectInsets(0,0,0,0)
		_G["ChatFrame"..i]:SetWidth(CalifporniaCFG["chat"].chatframewidth)
		_G["ChatFrame"..i]:SetHeight(CalifporniaCFG["chat"].chatframeheight)
	end	
	local addon = ...
	if event == "ADDON_LOADED" then
		if addon == "Blizzard_CombatLog" then
			self:UnregisterEvent("ADDON_LOADED")
			SetupChat(self)
			--return CombatLogQuickButtonFrame_Custom:SetAlpha(.4)
		end
	elseif event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		SetupChatPosAndFont(self)
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

REURL_COLOR = "16FF5D"
ReURL_Brackets = false
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
		button:SetHeight(22)
		button:SetWidth(20)
		button:SetPoint("BOTTOMLEFT" , UIParent, "BOTTOMLEFT", 398, 155)
				
		local buttontext = button:CreateFontString(nil,"OVERLAY",nil)
		buttontext:SetFont(font,12,"OUTLINE")
		buttontext:SetText("C")
		buttontext:SetPoint("CENTER", 1, 0)
		buttontext:SetJustifyH("CENTER")
		buttontext:SetJustifyV("CENTER")
		buttontext:SetTextColor(1,1,1,0.5)
						
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
