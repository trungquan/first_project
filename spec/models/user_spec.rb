# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  password_digest :string(255)
#  admin           :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'spec_helper'

describe User do

  before { @user = User.new(name: "testname", password: "27111991", password_confirmation: "27111991") }

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }

  it { should be_valid }
  it { should_not be_admin }
  
  #Validates name of users
  describe "accessible attributes" do
    it  "should not allow access to admin" do
      expect do 
        User.new(admin: true)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "when name is not presence" do
    before { @user.name = " "}
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = 'a' * 31 }
    it { should_not be_valid }
  end

  describe "when password is not presence" do
    before { @user.password = " " } 
    it { should_not be_valid }
  end

  describe "when password is too short" do
    before { @user.password = 'a' * 5 }
    it { should_not be_valid }
  end

  describe "when password_confirmation is nil" do
    before { @user.password_confirmation = nil }
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "notmatch" }
    it {should_not be_valid }
  end

 describe "name is already exist" do
    before do
      user_same = @user.dup
      user_same_ = @user.name.upcase
      user_same.save
    end
    it { should_not be_valid }
  end

  describe "name should be downcase" do
    let(:mixed_name) {"QuAnTruNG"}
    it "save all downcase" do
      @user.name = mixed_name
      @user.save
      @user.reload.name == mixed_name.downcase
    end
  end

 
end
