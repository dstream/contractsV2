//-----------------------------------------------------------------------------------------------------------------------//
//                                                                                                                       //
//  8 8888          8 8888 8 888888888o   8 8888888888   8 888888888o. 8888888 8888888888   .8.            d888888o.     //
//  8 8888          8 8888 8 8888    `88. 8 8888         8 8888    `88.      8 8888        .888.         .`8888:' `88.   //
//  8 8888          8 8888 8 8888     `88 8 8888         8 8888     `88      8 8888       :88888.        8.`8888.   Y8   //
//  8 8888          8 8888 8 8888     ,88 8 8888         8 8888     ,88      8 8888      . `88888.       `8.`8888.       //
//  8 8888          8 8888 8 8888.   ,88' 8 888888888888 8 8888.   ,88'      8 8888     .8. `88888.       `8.`8888.      //
//  8 8888          8 8888 8 8888888888   8 8888         8 888888888P'       8 8888    .8`8. `88888.       `8.`8888.     //
//  8 8888          8 8888 8 8888    `88. 8 8888         8 8888`8b           8 8888   .8' `8. `88888.       `8.`8888.    //
//  8 8888          8 8888 8 8888      88 8 8888         8 8888 `8b.         8 8888  .8'   `8. `88888.  8b   `8.`8888.   //
//  8 8888          8 8888 8 8888    ,88' 8 8888         8 8888   `8b.       8 8888 .888888888. `88888. `8b.  ;8.`8888   //
//  8 888888888888  8 8888 8 888888888P   8 888888888888 8 8888     `88.     8 8888.8'       `8. `88888. `Y8888P ,88P'   //
//                                                                                                                       //
//-----------------------------------------------------------------------------------------------------------------------//
//                                          Made with ❤ by Anudit Nagar                                                 //
//-----------------------------------------------------------------------------------------------------------------------//

// SPDX-License-Identifier: MIT
pragma solidity >=0.6.10 <0.7.0;

library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        return c;
    }

}

interface ILibertas {
    function disableAd(uint256 _adID) external;
    function disableVideo(uint256 _videoID) external;
}

contract LibertasVoting {

    using SafeMath for uint256;

    address public owner;
    ILibertas public libertas;

    mapping (address => uint256) public addressToStakeLevel;
    uint256[] stakeLevels = [1 ether, 2 ether, 3 ether, 4 ether, 5 ether];
    uint256 slashedFundAmount = 0;

    modifier onlyOwner () {
      require(msg.sender == owner);
      _;
    }

    constructor() public{
        owner = msg.sender;
    }

    function updateLibertas(address _libertasAddress) public onlyOwner {
        libertas = ILibertas(_libertasAddress);
    }

    function updateStakeAmount(uint256 _level, uint256 _amount) public onlyOwner {
        stakeLevels[_level] = _amount;
    }

    function stake(uint256 _level) public payable{
        require(_level > addressToStakeLevel[msg.sender]);
        require(stakeLevels[_level] == msg.value);
        addressToStakeLevel[msg.sender] = _level;
    }

    function slashStake(address staker) public {
        uint256 amt = stakeLevels[addressToStakeLevel[staker]];
        addressToStakeLevel[staker] = 0;
        slashedFundAmount = slashedFundAmount.add(amt);
    }



}
