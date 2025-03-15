require 'vips'

def resize_image(input_file)
  begin
    # Generate output filename
    output_file = input_file.sub(/\.[^.]+$/, '') + '_370x320.png'
    
    # Load and resize image
    image = Vips::Image.new_from_file(input_file)
    
    # Calculate scale factor to fit within 370x320 while maintaining aspect ratio
    width_scale = 370.0 / image.width
    height_scale = 320.0 / image.height
    scale = [width_scale, height_scale].min
    
    # Resize image
    resized = image.resize(scale)
    
    # Save with lossless compression
    resized.write_to_file(output_file, compression: 9)
    
    puts "處理完成：#{input_file} -> #{output_file}"
  rescue => e
    puts "處理圖片時發生錯誤：#{e.message}"
    exit 1
  end
end

# 取得輸入檔案路徑
if ARGV.empty?
  print "請輸入圖片檔案路徑："
  input_file = gets.chomp
else
  input_file = ARGV[0]
end

# 檢查檔案是否存在
unless File.exist?(input_file)
  puts "錯誤：檔案 '#{input_file}' 不存在"
  exit 1
end

resize_image(input_file)
