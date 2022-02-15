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