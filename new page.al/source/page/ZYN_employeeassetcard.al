page 50185 ZYNEmployeeAssetsCard
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = ZYNEmployeeAssetList;
    Caption = 'Employee Assets Card';

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
                        AssetRec: Record ZYNAssetsList;
                    begin
                        if AssetRec.Get(Rec."serial no") then begin

                            if (CalcDate('<-5Y>', WorkDate) > AssetRec."Procured Date") then
                                Error('This asset is older than 5 years and cannot be assigned.');

                            // if not AssetRec.Available then
                            //     Error('This asset is already lost or unavailable.');
                        end;
                    end;
                }
                field("Asset Type"; Rec."Asset Type")
                 {
                  }
                field(status; Rec.status)
                {
                    trigger OnValidate()

                    var
                        AssetRec: Record ZYNAssetsList;
                    begin
                        UpdateEditableFields();
                        AssetRec.Reset();
                        AssetRec.SetRange("Serial No", Rec."serial no");
                        if AssetRec.FindFirst() then begin
                            case Rec.Status of
                                Rec.Status::Assigned:
                                    AssetRec.Available := false;
                                Rec.Status::Returned:
                                    AssetRec.Available := true;
                                Rec.Status::Lost:
                                    AssetRec.Available := false;
                            end;
                            AssetRec.Modify();
                        end;

                    end;
                }
                field("Assigned Date"; Rec."Assigned Date")
                {
                    trigger OnValidate()
                    var
                        AssetRec: Record ZYNAssetsList;
                    begin
                        AssetRec.Reset();
                        AssetRec.SetRange("Serial No", Rec."serial no");
                        if AssetRec.FindFirst() then begin
                            if Rec."Assigned Date" > CalcDate('<+5Y>', AssetRec."Procured Date") then
                                Error('This asset is older than 5 years and cannot be assigned.');
                        end;
                    end;
                }

                field("Returned date date"; Rec."Returned Date")
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

    var
        ReturnDateEditable: Boolean;
        LostDateEditable: Boolean;
        OtherAsset: Record ZYNEmployeeAssetList;
        AssetRec: Record ZYNAssetsList;


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

                    if Rec."serial no" = '' then
                        Error('Serial No. must be entered.');

                    AssetRec.Reset();
                    AssetRec.SetRange("Serial No", Rec."serial no");
                    if not AssetRec.FindFirst() then
                        Error('Asset with Serial No %1 not found.', Rec."serial no");

                    // If Available = false → check why
                    if not AssetRec.Available then begin
                        // Error('This asset is marked as Lost and cannot be assigned.');
                        OtherAsset.Reset();
                        OtherAsset.SetRange("serial no", Rec."serial no");
                        OtherAsset.SetRange(Status, OtherAsset.Status::Assigned);
                        OtherAsset.SetFilter("Employee", '<>%1', Rec."Employee");
                        if OtherAsset.FindFirst() then
                            Error('This asset is already assigned to %1 and not available.', OtherAsset."Employee");

                        // Case 2: Marked as Lost in history
                        OtherAsset.Reset();
                        OtherAsset.SetRange("serial no", Rec."serial no");
                        OtherAsset.SetRange(Status, OtherAsset.Status::Lost);
                        if OtherAsset.FindFirst() then
                            Error('This asset is marked as Lost and cannot be assigned.');
                    end;
                end;
            Rec.Status::returned:
                begin
                    ReturnDateEditable := true;
                    LostDateEditable := false;
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

                end;
        // else begin
        //     ReturnDateEditable := true;
        //     LostDateEditable := true;
        // end;
        end;
        CurrPage.Update(false);
    end;
}