require 'spec_helper'

describe StripeWrapper do
  let(:valid_token) do
    Stripe::Token.create(
      card: {
        number: "4242424242424242",
        exp_month: 3,
        exp_year: 2017,
        cvc: "314"
      }
    ).id
  end

  let(:invalid_token) do
    Stripe::Token.create(
      card: {
        number: "4000000000000002",
        exp_month: 3,
        exp_year: 2017,
        cvc: "314"
      }
    ).id
  end

  describe StripeWrapper::Charge do
    describe ".create" do
      it "makes a successful charge", :vcr do
        response = StripeWrapper::Charge.create(
          amount: 999,
          source: valid_token,
          description: "valid charge"
        )

        expect(response).to be_successful
      end

      it "makes a card declined charge", :vcr do
        response = StripeWrapper::Charge.create(
          amount: 999,
          source: invalid_token,
          description: "invalid charge"
        )

        expect(response).not_to be_successful
      end

      it "returns the error message for declined charges", :vcr do
        response = StripeWrapper::Charge.create(
          amount: 999,
          source: invalid_token,
          description: "invalid charge"
        )

        expect(response.error_message).to eq("Your card was declined.")
      end
    end
  end

  describe StripeWrapper::Customer do
    describe ".create" do
      it "creates a customer with valid card", :vcr do
        alice = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          user: alice,
          source: valid_token
        )

        expect(response).to be_successful
      end

      it "does not create a customer with invalid card", :vcr do
        alice = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          user: alice,
          source: invalid_token
        )

        expect(response).not_to be_successful
      end

      it "returns the error message for declined charges", :vcr do
        alice = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          user: alice,
          source: invalid_token
        )

        expect(response.error_message).to eq("Your card was declined.")
      end
    end
  end
end
