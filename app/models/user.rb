class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :token_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  #
  has_many :entries
  has_many :undone_entries, :source => :entries, :class_name => "Entry", :conditions => { :entries => { :completed => false } }
  has_many :finished_entries, :source => :entries, :class_name => "Entry", :conditions => { :entries => { :completed => true } }

end
