page 50231 RevenueGeneratedPage
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = PlanSubscriptionTable;
    Editable = false;
    InsertAllowed = false;
    layout
    {
        area(Content)
        {
            cuegroup("Subscriptions")
            {


                field("This Month Subscriptions Revenue"; ThisMonthRevenue)
                {
                    ApplicationArea = All;
                    Caption = 'This Month Subscription Revenue';
                    DrillDown = true;

                    trigger OnDrillDown()
                    var
                        SalesInv: Record "Sales Header";
                        
                    begin
                        CurrMonth := Date2DMY(WorkDate(), 2);
                        CurrYear := Date2DMY(WorkDate(), 3);

                        StartDate := DMY2Date(1, CurrMonth, CurrYear);
                        EndDate := CalcDate('<CM>', StartDate);

                        SalesInv.Reset();
                        SalesInv.SetRange("Document Type", SalesInv."Document Type"::Invoice);
                        SalesInv.SetRange("From Subscription", true);
                        SalesInv.SetRange("Document Date", StartDate, EndDate);

                        Page.RunModal(Page::"Sales Invoice List", SalesInv);
                    end;



                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()

   
    begin
        CurrMonth := Date2DMY(WorkDate(), 2);
        CurrYear := Date2DMY(WorkDate(), 3);


        StartDate := DMY2Date(1, CurrMonth, CurrYear);


        EndDate := CalcDate('<CM>', StartDate);

        ThisMonthRevenue := 0;

        SalesInvHdr.Reset();
        SalesInvHdr.SetRange("Document Type", SalesInvHdr."Document Type"::Invoice);
        SalesInvHdr.SetRange("From Subscription", true);
        SalesInvHdr.SetRange("Posting Date", StartDate, EndDate);

        if SalesInvHdr.FindSet() then
            repeat
                SalesInvLine.Reset();
                SalesInvLine.SetRange("Document Type", SalesInvLine."Document Type"::Invoice);
                SalesInvLine.SetRange("Document No.", SalesInvHdr."No.");
                SalesInvHdr.SetRange("Document Date", StartDate, EndDate);
                if SalesInvLine.FindSet() then
                    repeat
                        ThisMonthRevenue += SalesInvLine.Amount;
                    until SalesInvLine.Next() = 0;
            until SalesInvHdr.Next() = 0;
    end;


    var
        ThisMonthRevenue: Decimal;
        SalesInvHdr: Record "Sales Header";
        SalesInvLine: Record "Sales Line";
        StartDate: Date;
        EndDate: Date;
        CurrMonth: Integer;
        CurrYear: Integer;
}