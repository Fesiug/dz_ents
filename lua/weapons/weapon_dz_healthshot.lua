AddCSLuaFile()

game.AddAmmoType({
    name = "dz_healthshot",
    maxcarry = "dzents_healthshot_maxammo", -- woah, cool feature! doesn't fucking work because nobody sets gmod_maxammo!
})
if CLIENT then
    language.Add("dz_healthshot_ammo", "Medi-Shots")
end

SWEP.PrintName = "Medi-Shot"
SWEP.Slot = 5
SWEP.Weight = 150

SWEP.Author = "8Z"
SWEP.Purpose = "Restores a portion of your health and provides a brief speed boost."
SWEP.Instructions = "Primary Attack: Inject\nReload: Drop"

SWEP.Base = "weapon_base_dz"
DEFINE_BASECLASS(SWEP.Base)

SWEP.Category = "CS:GO Equipment"
SWEP.Spawnable = true

SWEP.SubCategory = "Equipment"
SWEP.SortOrder = 1

SWEP.ViewModel = "models/weapons/dz_ents/c_eq_healthshot.mdl"
SWEP.WorldModel = "models/weapons/dz_ents/w_eq_healthshot.mdl"
SWEP.ViewModelFOV = 68
SWEP.UseHands = true

SWEP.WepSelectIcon = Material("dz_ents/select/healthshot.png", "smooth")
SWEP.WepSelectIconRatio = 0.75

SWEP.AmmoType = "dz_healthshot"

SWEP.Primary.Ammo = "dz_healthshot"
SWEP.Primary.DefaultClip = 1

SWEP.HoldType = "normal"

function SWEP:SetupDataTables()
    if BaseClass.SetupDataTables then
        BaseClass.SetupDataTables(self)
    end
    if not self.GetWeaponIdleTime then
        self:NetworkVar("Float", 1, "WeaponIdleTime")
    end
    self:NetworkVar("Float", 16, "StimTime")
    self:NetworkVar("Bool", 6, "Stimmed")
end

function SWEP:Initialize()
    BaseClass.Initialize(self, false)

    -- SWCS hates ammo types apparently
    self.Primary.Ammo = self.AmmoType

    -- engine deploy blocks weapon from thinking and doing most stuff
    self.m_WeaponDeploySpeed = 255

    self:SetHoldType(self.HoldType)
    self:SetStimTime(0)
    self:SetStimmed(false)
end

function SWEP:Deploy()
    local owner = self:GetOwner()
    if not owner or not owner:IsPlayer() then return end

    self:SetHoldType(self.HoldType)
    self:SetWeaponAnim(ACT_VM_DEPLOY)
    -- self:SetNextPrimaryFire(CurTime() + 1)
    -- self:SetWeaponIdleTime(CurTime() + 1)
    self:SetStimTime(0)
    self:SetStimmed(false)
    self:SetBodygroup(0, 0)

    local vm = owner:GetViewModel(self:ViewModelIndex())
    if vm:IsValid() then
        vm:SetPlaybackRate(self:GetDeploySpeed())
        self:SetWeaponIdleTime(CurTime() + (self:SequenceDuration() * (1 / self:GetDeploySpeed())))
    end
    self:SetNextPrimaryFire(CurTime() + self:SequenceDuration() * (1 / self:GetDeploySpeed()) * 0.9)

    return true
end

function SWEP:Holster(nextWep)
    if SERVER and IsValid(self:GetOwner()) and self:GetOwner():GetAmmoCount(self:GetPrimaryAmmoType()) <= 0 then
        self:Remove()
    end
    self:SetBodygroup(0, 0)
    self:SetStimTime(0)
    return BaseClass.Holster(self, nextWep)
end

function SWEP:CanPrimaryAttack()
    local ply = self:GetOwner()
    if not ply:IsPlayer() then return false end
    if self:GetStimTime() > 0 or self:GetNextPrimaryFire() > CurTime() then return false end
    if ply:Health() >= ply:GetMaxHealth() and not GetConVar("dzents_healthshot_use_at_full"):GetBool() then return false end

    if self:Ammo1() <= 0 then
        self:RemoveAndSwitch()
        return false
    end

    return true
end

function SWEP:PrimaryAttack()
    if self:CanPrimaryAttack() then
        self:SetNextPrimaryFire(CurTime() + 2)
        self:SetStimTime(CurTime() + 28 / 40)
        self:SetWeaponAnim(ACT_VM_PRIMARYATTACK)
        self:SetHoldType("slam")
        self:SetBodygroup(0, 1)
    end
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
    local ply = self:GetOwner()
    if ply:KeyPressed(IN_RELOAD) and self:Ammo1() > 0 then

        self:SetNextPrimaryFire(CurTime() + 0.75)
        ply:DoAnimationEvent(ACT_GMOD_GESTURE_ITEM_DROP)

        -- if SERVER then
        --     ply:DropWeapon(self)
        --     self:SetClip1(1)

        --     ply:RemoveAmmo(1, self:GetPrimaryAmmoType())
        --     if ply:GetAmmoCount(self:GetPrimaryAmmoType()) > 0 then
        --         local new = ply:Give(self:GetClass(), true)
        --         ply:SelectWeapon(new)
        --     end
        -- end

        if SERVER then
            ply:RemoveAmmo(1, self:GetPrimaryAmmoType())

            local ent = ents.Create(self:GetClass())
            ent:SetPos(ply:GetShootPos() - Vector(0, 0, 12))
            ent:SetAngles(ply:EyeAngles() + AngleRand())
            ent:Spawn()
            ent.DZENTS_Pickup = CurTime() + 1
            local phys = ent:GetPhysicsObject()
            if IsValid(phys) then
                phys:SetVelocityInstantaneous(ply:GetAimVector() * 400)
                phys:AddAngleVelocity(VectorRand() * 200)
            end

            if GetConVar("dzents_drop_cleanup"):GetFloat() > 0 then
                timer.Simple(GetConVar("dzents_drop_cleanup"):GetFloat(), function()
                    if IsValid(ent) and not IsValid(ent:GetOwner()) then
                        ent.DZENTS_Pickup = CurTime() + 2
                        ent:SetRenderMode(RENDERMODE_TRANSALPHA) -- doesn't seem to work but whatever
                        ent:SetRenderFX(kRenderFxFadeSlow)
                        SafeRemoveEntityDelayed(ent, 1)
                    end
                end)
            end
        end

        if self:Ammo1() <= 0 then
            self:SetWeaponAnim(ACT_VM_IDLE)
            self:RemoveAndSwitch()
        else
            self:SetWeaponAnim(ACT_VM_DEPLOY)
            self:SetWeaponIdleTime(CurTime() + 1)
            self:SetStimTime(0)
            self:SetStimmed(false)
            self:SetHoldType(self.HoldType)
            self:SetBodygroup(0, 0)
        end
    end
end

function SWEP:Think()
    if self:GetStimTime() > 0 and self:GetStimTime() < CurTime() and IsFirstTimePredicted() then
        self:SetStimTime(0)
        self:SetStimmed(true)
        self:EmitSound("DZ_Ents.Healthshot.Success")
        self:GetOwner():RemoveAmmo(1, self:GetPrimaryAmmoType())

        local ply = self:GetOwner()
        ply:SetNWFloat("DZ_Ents.Healthshot", CurTime() + GetConVar("dzents_healthshot_duration"):GetFloat())
        ply:DoAnimationEvent(ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER)

        if SERVER and ply:GetMaxHealth() > ply:Health() then
            local amt = GetConVar("dzents_healthshot_health"):GetInt()
            local dur = GetConVar("dzents_healthshot_healtime"):GetFloat()
            if dur <= 0 then
                ply:SetHealth(math.min(ply:Health() + amt, ply:GetMaxHealth()))
            else
                -- Timers cannot run more frequently than the tick interval. If the duration is short enough, we must heal more than 1hp per tick.
                local lasttick = 0
                local tickheal = 1
                local tickamt = amt
                local interval = dur / amt
                while interval < engine.TickInterval() do
                    tickheal = tickheal + 1
                    tickamt = math.floor(amt / tickheal)
                    lasttick = amt - (tickheal * tickamt)
                    interval = dur / tickamt
                end
                local timername = "healthshot_" .. ply:EntIndex() -- timers of the same name will overwrite each other. This is intentional!
                timer.Create(timername, interval, tickamt, function()
                    if not ply:Alive() or ply:GetMaxHealth() <= ply:Health() then
                        timer.Remove(timername)
                        return
                    end
                    ply:SetHealth(math.min(ply:Health() + tickheal, ply:GetMaxHealth()))
                    if timer.RepsLeft(timername) == 0 then
                        ply:SetHealth(math.min(ply:Health() + lasttick, ply:GetMaxHealth()))
                    end
                end)
            end
        end
    end

    self:WeaponIdle()
end

function SWEP:WeaponIdle()
    if self:GetWeaponIdleTime() > CurTime() then return end

    if self:GetStimmed() then
        if self:Ammo1() <= 0 then
            self:RemoveAndSwitch()
        else
            self:SetWeaponAnim(ACT_VM_DEPLOY)
            self:SetNextPrimaryFire(CurTime() + 1)
            self:SetWeaponIdleTime(CurTime() + 1)
            self:SetStimTime(0)
            self:SetStimmed(false)
            self:SetHoldType(self.HoldType)
            self:SetBodygroup(0, 0)
        end
    else
        self:SetWeaponIdleTime(math.huge) -- it's looping anyways
        self:SetWeaponAnim(ACT_VM_IDLE)
    end
end