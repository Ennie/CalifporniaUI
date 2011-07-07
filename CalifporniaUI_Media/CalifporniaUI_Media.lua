addonName, ns = ...

local LSM = LibStub("LibSharedMedia-3.0") 

LSM:Register("border", "BackDrop", "Interface\\Addons\\"..addonName.."\\textures\\backdrop.tga" )
LSM:Register("border", "BackDropEdge", "Interface\\Addons\\"..addonName.."\\textures\\backdrop_edge.tga" )
LSM:Register("background", "CoolRaidIcons", "Interface\\Addons\\"..addonName.."\\textures\\raid_icons.blp" )
LSM:Register("statusbar", "Minimalist", "Interface\\Addons\\"..addonName.."\\textures\\minimalist.tga" )
LSM:Register("statusbar", "X-Perl", "Interface\\Addons\\"..addonName.."\\textures\\highlight.tga" )
LSM:Register("font", "Big Noodle Titling", "Interface\\Addons\\"..addonName.."\\fonts\\big_noodle_titling.ttf", LSM.LOCALE_BIT_western + LSM.LOCALE_BIT_ruRU)
LSM:Register("sound", "WhisperSound", "Interface\\Addons\\"..addonName.."\\sounds\\whisper.mp3" )
