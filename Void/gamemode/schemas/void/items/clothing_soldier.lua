ITEM.Name = "EV-7e Combat Exosuit";
ITEM.Class = "clothing_soldier";
ITEM.Description = "Standard armor, designed with space in mind";
ITEM.Model = "models/Combine_Soldier.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 750;
ITEM.ItemGroup = 2;
ITEM.Flags = {
	"armor;120"
}
function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
