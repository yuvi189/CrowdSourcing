// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./SimpleStorage.sol";

contract StorageFactoryPattern is SimpleStorage//is keyword is used for inheritance
{
    SimpleStorage[] public arrayOfSS;

    function createNewSimpleStoragewContract() public 
    {
        SimpleStorage newSSContract=new SimpleStorage();
        arrayOfSS.push(SimpleStorage(newSSContract));
    }


    function callStoreValue1(uint256 simpleContractIndex,uint256 _favouriteNumber) public 
    {
        //Whenever we need to interact with another contract, we need two things:-
        //1.Address of the Contract
        //2.ABI{Application Binary Interface}
        SimpleStorage newSSContract=SimpleStorage(address(arrayOfSS[simpleContractIndex]));
        newSSContract.storeVal1(_favouriteNumber);
    }
    function callRetrieveSS(uint256 simpleContractIndex) public view returns(uint256)
    {
        //Whenever we need to interact with another contract, we need two things:-
        //1.Address of the Contract
        //2.ABI{Application Binary Interface}
        SimpleStorage newSSContract=SimpleStorage(address(arrayOfSS[simpleContractIndex]));
        uint retrievedNumber=newSSContract.retrieve();
        return retrievedNumber;
    }
}