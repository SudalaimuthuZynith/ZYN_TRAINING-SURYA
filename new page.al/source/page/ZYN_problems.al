page 50110 problems_page
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = problems;

    layout
    {
        area(Content)
        {
            group(Problem)
            {
                field(cust_id; Rec.cust_id)
                {
                    ApplicationArea = all;
                }
                field(cust_name; Rec.cust_name)
                {
                    ApplicationArea = all;
                }
                field(phone_no; Rec.phone_no)
                {
                    ApplicationArea = all;
                }
                field(problems; Rec.problems)
                {

                    ApplicationArea = all;
                }
                field(description; Rec.description)
                {

                }
                field(tech_id; Rec.tech_id)
                {
                    // TableRelation = "AllObjWithCaption"."Object ID" where("Object Type" = const(Table));
                    TableRelation = technicians.tech_id where(problems = field(problems));
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}