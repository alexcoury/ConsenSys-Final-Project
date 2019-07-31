# ConsenSys Bootcamp Final Project Summer 2019

## CrowdFunding Dapp Overview
My project is a crowdfunding application which allows creators to create a crowdfunding campaign project to raise funds in ETH from supporters.

A project campaign contains a title, description, contribution minimum, target goal, owner, and a bool to check if the project is active or inactive.

The contributor(s)/supporter(s) must contribute more than the minimum contribution limit that the creator sets when intializing the crowdfunding campaign. 

Only the owner of the crowdfunding campaign contract can withdraw the funds when he/she desires. 

## Project Set Up
This project is a [truffle project](https://truffleframework.com/docs/truffle/overview). Create a directory where you would like to keep this project, and move inside it with your terminal. Run the truffle command `truffle compile` and then `truffle compile`. 

The ganache client test blockchain should be running on `port: 7545` and on host `127.0.0.1`. 

## Tests
Tests can be ran by using the command `truffle test` within the project directory inside your terminal.

**Tests**:
**Setup** - The setup test checks to ensure the owner/creator is the deployer of the contract. This test was created to ensure the owner is always the deployer of the contract.

**readCampaign()** - The readCampaign test ensures the campaign details return and match their appropriate fields. This test was created to ensure the campaign details are accurate.

**contribute()** - The contribute tests a couple of things: 
1. The supporter(s) funds contribute to the campaign should be greater than the minimum contribution limit the owner sets in the beginning of intialization. This test ensures that the contributor cannot contribute under the minimum set by the owner.
2. The ability to contribute should only be enabled when the campaign is still active. This test ensures that a supporter can't contribute to an inactive project.

**withdraw()** - The withdraw tests a few things:
1. The campaign owner should be able to close/make inactive crowdfunding contributions from supporters. This test ensures the contract is made inactive once the owner withdraws their funds.
2. An address other than the owner's should not be able to close the campaign/withdraw funds. This test ensures that anyone other than the owner cannot access the funds.
3. The contract balance should be transferred fully to the owner when the campaign is closed and withdraw is requested. This test ensures the whole balance of the contract is sent to the owner.

**circuitBreaker()** - The circuitBreaker tests to ensure the withdraw and contribute functions are disabled/frozen when the owner of the CrowdFunding contract toggles the circuitBreaker if a vulerability/bug is found. This test ensures the circuit breaker design pattern works when the owner toggles both functions to be disabled.
