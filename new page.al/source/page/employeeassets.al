page 50195 EmployeeAssetsListPage
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = EmployeeAssetListTable;
    CardPageId = EmployeeAssetsCardPage;
    Editable=false;InsertAllowed=false;
    layout
    {
        area(Content)
        {
            repeater(general)
            {
                field(Employee; Rec.Employee)
                {

                }
                field("serial no"; Rec."serial no")
                {

                }
                field("Asset Type";Rec."Asset Type"){}
                field(status; Rec.status)
                {
                    
                }
                field("Assigned date"; Rec."Assigned date") { }
                field("Returned date date"; Rec."Returned date date") { }
                field("Lost date"; Rec."Lost date") { }
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