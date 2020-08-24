defmodule BMP do

# using BMP version 2 - https://www.fileformat.info/format/bmp/egff.htm
# assumption: 24 bit bitmap without color palette

# try generate_file()

  # 1. Generate example picture without color palette (using standard 24 bit one)
  def generate_file(width \\ 30, height \\ 47, name \\ "12-generated-pic.bmp") do
    save(name, file_header() <> win2x_header(width, height), generate_example_data(width, height))
  end

  # 2. Generate example picture with monochrome color palette (1 bit per pixel)
  def generate_monochrome(width \\ 500, height \\ 500, name \\ "12-generated-monochrome-pic.bmp") do
    header = file_header(26 + 3 * 2) # two colors with 3 bytes each
             <> win2x_header(width, height, 1) # 1 bit per pixel
    palette = win2x_palette([[255,0,128],[127,255,127]])
    data = for row <- 1..height, into: <<>> do
        cols = for col <- 1..width, into: <<>> do
          <<(if row*row + col*col > 100_000, do: 1, else: 0)::1>>
        end
        <<cols::bitstring, padding_for(width, 1)::bitstring>> # 1 bit / pixel
    end
    save(name, header <> palette, data)
  end

  # 3. Generate example picture with 4-bit color palette (4 bits per pixel > makes 16 colors)
  def generate_4bit(width \\ 400, height \\ 100, name \\ "12-generated-4bit-pic.bmp") do
    header = file_header(26 + 3 * 16) <> win2x_header(width, height, 4) # 4 bits per pixel
    # colors = [[255,0,128],[127,255,127],[12,25,127],[12,255,127],[127,25,127],[127,255,17],[127,25,127]]...
    # use 16 random colors instead of fixed palette
    randomColors = for _ <- 1..16, into: [], do: rPix()
    palette = win2x_palette(randomColors)
    data = for _row <- 1..height, into: <<>> do
        cols = for col <- 1..width, into: <<>> do
          <<rem(div(col-1, 25), 16)::4>>
        end
        <<cols::bitstring, padding_for(width, 4)::bitstring>> # 4 bits / pixel
    end
    save(name, header <> palette, data)
  end

  def rNbr, do: Enum.random(0..255)
  def rPix, do: [rNbr(), rNbr(), rNbr()]

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
        for item <- 1..width, into: <<>> do
          pixel(100 + 5 * item, 2 * row, 5 * item + row)
        end <> padding_for(width, 24) #24 bits / pixel
    end
  end

  def pixel(blue, green, red) do
    <<blue::little-8, green::little-8, red::little-8>>
  end

  def padding_for(width, bpp \\ 24) do
    bits_past = rem(width * bpp, 32)
    num = if bits_past>0, do: (32 - bits_past), else: 0
    <<0::size(num)>>
  end

  def save(filename, header, pixels) do
    File.write!(filename, header <> pixels)
  end

  def win2x_palette(colors) do
    Enum.into(colors, <<>>, &(apply(BMP, :pixel, &1)))
  end
end