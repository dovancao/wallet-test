pragma solidity ^0.4.21;

interface ERC20 {
    function allowance(address _owner, address _spender) external view returns (uint);
    function approve(address _spender, uint _value) external returns (bool);
    function transferFrom(address _from, address _to, uint _value) external returns (bool);

    event Approval(address indexed _owner, address indexed _spender, uint _value);
}