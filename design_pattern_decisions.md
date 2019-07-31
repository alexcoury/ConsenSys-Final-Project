# Design Patterns

## Implemented Patterns:

**Circuit Breaker** - The Circuit Breaker design pattern was a required design for the project. The design pattern allows the owner/deployer of a crowdfunding campaign to toggle a freeze of contract functionality using the `circuitBreaker()` method. This functionality is desirable in case a bug is spotted which can allow the owner to freeze the contract until the bug is resolved. For my circuit breaker design, the `contribute()` and `withdraw()`functions are both frozen until the bug is explored. This design was considered due to the owner not being able to exploit their fundraise and withdraw the funds if a bug was found.

**Fail early and fail loud** - The fail early and fail loud design was reinforced throughout the bootcamp lessons. Instead of using if statements that don't throw exceptions which don't make it clear if the function properly excuted or not. The application is designed with required conditions. The required conditions allow for execution as early as possible in the function body and throws an exception if the condition is not met. This is a good practice to reduce unnecessary code execution in the event that an exception will be thrown.

**Restricting Access**

**Factory**

## Patterns not implemented but could considered later:

**Auto Deprecation** - For furture state of the application, each crowdfunding project campaign will have a fund raising deadline which can will be set by the creator. The Auto Deprecation pattern then can be implemented to closing contracts that have expire after the fundraising deadline has passed. This design pattern will migrate manipulation by the block miners by refraining from using timestamps.

**Pull over Push Payments/Withdrawal** - For the future state of the application, a pull over push payments design could be implemented to increase security around the withdraw method. This design pattern protects against re-entrancy and denial of service attacks.

## Patterns not considered:

**Mortal** - The Mortal design pattern was not considered due to not wanting bad actors or admins to raise a crowdfund and erase all history by deleting it from the blockchain. This could allow bad actors to raise a campaign for illegal purposes and run away with the funds while deleting the history. The blockchain can ensure auditability and transparency for the application. Also, do not want an Admin model for the system which will make the application more centralized. 

**State Machine** - The State machine pattern is more applicable to more complex systems. Systems that are well suited to the pattern should be easily broken down into distinct stages, where different behavior occurs, or different functionality is permitted. State Machine design breaks complex ideas down into a more simply understood constructs. A system designed as a state machine allows states to be individually tested and without risking interference from other states and their behaviour. The functionality of the crowdfunding app isn't complex enough to consider the State Machine for now.
