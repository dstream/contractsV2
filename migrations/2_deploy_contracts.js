const ChiToken = artifacts.require("ChiToken");
const ANC = artifacts.require("ANC");
const Libertas = artifacts.require("Libertas");
const LibertasArticles = artifacts.require("LibertasArticles");

module.exports = async function(deployer) {

  deployer.then(function() {
    return deployer.deploy(ChiToken);
  }).then(function(instance) {
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
  }).then(function(instance) {
    ANCContract = instance;
  }).then(()=>{
    return deployer.deploy(Libertas, ANCContract.address);
  }).then((instance)=>{
    LibertasContract = instance;
  }).then(()=>{
    return deployer.deploy(LibertasArticles);
  }).then((instance)=>{
    LibertasArticlesContract = instance;
  }).then(()=>{
    console.log('ChiTokenContract\t ', ChiTokenContract.address);
    console.log('ANCContract\t\t ', ANCContract.address);
    console.log('LibertasContract\t ', LibertasContract.address);
    console.log('LibertasArticlesContract ', LibertasArticlesContract.address);
  });

};
