import {readFileSync} from 'fs';
import {expect, use} from 'chai';
import {getDefaultProvider, Wallet} from 'ethers';
import {deployErc998Explorer} from '../src/deploy';
import {Erc998ExplorerFactory} from '../build';
import {solidity} from 'ethereum-waffle';

use(solidity);

describe('Test 2', () => {
    const erc998Address = '0x4d31d9B48CDBe23AcE6F5A46E5c54C4B3d59B920';

    const deploymentFile = readFileSync('secrets/deployment.json', 'utf8');
    const deployment = JSON.parse(deploymentFile);
    const provider = getDefaultProvider(deployment.network);
    const deployer = new Wallet(deployment.privateKey, provider);

    it('Read from erc998', async () => {
        let erc998Explorer = Erc998ExplorerFactory.connect("0xcfD18592Aa9cAf6fC8E8b63Fe92F3AF4e3E9eC9e", deployer);
        let data1 = await erc998Explorer.getDataByToken(erc998Address, 3);
        let data2 = await erc998Explorer.getData(erc998Address, 1, 1, 1, [1, 3, 5, 7]);
    });

});
