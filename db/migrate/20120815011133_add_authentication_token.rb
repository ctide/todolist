class AddAuthenticationToken < ActiveRecord::Migration
  def change
    add_column :users, :authentication_token, :string
    add_index :users, :authentication_token, :unique => true
    User.all.each do |u|
      u.reset_authentication_token! if u.authentication_token.blank?
    end
  end
end
