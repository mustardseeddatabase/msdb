# monkeypatch alert, timeout problems with selenium-webdriver
if Rails.env=='development'

  class Capybara::Selenium::Driver < Capybara::Driver::Base

    def find(selector)
      begin
        find_elements(selector)
      rescue # Selenium::Webdriver::Error::UnhandledError
        sleep 1
        find_elements(selector)
      end
    end

  private
    def find_elements(selector)
      browser.find_elements(:xpath, selector).map{ |node| Capybara::Selenium::Node.new(self, node) }
    end
  end

end
