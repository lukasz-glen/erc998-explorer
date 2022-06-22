import {readFileSync} from 'fs';
import {getDefaultProvider, Wallet} from 'ethers';
import {deployErc998Explorer} from './deploy';
import {Network} from '@ethersproject/networks'

async function run(args: string[]) {
    if (args.length !== 1) {
        throw new Error('Invalid number of arguments');
    }

    const deploymentFile = readFileSync(args[0], 'utf8');
    const deployment = JSON.parse(deploymentFile);
    const provider = getDefaultProvider(deployment.network);
    const deployer = new Wallet(deployment.privateKey, provider);

    await deployErc998Explorer(deployer);
}


run(process.argv.slice(2))
    .catch(e => {
        console.error(e);
        process.exit(1);
    });
