class UserController < ApplicationController
    # /User Routes
    #logging in

    # pp request.env["HTTP_AUTH"]

    post "/login" do
      name = request.POST["name"] ||= ""
      return to_response suc: false, res: "Failed to login" if name==""

      results = User.login name

      if results.count == 0
        return to_response suc: false, res: "No user found!"
      end

      userObj = { **results[0].attributes, role: results[0].get_role }

      final = {
        user: userObj,
        token: Base64.urlsafe_encode64(userObj.to_json)
      }
      
      to_response suc: true, res: final
    end


    
    #view profile id or name
    get "/:userid" do
      user = params[:userid] ||= ""
      return to_response suc: false, res: "No user param found!" if user==""

      results = is_numeric?(user) ?  User.find(user) : User.get_profile(name: user)
      
      return to_response suc: false, res: "No user found!" if results == nil
      
      userObj = { **results.attributes, role: results.get_role }
            
      to_response suc: true, res: userObj
  
    end

    #view profile posts
    get "/:userid/posts" do
      user = params[:userid] ||= ""
      return to_response suc: false, res: "No user param found!" if user==""

      results = is_numeric?(user) ?  User.find(user) : User.get_profile(name: user)
      
      return to_response suc: false, res: "No user found!" if results == nil

     
      if !!request.env["HTTP_TOKEN"]
        verify = verify_token(request.env["HTTP_TOKEN"])

        if verify[:success]
          return to_response suc: true, res: results.get_all_posts(isAuthor: verify[:user].id == results.id)
        end

      end
            
      to_response suc: true, res: results.get_public_posts
  
    end
end