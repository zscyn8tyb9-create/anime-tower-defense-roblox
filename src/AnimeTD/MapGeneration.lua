-- ReplicatedStorage/Shared/AnimeTD/MapGeneration.lua
local MapGeneration = {}

local arenaTemplates = {
    {
        Name = "Crimson Shrine",
        PathLength = 14,
        TowerZones = 8,
        Theme = "ancient_temple",
        Waypoints = {
            Vector3.new(-120, 3, 0),
            Vector3.new(-80, 3, 30),
            Vector3.new(-30, 3, 35),
            Vector3.new(20, 3, 5),
            Vector3.new(80, 3, 15),
            Vector3.new(120, 3, -40),
            Vector3.new(170, 3, -80),
            Vector3.new(200, 3, -20),
            Vector3.new(150, 3, 70),
            Vector3.new(80, 3, 110),
            Vector3.new(10, 3, 120),
            Vector3.new(-60, 3, 90),
            Vector3.new(-120, 3, 35),
            Vector3.new(-170, 3, -20),
        },
        ZonePositions = {
            Vector3.new(-70, 3, 30),
            Vector3.new(-20, 3, 50),
            Vector3.new(35, 3, 45),
            Vector3.new(100, 3, 15),
            Vector3.new(160, 3, -55),
            Vector3.new(120, 3, 80),
            Vector3.new(20, 3, 100),
            Vector3.new(-95, 3, 75),
        },
    },
    {
        Name = "Moonlit Lake",
        PathLength = 12,
        TowerZones = 7,
        Theme = "lake_night",
        Waypoints = {
            Vector3.new(-150, 5, -50),
            Vector3.new(-100, 5, -30),
            Vector3.new(-50, 5, 0),
            Vector3.new(0, 5, 50),
            Vector3.new(50, 5, 80),
            Vector3.new(100, 5, 60),
            Vector3.new(150, 5, 20),
            Vector3.new(120, 5, -60),
            Vector3.new(60, 5, -100),
            Vector3.new(-20, 5, -80),
            Vector3.new(-100, 5, -50),
            Vector3.new(-150, 5, -80),
        },
        ZonePositions = {
            Vector3.new(-100, 5, 20),
            Vector3.new(-30, 5, 40),
            Vector3.new(40, 5, 60),
            Vector3.new(120, 5, 40),
            Vector3.new(130, 5, -40),
            Vector3.new(50, 5, -90),
            Vector3.new(-50, 5, -100),
        },
    },
}

function MapGeneration:GetTemplate(arenaName)
    for _, template in ipairs(arenaTemplates) do
        if template.Name == arenaName then
            return template
        end
    end
    return arenaTemplates[1]
end

function MapGeneration:GenerateArena(template, parent)
    local arena = Instance.new("Folder")
    arena.Name = template.Name
    arena.Parent = parent

    -- Create path markers
    local pathFolder = Instance.new("Folder")
    pathFolder.Name = "Path"
    pathFolder.Parent = arena

    for i, waypoint in ipairs(template.Waypoints) do
        local marker = Instance.new("Part")
        marker.Name = "Waypoint" .. i
        marker.Anchored = true
        marker.CanCollide = false
        marker.Transparency = 0.6
        marker.Material = Enum.Material.Neon
        marker.Size = Vector3.new(4, 1, 4)
        marker.Position = waypoint
        marker.Color = Color3.fromRGB(255, 220, 100)
        marker.Parent = pathFolder
    end

    -- Create tower zones
    local zoneFolder = Instance.new("Folder")
    zoneFolder.Name = "TowerZones"
    zoneFolder.Parent = arena

    for i, position in ipairs(template.ZonePositions) do
        local zone = Instance.new("Part")
        zone.Name = "Zone" .. i
        zone.Size = Vector3.new(18, 1, 18)
        zone.Position = position
        zone.Anchored = true
        zone.Color = Color3.fromRGB(80, 120, 255)
        zone.Material = Enum.Material.SmoothPlastic
        zone.Transparency = 0.45
        zone.CanCollide = false
        zone.Parent = zoneFolder
    end

    -- Create base floor
    local base = Instance.new("Part")
    base.Name = "Base"
    base.Size = Vector3.new(500, 1, 500)
    base.Position = Vector3.new(0, 0, 0)
    base.Anchored = true
    base.Color = Color3.fromRGB(50, 60, 80)
    base.Material = Enum.Material.Brick
    base.CanCollide = true
    base.Parent = arena

    return arena
end

return MapGeneration
