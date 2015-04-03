class UserSignUp
  attr_accessor :user
  attr_reader :error_message

  def initialize(user)
    @user = user
  end

  def sign_up(stripe_token, invite_token)
    if user.valid?
      customer = StripeWrapper::Customer.create(
          user: user,
          source: stripe_token,
        )

      if customer.successful?
        user.save

        handle_invitation(invite_token)

        UserMailer.welcome_email(user.id).deliver
        @status = :success
        self
      else
        @error_message = customer.error_message
        @status = :failed
        self
      end
    else
      @error_message = "Please correct the below errors"
      @status = :failed
      self
    end
  end

  def handle_invitation(token)
    invite_token = token

    if invite_token.present?
      invite = Invite.find_by(invite_token: invite_token)
      @inviter = invite.inviter
      user.follow(@inviter)
      @inviter.follow(user)
      invite.remove_token!
    end
  end

  def successful?
    @status == :success
  end
end
