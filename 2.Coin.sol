// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Coin {
    // public 可以让变量可以从外部读取
    // address为地址类型
    address public minter;

    // 创建一个公共状态的变量，为mapping类型
    mapping(address => uint256) public balances;

    //声明的一个事件
    event Sent(address from, address to, uint256 amount);

    // 仅在创建合约的时候运行的构造函数，创建之后不可以调用
    constructor() {
        minter = msg.sender;
    }

    function mint(address receiver, uint256 amount) public {
      // 确保合约的创建者才可以调用 mint
        require(msg.sender == minter);
        balances[receiver] += amount;
    }

    // error 与 revert语句一起使用
    error InsufficientBalance(uint requested, uint available);

    function send(address receiver, uint256 amount) public {
        if (amount > balances[msg.sender])
            revert InsufficientBalance({
                requested: amount,
                available: balances[msg.sender]
            });

        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Sent(msg.sender, receiver, amount);
    }
}
