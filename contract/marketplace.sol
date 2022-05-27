// SPDX-License-Identifier: MIT  

pragma solidity >=0.7.0 <0.9.0;

interface IERC20Token {
  function transfer(address, uint256) external returns (bool);
  function approve(address, uint256) external returns (bool);
  function transferFrom(address, address, uint256) external returns (bool);
  function totalSupply() external view returns (uint256);
  function balanceOf(address) external view returns (uint256);
  function allowance(address, address) external view returns (uint256);

  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}



contract AmbuMarketPlace {

    uint internal hospitalsLength = 0;
    uint internal likes;
    uint number;
    address internal cUsdTokenAddress = 0x874069Fa1Eb16D44d622F2e0Ca25eeA172369bC1;

    struct Hospital {
        address payable owner;
        string name;
        string image;
        string location;
        uint price;
        uint services;
        uint avgRating;
        uint numOfRaters;
        uint totalRating;
    }

    mapping (uint => Hospital) internal hospitals;
    mapping(uint => mapping(address => bool)) hasBought;

// write each hospital as a struct into our map
    function writeHospital(
        string memory _name,
        string memory _image,
        string memory _location,
        uint _price
    ) public {
        uint valueZero = 0;
        hospitals[hospitalsLength] = Hospital(
            payable(msg.sender),
			_name,
			_image,
			_location,
            _price,
            valueZero,
            valueZero,
            valueZero,
            valueZero
        );

        //Setting the hasBought for the user to be true
        hasBought[hospitalsLength][msg.sender] = true;
        hospitalsLength++;
    }

// returns each hospitals and their properties
    function readHospital(uint _index) public view returns (
		address payable,
		string memory, 
		string memory, 
		string memory, 
		uint, 
		uint,
        uint,
		uint
	) {
		return (
			hospitals[_index].owner, 
			hospitals[_index].name, 
			hospitals[_index].image, 
			hospitals[_index].location, 
			hospitals[_index].price,
			hospitals[_index].avgRating,
			hospitals[_index].numOfRaters,
			hospitals[_index].services
		);
	}

// orders ambulance and increases services for each order
    function orderAmbulance(uint _index) public payable {
        require(
                IERC20Token(cUsdTokenAddress).transferFrom(
                    msg.sender,
                    hospitals[_index].owner,
                    hospitals[_index].price
            ),
            "Transfer failed"
        );
        hospitals[_index].services++;
    }

// returnds number of hospital services available
    function getHospitalsLength() public view returns (uint) {
        return (hospitalsLength);
    } 

// write rating for each hospital
    function writeRating(uint _index, uint _selectedRate) public {
        require(hasBought[_index][msg.sender] == true, "You need to buy the service to rate the service");
        hospitals[_index].totalRating += _selectedRate;
        hospitals[_index].numOfRaters++;
        hospitals[_index].avgRating = hospitals[_index].totalRating / hospitals[_index].numOfRaters;
    }

}

