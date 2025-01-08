// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Profile {


    struct UserProfile {
        string displayName;
        string bio;
    }

    mapping (address => UserProfile) public profiles;


    function setProfile(string memory _displayName, string memory _bio) public {
        profiles[msg.sender] = UserProfile(_displayName,_bio);

        UserProfile memory newUserProfile = UserProfile ({
            displayName: _displayName,
            bio: _bio
        });

        profiles[msg.sender] = newUserProfile;
    }
 
    function getProfile(address _user) public view returns (UserProfile memory) {
        return profiles[_user];
    }
}