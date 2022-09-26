import math
from flask import current_app as app
import boto3
import botocore
from flask import request, session
from passlib.hash import pbkdf2_sha256
from jose import jwt
from modules import tools
from modules import auth
from werkzeug.utils import secure_filename
import json
import random


class User:

    def __init__(self):
        self.defaults = {
            "id": tools.randID(),
            "ip_addresses": [request.remote_addr],
            "acct_active": True,
            "createdAt": tools.nowDatetimeUTC(),
            "last_login": tools.nowDatetimeUTC(),
            "name": "",
            "email": "",
            "profile_picture": "",
            "emailVerified": False
        }

    def get(self):
        token_data = jwt.decode(request.headers.get(
            'AccessToken'), app.config['SECRET_KEY'])

        user = app.db.users.find_one({"id": token_data['user_id']}, {
            "_id": 0,
            "password": 0
        })

        if user:
            resp = tools.JsonResp(user, 200)
        else:
            resp = tools.JsonResp({"message": "User not found"}, 404)

        return resp

    def verifyEmail(self):
        data = json.loads(request.data)
        otp = data["otp"]
        email = data["email"]
        print("Email", email)
        print("Otp", otp)
        resp = tools.JsonResp(
            {"message": "Email verification token is expired or invalid"}, 400)
        if email:
            try:
                existing_email = app.db.users.find_one(
                    {"email": email, "otp": otp})

                if not existing_email:
                    resp = tools.JsonResp(
                        {"message": "Otp wrong!"}, 400)
                else:
                    decoded = jwt.decode(
                        existing_email['email_verification_token'], app.config["SECRET_KEY"])
                    app.db.users.update_one({"email": decoded["email"]}, {"$set": {
                        "emailVerified": True,
                        "otp": "",
                        "email_verification_token": ""
                    }})
                    resp = tools.JsonResp(
                        {"message": "Email successfully verified!"}, 200)

            except Exception as e:
                resp = tools.JsonResp(
                    {"message": "Otp expired!"}, 500)

        return resp

    def getAuth(self):
        access_token = request.headers.get("AccessToken")
        refresh_token = request.headers.get("RefreshToken")

        resp = tools.JsonResp({"message": "User not logged in"}, 401)

        if access_token:
            try:
                decoded = jwt.decode(access_token, app.config["SECRET_KEY"])
                resp = tools.JsonResp(decoded, 200)
            except:
                # If the access_token has expired, get a new access_token - so long as the refresh_token hasn't expired yet
                resp = auth.refreshAccessToken(refresh_token)

        return resp

    def login(self):
        resp = tools.JsonResp(
            {"message": "Invalid user credentials", "error_code": "invalid_credentials"}, 400)

        try:
            data = json.loads(request.data)
            email = data["email"].lower()
            usertype = data["usertype"]
            user = app.db.users.find_one(
                {"email": email,  "usertype": usertype}, {"_id": 0})

            if user and user['emailVerified'] == False:
                resp = tools.JsonResp(
                    {"message": "Email not verified, please verify your email", "data": {
                        "email": user["email"]
                    }, "error_code": "email_not_verified"}, 400)

            elif user and pbkdf2_sha256.verify(data["password"], user["password"]):
                access_token = auth.encodeAccessToken(
                    user["id"], user["email"])
                refresh_token = auth.encodeRefreshToken(
                    user["id"], user["email"])

                app.db.users.update_one({"id": user["id"]}, {"$set": {
                    "refresh_token": refresh_token,
                    "access_token": access_token
                }})
                resp = tools.JsonResp({
                    "message": "Successfully Logged In!",
                    "data": {
                        "id": user["id"],
                        "email": user["email"],
                        "name": user["name"],
                        "type": user["usertype"],
                        "profile_picture": user["profile_picture"],
                        "access_token": access_token,
                        "refresh_token": refresh_token
                    }
                }, 200)

        except Exception as e:
            print("Error", e)
            pass

        return resp

    def logout(self):
        try:
            tokenData = jwt.decode(request.headers.get(
                "AccessToken"), app.config["SECRET_KEY"])
            app.db.users.update({"id": tokenData["user_id"]}, {
                                '$unset': {"refresh_token": ""}})

        except:
            pass

        resp = tools.JsonResp({"message": "User logged out"}, 200)

        return resp

    def generate_random_number(self, length):
        digits = "0123456789"
        OTP = ""
        for i in range(length):
            OTP += digits[math.floor(random.random() * 10)]

        return OTP

    def resendVerificationEmail(self):
        data = json.loads(request.data)
        existing_email = app.db.users.find_one({"email": data["email"]})
        if existing_email:
            otp = self.generate_random_number(5)
            access_token = auth.encodeAccessToken(
                existing_email["id"], existing_email["email"])

            app.db.users.update_one({"id": existing_email["id"]}, {
                "$set": {
                    "email_verification_token": access_token,
                    "otp": otp
                }
            })
            auth.send_emailverify_email(
                data["email"], otp, existing_email['name'])
            resp = tools.JsonResp({
                "message": "Email sent successfully!",
            }, 200)
        else:
            resp = tools.JsonResp({
                "message": "User doesn't exist!",
            }, 400)

        return resp

    def add(self):
        data = json.loads(request.data)

        expected_data = {
            "name": data['name'],
            "email": data['email'].lower(),
            "profile_picture": "",
            "password": data['password'],
            "usertype": data["usertype"]
        }

        # Merge the posted data with the default user attributes
        self.defaults.update(expected_data)
        user = self.defaults

        # Encrypt the password
        user["password"] = pbkdf2_sha256.encrypt(
            user["password"], rounds=20000, salt_size=16)

        # Make sure there isn"t already a user with this email address
        existing_email = app.db.users.find_one({"email": user["email"]})

        if existing_email:
            resp = tools.JsonResp({
                "message": "There's already an account with this email address",
                "error": "email_exists"
            }, 400)

        else:
            if app.db.users.insert_one(user):

                # Log the user in (create and return tokens)
                access_token = auth.encodeAccessToken(
                    user["id"], user["email"])

                print("Token", access_token)

                otp = self.generate_random_number(5)

                auth.send_emailverify_email(
                    user["email"], otp, user['name'])

                app.db.users.update_one({"id": user["id"]}, {
                    "$set": {
                        "email_verification_token": access_token,
                        "otp": otp
                    }
                })

                resp = tools.JsonResp({
                    "message": "Registered successfully, Please verify your email",
                    "data": {
                        "id": user["id"],
                        "email": user["email"],
                        "name": user["name"],
                        "profile_picture": "",
                        "type": user["usertype"]
                    }

                }, 200)

            else:
                resp = tools.JsonResp(
                    {"message": "User could not be added"}, 400)

        return resp

    def forgotPassword(self):
        data = json.loads(request.data)
        email = data["email"].lower()
        otp = self.generate_random_number(5)
        user = app.db.users.find_one({"email": email})

        token = auth.get_reset_token(data["email"].lower())

        app.db.users.update_one({"id": user["id"]}, {
            "$set": {
                "reset_pass_token": token,
                "reset_otp": otp
            }
        })
        if user:
            auth.send_forgot_email(
                user['email'], token, user['name'], otp)

            resp = tools.JsonResp({
                "message": "Email sent with further instruction",
            }, 200)

        else:
            resp = tools.JsonResp(
                {"message": "Email address not found!"}, 400)

        return resp

    def resetPassword(self):
        data = json.loads(request.data)
        print("Data", data)
        resp = tools.JsonResp({
            "message": "Otp expired or invalid",
        }, 400)
        user = app.db.users.find_one(
            {"email": data['email'], "reset_otp": data['otp']})
        if user:
            if user['reset_pass_token']:
                try:
                    decoded = jwt.decode(user['reset_pass_token'],
                                         app.config["SECRET_KEY"])
                    password = pbkdf2_sha256.encrypt(
                        data["password"], rounds=20000, salt_size=16)
                    app.db.users.update_one({"email": decoded["email"].lower()}, {
                        '$set': {"password": password, "reset_otp": "", "reset_pass_token": ""}})
                    resp = tools.JsonResp({
                        "message": "Password successfully changed",
                    }, 200)

                except Exception as e:
                    print("Error", e)
                    pass
        else:
            resp = tools.JsonResp({
                "message": "Otp is wrong!",
            }, 200)

        return resp

    def updateProfileName(self):
        data = json.loads(request.data)
        token_data = jwt.decode(request.headers.get(
            'AccessToken'), app.config['SECRET_KEY'])
        try:
            app.db.users.update_one({"id": token_data["user_id"]}, {
                "$set": {
                    "name": data["name"]
                }
            })
            user = app.db.users.find_one(
                {"id": token_data["user_id"]}, {"_id": 0})
            resp = tools.JsonResp({
                "message": "Profile name successfully updated",
                "data": user
            }, 200)
        except Exception as e:
            resp = tools.JsonResp({
                "message": "Something went wrong",
            }, 500)

        return resp

    def updatePassword(self):
        data = json.loads(request.data)
        token_data = jwt.decode(request.headers.get(
            'AccessToken'), app.config['SECRET_KEY'])
        try:
            password = pbkdf2_sha256.encrypt(
                data["password"], rounds=20000, salt_size=16)
            app.db.users.update_one({"id": token_data["user_id"]}, {
                "$set": {
                    "password": password
                }
            })
            resp = tools.JsonResp({
                "message": "Password successfully updated",
            }, 200)
        except Exception as e:
            resp = tools.JsonResp({
                "message": "Something went wrong",
            }, 500)

        return resp

    def updateProfilePicture(self):
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
        print(file)
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
                token_data = jwt.decode(request.headers.get(
                    'AccessToken'), app.config['SECRET_KEY'])

                app.db.users.update_one({"id": token_data["user_id"]}, {
                    "$set": {
                        "profile_picture": "{}{}".format(app.config["S3_LOCATION"], file.filename)
                    }
                })
                existing_user = app.db.users.find_one(
                    {"id": token_data["user_id"]})
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
