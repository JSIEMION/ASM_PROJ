using System.Diagnostics;
using System.Diagnostics.Eventing.Reader;
using System.Drawing.Imaging;
using System.Runtime.InteropServices;
using System.Threading;

namespace ASM_GUI
{
    public partial class mainForm : Form
    {
        public mainForm()
        {
            InitializeComponent();


        }

        private void openFileButton_Click(object sender, EventArgs e)
        {
            String workingDirectoryTemp = Environment.GetFolderPath(Environment.SpecialFolder.Desktop);
            openFileDialog.InitialDirectory = workingDirectoryTemp;
            openFileDialog.ShowDialog(this);
        }

        private void openFileDialog_FileOk(object sender, System.ComponentModel.CancelEventArgs e)
        {
            sourceBmp = new Bitmap(openFileDialog.FileName);
            sourcePathBox.Text = openFileDialog.FileName;
            sourcePictureBox.Image = sourceBmp;
            if (sourceBmp != null)
            {
                startButton.Enabled = true;
            }
        }

        private void startButton_Click(object sender, EventArgs e)
        {
            int w = sourceBmp.Width;
            int h = sourceBmp.Height;


            destBmp = new Bitmap(w, h);

            Rectangle rect = new Rectangle(0, 0, w, h);

            System.Drawing.Imaging.BitmapData sourceData =
                sourceBmp.LockBits(rect, System.Drawing.Imaging.ImageLockMode.ReadOnly, PixelFormat.Format24bppRgb);

            System.Drawing.Imaging.BitmapData destData =
                destBmp.LockBits(rect, System.Drawing.Imaging.ImageLockMode.WriteOnly, PixelFormat.Format24bppRgb);

            IntPtr sourcePtr = sourceData.Scan0;

            IntPtr destPtr = destData.Scan0;

            threadsNumber = (int)threadsNumberNumericUpDown.Value;

            Thread[] Threads = new Thread[threadsNumber];

            Stopwatch sw = new Stopwatch();

            sw.Start();

            if (libraryComboBox.SelectedIndex == 0)
            { //C procedure

                for (int i = 0; i < threadsNumber; i++)
                {
                    int start = i * (sourceBmp.Height / threadsNumber);

                    int end = 0;

                    if (i == threadsNumber - 1)
                    {
                        end = sourceBmp.Height;
                    }
                    else
                    {
                        end = (i + 1) * (sourceBmp.Height / threadsNumber);
                    }
                    try
                    {
                        Threads[i] = new Thread(() => Program.cProc(sourcePtr, destPtr, h, w, start, end));
                        Threads[i].Start();
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine("Thread: " + i + " failed");
                        Console.WriteLine(ex.StackTrace);
                    }
                }

                foreach (Thread thread in Threads)
                {
                    try
                    {
                        thread.Join();
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine("Thread failed");
                        Console.WriteLine(ex.StackTrace);
                    }
                }

                sw.Stop();

            }

            else if (libraryComboBox.SelectedIndex == 1)
            { //Asm procedure

                for (int i = 0; i < threadsNumber; i++)
                {
                    int start = i * (sourceBmp.Height / threadsNumber);

                    int end = 0;

                    if (i == threadsNumber - 1)
                    {
                        end = sourceBmp.Height;
                    }
                    else
                    {
                        end = (i + 1) * (sourceBmp.Height / threadsNumber);
                    }
                    try
                    {
                        Threads[i] = new Thread(() => Program.asmProc(sourcePtr, destPtr, h, w, start, end));
                        Threads[i].Start();
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine("Thread: " + i + " failed");
                        Console.WriteLine(ex.StackTrace);
                    }
                }

                foreach (Thread thread in Threads)
                {
                    try
                    {
                        thread.Join();
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine("Thread failed");
                        Console.WriteLine(ex.StackTrace);
                    }
                }

                sw.Stop();

            }

            sourceBmp.UnlockBits(sourceData);

            destBmp.UnlockBits(destData);

            destPictureBox.Image = destBmp;

            timeElapsedBox.Text = sw.ElapsedMilliseconds + " ms";
        }

        private void saveFileButton_Click(object sender, EventArgs e)
        {

            if (destBmp != null)
            {
                String workingDirectoryTemp = Environment.GetFolderPath(Environment.SpecialFolder.Desktop);
                saveFileDialog.InitialDirectory = workingDirectoryTemp;
                saveFileDialog.FileName = Path.GetFileNameWithoutExtension(sourcePathBox.Text) + "Filtered.png";
                saveFileDialog.ShowDialog(this);
            }
        }

        private void saveFileDialog_FileOk(object sender, System.ComponentModel.CancelEventArgs e)
        {
            destBmp.Save(saveFileDialog.FileName, ImageFormat.Png);
        }

        private void sourcePictureBox_DragDrop(object sender, DragEventArgs e)
        {
            var data = e.Data.GetData(DataFormats.FileDrop);

            if (data != null)
            {
                var fileName = data as string[];
                if (fileName.Length > 0)
                {
                    sourceBmp = new Bitmap(fileName[0]);
                    sourcePathBox.Text = fileName[0];
                    sourcePictureBox.Image = sourceBmp;
                }
                if (sourceBmp != null)
                {
                    startButton.Enabled = true;
                }
            }

        }

        private void sourcePictureBox_DragEnter(object sender, DragEventArgs e)
        {
            e.Effect = DragDropEffects.Copy;
        }
    }
}
