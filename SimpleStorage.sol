// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.0 <0.9.0;

//In case of any issues while runnning solidity in vscode
// file/preferences/settings
//seacrh solidity
//go into solidity configuration and check "remote compiler version" matches with our code

contract SimpleStorage
{
    // uint256 favNum=7;//uint256->unsgined integer of 256 bits
    // int256 favNegNum=-7;
    // bool favBool=true;
    // string favString="String";
    // bytes32 favByte="somethingCool";
    // address favAddress=0x8685De4413c68DCf55dE6A566252517B2696affB;

    uint256 public num;//When nothing is specified it gets initialised to 0;

    //There are 4 function visibility modes in solidity:-
    // 1.Public
    // Can be accessed 
    // (i) Within the contract 
    // (ii) Within Derived contract 
    // (iii) Within outside contract                     
    // (iv) Within other contract 

    // 2.Private
    // Can be accessed 
    // (i) Within the contract 

    // 3.Internal
    // Can be accessed 
    // (i) Within the contract 
    // (ii) Within Derived contract 

    // 4.External
    // Can be accessed 
    // (ii) Within Derived contract 
    // (iii) Within outside contract                     
    // (iv) Within other contract 

    // If no visibility mode is mentioned then the default visibility mode is internal

    function storeVal1(uint256 _num) public 
    {
        num=_num;
    }
    function storeVal2(uint256 _num) private
    {
        num=_num;
        storeVal1(_num);
        storeVal3(_num);
    }
    function storeVal3(uint256 _num) internal
    {
        num=_num;
    }
    function storeVal4(uint256 _num) external 
    {
        num=_num;
        storeVal2(_num);
    }

    //After deployment the yellow boxes indicate that, whenever a yellow box function is called, a transaction is executed.
    //Blue boxes indicate transactionless Functions or Variables.

    //If we use the keyword "pure" or "view", then we can create a transactionless function. 

    //1. Pure Functions:-
    //  -They neither read from the state nor alter the state.

    //2. View Functions:-
    //  -They only read form the state but do not alter the state.

    function retrieve() public view returns(uint256)
    {
        return num;
    }

    function retrieve1(uint256 a,uint256 b) public pure returns(uint256)
    {
        return a+b;
    }
    function retrieve2(uint256 a,uint256 b) public view returns(uint256)
    {
        return a+b+num;
    }

    //Structs in solidity {Similar to classes}
    struct people
    {
        uint256 favNumber;
        string favName;
    }

    people public person=people({favNumber:99,favName:"yuvraj"});//creating an object of type people

    // Creating an array of type people
    // people[size integer] public arrayOfPeople;//Fixed size array

    people[] public arrayOfPeople;//Dynamic array
    mapping(string=>uint256) public nameToNumber;//This basically creates a (key,value) pair dictionary.

    //Creating a function to add persons to the array

    //Here, we have to use the "memory" keyword to store a string because its not actually a dataType but an array of a dataType(Bytes).
    //For such storage we have two keywords:-
    // 1.Memory
    //  -The data is stored only during execution of the function.
    // 2.Storage
    //  -The data is stored even after the execution of the function
    function addPerson(uint256 _favNumber,string memory _favName) public 
    {
        arrayOfPeople.push(people({favName:_favName,favNumber:_favNumber}));
        nameToNumber[_favName]=_favNumber;
    }

    //In order to actually deploy your smart contract on a network, we first need to connect our IDE with our metamask Account.
    //This can be done by switching the environment to => Injected Provider - MetaMask .
}
