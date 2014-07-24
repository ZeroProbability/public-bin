public-bin
==========

This project contains scripts I use in my day to day workflow.


lookup_commands.pl
------------------

This script helps me store, organize and retrieve one-line command line scripts that I use frequently. Bash history is really good for 75% of the time, but often times searching through the history to pick out the correct command is no so easy. 

This script looks for a file named `commands.txt` in your home folder (can be over-ridden using environment variable LOOKUP\_FILE\_NAME).

The commands file is of following format.

    tag1, tag2 .. tagn : some description : some-long-one-liner-command

Example:     

    convert, links: replace soft links with real files  : for file in `find . -type l`; do echo "`readlink $file` --> $file"; cp --remove-destination `readlink $file` $file; done

The commands can have placeholders in them with format `${var:default_value}`. If the script finds any such placeholders, it prompts user to enter a value.

I also have following lines in my `.bashrc` that simplifies command lookup.

    alias lookup="_lookup $*"
    _lookup() 
    {
        __COMMAND=$(${HOME}/bin/public-bin/lookup_commands.pl $*)
        if [ "$?" -gt "0" ]; then
            return
        fi
        echo "About to execute: $__COMMAND"
        read -p "Proceed [y/n]? " -n 1 -r
        echo  # new line 
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            history -s $__COMMAND
            eval $__COMMAND
        else 
            echo "Command skipped."
        fi
    }

Once you have both setup, log back in into the shell and execute

    lookup convert
    
The script should lookup your tags and list the matching commands for you to choose. Chosen script is executed.

__note__: the additional history command in the `\_lookup()` function above will put the command in history so that the next time you could recall the command directly from history.

