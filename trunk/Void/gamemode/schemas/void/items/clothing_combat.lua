ITEM.Name = "Female Combat Clothes";
ITEM.Class = "clothing_light_combatf";
ITEM.Description = "Combat suit, tailored for ladies";
ITEM.Model = "models/Humans/Group03/Female_01.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 300;
ITEM.ItemGroup = 2;
ITEM.Flags = {
	"armor;50"
}
function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
