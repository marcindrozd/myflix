require 'spec_helper'

describe "Deactivate user on unsuccessful charge" do
  let(:event_data) do
    {
      "id" => "evt_15ot24HxsS6mta1ygYAXiDYf",
      "created" => 1428399008,
      "livemode" => false,
      "type" => "charge.failed",
      "data" => {
        "object" => {
          "id" => "ch_15ot24HxsS6mta1yP9rlWpjY",
          "object" => "charge",
          "created" => 1428399008,
          "livemode" => false,
          "paid" => false,
          "status" => "failed",
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "source" => {
            "id" => "card_15ot1RHxsS6mta1yZZCFcx4W",
            "object" => "card",
            "last4" => "0341",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 4,
            "exp_year" => 2019,
            "fingerprint" => "0SzLbc6aGvtC2dwm",
            "country" => "US",
            "name" => nil,
            "address_line1" => nil,
            "address_line2" => nil,
            "address_city" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_country" => nil,
            "cvc_check" => "pass",
            "address_line1_check" => nil,
            "address_zip_check" => nil,
            "dynamic_last4" => nil,
            "metadata" => {},
            "customer" => "cus_60Yfj9J09lrHcS"
          },
          "captured" => false,
          "balance_transaction" => nil,
          "failure_message" => "Your card was declined.",
          "failure_code" => "card_declined",
          "amount_refunded" => 0,
          "customer" => "cus_60Yfj9J09lrHcS",
          "invoice" => nil,
          "description" => "failed payment",
          "dispute" => nil,
          "metadata" => {},
          "statement_descriptor" => "myflix",
          "fraud_details" => {},
          "receipt_email" => nil,
          "receipt_number" => nil,
          "shipping" => nil,
          "application_fee" => nil,
          "refunds" => {
            "object" => "list",
            "total_count" => 0,
            "has_more" => false,
            "url" => "/v1/charges/ch_15ot24HxsS6mta1yP9rlWpjY/refunds",
            "data" => []
          }
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_60urv4Q6oPxM9G",
      "api_version" => "2015-02-18"
    }
  end

  it "deactivates user when failed charge webhook was received", :vcr do
    alice = Fabricate(:user, customer_token: "cus_60Yfj9J09lrHcS")
    post "/stripe_events", event_data
    expect(alice.reload).not_to be_active
  end
end
