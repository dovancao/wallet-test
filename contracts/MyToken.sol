pragma solidity ^0.4.21;

import "./Token.sol";
import "./ERC20.sol";
import "./SafeMath.sol";
import "./ERC223.sol";
import "./ERC223ReceivingContract.sol";

contract MyToken is Token, ERC223, ERC20{

    Token private token;

    using SafeMath for uint256;

    mapping (address =>uint) internal _balanceOf;
    mapping (address => mapping(address => uint)) internal _allowances;


    function balanceOf(address _owner) public view returns(uint){
        return _balanceOf[_owner];
    }

    //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
    function isContract(address _addr) private view returns (bool is_contract) {
        uint length;
        assembly {
        //retrieve the size of the code on target address, this needs assembly
            length := extcodesize(_addr)
        }
        return (length>0);
    }

    function transfer(address _to, uint _value) public returns (bool){
        return transfer(_to, _value, "");
    }

    function transfer(address _to, uint _value, bytes _data) public returns (bool){
        if(_value>0 && _balanceOf[msg.sender] >= _value){
            if(isContract(_to)){
                ERC223ReceivingContract _contract = ERC223ReceivingContract(_to);
                _contract.tokenFallback(msg.sender,_value, _data);
            }
            _balanceOf[msg.sender] = _balanceOf[msg.sender].sub(_value);
            _balanceOf[_to] = _balanceOf[_to].add(_value);
            emit Transfer(msg.sender, _to, _value, _data);
            return true;
        } else{
            return false;
        }
    }

    function transferFrom(address _from, address _to, uint _value) public returns (bool) {
        return transferFrom(_from, _to, _value,"");
    }

    function transferFrom(address _from, address _to, uint _value, bytes _data) public returns (bool) {
        if(_value >0 &&
        _allowances[_from][msg.sender]>= _value &&
        _balanceOf[_from] >= _value){
            if(isContract(_to)){
                ERC223ReceivingContract _contract = ERC223ReceivingContract(_to);
                _contract.tokenFallback(msg.sender,_value, _data);
            }
            _balanceOf[_from] = _balanceOf[_from].sub(_value);
            _balanceOf[_to] = _balanceOf[_to].add(_value);
            emit Transfer(_from, _to, _value);
            return true;
        }
        return false;
    }

    function approve(address _spender, uint _value)
    public
    returns (bool){
        if(_balanceOf[msg.sender]>= _value){
            _allowances[msg.sender][_spender] = _value;
            emit Approval(msg.sender, _spender, _value);
            return true;
        }
        return false;
    }

    function allowance(address _owner, address _spender) public view returns (uint)
    {
        if(_allowances[_owner][_spender]< _balanceOf[_owner]){
            return _allowances[_owner][_spender];
        }
        return _balanceOf[_owner];
    }

    // standard function transfer similar to erc20 transfer without no data

    //    function transfer(address _to, uint _value) public returns (bool success){
    //        bytes memory empty;
    //        if(isContract(_to)){
    //            return transferToContract(_to,_value, empty);
    //        }else{
    //            return transfereToAddress(_to,_value, empty);
    //        }
    //    }
    //
    //    function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success){
    //        if(_balanceOf[msg.sender] < _value) revert();
    //        _balanceOf[msg.sender] = sub(_balanceOf[msg.sender],tokens);
    //        _balanceOf[_to] = add(_balanceOf[_to], tokens);
    //        Transfer(msg.sender, _to, _value, _data);
    //        return true;
    //    }
    //
    //    function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
    //        if(_balanceOf[msg.sender] < _value) revert();
    //        _balanceOf[msg.sender] = sub(_balanceOf[msg.sender],tokens);
    //        _balanceOf[_to] = add(_balanceOf[_to], tokens);
    //
    //        Transfer(msg.sender, _to, _value, _data);
    //        return true;
    //    }
    // dont accept eth
    function() public payable {
        revert();
    }

}

