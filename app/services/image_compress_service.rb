class ImageCompressService
  MAX_QUALITY = 100
  MAX_FILE_SIZE = 10.megabytes
  QUALITY_STEP = 5

  def call(file)
    return file if file.size <= MAX_FILE_SIZE
    
    convert_file(file)
    compress_file_sequence
  end

  private

  attr_accessor :file

  def convert_file(file)
    @file = ImageProcessing::Vips.convert('jpg').call(file)
  end

  def compress_file(quality)
    @file = ImageProcessing::Vips.saver(quality: quality).call(file)
  end

  def compress_file_sequence
    (0..MAX_QUALITY).step(QUALITY_STEP).reverse_each do |new_quality|
      compress_file(new_quality) if new_quality != MAX_QUALITY
      return @file if @file.size < MAX_FILE_SIZE
    end
  end
end
