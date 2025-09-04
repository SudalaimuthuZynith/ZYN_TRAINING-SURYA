page 50158 SubscriptionCardPage
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = PlanSubscriptionTable;

    layout
    {
        area(Content)
        {
            group(Group)
            {
                field("Subscription ID"; Rec."Subscription ID") { }
                field("Customer ID"; Rec."Customer ID") { }
                field("Plan ID"; Rec."Plan ID")
                {
                    trigger OnValidate()
                    var
                        PlanRec: Record PlanTable;
                    begin
                        if Rec."Plan ID" <> '' then begin
                            if PlanRec.Get(Rec."Plan ID") then begin
                                if PlanRec.Status = PlanRec.Status::InActive then
                                    Error(
                                      'You cannot create a subscription for Plan %1 because it is InActive.',
                                      Rec."Plan ID");
                            end;
                        end;
                    end;
                }
                field("Start Date"; Rec."Start Date")
                {
                    // trigger OnValidate()
                    // var
                    //     TempDate: Date;
                    // begin

                    //     TempDate := Rec."Start Date";
                    //     Rec."Next Billing Date" := CalcDate('<+1M>', TempDate);
                    //     while Rec."Next Billing Date" <= Rec."End Date" do begin
                    //         TempDate := Rec."Next Billing Date";
                    //         Rec."Next Billing Date" := CalcDate('<+1M>', TempDate);
                    //     end;
                    //     if Rec."Next Billing Date" > Rec."End Date" then
                    //         Rec."Next Billing Date" := TempDate;
                    // end;
                }
                field(Duration; Rec.Duration)
                {
                    // trigger OnValidate()
                    // begin
                    //     Rec."End Date" := CalcDate('<+' + Format(Rec.Duration) + 'M>', Rec."Start Date")
                    // end;
                }
                field("End Date"; Rec."End Date") { }
                field("Next Billing Date"; Rec."Next Billing Date") { }
                field(substatus; Rec.substatus) { }
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















// if Rec.Duration > 0 then
//             Rec."End Date" := CalcDate('<+' + Format(Rec.Duration) + 'M>', Rec."Start Date")
//         else
//             Rec."End Date" := Rec."Start Date"; 