page 50125 "role Center"
{
    PageType = RoleCenter;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Role Center Page';
    layout
    {
        area(RoleCenter)
        {
            part(mycuse; 50107)
            {
                ApplicationArea = All;
            }
            part(Subscriptions; ZYN_ActiveSubscriptionsPage)
            {
                ApplicationArea = All;
            }
            part(RevenueGeneratedPage; ZYN_RevenueGeneratedPage)
            {
                ApplicationArea = all;
            }

        }
    }
    actions
    {
        area(Sections)
        {
            group("My Navigations")
            {

                action(Customers)
                {
                    ApplicationArea = all;
                    RunObject = page "Customer List";
                    Caption = 'Customer';
                    Image = Customer;

                }
            }
            group("Employye Managment")
            {
                action(AssetList)
                {
                    ApplicationArea = all;
                    RunObject = page ZYNAssetsList;

                    Image = FixedAssetLedger;
                }
                action(AssetType)
                {
                    ApplicationArea = all;
                    RunObject = page ZYNAssetTypeList;
                    Image = FixedAssets;
                }
                action(EmployeeAsset)
                {
                    ApplicationArea = all;
                    RunObject = page ZYNEmployeeAssetsList;

                    Image = Employee;
                }
            }
            group(Expense)
            {
                action(ExpenseList)
                {
                    ApplicationArea = all;
                    RunObject = page ZYNExpenseList;
                    Image = LedgerEntries;
                }
                action(ExpenseCatagoryList)
                {
                    ApplicationArea = all;
                    RunObject = page ZYNExpenseCatagory;
                    Image = Ledger;
                }
            }
            group(Income)
            {
                action(IncomeList)
                {
                    ApplicationArea = all;
                    RunObject = page IncomeListPage;
                    Image = Sales;
                }
                action(IncomeCatagoryList)
                {
                    ApplicationArea = all;
                    RunObject = page IncomeCatagoryPage;
                    Image = Purchase;
                }
            }
            group(Budget)
            {
                action(BudgetList)
                {
                    ApplicationArea = all;
                    RunObject = page ZYNBudgetList;
                    Image = LedgerBudget;
                }

            }
            group(Attendace)
            {
                action(EmployeeList)
                {
                    ApplicationArea = all;
                    RunObject = page ZYNEmployeeList;
                    Image = Employee;
                }
                action(LeaveCatagoryList)
                {
                    ApplicationArea = all;
                    RunObject = page IncomeCatagoryPage;
                    Image = ApplyEntries;
                }
                action(LeaveRequestList)
                {
                    ApplicationArea = all;
                    RunObject = page ZYNLeaveRequestList;
                    Image = ListPage;
                }
            }
            group(SubscriptionManagment)
            {
                action(Plans)
                {
                    ApplicationArea = all;
                    RunObject = page ZYN_PlanListPage;
                    Image = LedgerBudget;
                }
                action(Subscrptions)
                {
                    ApplicationArea = all;
                    RunObject = page ZYN_SubscriptionListPage;
                    Image = LedgerBudget;
                }

            }
        }
    }

}

