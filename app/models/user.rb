class User < ActiveRecord::Base
    belongs_to :role
    has_many :posts, foreign_key: 'author_id'


    # Instance methods
    #gets current user role
    def get_role
        self.role.name
    end

    #get public posts from user
    def get_public_posts
        Post.merge_author(self.posts.where(viewable: Viewable.find_by(name: "public")).order(created_at: :desc))
    end

    #get all posts from user - post owners will see all posts include drafts
    def get_all_posts isAuthor: false
        if isAuthor
            Post.merge_author(self.posts.order(created_at: :desc))
        else
            Post.merge_author(self.posts.where.not(viewable: Viewable.find_by(name: "draft")).order(created_at: :desc))
        end
    end

    # Class methods

    def self.login name
        where("lower(name) = ?", name.downcase)
    end

    def self.get_profile attr
        where("lower(name) = ?", attr[:name].downcase).first
    end
end