
local util  	= util
local file  	= file

util.AddNetworkString("propkill_changeteam")

baseTeams = {}
baseTeams["Spectator"] = Color( 30 , 255 , 30 )
--baseTeams["Blue"] = Color( 30 , 255 , 30 )
--baseTeams["Red"] = Color( 30 , 255 , 30 )

local Teams = {}

function TeamGetinfo( name )
	
	return Teams[name] or nil
end

team.Count = team.Count or 0

local function CreateTeams( name , col , tblWeapons , model ,  adminonly )

	team.Count = team.Count + 1

	Teams[team.Count] = {}

	Teams[team.Count].color = col
	Teams[team.Count].adminonly = adminonly
	Teams[team.Count].name = name
	Teams[team.Count].weapons = tblWeapons
	Teams[team.Count].id = team.Count
	Teams[team.Count].model = model

	team.SetUp( team.Count , name , col , true )
	
end

for name , col in pairs(baseTeams) do
	CreateTeams( name , col , {"weapon_physgun"} , "models/player/combine_super_soldier.mdl" , false )
end

local function LoadCustomTeam( x )

	x = util.JSONToTable( file.Read( x , "DATA" ) )
	
	if !x then
		error("cant load custom teams ", 1 )
		return 
	end
  
	CreateTeams( x.name , x.color , x.weapons , x.model , x.adminonly )

end

local files, directories = file.Find( "propkill/config/customteams/*" , "DATA" )

for k,v in pairs(files) do
	LoadCustomTeam( "propkill/config/customteams/" .. v )
end

PrintTable( Teams )

for k,v in pairs(Teams) do
	if v.name == "Propkiller" then
		TEAM_PROPKILLER = k
	end
end

local function Sendteams( ply )

	ply:SetTeam( TEAM_PROPKILLER )
	net.Start("propkill_changeteam", false )
	net.WriteTable( Teams )
	net.Send( ply )

end

hook.Add("PlayerInitialSpawn","Propkill_Sendteams", Sendteams )

for k,v in pairs(player.GetAll()) do
	Sendteams( v )
end

 --local Default = {}
--
--Default["Propkiller"] = {}
--Default["Propkiller"].color = Color( 30 , 255 , 30 )
--Default["Propkiller"].name = "Propkiller"
--Default["Propkiller"].weapons = {"weapon_physgun"}
--Default["Propkiller"].model = "models/player/p2_chell.mdl"
--Default["Propkiller"].adminonly = false
--
--for k,v in pairs(Default) do
--	file.CreateDir( "propkill/config/customteams" )
--	print( k , v )
--	file.Write( "propkill/config/customteams/" .. k:lower() .. ".txt" , util.TableToJSON( v , true ) )
--	 
--	print( util.TableToJSON( v , true ) )
--end
