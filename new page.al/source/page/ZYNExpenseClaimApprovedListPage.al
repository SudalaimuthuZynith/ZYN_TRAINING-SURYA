page 50244 ZYNExpenseClaimApprovedPage
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = ZYNExpenseClaimsTable;
    CardPageId=ZYNExpenseClaimsCardPage;
    Editable = false;
    InsertAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Expense ID"; Rec."Expense ID") { ApplicationArea = all; }
                field("Employee ID"; Rec."Employee ID") { ApplicationArea = all; }
                field("Catagory Name"; Rec."Catagory Name") { ApplicationArea = all; }
                field(Subtype; Rec.Subtype) { ApplicationArea = all; }
                field(Amount; Rec.Amount) { ApplicationArea = all; }
                field("Claim Date"; Rec."Claim Date") { ApplicationArea = all; }
                field("Bill Date"; Rec."Bill Date") { ApplicationArea = all; }
                field(Bill; Rec.Bill) { ApplicationArea = all; }
                field(Remarks; Rec.Remarks) { ApplicationArea = all; }
                field(Status; Rec.Status) { ApplicationArea = all; }
            }
        }
    }
    actions
    {

        area(Processing)
        {

            action(Approve)
            {
                trigger OnAction()
                var
                    ExpenseMgt: Codeunit "ZYN Expense Management";
                    ThreeMonthsAgo: Date;
                    TempRec: Record ZYNExpenseClaimsTable;
                begin
                    // Validate Status
                    if Rec.Status <> Rec.Status::Pending then
                        Error('Expense claim with amount %1 cannot be processed. Status: %2', Rec.Amount, Rec.Status);
                    //Bill Status
                    if not Rec."Bill".HasValue then
                        Error('You must upload a Bill before approving this expense.');
                    // Check 3-month limit
                    ThreeMonthsAgo := CalcDate('<-3M>', WorkDate());
                    if Rec."Bill Date" < ThreeMonthsAgo then
                        Error('Expense claim with amount %1 has a Bill Date older than 3 months: %2', Rec.Amount, Rec."Bill Date");

                    // Check duplicate
                    TempRec.SetRange("Employee ID", Rec."Employee ID");
                    TempRec.SetRange("Catagory Name", Rec."Catagory Name");
                    TempRec.SetRange(Subtype, Rec.Subtype);
                    TempRec.SetRange("Bill Date", Rec."Bill Date");
                    TempRec.SetRange(Status, Rec.Status::Approved);
                    if TempRec.FindFirst() then
                        Error('This already exists, this is duplicate');

                    // Calculate amount and approve
                    ExpenseMgt.CheckAmountLimit(Rec."Catagory Name", Rec.Subtype, Rec.Amount);
                    ExpenseMgt.CalculateAmount(Rec."Catagory Name", Rec.Subtype, Rec.Amount);
                    Rec.Status := Rec.Status::Approved;
                    Rec.Modify();

                    Message('Expense claim approved successfully.');
                end;
            }


            action(Reject)
            {
                trigger OnAction()
                begin

                    if Rec.Status <> Rec.Status::Pending then
                        Error('Expense claim with amount %1 cannot be rejected. Status: %2', Rec.Amount, Rec.Status);

                    Rec.Status := Rec.Status::Rejected;
                    Rec.Modify();
                    Message('Expense claim rejected successfully.');
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        expclaim: Record ZYNExpenseClaimsTable;
    begin
        // Show only Pending claims when page opens
        // expclaim.SetRange(Status, Rec.Status::Pending);
        // if expclaim.FindSet() then
        //     Page.RunModal(Page::ZYNExpenseClaimsListPage, expclaim);
        Rec.SetRange(Status, Rec.Status::Pending);
    end;
}
