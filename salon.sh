#! /bin/bash

# DEFAULT VARIABLES
DB_NAME="salon"
PSQL="psql --username=freecodecamp --dbname=$DB_NAME -t --no-align -c"
DELIMITER="|"


# FUNCTIONS
list_services() {
  echo "$($PSQL "SELECT service_id, name FROM services ORDER BY service_id ASC;")" | while IFS="$DELIMITER" read SERVICE_ID SERVICE_NAME; do
    echo -e "$SERVICE_ID) $SERVICE_NAME"
  done
}


# MAIN
echo -e "\n~~~~~ MY SALON ~~~~~\n"

# List all services and get service id from user
echo -e "Welcome to My Salon, how can I help you?\n"; list_services
while 
  read SERVICE_ID_SELECTED
  COSTUMER_SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  [[ -z $COSTUMER_SERVICE_NAME ]] 
do
  echo -e "I could not find that service. What would you like today?\n"
  list_services
done

# Get the user number, name and id
echo "What's your phone number?"
read CUSTOMER_PHONE
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE';")
if [[ -z $CUSTOMER_NAME ]]; then
  echo -e "I don't have a record for that phone number, what's your name?\n"
  read CUSTOMER_NAME
  # Register the user in database
  $($PSQL "INSERT INTO customers (name, phone) VALUES ('$CUSTOMER_NAME', '$CUSTOMER_PHONE');")
fi
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE';")


# Set the consult time
echo "What time would you like your cut, $CUSTOMER_NAME?"
read SERVICE_TIME

# Register appointment
INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments (time, service_id, customer_id) VALUES ('$SERVICE_TIME', $SERVICE_ID_SELECTED, $CUSTOMER_ID);")

echo -e "I have put you down for a $COSTUMER_SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
