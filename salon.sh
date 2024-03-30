#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ Bambi & Mitzi's hair of magic ~~~~~\n"

# RESET_TABLE=$($PSQL "TRUNCATE TABLE customers RESTART IDENTITY CASCADE;")
# RESET_TABLE

MAIN_MENU() {
  if [[ $1 ]]
  then 
    echo -e "\n$1\n"
  fi

  SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id;")

  echo -e "Which spell would you like us to use on your hair today?\n"
  echo "$SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
  do
    echo -e "$SERVICE_ID) $SERVICE_NAME"
  done
  echo -e "4) exit\n"
  
  read SERVICE_ID_SELECTED
  
  case $SERVICE_ID_SELECTED in
    1) SERVICE_SELECTION 1 ;;
    2) SERVICE_SELECTION 2 ;;
    3) SERVICE_SELECTION 3 ;;
    4) EXIT ;;
    *) MAIN_MENU "That is not a valid option, please try again." ;;
  esac

}

SERVICE_SELECTION() {
  # read SERVICE_ID_SELECTED

  #if [[ $SERVICE_ID_SELECTED == 4 ]]
  #then
    #EXIT
  #else
    
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$1")
  SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE service_id=$1")

  echo -e "\nYou have selected the$SERVICE_NAME spell.\n"
  echo -e "\nPlease enter your phone number:\n"
  read CUSTOMER_PHONE

  PHONE_NUMBER=$($PSQL "SELECT phone FROM customers WHERE phone='$CUSTOMER_PHONE'")
  EXISTING_CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")

  if [[ -z $PHONE_NUMBER ]]
  then
    echo -e "We are unable to find this number in our system, please enter your name so we can add you: "
    read CUSTOMER_NAME
    INSERT_CUSTOMER_INFO=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  else
    echo -e "\nWelcome back$EXISTING_CUSTOMER_NAME!"
  fi
  
  FINAL_CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

  echo -e "\nPlease select a time you'd like to schedule your appointment: "
  read SERVICE_TIME
  ADD_SERVICE_TIME=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID, '$SERVICE_TIME')")


  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME,$FINAL_CUSTOMER_NAME."




}
EXIT() {
  echo -e "\n Thank you and have a wonderful day!\n"
}

MAIN_MENU