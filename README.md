# ![Markdown Here logo](https://raw.githubusercontent.com/nickmc01/materis/master/app/assets/images/logo.png)

Materis is a task & productivity management application ideal for fast growing startups and small companies. 

Materis is engineered based on the concepts of [OKR](https://en.wikipedia.org/wiki/OKR) - Objectives and Key Results, invented and made popular by John Doerr. OKRs and OKR tools are used today by many companies, including Google, LinkedIn and Twitter

## You can use Materis for
- Managing and Tracking OKRs
- Creating, assigning and tracking tasks
- Maintaining log of time spent by employees
- Generating different types of reports, and in different formats
- Analyzing progress and productivity of your company, its departments, teams and employees

## License
Materis is released under [Apache License 2.0](https://github.com/nickmc01/Materis/blob/master/LICENSE)


## Installation

### Dependencies
- Ruby 2.1.0
- MySQL or MariaDB server
- Imagemagick
- wkhtmltopdf (To be downloaded from [this website](http://wkhtmltopdf.org/) and placed in lib folder)


### Install bundler and required gems
Once the specified version of Ruby is installed with all its dependencies satisfied, run the following command from the root directory of the application. (You can skip this section if you are using docker)
```sh
gem install bundler
bundle install
```
### Configure application

### Create and configure database


```sh
cp config/database.yml.example config/database.yml
```
Update the credentials in database.yml with actual values.

Now you can create the database and perform migrations
```sh
rake db:create
rake db:migrate
```
Materis will populate the database with an admin user entry when we run the seed.
```sh
rake db:seed
```
### Start the application

You can start the Rails server using
```sh
rails server
```


Materis can be accessed from the browser by navigating to [http://localhost:3000]().
#### Initial login credentials:
Email: admin@materis.local

Password: password
