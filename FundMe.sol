// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";//This import statement is the same as writing the entire code of the AggregatorV3Interface above our fundMe Contract

// interface AggregatorV3Interface 
// {
//   function decimals() external view returns (uint8);

//   function description() external view returns (string memory);

//   function version() external view returns (uint256);

//   function getRoundData(uint80 _roundId)
//     external
//     view
//     returns (
//       uint80 roundId,
//       int256 answer,
//       uint256 startedAt,
//       uint256 updatedAt,
//       uint80 answeredInRound
//     );

//   function latestRoundData()
//     external
//     view
//     returns (
//       uint80 roundId,
//       int256 answer,
//       uint256 startedAt,
//       uint256 updatedAt,
//       uint80 answeredInRound
//     );
// }




contract FundMe 
{
    mapping(address => uint256) public amountFunded;
    address public owner;
    address[] public funders;

    constructor() public   //The constructor is called immediatelty when the contract is deployed
    { owner=msg.sender;  //Since we deploy the contract,we are the sender and thus the owner.
    }
    


    function getVersionInfo() public view returns(uint256)
    {
      AggregatorV3Interface priceFeed=AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
      return priceFeed.version();
    }

    function getPrice()public view returns(uint256)
    {
      AggregatorV3Interface priceFeed=AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);// ETH/USD ADDRESS

      //Below is the syntax and creation of a tuple
      //We have kept the fields which we do not require as blank, so that the compiler is happy :>
      (,int256 answer,,,)=priceFeed.latestRoundData();
      return uint256(answer);
      //the returned value is actually the actual value ^(10^8) because it is a uint256 value and 256=2^8
    }


    function getConversionRate() public view returns(uint256)
    {
      uint256 oneEthToUsd=getPrice();//this returns the USD value of 1ETH
      return uint256(oneEthToUsd/10**10);
    } 

    function fund() public payable //Using the payable keyword you can send/receive money along with the function call
    {
      uint256 conversionrate=getConversionRate();
      uint256 minValUsd=50;
      uint256 actualVal=(msg.value*conversionrate)/(10**16);
      require(actualVal >= minValUsd,"not enough ETH Kanjoos");
      amountFunded[msg.sender]+=uint256(msg.value*conversionrate);
      //Basically, funding of a smart contract will be in ETH but we want to relate it with a usual currency say the USD$.
      //For that, we need to know the USD -> ETH Conversion Rates
      //By default, the value returned is in WEI
      //Actual Amount in USD=(value returned by this function)/(10^16)

      funders.push(msg.sender);
    }

    modifier onlyOwner
    {
      require(msg.sender==owner);//msg.sender is the person who calls the function.
      _;
    }




    // Withdrawing
    //This function is basically used by a person who had funded some ether on the contract, to withdraw their ether.
    function withdraw()  public payable onlyOwner
    {
      (payable(msg.sender)).transfer(address(this).balance);//This basically sends back ethereum from the contract funding, back to the sender.
                                                           //address(this) => address of the contract.
      for(uint256 i=0; i<funders.length;i++)
      {
        address funder=funders[i];
        amountFunded[funder]=0;
      }
      funders=new address[](0);//resetting the funders array
    }
}