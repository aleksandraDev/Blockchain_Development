var VotingA = artifacts.require('./VotingA.sol');

module.exports = function (deployer) {
	deployer.deploy(VotingA);
};
