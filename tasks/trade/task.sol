pragma solidity ^0.4.18;

/* Note this is like an abstract interface */
contract HubToken {
    function transfer(address _from, address _to, uint256 _value) public { }
}

contract Trade {
    
    /* address where ERC20 token is deployed */
    address constant hubTokenAddress = 0x581444C094E6231B70bDb7E903dA149479cF0B01;
    
    enum Stages {
        AcceptingOffers,
        Closed
    }
    
    Stages public stage = Stages.AcceptingOffers;
    
    struct Offer {
        uint stake;
        bytes32 description;
    }
    
    modifier atStage(Stages _stage) {
        require(stage == _stage);
        _;
    }
    
    mapping (address => Offer) public offers;
    
    /* can't iterate over a mapping. storing user addresses in an array */
    address[] public users;
    
    function makeOffer(address user, uint256 stake, bytes32 description) atStage(Stages.AcceptingOffers) public {
        users.push(user);
        offers[user].description = description;
        
        /* hold user's tokens in the contract till close */
        if(stake > offers[user].stake) {
            transferTokens(user, this, stake - offers[user].stake);
        } 
        
        /* user has updated stake to lesser than what originally offered */
        else if (stake < offers[user].stake){
            transferTokens(this, user, offers[user].stake - stake);
        }
            
        offers[user].stake = stake;
    }
    
    function close() public atStage(Stages.AcceptingOffers) {
        for (uint i=0; i<users.length; i++) {
            address user = users[i];
            uint stake = offers[user].stake;
            transferTokens(this, user, stake);
        }
    }
    
    function transferTokens(address from, address to, uint value) private {
        HubToken hubTokenContract = HubToken(hubTokenAddress);
        return hubTokenContract.transfer(from, to, value);
    
        /*
        The following approach doesn't need the abi, but its not recommended
        if(!hubTokenAddress.call(bytes4(keccak256("transfer(address _from, address _to, uint256 _value)")), from, to, value)) {
           revert(); 
        }*/
    }
    
}