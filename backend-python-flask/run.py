from modules import create_app
from flask_cors import CORS
#import logging

if __name__ == "__main__":
    app = create_app()
    CORS(app, resources={r"/api/*": {"origins": "*"}},
         supports_credentials=True)
    app.run(host=app.config["FLASK_DOMAIN"],
            port=app.config["FLASK_PORT"], debug=True)
