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

-- DO NOT MODIFY THIS FILE UNLESS YOU KNOW WHAT YOUR DOING!

local username = script.Username.Value		-- Get Presaved server details
local apiKey = script.Apikey.Value			-- Get Presaved server details
local hostname = script.Hostname.Value		-- Get Presaved server details

local HttpService = game:GetService("HttpService")		-- Create a HttpService

local DataStore3 = {};		-- Create a modula variable

-------- Local Script functions

local function encode(dataFields)	

	local data = ""		-- Create encoded data save point
	for k, v in pairs(dataFields) do		-- Encode the data into json
		data = data .. ("&%s=%s"):format(
			HttpService:UrlEncode(k),
			HttpService:UrlEncode(v)
		)
	end
	return data
end


-------- Modula Functions

---------------------------------------------------------------------------------------------------------------- Test connection

DataStore3.testConnection = function()
	local url = "http://"..hostname.."/api/test/"	-- Craft a url from hostname

	----------------- Encodes the data into a json form format

	local dataFields = {		-- Create a DataField Containing Server details and payload
		["key"] = apiKey;
		["username"] = username;
	}

	local data = encode(dataFields)			-- Encode dataFields

	----------------- Sends a post request to the database

	local response = HttpService:PostAsync(url, data, Enum.HttpContentType.ApplicationUrlEncoded, false)		-- Send a PostAsync request to the server
	local data = HttpService:JSONDecode(response)		-- Receive the data from the server

	----------------- Print SQL error Code

	if data.ReturnCode == 0 then		-- If Return code is 0 (Meaning an error)
		print("Connection Failed -"..data.ErrorCode)		-- Print the sql error
	elseif data.ReturnCode == 1 then
		print("Connection success")
	end

	return data		-- Return server response
end

---------------------------------------------------------------------------------------------------------------- Create table

DataStore3.CreateTable = function(tableName, primaryKey, dataType)
	local url = "http://"..hostname.."/api/payload/post/"	-- Craft a url from hostname

	----------------- Encodes the data into a json form format

	local dataFields = {		-- Create a DataField Containing Server details and payload
		["key"] = apiKey;
		["username"] = username;
		["payload"] = "CREATE TABLE "..tableName.."("..primaryKey.." "..dataType..", PRIMARY KEY("..primaryKey.."));";
	}

	local data = encode(dataFields)			-- Encode dataFields

	----------------- Sends a post request to the database

	local response = HttpService:PostAsync(url, data, Enum.HttpContentType.ApplicationUrlEncoded, false)		-- Send a PostAsync request to the server
	local data = HttpService:JSONDecode(response)		-- Receive the data from the server

	----------------- Print SQL error Code

	if data.ReturnCode == 0 then		-- If Return code is 0 (Meaning an error)
		print("!! SQL ERROR !! -"..data.ErrorCode)		-- Print the sql error
	end

	return data		-- Return server response
end

---------------------------------------------------------------------------------------------------------------- Delete table

DataStore3.DeleteTable = function(tableName)
	local url = "http://"..hostname.."/api/payload/post/"	-- Craft a url from hostname

	----------------- Encodes the data into a json form format

	local dataFields = {		-- Create a DataField Containing Server details and payload
		["key"] = apiKey;
		["username"] = username;
		["payload"] = "DROP TABLE "..tableName..";";
	}

	local data = encode(dataFields)			-- Encode dataFields

	----------------- Sends a post request to the database

	local response = HttpService:PostAsync(url, data, Enum.HttpContentType.ApplicationUrlEncoded, false)		-- Send a PostAsync request to the server
	local data = HttpService:JSONDecode(response)		-- Receive the data from the server

	----------------- Print SQL error Code

	if data.ReturnCode == 0 then		-- If Return code is 0 (Meaning an error)
		print("!! SQL ERROR !! -"..data.ErrorCode)		-- Print the sql error
	end


	return data		-- Return server response
end

---------------------------------------------------------------------------------------------------------------- Delete a column to table


DataStore3.DeleteColumn = function(TableName, ColumnName)
	local url = "http://"..hostname.."/api/payload/get/"	-- Craft a url from hostname

	----------------- Gets all columns in table

	local dataFields = {		-- Create a DataField Containing Server details and payload
		["key"] = apiKey;
		["username"] = username;
		["payload"] =  "pragma table_info("..TableName..")";
	}

	local data = encode(dataFields)			-- Encode dataFields

	----------------- Sends a post request to the database

	local response = HttpService:PostAsync(url, data, Enum.HttpContentType.ApplicationUrlEncoded, false)		-- Send a PostAsync request to the server
	local columns = HttpService:JSONDecode(response)		-- Receive the data from the server

	print(columns)

	local columnNames = ""
	local RawColumnNames = ""
	local primarykey = nil

	for i,v in pairs(columns.Response) do  -- Loop through all columns
		if v[2] ~= ColumnName then
			local addition = ""
			if v[4] == 1 then
				addition = "NOT NULL"
			end
			if v[6] == 1 then
				primarykey = v[2]
			end
			RawColumnNames = RawColumnNames..v[2]..","
			columnNames = columnNames..v[2].." "..v[3].." "..addition..","
		end
	end

	if primarykey ~= nil then
		columnNames = columnNames:sub(1, -2)
		columnNames = columnNames..",PRIMARY KEY("..primarykey.."),"
	end

	RawColumnNames = RawColumnNames:sub(1, -2)
	columnNames = columnNames:sub(1, -2)

	local url = "http://"..hostname.."/api/payload/post/"	-- Craft a url from hostname

	----------------- Gets all columns in table

	local dataFields = {		-- Create a DataField Containing Server details and payload
		["key"] = apiKey;
		["username"] = username;
		["payload"] =  "BEGIN TRANSACTION; CREATE TEMPORARY TABLE "..TableName.."_backup("..columnNames.."); INSERT INTO "..TableName.."_backup SELECT "..RawColumnNames.." FROM "..TableName.."; DROP TABLE "..TableName.."; CREATE TABLE "..TableName.."("..columnNames.."); INSERT INTO "..TableName.." SELECT "..RawColumnNames.." FROM "..TableName.."_backup; DROP TABLE "..TableName.."_backup;";

	}

	local data = encode(dataFields)			-- Encode dataFields

	----------------- Sends a post request to the database

	local response = HttpService:PostAsync(url, data, Enum.HttpContentType.ApplicationUrlEncoded, false)		-- Send a PostAsync request to the server
	local data = HttpService:JSONDecode(response)		-- Receive the data from the server

	----------------- Print SQL error Code

	if data.ReturnCode == 0 then		-- If Return code is 0 (Meaning an error)
		print("!! SQL ERROR !! -"..data.ErrorCode)		-- Print the sql error
	end


	return data		-- Return server response



end


---------------------------------------------------------------------------------------------------------------- Add a column to table


DataStore3.CreateColumn = function(TableName, ColumnName, DataType)
	local url = "http://"..hostname.."/api/payload/post/"	-- Craft a url from hostname

	----------------- Encodes the data into a json form format

	local dataFields = {		-- Create a DataField Containing Server details and payload
		["key"] = apiKey;
		["username"] = username;
		["payload"] =  "ALTER TABLE "..TableName.." ADD "..ColumnName.." "..DataType..";";
	}

	local data = encode(dataFields)			-- Encode dataFields

	----------------- Sends a post request to the database

	local response = HttpService:PostAsync(url, data, Enum.HttpContentType.ApplicationUrlEncoded, false)		-- Send a PostAsync request to the server
	local data = HttpService:JSONDecode(response)		-- Receive the data from the server

	----------------- Print SQL error Code

	if data.ReturnCode == 0 then		-- If Return code is 0 (Meaning an error)
		print("!! SQL ERROR !! -"..data.ErrorCode)		-- Print the sql error
	end


	return data		-- Return server response



end

---------------------------------------------------------------------------------------------------------------- Raw Payload Post Request

DataStore3.PostPayload = function(payload)
	local url = "http://"..hostname.."/api/payload/post/"	-- Craft a url from hostname

	----------------- Encodes the data into a json form format

	local dataFields = {		-- Create a DataField Containing Server details and payload
		["key"] = apiKey;
		["username"] = username;
		["payload"] = payload;
	}

	local data = encode(dataFields)			-- Encode dataFields

	----------------- Sends a post request to the database

	local response = HttpService:PostAsync(url, data, Enum.HttpContentType.ApplicationUrlEncoded, false)		-- Send a PostAsync request to the server
	local data = HttpService:JSONDecode(response)		-- Receive the data from the server

	----------------- Print SQL error Code

	if data.ReturnCode == 0 then		-- If Return code is 0 (Meaning an error)
		print("!! SQL ERROR !! -"..data.ErrorCode)		-- Print the sql error
	end


	return data		-- Return server response
end

---------------------------------------------------------------------------------------------------------------- Raw Get Request

DataStore3.GetPayload = function(payload)
	local url = "http://"..hostname.."/api/payload/get/"	-- Craft a url from hostname

	----------------- Encodes the data into a json form format

	local dataFields = {		-- Create a DataField Containing Server details and payload
		["key"] = apiKey;
		["username"] = username;
		["payload"] = payload;
	}

	local data = encode(dataFields)			-- Encode dataFields

	----------------- Sends a post request to the database

	local response = HttpService:PostAsync(url, data, Enum.HttpContentType.ApplicationUrlEncoded, false)		-- Send a PostAsync request to the server (This is a get function but we need to post to the server in this instance)
	local data = HttpService:JSONDecode(response)		-- Receive the data from the server

	----------------- Print SQL error Code

	if data.ReturnCode == 0 then		-- If Return code is 0 (Meaning an error)
		print("!! SQL ERROR !! -"..data.ErrorCode)		-- Print the sql error
	end


	return data		-- Return server response
end


return DataStore3;
