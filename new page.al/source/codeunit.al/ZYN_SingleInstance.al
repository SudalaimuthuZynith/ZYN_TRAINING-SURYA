codeunit 50111 Zyn_SingleInstanceManagment
{
    SingleInstance = true;

    var
        FromCreateAs: Boolean;

    internal procedure SetFromCreateAs()
    begin
        FromCreateAs := true;
    end;

    internal procedure GetFromCreateAs(): Boolean
    begin
        exit(FromCreateAs);
    end;

    internal procedure ClearCreateAs()
    begin
        Clear(FromCreateAs);
    end;
}