// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;



contract Twitter{
    address private owner;

    constructor(){
        owner = msg.sender;
    }

    struct Tweet {
        uint256   ID;
        address  author;
        string   content;
        uint256  TimeStamp;
        uint64  likes ;
    }

    mapping(address => Tweet[]) private UserTwetts;

    event newTweet(string indexed notify, address indexed tweetHost);

    uint32 private MAX_LENGTH = 280;



    modifier OnlyOwner(){
        require(msg.sender == owner,"You are not the owner");
        _;
    }

    function changeTweetLength(uint32 newMaxLength) public OnlyOwner{
        MAX_LENGTH = newMaxLength;
    }

    function getTweetLength()public view returns (uint32){
        return MAX_LENGTH;
    }

    function createTweet(string memory _tweet) external {
        require(bytes(_tweet).length <= MAX_LENGTH ,"You used the maximum number of characters possible");

        Tweet memory newTwet = Tweet({
            ID: UserTwetts[msg.sender].length,
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

    function likeTweet(address author, uint256 _id) external {
        require(UserTwetts[author][_id].ID == _id,"Tweet does not exist");
        UserTwetts[author][_id].likes++;
    }

    function dislikeTweet(address author, uint256 _id) external {
        require(UserTwetts[author][_id].ID == _id  && UserTwetts[author][_id].likes > 0,"Not possible");
        UserTwetts[author][_id].likes--;
    }

} 