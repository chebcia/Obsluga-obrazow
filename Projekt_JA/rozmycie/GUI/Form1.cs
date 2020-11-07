using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading;
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
                img = System.Drawing.Image.FromFile(dialog.FileName);

            }
            catch (Exception)
            {
                MessageBox.Show("An Error occured", "Eror", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        [DllImport("rozmycie.dll", CallingConvention = CallingConvention.Cdecl)]
        private static extern void rozmycie(byte[] ptr, int height, int width, int thread);


        [DllImport("rozmycie.dll", CallingConvention = CallingConvention.Cdecl)]
        public extern static void b_w(byte[] ptr, int start, int stop);
       
        [DllImport("rozmycie.dll", CallingConvention = CallingConvention.Cdecl)]
        public extern static void sep(byte[] ptr, int start, int stop);

        [DllImport("rozmycie.dll", CallingConvention = CallingConvention.Cdecl)]
        public extern static void neg(byte[] ptr, int start, int stop);


        private void button5_Click(object sender, EventArgs e)
        {    
            var bmp = new Bitmap(img);
            // using uzywamy do unmanaged resource po wyjsciu z using skasujemy zasób wywołanie dispose z automatu 

            using (var bitmapReader = new BitmapPixelDataReader(bmp))
            {
                int work_to_do = bitmapReader.data.Length / thread;
                Thread[] threads = new Thread[thread];
                Stopwatch watch = new Stopwatch();
                watch.Start();
                for (int i = 0; i < thread; i++)
                {  
                    var start = i * work_to_do;
                    var stop = (i + 1) * work_to_do;
                    threads[i] = new Thread(() => b_w(bitmapReader.data, start, stop));
                    threads[i].Start();
                }
                
                for (int i = 0; i < thread;  i++)
                {
                    threads[i].Join();
                }
                watch.Stop();
                textBox1.Text = watch.Elapsed.TotalMilliseconds.ToString();
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


        private void button1_Click(object sender, EventArgs e)
        {
            var bmp = new Bitmap(img);
            // using uzywamy do unmanaged resource po wyjsciu z using skasujemy zasób wywołanie dispose z automatu 

            using (var bitmapReader = new BitmapPixelDataReader(bmp))
            {
                int work_to_do = bitmapReader.data.Length / thread;
                Thread[] threads = new Thread[thread];
                Stopwatch watch = new Stopwatch();
                watch.Start();
                for (int i = 0; i < thread; i++)
                {
                    var start = i * work_to_do;
                    var stop = (i + 1) * work_to_do;
                    threads[i] = new Thread(() => sep(bitmapReader.data, start, stop));
                    threads[i].Start();
                }

                for (int i = 0; i < thread; i++)
                {
                    threads[i].Join();
                }
                watch.Stop();
                textBox1.Text = watch.Elapsed.TotalMilliseconds.ToString();
            }
            bmp.Save("out.jpg", ImageFormat.Jpeg);
        }

        private void button8_Click(object sender, EventArgs e)
        {
            var bmp = new Bitmap(img);
            // using uzywamy do unmanaged resource po wyjsciu z using skasujemy zasób wywołanie dispose z automatu 

            using (var bitmapReader = new BitmapPixelDataReader(bmp))
            {
                int work_to_do = bitmapReader.data.Length / thread;
                Thread[] threads = new Thread[thread];
                Stopwatch watch = new Stopwatch();
                watch.Start();
                for (int i = 0; i < thread; i++)
                {
                    var start = i * work_to_do;
                    var stop = (i + 1) * work_to_do;
                    threads[i] = new Thread(() => neg(bitmapReader.data, start, stop));
                    threads[i].Start();
                }

                for (int i = 0; i < thread; i++)
                {
                    threads[i].Join();
                }
                watch.Stop();
                textBox1.Text = watch.Elapsed.TotalMilliseconds.ToString();
            }
            bmp.Save("out.jpg", ImageFormat.Jpeg);


        }

        private void button4_Click(object sender, EventArgs e)
        {
            var bmp = new Bitmap(img);
            using (var bitmapReader = new BitmapPixelDataReader(bmp))
            {
                int work_to_do = bitmapReader.data.Length / thread;
                Thread[] threads = new Thread[thread];
                Stopwatch watch = new Stopwatch();
                watch.Start();
                for (int i = 0; i < thread; i++)
                {
                    var start = i * work_to_do;
                    var stop = (i + 1) * work_to_do;
                    threads[i] = new Thread(() => ASM.MyProc1(bitmapReader.data, work_to_do, start));
                    threads[i].Start();
                }

                for (int i = 0; i < thread; i++)
                {
                    threads[i].Join();
                }
                watch.Stop();
                textBox1.Text = watch.Elapsed.TotalMilliseconds.ToString();
                // ASM.MyProc1(bitmapReader.data, bitmapReader.data.Length);


            }
            bmp.Save("out.jpg", ImageFormat.Jpeg);


        }

        private void button7_Click(object sender, EventArgs e)
        {
            var bmp = new Bitmap(img);
            using (var bitmapReader = new BitmapPixelDataReader(bmp))
            {

                int work_to_do = bitmapReader.data.Length / thread;
                Thread[] threads = new Thread[thread];
                Stopwatch watch = new Stopwatch();
                watch.Start();

                for (int i = 0; i < thread; i++)
                {
                    var start = i * work_to_do;
                    var stop = (i + 1) * work_to_do;
                    threads[i] = new Thread(() => ASM.MyProc2(bitmapReader.data, work_to_do, start));
                    threads[i].Start();
                }

                for (int i = 0; i < thread; i++)
                {
                    threads[i].Join();
                }
                watch.Stop();
                textBox1.Text = watch.Elapsed.TotalMilliseconds.ToString();


                // ASM.MyProc2(bitmapReader.data, bitmapReader.data.Length);


            }
            bmp.Save("out.jpg", ImageFormat.Jpeg);



        }

        private void button8_Click_1(object sender, EventArgs e)
        {
            var bmp = new Bitmap(img);
            using (var bitmapReader = new BitmapPixelDataReader(bmp))
            {
                int work_to_do = bitmapReader.data.Length / thread;
                Thread[] threads = new Thread[thread];
                Stopwatch watch = new Stopwatch();
                watch.Start();
                for (int i = 0; i < thread; i++)
                {
                    var start = i * work_to_do;
                    var stop = (i + 1) * work_to_do;
                    threads[i] = new Thread(() => ASM.MyProc3(bitmapReader.data, work_to_do, start));
                    threads[i].Start();
                }

                for (int i = 0; i < thread; i++)
                {
                    threads[i].Join();
                }
                watch.Stop();
                textBox1.Text = watch.Elapsed.TotalMilliseconds.ToString();

                //  ASM.MyProc3(bitmapReader.data, bitmapReader.data.Length, 0);
            }
            bmp.Save("out.jpg", ImageFormat.Jpeg);


        }

      
    }

    class ASM
    {


        [DllImport("JAAsm.dll")]
        public extern static void MyProc1(byte[] data, int length, int start);
        [DllImport("JAAsm.dll")]
        public extern static void MyProc2(byte[] data, int length, int start);
        [DllImport("JAAsm.dll")]
        public static extern bool checkMMXCapability();
        [DllImport("JAAsm.dll")]
        public extern static void MyProc3(byte[] data, int length, int start);

    }
}

