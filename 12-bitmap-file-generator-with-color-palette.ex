defmodule BMP do

# using BMP version 2 - https://www.fileformat.info/format/bmp/egff.htm
# assumption: 24 bit bitmap without color palette

# try generate_file()

  def generate_file(width \\ 30, height \\ 47, name \\ "12-generated-pic.bmp") do
    save(name, file_header() <> win2x_header(width, height), generate_example_data(width, height))
  end

# BMP file Header
# typedef struct _WinBMPFileHeader
# {
# 	WORD   FileType;     /* File type, always 4D42h ("BM") */
# 	DWORD  FileSize;     /* Size of the file in bytes */
# 	WORD   Reserved1;    /* Always 0 */
# 	WORD   Reserved2;    /* Always 0 */
# 	DWORD  BitmapOffset; /* Starting position of image data in bytes */
# } WINBMPFILEHEADER;
  
  def file_header(offset \\ 26) do
    # Bitmap data starts at byte 26 when if no color palette needed
    # word is 2 bytes, dword 4
    file_type = "BM"
    file_size = <<0::little-32>> # 4 bytes, 0 for uncompressed files
    reserved = <<0::32>> # <<0, 0, 0, 0>> # always 0
    bitmap_offset = <<offset::little-32>>
    file_type <> file_size <> reserved <> bitmap_offset
  end

# BMP bitmap header
# typedef struct _Win2xBitmapHeader
# {
# 	DWORD Size;            /* Size of this header in bytes */
# 	SHORT Width;           /* Image width in pixels */
# 	SHORT Height;          /* Image height in pixels */
# 	WORD  Planes;          /* Number of color planes */
# 	WORD  BitsPerPixel;    /* Number of bits per pixel */
# } WIN2XBITMAPHEADER;

  def win2x_header(width, height, bits_per_pixel \\ 24) do
    size = <<12::little-32>>
    w = <<width::little-16>>
    h = <<height::little-16>>
    planes = <<1, 0>>
    bpp = <<bits_per_pixel::little-16>>
    size <> w <> h <> planes <> bpp
  end

  def generate_example_data(width, height) do
    for row <- 1..height, into: <<>> do
        bytes_past = rem(3 * width, 4)
        padding = (4 - bytes_past) * 8
        for item <- 1..width, into: <<>> do
          pixel(100 + 5 * item, 2 * row, 5 * item + row)
        end <> <<0::size(padding)>>
    end
  end

  def pixel(blue, green, red) do
    <<blue::little-8, green::little-8, red::little-8>>
  end

  def save(filename, header, pixels) do
    File.write!(filename, header <> pixels)
  end

  def win2x_palette do
    
  end
end