-- ⚔️ Auto chọn team
pcall(function()
    if getgenv().team == "Pirates" or getgenv().team == "Marines" then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", getgenv().team)
        warn("Đã chọn team: " .. getgenv().team)
    end
end)

-- 🚀 FPS Boost
if getgenv().FPS then
    task.spawn(function()
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") then
                v.Material = Enum.Material.Plastic
                v.Reflectance = 0
                v.CastShadow = false
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Enabled = false
            elseif v:IsA("PointLight") or v:IsA("SpotLight") or v:IsA("SurfaceLight") then
                v.Enabled = false
            end
        end
        local Lighting = game:GetService("Lighting")
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        sethiddenproperty(Lighting, "Technology", Enum.Technology.Compatibility)
        warn("FPS Boost: ON")
    end)
end

-- 🔥 Auto V4
if getgenv().V4 then
    task.spawn(function()
        while task.wait(5) do
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Awakening", "Start")
            end)
        end
    end)
    warn("Auto V4: ON")
end

-- 📜 Boss Scripts Loader
local scripts = {
    Darkbread = "https://raw.githubusercontent.com/skibidi687/Premium/refs/heads/main/darkbread.lua",
    Doughking = "https://raw.githubusercontent.com/skibidi687/Premium/refs/heads/main/doughking.lua",
    Rip_indra = "https://raw.githubusercontent.com/skibidi687/Premium/refs/heads/main/rip_indra.lua",
    Tyrant = "https://raw.githubusercontent.com/skibidi687/Premium/refs/heads/main/tyrantoftheskies.lua",
    Cursed_captian = "https://raw.githubusercontent.com/skibidi687/Premium/refs/heads/main/cursedcaptian.lua",
    Tushita = "https://raw.githubusercontent.com/skibidi687/Premium/refs/heads/main/tushita.lua"
}

if getgenv().name ~= "" and scripts[getgenv().name] then
    loadstring(game:HttpGet(scripts[getgenv().name]))()
    warn("Đã load script boss: " .. getgenv().name)
else
    warn("Không có boss hoặc để trống name")
end