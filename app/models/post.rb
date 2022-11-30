class Post < ActiveRecord::Base
    belongs_to :author, class_name:'User', foreign_key: 'author_id'
    belongs_to :viewable


    def self.get_all_posts
        merge_author(self.where(viewable: Viewable.find_by(name: "public")))
    end

    def self.get_all_posts_auth
        merge_author(self.where.not(viewable: Viewable.find_by(name: "draft")))
    end

    def self.get_single_post id
        merge_author(self.where(id: id).where(viewable: Viewable.find_by(name: "public")))
    end

    def self.get_single_post_auth id
        merge_author(self.where(id: id).where.not(viewable: Viewable.find_by(name: "draft")))
    end

    def self.get_user_all_posts id
        self.where(viewable: Viewable.find_by(name: "public"), author: User.find(id))
    end
    def self.get_user_all_posts_auth id
        self.where.not(viewable: Viewable.find_by(name: "draft")).where(author: User.find(id))
    end


    private

    def self.merge_author postQuery
        postQuery.includes(:author).map do |post|
            post.attributes.merge(
              'author' => post.author,
            )
        end
    end


end