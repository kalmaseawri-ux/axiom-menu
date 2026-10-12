
-- AXIOM VEHICLE SPEED SERVER
-- For vehicles owned/managed by your own Roblox game.
-- Expected vehicle structure:
-- Vehicle Model
--   VehicleSeat
--   VehicleController (this script reads the attribute below)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local event = ReplicatedStorage:FindFirstChild("AxiomVehicleSpeed")
if not event then
    event = Instance.new("RemoteEvent")
    event.Name = "AxiomVehicleSpeed"
    event.Parent = ReplicatedStorage
end

local MIN_SPEED = 10
local MAX_SPEED = 200

local function getDrivenVehicle(player)
    local character = player.Character
    if not character then return nil end

    for _, model in ipairs(workspace:GetDescendants()) do
        if model:IsA("VehicleSeat")
            and model.Occupant
            and model.Occupant.Parent == character then

            return model
        end
    end

    return nil
end

event.OnServerEvent:Connect(function(player, requestedSpeed)
    if typeof(requestedSpeed) ~= "number" then return end
    if requestedSpeed ~= requestedSpeed then return end

    requestedSpeed = math.clamp(
        requestedSpeed,
        MIN_SPEED,
        MAX_SPEED
    )

    local seat = getDrivenVehicle(player)
    if not seat then return end

    local vehicle = seat:FindFirstAncestorOfClass("Model")
    if not vehicle then return end

    -- Attribute consumed by your vehicle controller.
    vehicle:SetAttribute("AxiomTargetSpeed", requestedSpeed)
end)
