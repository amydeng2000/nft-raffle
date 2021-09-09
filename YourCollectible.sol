pragma solidity >=0.6.0 <0.7.0;
//SPDX-License-Identifier: MIT

//import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
//learn more: https://docs.openzeppelin.com/contracts/3.x/erc721

// GET LISTED ON OPENSEA: https://testnets.opensea.io/get-listed/step-two

contract YourCollectible is ERC721, Ownable {

  enum RAFFLE_STATE { OPEN, CLOSED}
    RAFFLE_STATE public raffle_state;
    uint256 public raffleId;
    address payable[] public players;
    uint256 public _tokenId;

    // price to enter raffle is 0.1ETH
    uint256 public PRICE = 1000000000000000;

    constructor() public ERC721("RaffleGame", "RGM")
    {
        raffle_state = RAFFLE_STATE.CLOSED;
        raffleId = 1;
        _setBaseURI("https://ipfs.io/ipfs/");
    }

    function start_raffle() public {
        require(raffle_state == RAFFLE_STATE.CLOSED, "The raffle should be closed, but something went wrong!");
        raffle_state = RAFFLE_STATE.OPEN;
    }

    // call with MyContract.foo().send({from: _from, value: _value")}
    function enter() public payable {
        assert(msg.value == PRICE);
        assert(raffle_state == RAFFLE_STATE.OPEN);
        players.push(msg.sender);
    }

    function close_raffle() public {
        require(raffle_state == RAFFLE_STATE.OPEN, "The raffle should be open, but something went wrong!");
        raffle_state = RAFFLE_STATE.CLOSED;
        raffleId = raffleId + 1;
    }

    function mintItem(address to, string memory tokenURI)
      public
      returns (uint256)
  {
      _tokenId = _tokenId + 1;
      _mint(to, _tokenId);
      _setTokenURI(_tokenId, tokenURI);
      return _tokenId;
  }
}
