// codeunit 50116 newcompany
// {
//     [EventSubscriber(ObjectType::Table, database::Customer, OnAfterInsertEvent, '', false, false)]
//     procedure newcomp(var Rec: Record Customer)

//     begin
//         insert(Rec);
//     end;

//     [EventSubscriber(ObjectType::Table, database::Customer, OnAfterModifyEvent, '', false, false)]
//     procedure modifycomp(var Rec: Record Customer)

//     begin
//         insert(Rec);
//     end;

//     procedure insert(var Rec: Record Customer)
    // var
    //     transfercust: Record Customer;
    // begin
    //     transfercust.ChangeCompany('Mr.Surya');
    //     if not transfercust.Get(Rec."No.") then begin
    //         transfercust.Init();
    //         transfercust.TransferFields(Rec);
    //         transfercust.Insert();
    //     end else begin
    //         transfercust.TransferFields(Rec);
    //         transfercust.Modify(false);
    //     end;
    // end;


// }

