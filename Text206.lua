-- ===== AUTO BUY KNIFE PARA LOADRING =====
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local camera = Workspace.CurrentCamera

-- Toggle global
if _G.AutoBuyKnife == nil then _G.AutoBuyKnife = false end
_G.AutoBuyKnife = true -- lo activamos directo

-- Referencias al pedestal y prompt
local function getKnifePedestal()
    return Workspace:WaitForChild("Spawnm"):WaitForChild("KnifePedestal")
end

local function getPrompt(pedestal)
    return pedestal:WaitForChild("BuyKnife")
end

-- Esperar personaje y HRP
local function esperarPersonajeYHRP()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    return char, hrp
end

-- Teletransportar, enfocar cámara y activar prompt
local function teleportaYActiva()
    if not _G.AutoBuyKnife then return end
    local char, hrp = esperarPersonajeYHRP()
    local pedestal = getKnifePedestal()
    local prompt = getPrompt(pedestal)

    -- Esperar 1.5 segundos antes de teletransportar
    task.wait(1.5)

    -- Teletransportar al jugador
    local teleportPos = pedestal.Position + Vector3.new(0,3,-5)
    hrp.CFrame = CFrame.new(teleportPos)

    -- Enfocar cámara
    camera.CameraType = Enum.CameraType.Scriptable
    camera.CFrame = CFrame.new(teleportPos, pedestal.Position)

    -- Activar ProximityPrompt
    if prompt and prompt:IsA("ProximityPrompt") then
        prompt:InputHoldBegin()
        task.wait(0.1)
        prompt:InputHoldEnd()
    end

    -- Volver control de cámara al jugador
    task.wait(0.2)
    camera.CameraType = Enum.CameraType.Custom
    camera.CameraSubject = char:WaitForChild("Humanoid")
end

-- Ejecutar solo si estamos en Lobby
local function checkTeam()
    if not _G.AutoBuyKnife then return end
    if LocalPlayer.Team and LocalPlayer.Team.Name == "Lobby" then
        teleportaYActiva()
    end
end

-- Conectar cambios de team
LocalPlayer:GetPropertyChangedSignal("Team"):Connect(checkTeam)

-- Ejecutar al inicio si ya estamos en Lobby
checkTeam()
