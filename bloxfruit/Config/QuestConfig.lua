-- [[ Blox Fruits: Master Quest Configuration (Sea 1, 2, 3) - Updated to Level 2600 ]] --
local QuestConfig = {
    -- ==================== SEA 1 ====================
    [1] = {
        { MinLevel = 1, MaxLevel = 9, MobName = "Bandit", QuestName = "BanditQuest1", NPCSpawn = Vector3.new(1059.3, 16.3, 1549.9) },
        { MinLevel = 10, MaxLevel = 14, MobName = "Monkey", QuestName = "JungleQuest", NPCSpawn = Vector3.new(-1598.1, 36.7, 153.7) },
        { MinLevel = 15, MaxLevel = 29, MobName = "Gorilla", QuestName = "JungleQuest2", NPCSpawn = Vector3.new(-1598.1, 36.7, 153.7) },
        { MinLevel = 30, MaxLevel = 39, MobName = "Pirate", QuestName = "PirateQuest", NPCSpawn = Vector3.new(-1140.1, 4.8, 3828.5) },
        { MinLevel = 40, MaxLevel = 59, MobName = "Brute", QuestName = "PirateQuest2", NPCSpawn = Vector3.new(-1140.1, 4.8, 3828.5) },
        { MinLevel = 60, MaxLevel = 89, MobName = "Desert Bandit", QuestName = "DesertQuest", NPCSpawn = Vector3.new(896.8, 6.5, 4390.3) },
        { MinLevel = 90, MaxLevel = 99, MobName = "Snow Bandit", QuestName = "SnowQuest", NPCSpawn = Vector3.new(1389.7, 87.3, -1298.8) },
        { MinLevel = 100, MaxLevel = 119, MobName = "Snowman", QuestName = "SnowQuest2", NPCSpawn = Vector3.new(1389.7, 87.3, -1298.8) },
        { MinLevel = 120, MaxLevel = 149, MobName = "Chief Petty Officer", QuestName = "MarineQuest", NPCSpawn = Vector3.new(-5035.8, 20.6, 4324.7) },
        { MinLevel = 150, MaxLevel = 174, MobName = "Sky Bandit", QuestName = "SkyQuest", NPCSpawn = Vector3.new(-4842.2, 717.7, -2623.4) },
        { MinLevel = 175, MaxLevel = 189, MobName = "Dark Master", QuestName = "SkyQuest2", NPCSpawn = Vector3.new(-5202.4, 434.0, -2254.3) },
        { MinLevel = 190, MaxLevel = 209, MobName = "Prisoner", QuestName = "PrisonQuest", NPCSpawn = Vector3.new(5308.9, 1.7, 474.9) },
        { MinLevel = 210, MaxLevel = 249, MobName = "Dangerous Prisoner", QuestName = "PrisonQuest2", NPCSpawn = Vector3.new(5308.9, 1.7, 474.9) },
        { MinLevel = 250, MaxLevel = 274, MobName = "Toga Warrior", QuestName = "ColosseumQuest", NPCSpawn = Vector3.new(-1580.4, 7.3, -2985.1) },
        { MinLevel = 275, MaxLevel = 299, MobName = "Military Soldier", QuestName = "MagmaQuest", NPCSpawn = Vector3.new(-5315.8, 12.3, 8515.5) },
        { MinLevel = 300, MaxLevel = 374, MobName = "Military Spy", QuestName = "MagmaQuest2", NPCSpawn = Vector3.new(-5315.8, 12.3, 8515.5) },
        { MinLevel = 375, MaxLevel = 399, MobName = "Fishman Warrior", QuestName = "FishmanQuest", NPCSpawn = Vector3.new(61122.9, 18.5, 1568.5) },
        { MinLevel = 400, MaxLevel = 449, MobName = "Fishman Commando", QuestName = "FishmanQuest2", NPCSpawn = Vector3.new(61122.9, 18.5, 1568.5) },
        { MinLevel = 450, MaxLevel = 474, MobName = "God's Guard", QuestName = "SkyExp1Quest", NPCSpawn = Vector3.new(-7862.8, 5545.5, -380.2) },
        { MinLevel = 475, MaxLevel = 524, MobName = "Shanda", QuestName = "SkyExp1Quest2", NPCSpawn = Vector3.new(-7862.8, 5545.5, -380.2) },
        { MinLevel = 525, MaxLevel = 549, MobName = "Royal Squad", QuestName = "SkyExp2Quest", NPCSpawn = Vector3.new(-7903.8, 5635.8, -1412.1) },
        { MinLevel = 550, MaxLevel = 624, MobName = "Royal Soldier", QuestName = "SkyExp2Quest2", NPCSpawn = Vector3.new(-7903.8, 5635.8, -1412.1) },
        { MinLevel = 625, MaxLevel = 700, MobName = "Galley Pirate", QuestName = "FountainQuest", NPCSpawn = Vector3.new(5259.8, 38.6, 4050.2) },
    },

    -- ==================== SEA 2 ====================
    [2] = {
        { MinLevel = 700, MaxLevel = 724, MobName = "Raider", QuestName = "Area1Quest", NPCSpawn = Vector3.new(-424.1, 72.9, 1835.8) },
        { MinLevel = 725, MaxLevel = 749, MobName = "Mercenary", QuestName = "Area1Quest2", NPCSpawn = Vector3.new(-424.1, 72.9, 1835.8) },
        { MinLevel = 750, MaxLevel = 774, MobName = "Swan Pirate", QuestName = "Area2Quest", NPCSpawn = Vector3.new(635.6, 73.1, 918.5) },
        { MinLevel = 775, MaxLevel = 799, MobName = "Factory Staff", QuestName = "Area2Quest2", NPCSpawn = Vector3.new(635.6, 73.1, 918.5) },
        { MinLevel = 800, MaxLevel = 824, MobName = "Marine Lieutenant", QuestName = "MarineQuest3", NPCSpawn = Vector3.new(-2442.8, 73.0, -3215.1) },
        { MinLevel = 825, MaxLevel = 849, MobName = "Marine Captain", QuestName = "MarineQuest3_2", NPCSpawn = Vector3.new(-2442.8, 73.0, -3215.1) },
        { MinLevel = 850, MaxLevel = 874, MobName = "Zombie", QuestName = "ZombieQuest", NPCSpawn = Vector3.new(-5497.1, 48.0, -794.9) },
        { MinLevel = 875, MaxLevel = 899, MobName = "Vampire", QuestName = "ZombieQuest2", NPCSpawn = Vector3.new(-5497.1, 48.0, -794.9) },
        { MinLevel = 900, MaxLevel = 949, MobName = "Snow Trooper", QuestName = "SnowMountainQuest", NPCSpawn = Vector3.new(602.5, 402.1, -5354.2) },
        { MinLevel = 950, MaxLevel = 999, MobName = "Winter Warrior", QuestName = "SnowMountainQuest2", NPCSpawn = Vector3.new(602.5, 402.1, -5354.2) },
        { MinLevel = 1000, MaxLevel = 1049, MobName = "Lava Pirate", QuestName = "IceSideQuest", NPCSpawn = Vector3.new(-5428.1, 16.3, -5295.5) },
        { MinLevel = 1050, MaxLevel = 1099, MobName = "Magma Ninja", QuestName = "IceSideQuest2", NPCSpawn = Vector3.new(-5428.1, 16.3, -5295.5) },
        { MinLevel = 1100, MaxLevel = 1149, MobName = "Ship Deckhand", QuestName = "ShipQuest", NPCSpawn = Vector3.new(1038.0, 125.1, 32912.5) },
        { MinLevel = 1150, MaxLevel = 1199, MobName = "Ship Engineer", QuestName = "ShipQuest2", NPCSpawn = Vector3.new(1038.0, 125.1, 32912.5) },
        { MinLevel = 1200, MaxLevel = 1249, MobName = "Snow Lurker", QuestName = "FrostQuest", NPCSpawn = Vector3.new(5669.6, 28.1, -6486.2) },
        { MinLevel = 1250, MaxLevel = 1299, MobName = "Arctic Warrior", QuestName = "FrostQuest2", NPCSpawn = Vector3.new(5669.6, 28.1, -6486.2) },
        { MinLevel = 1300, MaxLevel = 1349, MobName = "Sea Soldier", QuestName = "ForgottenQuest", NPCSpawn = Vector3.new(-3054.5, 237.6, -10145.2) },
        { MinLevel = 1350, MaxLevel = 1499, MobName = "Water Fighter", QuestName = "ForgottenQuest2", NPCSpawn = Vector3.new(-3054.5, 237.6, -10145.2) },
    },

    -- ==================== SEA 3 ====================
    [3] = {
        { MinLevel = 1500, MaxLevel = 1524, MobName = "Pirate Millionaire", QuestName = "PortTownQuest", NPCSpawn = Vector3.new(-290.1, 43.8, 5581.5) },
        { MinLevel = 1525, MaxLevel = 1574, MobName = "Pistol Billionaire", QuestName = "PortTownQuest2", NPCSpawn = Vector3.new(-290.1, 43.8, 5581.5) },
        { MinLevel = 1575, MaxLevel = 1624, MobName = "Dragon Crew Warrior", QuestName = "HydraQuest", NPCSpawn = Vector3.new(5243.8, 11.6, 335.8) },
        { MinLevel = 1625, MaxLevel = 1649, MobName = "Dragon Crew Archer", QuestName = "HydraQuest2", NPCSpawn = Vector3.new(5243.8, 11.6, 335.8) },
        { MinLevel = 1650, MaxLevel = 1699, MobName = "Hydra Enforcer", QuestName = "HydraQuest3", NPCSpawn = Vector3.new(5243.8, 11.6, 335.8) },
        { MinLevel = 1700, MaxLevel = 1724, MobName = "Marine Lieutenant", QuestName = "GreatTreeQuest", NPCSpawn = Vector3.new(2337.8, 24.8, -6701.5) },
        { MinLevel = 1725, MaxLevel = 1774, MobName = "Marine Commodore", QuestName = "GreatTreeQuest2", NPCSpawn = Vector3.new(2337.8, 24.8, -6701.5) },
        { MinLevel = 1775, MaxLevel = 1799, MobName = "Fishman Raider", QuestName = "TurtleQuest", NPCSpawn = Vector3.new(-12470.2, 331.7, -7551.9) },
        { MinLevel = 1800, MaxLevel = 1849, MobName = "Forest Pirate", QuestName = "TurtleQuest2", NPCSpawn = Vector3.new(-12470.2, 331.7, -7551.9) },
        { MinLevel = 1850, MaxLevel = 1899, MobName = "Mythological Pirate", QuestName = "MojoQuest", NPCSpawn = Vector3.new(-12470.2, 331.7, -7551.9) },
        { MinLevel = 1900, MaxLevel = 1974, MobName = "Musketeer Pirate", QuestName = "MojoQuest2", NPCSpawn = Vector3.new(-12470.2, 331.7, -7551.9) },
        { MinLevel = 1975, MaxLevel = 2024, MobName = "Reborn Skeleton", QuestName = "HauntedQuest", NPCSpawn = Vector3.new(-9516.9, 172.1, 6078.6) },
        { MinLevel = 2025, MaxLevel = 2074, MobName = "Living Zombie", QuestName = "HauntedQuest2", NPCSpawn = Vector3.new(-9516.9, 172.1, 6078.6) },
        { MinLevel = 2075, MaxLevel = 2124, MobName = "Demonic Soul", QuestName = "HauntedQuest3", NPCSpawn = Vector3.new(-9516.9, 172.1, 6078.6) },
        { MinLevel = 2125, MaxLevel = 2224, MobName = "Posessed Mummy", QuestName = "HauntedQuest4", NPCSpawn = Vector3.new(-9516.9, 172.1, 6078.6) },
        { MinLevel = 2230, MaxLevel = 2274, MobName = "Ice Cream Chef", QuestName = "IceCreamQuest", NPCSpawn = Vector3.new(-802.1, 62.7, -10963.2) },
        { MinLevel = 2275, MaxLevel = 2324, MobName = "Ice Cream Commander", QuestName = "IceCreamQuest2", NPCSpawn = Vector3.new(-802.1, 62.7, -10963.2) },
        { MinLevel = 2325, MaxLevel = 2374, MobName = "Cocoa Warrior", QuestName = "CakeQuest", NPCSpawn = Vector3.new(215.3, 23.6, -12599.1) },
        { MinLevel = 2375, MaxLevel = 2424, MobName = "Chocolate Bar Battler", QuestName = "CakeQuest2", NPCSpawn = Vector3.new(215.3, 23.6, -12599.1) },
        { MinLevel = 2425, MaxLevel = 2449, MobName = "Sweet Thug", QuestName = "CakeQuest3", NPCSpawn = Vector3.new(215.3, 23.6, -12599.1) },
        { MinLevel = 2450, MaxLevel = 2549, MobName = "Head Baker", QuestName = "CakeQuest4", NPCSpawn = Vector3.new(215.3, 23.6, -12599.1) },
        { MinLevel = 2550, MaxLevel = 2600, MobName = "Isle Outlaw", QuestName = "TikiQuest1", NPCSpawn = Vector3.new(-16515.5, 54.3, 502.1) }
    }
}

return QuestConfig
