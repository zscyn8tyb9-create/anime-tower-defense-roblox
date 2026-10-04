-- ReplicatedStorage/Shared/AnimeTD/ArenaCatalog.lua
local ArenaCatalog = {
    Lobby = {
        Name = "Anime Tower Defense Lobby",
        Theme = "Celestial Nexus",
        Background = "Floating pagodas, neon sky bridges, moonlit gardens",
        ArenaCount = 10,
        SelectionMessage = "Choose your battlefield",
    },

    Arenas = {
        {
            Id = 1,
            Name = "Crimson Shrine",
            Theme = "Blood sakura and stone altars",
            Difficulty = 1,
            WaveMultiplier = 1.0,
            Environment = "Temple ruins",
            Boss = "Ashen Oni",
        },
        {
            Id = 2,
            Name = "Moonlit Lake",
            Theme = "Reflective water and glowing lilies",
            Difficulty = 2,
            WaveMultiplier = 1.1,
            Environment = "Lakefront arcades",
            Boss = "Moonlit Naga",
        },
        {
            Id = 3,
            Name = "Volcanic Courtyard",
            Theme = "Magma veins and floating obsidian",
            Difficulty = 3,
            WaveMultiplier = 1.2,
            Environment = "Volcanic fortress",
            Boss = "Cinder Warden",
        },
        {
            Id = 4,
            Name = "Fallen Palace",
            Theme = "Shattered royal towers",
            Difficulty = 4,
            WaveMultiplier = 1.3,
            Environment = "Ancient palace",
            Boss = "Vesper King",
        },
        {
            Id = 5,
            Name = "Stormfront Harbor",
            Theme = "Distant thunder and flying docks",
            Difficulty = 5,
            WaveMultiplier = 1.4,
            Environment = "Thunder harbor",
            Boss = "Tidebreaker",
        },
        {
            Id = 6,
            Name = "Sakura Abyss",
            Theme = "Blooming petals over dark void",
            Difficulty = 6,
            WaveMultiplier = 1.5,
            Environment = "Moon abyss",
            Boss = "Rose Reaper",
        },
        {
            Id = 7,
            Name = "Flame Citadel",
            Theme = "Golden fire banners and floating ruins",
            Difficulty = 7,
            WaveMultiplier = 1.6,
            Environment = "Castle ruins",
            Boss = "Ember Sovereign",
        },
        {
            Id = 8,
            Name = "Sky Ruins",
            Theme = "Airship wreckage and suspended chasms",
            Difficulty = 8,
            WaveMultiplier = 1.7,
            Environment = "Sky battlefield",
            Boss = "Nightfall Dragon",
        },
        {
            Id = 9,
            Name = "Glacier Sanctuary",
            Theme = "Frozen temple gardens and crystal fog",
            Difficulty = 9,
            WaveMultiplier = 1.8,
            Environment = "Ice sanctuary",
            Boss = "Crystal Saint",
        },
        {
            Id = 10,
            Name = "Divine Zenith",
            Theme = "Heavenly arcways and radiant clouds",
            Difficulty = 10,
            WaveMultiplier = 2.0,
            Environment = "Celestial summit",
            Boss = "Celestial Ruler",
        },
    },
}

function ArenaCatalog:GetLobby()
    return self.Lobby
end

function ArenaCatalog:GetAll()
    return self.Arenas
end

function ArenaCatalog:GetByDifficulty(difficulty)
    local results = {}
    for _, arena in ipairs(self.Arenas) do
        if arena.Difficulty == difficulty then
            table.insert(results, arena)
        end
    end
    return results
end

function ArenaCatalog:GetByName(name)
    for _, arena in ipairs(self.Arenas) do
        if arena.Name == name then
            return arena
        end
    end
    return nil
end

return ArenaCatalog
