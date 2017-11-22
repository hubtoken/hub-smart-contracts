pragma solidity ^0.4.18;

contract HubToken {
    /* This creates an array with all balances */
    mapping (address => uint256) public balanceOf;
    address public sourceAccount;
    
    /* Initializes contract with initial supply tokens to the account specified */
    function HubToken(
        address account,
        uint256 initialSupply
        ) public {
        
        sourceAccount = account;
        balanceOf[account] = initialSupply;
    }

    /* Send tokens */
    function transfer(address _from, address _to, uint256 _value) public {
        require(balanceOf[_from] >= _value);           
        require(balanceOf[_to] + _value >= balanceOf[_to]); 
        balanceOf[_from] -= _value;                    
        balanceOf[_to] += _value;                           
    }
    
    function transfer(address _to, uint256 _value) public {
        transfer(msg.sender, _to, _value);
    }
}
