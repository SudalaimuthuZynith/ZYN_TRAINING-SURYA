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
            part(Subscriptions; ActiveSubscriptionsPage)
            {
                ApplicationArea = All;
            }
            part(RevenueGeneratedPage; RevenueGeneratedPage)
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
                    RunObject = page AssetsListPage;

                    Image = FixedAssetLedger;
                }
                action(AssetType)
                {
                    ApplicationArea = all;
                    RunObject = page AssetTypeListPage;
                    Image = FixedAssets;
                }
                action(EmployeeAsset)
                {
                    ApplicationArea = all;
                    RunObject = page EmployeeAssetsListPage;

                    Image = Employee;
                }
            }
            group(Expense)
            {
                action(ExpenseList)
                {
                    ApplicationArea = all;
                    RunObject = page ExpenseListPage;
                    Image = LedgerEntries;
                }
                action(ExpenseCatagoryList)
                {
                    ApplicationArea = all;
                    RunObject = page ExpenseCatagoryPage;
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
                    RunObject = page BudgetListPage;
                    Image = LedgerBudget;
                }

            }
            group(Attendace)
            {
                action(EmployeeList)
                {
                    ApplicationArea = all;
                    RunObject = page EmployeeListPage;
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
                    RunObject = page LeaveRequestListPage;
                    Image = ListPage;
                }
            }
            group(SubscriptionManagment)
            {
                action(Plans)
                {
                    ApplicationArea = all;
                    RunObject = page PlanListPage;
                    Image = LedgerBudget;
                }
                action(Subscrptions)
                {
                    ApplicationArea = all;
                    RunObject = page SubscriptionListPage;
                    Image = LedgerBudget;
                }

            }
        }
    }
}