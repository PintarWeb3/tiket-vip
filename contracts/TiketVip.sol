// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract TiketVip is ERC721 {
    using SafeMath for uint256;
    using Counters for Counters.Counter;

    uint256 public constant maxSupply = 8000;

    Counters.Counter private _idGen;

    string public baseTokenURI;

    address public owner;

    event ItemMinted(uint256 indexed tokenId);

    constructor(string memory _baseTokenURI, address _owner)
        ERC721("TiketVIP", "VIP")
    {
        baseTokenURI = _baseTokenURI;
        owner = _owner;
    }

    function _isOwner(address account) internal view returns (bool) {
        return account == owner;
    }

    modifier onlyOwner() {
        require(
            _isOwner(_msgSender()),
            "Only root or owner can set daily aging rate"
        );
        _;
    }

    function mint(address to) external returns (uint256) {
        _idGen.increment();
        uint256 tokenId = _idGen.current();

        require(tokenId <= maxSupply, "max supply exceeded");

        _safeMint(to, tokenId);

        emit ItemMinted(tokenId);

        return tokenId;
    }

    function totalSupply() external view returns (uint256) {
        return _idGen.current();
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseTokenURI;
    }

    function setBaseURI(string memory baseURI) public onlyOwner {
        baseTokenURI = baseURI;
    }
}
