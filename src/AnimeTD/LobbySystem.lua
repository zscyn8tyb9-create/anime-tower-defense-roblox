-- ServerScriptService/AnimeTD/LobbySystem.lua
local LobbySystem = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local sharedFolder = ReplicatedStorage:FindFirstChild("Shared")
if not sharedFolder then
    sharedFolder = Instance.new("Folder")
    sharedFolder.Name = "Shared"
    sharedFolder.Parent = ReplicatedStorage
end

local animeFolder = sharedFolder:FindFirstChild("AnimeTD")
if not animeFolder then
    animeFolder = Instance.new("Folder")
    animeFolder.Name = "AnimeTD"
    animeFolder.Parent = sharedFolder
end

-- Load data modules if present
local success, UnitCatalog = pcall(function()
    return require(animeFolder:WaitForChild("UnitCatalog"))
end)

local successBoss, BossCatalog = pcall(function()
    return require(animeFolder:WaitForChild("BossCatalog"))
end)

local successArena, ArenaCatalog = pcall(function()
    return require(animeFolder:WaitForChild("ArenaCatalog"))
end)

local function createLobbyFolder()
    local lobbyFolder = workspace:FindFirstChild("AnimeTD_Lobby")
    if lobbyFolder then
        return lobbyFolder
    end

    lobbyFolder = Instance.new("Folder")
    lobbyFolder.Name = "AnimeTD_Lobby"
    lobbyFolder.Parent = workspace
    return lobbyFolder
end

local function createArenaPortal(arenaName, position)
    local portal = Instance.new("Part")
    portal.Name = arenaName .. "_Portal"
    portal.Size = Vector3.new(10, 16, 4)
    portal.Anchored = true
    portal.Position = position
    portal.Material = Enum.Material.Neon
    portal.Color = Color3.fromRGB(140, 120, 255)
    portal.Parent = createLobbyFolder()

    local glow = Instance.new("PointLight")
    glow.Brightness = 2
    glow.Range = 20
    glow.Color = Color3.fromRGB(170, 120, 255)
    glow.Parent = portal

    local hint = Instance.new("BillboardGui")
    hint.Size = UDim2.new(0, 200, 0, 80)
    hint.StudsOffset = Vector3.new(0, 8, 0)
    hint.AlwaysOnTop = true
    hint.Parent = portal

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 1, 0)
    title.BackgroundTransparency = 1
    title.Text = arenaName
    title.Font = Enum.Font.GothamBold
    title.TextScaled = true
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Parent = hint

    return portal
end

local function buildLobby()
    local lobbyFolder = createLobbyFolder()
    local lobbyBase = lobbyFolder:FindFirstChild("Base")
    if not lobbyBase then
        lobbyBase = Instance.new("Part")
        lobbyBase.Name = "Base"
        lobbyBase.Size = Vector3.new(200, 1, 200)
        lobbyBase.Position = Vector3.new(0, 0, 0)
        lobbyBase.Material = Enum.Material.SmoothPlastic
        lobbyBase.Color = Color3.fromRGB(35, 40, 60)
        lobbyBase.Anchored = true
        lobbyBase.Parent = lobbyFolder
    end

    local arenaList = ArenaCatalog and ArenaCatalog:GetAll() or {}
    local spacing = 26
    for index, arena in ipairs(arenaList) do
        local x = ((index - 1) % 5) * spacing - 52
        local z = math.floor((index - 1) / 5) * spacing - 26
        createArenaPortal(arena.Name, Vector3.new(x, 6, z))
    end
end

local function createLobbyUI(player)
    local playerGui = player:WaitForChild("PlayerGui")
    local gui = playerGui:FindFirstChild("AnimeTD_LobbyUI")
    if gui then
        return gui
    end

    gui = Instance.new("ScreenGui")
    gui.Name = "AnimeTD_LobbyUI"
    gui.ResetOnSpawn = false
    gui.Parent = playerGui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0, 500, 0, 60)
    title.Position = UDim2.new(0.5, -250, 0, 24)
    title.BackgroundTransparency = 1
    title.Text = "Anime Tower Defense Lobby"
    title.Font = Enum.Font.GothamBlack
    title.TextScaled = true
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Parent = gui

    local arenaList = Instance.new("ScrollingFrame")
    arenaList.Size = UDim2.new(0, 420, 0, 280)
    arenaList.Position = UDim2.new(0.5, -210, 0.5, -140)
    arenaList.BackgroundColor3 = Color3.fromRGB(15, 16, 26)
    arenaList.BackgroundTransparency = 0.15
    arenaList.BorderSizePixel = 0
    arenaList.Parent = gui

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 10)
    listLayout.Parent = arenaList

    local arenas = ArenaCatalog and ArenaCatalog:GetAll() or {}
    for _, arena in ipairs(arenas) do
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, -20, 0, 50)
        button.BackgroundColor3 = Color3.fromRGB(110, 95, 255)
        button.Text = arena.Name .. " · Difficulty " .. arena.Difficulty
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Font = Enum.Font.GothamBold
        button.TextSize = 18
        button.BorderSizePixel = 0
        button.Parent = arenaList

        button.MouseButton1Click:Connect(function()
            print("Selected arena:", arena.Name)
        end)
    end

    return gui
end

Players.PlayerAdded:Connect(function(player)
    createLobbyUI(player)
end)

for _, player in ipairs(Players:GetPlayers()) do
    createLobbyUI(player)
end

buildLobby()

return LobbySystem
