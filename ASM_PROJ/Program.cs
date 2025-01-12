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
using System.Collections;

namespace ASM_PROJ
{
    internal class Program
    {
        [DllImport(@"C:\Users\damby\Desktop\ASM_PROJ\x64\Debug\ASM_DLL.dll")]
        static extern int MyProc1(IntPtr sourcePtr, IntPtr destPtr, int height, int width, int start, int end);
        static void Main(string[] args)
        {
            Console.WriteLine("Enter file path: ");

            Bitmap source = new Bitmap("C:\\Users\\damby\\Desktop\\ASM_PROJ\\png.png");


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


            int w = source.Width;
            int h = source.Height;


            Bitmap dest = new Bitmap(w, h);

            Rectangle rect = new Rectangle(0, 0, w, h);
            
            System.Drawing.Imaging.BitmapData sourceData =
                source.LockBits(rect, System.Drawing.Imaging.ImageLockMode.ReadOnly, PixelFormat.Format24bppRgb);

            System.Drawing.Imaging.BitmapData destData =
                dest.LockBits(rect, System.Drawing.Imaging.ImageLockMode.WriteOnly, PixelFormat.Format24bppRgb);

            IntPtr sourcePtr = sourceData.Scan0;

            IntPtr destPtr = destData.Scan0;

            Console.WriteLine("Enter threads number: ");

            string threadsString = Console.ReadLine();

            int threadsNumber = int.Parse(threadsString);

            Thread[] threads = new Thread[threadsNumber];

            if (source.Width % 4 != 0)
            {
                w += 4 - (source.Width % 4);
            }

            Stopwatch sw = new Stopwatch();
            sw.Start();

            for (int i = 0; i < threadsNumber; i++)
            {
                int start = i * (source.Height / threadsNumber);

                int end = 0;

                if (i == threadsNumber - 1)
                {
                    end = source.Height;
                }
                else
                { 
                    end = (i + 1) * (source.Height / threadsNumber); 
                }
                try
                {
                    Console.WriteLine("Thread: " + i + " creating");
                    Console.WriteLine("start line: " + start);
                    Console.WriteLine("end line: " + end);
                    Console.WriteLine("width: " + w);
                    Console.WriteLine("height: " + h);
                    threads[i] = new Thread(() => MyProc1(sourcePtr, destPtr, h, w, start, end));
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
            source.UnlockBits(sourceData);
            dest.UnlockBits(destData);
            dest.Save("C:\\Users\\damby\\Desktop\\ASM_PROJ\\bmp.png", ImageFormat.Png);
            Console.ReadKey();
        }

    }
}
