if SERVER then
	AddCSLuaFile( "resizer_main.lua" )
end

Sizing = { 
		Hulls = { 
			Standing = {
					Minimum = Vector( -16, -16, 00 ),
					Maximum = Vector(  16,  16, 72 ),
				},
			Ducking = {
					Minimum = Vector( -16, -16, 00 ),
					Maximum = Vector(  16,  16, 36 ),
				}
			},
		Offsets = {
			Standing 	= 64 / 72,
			Ducking 	= 28 / 72,
			},
		Variables = {
			JumpPower 	= 160 / 36	,
			StepSize 	= 18 / 72	,
			RunSpeed	= 500 / 72	,
			WalkSpeed	= 250 / 72	,
		},
	}
	
Sizing.Default = {
			StandingHull 	= Sizing.Hulls.Standing,
			DuckingHull 	= Sizing.Hulls.Ducking,
			JumpPower 	= 10,
			StepSize 	= 18,
			RunSpeed 	= 250,
			WalkSpeed 	= 80,
			Scale 		= Vector( ),
			ViewOffset 	= Vector( 0, 0, 64 ),
			ViewOffsetDuck 	= Vector( 0, 0, 28 ),
			AdjustToHeight	= true,
		}

function VecMul( a, b )
	return Vector( a.x * b.x, a.y * b.y, a.z * b.z )
end
local function Tick( )
	local k, v, delta
	
	delta = FrameTime( ) * 2
	
	for k, v in pairs( player.GetAll( ) ) do
		if not v.Currents then
			v.Currents 	= table.Copy( Sizing.Default )
			v.Progress 	= 0
		end
		
		if not v.Targets then
			v.Targets 	= table.Copy( v.Currents )
			v.Progress	= 0
		end
		
		if v.Progress ~= 1 then
			v.Currents.Scale 			= Lerp( v.Progress, v.Currents.Scale			, v.Targets.Scale 			)
			v.Currents.StandingHull.Minimum 	= Lerp( v.Progress, v.Currents.StandingHull.Minimum	, v.Targets.StandingHull.Minimum 	)
			v.Currents.StandingHull.Maximum 	= Lerp( v.Progress, v.Currents.StandingHull.Maximum	, v.Targets.StandingHull.Maximum 	)
			v.Currents.DuckingHull.Minimum 		= Lerp( v.Progress, v.Currents.DuckingHull.Minimum	, v.Targets.DuckingHull.Minimum 	)
			v.Currents.DuckingHull.Maximum 		= Lerp( v.Progress, v.Currents.DuckingHull.Maximum	, v.Targets.DuckingHull.Maximum 	)
			//v.Currents.JumpPower 			= Lerp( v.Progress, v.Currents.JumpPower		, v.Targets.JumpPower 			)
			v.Currents.StepSize 			= Lerp( v.Progress, v.Currents.StepSize			, v.Targets.StepSize 			)
			//v.Currents.RunSpeed			= Lerp( v.Progress, v.Currents.RunSpeed			, v.Targets.RunSpeed 			)
			//v.Currents.WalkSpeed			= Lerp( v.Progress, v.Currents.WalkSpeed		, v.Targets.WalkSpeed 			)
			v.Currents.ViewOffset			= Lerp( v.Progress, v.Currents.ViewOffset		, v.Targets.ViewOffset 			)
			v.Currents.ViewOffsetDuck 		= Lerp( v.Progress, v.Currents.ViewOffsetDuck		, v.Targets.ViewOffsetDuck 		)
			
			if CLIENT then	
				v:SetModelScale( v.Currents.Scale )
			end
			
			if v.Currents.AdjustToHeight then
				//v:SetJumpPower( v.Currents.JumpPower )
				v:SetStepSize( v.Currents.StepSize )
				gamemode.Call( "SetPlayerSpeed", v, v.Currents.WalkSpeed, v.Currents.RunSpeed )
			end
			
			v:SetHull( 	v.Currents.StandingHull.Minimum	, v.Currents.StandingHull.Maximum 	)
			v:SetHullDuck( 	v.Currents.DuckingHull.Minimum	, v.Currents.DuckingHull.Maximum 	)
			
			v:SetViewOffset( 	v.Currents.ViewOffset 		)
			v:SetViewOffsetDucked( 	v.Currents.ViewOffsetDuck 	)
		
			v.Progress = math.Approach( v.Progress, 1, delta )
		end
	end
end

hook.Add( "Tick", "Resizer.Tick", Tick )

function PrepPlayer( pl, scale, shullmin, shullmax, dullmin, dullmax, jump, step, run, walk, off, offd, adj )
	local t
	
	if scale == "~update" then
		t = table.Copy( pl.Targets )

		if SERVER then
			umsg.Start( "Resize Player" )
				umsg.Entity( pl )
				umsg.Vector( t.Scale )
				umsg.Long( t.JumpPower )
				umsg.Long( t.StepSize )
				umsg.Long( t.RunSpeed )
				umsg.Long( t.WalkSpeed )
				umsg.Long( t.ViewOffset.z )
				umsg.Long( t.ViewOffsetDuck.z )
				umsg.Bool( t.AdjustToHeight )
			umsg.End( )
		end
	else
		t = table.Copy( Sizing.Default )
	
		t.Scale = scale
		t.StandingHull.Minimum = shullmin
		t.StandingHull.Maximum = shullmax
		t.DuckingHull.Minimum = dullmin
		t.DuckingHull.Maximum = dullmax
		t.JumpPower = jump
		t.StepSize = step
		t.RunSpeed = run
		t.WalkSpeed = walk
		t.ViewOffset = off
		t.ViewOffsetDuck = offd	
		t.AdjustToHeight = adj
	
		pl.Progress = 0
		pl.Targets = t
		pl.Currents = pl.Currents or table.Copy( Sizing.Default )
	
		if SERVER then	
			umsg.Start( "Resize Player" )
				umsg.Entity( pl )
				umsg.Vector( scale )
				umsg.Long( jump )
				umsg.Long( step )
				umsg.Long( run )
				umsg.Long( walk )
				umsg.Long( off.z )
				umsg.Long( offd.z )
				umsg.Bool( adj )
			umsg.End( )
		end
	end
end

if CLIENT then
	local function umResize( um )
		local pl, scale, t
	
		pl = um:ReadEntity( )
		scale = um:ReadVector( )
		
		t = table.Copy( Sizing.Default )
	
		PrepPlayer( pl, scale, 	VecMul( t.StandingHull.Minimum, t.Scale ), 
				VecMul( t.StandingHull.Maximum, t.Scale ), 
				VecMul( t.DuckingHull.Minimum , t.Scale ),
				VecMul( t.DuckingHull.Maximum , t.Scale ),
				um:ReadLong( ), um:ReadLong( ), um:ReadLong( ), um:ReadLong( ),
				Vector( 0, 0, um:ReadLong( ) ), Vector( 0, 0, um:ReadLong( ) ),
				um:ReadBool( ) )
	end
	usermessage.Hook( "Resize Player", umResize )
else
	timer.Create( "Resize.Updater", 30, 0, function( )
							local k, v
							
							for k, v in pairs( player.GetAll( ) ) do
								PrepPlayer( v, "~update" )
							end
						end )
end