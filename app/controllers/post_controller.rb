class PostController < ApplicationController

    hash_post_options = {except: ["viewable_id", "author_id", "role_id"]}

    # /posts Routes
    get "/" do
        to_response(
            suc: true, 
            res: merge_author_json(Post.where(viewable: Viewable.find_by(name: "public"))), 
            options: hash_post_options
        )    
    end

    post "/" do      
        to_response(
            suc: true, 
            res: merge_author_json(Post.where.not(viewable: Viewable.find_by(name: "draft"))), 
            options: hash_post_options
        )    
    end

    private

    def merge_author_json postQuery
        postQuery.includes(:author).map do |post|
            post.attributes.merge(
              'author' => post.author,
            )
        end
    end

    

end