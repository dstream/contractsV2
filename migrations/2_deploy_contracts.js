const ChiToken = artifacts.require("ChiToken");
const ANC = artifacts.require("ANC");
const Faucet = artifacts.require("Faucet");
const LibertasGovernance = artifacts.require("LibertasGovernance");
const Libertas = artifacts.require("Libertas");
const LibertasArticles = artifacts.require("LibertasArticles");

module.exports = async function(deployer) {

  let ChiTokenContract;
  let ANCContract;
  let FaucetContract;
  let LibertasGovernanceContract;
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
    return deployer.deploy(LibertasGovernance);
  })
  .then((instance)=>{
    LibertasGovernanceContract = instance;
  })
  .then(()=>{
    return deployer.deploy(Libertas, ANCContract.address, LibertasGovernanceContract.address);
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
    console.log(`const chiTokenAddress = '${ChiTokenContract.address}';`);
    console.log(`const tokenAddress = '${ANCContract.address}';`);
    console.log(`const faucetAddress = '${Faucet.address}';`);
    console.log(`const libertasGovernanceAddress = '${LibertasGovernanceContract.address}';`);
    console.log(`const libertasAddress = '${LibertasContract.address}';`);
    console.log(`const libertasArticlesAddress = '${LibertasArticlesContract.address}';`);
  });

};
