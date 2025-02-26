table 40129 "GP PM20000"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; VCHRNMBR; Text[21])
        {
            DataClassification = CustomerContent;
        }
        field(2; VENDORID; Text[15])
        {
            DataClassification = CustomerContent;
        }
        field(3; DOCTYPE; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(4; DOCDATE; Date)
        {
            DataClassification = CustomerContent;
        }
        field(5; DOCNUMBR; Text[21])
        {
            DataClassification = CustomerContent;
        }
        field(7; CURTRXAM; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(15; DUEDATE; Date)
        {
            DataClassification = CustomerContent;
        }
        field(25; VOIDED; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(46; PYMTRMID; Text[21])
        {
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(Key1; DOCTYPE, VCHRNMBR)
        {
            Clustered = true;
        }

        key(Key2; DOCTYPE, CURTRXAM, VOIDED)
        {
        }
    }
}

