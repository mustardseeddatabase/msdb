require Authengine::Engine.root.join('app', 'models', 'authenticated_system').to_s
require Authengine::Engine.root.join('app', 'models', 'authorized_system').to_s
require 'flexmock'
SITE_URL = "same_domain.com"

RSpec.configure do |config|
  config.mock_with :flexmock
end


class Foobar
  attr_accessor :flash

  def initialize
    @flash = {}
  end

  def extension; end

  def headers
    {}
  end


  def render(something); end

  include AuthenticatedSystem
  include AuthorizedSystem
end

describe "AuthenticatedSystem redirection when permission is denied" do

  it "redirects to the login page when user came from another site" do
    ext = flexmock('extension')
    ext.should_receive(:html).once.and_yield
    ext.should_receive(:xml).once.and_yield
    flexmock(Foobar).new_instances do |f|
      f.should_receive(:respond_to).once.and_yield(ext)
      f.should_receive(:session).and_return({:refer_to => nil})
      env = flexmock("env",
                     :env => {"HTTP_REFERER" => "http://same_domain.com/some_page"},
                     :fullpath => "http://same_domain.com/some_page")
      f.should_receive(:request).and_return(env)
      f.should_receive(:root_path).and_return("root_path")
      f.should_receive(:domain_name).and_return("http://same_domain.com/some_page")
      f.should_receive("redirect_to").once.with("root_path")
    end

    Foobar.new.send('permission_denied')
  end

  it "redirects to the login page if the http referer is not present" do
    ext = flexmock('extension')
    ext.should_receive(:html).once.and_yield
    ext.should_receive(:xml).once.and_yield
    flexmock(Foobar).new_instances do |f|
      f.should_receive(:respond_to).once.and_yield(ext)
      f.should_receive(:session).and_return({:refer_to => nil})
      env = flexmock("env",
                     :env => {"HTTP_REFERER" => nil},
                     :fullpath => "http://same_domain.com/some_page")
      f.should_receive(:request).and_return(env)
      f.should_receive(:root_path).and_return("root_path")
      f.should_receive(:domain_name).and_return("http://same_domain.com/some_page")
      f.should_receive("redirect_to").once.with("root_path")
    end

    Foobar.new.send('permission_denied')
  end

  context "when user came from this site" do
    it "redirects to the previous page if it's not the same as the requested page" do
      ext = flexmock('extension')
      ext.should_receive(:html).once.and_yield
      ext.should_receive(:xml).once.and_yield
      flexmock(Foobar).new_instances do |f|
        f.should_receive(:respond_to).once.and_yield(ext)
        f.should_receive(:session).and_return({:refer_to => nil})
        env = flexmock("env",
                       :env => {"HTTP_REFERER" => "http://same_domain.com/different_page"},
                       :fullpath => "http://same_domain.com/some_page")
        f.should_receive(:request).and_return(env)
        f.should_receive(:root_path).and_return("root_path")
        f.should_receive(:domain_name).and_return("http://same_domain.com/some_page")
        f.should_receive("redirect_to").once.with("http://same_domain.com/different_page")
      end

      Foobar.new.send('permission_denied')
    end

    it "redirects to the login page if the previous page is the same as the requested page" do
      ext = flexmock('extension')
      ext.should_receive(:html).once.and_yield
      ext.should_receive(:xml).once.and_yield
      flexmock(Foobar).new_instances do |f|
        f.should_receive(:respond_to).once.and_yield(ext)
        f.should_receive(:session).and_return({:refer_to => nil})
        env = flexmock("env",
                       :env => {"HTTP_REFERER" => "http://same_domain.com/some_page"},
                       :fullpath => "http://same_domain.com/some_page")
        f.should_receive(:request).and_return(env)
        f.should_receive(:root_path).and_return("root_path")
        f.should_receive("redirect_to").once.with("root_path")
      end

      Foobar.new.send('permission_denied')
    end
  end
end
