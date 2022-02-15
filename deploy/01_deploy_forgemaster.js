// deploy/00_deploy_my_contract.js
module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy } = deployments;
    const { deployer } = await getNamedAccounts();

    const NiftyForge721 = await deployments.get('NiftyForge721');

    await deploy('ForgeMaster', {
        from: deployer,
        proxy: {
            proxyContract: 'OpenZeppelinTransparentProxy',
            execute: {
                init: {
                    methodName: 'initialize',
                    args: [
                        true,
                        ethers.utils.parseEther('0.025'), // fees when not free
                        25, // free contracts
                        NiftyForge721.address, // erc721Implementation
                        ethers.constants.AddressZero, // erc1155implementation
                        ethers.constants.AddressZero, // owner
                    ],
                },
            },
        },
        log: true,
    });
};

module.exports.tags = ['ForgeMaster'];
module.exports.dependencies = ['NiftyForge721'];
