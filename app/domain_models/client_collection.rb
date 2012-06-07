class ClientCollection
  attr_accessor :clients

  def initialize(clients)
    @clients = clients
  end

  def aggregated_race_demographics
    blank_counts = {:AA => 0, :AS => 0, :WH => 0, :HI => 0, :UNK => 0, :total => clients.count}
    clients.group_by(&:race_or_unknown).inject(blank_counts) do |hash, (r,cc)|
      hash[r.to_sym] = cc.count
      hash
    end
  end

end
