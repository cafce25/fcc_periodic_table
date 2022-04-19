#!/bin/bash

PSQL="psql -X --user=freecodecamp --dbname=periodic_table --tuples-only -c"
if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ ^[0-9]+$ ]]; then
    ATOMIC_NUMBER=$1
  fi
  if [[ -z $ATOMIC_NUMBER ]]; then
    # lookup element by symbol
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1'" | sed -r 's/^\s+|\s+$//g')
  fi
  if [[ -z $ATOMIC_NUMBER ]]; then
    # lookup element by name
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$1'" | sed -r 's/^\s+|\s+$//g')
  fi
  if [[ -z $ATOMIC_NUMBER ]]; then
    echo I could not find that element in the database.
  else
    # fectch all info
    ELEMENT_INFO=$($PSQL "SELECT name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = $ATOMIC_NUMBER")
    # display info
    echo "$ELEMENT_INFO" | while read NAME BAR SYMBOL BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT; do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
fi