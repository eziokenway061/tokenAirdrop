
const bip39 = require('bip39');
const HDWallet = require('ethereum-hdwallet');
const excelHandleManager = require('./excelHandleManager.js');
// const mnemonic_chinese = bip39.generateMnemonic(128,null,bip39.wordlists.chinese_simplified)
const mnemonic_chinese = bip39.generateMnemonic()
console.log('助记词： '+ mnemonic_chinese)



async function getAddress(mnemonic){
	const seed = await bip39.mnemonicToSeed(mnemonic)
	const hdwallet = HDWallet.fromSeed(seed)
    
    const data=[];
	for (var i = 1; i <= 1100; i++) { // 同一个种子生成
		console.log("==============地址" + (i+1) + "=================")
		const key = hdwallet.derive("m/44'/60'/0'/0/"+i) // 地址最后一位增加
		const EthAddress = '0x' + key.getAddress().toString('hex')
        const privatekey = key.getPrivateKey().toString('hex')
        const publickey = key.getPublicKey().toString('hex')
		// console.log("PrivateKey = "+ privatekey)
		// console.log("PublicKey = "+ publickey)
        // console.log("ETH Address = "+ EthAddress)
        const arr=[];
        arr.push(i);
        arr.push(privatekey);
        arr.push(publickey);
        arr.push(EthAddress);
        data.push(arr);
	}
    excelHandleManager.generateAddress(data,'./genAddr.xlsx');
}	
getAddress(mnemonic_chinese)