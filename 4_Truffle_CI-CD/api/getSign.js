var  Web3  =  require('web3');
require('dotenv').config();

const HDWalletProvider = require('@truffle/hdwallet-provider');

const provider = new HDWalletProvider(`${process.env.MNEMONIC}`, `https://ropsten.infura.io/v3/${process.env.INFURA_ID}`)
const web3 = new Web3(provider);

const tx = {
	from: '0x1c4955A6caAc65eA5faB4ceBaBa619C287a322A7',
	to: '0x9a435Ea40cF88f8947F378e3f149d5C7D852e96e',
	value: 100000000000000000,
};

const signPromise = web3.eth.signTransaction(tx, tx.from);

signPromise.then((signedTx) => {
  const sentTx = web3.eth.sendSignedTransaction(signedTx.raw || signedTx.rawTransaction);
  sentTx.on('receipt', receipt => {
    console.log('super');
  })
  sentTx.on('error', err => {
    console.log('oopsie');
  })
}).catch((err) => {
  console.log('oupsie2')
})