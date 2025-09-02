// codeunit 50128 insertlog
// {
//     [EventSubscriber(ObjectType::Table, database::Customer, OnAfterModifyEvent, '', true, true)]
//     procedure call(var Rec: Record Customer)
//     var
//         myPublishermess: Codeunit mupublisher;
//     begin
  
//         myPublishermess.onaftercustomercreation(Rec.Name);
//     end;
// }