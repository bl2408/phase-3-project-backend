class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json'

  # Add your routes here
  get "/" do
    { result: "Nothing going on here." }.to_json
  end

  get "/roles" do
    to_response(
      suc: true, 
      res: Role.all, 
  )
  end

  get "/viewables" do
    to_response(
        suc: true, 
        res: Viewable.all, 
    ) 
  end


  def verify_token token
    results = {success: false, user: {} }
    decodeToken = Base64.urlsafe_decode64(token);
    tokenHash = eval(decodeToken)
    
    db = User.find(tokenHash[:id])

    if tokenHash[:id] != db["id"]|| tokenHash[:name] != db["name"] || tokenHash[:role_id] != db["role_id"]
      results
      pp "TOKEN: #{token} | VERIFIED: false"
    else
      pp "TOKEN: #{token} | VERIFIED: true"
      results[:success] = true
      results[:user] = db
      results
    end

  end


  def to_response suc:false, res: nil, options: nil
    {
      success: suc,
      results: res,
    }.to_json(options)

  end

  def is_numeric?(obj) 
    obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
  end

end
