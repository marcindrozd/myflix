require 'spec_helper'

describe "Create payments on successful charge" do
  let(:event_data) do
    {
      "id" => "evt_15oVVlHxsS6mta1yQRxxkjqm",
      "created" => 1428308593,
      "livemode" => false,
      "type" => "charge.succeeded",
      "data" => {
        "object" => {
          "id" => "ch_15oVVlHxsS6mta1yEmoCEDC2",
          "object" => "charge",
          "created" => 1428308593,
          "livemode" => false,
          "paid" => true,
          "status" => "succeeded",
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "source" => {
            "id" => "card_15oVVeHxsS6mta1ymzvkaJjo",
            "object" => "card",
            "last4" => "4242",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 4,
            "exp_year" => 2017,
            "fingerprint" => "a1801dj0RfTG9ojP",
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
            "customer" => "cus_60WY3HcLTnZ1Oa"
          },
          "captured" => true,
          "balance_transaction" => "txn_15oVVlHxsS6mta1yrHTNTRye",
          "failure_message" => nil,
          "failure_code" => nil,
          "amount_refunded" => 0,
          "customer" => "cus_60WY3HcLTnZ1Oa",
          "invoice" => "in_15oVVlHxsS6mta1yaHiiIkGu",
          "description" => nil,
          "dispute" => nil,
          "metadata" => {},
          "statement_descriptor" => nil,
          "fraud_details" => {},
          "receipt_email" => nil,
          "receipt_number" => nil,
          "shipping" => nil,
          "application_fee" => nil,
          "refunds" => {
            "object" => "list",
            "total_count" => 0,
            "has_more" => false,
            "url" => "/v1/charges/ch_15oVVlHxsS6mta1yEmoCEDC2/refunds",
            "data" => []
          }
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_60WYHq1A7ftiv2",
      "api_version" => "2015-02-18"
    }
  end

  it "creates a payment with a webhook when charge succeeded", :vcr do
    post "/stripe_events", event_data
    expect(Payment.count).to eq(1)
  end

  it "creates payment with associated user", :vcr do
    alice = Fabricate(:user, customer_token: "cus_60WY3HcLTnZ1Oa")
    post "/stripe_events", event_data
    expect(Payment.first.user).to eq(alice)
  end

  it "creates payment with the amount", :vcr do
    alice = Fabricate(:user, customer_token: "cus_60WY3HcLTnZ1Oa")
    post "/stripe_events", event_data
    expect(Payment.first.amount).to eq(999)
  end

  it "creates payment with reference id", :vcr do
    alice = Fabricate(:user, customer_token: "cus_60WY3HcLTnZ1Oa")
    post "/stripe_events", event_data
    expect(Payment.first.reference_id).to eq("ch_15oVVlHxsS6mta1yEmoCEDC2")
  end
end
