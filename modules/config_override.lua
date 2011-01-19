----------------------------------------------------------------------------
-- Simply loads all saved variables, and replaces config file values if match. Also cleans saved variables from crap
----------------------------------------------------------------------------
if CalifporniaData == nil or CalifporniaData.Config == nil then return end

for group,options in pairs(CalifporniaData.Config) do
	if Califpornia.CFG[group] then
		local count = 0
		for option,value in pairs(options) do
			if Califpornia.CFG[group][option] ~= nil then
				if Califpornia.CFG[group][option] == value then
					CalifporniaData.Config[group][option] = nil	
				else
					count = count+1
					Califpornia.CFG[group][option] = value
				end
			end
		end
		if count == 0 then CalifporniaData.Config[group] = nil end
	else
		CalifporniaData.Config[group] = nil
	end
end 