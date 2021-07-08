local DataStore3 = require(game:GetService("ServerScriptService").DataStore3Libary);



-- Database hostname eg. (IPV4, URL) [DO NOT INCLUDE HTTP:// OR WWW.]
local url = ""

-- Key used to access database
local apiKey = ""

-- Database owner username (not roblox username)
local username = ""

local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(player)
	local userid = player.UserId
	local payload = "SELECT * FROM userData WHERE userId ='"..userid.."'"
	local response = DataStore3.GetPayload(url, apiKey, username, payload)

	if response.Response == nil then
		local payload = "INSERT INTO userData VALUES ('"..userid.."', '', '', '')"
		local response = DataStore3.PostPayload(url, apiKey, username, payload)
	else
		local payload = "SELECT * FROM userData WHERE userId = '"..player.UserId.."'"
		local response = DataStore3.GetPayload(url, apiKey, username, payload)
		print(response)
		print(response.Response)
		
		player.leaderstats.Gold.Value = response.Response[1][2]
		player.leaderstats.Gems.Value = response.Response[1][4]
		player.Inventory.Wood.Value = response.Response[1][3]
	end
end)

Players.PlayerRemoving:Connect(function(player)
	gold = player.leaderstats.Gold.Value
	gems = player.leaderstats.Gems.Value
	wood = player.Inventory.Wood.Value
	local payload = "UPDATE userData SET gold ='"..gold.."', wood ='"..wood.."', gems='"..gems.."' WHERE userId = '"..player.UserId.."';"
	local response = DataStore3.PostPayload(url, apiKey, username, payload)
end)

while true do
	for i,v in pairs(game.Players:GetChildren()) do
		gold = v.leaderstats.Gold.Value
		gems = v.leaderstats.Gems.Value
		wood = v.Inventory.Wood.Value
		local payload = "UPDATE userData SET gold ='"..gold.."', wood ='"..wood.."', gems='"..gems.."' WHERE userId = '"..v.UserId.."';"
		local response = DataStore3.PostPayload(url, apiKey, username, payload)
	end
	print("Saved Successfully")
	wait(30)
end
