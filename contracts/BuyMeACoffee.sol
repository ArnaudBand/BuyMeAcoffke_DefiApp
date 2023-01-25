// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

// Uncomment this line to use console.log
// import "hardhat/console.sol";


contract BuyMeACoffee {
    //  Event to emit when a Memo is created

    event NewMemo(
        address indexed from,
        uint256 timestamp,
        string name,
        string message
    );

    // Memo struct.

    struct Memo {
        address from;
        uint256 timestamp;
        string name;
        string message;
    }

    // List of all memos received from friends.

    Memo[] memos;

    // Address of contract deployer.

    address payable owner;
    address payable withdrawalAddress;

    // Deploy logic.

    constructor() {
        owner = payable(msg.sender);
        withdrawalAddress = payable(msg.sender);
    }

    /**
     * @dev buy a coffee for the contract owner
     * @param _name name of coffee buyer
     * @param _message a nice message from the coffe buyer
     */

    function buyCoffee(string memory _name, string memory _message) public payable {
        require(msg.value > 0, "You can't buy a coffee with 0 ETH");


        // Add memos to the storage
        memos.push(Memo (
                msg.sender,
                block.timestamp,
                _name,
                _message
        ));

        // Emit a log event when a new memo is created!

        emit NewMemo(
            msg.sender,
            block.timestamp,
            _name,
            _message
        );
    }

    /**
     * @dev update the withdraw address
     */

    function updateWithdrawalAddress(address payable newAddress) public {
        require(msg.sender == owner, "Only the owner can update the withdrawal address.");
        withdrawalAddress = newAddress;
    }

    /**
     * @dev send the entire balance stored in this contract to the owner
     */

    function withdrawTips() public {
        require(msg.sender == owner, "Only the owner can withdraw funds.");
        require(withdrawalAddress != address(0), "Withdraw address is not set.");
        withdrawalAddress.transfer(address(this).balance);
    }

    /**
     * @dev retrieve all the memos received and stored on the blockchain
     */

    function getMemos() public view returns(Memo[] memory) {
        return memos;
    }
}
