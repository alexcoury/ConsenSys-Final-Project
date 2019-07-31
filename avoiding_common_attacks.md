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
The overflow and underflow security risk is secured by a few different measures. The  

## Denial of Service

## Denial of Service by Block Gas Limit (or startGas)

## Force Sending Ether

