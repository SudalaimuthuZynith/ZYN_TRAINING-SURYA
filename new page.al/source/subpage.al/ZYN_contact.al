page 50121 ZYN_Factbox
{
    PageType = CardPart;
    ApplicationArea = All; // Page available in all application areas
    SourceTable = Customer;

    layout
    {
        area(Content)
        {
            group(Factbox)
            {
                // Contact information group
                group(Contact)
                {
                    Visible = hasvalue; // Show only if a contact exists

                    // Contact Name field
                    field(Name; Name)
                    {
                        Caption = 'NAME';
                        DrillDown = true;
                        trigger OnDrillDown()
                        var
                            "Contact Card": Page "Contact Card";
                        begin
                            "Contact Card".SetRecord("Contact");
                            "Contact Card".Run();
                        end;
                    }

                    // Contact No. field
                    field(No; No)
                    {
                        Caption = 'NO';
                        DrillDown = true;
                        trigger OnDrillDown()
                        var
                            "Contact Card": Page "Contact Card";
                        begin
                            "Contact Card".SetRecord("Contact");
                            "Contact Card".Run();
                        end;
                    }
                }

                // Overview of invoices and orders
                cuegroup(Overview)
                {
                    Caption = 'INVOICE';

                    // Open invoices count field
                    field("Invoice Count"; InvoiceCount)
                    {
                        Caption = 'INVOICE';
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

                    // Open orders count field
                    field("Order Count"; OrderCount)
                    {
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
        hasvalue: Boolean; // Determines if contact info is available
        Name: Text[30];    // Contact name
        No: Code[30];      // Contact number
        InvoiceCount: Integer; // Number of open invoices
        OrderCount: Integer;   // Number of open orders
        SalesHeader: Record "Sales Header"; // Sales document records
        "Contact": Record Contact; // Contact record

    trigger OnAfterGetRecord()
    begin
        // Initialize variables
        Clear(Name);
        Clear(No);
        hasvalue := false;

        // Load primary contact details if available
        if (Rec."Primary Contact No." <> '') and (Rec.Contact <> '') then begin
            if "Contact".Get(Rec."Primary Contact No.") then begin
                Name := "Contact".Name;
                No := "Contact"."No.";
                hasvalue := true;
            end;
        end;

        // Calculate open invoice count
        SalesHeader.Reset();
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Invoice);
        SalesHeader.SetRange("Sell-to Customer No.", Rec."No.");
        SalesHeader.SetRange(Status, SalesHeader.Status::Open);
        InvoiceCount := SalesHeader.Count;

        // Calculate open order count
        SalesHeader.Reset();
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetRange("Sell-to Customer No.", Rec."No.");
        SalesHeader.SetRange(Status, SalesHeader.Status::Open);
        OrderCount := SalesHeader.Count;
    end;
}
