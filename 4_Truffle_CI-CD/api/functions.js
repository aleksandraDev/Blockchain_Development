async function main() {
	var Web3 = require('web3');
	require('dotenv').config();

	const HDWalletProvider = require('@truffle/hdwallet-provider');

	const provider = new HDWalletProvider(
		`${process.env.MNEMONIC}`,
		`https://ropsten.infura.io/v3/${process.env.INFURA_ID}`
	);
	const web3 = new Web3(provider);

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
	0x1c4955a6caac65ea5fab4cebaba619c287a322a7;

	Contract.methods.retrieve().call().then(console.log);

	await Contract.methods.store(5).send({ from: '0x1c4955A6caAc65eA5faB4ceBaBa619C287a322A7' });

	Contract.methods.retrieve().call().then(console.log);
}

main();
