
local ply = LocalPlayer()
local mousepx = 0
local mousepy = 0
local markerx = 0
local markery = 0
local ourcommand1 = ""
local whocan = ""



function battlemapfull()
local main = vgui.Create( "DFrame" )
main:SetPos( ScrW()/2 - 331 , ScrH()/2 - 286 ) 
main:SetSize( 662, 572 )
main:SetTitle( "" )
main:SetVisible( true )
main:SetDraggable( true )
main:ShowCloseButton( true )
main:MakePopup()
main.Paint = function( self, w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color( 70, 70, 70, 155 ) )
end

function main_close()
	main:SetVisible(false)
	
end

local backgroundmap = game.GetMap()

local logo = vgui.Create( "DImage", main )
logo:SetPos( 30, 30 )
logo:SetSize( 512, 512 )
logo:SetImage( "vgui/hud/battlemaps/" .. backgroundmap .. ".png" )

local xval = vgui.Create("DTextEntry", main)
xval:SetText("X")
xval:SetSize( 100, 20 )
xval:SetPos(551, 70)
xval.OnChange = function(self)
	markerx = self:GetValue()
end

local yval = vgui.Create("DTextEntry", main)
yval:SetText("Y")
yval:SetSize( 100, 20 )
yval:SetPos(551, 95)
yval.OnChange = function(self)
	markery = self:GetValue()
end

local lmark = vgui.Create( "DImage", logo )
lmark:SetPos( 0 - 8 , 0 - 8 )
lmark:SetSize( 16, 16 )
lmark:SetImage( "vgui/hud/locationmarker.png" )

local gridpat = vgui.Create( "DGrid", main )
gridpat:SetPos( 30, 30 )
gridpat:SetCols( 16 )
gridpat:SetColWide( 32 )
gridpat:SetRowHeight( 32 )

--print( game.GetMap() )

for i = 1, 256 do
	local ya = math.floor( i/16, 0) + 0
	local xa = i - (16*ya)
	local grid = vgui.Create( "DImageButton" )
	grid:SetPos( 0, 0 )
	grid:SetSize( 32, 32 )
	grid:SetImage( "vgui/hud/gridblock.png" )
	gridpat:AddItem( grid )
	grid.DoClick = function()
		local ply = LocalPlayer()
		--ply:ChatPrint("Cords: X = " .. xa .. " Y = " .. ya)
		xval:SetText(xa)
		markerx = xa
		yval:SetText(ya)
		markery = ya
		lmark:SetPos( (markerx * 32) - 24, (markery * 32) + 8)
		ply:EmitSound("common/talk.wav")
	end
end

local cinfo = vgui.Create( "RichText", main )
cinfo:SetSize( 100, 20 )
cinfo:SetPos( 551, 45 )
cinfo:AppendText("Place marker")



local setmarkpos = vgui.Create("DButton", main)
setmarkpos:SetPos( 551, 120 )
setmarkpos:SetSize( 100, 20 )
setmarkpos:SetText("Move")
setmarkpos.DoClick = function()
	lmark:SetPos( (markerx * 32) - 24, (markery * 32) + 8)
end

local calloption = vgui.Create("DComboBox", main)
calloption:SetPos( 551, 145 )
calloption:SetSize( 100, 20 )
calloption:SetValue("Call Type")
calloption:AddChoice("Artillery Strike at")
calloption:AddChoice("Need Help at")
calloption:AddChoice("Enemy at")
calloption:AddChoice("Move to")
calloption.OnSelect = function(panel, index, value)
	ourcommand1 = (value)
end

local calloption = vgui.Create("DComboBox", main)
calloption:SetPos( 551, 170 )
calloption:SetSize( 100, 20 )
calloption:SetValue("Can Hear:")
calloption:AddChoice("Team")
calloption:AddChoice("Everyone")
calloption.OnSelect = function(panel, index, value)
	if value == "Everyone" then
		whocan = "say "
	else
		whocan = "say_team "
	end
end

local arty = vgui.Create("DButton", main)
arty:SetPos( 551, 195 )
arty:SetSize( 100, 20 )
arty:SetText("Call")
arty.DoClick = function()
	local ply = LocalPlayer()
	ply:ConCommand( whocan .. ourcommand1 .. " x: " .. markerx .. " y: " .. markery .. ".")
end

/*
local mscale = 512/16384
local myposx = LocalPlayer():GetPos().x
local myposy = LocalPlayer():GetPos().y

local myposx2 = myposx*mscale
local myposy2 = myposy*mscale

local pmark = vgui.Create( "DImage", logo )
pmark:SetPos( myposx2 + 256, myposy2 + 256)
pmark:SetSize( 16, 16 )
pmark:SetImage( "vgui/hud/playermarker.png" )
*/
local mmark = vgui.Create( "DImage", logo )
mmark:SetPos( mousepx - 8 , mousepy - 8 )
mmark:SetSize( 16, 16 )
mmark:SetImage( "vgui/hud/mousemarker.png" )

if file.Exists( ("materials/vgui/hud/battlemaps/" .. backgroundmap .. ".png"), "GAME" ) == false then
	logo:SetImage( "vgui/hud/battlemaps/devtexture.png" )
end

function main:Think()
	local mousepx, mousepy = logo:CursorPos()
	mmark:SetPos( mousepx - 8, mousepy - 8)
	--pmark:SetPos( myposx2 + 256, myposy2 + 256)
end

end
concommand.Add( "battlemapfull", battlemapfull )


function setmetozero()
	print("Oi! To go to zero, type: lua_run dogadank = player.GetAll()")
	print("Then type: lua_run dogadank[1]:SetPos(Vector(0,0,0))")
	print("This MUST be done in single player with NO bots.")
	print("--== GUIDE TO MAKING THE MAP PICTURE!==-- Enter the commands above. Once at (0,0,0), type in console cl_leveloverview {number}. Higher numbers give you a higher up view, and vice versa. Get to a height where you can see the WHOLE map. Using the camera tool, take a picture. After you have the picture, open it up in paint.net or something and use the square select tool to select ONLY THE MAP. Open a new image and paste the image. Resize width to 512 WITH KEEP ASPECT RATIO ENABLED. Save as my_map_name (or what ever your map is called) and as a PNG file under (addon)/materials/vgui/hud/battlemaps . This does not need to be saved directly in the addon itself's folder, rather any addon so long as the file path remains the same.")
	print("You may also want to remove all the green crap that will fill empty areas. PENIS")
end
concommand.Add( "setmetozero", setmetozero)

