class PersonMailer < ApplicationMailer
  def gift_message(giver_id, receiver_id)
    @giver = Person.find(giver_id)
    @receiver = Person.find(receiver_id)

    mail to: @giver.email, subject: 'Prezencik'
  end
end
