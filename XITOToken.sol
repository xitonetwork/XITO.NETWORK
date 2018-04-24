pragma solidity ^0.4.21;

import './BurnableToken.sol';
import './SafeMath.sol';

/**
 * @title XITO Token
 * @dev Token representing USDX.
 */
 contract XITOToken is BurnableToken {
     string public name ;
     string public symbol ;
     uint8 public decimals = 18 ;
     
     /**
     *@dev users sending ether to this contract will be reverted. Any ether sent to the contract will be sent back to the caller
     */
     function ()public payable {
         revert();
     }
     
     /**
     * @dev Constructor function to initialize the initial supply of token to the creator of the contract
     */
     function XITOToken(
            address wallet
         ) public {
         owner = wallet;
         totalSupply = 100000000000;
         totalSupply = totalSupply.mul( 10 ** uint256(decimals)); //Update total supply with the decimal amount
         name = "XITO";
         symbol = "USDX";
         balances[wallet] = totalSupply;
         percentQuotient = 3;
         percentDividend = 1000;
         
         //Emitting transfer event since assigning all tokens to the creator also corresponds to the transfer of tokens to the creator
         emit Transfer(address(0), msg.sender, totalSupply);
     }
     
     /**
     *@dev helper method to get token details, name, symbol and totalSupply in one go
     */
    function getTokenDetail() public view returns (string, string, uint256) {
	    return (name, symbol, totalSupply);
    }
    
    function setFee(uint _percentQuotient, uint _percentDividend) public onlyOwner
    {
        percentQuotient = _percentQuotient;
        percentDividend = _percentDividend;
    }
 }