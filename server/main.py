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

from flask import Flask, redirect, url_for, render_template, request, session, flash, send_file, jsonify
from flask_assets import Environment, Bundle
import sqlite3
import hashlib
import json
import datetime
import random
import string
import os
from os import listdir
from waitress import serve

app = Flask(__name__)
assets = Environment(app)
app.permanent_session_lifetime = datetime.timedelta(days=365)
app.secret_key =  "abc123#"#''.join(random.choice(string.ascii_letters) for i in range(100)).encode('ascii')

from sqlExecuter import SqlExecutionApi
app.register_blueprint(SqlExecutionApi)


@app.route('/')
def index():
    if session != []:
        if "logedin" in session:
            path = f"SqliteStorage\\{session['username']}"
            dbdata = {"databases": []}
            for filename in listdir(path):
                conn = sqlite3.connect(f'SqliteStorage/{session["username"]}/{filename}')
                c = conn.cursor()
                c.execute("SELECT name FROM sqlite_master WHERE type='table';")
                tables = c.fetchall()
                x = {
                    "id": filename[:40],
                    "name": filename[40:-3].upper(),
                    "tables": tables,
                    "tablelen": len(tables),
                    "size": round(int(os.path.getsize(f"SqliteStorage/{ session['username']}/{filename}")) / 1048576, 2),
                    "sizeb": os.path.getsize(f"SqliteStorage/{ session['username']}/{filename}")
                }
                dbdata["databases"].append(x)
            return render_template('index.html', databases=dbdata)
        else:
            return redirect(url_for("login"))
    else:
        return redirect(url_for("login"))

@app.route('/dbs')
def databases():
    if session != []:
        if "logedin" in session:
            path = f"SqliteStorage\\{session['username']}"
            dbdata = {"databases": []}
            for filename in listdir(path):
                conn = sqlite3.connect(f'SqliteStorage/{session["username"]}/{filename}')
                c = conn.cursor()
                c.execute("SELECT name FROM sqlite_master WHERE type='table';")
                tables = c.fetchall()
                x = {
                    "id": filename[:40],
                    "name": filename[40:-3].upper(),
                    "tables": tables,
                    "tablelen": len(tables),
                    "size": round(int(os.path.getsize(f"SqliteStorage/{ session['username']}/{filename}")) / 1048576, 2)
                }
                dbdata["databases"].append(x)
            return render_template('databases.html', databases=dbdata)
        else:
            return redirect(url_for("Four0Four"))
    else:
        return redirect(url_for("Four0Four"))

@app.route('/apikey')
def apikey():
    if session != []:
        if "logedin" in session:
            path = f"SqliteStorage\\{session['username']}"
            dbdata = {"databases": []}
            for filename in listdir(path):
                conn = sqlite3.connect(f'SqliteStorage/{session["username"]}/{filename}')
                c = conn.cursor()
                c.execute("SELECT name FROM sqlite_master WHERE type='table';")
                tables = c.fetchall()
                conn.close()
                conn = sqlite3.connect(f'SqliteStorage/apiKeys.db')
                c = conn.cursor()
                c.execute(f"SELECT * FROM Keys WHERE _id='{filename[:40]}'")
                keys = c.fetchall()
                x = {
                    "id": filename[:40],
                    "name": filename[40:-3].upper(),
                    "tables": tables,
                    "tablelen": len(tables),
                    "keys": len(keys),
                    "key": keys
                }
                dbdata["databases"].append(x)
            return render_template('apikey.html', databases=dbdata)
        else:
            return redirect(url_for("Four0Four"))
    else:
        return redirect(url_for("Four0Four"))

@app.route('/login', defaults={'_other': ""})
@app.route('/login/<string:_other>')
def login(_other):
    if session != []:
        if "logedin" in session:
            return redirect(url_for("index"))
        else:
            return render_template('login.html', other=_other)
    else:
        return render_template('login.html', other=_other)

@app.errorhandler(404)
def page_not_found(e): 
    return redirect(url_for("Four0Four"))

@app.route('/404')
def Four0Four():
    return "Page Not Found"

#------------------------------------------------------------------------------------------- POST REQUESTS


@app.route('/newDataBase', defaults={'name': None}, methods=["POST"])
@app.route('/newDataBase/<string:name>', methods=["POST"])
def newDataBase(name):
    if session != []:
        if "logedin" in session:
            from datetime import date
            id = hashlib.sha1(f"{date.today()}{random.random()}".encode("ascii")).hexdigest()
            open(f"SqliteStorage/{session['username']}/{id}{request.form['dbname']}.db", "w")
            flash("Successfull Created Database")
            return redirect(url_for("databases"))
        else:
            return redirect(url_for("Four0Four"))
    else:
        return redirect(url_for("Four0Four"))

@app.route('/DelKey', defaults={'keyid': None})
@app.route('/DelKey/<string:keyid>')
def DelKey(keyid):
    if session != []:
        if "logedin" in session:
            if keyid != None:
                
                conn = sqlite3.connect(f'SqliteStorage/apiKeys.db')
                c = conn.cursor()
                c.execute(f"DELETE from keys WHERE _key = '{keyid}'")
                conn.commit()
                conn.close()

                flash('Success')
                return redirect(url_for("apikey"))

            else:
                return redirect(url_for("Four0Four"))
        else:
            return redirect(url_for("Four0Four"))
    else:
        return redirect(url_for("Four0Four"))

@app.route('/GenKey', defaults={'dbid': None})
@app.route('/GenKey/<string:dbid>')
def GenKey(dbid):
    if session != []:
        if "logedin" in session:
            if dbid != None:
                
                conn = sqlite3.connect(f'SqliteStorage/apiKeys.db')
                c = conn.cursor()
                c.execute(f"SELECT * FROM Keys WHERE _id='{dbid}'")
                keys = c.fetchall()
                
                if len(keys) >= 4:
                    conn.close()
                    flash("To many active Api Keys")
                    return redirect(url_for("apikey"))
                else:
                    key = hashlib.sha1(str(random.randint(100000,999999)).encode("ascii")).hexdigest()
                    c.execute('INSERT INTO Keys VALUES (:id ,:key)',
                    {'id':dbid, 'key':key})
                    conn.commit()
                    conn.close()
                    flash("Success")
                    return redirect(url_for("apikey"))
            else:
                return redirect(url_for("Four0Four"))
        else:
            return redirect(url_for("Four0Four"))
    else:
        return redirect(url_for("Four0Four"))

@app.route('/loginPost', methods=["POST"])
def loginPost():
    conn = sqlite3.connect('SqliteStorage/userCreds.db')
    c = conn.cursor()
    c.execute(f'SELECT * FROM members WHERE _username="{request.form["username"]}"')
    response = c.fetchone()

    if response != [] or request.form["password"] != None:
        if response[2] == hashlib.sha256(request.form["password"].encode('ascii')).hexdigest():
            session["logedin"] = True
            session["username"] = request.form["username"]
            return redirect(url_for("index"))
        else:
            flash("Username / Password incorrect")
            return redirect(url_for("login"))
    else:
        flash("Username / Password incorrect")
        return redirect(url_for("login"))

@app.route('/Signout')
def Signout():
    if session != []:
        if "logedin" in session:
            session.clear()
            return redirect(url_for("login"))
        else:
            return redirect(url_for("login"))
    else:
        return redirect(url_for("login"))

@app.route('/deleteDb', defaults={'name': None, "id": None})
@app.route('/deleteDb/<string:name>/<string:id>')
def deleteDb(name, id):
    if session != []:
        if "logedin" in session:
            if name != None and id != None:
                conn = sqlite3.connect(f'SqliteStorage/apiKeys.db')
                c = conn.cursor()
                c.execute(f"DELETE FROM keys WHERE _id = '{id}';")
                conn.commit()
                conn.close()
                os.remove(f'SqliteStorage/{session["username"]}/{id}{name}.db')
                return redirect(url_for("databases"))
            else:
                return redirect(url_for("databases"))
        else:
            return redirect(url_for("Four0Four"))
    else:
        return redirect(url_for("Four0Four"))


@app.route('/renameDb', methods=["POST"])
def renameDb():
    oldname = request.form["oldname"]
    newname = request.form["newname"]
    id = request.form["id"]
    if session != []:
        if "logedin" in session:
            if oldname != None or id != None or newname != None:
                os.rename(f'SqliteStorage/{session["username"]}/{id}{oldname}.db',f'SqliteStorage/{session["username"]}/{id}{newname}.db')
                return redirect(url_for("databases"))
            else:
                return redirect(url_for("databases"))
        else:
            return redirect(url_for("Four0Four"))
    else:
        return redirect(url_for("Four0Four"))

@app.route('/exportGet', defaults={'name': None, "id": None})
@app.route('/exportGet/<string:name>/<string:id>')
def exportGet(name, id):
    if session != []:
        if "logedin" in session:
            if name != None and id != None:
                return send_file(f'SqliteStorage/{session["username"]}/{id}{name}.db', as_attachment=True)
            else:
                return redirect(url_for("databases"))
        else:
            return redirect(url_for("Four0Four"))
    else:
        return redirect(url_for("Four0Four"))

@app.route('/import', methods=["POST"])
def importPost():
    if session != []:
        if "logedin" in session:
            f = request.files['file']
            id = hashlib.sha1(f"{f.read()}{random.random()}".encode("ascii")).hexdigest()
            name = f"{id}{request.form['filename']}.db"
            f.save(f"SqliteStorage/{session['username']}/{name}")
            flash("Successfull Import")
            return redirect(url_for("databases"))
        else:
            return redirect(url_for("Four0Four"))
    else:
        return redirect(url_for("Four0Four"))


if __name__ == "__main__":
    import socket
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.connect(("8.8.8.8", 80))
    hostname = s.getsockname()[0]
    s.close()
    port = json.load(open("config.json"))["port"]
    debug = json.load(open("config.json"))["debug"]
    if debug:
        app.run(host=hostname, port=port, debug=True)
    else:
        print(f"""
        DataStore3
        Host: {hostname}
        Port: {port}
        Url : http://{hostname}:{port}
        """)
        serve(app, host=hostname, port=port)
