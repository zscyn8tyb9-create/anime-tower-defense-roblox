-- ReplicatedStorage/Shared/AnimeTD/UnitAwakening.lua
local UnitAwakening = {}

local awakeningMaterials = {
    { Id = 1, Name = "Flame Essence", Rarity = "Common", Value = 1 },
    { Id = 2, Name = "Mystic Core", Rarity = "Rare", Value = 5 },
    { Id = 3, Name = "Divine Fragment", Rarity = "Epic", Value = 25 },
    { Id = 4, Name = "Celestial Shard", Rarity = "Legendary", Value = 100 },
    { Id = 5, Name = "Dimensional Stone", Rarity = "Mythic", Value = 500 },
}

local awakeningLevels = {
    { Level = 1, Name = "Awakening", MaterialsRequired = 10, GoldRequired = 5000, StatBoost = { Damage = 0.20, Health = 0.15 } },
    { Level = 2, Name = "Ascension", MaterialsRequired = 25, GoldRequired = 15000, StatBoost = { Damage = 0.30, Health = 0.25 } },
    { Level = 3, Name = "Transcendence", MaterialsRequired = 50, GoldRequired = 50000, StatBoost = { Damage = 0.50, Health = 0.40 } },
    { Level = 4, Name = "Apotheosis", MaterialsRequired = 100, GoldRequired = 150000, StatBoost = { Damage = 0.80, Health = 0.70 } },
    { Level = 5, Name = "Godhood", MaterialsRequired = 200, GoldRequired = 500000, StatBoost = { Damage = 1.50, Health = 1.20 } },
}

function UnitAwakening:GetAwakeningMaterials()
    return awakeningMaterials
end

function UnitAwakening:GetAwakeningLevels()
    return awakeningLevels
end

function UnitAwakening:CanAwaken(unitLevel, awakeningLevel)
    if awakeningLevel >= #awakeningLevels then
        return false
    end
    return unitLevel >= (awakeningLevel * 20 + 20)
end

function UnitAwakening:CalculateAwakeningStats(baseDamage, baseHealth, awakeningLevel)
    local boost = awakeningLevels[awakeningLevel]
    if not boost then return baseDamage, baseHealth end

    return baseDamage * (1 + boost.StatBoost.Damage), baseHealth * (1 + boost.StatBoost.Health)
end

function UnitAwakening:GetAwakeningCost(awakeningLevel)
    local level = awakeningLevels[awakeningLevel]
    if not level then return 0, 0 end
    return level.MaterialsRequired, level.GoldRequired
end

return UnitAwakening
