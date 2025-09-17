codeunit 50100 "ZYN Expense Management"
{
    procedure CheckAmountLimit(CategoryName: Text[20]; Subtype: Text[20]; CurrentAmount: Decimal)
    var
        expcat: Record ZYNExpenseCatagoryTable;
    begin
        expcat.Reset();
        expcat.SetRange(Catagory, CategoryName);
        expcat.SetRange(Name, Subtype);

        if expcat.FindFirst() then begin
            if CurrentAmount > expcat.Amount then
                Error(
                  'Expense limit exceeded for Category %1 and Subtype %2. Current Amount: %3, Limit: %4',
                  CategoryName, Subtype, CurrentAmount, expcat.Amount);
        end;
    end;


    procedure CalculateAmount(CategoryName: Text[20]; Subtype: Text[20];CurrentAmount: Decimal)
    var
        expcat: Record ZYNExpenseCatagoryTable;
        expclaim: Record ZYNExpenseClaimsTable;
        totalamount: Decimal;
    begin
        
        expclaim.Reset();
        expclaim.SetRange("Catagory Name", CategoryName);
        expclaim.SetRange("Subtype", Subtype);
        expclaim.SetRange(Status, expclaim.Status::Approved);

        if expclaim.FindSet() then
            repeat
                totalamount += expclaim.Amount;
            until expclaim.Next() = 0;

        totalamount += CurrentAmount;
        expcat.Reset();
        expcat.SetRange(Catagory, CategoryName);
        expcat.SetRange(Name, Subtype);

        if expcat.FindFirst() then begin
            if totalamount > expcat.Amount then
                Error(
                    'Limit Exceeded for Category %1 / Subtype %2. Allowed = %3, Current Total = %4',
                    CategoryName, Subtype, expcat.Amount, totalamount);
        end;
    end;
}
