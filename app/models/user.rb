 class User < ApplicationRecord
  before_save :format_name, :format_email
  validates :name, length: { minimum: 1, maximum: 100 }, presence: true
  validates :password, presence: true, length: { minimum: 6 }, if: "password_digest.nil?"
  validates :password, length: { minimum: 6 }, allow_blank: true
  validates :email,
             presence: true,
             uniqueness: { case_sensitive: false },
             length: { minimum: 3, maximum: 254 }

  has_secure_password
  private
    def format_name
      if name.present?
        full_name = self.name.split(" ")
        full_name.each_with_index {|n,i| full_name[i] = n.capitalize}
        self.name = full_name.join(" ")
      end
    end

    def format_email
      self.email = email.downcase if email.present?
    end
 end