page 50185 EmployeeAssetsCardPage
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = EmployeeAssetListTable;
    //CardPageId=AssetsCardtPage;

    layout
    {
        area(Content)
        {
            group(general)
            {
                field(Employee; Rec.Employee)
                {

                }
                field("serial no"; Rec."serial no")
                {
                    trigger OnValidate()
                    var
                        AssetRec: Record AssetsListTable;
                    begin
                        if AssetRec.Get(Rec."serial no") then begin

                            if (CalcDate('<-5Y>', WorkDate) > AssetRec."Procured Date") then
                                Error('This asset is older than 5 years and cannot be assigned.');

                            if not AssetRec.Available then
                                Error('This asset is already lost or unavailable.');
                        end;
                    end;
                }
                field("Asset Type"; Rec."Asset Type") { }
                field(status; Rec.status)
                {
                    trigger OnValidate()
                    var
                    begin
                        UpdateEditableFields();

                    end;

                }
                field("Assigned Date"; Rec."Assigned Date")
                {
                    trigger OnValidate()
                    var
                        AssetRec: Record AssetsListTable;
                    begin
                        AssetRec.Reset();
                        AssetRec.SetRange("Serial No", Rec."serial no");
                        if AssetRec.FindFirst() then begin


                            if Rec."Assigned Date" > CalcDate('<+5Y>', AssetRec."Procured Date") then
                                Error('This asset is older than 5 years and cannot be assigned.');


                            // if not AssetRec.Available then
                            //     Error('This asset is already lost or unavailable.');
                        end;
                    end;
                }

                field("Returned date date"; Rec."Returned date date")
                {
                    Editable = ReturnDateEditable;
                }
                field("Lost date"; Rec."Lost date")
                {
                    Editable = LostDateEditable;
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
        ReturnDateEditable: Boolean;
        LostDateEditable: Boolean;
        OtherAsset: Record EmployeeAssetListTable;
        AssetRec: Record AssetsListTable;
        NewAssetRec: Record EmployeeAssetListTable;

    trigger OnAfterGetCurrRecord()
    begin
        UpdateEditableFields();
    end;

    local procedure UpdateEditableFields()
    begin
        case Rec.Status of
            Rec.Status::Assigned:
                begin
                    ReturnDateEditable := false;
                    LostDateEditable := false;
                    OtherAsset.Reset();
                    OtherAsset.SetRange("serial no", Rec."serial no");
                    OtherAsset.SetRange(Status, OtherAsset.Status::Assigned);
                    if OtherAsset.FindFirst() then begin
                        if (OtherAsset."Employee" <> Rec."Employee") then
                            Error('This asset is already assigned to another employee.');
                    end;

                    AssetRec.Reset();
                    AssetRec.SetRange("Serial No", Rec."serial no");
                    if AssetRec.FindFirst() then begin
                       

                        AssetRec.Available := false;
                        AssetRec.Modify();
                    end;
                end;
            Rec.Status::returned:
                begin
                    ReturnDateEditable := true;
                    LostDateEditable := false;
                    AssetRec.Reset();
                    AssetRec.SetRange("Serial No", Rec."serial no");
                    if AssetRec.FindFirst() then begin
                        AssetRec.Available := true;
                        AssetRec.Modify();
                    end;
                    OtherAsset.Reset();
                    OtherAsset.SetRange("serial no", Rec."serial no");
                    OtherAsset.SetRange(Status, OtherAsset.Status::Assigned);
                    if Rec."Assigned Date" = 0D then
                        Rec."Assigned Date" := OtherAsset."Assigned date";

                end;
            Rec.Status::Lost:
                begin
                    ReturnDateEditable := false;
                    LostDateEditable := true;
                    AssetRec.Reset();
                    AssetRec.SetRange("Serial No", Rec."serial no");
                    if AssetRec.FindFirst() then begin
                        AssetRec.Available := false;
                        AssetRec.Modify();
                    end;
                end;
            else begin
                ReturnDateEditable := true;
                LostDateEditable := true;
            end;
        end;
        CurrPage.Update(false);
    end;






    // local procedure PrefillAssignedDateFromHistory()
    // var
    //     Hist: Record EmployeeAssetListTable;
    // begin
    //     if Rec."Assigned Date" <> 0D then
    //         exit;

    //     Hist.Reset();
    //     Hist.SetRange("serial no", Rec."serial no");

    //     Hist.SetRange(Status, Hist.Status::Assigned);


    //     Hist.SetCurrentKey("serial no", "Assigned Date");
    //     if Hist.FindLast() then

    //         Rec.Validate("Assigned Date", Hist."Assigned Date");
    // end;
}