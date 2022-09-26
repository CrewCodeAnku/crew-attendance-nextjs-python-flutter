from flask import current_app as app
import boto3
from flask import request
from modules import tools
from jose import jwt
import json
from bson.json_util import dumps
from werkzeug.utils import secure_filename
from datetime import datetime


class Teacher:

    def __init__(self):
        self.defaults = {
            "id": tools.randID(),
            "ip_addresses": [request.remote_addr],
            "createdAt": tools.nowDatetimeUTC(),
            "courseName": "",
            "courseShortName": "",
            "courseStartDate": "",
            "courseEndDate": "",
            "teacherid": ""
        }

    def createCourse(self):
        try:
            data = json.loads(request.data)
            print("Data", data)
            access_token = request.headers.get('AccessToken')
            tokendata = jwt.decode(access_token, app.config['SECRET_KEY'])
            expected_data = {
                "courseName": data['courseName'],
                "courseShortName": data['courseShortName'],
                "courseStartDate": data['courseStartDate'],
                "courseEndDate": data['courseEndDate'],
                "teacherid": tokendata["user_id"],
            }
            self.defaults.update(expected_data)
            course = self.defaults
            if app.db.courses.insert_one(course):
                resp = tools.JsonResp({
                    "message": "Course Added successfully!",
                }, 200)
            else:
                resp = tools.JsonResp(
                    {"message": "Course could not be added"}, 400)

        except Exception as e:
            print(e)
            resp = tools.JsonResp({
                "message": "Something went wrong!",
            }, 500)

        return resp

    def editAttendance(self):
        try:
            data = json.loads(request.data)
            expected_data = {"$set": {
                "present": data['present'],
                "absent": data['absent'],
                "classImage": data['classImage'],
                "studentParticipated": data['studentParticipated'],
                "courseId": data["courseId"],
            }}

            filter = {'id': data['attendanceId']}

            if app.db.attendance.update_one(filter, expected_data):
                resp = tools.JsonResp({
                    "message": "Attendance Updated successfully!",
                }, 200)
            else:
                resp = tools.JsonResp(
                    {"message": "Attendance could not be updated"}, 400)

        except Exception as e:
            print(e)
            resp = tools.JsonResp({
                "message": "Something went wrong!",
            }, 500)

        return resp

    def createAttendance(self):
        try:
            data = json.loads(request.data)
            expected_data = {
                "id": tools.randID(),
                "present": data['present'],
                "absent": data['absent'],
                "classImage": data['classImage'],
                "studentParticipated": data['studentParticipated'],
                "courseId": data["courseId"],
                "attendanceDate": str(datetime.utcnow().date())
            }
            print(datetime.utcnow().date())
            attendance_exist = app.db.attendance.find_one(
                {"courseId": data["courseId"], "attendanceDate": str(datetime.utcnow().date())})

            if attendance_exist:
                resp = tools.JsonResp(
                    {"message": "Attendance already marked for today"}, 400)
            else:
                print("Inside else")
                if app.db.attendance.insert_one(expected_data):
                    resp = tools.JsonResp({
                        "message": "Attendance Added successfully!",
                    }, 200)
                else:
                    resp = tools.JsonResp(
                        {"message": "Attendance could not be added"}, 400)

        except Exception as e:
            print(e)
            resp = tools.JsonResp({
                "message": "Something went wrong!",
            }, 500)

        return resp

    def studentListing(self):
        try:
            access_token = request.headers.get('AccessToken')
            data = jwt.decode(access_token, app.config['SECRET_KEY'])
            args = request.args
            agg_result = dumps(app.db.courses.aggregate([
                {"$match": {
                    "teacherid": data["user_id"], "id":args["courseid"]}},
                {
                    "$lookup": {
                        "from": "users",
                        "localField": "students",
                        "foreignField": "id",
                        "as": "courseStudent"
                    }
                },
                {
                    "$lookup": {
                        "from": "users",
                        "localField": "teacherid",
                        "foreignField": "id",
                        "as": "teacherid"
                    }
                },
                {
                    "$project": {
                        "id": 1,
                        "courseStudent": 1
                    }
                }
            ],),)
            print("Result", agg_result)
            resp = tools.JsonResp({
                "message": "Student Listing!",
                "data": agg_result
            }, 200)
        except Exception as e:
            print(e)
            resp = tools.JsonResp({
                "message": "Something went wrong!",
            }, 500)

        return resp

    def courseListing(self):
        try:
            access_token = request.headers.get('AccessToken')
            data = jwt.decode(access_token, app.config['SECRET_KEY'])
            agg_result = dumps(app.db.courses.aggregate([
                {"$match": {"teacherid": data["user_id"]}},
                {
                    "$lookup": {
                        "from": "users",
                        "localField": "students",
                        "foreignField": "_id",
                        "as": "courseObjects"
                    }
                },
                {
                    "$lookup": {
                        "from": "users",
                        "localField": "teacherid",
                        "foreignField": "id",
                        "as": "teacherid"
                    }
                },
            ]))

            resp = tools.JsonResp({
                "message": "Course Listing!",
                "data": agg_result
            }, 200)
        except Exception as e:
            print(e)
            resp = tools.JsonResp({
                "message": "Something went wrong!",
            }, 500)

        return resp

    def fetchAttendanceResult(self):
        s3 = boto3.client(
            "s3",
            aws_access_key_id=app.config['S3_KEY'],
            aws_secret_access_key=app.config['S3_SECRET']
        )
        if "user_file" not in request.files:
            resp = tools.JsonResp({
                "message": "No user_file key in request.files",
            }, 400)
        file = request.files["user_file"]
        if file.filename == "":
            resp = tools.JsonResp({
                "message": "Please select a file",
            }, 400)
        if file:
            file.filename = secure_filename(file.filename)
            print("File")
            print(file.filename)
            try:
                s3.upload_fileobj(
                    file,
                    app.config["BUCKET_NAME"],
                    Key=file.filename,
                    ExtraArgs={
                        "ACL": "public-read",
                        "ContentType": file.content_type
                    }
                )

                existing_user = app.db.users.find({})

                for user in existing_user:
                    print(user.get("profile_picture"))

                resp = tools.JsonResp({
                    "message": "Profile picture successfully uploaded",
                    "data": existing_user
                }, 200)

            except Exception as e:
                print("Something Happened: ", e)
                resp = tools.JsonResp({
                    "message": "Somethong went wrong",
                }, 500)

        return resp

    def attendanceListing(self):
        try:
            args = request.args
            agg_result = dumps(app.db.attendance.aggregate([
                {"$match": {
                    "courseId": args["courseid"]}},
                {
                    "$lookup": {
                        "from": "users",
                        "localField": "studentParticipated",
                        "foreignField": "id",
                        "as": "studentParticipated"
                    }
                },
            ],),)
            resp = tools.JsonResp({
                "message": "Attendance Listing!",
                "data": agg_result
            }, 200)
        except Exception as e:
            print(e)
            resp = tools.JsonResp({
                "message": "Something went wrong!",
            }, 500)

        return resp

    def deleteCourse(self):
        id = request.query.get(id)
        if app.db.courses.delete_one({"_id": id}):
            resp = tools.JsonResp({
                "message": "Course Deleted successfully!",
            }, 200)
        else:
            resp = tools.JsonResp(
                {"message": "Course could not be deleted"}, 400)

        return resp
