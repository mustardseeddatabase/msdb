class SessionRole

  attr_accessor :current_role_ids

  def initialize
    @current_role_ids = []
  end

  def add_roles(ids)
    @current_role_ids += ids
  end

  def create(id)
    @current_role_ids << id
  end

end
