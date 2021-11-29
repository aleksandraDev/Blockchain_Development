mapping(address => uint) public balanceOf;

// Insecure
function transfer(address _to, uint256 _value) {
  // Check if sender has balance
  require(balanceOf[msg.sender] >= _value);
  // Add and substract new balances
  balancesOf[msg.sender] -= _value;
  balanceOf[_to] += _value;
}

// Secure
function transfer(address _to, uint _value) {
  // Check if sender has balance and for overflows
  require(balanceOf(msg.sender) >= _value && balanceOf[_to] + _value >= balanceOf[_to]);
  
  // Add and substract new balances
  balanceOf[msg.sender] -= _value;
  balanceOf[_to] += _value;
}