require 'spec_helper'

describe User do
  context '#undone_entries' do
    before :each do
      @user = FactoryGirl.create(:user)
      @entry = FactoryGirl.create(:entry, :user => @user)
      @entry2 = FactoryGirl.create(:entry, :user => @user)
    end

    it 'should return all entries that are not done' do
      @user.undone_entries.should include(@entry)
      @user.undone_entries.should include(@entry2)
    end

    it 'should not return completed entries' do
      @entry2.completed = true
      @entry2.save!
      @user.undone_entries.should_not include(@entry2)
    end
  end
end


