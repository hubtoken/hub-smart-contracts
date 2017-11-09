pragma solidity ^0.4.18;

contract LunchOrder 
{
    address requestor;
    uint requestor_stake;
    uint requestor_bounty;
    uint requestor_loan;
    string requestor_terms;

    address runner;
    uint runner_stake;

    bool delivery_accepted;
    bool payment_accepted;

    string delivery_rejection_reason;
    string payment_rejection_reason;

    function LunchOrder(uint stake, uint bounty, uint loan, string terms) public
    {
        requestor = msg.sender;
        requestor_stake = stake;
        requestor_bounty = bounty;
        requestor_loan = loan;
        requestor_terms = terms;
    }

    function acceptOrder(uint stake) public          
    {
        runner = msg.sender;
        runner_stake = stake;
    }
    
    function acceptDelivery() public
    {
        if( msg.sender == requestor )
            delivery_accepted = true;
    }

    function acceptPayment() public
    {
        if( msg.sender == runner )
            payment_accepted = true;
    }

    function rejectDelivery( string reason ) public
    {
        if( msg.sender == requestor )
            delivery_rejection_reason = reason;
    }

    function rejectPayment( string reason ) public
    {
        if( msg.sender == runner )
            payment_rejection_reason = reason;
    }
    
    function kill() public
    { 
        if (msg.sender == requestor)  
            selfdestruct(requestor);
    }
}