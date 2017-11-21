pragma solidity ^0.4.18;

contract HubToken {
    /* This creates an array with all balances */
    mapping (address => uint256) public balanceOf;
    address public sourceAccount;
    
    /* Initializes contract with initial supply tokens to the creator of the contract */
    function HubToken(
        address account,
        uint256 initialSupply
        ) public {
        
        /*Not working*/
        /*balanceOf[msg.sender] = initialSupply;*/
        
        sourceAccount = account;
        balanceOf[account] = initialSupply;
    }

    /* Send coins */
    function transfer(address _to, uint256 _value) public {
        require(balanceOf[msg.sender] >= _value);           
        require(balanceOf[_to] + _value >= balanceOf[_to]); 
        balanceOf[msg.sender] -= _value;                    
        balanceOf[_to] += _value;                           
    }
    
    function getBalance(address account) public view returns (uint256 res) {
        return balanceOf[account];
    }
}
