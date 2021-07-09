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

-- In this script the users data for gold, gems and wood are auto saved every 30 seconds
-- all data is saved by userid so this data can also be accessed via another game

local DataStore3 = require(game:GetService("ServerScriptService").DataStore3Libary);  --Imports the DataStore3 libary

local Players = game:GetService("Players")

while true do  -- Infinate Loop
	for i,v in pairs(game.Players:GetChildren()) do  -- Get all active players in game
		local gold = v.leaderstats.Gold.Value  -- Get players Gold Value
		local gems = v.leaderstats.Gems.Value  -- Get players Gems Value
		local wood = v.Inventory.Wood.Value  -- Get players Wood Value
		local payload = "UPDATE userData SET gold ='"..gold.."', wood ='"..wood.."', gems='"..gems.."' WHERE userId = '"..v.UserId.."';" -- Update table called userData and set gold, wood and gems where usersId = players user id
		local response = DataStore3.PostPayload(payload)  -- Send the Post request to the server
	end
	print("Saved Successfully") -- Print to server 'Saved Successfully' only developers will see this as players cant access the server console
	wait(30)  -- Wait 30 seconds to loop again
end
