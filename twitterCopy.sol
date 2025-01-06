// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;



contract Twitter{

    mapping(address => string) private UserTwetts;

    event newTweet(string indexed notify, address indexed tweetHost);

    function createTweet(string memory tweet) external payable {
        require(msg.value >= 1 wei);
        UserTwetts[msg.sender] = tweet;
        emit newTweet("New Tweet by: ", msg.sender);
    }

    function getTweet(address user)external view returns (string memory){
        return UserTwetts[user];
    }

}