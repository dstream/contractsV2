const ChiToken = artifacts.require("ChiToken");
const ANC = artifacts.require("ANC");
const Faucet = artifacts.require("Faucet");
const LibertasVoting = artifacts.require("LibertasVoting");
const Libertas = artifacts.require("Libertas");
const LibertasArticles = artifacts.require("LibertasArticles");

module.exports = async function(deployer) {

  let ChiTokenContract;
  let ANCContract;
  let FaucetContract;
  let LibertasVotingContract;
  let LibertasContract;
  let LibertasArticlesContract;

  deployer.then(function() {
    return deployer.deploy(ChiToken);
  })
  .then(function(instance) {
    ChiTokenContract = instance;
    return deployer.deploy(ANC,
      "Anudit Coin",
      "ANC",
      "18",
      "100000000000000000000000000",
      "0",
      true,
      false,
      ChiTokenContract.address
    );
  })
  .then(function(instance) {
    ANCContract = instance;
  })
  .then(()=>{
    return deployer.deploy(Faucet, ANCContract.address);
  })
  .then((instance)=>{
    FaucetContract = instance;
  })
  .then(()=>{
    return deployer.deploy(LibertasVoting);
  })
  .then((instance)=>{
    LibertasVotingContract = instance;
  })
  .then(()=>{
    return deployer.deploy(Libertas, ANCContract.address);
  })
  .then((instance)=>{
    LibertasContract = instance;
  })
  .then(()=>{
    return deployer.deploy(LibertasArticles);
  })
  .then((instance)=>{
    LibertasArticlesContract = instance;
  })
  .then(()=>{
    console.log('ChiToken\t ', ChiTokenContract.address);
    console.log('ANCToken\t ', ANCContract.address);
    console.log('Faucet\t\t ', Faucet.address);
    console.log('LibertasVoting\t ', LibertasVotingContract.address);
    console.log('Libertas\t ', LibertasContract.address);
    console.log('LibertasArticles ', LibertasArticlesContract.address);
  });

};
