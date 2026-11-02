#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

#Program that outputs information about elements

#if no provided argument
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

ELEMENT_DATA=$($PSQL "SELECT e.atomic_number, name, symbol, t.type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements e JOIN properties USING(atomic_number) JOIN types t USING(type_id) WHERE e.atomic_number::TEXT = '$1' OR symbol ILIKE '$1' OR name ILIKE '$1'")

if [[ -z $ELEMENT_DATA ]]
then
  echo "I could not find that element in the database."
else
  # 3. If it found something, read and print it
  echo "$ELEMENT_DATA" | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING
  do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  done
fi