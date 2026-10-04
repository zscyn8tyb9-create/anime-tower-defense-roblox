-- ReplicatedStorage/Shared/AnimeTD/GachaSystem.lua
local GachaSystem = {}

local banners = {
    StandardBanner = {
        Name = "Standard Summon",
        Cost = 30,
        FiveStarRate = 0.06,
        FourStarRate = 0.10,
        Description = "Standard anime unit summon. Guaranteed 4+ star every 10 pulls.",
        PityCounter = 80,
        GuaranteedFiftyFifty = true,
    },
    LimitedBanner = {
        Name = "Anime Chronicles",
        Cost = 30,
        FiveStarRate = 0.10,
        FourStarRate = 0.15,
        Description = "Limited summon featuring exclusive 5-star anime units.",
        PityCounter = 80,
        GuaranteedFiveStar = true,
    },
    WeaponBanner = {
        Name = "Divine Armory",
        Cost = 30,
        FiveStarWeaponRate = 0.07,
        FourStarWeaponRate = 0.12,
        Description = "Summon powerful weapons and relics to boost your units.",
        PityCounter = 80,
    },
    ChroniclesBanner = {
        Name = "Echoes of Time",
        Cost = 30,
        FiveStarRate = 0.08,
        FourStarRate = 0.13,
        Description = "Rerun limited summon featuring previously released 5-star units.",
        PityCounter = 80,
    },
}

local rarityWeights = {
    FiveStar = { Min = 96, Max = 100 },
    FourStar = { Min = 86, Max = 95 },
    ThreeStar = { Min = 0, Max = 85 },
}

function GachaSystem:GetBanners()
    return banners
end

function GachaSystem:PullOnce(bannerName, unitCatalog)
    local banner = banners[bannerName]
    if not banner then return nil end

    local roll = math.random(1, 100)
    local rarity = "ThreeStar"

    if roll >= rarityWeights.FiveStar.Min then
        rarity = "FiveStar"
    elseif roll >= rarityWeights.FourStar.Min then
        rarity = "FourStar"
    end

    if unitCatalog then
        local unitsByRarity = unitCatalog:GetByRarity(rarity)
        if #unitsByRarity > 0 then
            return unitsByRarity[math.random(1, #unitsByRarity)]
        end
    end

    return {
        Name = rarity .. " Unit",
        Rarity = rarity,
        Cost = banner.Cost,
    }
end

function GachaSystem:PullTen(bannerName, unitCatalog)
    local results = {}
    for i = 1, 10 do
        local unit = self:PullOnce(bannerName, unitCatalog)
        table.insert(results, unit)
    end
    return results
end

function GachaSystem:CalculatePity(pullCount, guaranteedCounter)
    if pullCount >= 80 then
        return true
    elseif guaranteedCounter and guaranteedCounter >= 160 then
        return true
    end
    return false
end

return GachaSystem
