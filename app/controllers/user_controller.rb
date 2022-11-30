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
    get "/:id" do
  
      profile = params[:id] ||= ""
  
      return to_response suc: false, res: "No user param found!" if profile==""

      results = is_numeric?(profile) ? User.find(profile) : User.get_profile(name: profile)

      
      return to_response suc: false, res: "No user found!" if results == nil
      
      to_response suc: true, res: results, options: {:except => [ :role_id ]}
  
    end


    #view profile posts
    get "/:id/posts" do
      user = params[:id] ||= ""

      return to_response suc: false, res: "No user param found!" if user==""

      profile = is_numeric?(user) ?  user : User.get_profile(name: user).id

      results = Post.get_user_all_posts profile

        to_response(
            suc: results.size > 0, 
            res: results,
            options: {except: ["viewable_id", "author_id"]} 
        ) 
    end

    #view profile posts with auth
    post "/:id/posts" do
      user = params[:id] ||= ""

      return to_response suc: false, res: "No user param found!" if user==""

      profile = is_numeric?(user) ?  user : User.get_profile(name: user).id

      results = Post.get_user_all_posts_auth profile

        to_response(
            suc: results.size > 0, 
            res: results, 
            options: {except: ["viewable_id", "author_id"]}
        ) 
    end


end