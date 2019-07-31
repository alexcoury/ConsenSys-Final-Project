# Common Attacks

## Re-entracy Attacks 
One of the major dangers of calling external contracts is that they can take over the control flow, and make changes to your data that the calling function wasn't expecting. The called contract may end up calling the smart contract function again in a recursive manner.

  **Measures**:
The `withdraw()` function is secured by a number of measures:
   1. The method is only able to be called by the owner/deployer of the contract. This is secured by the `isCreator` modifier.
   2. The method also has a `onlyInEmergency` modifier which is toggled by the owner to freeze the function if a bug is spotted in the contract. This modifier leverages the Circuit Breaker design.
   3. Each CrowdFunding campaign has a boolean to check if the campaign is still active/inactive. The function will first make the project inactive before the value transfer happens. 

**Transaction Ordering and Timestamp Dependence

**Integer Overflow and Underflow

**Denial of Service

**Denial of Service by Block Gas Limit (or startGas)

**Force Sending Ether

