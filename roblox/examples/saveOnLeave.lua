-- $$$$$$$\             $$\                $$$$$$\    $$\                                          $$$$$$\  
-- $$  __$$\            $$ |              $$  __$$\   $$ |                                        $$ ___$$\ 
-- $$ |  $$ | $$$$$$\ $$$$$$\    $$$$$$\  $$ /  \__|$$$$$$\    $$$$$$\   $$$$$$\   $$$$$$\        \_/   $$ |
-- $$ |  $$ | \____$$\\_$$  _|   \____$$\ \$$$$$$\  \_$$  _|  $$  __$$\ $$  __$$\ $$  __$$\         $$$$$ / 
-- $$ |  $$ | $$$$$$$ | $$ |     $$$$$$$ | \____$$\   $$ |    $$ /  $$ |$$ |  \__|$$$$$$$$ |        \___$$\ 
-- $$ |  $$ |$$  __$$ | $$ |$$\ $$  __$$ |$$\   $$ |  $$ |$$\ $$ |  $$ |$$ |      $$   ____|      $$\   $$ |
-- $$$$$$$  |\$$$$$$$ | \$$$$  |\$$$$$$$ |\$$$$$$  |  \$$$$  |\$$$$$$  |$$ |      \$$$$$$$\       \$$$$$$  |
-- \_______/  \_______|  \____/  \_______| \______/    \____/  \______/ \__|       \_______|       \______/ 

-- Create by Reece Harris (https://github.com/NotReeceHarris) & Deven Briers (https://github.com/NotDevenBriers)
-- This service is a SQL datastore for roblox, allowing multiple users to create multiple databases.
-- $Apache2 License.
-- https://github.com/NotReeceHarris/DataStore3

-- This file is an example, any values such as gold, wood and gems can be changed do what ever you want your are not restricted by value amounts ever so you can stop up too 5 Gb of data (Not per person)

local DataStore3 = require(game:GetService("ServerScriptService").DataStore3Libary);  --Imports the DataStore3 libary


local Players = game:GetService("Players")

Players.PlayerRemoving:Connect(function(player)  -- Player Leave function
	local gold = player.leaderstats.Gold.Value  -- Get players leaderstat values (Gold)
	local gems = player.leaderstats.Gems.Value  -- Get players leaderstat values (Gold)
	local wood = player.Inventory.Wood.Value    -- Get players leaderstat values (Gold)
	local payload = "UPDATE userData SET gold ='"..gold.."', wood ='"..wood.."', gems='"..gems.."' WHERE userId = '"..player.UserId.."';"  -- Update userData table and set Gold, Wood, Gems where usersId = Players userId
	local response = DataStore3.PostPayload(payload)  -- Send the Post request to the server
end)
