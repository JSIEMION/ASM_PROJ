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

            //String workingDirectory = Directory.GetCurrentDirectory();
            //workingDirectory = Directory.GetParent(workingDirectory).FullName;
            //workingDirectory = Directory.GetParent(workingDirectory).FullName;
            //workingDirectory = Directory.GetParent(workingDirectory).FullName;
            //workingDirectory = Directory.GetParent(workingDirectory).FullName;
            //workingDirectory = Directory.GetParent(workingDirectory).FullName;
            //workingDirectory += "\\x64\\Release";

            //SetDllDirectory(workingDirectory);
            // To customize application configuration such as set high DPI settings or default font,
            // see https://aka.ms/applicationconfiguration.
            ApplicationConfiguration.Initialize();
            Application.Run(new mainForm());

            

        }

        [DllImport("kernel32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        public static extern bool SetDllDirectory(string lpPathName);

        [DllImport(@"C_DLL.dll")]
        public static extern void cProc(IntPtr sourcePtr, IntPtr destPtr, int height, int width, int start, int end);

        [DllImport(@"ASM_DLL.dll")]
        public static extern void asmProc(IntPtr sourcePtr, IntPtr destPtr, int height, int width, int start, int end);

    }

}
