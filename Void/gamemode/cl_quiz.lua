--Again, Big Bang's (Kamaitama) code. Nothing stolen from anywhere.

function CreateQuiz( um )

--[[
	
	gui.EnableScreenClicker( true );
	
    local quiz = vgui.Create( "DFrame" )
    quiz:SetPos( ScrW() / 2 - 270, ScrH() / 2 - 340 )
	quiz:SetSize( 450, 700 )
	quiz:SetTitle( "Answer to continue ( Choose 1, not multiple choice )" )
    quiz:ShowCloseButton( false )
    
    quizpanel = vgui.Create( "DPanel", quiz )
    quizpanel:SetPos( 2, 23 )
    quizpanel:SetSize( 446, 675 )
    quizpanel.Paint = function()
        surface.SetDrawColor( 50, 50, 50, 255 )
        surface.DrawRect( 0, 0, quizpanel:GetWide(), quizpanel:GetTall() )
    end
    
    question1 = vgui.Create( "DForm", quizpanel )
    question1:SetName( "What's the name of this RP server?" )
    question1:SetPos( 10, 10 )
    question1:SetSize( 426, 200 )
    question1:SetSpacing( 5 )
    question1:SetPadding( 10 )
    
    option1 = vgui.Create( "DCheckBoxLabel" )
    option1:SetText( "VoidRP" )
    question1:AddItem( option1 )
	
	option12 = vgui.Create( "DCheckBoxLabel" )
	option12:SetText( "TnB" )
	question1:AddItem( option12 )
    
    option13 = vgui.Create( "DCheckBoxLabel" )
    option13:SetText( "Real Life RP" )
    question1:AddItem( option13 )
    
    option14 = vgui.Create( "DCheckBoxLabel" )
    option14:SetText( "EvilRP" )
    question1:AddItem( option14 )
    
    question2 = vgui.Create( "DForm", quizpanel )
    question2:SetPos( 10, 140 )
    question2:SetName( "What is metagame?" )
    question2:SetSize( 426, 300 )
    question2:SetSpacing( 5 )
    question2:SetPadding( 10 )
    
    option21 = vgui.Create( "DCheckBoxLabel" )
    option21:SetText( "Playing another game while roleplaying" )
    question2:AddItem( option21 )
    
    option22 = vgui.Create( "DCheckBoxLabel" )
    option22:SetText( "Killing cops as a gangster" )
    question2:AddItem( option22 )
    
    option2 = vgui.Create( "DCheckBoxLabel" )
    option2:SetText( "Taking IC knowledge OOC" )
    question2:AddItem( option2 )
    
    question3 = vgui.Create( "DForm", quizpanel )
    question3:SetPos( 10, 250 )
    question3:SetName( "How do you acquire guns on this RP?" )
    question3:SetSize( 426, 300 )
    question3:SetSpacing( 5 )
    question3:SetPadding( 10 )
    
    option31 = vgui.Create( "DCheckBoxLabel" )
    option31:SetText( "From the rebels or the CPs" )
    question3:AddItem( option31 )
    
    option3 = vgui.Create( "DCheckBoxLabel" )
    option3:SetText( "You are given them when properly needed" )
    question3:AddItem( option3 )
    
    option32 = vgui.Create( "DCheckBoxLabel" )
    option32:SetText( "From the gun dealer" )
    question3:AddItem( option32 )
    
    question4 = vgui.Create( "DForm", quizpanel )
    question4:SetPos( 10, 360 )
    question4:SetName( "How do you score points on this RP?" )
    question4:SetSize( 426, 300 )
    question4:SetSpacing( 5 )
    question4:SetPadding( 10 )
    
    option41 = vgui.Create( "DCheckBoxLabel" )
    option41:SetText( "By getting a job" )
    question4:AddItem( option41 )
    
    option42 = vgui.Create( "DCheckBoxLabel" )
    option42:SetText( "By selling stuff" )
    question4:AddItem( option42 )
    
    option4 = vgui.Create( "DCheckBoxLabel" )
    option4:SetText( "You don't" )
    question4:AddItem( option4 )
    
    question5 = vgui.Create( "DForm", quizpanel )
    question5:SetPos( 10, 470 )
    question5:SetName( "What's the genre of this RP?" )
    question5:SetSize( 426, 100 )
    question5:SetSpacing( 5 )
    question5:SetPadding( 10 )
    
    option51 = vgui.Create( "DCheckBoxLabel" )
    option51:SetText( "Half Life 2 RP" )
    question5:AddItem( option51 )
    
    option5 = vgui.Create( "DCheckBoxLabel" )
    option5:SetText( "Space Based RP" )
    question5:AddItem( option5 )
    
    option52 = vgui.Create( "DCheckBoxLabel" )
    option52:SetText( "Medieval RP" )
    question5:AddItem( option52 )  
    
    option53 = vgui.Create( "DCheckBoxLabel" )
    option53:SetText( "Real Life RP" )
    question5:AddItem( option53 )
    
    closebutton = vgui.Create( "DButton", quizpanel )
    closebutton:SetSize( 200, 50 )
    closebutton:SetText( "Submit Answers" )
    closebutton:SetPos( 125, 600 )
    closebutton.DoClick = function ( btn )
	
        if( option1:GetChecked(true) and option2:GetChecked(true) and option3:GetChecked(true) and option4:GetChecked(true) and option5:GetChecked(true) )then
        
			LocalPlayer():ConCommand( "rp_testpass" )
            
        else
        
			LocalPlayer():ConCommand( "rp_testfail" )
        
        end
		
		quizpanel:Remove()
		quizpanel = nil
        quiz:Remove();
        quiz = nil;
		
    end
    
end]]--
end
usermessage.Hook( "CreateQuiz", CreateQuiz );

/*function DoQuiz( )
	
	gui.EnableScreenClicker( true );
	
    local quiz = vgui.Create( "DFrame" )
    quiz:SetPos( ScrW() / 2 - 270, ScrH() / 2 - 340 )
	quiz:SetSize( 450, 700 )
	quiz:SetTitle( "Answer to continue ( Choose 1, not multiple choice )" )
    quiz:ShowCloseButton( false )
    
    quizpanel = vgui.Create( "DPanel", quiz )
    quizpanel:SetPos( 2, 23 )
    quizpanel:SetSize( 446, 675 )
    quizpanel.Paint = function()
        surface.SetDrawColor( 50, 50, 50, 255 )
        surface.DrawRect( 0, 0, quizpanel:GetWide(), quizpanel:GetTall() )
    end
    
    question1 = vgui.Create( "DForm", quizpanel )
    question1:SetName( "What's the name of the City this RP takes place?" )
    question1:SetPos( 10, 10 )
    question1:SetSize( 426, 200 )
    question1:SetSpacing( 5 )
    question1:SetPadding( 10 )
    
    option1 = vgui.Create( "DCheckBoxLabel" )
    option1:SetText( "Surna" )
    question1:AddItem( option1 )
	
	option12 = vgui.Create( "DCheckBoxLabel" )
	option12:SetText( "Thereon" )
	question1:AddItem( option12 )
    
    option13 = vgui.Create( "DCheckBoxLabel" )
    option13:SetText( "City 45" )
    question1:AddItem( option13 )
    
    option14 = vgui.Create( "DCheckBoxLabel" )
    option14:SetText( "Washington" )
    question1:AddItem( option14 )
    
    question2 = vgui.Create( "DForm", quizpanel )
    question2:SetPos( 10, 140 )
    question2:SetName( "What is metagame?" )
    question2:SetSize( 426, 300 )
    question2:SetSpacing( 5 )
    question2:SetPadding( 10 )
    
    option21 = vgui.Create( "DCheckBoxLabel" )
    option21:SetText( "Playing another game while roleplaying" )
    question2:AddItem( option21 )
    
    option22 = vgui.Create( "DCheckBoxLabel" )
    option22:SetText( "Killing cops as a gangster" )
    question2:AddItem( option22 )
    
    option2 = vgui.Create( "DCheckBoxLabel" )
    option2:SetText( "Taking IC knowledge OOC" )
    question2:AddItem( option2 )
    
    question3 = vgui.Create( "DForm", quizpanel )
    question3:SetPos( 10, 250 )
    question3:SetName( "How do you acquire guns on this RP?" )
    question3:SetSize( 426, 300 )
    question3:SetSpacing( 5 )
    question3:SetPadding( 10 )
    
    option31 = vgui.Create( "DCheckBoxLabel" )
    option31:SetText( "From the rebels or the CPs" )
    question3:AddItem( option31 )
    
    option3 = vgui.Create( "DCheckBoxLabel" )
    option3:SetText( "You don't" )
    question3:AddItem( option3 )
    
    option32 = vgui.Create( "DCheckBoxLabel" )
    option32:SetText( "From the gun dealer" )
    question3:AddItem( option32 )
    
    question4 = vgui.Create( "DForm", quizpanel )
    question4:SetPos( 10, 360 )
    question4:SetName( "How do you win money on this RP?" )
    question4:SetSize( 426, 300 )
    question4:SetSpacing( 5 )
    question4:SetPadding( 10 )
    
    option41 = vgui.Create( "DCheckBoxLabel" )
    option41:SetText( "By getting a job" )
    question4:AddItem( option41 )
    
    option42 = vgui.Create( "DCheckBoxLabel" )
    option42:SetText( "By selling stuff" )
    question4:AddItem( option42 )
    
    option4 = vgui.Create( "DCheckBoxLabel" )
    option4:SetText( "You don't" )
    question4:AddItem( option4 )
    
    question5 = vgui.Create( "DForm", quizpanel )
    question5:SetPos( 10, 470 )
    question5:SetName( "What's the genre of this RP?" )
    question5:SetSize( 426, 100 )
    question5:SetSpacing( 5 )
    question5:SetPadding( 10 )
    
    option51 = vgui.Create( "DCheckBoxLabel" )
    option51:SetText( "Half Life 2 RP" )
    question5:AddItem( option51 )
    
    option5 = vgui.Create( "DCheckBoxLabel" )
    option5:SetText( "Fantasy RP" )
    question5:AddItem( option5 )
    
    option52 = vgui.Create( "DCheckBoxLabel" )
    option52:SetText( "Medieval RP" )
    question5:AddItem( option52 )  
    
    option53 = vgui.Create( "DCheckBoxLabel" )
    option53:SetText( "Real Life RP" )
    question5:AddItem( option53 )
    
    closebutton = vgui.Create( "DButton", quizpanel )
    closebutton:SetSize( 200, 50 )
    closebutton:SetText( "Submit Answers" )
    closebutton:SetPos( 125, 600 )
    closebutton.DoClick = function ( btn )
	
        if( option1:GetChecked(true) and option2:GetChecked(true) and option3:GetChecked(true) and option4:GetChecked(true) and option5:GetChecked(true) )then
        
            chat:AddText( Color( 0, 255, 0, 255 ), "You passed the test!" )
			
			CreatePlayerMenu( )
			PlayerMenu:ShowCloseButton( false )
			PropertySheet:SetActiveTab( PropertySheet.Items[ 2 ].Tab );
			PropertySheet.SetActiveTab = function( ) end;
	
				if( LocalPlayer():GetInfo( "facetoggle" ) == "1" ) then
					InitHUDMenu( );
				end
			
			gui.EnableScreenClicker( false );
            
        else
        
            chat:AddText( Color( 255, 0, 0, 255 ), "You didn't pass the test." )
			LocalPlayer():ConCommand( "rp_testfail" )
        
        end
		
        quiz:Remove();
        quiz = nil;
		
    end
    
end
*/