-- ReplicatedStorage/Shared/AnimeTD/PrestigeSystem.lua
local PrestigeSystem = {}

local prestigeLevels = {
    { Prestige = 1, ResetCost = 100000, Reward = { Gems = 500, Multiplier = 1.1 } },
    { Prestige = 2, ResetCost = 500000, Reward = { Gems = 1000, Multiplier = 1.2 } },
    { Prestige = 3, ResetCost = 2000000, Reward = { Gems = 2000, Multiplier = 1.3 } },
    { Prestige = 4, ResetCost = 10000000, Reward = { Gems = 5000, Multiplier = 1.5 } },
    { Prestige = 5, ResetCost = 50000000, Reward = { Gems = 10000, Multiplier = 2.0 } },
}

function PrestigeSystem:GetPrestigeLevels()
    return prestigeLevels
end

function PrestigeSystem:CanPrestige(playerGold, currentPrestige)
    if currentPrestige > #prestigeLevels then
        return false
    end
    local cost = prestigeLevels[currentPrestige].ResetCost
    return playerGold >= cost
end

function PrestigeSystem:ApplyPrestige(prestige)
    if prestige > #prestigeLevels then
        return { Gems = 0, Multiplier = 1.0 }
    end
    return prestigeLevels[prestige].Reward
end

function PrestigeSystem:GetPrestigeMultiplier(prestige)
    local total = 1.0
    for i = 1, math.min(prestige, #prestigeLevels) do
        total = total * prestigeLevels[i].Reward.Multiplier
    end
    return total
end

return PrestigeSystem
