// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MyToken_721 is ERC721, Ownable {

    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    mapping(address => uint) private minters; 

    uint constant TOKEN_PRICE = 10 ** 16 wei;

    string private baseURI;

    bool internal locked;

    modifier reentrancyGuard() {
        require(!locked);
        locked = true;
        _;
        locked = false;
    }

    constructor(string memory CIDofMetafiles) ERC721("MyToken", "MTK") {
        baseURI = string(abi.encodePacked("ipfs://", CIDofMetafiles, "/"));
    }

    function safeMint(address to) public payable reentrancyGuard {
        uint mintCount = minters[msg.sender];
        if (mintCount > 9) {
            require(msg.value == TOKEN_PRICE, "Token price is 0.01 ether!");
        } else {
            require(msg.value == 0, "For 10 Tokens there is no cost!");
        }
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        minters[msg.sender] += 1;
        _safeMint(to, tokenId);
    }

    function totalCountOfTokens() external view onlyOwner returns (uint) {
        return _tokenIdCounter.current();
    }

    function _baseURI() internal view override virtual returns (string memory) {
        return baseURI;
    }

    function changeBaseURI(string calldata CIDofMetafiles) external onlyOwner  {
        baseURI = string(abi.encodePacked("ipfs://", CIDofMetafiles, "/"));
    }

    function balance() external view returns (uint) {
        return address(this).balance;
    }

    function withdraw(uint _amount) external payable onlyOwner {
        require(_amount <= address(this).balance);
        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success, "Failed to transfer!");
    }
}
