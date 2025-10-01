-- Auto Tushita Sword Script for KAITUN
-- Tự động: Kiểm tra rip_indra → Thắp đuốc → Đánh Longma

-- Các hàm hỗ trợ từ rip_indra.lua
local TrollApi = loadstring(game:HttpGet("https://raw.githubusercontent.com/PorryDepTrai/exploit/main/SimpleTroll.lua"))()
local function decode(job) return TrollApi["Decode JobId API Porry | discord.gg/umaru | MB KHOI"](job, "discord.gg/umaru | MB_Bank 9929992999 Phan Dat Khoi") end

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

-- Noclip System
spawn(function()
    pcall(function()
        while task.wait() do
            if _G.Auto_Tushita then
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
            if _G.Auto_Tushita then
                for _, v in pairs(game:GetService("Players").LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end
        end)
    end)
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

function GetBP(itemName)
    return game.Players.LocalPlayer.Backpack:FindFirstChild(itemName) or 
           game.Players.LocalPlayer.Character:FindFirstChild(itemName)
end

function GetConnectionEnemies(enemyName)
    for _, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
        if v.Name == enemyName and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
            return v
        end
    end
    return nil
end

-- Kiểm tra rip_indra True Form
function CheckRipIndra()
    for _, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
        if v.Name == "rip_indra True Form" and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
            return true
        end
    end
    
    if game:GetService("ReplicatedStorage"):FindFirstChild("rip_indra True Form") then
        return true
    end
    
    return false
end

-- Kiểm tra đã có Tushita Sword chưa
function HasTushitaSword()
    return GetBP("Tushita") ~= nil
end

-- Hàm hop server
function HopServer()
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

-- Vị trí tấn công
local PosY = 25
local Type = 1
local Pos = CFrame.new(0, PosY, -19)

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

-- Weapon Selection
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
            end
        end)
    end
end)

-- Attack System
local Attack = {}
function Attack.Kill(enemy, condition)
    local plr = game.Players.LocalPlayer
    if not enemy or not enemy:FindFirstChild("Humanoid") or not enemy:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    repeat
        task.wait()
        if not plr.Character or not plr.Character.Humanoid or plr.Character.Humanoid.Health <= 0 then
            break
        end
        if not enemy.Parent or enemy.Humanoid.Health <= 0 then
            break
        end
        
        AutoHaki()
        EquipWeapon(_G.SelectWeapon)
        enemy.HumanoidRootPart.CanCollide = false
        enemy.Humanoid.WalkSpeed = 0
        topos(enemy.HumanoidRootPart.CFrame * Pos)
        sethiddenproperty(plr, "SimulationRadius", math.huge)
    until not condition or not enemy.Parent or enemy.Humanoid.Health <= 0
end

-- Biến theo dõi trạng thái
_G.TorchesLit = false
_G.TushitaStep = "CheckIndra" -- CheckIndra, LightTorches, KillLongma, Complete

-- Hàm thắp đuốc
function LightTorches()
    local plr = game.Players.LocalPlayer
    
    -- Kiểm tra có Holy Torch không
    if not GetBP("Holy Torch") then
        topos(CFrame.new(5148.03613, 162.352493, 910.548218))
        wait(0.7)
        return false
    end
    
    -- Có Holy Torch, bắt đầu thắp đuốc
    EquipWeapon("Holy Torch")
    task.wait(1)
    
    -- Đuốc 1
    repeat 
        task.wait() 
        topos(CFrame.new(-10752, 417, -9366)) 
    until not _G.Auto_Tushita or (CFrame.new(-10752, 417, -9366).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10
    wait(0.7)
    
    -- Đuốc 2
    repeat 
        task.wait() 
        topos(CFrame.new(-11672, 334, -9474)) 
    until not _G.Auto_Tushita or (CFrame.new(-11672, 334, -9474).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10
    wait(0.7)
    
    -- Đuốc 3
    repeat 
        task.wait() 
        topos(CFrame.new(-12132, 521, -10655)) 
    until not _G.Auto_Tushita or (CFrame.new(-12132, 521, -10655).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10
    wait(0.7)
    
    -- Đuốc 4
    repeat 
        task.wait() 
        topos(CFrame.new(-13336, 486, -6985)) 
    until not _G.Auto_Tushita or (CFrame.new(-13336, 486, -6985).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10
    wait(0.7)
    
    -- Đuốc 5
    repeat 
        task.wait() 
        topos(CFrame.new(-13489, 332, -7925)) 
    until not _G.Auto_Tushita or (CFrame.new(-13489, 332, -7925).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10
    wait(0.7)
    
    _G.TorchesLit = true
    return true
end

-- Main Auto Tushita Logic for KAITUN
local Sec = 0.1
local plr = game.Players.LocalPlayer
local replicated = game:GetService("ReplicatedStorage")

local Q = Tabs.Quests:AddToggle("Q", {
    Title = "Auto Tushita [KAITUN]", 
    Description = "Tự động farm Tushita khi bật lên", 
    Default = false
})

Q:OnChanged(function(Value)
    _G.Auto_Tushita = Value
    if not Value then
        _G.TorchesLit = false
        _G.TushitaStep = "CheckIndra"
    end
end)

-- AUTO START WHEN ENABLED
spawn(function()
    while wait(Sec) do
        pcall(function()
            if _G.Auto_Tushita then
                
                -- KIỂM TRA ĐÃ CÓ TUSHITA CHƯA
                if HasTushitaSword() then
                    _G.Auto_Tushita = false
                    return
                end
                
                -- BƯỚC 1: KIỂM TRA RIP_INDRA
                if _G.TushitaStep == "CheckIndra" then
                    if not CheckRipIndra() then
                        HopServer()
                        return
                    else
                        _G.TushitaStep = "LightTorches"
                    end
                end
                
                -- BƯỚC 2: THẮP ĐỐC
                if _G.TushitaStep == "LightTorches" then
                    if workspace.Map.Turtle:FindFirstChild("TushitaGate") then
                        _G.TushitaStep = "Complete"
                        return
                    end
                    
                    if not _G.TorchesLit then
                        local success = LightTorches()
                        if success then
                            _G.TushitaStep = "KillLongma"
                        end
                    else
                        _G.TushitaStep = "KillLongma"
                    end
                end
                
                -- BƯỚC 3: ĐÁNH LONGMA (Giết xong = nhận Tushita)
                if _G.TushitaStep == "KillLongma" then
                    local v = GetConnectionEnemies("Longma")
                    if v then 
                        repeat 
                            task.wait() 
                            Attack.Kill(v, _G.Auto_Tushita) 
                        until v.Humanoid.Health <= 0 or not _G.Auto_Tushita or not v.Parent
                        
                        -- Sau khi giết xong Longma
                        wait(2)
                        
                        -- Kiểm tra đã nhận được Tushita chưa
                        if HasTushitaSword() then
                            -- Đã có Tushita → Hoàn thành
                            _G.Auto_Tushita = false
                            _G.TushitaStep = "Complete"
                        else
                            -- Chưa có Tushita → Thắp lại đuốc
                            _G.TorchesLit = false
                            _G.TushitaStep = "LightTorches"
                        end
                    else 
                        -- Longma chưa spawn
                        if replicated:FindFirstChild("Longma") then 
                            topos(replicated:FindFirstChild("Longma").HumanoidRootPart.CFrame * CFrame.new(0, 40, 0)) 
                        end
                    end
                end
                
            end
        end)
    end
end)