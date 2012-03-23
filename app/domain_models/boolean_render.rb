module BooleanRender
  def method_missing(method, *args, &block)
    if method.to_s.match(/_yn$/)
      if send(method.to_s.gsub(/_yn$/,''))
        'Y'
      else
        'N'
      end
    else
      super method, *args, &block
    end
  end
end

