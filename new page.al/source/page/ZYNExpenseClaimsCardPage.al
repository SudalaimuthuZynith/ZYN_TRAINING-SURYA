page 50232 ZYNExpenseClaimsCardPage
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = ZYNExpenseClaimsTable;

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
                        expcat: Record ZYNExpenseCatagoryTable;
                    begin
                        expcat.Reset();
                        if PAGE.RunModal(Page::ZYNExpenseCatagoryListPage, expcat) = ACTION::LookupOK then begin
                            Rec."Subtype" := expcat.Name;
                            Rec."Catagory Name" := expcat.Catagory;
                            Rec."Subtype Limit Amount" := expcat.Amount;
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
                        ExpenseMgt: Codeunit "ZYN Expense Management";
                    begin
                        ExpenseMgt.CheckAmountLimit(Rec."Catagory Name", Rec.Subtype, Rec.Amount);
                        RecalculateClaimedAmount();
                        //ExpenseMgt.CalculateAmount(Rec."Catagory Name", Rec.Subtype, Rec.Amount);
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
            field("Claimed Amount"; Rec."Claimed Amount") { ApplicationArea = all; }
            field("Subtype Limit Amount"; Rec."Subtype Limit Amount") { ApplicationArea = all; }
            field("Remaining Amount"; Rec."Remaining Amount") { ApplicationArea = all; }

            // field("Date Filter"; Rec."Date Filter") { ApplicationArea = all; }
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
                        Message('File %1 uploaded successfully.', FileName);
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
                        Rec."Bill".CreateInStream(InStream);
                        FileName := 'Bill.pdf'; // or store original FileName in a Text field
                        DownloadFromStream(InStream, '', '', '', FileName);
                    end else
                        Message('No file uploaded.');
                end;
            }

        }

    }
    procedure RecalculateClaimedAmount()
    begin
        if (Rec."Employee ID" <> '') and (Rec."Catagory Name" <> '') and (Rec.Subtype <> '') then
            Rec.CALCFIELDS("Claimed Amount");
    end;

    procedure UpdateDateFilter()
    begin
        if Rec."Claim Date" <> 0D then
            Rec."Date Filter" := CalcDate('<-CY>', Rec."Claim Date");
    end;





}