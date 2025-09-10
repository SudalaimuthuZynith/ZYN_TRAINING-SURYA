page 50221 ZYN_CustomerSubscriptionsPage
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = ZYN_PlanSubscriptionTable;
    Editable = false;
    InsertAllowed = false;
    layout
    {
        area(Content)
        {
            cuegroup("Subscriptions")
            {
                field("Active Subscriptions"; ActiveCount)
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    DrillDownPageId = ZYN_SubscriptionListPage;
                    trigger OnDrillDown()
                    begin
                        Sub.Reset();
                        Sub.SetRange("Customer ID",Rec."Customer ID");
                        Sub.SetRange(substatus, Rec.substatus::Active);
                        Page.RunModal(Page::ZYN_SubscriptionListPage, Sub);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        Sub.Reset();
        Sub.SetRange("Customer ID",Rec."Customer ID");
        Sub.SetRange(substatus, Rec.substatus::Active);
        ActiveCount := Sub.Count();
    end;


    var
        ActiveCount: Integer;
        Sub: Record ZYN_PlanSubscriptionTable;
}