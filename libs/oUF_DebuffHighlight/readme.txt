This is an addon that adds Debuff Highlighting to the oUF unitframes.

Whenever a unit has a debuff it will highlight the frame in the debuff color. This can be done either on
the unitframe background or a specially created frame for the task.

To use this in your oUF layout you will need one of the following:

self.DebuffHighlightBackdrop = true
and/or
self.DebuffHighlightBackdropBorder = true

This will let oUF_DebuffHighlight know to use the backdrop for debuff highlighting. The original color and alpha
of the backdrop and backdrop border will be stored and whenever the unit needs highlighting it will color the
backdrop and backdrop border in corresponding color and set the alpha. When the debuff is gone the original
color and alpha will be restored.

The other option to add Debuff Highlighting is to provide a texture (or other UI type that supports :SetVertexcolor)
on your unit frame.

local dbh = self:CreateTexture(nil, "OVERLAY")
dbh:SetAllPoints(self)
dbh:SetTexture("SomeKindOfTexturepath")
dbh:SetBlendMode("ADD")
dbh:SetVertexColor(0,0,0,0) -- set alpha to 0 to hide the texture
self.DebuffHighlight = dbh

Be warned, your healthbar is probably the best place to create a full glow texture:
local dbh = hp:CreateTexture(nil, "OVERLAY") 
Because all your unit UI elements will be covering your unitframe (self) most likely.

This frame will now be used with :SetVertexColor() to highlight debuffs.

You can control the alpha of the debuff highlight on backdrop or debuffhighlight frame by setting:

self.DebuffHighlightAlpha = .5

The default value is .5 for the highlight frame and 1 for the backdrop.

If you only want to highlight debuffs that you can cure:

self.DebuffHighlightFilter = true

This is off by default.

If you want to use the actual texture of the debuff to show instead of coloring the frame do the following:

Create the self.DebuffHighlight texture and positionit, make sure it's visible (alpha not set to 0):

local dbh = hp:CreateTexture(nil, "OVERLAY")
dbh:SetWidth(32)
dbh:SetHeight(32)
dbh:SetPoint("CENTER", self, "CENTER")
self.DebuffHighlight = dbh

And set: 

self.DebuffHighlightUseTexture = true


Enjoy

-Ammo 