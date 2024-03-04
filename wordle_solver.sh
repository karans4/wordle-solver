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
    :
else
    echo "Invalid pattern: $pattern"
    echo "Must be 5 characters, either lowercase letters or dots"
    exit 1
fi

printf '%s' "Enter the (yellow) letters with unknown spots, spaces in between:"
read yellows

yellows=`echo "$yellows" | tr '[:upper:]' '[:lower:]' |  awk '{ for(i = 1; i <= NF; i++){ if (i == NF) { printf $i " " "\n" } else { printf $i " "\
}}}'`
#echo $yellows
if echo $yellows | grep -E "([a-z] )*$"
then
    :
else
    echo "Invalid pattern: $yellows"
    echo "Must be letters seperated by spaces"
    exit 1
fi


command="grep -E '^$pattern\$' $dictionary_location"

for letter in $yellows
do
    command="$command | grep $letter"
done

printf '%s' "Enter the (gray) letters that are excluded, spaces in between:"

read grays

grays=`echo "$grays" | tr '[:upper:]' '[:lower:]' | awk '{ for(i = 1; i <= NF; i++){ if (i == NF) { printf $i " " "\n" } else { printf $i " "\
}}}'`
#echo $grays
if test "$grays" != ""
then
   command="$command | grep -E \"[^" 
   if echo $grays | grep -E " *([a-z] )* *$"
   then
       :
   else
       echo "Invalid pattern: $grays"
       echo "Must be letters seperated by spaces"
       exit 1
   fi

   for letter in $grays
   do
       command="$command$letter"
   done

   command="$command]{5}\""
fi

#echo $command

# filters out non letters (apostrophes and hyphens usually)
possible_words=$(eval $command | grep -E '[a-z]{5}')


# gets the count of each letter in the possible words list
# this is surprisingly not horribly slow.
#letters_count=`echo "$possible_words" |grep -o -E "[a-z]" - | sort| uniq -c`

letters_count=`echo $possible_words | awk '{
    split("", seen)
    for (i = 1; i <= NF; i++) {
        delete seen
        for (j = 1; j <= length($i); j++) {
            letter = substr($i, j, 1)
            if (!(letter in seen)) {
                count[letter]++
                seen[letter] = 1
            }
        }
    }
}
END {
    for (letter in count) {
        print letter " " count[letter]
    }
}'`


echo $letters_count


# This implementation *is* horribly slow so I rewrote it in awk
echo "These are the words you should try out next."
echo "The higher the number, the greater the chance of it being right"



#for word in $possible_words
#do
#     score="0"
#     for letter in `echo $word | grep -o -E "[a-z]" | sort | uniq`
#     do
# 	score=$(( $score + `echo $letters_count | grep -o -E "$letter [0-9]+" | grep -o -E "[0-9]+"`))
#     done
#     echo "$score $word"
# done | sort -n

printf "%s\n%s\n" "$letters_count" "$possible_words" | awk '{
    if (NF == 2) {
        scores[$1] = $2
    } else {
      score = 0
      word = $1
      delete seen
      for (i = 1; i <= length(word); i++) {
      	  letter = substr(word, i, 1)
	  if (!(letter in seen)) {
	     score += scores[letter]
	     seen[letter] = 1
	  }
      }

      print score " " word 
    }
}' | sort -n

echo "Just to repeat"
echo "These are the words you should try out next."
echo "The higher the number, the greater the chance of it being right"
