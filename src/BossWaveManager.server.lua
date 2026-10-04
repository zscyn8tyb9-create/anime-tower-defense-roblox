-- ServerScriptService/BossWaveManager.server.lua
-- Manages boss encounters and wave scaling

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AnimeTD = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("AnimeTD")

local BossCatalog = require(AnimeTD:WaitForChild("BossCatalog"))
local EnemySystem = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("EnemySystem"))
local EffectSystem = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("EffectSystem"))

local BossWaveManager = {}

local activeBosses = {}
local nextBossId = 1

-- ===== BOSS SPAWN LOGIC =====
function BossWaveManager:SpawnBoss(bossName, waveNumber)
    local bossCatalog = BossCatalog:GetAll()
    local bossData = nil

    for _, boss in ipairs(bossCatalog) do
        if boss.Name == bossName then
            bossData = boss
            break
        end
    end

    if not bossData then
        print("[BOSS] Boss not found:", bossName)
        return nil
    end

    local bossId = nextBossId
    nextBossId += 1

    -- Apply wave scaling
    local healthMultiplier = 1 + (waveNumber - bossData.Phase) * 0.2
    local scaledHealth = bossData.Health * healthMultiplier

    activeBosses[bossId] = {
        Id = bossId,
        Name = bossName,
        Health = scaledHealth,
        MaxHealth = scaledHealth,
        Phase = bossData.Phase,
        Ability = bossData.Ability,
        Reward = bossData.Reward,
        IsAlive = true,
        Position = Vector3.new(0, 5, 0),
    }

    print("[BOSS] Spawned:", bossName, "Health:", scaledHealth, "Phase:", bossData.Phase)
    return activeBosses[bossId]
end

function BossWaveManager:DamageBoss(bossId, damage)
    local boss = activeBosses[bossId]
    if not boss or not boss.IsAlive then return false end

    boss.Health -= damage

    if boss.Health <= 0 then
        boss.IsAlive = false
        print("[BOSS] Defeated:", boss.Name, "Reward:", boss.Reward)
        return true
    end

    return false
end

function BossWaveManager:GetBoss(bossId)
    return activeBosses[bossId]
end

function BossWaveManager:GetAllBosses()
    return activeBosses
end

return BossWaveManager
