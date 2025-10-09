page 50152 ZYN_LostAssets
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
                    Caption = 'Lost Assets';
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
                                    if ZYNEmployeeAssetList.Status = ZYNEmployeeAssetList.Status::lost then begin
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
                    if ZYNEmployeeAssetList.Status = ZYNEmployeeAssetList.Status::lost then
                        AssignedAssets += 1;
                end;
            until ZYNAssetsList.Next() = 0;
    end;
}
