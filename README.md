# 貼圖大小調整工具

一個用於調整貼圖大小的 Ruby 工具，可以單張處理或批次處理。

## 功能特點

- 維持圖片比例
- PNG 無損壓縮
- 自動調整大小至 370x320 像素範圍內（單張處理模式）
- 批次處理模式可自動縮放為原圖 1/4 大小

## 系統需求

- Ruby
- [libvips](https://www.libvips.org/) (圖片處理函式庫)

## 安裝設定

1. 安裝 libvips：
   ```bash
   # macOS
   brew install vips

   # Ubuntu/Debian
   sudo apt-get install libvips
   ```

2. 安裝 Ruby 相依套件：
   ```bash
   bundle install
   ```

## 使用方式

### 單張圖片處理

使用 `resize_image.rb` 來處理單一圖片：

```bash
ruby resize_image.rb 輸入圖片檔案.png
```

- 圖片會被調整至符合 370x320 像素範圍
- 輸出檔案會加上 "_370x320.png" 後綴
- 使用無損壓縮

### 批次處理模式

使用 `sort_and_resize_images.rb` 來批次處理多張圖片：

1. 準備一個資料夾，包含：
   - 要處理的圖片檔案
   - `orders.json`：定義要處理的檔案列表
   - `main.PNG` 和 `tab.PNG`（選擇性）

2. `orders.json` 格式範例：
   ```json
   {
     "files": [
       "圖片1.png",
       "圖片2.png",
       "圖片3.png"
     ]
   }
   ```

3. 執行批次處理：
   ```bash
   ruby sort_and_resize_images.rb 圖片資料夾路徑
   ```

批次處理會：
- 將 `orders.json` 中列出的圖片縮小為原本的 1/4 大小
- 直接複製 `main.PNG` 和 `tab.PNG`（如果存在）
- 所有輸出檔案會存放在 `outputs` 資料夾中
- 檔案會依序重新命名為 `01.PNG`、`02.PNG` 等
