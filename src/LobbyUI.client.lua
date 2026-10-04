-- StarterPlayer/StarterPlayerScripts/LobbyUI.client.lua
-- Full lobby UI with arena selection, gacha, profile

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Wait for remotes
local remotes = ReplicatedStorage:WaitForChild("Remotes")
local selectArenaEvent = remotes:WaitForChild("SelectArena")
local pullGachaEvent = remotes:WaitForChild("PullGacha")
local createCoopEvent = remotes:WaitForChild("CreateCoopLobby")
local gameStateEvent = remotes:WaitForChild("GameStateUpdate")

-- Load data
local Shared = ReplicatedStorage:WaitForChild("Shared")
local AnimeTD = Shared:WaitForChild("AnimeTD")
local ArenaCatalog = require(AnimeTD:WaitForChild("ArenaCatalog"))
local UnitCatalog = require(AnimeTD:WaitForChild("UnitCatalog"))
local BossCatalog = require(AnimeTD:WaitForChild("BossCatalog"))
local RarityTiers = require(AnimeTD:WaitForChild("RarityTiers"))

local currentScreen = "Lobby"
local selectedArena = nil
local selectedDifficulty = 1

-- ===== MAIN SCREEN GUI =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AnimeTD_LobbyUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- ===== TITLE SCREEN =====
local function createTitleScreen()
    local container = Instance.new("Frame")
    container.Name = "TitleScreen"
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
    container.BorderSizePixel = 0
    container.Parent = screenGui

    -- Background gradient
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 15, 40)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 20, 60)),
    })
    gradient.Parent = container

    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0, 800, 0, 100)
    title.Position = UDim2.new(0.5, -400, 0, 50)
    title.BackgroundTransparency = 1
    title.Text = "⚔️ ANIME TOWER DEFENSE ⚔️"
    title.Font = Enum.Font.GothamBlack
    title.TextScaled = true
    title.TextColor3 = Color3.fromRGB(255, 200, 100)
    title.Parent = container

    -- Play Button
    local playBtn = Instance.new("TextButton")
    playBtn.Size = UDim2.new(0, 300, 0, 60)
    playBtn.Position = UDim2.new(0.5, -150, 0.5, -60)
    playBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    playBtn.Text = "▶ PLAY"
    playBtn.Font = Enum.Font.GothamBold
    playBtn.TextScaled = true
    playBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    playBtn.BorderSizePixel = 0
    playBtn.Parent = container

    local playCorner = Instance.new("UICorner")
    playCorner.CornerRadius = UDim.new(0, 15)
    playCorner.Parent = playBtn

    -- Gacha Button
    local gachaBtn = Instance.new("TextButton")
    gachaBtn.Size = UDim2.new(0, 300, 0, 60)
    gachaBtn.Position = UDim2.new(0.5, -150, 0.5, 40)
    gachaBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 255)
    gachaBtn.Text = "✨ SUMMON"
    gachaBtn.Font = Enum.Font.GothamBold
    gachaBtn.TextScaled = true
    gachaBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    gachaBtn.BorderSizePixel = 0
    gachaBtn.Parent = container

    local gachaCorner = Instance.new("UICorner")
    gachaCorner.CornerRadius = UDim.new(0, 15)
    gachaCorner.Parent = gachaBtn

    playBtn.MouseButton1Click:Connect(function()
        currentScreen = "ArenaSelect"
        container:Destroy()
        createArenaSelectScreen()
    end)

    gachaBtn.MouseButton1Click:Connect(function()
        currentScreen = "Gacha"
        container:Destroy()
        createGachaScreen()
    end)
end

-- ===== ARENA SELECTION SCREEN =====
function createArenaSelectScreen()
    local container = Instance.new("Frame")
    container.Name = "ArenaSelectScreen"
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
    container.BorderSizePixel = 0
    container.Parent = screenGui

    -- Back button
    local backBtn = Instance.new("TextButton")
    backBtn.Size = UDim2.new(0, 100, 0, 40)
    backBtn.Position = UDim2.new(0, 10, 0, 10)
    backBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    backBtn.Text = "← BACK"
    backBtn.Font = Enum.Font.GothamBold
    backBtn.TextSize = 14
    backBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    backBtn.BorderSizePixel = 0
    backBtn.Parent = container

    backBtn.MouseButton1Click:Connect(function()
        currentScreen = "Lobby"
        container:Destroy()
        createTitleScreen()
    end)

    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 60)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    title.Text = "⚙️ SELECT YOUR BATTLEFIELD ⚙️"
    title.Font = Enum.Font.GothamBold
    title.TextScaled = true
    title.TextColor3 = Color3.fromRGB(255, 200, 100)
    title.BorderSizePixel = 0
    title.Parent = container

    -- Arena scroll list
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, -40, 1, -140)
    scrollFrame.Position = UDim2.new(0, 20, 0, 80)
    scrollFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 10
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.Parent = container

    local layout = Instance.new("UIGridLayout")
    layout.CellSize = UDim2.new(0, 250, 0, 200)
    layout.CellPadding = UDim2.new(0, 20, 0, 20)
    layout.Parent = scrollFrame

    -- Create arena buttons
    local arenas = ArenaCatalog:GetAll()
    for _, arena in ipairs(arenas) do
        local arenaCard = Instance.new("TextButton")
        arenaCard.Size = UDim2.new(0, 250, 0, 200)
        arenaCard.BackgroundColor3 = Color3.fromRGB(50, 50, 100)
        arenaCard.Text = ""
        arenaCard.BorderSizePixel = 0
        arenaCard.Parent = scrollFrame

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 12)
        corner.Parent = arenaCard

        -- Arena name
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 0, 50)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = arena.Name
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextScaled = true
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.Parent = arenaCard

        -- Difficulty
        local diffLabel = Instance.new("TextLabel")
        diffLabel.Size = UDim2.new(1, 0, 0, 40)
        diffLabel.Position = UDim2.new(0, 0, 0, 60)
        diffLabel.BackgroundTransparency = 1
        diffLabel.Text = "Difficulty: " .. arena.Difficulty
        diffLabel.Font = Enum.Font.Gotham
        diffLabel.TextSize = 16
        diffLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        diffLabel.Parent = arenaCard

        -- Boss
        local bossLabel = Instance.new("TextLabel")
        bossLabel.Size = UDim2.new(1, 0, 0, 40)
        bossLabel.Position = UDim2.new(0, 0, 0, 100)
        bossLabel.BackgroundTransparency = 1
        bossLabel.Text = "Boss: " .. arena.Boss
        bossLabel.Font = Enum.Font.Gotham
        bossLabel.TextSize = 14
        bossLabel.TextColor3 = Color3.fromRGB(255, 150, 150)
        bossLabel.Parent = arenaCard

        arenaCard.MouseButton1Click:Connect(function()
            selectedArena = arena.Name
            selectArenaEvent:FireServer(arena.Name, selectedDifficulty, nil)
            container:Destroy()
            print("[CLIENT] Selected arena:", arena.Name)
        end)

        arenaCard.MouseEnter:Connect(function()
            arenaCard.BackgroundColor3 = Color3.fromRGB(80, 80, 150)
        end)

        arenaCard.MouseLeave:Connect(function()
            arenaCard.BackgroundColor3 = Color3.fromRGB(50, 50, 100)
        end)
    end
end

-- ===== GACHA SCREEN =====
function createGachaScreen()
    local container = Instance.new("Frame")
    container.Name = "GachaScreen"
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
    container.BorderSizePixel = 0
    container.Parent = screenGui

    -- Back button
    local backBtn = Instance.new("TextButton")
    backBtn.Size = UDim2.new(0, 100, 0, 40)
    backBtn.Position = UDim2.new(0, 10, 0, 10)
    backBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    backBtn.Text = "← BACK"
    backBtn.Font = Enum.Font.GothamBold
    backBtn.TextSize = 14
    backBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    backBtn.BorderSizePixel = 0
    backBtn.Parent = container

    backBtn.MouseButton1Click:Connect(function()
        currentScreen = "Lobby"
        container:Destroy()
        createTitleScreen()
    end)

    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 60)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    title.Text = "✨ SUMMON RARE ANIME UNITS ✨"
    title.Font = Enum.Font.GothamBold
    title.TextScaled = true
    title.TextColor3 = Color3.fromRGB(255, 200, 100)
    title.BorderSizePixel = 0
    title.Parent = container

    -- Pull once button
    local pullOnceBtn = Instance.new("TextButton")
    pullOnceBtn.Size = UDim2.new(0, 300, 0, 60)
    pullOnceBtn.Position = UDim2.new(0.5, -350, 0.5, -60)
    pullOnceBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    pullOnceBtn.Text = "🎯 SINGLE PULL (30 Gems)"
    pullOnceBtn.Font = Enum.Font.GothamBold
    pullOnceBtn.TextScaled = true
    pullOnceBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    pullOnceBtn.BorderSizePixel = 0
    pullOnceBtn.Parent = container

    local pullOnceCorner = Instance.new("UICorner")
    pullOnceCorner.CornerRadius = UDim.new(0, 15)
    pullOnceCorner.Parent = pullOnceBtn

    -- Pull 10x button
    local pullTenBtn = Instance.new("TextButton")
    pullTenBtn.Size = UDim2.new(0, 300, 0, 60)
    pullTenBtn.Position = UDim2.new(0.5, 50, 0.5, -60)
    pullTenBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 100)
    pullTenBtn.Text = "🎊 10x SUMMON (300 Gems)"
    pullTenBtn.Font = Enum.Font.GothamBold
    pullTenBtn.TextScaled = true
    pullTenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    pullTenBtn.BorderSizePixel = 0
    pullTenBtn.Parent = container

    local pullTenCorner = Instance.new("UICorner")
    pullTenCorner.CornerRadius = UDim.new(0, 15)
    pullTenCorner.Parent = pullTenBtn

    pullOnceBtn.MouseButton1Click:Connect(function()
        pullGachaEvent:FireServer("StandardBanner", 1)
        print("[CLIENT] Pulled 1x")
    end)

    pullTenBtn.MouseButton1Click:Connect(function()
        pullGachaEvent:FireServer("StandardBanner", 10)
        print("[CLIENT] Pulled 10x")
    end)
end

-- ===== INITIALIZE =====
print("[CLIENT] Lobby UI loaded")
createT itleScreen()

gameStateEvent.OnClientEvent:Connect(function(state)
    print("[CLIENT] Received game state update")
end)
