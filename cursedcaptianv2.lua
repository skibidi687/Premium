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
                    if v.Name == "Cursed Captain" and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
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
                    local cursedCaptain = ReplicatedStorage:FindFirstChild("Cursed Captain")
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