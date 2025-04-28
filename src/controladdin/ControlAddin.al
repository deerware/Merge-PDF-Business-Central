controladdin PDF
{
    Scripts = 'src/script/pdf-lib.min.js',
    'src/script/download.js',
    'src/script/scripts.js';

    StartupScript = 'src/script/startup.js';

    MaximumHeight = 1;
    MaximumWidth = 1;
    event DownloadPDF(stringpdffinal: text);
    event AddinReady();
    procedure createPdf();
    procedure MergePDF(JObjectToMerge: text);

}