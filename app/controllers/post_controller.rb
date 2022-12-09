class PostController < ApplicationController

    hash_post_options = {except: ["viewable_id", "author_id", "role_id"]}

    # /posts Routes

    #all posts
    get "/" do

        isVerified = {success: false}

        if !!request.env["HTTP_TOKEN"]
            isVerified = verify_token(request.env["HTTP_TOKEN"])
        end

        results = Post.get_all_posts isVerified[:success]

        to_response(
            suc: results.size > 0, 
            res: results, 
            options: hash_post_options
        )    
    end
    # create post
    post "/" do

        isVerified = {success: false}

        if !!request.env["HTTP_TOKEN"]
            isVerified = verify_token(request.env["HTTP_TOKEN"])
        end

        viewable = Viewable.find_by(name: params["viewable"]);

        if viewable == nil
            isVerified[:success] = false
        end

        if !isVerified[:success]
            return to_response(
                suc: false, 
                res: "Error creating post!", 
            )
        end

        results = Post.new_post user: isVerified[:user], post: params, view: viewable

        to_response(
            suc: true, 
            res: results, 
            options: hash_post_options
        )    
    end

    #single posts
    get "/:id" do

        isVerified = {success: false}
        

        if !!request.env["HTTP_TOKEN"]
            isVerified = verify_token(request.env["HTTP_TOKEN"])
        end

        results = Post.get_single_post params[:id], isVerified[:success]

        to_response(
            suc: results.size == 1, 
            res: results, 
            options: hash_post_options
        )    
    end
    # update post
    put "/:id" do

        isVerified = {success: false}

        if !!request.env["HTTP_TOKEN"]
            isVerified = verify_token(request.env["HTTP_TOKEN"])
        end

        viewable = Viewable.find_by(name: params["viewable"]);

        if viewable == nil
            isVerified[:success] = false
        end

        if !isVerified[:success]
            return to_response(
                suc: false, 
                res: "Error editing post!", 
            )
        end

        results = Post.edit_post postId: params["id"], user: isVerified[:user], post: params, view: viewable

        to_response(
            suc: true, 
            res: results, 
            options: hash_post_options
        )    
    end

    delete "/:id" do 
        isVerified = {success: false}

        if !!request.env["HTTP_TOKEN"]
            isVerified = verify_token(request.env["HTTP_TOKEN"])
        end     

        results = Post.delete_post params[:id], isVerified[:user] 

        to_response(
            suc: results.size > 0, 
            res: results, 
            options: {except: ["viewable_id", "author_id"]}
        )
    end




end