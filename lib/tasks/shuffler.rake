namespace :shuffler do
  desc "Shuffles people and sends emails"
  task go: :environment do
    invalid_person = Person.all.find do |person|
      person.gifts_to_make != 0 || person.gifts_to_receive != 0
    end

    if invalid_person.present?
      raise 'Error! (0)'
    end

    emails = []
    result = {}
    candidate_ids = Person.ids.shuffle

    puts 'Shuffle...'

    Person.all.shuffle.each do |person|
      counter = 0
      loop do
        raise 'Something went wrong' if counter == 1000
        counter += 1
        candidate = Person.find(candidate_ids.sample)
        next if person.id == candidate.id
        next if person.group_id && person.group_id == candidate.group_id
        next if person.last_year_receiver == candidate
        result[person.id] = candidate.id
        candidate_ids.delete(candidate.id)
        break
      end
    end

    if result.keys.sort != result.values.sort
      raise 'Error! (1)'
    end

    if result.keys.count != result.keys.uniq.count
      raise 'Error! (2)'
    end

    if result.values.count != result.values.uniq.count
      raise 'Error! (3)'
    end

    Person.transaction do
      puts 'Setting counters...'
      result.each do |giver_id, receiver_id|
        giver = Person.find(giver_id)
        receiver = Person.find(receiver_id)

        giver.giver!
        receiver.receiver!

        giver.last_year_receiver! receiver
      end

      puts 'Sending emails...'


      result.each do |giver_id, receiver_id|
        emails.push PersonMailer.gift_message(giver_id, receiver_id)
      end

      if emails.compact.count != Person.count
        raise 'Error! (4)'
      end

      emails.each do |email|
        puts '#################################'
        puts '######### DELIVER EMAIL #########'
        puts '#################################'
        email.deliver_now
      end

      20.times do
        puts 'Done!'
      end

      puts "#{result.values.count} people shuffled, #{emails.count} emails delivered."
    end
  end

  desc 'Sends test email'
  task test: :environment do
    Person.all.each do |person|
      PersonMailer.test_message(person).deliver_now
    end
  end

  desc 'Resets user stats'
  task reset: :environment do
    print 'Reset users stats... '
    Person.update_all(gifts_to_receive: 0, gifts_to_make: 0)
    puts 'Done!'
  end
end
