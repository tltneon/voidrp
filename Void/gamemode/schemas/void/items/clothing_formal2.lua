ITEM.Name = "Formal Clothes (2)";
ITEM.Class = "clothing_formal2";
ITEM.Description = "For the refined gentlemen";
ITEM.Model = "models/gman_high.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 500;
ITEM.ItemGroup = 1;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
