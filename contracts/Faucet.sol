// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.7.0;

interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);

    function totalSupply() external view returns (uint256);

    function balanceOf(address who) external view returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 value);

}


contract Faucet {

    address public owner;
    uint256 public sendAmount;
    mapping (address => uint) public lastSent;
    uint public blockLimit;
    IERC20 public ANC;

    constructor (address _tokenAddress) public {
        owner = msg.sender;
        sendAmount = 10 * (10**18);
        blockLimit = 50;
        ANC = IERC20(_tokenAddress);
    }

	function getBalance() public view returns (uint){
	     return ANC.balanceOf(address(this));
	}

	function getWei() public {
	    require(lastSent[msg.sender] < (block.number-blockLimit), "Too Soon");
	    require(ANC.balanceOf(address(this)) >= sendAmount, "Insufficient Funds");
        lastSent[msg.sender] = block.number;
        ANC.transfer(msg.sender, sendAmount);
	}

	function sendWei(address receiver) public {
		require(lastSent[msg.sender] < (block.number-blockLimit), "Too Soon");
	    require(ANC.balanceOf(address(this)) >= sendAmount, "Insufficient Funds");
	    ANC.transfer(receiver, sendAmount);
        lastSent[receiver] = block.number;
	}

	function getRemainingBlocks() public view returns (uint){
	    if(blockLimit>(block.number-lastSent[msg.sender]))
            return blockLimit-(block.number-lastSent[msg.sender]);
        else
            return 0;
	}

	function setBlockLimit(uint limit) public returns (bool){
        require(msg.sender==owner);
	    blockLimit = limit;
	}
	function setSendAmount(uint256 val) public returns (bool){
	    require(msg.sender==owner);
	    sendAmount = val;
	}

	function withdrawAll() public {
	   require(msg.sender==owner);
	   ANC.transfer(msg.sender, ANC.balanceOf(address(this)));
	}
}
