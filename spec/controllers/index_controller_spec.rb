require 'spec_helper'

describe IndexController do

  context '#index' do
    it "should render the index template if no one signed in" do
      get :index
      response.should render_template('index')
    end

    context '#user signed in' do

      before :each do
        @user = User.new
        controller.stub(:current_user).and_return(@user)
      end

      it "should render dashboard if the user is signed in" do
        get :index
        response.should render_template('dashboard')
      end

    end

  end
end

