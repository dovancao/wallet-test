# wallet-test
We create an online wallet to test "Set Function" with Lightwallet and Hooked-Web3-provider

If it is succeed, we run all smart contract in Contract Folder.

Contract Folder contains
```
CTKCrowdsale.sol , Mytoken.sol
```
# Used Tools
```
LightWallet
Hooked-Web3-Provider
```
# About
We ran ETH dev to start full node on http://localhost:8545
```
 geth --dev --rpc --rpccorsdomain "*" --rpcaddr "0.0.0.0" --rpcport
"8545" --mine --unlock=0
```
Contract is tested with lightwallet

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

The eth-lightwallet package contains /js/lightwallet.min.js that can be included in an HTML page
The hooked-web3-provider  package contains /js/hooked-web3-provider.min.js that can be included in an HTML page
```
The file /js/lightwallet.min.js exposes the global object lightwallet to the browser
The file /js/hooked-web3-provider.min.js exposes the global object lightwallet to the browser
```

The default BIP32 HD derivation path has been m/0'/0'/0'

# Thing is done

```
GenerateSeed using LightWallet
```

```
Generate Address using LightWallet
```

#Thing isn't done

We tried to sign transaction of contract but it was rejected

```
lightwallet.keystore.createVault({
        password: password,
        seedPhrase: seed,
        hdPathString: "m/0'/0'/0'"
    }, function(err, ks){
        ks.keyFromPassword(password, function(err,pwDerivedKey){
            if(err){
                document.getElementById("info").innerHTML = err;
            }
            else{
                ks.generateNewAddress(pwDerivedKey,5);
                let sendingAddr = ks.getAddresses()[0];
                ks.passwordProvider = function (callback){
                    callback(null, password);
                };
                
                /// not yet
                
                nonce = web3.eth.getTransactionCount(sendingAddr);
                nonceHex = web3.toHex(nonce);
                gasPrice = web3.eth.gasPrice;
                gasPriceHex = web3.toHex(gasPrice);
                gasLimitHex = web3.toHex(300000);

                txOptions = {
                    gasPrice: gasPriceHex,
                    gasLimit: gasLimitHex,
                    value: 1000000,
                    nonce: nonceHex,
                    data: compiled_code
                }

                //sendingAddr is needed to compute the contract address
               let contractData = lightwallet.txutils.createContractTx(sendingAddr, txOptions);
               let singedTx = lightwallet.singing.singeTx(ks, pwDerivedKey,contractData.tx, sendingAddr);
               
               console.log("Signed contract creation tx: "+ singedTx);
               console.log("");
               console.log("Contract Adress: " + contractData.addr)

               txOptions.to = contractData.addr;

                // setInfo: fName: son, LNamr: do
                let setInfoTx = lightwallet.txutils.funntionTx(abi,'setInfo',[sendingAddr,$("#fName").val(),$("#lName").val()],txOptions);
                let signedSetInfoTx = lightwallet.singing.singeTx(ks,pwDerivedKey,setInfoTx,sendingAddr).toString('hex');


                web3.eth.sendTransaction({
                    from: addresses[0],
                    to: txOptions.to,
                    data: signedSetInfoTx,
                    value: '0x00',
                    gasPrice: gasPriceHex,
                    gas: 50000
                },function(err,txhash){
                    if(err) console.log(err);
                    document.getElementById("info").innerHTML = "txn hash: "+txhash;
                })
                }
                });
```

