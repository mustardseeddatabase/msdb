class String
  def create_barcode_image(file_path)
    barcode = RBarcode::Code39.new(:text => self)
    barcode.to_img(Rails.root.join(file_path).to_s,100,18,:right)
    file_path
  end
end
