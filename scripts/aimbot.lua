getgenv().Main = loadstring(game:HttpGet("https://raw.githubusercontent.com/SuperGamingBros4/Roblox-HAX/main/Better_UI_Library.lua"))()

local camera = game:GetService("Workspace").CurrentCamera 
local Plr = game:GetService("Players").LocalPlayer
local RS = game:GetService("RunService")
local mouse = Plr:GetMouse()

function getclosestplayertomouse()
    local Target = nil
    for i,v in pairs(game:GetService("Players"):GetPlayers()) do
        if v.Character then
            if v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("Humanoid").Health ~= 0 and v.Character:FindFirstChild("HumanoidRootPart") and v.TeamColor ~= Plr.TeamColor then
                local pos, vis = camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                local dist = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
                if Main.Flags.VisCheck then
                    if Main.Flags.Size > dist and vis then
                        Target = v
                        print(dist)
                    end
                else
                    if Main.Flags.Size > dist then
                        Target = v
                    end
                end
            end
        end
    end
    return Target
end

local circle = Drawing.new("Circle")
circle.Thickness = 0.1
RS.RenderStepped:Connect(function()
    local Settings = Main.Flags
    
    if Settings.Aimbot and Settings.FovCircle then -- FovCircle
        circle.Visible = true
        circle.Color = Color3.fromRGB(Settings.FovRed, Settings.FovGreen, Settings.FovBlue)
        circle.NumSides = Settings.Smoothing
        circle.Radius = Settings.Size
	    circle.Position = Vector2.new(mouse.X, mouse.Y + 35)
    else
        circle.Visible = false
    end
    
    if Settings.Aimbot then -- Aimbot
        for i,arrow in pairs(game:GetService("Workspace"):GetChildren()) do
            if arrow.Name == "arrow" or arrow.Name == "crossbow_arrow" then
                pcall(function()
                    arrow:WaitForChild("Handle").Position = getclosestplayertomouse().Character.HumanoidRootPart.Position
                end)
            end
        end
    end
    if Main.Flags.Speed then -- Toggle Speed
        pcall(function() Plr.Character.Humanoid.WalkSpeed = 22 end)
    end
end)

local function InvisPlayer()
    getgenv().InvisRunning = false
    wait(0.01)
    getgenv().InvisRunning = true
    pcall(function()
        local CFrame = Plr.Character.UpperTorso.CFrame
        Plr.Character.HumanoidRootPart:BreakJoints()
        while InvisRunning do
            Plr.Character.UpperTorso.CFrame = CFrame
            wait(0.000001)
        end
    end)
end

coroutine.wrap(function()
    while true do
        wait(1)
        if Main.Flags.InstantBreak then -- InstantBreak
            for i,block in pairs(game:GetService("Workspace").Map.Blocks:GetChildren()) do
                block:SetAttribute("Health", 1) 
            end
        end
    end
end)()
local Window = Main:CreateWindow("BedWars")
local MainTab = Window:AddTab("Main") do
    MainTab:AddToggle({Name = "Aimbot", Flag = "Aimbot"})
    MainTab:AddToggle({Name = "AimBot Circle", Flag = "FovCircle"})
    MainTab:AddToggle({Name = "VisCheck", Flag = "VisCheck"})
    MainTab:AddSlider({Name = "Aimbot Fov", Default = 50, Max = 500, Flag = "Size"})
    MainTab:AddToggle({Name = "Toggle Sprint", Flag = "Speed"})
    MainTab:AddToggle({Name = "Instant Break", Flag = "InstantBreak"})
    MainTab:AddText("To get out of invisibility, just reset.")
    MainTab:AddButton({Name = "Invisibility", Callback = InvisPlayer})
end
local SettingsTab = Window:AddTab("Settings") do
    SettingsTab:AddText("Fov Circle Settings")
    SettingsTab:AddSlider({Name = "Red", Flag = "FovRed", Default = 255, Max = 255})
    SettingsTab:AddSlider({Name = "Green", Flag = "FovGreen", Default = 255, Max = 255})
    SettingsTab:AddSlider({Name = "Blue", Flag = "FovBlue", Default = 255, Max = 255})
    SettingsTab:AddSlider({Name = "Smoothness", Flag = "Smoothing", Min = 12, Default = 40, Max = 75})
end
