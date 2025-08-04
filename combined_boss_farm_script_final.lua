local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LogoGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- Logo (ảnh)
local imageLabel = Instance.new("ImageLabel")
imageLabel.Name = "CenterLogo"
imageLabel.Size = UDim2.new(0, 200, 0, 200)
imageLabel.Position = UDim2.new(0.5, 0, 0.5, -80) -- Chỉnh lại -80 để nó cao hơn một chút
imageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
imageLabel.BackgroundTransparency = 1
imageLabel.Image = "rbxassetid://101666202705923"
imageLabel.Parent = screenGui

-- Chữ dưới logo
local textLabel = Instance.new("TextLabel")
textLabel.Name = "LogoText"
textLabel.Size = UDim2.new(0, 300, 0, 50)
textLabel.Position = UDim2.new(0.5, 0, 0.5, 40) -- Gần hơn (trước là 120)
textLabel.AnchorPoint = Vector2.new(0.5, 0.5)
textLabel.BackgroundTransparency = 1
textLabel.Text = "Bacon Hub"
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.TextStrokeTransparency = 0.5
textLabel.TextScaled = true
textLabel.Font = Enum.Font.GothamBold
textLabel.Parent = screenGui

-- Các cài đặt ban đầu
local TrollApi = loadstring(game:HttpGet("https://raw.githubusercontent.com/PorryDepTrai/exploit/main/SimpleTroll.lua"))()
if not TrollApi then
    return
end

local function decode(job) 
    local success, result = pcall(function()
        return TrollApi["Decode JobId API Porry | discord.gg/umaru | MB KHOI"](job, "discord.gg/umaru | MB_Bank 9929992999 Phan Dat Khoi")
    end)
    if not success then
        return nil
    end
    return result
end

-- Kiểm tra dịch vụ
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local plr = Players.LocalPlayer

if not ReplicatedStorage or not TweenService or not HttpService or not TeleportService then
    return
end

pcall(function()
    require(game.ReplicatedStorage.Util.CameraShaker):Stop()
end)

loadstring(game:HttpGet("https://raw.githubusercontent.com/skibidi687/Premium/refs/heads/main/fasattack"))()

-- Xác định thế giới
local World1, World2, World3
if game.PlaceId == 2753915549 then
    World1 = true
elseif game.PlaceId == 4442272183 then
    World2 = true
elseif game.PlaceId == 7449423635 then
    World3 = true
else
    return
end

if not World2 then
    return
end

-- Hàm hỗ trợ
function WaitHRP(player)
    if not player then 
        return nil 
    end
    local character = player.Character
    if character then
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            return hrp
        end
    end
    return nil
end

-- Hàm teleport
local isTeleporting = false
function CheckNearestTeleporter(pos)
    local vcspos = pos.Position
    local minDist = math.huge
    local chosenTeleport = nil
    local TableLocations = {
        ["Kingdom of Rose"] = Vector3.new(-394, 139, 2289),
        ["Dark Arena"] = Vector3.new(3876, 15, -3889),
        ["Green Zone"] = Vector3.new(-2250, 73, -2819)
    }
    
    for name, v in pairs(TableLocations) do
        local dist = (v - vcspos).Magnitude
        if dist < minDist then
            minDist = dist
            chosenTeleport = v
        end
    end

    local playerPos = WaitHRP(plr) and plr.Character.HumanoidRootPart.Position
    if playerPos and minDist <= (vcspos - playerPos).Magnitude then
        return chosenTeleport
    end
    return nil
end

function requestEntrance(teleportPos)
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", teleportPos)
        local char = WaitHRP(plr)
        if char then
            char.CFrame = char.CFrame + Vector3.new(0, 50, 0)
        end
    end)
    task.wait(0.5)
end

function topos(pos)
    local hrp = WaitHRP(plr)
    if not hrp or not plr.Character or not plr.Character.Humanoid or plr.Character.Humanoid.Health <= 0 then
        task.wait(1)
        return
    end

    local distance = (pos.Position - hrp.Position).Magnitude
    local nearestTeleport = distance > 1000 and CheckNearestTeleporter(pos)
    
    if nearestTeleport then
        requestEntrance(nearestTeleport)
        task.wait(1)
    end

    local partTele = plr.Character:FindFirstChild("PartTele")
    if not partTele then
        partTele = Instance.new("Part", plr.Character)
        partTele.Size = Vector3.new(10, 1, 10)
        partTele.Name = "PartTele"
        partTele.Anchored = true
        partTele.Transparency = 1
        partTele.CanCollide = false
        partTele.CFrame = hrp.CFrame
        
        partTele:GetPropertyChangedSignal("CFrame"):Connect(function()
            if not isTeleporting then return end
            task.wait()
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local targetCFrame = partTele.CFrame
                WaitHRP(plr).CFrame = CFrame.new(targetCFrame.Position.X, pos.Position.Y, targetCFrame.Position.Z)
            end
        end)
    end
    
    isTeleporting = true
    local speed = getgenv().TweenSpeed or 350
    if distance <= 250 then
        speed = speed * 3
    end

    local success, tween = pcall(function()
        return TweenService:Create(
            partTele,
            TweenInfo.new(distance / speed, Enum.EasingStyle.Linear),
            {CFrame = pos}
        )
    end)
    if not success then
        isTeleporting = false
        return
    end
    
    tween:Play()
    
    tween.Completed:Connect(function(status)
        if status == Enum.PlaybackState.Completed then
            if plr.Character:FindFirstChild("PartTele") then
                plr.Character.PartTele:Destroy()
            end
            isTeleporting = false
        end
    end)
end

function stopTeleport()
    isTeleporting = false
    if plr.Character and plr.Character:FindFirstChild("PartTele") then
        plr.Character.PartTele:Destroy()
    end
end

spawn(function()
    while task.wait() do
        if not isTeleporting then
            stopTeleport()
        end
    end
end)

spawn(function()
    while task.wait() do
        pcall(function()
            if plr.Character and plr.Character:FindFirstChild("PartTele") then
                if (plr.Character.HumanoidRootPart.Position - plr.Character.PartTele.Position).Magnitude >= 100 then
                    stopTeleport()
                end
            end
        end)
    end
end)

local function onCharacterAdded(character)
    local humanoid = character:WaitForChild("Humanoid", 10)
    if humanoid then
        humanoid.Died:Connect(function()
            stopTeleport()
        end)
    end
end

plr.CharacterAdded:Connect(onCharacterAdded)
if plr.Character then
    onCharacterAdded(plr.Character)
end

-- Noclip
spawn(function()
    pcall(function()
        while task.wait() do
            if _G.FarmBoss then
                if not plr.Character or not plr.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
                    local noclip = Instance.new("BodyVelocity")
                    noclip.Name = "BodyClip"
                    noclip.Parent = plr.Character and plr.Character.HumanoidRootPart
                    noclip.MaxForce = Vector3.new(100000, 100000, 100000)
                    noclip.Velocity = Vector3.new(0, 0, 0)
                end
            end
        end
    end)
end)

spawn(function()
    pcall(function()
        game:GetService("RunService").Stepped:Connect(function()
            if _G.FarmBoss then
                for _, v in pairs(plr.Character and plr.Character:GetDescendants() or {}) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end
        end)
    end)
end)

-- Vị trí tấn công
local PosY = 25
local Type = 1
spawn(function()
    while task.wait() do
        if Type == 1 then
            Pos = CFrame.new(0, PosY, -19)
        elseif Type == 2 then
            Pos = CFrame.new(19, PosY, 0)
        elseif Type == 3 then
            Pos = CFrame.new(0, PosY, 19)
        elseif Type == 4 then
            Pos = CFrame.new(-19, PosY, 0)
        end
    end
end)

spawn(function()
    while task.wait(0.1) do
        Type = 1
        task.wait(0.2)
        Type = 2
        task.wait(0.2)
        Type = 3
        task.wait(0.2)
        Type = 4
        task.wait(0.2)
    end
end)

-- Hàm hỗ trợ
function AutoHaki()
    pcall(function()
        if not plr.Character:FindFirstChild("HasBuso") then
            ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
        end
    end)
end

function EquipWeapon(ToolSe)
    pcall(function()
        if plr.Backpack:FindFirstChild(ToolSe) then
            local Tool = plr.Backpack:FindFirstChild(ToolSe)
            task.wait(0.1)
            plr.Character.Humanoid:EquipTool(Tool)
        end
    end)
end

_G.SelectWeapon = "Melee"
task.spawn(function()
    while task.wait() do
        pcall(function()
            if _G.SelectWeapon == "Melee" then
                for _, v in pairs(plr.Backpack:GetChildren()) do
                    if v.ToolTip == "Melee" then
                        _G.SelectWeapon = v.Name
                        break
                    end
                end
            end
        end)
    end
end)

-- Hàm gọi API
local function scrapeAPI()
    local success, response = pcall(function()
        return game:HttpGet("https://hostserver.porry.store/bloxfruit/bot/JobId/darkbread")
    end)
    if success then
        local data = HttpService:JSONDecode(response)
        return data
    else
        return nil
    end
end

-- Hàm nhảy server
local function autoHopIfNeeded()
    local maxAttempts = 3
    local attempt = 1
    while attempt <= maxAttempts do
        local data = scrapeAPI()
        if data and data.JobId then
            for _, job in ipairs(data.JobId) do
                for jobId, _ in pairs(job) do
                    local decodedJobId = decode(jobId)
                    if decodedJobId then
                        pcall(function()
                            TeleportService:TeleportToPlaceInstance(game.PlaceId, decodedJobId)
                        end)
                        task.wait(5)
                        return
                    end
                end
            end
        end
        attempt = attempt + 1
        task.wait(2)
    end
end

-- Logic đánh Darkbeard
_G.FarmBoss = true
spawn(function()
    while task.wait() do
        if _G.FarmBoss then
            pcall(function()
                local enemies = game:GetService("Workspace").Enemies
                local hrp = WaitHRP(plr)
                if not hrp or not plr.Character or not plr.Character.Humanoid or plr.Character.Humanoid.Health <= 0 then
                    task.wait(1)
                    return
                end

                -- Kiểm tra và đánh Darkbeard
                local foundBoss = false
                for _, v in pairs(enemies:GetChildren()) do
                    if v.Name == getgenv().name and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                        foundBoss = true
                        repeat
                            task.wait()
                            if not plr.Character or not plr.Character.Humanoid or plr.Character.Humanoid.Health <= 0 then
                                break
                            end
                            AutoHaki()
                            EquipWeapon(_G.SelectWeapon)
                            v.HumanoidRootPart.CanCollide = false
                            v.Humanoid.WalkSpeed = 0
                            topos(v.HumanoidRootPart.CFrame * Pos)
                        until not _G.FarmBoss or not v.Parent or v.Humanoid.Health <= 0
                    end
                end

                -- Teleport hoặc nhảy server nếu không tìm thấy boss
                if not foundBoss then
                    local darkbeard = ReplicatedStorage:FindFirstChild(getgenv().name)
                    if darkbeard then
                        topos(darkbeard.HumanoidRootPart.CFrame * CFrame.new(5, 10, 7))
                    else
                        topos(CFrame.new(3876, 15, -3889))
                        task.wait(5)
                        autoHopIfNeeded()
                    end
                end
            end)
        end
    end
end)

-- FILE: doughking.txt --

-- Các cài đặt ban đầu
local TrollApi = loadstring(game:HttpGet("https://raw.githubusercontent.com/PorryDepTrai/exploit/main/SimpleTroll.lua"))()

local function decode(job) return TrollApi["Decode JobId API Porry | discord.gg/umaru | MB KHOI"](job, "discord.gg/umaru | MB_Bank 9929992999 Phan Dat Khoi") end
require(game.ReplicatedStorage.Util.CameraShaker):Stop()

loadstring(game:HttpGet("https://raw.githubusercontent.com/skibidi687/Premium/refs/heads/main/fasattack"))()

-- Xác định thế giới
local World1, World2, World3
if game.PlaceId == 2753915549 then
    World1 = true
elseif game.PlaceId == 4442272183 then
    World2 = true
elseif game.PlaceId == 7449423635 then
    World3 = true
end

-- Hàm teleport
local isTeleporting = false
function WaitHRP(player)
    if not player then return end
    local character = player.Character
    if character then
        return character:FindFirstChild("HumanoidRootPart")
    end
    return nil
end

function CheckNearestTeleporter(pos)
    local vcspos = pos.Position
    local minDist = math.huge
    local chosenTeleport = nil
    local TableLocations = {}

    if game.PlaceId == 2753915549 then
        TableLocations = {
            ["Sky3"] = Vector3.new(-7894, 5547, -380),
            ["Sky3Exit"] = Vector3.new(-4607, 874, -1667),
            ["UnderWater"] = Vector3.new(61163, 11, 1819),
            ["UnderwaterExit"] = Vector3.new(4050, -1, -1814)
        }
    elseif game.PlaceId == 4442272183 then
        TableLocations = {
            ["Swan Mansion"] = Vector3.new(-390, 332, 673),
            ["Swan Room"] = Vector3.new(2285, 15, 905),
            ["Cursed Ship"] = Vector3.new(923, 126, 32852),
            ["Zombie Island"] = Vector3.new(-6509, 83, -133)
        }
    elseif game.PlaceId == 7449423635 then
        TableLocations = {
            ["Floating Turtle"] = Vector3.new(-12462, 375, -7552),
            ["Hydra Island"] = Vector3.new(5662, 1013, -335),
            ["Mansion"] = Vector3.new(-12462, 375, -7552),
            ["Castle"] = Vector3.new(-5036, 315, -3179),
            ["Beautiful Pirate"] = Vector3.new(5319, 23, -93),
            ["Beautiful Room"] = Vector3.new(5314.58203, 22.5364361, -125.942276),
            ["Temple of Time"] = Vector3.new(28286, 14897, 103)
        }
    end

    for _, v in pairs(TableLocations) do
        local dist = (v - vcspos).Magnitude
        if dist < minDist then
            minDist = dist
            chosenTeleport = v
        end
    end

    local playerPos = WaitHRP(game.Players.LocalPlayer) and game.Players.LocalPlayer.Character.HumanoidRootPart.Position
    if playerPos and minDist <= (vcspos - playerPos).Magnitude then
        return chosenTeleport
    end
end

function requestEntrance(teleportPos)
    game.ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", teleportPos)
    local char = WaitHRP(game.Players.LocalPlayer)
    if char then
        char.CFrame = char.CFrame + Vector3.new(0, 50, 0)
    end
    task.wait(0.5)
end

function topos(pos)
    local plr = game.Players.LocalPlayer
    if not plr.Character or not plr.Character.Humanoid or plr.Character.Humanoid.Health <= 0 or not plr.Character:FindFirstChild("HumanoidRootPart") then
        return
    end

    local distance = (pos.Position - plr.Character.HumanoidRootPart.Position).Magnitude
    local nearestTeleport = distance > 1000 and CheckNearestTeleporter(pos)

    if nearestTeleport then
        requestEntrance(nearestTeleport)
        task.wait(1)
    end

    local partTele = plr.Character:FindFirstChild("PartTele")
    if not partTele then
        partTele = Instance.new("Part", plr.Character)
        partTele.Size = Vector3.new(10, 1, 10)
        partTele.Name = "PartTele"
        partTele.Anchored = true
        partTele.Transparency = 1
        partTele.CanCollide = false
        partTele.CFrame = WaitHRP(plr).CFrame
        partTele:GetPropertyChangedSignal("CFrame"):Connect(function()
            if not isTeleporting then return end
            task.wait()
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local targetCFrame = partTele.CFrame
                WaitHRP(plr).CFrame = CFrame.new(targetCFrame.Position.X, pos.Position.Y, targetCFrame.Position.Z)
            end
        end)
    end

    isTeleporting = true
    local speed = getgenv().TweenSpeed or 350
    if distance <= 250 then
        speed = speed * 3
    end

    local tween = game:GetService("TweenService"):Create(
        partTele,
        TweenInfo.new(distance / speed, Enum.EasingStyle.Linear),
        {CFrame = pos}
    )
    tween:Play()

    tween.Completed:Connect(function(status)
        if status == Enum.PlaybackState.Completed then
            if plr.Character:FindFirstChild("PartTele") then
                plr.Character.PartTele:Destroy()
            end
            isTeleporting = false
        end
    end)
end

function stopTeleport()
    isTeleporting = false
    local plr = game.Players.LocalPlayer
    if plr.Character and plr.Character:FindFirstChild("PartTele") then
        plr.Character.PartTele:Destroy()
    end
end

spawn(function()
    while task.wait() do
        if not isTeleporting then
            stopTeleport()
        end
    end
end)

spawn(function()
    local plr = game.Players.LocalPlayer
    while task.wait() do
        pcall(function()
            if plr.Character and plr.Character:FindFirstChild("PartTele") then
                if (plr.Character.HumanoidRootPart.Position - plr.Character.PartTele.Position).Magnitude >= 100 then
                    stopTeleport()
                end
            end
        end)
    end
end)

local plr = game.Players.LocalPlayer
local function onCharacterAdded(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.Died:Connect(function()
        stopTeleport()
    end)
end

plr.CharacterAdded:Connect(onCharacterAdded)
if plr.Character then
    onCharacterAdded(plr.Character)
end

-- Noclip
spawn(function()
    pcall(function()
        while task.wait() do
            if _G.FarmBoss then
                if not game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
                    local noclip = Instance.new("BodyVelocity")
                    noclip.Name = "BodyClip"
                    noclip.Parent = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
                    noclip.MaxForce = Vector3.new(100000, 100000, 100000)
                    noclip.Velocity = Vector3.new(0, 0, 0)
                end
            end
        end
    end)
end)

spawn(function()
    pcall(function()
        game:GetService("RunService").Stepped:Connect(function()
            if _G.FarmBoss then
                for _, v in pairs(game:GetService("Players").LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end
        end)
    end)
end)

-- Vị trí tấn công
local PosY = 25
local Type = 1
spawn(function()
    while task.wait() do
        if Type == 1 then
            Pos = CFrame.new(0, PosY, -19)
        elseif Type == 2 then
            Pos = CFrame.new(19, PosY, 0)
        elseif Type == 3 then
            Pos = CFrame.new(0, PosY, 19)
        elseif Type == 4 then
            Pos = CFrame.new(-19, PosY, 0)
        end
    end
end)

spawn(function()
    while task.wait(0.1) do
        Type = 1
        task.wait(0.2)
        Type = 2
        task.wait(0.2)
        Type = 3
        task.wait(0.2)
        Type = 4
        task.wait(0.2)
    end
end)

-- Hàm hỗ trợ
function AutoHaki()
    if not game:GetService("Players").LocalPlayer.Character:FindFirstChild("HasBuso") then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
    end
end

function EquipWeapon(ToolSe)
    if game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe) then
        local Tool = game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe)
        task.wait(0.1)
        game.Players.LocalPlayer.Character.Humanoid:EquipTool(Tool)
    end
end

_G.SelectWeapon = "Melee"
task.spawn(function()
    while task.wait() do
        pcall(function()
            if _G.SelectWeapon == "Melee" then
                for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                    if v.ToolTip == "Melee" then
                        _G.SelectWeapon = v.Name
                    end
                end
            elseif _G.SelectWeapon == "Sword" then
                for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                    if v.ToolTip == "Sword" then
                        _G.SelectWeapon = v.Name
                    end
                end
            elseif _G.SelectWeapon == "Gun" then
                for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                    if v.ToolTip == "Gun" then
                        _G.SelectWeapon = v.Name
                    end
                end
            elseif _G.SelectWeapon == "Fruit" then
                for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                    if v.ToolTip == "Blox Fruit" then
                        _G.SelectWeapon = v.Name
                    end
                end
            end
        end)
    end
end)

-- Logic đánh boss và nhảy server
_G.FarmBoss = true
spawn(function()
    while task.wait() do
        if _G.FarmBoss then
            pcall(function()
                local enemies = game:GetService("Workspace").Enemies
                local plr = game.Players.LocalPlayer
                if not plr.Character or not plr.Character.Humanoid or plr.Character.Humanoid.Health <= 0 then
                    return
                end

                -- Kiểm tra và đánh Dough King
                local foundBoss = false
                for _, v in pairs(enemies:GetChildren()) do
                    if v.Name == getgenv().name and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                        foundBoss = true
                        repeat
                            task.wait()
                            if not plr.Character or not plr.Character.Humanoid or plr.Character.Humanoid.Health <= 0 then
                                break
                            end
                            AutoHaki()
                            EquipWeapon(_G.SelectWeapon)
                            v.HumanoidRootPart.CanCollide = false
                            v.Humanoid.WalkSpeed = 0
                            topos(v.HumanoidRootPart.CFrame * Pos)
                            sethiddenproperty(plr, "SimulationRadius", math.huge)
                        until not _G.FarmBoss or not v.Parent or v.Humanoid.Health <= 0
                    end
                end

                -- Nhảy server nếu không tìm thấy boss
                if not foundBoss then
                    local doughKing = game:GetService("ReplicatedStorage"):FindFirstChild(getgenv().name)
                    if doughKing then
                        topos(doughKing.HumanoidRootPart.CFrame * CFrame.new(5, 10, 7))
                    else
                        local HttpService = game:GetService("HttpService")
                        local TeleportService = game:GetService("TeleportService")
                        local maxAttempts = 3
                        local attempt = 1

                        local function scrapeAPI()
                            local success, response = pcall(function()
                                return game:HttpGet("https://hostserver.porry.store/bloxfruit/bot/JobId/doughking")
                            end)
                            if success then
                                local data = HttpService:JSONDecode(response)
                                return data
                            end
                            return nil
                        end

                        local function autoHopIfNeeded()
                            while attempt <= maxAttempts do
                                local data = scrapeAPI()
                                if data and data.JobId then
                                    for _, job in ipairs(data.JobId) do
                                        for jobId, _ in pairs(job) do
                                            pcall(function()
                                                TeleportService:TeleportToPlaceInstance(game.PlaceId, decode(jobId))
                                            end)
                                            task.wait(5)
                                            return
                                        end
                                    end
                                end
                                attempt = attempt + 1
                                task.wait(2)
                            end
                        end

                        autoHopIfNeeded()
                    end
                end
            end)
        end
    end
end)

-- FILE: rip_indra.txt --

-- Các cài đặt ban đầu
local TrollApi = loadstring(game:HttpGet("https://raw.githubusercontent.com/PorryDepTrai/exploit/main/SimpleTroll.lua"))()

local function decode(job) return TrollApi["Decode JobId API Porry | discord.gg/umaru | MB KHOI"](job, "discord.gg/umaru | MB_Bank 9929992999 Phan Dat Khoi") end
require(game.ReplicatedStorage.Util.CameraShaker):Stop()

loadstring(game:HttpGet("https://raw.githubusercontent.com/skibidi687/Premium/refs/heads/main/fasattack"))()

-- Xác định thế giới
local World3
if game.PlaceId == 7449423635 then
    World3 = true
else
    return
end

-- Hàm teleport
local isTeleporting = false
function WaitHRP(player)
    if not player then return end
    local character = player.Character
    if character then
        return character:FindFirstChild("HumanoidRootPart")
    end
    return nil
end

function CheckNearestTeleporter(pos)
    local vcspos = pos.Position
    local minDist = math.huge
    local chosenTeleport = nil
    local TableLocations = {
        ["Floating Turtle"] = Vector3.new(-12462, 375, -7552),
        ["Hydra Island"] = Vector3.new(5662, 1013, -335),
        ["Mansion"] = Vector3.new(-12462, 375, -7552),
        ["Castle"] = Vector3.new(-5036, 315, -3179),
        ["Beautiful Pirate"] = Vector3.new(5319, 23, -93),
        ["Beautiful Room"] = Vector3.new(5314.58203, 22.5364361, -125.942276),
        ["Temple of Time"] = Vector3.new(28286, 14897, 103)
    }

    for _, v in pairs(TableLocations) do
        local dist = (v - vcspos).Magnitude
        if dist < minDist then
            minDist = dist
            chosenTeleport = v
        end
    end

    local playerPos = WaitHRP(game.Players.LocalPlayer) and game.Players.LocalPlayer.Character.HumanoidRootPart.Position
    if playerPos and minDist <= (vcspos - playerPos).Magnitude then
        return chosenTeleport
    end
end

function requestEntrance(teleportPos)
    game.ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", teleportPos)
    local char = WaitHRP(game.Players.LocalPlayer)
    if char then
        char.CFrame = char.CFrame + Vector3.new(0, 50, 0)
    end
    task.wait(0.5)
end

function topos(pos)
    local plr = game.Players.LocalPlayer
    if not plr.Character or not plr.Character.Humanoid or plr.Character.Humanoid.Health <= 0 or not plr.Character:FindFirstChild("HumanoidRootPart") then
        return
    end

    local distance = (pos.Position - plr.Character.HumanoidRootPart.Position).Magnitude
    local nearestTeleport = distance > 1000 and CheckNearestTeleporter(pos)

    if nearestTeleport then
        requestEntrance(nearestTeleport)
        task.wait(1)
    end

    local partTele = plr.Character:FindFirstChild("PartTele")
    if not partTele then
        partTele = Instance.new("Part", plr.Character)
        partTele.Size = Vector3.new(10, 1, 10)
        partTele.Name = "PartTele"
        partTele.Anchored = true
        partTele.Transparency = 1
        partTele.CanCollide = false
        partTele.CFrame = WaitHRP(plr).CFrame
        partTele:GetPropertyChangedSignal("CFrame"):Connect(function()
            if not isTeleporting then return end
            task.wait()
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local targetCFrame = partTele.CFrame
                WaitHRP(plr).CFrame = CFrame.new(targetCFrame.Position.X, pos.Position.Y, targetCFrame.Position.Z)
            end
        end)
    end

    isTeleporting = true
    local speed = getgenv().TweenSpeed or 350
    if distance <= 250 then
        speed = speed * 3
    end

    local tween = game:GetService("TweenService"):Create(
        partTele,
        TweenInfo.new(distance / speed, Enum.EasingStyle.Linear),
        {CFrame = pos}
    )
    tween:Play()

    tween.Completed:Connect(function(status)
        if status == Enum.PlaybackState.Completed then
            if plr.Character:FindFirstChild("PartTele") then
                plr.Character.PartTele:Destroy()
            end
            isTeleporting = false
        end
    end)
end

function stopTeleport()
    isTeleporting = false
    local plr = game.Players.LocalPlayer
    if plr.Character and plr.Character:FindFirstChild("PartTele") then
        plr.Character.PartTele:Destroy()
    end
end

spawn(function()
    while task.wait() do
        if not isTeleporting then
            stopTeleport()
        end
    end
end)

spawn(function()
    local plr = game.Players.LocalPlayer
    while task.wait() do
        pcall(function()
            if plr.Character and plr.Character:FindFirstChild("PartTele") then
                if (plr.Character.HumanoidRootPart.Position - plr.Character.PartTele.Position).Magnitude >= 100 then
                    stopTeleport()
                end
            end
        end)
    end
end)

local plr = game.Players.LocalPlayer
local function onCharacterAdded(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.Died:Connect(function()
        stopTeleport()
    end)
end

plr.CharacterAdded:Connect(onCharacterAdded)
if plr.Character then
    onCharacterAdded(plr.Character)
end

-- Noclip
spawn(function()
    pcall(function()
        while task.wait() do
            if _G.FarmBoss then
                if not game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
                    local noclip = Instance.new("BodyVelocity")
                    noclip.Name = "BodyClip"
                    noclip.Parent = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
                    noclip.MaxForce = Vector3.new(100000, 100000, 100000)
                    noclip.Velocity = Vector3.new(0, 0, 0)
                end
            end
        end
    end)
end)

spawn(function()
    pcall(function()
        game:GetService("RunService").Stepped:Connect(function()
            if _G.FarmBoss then
                for _, v in pairs(game:GetService("Players").LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end
        end)
    end)
end)

-- Vị trí tấn công
local PosY = 25
local Type = 1
spawn(function()
    while task.wait() do
        if Type == 1 then
            Pos = CFrame.new(0, PosY, -19)
        elseif Type == 2 then
            Pos = CFrame.new(19, PosY, 0)
        elseif Type == 3 then
            Pos = CFrame.new(0, PosY, 19)
        elseif Type == 4 then
            Pos = CFrame.new(-19, PosY, 0)
        end
    end
end)

spawn(function()
    while task.wait(0.1) do
        Type = 1
        task.wait(0.2)
        Type = 2
        task.wait(0.2)
        Type = 3
        task.wait(0.2)
        Type = 4
        task.wait(0.2)
    end
end)

-- Hàm hỗ trợ
function AutoHaki()
    if not game:GetService("Players").LocalPlayer.Character:FindFirstChild("HasBuso") then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
    end
end

function EquipWeapon(ToolSe)
    if game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe) then
        local Tool = game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe)
        task.wait(0.1)
        game.Players.LocalPlayer.Character.Humanoid:EquipTool(Tool)
    end
end

_G.SelectWeapon = "Melee"
task.spawn(function()
    while task.wait() do
        pcall(function()
            if _G.SelectWeapon == "Melee" then
                for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                    if v.ToolTip == "Melee" then
                        _G.SelectWeapon = v.Name
                    end
                end
            elseif _G.SelectWeapon == "Sword" then
                for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                    if v.ToolTip == "Sword" then
                        _G.SelectWeapon = v.Name
                    end
                end
            elseif _G.SelectWeapon == "Gun" then
                for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                    if v.ToolTip == "Gun" then
                        _G.SelectWeapon = v.Name
                    end
                end
            elseif _G.SelectWeapon == "Fruit" then
                for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                    if v.ToolTip == "Blox Fruit" then
                        _G.SelectWeapon = v.Name
                    end
                end
            end
        end)
    end
end)

-- Logic đánh boss và nhảy server
_G.FarmBoss = true
spawn(function()
    while task.wait() do
        if _G.FarmBoss then
            pcall(function()
                local enemies = game:GetService("Workspace").Enemies
                local plr = game.Players.LocalPlayer
                if not plr.Character or not plr.Character.Humanoid or plr.Character.Humanoid.Health <= 0 then
                    return
                end

                -- Kiểm tra và đánh rip_indra True Form
                local foundBoss = false
                for _, v in pairs(enemies:GetChildren()) do
                    if v.Name == getgenv().name and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                        foundBoss = true
                        repeat
                            task.wait()
                            if not plr.Character or not plr.Character.Humanoid or plr.Character.Humanoid.Health <= 0 then
                                break
                            end
                            AutoHaki()
                            EquipWeapon(_G.SelectWeapon)
                            v.HumanoidRootPart.CanCollide = false
                            v.Humanoid.WalkSpeed = 0
                            topos(v.HumanoidRootPart.CFrame * Pos)
                            sethiddenproperty(plr, "SimulationRadius", math.huge)
                        until not _G.FarmBoss or not v.Parent or v.Humanoid.Health <= 0
                    end
                end

                -- Nhảy server nếu không tìm thấy boss
                if not foundBoss then
                    local ripIndra = game:GetService("ReplicatedStorage"):FindFirstChild(getgenv().name)
                    if ripIndra then
                        topos(ripIndra.HumanoidRootPart.CFrame * CFrame.new(5, 10, 7))
                    else
                        local HttpService = game:GetService("HttpService")
                        local TeleportService = game:GetService("TeleportService")
                        local maxAttempts = 3
                        local attempt = 1

                        local function scrapeAPI()
                            local success, response = pcall(function()
                                return game:HttpGet("https://hostserver.porry.store/bloxfruit/bot/JobId/indra")
                            end)
                            if success then
                                local data = HttpService:JSONDecode(response)
                                return data
                            end
                            return nil
                        end

                        local function autoHopIfNeeded()
                            while attempt <= maxAttempts do
                                local data = scrapeAPI()
                                if data and data.JobId then
                                    for _, job in ipairs(data.JobId) do
                                        for jobId, _ in pairs(job) do
                                            pcall(function()
                                                TeleportService:TeleportToPlaceInstance(game.PlaceId, decode(jobId))
                                            end)
                                            task.wait(5)
                                            return
                                        end
                                    end
                                end
                                attempt = attempt + 1
                                task.wait(2)
                            end
                        end

                        autoHopIfNeeded()
                    end
                end
            end)
        end
    end
end)

-- FILE: farmtyrantoftheskies.txt --

-- Các cài đặt ban đầu
local TrollApi = loadstring(game:HttpGet("https://raw.githubusercontent.com/PorryDepTrai/exploit/main/SimpleTroll.lua"))()

local function decode(job) return TrollApi["Decode JobId API Porry | discord.gg/umaru | MB KHOI"](job, "discord.gg/umaru | MB_Bank 9929992999 Phan Dat Khoi") end
require(game.ReplicatedStorage.Util.CameraShaker):Stop()

loadstring(game:HttpGet("https://raw.githubusercontent.com/skibidi687/Premium/refs/heads/main/fasattack"))()

-- Xác định thế giới
local World3
if game.PlaceId == 7449423635 then
    World3 = true
else
    return
end

-- Hàm teleport
local isTeleporting = false
function WaitHRP(player)
    if not player then return end
    local character = player.Character
    if character then
        return character:FindFirstChild("HumanoidRootPart")
    end
    return nil
end

function CheckNearestTeleporter(pos)
    local vcspos = pos.Position
    local minDist = math.huge
    local chosenTeleport = nil
    local TableLocations = {
        ["Floating Turtle"] = Vector3.new(-12462, 375, -7552),
        ["Hydra Island"] = Vector3.new(5662, 1013, -335),
        ["Mansion"] = Vector3.new(-12462, 375, -7552),
        ["Castle"] = Vector3.new(-5036, 315, -3179),
        ["Beautiful Pirate"] = Vector3.new(5319, 23, -93),
        ["Beautiful Room"] = Vector3.new(5314.58203, 22.5364361, -125.942276),
        ["Temple of Time"] = Vector3.new(28286, 14897, 103)
    }

    for _, v in pairs(TableLocations) do
        local dist = (v - vcspos).Magnitude
        if dist < minDist then
            minDist = dist
            chosenTeleport = v
        end
    end

    local playerPos = WaitHRP(game.Players.LocalPlayer) and game.Players.LocalPlayer.Character.HumanoidRootPart.Position
    if playerPos and minDist <= (vcspos - playerPos).Magnitude then
        return chosenTeleport
    end
end

function requestEntrance(teleportPos)
    game.ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", teleportPos)
    local char = WaitHRP(game.Players.LocalPlayer)
    if char then
        char.CFrame = char.CFrame + Vector3.new(0, 50, 0)
    end
    task.wait(0.5)
end

function topos(pos)
    local plr = game.Players.LocalPlayer
    if not plr.Character or not plr.Character.Humanoid or plr.Character.Humanoid.Health <= 0 or not plr.Character:FindFirstChild("HumanoidRootPart") then
        return
    end

    local distance = (pos.Position - plr.Character.HumanoidRootPart.Position).Magnitude
    local nearestTeleport = distance > 1000 and CheckNearestTeleporter(pos)

    if nearestTeleport then
        requestEntrance(nearestTeleport)
        task.wait(1)
    end

    local partTele = plr.Character:FindFirstChild("PartTele")
    if not partTele then
        partTele = Instance.new("Part", plr.Character)
        partTele.Size = Vector3.new(10, 1, 10)
        partTele.Name = "PartTele"
        partTele.Anchored = true
        partTele.Transparency = 1
        partTele.CanCollide = false
        partTele.CFrame = WaitHRP(plr).CFrame
        partTele:GetPropertyChangedSignal("CFrame"):Connect(function()
            if not isTeleporting then return end
            task.wait()
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local targetCFrame = partTele.CFrame
                WaitHRP(plr).CFrame = CFrame.new(targetCFrame.Position.X, pos.Position.Y, targetCFrame.Position.Z)
            end
        end)
    end

    isTeleporting = true
    local speed = getgenv().TweenSpeed or 350
    if distance <= 250 then
        speed = speed * 3
    end

    local tween = game:GetService("TweenService"):Create(
        partTele,
        TweenInfo.new(distance / speed, Enum.EasingStyle.Linear),
        {CFrame = pos}
    )
    tween:Play()

    tween.Completed:Connect(function(status)
        if status == Enum.PlaybackState.Completed then
            if plr.Character:FindFirstChild("PartTele") then
                plr.Character.PartTele:Destroy()
            end
            isTeleporting = false
        end
    end)
end

function stopTeleport()
    isTeleporting = false
    local plr = game.Players.LocalPlayer
    if plr.Character and plr.Character:FindFirstChild("PartTele") then
        plr.Character.PartTele:Destroy()
    end
end

spawn(function()
    while task.wait() do
        if not isTeleporting then
            stopTeleport()
        end
    end
end)

spawn(function()
    local plr = game.Players.LocalPlayer
    while task.wait() do
        pcall(function()
            if plr.Character and plr.Character:FindFirstChild("PartTele") then
                if (plr.Character.HumanoidRootPart.Position - plr.Character.PartTele.Position).Magnitude >= 100 then
                    stopTeleport()
                end
            end
        end)
    end
end)

local plr = game.Players.LocalPlayer
local function onCharacterAdded(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.Died:Connect(function()
        stopTeleport()
    end)
end

plr.CharacterAdded:Connect(onCharacterAdded)
if plr.Character then
    onCharacterAdded(plr.Character)
end

-- Noclip
spawn(function()
    pcall(function()
        while task.wait() do
            if _G.FarmBoss then
                if not game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
                    local noclip = Instance.new("BodyVelocity")
                    noclip.Name = "BodyClip"
                    noclip.Parent = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
                    noclip.MaxForce = Vector3.new(100000, 100000, 100000)
                    noclip.Velocity = Vector3.new(0, 0, 0)
                end
            end
        end
    end)
end)

spawn(function()
    pcall(function()
        game:GetService("RunService").Stepped:Connect(function()
            if _G.FarmBoss then
                for _, v in pairs(game:GetService("Players").LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end
        end)
    end)
end)

-- Vị trí tấn công
local PosY = 25
local Type = 1
spawn(function()
    while task.wait() do
        if Type == 1 then
            Pos = CFrame.new(0, PosY, -19)
        elseif Type == 2 then
            Pos = CFrame.new(19, PosY, 0)
        elseif Type == 3 then
            Pos = CFrame.new(0, PosY, 19)
        elseif Type == 4 then
            Pos = CFrame.new(-19, PosY, 0)
        end
    end
end)

spawn(function()
    while task.wait(0.1) do
        Type = 1
        task.wait(0.2)
        Type = 2
        task.wait(0.2)
        Type = 3
        task.wait(0.2)
        Type = 4
        task.wait(0.2)
    end
end)

-- Hàm hỗ trợ
function AutoHaki()
    if not game:GetService("Players").LocalPlayer.Character:FindFirstChild("HasBuso") then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
    end
end

function EquipWeapon(ToolSe)
    if game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe) then
        local Tool = game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe)
        task.wait(0.1)
        game.Players.LocalPlayer.Character.Humanoid:EquipTool(Tool)
    end
end

_G.SelectWeapon = "Melee"
task.spawn(function()
    while task.wait() do
        pcall(function()
            if _G.SelectWeapon == "Melee" then
                for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                    if v.ToolTip == "Melee" then
                        _G.SelectWeapon = v.Name
                    end
                end
            elseif _G.SelectWeapon == "Sword" then
                for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                    if v.ToolTip == "Sword" then
                        _G.SelectWeapon = v.Name
                    end
                end
            elseif _G.SelectWeapon == "Gun" then
                for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                    if v.ToolTip == "Gun" then
                        _G.SelectWeapon = v.Name
                    end
                end
            elseif _G.SelectWeapon == "Fruit" then
                for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                    if v.ToolTip == "Blox Fruit" then
                        _G.SelectWeapon = v.Name
                    end
                end
            end
        end)
    end
end)

-- Logic farm boss
_G.FarmBoss = true
spawn(function()
    while task.wait() do
        if _G.FarmBoss then
            pcall(function()
                local enemies = game:GetService("Workspace").Enemies
                local plr = game.Players.LocalPlayer
                if not plr.Character or not plr.Character.Humanoid or plr.Character.Humanoid.Health <= 0 then
                    return
                end

                -- Kiểm tra và đánh Tyrant of the Skies
                local foundBoss = false
                for _, v in pairs(enemies:GetChildren()) do
                    if v.Name == getgenv().name and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                        foundBoss = true
                        repeat
                            task.wait()
                            if not plr.Character or not plr.Character.Humanoid or plr.Character.Humanoid.Health <= 0 then
                                break
                            end
                            AutoHaki()
                            EquipWeapon(_G.SelectWeapon)
                            v.HumanoidRootPart.CanCollide = false
                            v.Humanoid.WalkSpeed = 0
                            topos(v.HumanoidRootPart.CFrame * Pos)
                            sethiddenproperty(plr, "SimulationRadius", math.huge)
                        until not _G.FarmBoss or not v.Parent or v.Humanoid.Health <= 0
                    end
                end

                -- Di chuyển đến Tiki Outpost hoặc nhảy server
                if not foundBoss then
                    local tyrant = game:GetService("ReplicatedStorage"):FindFirstChild(getgenv().name)
                    if tyrant then
                        topos(tyrant.HumanoidRootPart.CFrame * CFrame.new(5, 10, 7))
                    else
                        topos(CFrame.new(-16554, 432, -16271)) -- Tiki Outpost tọa độ chính xác
                        task.wait(2)
                        local HttpService = game:GetService("HttpService")
                        local TeleportService = game:GetService("TeleportService")
                        local maxAttempts = 3
                        local attempt = 1

                        local function scrapeAPI()
                            local success, response = pcall(function()
                                return game:HttpGet("https://hostserver.porry.store/bloxfruit/bot/JobId/conchimkicuc")
                            end)
                            if success then
                                local data = HttpService:JSONDecode(response)
                                return data
                            end
                            return nil
                        end

                        local function autoHopIfNeeded()
                            while attempt <= maxAttempts do
                                local data = scrapeAPI()
                                if data and data.JobId then
                                    for _, job in ipairs(data.JobId) do
                                        for jobId, _ in pairs(job) do
                                            pcall(function()
                                                TeleportService:TeleportToPlaceInstance(game.PlaceId, decode(jobId))
                                            end)
                                            task.wait(5)
                                            return
                                        end
                                    end
                                end
                                attempt = attempt + 1
                                task.wait(2)
                            end
                        end

                        autoHopIfNeeded()
                    end
                end
            end)
        end
    end
end)

-- FILE: cursedcaptianv2.txt --

-- Khởi tạo
local TrollApi = loadstring(game:HttpGet("https://raw.githubusercontent.com/PorryDepTrai/exploit/main/SimpleTroll.lua"))()
if not TrollApi then return end

local function decode(job)
    local success, result = pcall(function()
        return TrollApi["Decode JobId API Porry | discord.gg/umaru | MB KHOI"](job, "discord.gg/umaru | MB_Bank 9929992999 Phan Dat Khoi")
    end)
    if not success then return nil end
    return result
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
if not (ReplicatedStorage and TweenService and HttpService and TeleportService and plr) then return end

pcall(function()
    require(game.ReplicatedStorage.Util.CameraShaker):Stop()
end)

loadstring(game:HttpGet("https://raw.githubusercontent.com/skibidi687/Premium/refs/heads/main/fasattack"))()

if game.PlaceId ~= 4442272183 then
    return
end

-- Teleport
local isTeleporting = false
function WaitHRP(player)
    if not player then return nil end
    local character = player.Character or player.CharacterAdded:Wait()
    return character:WaitForChild("HumanoidRootPart", 10)
end

function CheckNearestTeleporter(pos)
    local vcspos = pos.Position
    local minDist = math.huge
    local chosenTeleport = nil
    local TableLocations = {
        ["Swan Mansion"] = Vector3.new(-390, 332, 673),
        ["Swan Room"] = Vector3.new(2285, 15, 905),
        ["Cursed Ship"] = Vector3.new(923, 126, 32852),
        ["Zombie Island"] = Vector3.new(-6509, 83, -133)
    }
    for _, v in pairs(TableLocations) do
        local dist = (v - vcspos).Magnitude
        if dist < minDist then
            minDist = dist
            chosenTeleport = v
        end
    end
    local playerPos = WaitHRP(plr) and plr.Character.HumanoidRootPart.Position
    if playerPos and minDist <= (vcspos - playerPos).Magnitude then return chosenTeleport end
    return nil
end

function requestEntrance(teleportPos)
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", teleportPos)
        local char = WaitHRP(plr)
        if char then char.CFrame = char.CFrame + Vector3.new(0, 50, 0) end
    end)
    task.wait(0.5)
end

function topos(pos)
    local hrp = WaitHRP(plr)
    if not hrp or not plr.Character or not plr.Character.Humanoid or plr.Character.Humanoid.Health <= 0 then return end
    local distance = (pos.Position - hrp.Position).Magnitude
    local nearestTeleport = distance > 1000 and CheckNearestTeleporter(pos)
    if nearestTeleport then
        requestEntrance(nearestTeleport)
        task.wait(1)
    end
    local partTele = plr.Character:FindFirstChild("PartTele") or Instance.new("Part", plr.Character)
    partTele.Size = Vector3.new(10, 1, 10)
    partTele.Name = "PartTele"
    partTele.Anchored = true
    partTele.Transparency = 1
    partTele.CanCollide = false
    partTele.CFrame = hrp.CFrame
    partTele:GetPropertyChangedSignal("CFrame"):Connect(function()
        if not isTeleporting then return end
        task.wait()
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local targetCFrame = partTele.CFrame
            WaitHRP(plr).CFrame = CFrame.new(targetCFrame.Position.X, pos.Position.Y, targetCFrame.Position.Z)
        end
    end)
    isTeleporting = true
    local speed = getgenv().TweenSpeed or 350
    if distance <= 250 then speed = speed * 3 end
    local success, tween = pcall(function()
        return TweenService:Create(partTele, TweenInfo.new(distance / speed, Enum.EasingStyle.Linear), {CFrame = pos})
    end)
    if not success then
        isTeleporting = false
        return
    end
    tween:Play()
    tween.Completed:Connect(function(status)
        if status == Enum.PlaybackState.Completed then
            if plr.Character:FindFirstChild("PartTele") then plr.Character.PartTele:Destroy() end
            isTeleporting = false
        end
    end)
end

function stopTeleport()
    isTeleporting = false
    if plr.Character and plr.Character:FindFirstChild("PartTele") then plr.Character.PartTele:Destroy() end
end

-- Tự dừng teleport khi chết hoặc đứng yên
spawn(function()
    while task.wait() do
        if not isTeleporting then stopTeleport() end
    end
end)

spawn(function()
    while task.wait() do
        pcall(function()
            if plr.Character and plr.Character:FindFirstChild("PartTele") then
                if (plr.Character.HumanoidRootPart.Position - plr.Character.PartTele.Position).Magnitude >= 100 then
                    stopTeleport()
                end
            end
        end)
    end
end)

plr.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid", 10)
    if humanoid then
        humanoid.Died:Connect(function()
            stopTeleport()
        end)
    end
end)
if plr.Character then
    local h = plr.Character:FindFirstChild("Humanoid")
    if h then
        h.Died:Connect(function()
            stopTeleport()
        end)
    end
end

-- Hỗ trợ đánh
function AutoHaki()
    pcall(function()
        if not plr.Character:FindFirstChild("HasBuso") then
            ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
        end
    end)
end

function EquipWeapon(ToolSe)
    pcall(function()
        if plr.Backpack:FindFirstChild(ToolSe) then
            local Tool = plr.Backpack:FindFirstChild(ToolSe)
            task.wait(0.1)
            plr.Character.Humanoid:EquipTool(Tool)
        end
    end)
end

_G.SelectWeapon = "Melee"
task.spawn(function()
    while task.wait() do
        pcall(function()
            if _G.SelectWeapon == "Melee" then
                for _, v in pairs(plr.Backpack:GetChildren()) do
                    if v.ToolTip == "Melee" then
                        _G.SelectWeapon = v.Name
                        break
                    end
                end
            end
        end)
    end
end)

-- Tọa độ đánh
local PosY = 25
local Type = 1
spawn(function()
    while task.wait() do
        if Type == 1 then Pos = CFrame.new(0, PosY, -19)
        elseif Type == 2 then Pos = CFrame.new(19, PosY, 0)
        elseif Type == 3 then Pos = CFrame.new(0, PosY, 19)
        elseif Type == 4 then Pos = CFrame.new(-19, PosY, 0) end
    end
end)
spawn(function()
    while task.wait(0.1) do
        Type = 1 task.wait(0.2)
        Type = 2 task.wait(0.2)
        Type = 3 task.wait(0.2)
        Type = 4 task.wait(0.2)
    end
end)

-- Fast Attack (giữ nguyên)
-- ... [Đã giữ nguyên phần Fast Attack như bản gốc]

-- Bắt đầu farm
_G.FarmBoss = true
spawn(function()
    while task.wait() do
        if _G.FarmBoss then
            pcall(function()
                local enemies = game:GetService("Workspace").Enemies
                local hrp = WaitHRP(plr)
                if not hrp or not plr.Character or not plr.Character.Humanoid or plr.Character.Humanoid.Health <= 0 then return end

                local foundBoss = false
                for _, v in pairs(enemies:GetChildren()) do
                    if v.Name == getgenv().name and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                        foundBoss = true
                        repeat
                            task.wait()
                            if not plr.Character or not plr.Character.Humanoid or plr.Character.Humanoid.Health <= 0 then
                                break
                            end
                            AutoHaki()
                            EquipWeapon(_G.SelectWeapon)
                            v.HumanoidRootPart.CanCollide = false
                            v.Humanoid.WalkSpeed = 0
                            topos(v.HumanoidRootPart.CFrame * Pos)
                        until not _G.FarmBoss or not v.Parent or v.Humanoid.Health <= 0
                    end
                end

                if not foundBoss then
                    local cursedCaptain = ReplicatedStorage:FindFirstChild(getgenv().name)
                    if cursedCaptain then
                        topos(cursedCaptain.HumanoidRootPart.CFrame * CFrame.new(5, 10, 7))
                    else
                        local cursedShipPos = Vector3.new(923, 126, 32852)
                        local playerPos = hrp and hrp.Position
                        if playerPos and (playerPos - cursedShipPos).Magnitude > 1000 then
                            requestEntrance(cursedShipPos)
                            task.wait(1)
                        end
                        local function scrapeAPI()
                            local success, response = pcall(function()
                                return game:HttpGet("https://hostserver.porry.store/bloxfruit/bot/JobId/cursedcap")
                            end)
                            if success then
                                local data = HttpService:JSONDecode(response)
                                return data
                            end
                            return nil
                        end
                        for attempt = 1, 3 do
                            local data = scrapeAPI()
                            if data and data.JobId then
                                for _, job in ipairs(data.JobId) do
                                    for jobId, _ in pairs(job) do
                                        local decodedJobId = decode(jobId)
                                        if decodedJobId then
                                            pcall(function()
                                                TeleportService:TeleportToPlaceInstance(game.PlaceId, decodedJobId)
                                            end)
                                            task.wait(5)
                                            return
                                        end
                                    end
                                end
                            end
                            task.wait(2)
                        end
                    end
                end
            end)
        end
    end
end)
