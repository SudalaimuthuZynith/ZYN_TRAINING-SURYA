page 50196 EmployeeAssetsHistoryPage
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = ZYNEmployeeAssetList;

    layout
    {
        area(Content)
        {
            cuegroup(income)
            {
                field(AssignedAssets; AssignedAssets)
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    trigger OnDrillDown()
                    begin
                        income.Reset();
                        income.SetRange(Employee, Rec.Employee);
                        Page.RunModal(Page::ZYNEmployeeAssetsList, income);
                    end;
                }
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
        AssignedAssets: Integer;
        income: Record ZYNEmployeeAssetList;

    trigger OnAfterGetCurrRecord()
    begin
        income.Reset();
        income.SetRange(Employee, Rec.Employee);
        AssignedAssets := income.Count;
    end;
}