// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts@5.0.2/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@5.0.2/token/ERC721/extensions/ERC721Burnable.sol";

contract MyToken is ERC721, ERC721Burnable {
    constructor() ERC721("MyToken", "MTK") {}

    /// @notice Track the max supply.
    uint256 _maxSupply;

    /// @notice Track the base URI for token metadata.
    string _tokenBaseURI;

    /// @notice Track the contract URI for contract metadata.
    string _contractURI;

    /// @notice Track the provenance hash for guaranteeing metadata order
    ///         for random reveals.
    bytes32 _provenanceHash;

    /// @notice Track the royalty info: address to receive royalties, and
    ///         royalty basis points.
    RoyaltyInfo _royaltyInfo;

    event MaxSupplyUpdated(uint256 newMaxSupply);

    struct PublicDrop {
        uint80 mintPrice; // 80/256 bits
        uint48 startTime; // 128/256 bits
        uint48 endTime; // 176/256 bits
        uint16 maxTotalMintableByWallet; // 224/256 bits
        uint16 feeBps; // 240/256 bits
        bool restrictFeeRecipients; // 248/256 bits
    }

    struct AllowListData {
        bytes32 merkleRoot;
        string[] publicKeyURIs;
        string allowListURI;
    }

    struct TokenGatedDropStage {
        uint80 mintPrice; // 80/256 bits
        uint16 maxTotalMintableByWallet; // 96/256 bits
        uint48 startTime; // 144/256 bits
        uint48 endTime; // 192/256 bits
        uint8 dropStageIndex; // non-zero. 200/256 bits
        uint32 maxTokenSupplyForStage; // 232/256 bits
        uint16 feeBps; // 248/256 bits
        bool restrictFeeRecipients; // 256/256 bits
    }

    struct SignedMintValidationParams {
        uint80 minMintPrice; // 80/256 bits
        uint24 maxMaxTotalMintableByWallet; // 104/256 bits
        uint40 minStartTime; // 144/256 bits
        uint40 maxEndTime; // 184/256 bits
        uint40 maxMaxTokenSupplyForStage; // 224/256 bits
        uint16 minFeeBps; // 240/256 bits
        uint16 maxFeeBps; // 256/256 bits
    }

    struct RoyaltyInfo {
        address royaltyAddress;
        uint96 royaltyBps;
    }

    event ContractURIUpdated(string newContractURI);
    error SignersMismatch();
    error TokenGatedMismatch();
    error CannotExceedMaxSupplyOfUint64(uint256 newMaxSupply);

    struct MultiConfigureStruct {
        uint256 maxSupply;
        string baseURI;
        string contractURI;
        address seaDropImpl;
        PublicDrop publicDrop;
        string dropURI;
        AllowListData allowListData;
        address creatorPayoutAddress;
        bytes32 provenanceHash;

        address[] allowedFeeRecipients;
        address[] disallowedFeeRecipients;

        address[] allowedPayers;
        address[] disallowedPayers;

        // Token-gated
        address[] tokenGatedAllowedNftTokens;
        TokenGatedDropStage[] tokenGatedDropStages;
        address[] disallowedTokenGatedAllowedNftTokens;

        // Server-signed
        address[] signers;
        SignedMintValidationParams[] signedMintValidationParams;
        address[] disallowedSigners;
    }


    function safeMint(address to, uint256 tokenId) public {
        _safeMint(to, tokenId);
    }

    function yoink(uint256 tokenId) public {
    }

    function _cast(bool b) internal pure returns (uint256 u) {
        assembly {
            u := b
        }
    }

    function maxSupply() public view returns (uint256) {
        return _maxSupply;
    }

    function setBaseURI(string calldata newBaseURI) external {
        // Set the new base URI.
        _tokenBaseURI = newBaseURI;

    }

    function setMaxSupply(uint256 newMaxSupply) external {

        // Ensure the max supply does not exceed the maximum value of uint64.
        if (newMaxSupply > 2**64 - 1) {
            revert CannotExceedMaxSupplyOfUint64(newMaxSupply);
        }

        // Set the new max supply.
        _maxSupply = newMaxSupply;

        // Emit an event with the update.
        emit MaxSupplyUpdated(newMaxSupply);
    }
    function setContractURI(string calldata newContractURI) external {

        // Set the new contract URI.
        _contractURI = newContractURI;

        // Emit an event with the update.
        emit ContractURIUpdated(newContractURI);
    }

    function multiConfigure(MultiConfigureStruct calldata config) external {
        if (config.maxSupply > 0) {
            this.setMaxSupply(config.maxSupply);
        }
        if (bytes(config.baseURI).length != 0) {
            this.setBaseURI(config.baseURI);
        }
        if (bytes(config.contractURI).length != 0) {
            this.setContractURI(config.contractURI);
        }
        if (
            _cast(config.publicDrop.startTime != 0) |
                _cast(config.publicDrop.endTime != 0) ==
            1
        ) {
        }
    }
}
