
Mod_AddonSkins = CreateFrame("Frame")
local Mod_AddonSkins = Mod_AddonSkins

function Mod_AddonSkins:SkinFrame(frame)
	Califpornia.CreateBD1px(frame)
	Califpornia.CreateShadow(frame)
--	frame1px(frame)
--	CreateShadow(frame)
end

function Mod_AddonSkins:SkinBackgroundFrame(frame)
	self:SkinFrame(frame)
end

function Mod_AddonSkins:SkinButton(button)
	Califpornia.SkinUIButton(button)
--	self:SkinFrame(button)
--	StyleButton(button,button.GetCheckedTexture and button:GetCheckedTexture())
end

function Mod_AddonSkins:SkinActionButton(button)
	if not button then return end
	self:SkinButton(button)
	local name = button:GetName()
	button.count = button.count or _G[name.."Count"]
	if button.count then
		button.count:SetFont(self.font,self.fontSize,self.fontFlags)
		button.count:SetDrawLayer("OVERLAY")
	end
	button.hotkey = button.hotkey or _G[name.."HotKey"]
	if button.hotkey then
		button.hotkey:SetFont(self.font,self.fontSize,self.fontFlags)
		button.hotkey:SetDrawLayer("OVERLAY")
	end
	button.icon = button.icon or _G[name.."Icon"]
	if button.icon then
		button.icon:SetTexCoord(unpack(self.buttonZoom))
		button.icon:SetDrawLayer("ARTWORK",-1)
		button.icon:ClearAllPoints()
		button.icon:SetPoint("TOPLEFT",button,"TOPLEFT",self.borderWidth, -self.borderWidth)
		button.icon:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",-self.borderWidth, self.borderWidth)
	end
	button.textName = button.textName or _G[name.."Name"]
	if button.textName then
		button.textName:SetAlpha(0)
	end
	button.cd = button.cd or _G[name.."Cooldown"]
end

Mod_AddonSkins.barTexture = Califpornia.CFG.media.normTex
Mod_AddonSkins.bgTexture = "Interface\\Buttons\\WHITE8x8"
Mod_AddonSkins.font = Califpornia.CFG.media.font
Mod_AddonSkins.smallFont = Califpornia.CFG.media.uffont
Mod_AddonSkins.fontSize = 12
Mod_AddonSkins.buttonSize = 27
Mod_AddonSkins.buttonSpacing = 4
Mod_AddonSkins.borderWidth = 2
Mod_AddonSkins.buttonZoom = {.08,.92,.08,.92}
Mod_AddonSkins.barSpacing = 1
Mod_AddonSkins.barHeight = 20
Mod_AddonSkins.skins = {}
Mod_AddonSkins.__index = Mod_AddonSkins

-- TukUI-Specific Integration Support

local CustomSkin = setmetatable(CustomSkin or {},Mod_AddonSkins)

-- Custom SexyCooldown positioning. This is used to lock the bars into place above the action bar or over either info bar.
-- To achieve this, the user must name their bar either "actionbar", "infoleft", or "inforight" depending on where they want
-- the bar anchored.
if not CustomSkin.PositionSexyCooldownBar then
	function CustomSkin:PositionSexyCooldownBar(bar)
		if bar.settings.bar.name == "actionbar" then
			self:SCDStripLayoutSettings(bar)
			bar.settings.bar.inactiveAlpha = 1
			bar:SetHeight(self.buttonSize)
			bar:SetWidth(ActionBarBackground:GetWidth() - 2 * self.buttonSpacing)
			bar:SetPoint("TOPLEFT",ActionBarBackground,"TOPLEFT",self.buttonSpacing,-self.buttonSpacing)
			bar:SetPoint("TOPRIGHT",ActionBarBackground,"TOPRIGHT",-self.buttonSpacing,-self.buttonSpacing)
			if not ActionBarBackground.resized then
				ActionBarBackground:SetHeight(ActionBarBackground:GetHeight() + self.buttonSize + self.buttonSpacing)
				InvActionBarBackground:SetHeight(ActionBarBackground:GetHeight())
				ActionBarBackground.resized = true
			end
		elseif bar.settings.bar.name == "infoleft" then
			self:SCDStripLayoutSettings(bar)
			bar.settings.bar.inactiveAlpha = 0
			bar:SetAllPoints(dataleftp)
		elseif bar.settings.bar.name == "inforight" then
			self:SCDStripLayoutSettings(bar)
			bar.settings.bar.inactiveAlpha = 0
			bar:SetAllPoints(datarightp)
		end
	end
end

-- Dummy function expected by some skins
function dummy() end


function Mod_AddonSkins:RegisterSkin(name, initFunc)
	self = Mod_AddonSkins -- Static function
	if type(initFunc) ~= "function" then error("initFunc must be a function!",2) end
	self.skins[name] = initFunc
	if name == "LibSharedMedia" then -- Load LibSharedMedia early.
		initFunc(self, CustomSkin, self, CustomSkin, CustomSkin)
		self.skins[name] = nil
	end
end

Mod_AddonSkins:RegisterEvent("PLAYER_LOGIN")
Mod_AddonSkins:SetScript("OnEvent",function(self)
	self:UnregisterEvent("PLAYER_LOGIN")
	self:SetScript("OnEvent",nil)
	-- Initialize all skins
	for name, func in pairs(self.skins) do
		func(self,CustomSkin,self,CustomSkin,CustomSkin) -- Mod_AddonSkins functions as skin, layout, and config.
	end
end)