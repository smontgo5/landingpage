class DefaultController < ApplicationController
def index
  end
  
  def authenticated
    if params[:code]
      auth_token = Github.new.fetch_auth_token(params[:code])
      user = Github.new.user(auth_token)
      render :text => "Are you #{user['login']} &lt;#{user['email']}&gt;?"
    else
      render :nothing => true
    end
  end
end