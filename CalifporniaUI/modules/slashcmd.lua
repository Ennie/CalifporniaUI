----------------------------------------------------------------------------------------
-- Slash commands
----------------------------------------------------------------------------------------
SlashCmdList["ROLEPOLL"] = function() InitiateRolePoll() end
SLASH_ROLEPOLL1 = "/rp"

SlashCmdList["FRAME"] = function() print(GetMouseFocus():GetName()) end
SLASH_FRAME1 = "/gn"
SLASH_FRAME2 = "/frame"

SlashCmdList["GETPARENT"] = function() print(GetMouseFocus():GetParent():GetName()) end
SLASH_GETPARENT1 = "/gp"
SLASH_GETPARENT2 = "/parent"

SlashCmdList["RELOADUI"] = function() ReloadUI() end
SLASH_RELOADUI1 = "/rl"
SLASH_RELOADUI2 = "/кд"

SlashCmdList["RCSLASH"] = function() DoReadyCheck() end
SLASH_RCSLASH1 = "/rc"
SLASH_RCSLASH2 = "/кс"

SlashCmdList["TICKET"] = function() ToggleHelpFrame() end
SLASH_TICKET1 = "/ticket"
SLASH_TICKET2 = "/gm"
SLASH_TICKET3 = "/гм"

SlashCmdList["DISABLE_ADDON"] = function(s) DisableAddOn(s) end
SLASH_DISABLE_ADDON1 = "/dis"

SlashCmdList["ENABLE_ADDON"] = function(s) EnableAddOn(s) end
SLASH_ENABLE_ADDON1 = "/en"

----------------------------------------------------------------------------------------
-- Disband party or raid(by Monolit)
----------------------------------------------------------------------------------------
SlashCmdList["GROUPDISBAND"] = function()
		local pName = UnitName("player")
		SendChatMessage("Disbanding group.", "RAID" or "PARTY")
		if UnitInRaid("player") then
			for i = 1, GetNumRaidMembers() do
				local name, _, _, _, _, _, _, online = GetRaidRosterInfo(i)
				if online and name ~= pName then
					UninviteUnit(name)
				end
			end
		else
			for i = MAX_PARTY_MEMBERS, 1, -1 do
				if GetPartyMember(i) then
					UninviteUnit(UnitName("party"..i))
				end
			end
		end
		LeaveParty()
end
SLASH_GROUPDISBAND1 = "/rd"
----------------------------------------------------------------------------------------
-- Move watchframe
----------------------------------------------------------------------------------------
local wf = WatchFrame
local wfmove = false 

wf:SetMovable(true);
wf:SetClampedToScreen(false); 
wf:ClearAllPoints()
wf:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", 0, -150)
wf:SetWidth(250)
wf:SetHeight(500)
wf:SetUserPlaced(true)
wf.SetPoint = function() end
--WatchFrameTitle:Hide()
--WatchFrameTitle.Show = CalifporniaCFG.dummy

local function WATCHFRAMELOCK()
	if wfmove == false then
		wfmove = true
		print("WatchFrame unlocked for drag")
		wf:EnableMouse(true);
		wf:RegisterForDrag("LeftButton"); 
		wf:SetScript("OnDragStart", wf.StartMoving); 
		wf:SetScript("OnDragStop", wf.StopMovingOrSizing);
	elseif wfmove == true then
		wf:EnableMouse(false);
		wfmove = false
		print("WatchFrame locked")
	end
end

SLASH_WATCHFRAMELOCK1 = "/wf"
SlashCmdList["WATCHFRAMELOCK"] = WATCHFRAMELOCK