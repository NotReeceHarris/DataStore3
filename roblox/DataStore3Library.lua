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

-- DO NOT MODIFY THIS FILE UNLESS YOU KNOW WHAT YOUR DOING!


local DataStore3 = {};


DataStore3.TestFunction = function()
	print("Import Successfull")
end



---------------------------------------------------------------------------------------------------------------- Post Request

DataStore3.PostPayload = function(hostname, apiKey, username, payload)
	local HttpService = game:GetService("HttpService")
	local url = "http://"..hostname.."/api/payload/post/"

	----------------- Encodes the data into a json form format

	local dataFields = {
		["key"] = apiKey;
		["username"] = username;
		["payload"] = payload;
	}
	local data = ""
	for k, v in pairs(dataFields) do
		data = data .. ("&%s=%s"):format(
			HttpService:UrlEncode(k),
			HttpService:UrlEncode(v)
		)
	end

	----------------- Sends a post request to the database


	return HttpService:PostAsync(url, data, Enum.HttpContentType.ApplicationUrlEncoded, false)
end

---------------------------------------------------------------------------------------------------------------- Get Request

DataStore3.GetPayload = function(hostname, apiKey, username, payload)
	local HttpService = game:GetService("HttpService")
	local url = "http://"..hostname.."/api/payload/post/"

	----------------- Encodes the data into a json form format

	local dataFields = {
		["key"] = apiKey;
		["username"] = username;
		["payload"] = payload;
	}
	local data = ""
	for k, v in pairs(dataFields) do
		data = data .. ("&%s=%s"):format(
			HttpService:UrlEncode(k),
			HttpService:UrlEncode(v)
		)
	end

	----------------- Sends a post request to the database


	return HttpService:GetAsync(url, data, Enum.HttpContentType.ApplicationUrlEncoded, false)
end


return DataStore3;
