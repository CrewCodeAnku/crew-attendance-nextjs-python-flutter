from flask import current_app as app
from flask import request
from modules import tools
import json
from bson.json_util import dumps
from jose import jwt


class Student:

    def joinCourse(self):
        data = json.loads(request.data)
        try:
            access_token = request.headers.get('AccessToken')
            token_data = jwt.decode(access_token, app.config['SECRET_KEY'])

            existing_course = app.db.courses.find_one(
                {"courseShortName": data['courseCode']})
            if not existing_course:
                resp = tools.JsonResp(
                    {"message": "Course doen't exist course code is wrong!"}, 400)
            else:
                app.db.users.update_one({"id": token_data["user_id"]},
                                        {'$push': {
                                            'courses': existing_course['id']}}
                                        )
                app.db.courses.update_one({"id": existing_course['id']},
                                          {'$push': {
                                              'students': token_data['user_id']}}
                                          )

                resp = tools.JsonResp({
                    "message": "Successfully, joined course!",
                }, 200)
        except Exception as e:
            print(e)
            resp = tools.JsonResp(
                {"message": "Something went wrong"}, 500)

        return resp

    def courseListing(self):
        """user_id = request.args.get('user_id')"""
        try:
            access_token = request.headers.get('AccessToken')
            token_data = jwt.decode(access_token, app.config['SECRET_KEY'])
            course_result = dumps(app.db.courses.find(
                {"students": {"$in": [token_data['user_id']]}}))

            resp = tools.JsonResp({
                "message": "Course Listing!",
                "data": course_result
            }, 200)

            print(resp)

        except Exception as e:
            print(e)
            resp = tools.JsonResp(
                {"message": "Something went wrong"}, 500)

        return resp

    def leaveCourse(self):
        data = json.loads(request.data)
        try:
            access_token = request.headers.get('AccessToken')
            token_data = jwt.decode(access_token, app.config['SECRET_KEY'])
            app.db.users.update_one({"id": token_data["user_id"]},
                                    {'$pull': {'courses': data['course_id']}}
                                    )
            app.db.courses.update_one({"id": data["course_id"]},
                                      {'$pull': {
                                          'students': token_data['user_id']}}
                                      )
            resp = tools.JsonResp({
                "message": "Successfully, left the course!",
            }, 200)
        except:
            resp = tools.JsonResp(
                {"message": "Something went wrong"}, 500)

        return resp
