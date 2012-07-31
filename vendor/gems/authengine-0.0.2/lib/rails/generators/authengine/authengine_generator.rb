require 'rails/generators'
require 'rails/generators/migration'

class AuthengineGenerator < Rails::Generators::Base
  include Rails::Generators::Migration

  def self.source_root
    File.join(File.dirname(__FILE__), 'templates')
  end

  def self.next_migration_number(dirname) #:nodoc:
    if ActiveRecord::Base.timestamped_migrations
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    else
      "%.3d" % (current_migration_number(dirname) + 1)
    end
  end


  # Every method that is declared below will be automatically executed when the generator is run

  def create_migration_file
    prepare_migration_directory
    remove_previous_migration

    f = File.open File.join(File.dirname(__FILE__), 'templates', 'schema.rb')
    schema = f.read; f.close

    schema.gsub!(/ActiveRecord::Schema.*\n/, '')
    schema.gsub!(/^end\n*$/, '')

    f = File.open File.join(File.dirname(__FILE__), 'templates', 'migration.rb')
    migration = f.read; f.close
    migration.gsub!(/SCHEMA_AUTO_INSERTED_HERE/, schema)

    f = File.open File.join(File.dirname(__FILE__), 'templates', 'pre_populate_database.rb')
    pre_populate = f.read; f.close
    migration.gsub!(/DATABASE_PREPOPULATE/, pre_populate)

    tmp = File.open "tmp/~migration_ready.rb", "w"
    tmp.write migration
    tmp.close
    
    if !File.exists?(File.join(Rails.root,'db','migrate'))
      FileUtils.makedirs(File.join(Rails.root, 'db', 'migrate'))
    end
    migration_template  '../../../tmp/~migration_ready.rb', 'db/migrate/create_authengine_tables.rb'
    remove_file 'tmp/~migration_ready.rb'
  end

  def copy_initializer_file
    copy_file 'initializer.rb', 'config/initializers/authengine.rb'
  end

  def update_application_template
    case
      when layout.unmodified?

        print "    \e[1m\e[34mquestion\e[0m  Your layouts/#{application_layout_file} layout currently has the line <%= yield %>. This gem needs to change this line to <%= content_for?(:content) ? yield(:content) : yield %> to support its nested layouts. This change should not affect any of your existing layouts or views. Is this okay? [y/n] "
        begin
          answer = gets.chomp
        end while not answer =~ /[yn]/i

        if answer =~ /y/i

          case
            when application_layout_file.erb?
              layout.gsub!(/<%=[ ]+yield[ ]+%>/, '<%= content_for?(:content) ? yield(:content) : yield %>')
              tmp = File.open "tmp/~application.html.erb", "w"
              tmp.write layout; tmp.close

              remove_file 'app/views/layouts/application.html.erb'
              copy_file '../../../tmp/~application.html.erb', 'app/views/layouts/application.html.erb'
              remove_file 'tmp/~application.html.erb'
            when application_layout_file.haml?
              layout.gsub!(/=\s*yield/, haml_yield_string)
              tmp = File.open "tmp/~application.html.haml", "w"
              tmp.write layout; tmp.close

              remove_file 'app/views/layouts/application.html.haml'
              copy_file '../../../tmp/~application.html.haml', 'app/views/layouts/application.html.haml'
              remove_file 'tmp/~application.html.haml'
          end
        end

      when layout.modified?
        puts "    \e[1m\e[33mskipping\e[0m  layouts/#{application_layout_file} modification is already done."
      else
        puts "    \e[1m\e[31mconflict\e[0m  The gem is confused by your layouts/#{application_layout_file}. It does not contain the default line <%= yield %>, you may need to make manual changes to get this gem's nested layouts working. Visit ###### for details."
      end
  end

  private
  # a fresh rails application does not have a db/migrate directory
  def prepare_migration_directory
    FileUtils.makedirs(File.join(Rails.root, 'db', 'migrate'))
  end

  # in case the generator is re-run, the migration is not duplicated
  # instead the user is asked if (s)he wants to remove the previous migration
  def remove_previous_migration
    migrate_dir = Dir.new(File.join(Rails.root, 'db', 'migrate'))
    if migration = migrate_dir.entries.detect{|f| f.match(/_create_authengine_tables.rb/)}
        print "    \e[1m\e[34mquestion\e[0m  A migration file called #{migration} already exists. Do you wish to overwrite it? [y/n] "
        begin
          answer = gets.chomp
        end while not answer =~ /[yn]/i

        if answer =~ /y/i
          File.delete(File.join(Rails.root, 'db', 'migrate', migration))
        end
    end
  end

  def layout
    f = File.open File.join("app", "views", "layouts", application_layout_file)
    @contents ||= f.read # otherwise every time we call layout, it re-reads the file!

    def @contents.unmodified?
      stripped_contents = self.gsub(/\s*/,'')
      match_haml = !(stripped_contents =~ /=yield/).nil?
      match_erb =  !(stripped_contents =~ /<%=yield%>/).nil?
      match_haml || match_erb
    end

    def @contents.modified?
      stripped_contents = self.gsub(/\s*/,'')
      match_haml = !(stripped_contents =~ /-content_for\?\(:content\)\?=yield\(:content\):=yield/).nil?
      match_erb =  !(stripped_contents =~ /<%=content_for\?\(:content\)\?yield\(:content\):yield%>/).nil?
      match_haml || match_erb
    end

    f.close
    @contents
  end

  def haml_yield_string
    "= content_for?(:content) ? yield(:content) : yield"
  end

  def erb_yield_string
    "<%#{haml_yield_string} %>"
  end

  def application_layout_file
    file = Dir.new("app/views/layouts").entries.detect{|f| f =~ /^application/ }

      def file.haml?
        !(self =~ /haml$/).nil?
      end

      def file.erb?
        !(self =~ /erb$/).nil?
      end

    file
  end

end

