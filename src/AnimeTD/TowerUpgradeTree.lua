-- ReplicatedStorage/Shared/AnimeTD/TowerUpgradeTree.lua
-- Tower unlock and upgrade progression

local TowerUpgradeTree = {}

local towerProgression = {
    {
        Tier = 1,
        Name = "Basic Anime Warriors",
        Towers = { "Samurai", "Archer", "FrostMage" },
        UnlockWave = 1,
        RequiredGold = 0,
    },
    {
        Tier = 2,
        Name = "Advanced Anime Heroes",
        Towers = { "DemonSummoner", "LightPriestess", "ShadowNinja" },
        UnlockWave = 5,
        RequiredGold = 10000,
    },
    {
        Tier = 3,
        Name = "Legendary Anime Units",
        Towers = { "CelestialSwordmaster", "VoidNecromancer", "DragonLord" },
        UnlockWave = 10,
        RequiredGold = 50000,
    },
    {
        Tier = 4,
        Name = "Mythic Anime Gods",
        Towers = { "CelestialEmperor", "AbyssalMonarch", "TimeBendingSeraph" },
        UnlockWave = 20,
        RequiredGold = 500000,
    },
}

local upgradeTree = {
    Damage = { Max = 5, CostPerLevel = function(level) return 200 * (level + 1) end },
    Range = { Max = 5, CostPerLevel = function(level) return 150 * (level + 1) end },
    FireRate = { Max = 5, CostPerLevel = function(level) return 180 * (level + 1) end },
    Special = { Max = 3, CostPerLevel = function(level) return 300 * (level + 1) end },
}

function TowerUpgradeTree:GetProgression()
    return towerProgression
end

function TowerUpgradeTree:GetUnlockedTowers(waveNumber, totalGoldEarned)
    local unlockedTowers = {}
    for _, tier in ipairs(towerProgression) do
        if waveNumber >= tier.UnlockWave and totalGoldEarned >= tier.RequiredGold then
            for _, tower in ipairs(tier.Towers) do
                table.insert(unlockedTowers, tower)
            end
        end
    end
    return unlockedTowers
end

function TowerUpgradeTree:GetUpgradeTree()
    return upgradeTree
end

function TowerUpgradeTree:CalculateUpgradeCost(upgradeType, level)
    local upgrade = upgradeTree[upgradeType]
    if not upgrade or level >= upgrade.Max then
        return 0
    end
    return upgrade.CostPerLevel(level)
end

return TowerUpgradeTree
