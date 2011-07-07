----------------------------------------------------------------------------
-- Simply loads all saved variables, and replaces config file values if match. Also cleans saved variables from crap
----------------------------------------------------------------------------
local function LoadConfigFromVar(conf)
	print ('loading config')
	if conf == nil then return end
	for group,options in pairs(conf) do
		if Califpornia.CFG[group] then
			local count = 0
			for option,value in pairs(options) do
				if Califpornia.CFG[group][option] ~= nil then
					if Califpornia.CFG[group][option] == value then
						conf[group][option] = nil	
					else
						count = count+1
						Califpornia.CFG[group][option] = value
					end
				end
			end
			if count == 0 then conf[group] = nil end
		else
			conf[group] = nil
		end
	end 
end

LoadConfigFromVar(Califpornia.DB.Config)
-- Load character settings
if Califpornia.DB.CharConfig == nil or Califpornia.DB.CharConfig[Califpornia.myrealm] == nil then return end
LoadConfigFromVar(Califpornia.DB.CharConfig[Califpornia.myrealm][Califpornia.myname])
