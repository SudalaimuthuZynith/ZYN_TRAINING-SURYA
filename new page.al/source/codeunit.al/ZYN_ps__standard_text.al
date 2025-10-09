codeunit 50122 "Extended Text Handler"
{
    // procedure LoadExtendedTextLines(SalesHeader: Record "Sales Header")
    // var
    //     ExtTextLine: Record "Extended Text Line";
    //     CustomExtText: Record "ExtendedTextTable";
    //     CustomerRec: Record Customer;
    //     LangCode: Code[10];
    // begin
    //     CustomExtText.SetRange("Document No.", SalesHeader."No.");
    //     CustomExtText.SetRange(selection, CustomExtText.selection::"begin text");
    //     CustomExtText.DeleteAll();
    //     if CustomerRec.Get(SalesHeader."Sell-to Customer No.") then
    //         LangCode := CustomerRec."Language Code";
    //     ExtTextLine.SetRange("No.", SalesHeader.beginning);
    //     ExtTextLine.SetRange("Language Code", LangCode);
    //     if ExtTextLine.FindSet() then begin
    //         repeat
    //             CustomExtText.Init();
    //             CustomExtText."Document No." := SalesHeader."No.";
    //             CustomExtText."Document Type" := SalesHeader."Document Type";
    //             CustomExtText."Lino No." := ExtTextLine."Line No.";
    //             CustomExtText."Text" := ExtTextLine.Text;
    //             CustomExtText.selection := CustomExtText.selection::"begin text";
    //             CustomExtText.Insert(true);
    //         until ExtTextLine.Next() = 0;
    //     end;
    // end;

    // procedure LoadExtendedText(SalesHeader: Record "Sales Header")
    // var
    //     ExtTextLine: Record "Extended Text Line";
    //     CustomExtText: Record "ExtendedTextTable";
    //     CustomerRec: Record Customer;
    //     LangCode: Code[10];
    // begin
    //     CustomExtText.SetRange("Document No.", SalesHeader."No.");
    //     CustomExtText.SetRange(selection, CustomExtText.selection::"end text");
    //     CustomExtText.DeleteAll();

    //     if CustomerRec.Get(SalesHeader."Sell-to Customer No.") then
    //         LangCode := CustomerRec."Language Code";
    //     ExtTextLine.SetRange("No.", SalesHeader.ending);
    //     ExtTextLine.SetRange("Language Code", LangCode);
    //     if ExtTextLine.FindSet() then begin
    //         repeat
    //             CustomExtText.Init();
    //             CustomExtText."Document No." := SalesHeader."No.";
    //             CustomExtText."Document Type" := SalesHeader."Document Type";
    //             CustomExtText."Lino No." := ExtTextLine."Line No.";
    //             CustomExtText."Text" := ExtTextLine.Text;
    //             CustomExtText.selection := CustomExtText.selection::"end text";
    //             CustomExtText.Insert();
    //         until ExtTextLine.Next() = 0;
    //     end;
    // end;
    procedure LoadExtendedTextGeneric(SalesHeader: Record "Sales Header"; StandardTextCode: Code[200]; Selection: Enum selection)
    var
        ExtTextLine: Record "Extended Text Line";
        CustomExtText: Record ZYN_ExtendedTextTable;
        CustomerRec: Record Customer;
        LangCode: Code[10];
    begin
        CustomExtText.SetRange("Document No.", SalesHeader."No.");
        CustomExtText.SetRange(selection, Selection);
        CustomExtText.DeleteAll();

        if CustomerRec.Get(SalesHeader."Sell-to Customer No.") then
            LangCode := CustomerRec."Language Code";

        ExtTextLine.SetRange("No.", StandardTextCode);
        ExtTextLine.SetRange("Language Code", LangCode);

        if ExtTextLine.FindSet() then begin
            repeat
                CustomExtText.Init();
                CustomExtText."Document No." := SalesHeader."No.";
                CustomExtText."Document Type" := SalesHeader."Document Type";
                CustomExtText."Lino No." := ExtTextLine."Line No.";
                CustomExtText."Text" := ExtTextLine.Text;
                CustomExtText.selection := Selection;
                CustomExtText.Insert(true);
            until ExtTextLine.Next() = 0;
        end;
    end;



    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnAfterSalesInvHeaderInsert, '', true, true)]
    // procedure HandlePostedInvoiceText(var SalesInvHeader: Record "Sales Invoice Header"; SalesHeader: Record "Sales Header")
    // var
    //     PostedExtendedTextTable: Record ExtendedTextTable;
    //     ExtendedTextTable: Record ExtendedTextTable;
    //     ExtendLine: Record "Extended Text Line";
    //     SelectionEnum: Enum selection;
    //     StandardTextCode: Code[20];
    //     CustomerRec: Record Customer;
    //     LangCode: Code[10];
    //     i: Integer;
    // begin

    //     SalesInvHeader.beginning_text := SalesHeader.beginning;
    //     SalesInvHeader.end_text := SalesHeader.ending;

    //     if SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice then begin

    //         for i := 1 to 2 do begin
    //             case i of
    //                 1:
    //                     SelectionEnum := SelectionEnum::"begin text";
    //                 2:
    //                     SelectionEnum := SelectionEnum::"end text";
    //             end;


    //             ExtendedTextTable.Reset();
    //             ExtendedTextTable.SetRange("Document No.", SalesHeader."No.");
    //             ExtendedTextTable.SetRange(selection, SelectionEnum);

    //             if ExtendedTextTable.FindSet() then begin
    //                 repeat
    //                     PostedExtendedTextTable.Init();
    //                     PostedExtendedTextTable.TRANSFERFIELDS(ExtendedTextTable);
    //                     PostedExtendedTextTable."Document No." := SalesInvHeader."No.";
    //                     PostedExtendedTextTable."Document Type" := PostedExtendedTextTable."Document Type"::"posted sales invoice";
    //                     PostedExtendedTextTable.Insert();
    //                 until ExtendedTextTable.Next() = 0;
    //             end;


    //             ExtendedTextTable.Reset();
    //             ExtendedTextTable.SetRange("Document No.", SalesHeader."No.");
    //             ExtendedTextTable.SetRange(selection, SelectionEnum);
    //             ExtendedTextTable.DeleteAll();
    //         end;
    //     end else begin
    //         if CustomerRec.Get(SalesHeader."Sell-to Customer No.") then
    //             LangCode := CustomerRec."Language Code";


    //         for i := 1 to 2 do begin
    //             case i of
    //                 1:
    //                     begin
    //                         SelectionEnum := SelectionEnum::"begin text";
    //                         StandardTextCode := SalesHeader."begin order";
    //                     end;
    //                 2:
    //                     begin
    //                         SelectionEnum := SelectionEnum::"end text";
    //                         StandardTextCode := SalesHeader."end order";
    //                     end;
    //             end;
    //             PostedExtendedTextTable.Reset();
    //             PostedExtendedTextTable.SetRange("Document No.", SalesInvHeader."No.");
    //             PostedExtendedTextTable.SetRange(Selection, SelectionEnum);
    //             PostedExtendedTextTable.DeleteAll();

    //             ExtendLine.Reset();
    //             ExtendLine.SetRange("No.", StandardTextCode);
    //             ExtendLine.SetRange("Language Code", LangCode);

    //             if ExtendLine.FindSet() then begin
    //                 repeat
    //                     PostedExtendedTextTable.Init();
    //                     PostedExtendedTextTable."Document No." := SalesInvHeader."No.";
    //                     PostedExtendedTextTable."Document Type" := PostedExtendedTextTable."Document Type"::"posted sales invoice";
    //                     PostedExtendedTextTable."Lino No." := ExtendLine."Line No.";
    //                     PostedExtendedTextTable."Language Code" := LangCode;
    //                     PostedExtendedTextTable."Text" := ExtendLine."Text";
    //                     PostedExtendedTextTable."Selection" := SelectionEnum;
    //                     PostedExtendedTextTable.Insert(true);
    //                 until ExtendLine.Next() = 0;
    //             end;
    //         end;
    //     end;
    // end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnAfterSalesCrMemoHeaderInsert, '', true, true)]
    procedure HandlePostedcreditText(var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; WhseShip: Boolean; WhseReceive: Boolean; var TempWhseShptHeader: Record "Warehouse Shipment Header"; var TempWhseRcptHeader: Record "Warehouse Receipt Header")
    var
        PostedExtendedTextTable: Record ZYN_ExtendedTextTable;
        ExtendedTextTable: Record ZYN_ExtendedTextTable;
        SelectionEnum: Enum selection;
        i: Integer;
    begin
        SalesCrMemoHeader.beginning_text := SalesHeader.beginning;
        SalesCrMemoHeader.end_text := SalesHeader.ending;

        for i := 1 to 2 do begin
            case i of
                1:
                    SelectionEnum := SelectionEnum::"begin text";
                2:
                    SelectionEnum := SelectionEnum::"end text";
            end;

            ExtendedTextTable.Reset();
            ExtendedTextTable.SetRange("Document No.", SalesHeader."No.");
            ExtendedTextTable.SetRange(selection, SelectionEnum);

            if ExtendedTextTable.FindSet() then begin
                repeat
                    PostedExtendedTextTable.Init();
                    PostedExtendedTextTable.TRANSFERFIELDS(ExtendedTextTable);
                    PostedExtendedTextTable."Document No." := SalesCrMemoHeader."No.";
                    PostedExtendedTextTable."Document Type" := PostedExtendedTextTable."Document Type"::"posted sales credit memo";
                    PostedExtendedTextTable.Insert();
                until ExtendedTextTable.Next() = 0;
            end;

            ExtendedTextTable.Reset();
            ExtendedTextTable.SetRange("Document No.", SalesHeader."No.");
            ExtendedTextTable.SetRange(selection, SelectionEnum);
            ExtendedTextTable.DeleteAll();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order", OnAfterInsertSalesOrderHeader, '', true, true)]
    procedure HandlePostedsalesquotwText(var SalesOrderHeader: Record "Sales Header"; SalesQuoteHeader: Record "Sales Header")
    var
        PostedExtendedTextTable: Record ZYN_ExtendedTextTable;
        ExtendedTextTable: Record ZYN_ExtendedTextTable;
        SelectionEnum: Enum selection;
        i: Integer;
    begin
        SalesOrderHeader.beginning := SalesQuoteHeader.beginning;
        SalesOrderHeader.ending := SalesQuoteHeader.ending;

        for i := 1 to 2 do begin
            case i of
                1:
                    SelectionEnum := SelectionEnum::"begin text";
                2:
                    SelectionEnum := SelectionEnum::"end text";
            end;

            ExtendedTextTable.Reset();
            ExtendedTextTable.SetRange("Document No.", SalesQuoteHeader."No.");
            ExtendedTextTable.SetRange(selection, SelectionEnum);

            if ExtendedTextTable.FindSet() then begin
                repeat
                    PostedExtendedTextTable.Init();
                    PostedExtendedTextTable.TRANSFERFIELDS(ExtendedTextTable);
                    PostedExtendedTextTable."Document No." := SalesOrderHeader."No.";
                    PostedExtendedTextTable."Document Type" := PostedExtendedTextTable."Document Type"::"posted sales credit memo";
                    PostedExtendedTextTable.Insert();
                until ExtendedTextTable.Next() = 0;
            end;

            ExtendedTextTable.Reset();
            ExtendedTextTable.SetRange("Document No.", SalesQuoteHeader."No.");
            ExtendedTextTable.SetRange(selection, SelectionEnum);
            ExtendedTextTable.DeleteAll();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnAfterSalesInvHeaderInsert, '', true, true)]
    procedure HandlePostedInvoice(var SalesInvHeader: Record "Sales Invoice Header"; SalesHeader: Record "Sales Header")
    var
        PostedExtendedTextTable: Record ZYN_ExtendedTextTable;
        ExtendedTextTable: Record ZYN_ExtendedTextTable;
        ExtendLine: Record "Extended Text Line";
        SelectionEnum: Enum selection;
        StandardTextCode: Code[20];
        CustomerRec: Record Customer;
        LangCode: Code[10];
        i: Integer;
    begin
        SalesInvHeader.beginning_text := SalesHeader.beginning;
        SalesInvHeader.end_text := SalesHeader.ending;
        for i := 1 to 2 do begin
            case i of
                1:
                    begin
                        SelectionEnum := SelectionEnum::"begin text";
                        StandardTextCode := SalesHeader."begin order";
                    end;
                2:
                    begin
                        SelectionEnum := SelectionEnum::"end text";
                        StandardTextCode := SalesHeader."end order";
                    end;
            end;
            if SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice then begin
                ExtendedTextTable.Reset();
                ExtendedTextTable.SetRange("Document No.", SalesHeader."No.");
                ExtendedTextTable.SetRange(selection, SelectionEnum);

                if ExtendedTextTable.FindSet() then begin
                    repeat
                        PostedExtendedTextTable.Init();
                        PostedExtendedTextTable.TRANSFERFIELDS(ExtendedTextTable);
                        PostedExtendedTextTable."Document No." := SalesInvHeader."No.";
                        PostedExtendedTextTable."Document Type" := PostedExtendedTextTable."Document Type"::"posted sales invoice";
                        PostedExtendedTextTable.Insert();
                    until ExtendedTextTable.Next() = 0;
                end;

                ExtendedTextTable.Reset();
                ExtendedTextTable.SetRange("Document No.", SalesHeader."No.");
                ExtendedTextTable.SetRange(selection, SelectionEnum);
                ExtendedTextTable.DeleteAll();
            end else begin
                if CustomerRec.Get(SalesHeader."Sell-to Customer No.") then
                    LangCode := CustomerRec."Language Code";
                PostedExtendedTextTable.Reset();
                PostedExtendedTextTable.SetRange("Document No.", SalesInvHeader."No.");
                PostedExtendedTextTable.SetRange(Selection, SelectionEnum);
                PostedExtendedTextTable.DeleteAll();

                ExtendLine.Reset();
                ExtendLine.SetRange("No.", StandardTextCode);
                ExtendLine.SetRange("Language Code", LangCode);

                if ExtendLine.FindSet() then begin
                    repeat
                        PostedExtendedTextTable.Init();
                        PostedExtendedTextTable."Document No." := SalesInvHeader."No.";
                        PostedExtendedTextTable."Document Type" := PostedExtendedTextTable."Document Type"::"posted sales invoice";
                        PostedExtendedTextTable."Lino No." := ExtendLine."Line No.";
                        PostedExtendedTextTable."Language Code" := LangCode;
                        PostedExtendedTextTable."Text" := ExtendLine."Text";
                        PostedExtendedTextTable."Selection" := SelectionEnum;
                        PostedExtendedTextTable.Insert(true);
                    until ExtendLine.Next() = 0;
                end;
            end;
        end;
    end;
}

// [EventSubscriber(ObjectType::Codeunit, codeunit::"Sales-Post", OnAfterSalesInvHeaderInsert, '', true, true)]
// procedure postedinvoicebegin(var SalesInvHeader: Record "Sales Invoice Header"; SalesHeader: Record "Sales Header")
// var
//     PostedExtendedTextTable: Record ExtendedTextTable;
//     ExtendedTextTable: Record ExtendedTextTable;
// begin

// SalesInvHeader.beginning_text := SalesHeader.beginning;

// ExtendedTextTable.SetRange("Document No.", SalesHeader."No.");
// ExtendedTextTable.SetRange(selection, ExtendedTextTable.selection::"begin text");

// if ExtendedTextTable.FindSet() then begin
//     repeat
//         PostedExtendedTextTable.Init();
//         PostedExtendedTextTable."Document No." := SalesInvHeader."No.";
//         PostedExtendedTextTable."Document Type" := PostedExtendedTextTable."Document Type"::"posted sales invoice";
//         PostedExtendedTextTable."Language code" := ExtendedTextTable."Language code";
//         PostedExtendedTextTable."Lino No." := ExtendedTextTable."Lino No.";
//         PostedExtendedTextTable.selection := PostedExtendedTextTable.selection::"begin text";
//         PostedExtendedTextTable.Text := ExtendedTextTable.Text;
//         PostedExtendedTextTable.Insert();
//     until ExtendedTextTable.Next() = 0;
// end;

// // Now safely delete them after copying
// ExtendedTextTable.SetRange("Document No.", SalesHeader."No.");
// ExtendedTextTable.SetRange(selection, ExtendedTextTable.selection::"begin text");
// ExtendedTextTable.DeleteAll();
// end;

// [EventSubscriber(ObjectType::Codeunit, codeunit::"Sales-Post", OnAfterSalesInvHeaderInsert, '', true, true)]
// procedure postedinvoice(var SalesInvHeader: Record "Sales Invoice Header"; SalesHeader: Record "Sales Header")
// var
//     PostedExtendedTextTable: Record ExtendedTextTable;
//     ExtendedTextTable: Record ExtendedTextTable;
// begin
//     SalesInvHeader.end_text := SalesHeader.ending;

//     ExtendedTextTable.SetRange("Document No.", SalesHeader."No.");
//     ExtendedTextTable.SetRange(selection, ExtendedTextTable.selection::"end text");

//     if ExtendedTextTable.FindSet() then begin
//         repeat
//             PostedExtendedTextTable.Init();
//             PostedExtendedTextTable."Document No." := SalesInvHeader."No.";
//             PostedExtendedTextTable."Document Type" := PostedExtendedTextTable."Document Type"::"posted sales invoice";
//             PostedExtendedTextTable."Language code" := ExtendedTextTable."Language code";
//             PostedExtendedTextTable."Lino No." := ExtendedTextTable."Lino No.";
//             PostedExtendedTextTable.selection := PostedExtendedTextTable.selection::"end text";
//             PostedExtendedTextTable.Text := ExtendedTextTable.Text;
//             PostedExtendedTextTable.Insert();
//         until ExtendedTextTable.Next() = 0;
//     end;

//     
//     ExtendedTextTable.SetRange("Document No.", SalesHeader."No.");
//     ExtendedTextTable.SetRange(selection, ExtendedTextTable.selection::"end text");
//     ExtendedTextTable.DeleteAll();
// end;

