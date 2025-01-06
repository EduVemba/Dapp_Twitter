// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;



contract Twitter{

    mapping(address => string[]) private UserTwetts;

    address owner;

    constructor(){
        owner = msg.sender;
    }

    event newTweet(string indexed notify, address indexed tweetHost);

    function createTweet(string memory tweet) external {
        UserTwetts[msg.sender].push(tweet);
        emit newTweet("New Tweet by: ", msg.sender);
    
    }

    function getTweet(address user, uint _i)external view returns (string memory){
      return UserTwetts[user][_i];
    }

    function getAllTwetts(address _owner) external view returns (string[] memory){
        return UserTwetts[_owner];
    }

}