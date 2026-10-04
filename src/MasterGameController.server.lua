-- ServerScriptService/MasterGameController.server.lua
-- Main game controller that ties all systems together

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Load all modules
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Modules = Shared:WaitForChild("Modules")
local AnimeTD = Shared:WaitForChild("AnimeTD")

local GameConfig = require(Modules:WaitForChild("GameConfig"))
local ResourceManager = require(Modules:WaitForChild("ResourceManager"))
local WaveManager = require(Modules:WaitForChild("WaveManager"))
local TowerSystem = require(Modules:WaitForChild("TowerSystem"))
local EnemySystem = require(Modules:WaitForChild("EnemySystem"))
local UIManager = require(Modules:WaitForChild("UIManager"))
local EffectSystem = require(Modules:WaitForChild("EffectSystem"))

-- Load new anime TD systems
local UnitCatalog = require(AnimeTD:WaitForChild("UnitCatalog"))
local BossCatalog = require(AnimeTD:WaitForChild("BossCatalog"))
local ArenaCatalog = require(AnimeTD:WaitForChild("ArenaCatalog"))
local GachaSystem = require(AnimeTD:WaitForChild("GachaSystem"))
local ProgressionSystem = require(AnimeTD:WaitForChild("ProgressionSystem"))
local CoopSystem = require(AnimeTD:WaitForChild("CoopSystem"))
local SynergySystem = require(AnimeTD:WaitForChild("SynergySystem"))
local EventSystem = require(AnimeTD:WaitForChild("EventSystem"))
local UnitAwakening = require(AnimeTD:WaitForChild("UnitAwakening"))
local MapGeneration = require(AnimeTD:WaitForChild("MapGeneration"))
local PrestigeSystem = require(AnimeTD:WaitForChild("PrestigeSystem"))
local EndgameContent = require(AnimeTD:WaitForChild("EndgameContent"))
local RarityTiers = require(AnimeTD:WaitForChild("RarityTiers"))

print("[ANIME TD] Loading all systems...")

-- ===== GAME STATE =====
local gameState = {
    GameMode = "Lobby", -- Lobby, Playing, GameOver, Paused
    CurrentArena = nil,
    CurrentDifficulty = 1,
    CurrentChallenge = nil,
    Players = {},
    IsCoOp = false,
    CoOpLobbyId = nil,
}

-- ===== REMOTE EVENTS =====
local remotes = ReplicatedStorage:FindFirstChild("Remotes")
if not remotes then
    remotes = Instance.new("Folder")
    remotes.Name = "Remotes"
    remotes.Parent = ReplicatedStorage
end

local function createRemote(name)
    local existing = remotes:FindFirstChild(name)
    if existing then return existing end
    local remote = Instance.new("RemoteEvent")
    remote.Name = name
    remote.Parent = remotes
    return remote
end

local GameStateUpdate = createRemote("GameStateUpdate")
local SelectArena = createRemote("SelectArena")
local PullGacha = createRemote("PullGacha")
local AwakeUnit = createRemote("AwakeUnit")
local CreateCoopLobby = createRemote("CreateCoopLobby")
local JoinCoopLobby = createRemote("JoinCoopLobby")
local StartGame = createRemote("StartGame")
local PlaceTowerEvent = createRemote("PlaceTower")
local UpgradeTowerEvent = createRemote("UpgradeTower")
local SellTowerEvent = createRemote("SellTower")

print("[ANIME TD] Remote events created.")

-- ===== ARENA SETUP =====
local function setupArenas()
    local arenasFolder = workspace:FindFirstChild("Arenas")
    if not arenasFolder then
        arenasFolder = Instance.new("Folder")
        arenasFolder.Name = "Arenas"
        arenasFolder.Parent = workspace
    end

    local arenaList = ArenaCatalog:GetAll()
    for _, arenaData in ipairs(arenaList) do
        local existing = arenasFolder:FindFirstChild(arenaData.Name)
        if not existing then
            local template = MapGeneration:GetTemplate(arenaData.Name)
            MapGeneration:GenerateArena(template, arenasFolder)
            print("[ANIME TD] Generated arena:", arenaData.Name)
        end
    end

    return arenasFolder
end

local ArenasFolder = setupArenas()

print("[ANIME TD] Arena setup complete.")

-- ===== PLAYER PROGRESSION =====
local playerData = {}

local function initializePlayer(player)
    playerData[player.UserId] = {
        Player = player,
        Progression = ProgressionSystem:CreatePlayerProgression(player.UserId),
        OwnedUnits = {},
        EquippedTeam = {},
        CurrentArena = nil,
        IsPlaying = false,
    }
    print("[ANIME TD] Player initialized:", player.Name)
end

Players.PlayerAdded:Connect(function(player)
    initializePlayer(player)
end)

for _, player in ipairs(Players:GetPlayers()) do
    initializePlayer(player)
end

-- ===== GACHA SYSTEM =====
PullGacha.OnServerEvent:Connect(function(player, bannerName, pullCount)
    local data = playerData[player.UserId]
    if not data then return end

    local pullCost = 30 * (pullCount or 1)
    local progression = data.Progression

    if progression.Gems < pullCost then
        print("[GACHA] Player", player.Name, "insufficient gems")
        return
    end

    progression.Gems -= pullCost

    local results = {}
    if pullCount == 10 then
        results = GachaSystem:PullTen(bannerName, UnitCatalog)
    else
        results = { GachaSystem:PullOnce(bannerName, UnitCatalog) }
    end

    for _, unit in ipairs(results) do
        table.insert(data.OwnedUnits, unit)
    end

    print("[GACHA] Player", player.Name, "pulled", #results, "units")
    GameStateUpdate:FireClient(player, {
        Progression = progression,
        OwnedUnits = #data.OwnedUnits,
        PullResults = results,
    })
end)

-- ===== ARENA SELECTION =====
SelectArena.OnServerEvent:Connect(function(player, arenaName, difficulty, challengeMode)
    local data = playerData[player.UserId]
    if not data then return end

    local arena = ArenaCatalog:GetByName(arenaName)
    if not arena then
        print("[ARENA] Invalid arena:", arenaName)
        return
    end

    data.CurrentArena = arena
    data.Progression.Gold = GameConfig.StartingGold
    data.Progression.Lives = GameConfig.StartingLives

    gameState.CurrentArena = arenaName
    gameState.CurrentDifficulty = difficulty or 1
    gameState.CurrentChallenge = challengeMode
    gameState.GameMode = "Playing"

    print("[ARENA] Player", player.Name, "selected:", arenaName, "Difficulty:", difficulty)

    GameStateUpdate:FireClient(player, {
        GameMode = "Playing",
        Arena = arena,
        Difficulty = difficulty,
        Gold = data.Progression.Gold,
        Lives = data.Progression.Lives,
    })
end)

-- ===== UNIT AWAKENING =====
AwakeUnit.OnServerEvent:Connect(function(player, unitId, materialsUsed)
    local data = playerData[player.UserId]
    if not data then return end

    -- Find unit in owned units
    for i, unit in ipairs(data.OwnedUnits) do
        if unit.Id == unitId then
            local awakeningLevel = (unit.AwakeningLevel or 0) + 1
            if UnitAwakening:CanAwaken(unit.Level or 1, awakeningLevel) then
                unit.AwakeningLevel = awakeningLevel
                local baseDmg, baseHealth = UnitAwakening:CalculateAwakeningStats(
                    unit.Damage,
                    unit.Health,
                    awakeningLevel
                )
                unit.Damage = baseDmg
                unit.Health = baseHealth
                print("[AWAKENING] Unit", unitId, "awakened to level", awakeningLevel)
            end
            break
        end
    end
end)

-- ===== CO-OP SYSTEM =====
CreateCoopLobby.OnServerEvent:Connect(function(player, difficulty, maxPlayers)
    local lobbyId = CoopSystem:CreateLobby(player.Name, difficulty, maxPlayers)
    local data = playerData[player.UserId]
    data.CoOpLobbyId = lobbyId
    gameState.IsCoOp = true
    gameState.CoOpLobbyId = lobbyId

    print("[CO-OP] Lobby created by", player.Name, "ID:", lobbyId)

    GameStateUpdate:FireClient(player, {
        CoOpMode = true,
        LobbyId = lobbyId,
    })
end)

JoinCoopLobby.OnServerEvent:Connect(function(player, lobbyId)
    local success = CoopSystem:JoinLobby(lobbyId, player.Name)
    if success then
        print("[CO-OP] Player", player.Name, "joined lobby", lobbyId)
    else
        print("[CO-OP] Player", player.Name, "failed to join lobby", lobbyId)
    end
end)

-- ===== TOWER PLACEMENT & UPGRADES =====
PlaceTowerEvent.OnServerEvent:Connect(function(player, towerType, zoneId)
    local data = playerData[player.UserId]
    if not data or not data.IsPlaying then return end

    local progression = data.Progression
    local towerConfig = GameConfig.Towers[towerType]
    if not towerConfig or progression.Gold < towerConfig.Cost then
        return
    end

    progression.Gold -= towerConfig.Cost
    print("[TOWER] Player", player.Name, "placed", towerType, "at zone", zoneId)
end)

UpgradeTowerEvent.OnServerEvent:Connect(function(player, towerId)
    local data = playerData[player.UserId]
    if not data or not data.IsPlaying then return end

    -- Tower upgrade logic
    print("[UPGRADE] Player", player.Name, "upgraded tower", towerId)
end)

SellTowerEvent.OnServerEvent:Connect(function(player, towerId)
    local data = playerData[player.UserId]
    if not data or not data.IsPlaying then return end

    -- Tower sell logic
    print("[SELL] Player", player.Name, "sold tower", towerId)
end)

-- ===== MAIN GAME LOOP =====
local function gameLoop()
    while true do
        for userId, data in pairs(playerData) do
            if data.IsPlaying then
                -- Update progression and stats
                ProgressionSystem:AddXP(userId, 10)

                -- Check for event bonuses
                local activeEvents = EventSystem:GetActiveEvents(data.Progression.Wave or 0)
                if #activeEvents > 0 then
                    -- Apply event multipliers
                end

                -- Update game state
                GameStateUpdate:FireClient(data.Player, {
                    Progression = data.Progression,
                    OwnedUnits = #data.OwnedUnits,
                    GameMode = gameState.GameMode,
                })
            end
        end

        task.wait(1)
    end
end

-- ===== PERIODIC TASKS =====
local function handleDailyRewards()
    while true do
        task.wait(86400) -- 24 hours
        for userId, data in pairs(playerData) do
            local dailyRewards = EventSystem:GetDailyRewards()
            if dailyRewards[1] then
                data.Progression.Gems += dailyRewards[1].Reward.Gems or 0
                data.Progression.Gold += dailyRewards[1].Reward.Gold or 0
                print("[DAILY] Reward given to player ID:", userId)
            end
        end
    end
end

local function handleLeaderboardUpdate()
    while true do
        task.wait(3600) -- 1 hour
        -- Update leaderboard with current player stats
        print("[LEADERBOARD] Updated")
    end
end

-- ===== START SYSTEMS =====
print("[ANIME TD] Starting game loop...")
task.spawn(gameLoop)
task.spawn(handleDailyRewards)
task.spawn(handleLeaderboardUpdate)

print("[ANIME TD] Master Game Controller initialized successfully!")
