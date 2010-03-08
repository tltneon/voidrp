-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- concmd.lua
-- Contains the concommands and changes the way other concommands work.
-------------------------------

-- Deprecated, PlayerGiveSwep does the same thing.
-- function NoSweps( ply, cmd, args )
-- 
-- 	if( ply:IsSuperAdmin( ) ) then ply:Give( args[ 1 ] ); else return false; end
-- 	
-- end
-- concommand.Add( "gm_giveswep", NoSweps );

function GM:PlayerSpawnSWEP( ply, class )

	CAKE.CallTeamHook( "PlayerSpawnSWEP", ply, class ); -- Perhaps allow certain flags to use sweps, eh?
	
	if( ply:IsSuperAdmin( ) ) then return true; end
	return false;
	
end

function GM:PlayerGiveSWEP( ply )

	CAKE.CallTeamHook( "PlayerGiveSWEP", ply, class ); -- Perhaps allow certain flags to use sweps, eh?

	if( ply:IsSuperAdmin( ) ) then return true; end
	return false; 
	
end

-- This is the F1 menu
function GM:ShowHelp( ply )

	local PlyCharTable = CAKE.PlayerData[ CAKE.FormatSteamID( ply:SteamID() ) ]["characters"]

	for k, v in pairs( PlyCharTable ) do
		
		umsg.Start( "ReceiveChar", ply );
			umsg.Long( k );
			umsg.String( v[ "name" ] );
			umsg.String( v[ "model" ] );
		umsg.End( );
		
	end

	umsg.Start( "playermenu", ply );
	umsg.End( )
	
end

-- NO SENT FOR YOU.
function GM:PlayerSpawnSENT( ply, class )

	CAKE.CallTeamHook( "PlayerSpawnSWEP", ply, class ); -- Perhaps allow certain flags to use sents, eh?
	
	if( ply:IsSuperAdmin( ) ) then return true; end
	return false;
	
end

-- Disallows suicide
function GM:CanPlayerSuicide( ply )

	if( CAKE.ConVars[ "SuicideEnabled" ] != "1" ) then
	
		ply:ChatPrint( "Suicide is disabled!" )
		return false
		
	end
	
	return true;
	
end

function ccSetTitle2( ply, cmd, args )
	
	local title = args[1]
	
	for k, v in pairs( args ) do
		if v != args[1] then
			title = title .. " " .. v
		end
	end
	
	if( string.len( title ) > 40 ) then
		CAKE.SendChat( ply, "Title is too long! Max 40 characters" );
		return;
	end
	
	CAKE.SetCharField( ply, "title2", title );
	ply:SetNWString("title2", title);
	
	return;
	
end
concommand.Add( "rp_title2", ccSetTitle2 );
-- Set Title
function ccSetTitle( ply, cmd, args )

	local title = args[1]
	
	for k, v in pairs( args ) do
		if v != args[1] then
			title = title .. " " .. v
		end
	end
	
	if( string.len( title ) > 40 ) then
	
		CAKE.SendChat( ply, "Title is too long! Max 40 characters" );
		return;
		
	end
	
	CAKE.SetCharField( ply, "title", title );
	ply:SetNWString("title", title);
	
	return;
	
end
concommand.Add( "rp_title", ccSetTitle );

--[[
local function ccSetClothing( ply, cmd, args )
	
	local clothes = args[1]
	local helmet = args[2]
	
	/*
	if( helmet == "none" or helmet == "" ) then
		helmet = CAKE.GetCharField( ply, "model" )
	end
	if( clothes == "none" or clothes == "" ) then
		clothes = CAKE.GetCharField( ply, "model" )
	else
		ply:SetNoDraw( true )
	end*/
	
	
	CAKE.SetClothing( ply, clothes, helmet )
	CAKE.SetCharField( ply, "clothing", clothes )
	CAKE.SetCharField( ply, "helmet", helmet )
	CAKE.SavePlayerData( ply )
	CAKE.SendConsole( ply, "Clothing set to:" .. clothes );
	CAKE.SendConsole( ply, "Helmet set to:" .. helmet );
	
end
concommand.Add( "rp_setclothing", ccSetClothing );
local function ccSetGear( ply, cmd, args )

	local model = args[1]
	local bone = args[2]
	local pos = Vector( tonumber( args[3] ), tonumber( args[4] ), tonumber( args[5] ) )
	local ang = Angle(tonumber(  args[6] ), tonumber( args[7] ), tonumber( args[8] ) )
	CAKE.SetGear( ply, model, bone, pos, ang )
	CAKE.SendChat( ply, "Gear set to:" .. model )

end
concommand.Add( "rp_setgear", ccSetGear )
]]--
-- Change IC Name
function ccChangeName( ply, cmd, args )

	local name = args[ 1 ];
	CAKE.SetCharField(ply, "name", name );
	ply:SetNWString("name", name);
	
end
concommand.Add( "rp_changename", ccChangeName );

-- Allows a player to skip the respawn timer.
function ccAcceptDeath( ply, cmd, args )

	ply.deathtime = 120;
	
end
concommand.Add( "rp_acceptdeath", ccAcceptDeath );

function ccFlag( ply, cmd, args )
	
	local FlagTo = "";
	
	for k, v in pairs( CAKE.Teams ) do
	
		if( v[ "flag_key" ] == args[ 1 ] ) then
		
			FlagTo = v;
			FlagTo.n = k;
			break;
			
		end
		
	end
	
	if( FlagTo == "" ) then
	
		CAKE.SendChat( ply, "Incorrect Flag!" );
		return;
		
	end

	if( ( CAKE.GetCharField(ply, "flags" ) != nil and table.HasValue( CAKE.GetCharField( ply, "flags" ), args[ 1 ] ) ) or FlagTo[ "public" ] ) then
		
		ply:SetTeam( FlagTo.n );
		ply:RefreshBusiness();
		ply:Spawn( );
		return;
				
	else
	
		CAKE.SendChat( ply, "You do not have this flag!" );
		
	end		
	
end
concommand.Add( "rp_flag", ccFlag );

function ccLockDoor( ply, cmd, args )
	
	local entity = ents.GetByIndex( tonumber( args[ 1 ] ) );
	
	if( CAKE.IsDoor( entity ) ) then
	
		if( entity.owner == ply ) then
		
			entity:Fire( "lock", "", 0 );
			
		else
		
			CAKE.SendChat( ply, "This is not your door!" );
			
		end
		
	end

end
concommand.Add( "rp_lockdoor", ccLockDoor );

function ccUnLockDoor( ply, cmd, args )
	
	local entity = ents.GetByIndex( tonumber( args[ 1 ] ) );
	
	if( CAKE.IsDoor( entity ) ) then
	
		if( entity.owner == ply ) then
		
			entity:Fire( "unlock", "", 0 );
			
		else
		
			CAKE.SendChat( ply, "This is not your door!" );
			
		end
		
	end

end
concommand.Add( "rp_unlockdoor", ccUnLockDoor );

function ccOpenDoor( ply, cmd, args )

	local entity = ply:GetEyeTrace( ).Entity;
	
	if( entity != nil and entity:IsValid( ) and CAKE.IsDoor( entity ) and ply:GetPos( ):Distance( entity:GetPos( ) ) < 200 ) then
	
		local pos = entity:GetPos( );
		
		for k, v in pairs( CAKE.Doors ) do
		
			if( tonumber( v[ "x" ] ) == math.ceil( tonumber( pos.x ) ) and tonumber( v[ "y" ] ) == math.ceil( tonumber( pos.y ) ) and tonumber( v[ "z" ] ) == math.ceil( tonumber( pos.z ) ) ) then
			
				for k2, v2 in pairs( CAKE.Teams[ ply:Team( ) ][ "door_groups" ] ) do
				
					if( tonumber( v[ "group" ] ) == tonumber( v2 ) ) then
					
						entity:Fire( "toggle", "", 0 );
						
					end
					
				end
				
			end
			
		end
		
	end
	
end
concommand.Add( "rp_opendoor", ccOpenDoor );

function ccPurchaseDoor( ply, cmd, args )
	local door = ents.GetByIndex( tonumber( args[ 1 ] ) );
	local pos = door:GetPos( );
	
	for k, v in pairs( CAKE.Doors ) do
		
		if( tonumber( v[ "x" ] ) == math.ceil( tonumber( pos.x ) ) and tonumber( v[ "y" ] ) == math.ceil( tonumber( pos.y ) ) and tonumber( v[ "z" ] ) == math.ceil( tonumber( pos.z ) ) ) then
		
			CAKE.SendChat( ply, "This is not a purchaseable door!" );
			return;
			
		end
		
	end
	
	if( CAKE.IsDoor( door ) ) then

		if( door.owner == nil ) then
		
			if( tonumber( CAKE.GetCharField( ply, "money" ) ) >= 50 ) then
				
				-- Enough money to start off, let's start the rental.
				CAKE.ChangeMoney( ply, -50 );
				door.owner = ply;
				
				local function Rental( ply, doornum )
				
					local door = ents.GetByIndex( tonumber( doornum ) );
					
					if( door.owner == ply ) then
					
						if( tonumber( CAKE.GetCharField( ply, "money" ) ) >= 50 ) then
						
							CAKE.ChangeMoney( ply, 0 - 50 );
							CAKE.SendChat( ply, "You have been charged 50 credits for a door!" );
							-- Start the timer again
							--timer.Simple( 900, Rental, ply, doornum ); -- 15 minutes hoo rah
							
						else
						
							CAKE.SendChat( ply, "You have lost a door due to insufficient funds." );
							door.owner = nil;
							
						end
						
					end
				
				end
				
				--timer.Simple( 900, Rental, ply, tonumber( args[ 1 ] ) );
				
			end
			
		elseif( door.owner == ply ) then
		
			door.owner = nil;
			CAKE.SendChat( ply, "Door Unowned" );
			
		else
		
			CAKE.SendChat( ply, "This door is already rented by someone else!" );
			
		end
	
	end
	
end
concommand.Add( "rp_purchasedoor", ccPurchaseDoor );

function ccDropWeapon( ply, cmd, args )
	
	local wep = ply:GetActiveWeapon( )
	CAKE.DropWeapon( ply, wep )
	
end
concommand.Add( "rp_dropweapon", ccDropWeapon );

function ccTestFail( ply, cmd, args )

		ply:Kick( "You failed the test. voidrp.ucoz.com/forum" )
	
end
concommand.Add( "rp_testfail", ccTestFail )

function ccTestPass( ply, cmd, args)

	umsg.Start( "charactercreate", ply )
	umsg.End()

end
concommand.Add( "rp_testpass", ccTestPass )

function ccPickupItem( ply, cmd, args )
	
	local item = ents.GetByIndex( tonumber( args[ 1 ] ) );
	
	if( item != nil and item:IsValid( ) and item:GetClass( ) == "item_prop" and item:GetPos( ):Distance( ply:GetShootPos( ) ) < 100 ) then
		
		if( string.match( item.Class, "weapon" ) ) then
			ply:Give( item.Class )
		end
		
		item:Pickup( ply );
		ply:GiveItem( item.Class );
		CAKE.SavePlayerData( ply )
		
	end

end
concommand.Add( "rp_pickup", ccPickupItem );

function ccUseItem( ply, cmd, args )
	
	local item = ents.GetByIndex( tonumber( args[ 1 ] ) );
	
	if( item != nil and item:IsValid( ) and item:GetClass( ) == "item_prop" and item:GetPos( ):Distance( ply:GetShootPos( ) ) < 100 ) then
	
		if( string.match( item.Class, "clothing" ) or string.match( item.Class, "helmet" ) or string.match( item.Class, "weapon" ) ) then
			if( string.match( item.Class, "weapon" ) ) then
				ply:Give( item.Class )
			end
			item:Pickup( ply );
			ply:GiveItem( item.Class );
			CAKE.SavePlayerData( ply )
		else
			item:UseItem( ply );
		end
	end

end
concommand.Add( "rp_useitem", ccUseItem );

function ccSetFrequency( ply, cmd, args )

	CAKE.SetCharField( ply, "frequency", tonumber( args[1] ))
	ply:SetNWFloat( "frequency", tonumber( args[1] ) )
	CAKE.SendChat( ply, "Radio frequency set to: " .. args[1] )

end
concommand.Add( "rp_setfrequency", ccSetFrequency )

function ccGiveMoney( ply, cmd, args )
	
	if( player.GetByID( args[ 1 ] ) != nil ) then
	
		local target = player.GetByID( args[ 1 ] );
		
		if( tonumber( args[ 2 ] ) > 0 ) then
		
			if( tonumber( CAKE.GetCharField( ply, "money" ) ) >= tonumber( args[ 2 ] ) ) then
			
				CAKE.ChangeMoney( target, args[ 2 ] );
				CAKE.ChangeMoney( ply, 0 - args[ 2 ] );
				CAKE.SendChat( ply, "You gave " .. target:Nick( ) .. " " .. args[ 2 ] .. " credits!" );
				CAKE.SendChat( target, ply:Nick( ) .. " gave you " .. args[ 2 ] .. " credits!" );
				
			else
			
				CAKE.SendChat( ply, "You do not have that many tokens!" );
				
			end
			
		else
		
			CAKE.SendChat( ply, "Invalid amount of money!" );
			
		end
		
	else
	
		CAKE.SendChat( ply, "Target not found!" );
		
	end
	
end
concommand.Add( "rp_givemoney", ccGiveMoney );	

function ccOpenChat( ply, cmd, args )

	ply:SetNWInt( "chatopen", 1 )
	
end
concommand.Add( "rp_openedchat", ccOpenChat );

function ccSendPM( ply, cmd, args )
	local target = CAKE.FindPlayer( args[1] )
	local text = table.concat( args, " ", 2, #args ) --Shit, again...
	if( target:IsPlayer() ) then
		CAKE.SendChat( ply, "[Sent to: " .. target:OOCName() .. "]:" .. text  )
		CAKE.SendChat( target, "[From: " .. ply:OOCName() .. "]:" .. text  )
	else
		CAKE.SendChat( ply, "Player is either dead or doesn't exist!" );
	end
end
concommand.Add( "rp_pm", ccSendPM )

function ccCloseChat( ply, cmd, args )

	ply:SetNWInt( "chatopen", 0 )
	
end
concommand.Add( "rp_closedchat", ccCloseChat );

local function ccSetClothing( ply, cmd, args )
	
	local body = ""
	local helmet = ""
	local gloves = ""
	
	if( args[1] == "" or args[1] == "none" )then
		body = "none"
	else
		body = args[1]
	end
	
	if( args[2] == "" or args[2] == "none" )then
		helmet = "none"
	else
		helmet = args[2]
	end
	
	if args[3] then
		if( args[3] == "" or args[3] == "none" )then
			gloves = "none"
		else
			gloves = args[3]
		end
	else
		gloves = body
	end
	
	ply:RemoveClothing()
	
	CAKE.SetClothing( ply, body, helmet, gloves )
	CAKE.SetCharField( ply, "clothing", body )
	CAKE.SetCharField( ply, "helmet", helmet )

end
concommand.Add( "rp_setclothing", ccSetClothing );

local function ccSetGear( ply, cmd, args )

	local model = args[1]
	local bone = args[2]
	local offset = Vector( tonumber( args[3] ), tonumber( args[4] ), tonumber( args[5] ) )
	local angle = Angle( tonumber( args[6] ), tonumber( args[7] ), tonumber( args[8] ) )
	
	CAKE.HandleGear( ply, model, bone, offset, angle )

end
concommand.Add( "rp_setgear", ccSetGear )

local function ccRemoveGear( ply, cmd, args )
	
	if( args[2] and args[2] != "" ) then
		CAKE.RemoveGear( ply, args[1], tonumber( args[2] ))
	elseif( args[1] and args[1] != "" ) then
		CAKE.RemoveGear( ply, args[1] )
	else
		CAKE.RemoveAllGear( ply )
	end

end
concommand.Add( "rp_removegear", ccRemoveGear )