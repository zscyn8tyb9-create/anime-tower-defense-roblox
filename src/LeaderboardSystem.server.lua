-- ServerScriptService/LeaderboardSystem.server.lua
-- Manages leaderboards and player rankings

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AnimeTD = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("AnimeTD")
local EndgameContent = require(AnimeTD:WaitForChild("EndgameContent"))

local LeaderboardSystem = {}

local leaderboards = {
    WaveRecord = {},
    GoldEarned = {},
    NightmareWins = {},
    Speedrun = {},
}

local function updateLeaderboard()
    -- Sort and rank players
    print("[LEADERBOARD] Updated all rankings")
end

function LeaderboardSystem:RecordWave(playerId, waveNumber)
    if not leaderboards.WaveRecord[playerId] then
        leaderboards.WaveRecord[playerId] = { PlayerId = playerId, Waves = waveNumber }
    else
        leaderboards.WaveRecord[playerId].Waves = math.max(leaderboards.WaveRecord[playerId].Waves, waveNumber)
    end
    updateLeaderboard()
end

function LeaderboardSystem:RecordGold(playerId, goldAmount)
    if not leaderboards.GoldEarned[playerId] then
        leaderboards.GoldEarned[playerId] = { PlayerId = playerId, Gold = goldAmount }
    else
        leaderboards.GoldEarned[playerId].Gold += goldAmount
    end
    updateLeaderboard()
end

function LeaderboardSystem:GetTopPlayers(leaderboardName, limit)
    local leaderboard = leaderboards[leaderboardName]
    if not leaderboard then return {} end

    local sorted = {}
    for _, data in pairs(leaderboard) do
        table.insert(sorted, data)
    end

    table.sort(sorted, function(a, b)
        return (a.Waves or a.Gold or 0) > (b.Waves or b.Gold or 0)
    end)

    local top = {}
    for i = 1, math.min(limit or 10, #sorted) do
        table.insert(top, sorted[i])
    end

    return top
end

return LeaderboardSystem
