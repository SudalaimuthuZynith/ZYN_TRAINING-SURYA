page 50196 ZYN_EmployeeAssetsHistory
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
                    Caption = 'Assigned Assets';
                    DrillDown = true;
                    trigger OnDrillDown()
                    begin
                        ZYNEmployeeAssetList.Reset();
                        ZYNEmployeeAssetList.SetRange(Employee, Rec.Employee);
                        Page.RunModal(Page::ZYNEmployeeAssetsList, ZYNEmployeeAssetList);
                    end;
                }
            }
        }
    }

    var
        AssignedAssets: Integer;
        ZYNEmployeeAssetList: Record ZYNEmployeeAssetList;

    trigger OnAfterGetCurrRecord()
    begin
        ZYNEmployeeAssetList.Reset();
        ZYNEmployeeAssetList.SetRange(Employee, Rec.Employee);
        AssignedAssets := ZYNEmployeeAssetList.Count;
    end;
}
