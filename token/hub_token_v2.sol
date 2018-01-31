pragma solidity ^0.4.18;

/* -----------------------------------------  */
/* HubTokenV2 Contract - Loosely based on the ERC223 standard */

contract HubTokenV2 {
    using SafeMath for uint;
    
    /* This creates an array with all balances */
    mapping (address => uint256) public balanceOf;
    
    /* Address that holds initial initial supply  */
    address public sourceAccount;
    
    /* Event fired when token is transfered   */
    event Transfer(address indexed from, address indexed to, uint value, bytes data);
    
    /* Initializes contract with initial supply tokens to the account specified */
    function HubToken(address account, uint256 initialSupply) public {
        sourceAccount = account;
        balanceOf[account] = initialSupply;
    }
    
    /*  Transfer tokens to an address (user or contract).   
        Optionally pass in data for the receiving contract
    */
    function transfer(address _to, uint _value, bytes _data) public {
        require(balanceOf[msg.sender] >= _value);           
        require(balanceOf[_to] + _value >= balanceOf[_to]); 
        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
        balanceOf[_to] = balanceOf[_to].add(_value);
        
        // Check to see if address is a contract
        uint codeLength;
        assembly {
            // Retrieve the size of the code on target address, this needs assembly .
            codeLength := extcodesize(_to)
        }
        
        if(codeLength>0) {
            // Call tokenFallback() on Contract to handle the incoming tokens
            // If ReceivingContract doesn't implement tokenFallback, the transaction will fail.
            ReceivingContract receiver = ReceivingContract(_to);
            receiver.tokenFallback(msg.sender, _value, _data);
        }
        
        Transfer(msg.sender, _to, _value, _data);
    }
    
    
    /*  Transfer tokens to an address (user or contract) without any extra data */   
    function transfer(address _to, uint256 _value) public {
        transfer(_to, _value, "");
    }
}

/*  -----------------------------------------  */  
/*  ReceivingContract interface  */  
contract ReceivingContract { 
    function tokenFallback(address _from, uint _value, bytes _data) public;
}

/*  -----------------------------------------  */
/* Math operations with safety checks */
 
library SafeMath {
  function mul(uint a, uint b) internal pure returns (uint) {
    uint c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint a, uint b) internal pure returns (uint) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint a, uint b) internal pure returns (uint) {
    assert(b <= a);
    return a - b;
  }

  function add(uint a, uint b) internal pure returns (uint) {
    uint c = a + b;
    assert(c >= a);
    return c;
  }

  function max64(uint64 a, uint64 b) internal pure returns (uint64) {
    return a >= b ? a : b;
  }

  function min64(uint64 a, uint64 b) internal pure returns (uint64) {
    return a < b ? a : b;
  }

  function max256(uint256 a, uint256 b) internal pure returns (uint256) {
    return a >= b ? a : b;
  }

  function min256(uint256 a, uint256 b) internal pure returns (uint256)  {
    return a < b ? a : b;
  }
}
