pragma solidity >=0.4.21 <0.7.0;

contract recordR {
    address admin;

    struct deedRecord{
        bytes32 registrationId;
        bytes32 landParcelNo;
        string province;
        string district;
        string town;
        string gnDivision;
        address[] owner;
        bytes32 status;
    }

    mapping(bytes32 => deedRecord) land;
    mapping(bytes32 => bool) mappingLand;

    modifier lrAdmin() {
        require(msg.sender == admin);
        _;
    }

    modifier newDeed(bytes32 _deedId){
        require(!mappingLand[_deedId]);
        _;
    }

    modifier existingDeed(bytes32 _deedId){
        require(mappingLand[_deedId]);
        _;
    }

    event AddDeed(
        bytes32 deedId,
        bytes32 registrationId,
        bytes32 landParcelNo,
        string province,
        string district,
        string town,
        string gnDivision,
        address owner,
        uint created
    );

    event AddOwner(
        bytes32 ddeId,
        address owner,
        uint created
    );

    event SetStatus(
        bytes32 deedId,
        bytes32 status,
        uint created
    );

    constructor() public{
        admin = msg.sender;
    }

    function addDeed(
        bytes32 _deedId,
        bytes32 _registrationId,
        bytes32 _landParcelNo,
        string memory _province,
        string memory _district,
        string memory _town,
        string memory _gnDivision,
        address _owner,
        bytes32 _status,
        uint _created
    ) public lrAdmin newDeed(_deedId) {
        land[_deedId].registrationId = _registrationId;
        land[_deedId].landParcelNo = _landParcelNo;
        land[_deedId].province = _province;
        land[_deedId].district = _district;
        land[_deedId].town = _town;
        land[_deedId].gnDivision = _gnDivision;
        land[_deedId].owner.push(_owner);
        land[_deedId].status = _status;

        mappingLand[_deedId] = true;

        emit AddDeed(
            _deedId,
            _registrationId,
            _landParcelNo,
            _province,
            _district,
            _town,
            _gnDivision,
            _owner,
            _created
        );
    }

    function addOwner(
        bytes32 _deedId,
        address _owner,
        uint _created
    ) public lrAdmin existingDeed(_deedId){

        land[_deedId].owner.push(_owner);

        emit AddOwner(
            _deedId,
            _owner,
            _created
        );
    }

    function setStatus(
        bytes32 _deedId,
        bytes32 _status,
        uint _created
    ) public lrAdmin existingDeed(_deedId) {
        land[_deedId].status = _status;

        emit SetStatus(
            _deedId,
            _status,
            _created
        );
    }

    function getStatus(bytes32 _deedId) public view existingDeed(_deedId) returns(
        bytes32
    ) {
        return (
            land[_deedId].status
        );
    }

    function fallback() public payable{}
}