 class User < ApplicationRecord
 # #2
   before_save { self.email = email.downcase if email.present? }
   before_save { 
    full_name = self.name.split(" ") if name.present?
    if full_name.length > 1
      full_name.each_with_index {|n,i| p full_name[i] = n.capitalize}  if full_name.present?
    end
    self.name = full_name.join(" ") if full_name.present?
    # self.name = self.name.split(" ").map do |name|
    #   name.capitalize 
    # end.join(" ")
   }

 # #3
   validates :name, length: { minimum: 1, maximum: 100 }, presence: true
 # #4
  validates :password, presence: true, length: { minimum: 6 }, if: "password_digest.nil?"
  validates :password, length: { minimum: 6 }, allow_blank: true
 # #5
   validates :email,
             presence: true,
             uniqueness: { case_sensitive: false },
             length: { minimum: 3, maximum: 254 }

 # #6
   has_secure_password
 end