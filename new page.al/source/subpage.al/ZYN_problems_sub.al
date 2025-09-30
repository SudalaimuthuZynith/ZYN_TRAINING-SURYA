page 50138 sub_problems
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = ZYNProblems;
    layout
    {
        area(Content)
        {
            repeater(subproblems)
            {
                field(cust_id; Rec.cust_id)
                {

                }
                field(cust_name; Rec.cust_name)
                {

                }
                field(phone_no; Rec.phone_no)
                {

                }
                field(problems; Rec.problems)
                {

                }
                field(description; Rec.description)
                {

                }
            }
        }
    }


}