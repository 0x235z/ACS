local config = {
    enabled = true, --start enabled slient aim
    teamcheck = true, --check team
    code = Enum.KeyCode.Y, --activate and deactivate using key code

    target = nil,
    part = nil
}

--services
local guiService = game:GetService("GuiService")
local input = game:GetService("UserInputService")

local player = game.Players.LocalPlayer

local camera = workspace.CurrentCamera
local guiInset = guiService.GetGuiInset

--draw
local draw = Drawing.new("Circle")
draw.Visible = config.enabled
draw.Radius = 80
draw.Color = Color3.fromRGB(255, 37, 135)
draw.Filled = false 
draw.Transparency = 1
draw.NumSides = 50 
draw.Thickness = 1
draw.ZIndex = 999

--funcs
local mouse = player:GetMouse()
local function getMousePos()
	return Vector2.new(mouse.X, mouse.Y)
end

local function updateDraw()
	draw.Position = Vector2.new(mouse.X, (mouse.Y + guiInset(guiService).Y + 4));
end

local function getViewPos(port : Vector2)
	return Vector2.new(port.X, port.Y)
end

local function getNearest(index)
    local mousePos = getMousePos()

    local trg, lpart
    for i,v in game.Players:GetPlayers() do
        if v ~= player and config.enabled then
            if config.teamcheck then
                if player.Team == v.Team then continue end
            end

            local character = v.Character
            local head = character and character:FindFirstChild("Head")

            if head then
                local headpos = head.Position
                local pos, visible = camera:WorldToViewportPoint(headpos)
                local view = getViewPos(pos)

                local dist = (mousePos - view).magnitude
                if visible and (dist - index) then
                    trg, lpart = v, head
                end
            end
        end
    end

    if trg and lpart then
        return trg, lpart
    end
end

--loop
task.spawn(function()
    while true do
        updateDraw()
        config.target, config.part = getNearest(draw.Radius)
        task.wait()
    end
end)

--change enabled
input.InputBegan:Connect(function(key)
	if key.KeyCode == config.code then
		config.enabled = not config.enabled
		draw.Visible = enabled
	end
end)

-- hook
local namecall
namecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
	local method, args = (getnamecallmethod or get_namecall_method)(), {...}

	if method == "Raycast" and getcallingscript().Name == "ACS_Framework" and config.part ~= nil then
        args[2] = ((config.part.Position - args[1]).Unit * 1000)
	end

	return namecall(self, unpack(args));
end))
