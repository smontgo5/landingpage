class Registrant < ActiveRecord::Base
 attr_accessible :login, :avatar_url, :gravatar_id, :name, :company, :blog, :location, :email
  
  def name_or_login
    name.blank? ? login : name
  end
end