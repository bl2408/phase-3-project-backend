class UserController < ApplicationController
    # /User Routes
    #logging in
    post "/login" do
  
      name = request.POST["name"] ||= ""
  
      if name == ""
        return to_response suc: false, res: "No name param found!"
      end
  
      results = User.login name
  
      if results.count == 0
        return to_response suc: false, res: "No user found!"
      end
  
      to_response suc: true, res: results
  
    end
    
    #view profile id or name
    get "/:userid" do
      user = params[:userid] ||= ""
      return to_response suc: false, res: "No user param found!" if user==""

      results = is_numeric?(user) ?  User.find(user) : User.get_profile(name: user)

      
      return to_response suc: false, res: "No user found!" if results == nil
      
      to_response suc: true, res: results, options: {:except => [ :role_id ]}
  
    end


    #view profile posts
    get "/:userid/posts" do
      user = params[:userid] ||= ""
      return to_response suc: false, res: "No user param found!" if user==""

      urlProfile = is_numeric?(user) ?  User.find(user) : User.get_profile(name: user)

      results = Post.get_user_all_posts urlProfile

        to_response(
            suc: results.size > 0, 
            res: results,
            options: {except: ["viewable_id", "author_id"]} 
        ) 
    end

    #view profile posts with auth
    post "/:userid/posts" do
      user = params[:userid] ||= ""
      return to_response suc: false, res: "No user param found!" if user==""

      # puts request.POST
      # return {success:false}.to_json

      # currentUser = {
      #   name: request.POST["name"] ||= "",
      #   id: request.POST["id"] ||= ""
      # }

      verify = verify_user(request.POST)
      urlProfile = is_numeric?(user) ?  User.find(user) : User.get_profile(name: user)
      results = Post.get_user_all_posts_auth urlProfile, verify[:value][:id] == urlProfile.id
        
      if verify[:success]
        to_response(
            suc: results.size > 0, 
            res: results, 
            options: {except: ["viewable_id", "author_id"]}
        )
      else
        to_response(
            suc: false, 
            res: [], 
            options: {except: ["viewable_id", "author_id"]}
        ) 
      end

      

      # profile = is_numeric?(user) ?  User.find(user) : User.get_profile(name: user)
      # results = Post.get_user_all_posts_auth profile, currentUser[:id] == profile.id

        
    end
end