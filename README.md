# PsyPad Server

Open source Ruby on Rails 4 application used to manage participants, configurations and logs for the [PsyPad iPad Application](https://github.com/davidlawson/PsyPad).

[PsyPad](http://www.psypad.net.au/) is an open source platform for facilitating visual psychophysics experiments.

## Installation

This application was developed using Ruby 2.1.2. 

On OS X you can [install RVM](https://rvm.io/rvm/install) and then run `rvm install 2.1.2; rvm use --default 2.1.2`.

You'll also need to install Postgres ([Postgres.app](http://postgresapp.com/) is good for OS X users).

You can then clone this repository (`git clone https://github.com/davidlawson/PsyPad-Server`) and run the following commands to get started:

```
git clone https://github.com/davidlawson/PsyPad-Server
cd PsyPad-Server
bundle install
rake db:create
rake db:migrate
```

Start the server with `rails s`.

If you want to host the server online, I recommend using [Heroku](https://www.heroku.com/) which has a generous free tier that should suit most purposes.
