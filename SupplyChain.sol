pragma solidity ^0.4.24;

//Import libraries
import "../coffeecore/Ownable.sol";
import "../coffeeaccesscontrol/ConsumerRole.sol";
import "../coffeeaccesscontrol/DistributorRole.sol";
import "../coffeeaccesscontrol/FarmerRole.sol";
import "../coffeeaccesscontrol/RetailerRole.sol";


// Define a contract 'Supplychain'
contract SupplyChain is ConsumerRole, DistributorRole, FarmerRole, RetailerRole, Ownable {

  // Define a variable called 'upc' for Universal Product Code (UPC)
  uint  upc;

  // Define a variable called 'sku' for Stock Keeping Unit (SKU)
  uint  sku;

  // Define a public mapping 'items' that maps the UPC to an Item.
  mapping (uint => Item) items;

  // Define a public mapping 'itemsHistory' that maps the UPC to an array of TxHash, 
  // that track its journey through the supply chain -- to be sent from DApp.
  mapping (uint => string []) itemsHistory;
  
  // Define enum 'State' with the following values:
  enum State 
  { 
    Harvested,  // 0
    Processed,  // 1
    Packed,     // 2
    ForSale,    // 3
    Sold,       // 4
    Shipped,    // 5
    Received,   // 6
    Purchased,   // 7
    Invalid //8  Used for testing purposes
    }

  address emptyAddress = address(0);
  State constant defaultState = State.Harvested;

    // address constant public predefined_ownerID = 0x27D8D15CbC94527cAdf5eC14B69519aE23288B95;
    // address constant public predefined_originFarmerID = 0x018C2daBef4904ECbd7118350A0c54DbeaE3549A;
    // address constant public predefined_distributorID = 0xCe5144391B4aB80668965F2Cc4f2CC102380Ef0A;
    // address constant public predefined_retailerID = 0x460c31107DD048e34971E57DA2F99f659Add4f02;
    // address constant public predefined_consumerID = 0xD37b7B8C62BE2fdDe8dAa9816483AeBDBd356088;

  // Define a struct 'Item' with the following fields:
  struct Item {
    uint    sku;  // Stock Keeping Unit (SKU)
    uint    upc; // Universal Product Code (UPC), generated by the Farmer, goes on the package, can be verified by the Consumer
    address ownerID;  // Metamask-Ethereum address of the current owner as the product moves through 8 stages
    address originFarmerID; // Metamask-Ethereum address of the Farmer
    string  originFarmName; // Farmer Name
    string  originFarmInformation;  // Farmer Information
    string  originFarmLatitude; // Farm Latitude
    string  originFarmLongitude;  // Farm Longitude
    uint    productID;  // Product ID potentially a combination of upc + sku
    string  productNotes; // Product Notes
    uint    productPrice; // Product Price
    State   itemState;  // Product State as represented in the enum above
    address distributorID;  // Metamask-Ethereum address of the Distributor
    address retailerID; // Metamask-Ethereum address of the Retailer
    address consumerID; // Metamask-Ethereum address of the Consumer
  }

  // Define 8 events with the same 8 state values and accept 'upc' as input argument
  event Harvested(uint upc);
  event Processed(uint upc);
  event Packed(uint upc);
  event ForSale(uint upc);
  event Sold(uint upc);
  event Shipped(uint upc);
  event Received(uint upc);
  event Purchased(uint upc);

  // Define a modifer that verifies the Caller
  modifier verifyCaller (address _address) {
    require(msg.sender == _address); 
    _;
  }

  // Define a modifier that checks if the paid amount is sufficient to cover the price
  modifier paidEnough(uint _price) { 
    require(msg.value >= _price); 
    _;
  }
  
  // Define a modifier that checks the price and refunds the remaining balance
  modifier checkValue(uint _upc) {
    _;
    uint _price = items[_upc].productPrice;
    uint amountToReturn = msg.value - _price;    
    items[_upc].distributorID.transfer(amountToReturn);
  }

  // Define a modifier that checks if an item.state of a upc is Harvested
  modifier harvested(uint _upc) {
    require(items[_upc].itemState == State.Harvested);
    _;
  }

  // Define a modifier that checks if an item.state of a upc is Processed
  modifier processed(uint _upc) {
    require(items[_upc].itemState == State.Processed);
    _;
  }
  
  // Define a modifier that checks if an item.state of a upc is Packed
  modifier packed(uint _upc) {
    require(items[_upc].itemState == State.Packed);
    _;
  }

  // Define a modifier that checks if an item.state of a upc is ForSale
  modifier forSale(uint _upc) {
    require(items[_upc].itemState == State.ForSale);
    _;
  }

  // Define a modifier that checks if an item.state of a upc is Sold
  modifier sold(uint _upc) {
    require(items[_upc].itemState == State.Sold);
    _;
  }
  
  // Define a modifier that checks if an item.state of a upc is Shipped
  modifier shipped(uint _upc) {
    require(items[_upc].itemState == State.Shipped);
    _;
  }

  // Define a modifier that checks if an item.state of a upc is Received
  modifier received(uint _upc) {
    require(items[_upc].itemState == State.Received);
    _;
  }

  // Define a modifier that checks if an item.state of a upc is Purchased
  modifier purchased(uint _upc) {
  require(items[_upc].itemState == State.Purchased);    
    _;
  }

  // In the constructor set 'owner' to the address that instantiated the contract
  constructor() public payable {
    // owner = msg.sender;
    sku = 1;
    upc = 1;
  }

  // Define a function 'kill' if required
  function kill() public {
    //if (msg.sender == owner) {
    if (isOwner()) {
      selfdestruct(owner());
    }
  }

  // Define a function 'harvestItem' that allows a farmer to mark an item 'Harvested'
  function harvestItem(uint _upc, address _originFarmerID, string memory _originFarmName, string memory _originFarmInformation, string memory _originFarmLatitude, string memory _originFarmLongitude, string memory _productNotes) public payable
  // Call modifier to verify caller of this function
  onlyFarmer()

  {
    // Add the new item as part of Harvest
    items[sku] = Item({
      sku: sku,
      upc: _upc,
      ownerID: _originFarmerID,
      originFarmerID: _originFarmerID, 
      originFarmName: _originFarmName, 
      originFarmInformation: _originFarmInformation, 
      originFarmLatitude: _originFarmLatitude, 
      originFarmLongitude: _originFarmLongitude,
      productID: 0,
      productNotes: _productNotes,
      productPrice: 1000000000000000000,
      itemState: State.Harvested,
      distributorID: emptyAddress,
      retailerID: emptyAddress,
      consumerID: emptyAddress
      });

    if (isFarmer(msg.sender))
    {
      items[sku].itemState = State.Harvested;
      items[sku].originFarmerID = msg.sender;      
    }      

      // Increment sku
      sku = sku + 1;

      // Emit the appropriate event
      emit Harvested(_upc);
    
  }

  // Define a function 'processtItem' that allows a farmer to mark an item 'Processed'
  function processItem(uint _upc) public payable
  // Call modifier to verify caller of this function
  onlyFarmer()

  // Call modifier to check if upc has passed previous supply chain stage
  harvested(_upc)
  
  // Call modifier to verify caller of this function
  // verifyCaller(owner)
  onlyOwner()
  {
    // Update the appropriate fields
    items[_upc].itemState = State.Processed;
    
    // Emit the appropriate event
    emit Processed(_upc);
  }

  // Define a function 'packItem' that allows a farmer to mark an item 'Packed'
  function packItem(uint _upc) public payable
   // Call modifier to verify caller of this function
   onlyFarmer()
  
  // Call modifier to check if upc has passed previous supply chain stage
  processed(_upc)

 
  {
    // Update the appropriate fields
    items[_upc].itemState = State.Packed;
    
    // Emit the appropriate event
    emit Packed(_upc);
  }

  // Define a function 'sellItem' that allows a farmer to mark an item 'ForSale'
  function sellItem(uint _upc, uint _price) public payable
  // Call modifier to verify caller of this function
  onlyFarmer()
  
  // Call modifier to check if upc has passed previous supply chain stage
  packed(_upc)

  {
    // Update the appropriate fields
    items[_upc].itemState = State.ForSale;
    items[_upc].productPrice = _price;


    // Emit the appropriate event
    emit ForSale(_upc);   
  }

  // Define a function 'buyItem' that allows the disributor to mark an item 'Sold'
  // Use the above defined modifiers to check if the item is available for sale, if the buyer has paid enough, 
  // and any excess ether sent is refunded back to the buyer
  function buyItem(uint _upc) public payable 
    // Call modifier to verify caller of this function
    onlyDistributor()
    
    // Call modifier to check if upc has passed previous supply chain stage
    forSale(_upc)

    // Call modifer to check if buyer has paid enough
    paidEnough(items[_upc].productPrice)
    
    // Call modifer to send any excess ether back to buyer
    checkValue(_upc)

    {

    // Update the appropriate fields - ownerID, distributorID, itemState
    items[_upc].distributorID = msg.sender; //predefined_distributorID; //
    items[_upc].ownerID = msg.sender;
    items[_upc].itemState = State.Sold;
    
    // Transfer money to farmer
    uint  price = items[_upc].productPrice;
    items[_upc].originFarmerID.transfer(price);
    
    //TODO Need to transfer contract ownership to the Distributor???
    //No. "You just need to check if the accounts are in the appropriate list (e.g. farmers, retailers, etc)"

    // emit the appropriate event
    emit Sold(_upc);
  }

  // Define a function 'shipItem' that allows the distributor to mark an item 'Shipped'
  // Use the above modifers to check if the item is sold
  function shipItem(uint _upc) public payable
    // Call modifier to verify caller of this function
    onlyDistributor()
    
    // Call modifier to check if upc has passed previous supply chain stage
    sold(_upc)
    
    // Call modifier to verify caller of this function
    // verifyCaller(owner)
    // onlyOwner()

    {
    // Update the appropriate fields
    items[_upc].itemState = State.Shipped;

    // Emit the appropriate event
    emit Shipped(_upc);
  }

  // Define a function 'receiveItem' that allows the retailer to mark an item 'Received'
  // Use the above modifiers to check if the item is shipped
  function receiveItem(uint _upc) public payable
    // Call modifier to verify caller of this function
    onlyRetailer()
    
    // Call modifier to check if upc has passed previous supply chain stage
    shipped(_upc)

    // Access Control List enforced by calling Smart Contract / DApp
    {
    // Update the appropriate fields - ownerID, retailerID, itemState
    items[_upc].ownerID = msg.sender;
    items[_upc].retailerID = msg.sender; //predefined_retailerID;
    items[_upc].itemState = State.Received;

    // Emit the appropriate event
    emit Received(_upc);
  }

  // Define a function 'purchaseItem' that allows the consumer to mark an item 'Purchased'
  // Use the above modifiers to check if the item is received
  // Alvaro P. (Mentor) "purchaseItem does not have to be payable in the project"
  function purchaseItem(uint _upc) public //payable
    // Call modifier to verify caller of this function
    onlyConsumer()
    
    // Call modifier to check if upc has passed previous supply chain stage
    received(_upc)

    // Access Control List enforced by calling Smart Contract / DApp
    {
    // Update the appropriate fields - ownerID, consumerID, itemState
    items[_upc].ownerID = msg.sender;
    items[_upc].consumerID = msg.sender; //predefined_consumerID;
    items[_upc].itemState = State.Purchased;

    // Emit the appropriate event
    emit Purchased(_upc);
  }

  // Define a function 'fetchItemBufferOne' that fetches the data
  function fetchItemBufferOne(uint _upc) public view returns 
  (
  uint    itemSKU,
  uint    itemUPC,
  address ownerID,
  address originFarmerID,
  string memory originFarmName,
  string memory originFarmInformation,
  string memory originFarmLatitude,
  string memory originFarmLongitude
  ) 
  {
  // Assign values to the 8 parameters
  itemSKU = items[_upc].sku;
  itemUPC = items[_upc].upc;
  ownerID = items[_upc].originFarmerID;
  originFarmerID = items[_upc].originFarmerID;
  originFarmName = items[_upc].originFarmName;
  originFarmInformation = items[_upc].originFarmInformation;
  originFarmLatitude = items[_upc].originFarmLatitude;
  originFarmLongitude = items[_upc].originFarmLongitude;

  return 
  (
  itemSKU,
  itemUPC,
  ownerID,
  originFarmerID,
  originFarmName,
  originFarmInformation,
  originFarmLatitude,
  originFarmLongitude
  );
  }

  // Define a function 'fetchItemBufferTwo' that fetches the data
  function fetchItemBufferTwo(uint _upc) public view returns 
  (
  uint    itemSKU,
  uint    itemUPC,
  uint    productID,
  string memory  productNotes,
  uint    productPrice,
  uint    itemState,
  address distributorID,
  address retailerID,
  address consumerID
  ) 
  {
    
    // Assign values to the 9 parameters
  itemSKU = items[_upc].sku;
  itemUPC = items[_upc].upc;
  productID = itemSKU + itemUPC;
  productNotes = items[_upc].productNotes;
  productPrice = items[_upc].productPrice;
  itemState = uint256(items[_upc].itemState);
  distributorID = items[_upc].distributorID;
  retailerID = items[_upc].retailerID;
  consumerID = items[_upc].consumerID;
    
  return 
  (
  itemSKU,
  itemUPC,
  productID,
  productNotes,
  productPrice,
  itemState,
  distributorID,
  retailerID,
  consumerID
  );
  }
}
