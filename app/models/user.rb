class User < ActiveRecord::Base
    belongs_to :role
    has_many :posts, foreign_key: 'author_id'


    # Instance methods
    def get_role
        self.role.name
    end

    def get_public_posts
        Post.merge_author(self.posts.where(viewable: Viewable.find_by(name: "public")))
    end

    def get_all_posts isAuthor: false
        if isAuthor
            Post.merge_author(self.posts)
        else
            Post.merge_author(self.posts.where.not(viewable: Viewable.find_by(name: "draft")))
        end
    end

    # Class methods

    def self.login name
        where("lower(name) = ?", name.downcase)
    end

    def self.get_profile attr
        where("lower(name) = ?", attr[:name].downcase).first
    end


    # def self.find_id_incl_role id
    #     merge_role(where("id = ?", id.to_i)).first
    # end

    # def self.get_profile_incl_role name
    #     merge_role(where("lower(name) = ?", name.downcase)).first
    # end

    # def self.get_profile attr
    #     check_name(attr[:name]).first
    # end

    # def self.login name=""
    #     # auth logic here
    #     get_profile_incl_role(name)
    # end

    # def self.create attr
    #     exists = check_name(attr[:name])
    #     exists.count != 0 ? "User already exists!" : super(attr)
    # end

    # private

    # def self.check_name name
    #     where("lower(name) = ?", name.downcase)
    # end

    # def self.merge_role userQuery
    #     userQuery.includes(:role).map do |user|
    #         user.attributes.merge(
    #           'role' => user.role.name,
    #         )
    #     end
    # end
end