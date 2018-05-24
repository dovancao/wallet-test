pragma solidity ^0.4.21;

contract Token {

    string internal _symbol;
    string internal _name;

    uint8 internal _decimals;
    uint internal _totalSupply;

    mapping (address => uint) internal _balanceOf;
    mapping (address => mapping (address => uint)) internal _allowances;

    function Token() public {
        _symbol = "CTK";
        _name = "Cut Token";
        _decimals = 0;
        _totalSupply = 100000;
        _balanceOf[msg.sender] = _totalSupply;
    }

    function name()
    public
    view
    returns (string) {
        return _name;
    }

    function symbol()
    public
    view
    returns (string) {
        return _symbol;
    }

    function decimals()
    public
    view
    returns (uint8) {
        return _decimals;
    }

    function totalSupply()
    public
    view
    returns (uint) {
        return _totalSupply;
    }

    function balanceOf(address _addr) external view returns (uint);
    function transfer(address _to, uint _value) external returns (bool success);
    event Transfer(address indexed _from, address indexed _to, uint _value);
}