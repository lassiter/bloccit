 class User < ApplicationRecord
 # #2
   before_save { self.email = email.downcase if email.present? }
   before_save { 
    fullName = self.name.split(" ") if name.present?
    if fullName.length > 1
      fullName.each_with_index {|n,i| p fullName[i] = n.capitalize}  if fullName.present?
    end
    self.name = fullName.join(" ") if fullName.present?
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