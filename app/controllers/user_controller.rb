class UserController < ApplicationController
    # /User Routes
    post "/login" do
  
      name = request.POST["name"] ||= ""
  
      if name == ""
        return create_response suc: false, res: "No name param found!"
      end
  
      result = User.login name
  
      if result.count == 0
        return create_response suc: false, res: "No user found!"
      end
  
      create_response suc: true, res: result
  
    end
  
    get "/:profile" do
  
      profile = params[:profile] ||= ""
  
      return create_response suc: false, res: "No profile param found!" if profile==""
  
      result = User.get_profile(name: profile)
      
      return create_response suc: false, res: "No user found!" if result == nil
      
      result = result.to_json(:except => [ :role_id ])
      create_response suc: true, res: JSON.parse(result)
  
    end
end