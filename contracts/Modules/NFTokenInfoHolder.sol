//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import './NFBaseModule.sol';

/// @title NFTokenInfoHolder
/// @author Simon Fremaux (@dievardump)
abstract contract NFTokenInfoHolder is NFBaseModule {
    /// @notice gets a token UUID
    /// @param registry the token contract
    /// @param tokenId the token id
    /// @return the token UUID
    function getTokenUUID(address registry, uint256 tokenId)
        public
        pure
        virtual
        returns (bytes32)
    {
        return keccak256(abi.encode(registry, tokenId));
    }

    /// @notice returns if a token exists
    /// @return if the token exists
    function _exists(bytes32) internal virtual returns (bool) {
        return false;
    }
}
