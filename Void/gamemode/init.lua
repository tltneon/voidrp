-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- init.lua
-- This file calls the rest of the script
-------------------------------

-- Set up the gamemode
require("datastream")
require("gamedescription")
require("glon")
DeriveGamemode( "sandbox" );

-- Define global variables
CAKE = {  };
CAKE.Running = false;
--CAKE.Name = "Void" --THIS SHOULD BE THE NAME OF THE FOLDER, mind you.
CAKE.Loaded = false;


-- Server Includes
include( "shared.lua" ); -- Shared Functions
include( "log.lua" ); -- Logging functions
include( "error_handling.lua" ); -- Error handling functions
include( "hooks.lua" ); -- CakeScript Hook System
include( "configuration.lua" ); -- Configuration data
include( "player_data.lua" ); -- Player data functions
include( "player_shared.lua" ); -- Shared player functions
include( "player_util.lua" ); -- Player functions
include( "admin.lua" ); -- Admin functions
include( "admin_cc.lua" ); -- Admin commands
include( "chat.lua" ); -- Chat Commands
include( "daynight.lua" ); -- Day/Night and Cloc
include( "concmd.lua" ); -- Concommands
include( "util.lua" ); -- Functions
include( "charactercreate.lua" ); -- Character Creation functions
include( "items.lua" ); -- Items system
include( "schema.lua" ); -- Schema system
include( "plugins.lua" ); -- Plugin system
include( "teams.lua" ); -- Teams system
include( "client_resources.lua" ); -- Sends files to the client
include( "animations.lua" ); -- Animations
include( "doors.lua" ); -- Doors
include( "resizer_main.lua" );
include( "clothing_mod.lua" );
include( "resources.lua" )


CAKE.LoadSchema( CAKE.ConVars[ "Schema" ] ); -- Load the schema and plugins, this is NOT initializing.

CAKE.Loaded = true; -- Tell the server that we're loaded up

function GM:Initialize( ) -- Initialize the gamemode
	
	-- My reasoning for this certain order is due to the fact that plugins are meant to modify the gamemode sometimes.
	-- Plugins need to be initialized before gamemode and schema so it can modify the way that the plugins and schema actually work.
	-- AKA, hooks.
	
	CAKE.DayLog( "script.txt", "Plugins Initializing" );
	CAKE.InitPlugins( );
	
	CAKE.DayLog( "script.txt", "Schemas Initializing" );
	CAKE.InitSchemas( );
	
	CAKE.DayLog( "script.txt", "Gamemode Initializing" );
	
	game.ConsoleCommand( "exec cakevars.cfg\n" ) -- Put any configuration variables in cfg/cakevars.cfg, set it using rp_admin setconvar varname value
	
	CAKE.InitTime();
	CAKE.LoadDoors();
	
	timer.Create( "timesave", 120, 0, CAKE.SaveTime );
	timer.Create( "sendtime", 1, 0, CAKE.SendTime );

	-- SALAARIIEEESS?!?!?!?!?!?! :O
	timer.Create( "givemoney", CAKE.ConVars[ "SalaryInterval" ] * 60, 0, function( )
		if( CAKE.ConVars[ "SalaryEnabled" ] == "1" ) then
		
			for k, v in pairs( player.GetAll( ) ) do
			
				if( CAKE.Teams[ v:Team( ) ] != nil ) then
				
					CAKE.ChangeMoney( v, CAKE.Teams[ v:Team( ) ][ "salary" ] );
					CAKE.SendChat( v, "Paycheck! " .. CAKE.Teams[ v:Team( ) ][ "salary" ] .. " credits earned." );
					
				end
				
			end 
			
		end

	end )
	
	CAKE.CallHook("GamemodeInitialize");
	
	CAKE.Running = true;
	
	//FindFiles()

	
end

-- Player Initial Spawn
function GM:PlayerInitialSpawn( ply )

	-- Call the hook before we start initializing the player
	CAKE.CallHook( "Player_Preload", ply );
	
	-- Send them valid models
	for k, v in pairs( CAKE.ValidModels ) do
		umsg.Start( "addmodel", ply );
		
			umsg.String( v );
			
		umsg.End( );
	end
	
	-- Set some default variables
	ply.LastNameChange = -10000
	ply:SetNWString( "oocname", ply:Name() )
	ply.Ready = false;
	ply:SetNWInt( "chatopen", 0 );
	ply:ChangeMaxHealth(CAKE.ConVars[ "DefaultHealth" ]);
	ply:ChangeMaxArmor(0);
	ply:ChangeMaxWalkSpeed(CAKE.ConVars[ "WalkSpeed" ]);
	ply:ChangeMaxRunSpeed(CAKE.ConVars[ "RunSpeed" ]);
	
	-- Check if they are admins
	if( table.HasValue( SuperAdmins, ply:SteamID( ) ) ) then ply:SetUserGroup( "superadmin" ); end
	if( table.HasValue( Admins, ply:SteamID( ) ) ) then ply:SetUserGroup( "admin" ); end
	
	-- Send them all the teams
	CAKE.InitTeams( ply );
	
	-- Load their data, or create a new datafile for them.
	CAKE.LoadPlayerDataFile( ply );

	-- Call the hook after we have finished initializing the player
	CAKE.CallHook( "Player_Postload", ply );
	
	self.BaseClass:PlayerInitialSpawn( ply )
	
	timer.Simple( 6, function()
		if( CAKE.GetPlayerField( ply, "proptrust" ) == 0 ) then
			CAKE.SetPlayerField(ply, "proptrust", 1);
		end 
	end )

end

function GM:PlayerLoadout(ply)

	CAKE.CallHook( "PlayerLoadout", ply );
	if(ply:GetNWInt("charactercreate") != 1) then
	
		-- if(ply:IsAdmin() or ply:IsSuperAdmin()) then ply:Give("gmod_tool"); end
		
		for k, v in pairs( CAKE.GetCharField( ply, "weapons" ) ) do
			ply:Give( v )
		end
		
		ply:RemoveAllAmmo( )
		ply:RestoreAmmo()

		ply:Give("hands");
		
		ply:SelectWeapon("hands");
		
	end
	
end

function GM:PlayerSpawn( ply )
	
	if(CAKE.PlayerData[CAKE.FormatSteamID(ply:SteamID())] == nil) then
		return; -- Player data isn't loaded. This is an initial spawn.
	end
	
	ply:StripWeapons( );
	
	self.BaseClass:PlayerSpawn( ply )
	
	GAMEMODE:SetPlayerSpeed( ply, CAKE.ConVars[ "WalkSpeed" ], CAKE.ConVars[ "RunSpeed" ] );
	
	if( ply:GetNWInt( "deathmode" ) == 1 ) then
	
		ply:SetNWInt( "deathmode", 0 );
		ply:SetViewEntity( ply );
		
	end
	
	-- Reset all the variables
	ply:ResetHull( )
	ply:SetViewOffset( Vector( 0, 0, Sizing.Offsets.Standing * 72 	) )
	ply:SetViewOffsetDucked( Vector( 0, 0, Sizing.Offsets.Ducking * 36 	) )
	ply:SetStepSize( Sizing.Variables.StepSize * 72 )
	ply:SetJumpPower( Sizing.Variables.JumpPower * 36 )
	CAKE.SetSize( ply, CAKE.NilFix( CAKE.GetCharField( ply, "height" ), 1 ) )
	ply:ChangeMaxHealth(CAKE.ConVars[ "DefaultHealth" ] - ply:MaxHealth());
	ply:ChangeMaxArmor(0 - ply:MaxArmor());
	ply:ChangeMaxWalkSpeed(CAKE.ConVars[ "WalkSpeed" ] - ply:MaxWalkSpeed());
	ply:ChangeMaxRunSpeed(CAKE.ConVars[ "RunSpeed" ] - ply:MaxRunSpeed());
	ply:ConCommand( "+walk" )
	ply:ConCommand( "-duck" )
	ply:SetNWFloat( "frequency", CAKE.GetCharField( ply, "frequency" ) )
	if( CAKE.GetCharField( ply, "business" ) != 0 ) then
		ply:SetNWBool( "usesbusiness", true )
	end
	timer.Create( "ammosavetimer" .. ply:Nick(), 15, 0, function()
		ply:SaveAmmo()
	end)
	// Set player clothing
	timer.Simple( 0.4, function()
		ply:RemoveClothing()
		local clothes = CAKE.GetCharField( ply, "clothing" )
		local helmet = CAKE.GetCharField( ply, "helmet" )
		CAKE.SetClothing( ply, clothes, helmet, "none" )
		CAKE.SetCharField( ply, "clothing", clothes )
		CAKE.SetCharField( ply, "helmet", helmet )
		CAKE.SendConsole( ply, "Clothing set to:" .. clothes );
		CAKE.SendConsole( ply, "Helmet set to:" .. helmet );
	end)
	
	CAKE.CallHook( "PlayerSpawn", ply )
	CAKE.CallTeamHook( "PlayerSpawn", ply ); -- Change player speeds perhaps?
	
end

function GM:PlayerSetModel(ply)
	
	if( ply:GetNWString( "model", "" ) != "" ) then
	
		local gender = CAKE.GetCharField( ply, "gender" )
		local m = CAKE.GetCharField( ply, "model" )
		ply:SetNWString( "model", m )
		CAKE.CallHook( "PlayerSetModel", ply, m);
		
		if( gender == "Female" ) then
			ply:SetModel( "models/alyx.mdl" );
		else
			ply:SetModel( "models/barney.mdl" );
		end
		ply:SetNoDraw( true )
		ply:SetRenderMode( RENDERMODE_NONE )
		ply:SetMaterial( "models/null" )
		
	else
		
		local m = "models/kleiner.mdl";
		ply:SetModel("models/kleiner.mdl");
		CAKE.CallHook( "PlayerSetModel", ply, m);
		
	end
	
	CAKE.CallTeamHook( "PlayerSetModel", ply, m); -- Hrm. Looks like the teamhook will take priority over the regular hook.. PREPARE FOR HELLFIRE (puts on helmet)

end

local function CakePlayerDeath(ply)

	--CAKE.DeathMode(ply);
	local weapons = CAKE.GetCharField( ply, "weapons" )
	for k, v in pairs( weapons ) do
		ply:TakeItem( v )
	end
	ply:RemoveAllAmmo( )
	CAKE.SetCharField( ply, "ammo", {} )
	CAKE.SetCharField( ply, "weapons", {} )
	CAKE.CallHook("PlayerDeath", ply);
	CAKE.CallTeamHook("PlayerDeath", ply);
	
end
hook.Add( "PlayerDeath", "CakePlayerDeath", CakePlayerDeath )

/*
function GM:PlayerDeathThink(ply)

	ply.nextsecond = CAKE.NilFix(ply.nextsecond, CurTime())
	ply.deathtime = CAKE.NilFix(ply.deathtime, 120);
	
	if(CurTime() > ply.nextsecond) then
	
		if(ply.deathtime < 120) then
		
			ply.deathtime = ply.deathtime + 1;
			ply.nextsecond = CurTime() + 1;
			ply:SetNWInt("deathmoderemaining", 120 - ply.deathtime);
			
		else
		
			ply.deathtime = nil;
			ply.nextsecond = nil;
			ply:Spawn();
			ply:SetNWInt("deathmode", 0);
			ply:SetNWInt("deathmoderemaining", 0);
			
		end
		
	end
	
end
*/

function GM:PlayerUse(ply, entity)

	if(CAKE.IsDoor(entity)) then
		local doorgroups = CAKE.GetDoorGroup(entity)
		for k, v in pairs(doorgroups) do
			if( tonumber( CAKE.GetCharField( ply, "doorgroup" ) ) == tonumber( v ) ) then
				entity:Fire( "open", "", 0 );
			end
		end
	end
	return self.BaseClass:PlayerUse(ply, entity);
end

local function usepressed(ply, key) --Override for City 8 doors.
	if( key == IN_USE ) then
		local trace = ply:GetEyeTrace( )
		if( trace.HitNonWorld ) then
			local entity = trace.Entity
			if(CAKE.IsDoor(entity)) then
				local doorgroups = CAKE.GetDoorGroup(entity)
				for k, v in pairs(doorgroups) do
					if( tonumber( CAKE.GetCharField( ply, "doorgroup" ) ) == tonumber( v ) ) then
						entity:Fire( "open", "", 0 );
					end
				end
			end
			if( entity:GetClass() == "item_prop" ) then
				ply:ConCommand( "rp_pickup " .. tostring( entity:EntIndex() ) )
			end
		end
	end
end
hook.Add( "KeyPress", "usepressedoverride", usepressed )

local function WeaponEquipItem( wep )

	timer.Simple(0.1, function() 
 
		local ply = wep:GetOwner() -- no longer a null entity.
		if CAKE.ItemData[ wep:GetClass( ) ] != nil and !table.HasValue( CAKE.GetCharField( ply, "inventory" ), wep:GetClass( ) ) then
			if !table.HasValue( CAKE.GetCharField( ply, "weapons" ), wep:GetClass( ) ) then
				local weapons = CAKE.GetCharField( ply, "weapons" )
				table.insert( weapons, wep:GetClass() )
				CAKE.SetCharField( ply, "weapons", weapons )
			end
			ply:GiveItem( wep:GetClass( ) )
		end 
 
	end)
 
end
hook.Add( "WeaponEquip", "GetWeaponAsItem", WeaponEquipItem )

local function ArmorLerp( ply )

	if( ply:Armor() < ply:GetNWFloat( "armor", 0 ) ) then
		timer.Simple( 0.1, function()
			ply:SetArmor( math.ceil( Lerp( 0.25, ply:Armor(), ply:GetNWFloat( "armor" ) ) ) )
			ArmorLerp( ply )
		end)
	else
		local effectdata = EffectData()
        effectdata:SetEntity( ply )
        util.Effect( "propspawn", effectdata, true, true )
		ply:EmitSound( Sound( "npc/sniper/reload1.wav" ))
		ply:SetBloodColor( -1 )
	end
	
end

--Performs clientside effects and the like.
function GM:PlayerTraceAttack( ply, dmginfo, dir, trace ) 
	
	
	if ply:Armor() > 5 then
		local effectdata = EffectData()
		effectdata:SetNormal( trace.HitNormal )
		effectdata:SetOrigin( trace.HitPos )
		util.Effect( "AR2Impact", effectdata )
		ply:SetBloodColor( -1 )
	elseif ply:Armor() <= 5 and ply:Armor() > 0 then
		local effectdata = EffectData()
        effectdata:SetEntity( ply )
        util.Effect( "entity_remove", effectdata, true, true )
		ply:EmitSound( Sound( "physics/glass/glass_largesheet_break2.wav" ) )
		ply:SetBloodColor( -1 )
	else
	
		if ( SERVER ) then 
			GAMEMODE:ScalePlayerDamage( ply, trace.HitGroup, dmginfo )
		end
		
	end
	
 	return false
	
end

--Performs damage calculations for unshielded players.
function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )

        // More damage if we're shot in the head
        if ( hitgroup == HITGROUP_HEAD ) then
			if( ply:GetNWBool( "hashelmet", false ) ) then
				dmginfo:ScaleDamage( 1 )
			else
                dmginfo:ScaleDamage( 3 )
			end
        end
         
		if ( hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM ) then		
			local randomchance = math.random( 1, 20 )
			if( randomchance == 5 ) then
				local wep = ply:GetActiveWeapon( )
				if( wep:GetClass() != "hands" and wep:GetClass() != "gmod_tool" and wep:GetClass() != "weapon_physcannon" and wep:GetClass() != "weapon_physgun" ) then
					CAKE.DropWeapon( ply, ply:GetActiveWeapon( ) )
				end
			end
			dmginfo:ScaleDamage( 0.5 )
		end
		 
        // Less damage if we're shot in the arms or legs
        if ( hitgroup == HITGROUP_LEFTLEG || hitgroup == HITGROUP_LEFTLEG || hitgroup == HITGROUP_GEAR ) then
            dmginfo:ScaleDamage( 0.5 )
        end

end

function GM:GravGunPunt( ply, ent )
    return false --Useless to RP
end

--Handles the actual damage done
local function Shielding( ent, inflictor, attacker, amount, dmginfo )
	
	if ent:IsPlayer() then
		if ent:Armor() > 5 then
			timer.Create( "armorrecharge" .. ent:Nick(), 5, 1, function()
				ArmorLerp( ent )
			end)
			ent:SetBloodColor( -1 )
			if( dmginfo:IsExplosionDamage() ) then
				dmginfo:ScaleDamage( 1.2 )
			elseif( dmginfo:IsBulletDamage() ) then
				dmginfo:ScaleDamage( 0.25 )
			end
			dmginfo:ScaleDamage( 0.25 )
			ent:SetArmor( ent:Armor() - dmginfo:GetDamage() )
			dmginfo:SetDamage( 0 )
		else
			ent:SetBloodColor( COLOR_RED )
			timer.Create( "armorrecharge" .. ent:Nick(), 20, 1, function()
				ArmorLerp( ent )
			end)
		end
	end
 
end
hook.Add( "EntityTakeDamage", "VoidShielding", Shielding )