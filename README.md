# Wallet-test (Online Wallet)
We create an online wallet to test "Set Function" with Lightwallet and Hooked-Web3-provider


If it is succeed, main function of wallet will be:
* Generate address and private key with user's password.
* Receive ETH and auto convert to X Token, keep X Token after crowsale ended.
* Send X Token to another wallet.


Main Contract Folder contains
```
CTKCrowdsale.sol , Mytoken.sol, ERC20.sol, ERC233.sol, SafeMath.sol, Token.sol
```

# Built With

* [LightWallet](https://github.com/ConsenSys/eth-lightwallet): Create seed, address and sign transaction
* [Hooked-Web3-Provider](https://github.com/ConsenSys/hooked-web3-provider): Allow to "hook in" an external transaction signer
* [Web3js](https://github.com/ethereum/web3.js/) : This is the Ethereum compatible JavaScript API

# About And Installing

1, Installed tools

```
npm install lightwallet
npm install hooked-web3-provider
```

The eth-lightwallet package contains /js/lightwallet.min.js that can be included in an HTML page
The hooked-web3-provider  package contains /js/hooked-web3-provider.min.js that can be included in an HTML page
```
The file /js/lightwallet.min.js exposes the global object lightwallet to the browser
The file /js/hooked-web3-provider.min.js hook-in an external signer
```

2, We ran ETH dev to start full node on http://localhost:8545

```
 geth --dev --rpc --rpccorsdomain "*" --rpcaddr "0.0.0.0" --rpcport
"8545" --mine --unlock=0
```

3, Contract was tested with lightwallet. It was deployed on [REMIX ETHEREUM](https://remix.ethereum.org/)

```
contract SendTransaction {
        address owner;
        
        struct Person{
            bytes16 firstName;
            bytes16 lastName;
        }
    
    mapping (address => Person) personOFAdress;
    
    event newInformation(bytes16 firstName, bytes16 lastName);
       
    function SendTransaction()public {
        owner = msg.sender;    
    }
    function getInfo(address _owner) view public returns (bytes16, bytes16){
        return (personOFAdress[_owner].firstName, personOFAdress[_owner].lastName);
    }    
    function setInfo(address _owner, bytes16 _firstName, bytes16 _lastName) public {
        personOFAdress[_owner].firstName = _firstName;
        personOFAdress[_owner].lastName = _lastName;
    }   
}
````

4. Create a nodejs server (app.js file)
```
const express = require('express');
var app = express();

app.use(express.static("public"));

app.get("/", function(req,res){
    res.sendFile(__dirname +"/public/html/index.html");
});

app.listen(4500, function(err){
    if(err) console.log(err);
    else console.log("server is up!");
});

```


The default BIP32 HD derivation path has been m/0'/0'/0'

# Thing is done

```
GenerateSeed using LightWallet
```

```
Generate Address using LightWallet
```

