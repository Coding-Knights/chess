# THE CODING KNIGHTS

This web application was created by Joe H, Vincent J, Edgar A, Arthur B, Adalberto T, & Raquibbi M of the Coding Knights. This was our final project for the UT Coding Bootcamp here in Austin, TX. This is an ongoing project and we will be adding more features as time progresses. 

## Features
- Personal account creation (sign in with Facebook, Twitter, Google, or simply create an account).<br />
- Two player games<br />
- Authenticated users can create new games<br />
- Users can destroy games<br />

## Installation

Made with `Ruby 2.5.3` and `Rails ~> 5.2.4`<br />
Dependencies managed with `Bundler version 1.17.1`

Run:
```bash
bundle install
```
..to install dependencies. 

Then run the following commands to build the database:

```bash
rake db:create
rake db:schema:load
```

### Running the tests

We chose [Rspec](https://rspec.info/) to build out our test suite.<br />
`bundle exec rspec` - will run all specs(tests) for the project. 

## Gem highlights

### Devise

This project uses Devise for user registration, authentication, and validation. You can read more about Devise on their [github.](https://github.com/heartcombo/devise)

### Bootstrap

This project uses Bootstrap framework for the responsive CSS. You can read more about it on their [website.](https://getbootstrap.com/docs/4.4/getting-started/introduction/)

### Simple Form 

This is used in tandem with Bootstrap for user form submittals. You can read more about it on their [github.](https://github.com/heartcombo/simple_form)

### Omniauth

The sign-in page relies on omniauth for users to create an account or sign in to an existing account via a third party. You will need to get your own API credentials from each company (Facebook, Google, Twitter) and set them in an `environment variable` for your version of this project to allow third-party authentication. 
