
--================================================
-- AXIOM CONTROL MENU v2.0
-- Roblox Studio | LocalScript
--================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
if not player then
    warn("[AXIOM] This script must run on the client.")
    return
end

local playerGui = player:WaitForChild("PlayerGui")

-- Remove previous instance
local previous = playerGui:FindFirstChild("AXIOM_V2")
if previous then
    previous:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "AXIOM_V2"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false
gui.DisplayOrder = 999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(320, 330)
main.Position = UDim2.new(0.5, -160, 0.5, -165)
main.BackgroundColor3 = Color3.fromRGB(20, 23, 34)
main.BorderSizePixel = 0
main.Visible = true
main.Parent = gui

Instance.new("UICorner", main).CornerRadius =
    UDim.new(0, 12)

local border = Instance.new("UIStroke")
border.Color = Color3.fromRGB(65, 140, 255)
border.Thickness = 1.5
border.Parent = main

local header = Instance.new("TextLabel")
header.Name = "Header"
header.Size = UDim2.new(1, -55, 0, 48)
header.Position = UDim2.fromOffset(15, 0)
header.BackgroundTransparency = 1
header.Text = "AXIOM CONTROL"
header.TextColor3 = Color3.fromRGB(115, 175, 255)
header.Font = Enum.Font.GothamBold
header.TextSize = 19
header.TextXAlignment = Enum.TextXAlignment.Left
header.Parent = main

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(34, 34)
close.Position = UDim2.new(1, -42, 0, 7)
close.Text = "X"
close.TextColor3 = Color3.new(1, 1, 1)
close.BackgroundColor3 = Color3.fromRGB(55, 60, 78)
close.Font = Enum.Font.GothamBold
close.TextSize = 15
close.Parent = main

Instance.new("UICorner", close).CornerRadius =
    UDim.new(0, 8)

local reopen = Instance.new("TextButton")
reopen.Size = UDim2.fromOffset(100, 38)
reopen.Position = UDim2.new(0, 16, 0.5, -19)
reopen.Text = "OPEN AXIOM"
reopen.TextColor3 = Color3.new(1, 1, 1)
reopen.BackgroundColor3 = Color3.fromRGB(35, 95, 200)
reopen.Font = Enum.Font.GothamBold
reopen.TextSize = 12
reopen.Visible = false
reopen.Parent = gui

Instance.new("UICorner", reopen).CornerRadius =
    UDim.new(0, 8)

close.Activated:Connect(function()
    main.Visible = false
    reopen.Visible = true
end)

reopen.Activated:Connect(function()
    main.Visible = true
    reopen.Visible = false
end)

-- Drag window
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

UIS.InputChanged:Connect(function(input)
    if dragging and
        input.UserInputType == Enum.UserInputType.MouseMovement then

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

local content = Instance.new("Frame")
content.Size = UDim2.new(1, -30, 0, 215)
content.Position = UDim2.fromOffset(15, 58)
content.BackgroundTransparency = 1
content.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 9)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = content

local function makeButton(label, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 40)
    button.BackgroundColor3 = Color3.fromRGB(38, 44, 61)
    button.TextColor3 = Color3.fromRGB(240, 243, 255)
    button.Text = label
    button.Font = Enum.Font.GothamMedium
    button.TextSize = 14
    button.AutoButtonColor = true
    button.Parent = content

    Instance.new("UICorner", button).CornerRadius =
        UDim.new(0, 8)

    button.Activated:Connect(callback)
    return button
end

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -30, 0, 32)
status.Position = UDim2.new(0, 15, 1, -40)
status.BackgroundTransparency = 1
status.Text = "STATUS: READY"
status.TextColor3 = Color3.fromRGB(100, 220, 160)
status.Font = Enum.Font.Gotham
status.TextSize = 12
status.Parent = main

makeButton("CHECK CHARACTER", function()
    local character = player.Character
    local humanoid = character and
        character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        status.Text = "STATUS: CHARACTER READY"
    else
        status.Text = "STATUS: CHARACTER NOT FOUND"
    end
end)

makeButton("WALK SPEED: TOGGLE", function()
    local character = player.Character
    local humanoid = character and
        character:FindFirstChildOfClass("Humanoid")

    if not humanoid then
        status.Text = "STATUS: CHARACTER NOT FOUND"
        return
    end

    if humanoid.WalkSpeed > 16 then
        humanoid.WalkSpeed = 16
        status.Text = "STATUS: NORMAL SPEED"
    else
        humanoid.WalkSpeed = 28
        status.Text = "STATUS: SPEED TEST ENABLED"
    end
end)

makeButton("RESET MENU POSITION", function()
    main.Position = UDim2.new(0.5, -160, 0.5, -165)
    status.Text = "STATUS: POSITION RESET"
end)

makeButton("CLOSE MENU", function()
    main.Visible = false
    reopen.Visible = true
end)

print("[AXIOM] GUI created:", gui:GetFullName())
