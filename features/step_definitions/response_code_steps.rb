# from http://www.cloudspace.com/blog/2009/02/18/creating-a-reusable-dictionary-of-steps-in-cucumber/
# but it doesn't seem to work! need to debug this
Then /^it should return a response code of "(.+)"$/ do |resp_code|
  response.code.should == resp_code
end
