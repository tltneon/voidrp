ITEM.Name = "SPLINTER Space-grade Exosuit";
ITEM.Class = "clothing_medium_splinter";
ITEM.Description = "Medium armor, adapted for all possible fields of battle";
ITEM.Model = "models/player/Neo_heavy.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 1200;
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
