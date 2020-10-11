using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.Runtime.InteropServices;


namespace GUI
{
    // IDisposable ta klasa posiada w sobie dane ktore musza zostac usuniete recznie
    class BitmapPixelDataReader : IDisposable
    {
        private readonly Bitmap bmp;
        private readonly BitmapData bitmapData; //do usuniecia recznie 
        public byte[] data;
        public BitmapPixelDataReader(Bitmap image)
        {
            // Create a new bitmap.
            //bmp = new Bitmap(image);
            bmp = image;
            // Lock the bitmap's bits.
            var rect = new Rectangle(0, 0, bmp.Width, bmp.Height);
            bitmapData =
                bmp.LockBits(rect, ImageLockMode.ReadWrite,
                bmp.PixelFormat);

            // Get the address of the first line.
            IntPtr ptr = bitmapData.Scan0;

            // Declare an array to hold the bytes of the bitmap.
            int bytes = Math.Abs(bitmapData.Stride) * bmp.Height;
            data = new byte[bytes];

            // Copy the RGB values into the array.
            Marshal.Copy(ptr, data, 0, bytes);
        }

        public void Dispose() // odblokowanie pikseli 
        {
            // Copy the RGB values back to the bitmap
            Marshal.Copy(data, 0, bitmapData.Scan0, data.Length);

            // Unlock the bits.
            bmp.UnlockBits(bitmapData);
           
        }




    }

}
