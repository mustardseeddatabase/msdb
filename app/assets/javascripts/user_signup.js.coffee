class @UserActivate
  constructor : ->
    $('#next_step').click => @check_user_info()
    $('#user_login').keyup => @check_user_info()
    $('#user_email').keyup => @check_user_info()
    $('#user_password').keyup => @check_user_info()
    $('#user_password_confirmation').keyup => @check_passwords()
    $("input[name='commit']").click => @check_policy()
    $("[id^='user_cb']").click => @check_policy()

  check_policy : ->
    checkbox_count = $("[id^='user_cb']").length
    @criterion($("[id^='user_cb']:checked").length == checkbox_count - 1) # -1 because we arrive here when the last cb id checked, but before it has the checked property
    @fail_message("Please check all the checkboxes to signify your agreement to comply with the #{ORGANIZATION_NAME} Privacy Policy")
    @error_field('#flash_message')

  check_user_info : ->
    if @_check_login() & @_check_email() & @_check_password() & @check_passwords()
      $(".user_info").css("display", "none")
      $("#privacy_policy").css("display", "block")

  check_passwords : ->
    @criterion($('#user_password').val() == $('#user_password_confirmation').val())
    @fail_message("The two password fields must match")
    @error_field('#password_confirmation_errors')

  _check_login : ->
    @criterion($('#user_login').val().length >= 6)
    @fail_message("Login name must have at least 6 characters")
    @error_field('#login_errors')

  _check_email : ->
    @criterion($('#user_email').val().length >= 9 )
    @fail_message('Please enter a legitimate email address')
    @error_field('#email_errors')

  _check_password : ->
    @criterion($('#user_password').val().length >= 7)
    @fail_message('Please select a password longer than 6 characters')
    @error_field('#password_errors')

  criterion : (test) ->
    @success = test

  fail_message : (message) ->
    if !@success
      @message = message
    else
      @message = ""

  error_field : (selector) ->
    $(selector).text(@message)
    @success
