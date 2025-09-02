report 50133 "NEWREPORT"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'NEWREPORT';

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView =where("Document Type" = const(Order),Status = const(Open));
            trigger OnAfterGetRecord()
            var
                SalesHeader: Record "Sales Header";
            begin
                SalesHeader."Posting Date" := newdate;
                SalesHeader.Modify();
                counter += 1;
                
            end;

            trigger OnPostDataItem()
            begin
                Message('%1 Sales Orders were updated with new Posting Date.', counter);
            end;
            
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(newdate; newdate)
                    {
                        Caption = 'New Posting Date';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    var
        counter: Integer;
        newdate: Date;
}
