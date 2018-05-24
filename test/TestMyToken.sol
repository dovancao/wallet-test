pragma solidity ^0.4.23;

import "truffle/Assert.sol";
import "../contracts/MyToken.sol";

contract TestMyToken {

    MyToken private _myToken;
    address private _owner;

    function TestMyToken() public{
        _owner = msg.sender;
    }

    function beforeEach() public {
        _myToken = new MyToken();
    }

    function test_constructor() public {
        uint allocatedTokens = _myToken.balanceOf(this);
        Assert.equal(allocatedTokens, 100000,"contract creator should hold 10000 tokens");
    }

    function test_transfer_withValidAmount() public {
        _myToken.transfer(_owner,1000);
        uint transferredTokens = _myToken.balanceOf(_owner);
        uint allocatedTokens = _myToken.balanceOf(this);
        Assert.equal(transferredTokens, 1000, "Recipient should hold 100 token");
        Assert.equal(allocatedTokens, 99000, "creator should hol 9900 token");
    }

    function test_transfer_withInvalidAmount() public {
        bool transferSuccessful = _myToken.transfer(_owner,10001);
        Assert.equal(transferSuccessful, false, "address should not be able to transfer more tokens than allocated");
    }

}
