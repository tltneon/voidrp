ITEM.Name = "ULTRA-3 Nanosuit Enhanced Exosuit";
ITEM.Class = "clothing_heavy_nanosuit";
ITEM.Description = "Heavy armor, ergonomically made and skin adjusted, gives the usability of heavy armor without hindering mobility";
ITEM.Model = "models/player/slow/nanosuit/slow_nanosuit.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 2000;
ITEM.ItemGroup = 2;
ITEM.Flags = {
	"armor;200"
}

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
