class User < ActiveRecord::Base
    belongs_to :role
    has_many :posts, foreign_key: 'owner_id'


    # Instance methods

    # Class methods

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
        where("lower(name) = ?", name.downcase)
    end
end