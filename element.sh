#!/bin/bash

PSQL="psql -X --user=freecodecamp --dbname=periodic_table --tuples-only -c"
if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
  exit 1
fi
if [[ $1 =~ ^[0-9]+$ ]]
then
  ATOMIC_NUMBER=$1
fi
if [[ -z $ATOMIC_NUMBER ]]
then
  # lookup element by symbol
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1'")
fi
if [[ -z $ATOMIC_NUMBER ]]
then
  # lookup element by name
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$1'")
fi
if [[ -z $ATOMIC_NUMBER ]]
then
  echo I could not find that element in the database.
  exit 2
else
  # fectch all info
  ELEMENT_INFO=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = $ATOMIC_NUMBER")
  # display info
  echo $ELEMENT_INFO
fi