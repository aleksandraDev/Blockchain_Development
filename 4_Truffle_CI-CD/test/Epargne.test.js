const { BN, ether, expectRevert } = require('@openzeppelin/test-helpers');
const expectEvent = require('@openzeppelin/test-helpers/src/expectEvent');
const { expect } = require('chai');
const Epargne = artifacts.require('Epargne');

contract('Epargne', function (accounts) {
    const owner = accounts[0];
    const recipient = accounts[1];
    const value = ether('1');
    
    before(async function () {
        this.EpargneInstance = await Epargne.deployed();
    });

    it('verifies if the balance of contract owner', async function (){
        let balanceOwner = await this.EpargneInstance.getBalance();
        let amount = new BN(0);
        console.log('balance', balanceOwner)
        expect(balanceOwner).to.be.bignumber.equal(amount);
    });

    it('verifies if owner balance changes after sending 1 eth', async function() {
      let tx = await this.EpargneInstance.sendEth({ value, from: owner });
      let balanceOwner2 = await this.EpargneInstance.getBalance();
      expect(balanceOwner2).to.be.bignumber.equal(value);
      expectEvent(tx, 'argentDepose')
    });

    it('test withdraw function and verifies balance of owner that should be 0', async function() {
      // let resultBlock = await web3.eth.getBlock(result.blockNumber).timestamp
      let amount = new BN(0);
      let balanceOwner2 = await this.EpargneInstance.getBalance();
      expect(balanceOwner2).to.be.bignumber.equal(value);
      await this.EpargneInstance.withdrawEth();
      balanceOwner2 = await this.EpargneInstance.getBalance();
      expect(balanceOwner2).to.be.bignumber.equal(amount);
    });

    it('___should revert', async function () {
      await expectRevert(this.EpargneInstance.sendEth({ value, from: owner }), 'Not enough Wei.')
    });
    
});
