class UserController < ApplicationController
    # /User Routes
    post "/login" do
  
      name = request.POST["name"] ||= ""
  
      if name == ""
        return to_response suc: false, res: "No name param found!"
      end
  
      result = User.login name
  
      if result.count == 0
        return to_response suc: false, res: "No user found!"
      end
  
      to_response suc: true, res: result
  
    end
  
    get "/:profile" do
  
      profile = params[:profile] ||= ""
  
      return to_response suc: false, res: "No profile param found!" if profile==""
  
      result = User.get_profile(name: profile)
      
      return to_response suc: false, res: "No user found!" if result == nil
      
      to_response suc: true, res: result, options: {:except => [ :role_id ]}
  
    end
end