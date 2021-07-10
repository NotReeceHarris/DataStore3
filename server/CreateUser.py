'''
$$$$$$$\             $$\                $$$$$$\    $$\                                          $$$$$$\  
$$  __$$\            $$ |              $$  __$$\   $$ |                                        $$ ___$$\ 
$$ |  $$ | $$$$$$\ $$$$$$\    $$$$$$\  $$ /  \__|$$$$$$\    $$$$$$\   $$$$$$\   $$$$$$\        \_/   $$ |
$$ |  $$ | \____$$\\_$$  _|   \____$$\ \$$$$$$\  \_$$  _|  $$  __$$\ $$  __$$\ $$  __$$\         $$$$$ / 
$$ |  $$ | $$$$$$$ | $$ |     $$$$$$$ | \____$$\   $$ |    $$ /  $$ |$$ |  \__|$$$$$$$$ |        \___$$\ 
$$ |  $$ |$$  __$$ | $$ |$$\ $$  __$$ |$$\   $$ |  $$ |$$\ $$ |  $$ |$$ |      $$   ____|      $$\   $$ |
$$$$$$$  |\$$$$$$$ | \$$$$  |\$$$$$$$ |\$$$$$$  |  \$$$$  |\$$$$$$  |$$ |      \$$$$$$$\       \$$$$$$  |
\_______/  \_______|  \____/  \_______| \______/    \____/  \______/ \__|       \_______|       \______/ 
Create by Reece Harris (https://github.com/NotReeceHarris) & Deven Briers (https://github.com/NotDevenBriers)
This service is a SQL datastore for roblox, allowing multiple users to create multiple databases.
- Apache2 License.
https://github.com/NotReeceHarris/DataStore3
'''

import random
import string
import sqlite3
import hashlib
import os

while True:

    username = input("Enter Username: ")
    password = ""

    while True:
        x = input("Do you want to generate a password [Y/n]: ").lower()
        if x in ["y", "n"]:
            if x == "y":
                password = ''.join(random.choice(string.ascii_letters) for i in range(10)) 
            if x == "n":
                while True:
                    password = input("Enter password: ")
                    if len(password) <= 10:
                        print("Password is to simple, make sure to make it longer then 10 characters!")
                    else:
                        break
            break
        else:
            print("Incorrect input!")

    try:
        conn = sqlite3.connect('SqliteStorage/userCreds.db')
        c = conn.cursor()
        c.execute("""
        CREATE TABLE members (
            _id varchar(40) NOT NULL UNIQUE,
            _username varchar(32) NOT NULL,
            _password varchar(64) NOT NULL,
            PRIMARY KEY(_id)
            )
        """)
        conn.commit()
    except:
        pass

    c.execute(f'SELECT * FROM members WHERE _id = "{hashlib.sha1(username.encode("ascii")).hexdigest()}"')
    data = c.fetchall()
    if data != []:
        print("Username Taken!")
    else:
        break

c.execute(f'INSERT INTO members VALUES ("{hashlib.sha1(username.encode("ascii")).hexdigest()}" ,"{username}" ,"{hashlib.sha256(password.encode("ascii")).hexdigest()}")')

conn.commit()
conn.close()

if not os.path.exists(f"SqliteStorage/{username}"):
    os.makedirs(f"SqliteStorage/{username}")

print(f"""
Username: {username}
Password: {password}
""")

input("Press Enter to continue..")
