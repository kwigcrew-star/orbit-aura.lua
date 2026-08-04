-- LocalScript inside StarterPlayer/StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

--------------------------------------------------------------------------------
-- CONFIGURATION
--------------------------------------------------------------------------------
local CONFIG = {
	DecalID = "rbxassetid://6071575925", -- Replace with your Decal Asset ID
	OrbitRadius = 6,                    -- Distance/Size of the orbit (in studs)
	OrbitSpeed = 3,                     -- Speed of rotation (higher = faster)
	AuraSize = Vector3.new(3, 3, 3),    -- Size of the aura image itself
	HeightOffset = 0,                   -- Vertical offset relative to HumanoidRootPart
	RotationSpeed = 2                   -- Speed at which the image particle itself spins
}
--------------------------------------------------------------------------------

-- Helper function to clean decal IDs
local function formatDecalID(id)
	if type(id) == "number" or not id:find("rbxassetid://") then
		return "rbxassetid://" .. tostring(id):gsub("%D", "")
	end
	return id
end

-- Create the Orbiting Aura Part
local function createAura(char)
	local rootPart = char:WaitForChild("HumanoidRootPart", 5)
	if not rootPart then return end

	-- Remove existing aura if re-spawning
	local existingAura = char:FindFirstChild("OrbitingAuraPart")
	if existingAura then existingAura:Destroy() end

	-- Create an invisible part to hold the decals
	local auraPart = Instance.new("Part")
	auraPart.Name = "OrbitingAuraPart"
	auraPart.Size = CONFIG.AuraSize
	auraPart.Transparency = 1
	auraPart.CanCollide = false
	auraPart.Massless = true
	auraPart.Anchored = false
	auraPart.Parent = char

	-- Add Decals on both front and back faces so it's visible from all sides
	local textureId = formatDecalID(CONFIG.DecalID)
	
	local frontDecal = Instance.new("Decal")
	frontDecal.Face = Enum.NormalId.Front
	frontDecal.Texture = textureId
	frontDecal.Parent = auraPart

	local backDecal = Instance.new("Decal")
	backDecal.Face = Enum.NormalId.Back
	backDecal.Texture = textureId
	backDecal.Parent = auraPart

	-- Orbit Animation Loop
	local angle = 0
	local selfRotation = 0

	local connection
	connection = RunService.RenderStepped:Connect(function(deltaTime)
		if not auraPart or not auraPart.Parent or not rootPart or not rootPart.Parent then
			connection:Disconnect()
			return
		end

		-- Increment orbit and self-rotation angles
		angle = angle + (CONFIG.OrbitSpeed * deltaTime)
		selfRotation = selfRotation + (CONFIG.RotationSpeed * deltaTime)

		-- Calculate 3D position in a circle around the character
		local x = math.cos(angle) * CONFIG.OrbitRadius
		local z = math.sin(angle) * CONFIG.OrbitRadius
		local targetPos = rootPart.Position + Vector3.new(x, CONFIG.HeightOffset, z)

		-- Apply position and spin orientation
		auraPart.CFrame = CFrame.new(targetPos) * CFrame.Angles(0, selfRotation, 0)
	end)
end

-- Initialize for current character and handle respawns
if character then
	createAura(character)
end

player.CharacterAdded:Connect(function(newCharacter)
	character = newCharacter
	createAura(newCharacter)
end)
