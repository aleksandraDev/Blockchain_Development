var Web3 = require('web3');
web3 = new Web3(
	new Web3.providers.HttpProvider('https://mainnet.infura.io/v3/55a7a41235ec41d5a379ccaa26bf497e')
);

var ethTx = '0xa964f1e38e1d6e2423cfca180785844e154978ca5838a8174955d9757115960f';

web3.eth.getTransaction(ethTx, function (err, result) {
	if (!err && result !== null) {
		console.log(result); // Log all the transaction info
		console.log('From Address: ' + result.from); // Log the from address
		console.log('To Address: ' + result.to); // Log the to address
		console.log('Ether Transacted: ' + web3.utils.fromWei(result.value, 'ether')); // Get the value, convert from Wei to Ether and log it
	} else {
		console.log('Error!', err); // Dump errors here
	}
});
