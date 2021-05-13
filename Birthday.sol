// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol";

contract Birthday {
    
    using Address for address payable;
    
    address private _birthdayReceiverAccount;
    uint256 private _birthdayDay;
    uint256 private _birthdayMonth;
    uint256 private _deployementTimeStamp = block.timestamp;
    uint256 constant private FIRSTJANUARY2021TIMESTAMP = 1609455599;
    uint256 constant private ONEYEARINSECONDS = 31556926;
    
    event Deposited(address indexed sender, uint256 amount);
    event Withdrew(address indexed recipient, uint256);
    
    constructor(address birthdayReceiverAccount_, uint256 birthdayDay_, uint256 birthdayMonth_){
    _birthdayReceiverAccount = birthdayReceiverAccount_;
    _birthdayDay = birthdayDay_;
    _birthdayMonth = birthdayMonth_;
    }
    
     receive() external payable {
        _deposit(msg.sender, msg.value);
    }
    
    fallback() external {}

    function deposit() external payable {
        _deposit(msg.sender, msg.value);
    }
    
     function total() public view returns (uint256) {
        return address(this).balance;
    }
    
    function birthdayTime () public view returns (uint256) {
        uint256 birthdayTimeStamp = FIRSTJANUARY2021TIMESTAMP + (_birthdayDay-1) * 1 days + (_birthdayMonth-1) * 30.44 days;
           if(_birthdayMonth < 2) {
               birthdayTimeStamp = FIRSTJANUARY2021TIMESTAMP + (_birthdayDay-1) * 1 days;
           }
        if (block.timestamp > birthdayTimeStamp) {
            birthdayTimeStamp = birthdayTimeStamp + ONEYEARINSECONDS;
            }
        return birthdayTimeStamp;
    }
    
    function daysToBirthday() public view returns (uint256) {
        require(birthdayTime() > block.timestamp, "Birthday: your birthday is past");
        return (birthdayTime() - block.timestamp) / 86400;
    }
        
       function getpresent(address recipient) public {
        require(recipient == _birthdayReceiverAccount, "Birthday: Only birthdayReceiverAccount can withdraw");
        require(birthdayTime () <= block.timestamp, "Birthday: can withdraw only after Anniversary date");
        uint256 amount = address(this).balance;
        payable(recipient).sendValue(amount);
        emit Withdrew(recipient, amount);
    }
    
    function _deposit(address sender, uint256 amount) private {
        amount = address(this).balance;
        emit Deposited(sender, amount);
    }
}

