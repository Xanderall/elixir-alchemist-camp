defmodule BMP do

# using BMP version 2 - https://www.fileformat.info/format/bmp/egff.htm

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
    file_size = <<0::little-size(32)>> # 4 bytes, 0 for uncompressed files
    reserved = <<0::size(32)>> # <<0, 0, 0, 0>> # always 0
    bitmap_offset = <<offset::little-size(32)>>
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

  def win2x_header() do
    
        
  end
end