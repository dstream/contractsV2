let Web3 = require('web3');
let web3 = new Web3(new Web3.providers.HttpProvider('https://rpc-mumbai.matic.today'));

web3.eth.accounts.signTransaction({
    to: '0xEC8fc8F9cFC522AC17e186F5eE1658F60aC675e1',
    value: '0',
    gasPrice: 100000000000,
    gas: 2000000,
    nonce: 1
}, '0xcc24b3c033acbb5c1ba039236706ff2d19dd04865ef6c7f68dd192af6b40644t')
.then((txn)=>{
    web3.eth.sendSignedTransaction(txn.rawTransaction)
    .on('receipt', console.log);
});
