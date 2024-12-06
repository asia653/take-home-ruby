require_relative './client.rb'
require_relative './issue.rb'
require 'json'
module Github
    class Processor
        # This class is responsible for processing the response from the Github API.
        # It accepts a client object and stores it as an instance variable.
        # It has a method called `issues` that returns a list of issues from the Github API.
        def initialize(client)
            @client = client
        end

        def print_issues(state: "closed")
            self.issues(state: state)
                .filter {|issue| issue["pull_request"].nil? }
                .map {|data| Github::Issue.new(data)}
                .sort
                .reverse
                .each(&:format)
        end

        def issues(state: "closed")
            # This method returns a list of issues from the Github API.
            # It accepts an optional argument called `open` that defaults to true.
            # If `open` is true, it returns only open issues.
            # If `open` is false, it returns only closed issues.
            # It makes a GET request to the Github API using the client object.
            # It returns the response from the Github API.
            raise ArgumentError.new("Unknown state value - #{state}") if !["closed", "open"].include?(state) 
            page = 1
            all_issues = []

             # Return a list of issues from the response, with each line showing the issue's title, whether it is open or closed,
            # and the date the issue was closed if it is closed, or the date the issue was created if it is open.
            # the issues are sorted by the date they were closed or created, from newest to oldest.
            
            loop do
                response = @client.get("/issues?state=#{state}&per_page=100&page=#{page}")
                issues = JSON.parse(response.body)
                break if issues.empty?
            
                all_issues.concat(issues)

                
                page += 1
            end
            all_issues
        end
    end
end
# The URL to make API requests for the IBM organization and the jobs repository
# would be 'https://api.github.com/repos/ibm/jobs'.
# Github::Processor.new(Github::Client.new(ENV['TOKEN'], ARGV[0])).print_issues(state: "open")
