require 'vips'
require 'fileutils'
require 'json'

def find_file_case_insensitive(dir, filename)
  # Convert filename to lowercase for comparison
  filename_lower = filename.downcase
  Dir.entries(dir).find { |f| f.downcase == filename_lower }
end

def process_images(input_dir)
  # Create outputs directory if it doesn't exist
  output_dir = File.join(input_dir, 'outputs')
  FileUtils.mkdir_p(output_dir)

  # Check for and read orders.json
  orders_file = File.join(input_dir, 'orders.json')
  unless File.exist?(orders_file)
    puts "錯誤：找不到 orders.json"
    exit 1
  end

  begin
    orders = JSON.parse(File.read(orders_file))
    unless orders["files"].is_a?(Array)
      puts "錯誤：orders.json 格式錯誤，找不到 files 陣列"
      exit 1
    end
  rescue JSON::ParserError => e
    puts "錯誤：orders.json 解析失敗 - #{e.message}"
    exit 1
  end

  # Copy main.PNG and tab.PNG without resizing
  ['main.PNG', 'tab.PNG'].each do |special_file|
    if found_file = find_file_case_insensitive(input_dir, special_file)
      source = File.join(input_dir, found_file)
      target = File.join(output_dir, special_file)  # 保持輸出為大寫 .PNG
      FileUtils.cp(source, target)
      puts "複製完成：#{found_file}"
    else
      puts "找不到檔案：#{special_file}"
    end
  end

  # Process images from orders.json
  orders["files"].each_with_index do |filename, index|
    if found_file = find_file_case_insensitive(input_dir, filename)
      input_file = File.join(input_dir, found_file)
      output_file = File.join(output_dir, format('%02d.PNG', index + 1))

      begin
        # Load and resize image
        image = Vips::Image.new_from_file(input_file)
        # Scale down by 1/4 (0.25)
        resized = image.resize(0.25)
        # Save with lossless compression
        resized.write_to_file(output_file, compression: 9)
        
        puts "處理完成：#{found_file} -> #{format('%02d.PNG', index + 1)}"
      rescue => e
        puts "處理 #{found_file} 時發生錯誤：#{e.message}"
      end
    else
      puts "找不到檔案：#{filename}"
    end
  end
  
  puts "\n所有圖片處理完成！輸出檔案已儲存在 outputs 資料夾中。"
end

# 顯示歡迎訊息
puts "=== 圖片批次縮放與整理程式 ==="
puts "本程式會將指定資料夾中的圖檔進行以下處理："
puts "1. 依照 orders.json 中的檔案列表處理圖檔並縮小為原本的 1/4 大小"
puts "2. 複製 main.PNG 和 tab.PNG 到輸出資料夾"
puts "3. 所有檔案會輸出到 outputs 資料夾\n\n"

if ARGV.empty?
  print "請輸入包含圖片的資料夾路徑：" 
  input_directory = gets.chomp
else
  input_directory = ARGV[0]
end

unless Dir.exist?(input_directory)
  puts "錯誤：資料夾 '#{input_directory}' 不存在"
  exit 1
end

puts "\n開始處理圖片..."
process_images(input_directory)
