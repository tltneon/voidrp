ITEM.Name = "Guerilla Combatant Armor";
ITEM.Class = "clothing_medium_terro2";
ITEM.Description = "Combat suit, with extra padding.";
ITEM.Model = "models/player/t_phoenix.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 700;
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
