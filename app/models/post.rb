class Post < ActiveRecord::Base
    belongs_to :author, class_name:'User', foreign_key: 'author_id'
    belongs_to :viewable


    def self.get_all_posts
        merge_author(self.where(viewable: self.viewable_all))
    end

    def self.get_all_posts_auth
        merge_author(self.where.not(viewable: self.viewable_all_auth))
    end

    def self.get_single_post id
        merge_author(self.where(id: id).where(viewable: self.viewable_all))
    end

    def self.get_single_post_auth id
        merge_author(self.where(id: id).where.not(viewable: self.viewable_all_auth))
    end

    def self.get_user_all_posts author
        self.where(viewable: self.viewable_all, author: author)
    end
    def self.get_user_all_posts_auth author
        self.where.not(viewable: self.viewable_all_auth).where(author: author)
    end


    private

    def self.merge_author postQuery
        postQuery.includes(:author).map do |post|
            post.attributes.merge(
              'author' => post.author,
            )
        end
    end

    def self.viewable_all
        Viewable.find_by(name: "public")
    end

    def self.viewable_all_auth
        Viewable.find_by(name: "draft")
    end


end