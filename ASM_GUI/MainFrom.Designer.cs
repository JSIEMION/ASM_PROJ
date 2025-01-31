namespace ASM_GUI
{
    partial class mainForm
    {
        /// <summary>
        ///  Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        ///  Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        /// 

        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        ///  Required method for Designer support - do not modify
        ///  the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            sourcePictureBox = new PictureBox();
            destPictureBox = new PictureBox();
            libraryComboBox = new ComboBox();
            startButton = new Button();
            sourcePathBox = new TextBox();
            threadsNumberNumericUpDown = new NumericUpDown();
            libSelectionLabel = new Label();
            threadsNumberLabel = new Label();
            timeElapsedLabel = new Label();
            sourcePathLabel = new Label();
            timeElapsedBox = new TextBox();
            openFileButton = new Button();
            saveFileButton = new Button();
            saveFileDialog = new SaveFileDialog();
            openFileDialog = new OpenFileDialog();
            splitContainer = new SplitContainer();
            groupBox1 = new GroupBox();
            ((System.ComponentModel.ISupportInitialize)sourcePictureBox).BeginInit();
            ((System.ComponentModel.ISupportInitialize)destPictureBox).BeginInit();
            ((System.ComponentModel.ISupportInitialize)threadsNumberNumericUpDown).BeginInit();
            ((System.ComponentModel.ISupportInitialize)splitContainer).BeginInit();
            splitContainer.Panel1.SuspendLayout();
            splitContainer.Panel2.SuspendLayout();
            splitContainer.SuspendLayout();
            groupBox1.SuspendLayout();
            SuspendLayout();
            // 
            // sourcePictureBox
            // 
            sourcePictureBox.AllowDrop = true;
            sourcePictureBox.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            sourcePictureBox.BackgroundImageLayout = ImageLayout.None;
            sourcePictureBox.BorderStyle = BorderStyle.Fixed3D;
            sourcePictureBox.Location = new Point(0, 0);
            sourcePictureBox.Margin = new Padding(3, 4, 3, 4);
            sourcePictureBox.Name = "sourcePictureBox";
            sourcePictureBox.Size = new Size(476, 415);
            sourcePictureBox.SizeMode = PictureBoxSizeMode.Zoom;
            sourcePictureBox.TabIndex = 0;
            sourcePictureBox.TabStop = false;
            sourcePictureBox.DragDrop += sourcePictureBox_DragDrop;
            sourcePictureBox.DragEnter += sourcePictureBox_DragEnter;
            // 
            // destPictureBox
            // 
            destPictureBox.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            destPictureBox.BackgroundImageLayout = ImageLayout.None;
            destPictureBox.BorderStyle = BorderStyle.Fixed3D;
            destPictureBox.Location = new Point(6, 0);
            destPictureBox.Margin = new Padding(3, 4, 3, 4);
            destPictureBox.Name = "destPictureBox";
            destPictureBox.Size = new Size(474, 415);
            destPictureBox.SizeMode = PictureBoxSizeMode.Zoom;
            destPictureBox.TabIndex = 1;
            destPictureBox.TabStop = false;
            // 
            // libraryComboBox
            // 
            libraryComboBox.Anchor = AnchorStyles.None;
            libraryComboBox.DropDownStyle = ComboBoxStyle.DropDownList;
            libraryComboBox.FormattingEnabled = true;
            libraryComboBox.Items.AddRange(new object[] { "C", "ASM" });
            libraryComboBox.Location = new Point(502, 17);
            libraryComboBox.Margin = new Padding(3, 4, 3, 4);
            libraryComboBox.MaxDropDownItems = 2;
            libraryComboBox.MaximumSize = new Size(87, 0);
            libraryComboBox.MinimumSize = new Size(87, 0);
            libraryComboBox.Name = "libraryComboBox";
            libraryComboBox.Size = new Size(87, 28);
            libraryComboBox.TabIndex = 2;
            // 
            // startButton
            // 
            startButton.Anchor = AnchorStyles.None;
            startButton.Enabled = false;
            startButton.Location = new Point(441, 95);
            startButton.Margin = new Padding(3, 4, 3, 4);
            startButton.MaximumSize = new Size(86, 31);
            startButton.MinimumSize = new Size(86, 31);
            startButton.Name = "startButton";
            startButton.Size = new Size(86, 31);
            startButton.TabIndex = 3;
            startButton.Text = "Nałóż filtr";
            startButton.UseVisualStyleBackColor = true;
            startButton.Click += startButton_Click;
            // 
            // sourcePathBox
            // 
            sourcePathBox.Anchor = AnchorStyles.Bottom;
            sourcePathBox.Location = new Point(102, 424);
            sourcePathBox.Margin = new Padding(3, 4, 3, 4);
            sourcePathBox.MaximumSize = new Size(375, 23);
            sourcePathBox.MinimumSize = new Size(375, 23);
            sourcePathBox.Name = "sourcePathBox";
            sourcePathBox.ReadOnly = true;
            sourcePathBox.Size = new Size(375, 27);
            sourcePathBox.TabIndex = 4;
            // 
            // threadsNumberNumericUpDown
            // 
            threadsNumberNumericUpDown.Anchor = AnchorStyles.None;
            threadsNumberNumericUpDown.Location = new Point(502, 56);
            threadsNumberNumericUpDown.Margin = new Padding(3, 4, 3, 4);
            threadsNumberNumericUpDown.MaximumSize = new Size(88, 0);
            threadsNumberNumericUpDown.Minimum = new decimal(new int[] { 1, 0, 0, 0 });
            threadsNumberNumericUpDown.MinimumSize = new Size(88, 0);
            threadsNumberNumericUpDown.Name = "threadsNumberNumericUpDown";
            threadsNumberNumericUpDown.Size = new Size(88, 27);
            threadsNumberNumericUpDown.TabIndex = 6;
            threadsNumberNumericUpDown.Value = new decimal(new int[] { 1, 0, 0, 0 });
            // 
            // libSelectionLabel
            // 
            libSelectionLabel.Anchor = AnchorStyles.None;
            libSelectionLabel.AutoSize = true;
            libSelectionLabel.Location = new Point(344, 21);
            libSelectionLabel.Name = "libSelectionLabel";
            libSelectionLabel.Size = new Size(137, 20);
            libSelectionLabel.TabIndex = 7;
            libSelectionLabel.Text = "Wybierz bibliotekę:";
            // 
            // threadsNumberLabel
            // 
            threadsNumberLabel.Anchor = AnchorStyles.None;
            threadsNumberLabel.AutoSize = true;
            threadsNumberLabel.Location = new Point(330, 59);
            threadsNumberLabel.Name = "threadsNumberLabel";
            threadsNumberLabel.Size = new Size(164, 20);
            threadsNumberLabel.TabIndex = 8;
            threadsNumberLabel.Text = "Wybierz liczbę wątków:";
            // 
            // timeElapsedLabel
            // 
            timeElapsedLabel.Anchor = AnchorStyles.Bottom;
            timeElapsedLabel.AutoSize = true;
            timeElapsedLabel.Location = new Point(131, 428);
            timeElapsedLabel.Name = "timeElapsedLabel";
            timeElapsedLabel.Size = new Size(158, 20);
            timeElapsedLabel.TabIndex = 9;
            timeElapsedLabel.Text = "Nałożenie filtra zajęło:";
            // 
            // sourcePathLabel
            // 
            sourcePathLabel.Anchor = AnchorStyles.Bottom;
            sourcePathLabel.AutoSize = true;
            sourcePathLabel.Location = new Point(3, 428);
            sourcePathLabel.Name = "sourcePathLabel";
            sourcePathLabel.Size = new Size(100, 20);
            sourcePathLabel.TabIndex = 11;
            sourcePathLabel.Text = "Plik źródłowy:";
            // 
            // timeElapsedBox
            // 
            timeElapsedBox.Anchor = AnchorStyles.Bottom;
            timeElapsedBox.Location = new Point(278, 424);
            timeElapsedBox.Margin = new Padding(3, 4, 3, 4);
            timeElapsedBox.MaximumSize = new Size(117, 23);
            timeElapsedBox.MinimumSize = new Size(117, 23);
            timeElapsedBox.Name = "timeElapsedBox";
            timeElapsedBox.ReadOnly = true;
            timeElapsedBox.Size = new Size(117, 27);
            timeElapsedBox.TabIndex = 13;
            timeElapsedBox.TextAlign = HorizontalAlignment.Center;
            // 
            // openFileButton
            // 
            openFileButton.Anchor = AnchorStyles.Bottom;
            openFileButton.Location = new Point(184, 463);
            openFileButton.Margin = new Padding(3, 4, 3, 4);
            openFileButton.MaximumSize = new Size(103, 31);
            openFileButton.MinimumSize = new Size(103, 31);
            openFileButton.Name = "openFileButton";
            openFileButton.Size = new Size(103, 31);
            openFileButton.TabIndex = 14;
            openFileButton.Text = "Otwóż plik";
            openFileButton.UseVisualStyleBackColor = true;
            openFileButton.Click += openFileButton_Click;
            // 
            // saveFileButton
            // 
            saveFileButton.Anchor = AnchorStyles.Bottom;
            saveFileButton.Location = new Point(214, 463);
            saveFileButton.Margin = new Padding(3, 4, 3, 4);
            saveFileButton.MaximumSize = new Size(86, 31);
            saveFileButton.MinimumSize = new Size(86, 31);
            saveFileButton.Name = "saveFileButton";
            saveFileButton.Size = new Size(86, 31);
            saveFileButton.TabIndex = 15;
            saveFileButton.Text = "Zapisz plik";
            saveFileButton.UseVisualStyleBackColor = true;
            saveFileButton.Click += saveFileButton_Click;
            // 
            // saveFileDialog
            // 
            saveFileDialog.Filter = "pliki png|*.png";
            saveFileDialog.Title = "Save file";
            saveFileDialog.FileOk += saveFileDialog_FileOk;
            // 
            // openFileDialog
            // 
            openFileDialog.Filter = "obraz|*.png;*.jpg";
            openFileDialog.Title = "Open file";
            openFileDialog.FileOk += openFileDialog_FileOk;
            // 
            // splitContainer
            // 
            splitContainer.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            splitContainer.Location = new Point(14, 16);
            splitContainer.Margin = new Padding(3, 4, 3, 4);
            splitContainer.Name = "splitContainer";
            // 
            // splitContainer.Panel1
            // 
            splitContainer.Panel1.Controls.Add(sourcePictureBox);
            splitContainer.Panel1.Controls.Add(openFileButton);
            splitContainer.Panel1.Controls.Add(sourcePathLabel);
            splitContainer.Panel1.Controls.Add(sourcePathBox);
            // 
            // splitContainer.Panel2
            // 
            splitContainer.Panel2.Controls.Add(destPictureBox);
            splitContainer.Panel2.Controls.Add(saveFileButton);
            splitContainer.Panel2.Controls.Add(timeElapsedBox);
            splitContainer.Panel2.Controls.Add(timeElapsedLabel);
            splitContainer.Size = new Size(966, 519);
            splitContainer.SplitterDistance = 481;
            splitContainer.SplitterWidth = 5;
            splitContainer.TabIndex = 16;
            // 
            // groupBox1
            // 
            groupBox1.Anchor = AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            groupBox1.Controls.Add(libSelectionLabel);
            groupBox1.Controls.Add(threadsNumberLabel);
            groupBox1.Controls.Add(libraryComboBox);
            groupBox1.Controls.Add(startButton);
            groupBox1.Controls.Add(threadsNumberNumericUpDown);
            groupBox1.Location = new Point(14, 543);
            groupBox1.Margin = new Padding(3, 4, 3, 4);
            groupBox1.Name = "groupBox1";
            groupBox1.Padding = new Padding(3, 4, 3, 4);
            groupBox1.Size = new Size(966, 133);
            groupBox1.TabIndex = 17;
            groupBox1.TabStop = false;
            // 
            // mainForm
            // 
            AutoScaleDimensions = new SizeF(8F, 20F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(993, 689);
            Controls.Add(splitContainer);
            Controls.Add(groupBox1);
            Margin = new Padding(3, 4, 3, 4);
            MinimumSize = new Size(1009, 726);
            Name = "mainForm";
            Text = "Form1";
            ((System.ComponentModel.ISupportInitialize)sourcePictureBox).EndInit();
            ((System.ComponentModel.ISupportInitialize)destPictureBox).EndInit();
            ((System.ComponentModel.ISupportInitialize)threadsNumberNumericUpDown).EndInit();
            splitContainer.Panel1.ResumeLayout(false);
            splitContainer.Panel1.PerformLayout();
            splitContainer.Panel2.ResumeLayout(false);
            splitContainer.Panel2.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)splitContainer).EndInit();
            splitContainer.ResumeLayout(false);
            groupBox1.ResumeLayout(false);
            groupBox1.PerformLayout();
            ResumeLayout(false);
        }

        #endregion

        private PictureBox sourcePictureBox;
        private PictureBox destPictureBox;
        private ComboBox libraryComboBox;
        private Button startButton;
        private TextBox sourcePathBox;
        private NumericUpDown threadsNumberNumericUpDown;
        private Label libSelectionLabel;
        private Label threadsNumberLabel;
        private Label timeElapsedLabel;
        private Label sourcePathLabel;
        private TextBox timeElapsedBox;
        private Button openFileButton;
        private Button saveFileButton;
        private SaveFileDialog saveFileDialog;
        private OpenFileDialog openFileDialog;
        
        private Bitmap sourceBmp;
        private Bitmap destBmp;
        private int threadsNumber = 1;
        private SplitContainer splitContainer;
        private GroupBox groupBox1;
    }
}
