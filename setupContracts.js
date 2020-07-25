let Web3 = require('web3');
const fs = require('fs');
const { exit } = require('process');

const keys = fs.readFileSync(".keys").toString().trim().replace('\r', '').replace('\r', '').split('\n');
console.log(`Found ${keys.length} Keys`)
let web3;
let networkId;
var args = process.argv;
console.log(`Running ${args[2]} version.`)

if (args[2] == 'prod'){
    web3 = new Web3(new Web3.providers.HttpProvider('https://rpc-mumbai.matic.today'));
    networkId = 80001;
}
else {

    web3 = new Web3(new Web3.providers.HttpProvider('http://127.0.0.1:8545'));
    networkId = 1001;
}

keys.forEach((key)=>{
    web3.eth.accounts.wallet.add(key);
})

function getContractInstance(name = '', network = networkId){

    let build = require(`./build/contracts/${name}.json`);
    let address = build.networks[network].address;
    let abi = build.abi;
    return new web3.eth.Contract(abi, address, {gas: 10000000});
}

let ANC = getContractInstance('ANC');
let Faucet = getContractInstance('Faucet');
let Libertas = getContractInstance('Libertas');
let LibertasArticles = getContractInstance('LibertasArticles');


(async () => {

    /* */
    await ANC.methods.enableTransfer().send({from: web3.eth.accounts.wallet[0].address})
    .once('confirmation', function(confirmationNumber, receipt){
        console.log(`✅ Enable Token Transfer 1: ${receipt.transactionHash}`)
    })

    await ANC.methods.mint(web3.eth.accounts.wallet[0].address, web3.utils.toWei('150', 'ether')).send({from: web3.eth.accounts.wallet[0].address})
    .once('confirmation', function(confirmationNumber, receipt){
        console.log(`✅ Mint ANC to Account 1: ${receipt.transactionHash}`)
    })

    await ANC.methods.mint(web3.eth.accounts.wallet[0].address, web3.utils.toWei('150', 'ether')).send({from: web3.eth.accounts.wallet[0].address})
    .once('confirmation', function(confirmationNumber, receipt){
        console.log(`✅ Mint More ANC to Account 1: ${receipt.transactionHash}`)
    })

    await ANC.methods.mint(web3.eth.accounts.wallet[1].address, web3.utils.toWei('100', 'ether')).send({from: web3.eth.accounts.wallet[0].address})
    .once('confirmation', function(confirmationNumber, receipt){
        console.log(`✅ Mint ANC to Account 2: ${receipt.transactionHash}`)
    })

    await ANC.methods.mint(web3.eth.accounts.wallet[2].address, web3.utils.toWei('100', 'ether')).send({from: web3.eth.accounts.wallet[0].address})
    .once('confirmation', function(confirmationNumber, receipt){
        console.log(`✅ Mint ANC to Account 3: ${receipt.transactionHash}`)
    })

    await ANC.methods.mint(Faucet._address, web3.utils.toWei('100')).send({from: web3.eth.accounts.wallet[0].address})
    .once('confirmation', function(confirmationNumber, receipt){
        console.log(`✅ Mint ANC to Faucet: ${receipt.transactionHash}`)
    })

    await ANC.methods.balanceOf(web3.eth.accounts.wallet[0].address).call()
    .then(function(data){
        console.log(`🤑 Balance of Account 1: ${web3.utils.fromWei(data)} ANC`)
    })
    await ANC.methods.balanceOf(web3.eth.accounts.wallet[1].address).call()
    .then(function(data){
        console.log(`🤑 Balance of Account 2: ${web3.utils.fromWei(data)} ANC`)
    })
    await ANC.methods.balanceOf(web3.eth.accounts.wallet[2].address).call()
    .then(function(data){
        console.log(`🤑 Balance of Account 3: ${web3.utils.fromWei(data)} ANC`)
    })
    await ANC.methods.balanceOf(Faucet._address).call()
    .then(function(data){
        console.log(`🤑 Balance of Faucet: ${web3.utils.fromWei(data)} ANC`)
    })

    await ANC.methods.approve(Libertas._address, web3.utils.toWei('300', 'ether')).send({from: web3.eth.accounts.wallet[0].address})
    .once('confirmation', function(confirmationNumber, receipt){
        console.log(`✅ Approve Libertas to Spend ANC from Acct 1: ${receipt.transactionHash}`)
    })

    await Libertas.methods.createAdvertiser('Adv1').send({from: web3.eth.accounts.wallet[0].address})
    .once('confirmation', function(confirmationNumber, receipt){
        console.log(`✅ Create 2Advertiser from Acct 1: ${receipt.transactionHash}`)
    })

    await Libertas.methods.createAd(
        "QmaH98sj1UVsjuKnnvFNmg2VG4LuYBT6XrCWhR25CBRw3Q","lego.com","2",web3.utils.toWei('1', 'ether'),web3.utils.toWei('100', 'ether')
    ).send({from: web3.eth.accounts.wallet[0].address})
    .once('confirmation', function(confirmationNumber, receipt){
        console.log(`✅ Create Ad 1 from Acct 1: ${receipt.transactionHash}`)
    })

    await Libertas.methods.createAd(
        "QmYufx8TtYYMtSDJE1czxPndTTcwQf9KBbPUTjnjRDJJPW","store.google.com","1",web3.utils.toWei('5', 'ether'),web3.utils.toWei('100', 'ether')
    ).send({from: web3.eth.accounts.wallet[0].address})
    .once('confirmation', function(confirmationNumber, receipt){
        console.log(`✅ Create Ad 2 from Acct 1: ${receipt.transactionHash}`)
    })

    await Libertas.methods.createVideo(
        "QmUY5PdTpDmSgwre8C4cdFUSTApVweXRPzdG7ErTgdFc8A","QmaQKArfLrdQFdbCpzbtxJiqFVs6mviVdHznJGh5iAu9WK","I Built The World's Largest Lego Tower","World's Largest Lego Tower","100","2"
    ).send({from: web3.eth.accounts.wallet[1].address})
    .once('confirmation', function(confirmationNumber, receipt){
        console.log(`✅ Create Video 1 from Acct 2: ${receipt.transactionHash}`)
    })

    await Libertas.methods.createVideo(
        "QmPU7pns9LQdQfqfiXVzxgiokwPSM4X46PycHHBk84GqVc","QmSBsiRTdJu34cREmwU3DT6okhjX69VMMdYz5sJCwGEHGh","The danger of AI is weirder than you think","TED talk by Janelle Shane","100","1"
    ).send({from: web3.eth.accounts.wallet[2].address})
    .once('confirmation', function(confirmationNumber, receipt){
        console.log(`✅ Create Video 2 from Acct 3: ${receipt.transactionHash}`)
    })


    await Libertas.methods.sponsorVideo(
        "1","1"
    ).send({from: web3.eth.accounts.wallet[0].address})
    .once('confirmation', function(confirmationNumber, receipt){
        console.log(`✅ Sponsor Video 1 from Acct 1: ${receipt.transactionHash}`)
    })

    await Libertas.methods.sponsorVideo(
        "2","2"
    ).send({from: web3.eth.accounts.wallet[0].address})
    .once('confirmation', function(confirmationNumber, receipt){
        console.log(`✅ Sponsor Video 2 from Acct 1: ${receipt.transactionHash}`)
    })

    await Libertas.methods.selectSponsor(
        "1","1"
    ).send({from: web3.eth.accounts.wallet[1].address})
    .once('confirmation', function(confirmationNumber, receipt){
        console.log(`✅ Select Sponsor for Video 1 from Acct 2: ${receipt.transactionHash}`)
    })

    await Libertas.methods.selectSponsor(
        "2","2"
    ).send({from: web3.eth.accounts.wallet[2].address})
    .once('confirmation', function(confirmationNumber, receipt){
        console.log(`✅ Select Sponsor for Video 2 from Acct 3: ${receipt.transactionHash}`)
    })



    await sleep(10000)
    exit(0)
})()


function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}
