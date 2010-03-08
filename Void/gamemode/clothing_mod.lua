--Credits to Andrew McWatters and the PAC team for parts of code.


--This list is taken from PAC, thanks to the PAC development team.
local BoneList, EditorBone = {
	["pelvis"			] = "ValveBiped.Bip01_Pelvis"		,
	["spine 1"			] = "ValveBiped.Bip01_Spine"		,
	["spine 2"			] = "ValveBiped.Bip01_Spine1"		,
	["spine 3"			] = "ValveBiped.Bip01_Spine2"		,
	["spine 4"			] = "ValveBiped.Bip01_Spine4"		,
	["neck"				] = "ValveBiped.Bip01_Neck1"		,
	["head"				] = "ValveBiped.Bip01_Head1"		,
	["right clavicle"	] = "ValveBiped.Bip01_R_Clavicle"	,
	["right upper arm"	] = "ValveBiped.Bip01_R_UpperArm"	,
	["right forearm"	] = "ValveBiped.Bip01_R_Forearm"	,
	["right hand"		] = "ValveBiped.Bip01_R_Hand"		,
	["left clavicle"	] = "ValveBiped.Bip01_L_Clavicle"	,
	["left upper arm"	] = "ValveBiped.Bip01_L_UpperArm"	,
	["left forearm"		] = "ValveBiped.Bip01_L_Forearm"	,
	["left hand"		] = "ValveBiped.Bip01_L_Hand"		,
	["right thigh"		] = "ValveBiped.Bip01_R_Thigh"		,
	["right calf"		] = "ValveBiped.Bip01_R_Calf"		,
	["right foot"		] = "ValveBiped.Bip01_R_Foot"		,
	["right toe"		] = "ValveBiped.Bip01_R_Toe0"		,
	["left thigh"		] = "ValveBiped.Bip01_L_Thigh"		,
	["left calf"		] = "ValveBiped.Bip01_L_Calf"		,
	["left foot"		] = "ValveBiped.Bip01_L_Foot"		,
	["left toe"			] = "ValveBiped.Bip01_L_Toe0"		
}

local function BoneTranslate( bone )
	return BoneList[string.lower(bone)]
end

local function PlayerDeath( Victim, Inflictor, Attacker )

		if( Victim.Clothing ) then
			for k, v in pairs( Victim.Clothing ) do
				if( ValidEntity( v ) ) then
					v:SetParent( Victim:GetRagdollEntity() )
					v:Initialize()
				end
			end
		end
	   
	   Victim:RemoveClothing()

end

hook.Add( "PlayerDeath", "PlayerRemoveClothing", PlayerDeath )


	local meta = FindMetaTable( "Player" );
	
	function CAKE.SetClothing( ply, body, helmet, glove )
		
		local usegloves = false
		if body and body != "none" then
			if ply:HasItem( body ) then
				if CAKE.ItemData[ body ].Flags then
					for k, v in pairs( CAKE.ItemData[ body ].Flags ) do
						if string.match( v, "armor" ) then
							local exp = string.Explode( ";", v )
							ply:SetNWFloat( "armor", tonumber( exp[2] ) )
							ply:SetArmor( tonumber( exp[2] ) )
						end
					end
					if ply:ItemHasFlag( body, "nogloves" ) then
						usegloves = true
						glove = "none"
					end
				end
				body = CAKE.ItemData[ body ].Model
			end
		else
			body = CAKE.GetCharField( ply, "model" )
		end
		
		if !helmet or helmet == "none" or !ply:HasItem( helmet ) then
			helmet = CAKE.GetCharField( ply, "model" )
		else
			helmet = CAKE.ItemData[ helmet ].Model
		end
		
		if usegloves then
			if !glove or glove == "none" then
				glove = CAKE.GetCharField( ply, "model" )
			end
		else
			glove = body
		end
		
		CAKE.HandleClothing( ply, body, 1 )
		CAKE.HandleClothing( ply, helmet, 2 )
		CAKE.HandleClothing( ply, glove, 3 )
		ply:SetRenderMode( RENDERMODE_NONE )
		
	end
	
	function meta:RemoveClothing()
		if self.Clothing then
			CAKE.RemoveAllGear( self )
		
			for k, v in pairs( self.Clothing ) do
				if type( v ) != "table" then
					if ValidEntity( v ) then
						v:Remove()
						v = nil
					end
				end
			end
		end
		
		self.Clothing = {}
		
	end
	
	function CAKE.HandleClothing( ply, model, type )
		
		if !ply.Clothing then
			ply.Clothing = {}
		end
		
		ply.Clothing[ type ] = ents.Create( "player_part" )
		ply.Clothing[ type ]:SetDTInt( 1, type )
		ply.Clothing[ type ]:SetModel( model )
		ply.Clothing[ type ]:SetParent( ply )
		ply.Clothing[ type ]:SetPos( ply:GetPos() )
		ply.Clothing[ type ]:SetAngles( ply:GetAngles() )
		ply.Clothing[ type ]:Spawn()
		
	end
	
	function CAKE.HandleGear( ply, model, bone, offset, angle )
	
		if !ply.Clothing then
			ply.Clothing = {}
		end
		
		if !ply.Clothing.Gear then
			ply.Clothing.Gear = {}
		end
		
		if !ply.Clothing.Gear[ bone ] then
			ply.Clothing.Gear[ bone ] = {}
		end
		
		local index = #ply.Clothing.Gear + 1
		
		ply.Clothing.Gear[ bone ][ index ] = ents.Create( "player_gear" )
		ply.Clothing.Gear[ bone ][ index ]:SetDTInt( 1, ply:LookupBone( bone ) )
		ply.Clothing.Gear[ bone ][ index ]:SetDTEntity( 2, ply )
		ply.Clothing.Gear[ bone ][ index ]:SetDTAngle( 3, angle )
		ply.Clothing.Gear[ bone ][ index ]:SetDTVector( 4, offset )
		ply.Clothing.Gear[ bone ][ index ]:SetModel( model )
		ply.Clothing.Gear[ bone ][ index ]:SetParent( ply )
		ply.Clothing.Gear[ bone ][ index ]:SetPos( ply:GetPos() )
		ply.Clothing.Gear[ bone ][ index ]:SetAngles( ply:GetAngles() )
		--ply.Clothing.Gear[ index ]:SetModelScale( scale )
		ply.Clothing.Gear[ bone ][ index ]:Spawn()
		
		PrintTable( ply.Clothing.Gear )
		
	end
	
	function CAKE.RemoveGear( ply, bone, index )
		if index then
			ply.Clothing.Gear[ bone ][ index ]:Remove()
			ply.Clothing.Gear[ bone ][ index ] = nil
		else
			for k, v in pairs( ply.Clothing.Gear[ bone ] ) do
				v:Remove()
				v = nil
			end
			ply.Clothing.Gear[ bone ] = {}
		end
	end
	
	function CAKE.RemoveAllGear( ply )
		if ply.Clothing.Gear then
			for k, v in pairs( ply.Clothing.Gear ) do
				for k2, v2 in pairs( ply.Clothing.Gear[ v ] ) do
					if ValidEntity( v2 ) then
						v2:Remove()
						v2 = nil		
					end
				end
				ply.Clothing.Gear[ v ] = {}
			end
		end
		
		ply.Clothing.Gear = {}
	end
	
	
	
	--Amazing how I can condense this mess into something as simple as the above.
	/*
	
	function CAKE.SetClothing( ply, model, helmet )
			
			local gloves = ""
				if( ply:Armor() <= 0 ) then
					if string.match( model, "light") then
						ply:SetNWFloat( "armor", 50 )
						ply:SetArmor( 50 )
						gloves = model
						ply:SetBloodColor( -1 )
					elseif string.match( model, "medium") then
						ply:SetNWFloat( "armor", 100 )
						ply:SetArmor( 100)
						gloves = model
						ply:SetBloodColor( -1 )
					elseif string.match( model, "heavy") then
						ply:SetArmor( 200)
						gloves = model
						ply:SetNWFloat( "armor", 200 )
						ply:SetBloodColor( -1 )
					else
						ply:SetArmor( 0 )
						ply:SetNWFloat( "armor", 0 )
						gloves = CAKE.GetCharField( ply, "model" )
						ply:SetBloodColor( COLOR_RED )
					end
				end
			
			if( !ply:HasItem( model ) ) then
				if CAKE.GetCharField( ply, "clothingoverride" ) == "none" then
					model = CAKE.GetCharField( ply, "model" )
				else
					model = CAKE.GetCharField( ply, "clothingoverride" )
				end
			else
				model = CAKE.ItemData[ model ].Model
			end
			if( !ply:HasItem( helmet ) ) then
				if CAKE.GetCharField( ply, "clothingoverride" ) == "none" then
					helmet = CAKE.GetCharField( ply, "model" )
				else
					gloves = CAKE.GetCharField( ply, "clothingoverride" )
					helmet = CAKE.GetCharField( ply, "clothingoverride" )
				end
			else
				helmet = CAKE.ItemData[ helmet ].Model
			end
	   ply:RemoveClothing()
	   if ( model == "" ) then
			ply:SetNoDraw( false )
			return
	   end
	   if ( model == "none" ) then 
			ply:SetNoDraw( false )
			return
		end
	   if( helmet != "" and helmet != "none" ) then ply:SetNWBool( "hashelmet", true ) end
		CAKE.HandleClothing( ply, model, helmet )
		CAKE.HandleGloves( ply, gloves )
	end
	
	function CAKE.HandleClothing( ply, model, helmet )
		ply:RemoveClothing()
		local gender = CAKE.GetCharField( ply, "gender" )
		util.PrecacheModel( model )
	   --ply:SetNoDraw( true )
	   ply.m_hModel = ents.Create( "player_model" )
	   ply.m_hModel:SetParent( ply )
	   ply.m_hModel:SetPos( ply:GetPos() )
	   ply.m_hModel:SetAngles( ply:GetAngles() )
		if( gender == "Female" ) then
			ply.m_hModel:SetModel( "models/alyx.mdl" );
		else
			ply.m_hModel:SetModel( "models/barney.mdl" );
		end
	   ply.m_hModel:Spawn()
	   ply.m_hModel:SetNoDraw( true )
	   ply.m_hClothing = ents.Create( "player_clothing" )
	   ply.m_hClothing:SetModel( model )
	   ply.m_hClothing:SetParent( ply )
	   ply.m_hClothing:SetPos( ply:GetPos() )
	   ply.m_hClothing:SetAngles( ply:GetAngles() )
	   ply.m_hClothing:Spawn()
	   if( helmet != "" and helmet != "none" ) then
		   util.PrecacheModel( helmet )
		   ply.m_hHelmet = ents.Create( "player_helmet" )
		   ply.m_hHelmet:SetModel( helmet )
		   ply.m_hHelmet:SetParent( ply )
		   ply.m_hHelmet:SetPos( ply:GetPos() )
		   ply.m_hHelmet:SetAngles( ply:GetAngles() )
		   ply.m_hHelmet:Spawn()
	   else
		   if ( ply.m_hHelmet and ply.m_hHelmet:IsValid() ) then
			   ply.m_hHelmet:Remove()
			   ply.m_hHelmet = nil
		   end
		   return
	   end
	end
	
	function CAKE.HandleGloves( ply, model )
		ply.m_hGloves = ents.Create( "player_glove" )
		ply.m_hGloves:SetModel( model )
		ply.m_hGloves:SetParent( ply )
		ply.m_hGloves:SetPos( ply:GetPos() )
		ply.m_hGloves:SetAngles( ply:GetAngles() )
		ply.m_hGloves:Spawn()
	end

	function CAKE.SetGear( ply, model, bone, pos, ang )
		if !ply.m_hGear then
			ply.m_hGear = {}
		end
		if ply.m_hGear[ bone ] and ply.m_hGear[ bone ]:IsValid() then
			ply:RemoveGear( bone )
		end
		ply.m_hGear[ bone ] = ents.Create( "player_gear" )
		ply.m_hGear[ bone ]:SetModel( model )
		--ply.m_hGear[ bone ]:SetParent( ply )
		ply.m_hGear[ bone ]:Spawn()
		umsg.Start("GetPlayerParts")
			umsg.Entity( ply.m_hModel )
			umsg.Entity( ply.m_hGear[ bone ] )
			umsg.String( bone )
			umsg.Vector( pos )
			umsg.Angle( ang )
		umsg.End()
	end
	
		function meta:RestoreGear()

	   if !self.m_hGear then
		   self.m_hGear = {}
	   end
	   
	   local bone = ""
	   for k, v in pairs ( CAKE.GetCharField( self, "gear" ) ) do
		   self:SetGear( v.model, v, Vector( v.posx, v.posy, v.posz ), Angle( v.anglep, v.angley, v.angler ) )
	   end

	end

	function meta:RemoveClothing()

	   if ( self.m_hClothing && self.m_hClothing:IsValid() ) then

		   self.m_hModel:Remove()
		   self.m_hModel = nil
		   self.m_hClothing:Remove()
		   self.m_hClothing = nil

		   self:SetMaterial( "" )

	   end
	   
	   if ( self.m_hHelmet and self.m_hHelmet:IsValid() ) then
		   
		   self.m_hHelmet:Remove()
		   self.m_hHelmet = nil
		   
	   end
	   
		if( self.m_hGloves and self.m_hGloves:IsValid() ) then
			self.m_hGloves:Remove()
			self.m_hGloves = nil
		end

	end

	function meta:RemoveGear( bone )

	   if !self.m_hGear then
		   self.m_hGear = {}
	   end
	   if self.m_hGear[ bone ] and self.m_hGear[ bone ]:IsValid() then
		   self.m_hGear[ bone ]:Remove()
		   self.m_hGear[ bone ] = nil
	   end
	   local savetable = CAKE.GetCharField( self, "gear" )
	   for k, v in pairs ( savetable ) do
		   if string.match( v, bone ) then
			   table.remove( savetable, k )
		   end
	   end
	   CAKE.SetCharField( self, "gear", savetable )
	   
	end

	function meta:RemoveAllGear()

	   if !self.m_hGear then
		   self.m_hGear = {}
	   end
	   
	   if self.m_hGear then
		   for k, v in pairs ( self.m_hGear ) do
			   v:Remove()
			   v = nil
		   end
	   end
	   
	   CAKE.SetCharField( self, "gear", {} )
	   
	end
	*/
