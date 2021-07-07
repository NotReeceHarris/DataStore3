local DataStore3 = require(game:GetService("ServerScriptService").DataStore3Libary);



-- Database hostname eg. (IPV4, URL) [DO NOT INCLUDE HTTP:// OR WWW.]
local url = ""

-- Key used to access database
local apiKey = ""

-- Database owner username (not roblox username)
local username = ""

-- Sql Code payload
local payload = [[
CREATE TABLE test (
	lorem VARCHAR(10) NOT NULL UNIQUE,
	ipsum INT(10) NOT NULL,
	dolor VARCHAR(40),
	sit	LONGBLOB, 
	amet BOOLEAN,
	
	PRIMARY KEY (lorem)
)
]]


-- DataStore3.PostPayload(url, apiKey, username, payload);
-- DataStore3.GetPayload(url, apiKey, username, payload);
-- DataStore3.TestFunction();
