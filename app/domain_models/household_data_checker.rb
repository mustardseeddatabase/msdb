module HouseholdDataChecker
  # not speed optimized, but intended only for admin, db checking
  def self.with_no_head
    includes(:perm_address, :temp_address, :clients).
      all.
      select(&:has_no_head?).
      sort_by{|h| [(h.perm_address || Address.new), (h.temp_address || Address.new)]}
  end

  # not speed optimized, but intended only for admin, db checking
  def self.with_multiple_heads
    includes(:perm_address, :temp_address, :clients).
      all.
      select(&:has_multiple_heads?).
      sort_by{|h| [(h.perm_address || Address.new), (h.temp_address || Address.new)]}
  end

  def self.with_no_addresses
    where('perm_address_id IS NULL && temp_address_id IS NULL')
  end

  def has_head?
    head_count > 0
  end

  def has_no_head?
    head_count == 0
  end

  def has_single_head?
    head_count == 1
  end

  # it's an error condition!
  def has_multiple_heads?
    head_count > 1
  end

private
  # to determine the error condition of multiple heads of household
  def head_count
    clients.map(&:headOfHousehold?).count(true)
  end
end
