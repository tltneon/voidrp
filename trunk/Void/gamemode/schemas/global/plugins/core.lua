PLUGIN.Name = "Core Plugin"; -- What is the plugin name
PLUGIN.Author = "LuaBanana"; -- Author of the plugin
PLUGIN.Description = "Configures the gamemode on a deeper level."; -- The description or purpose of the plugin

-- !!!! WARNING !!!! --
-- DO NOT REMOVE ANYTHING IN THIS FILE OR YOUR SERVER WILL CEASE TO FUNCTION.
-- !!!! WARNING !!!! --

CAKE.AddDataField( 1, "characters", { } );

-- These fields are what would be the default value, and it also allows the field to actually EXIST.
-- If there is a field in the data and it isn't added, it will automatically be removed.

-- Character Fields
CAKE.AddDataField( 2, "name", "Set Your Name" ); -- Let's hope this never gets used.
CAKE.AddDataField( 2, "model", "models/humans/group01/male_07.mdl" );
CAKE.AddDataField( 2, "title", CAKE.ConVars[ "Default_Title" ] );
CAKE.AddDataField( 2, "birthplace", "Earth" ) 
CAKE.AddDataField( 2, "gender", "Male" ) -- MAN POWER
CAKE.AddDataField( 2, "alignment", "True Neutral" )
CAKE.AddDataField( 2, "description", "" )
CAKE.AddDataField( 2, "clothing", "none" )
CAKE.AddDataField( 2, "helmet", "none" )
CAKE.AddDataField( 2, "clothingoverride", "none" )
CAKE.AddDataField( 2, "gear", {} )
CAKE.AddDataField( 2, "ammo", {} )
CAKE.AddDataField( 2, "weapons", {} )
CAKE.AddDataField( 2, "frequency", 0 )
CAKE.AddDataField( 2, "age", 30 )
CAKE.AddDataField( 2, "business", 0 )
CAKE.AddDataField( 2, "doorgroup", 0 )
CAKE.AddDataField( 2, "money", CAKE.ConVars[ "Default_Money" ] ); -- How much money do players start out with.
CAKE.AddDataField( 2, "flags", CAKE.ConVars[ "Default_Flags" ] ); -- What flags do they start with.
CAKE.AddDataField( 2, "inventory", CAKE.ConVars[ "Default_Inventory" ] );
CAKE.AddDataField( 2, "race", "human" )
CAKE.AddDataField( 2, "height", 1 )
CAKE.AddDataField( 2, "title2", "" ); --Second title
CAKE.AddDataField( 1, "oocred", 0 );
CAKE.AddDataField( 1, "oocgreen", 255 );
CAKE.AddDataField( 1, "oocblue", 0 );
CAKE.AddDataField( 1, "oocalpha", 100);
CAKE.AddDataField( 1, "oocname", "");
CAKE.AddDataField( 1, "passedtut", 0 )