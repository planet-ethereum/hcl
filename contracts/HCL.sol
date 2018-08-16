pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";


contract HCL {
  using SafeMath for uint256;

  event SourceClosed();
  event SourceOpened();
  event OwnershipTransferred(address to);
  event TaxPaid(uint256 amount);

  // Object being licensed,
  // potentially an ens domain
  bytes32 public object;

  // License holder, potentially
  // a multisig
  address public holder;

  uint256 public price;

  uint256 public stake;

  uint256 public lastCollectedTax;

  // 0x0 => nobody may use
  // 0x1 => only open-source projects may freely use
  // 0x2 => proprietary projects may also use
  // 0x3 => proprietary projects may also modify
  uint8 public permissions;

  uint16 constant TAX_PERCENT = 7;

  // Other licenses this license
  // depends on
  // []address dependencies;

  modifier isOpen() {
    require(permissions == 0x1);
    _;
  }

  modifier isClosed() {
    require(permissions == 0x0);
    _;
  }

  modifier isHolder() {
    require(holder == msg.sender);
    _;
  }

  constructor (bytes32 object_, address holder_) public {
    object = object_;
    holder = holder_;
    permissions = 0x1;
  }

  /**
   * @dev If a license holder wants to close their
   *      source, they specify their price and
   *      stake some ether, from which the tax will be deducted.
   * 
   * @param price_ Self-assessed price of license object
   */
  function closeSource(uint256 price_) public payable isHolder isOpen {
    require(msg.value > 0);

    permissions = 0x0;
    price = price_;
    lastCollectedTax = now;
    stake = msg.value;

    emit SourceClosed();
  }

  /**
   * @dev Anyone can call this function with value = price
   *      and open the source.
   */
  function free(address newHolder_) public payable isClosed {
    require(msg.value == price);

    holder.transfer(price);

    holder = newHolder_;
    price = 0;
    permissions = 0x1;
  }

  /**
   * @dev Anyone can call this function to calculate
   *      how much tax should be paid since the last
   *      payment. If there's not enough stake the permission
   *      will change to open source.
   */
  function payTax() public isClosed {
    uint256 duration = now - lastCollectedTax;
    uint256 amount = price.mul(TAX_PERCENT).mul(duration).div(
      (100 * 12 * 30 * 24 * 60 * 60)
    );

    if (stake < amount) {
      permissions = 0x1;
      emit SourceOpened();
      return;
    }


    stake = stake - amount;
    lastCollectedTax = now;

    emit TaxPaid(amount);
  }

  function topUpStake() public payable isHolder isClosed {
    require(msg.value > 0);

    stake = stake + msg.value;
  }

  function transferOwnership(address holder_) public isHolder {
    payTax();
    holder.transfer(stake);

    holder = holder_;

    emit OwnershipTransferred(holder_);
  }
}
