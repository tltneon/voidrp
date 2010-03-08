ITEM.Name = "Combat Clothes";
ITEM.Class = "clothing_light_combat";
ITEM.Description = "Combat ready outfit, not very reliable, but sturdy";
ITEM.Model = "models/Humans/Group03/male_06.mdl";
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
