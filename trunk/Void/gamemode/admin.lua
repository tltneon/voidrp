-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- admin.lua
-- Admin functions. Admin concommands are in admin_cc.lua
-------------------------------

SuperAdmins = { };
Admins = { };

CAKE.AdminCommands = {  }

function CAKE.AnnounceAction( ply, action )

	local s = "[ ADMIN ] " .. ply:Name( ) .. " " .. action;

	for k, v in pairs( player.GetAll( ) ) do

		v:ChatPrint( s );
		
	end

end

-- This will create an admin function.
function CAKE.AdminCommand( ccName, func, description, CanRunFromConsole, CanRunFromAdmin, SuperOnly )

		local cmd = {  };
		cmd.func = func;
		cmd.desc = description;
		cmd.CanRunFromConsole = CAKE.NilFix(CanRunFromConsole, true);
		cmd.CanRunFromAdmin = CAKE.NilFix(CanRunFromAdmin, true);
		cmd.SuperOnly = CAKE.NilFix(SuperOnly, false);

		CAKE.AdminCommands[ ccName ] = cmd;
	
end

-- Syntax is rp_admin command args
function ccAdmin( ply, cmd, args )

	local cmd = CAKE.NilFix( CAKE.AdminCommands[ args[ 1 ] ], 0);
	
	if( cmd == 0 ) then
	
		CAKE.SendChat( ply, "That is not a valid command!" );
		return;
		
	end
	
	local func = cmd.func; -- Retrieve the function
	local CanRunFromConsole = cmd.CanRunFromConsole; -- Can it be run from the console
	local CanRunFromAdmin = cmd.CanRunFromAdmin; -- Can it be run from a player's console
	local SuperOnly = cmd.SuperOnly; -- Can a regular admin run it
	
	table.remove( args, 1 ); -- Remove the admin command from the arguments
	
	if( ply:EntIndex( ) == 0 ) then -- We're dealing with a console
	
		if( CanRunFromConsole ) then
		
			func( ply, cmd, args );
			
		else

			CAKE.PrintConsole( "You cannot run this command from server console!" );
			
		end
		
	else	
	
		if( ply:IsAdmin( ) and !ply:IsSuperAdmin( ) ) then -- We're dealing with an admin.
			
			if( !SuperOnly and CanRunFromAdmin ) then
			
				func( ply, cmd, args )
				
			else
			
				CAKE.SendChat( ply, "You cannot run this command!" );
				
			end
		
		end
		
		if( ply:IsSuperAdmin( ) ) then -- We're dealing with a superadmin.
		
			if( CanRunFromAdmin ) then
			
				func( ply, cmd, args )
				
			else
			
				CAKE.SendChat( ply, "You cannot run this command!" );
				
			end
			
		end
		
		
	end

end
concommand.Add("rp_admin", ccAdmin) 