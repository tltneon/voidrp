PLUGIN.Name = "Chat Commands"; -- What is the plugin name
PLUGIN.Author = "LuaBanana"; -- Author of the plugin
PLUGIN.Description = "A set of default chat commands"; -- The description or purpose of the plugin

function OOCChat( ply, text )

	-- OOC Chat
	if( ply.LastOOC + CAKE.ConVars[ "OOCDelay" ] < CurTime() ) then
	
		ply.LastOOC = CurTime();
		return "[OOC]: " .. text;
	
	else
	
		local TimeLeft = math.ceil(ply.LastOOC + CAKE.ConVars[ "OOCDelay" ] - CurTime());
		CAKE.SendChat( ply, "Please wait " .. TimeLeft .. " seconds before using OOC chat again!");
		
		return "";
		
	end
	
end

function Broadcast( ply, text )

	-- Check to see if the player's team allows broadcasting
	local team = ply:Team( );
	
	if( CAKE.Teams[ team ][ "broadcast" ] ) then
		
		for k, v in pairs( player.GetAll( ) ) do
		
			CAKE.SendChat( v, ply:Nick( ) .. " [BROADCAST]: " .. text );
			
		end
	
	end
	
	return "";
	
end

function Advertise( ply, text )

	if(CAKE.ConVars[ "AdvertiseEnabled" ] == "1") then
	
		if( tonumber( CAKE.GetCharField( ply, "money" ) ) >= CAKE.ConVars[ "AdvertisePrice" ] ) then
			
			CAKE.ChangeMoney( ply, 0 - CAKE.ConVars[ "AdvertisePrice" ] );
		
			for _, pl in pairs(player.GetAll()) do
			
				CAKE.SendChat(pl, "[AD] " .. ply:Nick() .. ": " .. text)
		
			end
			
		else
		
			CAKE.SendChat(ply, "You do not have enough credits! You need " .. CAKE.ConVars[ "AdvertisePrice" ] .. " to send an advertisement.");
			
		end	
		
	else
	
		CAKE.ChatPrint(ply, "Advertisements are not enabled");
		
	end
	
	return "";
	
end

function ccAdminChat( ply, text )
if(!ply:IsAdmin()) then return false; end

	for k,v in pairs( player.GetAll() ) do

		if( v:IsAdmin() ) then
			LEMON.SendChat(v, "[ADMIN] ".. ply:Nick() ..": ".. text )
		end

	end

	return "";

end


function Event( ply, text )

	if( ply:IsAdmin() or ply:IsSuperAdmin() ) then
		
		for _, pl in pairs(player.GetAll()) do
			
			CAKE.SendChat(pl, "[EVENT] : " .. text)
		
		end
		
	else
	
		CAKE.SendChat(ply, "You are not allowed to do events");
		
	end
	
	return "";
	
end

function BigNotice( ply, text )

	if( ply:IsAdmin() or ply:IsSuperAdmin() ) then
		
		for _, pl in pairs(player.GetAll()) do
			
			pl:PrintMessage( HUD_PRINTCENTER, text )
		
		end
		
	else
	
		CAKE.SendChat(ply, "You are not allowed to do notices");
		
	end
	
	return "";
end
	

function AnonNotice( ply, text )

	if( ply:IsAdmin() or ply:IsSuperAdmin() ) then
		
		for _, pl in pairs(player.GetAll()) do
			
			CAKE.SendChat(pl, text)
		
		end
		
	else
	
		CAKE.SendChat(ply, "You are not allowed to do notices");
		
	end
	
	return "";
	
end

function AdminTalk( ply, text )
	for k, v in pairs( player.GetAll() ) do
		if( v:IsAdmin() or v:IsSuperAdmin() ) then
			CAKE.SendChat(v, "[Report from " .. ply:OOCName() .. "]:" .. text );
		end
	end
end

function PM( ply, text )
	ply:ConCommand( "rp_pm ".. text );
	return "";
end

function Radio( ply, text )

	local players = player.GetAll();
	local heardit = {};

	if(CAKE.PlayerData[CAKE.FormatSteamID(ply:SteamID())] == nil) then return ""; end
	
	if(ply:GetNWFloat( "frequency", 0 ) != 0 ) then
		for k2, v2 in pairs(player.GetAll()) do
			if( CAKE.PlayerData[CAKE.FormatSteamID(v2:SteamID())] != nil ) then
				if(ply:GetNWFloat( "frequency", 0 ) == v2:GetNWFloat( "frequency", 0 )) then
					CAKE.SendChat(v2, "[" .. tostring( v2:GetNWFloat( "frequency", 0 ) )  .. "] " .. ply:Nick() .. ": " .. text);
					table.insert(heardit, v2);
				end
			end
		end
	end

	for k, v in pairs(players) do
		
		if(!table.HasValue(heardit, v)) then
		
			local minirange = CAKE.ConVars[ "WhisperRange" ]
			
			if( v:EyePos( ):Distance( ply:EyePos( ) ) <= minirange ) then
				if(!table.HasValue(heardit, v)) then
					CAKE.SendChat( v, ply:Nick() .. ": " .. text );
					table.insert(heardit, v);
				end	
			end
		
			local range = CAKE.ConVars[ "TalkRange" ]
			
			if( v:EyePos( ):Distance( ply:EyePos( ) ) <= range ) then
			
				if(!table.HasValue(heardit, v)) then
				
					local randomchance = math.random( 1, 3 )
					
					if( randomchance == 1 ) then
					
						CAKE.SendChat( v, "*** " .. ply:Nick() .. " speaks on a communication device. You're too far to hear properly." );
						
					elseif( randomchance == 2 ) then
					
						CAKE.SendChat( v, "*** " .. ply:Nick() .. " said something you couldn't listen." );
						
					elseif( randomchance == 3 ) then
						
						CAKE.SendChat( v, "*** " .. ply:Nick() .. " spoke on a comm device, however you could not hear what was said." );
						
					end
					
				end
				
			end
			
		end
		
	end
	
	return "";

end

function ChangeTitle( ply, text )

	ply:ConCommand( "rp_title ".. text );

	return "";
	
end

function ChangeTitle2( ply, text )

	ply:ConCommand( "rp_title2 ".. text );

	return "";
	
end

function Chat_ModPlayerVars(ply)

	ply.LastOOC = -1000000; -- This is so people can talk for the first time without having to wait.
		
end

function PLUGIN.Init( ) -- We run this in init, because this is called after the entire gamemode has been loaded.

	CAKE.ConVars[ "AdvertiseEnabled" ] = "1"; -- Can players advertise
	CAKE.ConVars[ "AdvertisePrice" ] = 25; -- How much do advertisements cost
	CAKE.ConVars[ "OOCDelay" ] = 10; -- How long do you have to wait between OOC Chat
	CAKE.ConVars[ "OOCNameChange" ] = 300; -- How long do you have to wait between name changes
	CAKE.ConVars[ "YellRange" ] = 1.5; -- How much farther will yell chat go
	CAKE.ConVars[ "WhisperRange" ] = 0.2; -- How far will whisper chat go
	CAKE.ConVars[ "MeRange" ] = 1.0; -- How far will me chat go
	CAKE.ConVars[ "LOOCRange" ] = 1.0; -- How far will LOOC chat go
	
	CAKE.SimpleChatCommand( "/me", CAKE.ConVars[ "MeRange" ], "*** $1 $3" ); -- Me chat
	CAKE.SimpleChatCommand( "/anon", CAKE.ConVars[ "MeRange" ], "???: $3" ); -- Me chat
	CAKE.SimpleChatCommand( "/it", CAKE.ConVars[ "MeRange" ], "*** $3 ***" ); -- Me chat
	CAKE.SimpleChatCommand( "/y", CAKE.ConVars[ "YellRange" ], "$1 [YELL]: $3" ); -- Yell chat
	CAKE.SimpleChatCommand( "/w", CAKE.ConVars[ "WhisperRange" ], "$1 [WHISPER]: $3" ); -- Whisper chat
	CAKE.SimpleChatCommand( ".//", CAKE.ConVars[ "LOOCRange" ], "$1 | $2 [LOOC]: $3" ); -- Local OOC Chat
	CAKE.SimpleChatCommand( "[[", CAKE.ConVars[ "LOOCRange" ], "$1 | $2 [LOOC]: $3" ); -- Local OOC Chat

	CAKE.ChatCommand( "/ad", Advertise ); -- Advertisements
	//CAKE.ChatCommand( "/ooc", OOCChat ); -- OOC Chat
	//CAKE.ChatCommand( "//", OOCChat ); -- OOC Chat
	CAKE.ChatCommand( "/bc", Broadcast ); -- Broadcast
	CAKE.ChatCommand( "/event", Event );
	CAKE.ChatCommand( "/pm", PM );
	CAKE.ChatCommand( "/radio", Radio ); -- Radio
	CAKE.ChatCommand( "@@", AnonNotice );
	CAKE.ChatCommand( "@@@", BigNotice );
	CAKE.ChatCommand( "/a", ccAdminChat );
	CAKE.ChatCommand( "/title", ChangeTitle );
	CAKE.ChatCommand( "/title2", ChangeTitle2 );
	//CAKE.ChatCommand( "/a", AdminTalk );
	CAKE.AddHook("Player_Preload", "chat_modplayervars", Chat_ModPlayerVars); -- Put in our OOCDelay variable
	
end

