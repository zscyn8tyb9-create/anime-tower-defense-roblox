-- ReplicatedStorage/Shared/AnimeTD/UnitCatalog.lua
local UnitCatalog = {
    Units = {},
}

local prefixNames = {
    "Aiko", "Ren", "Sora", "Hana", "Kaito", "Mika", "Yori", "Akari", "Shin", "Nami",
    "Haru", "Yuna", "Kaori", "Daisuke", "Rin", "Saki", "Taiga", "Mio", "Rei", "Kenta",
    "Noa", "Riku", "Yui", "Rinzo", "Ichika", "Kiseki", "Emi", "Tsubasa", "Ayaka", "Kazuo",
    "Minori", "Goro", "Hikari", "Shiori", "Kuro", "Natsumi", "Maya", "Kenji", "Yuka", "Aoi",
    "Jun", "Seika", "Tomoe", "Ryo", "Hinata", "Kou", "Fuka", "Kei", "Zane", "Airi",
    "Kenshin", "Michi", "Ai", "Jin", "Anya", "Toma", "Setsuna", "Kazumi", "Hoshiko", "Takumi",
    "Nuriko", "Sae", "Masato", "Kaede", "Keito", "Shizuka", "Rai", "Yumiko", "Daichi", "Nero",
    "Aria", "Hoshin", "Karin", "Fumi", "Makoto", "Shou", "Aoiro", "Kanon", "Mizuki", "Koharu",
    "Tatsu", "Nagi", "Chika", "Eiko", "Roki", "Asuka", "Momo", "Sorae", "Rinon", "Yao",
    "Mina", "Kurohane", "Kiba", "Luna", "Kazane", "Sei", "Neroi", "Rinran", "Atsu", "Towa",
    "Kumi", "Rhea", "Kaya", "Sorah", "Kyra", "Hoshinai", "Yamato", "Kisara", "Aoiya", "Tamaki",
    "Atsumi", "Rinka", "Tora", "Ion", "Fuyumi", "Shinra", "Kokoro", "Mikoto", "Nanami", "Shinyo"
}

local roles = {"Damage", "Support", "Tank", "Control", "Burst", "Utility"}
local elements = {"Flame", "Frost", "Wind", "Shadow", "Light", "Storm", "Void", "Nature", "Thunder", "Arcane"}
local rarities = {"Common", "Rare", "Epic", "Legendary", "Mythic"}

for index, name in ipairs(prefixNames) do
    local roleIndex = (index % #roles) + 1
    local elementIndex = (index % #elements) + 1
    local rarityIndex = (index % #rarities) + 1
    local tier = index

    table.insert(UnitCatalog.Units, {
        Id = index,
        Name = name,
        Role = roles[roleIndex],
        Element = elements[elementIndex],
        Rarity = rarities[rarityIndex],
        Cost = 120 + (index * 7),
        Range = 20 + (index % 8) * 6,
        Damage = 12 + (index % 12) * 6,
        AttackSpeed = 0.6 + ((index % 10) * 0.08),
        UnlockWave = 1 + math.floor(index / 6),
        Ability = string.format("%s Burst %d", elements[elementIndex], (index % 5) + 1),
        Flavor = string.format("An anime striker forged in %s energy.", elements[elementIndex]),
        Tier = tier,
        Passive = "None",
        IsLegendary = rarityIndex == #rarities,
    })
end

function UnitCatalog:GetAll()
    return self.Units
end

function UnitCatalog:GetByRole(role)
    local results = {}
    for _, unit in ipairs(self.Units) do
        if unit.Role == role then
            table.insert(results, unit)
        end
    end
    return results
end

function UnitCatalog:GetByElement(element)
    local results = {}
    for _, unit in ipairs(self.Units) do
        if unit.Element == element then
            table.insert(results, unit)
        end
    end
    return results
end

function UnitCatalog:GetByRarity(rarity)
    local results = {}
    for _, unit in ipairs(self.Units) do
        if unit.Rarity == rarity then
            table.insert(results, unit)
        end
    end
    return results
end

function UnitCatalog:GetCount()
    return #self.Units
end

return UnitCatalog

-- This catalog intentionally exceeds 100 entries to meet the expansion goal.
-- It is intended to be used as a data source for tower unlock pools, gacha banners, and summon systems.
