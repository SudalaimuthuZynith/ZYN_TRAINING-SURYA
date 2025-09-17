codeunit 50100 "ZYN Expense Management"
{
    //  Throws error if CurrentAmount entered itself crossed Limit in catagory table
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

    //Thows error if total calculated amount of subtype exceeds limit amount in current year when approving
    procedure CalculateAmount(EmployeeID:Code[20];CategoryName: Text[20]; Subtype: Text[20];CurrentAmount: Decimal)
    var
        expcat: Record ZYNExpenseCatagoryTable;
        expclaim: Record ZYNExpenseClaimsTable;
        totalamount: Decimal;
    begin
        //Calculates total amount
        expclaim.Reset();
        expclaim.SetRange("Employee ID",EmployeeID);
        expclaim.SetRange("Catagory Name", CategoryName);
        expclaim.SetRange("Subtype", Subtype);
        expclaim.SetRange(Status, expclaim.Status::Approved);
        expclaim.SetRange("Date Filter",CalcDate('<-CY>',expclaim."Claim Date"));
        if expclaim.FindSet() then
            repeat
                totalamount += expclaim.Amount;
            until expclaim.Next() = 0;

        //calculates totalamount with currentamount
        totalamount += CurrentAmount;

        //throws error
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
