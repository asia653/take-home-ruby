require 'rspec'
require_relative "../processor.rb"
require 'debug'
# RSpec tests
RSpec.describe Github::Processor do
  describe "#issues" do
  
    before do
      @client = double()
    end
    it "raises an exception if state is invalid" do
      expect { Github::Processor.new(@client).issues("random") }.to raise_error(ArgumentError)
    end

    it "traverses multiple pages, compiling a list of listings" do
      allow(@client).to receive(:get).with("/issues?state=closed&per_page=100&page=1")
        .and_return(
          double("response 1", body: JSON.generate(["listing 1", "listing 2"]))
        ) 
      allow(@client).to receive(:get).with("/issues?state=closed&per_page=100&page=2")
        .and_return(
          double("response 2", body: JSON.generate(["listing 3"]))
        )
      allow(@client).to receive(:get).with("/issues?state=closed&per_page=100&page=3")
        .and_return(
          double("response 3", body: JSON.generate(["listing 4", "listing 5"]))
        )
      allow(@client).to receive(:get).with("/issues?state=closed&per_page=100&page=4")
        .and_return(
          double("response 3", body: JSON.generate([]))
        )
      expect(Github::Processor.new(@client).issues(state: "closed")).to eq(["listing 1", "listing 2", "listing 3", "listing 4", "listing 5"])
    end
  end


end

# Run tests if the script is executed directly
if __FILE__ == $0
  RSpec::Core::Runner.run([$__FILE__])
end