// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

///
/// @dev Implementation of IERC2981Receiver
///
interface IERC2981Receiver {
    ///
    /// bytes4(keccak256("onERC2981Received(address,uint256,address,uint256,uint256)")) == 0x44789470
    /// bytes4 private constant _INTERFACE_ID_2981RECEIVER = 0x44789470;

    /// @notice Called at time of royalties payment
    /// @param registry the NFT contract address
    /// @param tokenId the NFT id
    /// @param paymentToken the token used as payment. Should be address(0) if payment is in msg.value
    /// @param paymentValue the amount of the payment. This should match the msg.value or the value transfered in ERC20
    /// @param paymentTokenId the tokenId (in case of ERC1155 payment)
    /// @return `bytes4(keccak256("onERC2981Received(address,uint256,address,uint256,uint256)"))` if received as expected
    function onERC2981Received(
        address registry,
        uint256 tokenId,
        address paymentToken,
        uint256 paymentValue,
        uint256 paymentTokenId
    ) external payable returns (bytes4);
}
