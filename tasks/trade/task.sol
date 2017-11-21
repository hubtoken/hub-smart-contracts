pragma solidity ^0.4.18;

//import "browser/HubToken.sol";

contract Trade {
    
    address hubTokenAddress = 0x581444C094E6231B70bDb7E903dA149479cF0B01;
    
    struct Offer {
        uint stake;
        bytes32 description;
    }
    
    mapping (address => Offer) public offers;
    
    /* can't iterate over a mapping. storing user addresses in an array */
    address[] public users;
    
    function makeOffer(address user, uint256 stake, bytes32 description) public {
        users.push(user);
        offers[user].stake = stake;
        offers[user].description = description;
        
        /* hold the tokens in the contract till close */
        //transferTokens(user, this, stake);  
    }
    
    function close() pure public {
        /*
        for (uint i=0; i<users.length; i++) {
            address user = users[i];
            uint stake = offers[user].stake;
            transferTokens(this, user, stake);
        }*/
    }
    
    /*
    function transferTokens(address from, address to, uint value) private {
        HubToken hubToken = HubToken(hubTokenAddress);
        hubToken.transfer(from, to, value);
    }
    */
}
