pragma solidity 0.8.17;

contract Conduit {
    function take(
        address _nftContractAddress,
        uint256 _tokenId,
        address _to
    ) public {
        // Transfer the NFT from the user's account to the new address
        IERC721Receiver(_nftContractAddress).safeTransferFrom(
            _nftContractAddress,
            msg.sender, // Conduit is transferring from itself (i.e., its own address)
            _tokenId,
            ""
        );

        // Update the NFT owner mapping in the ERC721seadrop contract
        ERC721SeaDropStructs.nftOwners[_tokenId] = _to;
    }
}
