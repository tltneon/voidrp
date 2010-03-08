ITEM.Name = "Tough Guy Armor";
ITEM.Class = "clothing_medium_tough";
ITEM.Description = "Tuff Stuff";
ITEM.Model = "models/player/t_guerilla.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 750;
ITEM.ItemGroup = 2;
ITEM.Flags = {
	"armor;90"
}
function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
