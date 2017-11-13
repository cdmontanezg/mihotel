class User < ActiveRecord::Base
  # Include default devise modules.
  # :confirmable, :omniauthable, :registerable,
  devise :database_authenticatable,
          :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User
end
