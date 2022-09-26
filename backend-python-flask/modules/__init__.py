from flask import Flask
from flask_cors import CORS
from pymongo import MongoClient
from modules.tools import JsonResp
import os
import certifi


# Import Routes
from modules.routes.user import user_blueprint
from modules.routes.teacher import teacher_blueprint
from modules.routes.student import student_blueprint


def create_app():

    # Flask Config
    app = Flask(__name__)
    app.config.from_pyfile("config/config.cfg")

    CORS(app, resources={r"/*": {"origins": "*"}},
         supports_credentials=True)

    # Misc Config
    os.environ["TZ"] = app.config["TIMEZONE"]

    os.environ['FLASK_ENV'] = app.config["ENVIRONMENT"]

    # Database Config
    print(app.config["MONGO_AUTH_DATABASE"])
    if app.config["ENVIRONMENT"] == "development":
        mongo = MongoClient(
            app.config["MONGO_AUTH_DATABASE"],
            tlsCAFile=certifi.where()
        )

        app.db = mongo.get_database(app.config["MONGO_APP_DATABASE"])
    else:
        mongo = MongoClient(
            app.config["MONGO_AUTH_DATABASE"],
            tlsCAFile=certifi.where()
        )
        app.db = mongo.get_database(
            app.config["MONGO_APP_DATABASE"]
        )

    # Register Blueprints
    app.register_blueprint(user_blueprint, url_prefix='/user')
    app.register_blueprint(teacher_blueprint, url_prefix='/teacher')
    app.register_blueprint(student_blueprint, url_prefix='/student')

    # Index Route
    @app.route("/")
    def index():
        response = JsonResp({"status": "Online"}, 200)
        response.headers.add("Access-Control-Allow-Origin", "*")
        response.headers.add('Access-Control-Allow-Credentials', True)
        return response

    return app
