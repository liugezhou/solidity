// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract FreeMint is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter; 
    //Counters.Counter结构体的别名
    // increment()、current()

    address private _owner; //定义变量合约拥有者，是address类型
    mapping(address => bool) private _freeMinters;
    uint256 private _maxFreeMintCount;
    uint256 private _freeMintCount;

    //strut结构体包含图片名称和图片地址
    struct Wallpaper {
        string name;
        string imageUri;
    }

    mapping(uint256 => Wallpaper) private _wallpapers;

    constructor(string memory name, string memory symbol, uint256 maxFreeMintCount) ERC721(name, symbol) {
        _owner = msg.sender;
        _maxFreeMintCount = maxFreeMintCount; //可以写死或者初始化的时候传入
        _freeMintCount = 0; //初始mint个数为0
    }

    function mint(address userAddress, string memory name, string memory imageUri) public {
        require(msg.sender == _owner, "Only contract owner can mint.");
        require(_freeMintCount < _maxFreeMintCount, "Maximum free mint count reached.");
        require(!_freeMinters[userAddress], "User has already claimed a free mint.");

        _freeMinters[userAddress] = true;
        _tokenIdCounter.increment();
        uint256 newTokenId = _tokenIdCounter.current();
        _mint(userAddress, newTokenId);
        _wallpapers[newTokenId] = Wallpaper(name, imageUri);

        _freeMintCount++;
    }

    function getWallpaper(uint256 tokenId) public view returns (Wallpaper memory) {
        require(_exists(tokenId), "Wallpaper not found.");
        return _wallpapers[tokenId];
    }

    function hasClaimedFreeMint(address userAddress) public view returns (bool) {
        return _freeMinters[userAddress];
    }

    function getMaxFreeMintCount() public view returns (uint256) {
        return _maxFreeMintCount;
    }

    function getFreeMintCount() public view returns (uint256) {
        return _freeMintCount;
    }
}
