-- classes
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Highlight = {
	Highs = shared.highs or {}
}

shared.highs = Highlight.Highs

-- public
local local_player = Players.LocalPlayer

-- new highlight
local state = false
local function create(player, color, team_color)
	local new_high = shared.highs[player] or Instance.new("Highlight")
	new_high.OutlineColor = if team_color then player.TeamColor.Color else color or Color3.fromRGB(255, 0, 0)
	new_high.FillColor = new_high.OutlineColor
	new_high.Adornee = player.Character
	new_high.Parent = if RunService:IsStudio() then local_player.PlayerGui else game:GetService("CoreGui")
	new_high.Enabled = state

	Highlight.Highs[player] = new_high
	shared.highs = Highlight.Highs
	return new_high
end

function Highlight.active(color, team_color)
	state = not state

	-- update highs
	if state then
		for i, v in Players:GetPlayers() do
			local character = v.Character
			if character then
				create(v, color, team_color)
				v.CharacterAdded:Connect(function() 
					create(v, color, team_color)
				end)
			end
		end
	else
		for i, v in shared.highs do
			v.Enabled = false
		end
	end

	-- added high to player
	Players.PlayerAdded:Connect(function(player)
		if state then
			create(player, color, team_color)
		end
	end)

	-- removing high
	Players.PlayerRemoving:Connect(function(player)
		if Highlight.Highs[player] then
			Highlight.Highs[player]:Remove()
			shared.highs = Highlight.Highs
		end
	end)
end

return Highlight
