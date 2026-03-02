#!/bin/bash


#Incarca functiile aici

source ./COD_program

while true; do
      echo ""
      echo ""
      echo "***** Bine ai venit in aplicatia de sortat si editat liste *****"
      echo ""
      select opt in "Adauga task" "Lista task-uri" "Marcheaza task-ul ca si terminat" "Stergere task" "Exit";
      do
             case $REPLY in
                 1)task_nou; ;;
                 2)lista_taskuri; ;;
                 3)mark_done; ;;
                 4)stergere_task; ;;
                 5) echo "Asta a fost tot, o zi buna in continuare!"; exit 0 ;;
             esac
      done
done