codeunit 60000 "MJE Event Mgt."
{
    [EventSubscriber(ObjectType::Table, Database::"Report Selections", OnAfterSaveReportAsPDF, '', false, false)]
    local procedure OnAfterSaveReportAsPDF(var TempBlob: Codeunit "Temp Blob"; RecordVariant: Variant; ReportUsage: Enum "Report Selection Usage")
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        DocumentAttachment: Record "Document Attachment";
        MJEPDFDaemon: Page "MJE PDF Daemon";
        MergePDF: Codeunit MergePDF;
        Base64Convert: Codeunit "Base64 Convert";
        DATempBlob: Codeunit "Temp Blob";
        InStream: InStream;
        OutStream: OutStream;
        Text: Text;
        JsonArray: JsonArray;
    begin
        if ReportUsage <> ReportUsage::"S.Invoice" then
            exit;

        SalesInvoiceHeader := RecordVariant;

        DocumentAttachment.SetRange("Table ID", Database::"Sales Invoice Header");
        DocumentAttachment.SetRange("No.", SalesInvoiceHeader."No.");
        if not DocumentAttachment.FindSet() then
            exit;

        TempBlob.CreateInStream(InStream);
        MergePDF.AddBase64pdf(Base64Convert.ToBase64(InStream));

        repeat
            DocumentAttachment.GetAsTempBlob(DATempBlob);
            DATempBlob.CreateInStream(InStream);
            MergePDF.AddBase64pdf(Base64Convert.ToBase64(InStream));
        until DocumentAttachment.Next() = 0;

        JsonArray := MergePDF.GetJArray();
        JsonArray.WriteTo(Text);

        TempBlob.CreateOutStream(OutStream);
        MJEPDFDaemon.Show(Text, OutStream);
    end;
}