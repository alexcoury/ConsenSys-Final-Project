pragma solidity ^0.5.0;

//Importing OpenZeppelin's SafeMath Implementation
import "./SafeMath.sol";

contract CrowdFunding {
    using SafeMath for uint256;

    address payable public owner;
    string public title;
    mapping(address => bool) contributors; //bool to check if contributor supported a campaign
    string public description;
    uint256 public minimumContribution; //minimum constribution a contributor can send set by the creator
    uint256 public targetGoal; //The target goal of the campaign set by the creator
    uint256 public contributorsCount; //count of contributors for a single campaign
    bool public isOpen; //bool to check if the crowdraise is still active or not

    bool public stopped = false; //bool for Circuit Breaker


    event LogContribution(address contributor, uint256 value);
    event LogWithdrawalCompletion(address recipient, uint256 value);

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

    //Creator can freeze contract if they are aware of a bug
    function circuitBreaker() public isCreator {
       stopped = !stopped;
    }

    function readCampaign() public view returns(string memory projectTitle, string memory desc, uint256 min, uint256 projectGoal, bool open, uint256 count){
        projectTitle = title;
        desc = description;
        min = minimumContribution;
        projectGoal = targetGoal;
        open = isOpen;
        count = contributorsCount;
    }

    function contribute() public payable  stopInEmergency isContributor {
        require(isOpen == true, "The crowdfund is no longer open.");
        require(msg.value > minimumContribution, "The contribution must be above the minimum Contribution");
         contributors[msg.sender] = true;
        msg.sender.transfer(msg.value);
        contributorsCount++;
        emit LogContribution(msg.sender, msg.value);
    }
    function withdraw() public onlyInEmergency isCreator {
        isOpen = false;
        uint transferBalance = address(this).balance;
        owner.transfer(transferBalance);
        emit LogWithdrawalCompletion(owner, transferBalance);
    }

}

