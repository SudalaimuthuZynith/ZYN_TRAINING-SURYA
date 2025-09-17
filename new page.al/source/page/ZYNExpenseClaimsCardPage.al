page 50232 ZYN_ExpenseClaimsCardPage
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = ZYN_ExpenseClaimsTable;

    layout
    {
        area(Content)
        {
            group("Expense Claims")
            {
                field("Expense ID"; Rec."Expense ID") { ApplicationArea = all; }
                field("Employee ID"; Rec."Employee ID")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        RecalculateClaimedAmount();
                    end;
                }
                field("Catagory Name"; Rec."Catagory Name")
                {
                    ApplicationArea = all;
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        ZYNExpenseCatagoryTable: Record ZYN_ExpenseCatagoryTable;
                    begin
                        ZYNExpenseCatagoryTable.Reset();
                        if PAGE.RunModal(Page::ZYN_ExpenseCatagoryListPage, ZYNExpenseCatagoryTable) = ACTION::LookupOK then begin
                            Rec."Subtype" := ZYNExpenseCatagoryTable.Name;
                            Rec."Catagory Name" := ZYNExpenseCatagoryTable.Catagory;
                            Rec."Subtype Limit Amount" := ZYNExpenseCatagoryTable.Amount;
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        RecalculateClaimedAmount();
                    end;
                }
                field(Subtype; Rec.Subtype)
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        RecalculateClaimedAmount();

                    end;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                        "ZYN Expense Management": Codeunit "ZYN Expense Management";
                    begin
                        "ZYN Expense Management".CheckAmountLimit(Rec."Catagory Name", Rec.Subtype, Rec.Amount);
                        RecalculateClaimedAmount();
                    end;
                }
                field("Claim Date"; Rec."Claim Date")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        RecalculateClaimedAmount();
                        UpdateDateFilter();
                        Rec."Remaining Amount" := Rec."Subtype Limit Amount" - Rec."Claimed Amount";
                    end;
                }
                field("Bill Date"; Rec."Bill Date")
                {
                    ApplicationArea = all;
                }
                field("Bill"; Rec."Bill")
                {
                    ApplicationArea = All;
                }
            }
            field(Remarks; Rec.Remarks) { ApplicationArea = all; }
            field(Status; Rec.Status) { ApplicationArea = all; }

            field("Claimed Amount"; Rec."Claimed Amount") { ApplicationArea = all; Editable = false; }
            field("Subtype Limit Amount"; Rec."Subtype Limit Amount") { ApplicationArea = all; Editable = false; }
            field("Remaining Amount"; Rec."Remaining Amount") { ApplicationArea = all; Editable = false; }
            field("Rejection Reason"; Rec."Rejection Reason") { ApplicationArea = all; Editable = false; }
        }
    }





    actions
    {
        area(processing)
        {
            action(ImportBill)
            {
                ApplicationArea = All;
                Caption = 'Upload Bill';
                Image = Import;

                trigger OnAction()
                var
                    InStream: InStream;
                    OutStream: OutStream;
                    FileName: Text;
                begin
                    if UploadIntoStream('Select File', '', '', FileName, InStream) then begin
                        // Save uploaded file into the Blob
                        Rec."Bill".CreateOutStream(OutStream);
                        CopyStream(OutStream, InStream);
                        Rec.Modify(true);
                        Message(FileUploadMsg, FileName);
                    end;
                end;
            }

            action(ExportBill)
            {
                ApplicationArea = All;
                Caption = 'Download Bill';
                Image = Export;

                trigger OnAction()
                var
                    InStream: InStream;
                    FileName: Text;
                begin
                    if Rec."Bill".HasValue then begin
                        // Save downloaded file into the Blob
                        Rec."Bill".CreateInStream(InStream);
                        FileName := 'Bill.pdf'; // or store original FileName in a Text field
                        DownloadFromStream(InStream, '', '', '', FileName);
                    end
                end;
            }

        }

    }
    var
        FileUploadMsg: Label 'File %1 uploaded successfully.';

    procedure RecalculateClaimedAmount()
    begin
        //calculate claimed amount
        if (Rec."Employee ID" <> '') and (Rec."Catagory Name" <> '') and (Rec.Subtype <> '') then
            Rec.CALCFIELDS("Claimed Amount");
    end;

    procedure UpdateDateFilter()
    begin
        //Gives Start of the Year according to claim date
        if Rec."Claim Date" <> 0D then
            Rec."Date Filter" := CalcDate('<-CY>', Rec."Claim Date");
    end;
}