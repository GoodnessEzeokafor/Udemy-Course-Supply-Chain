pragma solidity ^0.6.0;
import "./ItemManager.sol";

contract Item{
    uint public priceInWei;
    uint public index;
    uint public pricePaid;
    ItemManager parentContract;

    constructor(ItemManager, uint _priceInWei, uint _index) public{
           priceInWei = _priceInWei;
           index = _index;
           parentContract = parentContract;
    }
    receive() external payable{
        require(pricePaid ==0, "Item is paid already");
        require(priceInWei == msg.value, "Only full payment allowed");
        pricePaid += msg.value;
       (bool success, )  = address(parentContract).call.value(msg.value)(abi.encodeWithSignature("triggerPayment(uint256)", index));
       require(success,"The Transaction wasn't successful, canceling");
    }
    fallback() external {}
 }
