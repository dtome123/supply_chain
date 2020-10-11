// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22;
import "./Strings.sol";
import "./Ownable.sol";
contract SupplyDrugs is Ownable {
    using strings for *;

    struct Drug  {
        uint idDrug;
        uint idOfPres;
        string name;
        uint limit;
    }
    struct Prescription{
        address patient;
        string date;
        string creator;
        uint32 duration;
        uint price;
    }

    Drug [] drugs;
    Prescription[] prescriptions;

    
    mapping(uint => address) public prescriptionsToOwner;
    mapping (address => uint) ownerprescriptionsCount;
    uint items=0;
    function AddDrug(string memory _name, uint _limit) public{
        uint id = ownerprescriptionsCount[msg.sender];
        Drug memory d = Drug(items,id,_name,_limit);
        drugs.push(d);
        items++;
    }
    function addToPrescription(address _patient,string memory _date, string memory _creator, uint _duration , uint _price) public {
        /* require(drugs.length>0);
        for(uint i=0;i<drugs.length;i++){
            if(drugs[i].idPres==items)
            {
                temp.push(drugs[i]);
            }
        }
        prescriptions.push(Prescription(_date,_creator));
        prescriptionMap[items]=temp;
        items=items+1;
        delete temp; */
        uint oneday = 1 days;
        prescriptions.push(Prescription(_patient,_date,_creator,uint32(_duration*oneday+ block.timestamp),_price));
        uint id = prescriptions.length-1;
        prescriptionsToOwner[id]=msg.sender;
        ownerprescriptionsCount[msg.sender]++;
        
        
        
    }
    
    function getList() public view returns (string memory){
        string memory s ="";
        uint id = prescriptions.length;
        if(drugs.length>0){
            for(uint i=0;i<drugs.length;i++)
            {
                if(drugs[i].idOfPres==id){
                    string memory temp =uintToString(drugs[i].limit);
                    s= s.toSlice().concat("\n".toSlice());
                    s= s.toSlice().concat(drugs[i].name.toSlice());
                    s= s.toSlice().concat("_".toSlice());
                    s= s.toSlice().concat(temp.toSlice());
                }
            }
        }
        return s;
    }
    function getDrugs() public view returns(uint){
        return drugs.length;
    }
    function getIdPPrescription() public view returns(uint){
        return ownerprescriptionsCount[msg.sender]-1;
    }

    function getCurrentPrescriptionByPatient() public view returns(string memory) {
        string memory s="";
        for(uint i = prescriptions.length-1;i>=0;i--)
        {
            if(prescriptions[i].patient==msg.sender){
                s= s.toSlice().concat("\n\n<h3>Prescription Id: ".toSlice());
                s= s.toSlice().concat(uintToString(i).toSlice());
                s= s.toSlice().concat("\n</h3>".toSlice());
                s= s.toSlice().concat("\n<p>Address: ".toSlice());
                s= s.toSlice().concat(toAsciiString(prescriptions[i].patient).toSlice());
                s= s.toSlice().concat("\n</p>".toSlice());
                for(uint j=0;j<drugs.length;j++){
                    if(drugs[j].idOfPres==i){
                        string memory temp =uintToString(drugs[j].limit);
                        s= s.toSlice().concat("\n<p>".toSlice());
                        s= s.toSlice().concat(drugs[j].name.toSlice());
                        s= s.toSlice().concat("_".toSlice());
                        s= s.toSlice().concat(temp.toSlice());
                        s= s.toSlice().concat("</p>".toSlice());
                    }
                }
                s= s.toSlice().concat("<p>Price: ".toSlice());
                s= s.toSlice().concat(uintToString(prescriptions[i].price).toSlice());
                s= s.toSlice().concat("<p>".toSlice());
                break;
            }
        }
        return s;
    }
    function getPrescriptionByOwner() public view onlyOwner returns(string memory) {
        string memory s="";
        for(uint i = 0;i<prescriptions.length;i++)
        {
            if(prescriptionsToOwner[i]==msg.sender){
                s= s.toSlice().concat("\n\n<h3>Prescription Id: ".toSlice());
                s= s.toSlice().concat(uintToString(i).toSlice());
                s= s.toSlice().concat("\n</h3>".toSlice());
                s= s.toSlice().concat("\n<p>Address: ".toSlice());
                s= s.toSlice().concat(toAsciiString(prescriptions[i].patient).toSlice());
                s= s.toSlice().concat("\n</p>".toSlice());
                for(uint j=0;j<drugs.length;j++){
                    if(drugs[j].idOfPres==i){
                        string memory temp =uintToString(drugs[j].limit);
                        s= s.toSlice().concat("\n<p>".toSlice());
                        s= s.toSlice().concat(drugs[j].name.toSlice());
                        s= s.toSlice().concat("_".toSlice());
                        s= s.toSlice().concat(temp.toSlice());
                        s= s.toSlice().concat("</p>".toSlice());
                    }
                }
            }
        }
        return s;
    }
    function takeDrugs(uint _idOfPrescription) public payable {
        require(prescriptions[_idOfPrescription].patient==msg.sender);
        for(uint i=0;i<drugs.length;i++){
            if(drugs[i].idOfPres==_idOfPrescription){
                drugs[i].limit = 0;
            }
        }
    }
    
    function uintToString(uint i) private pure returns (string memory str) {
        if (i == 0) return "0";
        uint8 i2=uint8(i);
        uint8 j = uint8(i) ;
        uint8 length;
        while (j != 0){
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint8 k = length - 1;
        while (i2 != 0){
            bstr[k--] = byte(48 + i2 % 10);
            i2 /= 10;
        }
        return string(bstr);
    }
    function toAsciiString(address x) public pure returns (string memory) {
    bytes memory s = new bytes(40);
    for (uint i = 0; i < 20; i++) {
        byte b = byte(uint8(uint(x) / (2**(8*(19 - i)))));
        byte hi = byte(uint8(b) / 16);
        byte lo = byte(uint8(b) - 16 * uint8(hi));
        s[2*i] = char(hi);
        s[2*i+1] = char(lo);            
    }
    return string(s);
    }

    function char(byte b) public pure returns (byte c) {
        if (uint8(b) < 10) return byte(uint8(b) + 0x30);
        else return byte(uint8(b) + 0x57);
    }


}