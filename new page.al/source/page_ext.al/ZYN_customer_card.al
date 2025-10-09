pageextension 50135 CustomerCardExt extends "Customer Card"
{
    layout
    {
        addfirst(factboxes)
        {
            part(cutomer; ZYN_Factbox)
            {
                SubPageLink = "No." = field("No.");
                ApplicationArea = all;
            }
            // part("INVOICECOUNT"; "INVOICECOUNT")
            // {
            //     ApplicationArea = all;
            // }
        }
    }
    actions
    {
        addlast(Processing)
        {
            action(modifiedlog)
            {
                ApplicationArea = All;
                Caption = 'modified log';
                Image = View;
                trigger OnAction()
                var
                    modifiedlog: Record ZYNlog;

                begin
                    modifiedlog.Init();
                    modifiedlog.SetRange(customer_no, Rec."No.");
                    Page.RunModal(PAGE::ZYNlog, modifiedlog);
                end;


            }
        }

        addlast(Processing)
        {
            action(VisitLog)
            {
                ApplicationArea = All;
                Caption = 'Visit Log';
                Image = View;
                trigger OnAction()
                var
                    visitlogrec: Record ZYN_Visitlog;
                begin
                    visitlogrec.Init();
                    visitlogrec.SetRange(CustomerNo, Rec."No.");
                    Page.RunModal(PAGE::ZYN_VisitLoglist, visitlogrec);
                end;


            }
        }
        addlast(Processing)
        {
            action(Raise_Problem)
            {
                ApplicationArea = All;
                Caption = 'raise_problem';
                Image = View;
                trigger OnAction()
                var
                    problemrec: Record ZYNProblems;
                    customerrec: Record Customer;
                begin
                    customerrec.Get(Rec."No.");
                    problemrec.Init();
                    problemrec.cust_id := customerrec."No.";
                    problemrec.cust_name := customerrec.Name;
                    problemrec.phone_no := customerrec."Phone No.";
                    problemrec.Insert();
                    Page.Run(Page::ZYNProblemsCard, problemrec);
                end;
            }
            action("Send To Slave")
            {
                ApplicationArea = all;
                Caption = 'Send to';
                Image = SendTo;
                trigger OnAction()
                var
                    zyncompany: Record ZYN_Company;
                begin
                    if PAGE.RunModal(Page::ZYN_Company, zyncompany) = ACTION::LookupOK then begin

                    end;
                    ;
                end;
            }
        }

    }

    var
        isNewCustomer: Boolean;

    trigger OnOpenPage()
    begin
        if Rec."No." = '' then
            isNewCustomer := true;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if isNewCustomer and (Rec.Name = '') then begin
            Message('Please enter a customer name');
            exit(false)
        end;
        exit(true)
    end;

    trigger OnClosePage()
    Var
        publisher: Codeunit mupublisher;
    begin
        if isNewCustomer and (Rec.Name <> '') then begin
            publisher.onaftercustomercreation(Rec.Name);
            publisher.onaftercustomerc(Rec);
        end;
    end;
}

