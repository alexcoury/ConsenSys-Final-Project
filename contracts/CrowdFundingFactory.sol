pragma solidity ^0.5.0;

import "./CrowdFunding.sol";
import "./SafeMath.sol";

contract CrowdFundingFactory {
    using SafeMath for uint256;

    address payable public owner = msg.sender;
    CrowdFunding[] public deployedCampaigns;

    event LogCampaignCreated(uint256 minimum, string title, string desc, uint256 goal, address campaignAddress);

    //Function that allows creator to create a new crowdFunding campaign
    function createCampaign(string memory _title, string memory _description, uint256 _minimum, uint256 _goal) public {
        CrowdFunding newCampaign = new CrowdFunding(_title, _description, _minimum, _goal, owner);
        deployedCampaigns.push(newCampaign);
        emit LogCampaignCreated(_minimum, _title, _description, _goal, address(newCampaign));
    }

    //returns a list of campaigns
    function getDeployedCampaigns() public view returns (CrowdFunding[] memory) {
        return deployedCampaigns;
    }
}