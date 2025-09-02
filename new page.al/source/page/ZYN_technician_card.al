page 50118 tech_card
{
    PageType = card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = technicians;

    layout
    {
        area(Content)
        {
            group(tech_list)
            {

                field(tech_id; Rec.tech_id)
                {

                }
                field(tech_name; Rec.tech_name) { }
                field(tech_phone_no; Rec.tech_phone_no) { }
                field(problems; Rec.problems)
                {
                    
                }

            }
        }
    }

    // actions
    // {
    //     area(Processing)
    //     {
    //         action(ActionName)
    //         {

    //             trigger OnAction()
    //             begin

    //             end;
    //         }
    //     }
    // }

    // var
    //     myInt: Integer;
}