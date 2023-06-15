// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SimpleToken is ERC20{
    address public owner;
    struct Minter{
        bool canMint;
        uint256 allowance;
    }
    mapping(address=>Minter) private minters;

    modifier onlyOwner(){
        require(msg.sender == owner,"You are not the owner" );
        _;
    }

    modifier onlyMinters(){
        require(minters[msg.sender].canMint == true,"Only minters can call this function");
        _;
    }

    constructor(
        string memory name,
        string memory symbol,
        uint256 initialSupply
    ) ERC20(name,symbol){
        owner = msg.sender;
        minters[owner].canMint = true;
        _mint(msg.sender,initialSupply);
    }

    function mint(address account, uint256 allowance) public onlyMinters{
        require(msg.sender == owner || minters[msg.sender].canMint == true,'Only minters can call this function');
        _mint(account,allowance);
        minters[msg.sender].allowance -=allowance;
    }

    function addMinter(address minterAddress,uint256 allowance) public onlyOwner{
        require(minters[minterAddress].canMint == false,'Minter already exists');
        minters[minterAddress].canMint = true;
        minters[minterAddress].allowance = allowance;
    }

    function removeMinter(address minterAddress) public onlyOwner{
        require(minterAddress != owner,"Owner can not be removed");
        require(minters[minterAddress].canMint == true,'Minter does not exist');
        minters[minterAddress].canMint = false;
        minters[minterAddress].allowance = 0;
    }

    function setMintAllowance(address minterAddress,uint256 allowance) public onlyOwner{
        require(minters[minterAddress].canMint == true,"Minter does not exist");
        minters[minterAddress].allowance = allowance;
    }
}
