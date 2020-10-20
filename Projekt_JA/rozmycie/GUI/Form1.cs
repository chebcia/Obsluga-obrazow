﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;


namespace GUI
{

    public partial class Form1 : Form
    {
        System.Drawing.Image img;
        int thread;
        public Form1()
        {
            InitializeComponent();
        }


        private void numericUpDown1_ValueChanged(object sender, EventArgs e)
        {

            numericUpDown1.Maximum = 64;
            numericUpDown1.Minimum = 1;
            thread = (int)numericUpDown1.Value;

        }

        private void button2_Click(object sender, EventArgs e)
        {

            string imageLocation = "";
            try
            {
                OpenFileDialog dialog = new OpenFileDialog();
                dialog.Filter = "jpg files(.*jpg)|*.jpg| PNG files(.*png)|*.png| All Files(*.*)|*.*";

                if (dialog.ShowDialog() == System.Windows.Forms.DialogResult.OK)
                {
                    imageLocation = dialog.FileName;
                    //image1.ImageLocation = imageLocation;
                }
                //image1.Show();
                img = System.Drawing.Image.FromFile(dialog.FileName);


                //Form2 form2 = new Form2();
                //form2.Show();

            }
            catch (Exception)
            {
                MessageBox.Show("An Error occured", "Eror", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        [DllImport("rozmycie.dll", CallingConvention = CallingConvention.Cdecl)]
        private static extern void rozmycie(byte[] ptr, int height, int width, int thread);


        [DllImport("rozmycie.dll", CallingConvention = CallingConvention.Cdecl)]
        public extern static void black_white(byte[] ptr, int len, int thread);

        [DllImport("rozmycie.dll", CallingConvention = CallingConvention.Cdecl)]
        public extern static void sepia(byte[] ptr, int len, int thread);

        [DllImport("rozmycie.dll", CallingConvention = CallingConvention.Cdecl)]
        public extern static void negative(byte[] ptr, int len, int thread);

        [DllImport("rozmycie.dll", CallingConvention = CallingConvention.Cdecl)]
        private static extern void edge(byte[] ptr, int height, int width, int threads);

        private void button5_Click(object sender, EventArgs e)
        {
            var bmp = new Bitmap(img);
            // using uzywamy do unmanaged resource po wyjsciu z using skasujemy zasób wywołanie dispose z automatu 

            using (var bitmapReader = new BitmapPixelDataReader(bmp))
            {
                black_white(bitmapReader.data, bitmapReader.data.Length, thread);

            }
            bmp.Save("out.jpg", ImageFormat.Jpeg);
        }
       

        private void button6_Click(object sender, EventArgs e)
        {
            var bmp = new Bitmap(img);
            using (var bitmapReader = new BitmapPixelDataReader(bmp))
            {
                rozmycie(bitmapReader.data, bmp.Height, bmp.Width ,  thread);

            }
            bmp.Save("out.jpg", ImageFormat.Jpeg);
        }

        private void button4_Click(object sender, EventArgs e)
        {
            var bmp = new Bitmap(img);
            using (var bitmapReader = new BitmapPixelDataReader(bmp))
            {
                edge(bitmapReader.data, bmp.Height, bmp.Width, 4);

            }
            bmp.Save("out.jpg", ImageFormat.Jpeg);



        }

        private void button1_Click(object sender, EventArgs e)
        {
            var bmp = new Bitmap(img);
            // using uzywamy do unmanaged resource po wyjsciu z using skasujemy zasób wywołanie dispose z automatu 

            using (var bitmapReader = new BitmapPixelDataReader(bmp))
            {
                sepia(bitmapReader.data, bitmapReader.data.Length, thread);

            }
            bmp.Save("out.jpg", ImageFormat.Jpeg);
        }

        private void button8_Click(object sender, EventArgs e)
        {

            var bmp = new Bitmap(img);
            // using uzywamy do unmanaged resource po wyjsciu z using skasujemy zasób wywołanie dispose z automatu 

            using (var bitmapReader = new BitmapPixelDataReader(bmp))
            {
                negative(bitmapReader.data, bitmapReader.data.Length, thread);

            }
            bmp.Save("out.jpg", ImageFormat.Jpeg);



        }

  
     
    }
}
