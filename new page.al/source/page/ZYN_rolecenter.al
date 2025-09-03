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
        }
    }
}