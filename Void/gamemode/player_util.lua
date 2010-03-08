-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- player_util.lua
-- Useful functions for players.
-------------------------------

function ccSetRed( ply, cmd, args )
	local red = tonumber( args[1] )
	if( red > 255 ) then red = 255 end
	ply:SetNWFloat( "oocred", red )
	CAKE.SetPlayerField( ply, "oocred", red )
end
concommand.Add( "rp_oocred", ccSetRed )

function ccSetBlue( ply, cmd, args )
	local blue = tonumber( args[1] )
	if( blue > 255 ) then blue = 255 end
	ply:SetNWFloat( "oocblue", blue )
	CAKE.SetPlayerField( ply, "oocblue", blue )
end
concommand.Add( "rp_oocblue", ccSetBlue )

function ccSetGreen( ply, cmd, args )
	local green = tonumber( args[1] )
	if( green > 255 ) then green = 255 end
	ply:SetNWFloat( "oocgreen", green )
	CAKE.SetPlayerField( ply, "oocgreen", green )
end
concommand.Add( "rp_oocgreen", ccSetGreen )

function ccSetAlpha( ply, cmd, args )
	local alpha = tonumber( args[1] )
	ply:SetNWFloat( "oocalpha", alpha )
	if( alpha > 100 ) then alpha = 100 end
	CAKE.SetPlayerField( ply, "oocalpha", alpha )
end
concommand.Add( "rp_oocalpha", ccSetAlpha )
function ccSetName( ply, cmd, args )
	local name = tostring( args[1] )
	ply:SetNWString( "oocname", name )
	if( string.len( name ) > 50 ) then
		CAKE.SendChat( ply, "Your name cannot be longer than 50 characters!" )
	end
	if( string.len( name ) < 1 ) then
		CAKE.SendChat( ply, "Enter a name!" )
	end
	if(ply.LastNameChange + CAKE.ConVars[ "OOCNameChange" ] < CurTime() ) then
		ply.LastNameChange = CurTime();
		CAKE.SetPlayerField( ply, "oocname", name )
	else
		local TimeLeft = math.ceil(ply.LastNameChange + CAKE.ConVars[ "OOCNameChange" ] - CurTime());
		CAKE.SendChat( ply, "Please wait " .. TimeLeft .. " seconds before changing OOC name again!");
		return;
	end
end
concommand.Add( "rp_oocname", ccSetName )

function ccGetCharInfo( ply, cmd, args )
	local target =  CAKE.FindPlayer( args[1] )
	local birthplace = CAKE.GetCharField( target, "birthplace" )
	local gender = CAKE.GetCharField( target, "gender" )
	local description = CAKE.GetCharField( target, "description" )
	local age = CAKE.GetCharField( target, "age" )
	local alignment = CAKE.GetCharField( target, "alignment" )
	umsg.Start("GetPlayerInfo", ply)
		umsg.Entity( target )
		umsg.String( birthplace )
		umsg.String( gender )
		umsg.String( description )
		umsg.String( age )
		umsg.String( alignment )
	umsg.End()
end
concommand.Add( "rp_getcharinfo", ccGetCharInfo )

function CAKE.OOCAdd( ply, text )

if( ply.LastOOC + CAKE.ConVars[ "OOCDelay" ] < CurTime() ) then
	local playername = ply:OOCName()
	local red = CAKE.GetPlayerField( ply, "oocred" )
	local blue = CAKE.GetPlayerField( ply, "oocblue" )
	local green = CAKE.GetPlayerField( ply, "oocgreen" )
	local alpha = CAKE.GetPlayerField( ply, "oocalpha" )
	if( string.sub( text, 1, 4 ) == "/ooc" ) then
		text = string.sub( text, 5 )
	else
		text = string.sub( text, 3 )
	end
	umsg.Start("AddOOCLine")
		umsg.String( tostring( text ) )
		umsg.String( tostring( playername ) )
		umsg.Vector( Vector( red, blue, green ) )
		umsg.Float( alpha )
	umsg.End()
	ply.LastOOC = CurTime();
	else
	local TimeLeft = math.ceil(ply.LastOOC + CAKE.ConVars[ "OOCDelay" ] - CurTime());
	CAKE.SendChat( ply, "Please wait " .. TimeLeft .. " seconds before using OOC chat again!");
end
	//CAKE.SendConsole( ply, "[OOC]" .. text )
end


function CAKE.SendChat( ply, msg )
	
	if ply:IsPlayer() then
		ply:PrintMessage( 3, msg );
	else
		print( msg )
	end
	
end

function CAKE.SendConsole( ply, msg )
	
	if ply:IsPlayer() then
		ply:PrintMessage( 2, msg ); -- At least I THINK it is 2..
	else
		print( msg )
	end
end

function ccPlayerFly( ply, cmd, args )
	if( CAKE.GetPlayerField( ply, "flytrust" ) == 1 ) then
		if( not ply:GetTable().Fly ) then
		ply:SetMoveType( 4 );
		
		ply:GetTable().Fly = true;
		
		else

		ply:SetMoveType( 2 );
		
		ply:GetTable().Fly = false;
		
		end
	else
		CAKE.SendChat( ply, "You don't have fly permission" );
	end
end
concommand.Add( "rp_fly", ccPlayerFly )

function ccRemoveChar( ply, cmd, args )

	local id = args[1]
	CAKE.RemoveCharacter( ply, id )
	
end
concommand.Add( "rp_removechar", ccRemoveChar )

function ccConfirmRemoval( ply, cmd, args )
	local id = args[1]
	local SteamID = CAKE.FormatSteamID( ply:SteamID() );
	local name = CAKE.PlayerData[ SteamID ][ "characters" ][ id ][ "name" ]
	local birthplace = CAKE.PlayerData[ SteamID ][ "characters" ][ id ][ "birthplace" ]
	local gender = CAKE.PlayerData[ SteamID ][ "characters" ][ id ][ "gender" ]
	local description = CAKE.PlayerData[ SteamID ][ "characters" ][ id ][ "description" ]
	local age = CAKE.PlayerData[ SteamID ][ "characters" ][ id ][ "age" ]
	local alignment = CAKE.PlayerData[ SteamID ][ "characters" ][ id ][ "alignment" ]
	local model = CAKE.PlayerData[ SteamID ][ "characters" ][ id ][ "model" ]
	umsg.Start("ConfirmCharRemoval", ply)
		umsg.String( name )
		umsg.String( birthplace )
		umsg.String( gender )
		umsg.String( description )
		umsg.String( age )
		umsg.String( alignment )
		umsg.String( model )
		umsg.Long( id )
	umsg.End()
end
concommand.Add( "rp_confirmremoval", ccConfirmRemoval )

function ccPlayerNoclip( ply, cmd, args )
	if( CAKE.GetPlayerField( ply, "nocliptrust" ) == 1 ) then
		if( not ply:GetTable().Fly ) then

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
	else
		CAKE.SendChat( ply, "You don't have noclip permission" );
	end
end
concommand.Add( "rp_noclip", ccPlayerNoclip )

function FreezeRagdoll( ent )

	--THIS SHIT IS FROM GARRY'S STATUE TOOL
	
	if( ent:GetTable().StatueInfo ) then
		return;
	end
 	 
 	ent:GetTable().StatueInfo = {} 
 	ent:GetTable().StatueInfo.Welds = {} 
 	 
 	local bones = ent:GetPhysicsObjectCount() 
 	 
 	local forcelimit = 0 
 	 

 	for bone=1, bones do 
 	 
 		local bone1 = bone - 1 
 		local bone2 = bones - bone 
 		 

 		if ( !ent:GetTable().StatueInfo.Welds[bone2] ) then 
 		 
 			local constraint1 = constraint.Weld( ent, ent, bone1, bone2, forcelimit ) 
 			 
 			if ( constraint1 ) then 
 			 
 				ent:GetTable().StatueInfo.Welds[bone1] = constraint1 
 			 
 			end 
 			 
 		end 
 		 
 		local constraint2 = constraint.Weld( ent, ent, bone1, 0, forcelimit ) 
 		 
 		if ( constraint2 ) then 
 		 
 			ent:GetTable().StatueInfo.Welds[bone1+bones] = constraint2 
 		 
 		end 
 		 
 	end 

end


DecayingRagdolls = {};

function CAKE.DeathMode( ply )

	CAKE.DayLog( "script.txt", "Starting death mode for " .. ply:SteamID( ) );
	local mdl = ply:GetModel( )
	
	local rag = ents.Create( "prop_ragdoll" )
	rag:SetModel( mdl )
	rag:SetPos( ply:GetPos( ) )
	rag:SetAngles( ply:GetAngles( ) )
	rag.isdeathdoll = true;
	rag.ply = ply;
	rag:Spawn( )
	
	ply:SetViewEntity( rag );
	
	ply.deathrag = rag;
	
	local n = #DecayingRagdolls + 1
	DecayingRagdolls[ n ] = ply.deathrag;
	
	ply:SetNWInt( "deathmode", 1 )
	
	ply.deathtime = 0;
	ply.nextsecond = CurTime( ) + 1;
	
	local function Freeze()
	local rag = DecayingRagdolls[ n ];

		if( rag and rag:IsValid() ) then
		
			FreezeRagdoll(rag)
	
		end
	
	end

	timer.Simple( 10, Freeze );
end

local meta = FindMetaTable( "Player" );

function meta:MaxHealth( )

	return self:GetNWFloat("MaxHealth");
	
end

function meta:ChangeMaxHealth( amt )

	self:SetNWFloat("MaxHealth", self:MaxHealth() + amt);
	
end

function CAKE.DropWeapon( ply, wep )

	if( CAKE.ItemData[ wep:GetClass( ) ] != nil ) then
		CAKE.CreateItem( wep:GetClass( ), ply:CalcDrop( ), Angle( 0,0,0 ) );
		ply:TakeItem( wep:GetClass() )
		local weapons = CAKE.GetCharField( ply, "weapons" )
		for k, v in pairs( weapons ) do
			if v == wep:GetClass( ) then
				v = nil
			end
		end
		CAKE.SetCharField( ply, "weapons", weapons )
	end
	ply:StripWeapon( wep:GetClass( ) );
	
end

function CAKE.SetSize( pl, size )
--Soz for the blatant copying.
	local a, b
	
	a = math.Clamp( size, .16, 16 ) * Vector( )
	b = 1
	
	if not pl:IsPlayer( ) then
		return false
	end
	
	PrepPlayer( pl, a,  	VecMul( Sizing.Hulls.Standing.Minimum, a ), 
				VecMul( Sizing.Hulls.Standing.Maximum, a ), 
				VecMul( Sizing.Hulls.Ducking.Minimum , a ),
				VecMul( Sizing.Hulls.Ducking.Maximum , a ),
				Sizing.Variables.JumpPower * a.z * 72 * ( a.z < .5 and 2 or 1 ), Sizing.Variables.StepSize * 72 * a.z, Sizing.Variables.RunSpeed * 72 * a.z, Sizing.Variables.WalkSpeed * 72 * a.z,
				Vector( 0, 0, a.z * 64 ), Vector( 0, 0, a.z * 28 ), b )		
	return true
	
end

function meta:MaxArmor( )

	return self:GetNWFloat("MaxArmor");
	
end

function meta:ChangeMaxArmor( amt )

	self:SetNWFloat("MaxArmor", self:MaxArmor() + amt);
	
end

function meta:MaxWalkSpeed( )

	return self:GetNWFloat("MaxWalkSpeed");
	
end

function meta:ChangeMaxWalkSpeed( amt )

	self:SetNWFloat("MaxWalkSpeed", self:MaxWalkSpeed() + amt);
	
end

function meta:MaxRunSpeed( )

	return self:GetNWFloat("MaxRunSpeed");
	
end

function meta:ChangeMaxRunSpeed( amt )

	self:SetNWFloat("MaxRunSpeed", self:MaxRunSpeed() + amt);
	
end

function meta:GiveItem( class )

	CAKE.DayLog( "economy.txt", "Adding item '" .. class .. "' to " .. CAKE.FormatCharString( self ) .. " inventory" );
	local inv = CAKE.GetCharField( self, "inventory" );
	table.insert( inv, class );
	CAKE.SetCharField( self, "inventory", inv);
	self:RefreshInventory( );

end

function meta:TakeItem( class )
	local inv = CAKE.GetCharField(self, "inventory" );
	
	for k, v in pairs( inv ) do
		if( v == class ) then
			inv[ k ] = nil;
			PrintTable( inv );
			CAKE.SetCharField( self, "inventory", inv);
			self:RefreshInventory( );
			CAKE.DayLog( "economy.txt", "Removing item '" .. class .. "' from " .. CAKE.FormatCharString( self ) .. " inventory" );
			return;
		end
	end
	
end

function meta:HasItem( class )
	local inv = CAKE.GetCharField(self, "inventory" );
	for k, v in pairs( inv ) do
		if( v == class ) then
			return true
		end
	end
	return false
end

function meta:ClearInventory( )
	umsg.Start( "clearinventory", self )
	umsg.End( );
end

function meta:RefreshInventory( )
	self:ClearInventory( )
	
	for k, v in pairs( CAKE.GetCharField( self, "inventory" ) ) do
		umsg.Start( "addinventory", self );
			umsg.String( CAKE.ItemData[ v ].Name );
			umsg.String( CAKE.ItemData[ v ].Class );
			umsg.String( CAKE.ItemData[ v ].Description );
			umsg.String( CAKE.ItemData[ v ].Model );
			if CAKE.ItemData[ v ].Flags then
				local concat = ""
				for k2, v2 in pairs( CAKE.ItemData[ v ].Flags ) do
					concat = concat .. v2 .. ","
				end
				umsg.String( concat );
			else
				CAKE.ItemData[ v ].Flags = {}
				umsg.String( "" );
			end
		umsg.End( );
	end
end

function meta:OOCName()
	if self:GetNWString( "oocname" ) == nil then
		return self:OOCName()
	else
		return self:GetNWString( "oocname" )
	end
end

function meta:ClearBusiness( )
	umsg.Start( "clearbusiness", self )
	umsg.End( );
end

function meta:ItemHasFlag( item, flag )

	if !CAKE.ItemData[ item ].Flags then
		CAKE.ItemData[ item ].Flags = {}
		return false
	end
	
	for k, v in pairs( CAKE.ItemData[ item ].Flags ) do
		if v == flag then
			return true
		end
	end
	
	return false

end

function meta:SaveAmmo()
	
	local tbl = {}
	if( CAKE.PlayerData[CAKE.FormatSteamID(self:SteamID())] != nil ) then
	tbl[ "AR2" ] = self:GetAmmoCount( "AR2" )
	tbl[ "AlyxGun" ] = self:GetAmmoCount( "AlyxGun" )
	tbl[ "Pistol" ] = self:GetAmmoCount( "Pistol" )
	tbl[ "SMG1" ] = self:GetAmmoCount( "SMG1" )
	tbl[ "357" ] = self:GetAmmoCount( "357" )
	tbl[ "XBowBolt" ] = self:GetAmmoCount( "XBowBolt" )
	tbl[ "Buckshot" ] = self:GetAmmoCount( "Buckshot" )
	tbl[ "RPG_Round" ] = self:GetAmmoCount( "RPG_Round" )
	tbl[ "SMG1_Grenade" ] = self:GetAmmoCount( "SMG1_Grenade" )
	tbl[ "SniperRound" ] = self:GetAmmoCount( "SniperRound" )
	tbl[ "SniperPenetratedRound" ] = self:GetAmmoCount( "SniperPenetratedRound" )
	tbl[ "Grenade" ] = self:GetAmmoCount( "Grenade" )
	tbl[ "Thumper" ] = self:GetAmmoCount( "Thumper" )
	tbl[ "Gravity" ] = self:GetAmmoCount( "Gravity" )
	tbl[ "Battery" ] = self:GetAmmoCount( "Battery" )
	tbl[ "GaussEnergy" ] = self:GetAmmoCount( "GaussEnergy" )
	tbl[ "CombineCannon" ] = self:GetAmmoCount( "CombineCannon" )
	tbl[ "AirboatGun" ] = self:GetAmmoCount( "AirboatGun" )
	tbl[ "StriderMinigun" ] = self:GetAmmoCount( "StriderMinigun" )
	tbl[ "HelicopterGun" ] = self:GetAmmoCount( "HelicopterGun" )
	tbl[ "AR2AltFire" ] = self:GetAmmoCount( "AR2AltFire" )
	tbl[ "slam" ] = self:GetAmmoCount( "slam" )
	CAKE.SetCharField( self, "ammo", tbl )
	end
	
end

function meta:RestoreAmmo()

	for k, v in pairs( CAKE.GetCharField( self, "ammo" ) ) do
		self:GiveAmmo( v, k )
	end

end

function meta:RefreshBusiness( )
	self:ClearBusiness( )
	local business = tonumber( CAKE.GetCharField( self, "business" ) )
		
	if(CAKE.Teams[self:Team()] == nil) then return; end -- Team not assigned
	
	for k, v in pairs( CAKE.ItemData ) do
	
		if( v.Purchaseable and business == v.ItemGroup ) then
		
			umsg.Start( "addbusiness", self );
				umsg.String( v.Name );
				umsg.String( v.Class );
				umsg.String( v.Description );
				umsg.String( v.Model );
				umsg.Long( v.Price );
			umsg.End( );
			
		end
	end
end

function meta:ConCommand( cmd ) --Rewriting this due to Garry fucking it up.
	if SERVER then
		umsg.Start( "runconcommand", self )
			umsg.String( cmd )
		umsg.End()
	end
end

function CAKE.ChangeMoney( ply, amount ) -- Modify someone's money amount.

	-- Come on, Nori, how didn't you see the error in this?
	--if( ( CAKE.GetCharField( ply, "money" ) - amount ) < 0 ) then return; end 
	
	CAKE.DayLog( "economy.txt", "Changing " .. ply:SteamID( ) .. "-" .. ply:GetNWString( "uid" ) .. " money by " .. tostring( amount ) );
	
	CAKE.SetCharField( ply, "money", CAKE.GetCharField( ply, "money" ) + amount );
	if CAKE.GetCharField( ply, "money" ) < 0 then -- An actual negative number block
		CAKE.SetCharField( ply, "money", 0 );
		ply:SetNWString("money", "0" )
	else
		ply:SetNWString("money", CAKE.GetCharField( ply, "money" ));
	end

end

function CAKE.DrugPlayer( pl, mul ) -- DRUG DAT BITCH

	mul = mul / 10 * 2;

	pl:ConCommand("pp_motionblur 1")
	pl:ConCommand("pp_motionblur_addalpha " .. 0.05 * mul)
	pl:ConCommand("pp_motionblur_delay " .. 0.035 * mul)
	pl:ConCommand("pp_motionblur_drawalpha 1.00")
	pl:ConCommand("pp_dof 1")
	pl:ConCommand("pp_dof_initlength 9")
	pl:ConCommand("pp_dof_spacing 8")

	local IDSteam = string.gsub(pl:SteamID(), ":", "")

	timer.Create(IDSteam, 40 * mul, 1, CAKE.UnDrugPlayer, pl)
end

function CAKE.UnDrugPlayer(pl)
	pl:ConCommand("pp_motionblur 0")
	pl:ConCommand("pp_dof 0")
end