# the table is managed so as to make it mirror the file system
# the only reason this is necessary is to be able to store in the
# database a last_modified attribute for a file, in order to
# know whether the actions table is up to date for this controller
# or should be regenerated from the file contents
# The class represents both filesystem objects and database objects
# hmmm... is that really the best way to design it, shouldn't it be two classes?
class Controller < ActiveRecord::Base
  has_many :actions, :dependent=>:delete_all
  CONTROLLERS_DIR = "#{Rails.root.to_s}/app/controllers"

  cattr_accessor :controllers

  # returns an array of strings, each one is a controller name
  def self.all_controller_names
    @@controllers ||= all_files.map { |file| file.camelize.gsub(".rb","") }
  end

  def self.all_files
    application_files + engine_files
  end

  def self.engine_files
    engine_controller_paths.inject([]) do |array, path|
      # entries may be controller files, but if there are namespaced controllers
      # then entries are directories
      directories, files = Dir.new(path).entries.reject{|c|c.match(/^\./)}.partition{|c| File.directory?(File.new(File.join(path,c)))}
      array += files
      directories.each do |directory|
        files = Dir.new(File.join(path,directory)).reject{|c|c.match(/^\./)}.entries.map{|file| File.join(directory,file)}
        array += files
      end
      array
    end
  end

  def self.engine_controller_paths
    Rails::Engine.subclasses.collect { |engine|
      engine.config.eager_load_paths.detect{|p| p=~/controller/}
    }.flatten.compact
  end

  def self.application_files
    Dir.new(CONTROLLERS_DIR).entries.reject{|c| c.match(/^\./)}.reject{|c| c == 'application_controller.rb'}
  end

  def self.all_modified_files
    all_controller_names.select(&:modified?)
  end

  # a file is declared to be modified if it's either older or newer than the last_modified date
  # this triggers re-parsing the actions in the file whether it's older or newer
  # and so responds both to the file being edited and also the database being restored
  # from an older version.
  # Only by converting to string could I persuade two apparently equal DateTime objects to match!
  def modified?
    file_modification_time.to_s != last_modified.getutc.to_datetime.to_s
  end

  def file_modification_time
    file.mtime.getutc.to_datetime
  end

  def file
    all_paths = Controller.engine_controller_paths << CONTROLLERS_DIR
    controller_path = all_paths.detect do |path|
      full_path = File.join(path, "#{controller_name}_controller.rb")
      File.exists?(full_path)
    end
    File.new(File.join(controller_path, "#{controller_name}_controller.rb"))
  end

  # updates the controllers table so that it contains a record for each controller file
  # in the /app/controllers directory
  def self.update_table
    cc = Controller.all.inject({}){ |hash,controller| hash[controller.controller_name]=controller; hash } # from the database
    all_controller_names.each do |f| # f is of the form "ItemsController"
      cont = f.tableize.gsub!("_controllers","") # cont is of the form "items"
      admin_name = Role.find_by_name("administrator") ? "administrator" : "admin"
      if !cc.keys.include?(cont) # it's not in the db
        new_controller = new(:controller_name=>f.underscore.gsub!("_controller", ""), :last_modified=>Date.today) # add controller to controllers table as there's not a record corresponding with the file
        new_controller.actions << new_controller.action_list.map { |a| Action.new(:action_name=>a[1]) }# when a new controller is added, its actions must be added to the actions.file
        new_controller.save
      elsif cc[cont].modified? # file was modified since db was updated, so read the actions from the file, and add/delete as necessary
        action_names = cc[cont].actions_from_file # action_names is of the form ["index", "new", "edit", "create", "update"]
        Action.update_table_for(cc[cont],action_names)
        # finally modify the last_modified date of the controller record to match the actual file
        cc[cont].update_attribute(:last_modified,cc[cont].file_modification_time)
      end
    end
    ActionRole.assign_developer_access
    # delete any records in the controllers table for which there's no xx_controller.rb file... it must've been deleted
    cc.each { |name,controller| controller.destroy if !all_controller_names.map{|cn| cn.tableize.gsub!("_controllers","")}.include?(name) }

  end

  def self.all_actions_from_files
    all_controller_names.inject([]){ |ar,c| ar+=c.action_list; ar  }
  end

  def model_name
    controller_name.gsub("Controller","").underscore
  end

  # the actions returned are those that were in the file when it was loaded
  # this is reasonable only because the actions are changed by the developer
  # and never get changed "on the fly". However this fact should be considered when testing!
  def actions_from_file
    # there's a workaround here for some strangeness that appeared in Rails 3
    # where public_instance_methods returns some spurious methods with the format
    # _one_time_conditions_valid_nnn?
    controller.public_instance_methods(false).reject{|m| m.match(/one_time_conditions_valid/)}.map(&:to_s)
  end

  def controller
    (controller_name+"_controller").classify.constantize
  end

  # returns an array of arrays, each contains the controller controller_name and action name
  def action_list
    actions_from_file.collect { |m| [model_name,m] }
  end

end
