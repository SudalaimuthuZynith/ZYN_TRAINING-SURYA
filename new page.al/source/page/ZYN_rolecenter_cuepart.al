page 50107 "My Cue Part"
{
    PageType = CardPart;
    SourceTable = customer;
    ApplicationArea = All;
    Caption = 'My Cue Part';
    layout
    {
        area(Content)
        {
            cuegroup(overview)
            {
                Caption = 'tiles';
                field("MYY TILES"; Visitlogcount)
                {
                    ApplicationArea = All;
                    Caption = 'MYY TILES';

                    trigger OnDrillDown()
                    var
                        VisitLogRec: Record "Visitlog";
                        CustomerRec: Record Customer;
                        TempCustomer: Record Customer temporary;
                        today: Date;
                    begin
                        today := WorkDate();

                        VisitLogRec.SetRange(Date, today);
                        if VisitLogRec.FindSet() then begin
                            repeat
                                if CustomerRec.Get(VisitLogRec.CustomerNo) then begin
                                    if not TempCustomer.Get(CustomerRec."No.") then begin
                                        TempCustomer.Init();
                                        TempCustomer.TransferFields(CustomerRec);
                                        TempCustomer.Insert();
                                    end;
                                end;
                            until VisitLogRec.Next() = 0;
                        end;

                        PAGE.RunModal(PAGE::"Customer List", TempCustomer);
                    end;
                }


            }
        }
    }
    var
        Visitlogcount: Integer;
        visitlogRec: Record "Visitlog";
        today: Date;

    trigger OnOpenPage()
    begin
        today := WorkDate();
        Visitlogcount := 0;
        visitlogRec.Reset();
        visitlogRec.SetRange(Date, today);
        Visitlogcount := visitlogRec.Count;
    end;


}

