class Post < ActiveRecord::Base
    belongs_to :author, class_name:'User', foreign_key: 'author_id'
    belongs_to :viewable

    # get all posts - verified users will get access to private posts
    def self.get_all_posts isVerified
        if isVerified
            merge_author(self.where.not(viewable: self.viewable_all_verified).order(created_at: :desc))
        else
            merge_author(self.where(viewable: self.viewable_all).order(created_at: :desc))
        end
    end

    # get single post - verified users will get access to private posts
    def self.get_single_post id, isVerified
        if isVerified
            merge_author(self.where(id: id).where.not(viewable: self.viewable_all_verified))
        else
            merge_author(self.where(id: id).where(viewable: self.viewable_all))
        end
    end

    #create new post
    def self.new_post user:, post:, view:
        Post.create(title: post["title"], body: post["body"], author: user, viewable: view)
    end

    #edit post
    def self.edit_post postId:, user:, post:, view:
        Post.update(postId, title: post["title"], body: post["body"], viewable: view)
    end

    #delete post
    def self.delete_post id
        db = self.where(id: id)
        return [] if db.size == 0
        stored = db.first
        db.first.destroy
        [stored]
    end
    
    #include/get author for query
    def self.merge_author postQuery
        postQuery.includes(:author).map do |post|
            post.attributes.merge(
                'author' => post.author,
            )
        end
    end
    
    private

    def self.viewable_all
        Viewable.find_by(name: "public")
    end

    def self.viewable_all_verified
        Viewable.find_by(name: "draft")
    end


end