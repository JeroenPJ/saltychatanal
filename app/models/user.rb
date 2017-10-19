class User < ApplicationRecord
  has_many :messages, dependent: :delete_all

  def messages_with(input)
    self.messages.select do |m|
      if input.class == String
        m.text.downcase.include? input
      else
        m.text.downcase =~ input
      end
    end
  end

  def count_messages_with(input)
    messages_with(input).length
  end

  def average_message_length
    sum = 0
    self.messages.each { |m| sum += m.text.length }
    sum.to_f / self.messages.count
  end

  def self.messages_with(string, options = {})
    relative = options[:relative] || false
    as_word = options[:as_word] || false

    string = word_to_regex(string) if as_word

    result = self.all.map do |user|
      messages = user.messages_with(string)
      message_count = messages.length
      count = relative ? (message_count / user.messages.count.to_f) : message_count

      {
        messages: messages,
        name: user.name,
        count: count,
        total_count: message_count
      }
    end
    result.each { |r| r[:answer] = "#{r[:name]}: #{r[:count]} #{%((#{r[:total_count]})) if relative}" }

    result = result.sort_by { |r| r[:count] }.reverse

    puts "'#{string}'#{" per bericht" if relative }:"
    result.each { |r| puts r[:answer] }

    result
  end

  def self.count_messages_with(string, options = {})
    self.messages_with(string, options = {})
  end

  def self.word_to_regex(string)
    / #{string}|#{string} /
  end

  def self.print_list(method)
    array = self.all.map do |user|
      [user.name, user.send(method)]
    end

    array.sort_by { |r| r[1] }.reverse.each { |r| puts "#{r[0]}: #{r[1]}" }
  end
end
