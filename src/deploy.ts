import {Wallet} from 'ethers';
import {Erc998ExplorerFactory} from '../build';


export async function deployErc998Explorer(deployer: Wallet) {
    console.log('Starting deployment of ERC998 Explorer:');

    const factory = new Erc998ExplorerFactory(deployer);
    const contract = await factory.deploy();
    await contract.deployed();
    console.log(`Contract deployed at ${contract.address}`);

    return contract.address;
}

