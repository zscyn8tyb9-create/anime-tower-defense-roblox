-- ReplicatedStorage/Shared/AnimeTD/EndgameContent.lua
local EndgameContent = {}

local challengeModes = {
    {
        Id = 1,
        Name = "Nightmare Mode",
        Description = "3x enemy health, 2x enemy speed",
        DifficultyMultiplier = 3.0,
        EnemyHealthMultiplier = 3,
        EnemySpeedMultiplier = 2,
        RewardMultiplier = 3,
    },
    {
        Id = 2,
        Name = "Endless Mode",
        Description = "Waves scale infinitely until you lose",
        Infinite = true,
        RewardMultiplier = 2,
    },
    {
        Id = 3,
        Name = "Time Attack",
        Description = "Clear waves before time runs out",
        TimeLimit = 600,
        RewardMultiplier = 1.5,
    },
    {
        Id = 4,
        Name = "No Gold Mode",
        Description = "Start with 0 gold, towers cost health",
        StartingGold = 0,
        TowerCostHealth = true,
        RewardMultiplier = 5,
    },
}

local leaderboards = {
    {
        Name = "Wave Record",
        Sorting = "descending",
        Duration = "All Time",
    },
    {
        Name = "Gold Earned",
        Sorting = "descending",
        Duration = "Weekly",
    },
    {
        Name = "Nightmare Wins",
        Sorting = "descending",
        Duration = "Monthly",
    },
    {
        Name = "Speedrun",
        Sorting = "ascending",
        Duration = "Weekly",
    },
}

local dailyChallenge = {
    Rotation = true,
    ResetTime = "00:00 UTC",
    Rewards = { Gems = 500, Gold = 10000, Experience = 5000 },
}

function EndgameContent:GetChallengeModes()
    return challengeModes
end

function EndgameContent:GetLeaderboards()
    return leaderboards
end

function EndgameContent:GetDailyChallenge()
    return dailyChallenge
end

function EndgameContent:ApplyDifficultyMultiplier(mode, baseValue)
    if mode.DifficultyMultiplier then
        return baseValue * mode.DifficultyMultiplier
    end
    return baseValue
end

return EndgameContent
