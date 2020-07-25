const Libertas = artifacts.require("Libertas");

module.exports = async function(deployer) {
    let ci;
    deployer.then(function() {
        return deployer.deploy(Libertas, '0x859c5Fd8be133510Fc5c7c15563Fb0a3ccDBb821');
    }).then(function(instance) {
        ci = instance;
    });

}
