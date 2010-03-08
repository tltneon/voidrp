PLUGIN.Name = "Admin Commands"; -- What is the plugin name
PLUGIN.Author = "LuaBanana"; -- Author of the plugin
PLUGIN.Description = "A set of default admin commands"; -- The description or purpose of the plugin

function Admin_AddDoor(ply, cmd, args)
	
	local tr = ply:GetEyeTrace()
	local trent = tr.Entity;
	
	if(!CAKE.IsDoor(trent)) then ply:PrintMessage(3, "You must be looking at a door!"); return; end

	if(table.getn(args) < 1) then ply:PrintMessage(3, "Specify a doorgroup!"); return; end
	
	local pos = trent:GetPos()
	local Door = {}
	Door["x"] = math.ceil(pos.x);
	Door["y"] = math.ceil(pos.y);
	Door["z"] = math.ceil(pos.z);
	Door["group"] = args[1];
	
	table.insert(CAKE.Doors, Door);
	
	CAKE.SendChat(ply, "Door added");
	
	local keys = util.TableToKeyValues(CAKE.Doors);
	file.Write("CakeScript/MapData/" .. game.GetMap() .. ".txt", keys);
	
end

function Admin_Goto( ply, cmd, args )

	local target = CAKE.FindPlayer(args[1]);

	if(target:Alive() and target:IsPlayer()) then
		ply:SetPos(target:GetPos());
	else
		CAKE.SendChat( ply, "Player is either dead or doesn't exist!" );
	end

end

function ApplyAccel( ent, magnitude, direction, dTime )
	if dTime == nil then dTime = 1 end

	if magnitude ~= nil then
		direction = direction:Normalize()
	else
		magnitude = 1
	end

	-- Times it by the time elapsed since the last update.
	local accel = magnitude * dTime
	-- Convert our scalar accel to a vector accel
	accel = direction * accel

	if ent:GetMoveType() == MOVETYPE_VPHYSICS then
		-- a = f/m , so times by mass to get the force.
		local force = accel * ent:GetPhysicsObject():GetMass()
		ent:GetPhysicsObject():ApplyForceCenter( force )
	else
		ent:SetVelocity( accel ) -- As it turns out, SetVelocity() is actually SetAccel() in GM10
	end
end

function Admin_Slay( ply, cmd, args )
	local target = CAKE.FindPlayer( args[1] )
	local reason = args[2]
	if reason == nil then reason = "None" end
	
	if target:IsPlayer() then
			target:Kill()
			CAKE.SendChat( target, "You've been slain by " .. ply:Nick() .. "due to the following reason: " .. reason )
			CAKE.SendChat( ply, "You slayed " .. target:Nick() )
	else
		return
	end
end


function Admin_Slap( ply, cmd, args )
local slapSounds = {
	"physics/body/body_medium_impact_hard1.wav",
	"physics/body/body_medium_impact_hard2.wav",
	"physics/body/body_medium_impact_hard3.wav",
	"physics/body/body_medium_impact_hard5.wav",
	"physics/body/body_medium_impact_hard6.wav",
	"physics/body/body_medium_impact_soft5.wav",
	"physics/body/body_medium_impact_soft6.wav",
	"physics/body/body_medium_impact_soft7.wav",
}
local ent = CAKE.FindPlayer( args[1] )
local damage = args[2]
local power = args[3]
local nosound = args[4]

if nosound == nil then nosound = false end

	if ent:GetMoveType() == MOVETYPE_OBSERVER then return end -- Nothing we can do.

	damage = damage or 0
	power = power or 500

	if ent:IsPlayer() then
		if not ent:Alive() then
			return -- Nothing we can do.
		end

		if ent:InVehicle() then
			ent:ExitVehicle()
		end

		if ent:GetMoveType() == MOVETYPE_NOCLIP then
			ent:SetMoveType( MOVETYPE_WALK )
		end
	end

	if not nosound then -- Play a slap sound
		local sound_num = math.random( #slapSounds ) -- Choose at random
		ent:EmitSound( slapSounds[ sound_num ] )
	end

	local direction = Vector( math.random( 20 )-10, math.random( 20 )-10, math.random( 20 )-5 ) -- Make it random, slightly biased to go up.
	ApplyAccel( ent, power, direction )

	local newHp = ent:Health() - damage
	if newHp <= 0 then
		if ent:IsPlayer() then
			ent:Kill()
		else
			ent:Fire( "break", 1, 0 )
		end
		return
	end
	ent:SetHealth( newHp )
end

function Admin_Bring( ply, cmd, args )
local target = CAKE.FindPlayer(args[1]);

	if(target:Alive() and target:IsPlayer()) then
		target:SetPos(ply:GetPos());
	else
	CAKE.SendChat( ply, "Player is either dead or doesn't exist!" );
	end

end

function Admin_LocalSound( ply, cmd, args )
if(!ply:IsAdmin()) then return false; end

util.PrecacheSound( args[1] );
ply:EmitSound( args[1] );

end

function Admin_GlobalSound( ply, cmd, args )
if(!ply:IsAdmin()) then return false; end

util.PrecacheSound( args[1] );

for k,v in pairs( player.GetAll() ) do

v:ConCommand("play ".. args[1] );

end

end

function Admin_SetModel( ply, cmd, args )

if(!ply:IsSuperAdmin()) then return false; end

local target = CAKE.FindPlayer(args[1]);

if(target:Alive() and target:IsPlayer()) then

target:SetModel( args[2] );
CAKE.SetCharField(target, "model", args[2] );

else

CAKE.SendChat( ply, "Player is either dead or doesn't exist!" );

end

end



function Admin_Observe( ply, cmd, args )

	if( not ply:GetNWBool( "observe" )) then



		ply:GodEnable();
		if( ValidEntity( ply.m_hClothing ) )then
			ply.m_hClothing:SetNoDraw( true );
		end
		if( ValidEntity( ply.m_hHelmet ) )then
			ply.m_hHelmet:SetNoDraw( true );
		end
		
		if( ValidEntity( ply:GetActiveWeapon() ) ) then
			ply:GetActiveWeapon():SetNoDraw( true );
		end
		
		ply:SetNotSolid( true );
		ply:SetMoveType( 8 );
		
		ply:SetNWBool( "observe", true )
		
	else

		ply:GodDisable();
		if( ValidEntity( ply.m_hClothing ) )then
			ply.m_hClothing:SetNoDraw( false );
		end
		if( ValidEntity( ply.m_hHelmet ) )then
			ply.m_hHelmet:SetNoDraw( false );
		end
		
		if( ply:GetActiveWeapon() ) then
			ply:GetActiveWeapon():SetNoDraw( false );
		end
		
		ply:SetNotSolid( false );
		ply:SetMoveType( 2 );
		
		ply:SetNWBool( "observe", false )
		
	end

end

function Admin_Noclip( ply, cmd, args )
	if( not ply:GetTable().Noclip ) then



		ply:GodEnable();
		
		ply:SetNotSolid( true );
		ply:SetMoveType( 8 );
		
		ply:GetTable().Observe = true;
		
	else

		ply:GodDisable();
		
		ply:SetNotSolid( false );
		ply:SetMoveType( 2 );
		
		ply:GetTable().Noclip = false;
		
	end
end
-- rp_admin kick "name" "reason"
function Admin_Kick( ply, cmd, args )

	if( #args != 2 ) then
	
		CAKE.SendChat( ply, "Invalid number of arguments! ( rp_admin kick \"name\" \"reason\" )" );
		return;
		
	end
	
	local plyname = args[ 1 ];
	local reason = args[ 2 ];
	
	local pl = CAKE.FindPlayer( plyname );
	
	if( pl:IsValid( ) and pl:IsPlayer( ) ) then
	
		local UniqueID = pl:UserID( );
		
		game.ConsoleCommand( "kickid " .. UniqueID .. " \"" .. reason .. "\"\n" );
		
		CAKE.AnnounceAction( ply, "kicked " .. pl:Name( ) );
		
	else
	
		CAKE.SendChat( ply, "Cannot find " .. plyname .. "!" );
		
	end
	
end

-- rp_admin ban "name" "reason" minutes
function Admin_Ban( ply, cmd, args )

	if( #args != 3 ) then
	
		CAKE.SendChat( ply, "Invalid number of arguments! ( rp_admin ban \"name\" \"reason\" minutes )" );
		return;
		
	end
	
	local plyname = args[ 1 ];
	local reason = args[ 2 ];
	local mins = tonumber( args[ 3 ] );
	
	if(mins > CAKE.ConVars[ "MaxBan" ]) then
	
		CAKE.SendChat( ply, "Max minutes is " .. CAKE.ConVars[ "MaxBan" ] .. " for regular ban. Use superban.");
		return;
	
	end
	
	local pl = CAKE.FindPlayer( plyname );
	
	if( pl != nil and pl:IsValid( ) and pl:IsPlayer( ) ) then
	
		local UniqueID = pl:UserID( );
		
		-- This bans, then kicks, then writes their ID to the file.
		game.ConsoleCommand( "banid " .. mins .. " " .. UniqueID .. "\n" );
		game.ConsoleCommand( "kickid " .. UniqueID .. " \"Banned for " .. mins .. " mins ( " .. reason .. " )\"\n" );
		game.ConsoleCommand( "writeid\n" );
		
		CAKE.AnnounceAction( ply, "banned " .. pl:Name( ) );
		
	else
	
		CAKE.SendChat( ply, "Cannot find " .. plyname .. "!" );
		
	end
	
end

function Admin_SetDoorGroup( ply, cmd, args )

	if( #args != 2 ) then
	
		CAKE.SendChat( ply, "Invalid number of arguments! ( rp_admin setdoorgroup \"name\" doorgroup )" );
		return;
		
	end
	
	local plyname = args[ 1 ];
	local doorgroup = args[ 2 ];
	local pl = CAKE.FindPlayer( plyname );
	if( pl != nil and pl:IsValid( ) and pl:IsPlayer( ) ) then
	
		CAKE.SetCharField( pl, "doorgroup", doorgroup )
		CAKE.SendChat( pl, "Your doorgroup has been set to " .. tostring( doorgroup ) )
	
	else
	
		CAKE.SendChat( ply, "Cannot find " .. plyname .. "!" );
		
	end
end

function Admin_SetBusiness( ply, cmd, args )

	if( #args != 2 ) then
	
		CAKE.SendChat( ply, "Invalid number of arguments! ( rp_admin setbusiness \"name\" \"business\" )" );
		return;
		
	end
	
	local plyname = args[ 1 ];
	local business = args[ 2 ];
	local pl = CAKE.FindPlayer( plyname );
	if( pl != nil and pl:IsValid( ) and pl:IsPlayer( ) ) then
	
		CAKE.SetCharField( pl, "business", tonumber( business ) )
		CAKE.SendChat( pl, "Your business has been set to " .. business )
	
	else
	
		CAKE.SendChat( ply, "Cannot find " .. plyname .. "!" );
		
	end
end

function Admin_SetMoney( ply, cmd, args )

	if( #args != 2 ) then
	
		CAKE.SendChat( ply, "Invalid number of arguments! ( rp_admin setmoney \"name\" money )" );
		return;
		
	end
	
	local plyname = args[ 1 ];
	local money = args[ 2 ];
	local pl = CAKE.FindPlayer( plyname );
	if( pl != nil and pl:IsValid( ) and pl:IsPlayer( ) ) then
	
		CAKE.SetCharField( pl, "money", tonumber( money ) )
		CAKE.SendChat( pl, "Your credits has been set to " .. money )
	
	else
	
		CAKE.SendChat( ply, "Cannot find " .. plyname .. "!" );
		
	end
end

-- rp_admin superban "name" "reason" minutes
function Admin_SuperBan( ply, cmd, args )

	if( #args != 3 ) then
	
		CAKE.SendChat( ply, "Invalid number of arguments! ( rp_admin superban \"name\" \"reason\" minutes )" );
		return;
		
	end
	
	local plyname = args[ 1 ];
	local reason = args[ 2 ];
	local mins = tonumber( args[ 3 ] );
	
	local pl = CAKE.FindPlayer( plyname );
	
	if( pl != nil and pl:IsValid( ) and pl:IsPlayer( ) ) then
	
		local UniqueID = pl:UserID( );
		
		-- This bans, then kicks, then writes their ID to the file.
		game.ConsoleCommand( "banid " .. mins .. " " .. UniqueID .. "\n" );
		
		if( mins == 0 ) then
		
			game.ConsoleCommand( "kickid " .. UniqueID .. " \"Permanently banned ( " .. reason .. " )\"\n" );
			CAKE.AnnounceAction( ply, "permabanned " .. pl:Name( ) );
	
		else
		
			game.ConsoleCommand( "kickid " .. UniqueID .. " \"Banned for " .. mins .. " mins ( " .. reason .. " )\"\n" );
			CAKE.AnnounceAction( ply, "banned " .. pl:Name( ) );
			
		end
		
		game.ConsoleCommand( "writeid\n" );
		
	else
	
		CAKE.SendChat( ply, "Cannot find " .. plyname .. "!" );
		
	end
	
end

function Admin_SetConVar( ply, cmd, args )

	if( #args != 2 ) then
	
		CAKE.SendChat( ply, "Invalid number of arguments! ( rp_admin setvar \"varname\" \"value\" )" );
		return;
		
	end
	
	if( CAKE.ConVars[ args[ 1 ] ] ) then
	
		local vartype = type( CAKE.ConVars[ args [ 1 ] ] );
		
		if( vartype == "string" ) then
		
			CAKE.ConVars[ args[ 1 ] ] = tostring(args[ 2 ]);
			
		elseif( vartype == "number" ) then
		
			CAKE.ConVars[ args[ 1 ] ] = CAKE.NilFix(tonumber(args[ 2 ]), 0); -- Don't set a fkn string for a number, dumbass! >:<
		
		elseif( vartype == "table" ) then
		
			CAKE.SendChat( ply, args[ 1 ] .. " cannot be changed, it is a table." ); -- This is kind of like.. impossible.. kinda. (Or I'm just a lazy fuck)
			return;
			
		end
		
		CAKE.SendChat( ply, args[ 1 ] .. " set to " .. args[ 2 ] );
		CAKE.CallHook( "SetConVar", ply, args[ 1 ], args[ 2 ] );
		
	else
	
		CAKE.SendChat( ply, args[ 1 ] .. " is not a valid convar! Use rp_admin listvars" );
		
	end
	
end

function Admin_ListVars( ply, cmd, args )

	CAKE.SendChat( ply, "---List of CakeScript ConVars---" );
	
	for k, v in pairs( CAKE.ConVars ) do
		
		CAKE.SendChat( ply, k .. " - " .. tostring(v) );
		
	end
	
end

function Admin_SetFlags( ply, cmd, args)
	
	local target = CAKE.FindPlayer(args[1])
	
	if(target != nil and target:IsValid() and target:IsPlayer()) then
		-- klol
	else
		CAKE.SendChat( ply, "Target not found!" );
		return;
	end
	
	table.remove(args, 1); -- Get rid of the name
	
	CAKE.SetCharField(target, "flags", args); -- KLOL!
	
	CAKE.SendChat( ply, target:OOCName() .. "'s flags were set to \"" .. table.concat(args, " ") .. "\"" );
	CAKE.SendChat( target, "Your flags were set to \"" .. table.concat(args, " ") .. "\" by " .. ply:OOCName());
	
end

function Admin_ForceClothing( ply, cmd, args)
	
	local target = CAKE.FindPlayer(args[1])
	
	if(target != nil and target:IsValid() and target:IsPlayer()) then
		-- klol
	else
		CAKE.SendChat( ply, "Target not found!" );
		return;
	end
	
	CAKE.SetCharField(target, "model", args[2] );
	
end

function Admin_Help( ply, cmd, args )

	CAKE.SendChat( ply, "---List of CakeScript Admin Commands---" );
	
	for cmdname, cmd in pairs( CAKE.AdminCommands ) do
	
		local s = cmdname .. " \"" .. cmd.desc .. "\"";
		
		if(cmd.CanRunFromConsole) then
		
			s = s .. " console";

		else
		
			s = s .. " noconsole";
			
		end
		
		if(cmd.CanRunFromAdmin) then
		
			s = s .. " admin";
			
		end
		
		if(cmd.SuperOnly) then
		
			s = s .. " superonly";
			
		end
		
		CAKE.SendChat( ply, s );
		
	end
	
end
	
-- Let's make some ADMIN COMMANDS!
function PLUGIN.Init( )

	CAKE.ConVars[ "MaxBan" ] = 300; -- What is the maximum ban limit for regular admins?
	
	CAKE.AdminCommand( "help", Admin_Help, "List of all admin commands", true, true, false );
	CAKE.AdminCommand( "kick", Admin_Kick, "Kick someone on the server", true, true, false );
	CAKE.AdminCommand( "ban", Admin_Ban, "Ban someone on the server", true, true, false );
	CAKE.AdminCommand( "superban", Admin_SuperBan, "Ban someone on the server ( Permanent allowed )", true, true, true );
	CAKE.AdminCommand( "setconvar", Admin_SetConVar, "Set a Convar", true, true, true );
	CAKE.AdminCommand( "listvars", Admin_ListVars, "List convars", true, true, true );
	CAKE.AdminCommand( "setflags", Admin_SetFlags, "Set a players flags", true, true, false );
	CAKE.AdminCommand( "adddoor", Admin_AddDoor, "Add a door to a doorgroup", true, true, true );
	CAKE.AdminCommand( "observe", Admin_Observe, "Observe mode.", true, true, false );
	CAKE.AdminCommand( "noclip", Admin_Noclip, "Noclip mode.", true, true, false );
	CAKE.AdminCommand( "globalsound", Admin_GlobalSound, "Play a sound everyone can hear.", true, true, false );
	CAKE.AdminCommand( "localsound", Admin_LocalSound, "Emit a sound.", true, true, false );
	CAKE.AdminCommand( "slap", Admin_Slap, "ULX Slap", true, true, false );
	CAKE.AdminCommand( "slay", Admin_Slay, "Kill someone on the server", true, true, false );
	CAKE.AdminCommand( "bring", Admin_Bring, "Bring someone to you", true, true, false );
	CAKE.AdminCommand( "goto", Admin_Goto, "Go to someone", true, true, false );
	CAKE.AdminCommand( "setdoorgroup", Admin_SetDoorGroup, "Set someone's door permissions", true, true, false );
	CAKE.AdminCommand( "setbusiness", Admin_SetBusiness, "Set someone's business", true, true, false );
	CAKE.AdminCommand( "setmoney", Admin_SetMoney, "Set someone's credits", true, true, true );
	CAKE.AdminCommand( "forceclothing", Admin_ForceClothing, "Set someone's clothing", true, true, false )
end

