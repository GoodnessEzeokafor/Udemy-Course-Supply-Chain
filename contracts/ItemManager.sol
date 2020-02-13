pragma solidity ^0.6.0;

import "./Ownable.sol";
import "./Item.sol";


contract ItemManager is Ownable{
    enum SupplyChainState{Created, Paid, Delivered}
    mapping (uint=>S_Item)public items;
    uint public itemIndex = 0;

    struct S_Item{
        Item _item;
        string _identifier;
        uint _itemPrice;
        ItemManager.SupplyChainState _state;
    }

    event SupplyChainStep(uint _itemIndex, uint _step, address _itemAddress);
    function createItem(
            string memory _identifier, 
            uint _itemPrice) public onlyOwner{
        Item item = new Item(this, _itemPrice, itemIndex);
        items[itemIndex]._item = item;
        items[itemIndex]._identifier = _identifier;
        items[itemIndex]._itemPrice = _itemPrice;
        items[itemIndex]._state = SupplyChainState.Created;
        // trigger event
        itemIndex++;
        emit SupplyChainStep(itemIndex, uint(items[itemIndex]._state), address(item));
    }

    function triggerPayment(uint _itemIndex) public payable onlyOwner{
        require(items[_itemIndex]._itemPrice == msg.value, "Only full paymeants accepted");
        require(items[_itemIndex]._state == SupplyChainState.Created, "Item is further in the chain");
        items[_itemIndex]._state = SupplyChainState.Paid;
                // trigger event
        emit SupplyChainStep(itemIndex, uint(items[itemIndex]._state), address(items[itemIndex]._item));

    }
    function triggerDelivery(uint _itemIndex) public{
        require(items[_itemIndex]._state == SupplyChainState.Paid, "Item has been paid in the chain");
        items[_itemIndex]._state = SupplyChainState.Delivered;
        // trigger event
        emit SupplyChainStep(itemIndex, uint(items[itemIndex]._state), address(items[itemIndex]._item));

    }
}