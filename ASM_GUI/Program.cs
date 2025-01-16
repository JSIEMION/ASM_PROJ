using System.Runtime.InteropServices;

namespace ASM_GUI
{
    internal static class Program
    {
        /// <summary>
        ///  The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {
            // To customize application configuration such as set high DPI settings or default font,
            // see https://aka.ms/applicationconfiguration.
            ApplicationConfiguration.Initialize();
            Application.Run(new mainForm());



        }

        [DllImport(@"C:\Users\damby\Desktop\ASM_PROJ\x64\Release\C_DLL.dll")]
        public static extern void cProc(IntPtr sourcePtr, IntPtr destPtr, int height, int width, int start, int end);

        [DllImport(@"C:\Users\damby\Desktop\ASM_PROJ\x64\Release\ASM_DLL.dll")]
        public static extern void asmProc(IntPtr sourcePtr, IntPtr destPtr, int height, int width, int start, int end);
    }
}