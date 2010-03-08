SCHEMA.Name = "Void RP";
SCHEMA.Author = "Big Bang";
SCHEMA.Description = "The future today";
SCHEMA.Base = "global";

function SCHEMA.SetUp( )
	
	local team = CAKE.HL2Team();
	
	
	CAKE.AddBusiness( "grocery", 1 )
	CAKE.AddBusiness( "bm", 2 )
	CAKE.AddBusiness( "medic", 3 )
	-- Citizens
	CAKE.AddTeam( CAKE.HL2Team( ) ); -- Citizen
	--We don't actually use flags themselves.

	CAKE.AddModels({
			  "models/humans/group01/male_01.mdl",
              "models/humans/group01/male_02.mdl",
              "models/humans/group01/male_03.mdl",
              "models/humans/group01/male_04.mdl",
              "models/humans/group01/male_06.mdl",
              "models/humans/group01/male_07.mdl",
              "models/humans/group01/male_08.mdl",
              "models/humans/group01/male_09.mdl",
			  "models/humans/group01/female_01.mdl",
              "models/humans/group01/female_02.mdl",
              "models/humans/group01/female_03.mdl",
              "models/humans/group01/female_04.mdl",
              "models/humans/group01/female_06.mdl",
              "models/humans/group01/female_07.mdl"
	});			  
end
