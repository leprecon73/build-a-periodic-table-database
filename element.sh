#!/bin/bash

MAIN () {

  if [[ -z $1  ]]
  then
    echo Please provide an element as an argument.
  else
    PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

    if [[ $1 =~ ^[0-9]+$ ]] # if argument is a number
    then
      ELEMENT=$($PSQL "SELECT * FROM elements WHERE atomic_number = $1")
    else
      ELEMENT=$($PSQL "SELECT * FROM elements WHERE symbol = '$1' OR name = '$1'")
    fi


    if [[ -z $ELEMENT ]]
    then 
      echo "I could not find that element in the database."
    else
      # 1|H|Hydrogen  -> 1 H Hydrogen
      ELEMENT=$(echo $ELEMENT | sed 's/|/ /g')
      #${ELEMENT[0]} -> 1 ${ELEMENT[1]} -> H ${ELEMENT[2]} -> Hydrogen
      ELEMENT=($ELEMENT)
      
      ELEMENT2=$($PSQL "SELECT * FROM properties WHERE atomic_number = ${ELEMENT[0]}")
      #1|1.008|-259.1|-252.9|1 -> 1 1.008 -259.1 -252.9 1
      ELEMENT2=$(echo $ELEMENT2 | sed 's/|/ /g')
      ELEMENT2=($ELEMENT2)

      ELEMENT3=$($PSQL "SELECT type FROM types WHERE type_id = ${ELEMENT2[4]}")

      echo -e "The element with atomic number ${ELEMENT[0]} is ${ELEMENT[2]} (${ELEMENT[1]}). It's a $ELEMENT3, with a mass of ${ELEMENT2[1]} amu. ${ELEMENT[2]} has a melting point of ${ELEMENT2[2]} celsius and a boiling point of ${ELEMENT2[3]} celsius."
    fi
  fi
}

MAIN $1
