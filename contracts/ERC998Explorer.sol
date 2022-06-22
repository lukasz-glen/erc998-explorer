// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./interfaces/IERC998ERC721TopDownEnumerable.sol";
import "./interfaces/IERC998ERC20TopDownEnumerable.sol";
import "./interfaces/IERC998ERC20TopDown.sol";
import "./interfaces/IERC998ERC1155TopDownEnumerable.sol";
import "./interfaces/IERC998ERC1155TopDown.sol";

contract ERC998Explorer {
    struct ChildTokens {
        address childContract;
        uint256[] childTokenIds;
    }
    struct TokenChildren {
        uint256 totalChildContracts;
        ChildTokens[] childTokens;
    }
    struct Erc20Tokens {
        address erc20Contract;
        uint256 amount;
    }
    struct TokenErc20s {
        uint256 totalERC20Contracts;
        Erc20Tokens[] erc20Tokens;
    }
    struct Erc1155Tokens {
        uint256 erc1155TokenId;
        uint256 amount;
    }
    struct Erc1155Contracts {
        address erc1155Contract;
        uint256 totalERC1155Tokens;
        Erc1155Tokens[] erc1155Tokens;
    }
    struct TokenErc1155s {
        uint256 totalERC1155Contracts;
        Erc1155Contracts[] erc1155Contracts;
    }

    function getErc721(address erc998, uint256 limitChildContracts, uint256 limitChildTokenIds, uint256[] calldata tokenIds) public view returns (TokenChildren[] memory) {
        IERC998ERC721TopDownEnumerable target = IERC998ERC721TopDownEnumerable(erc998);
        uint256 til = tokenIds.length;
        TokenChildren[] memory allTokenChildren = new TokenChildren[](til);
        for (uint256 i = 0; i < til; i++) {
            uint256 tokenId = tokenIds[i];
            uint256 tcc = target.totalChildContracts(tokenId);
            uint256 maxChildContracts = tcc < limitChildContracts ? tcc : limitChildContracts;
            TokenChildren memory tokenChildrenData = TokenChildren({totalChildContracts: tcc, childTokens: new ChildTokens[](maxChildContracts)});
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

    function getErc721ByToken(address erc998, uint256 tokenId) public view returns (TokenChildren memory) {
        IERC998ERC721TopDownEnumerable target = IERC998ERC721TopDownEnumerable(erc998);
        uint256 tcc = target.totalChildContracts(tokenId);
        TokenChildren memory tokenChildrenData = TokenChildren({totalChildContracts: tcc, childTokens: new ChildTokens[](tcc)});
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
            TokenErc20s memory tokenErc20sData = TokenErc20s({totalERC20Contracts: tec, erc20Tokens: new Erc20Tokens[](maxErc20Contracts)});
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

    function getErc20ByToken(address erc998, uint256 tokenId) public view returns (TokenErc20s memory) {
        IERC998ERC20TopDownEnumerable target = IERC998ERC20TopDownEnumerable(erc998);
        IERC998ERC20TopDown target_ = IERC998ERC20TopDown(erc998);
        uint256 tec = target.totalERC20Contracts(tokenId);
        TokenErc20s memory tokenErc20sData = TokenErc20s({totalERC20Contracts: tec, erc20Tokens: new Erc20Tokens[](tec)});
        for (uint256 j = 0; j < tec; j++) {
            address erc20Contract = target.erc20ContractByIndex(tokenId, j);
            uint256 balance = target_.balanceOfERC20(tokenId, erc20Contract);
            Erc20Tokens memory erc20TokensData = Erc20Tokens({erc20Contract: erc20Contract, amount: balance});
            tokenErc20sData.erc20Tokens[j] = erc20TokensData;
        }
        return tokenErc20sData;
    }

    function getErc1155(address erc998, uint256 limitErc1155Contracts, uint256 limitErc1155TokenIds, uint256[] calldata tokenIds) public view returns (TokenErc1155s[] memory) {
        IERC998ERC1155TopDownEnumerable target = IERC998ERC1155TopDownEnumerable(erc998);
        IERC998ERC1155TopDown target_ = IERC998ERC1155TopDown(erc998);
        TokenErc1155s[] memory allTokenErc1155s = new TokenErc1155s[](tokenIds.length);
        for (uint256 i = 0; i < tokenIds.length; i++) {
            uint256 tokenId = tokenIds[i];
            uint256 tec = target.totalERC1155Contracts(tokenId);
            uint256 maxErc1155Contracts = tec < limitErc1155Contracts ? tec : limitErc1155Contracts;
            TokenErc1155s memory tokenErc1155sData = TokenErc1155s({totalERC1155Contracts: tec, erc1155Contracts: new Erc1155Contracts[](maxErc1155Contracts)});
            allTokenErc1155s[i] = tokenErc1155sData;
            for (uint256 j = 0; j < maxErc1155Contracts; j++) {
                address erc1155Contact = target.erc1155ContractByIndex(tokenId, j);
                uint256 tet = target.totalERC1155Tokens(tokenId, erc1155Contact);
                uint256 maxErc1155TokenIds = tet < limitErc1155TokenIds ? tet : limitErc1155TokenIds;
                Erc1155Contracts memory erc1155ContractData = Erc1155Contracts({erc1155Contract: erc1155Contact,  totalERC1155Tokens: tet, erc1155Tokens: new Erc1155Tokens[](maxErc1155TokenIds)});
                tokenErc1155sData.erc1155Contracts[j] = erc1155ContractData;
                for (uint256 k = 0; k < maxErc1155TokenIds; k++) {
                    uint256 erc1155TokenId = target.erc1155TokenByIndex(tokenId, erc1155Contact, k);
                    uint256 balance = target_.balanceOfERC1155(tokenId, erc1155Contact, erc1155TokenId);
                    erc1155ContractData.erc1155Tokens[k] = Erc1155Tokens({erc1155TokenId : erc1155TokenId, amount : balance});
                }
            }
        }
        return allTokenErc1155s;
    }

    function getErc1155ByToken(address erc998, uint256 tokenId) public view returns (TokenErc1155s memory) {
        IERC998ERC1155TopDownEnumerable target = IERC998ERC1155TopDownEnumerable(erc998);
        IERC998ERC1155TopDown target_ = IERC998ERC1155TopDown(erc998);
        uint256 tec = target.totalERC1155Contracts(tokenId);
        TokenErc1155s memory tokenErc1155sData = TokenErc1155s({totalERC1155Contracts: tec, erc1155Contracts: new Erc1155Contracts[](tec)});
        for (uint256 j = 0; j < tec; j++) {
            address erc1155Contact = target.erc1155ContractByIndex(tokenId, j);
            uint256 tet = target.totalERC1155Tokens(tokenId, erc1155Contact);
            Erc1155Contracts memory erc1155ContractData = Erc1155Contracts({erc1155Contract: erc1155Contact,  totalERC1155Tokens: tet, erc1155Tokens: new Erc1155Tokens[](tet)});
            tokenErc1155sData.erc1155Contracts[j] = erc1155ContractData;
            for (uint256 k = 0; k < tet; k++) {
                uint256 erc1155TokenId = target.erc1155TokenByIndex(tokenId, erc1155Contact, k);
                uint256 balance = target_.balanceOfERC1155(tokenId, erc1155Contact, erc1155TokenId);
                erc1155ContractData.erc1155Tokens[k] = Erc1155Tokens({erc1155TokenId : erc1155TokenId, amount : balance});
            }
        }
        return tokenErc1155sData;
    }

    function getData(address erc998, uint256 limitChildContracts, uint256 limitChildTokenIds,
                     uint256 limitErc20Contracts, uint256 limitErc1155Contracts, uint256 limitErc1155TokenIds,
                     uint256[] calldata tokenIds) public view returns (TokenChildren[] memory, TokenErc20s[] memory, TokenErc1155s[] memory) {
        TokenChildren[] memory allTokenChildren = getErc721(erc998, limitChildContracts, limitChildTokenIds, tokenIds);
        TokenErc20s[] memory allTokenErc20s = getErc20(erc998, limitErc20Contracts, tokenIds);
        TokenErc1155s[] memory allTokenErc1155s = getErc1155(erc998, limitErc1155Contracts, limitErc1155TokenIds, tokenIds);
        return (allTokenChildren, allTokenErc20s, allTokenErc1155s);
    }

    function getDataByToken(address erc998, uint256 tokenId) public view returns (TokenChildren memory, TokenErc20s memory, TokenErc1155s memory) {
        TokenChildren memory tokenChildrenData = getErc721ByToken(erc998, tokenId);
        TokenErc20s memory tokenErc20sData = getErc20ByToken(erc998, tokenId);
        TokenErc1155s memory tokenErc1155sData = getErc1155ByToken(erc998, tokenId);
        return (tokenChildrenData, tokenErc20sData, tokenErc1155sData);
    }

}