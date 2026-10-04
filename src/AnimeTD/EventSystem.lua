-- ReplicatedStorage/Shared/AnimeTD/EventSystem.lua
local EventSystem = {}

local events = {
    {
        Id = 1,
        Name = "Flame Festival",
        Description = "Fire-type units earn 2x gold",
        StartWave = 1,
        EndWave = 5,
        Bonus = { GoldMultiplier = 2, Type = "Flame" },
        RewardUnit = "Festival Flame Dancer",
    },
    {
        Id = 2,
        Name = "Frost Ceremony",
        Description = "Ice units slow enemies 50% more",
        StartWave = 6,
        EndWave = 10,
        Bonus = { SlowMultiplier = 1.5, Type = "Frost" },
        RewardUnit = "Ceremony Frost Maiden",
    },
    {
        Id = 3,
        Name = "Thunder Festival",
        Description = "Lightning units deal 30% more damage",
        StartWave = 11,
        EndWave = 15,
        Bonus = { DamageMultiplier = 1.3, Type = "Thunder" },
        RewardUnit = "Festival Thunder Lord",
    },
    {
        Id = 4,
        Name = "Shadow Twilight",
        Description = "Dark units gain stealth ability",
        StartWave = 16,
        EndWave = 20,
        Bonus = { StealthChance = 0.3, Type = "Shadow" },
        RewardUnit = "Twilight Shadow Phantom",
    },
    {
        Id = 5,
        Name = "Divine Ascension",
        Description = "Light units grant 50% damage to nearby allies",
        StartWave = 21,
        EndWave = 30,
        Bonus = { SupportMultiplier = 1.5, Type = "Light" },
        RewardUnit = "Ascended Divine Angel",
    },
}

local limitedBanners = {
    {
        Id = 1,
        Name = "Flame Festival Summon",
        FeaturedUnit = "Festival Flame Dancer",
        Duration = 14,
        BonusRate = 0.15,
    },
    {
        Id = 2,
        Name = "Anniversary Celebration",
        FeaturedUnit = "Celestial Anniversary Hero",
        Duration = 21,
        BonusRate = 0.20,
    },
}

local dailyRewards = {
    { Day = 1, Reward = { Gems = 50, Gold = 1000 } },
    { Day = 2, Reward = { Gems = 50, Gold = 1000 } },
    { Day = 3, Reward = { Gems = 100, Gold = 2000 } },
    { Day = 4, Reward = { Gems = 50, Gold = 1000 } },
    { Day = 5, Reward = { Gems = 50, Gold = 1000 } },
    { Day = 6, Reward = { Gems = 100, Gold = 2000 } },
    { Day = 7, Reward = { Gems = 300, Gold = 5000, Unit = "Weekly Bonus Unit" } },
}

function EventSystem:GetActiveEvents(currentWave)
    local active = {}
    for _, event in ipairs(events) do
        if currentWave >= event.StartWave and currentWave <= event.EndWave then
            table.insert(active, event)
        end
    end
    return active
end

function EventSystem:GetLimitedBanners()
    return limitedBanners
end

function EventSystem:GetDailyRewards()
    return dailyRewards
end

function EventSystem:ApplyEventBonus(wave, unitType)
    local activeEvents = self:GetActiveEvents(wave)
    local totalMultiplier = 1.0

    for _, event in ipairs(activeEvents) do
        if event.Bonus.Type == unitType then
            for stat, value in pairs(event.Bonus) do
                if stat == "GoldMultiplier" then totalMultiplier *= value end
                if stat == "DamageMultiplier" then totalMultiplier *= value end
            end
        end
    end

    return totalMultiplier
end

return EventSystem
