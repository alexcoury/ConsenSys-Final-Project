var CrowdFunding = artifacts.require('CrowdFunding')
const CrowdFundingFactory = artifacts.require('CrowdFundingFactory')
let catchRevert = require("./exceptionsHelpers.js").catchRevert
const BN = web3.utils.BN

contract('CrowdFunding', function(accounts){
    const firstAccount = accounts[0]
    const secondAccount = accounts[1]
    const thirdAccount = accounts[3]

    const title = "title"
    const description = "description"
    const minimumContribution = 100
    const targetGoal = 1000
    const contributorsCount = 0
    
    let instance 

    beforeEach(async () =>  {
        instance = await CrowdFundingFactory.new()
    })

    describe("Setup", async() => {

        it("Owner/Creator should be set to the deploying address", async() => {
            const owner = await instance.owner()
            assert.equal(owner, firstAccount, "the deploying address should be the owner")
        })
    })

    describe("Functions", () => {

        it("readCampaign() should return campaign details", async() => {
            const campaign = await instance.createCampaign(title, description, minimumContribution, targetGoal)
            const campaignAddress = campaign.logs[0].args.campaignAddress
            const crowdFunding = await CrowdFunding.at(campaignAddress)
            
            const campaignDetails = await crowdFunding.readCampaign(campaign)
            assert.equal(campaignDetails.projectTitle, title, "the campaign titles should match")
            assert.equal(campaignDetails.desc, description, "the campaign descriptions should match")
            assert.equal(campaignDetails.min, minimumContribution, "the project minimum contributions should match")
            assert.equal(campaignDetails.projectGoal, targetGoal, "the project target goals should match")
        })

        describe("contribute()", async () => {
            it("Contribution should only be able to be made if msg.value is greater than or equal to minimum", async () => {
                const campaign = await instance.createCampaign(title, description, minimumContribution, targetGoal)
                const campaignAddress = campaign.logs[0].args.campaignAddress
                const crowdFunding = await CrowdFunding.at(campaignAddress)
                
                await catchRevert(crowdFunding.contribute({from: secondAccount, value: 99}))
            })
            it("Contribution should be enabled when the crowdfund campaign is open", async() => {
                const campaign = await instance.createCampaign(title, description, minimumContribution, targetGoal)
                const campaignAddress = campaign.logs[0].args.campaignAddress
                const crowdFunding = await CrowdFunding.at(campaignAddress)

                await crowdFunding.contribute({from: secondAccount, value: 105})
                const campaignDetails = await crowdFunding.readCampaign(campaign)
        
                assert.equal(campaignDetails.count, 1, "the contributor count should be 1")
            })
        })

        describe("withdraw()", async () => {

            it("the campaign owner should be able to close crowdfunding contributions", async() => {
                const campaign = await instance.createCampaign(title, description, minimumContribution, targetGoal)
                const campaignAddress = campaign.logs[0].args.campaignAddress
                const crowdFunding = await CrowdFunding.at(campaignAddress)

                await crowdFunding.withdraw({from: firstAccount})
                const campaignDetails = await crowdFunding.readCampaign(campaign)
        
                assert.equal(campaignDetails.open, false, "campaign status should be closed when the owner calls withdraw()")
            })
            it("addresses other than the owner should not be able to close the campaign", async() => {
                const campaign = await instance.createCampaign(title, description, minimumContribution, targetGoal)
                const campaignAddress = campaign.logs[0].args.campaignAddress
                const crowdFunding = await CrowdFunding.at(campaignAddress)

                await catchRevert(crowdFunding.withdraw({from: secondAccount}))
            })
            it("The contract balance should be transferred to the owner when the campaing is closed", async() => {
                const campaign = await instance.createCampaign(title, description, minimumContribution, targetGoal)
                const campaignAddress = campaign.logs[0].args.campaignAddress
                const crowdFunding = await CrowdFunding.at(campaignAddress)

                const preContributionAmount = await web3.eth.getBalance(firstAccount)
                const contributeReceipt = await crowdFunding.contribute({from: secondAccount, value: 200})
                const withdrawReceipt = await crowdFunding.withdraw({from: firstAccount})
                const postContributeAmount = await web3.eth.getBalance(firstAccount)

                const endWithdrawTx = await web3.eth.getTransaction(withdrawReceipt.tx)
                let endWithdrawTxCost = Number(endWithdrawTx.gasPrice) * withdrawReceipt.receipt.gasUsed
                assert.equal(postContributeAmount, (new BN(preContributionAmount).sub(new BN(endWithdrawTxCost))).toString(), "contract owner should receive contract balance when closing the campaign")
            })
        })

        describe("circuitBreaker()", async() => {
            it("withdraw and contribute functions should be disable when circuit breaker is toggled", async() => {
                const campaign = await instance.createCampaign(title, description,minimumContribution, targetGoal)
                const campaignAddress = campaign.logs[0].args.campaignAddress
                const crowdFunding = await CrowdFunding.at(campaignAddress)

                await crowdFunding.circuitBreaker({from: firstAccount})
                await catchRevert(crowdFunding.contribute({from: secondAccount, value: 105}))
                await catchRevert(crowdFunding.withdraw({from: firstAccount}))
            })
        })
    })
})