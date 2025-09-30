codeunit 50129 mysubscriber
{

    [EventSubscriber(ObjectType::Codeunit, codeunit::mupublisher, onaftercustomercreation, '', false, false)]
    procedure check(customer: text)

    begin
        Message('new customer   %1', customer);
    end;

    // [EventSubscriber(ObjectType::Codeunit, codeunit::mupublisher, onaftercustomerc, '', false, false)]
    // procedure check2(var Rec: Record Customer)
    // var
    //     transfercust: Record Customer;
    // begin
    //     transfercust.ChangeCompany('Mr.Surya');
    //     if not transfercust.Get(Rec."No.") then begin
    //         transfercust.Init();
    //         transfercust.TransferFields(Rec);
    //         transfercust.Insert();
    //     end;
    // end;

}

