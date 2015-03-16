require 'spec_helper'

describe Invite do
  it { should validate_presence_of(:friend_name) }
  it { should validate_presence_of(:friend_email) }
  it { should validate_presence_of(:message) }
  it { should belong_to(:inviter).class_name("User") }
end
