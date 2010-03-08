ITEM.Name = "Tactical CAT-5 Exosuit";
ITEM.Class = "clothing_medium_catsuit";
ITEM.Description = "Lightweight, yet durable. Perfect for assasins. Made for the ladies.";
ITEM.Model = "models/smashbros/samlyx.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 1000;
ITEM.ItemGroup = 2;
ITEM.Flags = {
	"armor;100"
}

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
