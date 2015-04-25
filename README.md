# PsyPad Server

Open source Ruby on Rails 4 application used to manage participants, configurations and logs for the [PsyPad iPad Application](https://github.com/davidlawson/PsyPad).

[PsyPad](http://www.psypad.net.au/) is an open source platform for facilitating visual psychophysics experiments.

## Installation

This application was developed using Ruby 2.1.2. 

To obtain Ruby 2.1.2 on OS X you can [install RVM](https://rvm.io/rvm/install) and then run `rvm install 2.1.2; rvm use --default 2.1.2` on the command line.

You'll also need to install Postgres ([Postgres.app](http://postgresapp.com/) is good for OS X users).

You can then clone this repository (`git clone https://github.com/davidlawson/PsyPad-Server`) and run the following commands to get started:

```
cd <PsyPad-Server location>
bundle install
rake db:create
rake db:migrate
```

You will need to set the following environment variables:

* `RECAPTCHA_PUBLIC` (https://www.google.com/recaptcha)
* `RECAPTCHA_PRIVATE` (https://www.google.com/recaptcha)
* `SECRET_KEY_BASE` (run `rake secret` to generate)
* `MAILER_HOST` (domain name to send emails from)
* `MAILER_FROM` (email `From` address)
* `MAILER_REPLY_TO` (email `Reply-To` address)
* `IMAGE_SET_DIRECTORY` (directory to save uploaded image sets to)

You can then start the server with `rails s`.

If you want to host the server online, I recommend using [Heroku](https://www.heroku.com/) which has a generous free tier that should suit most purposes.
