class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json'
  
  # Add your routes here
  get "/" do
    { result: "Good luck with your project!" }.to_json
  end

  post "/login" do

    name = params[:name] ||= ""

    if name == ""
      return create_response suc: false, res: "No name param found!"
    end

    result = User.login name

    if result.count == 0
      return create_response suc: false, res: "No user found!"
    end

    create_response suc: true, res: result

  end

  get "/profile/:profile" do

    profile = params[:profile] ||= ""

    return create_response suc: false, res: "No profile param found!" if profile==""

    result = User.get_profile(name: profile)
    
    return create_response suc: false, res: "No user found!" if result == nil
    
    result = result.to_json(:only => [ :id, :name ])
    create_response suc: true, res: JSON.parse(result)

  end

  private

  def create_response suc:false, res: ""
    {
      success: suc,
      result: res
    }.to_json
  end

end
