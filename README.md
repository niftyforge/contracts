# NiftyForge contracts

A very easy way to launch your own contracts with few efforts, lots of goodies.




- Roles Management
- Module Pattern (delegate tokenURI / royaltyInfo and other stuff to the minter module)
- Permits (EIP 4494 - draft)
- On chain Royalties (EIP 2981)
- mint / mintBatch with consecutive or arbitrary ids
- Events Listeners sent to modules for specific behaviors on Mint/Burn/Transfer

# install
```bash
npm add @0xdievardump/niftyforge
```

# Two types of contracts

Full or Slim depending on your needs and use

# hardhat-deploy

Easily load the current deployments in your hardhat config and deploy new contracts using hardhat-deploy

```js
	external: {
    deployments: {
      mainnet: ['node_modules/@0xdievardump/niftyforge/deployments/mainnet'],
      rinkeby: ['node_modules/@0xdievardump/niftyforge/deployments/rinkeby']
    }
  }
```

# Module Pattern

Create modules that you add as Minter on your contract. Those module can contain `tokenURI` `royaltyInfo` and a few other data specific to the NFTs they minted. This way: One contract, multiple sources for your NFTs, multiple royalties


```js
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "@0xdievardump/niftyforge/contracts/Modules/NFBaseModule.sol";
import "@0xdievardump/niftyforge/contracts/Modules/INFModuleTokenURI.sol";
import "@0xdievardump/niftyforge/contracts/Modules/INFModuleWithRoyalties.sol";


/// @notice Simple Module exemple that manages its own tokenURI and royaltyInfo
/// @author Simon Fremaux (@dievardump)
contract MyModuleWithSomeMonsterNFT is
    Ownable,
    NFBaseModule,
    INFModuleTokenURI,
    INFModuleWithRoyalties
{
		/// @notice the nftContract on which MyModule will Mint
		address public nftContract;

		/// @notice the baseURI for this module
		string public baseURI;

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override
        returns (bool)
    {
        return
            interfaceId == type(INFModuleTokenURI).interfaceId ||
            interfaceId == type(INFModuleWithRoyalties).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    /// @inheritdoc	INFModuleWithRoyalties
    function royaltyInfo(uint256 tokenId)
        public
        view
        override
        returns (address, uint256)
    {
        return royaltyInfo(msg.sender, tokenId);
    }

    /// @inheritdoc	INFModuleWithRoyalties
    function royaltyInfo(address, uint256 tokenId)
        public
        view
        override
        returns (address receiver, uint256 basisPoint)
    {
				// manage your own royalties.
        receiver = owner();
        // gets 10% royalties
        basisPoint = 1000;
    }

    /// @inheritdoc	INFModuleTokenURI
    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        return tokenURI(msg.sender, tokenId);
    }

    /// @inheritdoc	INFModuleTokenURI
    function tokenURI(address, uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
			// manage your own tokenURI.
			return string(abi.encodePacked(baseURI, tokenId.toString(), '.json'));
		}

		function mint() {
			// mint the next nft to msg.sender
			// there is no URI because it's managed in this contract
			// there are no royaltiesRecipient nor royaltieSamount because it's manage in this contract
			INiftyForge721(nftContract).mint(msg.sender, '', address(0), 0, address(0));
		}
}
```