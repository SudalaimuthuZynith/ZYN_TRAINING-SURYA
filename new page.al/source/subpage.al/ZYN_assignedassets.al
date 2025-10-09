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
page 50193 ZYN_AssignedAssets
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
                    var
                        ZYNAssetsList: Record ZYNAssetsList;
                        ZYNEmployeeAssetList: Record ZYNEmployeeAssetList;
                        TempRec: Record ZYNEmployeeAssetList temporary;
                    begin
                        TempRec.DeleteAll();

                        ZYNAssetsList.Reset();
                        if ZYNAssetsList.FindSet() then
                            repeat
                                ZYNEmployeeAssetList.Reset();
                                ZYNEmployeeAssetList.SetRange("serial no", ZYNAssetsList."Serial No");

                                if ZYNEmployeeAssetList.FindLast() then
                                    if ZYNEmployeeAssetList.Status = ZYNEmployeeAssetList.Status::Assigned then begin
                                        TempRec := ZYNEmployeeAssetList;
                                        TempRec.Insert();
                                    end;
                            until ZYNAssetsList.Next() = 0;

                        Page.RunModal(Page::ZYNEmployeeAssetsList, TempRec);
                    end;
                }
            }
        }
    }

    var
        AssignedAssets: Integer;
        ZYNEmployeeAssetList: Record ZYNEmployeeAssetList;

    trigger OnAfterGetCurrRecord()
    var
        ZYNAssetsList: Record ZYNAssetsList;
        ZYNEmployeeAssetList: Record ZYNEmployeeAssetList;
    begin
        AssignedAssets := 0;

        ZYNAssetsList.Reset();
        if ZYNAssetsList.FindSet() then
            repeat
                ZYNEmployeeAssetList.Reset();
                ZYNEmployeeAssetList.SetRange("serial no", ZYNAssetsList."Serial No");
                if ZYNEmployeeAssetList.FindLast() then begin
                    if ZYNEmployeeAssetList.Status = ZYNEmployeeAssetList.Status::Assigned then
                        AssignedAssets += 1;
                end;
            until ZYNAssetsList.Next() = 0;
    end;
}
