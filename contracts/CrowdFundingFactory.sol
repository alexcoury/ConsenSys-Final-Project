pragma solidity ^0.5.0;

import "./CrowdFunding.sol";
import "./SafeMath.sol";

contract CrowdFundingFactory {
    using SafeMath for uint256; //OpenZeppelin's Safe Math Library

    address payable public owner = msg.sender; //The creator/owner of the campaign
    CrowdFunding[] public deployedCampaigns; //list of campaigns created
    CrowdFunding[] public displayCampaigns; //Prevents a Denial of Service by Block Gas Limit due to unknow size of array
    uint256 nextCampaignIndex;

    //event which logs the creation of a campaign, campaign address is used for testing
    event LogCampaignCreated(uint256 minimum, string title, string desc, uint256 goal, address campaignAddress);

    /// @author Alex Coury
    /// @notice Intializes the CrowdFunding campaign contract all set by the owner
    /// @param _title The title of the project
    /// @param _description The description of the project
    /// @param _minimum The minimum of the project that contributors can donate
    /// @param _goal The target goal of the project
    function createCampaign(string memory _title, string memory _description, uint256 _minimum, uint256 _goal) public {
        CrowdFunding newCampaign = new CrowdFunding(_title, _description, _minimum, _goal, owner);
        deployedCampaigns.push(newCampaign);
        emit LogCampaignCreated(_minimum, _title, _description, _goal, address(newCampaign));
    }

    /// @author Alex Coury
    /// @notice Gets the list of Crowdfunding campaigns that have been created
    /// @return The function returns an array containing all the deployed addresses
    function getDeployedCampaigns() public returns (CrowdFunding[] memory) {
        uint256 i = nextCampaignIndex;
        while (i < deployedCampaigns.length && gasleft() > 200000) {
        i++;
        displayCampaigns.push(deployedCampaigns[i]);
        return displayCampaigns;
        }
        nextCampaignIndex = i;
    }
}