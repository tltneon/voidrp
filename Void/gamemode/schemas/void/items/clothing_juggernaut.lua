ITEM.Name = "'Juggernaut' Combat Exosuit";
ITEM.Class = "clothing_heavy_juggernaut";
ITEM.Description = "Heavy armor, made for today's needs";
ITEM.Model = "models/mw2guy/riot/juggernaut.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 2000;
ITEM.ItemGroup = 2;
ITEM.Flags = {
	"armor;250"
}
function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
