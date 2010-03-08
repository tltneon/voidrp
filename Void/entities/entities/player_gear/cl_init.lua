
include('shared.lua')

/*---------------------------------------------------------
   Name: DrawPre
---------------------------------------------------------*/
function ENT:Draw()

	if ( self.Entity:GetParent() && self.Entity:GetParent():IsValid() ) then

		if ( self.Entity:GetParent() == LocalPlayer() ) then

			if ( !gamemode.Call( "ShouldDrawLocalPlayer" ) ) then return end

		end

	end
	
	--Basically, we're just getting the bone position of the player we want to place the gear on, and making the model draw on that position.
	if self.Entity:GetDTInt( 1 ) then
		local position, angles = self.Entity:GetDTEntity( 2 ):GetBonePosition(self.Entity:GetDTInt(1))
		position, angles = LocalToWorld( Vector( 0, 0, 0 ), self.Entity:GetDTAngle(3), position, angles )
		self.Entity:SetPos(position + self.Entity:GetDTVector(4))
		self.Entity:SetAngles(angles)
	end

	self.Entity:DrawModel()
	self.Entity:DrawShadow( false )


end



