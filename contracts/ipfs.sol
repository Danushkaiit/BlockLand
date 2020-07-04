pragma solidity >=0.4.21 <0.7.0;

contract ipfs {
    string ipfsHashGet;

    function sendHash(string memory _ipfsHashGet) public {
        ipfsHashGet = _ipfsHashGet;
    }

    function get() public view returns(string memory) {
        return ipfsHashGet;
    }
}