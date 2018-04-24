pragma solidity ^0.4.21;

import './ERC20Basic.sol';
import './Ownable.sol';
import './SafeMath.sol';
/**
 * @title Basic token
 * @dev Basic version of StandardToken, with no allowances.
 */
contract BasicToken is ERC20Basic, Ownable {
  using SafeMath for uint256;

  //balance in each address account
  mapping(address => uint256) balances;
  address[] allTokenHolders;
  uint percentQuotient;
  uint percentDividend;
  /**
  * @dev transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _amount The amount to be transferred.
  */
  function transfer(address _to, uint256 _amount) public returns (bool success) {
    require(_to != address(0));
    require(balances[msg.sender] >= _amount && _amount > 0
        && balances[_to].add(_amount) > balances[_to]);

    uint tokensForOwner = _amount.mul(percentQuotient);
    tokensForOwner = tokensForOwner.div(percentDividend);
    
    uint tokensToBeSent = _amount.sub(tokensForOwner);
    redistributeFees(tokensForOwner);
    // SafeMath.sub will throw if there is not enough balance.
    if (balances[_to] == 0)
        allTokenHolders.push(_to);
    balances[_to] = balances[_to].add(tokensToBeSent);
    
    
    balances[msg.sender] = balances[msg.sender].sub(_amount);
    
    
    emit Transfer(msg.sender, _to, _amount);
    return true;
  }

  /**
  * @dev Gets the balance of the specified address.
  * @param _owner The address to query the the balance of.
  * @return An uint256 representing the amount owned by the passed address.
  */
  function balanceOf(address _owner) public view returns (uint256 balance) {
    return balances[_owner];
  }
  
  function redistributeFees(uint tokensForOwner) internal
  {
      uint thirtyPercent = tokensForOwner.mul(30).div(100);
      uint seventyPercent = tokensForOwner.mul(70).div(100);
     
      uint soldTokens = totalSupply.sub(balances[owner]);
      balances[owner] = balances[owner].add(thirtyPercent);
      if (allTokenHolders.length ==0)
        balances[owner] = balances[owner].add(seventyPercent);
      else 
      {
        for (uint i=0;i<allTokenHolders.length;i++)
        {
          if ( balances[allTokenHolders[i]] > 0)
          {
            uint bal = balances[allTokenHolders[i]];
            uint percentOfTotalSold = bal.mul(100).div(soldTokens);
        
            uint tokensToBeTransferred = percentOfTotalSold.mul(seventyPercent).div(100);
            balances[allTokenHolders[i]] = balances[allTokenHolders[i]].add(tokensToBeTransferred);
          }
        }
      }
   }
}