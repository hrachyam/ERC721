// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract MyToken_721 is ERC721Enumerable, Ownable, ReentrancyGuard {

    uint private _tokenPrice;
    string private _tokenBaseUri;
    mapping(address => uint) private _minters; 

    constructor(string memory baseUri, uint tokenPrice) ERC721("MyToken", "MTK") {
        _tokenBaseUri = baseUri;
        _tokenPrice = tokenPrice;
    }

    function safeMint() public payable nonReentrant {
        uint mintCount = _minters[msg.sender];
        if (mintCount > 9) {
            require(msg.value >= _tokenPrice, "Token price is less!");
        } else {
            require(msg.value == 0, "For 10 Tokens there is no cost!");
        }
        _minters[msg.sender] += 1;
        _safeMint(msg.sender, totalSupply() + 1);
    }

    function _baseURI() internal view override virtual returns (string memory) {
        return _tokenBaseUri;
    }

    function changeBaseURI(string calldata baseUri) external onlyOwner  {
        _tokenBaseUri = baseUri;
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
