# Mustard Seed Database: Food Pantry Software

Manages the three primary workflow of a food pantry operation:

  * **Verification of client eligibility** - when client checks in at the food pantry, prompts for re-verification of expired documentation. Verification documents include:
    * Verification of identification.
    * Proof of residency.
    * Proof of household income.
    * Eligibility documentation may be scanned and stored in the database.
    * Determination of extent of client eligibility based on household income and household size.
  * **Received donations** - Barcodes are scanned and non-barcode items assigned sku codes. Receiving of items is logged and added to current inventory.
  * **Food distribution** - Record distribution of food items to clients, resembling a supermarket checkout model.

Includes admistration facilities:

  * Inventory cycle count.
  * Resolve database to actual inventory.
  * Report generation (future).
  * Database validation.
  * Role-based access control. Long-term staff may be assigned access accounts. Access may be configured for temporary or short-term staff that limits privileges and expires at the end of the session.

Fully "skinnable" with your own color scheme and graphical elements (logo, navigation icons).

## Installation
Installation requires git, rubygems, bundler and ruby 1.9.3 to be installed on the host computer.

If these are not already present, follow the installation instructions for each of them at:

  * **ruby** - [ruby-lang.org](http://www.ruby-lang.org/en/downloads/)
  * **rubygems** - [rubygems.org](http://rubygems.org)
  * **bundler** - [gembundler.com](http://gembundler.com/)
  * **git** - [git-scm.com](http://git-scm.com/)

Download the code from github:

    git clone git://github.com/mustardseeddatabase/msdb.git

Or if you have a github account, fork the code into your account and download from there, later you will use your own account as a repo for your own customized version.

Install gem dependencies:

    cd msdb
    bundle

Create a database (the default database is sqlite, to facilitate installation. You will certainly wish to replace that with mySQL or Postgres, so edit config/database.yml appropriately).:

    rake db:schema:load

Prepare the test database:

    rake db:schema:load RAILS_ENV=test

Run the tests:

    cucumber features
    rspec spec

Run the javascript tests by starting the rails server:

    rails s

Then point a browser to localhost:3000/jasmine

If you wish to import your own data, rather than start with a clean slate, you will need to write rake tasks to map your existing database onto the tables in the application. Depending on the structure of your database, this can be a tricky endeavour. Verifying that the import has been correctly executed is a manual task and cannot easily be automated.

Bootstrap access accounts. Set up the first adminstrative account, from which other access accounts can be generated via the user interface.

Note that the command format has no spaces or quotes, the arguments are first name, last name, login and password.

    rake authengine:bootstrap[Harry,Harker,hhrocks,sekret]

A sample set of data may be loaded into the database so you can explore the application and get a feel for how it works. Load up the sample data with:

    rake msdb:preload

## Customize the color scheme and graphics

Run the rake task:

    rake msdb:create_theme

The theme's text elements (banner text and page title) may then be configured in config/locales/theme/en.yml.

All the images (logo and navigation icons) are combined in a single sprite, app/themes/custom/images/ms_sprite.png. Replace the elements in this image with images of your own.

Edit the stylesheets in app/themes/custom/stylesheets to render the pages with your own color scheme.

## Set up access accounts, roles and privileges

A bootstrap rake task is provided to configure the first admin account (see above). After the first account is configured, further accounts and roles may be added via the user interface.

Roles, with user-defined names, are configured, and access privileges are assigned to the roles. When a user account is added, the user is assigned one (or more) roles.

Since a food pantry operation may be staffed by a transient cast of volunteers, an account may be temporarily downgraded (for the duration of the session) so that the computer may be used for, for instance, client checkout, without exposing the full database to the temporary staffer.
