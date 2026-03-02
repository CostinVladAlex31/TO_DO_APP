#!/bin/bash

FILE="todo.txt"
#Facem fisierul daca acesta nu exista
create_file() {
       [ ! -f "$FILE" ] && touch "$FILE"
              }

#Luam urmatorul id
next_id() {
    if [ ! -s "$FILE" ]; then

           echo 1
    else
           awk -F "|" '{print $1}' "$FILE" | sort -n | tail -1 | awk '{print $1 +1}'
    fi
}

#Adaugam o sarcina de lucru
task_nou() {
    read -p "Descriere Task" descriere
    read -p "Prioritate (1-5):" prioritate
    while [[ ! "$prioritate" =~ ^[1-5]$ ]]; do
         read -p "Prioritate incorecta, introdu te rog un numar din intervalul 1-5:" prioritate
    done
    id=$(next_id)
    echo "${id}|${descriere}|${prioritate}|pending" >> "$FILE"
    echo "Taskul a fost adaugat cu succes cu ID-ul $id."
}

#Filtram sarcinile de lucru
lista_taskuri() {
    echo "Filtrare dupa stare (pending/done/all): "
    read stare
    echo "Filtrare dupa prioritate (1-5 sau all): "
    read prioritate
    echo "Sortare dupa (1=ID, 2=Prioritate, 3=Stare): "
    read sortare

    echo ""
    echo "ID | Descriere | Prioritate | Stare"
    echo "------------------------------------------"

    awk -F "|" -v s="$stare" -v p="$prioritate" '
    {
        ok_stare = (s == "all" || $4 == s)
        ok_prio  = (p == "all" || $3 == p)
        if (ok_stare && ok_prio)
            print $0
    }' "$FILE" | sort -t"|" -k"$sortare"
}


#Marcam o sarcina de lucru ca si terminata
mark_done() {
    echo "ID-ul taskului care este a fost terminat cu succes : "
    read id

    if grep -q "^$id|" "$FILE";then
       awk -F "|" -v id="$id" 'BEGIN {OFS="|" }
       {
           if ($1 == id) $4 = "done"
           print
       }' "$FILE" > temp && mv temp "$FILE"
       echo "Taskul $id a fost marcat ca rezolvat."
            else
       echo "Id invalid.Te rugam mai incearca o data."
       fi
}

#Stergere id in functie de task
stergere_task() {
    echo "Id-ul taskului respectiv care va fi sters"
    read id

    if grep -q "^$id|" "$FILE";then
       grep -v "^$id|" "$FILE" > temp && mv temp "$FILE"
         echo "Task-ul $id a fost sters cu succes."
              else
         echo "ID invalid.Te rugam mai incearca o data."
    fi
}