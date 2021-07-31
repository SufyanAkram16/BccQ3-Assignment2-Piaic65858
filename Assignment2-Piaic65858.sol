  // SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract Bank  {
    
     uint8 private totalAccounts;
     uint private totalBalance;
     
     event Deposite(address, uint);
     event Withdrwal(address, uint);
     event log(string);
     
     address payable private  owner = payable(msg.sender);
     
     mapping (address => uint) private balances;
     mapping (address => bool) public userExist;
     
     modifier ownerOnly() {
         require (owner == msg.sender);
         _;
     }
     
     
     
     // step 1: The owner can start the bank with initial deposit/capital in ether (min 50 eths)
     
     
     constructor()  payable {
        require(msg.value >= 50 ether, "50 Ethers required to open a bank.");
        balances[owner] = msg.value;
        owner = payable(msg.sender);
        emit log("The Bank is Opened");
      }
      
      
      // Srep 2: Only the owner can close the bank. Upon closing the balance should return to the Owner
      //only owner can closeBank 
      
     function closeBank() ownerOnly() public{
         selfdestruct(owner);
         emit log("The Bank is Closed");
     }
     
     
     
     //Step 3: Anyone can open an account in the bank for Account opening they need to deposit ether with address
    // step 7: First 5 accounts will get a bonus of 1 ether in bonus
    
     function openAccount(uint _amount) public returns (string memory){
         
          require(userExist[msg.sender] == false, "Account already created");
          
          if(totalAccounts < 5){
             balances[msg.sender] += (_amount *10**18) + 1 ether;
             totalBalance += (_amount *10**18) + 1 ether;
         }
         else {
             balances[msg.sender] += _amount *10**18;
             totalBalance += _amount *10**18;
         }
         userExist[msg.sender]=true;
         totalAccounts++;
         emit Deposite(msg.sender, _amount);
         return "Account is created";
     }
     
     
     //Step 5: Anyone can deposit in the bank
     function deposite(address _add, uint _amount) payable  external {
          
             balances[_add] += _amount *10**18;
             totalBalance += _amount *10**18;
             payable(msg.sender).transfer(_amount);
         
         emit Deposite(_add, _amount);
     }
     
     
     // Step 6:Only valid account holders can withdraw
     
     function withdrwal(uint _amount) payable  public {
         // to convert wei(_amount) into ether
         uint amount = _amount * 10 ** 18;
         require (amount > 0 && msg.sender != address(0), "The amount should not be 0 or Invalid Address");
         require (amount<= balances[msg.sender], "Invalid bank account");
         
         if(amount <= balances[msg.sender]){
         balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
         }
         emit Withdrwal(msg.sender, amount);
         
         
         }
     
     //Step 4: Bank will maintain balances of accounts
     //Step 8: Account holder can inquiry balance
     function checkbalance()  public view returns(uint) {
         return balances[msg.sender];
     }
     
     //step 9:The depositor can request for closing an account
     
     function closeAccount() public payable{
         require(userExist[msg.sender]==true);
         payable(msg.sender).transfer(balances[msg.sender]);
     }
    
    //only owner can invoke 
     function totaldeposite() ownerOnly() view public returns(uint){
         return totalBalance;
     }
    
    //only owner can invoke 
     function noOfAccounts()ownerOnly() public view returns(uint){
         return totalAccounts;
     }
     
    
     
}
