# orbit-aura.lua
-- Exploit Hub GUI | SuccCopier Scripts
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Create ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "SuccCopierHub"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = gethui and gethui() or LocalPlayer.PlayerGui

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 280, 0, 380)
main.Position = UDim2.new(0, 20, 0.5, -190)
main.BackgroundColor3 = Color3.fromRGB(7, 10, 16)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

-- Gradient border effect
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(96, 165, 250)
stroke.Thickness = 1.5
stroke.Parent = main

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 6)
corner.Parent = main

-- Title bar
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 36)
title.BackgroundColor3 = Color3.fromRGB(11, 16, 24)
title.BorderSizePixel = 0
title.Text = " ◈ SuccCopier Hub"
title.TextColor3 = Color3.fromRGB(96, 165, 250)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = main
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 6)

-- Toggle function
local toggles = {}
local function addToggle(name, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 34)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(15, 21, 32)
    btn.BorderSizePixel = 0
    btn.Text = "○  " .. name
    btn.TextColor3 = Color3.fromRGB(150, 180, 220)
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.Parent = main
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.Text = (active and "●  " or "○  ") .. name
        btn.TextColor3 = active and Color3.fromRGB(96, 165, 250) or Color3.fromRGB(150, 180, 220)
        callback(active)
    end)
    return btn
end

-- Speed hack
local speedEnabled = false
addToggle("Speed Hack (500)", 46, function(on)
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = on and 500 or 16 end
    end
    speedEnabled = on
end)

-- Infinite jump
addToggle("Infinite Jump", 86, function(on)
    if on then
        UserInputService.JumpRequest:Connect(function()
            if not speedEnabled then return end
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    end
end)

-- Noclip
local noclipConn = nil
addToggle("Noclip", 126, function(on)
    if on then
        noclipConn = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end)
    elseif noclipConn then
        noclipConn:Disconnect(); noclipConn = nil
    end
end)

-- God mode
addToggle("God Mode", 166, function(on)
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.MaxHealth = on and math.huge or 100; hum.Health = hum.MaxHealth end
end)

-- Anti AFK
local VU = game:GetService("VirtualUser")
addToggle("Anti-AFK", 206, function(on)
    if on then
        LocalPlayer.Idled:Connect(function()
            VU:Button2Down(Vector2.zero, workspace.CurrentCamera.CFrame)
            task.wait(0.5)
            VU:Button2Up(Vector2.zero, workspace.CurrentCamera.CFrame)
        end)
    end
end)

-- Close button
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 24, 0, 24)
close.Position = UDim2.new(1, -30, 0, 6)
close.BackgroundTransparency = 1
close.Text = "✕"
close.TextColor3 = Color3.fromRGB(80, 100, 140)
close.Font = Enum.Font.GothamBold
close.TextSize = 14
close.Parent = main
close.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)

-- Keybind to reopen (RightShift)
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        main.Visible = not main.Visible
    end
end)

print("[SuccCopier] Hub GUI loaded. RightShift to toggle.")
