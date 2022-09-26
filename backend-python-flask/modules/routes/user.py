from flask import Blueprint
from flask import current_app as app
from modules.auth import token_required
from modules.controllers.user import User
from flask_cors import CORS, cross_origin

user_blueprint = Blueprint("user", __name__)

CORS(user_blueprint, resources={r"/*": {"origins": "*"}},
     supports_credentials=True)


@user_blueprint.route("/", methods=["GET"])
@token_required
def get():
    return User().get()


@user_blueprint.route("/updateProfilePicture", methods=["POST"])
@token_required
def updateProfilePic():
    return User().updateProfilePicture()


@user_blueprint.route("/updatePassword", methods=["POST"])
@token_required
def updatePassword():
    return User().updatePassword()


@user_blueprint.route("/updateProfileName", methods=["POST"])
@token_required
def updateProfileName():
    return User().updateProfileName()


@user_blueprint.route("/auth", methods=["GET"])
def getAuth():
    return User().getAuth()


@user_blueprint.route("/login", methods=["POST"])
def login():
    return User().login()


@user_blueprint.route("/logout", methods=["GET"])
def logout():
    return User().logout()


@user_blueprint.route("/signup", methods=["POST"])
def add():
    return User().add()


@user_blueprint.route("/forgetpassword", methods=["POST"])
def forgotpassword():
    return User().forgotPassword()


@user_blueprint.route("/verifyemail", methods=["POST"])
def verifyemail():
    return User().verifyEmail()


@user_blueprint.route("/resendverifyemail", methods=["POST"])
def resendverifyemail():
    return User().resendVerificationEmail()


@user_blueprint.route("/resetpassword", methods=["POST"])
def resetpassword():
    return User().resetPassword()
