page 50121 factbox
{
    PageType = CardPart;
    ApplicationArea = All;
    SourceTable = Customer;

    layout
    {
        area(Content)
        {
            group(factbox)
            {
                group(contact)
                {
                    Visible = hasvalue;
                    field(name; name)
                    {

                        Caption = 'NAME';
                        ApplicationArea = all;
                        trigger OnDrillDown()
                        var
                            "Contact Card": Page "Contact Card";

                        begin
                            "Contact Card".SetRecord("Contact");
                            "Contact Card".Run();
                        end;
                    }
                    field(no; no)
                    {
                        Caption = 'NO';
                        ApplicationArea = all;
                        trigger OnDrillDown()
                        var
                            "Contact Card": Page "Contact Card";

                        begin
                            "Contact Card".SetRecord("Contact");
                            "Contact Card".Run();
                        end;
                    }
                }
                cuegroup(overview)
                {
                    Caption = 'INVOICE';
                    field("invoice count"; invoicecount)
                    {
                        ApplicationArea = All;
                        Caption = 'INVOICRE';
                        DrillDown = true;
                        trigger OnDrillDown()
                        begin
                            salesheader.Reset();
                            salesheader.SetRange("Document Type", salesheader."Document Type"::Invoice);
                            salesheader.SetRange("Sell-to Customer No.", Rec."No.");
                            salesheader.SetRange(Status, salesheader.Status::Open);
                            PAGE.RunModal(PAGE::"Sales Invoice List", salesheader);
                        end;
                    }
                    field("order count"; ordercount)
                    {
                        ApplicationArea = All;

                        Caption = 'ORDER';
                        DrillDown = true;
                        trigger OnDrillDown()
                        begin
                            salesheader.Reset();
                            salesheader.SetRange("Document Type", salesheader."Document Type"::Order);
                            salesheader.SetRange("Sell-to Customer No.", Rec."No.");
                            salesheader.SetRange(Status, salesheader.Status::Open);

                            PAGE.RunModal(PAGE::"Sales Order List", salesheader);
                        end;
                    }
                }
            }
        }

    }
    var
        hasvalue: Boolean;
        name: Text[30];
        no: Code[30];
        invoicecount: Integer;
        ordercount: Integer;
        salesheader: Record "Sales Header";
        "Contact": Record Contact;

    trigger OnAfterGetRecord()
    begin

        Clear(name);
        Clear(no);
        hasvalue := false;
        if (Rec."Primary Contact No." <> '') and (Rec.Contact <> '') then begin
            if "Contact".Get(Rec."Primary Contact No.") then begin
                name := "Contact".Name;
                no := "Contact"."No.";
                hasvalue := true;
            end;
        end;
        salesheader.Reset();
        salesheader.SetRange("Document Type", salesheader."Document Type"::Invoice);
        salesheader.SetRange("Sell-to Customer No.", Rec."No.");
        salesheader.SetRange(Status, salesheader.Status::Open);
        invoicecount := salesheader.Count;
        salesheader.Reset();
        salesheader.SetRange("Document Type", salesheader."Document Type"::Order);
        salesheader.SetRange("Sell-to Customer No.", Rec."No.");
        salesheader.SetRange(Status, salesheader.Status::Open);
        ordercount := salesheader.Count;
    end;
}