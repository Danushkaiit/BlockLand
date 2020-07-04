pragma solidity >=0.4.21 <0.7.0;

import "./contracts/recordR.sol" as recordR;
import "./contracts/landCoin.sol" as landCoin;


contract blockLand is recordR, landCoin{
    address admin;

    struct deedRecord{
        bytes32 landParcelId;
        address owner;
        address buyer;

        uint landPrice;
        uint tokenAmount;
        uint registrationFee; 

        bytes status;
    }

    mapping (bytes32 => deedRecord) registration;
    mapping (bytes32 => bool) MappingRegistry;

    modifier lrAdmin() {
        require(msg.sender == admin);
        _;
    }

    modifier newDeedRegistry(bytes32 landParcelId) {
        require(!MappingRegistry[landParcelId]);
        _;
    }

    modifier existingRegistry(bytes32 landParcelId){
        require(!MappingRegistry[landParcelId]);
        _;
    }

    event addDeedRecord(
        bytes32 landParcelId,
        bytes32 attributeId, //property
        uint created
    );

    event addBuyer(
        bytes32 landParcelId,
        bytes32 attributeId,
        address buyer,
        uint created
    );

    event setRegistrationFee(
        bytes32 landParcelId,
        bytes32 attributeId,
        uint registrationCharge,
        uint created
    );

    event setStatus(
        bytes32 landParcelId,
        bytes32 attributeId,
        bytes32 status,
        uint created
    );

    event tokenTransfer(
        bytes32 landParcelId,
        bytes32 attributeId,
        address from,
        address to,
        uint amount,
        uint ctrated
    );

    constructor() public{
        admin = msg.sender;
        allowedTokens = allowedTokens_;
        allowedTokens_ = 1000000000000;
        blances[msg.sender] = 1000000000000;
    }

    function getBalance(address _address) public view returns(uint){
        return balances[_address];
    }

    function getAllowedToken() public view returns(uint) {
        return allowedTokens_;
    }

    function addAllowedToken(uint _tokens) public view lrAdmin{
        allowedTokens_ += _tokens;
        blances[msg.sender] += _tokens;
    }

    function addDeedRecords(
        bytes32 _landParcelId,
        bytes32 _attributeId,
        address _owner,
        uint _tokenAmount,
        uint _created
    ) public lrAdmin newDeedRegistry(_landParcelId) {
        
        registration[_landParcelId].attributeId = _attributeId;
        registration[_landParcelId].owner = _owner;
        registration[_landParcelId].tokenAmount = _tokenAmount;
    
        MappingRegistry[_landParcelId] = true;

        emit addDeedRecord(
            _landParcelId,
            _attributeId,
            _owner,
            _tokenAmount,
            _created
        );

    }
    function addBuyers(
        bytes32 _landParcelId,
        bytes32 _attributeId,
        address _buyer,
        uint _created
    ) public lrAdmin existingRegistry(_landParcelId){
        registration[_landParcelId].buyer = _buyer;

        emit addBuyer(
            _landParcelId,
            _attributeId,
            _buyer,
            _created
        );
    }

    function setRegistrationFees(
        bytes32 _registrationId,
        bytes32 _attributeId,
        uint _registrationFee,
        uint _created
    ) public lrAdmin existingRegistry(_registrationId) {
        registration[_registrationId].registrationFee = _registrationFee;
    
        emit setRegistrationFees(
            _registrationId,
            _attributeId,
            _registrationFee,
            _created
        );
    }

    function setStatusA(
        bytes32 _registrationId,
        bytes32 _attributeId,
        bytes32 _status,
        uint _created
    ) public lrAdmin existingRegistry(_registrationId){
        registration[_registrationId].status = _status;

        emit setStatus(
            _registrationId,
            _attributeId,
            _status,
            _created
        );
    }

    function tokenTransferA(
        bytes32 _registrationId,
        bytes32 _attributeId,
        address _from,
        address _to,
        uint _amount,
        uint _created
    ) public lrAdmin{

        emit tokenTransfer(
            _registrationId,
            _attributeId,
            _from,
            _to,
            _amount,
            _created
        );
    }

    function fallback()public payable {}

    function close() public lrAdmin {
        selfdestruct(admin);
    }
}