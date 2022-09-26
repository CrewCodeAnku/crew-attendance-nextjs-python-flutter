from flask import Blueprint
from flask import current_app as app
from modules.auth import token_required
from modules.controllers.teacher import Teacher
from flask_cors import CORS

teacher_blueprint = Blueprint("teacher", __name__)

CORS(teacher_blueprint, resources={r"/*": {"origins": "*"}},
     supports_credentials=True)


@teacher_blueprint.route("/createCourse", methods=["POST"])
@token_required
def createCourse():
    return Teacher().createCourse()


@teacher_blueprint.route("/createAttendance", methods=["POST"])
@token_required
def createAttendance():
    return Teacher().createAttendance()


@teacher_blueprint.route("/editAttendance", methods=["POST"])
@token_required
def editAttendance():
    return Teacher().editAttendance()


@teacher_blueprint.route("/courseAttendance", methods=["GET"])
@token_required
def getCourseAttendance():
    return Teacher().attendanceListing()


@teacher_blueprint.route("/courseListing", methods=["GET"])
@token_required
def courseListing():
    return Teacher().courseListing()


@teacher_blueprint.route("/courseStudents", methods=["GET"])
@token_required
def studentListing():
    return Teacher().studentListing()


@teacher_blueprint.route("/fetchAttendanceResult", methods=["POST"])
@token_required
def fetchAttendanceResult():
    return Teacher().fetchAttendanceResult()


@teacher_blueprint.route("/deleteCourse/<id>", methods=["DELETE"])
@token_required
def deleteCourse():
    return Teacher().deleteCourse()
