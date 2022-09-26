# Crew Attendance Web and Mobile Application Using NextJS, Python and Flutter ✨

[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](https://crew-code.com/node-express-typescript-mongo-rest-api/)&nbsp;[![Build passing](https://img.shields.io/badge/Build-Passing-brightgreen.svg?style=flat-square)](https://crew-code.com/node-express-typescript-mongo-rest-api/)&nbsp;[![Open Source Love](https://badges.frapsoft.com/os/v1/open-source.svg?v=102)](https://crew-code.com/node-express-typescript-mongo-rest-api/)&nbsp;[![License](https://img.shields.io/badge/license-MIT-brightgreen)](https://crew-code.com/node-express-typescript-mongo-rest-api/)&nbsp;![Made with Love in India](https://madewithlove.org.in/badge.svg)

Crew Attendance is web and mobile application used to mark attendance of a class using realtime face recognition

## Features and Functionalities 😃

- Teacher and Student Login
- Teacher and Student Register
- Teacher Create Course
- Teacher Delete Course
- Teacher Mark Attendance
- Take class room attendance using face recognition
- Update Attendance
- Student enroll in course
- Student unenroll in course
- Teacher and Student update profile
- MongoDB for database
- NextJS as Frontend
- Flutter for Mobile Application
- Flask python for backend

## Screenshots

### App

![loginscreen](https://drive.google.com/uc?export=view&id=1qJYMhNzEeYJoljYwEv_It6CoKI2iBfDu)

### Create course

![create-course](https://drive.google.com/uc?export=view&id=1RuthzHDzwShNiE6KAoi2Y4hcR94dFQy8)

### Course Student Detail

![course-student](https://drive.google.com/uc?export=view&id=1xYg0V_vu4YDnjNkvPTRfx9MfGjs5Bc7b)

### Course Mark Attendance

![mark-attendance](https://drive.google.com/uc?export=view&id=1gpgSKgokzsURuw8XmFtOBLt7EnR5nhaM)

### Student enroll in course

![student-enroll](https://drive.google.com/uc?export=view&id=1DZ9Wo-oMejmc5eFw314iE56avAK1a9JS)

### Profile

![profile](https://drive.google.com/uc?export=view&id=1Hde8EktTCK_GiS5xpoaTpMU2QqTByPdg)

### Web Login

![login](https://drive.google.com/uc?export=view&id=1KHhIXhdNor9e-m5PEs2INTDW7TWmthkL)

### Web Course

![webcourse](https://drive.google.com/uc?export=view&id=1D9Dxqzn8RPTFOZlMkvgHWc-LI3KKAp1j)

## Tech Stack 💻

- [Flutter](https://flutter.dev/)
- [NextJS](https://nextjs.org/)
- [MongoDB](https://www.mongodb.com/)
- [Python Flask](https://flask.palletsprojects.com/en/2.2.x/)

## Installation and Running App:

### Running Backend API

**1. Clone this repo by running the following command :-**

```bash
 https://github.com/CrewCodeAnku/crew-attendance-nextjs-python-flutter.git
 cd crew-attendance-nextjs-python-flutter
```

**2. Run the setup this will install all the modules and create project for you :-**

```bash
 cd backend-python-flask
 ./setup.sh or bash setup.sh
```

**3. Enter all the credentials details inside modules/config/config.cfg :-**

```bash
 # Config files are not tracked in Git and must be placed manually in each
# app environment (e.g. development, staging, production).

# General
DEBUG = True
TIMEZONE = "US/Eastern"
SECRET_KEY = ""
ENVIRONMENT = "development"
FLASK_DIRECTORY = "Your project directory"
FLASK_DOMAIN = "0.0.0.0"
FLASK_PORT = 4000
FRONTEND_DOMAIN = "http://localhost:3000"
HTTP_HTTPS = "http://"
FRONTEND_URL = "http://localhost:3000"

# Database
MONGO_HOSTNAME = "localhost"
MONGO_PORT = 27017
MONGO_AUTH_DATABASE = ""
MONGO_AUTH_USERNAME = ""
MONGO_AUTH_PASSWORD = ""
MONGO_APP_DATABASE = "crewattendance"

# Sendgrid
SENDGRID_API_KEY = ""

# AWS
S3_KEY = ""
S3_SECRET    = ""
BUCKET_NAME   = ""
S3_LOCATION   = ""

```

**4. Now in order to start backend need to run following command :-**

Start your python flask api

```bash
python3 run.py
```

### Running Flutter App

**1. Go to mobile-app folder :-**

**2. Change the API url in lib/util/app_url file :-**

```bash
static const String localBaseURL = "http://192.168.1.4:4000";
```

**3. Start the app :-**

```bash
flutter run
```

### Running NextJS Web application

**1. Go to frontend-nextjs folder :-**

**2. Run following command to start the project :-**

```bash
cd frontend-nextjs
npm run dev
```

## 🤩 Don't forget to give this repo a ⭐ if you like this repo and want to appreciate our efforts

[![forthebadge](https://forthebadge.com/images/badges/built-with-love.svg)](https://forthebadge.com)
[![forthebadge](https://forthebadge.com/images/badges/built-by-developers.svg)](https://forthebadge.com)
