//-----------------------------------------------------------------------------------------------------------------------//
//                                                                                                                       //
//  8 8888          8 8888 8 888888888o   8 888888888888 8 888888888o. 8888888 8888888888   .8.            d888888o.     //
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
//                                               Articles Extension                                                      //
//                                          Made with ❤ by Anudit Nagar                                                 //
//-----------------------------------------------------------------------------------------------------------------------//

// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.7.0;

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

library DataStructs {

    struct Article {
        uint256 ID;
        address payable controller;
        uint256 category;

        bool active;
        bool published;
        string title;
        string dataHash;
        uint256 lastUpdated;

        bool isPaid;
        uint256 cost;
        uint256 earnings;
    }

}

contract LibertasArticles {

    using SafeMath for uint256;

    address payable owner;

    uint256 public costMultiplier = 100;

    mapping (string => bool) public pseudonymTaken;
    mapping (address => string) public addressToPseudonym;

    uint256 public lastArticleID = 0;
    mapping (address => uint256[]) public addressToArticleIDs;
    DataStructs.Article[] public Articles;

    event NewArticle(address indexed _controller, uint256 indexed _articleID);
    event PaidForArticle(address indexed _user, uint256 indexed _articleID);
    event ArticleUpdate(uint256 indexed _articleID, string _title,  string _newHash);
    event GotATip(uint256 indexed _articleID, address indexed _controller, uint256 _amount);

    modifier onlyOwner () {
      require(msg.sender == owner, "Restricted Access");
      _;
    }

    constructor() public {
        owner = msg.sender;
        string memory temp = 'owner';
        pseudonymTaken[temp] = true;
        addressToPseudonym[msg.sender] = temp;

        Articles.push( DataStructs.Article({
            ID: 0,
            controller : address(0x0),
            active : false,
            category : 0,
            published : false,
            title:'',
            dataHash : '',
            lastUpdated: 0,
            isPaid : false,
            cost : 0,
            earnings : 0
        }));
    }

    // start owner functions

    function withdrawBalance()
        public onlyOwner
    {
        owner.transfer(address(this).balance);
    }

    function setCostMultiplier(uint256 _costMultiplier)
        public onlyOwner
    {
        require(costMultiplier != _costMultiplier, "Same State");
        require(_costMultiplier >= 0, "Cost Multipler is Negative");
        costMultiplier = _costMultiplier;
    }

    // end owner functions


    function getStringLength(string memory _s) internal pure returns (uint length) {
        bytes memory bs = bytes(_s);
        return bs.length;
    }

    function calcCost(uint256 _length) public view returns (uint256 cost){
        if(_length>10){
             return 0;
        }
        else{
            return ((10**18) / _length.mul(_length)).mul(costMultiplier);
        }
    }

    function claimPseudonym(string memory _name)
        public payable
    {
        require(msg.value == calcCost(getStringLength(_name)), "Insufficient Amount");
        require(pseudonymTaken[_name] == false, "Pseudonym Taken");

        pseudonymTaken[_name] = true;
        addressToPseudonym[msg.sender] = _name;

    }

    function createArticle(bool _published, string memory _title, string memory _dataHash, bool _isPaid, uint256 _cost, uint256 _category)
        public
    {

        uint256 newArticleID = lastArticleID.add(1);

        Articles.push( DataStructs.Article({
            ID: newArticleID,
            controller : msg.sender,
            active : true,
            category : _category,
            published : _published,
            title: _title,
            dataHash : _dataHash,
            lastUpdated: block.timestamp,
            isPaid : _isPaid,
            cost : _cost,
            earnings : 0
        }));

        addressToArticleIDs[msg.sender].push(newArticleID);
        lastArticleID = newArticleID;
    }

    function createArticleAnonymous(string memory _title, string memory _dataHash, uint256 _category)
        public
    {

        uint256 newArticleID = lastArticleID.add(1);

        Articles.push( DataStructs.Article({
            ID: newArticleID,
            controller : address(0x0),
            active : true,
            category : _category,
            published : true,
            title: _title,
            dataHash : _dataHash,
            lastUpdated: block.timestamp,
            isPaid : false,
            cost : 0,
            earnings : 0
        }));

        addressToArticleIDs[address(0x0)].push(newArticleID);
        lastArticleID = newArticleID;
    }

    function payForArticle(address payable _forAddress, uint256 _articleID)
        public payable
    {
        require(Articles[_articleID].isPaid == true, "Article is not Paid");
        require(Articles[_articleID].cost == msg.value, "Invalid Article Cost");
        Articles[_articleID].earnings = Articles[_articleID].earnings.add(msg.value);
        Articles[_articleID].controller.transfer(msg.value);
        emit PaidForArticle(_forAddress, _articleID);
    }

    function tipArticle(uint256 _articleID)
        public payable
    {
        Articles[_articleID].controller.transfer(msg.value);
        emit GotATip(_articleID, Articles[_articleID].controller, _articleID);
    }

    function updateArticleData(uint256 _articleID, string memory _title, string memory _dataHash)
        public
    {
        require(Articles[_articleID].controller == msg.sender, "Only Article Owner");
        Articles[_articleID].title = _title;
        Articles[_articleID].dataHash = _dataHash;
        Articles[_articleID].lastUpdated = block.timestamp;
        emit ArticleUpdate(_articleID, _title, _dataHash);
    }

    function toggleArticleVisibility(uint256 _articleID)
        public
    {
        require(Articles[_articleID].controller == msg.sender, "Only Article Owner");
        Articles[_articleID].published = !Articles[_articleID].published;
    }


    function getArticleIDs(address _address)
        public view
    returns (uint256[] memory articleIDs){
        return addressToArticleIDs[_address];
    }

}
