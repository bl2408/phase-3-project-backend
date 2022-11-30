class PostController < ApplicationController

    # /posts Routes
    get "/" do
        merge_author_json(Post.where(viewable: Viewable.find_by(name: "public")))       
    end

    post "/" do
        merge_author_json(Post.where.not(viewable: Viewable.find_by(name: "draft")))        
    end

    private

    def merge_author_json postQuery
        postQuery.includes(:author).map do |post|
            post.attributes.merge(
              'author' => post.author,
            )
        end.to_json(except: ["viewable_id", "author_id", "role_id"])
    end

    

end