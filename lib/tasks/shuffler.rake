namespace :shuffler do
  desc "Shuffles people and sends emails"
  task go: :environment do
    result = {}
    candidate_ids = Person.ids.shuffle

    puts 'Shuffle...'

    Person.all.shuffle.each do |person|
      counter = 0
      loop do
        raise 'Something went wrong' if counter == 100
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
      raise 'Invalid shuffle result! (1)'
    end

    if result.keys.count != result.keys.uniq.count
      raise 'Invalid shuffle result! (2)'
    end

    if result.values.count != result.values.uniq.count
      raise 'Invalid shuffle result! (3)'
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
        PersonMailer.gift_message(giver_id, receiver_id).deliver_now
      end
    end

    puts 'Done!'
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
