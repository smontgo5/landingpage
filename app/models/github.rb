class Github
  CLIENT_SECRET = "0168b0e212238f79e5157246b0dc75de2c570bdd"
  CLIENT_ID     = "cb8b04ba869ac4b628fb"
  
  def initialize(http_fetcher=HttpFetcher.new)
    @http_fetcher = http_fetcher
  end
  
  def fetch_auth_token(code)
    from_json(@http_fetcher.post("https://github.com/login/oauth/access_token", 
                                 {:client_id => CLIENT_ID, :client_secret => CLIENT_SECRET, :code => code},
                                 :headers => {'Accept' => 'application/json'}))["access_token"]
  end
  
  def user(access_token)
    from_json(@http_fetcher.get("https://api.github.com/user", :authorization => "bearer #{access_token}"))
  end
  
  private
  def from_json(json)
    JSON.parse(json)
  end
end