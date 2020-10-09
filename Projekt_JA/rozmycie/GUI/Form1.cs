using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
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
        public Form1()
        {
            InitializeComponent();
        }

        [DllImport("rozmycie.dll")]          //w jakiej ddl bede wyszukiwała symbolu
        private static extern int sprawdz(int x); //
        
        private void button1_Click(object sender, EventArgs e)
        {
            openimage();
            import();
            
        }

        private Bitmap import()
        {

            Bitmap copy;
            using (var image = new Bitmap(@"img.jpg"))
            {
                copy = new Bitmap(image);
            }
            return copy;

        }
        //rozbudowana wersja wzieta z neta równiez sie nie odpala
        private void button2_Click(object sender, EventArgs e)
        {

            MessageBox.Show("An Error occured", "Eror", MessageBoxButtons.OK, MessageBoxIcon.Error);

            string imageLocation = "";
            try
            {
                OpenFileDialog dialog = new OpenFileDialog();
                dialog.Filter = "jpg files(.*jpg)|*.jpg| PNG files(.*png)|*.png| All Files(*.*)|*.*";

                if(dialog.ShowDialog() == System.Windows.Forms.DialogResult.OK)
                {
                    imageLocation = dialog.FileName;
                    image1.ImageLocation = imageLocation;
                }

            }
            catch(Exception)
            {
                MessageBox.Show("An Error occured", "Eror", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }
        //wziete z neta nie działa, tzn nie odpala sie ten przycisk
        private void button5_Click(object sender, EventArgs e)
        {
          opbl.Filter = "jpg|*.jpg";

            DialogResult res = opbl.ShowDialog();
            if (res == DialogResult.OK)
            {
                pbpic.Image = Image.FromFile(opbl.FileName);

            }
        }





        private Bitmap openimage()
        {

            Bitmap copy;
            using (var image = new Bitmap(@"img.jpg"))
            {
                copy = new Bitmap(image);
            }
            return copy;

        }
        public byte[] ImageToByteArray(System.Drawing.Image image)
        {
            using (var ms = new MemoryStream())
            {
                image.Save(ms, image.RawFormat);
                return ms.ToArray();
            }
        }

        


    }

}
