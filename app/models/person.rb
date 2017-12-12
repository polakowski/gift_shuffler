class Person < ApplicationRecord
  validates :name, :email, presence: true

  def receiver!
    increment! :gifts_to_receive
  end

  def giver!
    increment! :gifts_to_make
  end
end
