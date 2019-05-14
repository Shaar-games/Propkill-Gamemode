
AddCSLuaFile()
DEFINE_BASECLASS( "player_default" )

local PLAYER = {}


PLAYER.DuckSpeed			= 0.3		-- How fast to go from not ducking, to ducking
PLAYER.UnDuckSpeed			= 0.3		-- How fast to go from ducking, to not ducking
PLAYER.JumpPower			= 200	
PLAYER.CanUseFlashlight		= true	
PLAYER.MaxHealth			= 100	
PLAYER.StartHealth			= 100	
PLAYER.StartArmor			= 0		
PLAYER.DropWeaponOnDie		= false	
PLAYER.TeammateNoCollide	= false	
PLAYER.AvoidPlayers			= true	
PLAYER.UseVMHands			= true	
--
-- Creates a Taunt Camera
--
PLAYER.TauntCam = TauntCamera()

--

PLAYER.WalkSpeed 			= 160
PLAYER.RunSpeed				= 240


CreateConVar( "cl_playercolor", "0.24 0.34 0.41", { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "The value is a Vector - so between 0-1 - not between 0-255" )
CreateConVar( "cl_weaponcolor", "0.30 1.80 2.10", { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "The value is a Vector - so between 0-1 - not between 0-255" )
CreateConVar( "cl_playerskin", "0", { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "The skin to use, if the model has any" )
CreateConVar( "cl_playerbodygroups", "0", { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "The bodygroups to use, if the model has any" )


function PLAYER:SetupDataTables()

	BaseClass.SetupDataTables( self )

end


function PLAYER:Loadout()

	self.Player:RemoveAllAmmo()

	self.Player:StripAmmo()

	self.Player:StripWeapons()
 
	local Weapons = TeamGetinfo( self.Player:Team() ).weapons

	for k , weapon in pairs( Weapons ) do
	 	self.Player:Give( weapon )
	 end 

	self.Player:SwitchToDefaultWeapon()

end

function PLAYER:SetModel()

	BaseClass.SetModel( self )

	self.Player:SetModel( "models/player/p2_chell.mdl" )

	self.Player:SetSkin( 0 )

	self.Player:SetBodygroup( 0 , 0 )

end

function PLAYER:Spawn()

	BaseClass.Spawn( self )

	local color = team.GetColor( self.Player:Team() ) 

	self.Player:SetPlayerColor( Vector( color.r / 255, color.g / 255, color.b / 255 ) )

	--self.Player:SetWeaponColor( Vector( color.r / 255, color.g / 255, color.b / 255 ) )

	local col = Vector( self.Player:GetInfo( "cl_weaponcolor" ) )
	if col:Length() == 0 then
		col = Vector( 0.001, 0.001, 0.001 )
	end
	self.Player:SetWeaponColor( col )
 
end

function PLAYER:ShouldDrawLocal() 

	if ( self.TauntCam:ShouldDrawLocalPlayer( self.Player, self.Player:IsPlayingTaunt() ) ) then return true end

end

function PLAYER:CreateMove( cmd )

	if ( self.TauntCam:CreateMove( cmd, self.Player, self.Player:IsPlayingTaunt() ) ) then return true end

end

function PLAYER:CalcView( view )

	if ( self.TauntCam:CalcView( view, self.Player, self.Player:IsPlayingTaunt() ) ) then return true end

end

function PLAYER:GetHandsModel()


	local cl_playermodel = self.Player:GetModel()
	return player_manager.TranslatePlayerHands( cl_playermodel )

end



function PLAYER:StartMove( move )
	
	local col = Vector( self.Player:GetInfo( "cl_weaponcolor" ) )
	if col:Length() == 0 then
		col = Vector( 0.001, 0.001, 0.001 )
	end
	self.Player:SetWeaponColor( col )

end

function PLAYER:FinishMove( move )
	
end

player_manager.RegisterClass( "player_propkill", PLAYER, "player_default" )
