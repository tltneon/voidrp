InventoryTable = {}
local function FindEnumeration( actname )

	for k, v in pairs ( _E ) do
		if(  k == actname ) then
			return tonumber( v );
		end
	end
	
	return -1;
end

function AddItem(data)
	local itemdata = {}
	itemdata.Name = data:ReadString();
	itemdata.Class = data:ReadString();
	itemdata.Description = data:ReadString();
	itemdata.Model = data:ReadString();
	itemdata.Flags = string.Explode( ",", data:ReadString() )
	
	table.insert(InventoryTable, itemdata);
end
usermessage.Hook("addinventory", AddItem);

function ClearItems()
	
	InventoryTable = {}
	
end
usermessage.Hook("clearinventory", ClearItems);

BusinessTable = {};

function AddBusinessItem(data)
	local itemdata = {}
	itemdata.Name = data:ReadString();
	itemdata.Class = data:ReadString();
	itemdata.Description = data:ReadString();
	itemdata.Model = data:ReadString();
	itemdata.Price = data:ReadLong();
	
	table.insert(BusinessTable, itemdata);
end
usermessage.Hook("addbusiness", AddBusinessItem);

function ClearBusinessItems()
	
	BusinessTable = {}
	
end
usermessage.Hook("clearbusiness", ClearBusinessItems);

function InitHiddenButton()
	HiddenButton = vgui.Create("DButton") -- HOLY SHIT WHAT A HACKY METHOD FO SHO
	HiddenButton:SetSize(ScrW(), ScrH());
	HiddenButton:SetText("");
	HiddenButton:SetDrawBackground(false);
	HiddenButton:SetDrawBorder(false);
	HiddenButton.DoRightClick = function()
		local Vect = gui.ScreenToVector(gui.MouseX(), gui.MouseY());
		local tracedata = {};
		tracedata.start = LocalPlayer():GetShootPos();
		tracedata.endpos = LocalPlayer():GetShootPos() + (Vect * 100);
		tracedata.filter = LocalPlayer();
		local trace = util.TraceLine(tracedata);
		
		if(trace.HitNonWorld) then
			local target = trace.Entity;
			
			local ContextMenu = DermaMenu()
				if(CAKE.IsDoor(target)) then
					ContextMenu:AddOption("Rent/Unrent Door", function() LocalPlayer():ConCommand("rp_purchasedoor " .. target:EntIndex()) end);
					ContextMenu:AddOption("Lock", function() LocalPlayer():ConCommand("rp_lockdoor " .. target:EntIndex()) end);
					ContextMenu:AddOption("Unlock", function() LocalPlayer():ConCommand("rp_unlockdoor " .. target:EntIndex()) end);
				elseif(target:GetClass() == "item_prop") then
					ContextMenu:AddOption("Pick Up", function() LocalPlayer():ConCommand("rp_pickup " .. target:EntIndex()) end);
					ContextMenu:AddOption("Use", function() LocalPlayer():ConCommand("rp_useitem " .. target:EntIndex()) end);
				elseif(target:IsPlayer()) then
					local function PopupCredits()
						local CreditPanel = vgui.Create( "DFrame" );
						CreditPanel:SetPos(gui.MouseX(), gui.MouseY());
						CreditPanel:SetSize( 200, 175 )
						CreditPanel:SetTitle( "Give " .. target:Nick() .. " Credits");
						CreditPanel:SetVisible(true);
						CreditPanel:SetDraggable(true);
						CreditPanel:ShowCloseButton(true);
						CreditPanel:MakePopup();
						
						local Credits = vgui.Create( "DNumSlider", CreditPanel );
						Credits:SetPos( 25, 50 );
						Credits:SetWide(150);
						Credits:SetText("Credits to Give");
						Credits:SetMin( 0 );
						Credits:SetMax( tonumber(LocalPlayer():GetNWString("money")) );
						Credits:SetDecimals( 0 );
						
						local Give = vgui.Create( "DButton", CreditPanel );
						Give:SetText("Give");
						Give:SetPos( 25, 125 );
						Give:SetSize( 150, 25 );
						Give.DoClick = function()
							LocalPlayer():ConCommand("rp_givemoney " .. target:EntIndex() .. " " .. Credits:GetValue());
							CreditPanel:Remove();
							CreditPanel = nil;
						end
					end
					
					local function GetInfo()
						LocalPlayer():ConCommand("rp_getcharinfo \"" .. target:Nick() .. "\"")
					end
					
					ContextMenu:AddOption("Give Credits", PopupCredits);
					ContextMenu:AddOption("Get Info", GetInfo );
				end
				
			ContextMenu:Open();
		end
	end
end

InitHiddenButton();

function CreateModelWindow()

	if(ModelWindow) then
	
		ModelWindow:Remove();
		ModelWindow = nil;
		
	end

	ModelWindow = vgui.Create( "DFrame" )
	ModelWindow:SetTitle("Select Model");

	local mdlPanel = vgui.Create( "DModelPanel", ModelWindow )
	mdlPanel:SetSize( 300, 300 )
	mdlPanel:SetPos( 10, 20 )
	mdlPanel:SetModel( models[1] )
	mdlPanel:SetAnimSpeed( 0.0 )
	mdlPanel:SetAnimated( false )
	mdlPanel:SetAmbientLight( Color( 50, 50, 50 ) )
	mdlPanel:SetDirectionalLight( BOX_TOP, Color( 255, 255, 255 ) )
	mdlPanel:SetDirectionalLight( BOX_FRONT, Color( 255, 255, 255 ) )
	mdlPanel:SetCamPos( Vector( 50, 0, 50 ) )
	mdlPanel:SetLookAt( Vector( 0, 0, 50 ) )
	mdlPanel:SetFOV( 70 )

	local RotateSlider = vgui.Create("DNumSlider", ModelWindow);
	RotateSlider:SetMax(360);
	RotateSlider:SetMin(0);
	RotateSlider:SetText("Rotate");
	RotateSlider:SetDecimals( 0 );
	RotateSlider:SetWidth(300);
	RotateSlider:SetPos(10, 290);

	local BodyButton = vgui.Create("DButton", ModelWindow);
	BodyButton:SetText("Body");
	BodyButton.DoClick = function()

		mdlPanel:SetCamPos( Vector( 50, 0, 50) );
		mdlPanel:SetLookAt( Vector( 0, 0, 50) );
		mdlPanel:SetFOV( 70 );
		
	end
	BodyButton:SetPos(10, 40);

	local FaceButton = vgui.Create("DButton", ModelWindow);
	FaceButton:SetText("Face");
	FaceButton.DoClick = function()

		mdlPanel:SetCamPos( Vector( 50, 0, 60) );
		mdlPanel:SetLookAt( Vector( 0, 0, 60) );
		mdlPanel:SetFOV( 40 );
		
	end
	FaceButton:SetPos(10, 60);

	local FarButton = vgui.Create("DButton", ModelWindow);
	FarButton:SetText("Far");
	FarButton.DoClick = function()

		mdlPanel:SetCamPos( Vector( 100, 0, 30) );
		mdlPanel:SetLookAt( Vector( 0, 0, 30) );
		mdlPanel:SetFOV( 70 );
		
	end
	FarButton:SetPos(10, 80);
	
	local OkButton = vgui.Create("DButton", ModelWindow);
	OkButton:SetText("OK");
	OkButton.DoClick = function()

		SetChosenModel(mdlPanel.Entity:GetModel());
		ModelWindow:Remove();
		ModelWindow = nil;
		
	end
	OkButton:SetPos(10, 100);

	function mdlPanel:LayoutEntity(Entity)

		self:RunAnimation();
		Entity:SetAngles( Angle( 0, RotateSlider:GetValue(), 0) )
		
	end

	local i = 1;
	
	local LastMdl = vgui.Create( "DSysButton", ModelWindow )
	LastMdl:SetType("left");
	LastMdl.DoClick = function()

		i = i - 1;
		
		if(i == 0) then
			i = #models;
		end
		
		mdlPanel:SetModel(models[i]);
		
	end

	LastMdl:SetPos(10, 165);

	local NextMdl = vgui.Create( "DSysButton", ModelWindow )
	NextMdl:SetType("right");
	NextMdl.DoClick = function()

		i = i + 1;

		if(i > #models) then
			i = 1;
		end
		
		mdlPanel:SetModel(models[i]);
		
	end
	NextMdl:SetPos( 245, 165);
	
	ModelWindow:SetSize( 320, 330 )
	ModelWindow:Center()	
	ModelWindow:MakePopup()
	ModelWindow:SetKeyboardInputEnabled( false )
	
end

function InitHUDMenu()

	HUDMenu = vgui.Create( "DFrame" )
	HUDMenu:SetPos( ScrW() - 130 - 5, 5 )
	HUDMenu:SetSize( 130, 150 )
	HUDMenu:SetTitle( "Player Information" )
	HUDMenu:SetVisible( true )
	HUDMenu:SetDraggable( false )
	HUDMenu:ShowCloseButton( false )
	
	local label = vgui.Create("DLabel", HUDMenu);
	label:SetWide(0);
	label:SetPos(5, 25);
	label:SetText("Name: " .. LocalPlayer():Nick());
	
	local label3 = vgui.Create("DLabel", HUDMenu);
	label3:SetWide(0);
	label3:SetPos(5, 40);
	label3:SetText("Title: " .. LocalPlayer():GetNWString("title"));
	
	local labelfail = vgui.Create("DLabel", HUDMenu);
	labelfail:SetWide(0);
	labelfail:SetPos(5, 55);
	labelfail:SetText("Title 2: " .. LocalPlayer():GetNWString("title2"));
	
	local label4 = vgui.Create("DLabel", HUDMenu);
	label4:SetWide(0);
	label4:SetPos(5, 70);
	label4:SetText(LocalPlayer():GetNWString("money") .. " Credits");

	local label5 = vgui.Create("DLabel", HUDMenu);
	label5:SetWide(0);
	label5:SetPos(5, 85);
	label5:SetText("");
	
	local spawnicon = vgui.Create( "SpawnIcon", HUDMenu);
	spawnicon:SetSize( 128, 128 );
	spawnicon:SetPos(1,21);
	spawnicon:SetIconSize( 128 )
	spawnicon:SetModel(LocalPlayer():GetModel());
	spawnicon:SetToolTip("Open Player Menu");
	
	local FadeSize = 130;
	
	function UpdateGUIData()
		label:SetText("Name: " .. LocalPlayer():Nick() );
		
		labelfail:SetText("Title 2: " .. LocalPlayer():GetNWString("title2") );
		
		label3:SetText("Title: " .. LocalPlayer():GetNWString("title") );
		
		label4:SetText("Assosciation: " .. team.GetName(LocalPlayer():Team()));

		label5:SetText("");

		spawnicon:SetModel(LocalPlayer():GetModel());
		spawnicon:SetToolTip("OMG LOL IT FADES");
	end
	
	spawnicon.PaintOver = function()
		spawnicon:SetPos(FadeSize - 129, 21);
		HUDMenu:SetSize(FadeSize, 150);
		HUDMenu:SetPos(ScrW() - FadeSize - 5, 5 );
		
		label:SetWide(FadeSize - 128);
		labelfail:SetWide( FadeSize - 128 );
		label3:SetWide(FadeSize - 128);
		label4:SetWide(FadeSize - 128);
		label5:SetWide(FadeSize - 128);
		
		if(FadeSize > 130) then
			FadeSize = FadeSize - 5;
		end
		
		UpdateGUIData();
	end
	
	spawnicon.PaintOverHovered = function()
		
		spawnicon:SetPos(FadeSize - 129, 21);
		HUDMenu:SetSize(FadeSize, 150);
		HUDMenu:SetPos(ScrW() - FadeSize - 5, 5 );
		
		label:SetWide(FadeSize - 128);
		labelfail:SetWide( FadeSize - 128 );
		label3:SetWide(FadeSize - 128);
		label4:SetWide(FadeSize - 128);
		label5:SetWide(FadeSize - 128);
		
		if(FadeSize < 320) then
			FadeSize = FadeSize + 5;
		end
		
		UpdateGUIData();
	end
end

function CreatePlayerMenu()
	if(PlayerMenu) then
		PlayerMenu:Remove();
		PlayerMenu = nil;
	end
	
	PlayerMenu = vgui.Create( "DFrame" )
	PlayerMenu:SetPos( ScrW() / 2 - 320, ScrH() / 2 - 240 )
	PlayerMenu:SetSize( 640, 480 )
	PlayerMenu:SetTitle( "Player Menu" )
	PlayerMenu:SetVisible( true )
	PlayerMenu:SetDraggable( true )
	PlayerMenu:ShowCloseButton( true )
	PlayerMenu:MakePopup()
	
	PropertySheet = vgui.Create( "DPropertySheet" )
	PropertySheet:SetParent(PlayerMenu)
	PropertySheet:SetPos( 2, 30 )
	PropertySheet:SetSize( 636, 448 )
	
	local PlayerInfo = vgui.Create( "DPanelList" )
	PlayerInfo:SetPadding(20);
	PlayerInfo:SetSpacing(20);
	PlayerInfo:EnableHorizontal(false);
	
	local icdata = vgui.Create( "DForm" );
	icdata:SetPadding(4);
	icdata:SetName(LocalPlayer():Nick() or "");
	
	local FullData = vgui.Create("DPanelList");
	FullData:SetSize(0, 84);
	FullData:SetPadding(10);
	
	local DataList = vgui.Create("DPanelList");
	DataList:SetSize(0, 64);
	
	local spawnicon = vgui.Create( "SpawnIcon");
	spawnicon:SetModel(LocalPlayer():GetNWString( "model" ));
	spawnicon:SetSize( 64, 64 );
	DataList:AddItem(spawnicon);
	
	local DataList2 = vgui.Create( "DPanelList" )
	
	local label2 = vgui.Create("DLabel");
	label2:SetText("Title: " .. LocalPlayer():GetNWString("title"));
	DataList2:AddItem(label2);
	
	local labelfail = vgui.Create("DLabel");
	labelfail:SetText("Title 2: " .. LocalPlayer():GetNWString("title2"));
	DataList2:AddItem(labelfail);
	
	local label3 = vgui.Create("DLabel");
	label3:SetText(LocalPlayer():GetNWString("money") .. " Credits.");
	DataList2:AddItem(label3);

	local Divider = vgui.Create("DHorizontalDivider");
	Divider:SetLeft(spawnicon);
	Divider:SetRight(DataList2);
	Divider:SetLeftWidth(64);
	Divider:SetHeight(64);
	
	DataList:AddItem(spawnicon);
	DataList:AddItem(DataList2);
	DataList:AddItem(Divider);

	FullData:AddItem(DataList)
	
	icdata:AddItem(FullData)
	
	local vitals = vgui.Create( "DForm" );
	vitals:SetPadding(4);
	vitals:SetName("Character Details");
	
	local VitalData = vgui.Create("DPanelList");
	VitalData:SetAutoSize(true)
	VitalData:SetPadding(10);
	vitals:AddItem(VitalData);
	
	local radio = vgui.Create("DLabel");
	radio:SetText( "Enter your desired radio frequency:" )
	VitalData:AddItem( radio )
	
	local freq = vgui.Create("DTextEntry");
	VitalData:AddItem(freq);
	freq:SetMultiline( false )
	freq:SetText( tostring( LocalPlayer():GetNWFloat( "frequency", 0 ) ) );
	
	local freqset = vgui.Create("DButton");
	freqset:SetText("Click to set your frequency");
	freqset.DoClick = function( btn )
		LocalPlayer():ConCommand("rp_setfrequency \"" .. freq:GetValue() .. "\"" )
	end
	VitalData:AddItem(freqset);
	
	local fetchinfo = vgui.Create("DButton");
	fetchinfo:SetText("Click to fetch your information");
	fetchinfo.DoClick = function( btn )
		LocalPlayer():ConCommand("rp_getcharinfo \"" .. LocalPlayer():Nick() .. "\"" )
	end
	VitalData:AddItem(fetchinfo);
	
	PlayerInfo:AddItem(icdata)
	PlayerInfo:AddItem(vitals)
	
	CharPanel = vgui.Create( "DPanelList" )
	CharPanel:SetPadding(20);
	CharPanel:SetSpacing(10);
	CharPanel:EnableVerticalScrollbar();
	CharPanel:EnableHorizontal(false);
	
	local label = vgui.Create("DLabel");
	label:SetText("Click your character to select it");
	CharPanel:AddItem(label);
	
	/*charlist = vgui.Create( "DPanelList" )
	charlist:SetPadding(20);
	charlist:SetSpacing(10);
	charlist:EnableHorizontal(false);
	CharPanel:AddItem( charlist )*/
	
	local widthnshit = 600
	local numberofchars = table.getn( ExistingChars )
	local modelnumber = {}
	
	local function AddCharacterModel( n, model )
		
		local mdlpanel = modelnumber[n]
		
		mdlpanel = vgui.Create( "DModelPanel" )
		mdlpanel:SetSize( 200, 180 )
		mdlpanel:SetModel( model )
		mdlpanel:SetAnimSpeed( 0.0 )
		mdlpanel:SetAnimated( false )
		mdlpanel:SetAmbientLight( Color( 50, 50, 50 ) )
		mdlpanel:SetDirectionalLight( BOX_TOP, Color( 255, 255, 255 ) )
		mdlpanel:SetDirectionalLight( BOX_FRONT, Color( 255, 255, 255 ) )
		mdlpanel:SetCamPos( Vector( 100, 0, 40 ) )
		mdlpanel:SetLookAt( Vector( 0, 0, 40 ) )
		mdlpanel:SetFOV( 70 )

		mdlpanel.PaintOver = function()
			surface.SetTextColor(Color(255,255,255,255));
			surface.SetFont("Trebuchet18");
			surface.SetTextPos((180 - surface.GetTextSize(ExistingChars[n]['name'])) / 2 , 0);
			surface.DrawText(ExistingChars[n]['name'])
		end
		
		function mdlpanel:OnMousePressed()
			local Options = DermaMenu()
			Options:AddOption("Select Character", function() 
				LocalPlayer():ConCommand("rp_selectchar " .. n);
				LocalPlayer().MyModel = ""
			
				PlayerMenu:Remove();
				PlayerMenu = nil;
			end )
			Options:AddOption("Delete Character", function() 
				LocalPlayer():ConCommand("rp_confirmremoval " .. n);
				PlayerMenu:Remove();
				PlayerMenu = nil;
			end )
			Options:Open()
		end

		function mdlpanel:LayoutEntity(Entity)

			self:RunAnimation();
			
		end
		function InitAnim()
		
			if(mdlpanel.Entity) then		
				local iSeq = mdlpanel.Entity:LookupSequence( "idle_angry" );
				mdlpanel.Entity:ResetSequence(iSeq);
			
			end
			
		end
		
		InitAnim()
		CharPanel:AddItem(mdlpanel);
	
	end
	
	
	for k, v in pairs(ExistingChars) do
		AddCharacterModel( k, v['model'] )
		
	end
	
	local newchar = vgui.Create("DButton");
	newchar:SetSize(100, 25);
	newchar:SetText("New Character");
	newchar.DoClick = function ( btn )
		NewCharacterMenu()
		PlayerMenu:Remove();
		PlayerMenu = nil;
	end
	CharPanel:AddItem( newchar )
	
	/*Commands = vgui.Create( "DPanelList" )
	Commands:SetPadding(20);
	Commands:SetSpacing(20);
	Commands:EnableHorizontal(true);
	Commands:EnableVerticalScrollbar(true);
	
	local Flags = vgui.Create("DListView");
	Flags:SetSize(550,446);
	Flags:SetMultiSelect(false)
	Flags:AddColumn("Flag Name");
	Flags:AddColumn("Salary");
	Flags:AddColumn("Business Access");
	Flags:AddColumn("Public Flag?");
	Flags:AddColumn("Flag Key");
	
	function Flags:DoDoubleClick(LineID, Line)
	
		LocalPlayer():ConCommand("rp_flag " .. TeamTable[LineID].flagkey);
		PlayerMenu:Remove();
		PlayerMenu = nil;
		
	end
	
	for k, v in pairs(TeamTable) do
		local yesno = "";
		if(v.public) then
			yesno = "Yes";
		elseif(!v.public) then
			yesno = "No";
		end
		
		local yesno2 = "";
		if(v.business) then
			yesno2 = "Yes";
		elseif(!v.business) then
			yesno2 = "No";
		end
		
		Flags:AddLine(v.name, tostring(v.salary), yesno2, yesno, v.flagkey);
	end
	
	Commands:AddItem(Flags);*/
	
	Inventory = vgui.Create( "DPanelList" )
	Inventory:SetPadding(20);
	Inventory:SetSpacing(20);
	Inventory:EnableHorizontal(true);
	Inventory:EnableVerticalScrollbar(true);
	
	for k, v in pairs(InventoryTable) do
		local spawnicon = vgui.Create( "SpawnIcon");
		spawnicon:SetSize( 128, 128 );
		spawnicon:SetIconSize( 128 )
		spawnicon:SetModel(v.Model);
		spawnicon:SetToolTip(v.Description);
		
		local function DeleteMyself()
			spawnicon:Remove()
		end
		
		spawnicon.DoClick = function ( btn )
		
			local ContextMenu = DermaMenu()
				ContextMenu:AddOption("Drop", function() LocalPlayer():ConCommand("rp_dropitem " .. v.Class); DeleteMyself(); end);
			ContextMenu:Open();
			
		end
		
		spawnicon.PaintOver = function()
			surface.SetTextColor(Color(255,255,255,255));
			surface.SetFont("DefaultSmall");
			surface.SetTextPos(64 - surface.GetTextSize(v.Name) / 2, 5);
			surface.DrawText(v.Name)
		end
		
		spawnicon.PaintOverHovered = function()
			surface.SetTextColor(Color(255,255,255,255));
			surface.SetFont("DefaultSmall");
			surface.SetTextPos(64 - surface.GetTextSize(v.Name) / 2, 5);
			surface.DrawText(v.Name)
		end
		
		Inventory:AddItem(spawnicon);
	end
	
	Clothing = vgui.Create( "DPanelList" )
	Clothing:SetPadding(20);
	Clothing:SetSpacing(20);
	Clothing:EnableHorizontal(false);
	Clothing:EnableVerticalScrollbar(true);
	local ClothingBox = vgui.Create("DListView");
	ClothingBox:SetMultiSelect( false )
	ClothingBox:SetSize(550,150);
	ClothingBox:AddColumn("Item Name");
	ClothingBox:AddColumn("Item Class");
	ClothingBox:AddLine( "Default Clothes", "none" )
	for k, v in pairs( InventoryTable ) do
		if( string.match( v.Class, "clothing" ) ) then
			ClothingBox:AddLine( v.Name, v.Class )
		end
	end
	Clothing:AddItem( ClothingBox )
	local Helmets = vgui.Create("DListView");
	Helmets:SetMultiSelect( false )
	Helmets:SetSize( 550, 150 )
	Helmets:AddColumn( "Item Name" )
	Helmets:AddColumn( "Item Class" )
	Helmets:AddLine( "Default Helmet/Face", "none" )
	for k, v in pairs( InventoryTable ) do
		if( string.match( v.Class, "helmet" ) ) then
			Helmets:AddLine( v.Name, v.Class )
		end
	end
	Clothing:AddItem( Helmets )
	local applyclothes = vgui.Create("DButton");
	applyclothes:SetSize(100, 25);
	applyclothes:SetText("Apply");
	applyclothes.DoClick = function ( btn )
		if #ClothingBox:GetSelected() > 0 and #Helmets:GetSelected() > 0 then
			LocalPlayer():ConCommand( "rp_setclothing \"" .. ClothingBox:GetSelected()[1]:GetValue( 2 ) .. "\" \"" .. Helmets:GetSelected()[1]:GetValue( 2 ) .. "\"" )
		end
	end
	Clothing:AddItem( applyclothes )
	
	if(TeamTable[LocalPlayer():Team()] != nil) then
		if(LocalPlayer():GetNWBool( "usesbusiness", false)) then
			Business = vgui.Create( "DPanelList" )
			Business:SetPadding(20);
			Business:SetSpacing(20);
			Business:EnableHorizontal(true);
			Business:EnableVerticalScrollbar(true);
			for k, v in pairs(BusinessTable) do
				local spawnicon = vgui.Create( "SpawnIcon");
				spawnicon:SetSize( 128, 128 );
				spawnicon:SetIconSize( 128 )
				spawnicon:SetModel(v.Model);
				spawnicon:SetToolTip(v.Description);
				
				spawnicon.DoClick = function ( btn )
				
					local ContextMenu = DermaMenu()
						if(tonumber(LocalPlayer():GetNWString("money")) >= v.Price) then
							ContextMenu:AddOption("Purchase", function() LocalPlayer():ConCommand("rp_buyitem " .. v.Class); end);
						else
							ContextMenu:AddOption("Not Enough Tokens!");
						end
					ContextMenu:Open();
					
				end
				
				spawnicon.PaintOver = function()
					surface.SetTextColor(Color(255,255,255,255));
					surface.SetFont("DefaultSmall");
					surface.SetTextPos(64 - surface.GetTextSize(v.Name .. " (" .. v.Price .. ")") / 2, 5);
					surface.DrawText(v.Name .. " (" .. v.Price .. ")")
				end
				
				spawnicon.PaintOverHovered = function()
					surface.SetTextColor(Color(255,255,255,255));
					surface.SetFont("DefaultSmall");
					surface.SetTextPos(64 - surface.GetTextSize(v.Name .. " (" .. v.Price .. ")") / 2, 5);
					surface.DrawText(v.Name .. " (" .. v.Price .. ")")
				end
				
				Business:AddItem(spawnicon);
			end
		end
	end
	
	Scoreboard = vgui.Create( "DPanelList" )
	Scoreboard:SetPadding(0);
	Scoreboard:SetSpacing(0);

	-- Let's draw the SCOREBOARD.
	
	for k, v in pairs(player.GetAll()) do
		local DataList = vgui.Create("DPanelList");
		DataList:SetAutoSize( true )
		
		local CollapsableCategory = vgui.Create("DCollapsibleCategory");
		CollapsableCategory:SetExpanded( 0 )
		CollapsableCategory:SetLabel( v:Nick() );
		Scoreboard:AddItem(CollapsableCategory);
		
		local spawnicon = vgui.Create( "SpawnIcon");
		spawnicon:SetModel(v:GetNWString( "model" ));
		spawnicon:SetSize( 64, 64 );
		DataList:AddItem(spawnicon);
		
		local DataList2 = vgui.Create( "DPanelList" )
		DataList2:SetAutoSize( true )
		
		local label = vgui.Create("DLabel");
		label:SetText("OOC Name: " .. v:GetNWString( "oocname" ));
		DataList2:AddItem(label);
		
		local label2 = vgui.Create("DLabel");
		label2:SetText("Title: " .. v:GetNWString("title"));
		DataList2:AddItem(label2);
		
		local labelfail = vgui.Create("DLabel");
		labelfail:SetText("Title 2: " .. v:GetNWString("title2"));
		DataList2:AddItem(labelfail);
		
		local Divider = vgui.Create("DHorizontalDivider");
		Divider:SetLeft(spawnicon);
		Divider:SetRight(DataList2);
		Divider:SetLeftWidth(64);
		Divider:SetHeight(64);
		
		DataList:AddItem(spawnicon);
		DataList:AddItem(DataList2);
		DataList:AddItem(Divider);
		
		CollapsableCategory:SetContents(DataList);
	end

	local Help = vgui.Create( "DPanelList" )
	Help:SetPadding(20);
	Help:EnableHorizontal(false);
	Help:EnableVerticalScrollbar(true);
	local html = vgui.Create( "HTML")
	html:SetPos(0,30)
	html:SetSize(256, 370)
	html:OpenURL( "http://voidrp.ucoz.com/" )
	Help:AddItem( html )
	local Options = vgui.Create( "DPanelList" )
	Options:SetPadding( 20 )
	Options:EnableHorizontal( false);
	Options:EnableVerticalScrollbar(true)
	local testlabel = vgui.Create( "DLabel" )
	testlabel:SetText( "Test" )
	local red = vgui.Create("DNumSlider");
	red:SetMin( 0 )
	red:SetMax( 255 )
	red:SetDecimals( 0 )
	red:SetSize( 50, 50 )
	red:SetText( "Red" )
	red:SetConVar( "oocred" )
	Options:AddItem( red )
	local blue = vgui.Create("DNumSlider");
	blue:SetMin( 0 )
	blue:SetMax( 255 )
	blue:SetDecimals( 0 )
	blue:SetSize( 50, 50 )
	blue:SetText( "Green" )
	blue:SetConVar( "oocblue" )
	Options:AddItem( blue )
	local green = vgui.Create("DNumSlider");
	green:SetMin( 0 )
	green:SetMax( 255 )
	green:SetDecimals( 0 )
	green:SetSize( 50, 50 )
	green:SetText( "Blue" )
	green:SetConVar( "oocgreen" )
	Options:AddItem( green )
	local alpha = vgui.Create("DNumSlider");
	alpha:SetMin( 0 )
	alpha:SetMax( 255 )
	alpha:SetDecimals( 0 )
	alpha:SetSize( 50, 55 )
	alpha:SetText( "Alpha" )
	alpha:SetConVar( "oocalpha" )
	--Unsightly, but still.
	alpha.OnValueChanged = function()
		testlabel:SetTextColor( Color( red:GetValue(), blue:GetValue(), green:GetValue(), alpha:GetValue() ) )
	end
	red.OnValueChanged = function()
		testlabel:SetTextColor( Color( red:GetValue(), blue:GetValue(), green:GetValue(), alpha:GetValue() ) )
	end
	green.OnValueChanged = function()
		testlabel:SetTextColor( Color( red:GetValue(), blue:GetValue(), green:GetValue(), alpha:GetValue() ) )
	end
	
	blue.OnValueChanged = function()
		testlabel:SetTextColor( Color( red:GetValue(), blue:GetValue(), green:GetValue(), alpha:GetValue() ) )
	end
	
	Options:AddItem( alpha )
	Options:AddItem( testlabel )
	local refresh = vgui.Create("DButton");
	refresh:SetSize(100, 25);
	refresh:SetPos( 65, 10 )
	refresh:SetText("Set Color");
	refresh.DoClick = function ( btn )
	RunConsoleCommand( "oocred", tostring( red:GetValue() ) )
	RunConsoleCommand( "oocblue", tostring( blue:GetValue() ) )
	RunConsoleCommand( "oocgreen", tostring( green:GetValue() ) )
	RunConsoleCommand( "oocalpha", tostring( alpha:GetValue() ) )
	LocalPlayer():ConCommand("rp_oocred " .. tonumber( LocalPlayer():GetInfo( "oocred" ) ));
	LocalPlayer():ConCommand("rp_oocblue " .. tonumber( LocalPlayer():GetInfo( "oocblue" ) ));
	LocalPlayer():ConCommand("rp_oocgreen " .. tonumber( LocalPlayer():GetInfo( "oocgreen" ) ));
	LocalPlayer():ConCommand("rp_oocalpha " .. tonumber( LocalPlayer():GetInfo( "oocalpha" ) ));
	end
	Options:AddItem( refresh )
	local facetoggle = vgui.Create( "DCheckBoxLabel" )
	facetoggle:SetText( "Toggle Picture in HUD ( Needs reconnect )" )
	facetoggle:SetConVar( "facetoggle" )
	Options:AddItem( facetoggle )
	local titletoggle = vgui.Create( "DCheckBoxLabel" )
	titletoggle:SetText( "Toggle Title bar in HUD" )
	titletoggle:SetConVar( "titletoggle" )
	Options:AddItem( titletoggle )
	local timetoggle = vgui.Create( "DCheckBoxLabel" )
	timetoggle:SetText( "Toggle time in HUD" )
	timetoggle:SetConVar( "timetoggle" )
	Options:AddItem( timetoggle )
	local ooctoggle = vgui.Create( "DCheckBoxLabel" )
	ooctoggle:SetText( "Toggle OOC" )
	ooctoggle:SetConVar( "ooctoggle" )
	Options:AddItem( ooctoggle )
	/*local function AddHelpLine(text)
			local label = vgui.Create("DLabel");
			label:SetText(text);
			label:SizeToContents();
			Help:AddItem(label);
	end
	
	local lines = {
	"Welcome to CakeScript G2, the revolution of Garry's Mod RP.",
	"To interact with players, items or doors, hold TAB then right-click whatever you want to interact with.",
	"You can purchase doors, give players money, pick up items, and other things from this menu."
	}

	for k, v in pairs(lines) do
		AddHelpLine(v);
	end*/
	
	PropertySheet:AddSheet( "Player Menu", PlayerInfo, "gui/silkicons/user", false, false, "General information.");
	PropertySheet:AddSheet( "Character Menu", CharPanel, "gui/silkicons/group", false, false, "Switch to another character or create a new one.");
	//PropertySheet:AddSheet( "Commands/Flagging", Commands, "gui/silkicons/wrench", false, false, "Execute some common commands or set your flag.");
	PropertySheet:AddSheet( "Backpack", Inventory, "gui/silkicons/box", false, false, "View your inventory.")
	PropertySheet:AddSheet( "Business", Business, "gui/silkicons/box", false, false, "Purchase items.");
	PropertySheet:AddSheet( "Clothing", Clothing, "gui/silkicons/anchor", false, false, "Change your clothes." )
	PropertySheet:AddSheet( "Scoreboard", Scoreboard, "gui/silkicons/application_view_detail", false, false, "View the scoreboard.");		
	PropertySheet:AddSheet( "Help", Help, "gui/silkicons/magnifier", false, false, "Get some help with CakeScript!");
	PropertySheet:AddSheet( "Options", Options, "gui/silkicons/wrench", false, false, "Set your account options");
	
end
usermessage.Hook("playermenu", CreatePlayerMenu);