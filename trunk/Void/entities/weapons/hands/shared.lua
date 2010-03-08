if (SERVER) then
	AddCSLuaFile( "shared.lua" )
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
end

if ( CLIENT ) then
	SWEP.PrintName      = "Hands"
	SWEP.Author    = "LuaBanana"
	SWEP.Contact    = ""
	SWEP.DrawAmmo			= false
	SWEP.DrawCrosshair		= false
	SWEP.ViewModelFOV		= 70
	SWEP.ViewModelFlip		= false
	SWEP.CSMuzzleFlashes	= false
end
 
SWEP.Spawnable      = true
SWEP.AdminSpawnable  = true
 
SWEP.ViewModel      = ""
SWEP.WorldModel   = ""
 
SWEP.Primary.ClipSize      = 1
SWEP.Primary.DefaultClip    = 1
SWEP.Primary.Automatic    = false

SWEP.Secondary.ClipSize      = 0
SWEP.Secondary.DefaultClip    = 0

function SWEP:Reload()
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

function SWEP:Think()
end

function SWEP:Initialize()
	if (CLIENT) then return end
	self:SetWeaponHoldType("normal")
end 