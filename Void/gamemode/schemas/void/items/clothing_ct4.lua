ITEM.Name = "Mercenary Suit (4)";
ITEM.Class = "clothing_medium_ct4";
ITEM.Description = "Looks great on mercenaries";
ITEM.Model = "models/player/ct_gign.mdl";
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
