
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

	self.Entity:DrawModel()
	self.Entity:DrawShadow( false )

end

/*------------------------------------------------------------
	Does the actual bone scaling work. This function is made
	to work with copied bones too (realboneid).
------------------------------------------------------------*/
local function BoneScale( self, realboneid )

	local matBone = self:GetBoneMatrix( realboneid )

	matBone:Scale( Vector( 0, 0, 0 ) )

	self:SetBoneMatrix( realboneid, matBone )

end

local body = {
	"ValveBiped.Bip01_Head1",
	"ValveBiped.Bip01_L_Hand",
	"ValveBiped.Bip01_L_Finger0",
	"ValveBiped.Bip01_L_Finger1",
	"ValveBiped.Bip01_L_Finger2",
	"ValveBiped.Bip01_L_Finger3",
	"ValveBiped.Bip01_L_Finger4",
	"ValveBiped.Bip01_L_Finger01",
	"ValveBiped.Bip01_L_Finger02",
	"ValveBiped.Bip01_L_Finger11",
	"ValveBiped.Bip01_L_Finger12",
	"ValveBiped.Bip01_L_Finger21",
	"ValveBiped.Bip01_L_Finger22",
	"ValveBiped.Bip01_L_Finger31",
	"ValveBiped.Bip01_L_Finger32",
	"ValveBiped.Bip01_L_Finger41",
	"ValveBiped.Bip01_L_Finger42",
	"ValveBiped.Bip01_R_Hand",
	"ValveBiped.Bip01_R_Finger0",
	"ValveBiped.Bip01_R_Finger1",
	"ValveBiped.Bip01_R_Finger2",
	"ValveBiped.Bip01_R_Finger3",
	"ValveBiped.Bip01_R_Finger4",
	"ValveBiped.Bip01_R_Finger01",
	"ValveBiped.Bip01_R_Finger02",
	"ValveBiped.Bip01_R_Finger11",
	"ValveBiped.Bip01_R_Finger12",
	"ValveBiped.Bip01_R_Finger21",
	"ValveBiped.Bip01_R_Finger22",
	"ValveBiped.Bip01_R_Finger31",
	"ValveBiped.Bip01_R_Finger32",
	"ValveBiped.Bip01_R_Finger41",
	"ValveBiped.Bip01_R_Finger42",
	"ValveBiped.Bip01_R_Hand"
}

local gloves = {
	"ValveBiped.Bip01_L_Hand",
	"ValveBiped.Bip01_L_Finger0",
	"ValveBiped.Bip01_L_Finger1",
	"ValveBiped.Bip01_L_Finger2",
	"ValveBiped.Bip01_L_Finger3",
	"ValveBiped.Bip01_L_Finger4",
	"ValveBiped.Bip01_L_Finger01",
	"ValveBiped.Bip01_L_Finger02",
	"ValveBiped.Bip01_L_Finger11",
	"ValveBiped.Bip01_L_Finger12",
	"ValveBiped.Bip01_L_Finger21",
	"ValveBiped.Bip01_L_Finger22",
	"ValveBiped.Bip01_L_Finger31",
	"ValveBiped.Bip01_L_Finger32",
	"ValveBiped.Bip01_L_Finger41",
	"ValveBiped.Bip01_L_Finger42",
	"ValveBiped.Bip01_R_Hand",
	"ValveBiped.Bip01_R_Finger0",
	"ValveBiped.Bip01_R_Finger1",
	"ValveBiped.Bip01_R_Finger2",
	"ValveBiped.Bip01_R_Finger3",
	"ValveBiped.Bip01_R_Finger4",
	"ValveBiped.Bip01_R_Finger01",
	"ValveBiped.Bip01_R_Finger02",
	"ValveBiped.Bip01_R_Finger11",
	"ValveBiped.Bip01_R_Finger12",
	"ValveBiped.Bip01_R_Finger21",
	"ValveBiped.Bip01_R_Finger22",
	"ValveBiped.Bip01_R_Finger31",
	"ValveBiped.Bip01_R_Finger32",
	"ValveBiped.Bip01_R_Finger41",
	"ValveBiped.Bip01_R_Finger42",
	"ValveBiped.Bip01_R_Hand"
}

local head = {
	"ValveBiped.Bip01_Head1",
	"ValveBiped.Bip01_Neck1",
	"Bip01_ponytail",
	"Bip01_ponytail1",
	"Bip01_ponytail2",
	"Bip01_ponytail3",
	"Bip01_ponytail4",
	"HairN",
	"LMomi01N",
	"LMomi02N",
	"Ponytail01N",
	"Ponytail02N",
	"Ponytail03N",
	"RMomi01N",
	"RMomi02N"
}
/*---------------------------------------------------------
   Name: BuildBonePositions
   Desc:
---------------------------------------------------------*/
function ENT:BuildBonePositions( NumBones, NumPhysBones )

	local tbl = {}
	local index = 0
	local inverse = false
	local exceptions = {}
	if self.Entity:GetDTInt( 1 ) == 1 then
		exceptions = body
		inverse = true
	elseif self.Entity:GetDTInt( 1 ) == 2 then
		exceptions = head
	elseif self.Entity:GetDTInt( 1 ) == 3 then
		exceptions = gloves
	end
	for k, v in pairs( exceptions ) do
		index = self.Entity:LookupBone( v )
		if index != 0 then
			table.insert( tbl, index )
		end
	end
	
	for i=0, NumBones do
		if inverse then
			if ( table.HasValue( tbl, i ) ) then
				BoneScale( self, i )
			end
		else
			if ( !table.HasValue( tbl, i ) ) then
				BoneScale( self, i )
			end
		end
	end
	/*
	local realboneid = self.Entity:LookupBone( "ValveBiped.Bip01_Head1" )

	BoneScale( self, realboneid )*/

end

