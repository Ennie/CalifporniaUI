--------------------------------------------------------------------
 -- UNIT SPEED
--------------------------------------------------------------------
if CalifporniaCFG["datatext"].speed and Califpornia.CFG["datatext"].speed > 0 then
	local Stat = CreateFrame("Frame")
	Stat:EnableMouse(true)
	Stat:SetFrameStrata("BACKGROUND")
	Stat:SetFrameLevel(3)

	local Text  =Califpornia.Panels.CreateDataText(Califpornia.CFG["datatext"].speed)

	local Stat = CreateFrame("Frame")
	Stat:SetScript("OnUpdate", function()
		Text:SetText(format("Speed: %d%%", GetUnitSpeed("player")  / 7 * 100))
	end)
end