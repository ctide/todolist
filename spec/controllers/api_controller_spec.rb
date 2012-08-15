require 'spec_helper'

describe ApiController do

  context '#authentication_token' do
    context 'valid' do
      before :each do
        @f = stub_model(User, :authentication_token => 'abcdef_token')
        User.stub(:find).and_return(@f)
        @f.stub(:valid_password?).and_return(true)
      end

      it 'should return an authentication token and user info for the user whose credentials match those posted in' do
        post :authentication_token, :password => 'abcdef', :email => @f.email
        response.should be_success
        response.body.should match({auth_token: @f.authentication_token, user: {user_id: @f.id}}.to_json)
      end
    end

    it 'should not return an auth token with the wrong password' do
      f = FactoryGirl.create(:user)
      post :authentication_token, :password => 'abcdefdfgkjdfklg', :email => f.email, :format => :json
      response.should_not be_success
      response.body.should eq({success: false, error: "Action prohibited."}.to_json)
    end

    it 'should return access denied for invalid emails' do
      post :authentication_token, :password => 'abcdef', :email => 'invalid@email.com', :format => :json
      response.should_not be_success
      response.body.should match('Action prohibited.')
    end
  end
end
