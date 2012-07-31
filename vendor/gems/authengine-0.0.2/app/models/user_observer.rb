class UserObserver < ActiveRecord::Observer
  def after_create(user)
    Authengine::UserMailer.signup_notification(user).deliver
  end

  def after_save(user)
    # the next line causes deprecation warnings in
    # actionmailer/lib/actionmailer/adv_attr_accessor.rb
    # this could become fatal when the deprecated methods are removed
    Authengine::UserMailer.activation(user).deliver if user.pending? # pending? true if user is activated
    Authengine::UserMailer.forgot_password(user).deliver if user.recently_forgot_password?
    Authengine::UserMailer.reset_password(user).deliver if user.recently_reset_password?
  end
end
