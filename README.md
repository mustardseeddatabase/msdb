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

Download the code:

    git clone git://github.com/mustardseeddatabase/msdb.git

Install gem dependencies:

    bundle

Create a database:

    rake db:schema:load

Run the tests:

    cucumber features
    rspec spec

If you wish to import your own data, rather than start with a clean slate, you will need to write rake tasks to map your existing database onto the tables in the application. Depending on the structure of your database, this can be a tricky endeavour. Verifying that the import has been correctly executed is a manual task and cannot easily be automated.

## Customize the color scheme and graphics

Run the rake task:

    rake msdb:create_theme

The theme's text elements (banner text and page title) may then be configured in config/locales/en.yml.

All the images (logo and navigation icons) are combined in a single sprite, app/themes/custom/images/ms_sprite.png. Replace the elements in this image with images of your own.

Edit the stylesheets in app/themes/custom/stylesheets to render the pages with your own color scheme.

## Set up access accounts, roles and privileges

When it is first installed, the application is configured with a single access account with user name "admin" and password "password".

Another account should be configured, and the default account removed. It is a serious security vulnerability to leave the default account configured.
