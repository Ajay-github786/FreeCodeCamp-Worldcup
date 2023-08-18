#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games, teams")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
    then
      #get team_id from winners 
      TEAM_ID=$($PSQL "SELECT team_id FROM teams where name='$WINNER'")
      #if team_id not found
      if [[ -z $TEAM_ID ]]
      then
        #insert team name from winners
        INSERT_TEAM_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
        #if [[ $INSERT_TEAM_NAME="INSERT 0 1" ]]
        #then
          #echo inserted into teams $WINNER
        #fi
      fi

      #get team_id from opponents 
      TEAM_ID=$($PSQL "SELECT team_id FROM teams where name='$OPPONENT'")
      #if team_id not found
      if [[ -z $TEAM_ID ]]
      then
        #insert team name from opponents
        INSERT_TEAM_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
        #if [[ $INSERT_TEAM_NAME="INSERT 0 1" ]]
        #then
          #echo inserted into teams $OPPONENT
        #fi
      fi
  fi  

  #insert all 32 rows into games table

      if [[ $YEAR != "year" ]]
      then
        
        WINNER_TEAM_ID=$($PSQL "SELECT team_id FROM teams where name='$WINNER'")
        OPPONENT_TEAM_ID=$($PSQL "SELECT team_id FROM teams where name='$OPPONENT'")
        echo $WINNER_TEAM_ID $OPPONENT_TEAM_ID
        INSERT_INTO_GAMES_DETAIL=$($PSQL "INSERT INTO games(year, round, winner_goals, opponent_goals, winner_id, opponent_id) VALUES($YEAR, '$ROUND', $WINNER_GOALS, $OPPONENT_GOALS, $WINNER_TEAM_ID, $OPPONENT_TEAM_ID)")

      fi
done


