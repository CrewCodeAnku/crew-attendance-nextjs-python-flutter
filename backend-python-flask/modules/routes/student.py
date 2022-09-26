from flask import Blueprint
from flask import current_app as app
from modules.auth import token_required
from modules.controllers.student import Student
from flask_cors import CORS, cross_origin

student_blueprint = Blueprint("student", __name__)

CORS(student_blueprint, resources={r"/*": {"origins": "*"}},
     supports_credentials=True)


@student_blueprint.route("/joinCourse", methods=["POST"])
@token_required
def joinCourse():
    return Student().joinCourse()


@student_blueprint.route("/courseListing", methods=["GET"])
@token_required
def getCourseListing():
    return Student().courseListing()


@student_blueprint.route("/leaveCourse", methods=["POST"])
@token_required
def leaveCourse():
    return Student().leaveCourse()
