-- ReplicatedStorage/Shared/AnimeTD/BossCatalog.lua
local BossCatalog = {
    Bosses = {
        { Id = 1, Name = "Ashen Oni", Class = "Bruiser", Health = 12000, Reward = 1500, Arena = "Crimson Shrine", Phase = 2, Ability = "Rage Spiral" },
        { Id = 2, Name = "Moonlit Naga", Class = "Control", Health = 13000, Reward = 1600, Arena = "Moonlit Lake", Phase = 3, Ability = "Tidal Bind" },
        { Id = 3, Name = "Cinder Warden", Class = "Tank", Health = 14500, Reward = 1700, Arena = "Volcanic Courtyard", Phase = 2, Ability = "Meteor Guard" },
        { Id = 4, Name = "Vesper King", Class = "Caster", Health = 15000, Reward = 1800, Arena = "Fallen Palace", Phase = 3, Ability = "Celestial Collapse" },
        { Id = 5, Name = "Tidebreaker", Class = "Boss", Health = 16800, Reward = 2000, Arena = "Stormfront Harbor", Phase = 4, Ability = "Tidal Breaker" },
        { Id = 6, Name = "Rose Reaper", Class = "Assassin", Health = 17000, Reward = 2100, Arena = "Sakura Abyss", Phase = 4, Ability = "Petal Execution" },
        { Id = 7, Name = "Ember Sovereign", Class = "Caster", Health = 18000, Reward = 2200, Arena = "Flame Citadel", Phase = 4, Ability = "Solar Eruption" },
        { Id = 8, Name = "Nightfall Dragon", Class = "Boss", Health = 21000, Reward = 2500, Arena = "Sky Ruins", Phase = 5, Ability = "Void Wing Crash" },
        { Id = 9, Name = "Crystal Saint", Class = "Support", Health = 22000, Reward = 2700, Arena = "Glacier Sanctuary", Phase = 5, Ability = "Prism Judgment" },
        { Id = 10, Name = "Abyssal Seraph", Class = "Boss", Health = 26000, Reward = 3200, Arena = "Abyssal Gate", Phase = 6, Ability = "Final Hymn" },
        { Id = 11, Name = "Eclipse Tyrant", Class = "Boss", Health = 30000, Reward = 4000, Arena = "Black Moon Bastion", Phase = 7, Ability = "Eclipse Dominion" },
        { Id = 12, Name = "Celestial Ruler", Class = "Final Boss", Health = 42000, Reward = 6000, Arena = "Divine Zenith", Phase = 8, Ability = "Judgment of the Heavens" },
    }
}

function BossCatalog:GetAll()
    return self.Bosses
end

function BossCatalog:GetByArena(arenaName)
    local results = {}
    for _, boss in ipairs(self.Bosses) do
        if boss.Arena == arenaName then
            table.insert(results, boss)
        end
    end
    return results
end

function BossCatalog:GetFinalBoss()
    return self.Bosses[#self.Bosses]
end

return BossCatalog
