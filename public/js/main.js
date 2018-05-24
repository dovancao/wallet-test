
let web3 = new Web3();

let global_keystore;

let compiled_code = '608060405234801561001057600080fd5b50336000806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff16021790555061036b806100606000396000f30060806040526004361061004c576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff168063f9b04e6614610051578063ffdd5cf1146100ce575b600080fd5b34801561005d57600080fd5b506100cc600480360381019080803573ffffffffffffffffffffffffffffffffffffffff16906020019092919080356fffffffffffffffffffffffffffffffff1916906020019092919080356fffffffffffffffffffffffffffffffff19169060200190929190505050610178565b005b3480156100da57600080fd5b5061010f600480360381019080803573ffffffffffffffffffffffffffffffffffffffff169060200190929190505050610273565b60405180836fffffffffffffffffffffffffffffffff19166fffffffffffffffffffffffffffffffff19168152602001826fffffffffffffffffffffffffffffffff19166fffffffffffffffffffffffffffffffff191681526020019250505060405180910390f35b81600160008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060000160006101000a8154816fffffffffffffffffffffffffffffffff02191690837001000000000000000000000000000000009004021790555080600160008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060000160106101000a8154816fffffffffffffffffffffffffffffffff021916908370010000000000000000000000000000000090040217905550505050565b600080600160008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060000160009054906101000a900470010000000000000000000000000000000002600160008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060000160109054906101000a900470010000000000000000000000000000000002915091509150915600a165627a7a723058209b82441b5b305d4bbcc4813f4f62ff0049b7fbb9964839238d8d3bc6511740a10029';

let abi = [
	{
		"constant": false,
		"inputs": [
			{
				"name": "_owner",
				"type": "address"
			},
			{
				"name": "_firstName",
				"type": "bytes16"
			},
			{
				"name": "_lastName",
				"type": "bytes16"
			}
		],
		"name": "setInfo",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "_owner",
				"type": "address"
			}
		],
		"name": "getInfo",
		"outputs": [
			{
				"name": "",
				"type": "bytes16"
			},
			{
				"name": "",
				"type": "bytes16"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "firstName",
				"type": "bytes16"
			},
			{
				"indexed": false,
				"name": "lastName",
				"type": "bytes16"
			}
		],
		"name": "newInformation",
		"type": "event"
	}
];



function setWeb3Provider(keystore){
    let web3Provider = new HookedWeb3Provider({
        host: "https://localhost:8545",
        transaction_signer: keystore
    });
    web3.setProvider(web3Provider);
}

function generate_addresses(seed){
    if(seed == undefined) seed = document.getElementById("seed").value;
    if(!lightwallet.keystore.isSeedValid(seed)){
        console.log('pls enter valid seed');
        return;
    }
    let password = Math.random().toString();
    lightwallet.keystore.createVault({
        password: password,
        seedPhrase : seed,
        hdPathString: "m/0'/0'/0'"
    },function (err, ks){
        ks.keyFromPassword(password , function(err, pwDerivedKey){
            global_keystore = ks;
            //document.getElementById("seed").value = '';
            ks.generateNewAddress(pwDerivedKey, 5);
            let addresses = ks.getAddresses();
            setWeb3Provider(global_keystore);
            let html ="";
            for(var count = 0; count <addresses.length; count++){
                let address = addresses[count];
                let private_key = ks.exportPrivateKey(address, pwDerivedKey);
                //let balance = web3.eth.getBalance("0x"+ address);
                html = html + "<li>";
                html = html + "<p><b>Addresses: </b>0x" + address+ "</p>";
                html = html + "<p><b>Private key: </b>0x" + private_key +"</p>";
                //html = html + "<p><b>Balance: </b>" + web3.fromWei(balance, "ether")+" ether</p>";
                html = html + "</li>";
            }
            document.getElementById("fromAdress").value = addresses[0];
            document.getElementById("list").innerHTML = html;
        });
    });
}


$("#gSeed").click(function(){
    let secreatSeed = lightwallet.keystore.generateRandomSeed();
    document.getElementById("seed").value = secreatSeed;
    console.log(secreatSeed);
    generate_addresses(secreatSeed);
});


$("#gDetail").click( function(){
    let seed = document.getElementById("seed").value;
    generate_addresses(seed);
});


$("#button").click(function(){
    let seed = document.getElementById("seed").value;
    var password = Math.random().toString();
    if(!lightwallet.keystore.isSeedValid(seed)){
        console.log("please enter a valid seed");
        return;
    }

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

                setWeb3Provider(ks);

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
    });

});
