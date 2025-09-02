page 50197 LeaveRequestCardPage
{
    PageType = Card;
    ApplicationArea = All;
    //UsageCategory = Administration;
    //CardPageId = LeaveRequestCardPage;
    SourceTable = LeaveRequestTable;
    //Editable = false;

    layout
    {
        area(Content)
        {
            group(Group)
            {
                field("Employee ID"; Rec."Employee ID")
                {

                }
                field("Employee Name"; Rec."Employee Name")
                {

                }
                field(Catagory; Rec.Catagory) { }
                field(Reason; Rec.Reason) { }
                field("Start Date"; Rec."Start Date") { }
                field("End Date"; Rec."End Date") { }
                field("total days"; Rec."total days") { }
                field("Remaining leave days"; Rec."Remaining leave days") { }
                field(Status; Rec.Status) { }
            }
        }

    }

    actions
    {
        area(Processing)
        {
            action(Approve)
            {
                Caption = 'Approve';
                ApplicationArea = All;
                Image = Approve;
                trigger OnAction()
                var

                begin
                    Rec.Status := Rec.Status::Approved;

                end;

                // trigger OnAction()
                // var
                //     notifyRec: Record LeaveNotification;
                // begin
                //     // 1. Validate remaining leaves
                //     if Rec."Total Days" > Rec."Remaining leave days" then
                //         Error('YOU DO NOT HAVE ENOUGH LEAVES');

                //     // 2. Update status of the Leave Request
                //     Rec.Status := Rec.Status::Approved;
                //     Rec.Modify(true);

                //     // 3. Insert notification entry
                //     notifyRec.Init();
                //     notifyRec."Employee ID" := Rec."Employee ID";
                //     notifyRec."Employee Name" := Rec."Employee Name";
                //     notifyRec."Leave Category" := Rec.Catagory; // match field names in your Leave Request table
                //     notifyRec."Approved Days" := Rec."Total Days";
                //     notifyRec."Approval Date" := Today;

                //     // Set status = Approved in Notification table
                //     notifyRec.Status := notifyRec.Status::Approved;

                //     notifyRec.Insert();
                // end;
            }

            action(Reject)
            {

                trigger OnAction()
                var

                begin
                    Rec.Status := Rec.Status::Rejected;

                end;
            }
        }
    }
    // trigger OnOpenPage()
    // var
    //     budget: Record BudgetTable;
    // begin
    //     budget."From Date" := CalcDate('<-CM>', WorkDate);
    //     budget."To Date" := CalcDate('<-CM>', WorkDate);
    // end;

    var
        myInt: Integer;
}