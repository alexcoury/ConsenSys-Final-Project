pragma solidity ^0.5.0;

//Importing OpenZeppelin's SafeMath Implementation
import "./SafeMath.sol";

// @title A CrowdFunding contract to create a single campaign
/// @author Alex Coury
/// @notice The owner can use this contract to create a campaign and supporters can contribute to it
/// @dev The CrowdFundingFactory enables fluid intialization of a new crowdfunding campaign
contract CrowdFunding {
    using SafeMath for uint256;

    address payable public owner; //The owner/creator of the campaign
    string public title; //The title of the project
    mapping(address => bool) contributors; //bool to check if contributor supported a campaign
    string public description; //The description of the project
    uint256 public minimumContribution; //minimum constribution a contributor can send set by the creator
    uint256 public targetGoal; //The target goal of the campaign set by the creator
    uint256 public contributorsCount; //count of contributors for a single campaign
    bool public isOpen; //bool to check if the crowdraise is still active or not

    bool public stopped = false; //bool for Circuit Breaker

    //event to log when a supporter contributes to the campaign
    event LogContribution(address contributor, uint256 value);

    //logs the withdraw triggered only by the owner
    event LogWithdrawalCompletion(address owner, uint256 value);

    constructor(string memory _title, string memory _description, uint256 _minimum, uint256 _goal, address payable _owner) public {
        title = _title;
        description = _description;
        minimumContribution = _minimum;
        targetGoal = _goal;
        isOpen = true;
        owner = _owner;
    }

     //modifier to check if the caller is the owner of the campaign
    modifier isCreator {
        require(msg.sender == owner, "You must be the owner");
        _;
    }

     //modifier to check if the caller is a contributor of the campaign
    modifier isContributor {
        require(msg.sender != owner, "You must be a contributor");
        _;
    }

    //Circuit Breaker Modifiers
    modifier stopInEmergency {
        require(!stopped);
        _;
    }
    modifier onlyInEmergency {
        require(!stopped);
         _;
    }

    /// @author Alex Coury
    /// @notice Circuit Breaker is a design patterns that allow contract functionality to be stopped if a bug is found
    /// @dev The stopped bool starts out as false and disables both the contribute and withdraw function when enabled
    function circuitBreaker() public isCreator {
       stopped = !stopped;
    }

    /// @author Alex Coury
    /// @notice Displays the details of the crowdfunding campaign
    /// @return The campaign returns a title, description, minmum contributions allowed (set by owner), targeted fundraising goal,
    //bool for inactive/active, and count of how many supporters
    function readCampaign() public view returns(string memory projectTitle, string memory desc, uint256 min, uint256 projectGoal, bool open, uint256 count){
        projectTitle = title;
        desc = description;
        min = minimumContribution;
        projectGoal = targetGoal;
        open = isOpen;
        count = contributorsCount;
    }

   /// @author Alex Coury
    /// @notice Allows the supporters to contribute to the crowdfunding campaign
    /// @dev Only the contributor/supporter can contribute
    function contribute() public payable  stopInEmergency isContributor {
        require(isOpen == true, "The crowdfund is no longer open.");
        require(msg.value > minimumContribution, "The contribution must be above the minimum Contribution");
         contributors[msg.sender] = true;
        msg.sender.transfer(msg.value);
        contributorsCount++;
        emit LogContribution(msg.sender, msg.value);
    }

    /// @author Alex Coury
    /// @notice Owner can withdraw the funds of the crowdfund raising contract
    /// @dev Only the creator/owner can withdraw the funds
    function withdraw() public onlyInEmergency isCreator {
        isOpen = false;
        uint transferBalance = address(this).balance;
        owner.transfer(transferBalance);
        emit LogWithdrawalCompletion(owner, transferBalance);
    }

}

