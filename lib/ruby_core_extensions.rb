class String
  # creates a barcode image of the string at the passed-in file location
  def create_barcode_image(file_path)
    file_name = File.basename(file_path)
    cache = Rails.root.join('tmp', 'cache', 'barcode_images')
    FileUtils.mkdir(cache) unless File.exists?(cache)
    cache_file = [cache, file_name].join("/")
    unless File.exists? cache_file
      barcode = RBarcode::Code39.new(:text => self)
      barcode.to_img(cache_file,100,18,:right)
    end
    FileUtils.cp cache_file, file_path
    file_path
  end
end
