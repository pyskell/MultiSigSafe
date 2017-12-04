pragma solidity 0.4.18;

contract MultiSigSafe {
    
    // INITIALIZING OWNERS
    address constant public owner0 = 0x9Bb9459a6B2c78Be5057874A8b7560Bd675E9655; // elaine
    address constant public owner1 = 0xcC858994Ba2Ad9D79f05778493d8943908bb7F3D; // cody (dontpanicburns)
    address constant public owner2 = 0x8c2E4bAf8b50Ad99413E2d76b30c05675Ec3B2B4; // anthony (pyskell)
    address constant public owner3 = 0x21a6203d774e966f2d4185cad0096759ba323fee; // MikO
    address constant public owner4 = 0x5465e25037BF201f582Ab8d829CA89f8aA21d15a; // OmniEdge
    address constant public owner5 = 0xb5187e9dF7c11A32D98616F9C4c70cbd4fb81c5B; // D34D
    address constant public owner6 = ; // matt (snaproll) - Address TBD
    
    // INITIALIZING GLOBAL PUBLIC VARIABLES
    uint8 constant public threshold = 2;            // Number of valid signatures for executing Tx
    uint256 constant public limit = 1000*10**18;    // Limit of one Tx; modify at deploy time if needed
    uint256 public nonce;                           // to prevent multiple Tx executions

    function execute(uint8[] sigV, bytes32[] sigR, bytes32[] sigS, address destination, uint256 value, bytes data) public {

        // VALIDATE INPUTS
        require(value <= limit);                    // check value below limits
        require(sigV.length == 7 && sigR.length == 7 && sigS.length == 7);

        // VERIFYING OWNERS
        // Follows ERC191 signature scheme: https://github.com/ethereum/EIPs/issues/191
        // calculate hash
        bytes32 txHash = keccak256(byte(0x19), byte(0), this, destination, value, data, nonce);

        // count recovered if signature of owner0 is valid         
        uint8 recovered = 0;
        if (owner0 == ecrecover(txHash, sigV[0], sigR[0], sigS[0])) recovered = recovered + 1; 
        if (owner1 == ecrecover(txHash, sigV[1], sigR[1], sigS[1])) recovered = recovered + 1;
        if (owner2 == ecrecover(txHash, sigV[2], sigR[2], sigS[2])) recovered = recovered + 1;
        if (owner3 == ecrecover(txHash, sigV[3], sigR[3], sigS[3])) recovered = recovered + 1;
        if (owner4 == ecrecover(txHash, sigV[4], sigR[4], sigS[4])) recovered = recovered + 1;
        if (owner5 == ecrecover(txHash, sigV[5], sigR[5], sigS[5])) recovered = recovered + 1;
        if (owner6 == ecrecover(txHash, sigV[6], sigR[6], sigS[6])) recovered = recovered + 1;
  
        // VALIDATE CONFIGURATION
        require(recovered >= threshold);            // validate configuration

        // NONCE
        nonce = nonce + 1;                          // count nonce to avoid multiple Tx executions

        // SENDING Tx
        require(destination.call.value(value)(data));  // send Tx, throws if not successfull

    }

    function () public payable {}     

}
