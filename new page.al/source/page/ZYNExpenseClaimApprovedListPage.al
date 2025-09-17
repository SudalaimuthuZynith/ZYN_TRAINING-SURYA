page 50244 ZYN_ExpenseClaimApprovedPage
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = ZYN_ExpenseClaimsTable;
    CardPageId = ZYN_ExpenseClaimsCardPage;
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
                field("Rejection Reason"; Rec."Rejection Reason") { ApplicationArea = All; }
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
                    "ZYN Expense Management": Codeunit "ZYN Expense Management";
                    ThreeMonthsAgo: Date;
                    ZYN_ExpenseClaimsTable: Record ZYN_ExpenseClaimsTable;
                begin
                    // Validate Status
                    if Rec.Status <> Rec.Status::Pending then
                        Error(StatusError, Rec.Amount, Rec.Status);
                    //Bill Status
                    if not Rec."Bill".HasValue then
                        Error(BillError);
                    // Check 3-month limit
                    ThreeMonthsAgo := CalcDate('<-3M>', WorkDate());
                    if Rec."Bill Date" < ThreeMonthsAgo then
                        Error(validityerror, Rec.Amount, Rec."Bill Date");

                    // Check duplicate
                    "ZYN Expense Management".Duplicate(Rec."Employee ID", Rec."Catagory Name", rec.Subtype, Rec."Bill Date", Rec.Status);

                    // Calculate amount and approve
                    "ZYN Expense Management".CheckAmountLimit(Rec."Catagory Name", Rec.Subtype, Rec.Amount);
                    "ZYN Expense Management".CalculateAmount(Rec."Employee ID", Rec."Catagory Name", Rec.Subtype, Rec.Amount);
                    Rec.Status := Rec.Status::Approved;
                    Rec.Modify();

                    Message(ApprovalMessage);
                end;
            }

            action(RejectClaim)
            {
                ApplicationArea = All;
                Caption = 'Reject';
                Image = Cancel;

                trigger OnAction()
                var
                    ZYN_ExpenseRejectReason: Page ZYN_ExpenseRejectReason;
                    Reason: Text[250];
                begin


                    if ZYN_ExpenseRejectReason.RunModal() <> Action::OK then
                        Error(RejectionReasonError);

                    Reason := ZYN_ExpenseRejectReason.GetReason();


                    Rec.Validate(Status, Rec.Status::Rejected);
                    Rec."Rejection Reason" := Reason;
                    Rec.Modify(true);

                    Message(RejectionMessage, Rec."Expense ID", Reason);
                end;


            }
        }
    }
    var
        ValidityError: Label 'Expense claim with amount %1 has a Bill Date older than 3 months: %2';
        BillError: Label 'You must upload a Bill before approving this expense.';
        StatusError: Label 'Expense claim with amount %1 cannot be processed. Status: %2';
        ApprovalMessage: Label 'Expense claim approved successfully.';
        RejectionReasonError: Label 'You must provide a rejection reason.';
        RejectionMessage: Label 'Claim %1 has been rejected. Reason: %2';

    trigger OnOpenPage()
    var
        ZYN_ExpenseClaimsTable: Record ZYN_ExpenseClaimsTable;
    begin
        Rec.SetRange(Status, Rec.Status::Pending);
    end;
}

