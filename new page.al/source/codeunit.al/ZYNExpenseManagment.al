codeunit 50100 "ZYN Expense Management"
{
    //  Throws error if CurrentAmount entered itself crossed Limit in catagory table
    procedure CheckAmountLimit(CategoryName: Text[20]; Subtype: Text[20]; CurrentAmount: Decimal)
    var
        ZYN_ExpenseCatagoryTable: Record ZYN_ExpenseCatagoryTable;
    begin
        ZYN_ExpenseCatagoryTable.Reset();
        ZYN_ExpenseCatagoryTable.SetRange(Catagory, CategoryName);
        ZYN_ExpenseCatagoryTable.SetRange(Name, Subtype);

        if ZYN_ExpenseCatagoryTable.FindFirst() then begin
            if CurrentAmount > ZYN_ExpenseCatagoryTable.Amount then
                Error(AmountLimitError, CategoryName, Subtype, CurrentAmount, ZYN_ExpenseCatagoryTable.Amount);
        end;
    end;

    //Thows error if total calculated amount of subtype exceeds limit amount in current year when approving
    procedure CalculateAmount(EmployeeID: Code[20]; CategoryName: Text[20]; Subtype: Text[20]; CurrentAmount: Decimal)
    var
        ZYNExpenseCatagoryTable: Record ZYN_ExpenseCatagoryTable;
        ZYN_ExpenseClaimsTable: Record ZYN_ExpenseClaimsTable;
        totalamount: Decimal;
    begin
        //Calculates total amount
        ZYN_ExpenseClaimsTable.Reset();
        ZYN_ExpenseClaimsTable.SetRange("Employee ID", EmployeeID);
        ZYN_ExpenseClaimsTable.SetRange("Catagory Name", CategoryName);
        ZYN_ExpenseClaimsTable.SetRange("Subtype", Subtype);
        ZYN_ExpenseClaimsTable.SetRange(Status, ZYN_ExpenseClaimsTable.Status::Approved);
        ZYN_ExpenseClaimsTable.SetRange("Date Filter", CalcDate('<-CY>', ZYN_ExpenseClaimsTable."Claim Date"));
        if ZYN_ExpenseClaimsTable.FindSet() then
            repeat
                totalamount += ZYN_ExpenseClaimsTable.Amount;
            until ZYN_ExpenseClaimsTable.Next() = 0;

        //calculates totalamount with currentamount
        totalamount += CurrentAmount;

        //throws error
        ZYNExpenseCatagoryTable.Reset();
        ZYNExpenseCatagoryTable.SetRange(Catagory, CategoryName);
        ZYNExpenseCatagoryTable.SetRange(Name, Subtype);

        if ZYNExpenseCatagoryTable.FindFirst() then begin
            if totalamount > ZYNExpenseCatagoryTable.Amount then
                Error(TotalAmountError, CategoryName, Subtype, ZYNExpenseCatagoryTable.Amount, totalamount);
        end;
    end;

    procedure Duplicate(EmployeeID: Code[20]; CategoryName: Text[20]; Subtype: Text[20]; billdate: Date; status: Enum claimstatus)
    var
        ZYN_ExpenseClaimsTable: Record ZYN_ExpenseClaimsTable;
    begin
        ZYN_ExpenseClaimsTable.SetRange("Employee ID", EmployeeID);
        ZYN_ExpenseClaimsTable.SetRange("Catagory Name", CategoryName);
        ZYN_ExpenseClaimsTable.SetRange(Subtype, Subtype);
        ZYN_ExpenseClaimsTable.SetRange("Bill Date", billdate);
        ZYN_ExpenseClaimsTable.SetRange(Status, status);
        if ZYN_ExpenseClaimsTable.FindFirst() then
            Error(DuplicateError);
    end;

    var
        AmountLimitError: Label 'Expense limit exceeded for Category %1 and Subtype %2. Current Amount: %3, Limit: %4';
        TotalAmountError: Label 'Limit Exceeded for Category %1 / Subtype %2. Allowed = %3, Current Total = %4';
        DuplicateError: Label 'This already exists, this is duplicate';
}
