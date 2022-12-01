class Post < ActiveRecord::Base
    belongs_to :author, class_name:'User', foreign_key: 'author_id'
    belongs_to :viewable


    def self.get_all_posts
        merge_author(self.where(viewable: self.viewable_all).order(created_at: :desc))
    end

    def self.get_all_posts_auth
        merge_author(self.where.not(viewable: self.viewable_all_auth).order(created_at: :desc))
    end

    def self.get_single_post id
        merge_author(self.where(id: id).where(viewable: self.viewable_all))
    end

    def self.get_single_post_auth id, user
            db = merge_author(self.where(id: id)).first

            return [] if db == nil
            
            if db["viewable_id"] == self.viewable_all_auth.id
                if db["author"].id == user.id
                    [db]
                else
                    []
                end
            else
                [db]
            end
    end

    def self.get_user_all_posts author
        merge_author(self.where(viewable: self.viewable_all, author: author).order(created_at: :desc))
    end

    def self.get_user_all_posts_auth author, showDrafts = false
        if showDrafts
            merge_author(self.where(author: author).order(created_at: :desc))
        else
            merge_author(self.where.not(viewable: self.viewable_all_auth).where(author: author).order(created_at: :desc))
        end
    end

    def self.new_post user:, post:, view:
        Post.create(title: post["title"], body: post["body"], author: user, viewable: view)
    end

    def self.edit_post postId:, user:, post:, view:
        Post.update(postId, title: post["title"], body: post["body"], author: user, viewable: view)
    end

    def self.delete_post id
        db = self.where(id: id)
        return [] if db.size == 0
        stored = db.first
        db.first.destroy
        [stored]
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