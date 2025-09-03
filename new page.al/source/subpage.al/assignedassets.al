// page 50193 AssignedAssetsPage
// {
//     PageType = ListPart;
//     ApplicationArea = All;
//     UsageCategory = Administration;
//     SourceTable = EmployeeAssetListTable;

//     layout
//     {
//         area(Content)
//         {
//             cuegroup(income)
//             {
//                 field(AssignedAssets; AssignedAssets)
//                 {
//                     ApplicationArea = All;
//                     DrillDown = true;
//                     trigger OnDrillDown()
//                     begin
//                         income.Reset();
//                         income.SetRange(Status, income.Status::Assigned);
//                         Page.RunModal(Page::EmployeeAssetsListPage, income);
//                     end;
//                 }
//             }
//         }
//     }

//     actions
//     {
//         area(Processing)
//         {
//             action(ActionName)
//             {

//                 trigger OnAction()
//                 begin

//                 end;
//             }
//         }
//     }

//     var
//         AssignedAssets: Integer;
//         income: Record EmployeeAssetListTable;

//     trigger OnAfterGetCurrRecord()
//     begin
//         income.Reset();
//         income.SetRange(Status, income.Status::Assigned);
//         AssignedAssets := income.Count;
//     end;
// }
page 50193 AssignedAssetsPage
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = EmployeeAssetListTable;

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
                    var
                        AssetRec: Record AssetsListTable;
                        HistRec: Record EmployeeAssetListTable;
                        TempRec: Record EmployeeAssetListTable temporary;
                    begin
                       
                        TempRec.DeleteAll();

                        AssetRec.Reset();
                        if AssetRec.FindSet() then
                            repeat
                                HistRec.Reset();
                                HistRec.SetRange("serial no", AssetRec."Serial No");
                               
                                if HistRec.FindLast() then
                                    if HistRec.Status = HistRec.Status::Assigned then begin
                                        TempRec := HistRec;     
                                        TempRec.Insert();
                                    end;
                            until AssetRec.Next() = 0;

                        Page.RunModal(Page::EmployeeAssetsListPage, TempRec);
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
                trigger OnAction() begin end;
            }
        }
    }

    var
        AssignedAssets: Integer;
        income: Record EmployeeAssetListTable;

    trigger OnAfterGetCurrRecord()
    var
        AssetRec: Record AssetsListTable;
        HistRec: Record EmployeeAssetListTable;
    begin
        AssignedAssets := 0;

        AssetRec.Reset();
        if AssetRec.FindSet() then
            repeat
                HistRec.Reset();
                HistRec.SetRange("serial no", AssetRec."Serial No");
                if HistRec.FindLast() then begin
                    if HistRec.Status = HistRec.Status::Assigned then
                        AssignedAssets += 1;
                end;
            until AssetRec.Next() = 0;
    end;
}
