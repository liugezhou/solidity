// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract FreeMintableERC721 is ERC721 {
    // Event that is emitted when a new token is minted
    event Mint(address indexed to, uint256 indexed tokenId, uint256 indexed imageId);

    // 一张图片ID最多可以免费申请500次
    uint256 public constant MAX_FREE_MINTS_PER_IMAGE = 500;

    // 使用 mapping 类型，存储每一张图片的freeMint数量
    mapping(uint256 => uint256) private _freeMints;

    // 记录用户可以继续已经 mint过
    mapping(address => bool) private _hasFreeMinted;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {}

    // 免费Free Mint
    function freeMint(address to, uint256 imageId) public {
        require(!_hasFreeMinted[msg.sender], "You have already free minted once");
        require(_freeMints[imageId] < MAX_FREE_MINTS_PER_IMAGE, "The maximum free mints for this image have been reached");

        // 每一张图片的数量记录
        _freeMints[imageId]++;

        // totalSupply() 是 OpenZeppelin ERC721 合约中的一个内置函数，用于返回当前已铸造 token 的总数
        // 加 1 后得到的就是即将被铸造的新 token 的唯一标识符 tokenId。
        uint256 tokenId = totalSupply() + 1;
        _safeMint(to, tokenId);

        // Mark the user as free minted
        _hasFreeMinted[msg.sender] = true;

        // 向区块链事件日志中记录一条“铸造事件”
        emit Mint(to, tokenId, imageId);
    }

    // 给前端一个借口判断图片的免费额度是否已领完
    function getFreeMintCount(uint256 imageId) public view returns (uint256) {
        return _freeMints[imageId];
    }

    // 给前端一个借口判断是否 freeMint过
    function hasFreeMinted(address user) public view returns (bool) {
        return _hasFreeMinted[user];
    }
}
