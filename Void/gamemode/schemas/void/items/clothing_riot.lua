ITEM.Name = "'Riot' Combat Exosuit";
ITEM.Class = "clothing_medium_riot";
ITEM.Description = "Versatile medium armor, made for today's needs";
ITEM.Model = "models/mw2guy/riot/riot_ru.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 1250;
ITEM.ItemGroup = 2;
ITEM.Flags = {
	"armor;150"
}
function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
