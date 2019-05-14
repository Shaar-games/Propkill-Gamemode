

local F4MENUOPNED = false
local MAIN
local TEAMLIST

local function GetTeams()
	TEAMLIST = net.ReadTable()
end

net.Receive("propkill_changeteam",GetTeams)

local function F4MENU()

	if F4MENUOPNED then
		MAIN:Remove()
		
		F4MENUOPNED = !F4MENUOPNED
		return 
	end

	F4MENUOPNED = !F4MENUOPNED
 
	MAIN = vgui.Create( "Panel" )
	MAIN:SetSize( ScrW()/1.3 , ScrH()/1.3 )  
	MAIN:Center()
	MAIN:MakePopup()
	
	local WINDOW = vgui.Create( "Panel", MAIN )
	WINDOW:SetSize( ScrW()/1.3 - 50, ScrH()/1.3 - 50 )
	WINDOW:Center()
	WINDOW.Paint = function( self, w, h )
		draw.RoundedBox( 2, 1, 1, w - 2, h - 2, Color( 255, 255, 255 ) )
		
		draw.SimpleText( "Lele", "ChatFont", w/2, ScrH()/80, Color( 230, 230, 230 ) )
		
		surface.SetDrawColor( Color( 242, 242, 242 ) )
		surface.DrawLine( 24, 44, w , 44 )
	end
	
	LIST = vgui.Create( "DPanelList", WINDOW )
	LIST:SetPos( 24, 44 )
	LIST:SetSize( WINDOW:GetWide() - 30, WINDOW:GetTall() - 30 )
	LIST:EnableVerticalScrollbar( true )
	LIST:DockPadding( 0, 5, 10, 0 )

 
	for k, v in pairs( TEAMLIST ) do
	
		local TEAMFRAME = vgui.Create( "DPanel" )  
		TEAMFRAME:SetSize( LIST:GetWide(), ScrH()/10 )
		TEAMFRAME.Paint = function( self, w, h )
		
			surface.SetDrawColor( Color( 242, 242, 242 ) )
		
			surface.DrawLine( 0, h - 1, w, h - 1 )
			draw.SimpleText( v.name , "ChatFont", w/10 , ScrH()/25 , Color( 0, 0 , 0 ) )
			
			 
		end

		TEAMFRAME.OnCursorEntered = function( self ) end
		TEAMFRAME.OnCursorEntered = function( self ) end
		
		LIST:AddItem( TEAMFRAME )
		
		local BUTTON = vgui.Create( "DButton", TEAMFRAME )
		BUTTON:SetSize( ScrH()/10, ScrW()/50 )
		BUTTON:SetPos( TEAMFRAME:GetWide() - ScrW()/10, (TEAMFRAME:GetTall() / 2) - ScrH()/60 )
		BUTTON:SetText( "Become" )
		BUTTON:SetTextColor( Color( 255, 255, 255 ) )
		BUTTON.Paint = function( self, w, h )
			draw.RoundedBox( 4, 0, 0, w, h, Color( 239, 239, 243 ) )
			draw.RoundedBox( 4, 1, 1, w - 2, h - 2, Color( 76, 76, 76 ) )
			draw.RoundedBox( 4, 2, 2, w - 4, h - 4, Color( 84, 84, 84 ) )
			
			if self.hover then
				draw.RoundedBox( 4, 1, 1, w - 2, h - 2, Color( 68, 68, 68 ) )
			end
		end
		BUTTON.DoClick = function()
			MAIN:Remove()
			F4MENUOPNED = !F4MENUOPNED
		end

		
		local ICON = vgui.Create( "SpawnIcon", TEAMFRAME )
		ICON:SetSize( TEAMFRAME:GetTall() - 10 , TEAMFRAME:GetTall() - 10  )
		ICON:SetPos(  0 , 10 )
		ICON:SetModel( v.model )
		
	end
end

local delay = CurTime() + 2

hook.Add("Think","TeamMenu",function( ply , BTN )
	if input.IsButtonDown( KEY_F4 ) and delay + 0.2 < CurTime() then
		delay = CurTime()
		F4MENU()
	end
end)
