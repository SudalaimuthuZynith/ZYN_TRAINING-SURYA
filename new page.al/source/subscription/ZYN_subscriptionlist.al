page 50269 ZYN_SubscriptionListPage
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = ZYN_PlanSubscriptionTable;
    CardPageId = ZYN_SubscriptionCardPage;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Subscription ID"; Rec."Subscription ID") { }
                field("Customer ID"; Rec."Customer ID") { }
                field("Plan ID"; Rec."Plan ID") { }
                field("Start Date"; Rec."Start Date") { }
                field(Duration; Rec.Duration) { }
                field("End Date"; Rec."End Date") { }
                field("Next Billing Date"; Rec."Next Billing Date") { }
                //field("Remainder Date"; Rec."Remainder Date") { }
                field("Next renewal Date"; Rec."Next renewal Date") { }

                field(substatus; Rec.substatus) { }
                field("Remainder send"; Rec."Remainder send") { }
            }
        }
    }


}