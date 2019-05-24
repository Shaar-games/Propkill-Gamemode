if CLIENT then return end
local util  	= util
local file  	= file

util.AddNetworkString("propkill_changeteam")

baseTeams = {}
baseTeams["Spectator"] = Color( 30 , 255 , 30 )
--baseTeams["Blue"] = Color( 30 , 255 , 30 )
--baseTeams["Red"] = Color( 30 , 255 , 30 )

local Teams = {}


local noteam = {}
noteam.weapons = {}
noteam.model = "models/player/p2_chell.mdl"
noteam.name = "no team"
noteam.color = Color( 255 , 255 , 255 )
noteam.adminonly = false

function GAMEMODE.TeamGetinfo( name )
	return Teams[name] or noteam
end

team.Count = team.Count or 0

local function CreateTeam( name , col , tblWeapons , model ,  adminonly )

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
	CreateTeam( name , col , baseTeams.weapons or {} , "models/player/combine_super_soldier.mdl" , false )
end

local function LoadCustomTeam( x )

	x = util.JSONToTable( file.Read( x , "DATA" ) )
	
	if !x then
		error("cant load custom teams ", 1 )
		return 
	end
  
	CreateTeam( x.name , x.color , x.weapons , x.model , x.adminonly )

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
	net.Start("propkill_changeteam", false )
	net.WriteTable( Teams )
	net.Send( ply )

end

hook.Add("PlayerInitialSpawn","Propkill_Sendteams", Sendteams )

for k,v in pairs(player.GetAll()) do
	Sendteams( v )
end

local function callback( len , ply)
	local t = net.ReadUInt( 8 )
	if !Teams[t].name or ply:Team() == t then return end
	ply:SetTeam( t )
	ply:Spawn()
	print( "team changed " , Teams[t].name )
end

net.Receive("propkill_changeteam",callback)

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
