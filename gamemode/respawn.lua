
print("respawn module")
local lastdeath = {}

local function PlayerDeath( ply, wep, killer )
 
    lastdeath[ply] = CurTime() + 2
 
end
hook.Add( "PlayerDeath", "_GAMEMEMODE.PROPKILL.RESPAWN", PlayerDeath )
 
local function ForceRespawn( ply )
 
    if CurTime() >= lastdeath[ply] then
          ply:Spawn()
          ply.nextspawn = CurTime()^10
    end
 	return true
end
 
hook.Add( "PlayerDeathThink", "_GAMEMEMODE.PROPKILL.RESPAWN", ForceRespawn )