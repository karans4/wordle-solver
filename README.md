# wordle-solver
POSIX compatible SH wordle solver. Should work on MacOS and Linux.
You can pass in a word list file location as the first argument. Otherwise, it checks it it's at ``/usr/share/dict/words`` (the default location).

## Requirements
### MacOS
You should already have the words list installed. If you don't, then you must have done something weird. Scroll to the last heading.

### Debian/Ubuntu
You should already have the words list installed. Try to install a package you found using `aptitude search '?provides(wordlist)'` if you don't.

### Fedora/Red Hat/CentOS/Rocky Linux
Try `yum install words`.

### Arch Linux and Maybe Manjaro Linux
Try `pacman -Syu words`.

### Everyone who doesn't have a `words` file
You can [download one from here](https://gist.github.com/WChargin/8927565). Pass in the location of the file for the first argument.
