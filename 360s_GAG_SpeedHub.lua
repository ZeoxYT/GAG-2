--[[
=====================================================================
   360's GAG   -   Grow a Garden 2 hub
   UI: Speed Hub X 5.0 Modified Library (black/red theme)
   Right-click the script button to toggle UI.  Hub.unload() fully unloads.
=====================================================================
]]

--========================== SERVICES ==============================--
local Players          = game:GetService("Players")
local ReplicatedStorage= game:GetService("ReplicatedStorage")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local CollectionService= game:GetService("CollectionService")
local Workspace        = game:GetService("Workspace")
local LocalPlayer      = Players.LocalPlayer

--========================== GAME API ==============================--
local Net = (function() local ok,m = pcall(function() return require(ReplicatedStorage.SharedModules.Networking) end) return ok and m or nil end)()
local PSC = (function() local ok,m = pcall(function() return require(ReplicatedStorage.ClientModules.PlayerStateClient) end) return ok and m or nil end)()
if not Net then warn("[360's GAG] Networking module missing - aborting."); return end

local SeedData = (function() local ok,d = pcall(function() return require(ReplicatedStorage.SharedModules.SeedData) end) return ok and d or {} end)()
local SeedPrice = {}
for _, e in ipairs(SeedData) do
    if type(e) == "table" and e.SeedName then SeedPrice[e.SeedName] = tonumber(e.PurchasePrice) or math.huge end
end
local FruitValueCalc = (function() local ok,m = pcall(function() return require(ReplicatedStorage.SharedModules.FruitValueCalc) end) return (ok and type(m) == "function") and m or nil end)()
local SeedBaseValue = {}
if FruitValueCalc then
    for _, e in ipairs(SeedData) do
        if type(e) == "table" and e.SeedName then
            local ok, v = pcall(FruitValueCalc, e.SeedName, 1, nil, LocalPlayer, nil)
            SeedBaseValue[e.SeedName] = (ok and type(v) == "number") and v or 0
        end
    end
end
local MUT_BONUS = 2.35
local SIZE_EXP  = 2.65
local function sizeMul(sz) sz = tonumber(sz) or 1 return sz ^ SIZE_EXP end
local PetData = (function() local ok,m = pcall(function() return require(ReplicatedStorage.SharedData.PetData) end) return ok and m or {} end)()
local function getAnimalOptions()
    local list = {}
    for k, v in pairs(PetData) do if type(v) == "table" and type(k) == "string" then list[#list + 1] = k end end
    table.sort(list); return list
end

--========================== LIFECYCLE =============================--
local Hub = { running = true, conns = {} }
local genv = (getgenv and getgenv()) or _G
if genv.GAG360_unload then pcall(genv.GAG360_unload) end
local function track(conn) table.insert(Hub.conns, conn); return conn end
local function spawnLoop(interval, fn)
    task.spawn(function()
        while Hub.running do
            task.wait(interval)
            if not Hub.running then break end
            pcall(fn)
        end
    end)
end

--========================== STATE =================================--
local S = {
    autoBuySeed = false, buySeeds = {},
    autoPlant = false, plantSeeds = {}, plantReserve = 0, maxPerCycle = 40, plantDelay = 0.14, plantLoop = 1.2, smartReplant = false, autoExpand = false,
    plantPattern = "Fill", plantSource = "My Seeds", autoBuild = false, removeCrops = {},
    autoCollect = false, harvestCrops = {}, harvestMutsOnly = false, perFruitDelay = 0.05, harvestLoop = 1,
    autoSell = false, sellInterval = 20, sellOnFull = false,
    autoSteal = false, stealReturn = true, stealMult = 1,
    panicHarvest = false, retaliate = false,
    autoGrabPacks = false, grabRareOnly = true, packReturn = true, notifyRare = true,
    autoBuyGear = false, buyGears = {}, autoBuyCrate = false,
    autoEggs = false, autoCrates = false, autoPacks = false,
    autoTame = false, tameAnimals = {}, autoEquipPets = false, equipPets = {},
    walkSpeed = 16, jumpPower = 50, infJump = false, noclip = false, fly = false, flySpeed = 60,
    antiAfk = true, optimize = false, autoProgress = false,
    highlightReady = false, highlightRare = false, rareNotify = false,
    webhookUrl = "", whRareSeed = false, whBigHarvest = false, autoHopRare = false,
}

local SAVE_FILE = "360_GAG_GrowAGarden2.json"
local HttpService = game:GetService("HttpService")
local function saveSettings()
    if not writefile then return end
    pcall(function() writefile(SAVE_FILE, HttpService:JSONEncode(S)) end)
end
local function loadSettings()
    if not (readfile and isfile) then return end
    local ok, raw = pcall(function() return isfile(SAVE_FILE) and readfile(SAVE_FILE) or nil end)
    if not (ok and raw) then return end
    local good, data = pcall(function() return HttpService:JSONDecode(raw) end)
    if not (good and type(data) == "table") then return end
    for k, v in pairs(data) do
        if S[k] ~= nil then
            if type(S[k]) == "table" and type(v) == "table" then
                table.clear(S[k]); for kk, vv in pairs(v) do S[k][kk] = vv end
            elseif type(S[k]) == type(v) then
                S[k] = v
            end
        end
    end
end
loadSettings()

--========================== HELPERS ===============================--
local function getReplica() if not PSC then return nil end local ok,r = pcall(function() return PSC:GetLocalReplica() end) return ok and r or nil end
local function getData()    local r = getReplica() return r and r.Data or nil end
local function getSheckles() local d = getData() return d and d.Sheckles or 0 end
local function myPlot()
    local g = Workspace:FindFirstChild("Gardens"); if not g then return nil end
    for _, plot in ipairs(g:GetChildren()) do if plot:GetAttribute("OwnerUserId") == LocalPlayer.UserId then return plot end end
end
local function isNight() local n = ReplicatedStorage:FindFirstChild("Night") return n and n.Value == true end
local function char()     return LocalPlayer.Character end
local function hrp()      local c = char() return c and c:FindFirstChild("HumanoidRootPart") end
local function humanoid() local c = char() return c and c:FindFirstChildOfClass("Humanoid") end
local function fire(pkt, ...) local a = {...} return pcall(function() return pkt:Fire(table.unpack(a)) end) end
local function setCharCollide(on)
    local c = char(); if not c then return end
    for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then pcall(function() p.CanCollide = on end) end end
end
local HOP = 70
local function reach(pos)
    local r = hrp(); if not (r and pos) then return end
    local target = pos + Vector3.new(0, 3, 0)
    setCharCollide(false)
    for _ = 1, 60 do
        local cur = r.Position; local delta = target - cur
        if delta.Magnitude <= HOP then r.CFrame = CFrame.new(target); break end
        r.CFrame = CFrame.new(cur + delta.Unit * HOP); RunService.Heartbeat:Wait()
    end
    if not S.noclip then setCharCollide(true) end
end
local function fruitValue(m)
    local base = SeedBaseValue[m:GetAttribute("CorePartName") or m:GetAttribute("SeedName")] or 0
    return base * sizeMul(m:GetAttribute("SizeMulti") or 1) * (m:GetAttribute("Mutation") and MUT_BONUS or 1)
end
local function modelRipe(m)
    local age = tonumber(m:GetAttribute("Age")); local mx = tonumber(m:GetAttribute("MaxAge"))
    if age and mx then return age >= mx - 0.001 end
    for _, d in ipairs(m:GetDescendants()) do
        if d:IsA("ProximityPrompt") and CollectionService:HasTag(d, "HarvestPrompt") then return true end
    end
    return false
end
local function ownHarvestTargets(respectFilter)
    local useCrop = respectFilter and next(S.harvestCrops) ~= nil
    local out = {}
    local plot = myPlot(); if not plot then return out end
    local plants = plot:FindFirstChild("Plants"); if not plants then return out end
    local function consider(m)
        if not m:GetAttribute("PlantId") then return end
        local crop = m:GetAttribute("CorePartName") or m:GetAttribute("SeedName")
        local mutOk = (not respectFilter) or (not S.harvestMutsOnly) or (m:GetAttribute("Mutation") ~= nil)
        if ((not useCrop) or (crop and S.harvestCrops[crop] == true)) and mutOk then out[#out + 1] = m end
    end
    for _, plant in ipairs(plants:GetChildren()) do
        local fr = plant:FindFirstChild("Fruits")
        local fruits = fr and fr:GetChildren() or {}
        if #fruits > 0 then
            for _, m in ipairs(fruits) do if modelRipe(m) then consider(m) end end
        elseif modelRipe(plant) then
            consider(plant)
        end
    end
    return out
end
local function stealTargets()
    local out = {}
    for _, p in ipairs(CollectionService:GetTagged("StealPrompt")) do
        local m = p.Parent and p.Parent:FindFirstAncestorWhichIsA("Model")
        if m then
            local uid = tonumber(m:GetAttribute("UserId"))
            if uid and uid ~= LocalPlayer.UserId and m:GetAttribute("PlantId") then out[#out + 1] = { model = m, value = fruitValue(m) } end
        end
    end
    table.sort(out, function(a, b) return a.value > b.value end)
    return out
end
local function harvestAll(respectFilter)
    local plot = myPlot(); local ref = plot and plot:FindFirstChild("PlotSizeReference"); local r = hrp()
    if ref and r and (Vector3.new(r.Position.X,0,r.Position.Z) - Vector3.new(ref.Position.X,0,ref.Position.Z)).Magnitude > 16 then
        reach(ref.Position); task.wait(0.12)
    end
    local t = ownHarvestTargets(respectFilter); local n = 0
    for _, m in ipairs(t) do
        local pid = m:GetAttribute("PlantId")
        if pid then fire(Net.Garden.CollectFruit, pid, m:GetAttribute("FruitId") or ""); n = n + 1; task.wait(S.perFruitDelay) end
    end
    return n
end
local function stealModel(m, mult, skipReach)
    if not m or not m.Parent then return end
    local uid = tonumber(m:GetAttribute("UserId")); local pid = m:GetAttribute("PlantId")
    if not (uid and pid) then return end
    if not skipReach then reach(m:GetPivot().Position); task.wait(0.05) end
    fire(Net.Steal.BeginSteal, uid, pid, m:GetAttribute("FruitId") or "")
    for _ = 1, math.max(1, mult or 1) do fire(Net.Steal.CompleteSteal) end
end
local function stockItems(shop)
    local sv = ReplicatedStorage:FindFirstChild("StockValues"); sv = sv and sv:FindFirstChild(shop)
    return sv and sv:FindFirstChild("Items")
end
local function seedStockItems() return stockItems("SeedShop") end
local function gearStockItems() return stockItems("GearShop") end
local function stockOf(shop, name) local it = stockItems(shop); local v = it and it:FindFirstChild(name) return (v and v:IsA("ValueBase")) and v.Value or 0 end
local function seedStockOf(name) return stockOf("SeedShop", name) end
local function gearStockOf(name) return stockOf("GearShop", name) end
local function getGearOptions()
    local it = gearStockItems(); local list = {}
    if it then for _, sv in ipairs(it:GetChildren()) do list[#list + 1] = sv.Name end end
    table.sort(list); return list
end
local function getSeedOptions()
    local seen = {}
    for _, e in ipairs(SeedData) do if e.SeedName then seen[e.SeedName] = tonumber(e.SeedShopDisplayOrder) or 900 end end
    local it = seedStockItems(); if it then for _, sv in ipairs(it:GetChildren()) do if seen[sv.Name] == nil then seen[sv.Name] = 899 end end end
    local list = {} for name, ord in pairs(seen) do list[#list + 1] = { name, ord } end
    table.sort(list, function(a, b) if a[2] == b[2] then return a[1] < b[1] end return a[2] < b[2] end)
    local names = {} for _, x in ipairs(list) do names[#names + 1] = x[1] end
    return names
end
local function getOwnedSeedOptions()
    local d = getData(); local order = {}
    for _, e in ipairs(SeedData) do if e.SeedName then order[e.SeedName] = tonumber(e.SeedShopDisplayOrder) or 900 end end
    local list = {}
    if d and d.Inventory and d.Inventory.Seeds then
        for n, c in pairs(d.Inventory.Seeds) do if (c or 0) > 0 then list[#list + 1] = n end end
    end
    table.sort(list, function(a, b) local oa, ob = order[a] or 900, order[b] or 900 if oa == ob then return a < b end return oa < ob end)
    return list
end
local function getPlantedOptions()
    local plot = myPlot(); local seen = {}
    if plot then local plants = plot:FindFirstChild("Plants")
        if plants then for _, pl in ipairs(plants:GetChildren()) do local s = pl:GetAttribute("SeedName") or pl:GetAttribute("CorePartName") if s then seen[s] = true end end end
    end
    local list = {} for k in pairs(seen) do list[#list + 1] = k end table.sort(list); return list
end
local function getHarvestOptions()
    local seen = {}
    local plot = myPlot()
    if plot then local plants = plot:FindFirstChild("Plants") if plants then for _, pl in ipairs(plants:GetChildren()) do local s = pl:GetAttribute("SeedName") or pl:GetAttribute("CorePartName") if s then seen[s] = true end end end end
    local d = getData(); if d and d.Inventory and d.Inventory.Seeds then for n in pairs(d.Inventory.Seeds) do seen[n] = true end end
    local list = {} for k in pairs(seen) do list[#list + 1] = k end table.sort(list); return list
end
local function getPetOptions()
    local d = getData(); local seen = {}
    if d and d.Inventory and d.Inventory.Pets then
        for _, info in pairs(d.Inventory.Pets) do local nm = (type(info) == "table" and (info.PetType or info.Name)) or tostring(info) if nm and nm ~= "" then seen[nm] = true end end
    end
    local list = {} for k in pairs(seen) do list[#list + 1] = k end table.sort(list); return list
end
local function maxEquip() return tonumber(LocalPlayer:GetAttribute("MaxEquippedPets")) or 3 end
local function bestOwnedSeed()
    local d = getData(); local seeds = d and d.Inventory and d.Inventory.Seeds; if not seeds then return nil end
    local best, bestV
    for name, count in pairs(seeds) do
        if (count or 0) > 0 then local v = SeedBaseValue[name] or 0 if not bestV or v > bestV then best, bestV = name, v end end
    end
    return best, bestV
end
local function inventoryValue()
    local total, n = 0, 0
    local function scan(c) if not c then return end for _, t in ipairs(c:GetChildren()) do
        if t:IsA("Tool") and (t:GetAttribute("HarvestedFruit") or t:GetAttribute("Fruit")) then
            n = n + 1
            local base = SeedBaseValue[t:GetAttribute("Fruit") or t:GetAttribute("CorePartName")] or 0
            total = total + base * sizeMul(t:GetAttribute("SizeMultiplier") or t:GetAttribute("SizeMulti") or 1) * (t:GetAttribute("Mutation") and MUT_BONUS or 1)
        end
    end end
    scan(LocalPlayer:FindFirstChild("Backpack")); scan(char())
    return total, n
end
local function abbrev(n)
    n = tonumber(n) or 0
    if n >= 1e9 then return string.format("%.2fB", n/1e9) end
    if n >= 1e6 then return string.format("%.2fM", n/1e6) end
    if n >= 1e3 then return string.format("%.1fK", n/1e3) end
    return tostring(math.floor(n))
end
local function commafy(n)
    local neg = n < 0; local s = tostring(math.floor(math.abs(n) + 0.5))
    local out = s:reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
    return (neg and "-" or "") .. out
end
local function money(n) return "$" .. commafy(n) end
local function fmtPrice(n)
    n = tonumber(n); if not n or n <= 0 or n == math.huge then return "" end
    local s
    if n >= 1e9 then s = string.format("%.1fB", n/1e9)
    elseif n >= 1e6 then s = string.format("%.1fM", n/1e6)
    elseif n >= 1e3 then s = string.format("%.0fK", n/1e3)
    else s = commafy(n) end
    s = s:gsub("%.0(%a)", "%1")
    return s .. "\xc2\xa2"
end
local function currentEvent() return workspace:GetAttribute("ActiveWeather"), workspace:GetAttribute("ActivePhase"), tonumber(workspace:GetAttribute("PhaseDuration")) end
local function restockIn(shop)
    local sv = ReplicatedStorage:FindFirstChild("StockValues"); sv = sv and sv:FindFirstChild(shop)
    local nx = sv and sv:FindFirstChild("UnixNextRestock")
    return nx and math.max(0, nx.Value - os.time()) or nil
end

--========================== NOTIFY ================================--
local function setStatus(t) pcall(function() Net.Notification:Fire("360's GAG", t) end) end
local function notify(t, title) pcall(function() Net.Notification:Fire(title or "360's GAG", t) end) end

--====================== PLANT POSITIONS ==========================--
local PLANT_PATTERNS = { "Fill", "Checkerboard", "Rows", "Columns", "Diagonal", "Spaced" }
local function patternKeep(pat, gx, gz)
    if pat == "Checkerboard" then return (gx + gz) % 2 == 0
    elseif pat == "Rows" then return gz % 2 == 0
    elseif pat == "Columns" then return gx % 2 == 0
    elseif pat == "Diagonal" then return (gx - gz) % 3 == 0
    elseif pat == "Spaced" then return gx % 2 == 0 and gz % 2 == 0 end
    return true
end
local function plantAreas(plot)
    local areas = {}
    for _, p in ipairs(CollectionService:GetTagged("PlantArea")) do
        if p:IsA("BasePart") and p:IsDescendantOf(plot) and p.Size.X * p.Size.Z > 400 then areas[#areas + 1] = p end
    end
    if #areas == 0 then local ref = plot:FindFirstChild("PlotSizeReference"); if ref then areas = { ref } end end
    return areas
end
local function plantPositions(plot)
    local pat = S.plantPattern or "Fill"; local step = 6; local seen, list = {}, {}
    for _, area in ipairs(plantAreas(plot)) do
        local cf, sz = area.CFrame, area.Size
        local topY = area.Position.Y + sz.Y/2 + 0.3
        local hx, hz = sz.X/2 - 3, sz.Z/2 - 3
        local nx, nz = math.floor((2*hx)/step), math.floor((2*hz)/step)
        for ix = 0, nx do for iz = 0, nz do
            local w = (cf * CFrame.new(-hx + ix*step, 0, -hz + iz*step)).Position
            local gx, gz = math.floor(w.X/step + 0.5), math.floor(w.Z/step + 0.5)
            if patternKeep(pat, gx, gz) then
                local key = math.floor(w.X/4 + 0.5) .. "," .. math.floor(w.Z/4 + 0.5)
                if not seen[key] then seen[key] = true; list[#list + 1] = Vector3.new(w.X, topY, w.Z) end
            end
        end end
    end
    return list
end
local function freePlantPositions(plot)
    local grid = plantPositions(plot); local plants = plot:FindFirstChild("Plants"); local occ = {}
    if plants then for _, pl in ipairs(plants:GetChildren()) do local ok, pv = pcall(function() return pl:GetPivot().Position end) if ok then occ[#occ+1] = pv end end end
    local free = {}
    for _, pos in ipairs(grid) do
        local clear = true
        for _, o in ipairs(occ) do if (Vector3.new(o.X,0,o.Z) - Vector3.new(pos.X,0,pos.Z)).Magnitude < 6 then clear = false break end end
        if clear then free[#free+1] = pos end
    end
    return free
end

--======================= GARDEN SNAPSHOTS ========================--
local SNAP_FILE = "360_GAG_GAG2_Snapshots.json"
local Snapshots = {}
local function saveSnapshots() if writefile then pcall(function() writefile(SNAP_FILE, HttpService:JSONEncode(Snapshots)) end) end end
do
    if readfile and isfile then
        local ok, raw = pcall(function() return isfile(SNAP_FILE) and readfile(SNAP_FILE) or nil end)
        if ok and raw then local g, d = pcall(function() return HttpService:JSONDecode(raw) end) if g and type(d) == "table" then Snapshots = d end end
    end
end
local function snapshotNames()
    local list = {"My Seeds"} for n in pairs(Snapshots) do list[#list + 1] = n end table.sort(list); return list
end
local function gardenNearPlayer()
    local g = Workspace:FindFirstChild("Gardens"); local r = hrp(); if not (g and r) then return nil end
    local best, bestD
    for _, plot in ipairs(g:GetChildren()) do
        local ref = plot:FindFirstChild("PlotSizeReference")
        if ref then local d = (Vector3.new(ref.Position.X,0,ref.Position.Z) - Vector3.new(r.Position.X,0,r.Position.Z)).Magnitude
            if not bestD or d < bestD then best, bestD = plot, d end end
    end
    return best
end
local BUILD_FOLDERS = { "Props", "Sprinklers", "Gnomes", "PottedPlants", "Pots", "Objects", "Decor" }
local function captureSnapshot(name)
    local plot = gardenNearPlayer(); if not plot then return false, "no garden nearby" end
    local ref = plot:FindFirstChild("PlotSizeReference"); local center = ref and ref.Position or Vector3.zero
    local snap = { seeds = {}, buildings = {}, owner = plot:GetAttribute("OwnerUserId") }
    local plants = plot:FindFirstChild("Plants")
    if plants then for _, pl in ipairs(plants:GetChildren()) do
        local s = pl:GetAttribute("SeedName") or pl:GetAttribute("CorePartName")
        if s then snap.seeds[s] = (snap.seeds[s] or 0) + 1 end
    end end
    for _, fname in ipairs(BUILD_FOLDERS) do
        local f = plot:FindFirstChild(fname)
        if f then for _, b in ipairs(f:GetChildren()) do
            local ok, piv = pcall(function() return b:GetPivot().Position end)
            if ok then
                local kind = b:GetAttribute("PropName") or b:GetAttribute("ItemName") or b:GetAttribute("Name") or b:GetAttribute("Type") or b.Name
                snap.buildings[#snap.buildings + 1] = { kind = tostring(kind), folder = fname,
                    rx = piv.X - center.X, ry = piv.Y - center.Y, rz = piv.Z - center.Z,
                    rot = (select(2, (b:GetPivot()):ToOrientation()) or 0) }
            end
        end end
    end
    Snapshots[name] = snap; saveSnapshots()
    local nSeeds = 0 for _ in pairs(snap.seeds) do nSeeds = nSeeds + 1 end
    return true, ("captured %d seed types, %d buildings"):format(nSeeds, #snap.buildings)
end

--====================== REMOVE / BUILD ===========================--
local function findShovel()
    local function scan(cont) if cont then for _, c in ipairs(cont:GetChildren()) do if c:IsA("Tool") and (c:GetAttribute("Shovel") ~= nil or c.Name:lower():find("shovel")) then return c end end end end
    return scan(char()) or scan(LocalPlayer:FindFirstChild("Backpack"))
end
local function equipShovel()
    local sh = findShovel(); if not sh then return nil end
    local h = humanoid()
    if h and sh.Parent ~= char() then pcall(function() h:EquipTool(sh) end); task.wait(0.3) end
    return sh
end
local function removePlants(matchFn)
    local plot = myPlot(); if not plot then return 0 end
    local plants = plot:FindFirstChild("Plants"); if not plants then return 0 end
    local sh = equipShovel(); if not sh then setStatus("equip a shovel first"); return 0 end
    local sa = sh:GetAttribute("Shovel"); local n = 0; local lastPos
    for _, pl in ipairs(plants:GetChildren()) do
        local pid = pl:GetAttribute("PlantId")
        local crop = pl:GetAttribute("SeedName") or pl:GetAttribute("CorePartName")
        if pid and ((not matchFn) or matchFn(crop)) then
            local ok, pos = pcall(function() return pl:GetPivot().Position end)
            if ok and (not lastPos or (pos - lastPos).Magnitude > 10) then reach(pos); lastPos = pos end
            pcall(function() Net.Shovel.UseShovel:Fire(pid, "", sa, sh) end)
            n = n + 1; task.wait(0.05)
        end
    end
    return n
end
local function removeAllPlants() return removePlants(nil) end
local function removeSelectedPlants() return removePlants(function(crop) return crop and S.removeCrops[crop] == true end) end
local function removeAllBuildings()
    local plot = myPlot(); if not plot then return 0 end
    local n = 0
    for _, fname in ipairs(BUILD_FOLDERS) do
        local f = plot:FindFirstChild(fname)
        if f then for _, b in ipairs(f:GetChildren()) do
            pcall(function()
                if Net.Prop and Net.Prop.PickupProp then Net.Prop.PickupProp:Fire(b) end
                if Net.PotPlacement and Net.PotPlacement.PickUpPottedPlant then Net.PotPlacement.PickUpPottedPlant:Fire(b) end
                if fname == "Gnomes" and Net.Place and Net.Place.RemoveGnome then Net.Place.RemoveGnome:Fire(b) end
            end)
            n = n + 1; task.wait(0.06)
        end end
    end
    return n
end

--======================== SPEED HUB X 5.0 ========================--
local Speed_Library = loadstring(game:HttpGet("https://pastefy.app/NI2E2FUX/raw"))()
local Window = Speed_Library:CreateWindow({Name = "360's GAG  |  Grow a Garden 2"})

-- ===================== TAB: FARM =================================--
local FarmTab = Window:AddTab({Title = "Farm"})

-- Section: Auto Buy Seeds
local BuySec = FarmTab:AddSection({Title = "Auto Buy Seeds"})
BuySec:AddToggle({
    "Auto Buy Seeds", "Buys seeds from the shop automatically every 2 seconds",
    S.autoBuySeed, function(v) S.autoBuySeed = v; saveSettings() end
})
local buySeedDrop = BuySec:AddDropdown({
    "Seeds to Buy", "Leave empty to buy all seeds in stock",
    getSeedOptions(), {}, true,
    function(v)
        table.clear(S.buySeeds)
        for _, nm in ipairs(v) do S.buySeeds[nm] = true end
        saveSettings()
    end
})

-- Section: Auto Plant
local PlantSec = FarmTab:AddSection({Title = "Auto Plant"})
PlantSec:AddToggle({
    "Auto Plant", "Plants seeds from your inventory into free garden slots",
    S.autoPlant, function(v) S.autoPlant = v; saveSettings() end
})
PlantSec:AddToggle({
    "Smart Replant", "Always plants the highest-value seed you own",
    S.smartReplant, function(v) S.smartReplant = v; saveSettings() end
})
PlantSec:AddToggle({
    "Auto Expand Garden", "Fires the expand-garden request automatically",
    S.autoExpand, function(v) S.autoExpand = v; saveSettings() end
})
PlantSec:AddSlider({
    "Max Per Cycle", "Maximum seeds to plant each loop cycle",
    1, 100, S.maxPerCycle,
    function(v) S.maxPerCycle = math.floor(v); saveSettings() end
})
PlantSec:AddSlider({
    "Plant Delay (s)", "Delay in seconds between planting each seed",
    0.05, 2, S.plantDelay,
    function(v) S.plantDelay = v; saveSettings() end
})
PlantSec:AddSlider({
    "Plant Loop (s)", "Seconds between each full auto-plant cycle",
    0.5, 10, S.plantLoop,
    function(v) S.plantLoop = v; saveSettings() end
})
PlantSec:AddSlider({
    "Reserve Seeds", "Keep at least this many of each seed in reserve",
    0, 200, S.plantReserve,
    function(v) S.plantReserve = math.floor(v); saveSettings() end
})
local plantSeedDrop = PlantSec:AddDropdown({
    "Seeds to Plant", "Leave empty to plant all seeds you own",
    getSeedOptions(), {}, true,
    function(v)
        table.clear(S.plantSeeds)
        for _, nm in ipairs(v) do S.plantSeeds[nm] = true end
        saveSettings()
    end
})
PlantSec:AddDropdown({
    "Plant Pattern", "Grid pattern used when placing seeds",
    PLANT_PATTERNS, {S.plantPattern}, false,
    function(v)
        if v[1] then S.plantPattern = v[1]; saveSettings() end
    end
})
local sourceDrop = PlantSec:AddDropdown({
    "Plant Source", "Which seed set to replant from",
    snapshotNames(), {S.plantSource}, false,
    function(v)
        if v[1] then S.plantSource = v[1]; saveSettings() end
    end
})
PlantSec:AddButton({
    "Capture Snapshot", "Save the garden you are standing near as a snapshot",
    nil,
    function()
        local name = "Snap_" .. tostring(os.time() % 10000)
        local ok, msg = captureSnapshot(name)
        setStatus(ok and ("snapshot saved: " .. name .. " - " .. msg) or ("snapshot failed: " .. tostring(msg)))
        pcall(function() sourceDrop:Refresh(snapshotNames(), {S.plantSource}) end)
    end
})

-- Section: Auto Collect
local CollectSec = FarmTab:AddSection({Title = "Auto Collect"})
CollectSec:AddToggle({
    "Auto Collect", "Harvests your ripe crops automatically",
    S.autoCollect, function(v) S.autoCollect = v; saveSettings() end
})
CollectSec:AddToggle({
    "Mutations Only", "Only harvest mutated crops (gold, rainbow, etc.)",
    S.harvestMutsOnly, function(v) S.harvestMutsOnly = v; saveSettings() end
})
CollectSec:AddSlider({
    "Per-Fruit Delay (s)", "Pause between collecting each individual fruit",
    0.01, 1, S.perFruitDelay,
    function(v) S.perFruitDelay = v; saveSettings() end
})
CollectSec:AddSlider({
    "Harvest Loop (s)", "Seconds between each auto-harvest cycle",
    0.5, 10, S.harvestLoop,
    function(v) S.harvestLoop = v; saveSettings() end
})
CollectSec:AddButton({
    "Harvest Now", "Immediately harvest all ripe crops in your garden",
    nil,
    function() task.spawn(function() local n = harvestAll(true); setStatus("harvested " .. n) end) end
})
local harvestDrop = CollectSec:AddDropdown({
    "Crops to Harvest", "Leave empty to harvest all crop types",
    getHarvestOptions(), {}, true,
    function(v)
        table.clear(S.harvestCrops)
        for _, nm in ipairs(v) do S.harvestCrops[nm] = true end
        saveSettings()
    end
})

-- Section: Auto Sell
local SellSec = FarmTab:AddSection({Title = "Auto Sell"})
SellSec:AddToggle({
    "Auto Sell", "Sells all your fruit at regular intervals",
    S.autoSell, function(v) S.autoSell = v; saveSettings() end
})
SellSec:AddToggle({
    "Sell When Full", "Instantly sell when your backpack reaches capacity",
    S.sellOnFull, function(v) S.sellOnFull = v; saveSettings() end
})
SellSec:AddSlider({
    "Sell Interval (s)", "How often (in seconds) to auto-sell",
    5, 120, S.sellInterval,
    function(v) S.sellInterval = math.floor(v); saveSettings() end
})
SellSec:AddButton({
    "Sell Now", "Sell all fruit in your backpack immediately",
    nil,
    function() fire(Net.NPCS.SellAll); setStatus("sold all fruit") end
})

-- Section: Remove Plants
local RemoveSec = FarmTab:AddSection({Title = "Remove Plants"})
local removeDrop = RemoveSec:AddDropdown({
    "Crops to Remove", "Select which crop types to remove",
    getPlantedOptions(), {}, true,
    function(v)
        table.clear(S.removeCrops)
        for _, nm in ipairs(v) do S.removeCrops[nm] = true end
        saveSettings()
    end
})
RemoveSec:AddButton({
    "Remove Selected Crops", "Remove only the selected crop types (needs shovel equipped)",
    nil,
    function() task.spawn(function() local n = removeSelectedPlants(); setStatus("removed " .. n .. " plants") end) end
})
RemoveSec:AddButton({
    "Remove ALL Plants", "Remove every plant from your garden (needs shovel)",
    nil,
    function() task.spawn(function() local n = removeAllPlants(); setStatus("removed " .. n .. " plants") end) end
})
RemoveSec:AddButton({
    "Remove All Buildings", "Pick up every prop/sprinkler/gnome on your plot",
    nil,
    function() task.spawn(function() local n = removeAllBuildings(); setStatus("removed " .. n .. " buildings") end) end
})

-- ===================== TAB: NIGHT ================================--
local NightTab = Window:AddTab({Title = "Night"})

-- Section: Auto Steal
local StealSec = NightTab:AddSection({Title = "Auto Steal"})
StealSec:AddToggle({
    "Auto Steal", "Steals ripe fruit from other players during night-time",
    S.autoSteal, function(v) S.autoSteal = v; saveSettings() end
})
StealSec:AddToggle({
    "Return Home After Stealing", "Teleports back to your garden after each steal pass",
    S.stealReturn, function(v) S.stealReturn = v; saveSettings() end
})
StealSec:AddSlider({
    "Steal Multiplier", "CompleteSteal packets fired per fruit (more = more fruit stolen)",
    1, 10, S.stealMult,
    function(v) S.stealMult = math.floor(v); saveSettings() end
})

-- Section: Defense
local DefSec = NightTab:AddSection({Title = "Defense"})
DefSec:AddToggle({
    "Panic Harvest", "Instantly harvest ALL your crops when night begins",
    S.panicHarvest, function(v) S.panicHarvest = v; saveSettings() end
})
DefSec:AddToggle({
    "Retaliate", "Shovel-hit any player who walks on your garden plot",
    S.retaliate, function(v) S.retaliate = v; saveSettings() end
})

-- Section: Seed Packs
local GrabSec = NightTab:AddSection({Title = "Auto Grab Packs"})
GrabSec:AddToggle({
    "Auto Grab Packs", "Automatically collects event seed packs from the map",
    S.autoGrabPacks, function(v) S.autoGrabPacks = v; saveSettings() end
})
GrabSec:AddToggle({
    "Rare Packs Only", "Only collect gold/rainbow seeds and rare packs",
    S.grabRareOnly, function(v) S.grabRareOnly = v; saveSettings() end
})
GrabSec:AddToggle({
    "Return After Event", "Teleport back to your garden when night ends",
    S.packReturn, function(v) S.packReturn = v; saveSettings() end
})
GrabSec:AddToggle({
    "Notify Rare Spawn", "Show a notification when a rare seed spawns on the map",
    S.notifyRare, function(v) S.notifyRare = v; saveSettings() end
})

-- ===================== TAB: SHOP =================================--
local ShopTab = Window:AddTab({Title = "Shop"})

-- Section: Gear
local GearSec = ShopTab:AddSection({Title = "Auto Buy Gear"})
GearSec:AddToggle({
    "Auto Buy Gear", "Buys gear from the shop automatically",
    S.autoBuyGear, function(v) S.autoBuyGear = v; saveSettings() end
})
local gearDrop = GearSec:AddDropdown({
    "Gear to Buy", "Leave empty to buy all available gear",
    getGearOptions(), {}, true,
    function(v)
        table.clear(S.buyGears)
        for _, nm in ipairs(v) do S.buyGears[nm] = true end
        saveSettings()
    end
})

-- Section: Crates
local CrateSec = ShopTab:AddSection({Title = "Auto Buy Crates"})
CrateSec:AddToggle({
    "Auto Buy Crates", "Automatically buys crates from the shop",
    S.autoBuyCrate, function(v) S.autoBuyCrate = v; saveSettings() end
})

-- Section: Auto Open
local OpenSec = ShopTab:AddSection({Title = "Auto Open"})
OpenSec:AddToggle({
    "Auto Open Eggs", "Automatically opens all eggs in your inventory",
    S.autoEggs, function(v) S.autoEggs = v; saveSettings() end
})
OpenSec:AddToggle({
    "Auto Open Crates", "Automatically opens all crates in your inventory",
    S.autoCrates, function(v) S.autoCrates = v; saveSettings() end
})
OpenSec:AddToggle({
    "Auto Open Seed Packs", "Automatically opens all seed packs you own",
    S.autoPacks, function(v) S.autoPacks = v; saveSettings() end
})

-- ===================== TAB: PETS =================================--
local PetsTab = Window:AddTab({Title = "Pets"})

-- Section: Tame
local TameSec = PetsTab:AddSection({Title = "Auto Tame"})
TameSec:AddToggle({
    "Auto Tame", "Automatically tames wild animals that spawn on the map",
    S.autoTame, function(v) S.autoTame = v; saveSettings() end
})
local tameDrop = TameSec:AddDropdown({
    "Animals to Tame", "Leave empty to tame any wild animal",
    getAnimalOptions(), {}, true,
    function(v)
        table.clear(S.tameAnimals)
        for _, nm in ipairs(v) do S.tameAnimals[nm] = true end
        saveSettings()
    end
})

-- Section: Equip
local EquipSec = PetsTab:AddSection({Title = "Auto Equip"})
EquipSec:AddToggle({
    "Auto Equip Pets", "Automatically equips the selected pets",
    S.autoEquipPets, function(v) S.autoEquipPets = v; saveSettings() end
})
local equipDrop = EquipSec:AddDropdown({
    "Pets to Equip", "Select which pets to keep equipped",
    getPetOptions(), {}, true,
    function(v)
        table.clear(S.equipPets)
        for _, nm in ipairs(v) do S.equipPets[nm] = true end
        saveSettings()
    end
})

-- ===================== TAB: MOVEMENT =============================--
local MoveTab = Window:AddTab({Title = "Movement"})

local SpeedSec = MoveTab:AddSection({Title = "Speed & Jump"})
SpeedSec:AddSlider({
    "Walk Speed", "Character movement speed (default: 16)",
    16, 500, S.walkSpeed,
    function(v) S.walkSpeed = math.floor(v); saveSettings() end
})
SpeedSec:AddSlider({
    "Jump Power", "Character jump height (default: 50)",
    50, 500, S.jumpPower,
    function(v) S.jumpPower = math.floor(v); saveSettings() end
})
SpeedSec:AddToggle({
    "Infinite Jump", "Press Space again while airborne to jump indefinitely",
    S.infJump, function(v) S.infJump = v; saveSettings() end
})

local FlySec = MoveTab:AddSection({Title = "Fly & Noclip"})
FlySec:AddToggle({
    "Fly", "Fly with WASD + Space (up) + Ctrl (down)",
    S.fly,
    function(v)
        S.fly = v
        if not v then if Hub.stopFly then Hub.stopFly() end end
        saveSettings()
    end
})
FlySec:AddSlider({
    "Fly Speed", "Speed while flying",
    10, 300, S.flySpeed,
    function(v) S.flySpeed = math.floor(v); saveSettings() end
})
FlySec:AddToggle({
    "Noclip", "Phase through walls and terrain objects",
    S.noclip,
    function(v)
        S.noclip = v
        if not v then setCharCollide(true) end
        saveSettings()
    end
})

-- ===================== TAB: SETTINGS =============================--
local SetTab = Window:AddTab({Title = "Settings"})

-- Section: ESP
local EspSec = SetTab:AddSection({Title = "ESP / Highlights"})
EspSec:AddToggle({
    "Highlight Ready Crops", "Draw a red highlight over your ripe crops",
    S.highlightReady, function(v) S.highlightReady = v; saveSettings() end
})
EspSec:AddToggle({
    "Highlight Rare Fruits", "Draw a gold highlight over nearby mutated fruits",
    S.highlightRare, function(v) S.highlightRare = v; saveSettings() end
})
EspSec:AddToggle({
    "Rare Restock Notify", "Notification when an expensive seed appears in the shop",
    S.rareNotify, function(v) S.rareNotify = v; saveSettings() end
})

-- Section: Server
local SrvSec = SetTab:AddSection({Title = "Server Hop"})
SrvSec:AddButton({
    "Hop to Any Server", "Teleport to a different random server",
    nil,
    function()
        local TPS = game:GetService("TeleportService")
        local function fetchServers()
            local ok, res = pcall(function()
                local raw = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
                return HttpService:JSONDecode(raw)
            end)
            return (ok and res and res.data) or {}
        end
        task.spawn(function()
            setStatus("finding server...")
            local servers = fetchServers(); local pick
            for _, s in ipairs(servers) do
                if s.id ~= game.JobId and s.playing and s.maxPlayers and s.playing < s.maxPlayers then
                    pick = s; break
                end
            end
            if pick then setStatus("hopping..."); pcall(function() TPS:TeleportToPlaceInstance(game.PlaceId, pick.id, LocalPlayer) end)
            else setStatus("no server found") end
        end)
    end
})
SrvSec:AddButton({
    "Hop to Low Pop", "Join the server with the fewest players",
    nil,
    function()
        local TPS = game:GetService("TeleportService")
        local function fetchServers()
            local ok, res = pcall(function()
                local raw = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
                return HttpService:JSONDecode(raw)
            end)
            return (ok and res and res.data) or {}
        end
        task.spawn(function()
            setStatus("finding low-pop server...")
            local servers = fetchServers(); local pick
            for _, s in ipairs(servers) do
                if s.id ~= game.JobId and s.playing and s.maxPlayers and s.playing < s.maxPlayers then
                    if not pick or s.playing < pick.playing then pick = s end
                end
            end
            if pick then setStatus("hopping (" .. pick.playing .. " players)..."); pcall(function() TPS:TeleportToPlaceInstance(game.PlaceId, pick.id, LocalPlayer) end)
            else setStatus("no server found") end
        end)
    end
})
SrvSec:AddToggle({
    "Auto-Hop for Rare Seeds", "Keep hopping servers until a rare seed (5000+) is in stock",
    S.autoHopRare, function(v) S.autoHopRare = v; saveSettings() end
})

-- Section: Misc
local MiscSec = SetTab:AddSection({Title = "Misc"})
MiscSec:AddToggle({
    "Anti-AFK", "Prevents the 20-minute idle kick",
    S.antiAfk, function(v) S.antiAfk = v; saveSettings() end
})
MiscSec:AddToggle({
    "Auto Progress", "Hands-off mode: harvest → sell → buy best seeds → plant → tame",
    S.autoProgress, function(v) S.autoProgress = v; saveSettings() end
})
MiscSec:AddTextbox({
    "Discord Webhook URL", "Paste your webhook URL for notifications",
    S.webhookUrl,
    function(v) S.webhookUrl = v; saveSettings() end
})
MiscSec:AddToggle({
    "Webhook: Rare Seed Restock", "Send a webhook ping when a rare seed restocks",
    S.whRareSeed, function(v) S.whRareSeed = v; saveSettings() end
})
MiscSec:AddToggle({
    "Webhook: Big Harvest", "Send a webhook ping when you harvest a large amount",
    S.whBigHarvest, function(v) S.whBigHarvest = v; saveSettings() end
})

-- Periodic dropdown refresh (options change as inventory/stock change)
task.spawn(function()
    while Hub.running do
        task.wait(5)
        pcall(function() buySeedDrop:Refresh(getSeedOptions(), {}) end)
        pcall(function() plantSeedDrop:Refresh(getSeedOptions(), {}) end)
        pcall(function() harvestDrop:Refresh(getHarvestOptions(), {}) end)
        pcall(function() removeDrop:Refresh(getPlantedOptions(), {}) end)
        pcall(function() tameDrop:Refresh(getAnimalOptions(), {}) end)
        pcall(function() equipDrop:Refresh(getPetOptions(), {}) end)
        pcall(function() gearDrop:Refresh(getGearOptions(), {}) end)
        pcall(function() sourceDrop:Refresh(snapshotNames(), {S.plantSource}) end)
    end
end)

--========================== UNLOAD ================================--
function Hub.unload()
    if not Hub.running then return end
    saveSettings()
    Hub.running = false
    for _, c in ipairs(Hub.conns) do pcall(function() c:Disconnect() end) end
    Hub.conns = {}
    if Hub.stopFly then pcall(Hub.stopFly) end
    local h = humanoid(); if h then h.WalkSpeed = 16; h.UseJumpPower = true; h.JumpPower = 50; h.PlatformStand = false end
    local c = char(); if c then for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then pcall(function() p.CanCollide = true end) end end end
    for k, v in pairs(S) do if type(v) == "boolean" then S[k] = false end end
    print("[360's GAG] unloaded.")
end
genv.GAG360_unload = Hub.unload
genv.GAG360_notify = function(msg, title) notify(msg, title) end

--========================= FEATURE LOOPS =========================--

-- Auto Buy Seeds
spawnLoop(2, function()
    if not S.autoBuySeed then return end
    local it = seedStockItems(); if not it then return end
    local anySel = next(S.buySeeds) ~= nil
    for _, sv in ipairs(it:GetChildren()) do
        if sv:IsA("ValueBase") and sv.Value > 0 and ((not anySel) or S.buySeeds[sv.Name] == true) then
            if getSheckles() >= (SeedPrice[sv.Name] or 0) then fire(Net.SeedShop.PurchaseSeed, sv.Name); task.wait(0.08) end
        end
    end
end)

-- Auto Plant
spawnLoop(0.6, function()
    if not S.autoPlant then return end
    task.wait(math.max(0, S.plantLoop - 0.6))
    if not S.autoPlant then return end
    local plot = myPlot(); if not plot then return end
    local d = getData(); local seeds = d and d.Inventory and d.Inventory.Seeds; if not seeds then return end
    local useFilter = next(S.plantSeeds) ~= nil
    local toPlant = {}
    local snap = (S.plantSource and S.plantSource ~= "My Seeds") and Snapshots[S.plantSource] or nil
    if snap then
        local have = {}
        local plf = plot:FindFirstChild("Plants")
        if plf then for _, pl in ipairs(plf:GetChildren()) do local s = pl:GetAttribute("SeedName") or pl:GetAttribute("CorePartName") if s then have[s] = (have[s] or 0) + 1 end end end
        for seed, target in pairs(snap.seeds) do
            local need = math.min((target or 0) - (have[seed] or 0), seeds[seed] or 0)
            for _ = 1, math.max(0, need) do toPlant[#toPlant + 1] = seed end
        end
    elseif S.smartReplant then
        local best = bestOwnedSeed()
        if best and ((not useFilter) or S.plantSeeds[best]) then
            local keep = S.plantReserve or 0
            for _ = 1, math.min(math.max(0, (seeds[best] or 0) - keep), 80) do toPlant[#toPlant + 1] = best end
        end
    else
        for name, count in pairs(seeds) do
            if (not useFilter) or S.plantSeeds[name] == true then
                local keep = S.plantReserve or 0
                for _ = 1, math.min(math.max(0, (count or 0) - keep), 40) do toPlant[#toPlant + 1] = name end
            end
        end
    end
    if #toPlant == 0 then return end
    local free = freePlantPositions(plot); if #free == 0 then return end
    local cap = math.min(#free, #toPlant, S.maxPerCycle); local planted = 0
    for i = 1, cap do
        fire(Net.Plant.PlantSeed, free[i], toPlant[i], plot); planted = planted + 1; task.wait(S.plantDelay)
    end
    if planted > 0 then setStatus("planted " .. planted) end
end)

-- Auto Expand
spawnLoop(6, function()
    if not S.autoExpand then return end
    local plot = myPlot(); if not plot then return end
    local before = tonumber(plot:GetAttribute("GardenExpansion")) or 0
    fire(Net.Actions.ExpandGarden)
    task.wait(1)
    local after = tonumber(plot:GetAttribute("GardenExpansion")) or before
    if after > before then setStatus("garden expanded to size " .. after) end
end)

-- Auto Build
local function buildSnapshot()
    local snap = (S.plantSource and S.plantSource ~= "My Seeds") and Snapshots[S.plantSource] or nil
    if not (snap and snap.buildings and #snap.buildings > 0) then setStatus("pick a snapshot (with buildings) as the source") return 0 end
    local plot = myPlot(); if not plot then return 0 end
    local ref = plot:FindFirstChild("PlotSizeReference"); local center = ref and ref.Position or Vector3.zero
    local n = 0
    for _, b in ipairs(snap.buildings) do
        local pos = Vector3.new(center.X + (b.rx or 0), center.Y + (b.ry or 0), center.Z + (b.rz or 0))
        pcall(function() if Net.Prop and Net.Prop.PlaceProp then Net.Prop.PlaceProp:Fire(pos, b.kind, b.rot or 0, b.rot or 0) end end)
        n = n + 1; task.wait(0.15)
    end
    setStatus("auto-build: attempted " .. n .. " buildings")
    return n
end
spawnLoop(8, function()
    if not S.autoBuild then return end
    local snap = (S.plantSource and S.plantSource ~= "My Seeds") and Snapshots[S.plantSource] or nil
    if not (snap and snap.buildings and #snap.buildings > 0) then return end
    local plot = myPlot(); if not plot then return end
    local built = 0
    for _, fname in ipairs(BUILD_FOLDERS) do local f = plot:FindFirstChild(fname) if f then built = built + #f:GetChildren() end end
    if built < #snap.buildings then buildSnapshot() end
end)

-- Auto Collect
spawnLoop(0.4, function()
    if not S.autoCollect then return end
    task.wait(math.max(0, S.harvestLoop - 0.4))
    if not S.autoCollect then return end
    local n = harvestAll(true)
    if n > 0 then setStatus("harvested " .. n) end
end)

-- Sell on Full
spawnLoop(1, function()
    if S.sellOnFull then
        local fc = LocalPlayer:GetAttribute("FruitCount") or 0
        local mx = LocalPlayer:GetAttribute("MaxFruitCapacity") or 100
        if fc >= mx - 1 then fire(Net.NPCS.SellAll); setStatus("sold (backpack full)") end
    end
end)

-- Auto Sell interval
do
    local acc = 0
    spawnLoop(1, function() acc = acc + 1 if S.autoSell and acc >= S.sellInterval then acc = 0 fire(Net.NPCS.SellAll) end end)
end

-- Auto Steal
spawnLoop(0.8, function()
    if not S.autoSteal then return end
    if not isNight() then setStatus("steal: waiting for night") return end
    local home = hrp() and hrp().Position
    local t = stealTargets(); local n = 0; local lastPos
    for _, e in ipairs(t) do
        if not S.autoSteal or not isNight() then break end
        local m = e.model; local pos = (m and m.Parent) and m:GetPivot().Position or nil
        local skip = (lastPos and pos and (pos - lastPos).Magnitude <= 12) or false
        if pos and not skip then lastPos = pos end
        stealModel(m, S.stealMult, skip); n = n + 1
        setStatus(string.format("steal: %d/%d", n, #t)); task.wait(0.03)
    end
    if n > 0 then setStatus(("stole %d fruit this pass"):format(n)) end
    if S.stealReturn and home then reach(home - Vector3.new(0,3,0)) end
end)

-- Auto Grab Packs
local function packKind(loc)
    if loc:GetAttribute("GoldSeed") == true then return "Gold Seed" end
    if loc:GetAttribute("RainbowSeed") == true then return "Rainbow Seed" end
    if loc:GetAttribute("SeedPack") ~= nil then return tostring(loc:GetAttribute("SeedPack")) end
    return nil
end
local function isRarePack(loc)
    if loc:GetAttribute("GoldSeed") == true or loc:GetAttribute("RainbowSeed") == true then return true end
    local sp = loc:GetAttribute("SeedPack")
    return type(sp) == "string" and (sp:lower():find("gold") ~= nil or sp:lower():find("rainbow") ~= nil)
end
local function firePrompt(d)
    pcall(function()
        local hold = tonumber(d.HoldDuration) or 0
        if fireproximityprompt then
            if hold > 0 then fireproximityprompt(d, hold) else fireproximityprompt(d) end
        else
            d:InputHoldBegin(); task.wait(hold + 0.1); d:InputHoldEnd()
        end
    end)
end
local function packLocations()
    local map = Workspace:FindFirstChild("Map"); local f = map and map:FindFirstChild("SeedPackSpawnServerLocations")
    return f and f:GetChildren() or {}
end
local function holdSeedPrompts(pos)
    local map = Workspace:FindFirstChild("Map")
    for _, cont in ipairs({ map and map:FindFirstChild("SeedPackSpawnServerLocations"), map and map:FindFirstChild("SeedPackSpawnClient"), Workspace:FindFirstChild("Temporary") }) do
        if cont then for _, d in ipairs(cont:GetDescendants()) do
            if d:IsA("ProximityPrompt") then
                local p = d.Parent; local ok, pp = pcall(function() return p.Position end)
                if (not ok) or (pp - pos).Magnitude <= 35 then firePrompt(d) end
            end
        end end
    end
end
local function locPart(loc) return loc:IsA("BasePart") and loc or loc:FindFirstChildWhichIsA("BasePart", true) end
local function locPos(loc)
    if loc:IsA("BasePart") then return loc.Position end
    local ok, cf = pcall(function() return loc:GetPivot() end); if ok then return cf.Position end
    local bp = locPart(loc); return bp and bp.Position or nil
end
local function grabPack(loc)
    local landed = false
    for _ = 1, 90 do
        if not (loc and loc.Parent) then break end
        local pos = locPos(loc); if not pos then break end
        local r = hrp()
        if (not landed) or (r and (r.Position - pos).Magnitude > 6) then reach(pos); landed = true end
        for _, d in ipairs(loc:GetDescendants()) do if d:IsA("ProximityPrompt") then firePrompt(d) end end
        holdSeedPrompts(pos)
        local part = locPart(loc)
        if firetouchinterest and part and hrp() then pcall(function() firetouchinterest(hrp(), part, 0); firetouchinterest(hrp(), part, 1) end) end
        task.wait(0.12)
    end
end
do
    local grabbing = {}
    spawnLoop(0.6, function()
        if not S.autoGrabPacks then return end
        for _, loc in ipairs(packLocations()) do
            if loc.Parent and not grabbing[loc] then
                local rare = isRarePack(loc)
                if S.notifyRare and rare then local k = packKind(loc) or "Rare seed"; setStatus("EVENT: " .. k .. " spawned!"); notify(k .. " spawned - grabbing now!", "Rare Seed") end
                if (not S.grabRareOnly) or rare then
                    grabbing[loc] = true
                    task.spawn(function() grabPack(loc); grabbing[loc] = nil end)
                end
            end
        end
    end)
end
do
    local wasNight = false
    spawnLoop(1, function()
        local n = isNight()
        if S.packReturn and S.autoGrabPacks and wasNight and not n then
            local plot = myPlot(); local sp = plot and plot:FindFirstChild("SpawnPoint")
            if sp then reach(sp.Position); setStatus("event over - returned to garden") end
        end
        wasNight = n
    end)
end

-- Panic Harvest
do
    local wasNight = false
    spawnLoop(0.5, function()
        local n = isNight()
        if S.panicHarvest and n and not wasNight then
            setStatus("defense: panic harvesting")
            harvestAll(false)
        end
        wasNight = n
    end)
end

-- Retaliate
spawnLoop(0.6, function()
    if not S.retaliate then return end
    local plot = myPlot(); local ref = plot and plot:FindFirstChild("PlotSizeReference"); if not ref then return end
    local center, size = ref.Position, ref.Size
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer and pl.Character then
            local r = pl.Character:FindFirstChild("HumanoidRootPart")
            if r and math.abs(r.Position.X - center.X) < size.X/2 + 4 and math.abs(r.Position.Z - center.Z) < size.Z/2 + 4 then fire(Net.Shovel.HitPlayer, pl.UserId) end
        end
    end
end)

-- Auto Buy Crates
spawnLoop(3, function()
    if not S.autoBuyCrate then return end
    local it = stockItems("CrateShop"); if not it then return end
    for _, sv in ipairs(it:GetChildren()) do if sv:IsA("ValueBase") and sv.Value > 0 then fire(Net.CrateShop.PurchaseCrate, sv.Name); task.wait(0.1) end end
end)

-- Auto Buy Gear
spawnLoop(3, function()
    if not S.autoBuyGear then return end
    local it = gearStockItems(); if not it then return end
    local anySel = next(S.buyGears) ~= nil
    for _, sv in ipairs(it:GetChildren()) do
        if sv:IsA("ValueBase") and sv.Value > 0 and ((not anySel) or S.buyGears[sv.Name] == true) then fire(Net.GearShop.PurchaseGear, sv.Name); task.wait(0.1) end
    end
end)

-- Auto Open (Eggs / Crates / Seed Packs)
local function openAll(invKey, pkt, flag)
    spawnLoop(2.5, function()
        if not S[flag] then return end
        local d = getData(); local bag = d and d.Inventory and d.Inventory[invKey]; if not bag then return end
        for name, count in pairs(bag) do local n = (type(count) == "number") and count or 1 for _ = 1, n do task.spawn(function() fire(pkt, name) end) task.wait(0.15) end end
    end)
end
openAll("Eggs",      Net.Egg.OpenEgg,           "autoEggs")
openAll("Crates",    Net.Crate.OpenCrate,        "autoCrates")
openAll("SeedPacks", Net.SeedPack.OpenSeedPack,  "autoPacks")

-- Auto Tame
spawnLoop(1.2, function()
    if not S.autoTame then return end
    local map = Workspace:FindFirstChild("Map"); local refs = map and map:FindFirstChild("WildPetRef"); if not refs then return end
    local anySel = next(S.tameAnimals) ~= nil
    for _, pet in ipairs(refs:GetChildren()) do
        if not S.autoTame then break end
        local owner = tonumber(pet:GetAttribute("OwnerUserId")) or 0
        local species = pet:GetAttribute("PetName")
        if ((not anySel) or (species and S.tameAnimals[species] == true)) and (owner == 0 or owner == LocalPlayer.UserId) and pet:IsA("BasePart") then
            reach(pet.Position); setStatus("taming " .. tostring(species))
            for _ = 1, 6 do if not S.autoTame then break end pcall(function() Net.Pets.WildPetTame:Fire(pet) end) task.wait(0.08) end
        end
    end
end)

-- Auto Progress
local GOOD_PETS = {
    Raccoon = true, Dragonfly = true, ["Dragon Fly"] = true, Dragonling = true, Mimic = true,
    ["Disco Bee"] = true, ["Queen Bee"] = true, Kitsune = true, ["Red Fox"] = true, Fox = true,
    Owl = true, ["Night Owl"] = true, Bear = true, ["Polar Bear"] = true, Butterfly = true,
    ["Golden Lab"] = true, Cat = true, ["Red Giant Ant"] = true, Snail = true,
}
local function progressBuy()
    local it = seedStockItems(); if not it then return end
    local bal = getSheckles(); local best, bestV
    for _, sv in ipairs(it:GetChildren()) do
        if sv:IsA("ValueBase") and sv.Value > 0 then
            local price, val = SeedPrice[sv.Name] or math.huge, SeedBaseValue[sv.Name] or 0
            if price <= bal * 0.5 and (not bestV or val > bestV) then best, bestV = sv.Name, val end
        end
    end
    if best then for _ = 1, 6 do if getSheckles() < (SeedPrice[best] or 0) then break end fire(Net.SeedShop.PurchaseSeed, best); task.wait(0.1) end end
    return best
end
local function progressPlant()
    local plot = myPlot(); if not plot then return 0 end
    local d = getData(); local seeds = d and d.Inventory and d.Inventory.Seeds; if not seeds then return 0 end
    local toPlant = {}
    for name, count in pairs(seeds) do for _ = 1, math.min(count or 0, 30) do toPlant[#toPlant + 1] = name end end
    if #toPlant == 0 then return 0 end
    local free = freePlantPositions(plot); local cap = math.min(#free, #toPlant); local n = 0
    for i = 1, cap do fire(Net.Plant.PlantSeed, free[i], toPlant[i], plot); n = n + 1; task.wait(0.08) end
    return n
end
spawnLoop(4, function()
    if not S.autoProgress then return end
    local h = harvestAll(false)
    if (LocalPlayer:GetAttribute("FruitCount") or 0) > 0 then fire(Net.NPCS.SellAll); task.wait(0.2) end
    progressBuy()
    local p = progressPlant()
    setStatus(("auto progress: +%d harvest, +%d plant, %s"):format(h, p, money(getSheckles())))
end)
spawnLoop(1.5, function()
    if not S.autoProgress then return end
    local map = Workspace:FindFirstChild("Map"); local refs = map and map:FindFirstChild("WildPetRef"); if not refs then return end
    for _, pet in ipairs(refs:GetChildren()) do
        if not S.autoProgress then break end
        local species = pet:GetAttribute("PetName"); local owner = tonumber(pet:GetAttribute("OwnerUserId")) or 0
        if species and GOOD_PETS[species] and (owner == 0 or owner == LocalPlayer.UserId) and pet:IsA("BasePart") then
            reach(pet.Position); setStatus("auto progress: taming " .. species)
            for _ = 1, 6 do if not S.autoProgress then break end pcall(function() Net.Pets.WildPetTame:Fire(pet) end) task.wait(0.08) end
        end
    end
end)

-- Auto Equip Pets
spawnLoop(5, function()
    if not S.autoEquipPets then return end
    local n, mx = 0, maxEquip()
    for name in pairs(S.equipPets) do if n >= mx then break end fire(Net.Pets.RequestEquipByName, tostring(name)); n = n + 1; task.wait(0.15) end
end)

-- Fly + Movement
local flyBV, flyBG
local function stopFly()
    if flyBV then pcall(function() flyBV:Destroy() end) flyBV = nil end
    if flyBG then pcall(function() flyBG:Destroy() end) flyBG = nil end
    local h = humanoid(); if h then h.PlatformStand = false end
end
Hub.stopFly = stopFly
local function startFly()
    local r = hrp(); if not r then return end
    stopFly()
    flyBV = Instance.new("BodyVelocity"); flyBV.MaxForce = Vector3.new(1,1,1)*9e9; flyBV.Velocity = Vector3.zero; flyBV.Parent = r
    flyBG = Instance.new("BodyGyro"); flyBG.MaxTorque = Vector3.new(1,1,1)*9e9; flyBG.P = 1e5; flyBG.CFrame = r.CFrame; flyBG.Parent = r
end
track(RunService.Heartbeat:Connect(function()
    if not Hub.running then return end
    local h = humanoid()
    if h then
        if S.walkSpeed ~= 16 then h.WalkSpeed = S.walkSpeed end
        if S.jumpPower ~= 50 then h.UseJumpPower = true; h.JumpPower = S.jumpPower end
    end
    if S.noclip then local c = char() if c then for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end end end end
    if S.fly then
        local r = hrp(); local cam = Workspace.CurrentCamera
        if r and cam then
            if not flyBV then startFly() end
            if h then h.PlatformStand = true end
            local d = Vector3.zero
            local function k(c) return UserInputService:IsKeyDown(c) end
            if k(Enum.KeyCode.W) then d = d + cam.CFrame.LookVector end
            if k(Enum.KeyCode.S) then d = d - cam.CFrame.LookVector end
            if k(Enum.KeyCode.D) then d = d + cam.CFrame.RightVector end
            if k(Enum.KeyCode.A) then d = d - cam.CFrame.RightVector end
            if k(Enum.KeyCode.Space) then d = d + Vector3.new(0,1,0) end
            if k(Enum.KeyCode.LeftControl) then d = d - Vector3.new(0,1,0) end
            if flyBV then flyBV.Velocity = (d.Magnitude > 0 and d.Unit or Vector3.zero) * S.flySpeed end
            if flyBG then flyBG.CFrame = cam.CFrame end
        end
    elseif flyBV then stopFly() end
end))
track(UserInputService.JumpRequest:Connect(function() if S.infJump then local h = humanoid() if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end end))

-- Anti-AFK
do
    local VU = game:GetService("VirtualUser")
    track(LocalPlayer.Idled:Connect(function()
        if not S.antiAfk then return end
        pcall(function()
            VU:CaptureController()
            VU:ClickButton2(Vector2.new())
        end)
    end))
end

-- Webhook
local httpRequest = (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request) or (typeof(request) == "function" and request) or http_request
local function sendWebhook(content)
    if not (S.webhookUrl and S.webhookUrl ~= "" and httpRequest) then return false end
    task.spawn(function()
        pcall(function()
            httpRequest({ Url = S.webhookUrl, Method = "POST", Headers = { ["Content-Type"] = "application/json" },
                Body = HttpService:JSONEncode({ username = "360's GAG", content = content }) })
        end)
    end)
    return true
end

-- Auto Hop for Rare Seeds
local function rareSeedInStock()
    local it = seedStockItems(); if not it then return false end
    for _, sv in ipairs(it:GetChildren()) do if sv:IsA("ValueBase") and sv.Value > 0 and (SeedPrice[sv.Name] or 0) >= 5000 then return true, sv.Name end end
    return false
end
spawnLoop(20, function()
    if not S.autoHopRare then return end
    if not rareSeedInStock() then
        local TPS = game:GetService("TeleportService")
        local function fetchServers()
            local ok, res = pcall(function()
                local raw = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
                return HttpService:JSONDecode(raw)
            end)
            return (ok and res and res.data) or {}
        end
        local servers = fetchServers(); local pick
        for _, s in ipairs(servers) do
            if s.id ~= game.JobId and s.playing and s.maxPlayers and s.playing < s.maxPlayers then
                pick = s; break
            end
        end
        if pick then pcall(function() TPS:TeleportToPlaceInstance(game.PlaceId, pick.id, LocalPlayer) end) end
    end
end)

-- Highlight ESP
local hlFolder = Instance.new("Folder"); hlFolder.Name = "GAG_HL"; hlFolder.Parent = LocalPlayer:WaitForChild("PlayerGui")
local function clearHL() for _, h in ipairs(hlFolder:GetChildren()) do h:Destroy() end end
local function addHL(model, col)
    if not model or not model.Parent then return end
    local h = Instance.new("Highlight"); h.Adornee = model; h.FillColor = col; h.FillTransparency = 0.55
    h.OutlineColor = col; h.OutlineTransparency = 0; h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; h.Parent = hlFolder
end
spawnLoop(1, function()
    if not (S.highlightReady or S.highlightRare) then if #hlFolder:GetChildren() > 0 then clearHL() end return end
    clearHL()
    local root = hrp(); local rp = root and root.Position
    if S.highlightReady then for _, m in ipairs(ownHarvestTargets()) do addHL(m, Color3.fromRGB(196,30,58)) end end
    if S.highlightRare and rp then
        local count = 0
        for _, p in ipairs(CollectionService:GetTagged("StealPrompt")) do
            if count >= 50 then break end
            local m = p.Parent and p.Parent:FindFirstAncestorWhichIsA("Model")
            if m and m:GetAttribute("Mutation") then
                local ok, piv = pcall(function() return m:GetPivot().Position end)
                if ok and (piv - rp).Magnitude < 220 then addHL(m, Color3.fromRGB(255,205,70)); count = count + 1 end
            end
        end
    end
end)
table.insert(Hub.conns, { Disconnect = function() pcall(clearHL) pcall(function() hlFolder:Destroy() end) end })

-- Rare Seed Restock Notifier
do
    local prev = {}
    spawnLoop(3, function()
        if not S.rareNotify then return end
        local it = seedStockItems(); if not it then return end
        for _, sv in ipairs(it:GetChildren()) do
            if sv:IsA("ValueBase") then
                local now = sv.Value > 0
                if now and not prev[sv.Name] and (SeedPrice[sv.Name] or 0) >= 5000 then
                    local msg = sv.Name .. " is in stock! " .. fmtPrice(SeedPrice[sv.Name])
                    notify(msg, "Rare Seed Restock")
                    sendWebhook(msg)
                end
                prev[sv.Name] = now
            end
        end
    end)
end

-- Webhook: Big Harvest
spawnLoop(30, function()
    if not S.whBigHarvest then return end
    local val, n = inventoryValue()
    if n >= 20 then sendWebhook(("Big harvest: %d fruit worth ~%s in backpack"):format(n, money(math.floor(val)))) end
end)

print("[360's GAG] Speed Hub X 5.0 loaded successfully.")
