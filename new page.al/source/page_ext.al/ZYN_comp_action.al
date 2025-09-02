pageextension 50127 companypageect extends Companies
{
    actions
    {
        addlast(processing)
        {
            action(updatefield)
            {
                Caption = 'Update_Field';
                ApplicationArea = all;

                RunObject = page "Field Selection Page";
            }
        }

    }
}