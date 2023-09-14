#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.


echo $($PSQL "TRUNCATE TABLE games, teams;")



cat games.csv | while IFS="," read -r year round winner opponent winner_goals opponent_goals;
do


  if [[ $year != 'year' ]]
  then
    
    # check if winner is in table
    WINNER_TEAM=$($PSQL "SELECT name FROM teams WHERE name='$winner'")
    if [[ -z $WINNER_TEAM ]]
    then
    
    WINNER_TEAM_INSERT=$($PSQL "INSERT INTO teams(name) VALUES('$winner');")
    if [[ $WINNER_TEAM_INSERT == "INSERT 0 1" ]]
        then
          echo $winner
      fi
    fi 
    
    
    #check if loser is in table
    OPPONENT_TEAM=$($PSQL "SELECT name FROM teams WHERE name='$opponent'")
    if [[ -z $OPPONENT_TEAM ]]
    then
    # add loser
    OPPONENT_TEAM_INSERT=$($PSQL "INSERT INTO teams(name) VALUES('$opponent');")
    if [[ $OPPONENT_TEAM_INSERT == "INSERT 0 1" ]]
        then
          echo $opponent
      fi
    fi

  #find ids for winner and loser
  WINNER_TEAM=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")
  OPPONENT_TEAM=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")
  #insert values
  GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($year, '$round', $WINNER_TEAM, $OPPONENT_TEAM, $winner_goals, $opponent_goals)")

  fi
done

