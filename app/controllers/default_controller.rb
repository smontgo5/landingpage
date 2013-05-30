class DefaultController < ApplicationController
def index
  end
  
  def authenticated
    return render :nothing => true unless params[:code]
    auth_token = Github.new.fetch_auth_token(params[:code])
    user = Github.new.user(auth_token)
    registrant = Registrant.create(:login       => user['login'],
                                   :avatar_url  => user['avatar_url'],
                                   :gravatar_id => user['gravatar_id'],
                                   :name        => user['name'],
                                   :company     => user['company'],
                                   :blog        => user['blog'],
                                   :location    => user['location'],
                                   :email       => user['email'])

    flash[:notice] =  thank_you_message(registrant)
    redirect_to :action => :index
  end
  
  private
  def thank_you_message(registrant)
    "Thank you for your interest, #{registrant.name_or_login}! We will be in touch with you soon."
  end
end