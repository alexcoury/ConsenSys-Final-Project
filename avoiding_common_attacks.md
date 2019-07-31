# Common Attacks

## Re-entracy Attacks 
One of the major dangers of calling external contracts is that they can take over the control flow, and make changes to your data that the calling function wasn't expecting. The called contract may end up calling the smart contract function again in a recursive manner. It's important to first call internal functions before calling the external ones.

  **Measures**:
The `withdraw()` and `contribute()` function is secured by a number of measures:
   1. The methods are only able to be called by a specific address. The withdraw function is secured by the `isCreator` modifier and the contribute function is secured by the `isContributor`.
   2. The methods also have a `onlyInEmergency` and `stopInEmergency` modifier which is toggled by the owner to freeze the functions if a bug is spotted in the contract. This modifier leverages the Circuit Breaker design.
   3. Each CrowdFunding campaign has a boolean to check if the campaign is still active/inactive. The withdraw function will first make the project inactive before the value transfer happens. The contribute function requires the campaign to be active.

## Transaction Ordering and Timestamp Dependence

**Transaction Ordering:**
The transaction ordering has no effect on the application. The transparency and traceability of the blockchain allows supporters and owners of campaigns to ensure transactions are secure and funds are being sent to the correct campaign.

**Timestamp Dependence:**
The application does not utilize timestamp dependence. For furture state of the application, each crowdfunding project campaign will have a fund raising deadline which can will be set by the creator. The deadline functionality will leverage an Auto Deprecation deisgn pattern to avoid the use of timestamps. This design pattern will migrate manipulation by the block miners by refraining from using timestamps.

## Integer Overflow and Underflow
The overflow and underflow security risk is secured by a few different measures. The uints which are at risk to be attacked by an overflow and underflow attack are in control by the owner/deployer of the contact and other addresses cannot change these variables. The only uint variable that is called by addresses other than the owner is `the contributionCount` variable which keeps track of how many supporters contribute. This variable is purely for future state UI functionality and its unlikely the number of contributions reaches the maximum uint value of (2^256). The count is incrementing so it's never exposed to the risk of a underflow attack. The `contribute()` function requires that the address is unique and not duplicate which prevents a re-entracy attack of the variable and the risk of an overflow/underflow attack. **The Application also utilizes the SafeMath.sol library for arithmetic functions.** 

## Denial of Service
The current system design does not have any known risk for a DoS attack on the two contracts. The `CrowdFunding.sol` solely depends on the `CrowdFundingFactory` which creates a new instance of a crowdfunding campaign contract. However, in the future state of the application it can be at risk for a DoS attack once a refund function is implemented. The refund function needs to utilize the Pull over Push Payments/Withdrawal design pattern. 

## Denial of Service by Block Gas Limit (or startGas)
The current system design only leverages one loop which is vulnerable to a Denial of Service block gas limit attack. The function `getDeployedCampaigns` displays a list of all of the campaigns created once deployed. The measures to ensure safety of the unknown sized array could take mutiple blocks to ensure safety and checks to see if the gas limit has been exceeded by 200000. The `nextCampaignIndex` variable keeps track of the current place in the array the function is reading. 

## Force Sending Ether
No logic or calulations are being based on the contract's balance. The only functions ulitizing the contract balance is the withdraw and contribute functions. Which soley is used to build the contract balance and deposit to the owner/deployer once the campaign is made inactive. 
