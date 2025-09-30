page 50136 ZYNTempCustomer
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = lists;
    SourceTable = Customer;
    Caption = 'customer list';
    CardPageId = "Sales Order";

    layout
    {
        area(Content)
        {
            group(customerlist)
            {
                repeater(general)
                {

                    field("No."; Rec."No.")
                    {
                    }
                    field(Name; Rec.Name)
                    {
                    }
                    field(Address; Rec.Address)
                    {
                    }
                    field("Post Code"; Rec."Post Code")
                    {
                    }
                    field(City; Rec.City)
                    {
                    }
                    field("Contact Type"; Rec."Contact Type")
                    {
                    }
                }
            }
            part(salesorder; sales_order_subpage)
            {
                SubPageLink = "Sell-to Customer No." = field("No.");
                ApplicationArea = all;
            }
            part(salesinvoice; sales_invoice_subpage)
            {
                SubPageLink = "Sell-to Customer No." = field("No.");
                ApplicationArea = all;
            }
            part(salescreditmemo; sales_creditmemo_subpage)
            {
                SubPageLink = "Sell-to Customer No." = field("No.");
                ApplicationArea = all;
            }
        }
    }
}