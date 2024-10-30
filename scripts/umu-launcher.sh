#!/bin/bash

enable -f /usr/lib/bash/csv csv

if [[ $(echo "$PWD" | grep -o '[^/]*$') =~ \ |\' ]]
then
mv "$PWD" $(echo "$PWD" | sed 's![^/]*$!!')$(echo "$PWD" | grep -o '[^/]*$' | sed 's/ /-/g')
fi

gn=${1%%.*}
gi=0

if [ -n "$1" ]
then
if [ ! -f "$PWD"/UMU-GAME-ID.txt ]
then
while read -r line; do
    csv -a row "$line"
    # Break out when you find a match
    gl=$( echo ${row[0]} | sed "s/ //g")
    [[ $gl = $gn ]] && gi=${row[3]} && printf "\n\n$gl(=)$gn\n" && break
    printf "\n$gl(X)$gn"
done < <(wget -q -O - "https://github.com/Open-Wine-Components/umu-database/raw/refs/heads/main/umu-database.csv")
cat > "UMU-GAME-ID.txt" << EOF
$gi
EOF
fi
export WINEPREFIX="$PWD"/.wp
export GAMEID=$(cat "$PWD"/UMU-GAME-ID.txt)
export PROTONPATH=GE-Proton

printf "\n
WINEPREFIX=$WINEPREFIX
GAMEID=$GAMEID
PROTONPATH=$PROTONPATH

"
umu-run "$PWD"/"$1"
else
printf ' ------------------------
 |give a game executable|
 ------------------------
'
fi
