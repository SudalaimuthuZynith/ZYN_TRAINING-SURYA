page 50237 ZYNExpenseClaimsListPage
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
            repeater("Expense Claims")
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
                field("Claimed Amount"; Rec."Claimed Amount") { ApplicationArea = all; Editable = false; }
                field("Subtype Limit Amount"; Rec."Subtype Limit Amount") { ApplicationArea = all; Editable = false; }
                field("Remaining Amount"; Rec."Remaining Amount") { ApplicationArea = all; Editable = false; }
                field("Rejection Reason"; Rec."Rejection Reason") { ApplicationArea = all; Editable = false; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Expense Catagory")
            {
                RunObject = page ZYN_ExpenseCatagoryListPage;
            }
            action(Cancel)
            {
                trigger OnAction()
                begin
                    if Rec.Status <> Rec.Status::Pending then
                        Error(CancelStatusError, Rec.Amount, Rec.Status);

                    Rec.Status := Rec.Status::Cancelled;
                    Rec.Modify();
                    Message(CancelMsg);
                end;
            }
        }
    }

    var
        CancelStatusError: Label 'Expense claim with amount %1 cannot be cancelled. Status: %2';
        CancelMsg: Label 'Expense claim cancelled successfully.';
}