page 50136 custom_customer_list
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

                    field("No."; Rec."No.") { ApplicationArea = all; }
                    field(Name; Rec.Name) { ApplicationArea = all; }
                    field(Address; Rec.Address) { ApplicationArea = all; }
                    field("Post Code"; Rec."Post Code") { ApplicationArea = all; }
                    field(City; Rec.City) { ApplicationArea = all; }
                    field("Contact Type"; Rec."Contact Type") { ApplicationArea = all; }
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