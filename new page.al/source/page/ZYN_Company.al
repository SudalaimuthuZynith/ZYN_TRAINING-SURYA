page 50212 ZYN_Company
{
    Caption='Zynith Company';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = ZYN_Company;
    layout
    {
        area(Content)
        {
            repeater(Companies)
            {
                field(Name; Rec.Name)
                {
                }
                field("Evaluation Company"; Rec."Evaluation Company")
                {
                }
                field("Display Name"; Rec."Display Name")
                {
                }
                field(Id; Rec.Id)
                {
                }
                field("Business Profile Id"; Rec."Business Profile Id")
                {
                }
                field(IsMaster;Rec.IsMaster)
                {
                }
                field("Master Company Name";Rec."Master Company Name")
                {
                }
            }
        }
    }
}

