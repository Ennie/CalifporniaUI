----------------------------------------------------------------
-- CALIFPORNIAUI VARS
----------------------------------------------------------------

Califpornia = {}

-- Saved variables
Califpornia.DB = CalifporniaData

-- Config
Califpornia.CFG = {}

-- Player info
Califpornia.myname = UnitName("player")
_, Califpornia.myclass = UnitClass("player") 
Califpornia.mylevel = UnitLevel("player")
Califpornia.incombat = UnitAffectingCombat("player")

-- AddOn and Client info
Califpornia.Version = GetAddOnMetadata("CalifporniaUI", "Version")
Califpornia.patch = GetBuildInfo()
Califpornia.res_x, Califpornia.res_y = strsplit("x", ({GetScreenResolutions()})[GetCurrentResolution()])
Califpornia.locale = GetLocale()

-- Class colors
Califpornia.colors = { }
-- this is hack for me, if you like stupid pink color, delete or comment next four lines
local color_class = Califpornia.myclass
if color_class == 'PALADIN' then
	color_class = 'DEATHKNIGHT'
end
Califpornia.colors.class_colors = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)
local color = Califpornia.colors.class_colors[color_class]
Califpornia.colors.m_color = color
Califpornia.colors.m_backdrop = {color.r/10, color.g/10, color.b/10, 0.7}
Califpornia.colors.m_border = {color.r/3, color.g/3, color.b/3, 0.9}


--OLD STUFF



CalifporniaCFG = { }
Califpornia.CFG = CalifporniaCFG
CalifporniaLocal = { }

CalifporniaCFG.dummy = function() return end
CalifporniaCFG.myname, _ = UnitName("player")
_, CalifporniaCFG.myclass = UnitClass("player") 
CalifporniaCFG.client = GetLocale() 
CalifporniaCFG.resolution = GetCurrentResolution()
CalifporniaCFG.getscreenresolution = select(CalifporniaCFG.resolution, GetScreenResolutions())
CalifporniaCFG.version = GetAddOnMetadata("Tukui", "Version")
CalifporniaCFG.incombat = UnitAffectingCombat("player")
CalifporniaCFG.patch = GetBuildInfo()
CalifporniaCFG.level = UnitLevel("player")

CalifporniaCFG.colors = { }
local color_class = CalifporniaCFG.myclass
if color_class == 'PALADIN' then
	color_class = 'DEATHKNIGHT'
end
CalifporniaCFG.colors.all_class_colors = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)
local color = CalifporniaCFG.colors.all_class_colors[color_class]
CalifporniaCFG.colors.class_color = color
CalifporniaCFG.colors.class_backdrop = {color.r/10, color.g/10, color.b/10, 0.7}
CalifporniaCFG.colors.class_backdrop_border = {color.r/3, color.g/3, color.b/3, 0.9}
