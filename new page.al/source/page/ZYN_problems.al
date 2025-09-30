page 50110 ZYNProblemsCard
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = ZYNProblems;
    Caption='Problems Card';

    layout
    {
        area(Content)
        {
            group(Problem)
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
                field(tech_id; Rec.tech_id)
                {
                    TableRelation = technicians.tech_id where(problems = field(problems));
                }
            }
        }
    }
}