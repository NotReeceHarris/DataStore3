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

Players.PlayerAdded:Connect(function(player)  -- Player Join function
	local userid = player.UserId  -- Get UserId of joined player
	local payload = "SELECT * FROM userData WHERE userId ='"..userid.."'"  -- Select all from userdata table where userId = players userid (SQL CODE)
	local response = DataStore3.GetPayload(payload)  -- Send the post request to the server

	if response.Response == nil then  -- If the responce is nil (Meaning the player isnt already in the data base)
		local payload = "INSERT INTO userData VALUES ('"..userid.."', '0', '0', '0')"  -- Add the player to the database making the first value the userId (SQL CODE)
		local response = DataStore3.PostPayload(payload)   -- Send the post request to the server
	else   -- If the user is in the databse
		local payload = "SELECT * FROM userData WHERE userId = '"..player.UserId.."'"  -- Select all data from the userdata table where userId = players userid (SQL CODE) 
		local response = DataStore3.GetPayload(payload)    -- Send the get request to the server

		-- When getting a responce there are to parts the the table 'response.Response[a][b]' A & B a is the selector for example if a was equal to 1 you would 
		-- get the response code (1 is success and 0 is error) if a was equal to 2 you would get the SQL response for this example (userId, Gold, Wood, Gems)

		player.leaderstats.Gold.Value = response.Response[1][2]  -- Make the leaderstat of the player equal to the usersData (Gold, 2nd column in row)
		player.leaderstats.Gems.Value = response.Response[1][4]  -- Make the leaderstat of the player equal to the usersData (Gems, 4nd column in row)
		player.Inventory.Wood.Value = response.Response[1][3]    -- Make the leaderstat of the player equal to the usersData (Wood, 3nd column in row)
	end
end)
