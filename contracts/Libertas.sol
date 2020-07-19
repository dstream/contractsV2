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
pragma solidity >=0.6.11 <0.7.0;

// import "Sablier.sol";

interface Sablier {
    /**
     * @notice Emits when a stream is successfully created.
     */
    event CreateStream(
        uint256 indexed streamId,
        address indexed sender,
        address indexed recipient,
        uint256 deposit,
        address tokenAddress,
        uint256 startTime,
        uint256 stopTime
    );

    /**
     * @notice Emits when the recipient of a stream withdraws a portion or all their pro rata share of the stream.
     */
    event WithdrawFromStream(uint256 indexed streamId, address indexed recipient, uint256 amount);

    /**
     * @notice Emits when a stream is successfully cancelled and tokens are transferred back on a pro rata basis.
     */
    event CancelStream(
        uint256 indexed streamId,
        address indexed sender,
        address indexed recipient,
        uint256 senderBalance,
        uint256 recipientBalance
    );

    function balanceOf(uint256 streamId, address who) external view returns (uint256 balance);

    function getStream(uint256 streamId)
        external
        view
        returns (
            address sender,
            address recipient,
            uint256 deposit,
            address token,
            uint256 startTime,
            uint256 stopTime,
            uint256 balance,
            uint256 rate
        );

    function createStream(address recipient, uint256 deposit, address tokenAddress, uint256 startTime, uint256 stopTime)
        external
        returns (uint256 streamId);

    function withdrawFromStream(uint256 streamId, uint256 funds) external returns (bool);

    function cancelStream(uint256 streamId) external returns (bool);
}

interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);

    function approve(address spender, uint256 value) external returns (bool);

    function transferFrom(address from, address to, uint256 value) external returns (bool);

    function totalSupply() external view returns (uint256);

    function balanceOf(address who) external view returns (uint256);

    function allowance(address owner, address spender) external view returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

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

        struct Creator {
            string name;
            string imageHash;
            uint256 subscriberCnt;
            uint256 views;
        }

        struct Video {
            uint256 videoID;
            bool isEnabled;
            address owner;
            string videoHash;
            string thumbnailHash;
            string title;
            string description;
            uint256 duration;
            uint256 uploadtime;
            uint256 category;
            uint256[] streams;
        }

        struct VideoExtra {
            uint256 videoID;
            uint256 availableSponsorsCnt;
            address[] availableSponsors;
            address activeSponsor;
            uint256 activeAdID;
            address[] subscribers;
            uint256 viewCnt;
        }

        struct Ad {
            uint256 adID;
            bool isEnabled;
            address owner;
            string imageHash;
            string link;
            uint256 category;
            uint256 amountPerSecond;
            uint256 budget;
            uint256 time;
        }

        struct Advertiser {
            uint256 advertiserID;
            bool isEnabled;
            address billingAccount;
            string name;
            uint256 reportCnt;
        }

        struct Live {
            bool isEnabled;
            bool isPaid;
            string title;
            string desc;
            address[] fromAdd;
            uint256 watchCount;
            uint256[] streamIDs;
            uint256 duration;
            uint256 rate;
            string connID;

        }
}

contract Libertas {

    using SafeMath for uint256;

    address public owner;
    Sablier public sablier = Sablier(0xE1D1D66A37C22cCCfbbbbD15Dc77B41c44BF681f);
    IERC20 public ANC;

    uint256 public videoCount = 0;
    DataStructs.Video[] public videos;
    DataStructs.VideoExtra[] public videosExtra;
    mapping (address => uint256[]) public addressToVideos;

    uint256 public adCount = 0;
    DataStructs.Ad[] public ads;
    mapping (address => uint256[]) public advertiserToAdIDs;
    mapping (address => mapping (uint256 => uint256)) public advertiserToVideoToAd;

    uint256 public advertiserCount = 0;
    DataStructs.Advertiser[] public advertisers;
    mapping (address => uint256) public advertiserToId;

    mapping (address => address[]) public subscribers;
    mapping (address => DataStructs.Creator) public creatorData;

    mapping (address => DataStructs.Live) public liveStreams;

    event VideoView(address indexed _watcher, uint256 indexed _videoID, uint256 indexed _streamID);
    event LiveStreamJoined(address indexed _streamer, address indexed _watcher, uint256 _streamID);
    event LiveStreamConnectionUpdated(address indexed _streamer, string _connID);
    event LiveStreamStarted(address indexed _streamer, string _connID);
    event LiveStreamEnded(address indexed _streamer);
    event SponsorUpdated(uint256 indexed _videoID, uint256 indexed _adID);
    event NewSponsor(uint256 indexed _videoID, uint256 indexed _adID);

    constructor(address _ANCAdress) public {
        owner = msg.sender;

        ANC = IERC20(_ANCAdress);

        DataStructs.Advertiser memory emptyAdv;
        advertisers.push(emptyAdv);
        DataStructs.Ad memory emptyAd;
        ads.push(emptyAd);
        DataStructs.Video memory emptyVideo;
        videos.push(emptyVideo);
        DataStructs.VideoExtra memory emptyVideoExtra;
        videosExtra.push(emptyVideoExtra);
    }

    function updateSablier(address newSablierContract) public {
        require(msg.sender == owner);
        sablier = Sablier(newSablierContract);
    }

    function updateANC(address newTokenContract) public {
        require(msg.sender == owner);
        ANC = IERC20(newTokenContract);
    }

    function createVideo(string memory _videoHash, string memory _thumbnailHash, string memory _title, string memory _description, uint256 _duration, uint256 _category)
        public
    {

        uint256[] memory tempStreams;
        uint256 videoID = videoCount.add(1);

        videos.push( DataStructs.Video({
            videoID : videoID,
            isEnabled : true,
            owner : msg.sender,
            videoHash : _videoHash,
            thumbnailHash : _thumbnailHash,
            title : _title,
            description : _description,
            duration: _duration,
            uploadtime: now,
            category : _category,
            streams : tempStreams
        }));

        address[] memory tempAvailableSponsors;
        address[] memory tempSubscribers;
        videosExtra.push( DataStructs.VideoExtra({
            videoID : videoID,
            availableSponsorsCnt : 0,
            availableSponsors: tempAvailableSponsors,
            activeSponsor : address(0x0),
            activeAdID : 0,
            subscribers : tempSubscribers,
            viewCnt : 0
        }));

        addressToVideos[msg.sender].push(videoID);
        videoCount = videoCount.add(1);
    }

    function updateVideoTitle(uint256 _vid, string memory _title)
        public
    {
        require(msg.sender == videos[_vid].owner);
        videos[_vid].title = _title;
    }

    function updateVideoDescription(uint256 _vid, string memory _description)
        public
    {
        require(msg.sender == videos[_vid].owner);
        videos[_vid].description = _description;
    }

    function updateVideoThumbnail(uint256 _vid, string memory _thumbnailHash)
        public
    {
        require(msg.sender == videos[_vid].owner);
        videos[_vid].thumbnailHash = _thumbnailHash;
    }

    function createAd(string memory _imageHash, string memory _link, uint256 _category, uint256 _amountPerSecond, uint256 _budget )
        public
        payable
    {
        require(advertisers[advertiserToId[msg.sender]].isEnabled == true, "Invalid Advertiser");
        require(ANC.balanceOf(msg.sender) >= _budget, "Not Enough Allowance");
        require(ANC.allowance(msg.sender, address(this)) >= _budget, "Not Enough Allowance");
        require(ANC.transferFrom(msg.sender, address(this), _budget), "Transfer Error");

        uint newAdID = adCount.add(1);
        ads.push(DataStructs.Ad({
            adID : newAdID,
            isEnabled : true,
            owner : msg.sender,
            imageHash : _imageHash,
            link : _link,
            category : _category,
            amountPerSecond : _amountPerSecond,
            budget : _budget,
            time: now
        }));

        advertiserToAdIDs[msg.sender].push(newAdID);
        adCount = adCount.add(1);
    }

    function getAdvAdCnt(address  _address)
        public
        view
        returns (uint256 _adCnt)
    {
        return advertiserToAdIDs[_address].length;
    }

    function getAdvAdIDs(address  _address)
        public
        view
        returns (uint256[] memory _adIDs)
    {
        return advertiserToAdIDs[_address];
    }

    function increaseAdBudget(uint256 _adID,uint256 _amt)
        public
        payable
    {
        require(ads[_adID].isEnabled == true, "Invalid Ad");
        require(ads[_adID].owner == msg.sender, "Invalid Sender");
        require(_amt != 0, "Budget cannot be 0");
        require(ANC.balanceOf(msg.sender) >= _amt, "Not Enough Allowance");
        require(ANC.allowance(msg.sender, address(this)) >= _amt, "Not Enough Allowance");
        require(ANC.transferFrom(msg.sender, address(this), _amt), "Transfer Error");
        ads[_adID].budget = ads[_adID].budget.add(_amt);
    }

    function withdrawAdBudget(uint256 _adID,uint256 _amt)
        public
    {
        require(msg.sender == ads[_adID].owner, "Invalid Sender");
        require(_amt != 0, "Withdraw amount cannot be 0");
        require(_amt <= ads[_adID].budget, "Withdraw amount more than budget");
        ads[_adID].budget = ads[_adID].budget.sub(_amt);
        ANC.transfer(ads[_adID].owner, _amt);
    }

    function withdrawAdBudgetFull(uint256 _adID)
        public
    {
        require(msg.sender == ads[_adID].owner, "Invalid Sender");
        ANC.transfer(ads[_adID].owner, ads[_adID].budget);
    }

    function createAdvertiser(string memory _name)
        public
    {
        require(advertiserToId[msg.sender] == 0, "Advertiser already registered");
        uint newAdvID = advertiserCount.add(1);

        advertisers.push(DataStructs.Advertiser({
            advertiserID : newAdvID,
            isEnabled : true,
            billingAccount : msg.sender,
            name : _name,
            reportCnt : 0
        }));

        advertiserToId[msg.sender] = newAdvID;
        advertiserCount = advertiserCount.add(1);

    }
    function updateAdvertiserName(string memory _name)
        public
    {
        require(advertiserToId[msg.sender] != 0, "Advertiser not registered");
        advertisers[advertiserToId[msg.sender]].name = _name;
    }

    function sponsorVideo(uint256  _videoID, uint256  _adID)
        public
        returns (uint256 state)
    {
        require(videos[_videoID].isEnabled == true, "Invalid Video");
        require(ads[_adID].isEnabled == true, "Invalid Ad");
        require(ads[_adID].owner == msg.sender, "Invalid Sender");

        bool alreadySponsored = false;
        for (uint256 i=0; i < videosExtra[_videoID].availableSponsors.length; i=i.add(1)){
            if (videosExtra[_videoID].availableSponsors[i] == msg.sender){
                alreadySponsored = true;
            }
        }

        if (alreadySponsored == true){
            return 0;
        }
        else {
            videosExtra[_videoID].availableSponsors.push(msg.sender);
            videosExtra[_videoID].availableSponsorsCnt = videosExtra[_videoID].availableSponsorsCnt.add(1);
            advertiserToVideoToAd[msg.sender][_videoID] = _adID;
            emit SponsorUpdated(_videoID, _adID);
            return 1;
        }
    }

    function getSponsors(uint256  _videoID)
        public
        view
        returns (address[] memory)
    {
        require(videos[_videoID].isEnabled == true, "Invalid Video");
        return videosExtra[_videoID].availableSponsors;
    }

    function selectSponsor(uint256  _videoID, uint256  _adID)
        public
    {
        require(videos[_videoID].isEnabled == true, "Invalid Video");
        require(videos[_videoID].owner == msg.sender, "Invalid Video");

        bool validSponsor = false;
        for (uint256 i=0; i < videosExtra[_videoID].availableSponsorsCnt; i=i.add(1)){
            if (videosExtra[_videoID].availableSponsors[i] == ads[_adID].owner){
                validSponsor = true;
            }
        }

        require(validSponsor == true, "Video not sponsored by this Address");


        videosExtra[_videoID].activeSponsor = ads[_adID].owner;
        videosExtra[_videoID].activeAdID = _adID;
        emit SponsorUpdated(_videoID, _adID);
    }

    function getVideoCnt(address _user)
        public
        view
        returns (uint256 videoCnt)
    {
        return addressToVideos[_user].length;
    }

    function getVideoIDsByAddress(address _user)
        public
        view
        returns (uint256[] memory videoCnt)
    {
        return addressToVideos[_user];
    }

    function getVideoStreamIDs(uint256 _videoID)
        public
        view
        returns (uint256[] memory streamIDs)
    {
        return videos[_videoID].streams;
    }

    function watchVideo(uint256 _videoID)
        public
    {
        require(videos[_videoID].isEnabled == true);
        uint256 adCost = videos[_videoID].duration*ads[videosExtra[_videoID].activeAdID].amountPerSecond;
        ANC.approve(address(sablier), adCost);

        uint256 streamID = 0;
        if (videosExtra[_videoID].activeSponsor != address(0x0)){

            if (ads[videosExtra[_videoID].activeAdID].budget >= adCost){
                streamID = sablier.createStream(
                    videos[_videoID].owner,
                    adCost,
                    address(ANC),
                    now.add(15 seconds),
                    now.add(15 seconds).add(videos[_videoID].duration)
                );
                require(streamID != 0, "Streaming money error.");
                ads[videosExtra[_videoID].activeAdID].budget  = (ads[videosExtra[_videoID].activeAdID].budget).sub(adCost);
                videos[_videoID].streams.push(streamID);
            }
        }
        videosExtra[_videoID].viewCnt = videosExtra[_videoID].viewCnt.add(1);
        creatorData[videos[_videoID].owner].views = creatorData[videos[_videoID].owner].views.add(1);
        emit VideoView(msg.sender, _videoID, streamID);
    }

    function stopVideo(uint256 _streamID)
        public
    {
        require(sablier.cancelStream(_streamID));
    }

    function subscribe(address _creator)
        public
    {
        subscribers[msg.sender].push(_creator);
        creatorData[_creator].subscriberCnt = creatorData[_creator].subscriberCnt.add(1);
    }

    function unsubscribe(address _creator)
        public
    {
        for (uint256 i=0; i < subscribers[msg.sender].length; i=i.add(1)){
            if (subscribers[msg.sender][i] == _creator){
                delete subscribers[msg.sender][i];
                break;
            }
        }
        creatorData[_creator].subscriberCnt = creatorData[_creator].subscriberCnt.sub(1);
    }

    function updateCreatorName(string memory _name)
        public
    {
        creatorData[msg.sender].name = _name;
    }

    function updateCreatorImage(string memory _hash)
        public
    {
        creatorData[msg.sender].imageHash = _hash;
    }

    function getCreatorDataByVideo(uint256 _videoID)
        public
        view
        returns (
            string memory name,
            string memory imageHash,
            uint256 subscriberCnt,
            uint256 views
        )
    {
        require (videos[_videoID].isEnabled == true);
        return (creatorData[videos[_videoID].owner].name,
                creatorData[videos[_videoID].owner].imageHash,
                creatorData[videos[_videoID].owner].subscriberCnt,
                creatorData[videos[_videoID].owner].views
        );
    }

    function startLiveStream(string memory _connID, bool _isPaid, uint256 _duration, uint256 _rate, string memory _title, string memory _desc)
        public
    {

        liveStreams[msg.sender].isEnabled = true;
        liveStreams[msg.sender].isPaid = _isPaid;
        liveStreams[msg.sender].duration = _duration;
        liveStreams[msg.sender].rate = _rate;
        liveStreams[msg.sender].title = _title;
        liveStreams[msg.sender].desc = _desc;
        liveStreams[msg.sender].connID = _connID;

        emit LiveStreamConnectionUpdated(msg.sender, _connID);
    }

    function endLiveStream()
        public
    {
        liveStreams[msg.sender].isEnabled = false;
        emit LiveStreamEnded(msg.sender);
    }

    function updateLiveStreamConnection(string memory _connID)
        public
    {
        require(liveStreams[msg.sender].isEnabled == true, "Live Stream not Enabled");
        liveStreams[msg.sender].connID = _connID;
        emit LiveStreamConnectionUpdated(msg.sender, _connID);
    }

    function joinLiveStream(address _streamerAddress)
        public
    {
        require(liveStreams[_streamerAddress].isEnabled == true, "Invalid Stream");

        uint256 streamID = 0;
        if (liveStreams[_streamerAddress].isPaid == true){
            uint256 liveStreamCost = liveStreams[_streamerAddress].rate.mul(liveStreams[_streamerAddress].duration);

            require(ANC.balanceOf(msg.sender) >= liveStreamCost, "Not Enough Allowance");
            require(ANC.allowance(msg.sender, address(this)) >= liveStreamCost, "Not Enough Allowance");
            require(ANC.transferFrom(msg.sender, address(this), liveStreamCost), "Transfer Error");
            require(ANC.approve(address(sablier), liveStreamCost), "Unable to approve Sablier");
            streamID = sablier.createStream(
                _streamerAddress,
                liveStreamCost,
                address(ANC),
                now.add(15 seconds),
                now.add(15 seconds).add(liveStreams[_streamerAddress].duration)
            );
            liveStreams[_streamerAddress].streamIDs.push(streamID);

        }

        liveStreams[_streamerAddress].fromAdd.push(msg.sender);
        liveStreams[_streamerAddress].watchCount = liveStreams[_streamerAddress].watchCount.add(1);
        emit LiveStreamJoined(_streamerAddress, msg.sender, streamID);

    }

    //Testing Function TO BE REMOVED
    function app(uint256 amt) public {
        ANC.approve(address(sablier), amt);
    }
    //Testing Function TO BE REMOVED
    function simples(address receiver, uint256 amount, address tokenAddress, uint256 startTime, uint256 endTime) public {
        sablier.createStream(
            receiver,
            amount,
            tokenAddress,
            startTime,
            endTime
        );
    }
    //Testing Function TO BE REMOVED
    function withdrawAdmin() public {
        ANC.transfer(owner, ANC.balanceOf(address(this)));
    }
}
