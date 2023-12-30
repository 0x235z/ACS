local Draw = {}
Draw.__index = Draw

-- new drawing
local player = game.Players.LocalPlayer
function Draw.new()
	-- instances
	local screen = Instance.new("ScreenGui", game:GetService("CoreGui"))
	local Main = Instance.new("Frame", screen)
	local Drawing = Instance.new("Frame", Main)
	local UICorner = Instance.new("UICorner", Drawing)
	local UIStroke = Instance.new("UIStroke", Drawing)

	-- create new class
	local new_class = setmetatable({
		UIStroke = UIStroke,
		Frame = Drawing
	}, Draw)

	-- config gui
	screen.DisplayOrder = 10
	screen.ResetOnSpawn = false

	Main.Transparency = 1
	Main.Size = UDim2.new(0, 1, 0, 1)

	Drawing.Name = "Drawing"
	Drawing.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Drawing.BackgroundTransparency = 1
	Drawing.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Drawing.BorderSizePixel = 0
	Drawing.Size = UDim2.new(0, 100, 0, 100)
	Drawing.Visible = false

	UICorner.CornerRadius = UDim.new(0, 10000)
	UICorner.Parent = Drawing

	UIStroke.Color = Color3.fromRGB(255, 0, 0)
	return new_class
end

return Draw
