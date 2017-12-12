namespace :shuffler do
  desc "Shuffles people and sends emails"
  task go: :environment do
    result = {}
    candidate_ids = Person.ids.shuffle

    print 'Shuffle start'

    Person.all.shuffle.each do |person|
      print ?.
      counter = 0
      loop do
        raise 'Something went wrong' if counter == 100
        counter += 1
        candidate = Person.find(candidate_ids.sample)
        next if person.id == candidate.id
        next if person.group_id && person.group_id == candidate.group_id
        result[person.id] = candidate.id
        candidate_ids.delete(candidate.id)
        break
      end
    end

    puts ''

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
        Person.find(giver_id).giver!
        Person.find(receiver_id).receiver!
      end

      puts 'Sending emails...'

      result.each do |giver_id, receiver_id|
        PersonMailer.gift_message(giver_id, receiver_id).deliver_now
      end
    end

    puts 'Done!'
  end
end
