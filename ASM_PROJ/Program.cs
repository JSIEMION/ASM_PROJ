using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Drawing;
using System.Drawing.Imaging;
using System.Diagnostics;

namespace ASM_PROJ
{
    internal class Program
    {
        [DllImport(@"C:\Users\damby\Desktop\ASM_PROJ\x64\Debug\C_DLL.dll")]
        static extern void MyProc1(IntPtr ptr, int height, int width, int start, int end);
        static void Main(string[] args)
        {
            Console.WriteLine("Enter file path: ");

            string file = Console.ReadLine();

            Bitmap bmp = new Bitmap("C:\\Users\\damby\\Desktop\\ASM_PROJ\\png.png");

            //int newWidth = bmpNoBorder.Width + (2);
            //int newHeight = bmpNoBorder.Height + (2);

            //Bitmap bmp = new Bitmap(newWidth, newHeight);
            //using (Graphics gfx = Graphics.FromImage(bmp))
            //{
            //    using (Brush border = new SolidBrush(Color.White))
            //    {
            //        gfx.FillRectangle(border, 0, 0,
            //            newWidth, newHeight);
            //    }
            //    gfx.DrawImage(bmpNoBorder, new Rectangle(1, 1, bmpNoBorder.Width, bmpNoBorder.Height));

            //}


            int w = bmp.Width;
            int h = bmp.Height;

            Rectangle rect = new Rectangle(0, 0, w, h);
            
            System.Drawing.Imaging.BitmapData bmpData =
                bmp.LockBits(rect, System.Drawing.Imaging.ImageLockMode.ReadWrite, PixelFormat.Format24bppRgb);

            IntPtr ptr = bmpData.Scan0;

            Console.WriteLine("Enter threads number: ");

            string threadsString = Console.ReadLine();

            int threadsNumber = int.Parse(threadsString);

            Thread[] threads = new Thread[threadsNumber];

            Stopwatch sw = new Stopwatch();
            sw.Start();

            for (int i = 0; i < threadsNumber; i++)
            {
                int start = i * (bmp.Height / threadsNumber);

                int end = 0;

                if (i == threadsNumber - 1)
                {
                    end = bmp.Height;
                }
                else
                { 
                    end = (i + 1) * (bmp.Height / threadsNumber); 
                }
                try
                {
                    Console.WriteLine("Thread: " + i + " creating");
                    threads[i] = new Thread(() => MyProc1(ptr, h, w, start, end));
                    Console.WriteLine("Thread: " + i + " created");
                    Console.WriteLine("Thread: " + i + " starting");
                    threads[i].Start();
                    Console.WriteLine("Thread: " + i + " started");
                }
                catch(Exception e)
                {
                    Console.WriteLine("Thread: " + i + " failed");
                    Console.WriteLine(e.StackTrace);
                }
            }

            foreach( Thread thread in threads)
            {
                try
                {
                    Console.WriteLine("Thread joining");
                    thread.Join();
                    Console.WriteLine("Thread joined");
                }
                catch(Exception e) {
                    Console.WriteLine("Thread failed");
                    Console.WriteLine(e.StackTrace);
                }
            }

            sw.Stop();

            Console.WriteLine(sw.ElapsedMilliseconds + " ms has elapsed");

            bmp.UnlockBits(bmpData);
            bmp.Save("bmp.png", ImageFormat.Png);

            //int width= bmp.Width/threadsNumber;

            //List<Bitmap> bmpToProcess = new List<Bitmap>();

            //System.Drawing.Imaging.PixelFormat format = bmp.PixelFormat;

            //for (int i = 0; i < threadsNumber; i++)
            //{
            //    Rectangle cloneRect = new Rectangle(0+ width * i, 0, width, bmp.Height);
            //    bmpToProcess.Add(bmp.Clone(cloneRect,format));
            //}

            //Console.WriteLine(bmpToProcess.Count);

            //var parallelWorkItems = bmpToProcess.AsParallel().WithDegreeOfParallelism(threadsNumber);

            //parallelWorkItems.ForAll(Processing);

            //newImage.Save("bmp.png", ImageFormat.Png);

        }

    }
}
