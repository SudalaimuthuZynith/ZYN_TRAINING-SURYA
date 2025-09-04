tableextension 50112 salesheaderext extends "Sales Header"
{
    fields
    {
        // field(50100; beginning; code[200])
        // {
        //     Caption = 'beginning_text';
        //     DataClassification = CustomerContent;
        //     TableRelation = "Standard Text".Code;
        //     trigger OnValidate()
        //     var
        //         SalesHeaderRec: Record "Sales Header";
        //         ExtTextHandler: Codeunit "Extended Text Handler";

        //     begin
        //         SalesHeaderRec := Rec;
        //         ExtTextHandler.LoadExtendedTextLines(SalesHeaderRec);
        //     end;
        // }
        // field(50101; ending; code[200])
        // {
        //     Caption = 'ending_text';
        //     DataClassification = CustomerContent;
        //     TableRelation = "Standard Text".Code;
        //     trigger OnValidate()
        //     var
        //         SalesHeaderRec: Record "Sales Header";
        //         ExtTextHandler: Codeunit "Extended Text Handler";
        //     begin
        //         SalesHeaderRec := Rec;
        //         ExtTextHandler.LoadExtendedText(SalesHeaderRec);
        //     end;
        // }
        // field(50100; beginning; Code[200])
        // {
        //     Caption = 'beginning_text';
        //     DataClassification = CustomerContent;
        //     TableRelation = "Standard Text".Code;
        //     trigger OnValidate()
        //     var
        //         ExtTextHandler: Codeunit "Extended Text Handler";
        //     begin
        //         ExtTextHandler.LoadExtendedTextGeneric(Rec, Rec.beginning, Rec.selection::"begin text");
        //     end;
        // }

        // field(50101; ending; Code[200])
        // {
        //     Caption = 'ending_text';
        //     DataClassification = CustomerContent;
        //     TableRelation = "Standard Text".Code;
        //     trigger OnValidate()
        //     var
        //         ExtTextHandler: Codeunit "Extended Text Handler";
        //     begin
        //         ExtTextHandler.LoadExtendedTextGeneric(Rec, Rec.ending, Rec.selection::"end text");
        //     end;
        // }

        field(50100; beginning; Code[200])
        {
            Caption = 'beginning_text';
            DataClassification = CustomerContent;
            TableRelation = "Standard Text".Code;
            trigger OnValidate()
            var
                ExtTextHandler: Codeunit "Extended Text Handler";
                Selection: Enum selection;
            begin
                Selection := Selection::"begin text";
                ExtTextHandler.LoadExtendedTextGeneric(Rec, Rec.beginning, Selection);
            end;
        }

        field(50101; ending; Code[200])
        {
            Caption = 'ending_text';
            DataClassification = CustomerContent;
            TableRelation = "Standard Text".Code;
            trigger OnValidate()
            var
                ExtTextHandler: Codeunit "Extended Text Handler";
                Selection: Enum selection;
            begin
                Selection := Selection::"end text";
                ExtTextHandler.LoadExtendedTextGeneric(Rec, Rec.ending, Selection);
            end;
        }
        field(1000; "begin order"; Code[200])
        {
            Caption = 'beginning_invoice';
            DataClassification = CustomerContent;
            TableRelation = "Standard Text".Code;
            // trigger OnValidate()
            // var
            //     ExtTextHandler: Codeunit "Extended Text Handler";
            //     Selection: Enum selection;
            // begin
            //     Selection := Selection::"begin text";
            //     ExtTextHandler.LoadExtendedTextGeneric(Rec, Rec.beginning, Selection);
            // end;
        }
        field(1001; "end order"; code[200])

        {
            Caption = 'ending_invoice';
            DataClassification = CustomerContent;
            TableRelation = "Standard Text".Code;
            // trigger OnValidate()
            // var
            //     ExtTextHandler: Codeunit "Extended Text Handler";
            //     Selection: Enum selection;
            // begin
            //     Selection := Selection::"end text";
            //     ExtTextHandler.LoadExtendedTextGeneric(Rec, Rec.ending, Selection);
            // end;
        }
        field(5010; "From Subscription"; Boolean)
        {
            Caption = 'From Subscription';
            DataClassification = ToBeClassified;
        }


    }
    trigger OnDelete()
    var
        ExtendedTextTable: Record ExtendedTextTable;
    begin
        ExtendedTextTable.SetRange("Document Type", Rec."Document Type");
        ExtendedTextTable.SetRange("Document No.", Rec."No.");
        if not ExtendedTextTable.IsEmpty then
            ExtendedTextTable.DeleteAll();

    end;
}