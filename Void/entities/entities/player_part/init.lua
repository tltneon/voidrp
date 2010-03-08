
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )


/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()

	// Set engine effects
	self.Entity:AddEffects( EF_BONEMERGE | EF_BONEMERGE_FASTCULL | EF_PARENT_ANIMATES )

end



