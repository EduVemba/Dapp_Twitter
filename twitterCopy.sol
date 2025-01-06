// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;



contract Twitter{

    struct Tweet {
        address  author;
        string   content;
        uint256  TimeStamp;
        uint256  likes ;
    }

    mapping(address => Tweet[]) private UserTwetts;


    event newTweet(string indexed notify, address indexed tweetHost);

    function createTweet(string memory _tweet) external {
        
        Tweet memory newTwet = Tweet({
            author: msg.sender,
            content: _tweet,
            TimeStamp: block.timestamp,
            likes: 0
        });
        
        UserTwetts[msg.sender].push(newTwet);
        emit newTweet("New Tweet by: ", msg.sender);
    
    }

    function getTweet(address user, uint _i)external view returns (Tweet memory){
      return UserTwetts[user][_i];
    }

    function getAllTwetts(address _owner) external view returns (Tweet[] memory){
        return UserTwetts[_owner];
    }

} 