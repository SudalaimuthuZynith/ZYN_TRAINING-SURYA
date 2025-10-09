page 50157 ZYN_ReturnedAssets
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
                field(ReturnedAssets; ReturnedAssets)
                {
                    Caption = 'Returned Assets';
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
                                    if ZYNEmployeeAssetList.Status = ZYNEmployeeAssetList.Status::returned then begin
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
        ReturnedAssets: Integer;
        ZYNEmployeeAssetList: Record ZYNEmployeeAssetList;

    trigger OnAfterGetCurrRecord()
    var
        ZYNAssetsList: Record ZYNAssetsList;
        ZYNEmployeeAssetList: Record ZYNEmployeeAssetList;
    begin
        ReturnedAssets := 0;

        ZYNAssetsList.Reset();
        if ZYNAssetsList.FindSet() then
            repeat
                ZYNEmployeeAssetList.Reset();
                ZYNEmployeeAssetList.SetRange("serial no", ZYNAssetsList."Serial No");
                if ZYNEmployeeAssetList.FindLast() then begin
                    if ZYNEmployeeAssetList.Status = ZYNEmployeeAssetList.Status::returned then
                        ReturnedAssets += 1;
                end;
            until ZYNAssetsList.Next() = 0;
    end;
}
