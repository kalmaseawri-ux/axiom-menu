
-- AXIOM CONTROL V3
-- For your own Roblox Studio game

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("AXIOM_V3")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "AXIOM_V3"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(330, 390)
main.Position = UDim2.new(0.5, -165, 0.5, -195)
main.BackgroundColor3 = Color3.fromRGB(20, 23, 34)
main.BorderSizePixel = 0
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(65, 140, 255)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 45)
title.Position = UDim2.fromOffset(12, 0)
title.BackgroundTransparency = 1
title.Text = "AXIOM CONTROL V3"
title.TextColor3 = Color3.fromRGB(115, 175, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 19
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -24, 0, 28)
status.Position = UDim2.new(0, 12, 1, -34)
status.BackgroundTransparency = 1
status.Text = "STATUS: READY"
status.TextColor3 = Color3.fromRGB(100, 220, 160)
status.Font = Enum.Font.Gotham
status.TextSize = 12
status.Parent = main

local content = Instance.new("Frame")
content.Position = UDim2.fromOffset(12, 52)
content.Size = UDim2.new(1, -24, 1, -94)
content.BackgroundTransparency = 1
content.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = content

local function button(text, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 40)
    b.BackgroundColor3 = Color3.fromRGB(38, 44, 61)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 14
    b.Text = text
    b.Parent = content
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    b.Activated:Connect(callback)
    return b
end

-- Speed control
local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(1, 0, 0, 38)
speedBox.BackgroundColor3 = Color3.fromRGB(38, 44, 61)
speedBox.TextColor3 = Color3.new(1, 1, 1)
speedBox.PlaceholderText = "Speed: 16 - 100"
speedBox.Text = "28"
speedBox.Font = Enum.Font.Gotham
speedBox.TextSize = 14
speedBox.ClearTextOnFocus = false
speedBox.Parent = content
Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0, 8)

button("APPLY WALK SPEED", function()
    local speed = tonumber(speedBox.Text)
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    if not speed or speed < 16 or speed > 100 then
        status.Text = "STATUS: ENTER 16 - 100"
        return
    end

    if humanoid then
        humanoid.WalkSpeed = speed
        status.Text = "STATUS: SPEED " .. speed
    else
        status.Text = "STATUS: CHARACTER NOT FOUND"
    end
end)

-- Fly controls for your own game
local flying = false
local flyConnection
local velocity
local gyro
local root
local humanoid

local function stopFly()
    flying = false
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    if velocity then velocity:Destroy(); velocity = nil end
    if gyro then gyro:Destroy(); gyro = nil end

    local character = player.Character
    local h = character and character:FindFirstChildOfClass("Humanoid")
    if h then
        h.PlatformStand = false
        h:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
    status.Text = "STATUS: FLY OFF"
end

local function startFly()
    local character = player.Character
    humanoid = character and character:FindFirstChildOfClass("Humanoid")
    root = character and character:FindFirstChild("HumanoidRootPart")

    if not humanoid or not root then
        status.Text = "STATUS: CHARACTER NOT FOUND"
        return
    end

    flying = true
    humanoid.PlatformStand = true

    velocity = Instance.new("BodyVelocity")
    velocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
    velocity.Velocity = Vector3.zero
    velocity.Parent = root

    gyro = Instance.new("BodyGyro")
    gyro.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
    gyro.P = 1e4
    gyro.CFrame = workspace.CurrentCamera.CFrame
    gyro.Parent = root

    flyConnection = RunService.RenderStepped:Connect(function()
        if not flying or not root or not root.Parent then
            stopFly()
            return
        end

        local camera = workspace.CurrentCamera
        local move = Vector3.zero

        if UIS:IsKeyDown(Enum.KeyCode.W) then
            move += camera.CFrame.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.S) then
            move -= camera.CFrame.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.D) then
            move += camera.CFrame.RightVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.A) then
            move -= camera.CFrame.RightVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then
            move += Vector3.yAxis
        end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
            move -= Vector3.yAxis
        end

        velocity.Velocity = move.Magnitude > 0
            and move.Unit * 50 or Vector3.zero

        gyro.CFrame = camera.CFrame
    end)

    status.Text = "STATUS: FLY ON - WASD / SPACE / CTRL"
end

button("FLY: TOGGLE", function()
    if flying then
        stopFly()
    else
        startFly()
    end
end)

button("RESET WALK SPEED", function()
    local character = player.Character
    local h = character and character:FindFirstChildOfClass("Humanoid")
    if h then
        h.WalkSpeed = 16
        speedBox.Text = "16"
        status.Text = "STATUS: SPEED RESET"
    end
end)

button("CLOSE MENU", function()
    main.Visible = false
    reopen.Visible = true
end)

local reopen = Instance.new("TextButton")
reopen.Size = UDim2.fromOffset(115, 38)
reopen.Position = UDim2.new(0, 12, 0.5, 0)
reopen.Text = "OPEN AXIOM"
reopen.TextColor3 = Color3.new(1, 1, 1)
reopen.BackgroundColor3 = Color3.fromRGB(35, 95, 200)
reopen.Font = Enum.Font.GothamBold
reopen.TextSize = 12
reopen.Visible = false
reopen.Parent = gui
Instance.new("UICorner", reopen).CornerRadius = UDim.new(0, 8)

reopen.Activated:Connect(function()
    main.Visible = true
    reopen.Visible = false
end)

-- Drag the window by its title
local dragging, dragStart, startPosition

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPosition = main.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

player.CharacterAdded:Connect(function()
    if flying then stopFly() end
end)

print("[AXIOM] V3 menu loaded")
