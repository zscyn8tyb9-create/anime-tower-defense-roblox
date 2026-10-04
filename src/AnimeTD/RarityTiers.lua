-- ReplicatedStorage/Shared/AnimeTD/RarityTiers.lua
local RarityTiers = {}

local rarities = {
    {
        Name = "Common",
        Color = Color3.fromRGB(150, 150, 150),
        BaseMultiplier = 1.0,
        SummonWeight = 0.5,
        Icon = "🔷",
    },
    {
        Name = "Rare",
        Color = Color3.fromRGB(100, 150, 255),
        BaseMultiplier = 1.2,
        SummonWeight = 0.3,
        Icon = "🔹",
    },
    {
        Name = "Epic",
        Color = Color3.fromRGB(150, 100, 255),
        BaseMultiplier = 1.5,
        SummonWeight = 0.15,
        Icon = "🟣",
    },
    {
        Name = "Legendary",
        Color = Color3.fromRGB(255, 200, 50),
        BaseMultiplier = 2.0,
        SummonWeight = 0.04,
        Icon = "⭐",
    },
    {
        Name = "Mythic",
        Color = Color3.fromRGB(255, 50, 50),
        BaseMultiplier = 2.5,
        SummonWeight = 0.01,
        Icon = "👑",
    },
}

function RarityTiers:GetRarities()
    return rarities
end

function RarityTiers:GetByName(name)
    for _, rarity in ipairs(rarities) do
        if rarity.Name == name then
            return rarity
        end
    end
    return rarities[1]
end

function RarityTiers:GetColor(rarityName)
    local rarity = self:GetByName(rarityName)
    return rarity.Color
end

function RarityTiers:GetIcon(rarityName)
    local rarity = self:GetByName(rarityName)
    return rarity.Icon
end

return RarityTiers
