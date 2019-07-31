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
**Setup** - The setup test checks to ensure the owner/creator is the deployer of the contract.

**readCampaign()** - The readCampaign test ensures the campaign details return and match their appropriate fields.

**contribute()** - The contribute tests a couple of things: 1. The supporter(s) funds contribute to the campaign should be greater than the minimum contribution limit the owner sets in the beginning of intialization. 2. The ability to contribute should only be enabled when the campaign is still active.
