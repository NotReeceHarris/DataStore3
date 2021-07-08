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

-- Database hostname eg. (IPV4, URL) [DO NOT INCLUDE HTTP:// OR WWW.]
local url = ""
-- Key used to access database
local apiKey = ""
-- Database owner username (not roblox username)
local username = ""


local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(player)  -- Player Join function
	local userid = player.UserId  -- Get UserId of joined player
	local payload = "SELECT * FROM userData WHERE userId ='"..userid.."'"  -- Select all from userdata table where userId = players userid (SQL CODE)
	local response = DataStore3.GetPayload(url, apiKey, username, payload)  -- Send the post request to the server

	if response.Response == nil then  -- If the responce is nil (Meaning the player isnt already in the data base)
		local payload = "INSERT INTO userData VALUES ('"..userid.."', '0', '0', '0')"  -- Add the player to the database making the first value the userId (SQL CODE)
		local response = DataStore3.PostPayload(url, apiKey, username, payload)  -- Send the post request to the server
	else  -- If the user is in the databse
		local payload = "SELECT * FROM userData WHERE userId = '"..player.UserId.."'"  -- Select all data from the userdata table where userId = players userid (SQL CODE) 
		local response = DataStore3.GetPayload(url, apiKey, username, payload)  -- Send the get request to the server
		
		-- When getting a responce there are to parts the the table 'response.Response[a][b]' A & B a is the selector for example if a was equal to 1 you would 
		-- get the response code (1 is success and 0 is error) if a was equal to 2 you would get the SQL response for this example (userId, Gold, Wood, Gems)

		player.leaderstats.Gold.Value = response.Response[1][2]  -- Make the leaderstat of the player equal to the usersData (Gold, 2nd column in row)
		player.leaderstats.Gems.Value = response.Response[1][4]  -- Make the leaderstat of the player equal to the usersData (Gems, 4nd column in row)
		player.Inventory.Wood.Value = response.Response[1][3]  -- Make the leaderstat of the player equal to the usersData (Wood, 3nd column in row)
	end
end)

Players.PlayerRemoving:Connect(function(player)  -- Player Leave function
	gold = player.leaderstats.Gold.Value  -- Get players leaderstat values (Gold)
	gems = player.leaderstats.Gems.Value  -- Get players leaderstat values (Gold)
	wood = player.Inventory.Wood.Value  -- Get players leaderstat values (Gold)
	local payload = "UPDATE userData SET gold ='"..gold.."' WHERE userId = '"..player.UserId.."';"  -- Update userData table and set Gold, Wood, Gems where usersId = Players userId
	local response = DataStore3.PostPayload(url, apiKey, username, payload)  -- Send the Post request to the server
end)

while true do  -- Infinate Loop
	for i,v in pairs(game.Players:GetChildren()) do  -- Get all active players in game
		gold = v.leaderstats.Gold.Value  -- Get players Gold Value
		gems = v.leaderstats.Gems.Value  -- Get players Gems Value
		wood = v.Inventory.Wood.Value  -- Get players Wood Value
		local payload = "UPDATE userData SET gold ='"..gold.."', wood ='"..wood.."', gems='"..gems.."' WHERE userId = '"..v.UserId.."';" -- Update table called userData and set gold, wood and gems where usersId = players user id
		local response = DataStore3.PostPayload(url, apiKey, username, payload)  -- Send the Post request to the server
	end
	print("Saved Successfully") -- Print to server 'Saved Successfully' only developers will see this as players cant access the server console
	wait(30)  -- Wait 30 seconds to loop again
end
