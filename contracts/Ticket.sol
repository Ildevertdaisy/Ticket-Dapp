// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "./@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "./@openzeppelin/contracts/utils/Counters.sol";

contract Ticket is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _ticketsIds;
    address storeContract;
    event STOREMinted(uint256);

    constructor(address _store) ERC721("Store", "STR") {
        storeContract = _store;
    }

    function mint(string memory _storeURI) public {
        uint256 newTicketId = _ticketsIds.current();
        _mint(msg.sender, newTicketId);

        _setTokenURI(newTicketId, _storeURI);
        setApprovalForAll(storeContract, true);
        _ticketsIds.increment();
    }
}

