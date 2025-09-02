pageextension 50138 CustomerListExt extends "Customer List"
{
    layout
    {
        addfirst(factboxes)
        {
            part(cutomer; factbox)
            {
                SubPageLink = "No." = field("No.");
                ApplicationArea = all;
            }
            // part("INVOICECOUNT"; "INVOICECOUNT")
            // {
            //     ApplicationArea = all;
            // }
        }
    }
}
