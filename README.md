**Prerequisite:**

1. Node
2. Ganache
3. Metamask chrome extension
4. Truffle

**Steps to Start the project:**

1.  Go-To: Project Root Directory and Open Command Window.
2.  Run: "cd bitcrafty-app"
3.  Run: "npm install --force"
5.  Run: "cd .."
6.  Run: "cd bitcrafty-contract"
7.  Make sure Ganache is running at 7545 with correct RPC mentioned in truffle-config.js
8.  Run: "truffle migerate --reset"
9.  Copy Contract Address after file 2_deploy_contracts.js is executed from previous step and paste the address in config.js file located at BitCrafty-Dapp\bitcrafty-app\src\config.js
10. Run: "cd .."
11. Run: "cd bitcrafty-app"
12. Run: "npm start"
13. Visit: http://localhost:3000/
14. Connect to one of metamask Account from Ganache to network with port 7545