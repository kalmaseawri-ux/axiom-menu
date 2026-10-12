
-- AXIOM VEHICLE SPEED GUI
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local vehicleSpeedEvent =
    ReplicatedStorage:WaitForChild("AxiomVehicleSpeed")

createSection("VEHICLE CONTROL")

local vehicleSpeedInput = Instance.new("TextBox")
vehicleSpeedInput.Size = UDim2.new(1, -2, 0, 40)
vehicleSpeedInput.BackgroundColor3 = CONFIG.Panel
vehicleSpeedInput.TextColor3 = Color3.new(1, 1, 1)
vehicleSpeedInput.PlaceholderText = "Vehicle speed: 10 - 200"
vehicleSpeedInput.Text = "80"
vehicleSpeedInput.ClearTextOnFocus = false
vehicleSpeedInput.Font = Enum.Font.Gotham
vehicleSpeedInput.TextSize = 14
vehicleSpeedInput.Parent = content

Instance.new("UICorner", vehicleSpeedInput).CornerRadius =
    UDim.new(0, 9)

createButton("APPLY VEHICLE SPEED", function()
    local speed = tonumber(vehicleSpeedInput.Text)

    if not speed or speed < 10 or speed > 200 then
        setStatus("ENTER VEHICLE SPEED 10 - 200",
            Color3.fromRGB(255, 180, 80))
        return
    end

    vehicleSpeedEvent:FireServer(speed)
    setStatus("VEHICLE SPEED REQUEST SENT")
end)
