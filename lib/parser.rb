class Parser
  def parse(filename = './chat.txt')
    File.open(filename, 'r').each_line do |line|
      line_info = /(.*) - (.*): (.*)/.match(line)
      if line_info
        time = DateTime.strptime(line_info[0], '%m/%d/%y, %H:%M')
        username = line_info[2]
        message = line_info[3]
        message.gsub!("\u0000", '')

        user = User.find_or_create_by(name: username)
        Message.create(user: user, text: message, timestamp: time)
      end
    end
  end
end
