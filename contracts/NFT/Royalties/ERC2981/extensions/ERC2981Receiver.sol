// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import '@openzeppelin/contracts-upgradeable/token/ERC1155/IERC1155Upgradeable.sol';
import '@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol';
import './IERC2981Receiver.sol';

/// @notice This is an extension to ERC2981 I want to propose as an EIP
///         This allows easy following of royalties payments with a callback call
contract ERC2981Receiver is IERC2981Receiver {
    event RoyaltiesReceived(
        address registry,
        uint256 tokenId,
        address paymentToken,
        uint256 paymentAmount,
        uint256 paymentTokenId
    );

    // tokenId => paymentToken => paymentTokenId = amountReceived
    // here paymentTokenId will always be 0 for ERC20
    mapping(uint256 => mapping(address => mapping(uint256 => uint256)))
        internal _2981Received;

    /// @inheritdoc	IERC2981Receiver
    function onERC2981Received(
        address registry,
        uint256 tokenId,
        address paymentToken,
        uint256 paymentAmount,
        uint256 paymentTokenId
    ) external payable override returns (bytes4) {
        require(registry == address(this), '!WRONG_REGISTRY!');
        // verify that msg.value is the right one if paymentToken is nativ chain token
        if (paymentToken == address(0)) {
            require(msg.value == paymentAmount, '!WRONG_VALUE!');
        } else {
            // else, transfer the payment from msg.sender to ourselves
            // check if paymentToken is an ERC1155
            if (
                IERC1155Upgradeable(paymentToken).supportsInterface(
                    type(IERC1155Upgradeable).interfaceId
                )
            ) {
                IERC1155Upgradeable(paymentToken).safeTransferFrom(
                    msg.sender,
                    address(this),
                    paymentTokenId,
                    paymentAmount,
                    ''
                );
            } else {
                // or we consider it's an ERC20
                require(
                    paymentTokenId == 0 &&
                        IERC20Upgradeable(paymentToken).transferFrom(
                            msg.sender,
                            address(this),
                            paymentAmount
                        ) ==
                        true,
                    '!WRONG_VALUE!'
                );
            }
        }

        _2981Received[tokenId][paymentToken][paymentTokenId] += paymentAmount;
        emit RoyaltiesReceived(
            registry,
            tokenId,
            paymentToken,
            paymentAmount,
            paymentTokenId
        );

        return this.onERC2981Received.selector;
    }
}
