page 50172 PlanListPage
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = PlanTable;
    CardPageId = PlanCardPage;
    Editable = false;
    InsertAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Plan ID"; Rec."Plan ID") { }
                field(Name; Rec.Name) { }
                field(Description; Rec.Description) { }
                field(Fee; Rec.Fee) { }
                field(status; Rec.status) { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Make Plan InActive")
            {
                ApplicationArea = All;
                trigger OnAction()
                var
                    Sub: Record PlanSubscriptionTable;
                begin
                    
                    if Rec.FindFirst() then begin
                        Rec.Status := Rec.Status::InActive;  
                        Rec.Modify(true);
                    end;             
                    Sub.Reset();
                    Sub.SetRange("Plan ID", Rec."Plan ID");

                    if Sub.FindSet() then
                        repeat
                            Sub.substatus := Sub.substatus::InActive;
                            Sub.Modify(true);
                        until Sub.Next() = 0;
                end;
            }
            

        }
    }

    var
        myInt: Integer;
}