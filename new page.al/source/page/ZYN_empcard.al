page 50174 ZYNEmployeeCard
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = ZYNEmployee;
    Caption = 'Employee Card';

    layout
    {
        area(Content)
        {
            group(Group)
            {
                field("Employee ID"; Rec."Employee ID")
                {
                }
                field("Employee Name"; Rec."Employee Name")
                {
                }
                field(Department; Rec.Department)
                {
                }
                field(Role; Rec.Role)
                {
                }
            }
        }

    }
}