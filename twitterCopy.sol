// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.0/contracts/access/Ownable.sol";

interface IProfile {
    struct UserProfile {
        string displayName;
        string bio;
    }

    function getProfile(address _user) external view  returns (UserProfile memory); 
}

contract Twitter is Ownable {
    address private _owner;

    IProfile profileContract;

    constructor(address _profileContract) {

       profileContract = IProfile(_profileContract);
    }

    modifier onlyRegistered()  {
        IProfile.UserProfile memory userProfileTemp = profileContract.getProfile(msg.sender);
        require(bytes(userProfileTemp.displayName).length > 0,"User not Registered");
        _;
    }

    struct Tweet {
        uint256 ID;
        address author;
        string content;
        uint256 TimeStamp;
        uint64 likes;
    }

    mapping(address => Tweet[]) private UserTwetts;

    event newTweet(
        string indexed notify,
        address indexed tweetHost,
        string indexed content,
        uint256 timestamp
    );
    event TweetLiked(
        address indexed liker,
        address indexed author,
        uint64 indexed likeCount,
        uint256 timestamp
    );
    event TweetUnlike(
        address indexed unliker,
        address indexed author,
        uint64 indexed likeCount,
        uint256 timestamp
    );

    uint32 private MAX_LENGTH = 280;

    function changeTweetLength(uint32 newMaxLength) public onlyOwner{
        MAX_LENGTH = newMaxLength;
    }

    function getTweetLength() public view returns (uint32) {
        return MAX_LENGTH;
    }

    function createTweet(string memory _tweet) external onlyRegistered {
        require(
            bytes(_tweet).length <= MAX_LENGTH,
            "You used the maximum number of characters possible"
        );

        Tweet memory newTwet = Tweet({
            ID: UserTwetts[msg.sender].length,
            author: msg.sender,
            content: _tweet,
            TimeStamp: block.timestamp,
            likes: 0
        });

        UserTwetts[msg.sender].push(newTwet);

        emit newTweet(
            "New Tweet by: ",
            newTwet.author,
            newTwet.content,
            newTwet.TimeStamp
        );
    }

    function getTweet(address user, uint256 _i)
        external
        view
        returns (Tweet memory)
    {
        return UserTwetts[user][_i];
    }

    function getAllTwetts(address _ownerT)
        external
        view
        returns (Tweet[] memory)
    {
        return UserTwetts[_ownerT];
    }

    function likeTweet(address author, uint256 _id) external onlyRegistered {
        require(UserTwetts[author][_id].ID == _id, "Tweet does not exist");
        UserTwetts[author][_id].likes++;

        emit TweetLiked(
            msg.sender,
            author,
            UserTwetts[author][_id].likes,
            block.timestamp
        );
    }

    function dislikeTweet(address author, uint256 _id) external onlyRegistered {
        require(
            UserTwetts[author][_id].ID == _id &&
                UserTwetts[author][_id].likes > 0,
            "Not possible"
        );
        UserTwetts[author][_id].likes--;

        emit TweetUnlike(
            msg.sender,
            author,
            UserTwetts[author][_id].likes,
            block.timestamp
        );
    }

    function getTotalLikes(address author) external view returns (uint64) {
        uint64 totalLikes = 0;

        for (uint64 i; i < UserTwetts[author].length; i++) {
            totalLikes += UserTwetts[author][i].likes;
        }
        return totalLikes;
    }
}
