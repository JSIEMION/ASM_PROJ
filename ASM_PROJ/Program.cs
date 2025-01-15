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
        [DllImport(@"C:\Users\damby\Desktop\ASM_PROJ\x64\Debug\C_DLL.dll")]
        static extern void cProc(IntPtr sourcePtr, IntPtr destPtr, int height, int width, int start, int end);

        [DllImport(@"C:\Users\damby\Desktop\ASM_PROJ\x64\Debug\ASM_DLL.dll")]
        static extern void asmProc(IntPtr sourcePtr, IntPtr destPtr, int height, int width, int start, int end);
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


            Bitmap destC = new Bitmap(w, h);

            Bitmap destAsm = new Bitmap(w, h);

            Rectangle rect = new Rectangle(0, 0, w, h);
            
            System.Drawing.Imaging.BitmapData sourceData =
                source.LockBits(rect, System.Drawing.Imaging.ImageLockMode.ReadOnly, PixelFormat.Format24bppRgb);

            System.Drawing.Imaging.BitmapData destCData =
                destC.LockBits(rect, System.Drawing.Imaging.ImageLockMode.WriteOnly, PixelFormat.Format24bppRgb);

            System.Drawing.Imaging.BitmapData destAsmData =
                destAsm.LockBits(rect, System.Drawing.Imaging.ImageLockMode.WriteOnly, PixelFormat.Format24bppRgb);

            IntPtr sourcePtr = sourceData.Scan0;

            IntPtr destCPtr = destCData.Scan0;

            IntPtr destAsmPtr = destAsmData.Scan0;

            Console.WriteLine("Enter threads number: ");

            string threadsString = Console.ReadLine();

            int threadsNumber = int.Parse(threadsString);

            Thread[] cThreads = new Thread[threadsNumber];

            Stopwatch swC = new Stopwatch();
            swC.Start();

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
                    cThreads[i] = new Thread(() => cProc(sourcePtr, destCPtr, h, w, start, end));
                    Console.WriteLine("Thread: " + i + " created");
                    Console.WriteLine("Thread: " + i + " starting");
                    cThreads[i].Start();
                    Console.WriteLine("Thread: " + i + " started");
                }
                catch(Exception e)
                {
                    Console.WriteLine("Thread: " + i + " failed");
                    Console.WriteLine(e.StackTrace);
                }
            }

            foreach( Thread thread in cThreads)
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

            swC.Stop();

            Console.WriteLine(swC.ElapsedMilliseconds + " ms has elapsed for C");

            destC.UnlockBits(destCData);

            destC.Save("C:\\Users\\damby\\Desktop\\ASM_PROJ\\bmpC.png", ImageFormat.Png);

            source.UnlockBits(sourceData);



            source.LockBits(rect, System.Drawing.Imaging.ImageLockMode.ReadOnly, PixelFormat.Format24bppRgb);

            sourcePtr = sourceData.Scan0;

            Thread[] AsmThreads = new Thread[threadsNumber];

            Stopwatch swAsm = new Stopwatch();
            swAsm.Start();

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
                    AsmThreads[i] = new Thread(() => asmProc(sourcePtr, destAsmPtr, h, w, start, end));
                    Console.WriteLine("Thread: " + i + " created");
                    Console.WriteLine("Thread: " + i + " starting");
                    AsmThreads[i].Start();
                    Console.WriteLine("Thread: " + i + " started");
                }
                catch (Exception e)
                {
                    Console.WriteLine("Thread: " + i + " failed");
                    Console.WriteLine(e.StackTrace);
                }
            }

            foreach (Thread thread in AsmThreads)
            {
                try
                {
                    Console.WriteLine("Thread joining");
                    thread.Join();
                    Console.WriteLine("Thread joined");
                }
                catch (Exception e)
                {
                    Console.WriteLine("Thread failed");
                    Console.WriteLine(e.StackTrace);
                }
            }

            swAsm.Stop();

            Console.WriteLine(swAsm.ElapsedMilliseconds + " ms has elapsed for Asm");

            source.UnlockBits(sourceData);
            
            destAsm.UnlockBits(destAsmData);
            
            destAsm.Save("C:\\Users\\damby\\Desktop\\ASM_PROJ\\bmpAsm.png", ImageFormat.Png);

            Console.ReadKey();
        }

    }
}
