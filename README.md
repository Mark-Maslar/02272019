# Project write-up: UML
The following UML diagrams describe this application:
* 6A Activity Diagram.pdf
* 6A Class Diagram.pdf
* 6A Sequence Diagram.pdf
* 6A State Diagram.pdf



# Project write-up: Libraries & Dev Environment
The Smart Contract code itself (.SOL files) does not require any external libraries.

My development environment utilizes several npm libraries:
* truffle Suite (Ganache & Truffle. Local Ethereum tools.)
* ganache-cli (Command Line Interface)
* truffle-hdwallet-provider (This is used to deploy for deploying to the Rinkeby test network via Infura.)
* http-server (for hosting web pages in Windows environment)
* truffle-blockchain-utils
* web3

Additional Dev tooling:
* Visual Studio Code, with Solidity Extension (by Juan Blanco)
* Chrome browser, with MetaMask plugin
* Infura.io Tools for working with Rinkeby and other networks. 
     Project endpoint: https://rinkeby.infura.io/v3/76ac8ac11a5e4aa4b10788976ee55439 

# Versions
This repository requires Truffle v4 !
npm install -g truffle@4

truffle -- version
Truffle v4.1.15 (core: 4.1.15)
Solidity v0.4.25 (solc-js)

npm version
{ 'supply-chain-E': '1.0.0',
  npm: '6.4.1',
  ares: '1.10.1-DEV',
  cldr: '32.0',
  http_parser: '2.8.0',
  icu: '60.1',
  modules: '57',
  napi: '3',
  nghttp2: '1.32.0',
  node: '8.11.3',
  openssl: '1.0.2o',
  tz: '2017c',
  unicode: '10.0',
  uv: '1.19.1',
  v8: '6.2.414.54',
  zlib: '1.2.11' }

npm view web3 version
1.0.0-beta.46

## Additional Environment Notes
I open three Node.JS windows concurrently.
Window 1:
Navigate to the project-6 folder and start Ganache:
ganache-cli -m "spirit supply whale amount human item harsh scare congress discover talent hamster"

Window 2:
Navigate to the project-6 folder and start the http server:
http-server

Window 3:
Use this window to compile, test and deploy the contracts. e.g.
truffle compile
truffle test
truffle migrate --reset --compile-all --network infura



# Project Overview
This simplified DApp provides a means of proving the authenticity of Fair Trade coffee, leveraging the Ethereum blockchain. 

This DApp that demonstrates a Supply Chain flow between a Seller and Buyer. The user story is similar to any commonly used supply chain process. A Seller can add items to the inventory system stored in the blockchain. A Buyer can purchase such items from the inventory system. Additionally a Seller can mark an item as Shipped, and similarly a Buyer can mark an item as Received.

The app's implementation closely follows Project 6B's boilerplate code.



# Actors and their Wallet Addresses
Contract Owner: 0x27d8d15cbc94527cadf5ec14b69519ae23288b95  
Farmer:         0x018c2dabef4904ecbd7118350a0c54dbeae3549a  
Distributor:    0xce5144391b4ab80668965f2cc4f2cc102380ef0a  
Retailer:       0x460c31107dd048e34971e57da2f99f659add4f02  
Consumer:       0xd37b7b8c62be2fdde8daa9816483aebdbd356088  

Registration of actors and their addresses is out of scope for this project. It is presumed that that they already exist, with the addresses listed above.


# Contract & Transaction Addresses

Contract Creation, Rinkeby: 
https://rinkeby.etherscan.io/address/0xf49aa9385bbfa2f0be07f29f22015ce658593840
TxHash:0xb6edb010ba8890795021c80475cf86a0abd0963429f8329732ed2b3e925ff955
Contract Address: 0xF49aa9385BBFA2f0Be07F29F22015ce658593840

Sample Trasnactions:
Harvested - 0x5bb2b67795106d87f8f70006a398ddee345870ccdfe0197ed13d9010dfca00a3
Processed - 0x7f07d93b2a2eb4e38767c361ddde313bc9532c807a5c73ebdb1de982646a61bd
Packed - 0x37d4a1cb45a33d3d40b1e0c845ec1b3b60b6b4f1976895c72b4b8f1425b20629
ForSale - 0xf68f9dc74bd12841aa3fad31301f0f586f86d4d6f19aa0b30f2e648ef7681c71

Sample Output (from Chrome Console window)
* fetchItemBufferOne (8) [r, r, "0x018c2dabef4904ecbd7118350a0c54dbeae3549a", "0x018c2dabef4904ecbd7118350a0c54dbeae3549a", "John Doe", "Yarra Valley", "-38.239770", "144.341490"]

* fetchItemBufferTwo (9) [r, r, r, "Best beans for Espresso", r, r, "0xce5144391b4ab80668965f2cc4f2cc102380ef0a", "0x460c31107dd048e34971e57da2f99f659add4f02", "0xd37b7b8c62be2fdde8daa9816483aebdbd356088"]


# Operation
With your http server running, visit one of the addresses that it is monitoring. I.E. One of these addresses:
  http://10.0.0.4:8080
  http://127.0.0.1:8080
  http://172.29.192.1:8080
  http://172.28.170.17:8080

Ensure that MetaMask is running, that you are logged into it and that it is connected to the network where the contract is deployed. (And that your wallet has sufficient funds.)

Proceed through the supply chain process by successively clicking each step:
Harvest, Process, Pack, For Sale, Buy, Ship, Receive, Purchase.

Observe that the Transaction is populated as each transaction succeeds.
Open the browser's console (F12) and observe that the results of Fetch Data 1 and Fetch Data 2.
