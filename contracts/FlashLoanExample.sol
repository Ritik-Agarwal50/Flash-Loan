// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract FlashLoanExample is FlashLoanSimpleReceiverBase {
    using SafeMath for uint;
    event Log(address asset, uint val);

    constructor(IPoolAddressesProvider provider)
        FlashLoanSimpleReceiverBase(provider)
    {}

    function createFlashloan(address asset, uint amount) external {
        address receiver = address(this);
        bytes memory params = "";
        uint16 referralCode = 0;
        POOL.flashLoanSimple(receiver, asset, amount, params, referralCode);
    }

    function executeOperation(
        address assest,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external returns (bool) {
        uint amountOwing = amount.add(premium);
        IERC20(assest).approve(address(POOL), amountOwing);
        emit Log(assest, amountOwing);
        return true;
    }
}
