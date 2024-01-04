-- classes
local RunService = game:GetService("RunService")
local Draw = {}
Draw.__index = Draw

-- public
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

-- new drawing
function Draw.new()
	local screen = Instance.new("ScreenGui")
	local Main = Instance.new("Frame")
	local Drawing = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local UIStroke = Instance.new("UIStroke")

	-- create new class
	local new_class = setmetatable({
		UIStroke = UIStroke,
		Frame = Drawing
	}, Draw)

	-- configure attributes
	screen.DisplayOrder = 10
	screen.ResetOnSpawn = false
	screen.Parent = if RunService:IsStudio() then player.PlayerGui else game:GetService("CoreGui")

	Main.Transparency = 1
	Main.Size = UDim2.new(0, 1, 0, 1)
	Main.Parent = screen

	Drawing.Name = "Drawing"
	Drawing.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Drawing.BackgroundTransparency = 1
	Drawing.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Drawing.BorderSizePixel = 0
	Drawing.Size = UDim2.new(0, 100, 0, 100)
	Drawing.Visible = false
	Drawing.Parent = Main
	
	UICorner.CornerRadius = UDim.new(0, 10000)
	UICorner.Parent = Drawing

	UIStroke.Color = Color3.fromRGB(255, 0, 0)
	UIStroke.Parent = Drawing

	return new_class
end

local state = false
function Draw:update_draw()
	state = not state
	while state do
		self.Frame.Position = UDim2.new(0, (mouse.X - (self.Frame.Size.X.Scale / 2)), 0, (mouse.Y - (self.Frame.Size.Y.Scale / 2)))
		task.wait()
	end
end

return Draw
