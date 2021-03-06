pragma solidity 0.7.4;

import "hardhat/console.sol";
import "./OrcaPodManager.sol";
import "./OrcaVoteManager.sol";
import "./OrcaPodTokens.sol";

// TODO: consider  order of contract  deployment. May not want to deploy all together
// this will impact the modifiers that are important for securiy
// for not deploying supporting contracts as part of main contract

// TODO: custom implementation of erc1155
// enable defining your own podId
// enable transfer of the podId token
// only allow for one token per user

contract OrcaProtocol {
    event ManagerAddress(address contractAddress);
    event VotingAddress(address contractAddress);
    event PodCreated(uint256 podId);

    OrcaPodManager orcaPodManager;
    OrcaVoteManager orcaVoteManager;
    OrcaPodTokens orcaPodTokens;

    constructor(
        address orcaPodTokensAddress,
        // address OrcaPodManagerAddress,
        // address OrcaVotingManagerAddress,
        uint256 podId,
        uint256 totalSupply,
        address erc20Address,
        uint256 minimumBalance,
        uint256 votingPeriod,
        uint256 minQuorum
    ) public {
        orcaPodManager = new OrcaPodManager();
        emit ManagerAddress(address(orcaPodManager));
        orcaVoteManager = new OrcaVoteManager();
        emit VotingAddress(address(orcaVoteManager));
        orcaPodTokens = OrcaPodTokens(orcaPodTokensAddress);
        createPod(podId, totalSupply, erc20Address, minimumBalance, votingPeriod, minQuorum);
    }

    function createPod(
        uint256 podId,
        uint256 totalSupply,
        address erc20Address,
        uint256 minimumBalance,
        uint256 votingPeriod,
        uint256 minQuorum
    ) public {
        orcaPodTokens.mint(podId, totalSupply, bytes("bytes test"));
        orcaPodManager.createPodRule(podId, erc20Address, minimumBalance);
        orcaVoteManager.createVotingRule(podId, votingPeriod, minQuorum);
        emit PodCreated(podId);
    }
}
