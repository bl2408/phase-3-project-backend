class PostController < ApplicationController

    hash_post_options = {except: ["viewable_id", "author_id", "role_id"]}

    # /posts Routes

    #all posts
    get "/" do

        results = Post.get_all_posts

        to_response(
            suc: results.size > 0, 
            res: results, 
            options: hash_post_options
        )    
    end

    #all posts when auth
    post "/" do      
        results = Post.get_all_posts_auth

        to_response(
            suc: results.size > 0, 
            res: results, 
            options: hash_post_options
        )      
    end


    #single posts
    get "/:id" do
        results = Post.get_single_post params[:id]

        to_response(
            suc: results.size == 1, 
            res: results, 
            options: hash_post_options
        )    
    end

    #single post with auth
    post "/:id" do  
        verify = verify_user(request.POST)
        results = Post.get_single_post_auth params[:id], verify[:success] ? verify[:value] : nil
        
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
    end
end