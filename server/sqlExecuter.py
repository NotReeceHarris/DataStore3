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



This code is open source, all backend SQL executions will stay up to date
'''

from flask import request, session, jsonify, Blueprint
import sqlite3
import json
import os
import time

SqlExecutionApi = Blueprint('SqlExecutionApi', __name__)
def Ipfilter(ip):
    if ":" in ip:
        if json.load(open("config.json"))["ipfilter"]:
            return ip in json.load(open("ipRange.json"))
        else:
            return True
    else:
        if json.load(open("config.json"))["ipfilter"]:
            return '.'.join([str(elem) for elem in ip.split(".")[:-1]]) in json.load(open("ipRange.json"))
        else:
            return True

@SqlExecutionApi.route('/api/payload/post/', methods=["POST"])
def apiPayloadPost():
    time.sleep(0.01)
    

    if not Ipfilter(request.remote_addr):
        return jsonify({"ReturnCode": 0, "ErrorCode":"You are not roblox"}), 401

    Key = request.form["key"]
    Username = request.form["username"]
    Payload = request.form["payload"]
    conn = sqlite3.connect(f'SqliteStorage/apiKeys.db')
    c = conn.cursor()
    c.execute(f"SELECT * FROM Keys WHERE _key='{Key}'")
    apikey = c.fetchall()
    conn.close()
    dbfile = ""
    if apikey == []:
        print("hi2")
        return jsonify({"ReturnCode": 0, "ErrorCode":"Invalid Api Key"}), 401
    else:
        if Key == None or Payload == None:
            print("hi4")
            return jsonify({"ReturnCode": 0, "ErrorCode":"Missing Attributes"}), 505
        else:
            path = f"SqliteStorage\\{Username}"
            for root, dirs, files in os.walk(path):
                for filename in files:
                    if filename.startswith(apikey[0]):
                        dbfile = filename
            if dbfile == None:
                return jsonify({"ReturnCode": 0, "ErrorCode":"Missing database files, message a system admin"}), 505
            conn = sqlite3.connect(f'SqliteStorage/{Username}/{dbfile}')
            c = conn.cursor()
            c.execute("SELECT name FROM sqlite_master WHERE type='table';")
            response = c.fetchall()
            try:
                response = c.execute(Payload)
                conn.commit()
                conn.close()
                return jsonify({"ReturnCode": 1}), 200
            except sqlite3.OperationalError as a:
                return jsonify({"ReturnCode": 0, "ErrorCode": str(a)}), 200


@SqlExecutionApi.route('/api/payload/get/', methods=["POST"])
def apiPayloadGet():
    time.sleep(0.01)
    if not Ipfilter(request.remote_addr):
        return jsonify({"ReturnCode": 0, "ErrorCode":"You are not roblox"}), 401

    Key = request.form["key"]
    Username = request.form["username"]
    Payload = request.form["payload"]

    conn = sqlite3.connect(f'SqliteStorage/apiKeys.db')
    c = conn.cursor()
    c.execute(f"SELECT * FROM Keys WHERE _key='{Key}'")

    apikey = c.fetchall()
    conn.close()

    dbfile = ""

    if apikey == []:
        return jsonify({"ReturnCode": 0, "ErrorCode":"Invalid Api Key"}), 401
    else:

        if Key == None or Payload == None:
            return jsonify({"ReturnCode": 0, "ErrorCode":"Missing Attributes"}), 505
        else:
            path = f"SqliteStorage\\{Username}"
            for root, dirs, files in os.walk(path):
                for filename in files:
                     if filename.startswith(apikey[0]):
                        dbfile = filename
            if dbfile == None:
                return jsonify({"ReturnCode": 0, "ErrorCode":"Missing database files, message a system admin"}), 505

            conn = sqlite3.connect(f'SqliteStorage/{Username}/{dbfile}')
            c = conn.cursor()
            c.execute("SELECT name FROM sqlite_master WHERE type='table';")
            response = c.fetchall()
            try:
                c.execute(Payload)
                response = c.fetchall()

                if response == []:
                    response = None

                return jsonify({"ReturnCode": 1, "Response":response}), 200
            except sqlite3.OperationalError as a:
                return jsonify({"ReturnCode": 0, "ErrorCode": str(a)}), 200
