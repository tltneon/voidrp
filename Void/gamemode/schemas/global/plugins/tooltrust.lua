PLUGIN.Name = "Tool Trust"; -- What is the plugin name
PLUGIN.Author = "LuaBanana"; -- Author of the plugin
PLUGIN.Description = "Toolgun permissions, as well as physgun ban."; -- The description or purpose of the plugin

function Tooltrust_Give(ply)

	if(tostring(CAKE.GetPlayerField(ply, "tooltrust")) == "1") then
	
		ply:Give("gmod_tool");
		
	end
	
	if(tostring(CAKE.GetPlayerField(ply, "phystrust")) == "1") then
	
		ply:Give("weapon_physgun");
	
	end

	ply:Give("weapon_physcannon");
	
end

function Admin_Tooltrust(ply, cmd, args)

	if(#args != 2) then
	
		CAKE.SendChat( ply, "Invalid number of arguments! ( rp_admin tooltrust \"name\" 1/0 )" );
		return;

	end
	
	local target = CAKE.FindPlayer(args[1])
	
	if(target != nil and target:IsValid() and target:IsPlayer()) then
		-- klol
	else
		CAKE.SendChat( ply, "Target not found!" );
		return;
	end
	
	if(args[2] == "1") then
	
		CAKE.SetPlayerField(target, "tooltrust", 1);
		target:Give("gmod_tool");
		CAKE.SendChat( target, "You have been given tooltrust by " .. ply:OOCName() );
		CAKE.SendChat( ply, target:OOCName() .. " has been given tooltrust" );
		
	elseif(args[2] == "0") then
	
		CAKE.SetPlayerField(target, "tooltrust", 0);
		target:StripWeapon("gmod_tool");
		CAKE.SendChat( target, "Your tooltrust has been removed by " .. ply:OOCName() );
		CAKE.SendChat( ply, target:OOCName() .. "'s tooltrust has been removed" );
		
	end
	
end

function Admin_Phystrust(ply, cmd, args)

	if(#args != 2) then
	
		CAKE.SendChat( ply, "Invalid number of arguments! ( rp_admin phystrust \"name\" 1/0 )" );
		return;

	end
	
	local target = CAKE.FindPlayer(args[1])
	
	if(target != nil and target:IsValid() and target:IsPlayer()) then
		-- klol
	else
		CAKE.SendChat( ply, "Target not found!" );
		return;
	end
	
	if(args[2] == "0") then
	
		CAKE.SetPlayerField(target, "phystrust", 0);
		target:StripWeapon("weapon_physgun");
		CAKE.SendChat( target, "You have been banned from the physics gun by " .. ply:OOCName());
		CAKE.SendChat( ply, target:OOCName() .. " has been banned from the physics gun" );
		
	elseif(args[2] == "1") then
	
		CAKE.SetPlayerField(target, "phystrust", 1);
		target:Give("weapon_physgun");
		CAKE.SendChat( target, "You have been given the physgun by " .. ply:OOCName() );
		CAKE.SendChat( ply, target:OOCName() .. " has been given a physgun" );
		
	end
	
end

function Admin_Gravtrust(ply, cmd, args)

	if(#args != 2) then
	
		CAKE.SendChat( ply, "Invalid number of arguments! ( rp_admin gravtrust \"name\" 1/0 )" );
		return;

	end
	
	local target = CAKE.FindPlayer(args[1])
	
	if(target != nil and target:IsValid() and target:IsPlayer()) then
		-- klol
	else
		CAKE.SendChat( ply, "Target not found!" );
		return;
	end
	
	if(args[2] == "0") then
	
		CAKE.SetPlayerField(target, "gravtrust", 0);
		target:StripWeapon("weapon_physcannon");
		CAKE.SendChat( target, "You have been banned from the gravity gun by " .. ply:OOCName());
		CAKE.SendChat( ply, target:OOCName() .. " has been banned from the gravity gun" );
		
	elseif(args[2] == "1") then
	
		CAKE.SetPlayerField(target, "gravtrust", 1);
		target:Give("weapon_physcannon");
		CAKE.SendChat( target, "You have been given the gravgun by " .. ply:OOCName() );
		CAKE.SendChat( ply, target:OOCName() .. " has been given a gravgun" );
		
	end
	
end

function Admin_Proptrust(ply, cmd, args)

	if(#args != 2) then
	
		CAKE.SendChat( ply, "Invalid number of arguments! ( rp_admin proptrust \"name\" 1/0 )" );
		return;

	end
	
	local target = CAKE.FindPlayer(args[1])
	
	if(target != nil and target:IsValid() and target:IsPlayer()) then
		-- klol
	else
		CAKE.SendChat( ply, "Target not found!" );
		return;
	end
	
	if(args[2] == "0") then
	
		CAKE.SetPlayerField(target, "proptrust", 0);
		CAKE.SendChat( target, "You have been banned from spawning props by " .. ply:OOCName());
		CAKE.SendChat( ply, target:OOCName() .. " has been banned from spawning props" );
		
	elseif(args[2] == "1") then
	
		CAKE.SetPlayerField(target, "proptrust", 1);
		CAKE.SendChat( target, "You have been allowed to spawn props by " .. ply:OOCName() );
		CAKE.SendChat( ply, target:OOCName() .. " has been allowed to spawn props" );
		
	end
	
end

function Admin_Flytrust(ply, cmd, args)

	if(#args != 2) then
	
		CAKE.SendChat( ply, "Invalid number of arguments! ( rp_admin flytrust \"name\" 1/0 )" );
		return;

	end
	
	local target = CAKE.FindPlayer(args[1])
	
	if(target != nil and target:IsValid() and target:IsPlayer()) then
		-- klol
	else
		CAKE.SendChat( ply, "Target not found!" );
		return;
	end
	
	if(args[2] == "0") then
	
		CAKE.SetPlayerField(target, "flytrust", 0);
		CAKE.SendChat( target, "You have been banned from flying by " .. ply:OOCName());
		CAKE.SendChat( ply, target:OOCName() .. " has been banned from flying" );
		
	elseif(args[2] == "1") then
	
		CAKE.SetPlayerField(target, "flytrust", 1);
		CAKE.SendChat( target, "You have been allowed to fly by " .. ply:OOCName() );
		CAKE.SendChat( ply, target:OOCName() .. " has been allowed to fly" );
		
	end
	
end

function Admin_Nocliptrust(ply, cmd, args)

	if(#args != 2) then
	
		CAKE.SendChat( ply, "Invalid number of arguments! ( rp_admin nocliptrust \"name\" 1/0 )" );
		return;

	end
	
	local target = CAKE.FindPlayer(args[1])
	
	if(target != nil and target:IsValid() and target:IsPlayer()) then
		-- klol
	else
		CAKE.SendChat( ply, "Target not found!" );
		return;
	end
	
	if(args[2] == "0") then
	
		CAKE.SetPlayerField(target, "nocliptrust", 0);
		CAKE.SendChat( target, "You have been banned from using noclip by " .. ply:OOCName());
		CAKE.SendChat( ply, target:OOCName() .. " has been banned from noclip" );
		
	elseif(args[2] == "1") then
	
		CAKE.SetPlayerField(target, "nocliptrust", 1);
		CAKE.SendChat( target, "You have been allowed to use noclip by " .. ply:OOCName() );
		CAKE.SendChat( ply, target:OOCName() .. " has been allowed to noclip" );
		
	end
	
end
	
function PLUGIN.Init()

	CAKE.ConVars[ "Default_Tooltrust" ] = "0"; -- Are players allowed to have the toolgun when they first start.
	CAKE.ConVars[ "Default_Gravtrust" ] = "1"; -- Are players allowed to have the gravgun when they first start.
	CAKE.ConVars[ "Default_Phystrust" ] = "0"; -- Are players allowed to have the physgun when they first start.
	CAKE.ConVars[ "Default_Proptrust" ] = "0"; -- Are players allowed to spawn props when they first start.
	
	CAKE.AddDataField( 1, "tooltrust", CAKE.ConVars[ "Default_Tooltrust" ] ); -- Is the player allowed to have the toolgun
	CAKE.AddDataField( 1, "gravtrust", CAKE.ConVars[ "Default_Gravtrust" ] ); -- Is the player allowed to have the gravity gun
	CAKE.AddDataField( 1, "phystrust", CAKE.ConVars[ "Default_Phystrust" ] ); -- Is the player allowed to have the physics gun
	CAKE.AddDataField( 1, "proptrust", CAKE.ConVars[ "Default_Proptrust" ] ); -- Is the player allowed to spawn props
	CAKE.AddDataField( 1, "flytrust", "0" );
	CAKE.AddDataField( 1, "nocliptrust", "0" );
	
	CAKE.AddHook("PlayerSpawn", "tooltrust_give", Tooltrust_Give);
	
	CAKE.AdminCommand( "tooltrust", Admin_Tooltrust, "Change someones tooltrust", true, true, false );
	CAKE.AdminCommand( "gravtrust", Admin_Gravtrust, "Change someones gravtrust", true, true, false );
	CAKE.AdminCommand( "phystrust", Admin_Phystrust, "Change someones phystrust", true, true, false );
	CAKE.AdminCommand( "proptrust", Admin_Proptrust, "Change someones proptrust", true, true, false );
	CAKE.AdminCommand( "flytrust", Admin_Flytrust, "Change someones flytrust", true, true, false );
	CAKE.AdminCommand( "nocliptrust", Admin_Nocliptrust, "Change someones nocliptrust", true, true, false );
	
end