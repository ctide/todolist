require 'spec_helper'

describe EntriesController do

  context '#create' do
    context 'valid' do
      before :each do
        @u = FactoryGirl.create(:user)
        sign_in(@u)
      end

      it 'should accept posts with valid text and respond with a new entry' do
        post :create, :entry => {:task => 'new entry'}
        response.should be_success
        response.body.should match(@u.entries.first.to_json)
      end
    end

    it 'should not throw an access denied error if the user is not signed in' do
      post :create, :entry => {:task => 'new entry'}, :format => :json
      response.should_not be_success
      response.status.should eq(401)
    end
  end

  context '#update' do
    context 'valid' do
      before :each do
        @u = FactoryGirl.create(:user)
        sign_in(@u)
      end

      it 'should allow updates to an existing task' do
        @u.entries.create(:task => 'abc')
        post :update, :id => @u.entries.first.id, :entry => {:task => 'whammy', :completed => true}
        response.should be_success
        @u.entries.first.task.should eq('whammy')
        @u.entries.first.completed.should eq(true)
      end
    end
  end

end
