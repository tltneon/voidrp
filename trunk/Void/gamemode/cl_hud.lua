-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- cl_hud.lua 
-- General HUD stuff.
-------------------------------

LocalPlayer( ).MyModel = "" -- Has to be blank for the initial value, so it will create a spawnicon in the first place.

surface.CreateFont( "ChatFont", 22, 100, true, false, "PlInfoFont" );

local function DrawTime( )

	draw.DrawText( GetGlobalString( "time" ), "PlInfoFont", 10, 10, Color( 255,255,255,255 ), 0 );
	
end

function DrawTargetInfo( )
	
	local tr = LocalPlayer( ):GetEyeTrace( )
	
	if( !tr.HitNonWorld ) then return; end
	
	if( tr.Entity:GetClass( ) == "item_prop" and tr.Entity:GetPos( ):Distance( LocalPlayer( ):GetPos( ) ) < 100 and not tr.Entity:GetTable().Observe ) then
	
		local screenpos = tr.Entity:GetPos( ):ToScreen( )
		draw.DrawText( tr.Entity:GetNWString( "Name" ), "ChatFont", screenpos.x + 2, screenpos.y + 2, Color( 0, 0, 0, 255 ), 1 );	
		draw.DrawText( tr.Entity:GetNWString( "Name" ), "ChatFont", screenpos.x, screenpos.y, Color( 255, 255, 255, 255 ), 1 );
		draw.DrawText( tr.Entity:GetNWString( "Description" ), "ChatFont", screenpos.x + 2, screenpos.y + 22, Color( 0, 0, 0, 255 ), 1 );	
		draw.DrawText( tr.Entity:GetNWString( "Description" ), "ChatFont", screenpos.x, screenpos.y + 20, Color( 255, 255, 255, 255 ), 1 );

	end
	
end
		
function GM:HUDShouldDraw( name )

	if( LocalPlayer( ):GetNWInt( "charactercreate" ) == 1 or LocalPlayer( ):GetNWInt( "charactercreate" ) == nil ) then return false; end
	
	local nodraw = 
	{ 
	
		--"CHudHealth",
		"CHudAmmo",
		"CHudSecondaryAmmo"
		--"CHudBattery",
	
	 }
	
	for k, v in pairs( nodraw ) do
	
		if( name == v ) then return false; end
	
	end
	
	return true;

end

function DrawDeathMeter( )

	local timeleft = LocalPlayer( ):GetNWInt( "deathmoderemaining" );
	local w = ( timeleft / 120 ) * 198
	
	draw.RoundedBox( 8, ScrW( ) / 2 - 100, 5, 200, 50, Color( GUIcolor_trans ) );
	draw.RoundedBox( 8, ScrW( ) / 2 - 98, 7, w, 46, Color( 255, 0, 0, 255 ) );
	
	draw.DrawText( "Time Left ( Type !acceptdeath to respawn )", "ChatFont", ScrW( ) / 2 - 93, 25 - 5, Color( 255,255,255,255 ), 0 );
	
end

surface.CreateFont( "ChatFont", 22, 500, true, false, "PlInfoFont" );

function DrawPlayerInfo( )

	for k, v in pairs( player.GetAll( ) ) do	
	
		if( v != LocalPlayer( ) and !v:GetNWBool( "observe" )) then
		
			if( v:Alive( ) ) then
			
				local alpha = 0
				local tracedata = {}
				tracedata.start = LocalPlayer():GetShootPos()
				tracedata.endpos = v:GetPos()
				tracedata.filter = LocalPlayer()
				local trace = util.TraceLine( tracedata )
				local position = v:GetPos( )
				local position = Vector( position.x, position.y, position.z + 75 )
				local screenpos = position:ToScreen( )
				local dist = position:Distance( LocalPlayer( ):GetPos( ) )
				local dist = dist / 2
				local dist = math.floor( dist )
				
				if !trace.HitWorld then
					if( dist > 100 ) then
				
						alpha = 255 - ( dist - 100 )
					
					else
				
						alpha = 255
					
					end
				
					if( alpha > 255 ) then
				
						alpha = 255
					
					elseif( alpha < 0 ) then
				
						alpha = 0
					
					end
				
					
				
					draw.DrawText( v:Nick( ), "DefaultSmall", screenpos.x, screenpos.y, Color( 255, 255, 255, alpha ), 1 )
					draw.DrawText( v:GetNWString( "title" ), "DefaultSmall", screenpos.x, screenpos.y + 10, Color( 255, 255, 255, alpha ), 1 )
					draw.DrawText( v:GetNWString( "title2" ), "DefaultSmall", screenpos.x, screenpos.y + 20, Color( 255, 255, 255, alpha ), 1 )
				
					if( v:GetNWInt( "chatopen" ) == 1 ) then
					
						draw.DrawText( "Typing..", "ChatFont", screenpos.x, screenpos.y - 50, Color( 255, 255, 255, alpha ), 1 )
					
					end
				end
				
			end
			
		end
		
	end
	
end

function GM:HUDPaint( )
	
	if( LocalPlayer( ):GetNWInt( "deathmode" ) == 1 ) then
	
		DrawDeathMeter( )
		
	end
	
	-- DrawPlayerInfo( );
	if( LocalPlayer():GetInfo( "timetoggle" ) == "1" ) then
	DrawTime( );
	end
	DrawPlayerInfo( );
	DrawTargetInfo( );
	
end