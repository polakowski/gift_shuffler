class Person < ApplicationRecord
  belongs_to :last_year_receiver, class_name: Person, optional: true

  validates :name, :email, presence: true

  def receiver!
    increment! :gifts_to_receive
  end

  def giver!
    increment! :gifts_to_make
  end

  def last_year_receiver!(receiver)
    if last_year_receiver_id
      raise 'Ta osoba juz ma jednego odbiorce z zeszlego roku!'
    end

    update last_year_receiver_id: receiver.id
  end
end
