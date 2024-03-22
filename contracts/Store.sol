// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./@openzeppelin/contracts/utils/Counters.sol";
import "./@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./@openzeppelin/contracts/security/ReentrancyGuard.sol";


contract Store is ReentrancyGuard {
  using Counters for Counters.Counter;
  Counters.Counter private _ticketsSold;
  Counters.Counter private _ticketsNumber;
  uint256 public BASIC_PRICE = 0.0001 ether;
  address payable private _storeOwner;
  mapping(uint256 => Ticket) private _idToTicket;

  struct Ticket {
       address ticketContract;
       uint256 ticketId;
       address payable seller;
       address payable maker;
       string ticketURI;
       string name;
       uint256 price;
       bool isAvailable;
   }

  event TicketCreated(
    address ticketContract,
    uint256 ticketId,
    address seller,
    address maker,
    uint256 price
  );
  event TicketSold(
    address ticketContract,
    uint256 tiketId,
    address seller,
    address maker,
    uint256 price
  );

  constructor() {
    _storeOwner = payable(msg.sender);
  }


  // List the NFT on the marketplace
  function createTicket(address _nftContract, uint256 _tokenId, string memory _name, string memory _ticketURI) public payable nonReentrant {
      require(msg.value > 0, "Price must >= 0.0001 ether");
      require(msg.value == BASIC_PRICE, "Not enough ether create ticket");

      IERC721(ticketContract).transferFrom(msg.sender, address(this), _ticketId);

      _ticketsNumber.increment();

      _idToTicket[_ticketId] = Ticket(
          ticketContract, 
          _ticketId, 
          payable(msg.sender),
          payable(address(this)), 
          _ticketURI,
          _name, 
          BASIC_PRICE,
          true
      );

      emit TicketCreated(ticketContract, ticketId, msg.sender, address(this), BASIC_PRICE);

  }

  // Buy an NFT
  function buyTicket(address ticketContract, uint256 ticketId) public payable nonReentrant  {
     address owner = IERC721(ticketContract).ownerOf(ticketId);
     Ticket storage ticket = _idToTicket[ticketId];
     require(msg.value >= ticket.price, "Not enough ether");

     address buyer = payable(msg.sender);
     payable(ticket.seller).transfer(msg.value);
     IERC721(ticketContract).setApprovalForAll(buyer,true);
     IERC721(ticketContract).approve(buyer, ticketId);
     IERC721(ticketContract).transferFrom(owner, buyer, ticket.tokenId);

     _storeOwner.transfer(BASIC_PRICE);
     ticket.owner = payable(buyer);
     ticket.isAvailable = false;

    _ticketsSold.increment();
    emit TicketSold(ticketContract, ticket.ticketId, ticket.seller, buyer, msg.value);
  }


}
