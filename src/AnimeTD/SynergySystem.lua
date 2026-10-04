-- ReplicatedStorage/Shared/AnimeTD/SynergySystem.lua
local SynergySystem = {}

local synergies = {
    FireTeam = {
        Name = "Inferno Alliance",
        Units = { "Flame", "Ember", "Blaze" },
        Bonus = { Damage = 0.25, AttackSpeed = 0.15 },
        RequiredCount = 3,
    },
    FrostTeam = {
        Name = "Frozen Pact",
        Units = { "Frost", "Ice", "Chill" },
        Bonus = { Damage = 0.20, SlowDuration = 2 },
        RequiredCount = 2,
    },
    ThunderTeam = {
        Name = "Storm Dominion",
        Units = { "Lightning", "Thunder", "Bolt" },
        Bonus = { Damage = 0.30, Range = 15 },
        RequiredCount = 3,
    },
    ShadowTeam = {
        Name = "Void Curse",
        Units = { "Shadow", "Dark", "Void" },
        Bonus = { Damage = 0.35, CritChance = 0.20 },
        RequiredCount = 2,
    },
    LightTeam = {
        Name = "Divine Grace",
        Units = { "Light", "Holy", "Radiant" },
        Bonus = { Damage = 0.25, Support = 0.30 },
        RequiredCount = 2,
    },
    NatureTeam = {
        Name = "Verdant Bond",
        Units = { "Nature", "Growth", "Flourish" },
        Bonus = { Health = 0.20, Regeneration = 100 },
        RequiredCount = 2,
    },
}

local unitTraits = {
    Demon = { Bonus = 0.15, Description = "Demonic units gain +15% damage" },
    Angel = { Bonus = 0.15, Description = "Angelic units gain +15% defense" },
    Dragon = { Bonus = 0.20, Description = "Dragons gain +20% all stats" },
    Human = { Bonus = 0.10, Description = "Humans gain +10% speed" },
    Beast = { Bonus = 0.12, Description = "Beasts gain +12% attack speed" },
    God = { Bonus = 0.25, Description = "Gods gain +25% damage and range" },
}

function SynergySystem:GetSynergies()
    return synergies
end

function SynergySystem:GetUnitTraits()
    return unitTraits
end

function SynergySystem:CalculateTeamBonus(units)
    local bonuses = { Damage = 1.0, AttackSpeed = 1.0, Range = 0, Support = 1.0, Health = 1.0 }

    for synergyName, synergy in pairs(synergies) do
        local count = 0
        for _, unit in ipairs(units) do
            for _, unitType in ipairs(synergy.Units) do
                if string.find(unit.Type or "", unitType) then
                    count += 1
                end
            end
        end

        if count >= synergy.RequiredCount then
            for stat, bonus in pairs(synergy.Bonus) do
                if stat == "Damage" then bonuses.Damage *= (1 + bonus)
                elseif stat == "AttackSpeed" then bonuses.AttackSpeed *= (1 + bonus)
                elseif stat == "Range" then bonuses.Range += bonus
                elseif stat == "Support" then bonuses.Support *= (1 + bonus)
                elseif stat == "Health" then bonuses.Health *= (1 + bonus)
                end
            end
        end
    end

    return bonuses
end

function SynergySystem:GetTraitBonus(unitType)
    for trait, data in pairs(unitTraits) do
        if string.find(unitType or "", trait) then
            return data.Bonus
        end
    end
    return 1.0
end

return SynergySystem
