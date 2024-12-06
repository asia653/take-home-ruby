require 'debug'
module Github
  class Issue
    include Comparable
    attr_reader :title, :state, :created_at, :closed_at

    def initialize(data)
      @title = data['title']
      @state = data['state']
      @created_at = data['created_at']
      @closed_at = data['closed_at']
    end

    def <=>(other)
      if self.state == 'closed'
        self.closed_at <=> other.closed_at
      else
        self.created_at <=> other.created_at
      end
    end

    def format
      if state == 'closed'
        puts "#{title} - #{state} - Closed at: #{closed_at}"
      else
        puts "#{title} - #{state} - Created at: #{created_at}"
      end
    end
  end

end