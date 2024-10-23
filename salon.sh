#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

##Intro 
echo -e "\n~~~~ MY SALON ~~~~\n" 
##MAIN MENU PROMPT
#check if MAIN_MENU * $1 is called
MAIN_MENU() {
  if [[ $1 ]] 
  then 
    echo -e "\n$1"
  else
    echo -e "\nWelcome to my Salon, how can I help you?" 
  fi
  echo -e "\n1) cut\n2) color\n3) perm\n4) style\n5) trim"
  read SERVICE_ID_SELECTED
    case $SERVICE_ID_SELECTED in 
      1) SERVICE_NAME='cut';;
      2) SERVICE_NAME='color';;
      3) SERVICE_NAME='perm';;
      4) SERVICE_NAME='style';;
      5) SERVICE_NAME='trim';;
      *) MAIN_MENU "Please choose between 1 - 5" ;;
  esac
}
#beginning of the script 
MAIN_MENU

#get phone number 
echo -e "\nPlease input your Phone Number:" 
read CUSTOMER_PHONE

#check phone number 
PHONE_VALIDATE=$($PSQL "SELECT phone FROM customers WHERE phone='$CUSTOMER_PHONE'")
if [[ -z $PHONE_VALIDATE ]] 
then
#if no data found then ask for name
  echo -e "\nData is not in record, What is your name?" 
  read CUSTOMER_NAME 
  
  #insert phone and name into table 
  INSERT_CUSTOMERS=$($PSQL "INSERT INTO customers(name,phone) values('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
 
  #ask for time
  echo -e "\nWhat time would you like to $SERVICE_NAME?"
  read SERVICE_TIME
 
  #get id for customer_id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE' ")

  #Insert data into appointments table 
  INSERT_APPOINTMENTS=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) values($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")

  #display message of appointment to customer
  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
else
  #get customer name 
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE' ")
  #echo the name of the service and the customer name
  echo -e "\nWhat time would you want your $SERVICE_NAME,$CUSTOMER_NAME?"
  read SERVICE_TIME
  #get customer_id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE' ")
  #Insert data into appoinments
  INSERT_APPOINTMENTS=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) values($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
  #display to customers the appointment
  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

fi

