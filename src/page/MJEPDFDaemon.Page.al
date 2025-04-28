page 60000 "MJE PDF Daemon"
{
    PageType = NavigatePage;
    ApplicationArea = All;
    Caption = 'MJE PDF Daemon';

    layout
    {
        area(Content)
        {
            label("Working on it 1")
            {
                ApplicationArea = All;
                Caption = 'Merging PDF files...';
            }
            label("Working on it 2")
            {
                ApplicationArea = All;
                Caption = 'Please don''t close this page.';
                Style = Subordinate;
            }
            usercontrol(PDFAddin; PDF)
            {
                trigger AddinReady()
                begin
                    CurrPage.PDFAddin.MergePDF(Base64Input);
                end;

                trigger DownloadPDF(pdfToNav: text)
                begin
                    if pdfToNav = '' then
                        Error('Merge failed');

                    Base64Result := pdfToNav;
                    Ready := true;

                    // Message(Base64Result);
                    CurrPage.Close();
                end;
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        exit(Ready);
    end;

    var
        Ready: Boolean;
        Base64Input: Text;
        Base64Result: Text;

    procedure Show(JsonArrayText: Text; var OutStream: OutStream): Text;
    var
        Base64Convert: Codeunit "Base64 Convert";
    begin
        Ready := false;
        Base64Input := JsonArrayText;

        CurrPage.RunModal();

        Base64Convert.FromBase64(Base64Result, OutStream);
        exit(Base64Result);
    end;
}