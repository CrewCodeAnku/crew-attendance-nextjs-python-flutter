#!/bin/sh

WHITE='\033[1;37m'
RED='\033[0;31m'
GREEN='\033[0;32m'
BROWN='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
CYAN='\033[0;36m'
GREY='\033[1;30m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "${GREY}"

cat << "EOF"
#######   _____      __            
######   / ___/___  / /___  ______ 
#####    \__ \/ _ \/ __/ / / / __ \
####    ___/ /  __/ /_/ /_/ / /_/ /
###    /____/\___/\__/\__,_/ .___/ 
##                        /_/      
#

EOF

# PIPENV SETUP

echo "${BLUE}VIRTUAL ENVIRONMENT SETUP${NC}"
echo
pip install pipenv
pipenv install --python=$(which python3)
echo

# FLASK SETUP

echo "${BLUE}FLASK CONFIGURATION${NC}"
echo

# Defaults
SECRET_KEY=`cat /dev/urandom | head -c 24 | base64`
FLASK_DOMAIN="localhost"
FLASK_PORT_DEFAULT=5000
FLASK_DIRECTORY="$(pwd)/modules/"
MONGO_HOSTNAME_DEFAULT="localhost"

# Domain the Flask app will be running on
read -p "Flask App Domain [$FLASK_DOMAIN]: " FLASK_DOMAIN
FLASK_DOMAIN=${FLASK_DOMAIN:-$FLASK_DOMAIN}
echo

# Port the Flask app will be running on
read -p "Flask App Port [$FLASK_PORT_DEFAULT]: " FLASK_PORT
FLASK_PORT=${FLASK_PORT:-$FLASK_PORT_DEFAULT}
echo

# Domain of the front-end JavaScript application
read -p "Front-End Domain, port included (e.g. http://localhost, http://localhost:3000): " FRONTEND_DOMAIN
echo

# MongoDB hostname
read -p "Mongo Hostname [$MONGO_HOSTNAME_DEFAULT]: " MONGO_HOSTNAME
MONGO_HOSTNAME=${MONGO_HOSTNAME:-$MONGO_HOSTNAME_DEFAULT}
echo

# MongoDB database name for the app
while [[ $MONGO_APP_DATABASE == '' ]]
do
  read -p "Mongo App Database Name: " MONGO_APP_DATABASE

  if [[ $MONGO_APP_DATABASE == '' ]]
  then
    echo "${RED}Required${NC}"
  fi

  echo
done

# Rename config.cfg.sample to config.cfg
CONFIG_EXAMPLE_FILE=./modules/config/config.cfg.sample
CONFIG_FILE=./modules/config/config.cfg
mv $CONFIG_EXAMPLE_FILE $CONFIG_FILE

# Save configuration values to config.cfg
sed -i '' -e "s~##SECRET_KEY##~$SECRET_KEY~g" $CONFIG_FILE
sed -i '' -e "s~##FLASK_DOMAIN##~$FLASK_DOMAIN~g" $CONFIG_FILE
sed -i '' -e "s~##FLASK_PORT##~$FLASK_PORT~g" $CONFIG_FILE
sed -i '' -e "s~##FRONTEND_DOMAIN##~$FRONTEND_DOMAIN~g" $CONFIG_FILE
sed -i '' -e "s~##FLASK_DIRECTORY##~$FLASK_DIRECTORY~g" $CONFIG_FILE
sed -i '' -e "s~##MONGO_HOSTNAME##~$MONGO_HOSTNAME~g" $CONFIG_FILE
sed -i '' -e "s~##MONGO_APP_DATABASE##~$MONGO_APP_DATABASE~g" $CONFIG_FILE

echo "${GREEN}Flask configuration saved!${NC}"
echo

# INSTRUCTIONS TO START THE APP

echo "${BLUE}FIRE IT UP!${NC}"
echo

echo "To start the Flask app run these two commands:"
echo
echo "${GREY}> ${NC}pipenv shell"
echo "${GREY}> ${NC}./run"
echo