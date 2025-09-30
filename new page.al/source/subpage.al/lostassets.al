page 50152 LostAssetsPage
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
                    var
                        AssetRec: Record ZYNAssetsList;
                        HistRec: Record ZYNEmployeeAssetList;
                        TempRec: Record ZYNEmployeeAssetList temporary;
                    begin

                        TempRec.DeleteAll();

                        AssetRec.Reset();
                        if AssetRec.FindSet() then
                            repeat
                                HistRec.Reset();
                                HistRec.SetRange("serial no", AssetRec."Serial No");

                                if HistRec.FindLast() then
                                    if HistRec.Status = HistRec.Status::lost then begin
                                        TempRec := HistRec;
                                        TempRec.Insert();
                                    end;
                            until AssetRec.Next() = 0;

                        Page.RunModal(Page::ZYNEmployeeAssetsList, TempRec);
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
    var
        AssetRec: Record ZYNAssetsList;
        HistRec: Record ZYNEmployeeAssetList;
    begin
        AssignedAssets := 0;

        AssetRec.Reset();
        if AssetRec.FindSet() then
            repeat
                HistRec.Reset();
                HistRec.SetRange("serial no", AssetRec."Serial No");
                if HistRec.FindLast() then begin
                    if HistRec.Status = HistRec.Status::lost then
                        AssignedAssets += 1;
                end;
            until AssetRec.Next() = 0;
    end;
}
