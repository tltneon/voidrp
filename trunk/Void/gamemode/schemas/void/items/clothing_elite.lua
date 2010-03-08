ITEM.Name = "GR-X1 Combat Exosuit";
ITEM.Class = "clothing_heavy_elite";
ITEM.Description = "Heavy armor, designed with space in mind";
ITEM.Model = "models/Combine_Super_Soldier.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 1000;
ITEM.ItemGroup = 2;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
