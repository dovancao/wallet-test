pragma solidity ^0.4.23;

import "./ERC20.sol";
import "./SafeMath.sol";
import "./Token.sol";
import "./ERC223ReceivingContract.sol";

contract CTKCrowdSale is ERC223ReceivingContract {

    using SafeMath for uint;
    Token private token;

    //address where funds are collected
    address public wallet;

    // rate of token per wei
    uint256 public rate = 0.07 ether;
    uint private _limit = 1 ether;

    //amount of ether raised
    uint256 public etherRaised;

    // if not enough gas for transaction so prevent user from sending ether
    function() public payable {
        revert();
    }

    // limits of purchaser
    mapping (address => uint) private _limits;

    modifier limitOfPurchase(address beneficiary){
        require(_limit > _limits[beneficiary]);
        _;
    }

    event TokenPurchase (address indexed purchaser, address indexed beneficiary, uint256 amount, uint256 value);
    event tokenAmountReceived(uint amountReceived);
    event TokenTransfering(address purchaser, uint amountOfTokens);

    // _rate number of token unit a buyer gete per wei
    // _wallet address where collected funds wwill be forwared to
    // _token address of token being sold

    constructor(uint256 _rate, address _wallet, Token _token){
        require(_rate > 0);
        require(_wallet != address(0));
        require(_token != address(0));
         rate = _rate;
        wallet = _wallet;
        token = _token;
    }

    // buy for


        // valid puchaser, and puchaser had valid weiAmount
    function _preValidatePurchase(address _beneficiary, uint256 _etherAmount) internal{
        require(_beneficiary != address(0));
        require(_etherAmount !=0);
    }

    // so luong token se mua
    function _getTokenAmount(uint256 _etherAmount) internal view returns (uint256) {
        if(_etherAmount > _limit) revert();
        return _etherAmount.mul(rate);
    }

    function buyTokens(address _beneficiary) public limitOfPurchase(_beneficiary) payable {
        uint etherAmount = msg.value;
        // xac dinh nguoi mua co ton tai khong va wei phai lon hon 0
        _preValidatePurchase(_beneficiary, etherAmount);

        // so token nguoi mua se mua duoc
        uint amounts = _getTokenAmount(etherAmount);

        // chuyen token cho _beneficiary
        token.transfer(_beneficiary, amounts);

        // raise limit cua nguoi mua
        _limits[_beneficiary] = _limits[_beneficiary].add(amounts);

        emit TokenPurchase(msg.sender, _beneficiary, etherAmount, amounts);
    }

    // chuyen token cho nguoi mua
    function _deliverTokens (address _beneficiary, uint256 _tokenAmount) internal {
        token.transfer(_beneficiary, _tokenAmount);
        emit TokenTransfering(_beneficiary, _tokenAmount);
    }


}

