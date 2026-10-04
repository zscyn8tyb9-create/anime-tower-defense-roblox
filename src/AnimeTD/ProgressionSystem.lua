-- ReplicatedStorage/Shared/AnimeTD/ProgressionSystem.lua
local ProgressionSystem = {}

local playerProgression = {}

local gamePass = {
    BattlePass = { Cost = 10, Duration = 45, Rewards = 200 },
    DailyPass = { Cost = 5, Duration = 1, Rewards = 50 },
    WeeklyPass = { Cost = 15, Duration = 7, Rewards = 150 },
}

local achievements = {
    { Id = 1, Name = "First Wave", Description = "Complete Wave 1", Reward = 100 },
    { Id = 2, Name = "Treasure Hunter", Description = "Collect 1000 gold", Reward = 250 },
    { Id = 3, Name = "Boss Slayer", Description = "Defeat 10 bosses", Reward = 500 },
    { Id = 4, Name = "Arena Master", Description = "Clear all arenas", Reward = 2000 },
    { Id = 5, Name = "Legendary Collector", Description = "Own 50 Legendary units", Reward = 1500 },
    { Id = 6, Name = "Wave Survivor", Description = "Reach Wave 100", Reward = 5000 },
    { Id = 7, Name = "Ultimate Power", Description = "Max out 5 units", Reward = 3000 },
    { Id = 8, Name = "Community Builder", Description = "Play 100 co-op matches", Reward = 2000 },
    { Id = 9, Name = "Speedrunner", Description = "Complete an arena in under 5 minutes", Reward = 1000 },
    { Id = 10, Name = "Gods Among Men", Description = "Defeat final boss on Nightmare", Reward = 10000 },
}

local battlePass = {
    Tiers = {
        { Tier = 1, XpRequired = 0, Rewards = { Gems = 10, Gold = 500, Units = 1 } },
        { Tier = 2, XpRequired = 1000, Rewards = { Gems = 15, Gold = 750, Units = 1 } },
        { Tier = 3, XpRequired = 2500, Rewards = { Gems = 20, Gold = 1000, Units = 2 } },
        { Tier = 4, XpRequired = 4000, Rewards = { Gems = 25, Gold = 1500, Units = 2 } },
        { Tier = 5, XpRequired = 6000, Rewards = { Gems = 30, Gold = 2000, Ticket = 1 } },
        { Tier = 10, XpRequired = 15000, Rewards = { Gems = 100, Gold = 5000, LegendaryUnit = 1 } },
        { Tier = 50, XpRequired = 100000, Rewards = { Gems = 500, Gold = 50000, ExclusivePass = 1 } },
    },
    DailyMissions = {
        { Id = 1, Name = "Daily Battles", Description = "Complete 3 waves", Reward = 200 },
        { Id = 2, Name = "Gold Collector", Description = "Earn 5000 gold", Reward = 300 },
        { Id = 3, Name = "Boss Hunt", Description = "Defeat 2 bosses", Reward = 400 },
        { Id = 4, Name = "Unit Enhancer", Description = "Level up 2 units", Reward = 250 },
        { Id = 5, Name = "Co-op Master", Description = "Play 2 co-op matches", Reward = 350 },
    },
    WeeklyMissions = {
        { Id = 1, Name = "Weekly Grind", Description = "Complete 20 waves", Reward = 1000 },
        { Id = 2, Name = "Arena Conqueror", Description = "Clear 3 different arenas", Reward = 1500 },
        { Id = 3, Name = "Boss Destroyer", Description = "Defeat 10 bosses", Reward = 2000 },
    },
}

function ProgressionSystem:CreatePlayerProgression(playerId)
    playerProgression[playerId] = {
        Level = 1,
        XP = 0,
        Gold = 2500,
        Gems = 50,
        Units = {},
        OwnedUnits = {},
        Achievements = {},
        BattlePassTier = 0,
        BattlePassXP = 0,
        IsActiveBattlePass = false,
        Playtime = 0,
        GamesPlayed = 0,
        WavesCleared = 0,
        BossesDefeated = 0,
    }
    return playerProgression[playerId]
end

function ProgressionSystem:GetPlayerProgression(playerId)
    if not playerProgression[playerId] then
        self:CreatePlayerProgression(playerId)
    end
    return playerProgression[playerId]
end

function ProgressionSystem:AddXP(playerId, amount)
    local progression = self:GetPlayerProgression(playerId)
    progression.XP += amount
    progression.BattlePassXP += amount

    -- Level up logic
    if progression.XP >= progression.Level * 1000 then
        progression.Level += 1
        progression.Gold += 500
        progression.Gems += 10
    end

    -- Battle pass tier up
    if progression.IsActiveBattlePass and progression.BattlePassXP >= 10000 then
        self:AdvanceBattlePassTier(playerId)
    end
end

function ProgressionSystem:AdvanceBattlePassTier(playerId)
    local progression = self:GetPlayerProgression(playerId)
    progression.BattlePassTier += 1
    progression.BattlePassXP = 0

    local tierRewards = battlePass.Tiers[progression.BattlePassTier]
    if tierRewards then
        progression.Gems += tierRewards.Rewards.Gems or 0
        progression.Gold += tierRewards.Rewards.Gold or 0
    end
end

function ProgressionSystem:UnlockAchievement(playerId, achievementId)
    local progression = self:GetPlayerProgression(playerId)
    if table.find(progression.Achievements, achievementId) then
        return false
    end

    table.insert(progression.Achievements, achievementId)
    for _, achievement in ipairs(achievements) do
        if achievement.Id == achievementId then
            progression.Gems += achievement.Reward
            return true
        end
    end
    return false
end

function ProgressionSystem:PurchaseBattlePass(playerId, passType)
    local progression = self:GetPlayerProgression(playerId)
    local pass = gamePass[passType]
    if not pass or progression.Gems < pass.Cost then
        return false
    end

    progression.Gems -= pass.Cost
    progression.IsActiveBattlePass = true
    return true
end

function ProgressionSystem:GetAchievements()
    return achievements
end

function ProgressionSystem:GetBattlePass()
    return battlePass
end

function ProgressionSystem:GetGamePasses()
    return gamePass
end

return ProgressionSystem
