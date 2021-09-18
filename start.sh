#!/bin/sh
while true
do

  if ! grep -q "eula=true" eula.txt; then
      echo "Do you agree to the Mojang EULA available at https://account.mojang.com/documents/minecraft_eula ?"
      read  -n 1 -p "[y/n] " EULA
      if [ "$EULA" = "y" ]; then
          echo "eula=true" > eula.txt
          echo
      fi
  fi


  SERVERDIR="/home/minecraft/<servername>"
  cd ${SERVERDIR}

  JAVACMD="java"
  MAX_RAM="16G"
  MIN_RAM="6G"
  MCVER="1.12.2"
  FORGEVER="14.23.5.2855"
  #forge-1.12.2-14.23.5.2855.jar
  JARFILE="forge-$MCVER-$FORGEVER.jar"
  JAVA_PRAAMETERS="-XX:+UseG1GC -XX:+UnlockExperimentalVMOptions"
  #JAVA_PRAAMETERS="-XX:+UseConcMarkSweepGC"
  #JAVA_PRAAMETERS="-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent>

  #Originalstring
  #java -XX:+UseG1GC -XX:+UnlockExperimentalVMOptions -Xmx14G -Xms12G -jar forge-1.12.2-14.23.5.2855.jar nogui
  "$JAVACMD" -Xms${MIN_RAM} -Xmx${MAX_RAM} ${JAVA_PARAMETERS} -jar ${JARFILE} nogui

  echo "Restarting in 5 sec."
  sleep 5

done
