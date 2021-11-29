var Web3 = require('web3');
web3 = new Web3(
	new Web3.providers.HttpProvider('https://ropsten.infura.io/v3/55a7a41235ec41d5a379ccaa26bf497e')
);

console.log('Calling Contract.....');

var abi = [
	{
		inputs: [],
		name: 'retrieve',
		outputs: [
			{
				internalType: 'uint256',
				name: '',
				type: 'uint256',
			},
		],
		stateMutability: 'view',
		type: 'function',
	},
	{
		inputs: [
			{
				internalType: 'uint256',
				name: 'num',
				type: 'uint256',
			},
		],
		name: 'store',
		outputs: [],
		stateMutability: 'nonpayable',
		type: 'function',
	},
];
var addr = '0x40bF6CdD51de9Db5d7501431404295573183c79c';

var Contract = new web3.eth.Contract(abi, addr);

// FUNCTION must the name of the function you want to call.
Contract.methods.retrieve().call().then(console.log);
