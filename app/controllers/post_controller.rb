class PostController < ApplicationController

    hash_post_options = {except: ["viewable_id", "author_id", "role_id"]}

    # /posts Routes

    #all posts
    get "/" do

        isVerified = false

        if !!request.env["HTTP_TOKEN"]
            isVerified = verify_token(request.env["HTTP_TOKEN"])
        end

        results = Post.get_all_posts isVerified

        to_response(
            suc: results.size > 0, 
            res: results, 
            options: hash_post_options
        )    
    end

    #single posts
    get "/:id" do

        isVerified = false

        if !!request.env["HTTP_TOKEN"]
            isVerified = verify_token(request.env["HTTP_TOKEN"])
        end

        results = Post.get_single_post params[:id], isVerified

        to_response(
            suc: results.size == 1, 
            res: results, 
            options: hash_post_options
        )    
    end

    delete "/:id" do 
        results = Post.delete_post params[:id]

        to_response(
            suc: results.size > 0, 
            res: results, 
            options: {except: ["viewable_id", "author_id"]}
        )
    end




end