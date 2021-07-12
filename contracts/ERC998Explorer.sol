// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./interfaces/IERC998ERC721TopDownEnumerable.sol";
import "./interfaces/IERC998ERC20TopDownEnumerable.sol";
import "./interfaces/IERC998ERC20TopDown.sol";

contract ERC998Explorer {
    struct ChildTokens {
        address childContract;
        uint256[] childTokenIds;
    }
    struct TokenChildren {
        ChildTokens[] childTokens;
    }
    struct Erc20Tokens {
        address erc20Contract;
        uint256 amount;
    }
    struct TokenErc20s {
        Erc20Tokens[] erc20Tokens;
    }

    function getErc721(address erc998, uint256 limitChildContracts, uint256 limitChildTokenIds, uint256[] calldata tokenIds) public view returns (TokenChildren[] memory) {
        IERC998ERC721TopDownEnumerable target = IERC998ERC721TopDownEnumerable(erc998);
        uint256 til = tokenIds.length;
        TokenChildren[] memory allTokenChildren = new TokenChildren[](til);
        for (uint256 i = 0; i < til; i++) {
            uint256 tokenId = tokenIds[i];
            uint256 tcc = target.totalChildContracts(tokenId);
            uint256 maxChildContracts = tcc < limitChildContracts ? tcc : limitChildContracts;
            TokenChildren memory tokenChildrenData = TokenChildren({childTokens: new ChildTokens[](maxChildContracts)});
            allTokenChildren[i] = tokenChildrenData;
            for (uint256 j = 0; j < maxChildContracts; j++) {
                address childContract = target.childContractByIndex(tokenId, j);
                uint256 tct = target.totalChildTokens(tokenId, childContract);
                uint256 maxChildTokenIds = tct < limitChildTokenIds ? tct : limitChildTokenIds;
                ChildTokens memory childTokensData = ChildTokens({childContract: childContract, childTokenIds: new uint256[](maxChildTokenIds)});
                tokenChildrenData.childTokens[j] = childTokensData;
                for (uint256 k = 0; k < maxChildTokenIds; k++) {
                    uint256 childTokenId = target.childTokenByIndex(tokenId, childContract, k);
                    childTokensData.childTokenIds[k] = childTokenId;
                }
            }
        }
        return allTokenChildren;
    }

    function getErc721(address erc998, uint256 tokenId) public view returns (TokenChildren memory) {
        IERC998ERC721TopDownEnumerable target = IERC998ERC721TopDownEnumerable(erc998);
        uint256 tcc = target.totalChildContracts(tokenId);
        TokenChildren memory tokenChildrenData = TokenChildren({childTokens: new ChildTokens[](tcc)});
        for (uint256 j = 0; j < tcc; j++) {
            address childContract = target.childContractByIndex(tokenId, j);
            uint256 tct = target.totalChildTokens(tokenId, childContract);
            ChildTokens memory childTokensData = ChildTokens({childContract: childContract, childTokenIds: new uint256[](tct)});
            tokenChildrenData.childTokens[j] = childTokensData;
            for (uint256 k = 0; k < tct; k++) {
                uint256 childTokenId = target.childTokenByIndex(tokenId, childContract, k);
                childTokensData.childTokenIds[k] = childTokenId;
            }
        }
        return tokenChildrenData;
    }

    function getErc20(address erc998, uint256 limitErc20Contracts, uint256[] calldata tokenIds) public view returns (TokenErc20s[] memory) {
        IERC998ERC20TopDownEnumerable target = IERC998ERC20TopDownEnumerable(erc998);
        IERC998ERC20TopDown target_ = IERC998ERC20TopDown(erc998);
        uint256 til = tokenIds.length;
        TokenErc20s[] memory allTokenErc20s = new TokenErc20s[](til);
        for (uint256 i = 0; i < til; i++) {
            uint256 tokenId = tokenIds[i];
            uint256 tec = target.totalERC20Contracts(tokenId);
            uint256 maxErc20Contracts = tec < limitErc20Contracts ? tec : limitErc20Contracts;
            TokenErc20s memory tokenErc20sData = TokenErc20s({erc20Tokens: new Erc20Tokens[](maxErc20Contracts)});
            allTokenErc20s[i] = tokenErc20sData;
            for (uint256 j = 0; j < maxErc20Contracts; j++) {
                address erc20Contract = target.erc20ContractByIndex(tokenId, j);
                uint256 balance = target_.balanceOfERC20(tokenId, erc20Contract);
                Erc20Tokens memory erc20TokensData = Erc20Tokens({erc20Contract: erc20Contract, amount: balance});
                tokenErc20sData.erc20Tokens[j] = erc20TokensData;
            }
        }
        return allTokenErc20s;
    }

    function getErc20(address erc998, uint256 tokenId) public view returns (TokenErc20s memory) {
        IERC998ERC20TopDownEnumerable target = IERC998ERC20TopDownEnumerable(erc998);
        IERC998ERC20TopDown target_ = IERC998ERC20TopDown(erc998);
        uint256 tec = target.totalERC20Contracts(tokenId);
        TokenErc20s memory tokenErc20sData = TokenErc20s({erc20Tokens: new Erc20Tokens[](tec)});
        for (uint256 j = 0; j < tec; j++) {
            address erc20Contract = target.erc20ContractByIndex(tokenId, j);
            uint256 balance = target_.balanceOfERC20(tokenId, erc20Contract);
            Erc20Tokens memory erc20TokensData = Erc20Tokens({erc20Contract: erc20Contract, amount: balance});
            tokenErc20sData.erc20Tokens[j] = erc20TokensData;
        }
        return tokenErc20sData;
    }
}