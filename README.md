mygit
=====

A wrapper around some GitHub API commands to allow quicker access to do stuff.


Setup
-----

Put config file where I can find it :-

    cp .mygit-example ~/.mygit

And then edit it to add your details

Setup a symlink to a directory in your path (I have ~/bin in mine)

    ln -s <full-path>/mygit/mygit ~/bin/mygit

Usage
-----

Git a list of all repos :-

    $ mygit list
    ...
    urlybird                        git@github.com:globaldev/urlybird.git
    ...


Find info on a repo :-

    $ mygit find urlybird
    {"language"=>"Ruby",
     "description"=>"Fetches all your URIs in one fell swoop.",
     "ssh_url"=>"git@github.com:globaldev/urlybird.git",
     "html_url"=>"https://github.com/globaldev/urlybird",
     "pushed_at"=>"2012-05-30T11:13:54Z",
     "created_at"=>"2012-05-16T08:19:38Z",
     ....
     (tons more)

Clone a repo by name :-

    $ mygit clone urlybird
    Cloning into 'urlybird'...
    ...


