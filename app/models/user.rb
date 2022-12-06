class User < ActiveRecord::Base
    belongs_to :role
    has_many :posts, foreign_key: 'author_id'


    # Instance methods

    # Class methods

    def self.find id
        merge_role(where("id = ?", id.to_i)).first
    end

    def self.get_profile attr
        check_name(attr[:name]).first
    end

    def self.login name=""
        # auth logic here
        check_name(name)
    end

    def self.create attr
        exists = check_name(attr[:name])
        exists.count != 0 ? "User already exists!" : super(attr)
    end

    private

    def self.check_name name
        merge_role(where("lower(name) = ?", name.downcase))
    end

    def self.merge_role userQuery
        userQuery.includes(:role).map do |user|
            user.attributes.merge(
              'role' => user.role.name,
            )
        end
    end
end