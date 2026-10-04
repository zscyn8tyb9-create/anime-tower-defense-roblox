-- ReplicatedStorage/Shared/AnimeTD/CoopSystem.lua
local CoopSystem = {}

local activeLobbies = {}
local nextLobbyId = 1

function CoopSystem:CreateLobby(hostPlayer, difficulty, maxPlayers)
    local lobbyId = nextLobbyId
    nextLobbyId += 1

    activeLobbies[lobbyId] = {
        Id = lobbyId,
        Host = hostPlayer,
        Players = { hostPlayer },
        Difficulty = difficulty or 1,
        MaxPlayers = maxPlayers or 4,
        IsActive = false,
        CreatedAt = tick(),
        Wave = 0,
        Gold = 0,
        SharedResources = true,
    }

    return lobbyId
end

function CoopSystem:JoinLobby(lobbyId, player)
    local lobby = activeLobbies[lobbyId]
    if not lobby then return false end

    if #lobby.Players >= lobby.MaxPlayers then
        return false
    end

    if lobby.IsActive then
        return false
    end

    table.insert(lobby.Players, player)
    return true
end

function CoopSystem:LeaveLobby(lobbyId, player)
    local lobby = activeLobbies[lobbyId]
    if not lobby then return false end

    for i, p in ipairs(lobby.Players) do
        if p == player then
            table.remove(lobby.Players, i)
            if #lobby.Players == 0 then
                activeLobbies[lobbyId] = nil
            end
            return true
        end
    end
    return false
end

function CoopSystem:StartGame(lobbyId)
    local lobby = activeLobbies[lobbyId]
    if not lobby or #lobby.Players < 1 then return false end

    lobby.IsActive = true
    return true
end

function CoopSystem:EndGame(lobbyId, rewards)
    local lobby = activeLobbies[lobbyId]
    if not lobby then return false end

    lobby.IsActive = false
    -- Distribute rewards to all players
    for _, player in ipairs(lobby.Players) do
        print("Player", player, "earned", rewards or 0, "rewards")
    end

    activeLobbies[lobbyId] = nil
    return true
end

function CoopSystem:GetLobby(lobbyId)
    return activeLobbies[lobbyId]
end

function CoopSystem:GetAllLobbies()
    local lobbies = {}
    for id, lobby in pairs(activeLobbies) do
        if not lobby.IsActive then
            table.insert(lobbies, lobby)
        end
    end
    return lobbies
end

function CoopSystem:BroadcastToLobby(lobbyId, message)
    local lobby = activeLobbies[lobbyId]
    if not lobby then return end

    for _, player in ipairs(lobby.Players) do
        print("Message to", player, ":", message)
    end
end

return CoopSystem
