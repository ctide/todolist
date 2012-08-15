class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :token_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :entries
  has_many :undone_entries, :source => :entries, :class_name => "Entry", :conditions => { :entries => { :completed => false } }
  has_many :finished_entries, :source => :entries, :class_name => "Entry", :conditions => { :entries => { :completed => true } }

end
