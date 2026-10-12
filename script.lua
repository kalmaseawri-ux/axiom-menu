
--[[
    AXIOM ULTIMATE CONTROL V4
    Place as a LocalScript in:
    StarterPlayer > StarterPlayerScripts

    Designed for your own Roblox Studio game.
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local CONFIG = {
    DefaultSpeed = 16,
    MinSpeed = 8,
    MaxSpeed = 100,
    FlySpeed = 55,
    Accent = Color3.fromRGB(0, 190, 255),
    Background = Color3.fromRGB(13, 16, 26),
    Panel = Color3.fromRGB(24, 29, 43),
    Button = Color3.fromRGB(35, 43, 61),
}

local old = playerGui:FindFirstChild("AXIOM_ULTIMATE")
if old then old:Destroy() end

local state = {
    flying = false,
    speedEnabled = false,
    speed = CONFIG.DefaultSpeed,
    connections = {},
}

local function track(connection)
    table.insert(state.connections, connection)
    return connection
end

local function getCharacter()
    local character = player.Character
    if not character then return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")

    return character, humanoid, root
end

-- GUI root
local gui = Instance.new("ScreenGui")
gui.Name = "AXIOM_ULTIMATE"
gui.ResetOnSpawn = false
gui.DisplayOrder = 100
gui.Parent = playerGui

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(350, 440)
main.Position = UDim2.new(0.5, -175, 0.5, -220)
main.BackgroundColor3 = CONFIG.Background
main.BorderSizePixel = 0
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)

local outline = Instance.new("UIStroke")
outline.Color = CONFIG.Accent
outline.Thickness = 1.5
outline.Parent = main

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 58)
header.BackgroundColor3 = CONFIG.Panel
header.BorderSizePixel = 0
header.Parent = main
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 14)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -65, 1, 0)
title.Position = UDim2.fromOffset(16, 0)
title.BackgroundTransparency = 1
title.Text = "AXIOM // CONTROL"
title.TextColor3 = CONFIG.Accent
title.Font = Enum.Font.GothamBold
title.TextSize = 19
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(36, 36)
close.Position = UDim2.new(1, -46, 0, 11)
close.Text = "×"
close.TextSize = 24
close.Font = Enum.Font.GothamBold
close.TextColor3 = Color3.new(1, 1, 1)
close.BackgroundColor3 = CONFIG.Button
close.Parent = header
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 9)

local content = Instance.new("ScrollingFrame")
content.Position = UDim2.fromOffset(14, 70)
content.Size = UDim2.new(1, -28, 1, -120)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 4
content.ScrollBarImageColor3 = CONFIG.Accent
content.CanvasSize = UDim2.new()
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
content.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 9)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = content

local status = Instance.new("TextLabel")
status.Position = UDim2.new(0, 14, 1, -42)
status.Size = UDim2.new(1, -28, 0, 28)
status.BackgroundTransparency = 1
status.Text = "● SYSTEM READY"
status.TextColor3 = Color3.fromRGB(100, 230, 170)
status.Font = Enum.Font.GothamMedium
status.TextSize = 12
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = main

local function setStatus(message, color)
    status.Text = "● " .. message
    status.TextColor3 = color or Color3.fromRGB(100, 230, 170)
end

local function createButton(text, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -2, 0, 42)
    b.BackgroundColor3 = CONFIG.Button
    b.TextColor3 = Color3.fromRGB(240, 245, 255)
    b.Text = text
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 13
    b.AutoButtonColor = true
    b.Parent = content

    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 9)

    local edge = Instance.new("UIStroke")
    edge.Color = Color3.fromRGB(48, 63, 86)
    edge.Thickness = 1
    edge.Parent = b

    b.Activated:Connect(function()
        local ok, err = pcall(callback)
        if not ok then
            warn("[AXIOM] " .. tostring(err))
            setStatus("ACTION FAILED", Color3.fromRGB(255, 100, 100))
        end
    end)

    return b
end

local function createSection(text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 24)
    label.BackgroundTransparency = 1
    label.Text = "— " .. text
    label.TextColor3 = CONFIG.Accent
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = content
    return label
end

-- Speed controls
createSection("MOVEMENT")

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(1, -2, 0, 40)
speedInput.BackgroundColor3 = CONFIG.Panel
speedInput.TextColor3 = Color3.new(1, 1, 1)
speedInput.PlaceholderText = "WalkSpeed: 8 - 100"
speedInput.Text = tostring(CONFIG.DefaultSpeed)
speedInput.ClearTextOnFocus = false
speedInput.Font = Enum.Font.Gotham
speedInput.TextSize = 14
speedInput.Parent = content
Instance.new("UICorner", speedInput).CornerRadius = UDim.new(0, 9)

createButton("APPLY WALK SPEED", function()
    local value = tonumber(speedInput.Text)
    if not value or value < CONFIG.MinSpeed or value > CONFIG.MaxSpeed then
        setStatus("ENTER SPEED 8 - 100", Color3.fromRGB(255, 180, 80))
        return
    end

    local _, humanoid = getCharacter()
    if not humanoid then
        setStatus("CHARACTER NOT FOUND", Color3.fromRGB(255, 100, 100))
        return
    end

    state.speed = value
    state.speedEnabled = true
    humanoid.WalkSpeed = value
    setStatus("WALKSPEED: " .. value)
end)

createButton("RESET WALK SPEED", function()
    local _, humanoid = getCharacter()
    if humanoid then
        state.speed = CONFIG.DefaultSpeed
        state.speedEnabled = false
        humanoid.WalkSpeed = CONFIG.DefaultSpeed
        speedInput.Text = tostring(CONFIG.DefaultSpeed)
        setStatus("WALKSPEED RESET")
    end
end)

-- Fly mode for the developer's own game
createSection("FLIGHT")

local flyVelocity
local flyGyro
local flyConnection

local function stopFly()
    state.flying = false

    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end

    if flyVelocity then
        flyVelocity:Destroy()
        flyVelocity = nil
    end

    if flyGyro then
        flyGyro:Destroy()
        flyGyro = nil
    end

    local _, humanoid = getCharacter()
    if humanoid then
        humanoid.PlatformStand = false
        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
    end

    setStatus("FLIGHT DISABLED")
end

local function startFly()
    local _, humanoid, root = getCharacter()
    if not humanoid or not root then
        setStatus("CHARACTER NOT FOUND", Color3.fromRGB(255, 100, 100))
        return
    end

    if state.flying then return end
    state.flying = true
    humanoid.PlatformStand = true

    flyVelocity = Instance.new("BodyVelocity")
    flyVelocity.Name = "AxiomFlightVelocity"
    flyVelocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
    flyVelocity.Velocity = Vector3.zero
    flyVelocity.Parent = root

    flyGyro = Instance.new("BodyGyro")
    flyGyro.Name = "AxiomFlightGyro"
    flyGyro.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
    flyGyro.P = 15000
    flyGyro.CFrame = workspace.CurrentCamera.CFrame
    flyGyro.Parent = root

    flyConnection = RunService.RenderStepped:Connect(function()
        if not state.flying or not root.Parent then
            stopFly()
            return
        end

        local camera = workspace.CurrentCamera
        local direction = Vector3.zero

        if UIS:IsKeyDown(Enum.KeyCode.W) then
            direction += camera.CFrame.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.S) then
            direction -= camera.CFrame.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.A) then
            direction -= camera.CFrame.RightVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.D) then
            direction += camera.CFrame.RightVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then
            direction += Vector3.yAxis
        end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
            direction -= Vector3.yAxis
        end

        flyVelocity.Velocity = direction.Magnitude > 0
            and direction.Unit * CONFIG.FlySpeed
            or Vector3.zero

        flyGyro.CFrame = camera.CFrame
    end)

    setStatus("FLIGHT ENABLED: WASD / SPACE / CTRL")
end

createButton("FLIGHT: ON / OFF", function()
    if state.flying then
        stopFly()
    else
        startFly()
    end
end)

-- Character tools
createSection("CHARACTER")

createButton("CHECK CHARACTER", function()
    local character, humanoid, root = getCharacter()
    if character and humanoid and root then
        setStatus("CHARACTER READY")
    else
        setStatus("CHARACTER INCOMPLETE", Color3.fromRGB(255, 180, 80))
    end
end)

createButton("RESET CHARACTER", function()
    local _, humanoid = getCharacter()
    if humanoid then
        stopFly()
        humanoid.Health = 0
        setStatus("CHARACTER RESET")
    end
end)

createButton("RESET WINDOW POSITION", function()
    main.Position = UDim2.new(0.5, -175, 0.5, -220)
    setStatus("WINDOW POSITION RESET")
end)

-- Minimize / restore
local reopen = Instance.new("TextButton")
reopen.Size = UDim2.fromOffset(125, 40)
reopen.Position = UDim2.new(0, 16, 0.5, -20)
reopen.BackgroundColor3 = Color3.fromRGB(15, 75, 130)
reopen.TextColor3 = Color3.new(1, 1, 1)
reopen.Text = "OPEN AXIOM"
reopen.Font = Enum.Font.GothamBold
reopen.TextSize = 12
reopen.Visible = false
reopen.Parent = gui
Instance.new("UICorner", reopen).CornerRadius = UDim.new(0, 9)

close.Activated:Connect(function()
    main.Visible = false
    reopen.Visible = true
end)

reopen.Activated:Connect(function()
    main.Visible = true
    reopen.Visible = false
end)

-- Drag window by header
local dragging = false
local dragStart
local startPosition

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPosition = main.Position
    end
end)

track(UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end))

track(UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end))

track(player.CharacterAdded:Connect(function(character)
    if state.flying then stopFly() end

    local humanoid = character:WaitForChild("Humanoid", 10)
    if humanoid and state.speedEnabled then
        humanoid.WalkSpeed = state.speed
    end
end))

track(gui.Destroying:Connect(function()
    stopFly()
    for _, connection in ipairs(state.connections) do
        connection:Disconnect()
    end
end))

print("[AXIOM] Ultimate Control loaded successfully")
