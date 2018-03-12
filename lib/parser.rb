class Parser
  def self.parse(filename = './chat.txt')
    content = File.read(filename)

    puts "Finished reading file"

    regex = /(\d{1,2}\/\d{1,2}\/\d\d, \d\d:\d\d) - (.*?): (.+?(?=\d{1,2}\/\d{1,2}\/\d\d, \d\d:\d\d))/m

    puts "Scanning regex..."

    results = content.scan(regex)
    total = results.length

    puts "Finished scanning content, total messages: #{total}"

    results.each_with_index do |result, i|
      puts "Saving message #{i}/#{total}"
      time = DateTime.strptime(result[0], '%m/%d/%y, %H:%M')
      username = result[1]
      message = result[2]
      message.gsub!("\u0000", '')

      user = User.find_or_create_by(name: username)
      Message.create(user: user, text: message, timestamp: time)
    end
  end
end
