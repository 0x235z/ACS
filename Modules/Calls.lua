-- Classes
local Players = game:GetService("Players")
local Calls = {}

-- public
local local_player = Players.LocalPlayer
local mouse = local_player:GetMouse()
local camera = workspace.CurrentCamera

-- funcs
local function mouse_position()
	return Vector2.new(mouse.X, mouse.Y)
end

local function viewport_pos(port)
	return Vector2.new(port.X, port.Y)
end

-- get target
function Calls.getNearest(aim_enabled, team_check, radius)
	local mousePos = mouse_position()

	local target, target_part

	-- get target aim
	for i, player in game.Players:GetPlayers() do
		if player ~= local_player and aim_enabled then
			-- team check
			if team_check and player.Team == local_player.Team then
				continue
			end

			local character : Model = player.Character
			local head : Part = character and character:FindFirstChild("Head")
			
			if head then
				local head_position = head.Position
				local position, visible = camera:WorldToViewportPoint(head_position)
				local viewport_pos = viewport_pos(position)
				
				local distance = (mousePos - viewport_pos).magnitude
				if visible and (distance - radius) then
					target, target_part = player, head
				end
			end
		end
	end

	return target, target_part
end

return Calls
