page 50198 ZYN_PlanCardPage
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = ZYN_PlanTable;
    
    layout
    {
        area(Content)
        {
            group(Group)
            {
                field("Plan ID";Rec."Plan ID"){}
                field(Name;Rec.Name){}
                field(Description;Rec.Description){}
                field(Fee;Rec.Fee){}
                field(status;Rec.status){}
            }
        }
    }
    
    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                
                trigger OnAction()
                begin
                    
                end;
            }
        }
    }
    
    var
        myInt: Integer;
}