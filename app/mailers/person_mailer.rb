class PersonMailer < ApplicationMailer
  def gift_message(giver_id, receiver_id)
    @giver = Person.find(giver_id)
    @receiver = Person.find(receiver_id)

    mail to: @giver.email, subject: 'Kromka z masłem - prezenty'
  end

  def test_message(person)
    @person = person
    mail to: @person.email, subject: '-- Test --'
  end
end
