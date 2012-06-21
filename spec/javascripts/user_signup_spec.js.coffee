describe "Initial condition", ->
  beforeEach ->
    loadFixtures 'user_signup'
    ua = new UserActivate

  it "should show the user signup form", ->
    expect($('.user_info')).toBeVisible()
    expect($('#privacy_policy')).not.toBeVisible()

describe "When 'Next step...' is clicked", ->
  beforeEach ->
    loadFixtures 'user_signup'
    ua = new UserActivate

  it "should present error message when user selects login < 6chars", ->
    $('#user_login').val('norm')
    $('#next_step').click()
    expect($('#login_errors').text()).toEqual('Login name must have at least 6 characters')

  it "should remove error message when user increases login length", ->
    $('#next_step').click()
    $('#user_login').val('norman')
    $('#user_login').trigger('keyup')
    expect($('#login_errors').text()).toEqual('')

  it "should present error message when user selects email < 9chars", ->
    $('#user_email').val('no@y.co')
    $('#next_step').click()
    expect($('#email_errors').text()).toEqual('Please enter a legitimate email address')

  it "should remove error message when user increases email length", ->
    $('#next_step').click()
    $('#user_email').val('norm@foo.com')
    $('#user_email').trigger('keyup')
    expect($('#email_errors').text()).toEqual('')

  it "should present error message when user selects password less than 7 characters", ->
    $('#user_password').val("secret")
    $('#next_step').click()
    expect($('#password_errors').text()).toEqual('Please select a password longer than 6 characters')

  it "should remove error message when user increases password lenght", ->
    $('#next_step').click()
    $('#user_password').val("topsecret")
    $('#user_password').trigger('keyup')
    expect($('#password_errors').text()).toEqual('')

  it "should present error message when password confirmation does not match password", ->
    $('#user_password').val("topsecret")
    $('#user_password_confirmation').val("secret")
    $('#user_password_confirmation').trigger('keyup')
    expect($('#password_confirmation_errors').text()).toEqual("The two password fields must match")

  it "should remove the error message when the password fields match", ->
    $('#user_password').val("topsecret")
    $('#user_password_confirmation').val("topsecret")
    $('#user_password_confirmation').trigger('keyup')
    expect($('#password_confirmation_errors').text()).toEqual("")

  it "should hide the form and display the privacy policy when all fields are correctly entered", ->
    populate_user_fields()
    expect($('.user_info')).not.toBeVisible()
    expect($('#privacy_policy')).toBeVisible()

  describe "policy check", ->
    beforeEach ->
      populate_user_fields()

    it "should display error message if every checkbox is not checked", ->
      $("input[name='commit']").click()
      expect($('#flash_message').text()).toEqual("Please check all the checkboxes to signify your agreement to comply with the #{ORGANIZATION_NAME} Privacy Policy")

    it "should continue to show error message when one checkbox is checked", ->
      $("input[name='commit']").click() # puts error message up
      $("[id^='user_cb']")[0].checked = true # sets the property
      $("[id^='user_cb']")[0].click() # triggers the click event
      expect($('#flash_message').text()).toEqual("Please check all the checkboxes to signify your agreement to comply with the #{ORGANIZATION_NAME} Privacy Policy")

    it "should remove error message when all checkboxes are checked", ->
      $("input[name='commit']").click() # puts error message up
      _($("[id^='user_cb']")).each (cb)->
        cb.checked = true
        cb.click()
      expect($('#flash_message').text()).toEqual("")

populate_user_fields = ->
  $('#user_login').val('norman')
  $('#user_email').val('norm@foo.com')
  $('#user_password').val("topsecret")
  $('#user_password_confirmation').val("topsecret")
  $('#next_step').click()
