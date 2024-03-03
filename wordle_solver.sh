#!/usr/bin/env sh

# Variable to store dictionary (word list) location
dictionary_location=""

# You can pass the dictionary location as the first argument
# Otherwise it checks if it is at /usr/share/dict/words
if test -n "$1"
then
    if test -f "$1"
    then
	dictionary_location="$1"
    else
        echo "Error: Provided dictionary file does not exist"
        exit 1
    fi
elif test -f "/usr/share/dict/words"
then
    
    dictionary_location="/usr/share/dict/words"
else
    echo "Error: Default dictionary file not found"
    exit 1
fi

# This script does a series of grep commands on $dictionary_location
printf '%s' "Enter the (green) letters with known locations or dots (.) instead: "

read pattern

# Upper case to lower case
pattern=`echo "$pattern" | tr '[:upper:]' '[:lower:]'`

if echo $pattern | grep -E "^[a-z.]{5}$"
then
    continue
else
    echo "Invalid pattern: $pattern"
    echo "Must be 5 characters, either lowercase letters or dots"
    exit 1
fi

printf '%s' "Enter the (yellow) letters with unknown spots, spaces in between:"
read yellows

yellows=`echo "$yellows" | tr '[:upper:]' '[:lower:]'`
if echo $yellows | grep -E " *([a-z] )* *$"
then
    continue
else
    echo "Invalid pattern: $yellow"
    echo "Must be letters seperated by spaces"
    exit 1
fi

printf '%s' "Enter the (gray) letters that are excluded, spaces in between:"

read grays

grays=`echo "$grays" | tr '[:upper:]' '[:lower:]'`
if echo $grays | grep -E " *([a-z] )* *$"
then
    continue
else
    echo "Invalid pattern: $grays"
    echo "Must be letters seperated by spaces"
    exit 1
fi

command="grep -E '^$pattern\$' $dictionary_location"

for letter in $yellows
do
    command="$command | grep $letter"
done


command="$command | grep -E \"[^\\" #place holder if no letters excluded

for letter in $grays
do
    command="$command$letter"
done

command="$command]\""

eval "$command | grep -E '[a-z]{5}'" # filters out non letters ( ' or - usually)


