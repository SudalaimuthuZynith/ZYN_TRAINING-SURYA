page 50140 tech_list
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = tech_card;
    SourceTable = technicians;

    layout
    {
        area(Content)
        {
            group(tech_list)
            {
                repeater(general)
                {
                    field(tech_id; Rec.tech_id) { }
                    field(tech_name; Rec.tech_name) { }
                    field(tech_phone_no; Rec.tech_phone_no) { }
                    field(problems; Rec.problems) { }
                    field(count; Rec.count) { }
                }



            }
            part(problems_subpart; sub_problems)
            {
                SubPageLink = tech_id = field(tech_id);
                ApplicationArea = all;
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