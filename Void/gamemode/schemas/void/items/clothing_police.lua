ITEM.Name = "EV-5 Exosuit";
ITEM.Class = "clothing_police";
ITEM.Description = "Allows you to safely enter space, also provides partial armor";
ITEM.Model = "models/Police.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 500;
ITEM.ItemGroup = 2;
ITEM.Flags = {
	"armor;70"
}
function ITEM:Drop(ply)
	
end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
