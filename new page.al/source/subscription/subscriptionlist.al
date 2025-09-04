page 50269 SubscriptionListPage
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = PlanSubscriptionTable;
    CardPageId= SubscriptionCardPage;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Subscription ID";Rec."Subscription ID"){}
                field("Customer ID";Rec."Customer ID"){}
                field("Plan ID";Rec."Plan ID"){}
                field("Start Date";Rec."Start Date"){}
                field(Duration;Rec.Duration){}
                field("End Date";Rec."End Date"){}
                field("Next Billing Date";Rec."Next Billing Date"){}
                field(substatus;Rec.substatus){}
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