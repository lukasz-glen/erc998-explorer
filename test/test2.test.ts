import {readFileSync} from 'fs';
import {expect, use} from 'chai';
import {getDefaultProvider, Wallet} from 'ethers';
import {deployErc998Explorer} from '../src/deploy';
import {Erc998ExplorerFactory} from '../build';
import {solidity} from 'ethereum-waffle';

use(solidity);

describe('Test 2', () => {
    const erc998Address = '0xA7aCE4695d56762572812B9F1E6c91FAdD46cA30';

    const deploymentFile = readFileSync('secrets/deployment.json', 'utf8');
    const deployment = JSON.parse(deploymentFile);
    const provider = getDefaultProvider(deployment.network);
    const deployer = new Wallet(deployment.privateKey, provider);

    it('Read from erc998', async () => {
        let erc998Explorer = Erc998ExplorerFactory.connect("0xf0C659F430C1F05f62283e916B631f84e8DB3F4F", deployer);
        let data1 = await erc998Explorer.getDataByToken(erc998Address, 1);
        console.log(data1)
        let data2 = await erc998Explorer.getData(erc998Address, 1, 1, 1, 1, 1, [1, 3, 5, 7]);
        console.log(data2[0]);
    });

});
