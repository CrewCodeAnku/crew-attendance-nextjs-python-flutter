from flask import current_app as app
from flask import request
from functools import wraps
from modules.tools import JsonResp
from jose import jwt
import datetime
import time
from sendgrid import SendGridAPIClient
from sendgrid.helpers.mail import (
    Mail)
import certifi
import ssl


# Auth Decorator


def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        access_token = request.headers.get('AccessToken')
        try:
            data = jwt.decode(access_token, app.config['SECRET_KEY'])
        except Exception as e:
            return JsonResp({"message": "Token is invalid", "exception": str(e)}, 401)

        return f(*args, **kwargs)

    return decorated


def encodeAccessToken(user_id, email):
    accessToken = jwt.encode({
        "user_id": user_id,
        "email": email,
        # The token will expire in 15 minutes
        "exp": datetime.datetime.utcnow() + datetime.timedelta(minutes=15)
    }, app.config["SECRET_KEY"], algorithm="HS256")

    return accessToken


def encodeRefreshToken(user_id, email):
    refreshToken = jwt.encode({
        "user_id": user_id,
        "email": email,
        # The token will expire in 4 weeks
        "exp": datetime.datetime.utcnow() + datetime.timedelta(weeks=4)
    }, app.config["SECRET_KEY"], algorithm="HS256")

    return refreshToken


def refreshAccessToken(refresh_token):
    # If the refresh_token is still valid, create a new access_token and return it
    try:
        user = app.db.users.find_one({"refresh_token": refresh_token}, {
                                     "_id": 0, "id": 1, "email": 1})

        if user:
            decoded = jwt.decode(refresh_token, app.config["SECRET_KEY"])
            new_access_token = encodeAccessToken(
                decoded["user_id"], decoded["email"], decoded["plan"])
            result = jwt.decode(new_access_token, app.config["SECRET_KEY"])
            result["new_access_token"] = new_access_token
            resp = JsonResp(result, 200)
        else:
            result = {"message": "Auth refresh token has expired"}
            resp = JsonResp(result, 403)

    except:
        result = {"message": "Auth refresh token has expired"}
        resp = JsonResp(result, 403)

    return resp


def get_reset_token(email):
    resetToken = jwt.encode({
        "email": email,
        "exp": datetime.datetime.utcnow() + datetime.timedelta(minutes=15)
    }, app.config["SECRET_KEY"], algorithm="HS256")

    return resetToken


def send_emailverify_email(email, otp, username):
    message = Mail(
        from_email="noreply@crew-code.com",
        to_emails=email,
        subject='Verify your email address!',
    )

    message.dynamic_template_data = {
        "sitetitle": "Crew Attendance",
        "preheader": "Crew Attendance",
        "username": username,
        "emailcontent": "Your otp to verify email is {otp}".format(otp=otp),
        "endcontent": "Please ignore this email if you not requested this",
        "thankscontent": "Thanks, Crew Attendance",
    }

    message.template_id = "d-099fc366915d4d7b9f9b7d6cd136aa75"

    try:
        ssl._create_default_https_context = ssl._create_unverified_context
        sg = SendGridAPIClient(
            app.config["SENDGRID_API_KEY"])
        response = sg.send(message)
        code, body, headers = response.status_code, response.body, response.headers
        print(f"Response Code: {code} ")
        print(f"Response Body: {body} ")
        print(f"Response Headers: {headers} ")
        print("Message Sent!")
        return str(response.status_code)
    except Exception as e:
        print("Error: {0}".format(e))


def send_forgot_email(email, token, username, otp):
    message = Mail(
        from_email="noreply@crew-code.com",
        to_emails=email,
        subject='Otp verification!',
    )

    message.dynamic_template_data = {
        "sitetitle": "Crew Attendance",
        "preheader": "Crew Attendance",
        "username": username,
        "emailcontent": "Your otp to reset password is {otp}".format(otp=otp),
        "endcontent": "Please ignore this email if you not requested this",
        "thankscontent": "Thanks, Crew Attendance",
    }

    message.template_id = "d-67e5413363764f51ba3c6b66fe4b9400"

    try:
        ssl._create_default_https_context = ssl._create_unverified_context
        sg = SendGridAPIClient(app.config["SENDGRID_API_KEY"])
        response = sg.send(message)
        code, body, headers = response.status_code, response.body, response.headers
        print(f"Response Code: {code} ")
        print(f"Response Body: {body} ")
        print(f"Response Headers: {headers} ")
        print("Message Sent!")
        return str(response.status_code)
    except Exception as e:
        print("Error: {0}".format(e))
        return str(500)


def checkresetPasswordToken(token):
    try:
        return JsonResp(jwt.decode(token, app.config['SECRET_KEY']))
    except Exception as e:
        return JsonResp({"message": "Token is expired or invalid", "exception": str(e)}, 400)
